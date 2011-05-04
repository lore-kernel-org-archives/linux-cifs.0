From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix some unused variable warnings in id_rb_search
Date: Wed,  4 May 2011 08:08:19 -0400
Message-ID: <1304510899-30360-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

fs/cifs/cifsacl.c: In function =E2=80=98id_rb_search=E2=80=99:
fs/cifs/cifsacl.c:215:19: warning: variable =E2=80=98linkto=E2=80=99 se=
t but not used
[-Wunused-but-set-variable]
fs/cifs/cifsacl.c:214:18: warning: variable =E2=80=98parent=E2=80=99 se=
t but not used
[-Wunused-but-set-variable]

Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index a4aa0f0..bfb5ba5 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -211,19 +211,14 @@ id_rb_search(struct rb_root *root, struct cifs_si=
d *sidptr)
 {
 	int rc;
 	struct rb_node *node =3D root->rb_node;
-	struct rb_node *parent =3D NULL;
-	struct rb_node **linkto =3D &(root->rb_node);
 	struct cifs_sid_id *lsidid;
=20
 	while (node) {
 		lsidid =3D rb_entry(node, struct cifs_sid_id, rbnode);
-		parent =3D node;
 		rc =3D compare_sids(sidptr, &((lsidid)->sid));
 		if (rc > 0) {
-			linkto =3D &(node->rb_left);
 			node =3D node->rb_left;
 		} else if (rc < 0) {
-			linkto =3D &(node->rb_right);
 			node =3D node->rb_right;
 		} else /* node found */
 			return lsidid;
--=20
1.7.4.4
