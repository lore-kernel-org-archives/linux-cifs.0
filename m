From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/4] cifs: sanitize username handling
Date: Tue, 17 Jan 2012 16:42:25 -0500
Message-ID: <1326836547-7011-3-git-send-email-jlayton@redhat.com>
References: <1326836547-7011-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326836547-7011-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, it's not very clear whether you're allowed to have a NULL
vol->username or ses->user_name. Some places check for it and some don't.

Make it clear that a NULL pointer is OK in these fields, and ensure that
all the callers check for that.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_spnego.c |   10 +++++++---
 fs/cifs/cifsencrypt.c |   11 ++++++++---
 fs/cifs/connect.c     |   19 ++++++++++++-------
 3 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 2272fd5..e622863 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -113,9 +113,11 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
 		   MAX_MECH_STR_LEN +
 		   UID_KEY_LEN + (sizeof(uid_t) * 2) +
 		   CREDUID_KEY_LEN + (sizeof(uid_t) * 2) +
-		   USER_KEY_LEN + strlen(sesInfo->user_name) +
 		   PID_KEY_LEN + (sizeof(pid_t) * 2) + 1;
 
+	if (sesInfo->user_name)
+		desc_len += USER_KEY_LEN + strlen(sesInfo->user_name);
+
 	spnego_key = ERR_PTR(-ENOMEM);
 	description = kzalloc(desc_len, GFP_KERNEL);
 	if (description == NULL)
@@ -152,8 +154,10 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
 	dp = description + strlen(description);
 	sprintf(dp, ";creduid=0x%x", sesInfo->cred_uid);
 
-	dp = description + strlen(description);
-	sprintf(dp, ";user=%s", sesInfo->user_name);
+	if (sesInfo->user_name) {
+		dp = description + strlen(description);
+		sprintf(dp, ";user=%s", sesInfo->user_name);
+	}
 
 	dp = description + strlen(description);
 	sprintf(dp, ";pid=0x%x", current->pid);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 5d9b9ac..bce99e6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -420,15 +420,20 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 	}
 
 	/* convert ses->user_name to unicode and uppercase */
-	len = strlen(ses->user_name);
+	len = ses->user_name ? strlen(ses->user_name) : 0;
 	user = kmalloc(2 + (len * 2), GFP_KERNEL);
 	if (user == NULL) {
 		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
 		rc = -ENOMEM;
 		return rc;
 	}
-	len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
-	UniStrupr(user);
+
+	if (len) {
+		len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
+		UniStrupr(user);
+	} else {
+		memset(user, '\0', 2);
+	}
 
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
 				(char *)user, 2 * len);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a66dcb5..b8f5024 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1997,10 +1997,16 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 			return 0;
 		break;
 	default:
+		/* NULL username means anonymous session */
+		if (ses->user_name == NULL) {
+			if (!vol->nullauth)
+				return 0;
+			break;
+		}
+
 		/* anything else takes username/password */
-		if (ses->user_name == NULL)
-			return 0;
-		if (strncmp(ses->user_name, vol->username,
+		if (strncmp(ses->user_name,
+			    vol->username ? vol->username: "",
 			    MAX_USERNAME_SIZE))
 			return 0;
 		if (strlen(vol->username) != 0 &&
@@ -3167,10 +3173,9 @@ cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
 		return -EINVAL;
 
 	if (volume_info->nullauth) {
-		cFYI(1, "null user");
-		volume_info->username = kzalloc(1, GFP_KERNEL);
-		if (volume_info->username == NULL)
-			return -ENOMEM;
+		cFYI(1, "Anonymous login");
+		kfree(volume_info->username);
+		volume_info->username = NULL;
 	} else if (volume_info->username) {
 		/* BB fixme parse for domain name here */
 		cFYI(1, "Username: %s", volume_info->username);
-- 
1.7.7.5
