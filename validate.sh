#!/bin/bash
WHITE='\033[1;37m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function validate() {
if [ $? -eq 0 ]
then
  printf "[${GREEN}OK${NC}] $TERM\n"
else
  printf "[${RED}FAIL${NC}] $TERM\n"
  echo "--"
  printf "more details: execute command ${WHITE}mix $CMD${NC}\n"
  exit 1
fi
}

echo "----"
printf "${WHITE}Execute suite: check-warning, check-formatted, credo, test, coverage${NC}\n"
echo "----"

TERM="check-warning"
CMD="compile --warning-as-error"
bash -c "mix ${CMD}" > /dev/null 2>&1;
validate

TERM="check-formatted"
CMD="format --check-formatted"
bash -c "mix ${CMD}" > /dev/null 2>&1;
validate

TERM="credo"
CMD="credo --strict"
bash -c "mix ${CMD} | grep \"found no issues\"" > /dev/null 2>&1;
validate

TERM="test"
CMD="test"
bash -c "mix ${CMD} | grep \"Finished\"" > /dev/null 2>&1;
validate

TERM="coverage"
CMD="test --cover"
bash -c "mix ${CMD} | grep \"100.00% | Total\"" > /dev/null 2>&1;
validate

exit 0