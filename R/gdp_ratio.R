#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
get_gdp_ratios <- function(df){
  positions <- c('ipfa', 'ipfl', 'ipeqa', 'ipeql', 'ipfdia', 'ipfdil', 'ipdebta', 'ipdebtl', 'ipfx', 'ipdera', 'ipderl', 'ipnfa', 'ipeqay', 'ippda', 'ipddl', 'ipoa', 'ipol')
  df %>%
    mutate(across(any_of(positions),
                  ~ 100 * (.x / gdpd) * (e_eop / e_avg),
                  .names = "{.col}y"))
}
