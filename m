From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [v2 1/4] CIFS: Simplify connection structure search calls
Date: Thu,  5 May 2011 13:55:11 +0400
Message-ID: <1304589314-1147-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use separate functions for comparison between existing structure
and what we are requesting for to make server, session and tcon
search code easier to use on next superblock match call.

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |   90 +++++++++++++++++++++++++++++++++--------------------
 1 files changed, 56 insertions(+), 34 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 389dd9f..c19a110 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1650,6 +1650,25 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 	return true;
 }
 
+static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
+			 struct smb_vol *vol)
+{
+	if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
+		return 0;
+
+	if (!match_address(server, addr,
+			   (struct sockaddr *)&vol->srcaddr))
+		return 0;
+
+	if (!match_port(server, addr))
+		return 0;
+
+	if (!match_security(server, vol))
+		return 0;
+
+	return 1;
+}
+
 static struct TCP_Server_Info *
 cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 {
@@ -1657,17 +1676,7 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
-			continue;
-
-		if (!match_address(server, addr,
-				   (struct sockaddr *)&vol->srcaddr))
-			continue;
-
-		if (!match_port(server, addr))
-			continue;
-
-		if (!match_security(server, vol))
+		if (!match_server(server, addr, vol))
 			continue;
 
 		++server->srv_count;
@@ -1861,6 +1870,30 @@ out_err:
 	return ERR_PTR(rc);
 }
 
+static int match_session(struct cifsSesInfo *ses, struct smb_vol *vol)
+{
+	switch (ses->server->secType) {
+	case Kerberos:
+		if (vol->cred_uid != ses->cred_uid)
+			return 0;
+		break;
+	default:
+		/* anything else takes username/password */
+		if (ses->user_name == NULL)
+			return 0;
+		if (strncmp(ses->user_name, vol->username,
+			    MAX_USERNAME_SIZE))
+			return 0;
+		if (strlen(vol->username) != 0 &&
+		    ses->password != NULL &&
+		    strncmp(ses->password,
+			    vol->password ? vol->password : "",
+			    MAX_PASSWORD_SIZE))
+			return 0;
+	}
+	return 1;
+}
+
 static struct cifsSesInfo *
 cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
@@ -1868,25 +1901,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		switch (server->secType) {
-		case Kerberos:
-			if (vol->cred_uid != ses->cred_uid)
-				continue;
-			break;
-		default:
-			/* anything else takes username/password */
-			if (ses->user_name == NULL)
-				continue;
-			if (strncmp(ses->user_name, vol->username,
-				    MAX_USERNAME_SIZE))
-				continue;
-			if (strlen(vol->username) != 0 &&
-			    ses->password != NULL &&
-			    strncmp(ses->password,
-				    vol->password ? vol->password : "",
-				    MAX_PASSWORD_SIZE))
-				continue;
-		}
+		if (!match_session(ses, vol))
+			continue;
 		++ses->ses_count;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return ses;
@@ -2029,6 +2045,15 @@ get_ses_fail:
 	return ERR_PTR(rc);
 }
 
+static int match_tcon(struct cifsTconInfo *tcon, const char *unc)
+{
+	if (tcon->tidStatus == CifsExiting)
+		return 0;
+	if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+		return 0;
+	return 1;
+}
+
 static struct cifsTconInfo *
 cifs_find_tcon(struct cifsSesInfo *ses, const char *unc)
 {
@@ -2038,11 +2063,8 @@ cifs_find_tcon(struct cifsSesInfo *ses, const char *unc)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifsTconInfo, tcon_list);
-		if (tcon->tidStatus == CifsExiting)
+		if (!match_tcon(tcon, unc))
 			continue;
-		if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
-			continue;
-
 		++tcon->tc_count;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return tcon;
-- 
1.7.1
