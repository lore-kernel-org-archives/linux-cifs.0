From: Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: CIFS mount fails if I ctrl-c a long-running find process (Linux mounting Windows share)
Date: Tue, 18 Dec 2012 15:16:56 -0800 (PST)
Message-ID: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com>
Reply-To: Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have a windows 2003 server with a directory shared. I connect to it =
from linux (Ubuntu 12.04) using CIFS. Once mounted, I can read/write fi=
les, list files, et cetera from the linux box. However, if I run "find =
=2E -name \*txt" and hit ctrl-c before the find command finishes then t=
he mount immediately fails (the find command takes about 15 minutes to =
complete on this particular file system). Not only that, once the mount=
 fails I can't successfully remount the drive without rebooting the lin=
ux box. This makes me think a kernel bug is in play.... Occasionally us=
ing lsof or fuser I can find a process that is keeping the mount alive,=
 kill it, and remount the filesystem without rebooting. However, this i=
s rare.

Perhaps I'm just missing some setting to CIFS, but I can't figure it ou=
t. I know what you are thinking "Use the google, Luke" which I have tri=
ed. However, I get about 5000 hits for "I kan't mount my Windozes on my=
 linux, kan u give m3 teh codez pleaze" which is almost, but not quite =
my issue.

Anyhow, /etc/fstab contains:
//server/All_proj /server/all_proj cifs sec=3Dntlmv2i,iocharset=3Dutf8,=
uid=3Dperry,credentials=3D/home/me/.smbcred,noauto,filemode=3D0777,dir_=
mode=3D0777,_netdev,gid=3D5000 0 0

Around the time the mount fails, I see this in /var/log/syslog:
Dec 13 10:40:35 chinstrap kernel: [ 2412.028311] CIFS VFS: Unexpected S=
MB signature
Dec 13 10:40:35 chinstrap kernel: [ 2412.028318] CIFS VFS: Send error i=
n Close =3D -13
Dec 13 10:40:35 chinstrap kernel: [ 2412.028558] CIFS VFS: Unexpected S=
MB signature
Dec 13 10:40:35 chinstrap kernel: [ 2412.028886] CIFS VFS: Unexpected S=
MB signature
Dec 13 10:40:35 chinstrap kernel: [ 2412.029395] CIFS VFS: Unexpected S=
MB signature
=2E...

I also see the following in /var/log/kern.log
Dec 13 10:01:29 chinstrap kernel: [ =A0 66.567463] CIFS VFS: default se=
curity mechanism requested. =A0The default security mechanism will be u=
pgraded from ntlm to ntlmv2 in kernel release 3.3
Dec 13 10:40:35 chinstrap kernel: [ 2412.028311] CIFS VFS: Unexpected S=
MB signature
Dec 13 10:40:35 chinstrap kernel: [ 2412.028318] CIFS VFS: Send error i=
n Close =3D -13
Dec 13 10:40:35 chinstrap kernel: [ 2412.028558] CIFS VFS: Unexpected S=
MB signature
Dec 13 10:40:35 chinstrap kernel: [ 2412.028886] CIFS VFS: Unexpected S=
MB signature
Dec 13 10:40:35 chinstrap kernel: [ 2412.029395] CIFS VFS: Unexpected S=
MB signature
=2E...

So....I know there must be somewhere to report this as a bug and beg fo=
r help, but I have no idea where? Do I go to the Ubuntu folks at Canoni=
cal? To the Linux kernel team? Here?

Help please!

Thanks,
Tim
