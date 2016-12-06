From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH 15/15] CIFS: Allow to switch on encryption with seal mount option
Date: Tue,  6 Dec 2016 14:02:38 -0800
Message-ID: <1481061758-52020-16-git-send-email-pshilov@microsoft.com>
References: <1481061758-52020-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481061758-52020-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This allows users to inforce encryption for SMB3 shares if a server
supports it.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/connect.c | 41 ++++++++++++++++++++++++++++-------------
 fs/cifs/smb2pdu.c | 33 +++++++++++++++------------------
 2 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c41f496..872fc8a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2622,12 +2622,18 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	return ERR_PTR(rc);
 }
 
-static int match_tcon(struct cifs_tcon *tcon, const char *unc)
+static int match_tcon(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 {
 	if (tcon->tidStatus == CifsExiting)
 		return 0;
-	if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
+	if (strncmp(tcon->treeName, volume_info->UNC, MAX_TREE_SIZE))
 		return 0;
+	if (tcon->seal != volume_info->seal)
+		return 0;
+#ifdef CONFIG_CIFS_SMB2
+	if (tcon->snapshot_time != volume_info->snapshot_time)
+		return 0;
+#endif /* CONFIG_CIFS_SMB2 */
 	return 1;
 }
 
@@ -2640,14 +2646,8 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &ses->tcon_list) {
 		tcon = list_entry(tmp, struct cifs_tcon, tcon_list);
-		if (!match_tcon(tcon, volume_info->UNC))
-			continue;
-
-#ifdef CONFIG_CIFS_SMB2
-		if (tcon->snapshot_time != volume_info->snapshot_time)
+		if (!match_tcon(tcon, volume_info))
 			continue;
-#endif /* CONFIG_CIFS_SMB2 */
-
 		++tcon->tc_count;
 		spin_unlock(&cifs_tcp_ses_lock);
 		return tcon;
@@ -2693,8 +2693,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		cifs_dbg(FYI, "Found match on UNC path\n");
 		/* existing tcon already has a reference */
 		cifs_put_smb_ses(ses);
-		if (tcon->seal != volume_info->seal)
-			cifs_dbg(VFS, "transport encryption setting conflicts with existing tid\n");
 		return tcon;
 	}
 
@@ -2750,7 +2748,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		tcon->Flags &= ~SMB_SHARE_IS_IN_DFS;
 		cifs_dbg(FYI, "DFS disabled (%d)\n", tcon->Flags);
 	}
-	tcon->seal = volume_info->seal;
 	tcon->use_persistent = false;
 	/* check if SMB2 or later, CIFS does not support persistent handles */
 	if (volume_info->persistent) {
@@ -2787,6 +2784,24 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		tcon->use_resilient = true;
 	}
 
+	if (volume_info->seal) {
+		if (ses->server->vals->protocol_id == 0) {
+			cifs_dbg(VFS,
+				 "SMB3 or later required for encryption\n");
+			rc = -EOPNOTSUPP;
+			goto out_fail;
+#ifdef CONFIG_CIFS_SMB2
+		} else if (tcon->ses->server->capabilities &
+					SMB2_GLOBAL_CAP_ENCRYPTION)
+			tcon->seal = true;
+		else {
+			cifs_dbg(VFS, "Encryption is not supported on share\n");
+			rc = -EOPNOTSUPP;
+			goto out_fail;
+#endif /* CONFIG_CIFS_SMB2 */
+		}
+	}
+
 	/*
 	 * We can have only one retry value for a connection to a share so for
 	 * resources mounted more than once to the same server share the last
@@ -2918,7 +2933,7 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	if (!match_server(tcp_srv, volume_info) ||
 	    !match_session(ses, volume_info) ||
-	    !match_tcon(tcon, volume_info->UNC) ||
+	    !match_tcon(tcon, volume_info) ||
 	    !match_prepath(sb, mnt_data)) {
 		rc = 0;
 		goto out;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0abeb5f..ad83b3d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -79,9 +79,14 @@ static const int smb2_req_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 
 static int encryption_required(const struct cifs_tcon *tcon)
 {
+	if (!tcon)
+		return 0;
 	if ((tcon->ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA) ||
 	    (tcon->share_flags & SHI1005_FLAGS_ENCRYPT_DATA))
 		return 1;
+	if (tcon->seal &&
+	    (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
+		return 1;
 	return 0;
 }
 
@@ -835,8 +840,6 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	ses->Suid = rsp->hdr.sync_hdr.SessionId;
 
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
-	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
-		cifs_dbg(VFS, "SMB3 encryption not supported yet\n");
 
 	rc = SMB2_sess_establish_session(sess_data);
 out_put_spnego_key:
@@ -933,8 +936,6 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	ses->Suid = rsp->hdr.sync_hdr.SessionId;
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
-	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
-		cifs_dbg(VFS, "SMB3 encryption not supported yet\n");
 
 out:
 	kfree(ntlmssp_blob);
@@ -993,8 +994,6 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	ses->Suid = rsp->hdr.sync_hdr.SessionId;
 	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
-	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
-		cifs_dbg(VFS, "SMB3 encryption not supported yet\n");
 
 	rc = SMB2_sess_establish_session(sess_data);
 out:
@@ -1145,12 +1144,6 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (tcon && tcon->bad_network_name)
 		return -ENOENT;
 
-	if ((tcon && tcon->seal) &&
-	    ((ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION) == 0)) {
-		cifs_dbg(VFS, "encryption requested but no server support");
-		return -EOPNOTSUPP;
-	}
-
 	unc_path = kmalloc(MAX_SHARENAME_LENGTH * 2, GFP_KERNEL);
 	if (unc_path == NULL)
 		return -ENOMEM;
@@ -1168,15 +1161,16 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		return rc;
 	}
 
-	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
-		flags |= CIFS_TRANSFORM_REQ;
-
 	if (tcon == NULL) {
+		if ((ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA))
+			flags |= CIFS_TRANSFORM_REQ;
+
 		/* since no tcon, smb2_init can not do this, so do here */
 		req->hdr.sync_hdr.SessionId = ses->Suid;
 		/* if (ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
 			req->hdr.Flags |= SMB2_FLAGS_SIGNED; */
-	}
+	} else if (encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field and 1 for pad */
@@ -1233,9 +1227,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
 	    ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
 		cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
+
+	if (tcon->seal &&
+	    !(tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
+		cifs_dbg(VFS, "Encryption is requested but not supported\n");
+
 	init_copy_chunk_defaults(tcon);
-	if (tcon->share_flags & SHI1005_FLAGS_ENCRYPT_DATA)
-		cifs_dbg(VFS, "Encrypted shares not supported");
 	if (tcon->ses->server->ops->validate_negotiate)
 		rc = tcon->ses->server->ops->validate_negotiate(xid, tcon);
 tcon_exit:
-- 
2.7.4
