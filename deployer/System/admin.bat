@echo off
:: Administrator generator and password policy.

net user "ADMINUSER" <PASSWORD> /add
net accounts /maxpwage:unlimited
net localgroup Administrators "ADMINUSER" /add
net localgroup Users "ADMINUSER" /delete
