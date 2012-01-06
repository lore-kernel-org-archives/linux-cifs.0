From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts
Date: Fri,  6 Jan 2012 08:11:23 -0500
Message-ID: <1325855483-8846-4-git-send-email-jlayton@redhat.com>
References: <1325855483-8846-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1325855483-8846-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fix up multiuser mounts to set the secType and set the username and
password from the key payload in the vol info for non-krb5 auth types.

Look for a key of type "secret" with a description of
"cifs:a:<server address>" or "cifs:d:<domainname>". If that's found,
then scrape the username and password out of the key payload and use
that to create a new user session.

Finally, don't have the code enforce krb5 auth on multiuser mounts,
but do require a kernel with keys support.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 166 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5e96e60..48f2d15 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -38,6 +38,7 @@
 #include <asm/processor.h>
 #include <linux/inet.h>
 #include <linux/module.h>
+#include <keys/user-type.h>
 #include <net/ipv6.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
@@ -1594,11 +1595,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		}
 	}
 
-	if (vol->multiuser && !(vol->secFlg & CIFSSEC_MAY_KRB5)) {
-		cERROR(1, "Multiuser mounts currently require krb5 "
-			  "authentication!");
+#ifndef CONFIG_KEYS
+	/* Muliuser mounts require CONFIG_KEYS support */
+	if (vol->multiuser) {
+		cERROR(1, "Multiuser mounts require kernels with "
+			  "CONFIG_KEYS enabled.");
 		goto cifs_parse_mount_err;
 	}
+#endif
 
 	if (vol->UNCip == NULL)
 		vol->UNCip = &vol->UNC[2];
@@ -2061,6 +2065,133 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 	cifs_put_tcp_session(server);
 }
 
