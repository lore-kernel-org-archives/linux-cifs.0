Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793728988;
	b=IO/+TUqJj9aLPy6ZHPCIODw9moURI9mkIV1eogi0vNjOb0uCm9uZ0wm0LVLtEYF/Ze1K
	 5EzYlB1AaCWBFZ/+Q7XF3XzcCX77G7CHFJwr+wjz7ePr9FSMrEYpB1UdwvsrAhVoG9gzZ
	 6OFC2fgSZdGxrP1bHS9T7V3SlHbI8WG5jAxzKGsVGwnU18kUG54c/+rFQPUCcHhh7U66U
	 5Rpkt8sePt3HCcmcGD7tPc2QpZ9isj/H6exvk1+zR0+sxcfMqt59fGHBdRGoYAdYvvFhs
	 kN+EW6+bMYYf+uGKbUYqdUe5xyvsghZTnhyJ739JWDZhLXErWeztjLfOPkC4tIxoLmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793728988;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=VX0oe01hxECr23zDyAIZwcmKZd0iARZIKmz1WjAoAkY=;
	b=uiDSX+rYygPB2KR1URJRPMkgJjF7i1S4WpG+tVEkYk1F0lq5ct+c9CWUGS7XarmIMXa4
	 B2ta3EB0qGmaTd5/+DT2LnTsc3quWqn/z6/M/pAp3FGsl3RC1I8pB72bKu2IeqcVZVbY7
	 oWQf84LYQTF1nlGLtUKH+2O5pKqcT8sNyPPjviXRTnvDG3QYwyeCe+Cq/L+jV+5MOHfMZ
	 MXeiQ8Lz9CExmBzvk0GmVBzZt6n2Mg2Iq9wET8UZE+vgb7NfPFC63pX6QlFiyE2ClYBMy
	 8KUJKBTlLjbGgu5JIdKwKVehaCad5B0hHPPyX2qI5b11eiw+gVjmeeS+PxU/VuzfmvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=LlIf9yQ2;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502DD606D82A;
	Tue,  3 Nov 2026 18:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 502DD606D82A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=LlIf9yQ2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=VX0oe01hxECr23zDyAIZwcmKZd0iARZIKmz1WjAoAkY=; b=LlIf9yQ2kwq37i9MvpSlpJA2id
	dnJMNRAWu3VgjmG78GWuw7oUi0kWcMd5WGOQy/aHlsoJPjYAnmpEEYwi/ye1UWMqlxQCTVDswy8Vr
	Pb7Fw2NFhYlNcQk7rghjrjIcPHhxUx1w6ADe7/IJi3atn2Pb9gwG3u7TWHXo7x7Cee7jaj8bGh7kJ
	vZJvUksUpM7rH96gZEQym0AyMxFXovUsXsKRXAAlpHp+pd2RvWdtxXq0VuvVHxVW0Z6o52XQteVcG
	33A6eBoDMyN31QjxVI5Behu5IGhUF8cZ6yyC2+WPmloIJEsRcWWjZ9UTiHchf+kVq22hg+dc8i+Nc
	LN+JSa0w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOIqZ-00000000iw8-2Z1i;
	Tue, 03 Nov 2026 15:03:00 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 14/16] smb: client: let umount -f stop waiting for reconnects on hard mounts
Date: Tue,  3 Nov 2026 15:02:53 -0300
Message-ID: <20261103180255.1482516-15-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103180255.1482516-1-pc@manguebit.org>
References: <20261103180255.1482516-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Requests waiting in smb2_reconnect() or cifs_reconnect_tcon() for a
reconnect wait for as long as it takes on hard mounts.  With the server
gone, writeback stuck there keeps umount -f hanging in sync_filesystem()
while it waits for that writeback, even though retries of reads and
writes started before it now give up.

Count umount -f attempts per tcon and stop waiting for reconnects, as on
soft mounts, once one is made after the request started waiting, waking
up such requests on all channels right away.  Do this for the master
tcon and for the per-user tcons of a multiuser mount.  Don't gate it on
tc_count: it is also raised by internal references, such as a reconnect
worker, so an unshared mount could otherwise skip the abort entirely.
Requests started after umount -f are unaffected.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c    | 103 +++++++++++++++++++++++++++++---------
 fs/smb/client/cifsglob.h  |   6 +++
 fs/smb/client/cifsproto.h |   3 +-
 fs/smb/client/cifssmb.c   |   9 ++--
 fs/smb/client/misc.c      |  16 ++++--
 fs/smb/client/smb2pdu.c   |   9 ++--
 fs/smb/client/trace.h     |   4 +-
 7 files changed, 116 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index c90fb0cc0f0e..27b44a97c434 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -828,47 +828,104 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	return 0;
 }
 
