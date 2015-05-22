@echo off
git add . --all
set /p cmt="Please enter commit text, leave empty to add time: "
if defined cmt (
git commit -m "%cmt%"
) else git commit -m "%date%%time%"
git push -u origin master
pause