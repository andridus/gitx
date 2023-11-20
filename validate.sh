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
  printf "more details: execute command ${WHITE}$CMD${NC}\n"
  exit 1
fi
}

echo "----"
printf "${WHITE}Execute suite: check-warning, check-formatted, credo, test, coverage${NC}\n"
echo "----"

TERM="check-warning"
CMD="mix compile --warnings-as-errors"
bash -c "${CMD}" > /dev/null 2>&1;
validate
TERM="check-warning on tests"
CMD="MIX_ENV=test mix compile --warnings-as-errors"
bash -c "${CMD}" > /dev/null 2>&1;
validate

TERM="check-formatted"
CMD="mix format --check-formatted"
bash -c "${CMD}" > /dev/null 2>&1;
validate

TERM="credo"
CMD="mix credo --strict"
bash -c "${CMD} | grep \"found no issues\"" > /dev/null 2>&1;
validate

TERM="test"
CMD="mix test"
bash -c "${CMD} | grep \"Finished\"" > /dev/null 2>&1;
validate

TERM="coverage"
CMD="mix test --cover"
bash -c "${CMD} | grep \"100.00% | Total\"" > /dev/null 2>&1;
validate

exit 0