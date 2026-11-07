Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071594;
	b=Jc15/wateL5swVSrRFx540J83IWbfN3dnYMgrYZpJgJRrQwphglYYBfBiNQvio4THIRG
	 /2qYhgZT0VzwoFOaWRgn2po1bzSrpzffOt1XYgFJ99SPwG4w1QxcsxaenYYyxF+2e2Vdc
	 jyoM64KDH1h44xwAHnYhwWaeDPLVZkIVkkHnO9zgXpl9Y2Fk6rEHqnUM9Abtxgr6jfTGt
	 f2miCR4I9KJpDpJp1vVA8++R3+GAgVRG+LZR0Q+4MksO51osq2gfnJOs/qQHsTsGn0NZZ
	 9Na2pktIfV2VKHvxIMrIufFyIbWk5pMiGS32+Eb5XXRbNhkAPpqlNRVVNXSzbV5jK1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071594;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bWb6jBRlX1A1NqPWJN75nzeEQzIcCnV6lLDY33EgiVU=;
	b=o7RlCymnNKrW1YDNCqHqzH2TAeRb/sAwJ+kru03tgIngW4oVdjrgulhvYbB/fTXmrzhr
	 lQuZFPG7cldr4eld9aDW/e4BUeaa4XV4QT+UDyWJOaOtRROlwLkNMu1bkhoityoBSn3a6
	 TuhbtUlp8NkKDDsnn5H//Q5zFqNfLDYLO7+QCAMPxVgs7elXUAd56Z71mc5eRevLLVV4y
	 S/KAvj70Gy68kA4ZijVkqa2bxcnZu2TKm8vtSLrHxYz7PD/4Aons89jP4aGYrk7ArBxW2
	 HWVKMB8ehT9oMxQjDfIuIGznl1FiqsYL2qOD9aAy/OKbm8KSyDn3+toyRNe46zbkakw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=BEKNr0Ip;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741B7606A33E;
	Sat,  7 Nov 2026 17:13:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 741B7606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=BEKNr0Ip
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=bWb6jBRlX1A1NqPWJN75nzeEQzIcCnV6lLDY33EgiVU=; b=BEKNr0IpsO0InZ0QcruhJmgdg+
	mG+D9HA/vPEl29NBi6sISsx39MiZGZo60D3O3PFuMFfuAJKxq4RoY6niPynCTku7dXyTeeAjxtxTe
	YHqVO0C3h+3Y8yYHD4TQGh1d7NmPCZ4/7J8XKP5Yi9ad5VRpTNILGWkpuk4PnBXcWSCNLos2lPXAI
	6l4dq39jC+JFQIVoxvm3hoVK7UbJEgECS8iWPXiqN4xow3oLhvw+nh6yoTpxCUOacSJvKBwQgHdMV
	WQfgl3B6PN6L6aSaXpJDPKBEgV5hMR4zNTDN5iJ9sHOsd+fJIS7ZpYT8G1FdNDgFdKU2LakOHewbG
	UtUY1iWw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyY-000000017iW-3zMH;
	Sat, 07 Nov 2026 14:13:12 -0300
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
Subject: [PATCH v9 19/19] smb: client: stop reconnecting and replaying during a forced unmount
Date: Sat,  7 Nov 2026 14:13:05 -0300
Message-ID: <20261107171305.2847361-20-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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

Mark each of the mount's tcons dying, master and per-user alike, waking
their sessions' waiters, and have cifs_wait_for_server_reconnect(),
cifs_tcon_retry() and smb2_should_replay() give up while it is set, so
both the reconnect waits and the replay loops stop at every site, however
late the operation entered.  Keep it set, with the mount's tlinks pinned,
until cifs_umount() has dropped them, then drop it on those tcons that
another superblock still holds, and hand no dying tcon to a new mount.
Also treat a tcon that no mount references any more as dying, waking its
waiters when that happens, so that whatever still holds it (e.g. the
cached directory laundromat, a cancelled close, or its tree disconnect
after cifs_prune_tlinks()) stops too, and never reuse it.

Also stop the reconnect worker from wedging: smb2_reconnect_server() holds
a tcon or session reference across cifs_wait_for_server_reconnect(), so
with the server gone it never returns, pinning the cifsiod worker and
leaking the tcon, session, server and cifsd thread.  It only needs to
attempt the reconnect, so fail fast; it is retried once the transport is
back.  Reopen persistent handles from it once, without waiting, and
reschedule it if one failed for a transient reason.

