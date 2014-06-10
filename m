From: =?UTF-8?q?Bj=C3=B6rn=20Baumbach?= <bb@sernet.de>
Subject: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
Date: Tue, 10 Jun 2014 12:03:26 +0200
Message-ID: <1402394606-7910-1-git-send-email-bb@sernet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pavel Shilovsky <piastry@etersoft.ru>, stable@vger.kernel.org,
	=?UTF-8?q?Bj=C3=B6rn=20Baumbach?= <bb@sernet.de>,
	Stefan Metzmacher <metze@samba.org>
To: Steve French <sfrench@samba.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

commit d81b8a40e2ece0a9ab57b1fe1798e291e75bf8fc
("CIFS: Cleanup cifs open codepath")
changed disposition to FILE_OPEN.

Signed-off-by: Bj=C3=B6rn Baumbach <bb@sernet.de>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Reviewed-by: Stefan Metzmacher <metze@samba.org>
Cc: <stable@vger.kernel.org> # v3.14+
Cc: Pavel Shilovsky <piastry@etersoft.ru>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/link.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 264ece7..68559fd 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -374,7 +374,7 @@ cifs_create_mf_symlink(unsigned int xid, struct cif=
s_tcon *tcon,
 	oparms.cifs_sb =3D cifs_sb;
 	oparms.desired_access =3D GENERIC_WRITE;
 	oparms.create_options =3D create_options;
-	oparms.disposition =3D FILE_OPEN;
+	oparms.disposition =3D FILE_CREATE;
 	oparms.path =3D path;
 	oparms.fid =3D &fid;
 	oparms.reconnect =3D false;
--=20
1.7.9.5