+#ifdef CONFIG_KEYS
+
+/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
+#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
+
+/* Populate username and pw fields from keyring if possible */
+static int
+cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
+{
+	int rc = 0;
+	char *desc, *delim, *payload;
+	ssize_t len;
+	struct key *key;
+	struct TCP_Server_Info *server = ses->server;
+	struct sockaddr_in *sa;
+	struct sockaddr_in6 *sa6;
+	struct user_key_payload *upayload;
+
+	desc = kmalloc(CIFSCREDS_DESC_SIZE, GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	/* try to find an address key first */
+	switch (server->dstaddr.ss_family) {
+	case AF_INET:
+		sa = (struct sockaddr_in *)&server->dstaddr;
+		sprintf(desc, "cifs:a:%pI4", &sa->sin_addr.s_addr);
+		break;
+	case AF_INET6:
+		sa6 = (struct sockaddr_in6 *)&server->dstaddr;
+		sprintf(desc, "cifs:a:%pI6c", &sa6->sin6_addr.s6_addr);
+		break;
+	default:
+		cFYI(1, "Bad ss_family (%hu)", server->dstaddr.ss_family);
+		rc = -EINVAL;
+		goto out_err;
+	}
+
+	cFYI(1, "%s: desc=%s", __func__, desc);
+	key = request_key(&key_type_secret, desc, "");
+	if (IS_ERR(key)) {
+		if (!ses->domainName) {
+			cFYI(1, "domainName is NULL");
+			rc = PTR_ERR(key);
+			goto out_err;
+		}
+
+		/* didn't work, try to find a domain key */
+		sprintf(desc, "cifs:d:%s", ses->domainName);
+		cFYI(1, "%s: desc=%s", __func__, desc);
+		key = request_key(&key_type_secret, desc, "");
+		if (IS_ERR(key)) {
+			rc = PTR_ERR(key);
+			goto out_err;
+		}
+	}
+
+	down_read(&key->sem);
+	upayload = key->payload.data;
+	if (IS_ERR_OR_NULL(upayload)) {
+		rc = PTR_ERR(key);
+		goto out_key_put;
+	}
+
+	/* find first : in payload */
+	payload = (char *)upayload->data;
+	delim = strnchr(payload, upayload->datalen, ':');
+	cFYI(1, "payload=%s", payload);
+	if (!delim) {
+		cFYI(1, "Unable to find ':' in payload (datalen=%d)",
+				upayload->datalen);
+		rc = -EINVAL;
+		goto out_key_put;
+	}
+
+	len = delim - payload;
+	if (len > MAX_USERNAME_SIZE || len <= 0) {
+		cFYI(1, "Bad value from username search (len=%ld)", len);
+		rc = -EINVAL;
+		goto out_key_put;
+	}
+
+	vol->username = kstrndup(payload, len, GFP_KERNEL);
+	if (!vol->username) {
+		cFYI(1, "Unable to allocate %ld bytes for username", len);
+		rc = -ENOMEM;
+		goto out_key_put;
+	}
+	cFYI(1, "username=%s", vol->username);
+
+	len = key->datalen - (len + 1);
+	if (len > MAX_PASSWORD_SIZE || len <= 0) {
+		cFYI(1, "Bad len for password search (len=%ld)", len);
+		rc = -EINVAL;
+		kfree(vol->username);
+		vol->username = NULL;
+		goto out_key_put;
+	}
+
+	++delim;
+	vol->password = kstrndup(delim, len, GFP_KERNEL);
+	if (!vol->password) {
+		cFYI(1, "Unable to allocate %ld bytes for password", len);
+		rc = -ENOMEM;
+		kfree(vol->username);
+		vol->username = NULL;
+		goto out_key_put;
+	}
+	cFYI(1, "password=%s", vol->password);
+
+out_key_put:
+	up_read(&key->sem);
+	key_put(key);
+out_err:
+	kfree(desc);
+	cFYI(1, "%s: returning %d", __func__, rc);
+	return rc;
+}
+#else /* ! CONFIG_KEYS */
+static inline int
+cifs_set_cifscreds(struct smb_vol *vol __attribute__((unused)),
+		   struct cifs_ses *ses __attribute__((unused)))
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_KEYS */
+
 static bool warned_on_ntlm;  /* globals init to false automatically */
 
 static struct cifs_ses *
@@ -3678,16 +3809,38 @@ int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
+static int
+cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
+{
+	switch(ses->server->secType) {
+	case Kerberos:
+		vol->secFlg = CIFSSEC_MUST_KRB5;
+		return 0;
+	case NTLMv2:
+		vol->secFlg = CIFSSEC_MUST_NTLMV2;
+		break;
+	case NTLM:
+		vol->secFlg = CIFSSEC_MUST_NTLM;
+		break;
+	case RawNTLMSSP:
+		vol->secFlg = CIFSSEC_MAY_NTLMSSP;
+		break;
+	case LANMAN:
+		vol->secFlg = CIFSSEC_MAY_LANMAN;
+		break;
+	}
+
+	return cifs_set_cifscreds(vol, ses);
+}
+
 static struct cifs_tcon *
 cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 {
+	int rc;
 	struct cifs_tcon *master_tcon = cifs_sb_master_tcon(cifs_sb);
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon = NULL;
 	struct smb_vol *vol_info;
-	char username[28]; /* big enough for "krb50x" + hex of ULONG_MAX 6+16 */
-			   /* We used to have this as MAX_USERNAME which is   */
-			   /* way too big now (256 instead of 32) */
 
 	vol_info = kzalloc(sizeof(*vol_info), GFP_KERNEL);
 	if (vol_info == NULL) {
@@ -3695,8 +3848,6 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 		goto out;
 	}
 
-	snprintf(username, sizeof(username), "krb50x%x", fsuid);
-	vol_info->username = username;
 	vol_info->local_nls = cifs_sb->local_nls;
 	vol_info->linux_uid = fsuid;
 	vol_info->cred_uid = fsuid;
@@ -3706,8 +3857,11 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 	vol_info->local_lease = master_tcon->local_lease;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
 
-	/* FIXME: allow for other secFlg settings */
-	vol_info->secFlg = CIFSSEC_MUST_KRB5;
+	rc = cifs_set_vol_auth(vol_info, master_tcon->ses);
+	if (rc) {
+		tcon = ERR_PTR(rc);
+		goto out;
+	}
 
 	/* get a reference for the same TCP session */
 	spin_lock(&cifs_tcp_ses_lock);
@@ -3730,6 +3884,8 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 	if (ses->capabilities & CAP_UNIX)
 		reset_cifs_unix_caps(0, tcon, NULL, vol_info);
 out:
+	kfree(vol_info->username);
+	kfree(vol_info->password);
 	kfree(vol_info);
 
 	return tcon;
-- 
1.7.7.4
