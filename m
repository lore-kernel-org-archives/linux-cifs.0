Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A875C3115A6;
	Thu, 27 Nov 2025 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255877; cv=none; b=klJnxXcjRHI1CFUb2MHWmNu3/msP37uiX1SaQCs+JZ9/5Zb/fdYv9DoWk2Qj+uD3aIiu1r6YPBrorZkhzAlAw6Oy9LaghXtH44Mz1S4Gpj26aKNVx9QkQu68J5uVaPneitlWno34DqcICOXFdHFIa9KGILiP6OFiq0qwi6/0/1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255877; c=relaxed/simple;
	bh=EEdtEUfRJchKSbrlGprN9bM16DeXtFkQowltcg6/ffU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI+oQQ/PWxLrBu+PqFzGKOhnx97rnixAw/vK7bl8Iw9jA4GPKnNknp9LA646GsJJOOyMK63KqodGlN8+B3kdz4Q+h2vrRfWgm0hdsKB3oMTIFmkSrahqBiBinZPcmpv7S7Jkd4VrzVQJDKHvNTTraiFdHEjRYmrELkXM1wDnM7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwI0maNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwI0maNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B5DC4CEF8;
	Thu, 27 Nov 2025 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255877;
	bh=EEdtEUfRJchKSbrlGprN9bM16DeXtFkQowltcg6/ffU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GwI0maNHVhwiQVImCj347YUnhTgTr9mn+sAywq/jBf7FYGp3gcGKN3uLYsHTWXmM8
	 wqyXuBgX1ybAnqrtg/HS0+nfxW7nNfXW5jwYaWQJxMLWP1n5mToazgHbXJrIZM5cX3
	 t2/SPwcAK39Y0v9alC4OZ07XOUvpGOrf8l7CNTdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 146/175] smb: client: handle lack of IPC in dfs_cache_refresh()
Date: Thu, 27 Nov 2025 15:46:39 +0100
Message-ID: <20251127144048.287424369@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit fac56c4651ae95f3f2b468c2cf1884cf0e6d18c1 ]

In very rare cases, DFS mounts could end up with SMB sessions without
any IPC connections.  These mounts are only possible when having
unexpired cached DFS referrals, hence not requiring any IPC
connections during the mount process.

Try to establish those missing IPC connections when refreshing DFS
referrals.  If the server is still rejecting it, then simply ignore
and leave expired cached DFS referral for any potential DFS failovers.

Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/connect.c   | 38 ++++++++++++---------------
 fs/smb/client/dfs_cache.c | 55 +++++++++++++++++++++++++++++++++------
 3 files changed, 66 insertions(+), 29 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index e8fba98690ce3..8c00ff52a12a6 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -615,6 +615,8 @@ extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
 extern struct TCP_Server_Info *
 cifs_find_tcp_session(struct smb3_fs_context *ctx);
 
