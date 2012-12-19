From: Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS mount fails if I ctrl-c a long-running find process (Linux mounting Windows share)
Date: Wed, 19 Dec 2012 11:15:53 -0800 (PST)
Message-ID: <1355944553.61735.YahooMailNeo@web160303.mail.bf1.yahoo.com>
References: <1355872616.69791.YahooMailNeo@web160302.mail.bf1.yahoo.com> <20121219090322.3999f995@tlielax.poochiereds.net>
Reply-To: Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121219090322.3999f995-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear Jeff, et. al.,

I can reproduce the problem by starting "find . -name \*.ext"and killin=
g it when connected to either of our two Windows 2003 Servers. I can *n=
ot* reproduce it doing the same thing connected to a windows 7 box.

$ uname -a
Linux servername 3.2.0-34-generic #53-Ubuntu SMP Thu Nov 15 10:49:02 UT=
C 2012 i686 i686 i386 GNU/Linux
$ cat /proc/version

Linux version 3.2.0-34-generic (buildd@roseapple) (gcc version 4.6.3 (U=
buntu/Linaro 4.6.3-1ubuntu5) ) #53-Ubuntu SMP Thu Nov 15 10:49:02 UTC 2=
012
$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description: =A0 =A0Ubuntu 12.04.1 LTS
Release: =A0 =A0 =A0 =A012.04
Codename: =A0 =A0 =A0 precise


I tried using strace but hitting ctrl-c killed strace (obviously, oops)=
, but interestingly, this did *not* hang the file system. I will try an=
d kill the find command (kill -9 perhaps?) and see if I can recreate th=
e error that way.

Tim








----- Original Message -----
=46rom: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sent: Wednesday, December 19, 2012 6:03 AM
Subject: Re: CIFS mount fails if I ctrl-c a long-running find process (=
Linux mounting Windows share)

On Tue, 18 Dec 2012 15:16:56 -0800 (PST)
Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrote:

> We have a windows 2003 server with a directory shared. I connect to i=
t from linux (Ubuntu 12.04) using CIFS. Once mounted, I can read/write =
files, list files, et cetera from the linux box. However, if I run "fin=
d . -name \*txt" and hit ctrl-c before the find command finishes then t=
he mount immediately fails (the find command takes about 15 minutes to =
complete on this particular file system). Not only that, once the mount=
 fails I can't successfully remount the drive without rebooting the lin=
ux box. This makes me think a kernel bug is in play.... Occasionally us=
ing lsof or fuser I can find a process that is keeping the mount alive,=
 kill it, and remount the filesystem without rebooting. However, this i=
s rare.
>=20
> Perhaps I'm just missing some setting to CIFS, but I can't figure it =
out. I know what you are thinking "Use the google, Luke" which I have t=
ried. However, I get about 5000 hits for "I kan't mount my Windozes on =
my linux, kan u give m3 teh codez pleaze" which is almost, but not quit=
e my issue.
>=20
> Anyhow, /etc/fstab contains:
> //server/All_proj /server/all_proj cifs sec=3Dntlmv2i,iocharset=3Dutf=
8,uid=3Dperry,credentials=3D/home/me/.smbcred,noauto,filemode=3D0777,di=
r_mode=3D0777,_netdev,gid=3D5000 0 0
>=20
> Around the time the mount fails, I see this in /var/log/syslog:
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028311] CIFS VFS: Unexpected=
 SMB signature
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028318] CIFS VFS: Send error=
 in Close =3D -13
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028558] CIFS VFS: Unexpected=
 SMB signature
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028886] CIFS VFS: Unexpected=
 SMB signature
> Dec 13 10:40:35 chinstrap kernel: [ 2412.029395] CIFS VFS: Unexpected=
 SMB signature
> ....
>=20
> I also see the following in /var/log/kern.log
> Dec 13 10:01:29 chinstrap kernel: [ =A0 66.567463] CIFS VFS: default =
security mechanism requested. =A0The default security mechanism will be=
 upgraded from ntlm to ntlmv2 in kernel release 3.3
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028311] CIFS VFS: Unexpected=
 SMB signature
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028318] CIFS VFS: Send error=
 in Close =3D -13
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028558] CIFS VFS: Unexpected=
 SMB signature
> Dec 13 10:40:35 chinstrap kernel: [ 2412.028886] CIFS VFS: Unexpected=
 SMB signature
> Dec 13 10:40:35 chinstrap kernel: [ 2412.029395] CIFS VFS: Unexpected=
 SMB signature
> ....
>=20
> So....I know there must be somewhere to report this as a bug and beg =
for help, but I have no idea where? Do I go to the Ubuntu folks at Cano=
nical? To the Linux kernel team? Here?
>=20

I have no idea what kernel 12.04 uses. Can you tell us the kernel
version? As far as I know, Ubuntu generally pulls their kernels
directly from upstream ones (or the stable series) so this is probably
a problem for mainline kernels too.

It sounds like signals are somehow causing the sequence numbers for
signatures to get out-of-whack. -13 is -EACCES, so it sounds like the
server is just returning errors and not disconnecting the socket when
this happens. That behavior varies between different windows versions..=
=2E

The reason you need to reboot to clear this is probably because
something is holding a reference to the connection to the server. When
you try to unmount and remount it, then it ends up reusing the same
socket which is obviously still having problems.

The best thing you could do is to provide as simple a way as possible
to reproduce this problem. You may also want to do some investigation
on your own by stracing the process.

Is it getting hung on a particular syscall before you ever issue your
signal? If not, then does it get hung on a syscall afterward? What
state is the process in at that time?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
