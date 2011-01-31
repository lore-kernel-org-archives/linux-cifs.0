From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] cifs: fix compiler warning about incompatible pointer type (try #2)
Date: Mon, 31 Jan 2011 14:41:23 +0300
Message-ID: <1296474083-18350-1-git-send-email-piastry@etersoft.ru>
References: <4D4693CF.9090903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D4693CF.9090903-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fs/cifs/file.c: In function =E2=80=98cifs_iovec_write=E2=80=99:
fs/cifs/file.c:1740:9: warning: passing argument 6 of =E2=80=98CIFSSMBW=
rite2=E2=80=99 from incompatible pointer type
fs/cifs/cifsproto.h:343:12: note: expected =E2=80=98unsigned int *=E2=80=
=99 but argument is of type =E2=80=98size_t *=E2=80=99

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/file.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0de17c1..4940bac 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1667,9 +1667,9 @@ static ssize_t
 cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
-	size_t total_written =3D 0, written =3D 0;
-	unsigned long num_pages, npages;
-	size_t copied, len, cur_len, i;
+	unsigned int written =3D 0;
+	unsigned long num_pages, npages, i;
+	size_t copied, len, cur_len, total_written =3D 0;
 	struct kvec *to_send;
 	struct page **pages;
 	struct iov_iter it;
--=20
1.7.1
