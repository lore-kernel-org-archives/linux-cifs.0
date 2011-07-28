From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Compile warning
Date: Thu, 28 Jul 2011 11:03:02 -0500
Message-ID: <CAH2r5muQpc+rtCaVO+BXAAP6+Fubofa8nk0Tv2ceu1zOA7_m4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Compiler (gcc 4.4.3 on this system) throws an incorrect warning on
your recent ea patch.
It may be worth minor adjustments to remove the compile warning.

CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function =91CIFSSMBQAllEAs=92:
fs/cifs/cifssmb.c:5723: warning: =91ea_name_len=92 may be used
uninitialized in this function


--=20
Thanks,

Steve
