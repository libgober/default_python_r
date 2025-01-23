# Variables
PYTHON_SCRIPTS = scripts/python/
R_SCRIPTS = scripts/R/
DATA_DIR = data/
OUTPUT_DIR = outputs/
LOGS_DIR = $(OUTPUT_DIR)logs/

# Default task
all: clean data_cleaning analysis generate_reports

# Clean up outputs and logs
clean:
	rm -rf $(OUTPUT_DIR)processed/*
	rm -rf $(OUTPUT_DIR)figures/*
	rm -rf $(LOGS_DIR)*

# Run data cleaning in both R and Python
data_cleaning:
	@echo "Running data cleaning scripts..."
	Rscript $(R_SCRIPTS)data_cleaning.R
	python $(PYTHON_SCRIPTS)data_cleaning.py

# Run analysis in both R and Python
analysis:
	@echo "Running analysis scripts..."
	Rscript $(R_SCRIPTS)main_analysis.R
	python $(PYTHON_SCRIPTS)main_analysis.py

# Generate reports
generate_reports:
	@echo "Generating reports..."
	Rscript -e "rmarkdown::render('notebooks/reports/final_analysis.Rmd')"

# Install dependencies for Python and R
install_dependencies:
	pip install -r requirements.txt
	Rscript -e "renv::restore()"

# Run tests
test:
	@echo "Running tests..."
	pytest tests/python/
	Rscript $(R_SCRIPTS)test_suite.R

# Help command
help:
	@echo "Available Makefile commands:"
	@echo "  all                  - Run all steps: clean, data cleaning, analysis, reports"
	@echo "  clean                - Clean output and logs"
	@echo "  data_cleaning        - Run data cleaning scripts"
	@echo "  analysis             - Run analysis scripts"
	@echo "  generate_reports     - Generate final reports"
	@echo "  install_dependencies - Install Python and R dependencies"
	@echo "  test                 - Run all tests"
