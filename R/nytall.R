#' Collect NYT Article Search API Data by Term for Select Years
#'
#' This function returns a dataframe of New York Times article data for a given
#' term and selected years. Gets up to 2,000 articles in each search year at up
#' to 75 articles/min. Updates will be printed in the console every 8 seconds.
#'
#' @param term A string defining the search term. Use single apostrophes around
#' term for exact matches.
#' @param start A numeric year (YYYY) to start the search in.
#' @param nyt_key A string defining your New York Times API key:
#' https://developer.nytimes.com/
#' @param years (Optional) A numeric number of years to search after the start
#' year. Default or NULL gets all data from start to current year.
#' @return A dataframe of one article per row with various text/meta columns.
#' @examples # df <- get_articles("conservation", 1960, nyt_key)
#' # df <- get_articles("'climate change'", 1960, nyt_key)
#' # df <- get_articles("'climate change'", 1960, nyt_key, 10)
#' @import jsonlite
#' @import plyr
#' @import stringr
#' @export
get_articles <- function(term, start, nyt_key, years = NULL) {
  start_year <- start
  nyt_key_local <- nyt_key

  if (is.null(years)) {
    this_date <- Sys.Date()
    this_year <- as.numeric(str_sub(this_date, start = 1L, end = 4L))

    total_years <- this_year - start_year
  } else {
    total_years <- years - 1
  }

  current_year <- start_year
  current_year_end <- current_year + 1

  df_pages <- data.frame()

  str_term <- term
  term_fmt <- str_replace_all(str_term, "'", "%22")
  term_fmt <- str_replace_all(term_fmt, " ", "%20")

  for (x in 0:total_years) {
    str_current_date <- paste0(current_year, "0101")
    str_current_year_end <- paste0(current_year_end, "0101")

    str_baseurl <- paste0(
      "https://api.nytimes.com/svc/search/v2/articlesearch.json?begin_date=",
      str_current_date, "&end_date=", str_current_year_end,
      "&facet=false&facet_fields=news_desk&facet_filter=true&q=",
      str_term, "&sort=relevance&api-key=", nyt_key_local
    )

    initial_query <- fromJSON(str_baseurl)
    max_pages <- ceiling((initial_query$response$meta$hits[1] / 10) - 1)
    int_hits <- initial_query$response$meta$hits[1]

    if (int_hits > 0) {
      if (max_pages >= 200) {
        max_pages <- 199
      }

      for (i in 0:max_pages) {
        message(
          "Retrieving page ", i, " of ", max_pages, " between ",
          current_year, " and ", current_year_end
        )

        Sys.sleep(8)

        str_baseurl <- paste0(str_baseurl, "&page=", i)
        nyt_search <- fromJSON(str_baseurl, flatten = TRUE) %>% data.frame()

        df_pages <- rbind.fill(df_pages, nyt_search)
      }
    } else {
      message(
        "No articles found between ", current_year, " and ",
        current_year_end
      )

      Sys.sleep(8)
    }

    current_year <- current_year_end
    current_year_end <- current_year_end + 1
  }

  if (nrow(df_pages) > 0) {
    str_term <- str_replace_all(str_term, "'", "")
    df_pages$keyword <- str_term
  } else {
    message("No articles found. Try again.")
  }

  return(df_pages)
}

