:: ==============================================================================================
::                                     |    QStack    |
:: ==============================================================================================

@echo off
:: ===============================================
:: Git-related aliases
:: ===============================================

doskey co=git checkout $*
doskey cleanall=git clean -xdf
doskey git-fp=git fetch --all ^&^& git pull origin
doskey git-shortHash=git rev-parse --short HEAD
doskey git-longHash=git rev-parse HEAD
doskey gl=git log --oneline --all --graph --decorate $*