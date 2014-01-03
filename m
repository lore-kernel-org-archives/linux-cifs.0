From: mail654-Mmb7MZpHnFY@public.gmane.org
Subject: Aw: Re: blocking write() after disconnecting cifs server
Date: Fri, 3 Jan 2014 10:10:32 +0100 (CET)
Message-ID: <trinity-a630f46b-f2a6-464d-a451-aced2f4fe7e6-1388740232116@3capp-gmx-bs43>
References: <trinity-9dbe46e3-d6e6-4e61-84cc-98074cd0fea3-1386076567862@3capp-gmx-bs38>
 <20131223054643.4f6c06c9@tlielax.poochiereds.net>
 <trinity-2ffa0afb-c02b-46c6-9e2e-31b209aebd8b-1388678667254@3capp-gmx-bs34>,
 <20140102143157.3232068c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140102143157.3232068c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org wrote:
> On Thu, 2 Jan 2014 17:04:27 +0100 (CET)
> mail654-Mmb7MZpHnFY@public.gmane.org wrote:
>=20
> > > > write() from cifs kernel driver blocks when disconnecting the c=
ifs server. The blocking call didn't return after 30 minutes. Client an=
d server are connected via a switch and server's LAN cable is unplugged=
 during the write call. I use kernel 3.11.8 and mounted without "hard" =
option.
> > > >=20
> > > > Is there a possibility for an non-blocking write() without usin=
g O_SYNC or "directio" mount option?
> > > >=20
> > > > Way to reproduce the scenario: Below is a sample program which =
calls write() in a loop. The error messages appear when unplugging the =
cable during this loop.
> > > >=20
> > > > Kind regards,
> > > > Hagen
> > > >=20
> > > > CIFS VFS: sends on sock ffff88003710c280 stuck for 15 seconds
> > > > CIFS VFS: Error -11 sending data on socket to server
> > > >=20
> > > > #include <fstream>
> > > > #include <iostream>
> > > > int main () {
> > > > =C2=A0 const int size =3D 100000;
> > > > =C2=A0 char buffer[size];
> > > > =C2=A0 std::ofstream outfile("/mnt/new.bin",std::ofstream::bina=
ry);
> > > > =C2=A0 if (!outfile.is_open())
> > > > =C2=A0 {
> > > > =C2=A0=C2=A0=C2=A0 return 1;
> > > > =C2=A0 }
> > > > =C2=A0 for (int idx=3D0; idx<10000 && outfile.good(); idx++)
> > > > =C2=A0 {
> > > > =C2=A0=C2=A0=C2=A0 outfile.write(buffer,size);
> > > > =C2=A0=C2=A0=C2=A0 std::cout << "written, size=3D" << size << s=
td::endl;
> > > > =C2=A0 }
> > > > =C2=A0 std::cout << "finished " << outfile.good() << std::endl;
> > > > =C2=A0 outfile.close();
> > > > =C2=A0 return 0;
> > > > }
> > >=20
> > > A hang of that length is unexpected. If you're able to reproduce =
this,
> > > can you get the stack from the task issuing the write at the time=
?
> > >=20
> > >     $ cat /proc/<pid>/stack
> > >=20
> > > That might give us a clue as to what it's doing.
> >=20
> > [<ffffffff8170ab8c>] balance_dirty_pages.isra.19+0x4ac/0x55c
> > [<ffffffff8115455b>] balance_dirty_pages_ratelimited+0xeb/0x110
> > [<ffffffff81148f3a>] generic_perform_write+0x16a/0x210
> > [<ffffffff8114903d>] generic_file_buffered_write+0x5d/0x90
> > [<ffffffff8114aa66>] __generic_file_aio_write+0x1b6/0x3b0
> > [<ffffffff8114acc9>] generic_file_aio_write+0x69/0xd0
> > [<ffffffffa03ef225>] cifs_strict_writev+0xa5/0xd0 [cifs]
> > [<ffffffff811b2b95>] do_sync_readv_writev+0x65/0x90
> > [<ffffffff811b4312>] do_readv_writev+0xd2/0x2b0
> > [<ffffffff811b452c>] vfs_writev+0x3c/0x50
> > [<ffffffff811b46a2>] SyS_writev+0x52/0xc0
> > [<ffffffff8172976f>] tracesys+0xe1/0xe6
> > [<ffffffffffffffff>] 0xffffffffffffffff
> >=20
>=20
> Looks like it's stuck in dirty page throttling.
>=20
> What's likely happening is that you have a bunch of dirty pages when
> you go to pull the cable. At that point the system is trying to flush
> the pages so that this task can try to dirty more of them.
>=20
> What *should* happen (at least if this is a soft mount) is that the
> writeback of those pages eventually times out, the pages get their
> error bit set and eventually the write() syscalls go through.
>=20
> Have you tried stracing this and are able to tell that the write
> syscall never returns in this situation? Is it possible that the
> write() syscalls are returning, albeit slowly?

No, during several straces I've never seen a write() syscall returning =
after
pulling the cable.

Hagen
