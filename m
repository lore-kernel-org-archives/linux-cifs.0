From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix compiler warning in CIFSSMBQAllEAs
Date: Thu, 28 Jul 2011 12:48:26 -0400
Message-ID: <1311871706-8311-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The recent fix to the above function causes this compiler warning to po=
p
on some gcc versions:

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBQAllEAs=E2=80=99:
fs/cifs/cifssmb.c:5708: warning: =E2=80=98ea_name_len=E2=80=99 may be u=
sed uninitialized in
this function

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index acfbd41..f4d0988 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5730,7 +5730,7 @@ CIFSSMBQAllEAs(const int xid, struct cifs_tcon *t=
con,
 	char *temp_ptr;
 	char *end_of_smb;
 	__u16 params, byte_count, data_offset;
-	unsigned int ea_name_len;
+	unsigned int ea_name_len =3D ea_name ? strlen(ea_name) : 0;
=20
 	cFYI(1, "In Query All EAs path %s", searchName);
 QAllEAsRetry:
@@ -5825,10 +5825,6 @@ QAllEAsRetry:
 	list_len -=3D 4;
 	temp_fea =3D ea_response_data->list;
 	temp_ptr =3D (char *)temp_fea;
-
-	if (ea_name)
-		ea_name_len =3D strlen(ea_name);
-
 	while (list_len > 0) {
 		unsigned int name_len;
 		__u16 value_len;
--=20
1.7.6
