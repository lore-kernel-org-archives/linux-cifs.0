From: Koen Vermeer <koen-6aKAu+ryoJO2z7vLlVgmTQ@public.gmane.org>
Subject: Map missing in cifs-mount, but available in smbclient
Date: Fri, 10 Jun 2011 11:39:09 +0000 (UTC)
Message-ID: <loom.20110610T133205-66@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

I have mounted a share on a Windows-server with a corresponding entry in 
/etc/fstab of:

//san02-a/Data$	/mnt/san02-a/data	cifs	
domain=MYDOMAIN,user=MYUSER,password=MYPASSWD,uid=MYUID,gid=MYGID,_netdev
0	0

This works reasonably well, except that I'm missing a folder. If I run 'ls
/mnt/san02-a/data/Afdeling/ROI/', I get two entries (PRIVATE and PUBLIC), but
one (STUDIES) is missing.

Now, if I run

smbclient -U MYNAME -W MYDOMAIN //san02-a/Data$

and then do 'ls Afdeling\ROI\*', I do get all three directories. Changing to the
STUDIES directory also works fine.

Can anyone give me a hint on how to fix this or how to find out what's going on?

Best,
Koen
