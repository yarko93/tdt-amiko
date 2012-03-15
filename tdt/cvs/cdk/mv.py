#!/usr/bin/python2
fm = open('rules-make').readlines()
fa = open('rules-archive').readlines()
fi = open('rules-install').readlines()


default_url = "ftp://ftp.stlinux.com/pub/stlinux/2.2/updates/SRPMS"
cmd_tasks = ['dircreate', 'move', 'remove', 'link']

global ret
ret = ""

import sys
real_stdout = sys.stdout
sys.stdout = sys.stderr

def add2ret(s):
	global ret
	ret = ret + ('  '+s+'\n').replace(pn.replace('_','-'), '{PN}').replace(pv.replace('_','-'), '{PV}')

for lm in fm:
	lm = lm.strip()
	if not lm or lm.startswith('#') or lm.startswith('>>'): continue
	rm = lm.split(';')
	if not rm: continue
	print "Processing", rm
	pn = rm[0]
	ret += "%s\n" % pn
	pv = rm[1]
	ret += "  %s\n" % pv
	pdir = rm[2]
	add2ret(pdir)
	if len(rm) < 4:
		print "Empty", pn
		rm += ['']
	pdeps = rm[3].split(':')
	ptasks = rm[4:]
	print "  tasks are\n   ", '\n    '.join(ptasks)
	for tsk in ptasks:
		dep = tsk.split(':')[1]
		if dep in pdeps:
			pdeps.remove(dep)
		else:
			print "Warning: extra dep", dep
	if pdeps and pdeps[0]:
		print "Warning: left", pdeps
		for dep in pdeps:
				ptasks += ["nothing:"+dep]
	for tsk in ptasks:
		dep = tsk.split(':')[1]
		rule = tsk.split(':')[0]
		if rule in cmd_tasks:
			add2ret('p'+tsk)
			continue
		src = ""
		for la in fa:
			la = la.strip()
			if la.startswith('#'): continue
			ra = la.split(';')
			#print ra
			if len(ra) < 1: continue
			if len(ra) == 1: ra += [default_url]
			if dep != ra[0]: continue
			src = ra[1]+'/'+ra[0]
		if src == '':
			if dep.endswith('.src.rpm'):
				src = default_url+'/'+dep
			else:
				src = 'file://' + dep
		add2ret("%s:%s" % (rule, src))
	for li in fi:
		li = li.strip()
		ri = li.split(';')
		if pn != ri[0]: continue
		for rulei in ri[1:]:
			add2ret("%s" % rulei)
	ret += ";\n"
	
print ""
print ""
print "============================SMART========================="
print ""
sys.stdout = real_stdout
print ret
