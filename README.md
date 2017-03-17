# LaTex scripts for NIH grants  

I am using vim and LaTex for writing manuscripts and NIH grants. My citations are like this:


```
\citep{pmid24289793, pmid21796102}
```

I place the updateLatexCitation.pl file in the same dir as the tex file.  The following two lines in my .vimrc allows me to add new PubMed citations to the bibtex file and update the pdf. 

```
nmap <silent>,c :exe "!./updateLaTexCitation.pl %"<CR><CR> 
nmap <silent>,w :w!<CR><CR>:exe "!latexmk -pdf  %; latexmk -c %"<CR><CR> 
```

