Personal website

## CV

The CV LaTeX source lives in a separate private repo, [academic_resume](https://github.com/PeterCarragher/academic_resume). It is gitignored here (as a submodule it broke the GitHub Pages build), so clone it locally before updating publications:

```bash
git clone https://github.com/PeterCarragher/academic_resume academic_resume
```

When a publication changes, update both `_data/publications.yml` and `academic_resume/bibs/publications.bib`, rebuild the CV (`cd academic_resume && latexmk`), then copy `academic_resume/outputs/main.pdf` to `files/cv.pdf`.
