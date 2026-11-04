Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827704;
	b=IkNmEIyuv/Ulz228m3z2ZC+OdpbOyUSM/ug4YeUwCZ2xIz73BMbtd5QHD59QTDxktYQa
	 DMPUZ6W1S4gLhQobA/B4SE2VoP9U/F++UnMNuh3XX/DWEJuuLkdje8iGK/BqhqIhjmBs4
	 /iP/tW9O+BU9Bft7GzAPtaH4GaQNWZDN6PW37zc/Odf+TU9MnDUSXyRGhkOq5Ao61I1sC
	 tGa1MUm1HrBiiwgo3aL17YzvRaQcDcOsmj5yQNYk0NFlcLeCXFhm8YyBlmecaSx09KyMe
	 9m9s0rsotKpFTBpVrVvVA4e58h+UeGvMwlWnl2DeQu32+qZBVkh0QKXjcNvrAYMBuGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827704;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qWkfrZSHEjN0A7NAnoMAd1pEImspUxPhqA2xeKRpkQg=;
	b=Y1+RfAaK4VnafjRhRRh/ccoSFxSlyzWZyqfitNrzbdf9l1omezUYAnv1pVoFfNczRwXA
	 6cDXscXYwD+EiSLWh8sGXZeYJq+nA92MpNlZve1+C2ZHGC3Lvm2CVI69Ei1YutllOd2EW
	 YrXE6SujZwtTe5QVJq63G0WlTovEHYDbNOSS6p2r6KgosGRHk1wF1zQfQjGY25lnfsWw6
	 7Vf2s1OYejcgHkdb5o4LUoehW5Znfo12XY9fGcuJE3NBGhehBMBuWNMUQN3LHm8Asi6Qw
	 h2EbnpqEODUB2aIAKr6tWWv1apDgvbULV3q6RWgTIU8G3/OvZre2RWGKQ7OuMtGq55A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=qgM3piJY;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E186078019;
	Wed,  4 Nov 2026 21:28:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35E186078019
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=qgM3piJY
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=qWkfrZSHEjN0A7NAnoMAd1pEImspUxPhqA2xeKRpkQg=; b=qgM3piJYkfA5Salr9Oc8VOxDnv
	c3heFXtMNqNkoSNWMhp0DbJjaCWqQyoRHJROCqaoi+0gR5T14YmVtDkcBhIHLRh1GO2X6FyLuzwRA
	k8mSTKg6GTV799X6CA6WC8UUBy+ezaBZQAHetm0UiUexP7jzdKtawvtcLdb19qhkfh6fc37sAzB45
	eI5ztw8w8L1si/wd+t8efDVGUGogv9WqE88J+BHMx9imthQT6TlorcPsWo7tCw3rS+/kkmpCS/xCJ
	yY50UUcI781wKTHXNgjjyn7k+XKpgeRhofOC3uA4Ab/hm8bHbfKp0IbAHLScOiWeOW6cmHvYhI+Po
	FI7+3BbQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWl-00000000rJ8-2Giz;
	Wed, 04 Nov 2026 18:28:16 -0300
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
Subject: [PATCH v4 17/17] smb: client: stop reconnecting and replaying during a forced unmount
Date: Wed,  4 Nov 2026 18:28:10 -0300
Message-ID: <20261104212810.1935575-18-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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

umount -f of a gone server on a hard mount hangs the teardown.
cifs_kill_sb() flushes the deferred-file, cached-dir and oplock-break work
and then cifs_umount() sends a tree disconnect, but on a hard mount every
reconnect wait in cifs_wait_for_server_reconnect() and every per-PDU
replay loop (gated by smb2_should_replay()) retries forever, and the
per-tcon abort count that umount -f bumps is only snapshotted on entry to
smb2_reconnect(), so an operation that enters after the unmount began
never observes it and waits or spins out the teardown (e.g. a close work
item wedging flush_workqueue()).

Mark each of the mount's tcons dying for the duration of cifs_kill_sb()'s
teardown and have cifs_wait_for_server_reconnect(), cifs_tcon_retry() and
smb2_should_replay() give up while it is set, so both the reconnect waits
and the replay loops stop at every site, however late the operation
entered.  It is a count raised at the start of the teardown and dropped at
the end, so a tcon shared with another mount only has its retries
suppressed for those moments, not for good.

Also stop the reconnect worker from wedging: smb2_reconnect_server() holds
a tcon or session reference across cifs_wait_for_server_reconnect(), so
with the server gone it never returns, pinning the cifsiod worker and
leaking the tcon, session, server and cifsd thread.  It only needs to
attempt the reconnect, so fail fast; it is retried once the transport is
back.

