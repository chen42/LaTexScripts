# misc_scripts
I am warming up to using vim and LaTex for writing manuscripts and NIH grants. This repo contains my config files. I place the updateLatexCitation.pl file in the same dir as the tex file.  I have the following two lines in my .vimrc to add new PubMed citations to the bibtex file and update the pdf. 

```
nmap <silent>,c :exe "!./updateLaTexCitation.pl %"<CR><CR> 
nmap <silent>,w :exe "!latexmk -pdf  %"<CR><CR> 
```