Reads, metadata and SMB1 reconnect waits outside teardown still follow the
hard and retrans mount options, except on a tcon shared with another
mount, whose waits and replays give up too while the teardown runs; a
task blocked in one can be killed, and open files keep umount -f from
reaching teardown (-EBUSY).

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cifsfs.c    | 44 ++++++++++++++++++++++++++++++++++++++-
 fs/smb/client/cifsglob.h  | 10 ++++++++-
 fs/smb/client/cifsproto.h |  2 +-
 fs/smb/client/connect.c   |  9 +++++---
 fs/smb/client/file.c      | 13 +++++++++---
 fs/smb/client/misc.c      |  3 ++-
 fs/smb/client/smb2ops.c   |  4 ++++
 fs/smb/client/smb2pdu.c   |  7 ++++---
 8 files changed, 79 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 6a15c6a4fed2..7000fb4573c9 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -349,9 +349,46 @@ static void put_sb_tcons(struct list_head *tcons)
 	}
 }
 
+/*
+ * While a forced unmount tears a superblock down, keep its tcons from
+ * reconnecting or replaying so the teardown (flushing close and oplock work,
+ * sending the tree disconnect) can't hang on a server that is gone.  It is a
+ * count, not a flag, so a tcon shared with another mount only has its retries
+ * suppressed for the duration of this teardown; one no mount uses any more
+ * stays dying until it is freed.
+ */
+static void set_tcons_dying(struct cifs_sb_info *cifs_sb,
+			    struct list_head *tcons)
+{
+	struct cifs_tcon_ref *ref;
+
+	get_sb_tcons(cifs_sb, tcons);
+	list_for_each_entry(ref, tcons, list) {
+		atomic_inc(&ref->tcon->dying);
+		cifs_wake_ses_waiters(ref->tcon->ses);
+	}
+}
+
+static void clear_tcons_dying(struct list_head *tcons)
+{
+	struct cifs_tcon_ref *ref;
+
+	flush_workqueue(serverclose_wq);
+	list_for_each_entry(ref, tcons, list) {
+		guard(spinlock)(&ref->tcon->tc_lock);
+		if (ref->tcon->mnt_refs)
+			atomic_dec(&ref->tcon->dying);
+	}
+	put_sb_tcons(tcons);
+}
+
 static void cifs_kill_sb(struct super_block *sb)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	LIST_HEAD(tcons);
+	bool force;
+
+	force = atomic_read(&cifs_sb->umount_aborts);
 
 	/*
 	 * Reaching here after a umount -f means the mount is going away for
@@ -359,8 +396,10 @@ static void cifs_kill_sb(struct super_block *sb)
 	 * writeback to a server that is gone) rather than looping forever on
 	 * a hard mount and hanging the teardown below.
 	 */
-	if (atomic_read(&cifs_sb->umount_aborts))
+	if (force) {
 		WRITE_ONCE(cifs_sb->exiting, true);
+		set_tcons_dying(cifs_sb, &tcons);
+	}
 
 	/*
 	 * We need to release all dentries for the cached directories
@@ -394,6 +433,9 @@ static void cifs_kill_sb(struct super_block *sb)
 
 	kill_anon_super(sb);
 	cifs_umount(cifs_sb);
+
+	if (force)
+		clear_tcons_dying(&tcons);
 }
 
 static int
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0b66f2c9c9a9..4e16347886ed 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1207,6 +1207,7 @@ struct cifs_tcon {
 	int mnt_refs;		/* refs held by mounts, under tc_lock */
 	int mnt_unlinked;	/* mnt_refs of tlinks being built */
 	atomic_t umount_aborts;	/* nr of umount -f attempts */
+	atomic_t dying;		/* umount -f: stop reconnects/replays */
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
@@ -2408,9 +2409,16 @@ static inline void cifs_reset_oplock(struct cifsInodeInfo *cinode)
 		WRITE_ONCE(cinode->oplock, 0);
 }
 
