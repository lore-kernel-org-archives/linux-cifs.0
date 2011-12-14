From: Casey <csease-YgS7x4LLi8k@public.gmane.org>
Subject: cifs issue with Domain Based DFS share on Windows Server 2008 R2
Date: Wed, 14 Dec 2011 21:38:09 +0000 (UTC)
Message-ID: <loom.20111214T223547-440@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

I have been working on this for weeks and have exhausted all my resourc=
es. I am
hoping to get some help. We are having an issue connecting to domain ba=
sed DFS
shares on Windows 2008 R2 servers. It used to work when one of the DCs =
were
Windows 2003, but that DC has been decommissioned. I can get a browse t=
hese
shares using smbclient, but cifs is our preferred method of mounting wi=
ndows
shares. We can mount directly to the backend dfs servers, just not thro=
ugh the
Domain namespace.

Here is some background information:

Kernel =3D 2.6.32-131.12.1.el6.i686
Samba version =3D 3.5.10-114.el6.i686
mount.cifs version: 4.8.1
cifs-utils and keyutils is installed with request-key.conf configured c=
orrectly.
Doing a Wireshark trace of the failed mount shows we are not getting re=
ferrals.
CIFS debug shows =E2=80=9CStatus code returned 0xc00000cc NT_STATUS_BAD=
_NETWORK_NAME=E2=80=9D
I have tried with all different sec protocols to no avail.

Mount command we are using in fstab:
                //<domain name>/<DFS root> /opt/test cifs
rw,username=3D*****,password=3D*****,domain=3DNDGOV,dir_mode=3D0755,fil=
e_mode=3D0644 0 0

Thank you very much for your time!

Casey
