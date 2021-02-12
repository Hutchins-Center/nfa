
# Packages ------------------------------------------------------------------------------------


library(conflicted)
library('sjmisc')
library('tidyr')
library('ggplot2')
library('ggtext')
library('ggthemes')
library('RColorBrewer')
library('brolgar')
library('feasts')

filter <- dplyr::filter


# Cleaning ------------------------------------------------------------------------------------

filter <- dplyr::filter
positions <- c('ipfa', 'ipfl', 'ipeqa', 'ipeql', 'ipfdia', 'ipfdil', 'ipdebta', 'ipdebtl', 'ipfx', 'ipdera', 'ipderl', 'ipnfa', 'ipeqay', 'ippda', 'ipddl', 'ipoa', 'ipol')

emerging <-
  emerging %>% filter(!is.na(ipnfay)) %>%
  as_tsibble(key = country, index = date, regular = TRUE)

emerging <-
load_clean_data() %>%
get_gdp_ratios() %>%
filter(emerging == 1)


# Visualization -------------------------------------------------------------------------------
load_clean_data() %>%
  get_gdp_ratios()

emerging_near <-
  emerging %>%
  key_slope(ipnfay ~ date) %>%
  keys_near(key = country,
            var = .slope_date)

emerging_near_join <-
  emerging_near %>%
  left_join(emerging, by = 'country')

ggplot(emerging_near_join)

library(stickylabeller)
ggplot(emerging_near_join,

       aes(x = date,
           y = ipnfay,
           colour = country)) +
  geom_line() +
  facet_wrap(~stat + country,
             labeller = label_glue("Country: {country} \nNearest to the {stat} of the slope")) +
  theme_minimal() +
  theme(legend.position = "none") +
  custom_theme() +
  ggsave('analysis/figures/slope-stats.svg')




heights_near <- heights %>%
  key_slope(height_cm ~ year) %>%
  keys_near(key = country,
            var = .slope_year)
  group_by(country) %>% filter(!all(is.na(ipnfay))) %>% brolgar::key_slope(ipnfay ~ date)


  emerging %<>%
  as_tsibble(key = country, index = date, regular = TRUE)

  emerging %>%
  ggplot(aes(x = date, y = ipnfay, group= country)) +
  geom_line() +
  custom_theme() +
  facet_strata(along = date)

  emerging %>%
    ggplot(aes(x = date, y = ipnfay, group= country, color = country)) +
    geom_line(alpha = 0.5) +
    custom_theme() +
    facet_sample()

  emerging %>%
    mutate(continent = countrycode(country, 'country.name', 'continent')) %>%
    relocate(continent, .after = country) %>%
    ggplot(aes(x = date, y = ipnfay, group = country)) +
    geom_line(alpha = 0.5) +
    custom_theme() +
    facet_strata(along = ipnfay)

 p<- emerging %>%
    mutate(continent = countrycode(country, 'country.name', 'continent')) %>%
    filter(continent == 'Asia') %>%
    relocate(continent, .after = country) %>%
    ggplot(aes(x = date, y = ipnfay, group = country)) +
    geom_line(alpha = 0.5) +
    custom_theme() +
    facet_strata(along = date)

continent_plot <- function(continent){

  emerging %>%
    mutate(continent = countrycode(country, 'country.name', 'continent')) %>%
    filter(continent == continent) %>%
    ggplot(aes(x = date, y = ipnfay, group = country)) +
    geom_line(alpha = 0.4) +
    custom_theme() +
    facet_strata(along = date)
}
continents <- c('Asia', 'Europe', 'Africa', 'Americas', 'Oceania')
lapply(continents, continent_plot)
countrycode(emerging$country, 'country.name', 'continent')

  feat_two <- list(min = min,
                     max = max)
emerging %>%
  pivot_longer(-c(date, country, ifs_code, source)) %>%
  group_by(country) %>%
  filter(name == 'ipnfay',
         date == max(date) | date == min(date)) %>%
  ggplot(aes(x = date, y = value, group = country)) +
    geom_line(aes(color = country, alpha = 1), size = 1) +
  theme_hc()

emerging %>%
  filter(source == 'nfa_plus') %>%
  select(date, country, ipnfay, source) %>%
  pivot_longer(ipnfay) %>%
  ggplot(aes(x = date, y = value, group = country)) +
  geom_line() +
  facet_strata()

emerging %>%
  as_tibble() %>%
  filter(date > 2007) %>%
  mutate(continent = countrycode(country, 'country.name', 'continent')) %>%
  mutate(
         ipnfay_converted = ipnfa * e_eop / e_avg,
         ) %>%
  group_by(date, continent) %>%
  mutate(gdp_total = sum(gdp, na.rm = TRUE),
         total = sum(ipnfay_converted, na.rm = TRUE),
         variable = total / gdp_total) %>%
  select(date, continent, variable) %>%
  pivot_longer(variable) %>%
  ggplot(aes(x = date, y = value, color = continent)) +
  geom_line() +
  facet_wrap(~ continent)


