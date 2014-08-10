From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] cifs: Remove unused sess_auth_kerberos() for !CONFIG_CIFS_UPCALL case
Date: Sun, 10 Aug 2014 22:51:49 +0200
Message-ID: <1407703909-24350-2-git-send-email-geert@linux-m68k.org>
References: <1407703909-24350-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
To: Steve French <sfrench@samba.org>,
	Sachin Prabhu <sprabhu@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407703909-24350-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

If CONFIG_CIFS_UPCALL is not set:

fs/cifs/sess.c:1100: warning: =E2=80=98sess_auth_kerberos=E2=80=99 defi=
ned but not used

Commit cc87c47d9d7ac25554aa81cd8ded56e75f79c198 ("cifs: Separate
rawntlmssp auth from CIFS_SessSetup()") removed the sole user of the
dummy version of sess_auth_kerberos() in the non-CONFIG_CIFS_UPCALL
case, but forgot to remove the actual function definition.

Remove the dummy version to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 fs/cifs/sess.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 8090ad3c5ea5..31817bd5f4b0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1092,17 +1092,7 @@ out:
 	kfree(ses->auth_key.response);
 	ses->auth_key.response =3D NULL;
 }
-
-#else
-
-static void
-sess_auth_kerberos(struct sess_data *sess_data)
-{
-	cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
-	sess_data->result =3D -ENOSYS;
-	sess_data->func =3D NULL;
-}
-#endif /* ! CONFIG_CIFS_UPCALL */
+#endif /* CONFIG_CIFS_UPCALL */
=20
 /*
  * The required kvec buffers have to be allocated before calling this
--=20
1.9.1
