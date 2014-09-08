From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] cifs: remove dead code
Date: Mon, 08 Sep 2014 17:20:56 +0200
Message-ID: <3319326.1eJrmz0Vgc@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cifs provides two dummy functions 'sess_auth_lanman' and
'sess_auth_kerberos' for the case in which the respective
features are not defined. However, the caller is also under
an #ifdef, so we just get warnings about unused code:

fs/cifs/sess.c:1109:1: warning: 'sess_auth_kerberos' defined but not used [-Wunused-function]
 sess_auth_kerberos(struct sess_data *sess_data)

Removing the dead functions gets rid of the warnings without
any downsides that I can see.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 07fe97ac6b0c..ab0fda6e8e58 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -745,14 +745,6 @@ out:
 	sess_free_buffer(sess_data);
 }
 
-#else
-
-static void
-sess_auth_lanman(struct sess_data *sess_data)
-{
-	sess_data->result = -EOPNOTSUPP;
-	sess_data->func = NULL;
-}
 #endif
 
 static void
@@ -1103,15 +1095,6 @@ out:
 	ses->auth_key.response = NULL;
 }
 
-#else
-
-static void
-sess_auth_kerberos(struct sess_data *sess_data)
-{
-	cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
-	sess_data->result = -ENOSYS;
-	sess_data->func = NULL;
-}
 #endif /* ! CONFIG_CIFS_UPCALL */
 
 /*
