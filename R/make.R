#' @title Exporta uma planilha de dados
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' Esta função exporta uma planilha genérica
#'
planilha_ <- \(){
  svDialogs::dlg_input("Defina o filtro")$res -> .filtro
  svDialogs::dlg_input("Defina as colunas de interesse. Exemplo: coluna1, coluna2, coluna3")$res -> vars

  stringr::str_split(vars, ",") |>
    purrr::pluck(1) |>
    stringr::str_squish() |>
    purrr::map(rlang::sym) -> vars_sym

  dplyr::tbl(RenovaBI, .filtro) |>
    dplyr::select(!!!vars_sym) |>
    dplyr::collect() -> data

  list(data) |>
    purrr::set_names(.filtro) |>
    export()
}


#' @title Exporta uma planilha de dados
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' Esta função exporta uma planilha genérica
#' @export
#'
planilha <- \(){
  svDialogs::dlg_input("Defina o filtro")$res -> .filtro
  svDialogs::dlg_open("Defina as colunas e os filtros de interesse")$res -> path

  readxl::read_excel(path) -> vars

  vars |>
    dplyr::pull(1) |>
    na.omit() |>
    stringr::str_squish() |>
    purrr::map(rlang::sym) -> vars_sym

  purrr::map(names(vars[,-1]), rlang::sym) -> filter_sym

  purrr::map2(
    .x = filter_sym,
    .y = vars[,-1],
    ~ rlang::quo(!!.x %in% !!.y)
  ) -> vars_filter_sym

  dplyr::tbl(RenovaBI, .filtro) |>
    dplyr::select(!!!vars_sym) |>
    dplyr::filter(
      !!!vars_filter_sym
    ) |>
    dplyr::collect() -> data

  list(data)  |>
    purrr::set_names(.filtro)  |>
    export()
}




