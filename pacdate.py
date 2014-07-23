#!/bin/python

import subprocess, re
from urllib import request, error as urlerrors, parse
from bs4 import BeautifulSoup

def searchpkgs(pkgname):
	searchpage = request.urlopen("https://bugs.archlinux.org/index.php?string=%5B{}%5D&project=0".format(parse.quote(pkgname)))
	searchpage = BeautifulSoup(searchpage)
	bugtable = searchpage.find('table', id='tasklist_table').find('tbody')
	bugreports = []
	tagregex = re.compile("\[{}\] *".format(re.escape(pkgname)), re.I)
	for report in bugtable.find_all('tr'):
		entry = {}
		reporttext = report.find('td', 'task_summary').get_text()
		tag = tagregex.search(reporttext)
		reporttext = reporttext[:tag.start()] + reporttext[tag.end():]
		entry['pkgname'] = pkgname
		entry['id'] = report.find('td', 'task_id').get_text()
		entry['reporttext'] = reporttext
		entry['severity'] = report.find('td', 'task_severity').get_text()
#		entry['votes'] = report.find('td', 'task_votes').get_text()
		bugreports.append(entry)
	return bugreports
		
#main
subprocess.call(['sudo','pacman','-Sy'])
pkglist = subprocess.check_output(['pacman','-Quq']).decode('utf-8')

bugged = []
for pkgname in pkglist.splitlines():
	packagebugs = searchpkgs(pkgname)
	if packagebugs:
		bugged.append((pkgname, packagebugs))	
		print(pkgname)
		for bug in packagebugs:
			print("\t{0}\t{1}".format(bug['severity'], bug['reporttext']))
