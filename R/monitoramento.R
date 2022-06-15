#' @title Exporta a planilha de monitoramento do Fluxo Ágil
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' Esta função exporta a planilha de faturamento do Fluxo Ágil
#' @export
planilha_monitoramento <- \() {
  svDialogs::dlg_input("Digite a data para o filtro. Exemplo: 2022-02-25.")$res -> .date

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
      localidademanifestante,
      protocolo,
      statusManifestacao,
      datainsercao,
      unidadeinseriu,
      operadorinseriu,
      nomeoperadorinseriu,
      operadoralteracaofinal,
      manifestacaoAssuntoTema,
      requerAcaoFutura,
      statusdemanda,
    ) |>
    dplyr::filter(
      operadorinseriu %in% .codigo,
      statusManifestacao %in% "Respondida no ato",
      datainsercao >= .date) |>
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
      formapreferidaretorno,
      resumo
    ) |>
  dplyr::filter(
    de_en %in% .nome,
    data_en >= .date
  ) |>
    dplyr::collect() -> Encaminhamentos

  dplyr::tbl(RenovaBI, "filtro_327") |>
    dplyr::select(
      dataconclusao,
      localidademanifestante,
      protocolo,
      statusManifestacao,
      responsavelconclusao,
      manifestacaoAssuntoTema,
      requerAcaoFutura,
      statusdemanda,
      resumoconclusao
    ) |>
    dplyr::filter(
      responsavelconclusao %in% .responsavel,
      dataconclusao >= .date
    ) |>
    dplyr::collect() -> Conclusoes

  list(
    `Novas manifestações` = NovasManifestacoes,
    Encaminhamentos = Encaminhamentos,
    `Conclusões` = Conclusoes
  ) |>
    export()
}

