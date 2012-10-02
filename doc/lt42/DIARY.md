2012-09-02

* DONE moved most tests to mocha
* DONE added AGPL
* DONE rewrote build script
* TODO write down specification

2012-09-01

* DONE repaired geoname_import
* DONE made tests run again

2012-09-30

* DONE updates to stable version of nodes.js (0.6) and updates packages
* DONE convert docs to markdown

2012-09-26

* DONE rethought models, wrote down fancy diagrams, identified key problem:
  Which voyages should be kept? (all: O(n^2) storage, doable but huge)
  How much route information should be replicated in the graph?
  Remark: 
  We actually compute the transitive closure over all potential routes.
  Even with subroutes, alot of information will move into the graph.
  This is tricky. We need to rethink voyages.

2012-09-25

* DONE skimmed existing code @boggle
* DONE discussed architecture proposal @boggle @t
* DONE setup daily log @boggle

2012-09-24

* DONE setup trello @boggle @t
* DONE discussed overall schedules and key problems @boggle @t