+struct cifs_tcon *cifs_setup_ipc(struct cifs_ses *ses, bool seal);
+
 void __cifs_put_smb_ses(struct cifs_ses *ses);
 
 extern struct cifs_ses *
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dd12f3eb61dcb..d65ab7e4b1c26 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2015,39 +2015,31 @@ static int match_session(struct cifs_ses *ses,
 /**
  * cifs_setup_ipc - helper to setup the IPC tcon for the session
  * @ses: smb session to issue the request on
- * @ctx: the superblock configuration context to use for building the
- *       new tree connection for the IPC (interprocess communication RPC)
+ * @seal: if encryption is requested
  *
  * A new IPC connection is made and stored in the session
  * tcon_ipc. The IPC tcon has the same lifetime as the session.
  */
-static int
-cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
+struct cifs_tcon *cifs_setup_ipc(struct cifs_ses *ses, bool seal)
 {
 	int rc = 0, xid;
 	struct cifs_tcon *tcon;
 	char unc[SERVER_NAME_LENGTH + sizeof("//x/IPC$")] = {0};
-	bool seal = false;
 	struct TCP_Server_Info *server = ses->server;
 
 	/*
 	 * If the mount request that resulted in the creation of the
 	 * session requires encryption, force IPC to be encrypted too.
 	 */
-	if (ctx->seal) {
-		if (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION)
-			seal = true;
-		else {
-			cifs_server_dbg(VFS,
-				 "IPC: server doesn't support encryption\n");
-			return -EOPNOTSUPP;
-		}
+	if (seal && !(server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION)) {
+		cifs_server_dbg(VFS, "IPC: server doesn't support encryption\n");
+		return ERR_PTR(-EOPNOTSUPP);
 	}
 
 	/* no need to setup directory caching on IPC share, so pass in false */
 	tcon = tcon_info_alloc(false, netfs_trace_tcon_ref_new_ipc);
 	if (tcon == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock(&server->srv_lock);
 	scnprintf(unc, sizeof(unc), "\\\\%s\\IPC$", server->hostname);
@@ -2057,13 +2049,13 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	tcon->ses = ses;
 	tcon->ipc = true;
 	tcon->seal = seal;
-	rc = server->ops->tree_connect(xid, ses, unc, tcon, ctx->local_nls);
+	rc = server->ops->tree_connect(xid, ses, unc, tcon, ses->local_nls);
 	free_xid(xid);
 
 	if (rc) {
-		cifs_server_dbg(VFS, "failed to connect to IPC (rc=%d)\n", rc);
+		cifs_server_dbg(VFS | ONCE, "failed to connect to IPC (rc=%d)\n", rc);
 		tconInfoFree(tcon, netfs_trace_tcon_ref_free_ipc_fail);
-		goto out;
+		return ERR_PTR(rc);
 	}
 
 	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
@@ -2071,9 +2063,7 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	spin_lock(&tcon->tc_lock);
 	tcon->status = TID_GOOD;
 	spin_unlock(&tcon->tc_lock);
-	ses->tcon_ipc = tcon;
-out:
-	return rc;
+	return tcon;
 }
 
 static struct cifs_ses *
@@ -2347,6 +2337,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
+	struct cifs_tcon *ipc;
 	struct cifs_ses *ses;
 	unsigned int xid;
 	int retries = 0;
@@ -2525,7 +2516,12 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	cifs_setup_ipc(ses, ctx);
+	ipc = cifs_setup_ipc(ses, ctx->seal);
+	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&ses->ses_lock);
+	ses->tcon_ipc = !IS_ERR(ipc) ? ipc : NULL;
+	spin_unlock(&ses->ses_lock);
+	spin_unlock(&cifs_tcp_ses_lock);
 
 	free_xid(xid);
 
diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
index 4dada26d56b5f..f2ad0ccd08a77 100644
--- a/fs/smb/client/dfs_cache.c
+++ b/fs/smb/client/dfs_cache.c
@@ -1120,24 +1120,63 @@ static bool target_share_equal(struct cifs_tcon *tcon, const char *s1)
 	return match;
 }
 
-static bool is_ses_good(struct cifs_ses *ses)
+static bool is_ses_good(struct cifs_tcon *tcon, struct cifs_ses *ses)
 {
 	struct TCP_Server_Info *server = ses->server;
-	struct cifs_tcon *tcon = ses->tcon_ipc;
+	struct cifs_tcon *ipc = NULL;
 	bool ret;
 
+	spin_lock(&cifs_tcp_ses_lock);
 	spin_lock(&ses->ses_lock);
 	spin_lock(&ses->chan_lock);
+
 	ret = !cifs_chan_needs_reconnect(ses, server) &&
-		ses->ses_status == SES_GOOD &&
-		!tcon->need_reconnect;
+		ses->ses_status == SES_GOOD;
+
 	spin_unlock(&ses->chan_lock);
+
+	if (!ret)
+		goto out;
+
+	if (likely(ses->tcon_ipc)) {
+		if (ses->tcon_ipc->need_reconnect) {
+			ret = false;
+			goto out;
+		}
+	} else {
+		spin_unlock(&ses->ses_lock);
+		spin_unlock(&cifs_tcp_ses_lock);
+
+		ipc = cifs_setup_ipc(ses, tcon->seal);
+
+		spin_lock(&cifs_tcp_ses_lock);
+		spin_lock(&ses->ses_lock);
+		if (!IS_ERR(ipc)) {
+			if (!ses->tcon_ipc) {
+				ses->tcon_ipc = ipc;
+				ipc = NULL;
+			}
+		} else {
+			ret = false;
+			ipc = NULL;
+		}
+	}
+
+out:
 	spin_unlock(&ses->ses_lock);
+	spin_unlock(&cifs_tcp_ses_lock);
+	if (ipc && server->ops->tree_disconnect) {
+		unsigned int xid = get_xid();
+
+		(void)server->ops->tree_disconnect(xid, ipc);
+		_free_xid(xid);
+	}
+	tconInfoFree(ipc, netfs_trace_tcon_ref_free_ipc);
 	return ret;
 }
 
 /* Refresh dfs referral of @ses */
-static void refresh_ses_referral(struct cifs_ses *ses)
+static void refresh_ses_referral(struct cifs_tcon *tcon, struct cifs_ses *ses)
 {
 	struct cache_entry *ce;
 	unsigned int xid;
@@ -1153,7 +1192,7 @@ static void refresh_ses_referral(struct cifs_ses *ses)
 	}
 
 	ses = CIFS_DFS_ROOT_SES(ses);
-	if (!is_ses_good(ses)) {
+	if (!is_ses_good(tcon, ses)) {
 		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n",
 			 __func__);
 		goto out;
@@ -1241,7 +1280,7 @@ static void refresh_tcon_referral(struct cifs_tcon *tcon, bool force_refresh)
 	up_read(&htable_rw_lock);
 
 	ses = CIFS_DFS_ROOT_SES(ses);
-	if (!is_ses_good(ses)) {
+	if (!is_ses_good(tcon, ses)) {
 		cifs_dbg(FYI, "%s: skip cache refresh due to disconnected ipc\n",
 			 __func__);
 		goto out;
@@ -1309,7 +1348,7 @@ void dfs_cache_refresh(struct work_struct *work)
 	tcon = container_of(work, struct cifs_tcon, dfs_cache_work.work);
 
 	list_for_each_entry(ses, &tcon->dfs_ses_list, dlist)
-		refresh_ses_referral(ses);
+		refresh_ses_referral(tcon, ses);
 	refresh_tcon_referral(tcon, false);
 
 	queue_delayed_work(dfscache_wq, &tcon->dfs_cache_work,
-- 
2.51.0



