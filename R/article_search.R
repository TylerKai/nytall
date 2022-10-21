#' Collect NYT Article Data for a Search Term by Year Ranges and Field Filters
#'
#' This function returns a dataframe of New York Times article data. Gets up to 2,000 articles in each search year at up to 75 articles/min. Updates will be printed in the console every 8 seconds.
#'
#' @param term A string defining the search term. Use single apostrophes (') around term for exact matches.
#' @param start A numeric year (YYYY) to start the search on.
#' @param nyt_key A string defining your New York Times API key: https://developer.nytimes.com/
#' @param years (Optional) A numeric number of years to search after the start year. Empty or NULL gets all data from start to current year.
#' @param fields (Optional) Only for use with *fields_query* parameter. Enter the field exactly as shown on the API documentation: https://developer.nytimes.com/docs/articlesearch-product/1/overview
#' @param fields_query (Optional) Only for use with *fields* parameter. Enter the field query exactly as shown on the API documentation: https://developer.nytimes.com/docs/articlesearch-product/1/overview
#' @return A dataframe of one article per row with various text/meta columns.
#' @examples # df <- article_search(term = "conservation", start = 1960, nyt_key = nyt_key)
#' df <- article_search(term = "conservation", start = 1960, nyt_key = nyt_key, *years = 10, fields = "glocations", field_query = "Los Angeles"*)
#' @import jsonlite
#' @import plyr
#' @import stringr
#' @export
article_search <- function(term, start, nyt_key, years = NULL, fields = NULL, fields_query = NULL) {
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

    str_baseurl <- paste0("https://api.nytimes.com/svc/search/v2/articlesearch.json",
      "?begin_date=", str_current_date,
      "&end_date=", str_current_year_end,
      "&q=", term_fmt,
      "&sort=oldest",
      "&api-key=", nyt_key_local
      )

    if (!is.null(fields)) {
      fields_fmt <- str_replace_all(fields, "'", "%22")
      fields_fmt <- str_replace_all(fields_fmt, " ", "%20")
      str_baseurl <- paste0(str_baseurl, "&fl=", fields_fmt)
    }

    if (!is.null(fields_query)) {
      fields_query_fmt <- str_replace_all(fields_query, "'", "%22")
      fields_query_fmt <- str_replace_all(fields_query_fmt, " ", "%20")
      str_baseurl <- paste0(str_baseurl, "&fq=", fields_query_fmt)
    }

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

