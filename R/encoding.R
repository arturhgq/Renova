declare_UTF8_encoding <- \(.data) {
  .data |>
    dplyr::rename_with(
      ~ enc2utf8(.x)
    ) |>
    dplyr::mutate(
      dplyr::across(
        where(is.character),
        stringi::stri_enc_toutf8
      )
    )
}
