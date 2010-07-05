From: Kulikov Vasiliy <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: silence compiler warning
Date: Mon,  5 Jul 2010 12:01:09 +0400
Message-ID: <1278316870-29112-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kernel Janitors <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If buf is NULL then ppdata is unitialized after exit from validate_ntra=
nsact().
In this case we do not use ppdata, but compiler warns us. Make it happy=
=2E

This patch silences a compiler warning:
fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBGetCIFSACL=E2=80=99:
fs/cifs/cifssmb.c:3082: warning: =E2=80=98pdata=E2=80=99 may be used un=
initialized in this function

Signed-off-by: Kulikov Vasiliy <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c65c341..22805e2 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2506,6 +2506,7 @@ validate_ntransact(char *buf, char **ppparm, char=
 **ppdata,
=20
 	*pdatalen =3D 0;
 	*pparmlen =3D 0;
+	*ppdata =3D 0;
=20
 	if (buf =3D=3D NULL)
 		return -EINVAL;
--=20
1.7.0.4
