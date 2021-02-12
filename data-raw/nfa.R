library('tsibble')
library('magrittr')
library('conflicted')
## code to prepare `DATASET` dataset goes here
nfa <-
  readxl::read_xlsx('inst/extdata/NFA data for CGER 1970-2020.xlsx',
                    sheet = 'ToStata', na = '.') %>%
  as_tsibble(key = ifs_code, index = date) %>%
  mutate(source = 'nfa')


nfa_plus <-
  readxl::read_xlsx('inst/extdata/NFA data for CGER 1970-2020 (other countries).xlsx',
                    sheet = 'ToStata', na = '.') %>%
  as_tsibble(key = ifs_code, index = date) %>%
  mutate(source = 'nfa_plus')

nfa %<>%
  full_join(nfa_plus)

usethis::use_data(nfa, overwrite = TRUE)