Reads, metadata and SMB1 reconnect waits outside teardown still follow the
hard and retrans mount options; a task blocked in one can be killed, and
open files keep umount -f from reaching teardown (-EBUSY).

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c   | 39 ++++++++++++++++++++++++++++++++++++++-
 fs/smb/client/cifsglob.h |  4 +++-
 fs/smb/client/misc.c     |  3 ++-
 fs/smb/client/smb2ops.c  |  4 ++++
 fs/smb/client/smb2pdu.c  |  4 ++--
 5 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 5c40d03df7cd..679adb00c012 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -307,9 +307,40 @@ static void wake_ses_waiters(struct cifs_ses *ses)
 	}
 }
 
+/*
+ * While a forced unmount tears a superblock down, keep its tcons from
+ * reconnecting or replaying so the teardown (flushing close and oplock work,
+ * sending the tree disconnect) can't hang on a server that is gone.  It is a
+ * count, not a flag, so a tcon shared with another mount only has its retries
+ * suppressed for the duration of this teardown.
+ */
+static void cifs_set_tcon_dying(struct cifs_sb_info *cifs_sb, bool dying)
+{
+	struct cifs_tcon *master = cifs_sb_master_tcon(cifs_sb);
+	struct cifs_tcon *tcon;
+	struct rb_node *node;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(&cifs_sb->tlink_tree); node; node = rb_next(node)) {
+		tcon = tlink_tcon(rb_entry(node, struct tcon_link, tl_rbnode));
+		if (IS_ERR_OR_NULL(tcon))
+			continue;
+		if (dying)
+			atomic_inc(&tcon->dying);
+		else
+			atomic_dec(&tcon->dying);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	/* kick anyone already blocked in cifs_wait_for_server_reconnect() */
+	if (dying && !IS_ERR_OR_NULL(master) && master->ses)
+		wake_ses_waiters(master->ses);
+}
+
 static void cifs_kill_sb(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	bool force = atomic_read(&cifs_sb->umount_aborts);
 
 	/*
 	 * Reaching here after a umount -f means the mount is going away for
@@ -317,7 +348,7 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * writeback to a server that is gone) rather than looping forever on
 	 * a hard mount and hanging the teardown below.
 	 */
-	if (atomic_read(&cifs_sb->umount_aborts))
+	if (force)
 		WRITE_ONCE(cifs_sb->exiting, true);
 
 	/*
@@ -325,6 +356,9 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * and close all deferred file handles before we kill the sb.
 	 */
 	if (cifs_sb->root) {
+		if (force)
+			cifs_set_tcon_dying(cifs_sb, true);
+
 		close_all_cached_dirs(cifs_sb);
 		cifs_close_all_deferred_files_sb(cifs_sb);
 
@@ -345,6 +379,9 @@ static void cifs_kill_sb(struct super_block *sb)
 		flush_workqueue(serverclose_wq);
 		flush_workqueue(fileinfo_put_wq);
 
+		if (force)
+			cifs_set_tcon_dying(cifs_sb, false);
+
 		/* finally release root dentry */
 		dput(cifs_sb->root);
 		cifs_sb->root = NULL;
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0cc43ea48b77..7e55f445ddb6 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1197,6 +1197,7 @@ struct cifs_tcon {
 	int debug_id;		/* Debugging for tracing */
 	int tc_count;
 	atomic_t umount_aborts;	/* nr of umount -f attempts */
+	atomic_t dying;		/* umount -f teardown: stop reconnecting/replaying */
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
@@ -2387,7 +2388,8 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 
 static inline bool cifs_tcon_retry(struct cifs_tcon *tcon, int aborts)
 {
-	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts;
+	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts &&
+	       !atomic_read(&tcon->dying);
 }
 
 static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 4a3ecf5c80f7..8bf751e73369 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1077,7 +1077,8 @@ static bool reco_wait_done(struct TCP_Server_Info *server,
 			   struct cifs_tcon *tcon, int aborts)
 {
 	return server->tcpStatus != CifsNeedReconnect ||
-		atomic_read(&tcon->umount_aborts) != aborts;
+		atomic_read(&tcon->umount_aborts) != aborts ||
+		atomic_read(&tcon->dying);
 }
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 457f18ce3245..4124f9f042be 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2933,6 +2933,10 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 	if (!pretries || !pcur_sleep)
 		return false;
 
+	/* a forced unmount is tearing this tcon down; stop replaying */
+	if (atomic_read(&tcon->dying))
+		return false;
+
 	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
 		smb2_replay_backoff(pcur_sleep);
 		return true;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index e404351d577c..a0376c7e36b6 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4388,7 +4388,7 @@ void smb2_reconnect_server(struct work_struct *work)
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
 		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
-				    false);
+				    true);
 		if (!rc) {
 			cifs_renegotiate_iosize(server, tcon);
 			cifs_reopen_persistent_handles(tcon);
@@ -4421,7 +4421,7 @@ void smb2_reconnect_server(struct work_struct *work)
 	list_for_each_entry_safe(ses, ses2, &tmp_ses_list, rlist) {
 		tcon->ses = ses;
 		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
-				    false);
+				    true);
 		if (rc)
 			resched = true;
 		list_del_init(&ses->rlist);
-- 
2.56.0

