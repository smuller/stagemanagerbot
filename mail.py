#!/usr/bin/python
import subprocess

sender = "Stefan Muller <smuller@cs.cmu.edu>"

def makemail (to, body, subj):
    tos = "\n".join(map(lambda x: "To: " + x, to))
    return (tos + "\n" + "Subject: " + subj + "\n" + "From: " + sender + "\n\n" + body)

def sendmail (to, body, subj):
    f = open("temp", 'w')
    mail = makemail(to, body, subj)
    f.write(mail)
    f.close()
    tos = " ".join(map(lambda x: "\"" + x + "\"", to))
    cmd = "cat temp | sendmail " + tos
    print cmd
    subprocess.check_call(cmd, shell=True)

sendmail (["Stefan Muller <smuller@cs.cmu.edu>", "skm@andrew.cmu.edu"], "Hi!", "Hi!")
