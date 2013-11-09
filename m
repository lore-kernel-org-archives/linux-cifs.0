From: Eric Valette <eric.valette-GANU6spQydw@public.gmane.org>
Subject: possible write error code on a CIFS mounted file (e.g EAGAIN) see
 INTR recent question
Date: Sat, 09 Nov 2013 14:12:51 +0100
Message-ID: <527E34D3.70405@free.fr>
Reply-To: eric.valette-GANU6spQydw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ishikawa <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reading through the post of chiaki ISHIKAWA (tahnks for his time to try 
to fix the problem), I would like to explain a bit more the problem I 
have with thunderbid 24 on debian linux 64 bits (kernel 3.10.18) when I 
want to copy block of messages from an imap folder to a file located on 
a filler where my networked home exist.

First I have to say that thunderbird is the only program that does not 
behave correctly so the culprit is probably a bad coding in low level IO 
function handling in thunderbird (e.g read/write). I use the same debian 
setup at home, but local mail folder is really local and everything 
works there.

When I have a huge pile of IMAP message I sort them for archiving using 
classical search method (e.g all mail with foo.com in address stored in 
local/foo directory). Doing this I move several files including some 
with significant file attached (e.g 6MB). And usually it takes ages, 
does not finish but reports no error and the resulting target mbox is 
sometimes garbled. Doeing the same thing inside a windows VM on the same 
machine works well.

As significant file move by other applications from the local linux file 
system to the filler via linux cifs client code do work and are quite 
rapid, and  because after having problem with tunderbird other 
application continue to work well, I suspect the culprit is TB. But as 
it works for most people using local files folder, I suspect bad 
handling of error code (write return -1 and errno value is 
unexpected/unhandled).

So getting a list of possible errno value from read(2)/write(2) may help.


The mount option I have for this share:
I do not see the noserverino from the mount command result below but on 
the command line I have in addition to credential and domain:

iocharset=utf8,noserverino

rw,relatime,vers=1.0,sec=ntlmssp,cache=strict,username=xxxxx,domain=xxxx,uid=xxxxx,forceuid,gid=xxxxx,forcegid,addr=10.192.192.2,file_mode=0755,dir_mode=0755,nounix,rsize=61440,wsize=65536,actimeo=1)


-- eric
