From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 3 Nov 2011 15:55:30 -0500
Message-ID: <CAH2r5msk+vAHq28tCRzOjAEZ6t6Vpd-pM6XsPy5u3nhrmcbCDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit f362f98e7c445643d27c610bb7a86b79727b=
592e:
=A0 Linus Torvalds (1):
=A0=A0=A0=A0=A0=A0=A0 Merge branch 'for-next' of git://git.kernel.org/.=
=2E./hch/vfs-queue

are available in the git repository at:

=A0 git://git.samba.org/sfrench/cifs-2.6.git master

Pavel Shilovsky (2):
=A0=A0=A0=A0=A0 CIFS: Remove extra mutex_unlock in cifs_lock_add_if
=A0=A0=A0=A0=A0 CIFS: Fix the VFS brlock cache usage in posix locking c=
ase

Shirish Pargaonkar (1):
=A0=A0=A0=A0=A0 cifs: Assume passwords are encoded according to iochars=
et (try #2)

Steve French (1):
=A0=A0=A0=A0=A0 [CIFS] Update cifs version to 1.76

=A0fs/cifs/cifsencrypt.c |=A0=A0=A0 8 +++---
=A0fs/cifs/cifsfs.h=A0=A0=A0=A0=A0 |=A0=A0=A0 2 +-
=A0fs/cifs/cifsproto.h=A0=A0 |=A0=A0=A0 8 ++++--
=A0fs/cifs/connect.c=A0=A0=A0=A0 |=A0=A0=A0 2 +-
=A0fs/cifs/file.c=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 11 ++++++--
=A0fs/cifs/sess.c=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 2 +-
=A0fs/cifs/smbencrypt.c=A0 |=A0=A0 63 +++++++++------------------------=
---------------
=A07 files changed, 32 insertions(+), 64 deletions(-)


--
Thanks,

Steve
