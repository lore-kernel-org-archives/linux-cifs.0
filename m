From: mail654-Mmb7MZpHnFY@public.gmane.org
Subject: blocking write() after disconnecting cifs server
Date: Tue, 3 Dec 2013 14:16:08 +0100 (CET)
Message-ID: <trinity-9dbe46e3-d6e6-4e61-84cc-98074cd0fea3-1386076567862@3capp-gmx-bs38>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello,

write() from cifs kernel driver blocks when disconnecting the cifs serv=
er. The blocking call didn't return after 30 minutes. Client and server=
 are connected via a switch and server's LAN cable is unplugged during =
the write call. I use kernel 3.11.8 and mounted without "hard" option.

Is there a possibility for an non-blocking write() without using O_SYNC=
 or "directio" mount option?

Way to reproduce the scenario: Below is a sample program which calls wr=
ite() in a loop. The error messages appear when unplugging the cable du=
ring this loop.

Kind regards,
Hagen

CIFS VFS: sends on sock ffff88003710c280 stuck for 15 seconds
CIFS VFS: Error -11 sending data on socket to server

#include <fstream>
#include <iostream>
int main () {
=C2=A0 const int size =3D 100000;
=C2=A0 char buffer[size];
=C2=A0 std::ofstream outfile("/mnt/new.bin",std::ofstream::binary);
=C2=A0 if (!outfile.is_open())
=C2=A0 {
=C2=A0=C2=A0=C2=A0 return 1;
=C2=A0 }
=C2=A0 for (int idx=3D0; idx<10000 && outfile.good(); idx++)
=C2=A0 {
=C2=A0=C2=A0=C2=A0 outfile.write(buffer,size);
=C2=A0=C2=A0=C2=A0 std::cout << "written, size=3D" << size << std::endl=
;
=C2=A0 }
=C2=A0 std::cout << "finished " << outfile.good() << std::endl;
=C2=A0 outfile.close();
=C2=A0 return 0;
}
