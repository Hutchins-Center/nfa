#' Title
#'
#' @return
#' @export
#'
#' @examples
custom_theme <-
  function() {
    theme_bw() +
      theme(legend.position = "bottom",
            panel.grid.minor.x=element_blank(),
            panel.grid.major.x=element_blank(),
            plot.margin=unit(c(1.2,.5,.5,.5),"cm"),
            plot.title = element_markdown(size=12),
            plot.subtitle = element_markdown(size=10) ,
            plot.caption =
              element_textbox_simple(size = 9,
                                     lineheight = 1,
                                     padding = margin(5.5, 5.5, 5.5, 5.5),
                                     margin = margin(0, 0, 5.5, 0)),
            legend.text=element_markdown(size=10),
            legend.title=element_blank(),
            axis.title.x = element_blank(),
            axis.title.y = element_blank(),
            legend.spacing.y = unit(2, 'cm')
      ) # , legend.margin = unit(c(rep(-.8, 4)),"cm")
  }

#' Title
#'
#' @param df
#' @param col
#' @param by
#' @param group
#' @param keep
#'
#' @return
#' @export
#'
#' @examples
filter_across <- function(df, col, by, group = ifs_code, keep = FALSE ){

  df %>%
    group_by({{ group }}) %>%
    mutate(contains = {{ col }} %in% {{ by }}) %>%
    summarise(all = sum(contains)) %>%
    filter(all == 0) %>%
    select(-all) %>%
    inner_join(df)
}

#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
exclude_countries <- function(df){
  countries_to_exclude <- c('Belgium-Luxembourg', 'Liechtenstein', 'Faroe Islands', 'ECCU')
  df %>%
    filter(country %nin% countries_to_exclude)
}

#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
offshore_dummy <- function(df){
  codes <- c(113, 117, 118, 135, 171, 313, 316, 319, 353, 354, 377, 379, 381, 718, 823)
  offshore_countries <-
    nfa %>%
    filter(ifs_code %in% codes) %>%
    distinct(country) %>%
    pull()

  df %>%
    mutate(offshore = case_when(country %in% offshore_countries ~ 1,
                                TRUE ~ 0))
}
#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
large_offshore_dummy <- function(df){
  codes <- c(1, 112, 124, 137, 138, 146, 178, 181, 283, 419, 423, 532, 546, 576, 684)
  large_offshore_countries <-
    nfa %>%
    filter(ifs_code %in% codes) %>%
    distinct(country) %>%
    pull()

  df %>%
    mutate(large_offshore = case_when(country %in% large_offshore_countries ~ 1,
                                      TRUE ~ 0))

}
#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
advanced_economies_dummy <- function(df){
  codes <- c(423, 436, 528, 532, 546, 542, 576, 935, 936, 939, 941, 944, 961)
  advanced_economies <-
    nfa %>%
    filter(ifs_code %in% codes) %>%
    distinct(country) %>%
    pull()

  df %>%
    mutate(advanced = case_when(ifs_code == 163 ~ 0,
                                ifs_code == 186 ~ 0,
                                offshore == 1 ~ 0,
                                ifs_code > 196 & country %nin% advanced_economies ~ 0,
                                TRUE ~ 1))

}
#' Title
#'
#' @param df
#'
#' @return
#' @export
#'
#' @examples
emerging_economies_dummy <- function(df){
  df %>%
    mutate(emerging = case_when(advanced == 1 | offshore == 1 | large_offshore == 1 | ifs_code == 163 ~ 0,
                                TRUE ~ 1))
}
#' Title
#'
#' @return
#' @export
#'
#' @examples
load_clean_data <- function(){
  nfa %>%
    exclude_countries() %>%
    offshore_dummy() %>%
    large_offshore_dummy() %>%
    advanced_economies_dummy() %>%
    emerging_economies_dummy()
}