+static inline bool cifs_tcon_dying(struct cifs_tcon *tcon)
+{
+	return atomic_read(&tcon->dying) ||
+	       (!tcon->ipc && !tcon->dummy && !READ_ONCE(tcon->mnt_refs));
+}
+
 static inline bool cifs_tcon_retry(struct cifs_tcon *tcon, int aborts)
 {
-	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts;
+	return tcon->retry && atomic_read(&tcon->umount_aborts) == aborts &&
+	       !cifs_tcon_dying(tcon);
 }
 
 static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index b7a7fe372d47..15123c7b9373 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -244,7 +244,7 @@ int cifs_match_super(struct super_block *sb, struct fs_context *fc);
 int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
 void cifs_umount(struct cifs_sb_info *cifs_sb);
 void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
-void cifs_reopen_persistent_handles(struct cifs_tcon *tcon);
+bool cifs_reopen_persistent_handles(struct cifs_tcon *tcon);
 
 bool cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
 			     __u64 length, __u8 type, __u16 flags,
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 803cefc61194..900846533d48 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2619,7 +2619,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx,
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 		spin_lock(&tcon->tc_lock);
-		if (!match_tcon(tcon, ctx)) {
+		if (!match_tcon(tcon, ctx) || cifs_tcon_dying(tcon)) {
 			spin_unlock(&tcon->tc_lock);
 			continue;
 		}
@@ -2714,8 +2714,11 @@ void cifs_wake_ses_waiters(struct cifs_ses *ses)
 
 static void drop_mnt_ref(struct cifs_tcon *tcon)
 {
-	guard(spinlock)(&tcon->tc_lock);
-	tcon->mnt_refs--;
+	scoped_guard(spinlock, &tcon->tc_lock) {
+		if (--tcon->mnt_refs)
+			return;
+	}
+	cifs_wake_ses_waiters(tcon->ses);
 }
 
 static void put_mnt_tcon(struct cifs_tcon *tcon, enum smb3_tcon_ref_trace trace)
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 84125f9a43a4..d5b7d33a7a37 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2030,14 +2030,16 @@ int cifs_close(struct inode *inode, struct file *file)
 	return 0;
 }
 
-void
+bool
 cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *open_file, *tmp;
 	LIST_HEAD(tmp_list);
+	bool retry = false;
+	int rc;
 
 	if (!tcon->use_persistent || !tcon->need_reopen_files)
-		return;
+		return false;
 
 	tcon->need_reopen_files = false;
 
@@ -2055,11 +2057,16 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
 		/* do not flush */
-		if (cifs_reopen_file(open_file, false, 0))
+		rc = cifs_reopen_file(open_file, false,
+				      CIFS_REOPEN_BOUND | CIFS_REOPEN_NOWAIT);
+		if (rc) {
 			tcon->need_reopen_files = true;
+			retry |= is_replayable_error(rc);
+		}
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
 	}
+	return retry;
 }
 
 int cifs_closedir(struct inode *inode, struct file *file)
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 4a3ecf5c80f7..4d0df73d15d7 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1077,7 +1077,8 @@ static bool reco_wait_done(struct TCP_Server_Info *server,
 			   struct cifs_tcon *tcon, int aborts)
 {
 	return server->tcpStatus != CifsNeedReconnect ||
-		atomic_read(&tcon->umount_aborts) != aborts;
+		atomic_read(&tcon->umount_aborts) != aborts ||
+		cifs_tcon_dying(tcon);
 }
 
 int cifs_wait_for_server_reconnect(struct TCP_Server_Info *server,
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 0a487b24f4e7..298f549bd7ed 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2938,6 +2938,10 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
 	if (!pretries || !pcur_sleep)
 		return false;
 
+	/* the tcon is being torn down; stop replaying */
+	if (cifs_tcon_dying(tcon))
+		return false;
+
 	if (tcon->retry || (*pretries)++ < tcon->ses->server->retrans) {
 		smb2_replay_backoff(pcur_sleep);
 		return true;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 099fd94c58a4..20e6b948ba21 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4417,10 +4417,11 @@ void smb2_reconnect_server(struct work_struct *work)
 
 	list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist) {
 		rc = smb2_reconnect(SMB2_INTERNAL_CMD, tcon, server, true,
-				    false);
+				    true);
 		if (!rc) {
 			cifs_renegotiate_iosize(server, tcon);
-			cifs_reopen_persistent_handles(tcon);
+			if (cifs_reopen_persistent_handles(tcon))
+				resched = true;
 		} else
 			resched = true;
 		list_del_init(&tcon->rlist);
@@ -4450,7 +4451,7 @@ void smb2_reconnect_server(struct work_struct *work)
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