-static void cifs_umount_begin(struct super_block *sb)
+static void wake_ses_waiters(struct cifs_ses *ses)
 {
-	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	guard(spinlock)(&ses->chan_lock);
+	for (size_t i = 0; i < ses->chan_count; i++) {
+		struct TCP_Server_Info *server = ses->chans[i].server;
+
+		if (!server)
+			continue;
+		wake_up_all(&server->request_q);
+		wake_up_all(&server->response_q);
+	}
+}
+
+struct cifs_abort_tcon {
+	struct list_head list;
 	struct cifs_tcon *tcon;
+};
 
-	if (cifs_sb == NULL)
-		return;
-
-	atomic_inc(&cifs_sb->umount_aborts);
-	tcon = cifs_sb_master_tcon(cifs_sb);
+static void cifs_abort_reconnect(struct cifs_tcon *tcon)
+{
+	bool exiting;
 
 	spin_lock(&cifs_tcp_ses_lock);
 	spin_lock(&tcon->tc_lock);
 	trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 			    netfs_trace_tcon_ref_see_umount);
-	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
-		/* we have other mounts to same share or we have
-		   already tried to umount this and woken up
-		   all waiting network requests, nothing to do */
-		spin_unlock(&tcon->tc_lock);
-		spin_unlock(&cifs_tcp_ses_lock);
-		return;
-	}
-	/*
-	 * can not set tcon->status to TID_EXITING yet since we don't know if umount -f will
-	 * fail later (e.g. due to open files).  TID_EXITING will be set just before tdis req sent
-	 */
+	exiting = tcon->status == TID_EXITING;
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
+	/*
+	 * TID_EXITING means a previous umount -f already woke this tcon's
+	 * waiters.  tc_count is not checked: it is also raised by internal
+	 * references (e.g. a reconnect worker), not only by other mounts of
+	 * the same share, so it must not gate the abort.  TID_EXITING can not
+	 * be set here yet since this umount -f may fail (e.g. open files) and
+	 * leave the mount usable; it is set just before the tdis is sent.
+	 */
+	if (exiting)
+		return;
 
+	atomic_inc(&tcon->umount_aborts);
 	if (tcon->ses && tcon->ses->server) {
 		cifs_dbg(FYI, "wake up tasks now - umount begin not complete\n");
-		wake_up_all(&tcon->ses->server->request_q);
-		wake_up_all(&tcon->ses->server->response_q);
+		wake_ses_waiters(tcon->ses);
 		msleep(1); /* yield */
 		/* we have to kick the requests once more */
-		wake_up_all(&tcon->ses->server->response_q);
+		wake_ses_waiters(tcon->ses);
 		msleep(1);
 	}
+}
 
-	return;
+static void cifs_umount_begin(struct super_block *sb)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon *master, *tcon;
+	struct cifs_abort_tcon *at, *tmp;
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct tcon_link *tlink;
+	struct rb_node *node;
+	LIST_HEAD(tcons);
+
+	if (cifs_sb == NULL)
+		return;
+
+	atomic_inc(&cifs_sb->umount_aborts);
+	master = cifs_sb_master_tcon(cifs_sb);
+
+	/*
+	 * Abort the reconnect waits of the master tcon and of any per-user
+	 * tcons of a multiuser mount.  Collect the latter with a reference so
+	 * they stay alive while we abort and sleep outside the tree lock.
+	 */
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR_OR_NULL(tcon) || tcon == master)
+			continue;
+		at = kmalloc_obj(struct cifs_abort_tcon, GFP_ATOMIC);
+		if (!at)
+			break;
+		spin_lock(&tcon->tc_lock);
+		tcon->tc_count++;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_get_umount);
+		spin_unlock(&tcon->tc_lock);
+		at->tcon = tcon;
+		list_add_tail(&at->list, &tcons);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	cifs_abort_reconnect(master);
+	list_for_each_entry_safe(at, tmp, &tcons, list) {
+		cifs_abort_reconnect(at->tcon);
+		cifs_put_tcon(at->tcon, netfs_trace_tcon_ref_put_umount);
+		list_del(&at->list);
+		kfree(at);
+	}
 }
 
 static int cifs_freeze(struct super_block *sb)
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 96d2d858214e..3e65639c27cf 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1196,6 +1196,7 @@ struct cifs_tcon {
 	struct list_head tcon_list;
 	int debug_id;		/* Debugging for tracing */
 	int tc_count;
+	atomic_t umount_aborts;	/* nr of umount -f attempts */
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
@@ -2383,6 +2384,11 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 		WRITE_ONCE(cinode->oplock, 0);
 }
 
