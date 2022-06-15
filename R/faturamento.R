#' @title Exporta a planilha de faturamento do Fluxo Ágil
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' Esta função exporta a planilha de faturamento do Fluxo Ágil
#' @export
planilha_faturamento <- \() {
  svDialogs::dlg_input("Digite a data de inicio para o filtro. Exemplo: 2022-02-25.")$res -> .date_begin
  svDialogs::dlg_input("Digite a data de fim para o filtro. Exemplo: 2022-04-22.")$res -> .date_end

  svDialogs::dlg_open(
    title = "Planilha com tres abas, respectavamente, com o codigo, de_en e responsavel'")$res -> .path

  list(1,2,3) |>
    purrr::map(
      ~ readxl::read_excel(path = .path, sheet = .x)
    ) -> .filter

  .filter[[1]][[1]] -> .codigo
  .filter[[2]][[1]] -> .nome
  .filter[[3]][[1]] -> .responsavel

  dplyr::tbl(RenovaBI, "filtro_327") |>
    dplyr::select(
      datareg,
      protocolo,
      statusManifestacao,
      datainsercao,
      unidadeinseriu,
      operadorinseriu,
      nomeoperadorinseriu,
      operadoralteracaofinal,
      manifestacaoAssuntoTema,
      requerAcaoFutura,
      statusdemanda
    ) |>
    dplyr::filter(
      operadorinseriu %in% .codigo,
      dplyr::between(
        datainsercao,
        .date_begin,
        .date_end
      )
    ) |>
    dplyr::collect() -> NovasManifestacoes

  dplyr::tbl(RenovaBI, "filtro_1509") |>
    dplyr::select(
      data_en,
      protocolo,
      statusManifestacao,
      decod_en,
      de_en,
      manifestacaoAssuntoTema,
      manifencaminhamentotipo_en,
      formapreferidaretorno
    ) |>
    dplyr::filter(
      de_en %in% .nome,
      manifencaminhamentotipo_en != 'Retorno final dado',
      dplyr::between(
        data_en,
        .date_begin,
        .date_end
      )
    ) |>
    dplyr::collect() -> Encaminhamentos

  dplyr::tbl(RenovaBI, "filtro_327") |>
    dplyr::select(
      dataconclusao,
      protocolo,
      statusManifestacao,
      responsavelconclusao,
      manifestacaoAssuntoTema,
      requerAcaoFutura,
      statusdemanda
    ) |>
    dplyr::filter(
      responsavelconclusao %in% .responsavel,
      dplyr::between(
        dataconclusao,
        .date_begin,
        .date_end
      )
    ) |>
    dplyr::collect() -> Conclusoes

  list(
    `Novas manifestações` = NovasManifestacoes,
    Encaminhamentos = Encaminhamentos,
    `Conclusões` = Conclusoes
  ) |>
    export()
}
