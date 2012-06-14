From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs.upcall: more debug logging for krb5 upcalls
Date: Thu, 14 Jun 2012 11:06:13 -0400
Message-ID: <1339686373-15600-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While helping to track down a configuration problem, I found this
little bit of extra debug logging to be helpful. Might as well
make it part of the stock binary.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 4f9fe21..eef461d 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -994,10 +994,12 @@ retry_new_hostname:
 		break;
 	}
 
-	if (rc)
+	if (rc) {
+		syslog(LOG_DEBUG, "Unable to obtain service ticket");
 		goto out;
+	}
 
-	/* pack SecurityBLob and SessionKey into downcall packet */
+	/* pack SecurityBlob and SessionKey into downcall packet */
 	datalen =
 	    sizeof(struct cifs_spnego_msg) + secblob.length + sess_key.length;
 	keydata = (struct cifs_spnego_msg *)calloc(sizeof(char), datalen);
@@ -1029,8 +1031,10 @@ out:
 	 * make sure the kernel doesn't hang it off of a searchable keyring
 	 * and interfere with the next attempt to instantiate the key.
 	 */
-	if (rc != 0 && key == 0)
+	if (rc != 0 && key == 0) {
+		syslog(LOG_DEBUG, "Negating key");
 		keyctl_negate(key, 1, KEY_REQKEY_DEFL_DEFAULT);
+	}
 	data_blob_free(&secblob);
 	data_blob_free(&sess_key);
 	SAFE_FREE(ccname);
@@ -1038,5 +1042,6 @@ out:
 	SAFE_FREE(arg.ip);
 	SAFE_FREE(arg.username);
 	SAFE_FREE(keydata);
+	syslog(LOG_DEBUG, "Exit status %ld", rc);
 	return rc;
 }
-- 
1.7.7.6
