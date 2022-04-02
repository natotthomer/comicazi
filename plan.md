- endpoint to
  - submit a single CBR/CBZ (and optional CSV)
  - submit a zip/directory of CBR/CBZ files
  

- I want to be able to upload a single CBR/CBZ file and
  - store it to a DB
    - store multiple, differently compressed versions of it
    - pull primarily the cover but also every individual page for reading purposes
  - save favorites, make reading lists, organize by series, events, crossovers
  - edit/browse metadata
    - flexible creator credits
      - artist/penciler/inker/letterer/colorist/writer/plotter/scripts/editor/cover pencils/inks/colors
    - tags
    - series
      - continued from
      - continues in
  - able to select multiple books/folders, compress them and download
  - elasticsearch

- both an endpoint for fetching content AND a viewer 


How to organize Books?
- A book can come in many forms
  - individual issues
    - special editions
    - annuals
    - "king-size"/"giant-size"/etc
    - ashcans
  - a single volume work
  - collections of previously released material
    - re-edits/censored editions
    - re-colorations
    - "material from"
  - omnibus/oversized hardcovers
- a single work can be part of a larger story
- a series can change publishers
- a single issue can be thought of as belonging to different volumes of the same title:
  - Uncanny X-Men #600 could be thought of as the final issue of Brian Michael Bendis' Uncanny X-Men series that began in February 2013, or the 600th issue of the Uncanny X-Men series that begin in 1963 (although was only officially titled Uncanny X-Men starting with issue #142 even though the cover title had been reading as "Uncanny X-Men" since issue #114)
- a series can change title or have different cover and indicia titles
  - EC Comics' Weird Fantasy and Weird Science both have baffling publication histories as both titles had been previously renamed twice over and were then restructured into a single series by the title of Weird Science-Fantasy which was in turn re-titled Incredible Science Fiction