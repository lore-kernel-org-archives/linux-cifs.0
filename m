From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/8] CIFS: Delete 11 error messages for a failed memory
 allocation
Date: Sun, 20 Aug 2017 18:33:55 +0200
Message-ID: <3b4ecd79-ac00-9aa6-ae3e-2f153525214a@users.sourceforge.net>
References: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <sfrench@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <826310e5-e01c-38af-90df-c5630f761a4d@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Aug 2017 14:35:36 +0200

Omit extra messages for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/cifs/connect.c       | 17 ++++-------------
 fs/cifs/sess.c          |  7 ++-----
 fs/cifs/smb2ops.c       |  1 -
 fs/cifs/smb2pdu.c       |  6 ------
 fs/cifs/smb2transport.c |  1 -
 5 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 59647eb72c5f..b67a3c132a8f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1737,10 +1737,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			/* Now build new password string */
 			temp_len = strlen(value);
 			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
-			if (vol->password == NULL) {
-				pr_warn("CIFS: no memory for password\n");
+			if (!vol->password)
 				goto cifs_parse_mount_err;
-			}
 
 			for (i = 0, j = 0; i < temp_len; i++, j++) {
 				vol->password[j] = value[i];
@@ -1780,10 +1778,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			kfree(vol->domainname);
 			vol->domainname = kstrdup(string, GFP_KERNEL);
-			if (!vol->domainname) {
-				pr_warn("CIFS: no memory for domainname\n");
+			if (!vol->domainname)
 				goto cifs_parse_mount_err;
-			}
+
 			cifs_dbg(FYI, "Domain name set\n");
 			break;
 		case Opt_srcaddr:
@@ -1813,10 +1810,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				kfree(vol->iocharset);
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
-				if (!vol->iocharset) {
-					pr_warn("CIFS: no memory for charset\n");
+				if (!vol->iocharset)
 					goto cifs_parse_mount_err;
-				}
 			}
 			/* if iocharset not set then load_nls_default
 			 * is used by caller
@@ -2494,8 +2489,6 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 
 	vol->username = kstrndup(payload, len, GFP_KERNEL);
 	if (!vol->username) {
-		cifs_dbg(FYI, "Unable to allocate %zd bytes for username\n",
-			 len);
 		rc = -ENOMEM;
 		goto out_key_put;
 	}
@@ -2513,8 +2506,6 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 	++delim;
 	vol->password = kstrndup(delim, len, GFP_KERNEL);
 	if (!vol->password) {
-		cifs_dbg(FYI, "Unable to allocate %zd bytes for password\n",
-			 len);
 		rc = -ENOMEM;
 		kfree(vol->username);
 		vol->username = NULL;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 8b0502cd39af..2fb36bbaf5b0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -317,10 +317,9 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	if (tilen) {
 		ses->auth_key.response = kmemdup(bcc_ptr + tioffset, tilen,
 						 GFP_KERNEL);
-		if (!ses->auth_key.response) {
-			cifs_dbg(VFS, "Challenge target info alloc failure");
+		if (!ses->auth_key.response)
 			return -ENOMEM;
-		}
+
 		ses->auth_key.len = tilen;
 	}
 
@@ -1048,8 +1047,6 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory",
-				msg->sesskey_len);
 		rc = -ENOMEM;
 		goto out_put_spnego_key;
 	}
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index cfacf2c97e94..783b5d263704 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1988,7 +1988,6 @@ crypt_message(struct TCP_Server_Info *server, struct smb_rqst *rqst, int enc)
 	iv_len = crypto_aead_ivsize(tfm);
 	iv = kzalloc(iv_len, GFP_KERNEL);
 	if (!iv) {
-		cifs_dbg(VFS, "%s: Failed to alloc IV", __func__);
 		rc = -ENOMEM;
 		goto free_sg;
 	}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5fb2fc2d0080..668732e6f80f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -851,9 +851,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
 					 GFP_KERNEL);
 	if (!ses->auth_key.response) {
-		cifs_dbg(VFS,
-			"Kerberos can't allocate (%u bytes) memory",
-			msg->sesskey_len);
 		rc = -ENOMEM;
 		goto out_put_spnego_key;
 	}
@@ -2122,9 +2119,6 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 		if (!*data) {
 			*data = kmalloc(*dlen, GFP_KERNEL);
 			if (!*data) {
-				cifs_dbg(VFS,
-					"Error %d allocating memory for acl\n",
-					rc);
 				*dlen = 0;
 				goto qinf_exit;
 			}
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 67367cf1f8cd..abfcc759e75d 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -100,7 +100,6 @@ smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 			crypto_shash_descsize(server->secmech.cmacaes);
 	server->secmech.sdesccmacaes = kmalloc(size, GFP_KERNEL);
 	if (!server->secmech.sdesccmacaes) {
-		cifs_dbg(VFS, "%s: Can't alloc cmacaes\n", __func__);
 		kfree(server->secmech.sdeschmacsha256);
 		server->secmech.sdeschmacsha256 = NULL;
 		crypto_free_shash(server->secmech.hmacsha256);
-- 
2.14.0
