From: Thomas Creutz <thomas.creutz-Mmb7MZpHnFY@public.gmane.org>
Subject: character-problems
Date: Thu, 01 May 2014 10:59:21 +0200
Message-ID: <53620CE9.10301@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi List,

I use samba server on my webserver and mount the share with a linux
client to backup the files remote. Problem is, that I cannot access all
files with linux cifs client and secondly filenames are changed, so tha=
t
the backup (when possible to access the files) is not well done.

On the server output of ls -lah is:
insgesamt 400K
drwxr-xr-x  2 web178 client14 4,0K Mai 28  2008 .
drwxrwxrwx 13 web178 client14 4,0K Okt 17  2013 ..
-rw-r--r--  1 web178 client14  59K Mai 28  2008 JulianKiendlGitarre.jpg
-rw-r--r--  1 web178 client14  79K Mai 28  2008 Kost?me1.jpg
-rw-r--r--  1 web178 client14  51K Mai 28  2008 Kost?me2.jpg
-rw-r--r--  1 web178 client14  55K Mai 28  2008 MuellerReeb.jpg
-rw-r--r--  1 web178 client14  42K Mai 28  2008 Partyraum.jpg
-rw-r--r--  1 web178 client14  60K Mai 28  2008 Schlegel.jpg
-rw-r--r--  1 web178 client14  38K Mai 28  2008 Tanzen.jpg

on the client side:
insgesamt 392K
drwxr-xr-x  2 1124 1051   0 Mai 28  2008 .
drwxrwxrwx 13 1124 1051   0 Okt 17  2013 ..
-rw-r--r--  1 1124 1051 59K Mai 28  2008 JulianKiendlGitarre.jpg
-rw-r--r--  1 1124 1051 79K Mai 28  2008 Kost_me1.jpg
-rw-r--r--  1 1124 1051 51K Mai 28  2008 Kost_me2.jpg
-rw-r--r--  1 1124 1051 55K Mai 28  2008 MuellerReeb.jpg
-rw-r--r--  1 1124 1051 42K Mai 28  2008 Partyraum.jpg
-rw-r--r--  1 1124 1051 60K Mai 28  2008 Schlegel.jpg
-rw-r--r--  1 1124 1051 38K Mai 28  2008 Tanzen.jpg

LANG=3DC cp Kost_me1.jpg /tmp/
cp: cannot stat `Kost_me1.jpg': No such file or directory

The charset is correct, some folders use the right chars (=FC=E4=F6...)=
 which
are displayed on server and client right.

I tested to access the share with windows client and can open the
picture, so i am able to access the files from windows.

Mounted are the shares with:
//web1.domain.tld/root$ /backup/src/web1   cifs
noauto,sec=3Dntlmv2,ver=3D1,cred=3D/root/.smb/web1.domain.tld 0 0

Samba on Server 3.6.3
Kernel on client 3.5.0-49-generic (Ubuntu)

Any Idea, how I get access to
1. the original file names (no translation to _)
2. can access the files (possible done, when 1. is done)

Thanks for you help,
Thomas
