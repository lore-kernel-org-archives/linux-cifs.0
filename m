From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Subject: [PATCH] cifs:fix build warnings
Date: Thu, 11 Sep 2014 16:37:55 +0800
Message-ID: <35FD53F367049845BC99AC72306C23D103CDBFBFB01B@CNBJMBX05.corpusers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
To: "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>, "'sfrench@samba.org'" <sfrench@samba.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>, "'linux-cifs@vger.kernel.org'"
	<linux-cifs@vger.kernel.org>, "'samba-technical@lists.samba.org'" <samba-technical@lists.samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

this fix the following warnings=1B$B!'=1B(B
kernel.torvalds.git/fs/cifs/sess.c:751:1: warning: 'sess_auth_lanman' defin=
ed but not used [-Wunused-function]
kernel.torvalds.git/fs/cifs/sess.c:1109:1: warning: 'sess_auth_kerberos' de=
fined but not used [-Wunused-function]

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
fs/cifs/sess.c | 19 -------------------
1 file changed, 19 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3a5e833..7bc9c03 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -744,15 +744,6 @@ out:
               sess_data->func =3D NULL;
               sess_free_buffer(sess_data);
}
-
-#else
-
-static void
-sess_auth_lanman(struct sess_data *sess_data)
-{
-              sess_data->result =3D -EOPNOTSUPP;
-              sess_data->func =3D NULL;
-}
#endif
 static void
@@ -1102,16 +1093,6 @@ out:
               kfree(ses->auth_key.response);
               ses->auth_key.response =3D NULL;
}
-
-#else
-
-static void
-sess_auth_kerberos(struct sess_data *sess_data)
-{
-              cifs_dbg(VFS, "Kerberos negotiated but upcall support disabl=
ed!\n");
-              sess_data->result =3D -ENOSYS;
-              sess_data->func =3D NULL;
-}
#endif /* ! CONFIG_CIFS_UPCALL */
 /*
--
2.1.0
