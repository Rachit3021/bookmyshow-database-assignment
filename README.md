# BookMyShow Database Assignment

## Overview

This project contains the database design for a simplified BookMyShow theatre movie-show scenario.

The assignment covers:

- Entity identification
- Attribute identification
- Relational table design
- 1NF, 2NF, 3NF and BCNF normalization
- MySQL table creation
- Sample data
- Query to retrieve movie shows for a given theatre and date

## Database Tables

The database contains the following tables:

1. `theatre`
2. `screen`
3. `movie`
4. `show_schedule`

## Relationships

```text
Theatre
   |
   | 1:N
   ↓
Screen
   |
   | 1:N
   ↓
Show Schedule
   ↑
   |
   | N:1
 Movie
