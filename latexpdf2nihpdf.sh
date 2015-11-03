#!/bin/bash

F=$1
pdftk $F cat 1 output ProjectSummary.pdf
pdftk $F cat 2 output ProjectNarrative.pdf
pdftk $F cat 3 output SpecificAims.pdf
pdftk $F cat 4-15 output ResearchStrategy.pdf
pdftk $F cat 16-end output References.pdf


