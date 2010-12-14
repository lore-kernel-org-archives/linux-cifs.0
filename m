From: Cristian <naitso-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mount.cifs with EMC share
Date: Tue, 14 Dec 2010 19:49:45 +0000 (UTC)
Message-ID: <ie8hop$k75$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi there! 

I'm experiencing an issue with mount.cifs command (maybe in cifs module) 
on recent kernel 2.6.36.2 (mount.cifs version: 1.14-3.5.5). The same 
happens with kernel 2.6.33.4 too.

If i mount a EMC-SNAS (Celerra) Share (on windows is seen as simple 
share) with
mount -t cifs //IP-ADDRESS/Share /mnt/ -o user=myuser,pass=mypassword,ro
and I try the "ls" command I see the following output:

ls /mnt/
V/  V~1/  ???????/  ???????/  ???????/  ??/

With an older kernel like 2.6.27.31 (mount.cifs version: 1.12-3.2.15, 
samba-3.2.15) all works fine.

With smbclient command (on samba 3.5.5) all works fine, too.

What puzzles me is that if i type on the shell:
"ls /mnt"
and i press [TAB] key for 4, 5 times for autocompletion, the output is 
updated, the files and the directory names are showed correctly, 

ls /mnt/
Irfanview/ Outlook/   Windows/   Zetafax/

but the problem persists at the next mount.

With Windows share or smb share all works fine with recent kernel/samba;
the problem is only with EMC Hardware

Thanks in advance
