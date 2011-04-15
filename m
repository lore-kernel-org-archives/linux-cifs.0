From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/4] CIFS: Simplify connection structure search calls
Date: Fri, 15 Apr 2011 10:58:45 +0400
Message-ID: <1302850725-13867-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use separate functions for comparison between existing structure
and what we are requesting for to make server, session and tcon
search code easier to use on next superblock match call.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/connect.c |  104 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 63 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dd9d3e9..990c3e0 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1640,32 +1640,41 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 	return true;
 }
 
-static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
+static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
+			 struct smb_vol *vol)
 {
-	struct TCP_Server_Info *server;
-
-	spin_lock(&cifs_tcp_ses_lock);
-	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
-			continue;
+	if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns))
+		return 0;
 
-		if (!match_address(server, addr,
-				   (struct sockaddr *)&vol->srcaddr))
-			continue;
+	if (!match_address(server, addr,
+			   (struct sockaddr *)&vol->srcaddr))
+		return 0;
 
 #ifdef CONFIG_CIFS_SMB2
-		if ((server->is_smb2 == true) && (vol->use_smb2 == false))
-			continue;
+	if ((server->is_smb2 == true) && (vol->use_smb2 == false))
+		return 0;
 
-		if ((server->is_smb2 == false) && (vol->use_smb2 == true))
-			continue;
+	if ((server->is_smb2 == false) && (vol->use_smb2 == true))
+		return 0;
 #endif /* CONFIG_CIFS_SMB2 */
 
-		if (!match_port(server, addr))
-			continue;
+	if (!match_port(server, addr))
+		return 0;
+
+	if (!match_security(server, vol))
+		return 0;
+
+	return 1;
+}
+
+static struct TCP_Server_Info *
+cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
+{
+	struct TCP_Server_Info *server;
 
-		if (!match_security(server, vol))
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		if (!match_server(server, addr, vol))
 			continue;
 
 		++server->srv_count;
@@ -1865,6 +1874,30 @@ out_err:
 	return ERR_PTR(rc);
 }
 
+static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
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
 static struct cifs_ses *
 cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
@@ -1872,25 +1905,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol *vol)
 
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
@@ -2033,6 +2049,15 @@ get_ses_fail:
 	return ERR_PTR(rc);
 }
 
+static int match_tcon(struct cifs_tcon *tcon, const char *unc)
+{
+	if (tcon->tidStatus == CifsExiting)
+		return 0;
+	if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+		return 0;
+	return 1;
+}
+
 static struct cifs_tcon *
 cifs_find_tcon(struct cifs_ses *ses, const char *unc)
 {
@@ -2042,11 +2067,8 @@ cifs_find_tcon(struct cifs_ses *ses, const char *unc)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
-		if (tcon->tidStatus == CifsExiting)
-			continue;
-		if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+		if (!match_tcon(tcon, unc))
 			continue;
-
 		++tcon->tc_count;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return tcon;
-- 
1.7.1
