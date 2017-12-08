#!/bin/bash
read user
read pass

sudo /usr/local/uSpot/auth-guest-su.sh ${user} ${pass}
