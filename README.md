# Database
Relational database for biological specimens and associated metadata.

## Overview
This repository contains the materials developed for the implementation of a relational database designed for the storage and management of biological specimens and associated metadata.

The project includes the diagrams of the database (Entity Relationship and Relational Model), the database model, SQL implementation, an automatic data import script and a dataset with test data.

## Repository Contents
- EntidadeRelacionamento.drawio.png - Entity Relationship diagram.
- ModeloRelacional.drawio.png - Relational database model.
- database.sql - SQL code used to create the database schema.
- evochange.db - SQLite database.
- DummyData.xlsx - Example dataset used for testing.
- importExcel.py - Python script for automatic data import from the Excel file.

## Requirements

- SQLite
- Python 3
- pandas

## How to Run the Import Script
1. Ensure Python 3 is installed on your system

If Python is not installed, download it from here:
https://www.python.org/downloads/

2. Install pandas:
'''
pip install pandas
'''

3. Place the following files in the same directory:
- database.db
- DummyData.xlsx
- importExcel.py

4. Run the script
'''
python importExcel.py
'''

The script will automatically read the Excel file and insert the data into the SQLite database.
   

## Demonstration video
A demonstration video of the mechanism to import data into the database is available on YouTube.
<br/>Link: https://youtu.be/tvI2m3VA2EI?si=XBCGgT8W1rMsFEkn

## License
This project is distributed under the MIT License. See LICENSE.txt for details.
