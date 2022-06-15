#' export
export <- \(.data) {

  .data |>
    purrr::map(
      ~ .x |>
        dplyr::rename_with(enc2utf8)
    ) -> .data_list

    names(.data) -> .data_names

  options("openxlsx.dateFormat" = "yyyy-mm-dd")
  options("openxlsx.minWidth" = 10)
  options("openxlsx.maxWidth" = 250)

  openxlsx::createWorkbook() -> workbook

  purrr::map2(
    .x =  .data_list,
    .y = .data_names,
    ~{
      openxlsx::addWorksheet(
        wb = workbook,
        sheetName = .y
      )

      openxlsx::createStyle(
        wrapText = TRUE
      ) -> .headerStyle

      openxlsx::writeDataTable(
        wb = workbook,
        sheet = .y,
        x = .x,
        tableStyle = "TableStyleLight1",
        headerStyle = .headerStyle
      )

      openxlsx::modifyBaseFont(
        workbook,
        fontSize = 10,
        fontName = "Segoe UI Light"
      )
      openxlsx::setColWidths(
        workbook,
        sheet = .y,
        cols = 1:ncol(.x),
        widths = "auto"
      )
    })
  openxlsx::saveWorkbook(
    workbook,
    svDialogs::dlgSave(
      "file.xlsx",
      title = "Selecione o local para salvar o arquivo. Salve-o com a extensao 'xlsx'. Exemplo: 'PlanMonitV1_I.xslx'"
    )$res,
    overwrite = TRUE
  )
}
