From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] cifs: Remove unused sess_auth_lanman() for !CONFIG_CIFS_WEAK_PW_HASH case
Date: Sun, 10 Aug 2014 22:51:48 +0200
Message-ID: <1407703909-24350-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Steve French <sfrench@samba.org>,
	Sachin Prabhu <sprabhu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

If CONFIG_CIFS_WEAK_PW_HASH is not set:

fs/cifs/sess.c:751: warning: =E2=80=98sess_auth_lanman=E2=80=99 defined=
 but not used

Commit cc87c47d9d7ac25554aa81cd8ded56e75f79c198 ("cifs: Separate
rawntlmssp auth from CIFS_SessSetup()") removed the sole user of the
dummy version of sess_auth_lanman() in the non-CONFIG_CIFS_WEAK_PW_HASH
case, but forgot to remove the actual function definition.

Remove the dummy version to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/cifs/sess.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 39ee32688eac..8090ad3c5ea5 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -743,16 +743,7 @@ out:
 	sess_data->func =3D NULL;
 	sess_free_buffer(sess_data);
 }
-
-#else
-
-static void
-sess_auth_lanman(struct sess_data *sess_data)
-{
-	sess_data->result =3D -EOPNOTSUPP;
-	sess_data->func =3D NULL;
-}
-#endif
+#endif /* CONFIG_CIFS_WEAK_PW_HASH */
=20
 static void
 sess_auth_ntlm(struct sess_data *sess_data)
--=20
1.9.1