+static inline bool cifs_tcon_retry(struct cifs_tcon *tcon, int aborts)
+{
+	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts;
+}
+
 static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
 {
 	return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index a37eee2ca54b..8b7914dd13af 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -442,7 +442,8 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
-int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry);
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
+				   struct cifs_tcon *tcon, int aborts);
 
 static inline void cifs_put_smb_ses(struct cifs_ses *ses)
 {
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index fcf97b3d6bea..712086eb3d1f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -73,6 +73,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 {
 	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
+	int aborts;
 	int rc;
 
 	/*
@@ -83,6 +84,8 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	if (!tcon)
 		return 0;
 
+	aborts = atomic_read(&tcon->umount_aborts);
+
 	ses = tcon->ses;
 	server = ses->server;
 
@@ -102,7 +105,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&tcon->tc_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
 	if (rc)
 		return rc;
 
@@ -127,7 +130,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	default:
@@ -159,7 +162,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	}
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index ec28f102ea08..13eb067ad88a 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1073,7 +1073,15 @@ int cifs_inval_name_dfs_link_error(const unsigned int xid,
 }
 #endif
 
-int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
+static bool reco_wait_done(struct TCP_Server_Info *server,
+			   struct cifs_tcon *tcon, int aborts)
+{
+	return server->tcpStatus != CifsNeedReconnect ||
+		atomic_read(&tcon->umount_aborts) != aborts;
+}
+
+int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
+				   struct cifs_tcon *tcon, int aborts)
 {
 	int timeout = 10;
 	int rc;
@@ -1096,7 +1104,9 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 	 */
 	do {
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->tcpStatus != CifsNeedReconnect),
+						      reco_wait_done(server,
+								     tcon,
+								     aborts),
 						      timeout * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
@@ -1111,7 +1121,7 @@ int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server, bool retry)
 			return 0;
 		}
 		spin_unlock(&server->srv_lock);
-	} while (retry);
+	} while (cifs_tcon_retry(tcon, aborts));
 
 	cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
 	return -EHOSTDOWN;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 29e60f827c84..33f8d0638a54 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -251,6 +251,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	       struct TCP_Server_Info *server, bool from_reconnect)
 {
 	struct cifs_ses *ses;
+	int aborts;
 	int xid;
 	int rc = 0;
 
@@ -262,6 +263,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	if (tcon == NULL)
 		return 0;
 
+	aborts = atomic_read(&tcon->umount_aborts);
+
 	if (smb2_command == SMB2_TREE_CONNECT)
 		return 0;
 
@@ -318,7 +321,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	spin_unlock(&server->srv_lock);
 
 again:
-	rc = cifs_wait_for_server_reconnect(server, tcon->retry);
+	rc = cifs_wait_for_server_reconnect(server, tcon, aborts);
 	if (rc)
 		return rc;
 
@@ -346,7 +349,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	case CifsNeedReconnect:
 		spin_unlock(&server->srv_lock);
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	default:
@@ -377,7 +380,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	rc = cifs_negotiate_protocol(0, ses, server);
 	if (rc) {
 		mutex_unlock(&ses->session_mutex);
-		if (!tcon->retry)
+		if (!cifs_tcon_retry(tcon, aborts))
 			return -EHOSTDOWN;
 		goto again;
 	}
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5331ce6dc8b3..8abb296c5198 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -205,7 +205,9 @@
 	EM(netfs_trace_tcon_ref_see_fscache_collision,	"SEE FV-CO!") \
 	EM(netfs_trace_tcon_ref_see_fscache_okay,	"SEE FV-Ok ") \
 	EM(netfs_trace_tcon_ref_see_fscache_relinq,	"SEE FV-Rlq") \
-	E_(netfs_trace_tcon_ref_see_umount,		"SEE Umount")
+	EM(netfs_trace_tcon_ref_see_umount,		"SEE Umount") \
+	EM(netfs_trace_tcon_ref_get_umount,		"GET Umount") \
+	E_(netfs_trace_tcon_ref_put_umount,		"PUT Umount")
 
 #undef EM
 #undef E_
-- 
2.56.0

