#' @title Conecta a VPN da Renova via 'ODBC Driver 18 for SQL Server' para acessar a base de dados 'RENOVA_POWER_BI'
#' @description
#'
#' `r lifecycle::badge("stable")`
#'
#' Esta função faz a conexão entre a VPN da Renova e o R via 'ODBC Driver 18 for SQL Server' para acessar a base de dados 'RENOVA_POWER_BI'
#' @note
#' Baixe e instale o driver "ODBC Driver 18 for SQL Server" no site da Microsoft.
#'
#' Veja a lista de drivers instalados na sua máquina com o comando 'odbc::odbcListDrivers()'
#' @export

#uid = "crtf_avds@fundacaorenova.org",
#pwd = "BJ@m1E24"
#
renova_VPN <- \(){

  "frpvrenovapbi.database.windows.net" -> host
  "RenovaBI" -> name

  glue::glue(
    "odbc::dbConnect(
        drv = odbc::odbc(),
        Driver = 'ODBC Driver 18 for SQL Server',
        server = '{host}',
        database = 'RENOVA_POWER_BI',
        UID = svDialogs::dlgInput('E-mail do usuario')$res,
        Authentication = 'ActiveDirectoryInteractive',
        encoding = 'latin1'
      ) -> RenovaBI"
  ) |>
    as.character() -> script

  rstudioapi::sendToConsole(script)
}
