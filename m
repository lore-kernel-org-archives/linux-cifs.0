From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: blocking write() after disconnecting cifs server
Date: Mon, 23 Dec 2013 05:46:43 -0500
Message-ID: <20131223054643.4f6c06c9@tlielax.poochiereds.net>
References: <trinity-9dbe46e3-d6e6-4e61-84cc-98074cd0fea3-1386076567862@3capp-gmx-bs38>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mail654-Mmb7MZpHnFY@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <trinity-9dbe46e3-d6e6-4e61-84cc-98074cd0fea3-1386076567862@3capp-gmx-bs38>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 3 Dec 2013 14:16:08 +0100 (CET)
mail654-Mmb7MZpHnFY@public.gmane.org wrote:

> Hello,
>=20
> write() from cifs kernel driver blocks when disconnecting the cifs se=
rver. The blocking call didn't return after 30 minutes. Client and serv=
er are connected via a switch and server's LAN cable is unplugged durin=
g the write call. I use kernel 3.11.8 and mounted without "hard" option=
=2E
>=20
> Is there a possibility for an non-blocking write() without using O_SY=
NC or "directio" mount option?
>=20
> Way to reproduce the scenario: Below is a sample program which calls =
write() in a loop. The error messages appear when unplugging the cable =
during this loop.
>=20
> Kind regards,
> Hagen
>=20
> CIFS VFS: sends on sock ffff88003710c280 stuck for 15 seconds
> CIFS VFS: Error -11 sending data on socket to server
>=20
> #include <fstream>
> #include <iostream>
> int main () {
> =A0 const int size =3D 100000;
> =A0 char buffer[size];
> =A0 std::ofstream outfile("/mnt/new.bin",std::ofstream::binary);
> =A0 if (!outfile.is_open())
> =A0 {
> =A0=A0=A0 return 1;
> =A0 }
> =A0 for (int idx=3D0; idx<10000 && outfile.good(); idx++)
> =A0 {
> =A0=A0=A0 outfile.write(buffer,size);
> =A0=A0=A0 std::cout << "written, size=3D" << size << std::endl;
> =A0 }
> =A0 std::cout << "finished " << outfile.good() << std::endl;
> =A0 outfile.close();
> =A0 return 0;
> }

A hang of that length is unexpected. If you're able to reproduce this,
can you get the stack from the task issuing the write at the time?

    $ cat /proc/<pid>/stack

That might give us a clue as to what it's doing.
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
