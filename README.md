# Forecasting the 2024 U.S. Presidential Election: Analyzing Polling Data

## Overview

This repository provides a reproducible framework for forecasting the outcome of the 2024 U.S. Presidential Election using polling data. The project utilizes a "poll-of-polls" approach to build predictive models, leveraging statistical and machine learning techniques to analyze and interpret polling trends. The aim is to provide an informed forecast of the election results, accounting for various factors such as state-level data, polling methodologies, and historical trends.


## File Structure

The repo is structured as:

-   `data/raw_data` Contains the original raw polling data obtained from FiveThirtyEight.
-   `data/analysis_data` Includes cleaned and processed datasets used for modeling and analysis.
-   `model` Stores the fitted models and related outputs, such as saved regression models or prediction files. 
-   `other` Contains supplementary materials, including relevant literature, detailed information on LLM chat interactions, and sketches or notes.
-   `paper` Includes files used to generate the final paper, such as the Quarto document, reference bibliography, and the final PDF of the paper.
-   `scripts` Holds the R or Python scripts used for data cleaning, analysis, and model building. Scripts are organized based on their functionality.


## Statement on LLM usage

Aspects of the code were written with the help of the auto-complete tool, Codriver. The abstract and introduction were written with the help of ChatHorse and the entire chat history is available in inputs/llms/usage.txt.

## Some checks

- [ ] Change the rproj file name so that it's not starter_folder.Rproj
- [ ] Change the README title so that it's not Starter folder
- [ ] Remove files that you're not using
- [ ] Update comments in R scripts
- [ ] Remove this checklist