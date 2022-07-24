Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4368DC43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiGXPMh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiGXPMf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A993211159
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 624C235066;
        Sun, 24 Jul 2022 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675551; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoJyoQlq3v7CZoZ//ozFrg6ZGBUlW2BmspGsQ1fHQFA=;
        b=P9pzXy0IO4hLRJfv1pUPe64SFOhTO9IEBythge7lAgi83nTA4qw12scfgRuY2pQ+WwzYzj
        UTtf4XHlV7pcJhgvNSoskjeYsC1Jf5QZ6yV3ZZFJ10iUtNuuDqszyBsjqbTVviRiPXhveI
        rI65ZsYp4iuntn+N7TdSVy6at0QnXo0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675551;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoJyoQlq3v7CZoZ//ozFrg6ZGBUlW2BmspGsQ1fHQFA=;
        b=G95GeYp9vzzmkM2V3LW6qDNtrajp4Gx+f/KUdLSYNSa6AfjTR0psxKYVToA2oeJ7YQW4sv
        m9kK+5b6XQ6HiADw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 58A6513A8D;
        Sun, 24 Jul 2022 15:12:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G4ChBl5h3WJkMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:30 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 12/14] cifs: rename list_head fields
Date:   Sun, 24 Jul 2022 12:11:35 -0300
Message-Id: <20220724151137.7538-13-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Rename list_head fields for several structs to give more meaning and/or
set some standard for all cifs.ko structs.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c    |  38 ++++----
 fs/cifs/cifsfs.c        |   6 +-
 fs/cifs/cifsglob.h      |  68 +++++++--------
 fs/cifs/cifssmb.c       |  10 +--
 fs/cifs/connect.c       |  48 +++++-----
 fs/cifs/dfs_cache.c     |   6 +-
 fs/cifs/file.c          | 188 ++++++++++++++++++++--------------------
 fs/cifs/ioctl.c         |   4 +-
 fs/cifs/misc.c          |  65 +++++++-------
 fs/cifs/readdir.c       |   4 +-
 fs/cifs/sess.c          |   8 +-
 fs/cifs/smb1ops.c       |   4 +-
 fs/cifs/smb2file.c      |  14 +--
 fs/cifs/smb2misc.c      |  32 +++----
 fs/cifs/smb2ops.c       |  31 ++++---
 fs/cifs/smb2pdu.c       |   4 +-
 fs/cifs/smb2transport.c |  10 +--
 fs/cifs/transport.c     |   8 +-
 18 files changed, 273 insertions(+), 275 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 0c08166f8f30..8c8e33642fdd 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -56,7 +56,7 @@ void cifs_dump_mids(struct cifs_server_info *server)
 
 	cifs_dbg(VFS, "Dump pending requests:\n");
 	spin_lock(&g_mid_lock);
-	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+	list_for_each_entry(mid_entry, &server->pending_mid_q, head) {
 		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
 			 mid_entry->mid_state,
 			 le16_to_cpu(mid_entry->command),
@@ -182,11 +182,12 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 	seq_printf(m, " <filename>\n");
 #endif /* CIFS_DEBUG2 */
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-				spin_lock(&tcon->open_file_lock);
-				list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+	list_for_each_entry(server, &g_servers_list, head) {
+		list_for_each_entry(ses, &server->ses_list, head) {
+			list_for_each_entry(tcon, &ses->tcon_list, head) {
+				spin_lock(&tcon->open_files_lock);
+				list_for_each_entry(cfile, &tcon->open_files_list,
+						    tcon_head) {
 					seq_printf(m,
 						"0x%x 0x%llx 0x%x %d %d %d %pd",
 						tcon->tid,
@@ -202,7 +203,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
 					seq_printf(m, "\n");
 #endif /* CIFS_DEBUG2 */
 				}
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&tcon->open_files_lock);
 			}
 		}
 	}
@@ -268,7 +269,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 	c = 0;
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
+	list_for_each_entry(server, &g_servers_list, head) {
 		/* channel info will be printed as a part of sessions below */
 		if (CIFS_SERVER_IS_CHAN(server))
 			continue;
@@ -375,7 +376,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 		seq_printf(m, "\n\n\tSessions: ");
 		i = 0;
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(ses, &server->ses_list, head) {
 			i++;
 			if ((ses->serverDomain == NULL) ||
 				(ses->serverOS == NULL) ||
@@ -439,7 +440,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			else
 				seq_puts(m, "none\n");
 
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+			list_for_each_entry(tcon, &ses->tcon_list, head) {
 				++j;
 				seq_printf(m, "\n\t%d) ", j);
 				cifs_debug_tcon(m, tcon);
@@ -450,8 +451,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n\n\tServer interfaces: %zu",
 					   ses->iface_count);
 			j = 0;
-			list_for_each_entry(iface, &ses->iface_list,
-						 iface_head) {
+			list_for_each_entry(iface, &ses->iface_list, head) {
 				seq_printf(m, "\n\t%d)", ++j);
 				cifs_dump_iface(m, iface);
 				if (is_ses_using_iface(ses, iface))
@@ -464,7 +464,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 		seq_puts(m, "\n\n\tMIDs: ");
 		spin_lock(&g_mid_lock);
-		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+		list_for_each_entry(mid_entry, &server->pending_mid_q, head) {
 			seq_printf(m, "\n\tState: %d com: %d pid:"
 					" %d cbdata: %p mid %llu\n",
 					mid_entry->mid_state,
@@ -512,7 +512,7 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 		g_current_xid = 0;
 		spin_unlock(&g_mid_lock);
 		spin_lock(&g_servers_lock);
-		list_for_each_entry(server, &g_servers_list, server_head) {
+		list_for_each_entry(server, &g_servers_list, head) {
 			server->max_in_flight = 0;
 #ifdef CONFIG_CIFS_STATS2
 			for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
@@ -523,8 +523,8 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 				server->fastest_cmd[0] = 0;
 			}
 #endif /* CONFIG_CIFS_STATS2 */
-			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-				list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+			list_for_each_entry(ses, &server->ses_list, head) {
+				list_for_each_entry(tcon, &ses->tcon_list, head) {
 					atomic_set(&tcon->num_smbs_sent, 0);
 					spin_lock(&tcon->stat_lock);
 					tcon->bytes_read = 0;
@@ -579,7 +579,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 
 	i = 0;
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
+	list_for_each_entry(server, &g_servers_list, head) {
 		seq_printf(m, "\nMax requests in flight: %d", server->max_in_flight);
 #ifdef CONFIG_CIFS_STATS2
 		seq_puts(m, "\nTotal time spent processing by command. Time ");
@@ -598,8 +598,8 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 					atomic_read(&server->smb2slowcmd[j]),
 					server->hostname, j);
 #endif /* STATS2 */
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+		list_for_each_entry(ses, &server->ses_list, head) {
+			list_for_each_entry(tcon, &ses->tcon_list, head) {
 				i++;
 				seq_printf(m, "\n%d) %s", i, tcon->treeName);
 				if (tcon->need_reconnect)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5bb51b8cd3bd..497b64acf899 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -391,7 +391,7 @@ cifs_alloc_inode(struct super_block *sb)
 	cinode->uniqueid = 0;
 	cinode->createtime = 0;
 	cinode->epoch = 0;
-	spin_lock_init(&cinode->open_file_lock);
+	spin_lock_init(&cinode->open_files_lock);
 	generate_random_uuid(cinode->lease_key);
 
 	/*
@@ -399,8 +399,8 @@ cifs_alloc_inode(struct super_block *sb)
 	 * by the VFS.
 	 */
 	/* cinode->netfs.inode.i_flags = S_NOATIME | S_NOCMTIME; */
-	INIT_LIST_HEAD(&cinode->openFileList);
-	INIT_LIST_HEAD(&cinode->llist);
+	INIT_LIST_HEAD(&cinode->open_files_list);
+	INIT_LIST_HEAD(&cinode->fid_locks_list);
 	INIT_LIST_HEAD(&cinode->deferred_closes);
 	spin_lock_init(&cinode->deferred_lock);
 	return &cinode->netfs.inode;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e2c6cbacb6d5..03837f5781db 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -603,8 +603,8 @@ inc_rfc1001_len(void *buf, int count)
 }
 
 struct cifs_server_info {
-	struct list_head server_head;
-	struct list_head smb_ses_list;
+	struct list_head head;
+	struct list_head ses_list;
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
@@ -936,7 +936,7 @@ static inline void cifs_set_net_ns(struct cifs_server_info *srv, struct net *net
 #endif
 
 struct cifs_server_iface {
-	struct list_head iface_head;
+	struct list_head head;
 	struct kref refcount;
 	size_t speed;
 	unsigned int rdma_capable : 1;
@@ -952,7 +952,7 @@ release_iface(struct kref *ref)
 	struct cifs_server_iface *iface = container_of(ref,
 						       struct cifs_server_iface,
 						       refcount);
-	list_del_init(&iface->iface_head);
+	list_del_init(&iface->head);
 	kfree(iface);
 }
 
@@ -1004,7 +1004,7 @@ struct cifs_chan {
  * Session structure.  One of these for each uid session with a particular host
  */
 struct cifs_ses {
-	struct list_head smb_ses_list;
+	struct list_head head;
 	struct list_head rlist; /* reconnect list */
 	struct list_head tcon_list;
 	struct cifs_tcon *tcon_ipc;
@@ -1126,7 +1126,7 @@ struct cifs_fattr {
 };
 
 struct cached_dirent {
-	struct list_head entry;
+	struct list_head head;
 	char *name;
 	int namelen;
 	loff_t pos;
@@ -1166,13 +1166,13 @@ struct cached_fid {
  * session
  */
 struct cifs_tcon {
-	struct list_head tcon_list;
+	struct list_head head;
 	int tc_count;
 	struct list_head rlist; /* reconnect list */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
 	atomic_t num_remote_opens; /* num of all network opens on server */
-	struct list_head openFileList;
-	spinlock_t open_file_lock; /* protects list above */
+	struct list_head open_files_list;
+	spinlock_t open_files_lock; /* protects list above */
 	struct cifs_ses *ses;	/* pointer to session associated with */
 	char treeName[MAX_TREE_SIZE + 1]; /* UNC name of resource in ASCII */
 	char *nativeFileSystem;
@@ -1310,14 +1310,14 @@ extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
 #define CIFS_OPLOCK_NO_CHANGE 0xfe
 
 struct cifs_pending_open {
-	struct list_head olist;
+	struct list_head head;
 	struct tcon_link *tlink;
 	__u8 lease_key[16];
 	__u32 oplock;
 };
 
 struct cifs_deferred_close {
-	struct list_head dlist;
+	struct list_head head;
 	struct tcon_link *tlink;
 	__u16  netfid;
 	__u64  persistent_fid;
@@ -1325,11 +1325,11 @@ struct cifs_deferred_close {
 };
 
 /*
- * This info hangs off the cifs_file_info structure, pointed to by llist.
+ * This info hangs off the cifs_file_info structure.
  * This is used to track byte stream locks on the file
  */
 struct cifs_lock_info {
-	struct list_head llist;	/* pointer to next cifs_lock_info */
+	struct list_head head;	/* pointer to next cifs_lock_info */
 	struct list_head blist; /* pointer to locks blocked on this */
 	wait_queue_head_t block_q;
 	__u64 offset;
@@ -1387,27 +1387,27 @@ struct cifs_fid {
 };
 
 struct cifs_fid_locks {
-	struct list_head llist;
+	struct list_head head;
 	struct cifs_file_info *cfile;	/* fid that owns locks */
 	struct list_head locks;		/* locks held by fid above */
 };
 
 struct cifs_file_info {
-	/* following two lists are protected by tcon->open_file_lock */
-	struct list_head tlist;	/* pointer to next fid owned by tcon */
-	struct list_head flist;	/* next fid (file instance) for this inode */
+	/* following two lists are protected by tcon->open_files_lock */
+	struct list_head tcon_head; /* pointer to next fid owned by tcon */
+	struct list_head fid_head; /* next fid (file instance) for this inode */
 	/* lock list below protected by cinode->lock_sem */
-	struct cifs_fid_locks *llist;	/* brlocks held by this fid */
-	kuid_t uid;		/* allows finding which FileInfo structure */
-	__u32 pid;		/* process id who opened file */
-	struct cifs_fid fid;	/* file id from remote */
+	struct cifs_fid_locks *fid_locks; /* brlocks held by this fid */
+	kuid_t uid; /* allows finding which FileInfo structure */
+	__u32 pid; /* process id who opened file */
+	struct cifs_fid fid; /* file id from remote */
 	struct list_head rlist; /* reconnect list */
 	/* BB add lock scope info here if needed */ ;
 	/* lock scope id (0 if none) */
 	struct dentry *dentry;
 	struct tcon_link *tlink;
 	unsigned int f_flags;
-	bool invalidHandle:1;	/* file closed via session abend */
+	bool invalidHandle:1; /* file closed via session abend */
 	bool swapfile:1;
 	bool oplock_break_cancelled:1;
 	unsigned int oplock_epoch; /* epoch from the lease break */
@@ -1435,7 +1435,7 @@ struct cifs_io_parms {
 
 struct cifs_aio_ctx {
 	struct kref		refcount;
-	struct list_head	list;
+	struct list_head	rw_list;
 	struct mutex		aio_mutex;
 	struct completion	done;
 	struct iov_iter		iter;
@@ -1458,7 +1458,7 @@ struct cifs_aio_ctx {
 /* asynchronous read support */
 struct cifs_readdata {
 	struct kref			refcount;
-	struct list_head		list;
+	struct list_head		head;
 	struct completion		done;
 	struct cifs_file_info		*cfile;
 	struct address_space		*mapping;
@@ -1491,7 +1491,7 @@ struct cifs_readdata {
 /* asynchronous write support */
 struct cifs_writedata {
 	struct kref			refcount;
-	struct list_head		list;
+	struct list_head		head;
 	struct completion		done;
 	enum writeback_sync_modes	sync_mode;
 	struct work_struct		work;
@@ -1546,7 +1546,7 @@ void cifs_file_info_put(struct cifs_file_info *cifs_file);
 struct cifs_inode_info {
 	struct netfs_inode netfs; /* Netfslib context and vfs inode */
 	bool can_cache_brlcks;
-	struct list_head llist;	/* locks helb by this inode */
+	struct list_head fid_locks_list; /* locks helb by this inode */
 	/*
 	 * NOTE: Some code paths call down_read(lock_sem) twice, so
 	 * we must always use cifs_down_write() instead of down_write()
@@ -1554,8 +1554,8 @@ struct cifs_inode_info {
 	 */
 	struct rw_semaphore lock_sem;	/* protect the fields above */
 	/* BB add in lists for dirty pages i.e. write caching info for oplock */
-	struct list_head openFileList;
-	spinlock_t	open_file_lock;	/* protects openFileList */
+	struct list_head open_files_list;
+	spinlock_t open_files_lock; /* protects open_files_list */
 	__u32 cifs_attrs; /* e.g. DOS archive bit, sparse, compressed, system */
 	unsigned int oplock;		/* oplock/lease level we have */
 	unsigned int epoch;		/* used to track lease state changes */
@@ -1676,7 +1676,7 @@ typedef int (mid_handle_t)(struct cifs_server_info *server,
 
 /* one of these for every pending CIFS request to the server */
 struct mid_q_entry {
-	struct list_head qhead;	/* mids waiting on reply from this server */
+	struct list_head head;	/* mids waiting on reply from this server */
 	struct kref refcount;
 	struct cifs_server_info *server;	/* server corresponding to this mid */
 	__u64 mid;		/* multiplex id */
@@ -1912,14 +1912,14 @@ require use of the stronger protocol */
  *      updates to server->current_mid
  *  g_servers_lock protects:
  *	list operations on tcp and SMB session lists
- *  tcon->open_file_lock protects the list of open files hanging off the tcon
- *  inode->open_file_lock protects the openFileList hanging off the inode
+ *  tcon->open_files_lock protects the list of open files hanging off the tcon
+ *  inode->open_files_lock protects the open_files_list hanging off the inode
  *  cfile->file_info_lock protects counters and fields in cifs file struct
  *  f_owner.lock protects certain per file struct operations
  *  mapping->page_lock protects certain per page operations
  *
- *  Note that the cifs_tcon.open_file_lock should be taken before
- *  not after the cifs_inode_info.open_file_lock
+ *  Note that the cifs_tcon.open_files_lock should be taken before
+ *  not after the cifs_inode_info.open_files_lock
  *
  *  Semaphores
  *  ----------
@@ -1950,7 +1950,7 @@ extern struct list_head		g_servers_list;
  * protects some fields in the cifs_server_info struct such as dstaddr. Finally,
  * changes to the tcon->tidStatus should be done while holding this lock.
  * generally the locks should be taken in order g_servers_lock before
- * tcon->open_file_lock and that before file->file_info_lock since the
+ * tcon->open_files_lock and that before file->file_info_lock since the
  * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
  */
 extern spinlock_t		g_servers_lock;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index bd987f4042ca..52bbbf7274af 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -84,13 +84,13 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	spin_unlock(&g_servers_lock);
 
 	/* list all files open on tree connection and mark them invalid */
-	spin_lock(&tcon->open_file_lock);
-	list_for_each_safe(tmp, tmp1, &tcon->openFileList) {
-		open_file = list_entry(tmp, struct cifs_file_info, tlist);
+	spin_lock(&tcon->open_files_lock);
+	list_for_each_safe(tmp, tmp1, &tcon->open_files_list) {
+		open_file = list_entry(tmp, struct cifs_file_info, tcon_head);
 		open_file->invalidHandle = true;
 		open_file->oplock_break_cancelled = true;
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&tcon->open_files_lock);
 
 	mutex_lock(&tcon->crfid.fid_mutex);
 	tcon->crfid.is_valid = false;
@@ -2080,7 +2080,7 @@ cifs_writedata_direct_alloc(struct page **pages, work_func_t complete)
 	if (wdata != NULL) {
 		wdata->pages = pages;
 		kref_init(&wdata->refcount);
-		INIT_LIST_HEAD(&wdata->list);
+		INIT_LIST_HEAD(&wdata->head);
 		init_completion(&wdata->done);
 		INIT_WORK(&wdata->work, complete);
 	}
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0d0bbd2aa880..1f4fa32b7f89 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -212,7 +212,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 		return;
 	}
 
-	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->ses_list, head) {
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++)
 			ses->chans[i].server->status = SERVER_STATUS_NEED_RECONNECT;
@@ -250,7 +250,7 @@ cifs_mark_server_conns_for_reconnect(struct cifs_server_info *server,
 
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry_safe(ses, nses, &pserver->smb_ses_list, smb_ses_list) {
+	list_for_each_entry_safe(ses, nses, &pserver->ses_list, head) {
 		/* check if iface is still active */
 		if (!cifs_chan_is_iface_active(ses, server)) {
 			/*
@@ -279,7 +279,7 @@ cifs_mark_server_conns_for_reconnect(struct cifs_server_info *server,
 
 		ses->status = SES_STATUS_NEED_RECONNECT;
 
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, head) {
 			tcon->need_reconnect = true;
 			tcon->status = TCON_STATUS_NEED_RECONNECT;
 		}
@@ -324,19 +324,19 @@ cifs_abort_connection(struct cifs_server_info *server)
 	INIT_LIST_HEAD(&retry_list);
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&g_mid_lock);
-	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
+	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, head) {
 		kref_get(&mid->refcount);
 		if (mid->mid_state == MID_REQUEST_SUBMITTED)
 			mid->mid_state = MID_RETRY_NEEDED;
-		list_move(&mid->qhead, &retry_list);
+		list_move(&mid->head, &retry_list);
 		mid->mid_flags |= MID_DELETED;
 	}
 	spin_unlock(&g_mid_lock);
 	cifs_server_unlock(server);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
-	list_for_each_entry_safe(mid, nmid, &retry_list, qhead) {
-		list_del_init(&mid->qhead);
+	list_for_each_entry_safe(mid, nmid, &retry_list, head) {
+		list_del_init(&mid->head);
 		mid->callback(mid);
 		cifs_mid_q_entry_release(mid);
 	}
@@ -862,7 +862,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 		spin_unlock(&g_mid_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
-		list_del_init(&mid->qhead);
+		list_del_init(&mid->head);
 		mid->mid_flags |= MID_DELETED;
 		spin_unlock(&g_mid_lock);
 	}
@@ -909,7 +909,7 @@ static void clean_demultiplex_info(struct cifs_server_info *server)
 
 	/* take it off the list, if it's not already */
 	spin_lock(&g_servers_lock);
-	list_del_init(&server->server_head);
+	list_del_init(&server->head);
 	spin_unlock(&g_servers_lock);
 
 	cancel_delayed_work_sync(&server->echo);
@@ -950,20 +950,20 @@ static void clean_demultiplex_info(struct cifs_server_info *server)
 		INIT_LIST_HEAD(&dispose_list);
 		spin_lock(&g_mid_lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+			mid_entry = list_entry(tmp, struct mid_q_entry, head);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
 			kref_get(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
-			list_move(&mid_entry->qhead, &dispose_list);
+			list_move(&mid_entry->head, &dispose_list);
 			mid_entry->mid_flags |= MID_DELETED;
 		}
 		spin_unlock(&g_mid_lock);
 
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
+			mid_entry = list_entry(tmp, struct mid_q_entry, head);
 			cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
-			list_del_init(&mid_entry->qhead);
+			list_del_init(&mid_entry->head);
 			mid_entry->callback(mid_entry);
 			cifs_mid_q_entry_release(mid_entry);
 		}
@@ -1469,7 +1469,7 @@ cifs_find_server(struct smb3_fs_context *ctx)
 	struct cifs_server_info *server;
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
+	list_for_each_entry(server, &g_servers_list, head) {
 #ifdef CONFIG_CIFS_DFS_UPCALL
 		/*
 		 * DFS failover implementation in cifs_reconnect() requires unique tcp sessions for
@@ -1512,7 +1512,7 @@ cifs_put_server(struct cifs_server_info *server, int from_reconnect)
 
 	put_net(cifs_net_ns(server));
 
-	list_del_init(&server->server_head);
+	list_del_init(&server->head);
 	spin_unlock(&g_servers_lock);
 
 	/* For secondary channels, we pick up ref-count on the primary server */
@@ -1611,8 +1611,8 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	server->lstrp = jiffies;
 	server->compress_algorithm = cpu_to_le16(ctx->compression);
 	spin_lock_init(&server->req_lock);
-	INIT_LIST_HEAD(&server->server_head);
-	INIT_LIST_HEAD(&server->smb_ses_list);
+	INIT_LIST_HEAD(&server->head);
+	INIT_LIST_HEAD(&server->ses_list);
 	INIT_DELAYED_WORK(&server->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&server->resolve, cifs_resolve_server);
 	INIT_DELAYED_WORK(&server->reconnect, smb2_reconnect_server);
@@ -1697,7 +1697,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	server->ignore_signature = ctx->ignore_signature;
 	/* thread spawned, put it on the list */
 	spin_lock(&g_servers_lock);
-	list_add(&server->server_head, &g_servers_list);
+	list_add(&server->head, &g_servers_list);
 	spin_unlock(&g_servers_lock);
 
 	/* queue echo request delayed work */
@@ -1862,7 +1862,7 @@ cifs_find_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 	struct cifs_ses *ses;
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &server->ses_list, head) {
 		if (ses->status == SES_STATUS_EXITING)
 			continue;
 		if (!match_session(ses, ctx))
@@ -1914,7 +1914,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	}
 
 	spin_lock(&g_servers_lock);
-	list_del_init(&ses->smb_ses_list);
+	list_del_init(&ses->head);
 	spin_unlock(&g_servers_lock);
 
 	chan_count = ses->chan_count;
@@ -2220,7 +2220,7 @@ cifs_get_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 	 * need to lock before changing something in the session.
 	 */
 	spin_lock(&g_servers_lock);
-	list_add(&ses->smb_ses_list, &server->smb_ses_list);
+	list_add(&ses->head, &server->ses_list);
 	spin_unlock(&g_servers_lock);
 
 	free_xid(xid);
@@ -2260,7 +2260,7 @@ cifs_find_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	struct cifs_tcon *tcon;
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+	list_for_each_entry(tcon, &ses->tcon_list, head) {
 		if (!match_tcon(tcon, ctx))
 			continue;
 		++tcon->tc_count;
@@ -2295,7 +2295,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	/* tc_count can never go negative */
 	WARN_ON(tcon->tc_count < 0);
 
-	list_del_init(&tcon->tcon_list);
+	list_del_init(&tcon->head);
 	spin_unlock(&g_servers_lock);
 
 	/* cancel polling of interfaces */
@@ -2545,7 +2545,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
 
 	spin_lock(&g_servers_lock);
-	list_add(&tcon->tcon_list, &ses->tcon_list);
+	list_add(&tcon->head, &ses->tcon_list);
 	spin_unlock(&g_servers_lock);
 
 	return tcon;
diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index c864ca4432f0..14288096d555 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1525,12 +1525,12 @@ static void refresh_mounts(struct cifs_ses **sessions)
 	INIT_LIST_HEAD(&tcons);
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
+	list_for_each_entry(server, &g_servers_list, head) {
 		if (!server->is_dfs_conn)
 			continue;
 
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+		list_for_each_entry(ses, &server->ses_list, head) {
+			list_for_each_entry(tcon, &ses->tcon_list, head) {
 				if (!tcon->ipc && !tcon->need_reconnect) {
 					tcon->tc_count++;
 					list_add_tail(&tcon->ulist, &tcons);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c3561ac3c6d8..b4e171c6f4f6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -259,7 +259,7 @@ cifs_has_mand_locks(struct cifs_inode_info *cinode)
 	bool has_locks = false;
 
 	down_read(&cinode->lock_sem);
-	list_for_each_entry(cur, &cinode->llist, llist) {
+	list_for_each_entry(cur, &cinode->fid_locks_list, head) {
 		if (!list_empty(&cur->locks)) {
 			has_locks = true;
 			break;
@@ -302,7 +302,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 
 	INIT_LIST_HEAD(&fdlocks->locks);
 	fdlocks->cfile = cfile;
-	cfile->llist = fdlocks;
+	cfile->fid_locks = fdlocks;
 
 	cfile->count = 1;
 	cfile->pid = current->tgid;
@@ -330,28 +330,28 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 	}
 
 	cifs_down_write(&cinode->lock_sem);
-	list_add(&fdlocks->llist, &cinode->llist);
+	list_add(&fdlocks->head, &cinode->fid_locks_list);
 	up_write(&cinode->lock_sem);
 
-	spin_lock(&tcon->open_file_lock);
+	spin_lock(&tcon->open_files_lock);
 	if (fid->pending_open->oplock != CIFS_OPLOCK_NO_CHANGE && oplock)
 		oplock = fid->pending_open->oplock;
-	list_del(&fid->pending_open->olist);
+	list_del(&fid->pending_open->head);
 
 	fid->purge_cache = false;
 	server->ops->set_fid(cfile, fid, oplock);
 
-	list_add(&cfile->tlist, &tcon->openFileList);
+	list_add(&cfile->tcon_head, &tcon->open_files_list);
 	atomic_inc(&tcon->num_local_opens);
 
 	/* if readable file instance put first in list*/
-	spin_lock(&cinode->open_file_lock);
+	spin_lock(&cinode->open_files_lock);
 	if (file->f_mode & FMODE_READ)
-		list_add(&cfile->flist, &cinode->openFileList);
+		list_add(&cfile->fid_head, &cinode->open_files_list);
 	else
-		list_add_tail(&cfile->flist, &cinode->openFileList);
-	spin_unlock(&cinode->open_file_lock);
-	spin_unlock(&tcon->open_file_lock);
+		list_add_tail(&cfile->fid_head, &cinode->open_files_list);
+	spin_unlock(&cinode->open_files_lock);
+	spin_unlock(&tcon->open_files_lock);
 
 	if (fid->purge_cache)
 		cifs_zap_mapping(inode);
@@ -381,13 +381,13 @@ static void cifs_file_info_put_final(struct cifs_file_info *cifs_file)
 	 * is closed anyway.
 	 */
 	cifs_down_write(&cinode->lock_sem);
-	list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
-		list_del(&li->llist);
+	list_for_each_entry_safe(li, tmp, &cifs_file->fid_locks->locks, head) {
+		list_del(&li->head);
 		cifs_del_lock_waiters(li);
 		kfree(li);
 	}
-	list_del(&cifs_file->llist->llist);
-	kfree(cifs_file->llist);
+	list_del(&cifs_file->fid_locks->head);
+	kfree(cifs_file->fid_locks);
 	up_write(&cinode->lock_sem);
 
 	cifs_put_tlink(cifs_file->tlink);
@@ -420,8 +420,8 @@ void cifs_file_info_put(struct cifs_file_info *cifs_file)
  * _cifs_file_info_put - release a reference of file priv data
  *
  * This may involve closing the filehandle @cifs_file out on the
- * server. Must be called without holding tcon->open_file_lock,
- * cinode->open_file_lock and cifs_file->file_info_lock.
+ * server. Must be called without holding tcon->open_files_lock,
+ * cinode->open_files_lock and cifs_file->file_info_lock.
  *
  * If @wait_for_oplock_handler is true and we are releasing the last
  * reference, wait for any running oplock break handler of the file
@@ -445,13 +445,13 @@ void _cifs_file_info_put(struct cifs_file_info *cifs_file,
 	struct cifs_pending_open open;
 	bool oplock_break_cancelled;
 
-	spin_lock(&tcon->open_file_lock);
-	spin_lock(&cinode->open_file_lock);
+	spin_lock(&tcon->open_files_lock);
+	spin_lock(&cinode->open_files_lock);
 	spin_lock(&cifs_file->file_info_lock);
 	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file->file_info_lock);
-		spin_unlock(&cinode->open_file_lock);
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&cinode->open_files_lock);
+		spin_unlock(&tcon->open_files_lock);
 		return;
 	}
 	spin_unlock(&cifs_file->file_info_lock);
@@ -463,11 +463,11 @@ void _cifs_file_info_put(struct cifs_file_info *cifs_file,
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
-	list_del(&cifs_file->flist);
-	list_del(&cifs_file->tlist);
+	list_del(&cifs_file->fid_head);
+	list_del(&cifs_file->tcon_head);
 	atomic_dec(&tcon->num_local_opens);
 
-	if (list_empty(&cinode->openFileList)) {
+	if (list_empty(&cinode->open_files_list)) {
 		cifs_dbg(FYI, "closing last open instance for inode %p\n",
 			 d_inode(cifs_file->dentry));
 		/*
@@ -480,8 +480,8 @@ void _cifs_file_info_put(struct cifs_file_info *cifs_file,
 		cifs_set_oplock_level(cinode, 0);
 	}
 
-	spin_unlock(&cinode->open_file_lock);
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&cinode->open_files_lock);
+	spin_unlock(&tcon->open_files_lock);
 
 	oplock_break_cancelled = wait_oplock_handler ?
 		cancel_work_sync(&cifs_file->oplock_break) : false;
@@ -940,14 +940,14 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	INIT_LIST_HEAD(&tmp_list);
 
 	/* list all files open on tree connection, reopen resilient handles  */
-	spin_lock(&tcon->open_file_lock);
-	list_for_each_entry(open_file, &tcon->openFileList, tlist) {
+	spin_lock(&tcon->open_files_lock);
+	list_for_each_entry(open_file, &tcon->open_files_list, tcon_head) {
 		if (!open_file->invalidHandle)
 			continue;
 		cifs_file_info_get(open_file);
 		list_add_tail(&open_file->rlist, &tmp_list);
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&tcon->open_files_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
 		if (cifs_reopen_file(open_file, false /* do not flush */))
@@ -1050,7 +1050,7 @@ cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 	struct cifs_file_info *cur_cfile = fdlocks->cfile;
 	struct cifs_server_info *server = tlink_tcon(cfile->tlink)->ses->server;
 
-	list_for_each_entry(li, &fdlocks->locks, llist) {
+	list_for_each_entry(li, &fdlocks->locks, head) {
 		if (offset + length <= li->offset ||
 		    offset >= li->offset + li->length)
 			continue;
@@ -1085,7 +1085,7 @@ cifs_find_lock_conflict(struct cifs_file_info *cfile, __u64 offset, __u64 length
 	struct cifs_fid_locks *cur;
 	struct cifs_inode_info *cinode = CIFS_I(d_inode(cfile->dentry));
 
-	list_for_each_entry(cur, &cinode->llist, llist) {
+	list_for_each_entry(cur, &cinode->fid_locks_list, head) {
 		rc = cifs_find_fid_lock_conflict(cur, offset, length, type,
 						 flags, cfile, conf_lock,
 						 rw_check);
@@ -1140,7 +1140,7 @@ cifs_lock_add(struct cifs_file_info *cfile, struct cifs_lock_info *lock)
 {
 	struct cifs_inode_info *cinode = CIFS_I(d_inode(cfile->dentry));
 	cifs_down_write(&cinode->lock_sem);
-	list_add_tail(&lock->llist, &cfile->llist->locks);
+	list_add_tail(&lock->head, &cfile->fid_locks->locks);
 	up_write(&cinode->lock_sem);
 }
 
@@ -1167,7 +1167,7 @@ cifs_lock_add_if(struct cifs_file_info *cfile, struct cifs_lock_info *lock,
 					lock->type, lock->flags, &conf_lock,
 					CIFS_LOCK_OP);
 	if (!exist && cinode->can_cache_brlcks) {
-		list_add_tail(&lock->llist, &cfile->llist->locks);
+		list_add_tail(&lock->head, &cfile->fid_locks->locks);
 		up_write(&cinode->lock_sem);
 		return rc;
 	}
@@ -1291,7 +1291,7 @@ cifs_push_mandatory_locks(struct cifs_file_info *cfile)
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->fid_locks->locks, head) {
 			if (li->type != types[i])
 				continue;
 			cur->Pid = cpu_to_le16(li->pid);
@@ -1332,7 +1332,7 @@ hash_lockowner(fl_owner_t owner)
 }
 
 struct lock_to_push {
-	struct list_head llist;
+	struct list_head head;
 	__u64 offset;
 	__u64 length;
 	__u32 pid;
@@ -1377,7 +1377,7 @@ cifs_push_posix_locks(struct cifs_file_info *cfile)
 			rc = -ENOMEM;
 			goto err_out;
 		}
-		list_add_tail(&lck->llist, &locks_to_send);
+		list_add_tail(&lck->head, &locks_to_send);
 	}
 
 	el = locks_to_send.next;
@@ -1396,7 +1396,7 @@ cifs_push_posix_locks(struct cifs_file_info *cfile)
 			type = CIFS_RDLCK;
 		else
 			type = CIFS_WRLCK;
-		lck = list_entry(el, struct lock_to_push, llist);
+		lck = list_entry(el, struct lock_to_push, head);
 		lck->pid = hash_lockowner(flock->fl_owner);
 		lck->netfid = cfile->fid.netfid;
 		lck->length = length;
@@ -1405,7 +1405,7 @@ cifs_push_posix_locks(struct cifs_file_info *cfile)
 	}
 	spin_unlock(&flctx->flc_lock);
 
-	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
+	list_for_each_entry_safe(lck, tmp, &locks_to_send, head) {
 		int stored_rc;
 
 		stored_rc = CIFSSMBPosixLock(xid, tcon, lck->netfid, lck->pid,
@@ -1413,7 +1413,7 @@ cifs_push_posix_locks(struct cifs_file_info *cfile)
 					     lck->type, 0);
 		if (stored_rc)
 			rc = stored_rc;
-		list_del(&lck->llist);
+		list_del(&lck->head);
 		kfree(lck);
 	}
 
@@ -1421,8 +1421,8 @@ cifs_push_posix_locks(struct cifs_file_info *cfile)
 	free_xid(xid);
 	return rc;
 err_out:
-	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
-		list_del(&lck->llist);
+	list_for_each_entry_safe(lck, tmp, &locks_to_send, head) {
+		list_del(&lck->head);
 		kfree(lck);
 	}
 	goto out;
@@ -1583,9 +1583,9 @@ void
 cifs_free_llist(struct list_head *llist)
 {
 	struct cifs_lock_info *li, *tmp;
-	list_for_each_entry_safe(li, tmp, llist, llist) {
+	list_for_each_entry_safe(li, tmp, llist, head) {
 		cifs_del_lock_waiters(li);
-		list_del(&li->llist);
+		list_del(&li->head);
 		kfree(li);
 	}
 }
@@ -1632,7 +1632,7 @@ cifs_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 	for (i = 0; i < 2; i++) {
 		cur = buf;
 		num = 0;
-		list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
+		list_for_each_entry_safe(li, tmp, &cfile->fid_locks->locks, head) {
 			if (flock->fl_start > li->offset ||
 			    (flock->fl_start + length) <
 			    (li->offset + li->length))
@@ -1646,7 +1646,7 @@ cifs_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 				 * We can cache brlock requests - simply remove
 				 * a lock from the file's list.
 				 */
-				list_del(&li->llist);
+				list_del(&li->head);
 				cifs_del_lock_waiters(li);
 				kfree(li);
 				continue;
@@ -1661,7 +1661,7 @@ cifs_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 			 * the file's list if the unlock range request fails on
 			 * the server.
 			 */
-			list_move(&li->llist, &tmp_llist);
+			list_move(&li->head, &tmp_llist);
 			if (++num == max_num) {
 				stored_rc = cifs_lockv(xid, tcon,
 						       cfile->fid.netfid,
@@ -1673,7 +1673,7 @@ cifs_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 					 * list to the head of the file's list.
 					 */
 					cifs_move_llist(&tmp_llist,
-							&cfile->llist->locks);
+							&cfile->fid_locks->locks);
 					rc = stored_rc;
 				} else
 					/*
@@ -1691,7 +1691,7 @@ cifs_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 					       types[i], num, 0, buf);
 			if (stored_rc) {
 				cifs_move_llist(&tmp_llist,
-						&cfile->llist->locks);
+						&cfile->fid_locks->locks);
 				rc = stored_rc;
 			} else
 				cifs_free_llist(&tmp_llist);
@@ -2006,11 +2006,11 @@ struct cifs_file_info *find_readable_file(struct cifs_inode_info *cinode,
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
-	spin_lock(&cinode->open_file_lock);
+	spin_lock(&cinode->open_files_lock);
 	/* we could simply get the first_list_entry since write-only entries
 	   are always at the end of the list but since the first entry might
 	   have a close pending, we go through the whole list */
-	list_for_each_entry(open_file, &cinode->openFileList, flist) {
+	list_for_each_entry(open_file, &cinode->open_files_list, fid_head) {
 		if (fsuid_only && !uid_eq(open_file->uid, current_fsuid()))
 			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_READ) {
@@ -2018,7 +2018,7 @@ struct cifs_file_info *find_readable_file(struct cifs_inode_info *cinode,
 				/* found a good file */
 				/* lock it so it will not be closed on us */
 				cifs_file_info_get(open_file);
-				spin_unlock(&cinode->open_file_lock);
+				spin_unlock(&cinode->open_files_lock);
 				return open_file;
 			} /* else might as well continue, and look for
 			     another, or simply have the caller reopen it
@@ -2026,7 +2026,7 @@ struct cifs_file_info *find_readable_file(struct cifs_inode_info *cinode,
 		} else /* write only file */
 			break; /* write only files are last so must be done */
 	}
-	spin_unlock(&cinode->open_file_lock);
+	spin_unlock(&cinode->open_files_lock);
 	return NULL;
 }
 
@@ -2062,13 +2062,13 @@ cifs_get_writable_file(struct cifs_inode_info *cinode, int flags,
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
 		fsuid_only = false;
 
-	spin_lock(&cinode->open_file_lock);
+	spin_lock(&cinode->open_files_lock);
 refind_writable:
 	if (refind > MAX_REOPEN_ATT) {
-		spin_unlock(&cinode->open_file_lock);
+		spin_unlock(&cinode->open_files_lock);
 		return rc;
 	}
-	list_for_each_entry(open_file, &cinode->openFileList, flist) {
+	list_for_each_entry(open_file, &cinode->open_files_list, fid_head) {
 		if (!any_available && open_file->pid != current->tgid)
 			continue;
 		if (fsuid_only && !uid_eq(open_file->uid, current_fsuid()))
@@ -2079,7 +2079,7 @@ cifs_get_writable_file(struct cifs_inode_info *cinode, int flags,
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
 				cifs_file_info_get(open_file);
-				spin_unlock(&cinode->open_file_lock);
+				spin_unlock(&cinode->open_files_lock);
 				*ret_file = open_file;
 				return 0;
 			} else {
@@ -2099,7 +2099,7 @@ cifs_get_writable_file(struct cifs_inode_info *cinode, int flags,
 		cifs_file_info_get(inv_file);
 	}
 
-	spin_unlock(&cinode->open_file_lock);
+	spin_unlock(&cinode->open_files_lock);
 
 	if (inv_file) {
 		rc = cifs_reopen_file(inv_file, false);
@@ -2108,13 +2108,13 @@ cifs_get_writable_file(struct cifs_inode_info *cinode, int flags,
 			return 0;
 		}
 
-		spin_lock(&cinode->open_file_lock);
-		list_move_tail(&inv_file->flist, &cinode->openFileList);
-		spin_unlock(&cinode->open_file_lock);
+		spin_lock(&cinode->open_files_lock);
+		list_move_tail(&inv_file->fid_head, &cinode->open_files_list);
+		spin_unlock(&cinode->open_files_lock);
 		cifs_file_info_put(inv_file);
 		++refind;
 		inv_file = NULL;
-		spin_lock(&cinode->open_file_lock);
+		spin_lock(&cinode->open_files_lock);
 		goto refind_writable;
 	}
 
@@ -2144,12 +2144,12 @@ cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 
 	*ret_file = NULL;
 
-	spin_lock(&tcon->open_file_lock);
-	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+	spin_lock(&tcon->open_files_lock);
+	list_for_each_entry(cfile, &tcon->open_files_list, tcon_head) {
 		struct cifs_inode_info *cinode;
 		const char *full_path = build_path_from_dentry(cfile->dentry, page);
 		if (IS_ERR(full_path)) {
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&tcon->open_files_lock);
 			free_dentry_path(page);
 			return PTR_ERR(full_path);
 		}
@@ -2157,12 +2157,12 @@ cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 			continue;
 
 		cinode = CIFS_I(d_inode(cfile->dentry));
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&tcon->open_files_lock);
 		free_dentry_path(page);
 		return cifs_get_writable_file(cinode, flags, ret_file);
 	}
 
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&tcon->open_files_lock);
 	free_dentry_path(page);
 	return -ENOENT;
 }
@@ -2176,12 +2176,12 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 
 	*ret_file = NULL;
 
-	spin_lock(&tcon->open_file_lock);
-	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+	spin_lock(&tcon->open_files_lock);
+	list_for_each_entry(cfile, &tcon->open_files_list, tcon_head) {
 		struct cifs_inode_info *cinode;
 		const char *full_path = build_path_from_dentry(cfile->dentry, page);
 		if (IS_ERR(full_path)) {
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&tcon->open_files_lock);
 			free_dentry_path(page);
 			return PTR_ERR(full_path);
 		}
@@ -2189,13 +2189,13 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 			continue;
 
 		cinode = CIFS_I(d_inode(cfile->dentry));
-		spin_unlock(&tcon->open_file_lock);
+		spin_unlock(&tcon->open_files_lock);
 		free_dentry_path(page);
 		*ret_file = find_readable_file(cinode, 0);
 		return *ret_file ? 0 : -ENOENT;
 	}
 
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&tcon->open_files_lock);
 	free_dentry_path(page);
 	return -ENOENT;
 }
@@ -2956,7 +2956,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 
 		/* If the write was successfully sent, we are done */
 		if (!rc) {
-			list_add_tail(&wdata->list, wdata_list);
+			list_add_tail(&wdata->head, wdata_list);
 			return 0;
 		}
 
@@ -3126,7 +3126,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 			break;
 		}
 
-		list_add_tail(&wdata->list, wdata_list);
+		list_add_tail(&wdata->head, wdata_list);
 		offset += cur_len;
 		len -= cur_len;
 	} while (len > 0);
@@ -3148,7 +3148,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 
 	mutex_lock(&ctx->aio_mutex);
 
-	if (list_empty(&ctx->list)) {
+	if (list_empty(&ctx->rw_list)) {
 		mutex_unlock(&ctx->aio_mutex);
 		return;
 	}
@@ -3160,7 +3160,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	 * for any more replies.
 	 */
 restart_loop:
-	list_for_each_entry_safe(wdata, tmp, &ctx->list, list) {
+	list_for_each_entry_safe(wdata, tmp, &ctx->rw_list, head) {
 		if (!rc) {
 			if (!try_wait_for_completion(&wdata->done)) {
 				mutex_unlock(&ctx->aio_mutex);
@@ -3178,7 +3178,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 				struct iov_iter tmp_from = ctx->iter;
 
 				INIT_LIST_HEAD(&tmp_list);
-				list_del_init(&wdata->list);
+				list_del_init(&wdata->head);
 
 				if (ctx->direct_io)
 					rc = cifs_resend_wdata(
@@ -3196,11 +3196,11 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 						cifs_uncached_writedata_release);
 				}
 
-				list_splice(&tmp_list, &ctx->list);
+				list_splice(&tmp_list, &ctx->rw_list);
 				goto restart_loop;
 			}
 		}
-		list_del_init(&wdata->list);
+		list_del_init(&wdata->head);
 		kref_put(&wdata->refcount, cifs_uncached_writedata_release);
 	}
 
@@ -3278,7 +3278,7 @@ static ssize_t __cifs_writev(
 	mutex_lock(&ctx->aio_mutex);
 
 	rc = cifs_write_from_iter(iocb->ki_pos, ctx->len, &saved_from,
-				  cfile, cifs_sb, &ctx->list, ctx);
+				  cfile, cifs_sb, &ctx->rw_list, ctx);
 
 	/*
 	 * If at least one write was successfully sent, then discard any rc
@@ -3286,7 +3286,7 @@ static ssize_t __cifs_writev(
 	 * we'll end up returning whatever was written. If it fails, then
 	 * we'll get a new rc value from that.
 	 */
-	if (!list_empty(&ctx->list))
+	if (!list_empty(&ctx->rw_list))
 		rc = 0;
 
 	mutex_unlock(&ctx->aio_mutex);
@@ -3426,7 +3426,7 @@ cifs_readdata_direct_alloc(struct page **pages, work_func_t complete)
 	if (rdata != NULL) {
 		rdata->pages = pages;
 		kref_init(&rdata->refcount);
-		INIT_LIST_HEAD(&rdata->list);
+		INIT_LIST_HEAD(&rdata->head);
 		init_completion(&rdata->done);
 		INIT_WORK(&rdata->work, complete);
 	}
@@ -3690,7 +3690,7 @@ static int cifs_resend_rdata(struct cifs_readdata *rdata,
 		/* If the read was successfully sent, we are done */
 		if (!rc) {
 			/* Add to aio pending list */
-			list_add_tail(&rdata->list, rdata_list);
+			list_add_tail(&rdata->head, rdata_list);
 			return 0;
 		}
 
@@ -3842,7 +3842,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifs_file_info *open_file
 			break;
 		}
 
-		list_add_tail(&rdata->list, rdata_list);
+		list_add_tail(&rdata->head, rdata_list);
 		offset += cur_len;
 		len -= cur_len;
 	} while (len > 0);
@@ -3862,7 +3862,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 
 	mutex_lock(&ctx->aio_mutex);
 
-	if (list_empty(&ctx->list)) {
+	if (list_empty(&ctx->rw_list)) {
 		mutex_unlock(&ctx->aio_mutex);
 		return;
 	}
@@ -3870,7 +3870,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 	rc = ctx->rc;
 	/* the loop below should proceed in the order of increasing offsets */
 again:
-	list_for_each_entry_safe(rdata, tmp, &ctx->list, list) {
+	list_for_each_entry_safe(rdata, tmp, &ctx->rw_list, head) {
 		if (!rc) {
 			if (!try_wait_for_completion(&rdata->done)) {
 				mutex_unlock(&ctx->aio_mutex);
@@ -3882,7 +3882,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 				struct list_head tmp_list;
 				unsigned int got_bytes = rdata->got_bytes;
 
-				list_del_init(&rdata->list);
+				list_del_init(&rdata->head);
 				INIT_LIST_HEAD(&tmp_list);
 
 				/*
@@ -3920,7 +3920,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 						cifs_uncached_readdata_release);
 				}
 
-				list_splice(&tmp_list, &ctx->list);
+				list_splice(&tmp_list, &ctx->rw_list);
 
 				goto again;
 			} else if (rdata->result)
@@ -3934,7 +3934,7 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
 
 			ctx->total_len += rdata->got_bytes;
 		}
-		list_del_init(&rdata->list);
+		list_del_init(&rdata->head);
 		kref_put(&rdata->refcount, cifs_uncached_readdata_release);
 	}
 
@@ -4020,10 +4020,10 @@ static ssize_t __cifs_readv(
 	/* grab a lock here due to read response handlers can access ctx */
 	mutex_lock(&ctx->aio_mutex);
 
-	rc = cifs_send_async_read(offset, len, cfile, cifs_sb, &ctx->list, ctx);
+	rc = cifs_send_async_read(offset, len, cfile, cifs_sb, &ctx->rw_list, ctx);
 
 	/* if at least one read request send succeeded, then reset rc */
-	if (!list_empty(&ctx->list))
+	if (!list_empty(&ctx->rw_list))
 		rc = 0;
 
 	mutex_unlock(&ctx->aio_mutex);
@@ -4639,14 +4639,14 @@ static int is_inode_writable(struct cifs_inode_info *cinode)
 {
 	struct cifs_file_info *open_file;
 
-	spin_lock(&cinode->open_file_lock);
-	list_for_each_entry(open_file, &cinode->openFileList, flist) {
+	spin_lock(&cinode->open_files_lock);
+	list_for_each_entry(open_file, &cinode->open_files_list, fid_head) {
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
-			spin_unlock(&cinode->open_file_lock);
+			spin_unlock(&cinode->open_files_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&cinode->open_file_lock);
+	spin_unlock(&cinode->open_files_lock);
 	return 0;
 }
 
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 326c2b4cc9e2..55f4e15f876a 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -230,8 +230,8 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 		struct cifs_server_info *server_it = NULL;
 
 		spin_lock(&g_servers_lock);
-		list_for_each_entry(server_it, &g_servers_list, server_head) {
-			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(server_it, &g_servers_list, head) {
+			list_for_each_entry(ses_it, &server_it->ses_list, head) {
 				if (ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index c37ad2bb3ac4..706e47893345 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -71,7 +71,7 @@ sesInfoAlloc(void)
 		atomic_inc(&g_ses_alloc_count);
 		ret_buf->status = SES_STATUS_NEW;
 		++ret_buf->ses_count;
-		INIT_LIST_HEAD(&ret_buf->smb_ses_list);
+		INIT_LIST_HEAD(&ret_buf->head);
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
 		mutex_init(&ret_buf->session_mutex);
 		spin_lock_init(&ret_buf->iface_lock);
@@ -100,8 +100,7 @@ sesInfoFree(struct cifs_ses *buf_to_free)
 	kfree(buf_to_free->domainName);
 	kfree_sensitive(buf_to_free->auth_key.response);
 	spin_lock(&buf_to_free->iface_lock);
-	list_for_each_entry_safe(iface, niface, &buf_to_free->iface_list,
-				 iface_head)
+	list_for_each_entry_safe(iface, niface, &buf_to_free->iface_list, head)
 		kref_put(&iface->refcount, release_iface);
 	spin_unlock(&buf_to_free->iface_lock);
 	kfree_sensitive(buf_to_free);
@@ -126,9 +125,9 @@ tconInfoAlloc(void)
 	atomic_inc(&g_tcon_alloc_count);
 	ret_buf->status = TCON_STATUS_NEW;
 	++ret_buf->tc_count;
-	INIT_LIST_HEAD(&ret_buf->openFileList);
-	INIT_LIST_HEAD(&ret_buf->tcon_list);
-	spin_lock_init(&ret_buf->open_file_lock);
+	INIT_LIST_HEAD(&ret_buf->open_files_list);
+	INIT_LIST_HEAD(&ret_buf->head);
+	spin_lock_init(&ret_buf->open_files_lock);
 	mutex_init(&ret_buf->crfid.fid_mutex);
 	spin_lock_init(&ret_buf->stat_lock);
 	atomic_set(&ret_buf->num_local_opens, 0);
@@ -466,14 +465,14 @@ is_valid_oplock_break(char *buffer, struct cifs_server_info *srv)
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(ses, &srv->smb_ses_list, smb_ses_list) {
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+	list_for_each_entry(ses, &srv->ses_list, head) {
+		list_for_each_entry(tcon, &ses->tcon_list, head) {
 			if (tcon->tid != buf->Tid)
 				continue;
 
 			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
-			spin_lock(&tcon->open_file_lock);
-			list_for_each_entry(netfile, &tcon->openFileList, tlist) {
+			spin_lock(&tcon->open_files_lock);
+			list_for_each_entry(netfile, &tcon->open_files_list, tcon_head) {
 				if (pSMB->Fid != netfile->fid.netfid)
 					continue;
 
@@ -488,11 +487,11 @@ is_valid_oplock_break(char *buffer, struct cifs_server_info *srv)
 				netfile->oplock_break_cancelled = false;
 				cifs_queue_oplock_break(netfile);
 
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&tcon->open_files_lock);
 				spin_unlock(&g_servers_lock);
 				return true;
 			}
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&tcon->open_files_lock);
 			spin_unlock(&g_servers_lock);
 			cifs_dbg(FYI, "No matching file for oplock break\n");
 			return true;
@@ -598,14 +597,14 @@ void cifs_put_writer(struct cifs_inode_info *cinode)
  * This function is called from the demultiplex thread when it
  * receives an oplock break for @cfile.
  *
- * Assumes the tcon->open_file_lock is held.
+ * Assumes the tcon->open_files_lock is held.
  * Assumes cfile->file_info_lock is NOT held.
  */
 void cifs_queue_oplock_break(struct cifs_file_info *cfile)
 {
 	/*
 	 * Bump the handle refcount now while we hold the
-	 * open_file_lock to enforce the validity of it for the oplock
+	 * open_files_lock to enforce the validity of it for the oplock
 	 * break handler. The matching put is done at the end of the
 	 * handler.
 	 */
@@ -638,9 +637,9 @@ backup_cred(struct cifs_sb_info *cifs_sb)
 void
 cifs_del_pending_open(struct cifs_pending_open *open)
 {
-	spin_lock(&tlink_tcon(open->tlink)->open_file_lock);
-	list_del(&open->olist);
-	spin_unlock(&tlink_tcon(open->tlink)->open_file_lock);
+	spin_lock(&tlink_tcon(open->tlink)->open_files_lock);
+	list_del(&open->head);
+	spin_unlock(&tlink_tcon(open->tlink)->open_files_lock);
 }
 
 void
@@ -651,16 +650,16 @@ cifs_add_pending_open_locked(struct cifs_fid *fid, struct tcon_link *tlink,
 	open->oplock = CIFS_OPLOCK_NO_CHANGE;
 	open->tlink = tlink;
 	fid->pending_open = open;
-	list_add_tail(&open->olist, &tlink_tcon(tlink)->pending_opens);
+	list_add_tail(&open->head, &tlink_tcon(tlink)->pending_opens);
 }
 
 void
 cifs_add_pending_open(struct cifs_fid *fid, struct tcon_link *tlink,
 		      struct cifs_pending_open *open)
 {
-	spin_lock(&tlink_tcon(tlink)->open_file_lock);
+	spin_lock(&tlink_tcon(tlink)->open_files_lock);
 	cifs_add_pending_open_locked(fid, tlink, open);
-	spin_unlock(&tlink_tcon(open->tlink)->open_file_lock);
+	spin_unlock(&tlink_tcon(open->tlink)->open_files_lock);
 }
 
 /*
@@ -673,7 +672,7 @@ cifs_is_deferred_close(struct cifs_file_info *cfile, struct cifs_deferred_close
 {
 	struct cifs_deferred_close *dclose;
 
-	list_for_each_entry(dclose, &CIFS_I(d_inode(cfile->dentry))->deferred_closes, dlist) {
+	list_for_each_entry(dclose, &CIFS_I(d_inode(cfile->dentry))->deferred_closes, head) {
 		if ((dclose->netfid == cfile->fid.netfid) &&
 			(dclose->persistent_fid == cfile->fid.persistent_fid) &&
 			(dclose->volatile_fid == cfile->fid.volatile_fid)) {
@@ -703,7 +702,7 @@ cifs_add_deferred_close(struct cifs_file_info *cfile, struct cifs_deferred_close
 	dclose->netfid = cfile->fid.netfid;
 	dclose->persistent_fid = cfile->fid.persistent_fid;
 	dclose->volatile_fid = cfile->fid.volatile_fid;
-	list_add_tail(&dclose->dlist, &CIFS_I(d_inode(cfile->dentry))->deferred_closes);
+	list_add_tail(&dclose->head, &CIFS_I(d_inode(cfile->dentry))->deferred_closes);
 }
 
 /*
@@ -718,7 +717,7 @@ cifs_del_deferred_close(struct cifs_file_info *cfile)
 	is_deferred = cifs_is_deferred_close(cfile, &dclose);
 	if (!is_deferred)
 		return;
-	list_del(&dclose->dlist);
+	list_del(&dclose->head);
 	kfree(dclose);
 }
 
@@ -733,8 +732,8 @@ cifs_close_deferred_file(struct cifs_inode_info *cinode)
 		return;
 
 	INIT_LIST_HEAD(&file_head);
-	spin_lock(&cinode->open_file_lock);
-	list_for_each_entry(cfile, &cinode->openFileList, flist) {
+	spin_lock(&cinode->open_files_lock);
+	list_for_each_entry(cfile, &cinode->open_files_list, fid_head) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
@@ -745,7 +744,7 @@ cifs_close_deferred_file(struct cifs_inode_info *cinode)
 			}
 		}
 	}
-	spin_unlock(&cinode->open_file_lock);
+	spin_unlock(&cinode->open_files_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		_cifs_file_info_put(tmp_list->cfile, true, false);
@@ -762,8 +761,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	struct list_head file_head;
 
 	INIT_LIST_HEAD(&file_head);
-	spin_lock(&tcon->open_file_lock);
-	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+	spin_lock(&tcon->open_files_lock);
+	list_for_each_entry(cfile, &tcon->open_files_list, tcon_head) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
@@ -774,7 +773,7 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 			}
 		}
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&tcon->open_files_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		_cifs_file_info_put(tmp_list->cfile, true, false);
@@ -793,8 +792,8 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 
 	INIT_LIST_HEAD(&file_head);
 	page = alloc_dentry_path();
-	spin_lock(&tcon->open_file_lock);
-	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+	spin_lock(&tcon->open_files_lock);
+	list_for_each_entry(cfile, &tcon->open_files_list, fid_head) {
 		full_path = build_path_from_dentry(cfile->dentry, page);
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
@@ -808,7 +807,7 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 			}
 		}
 	}
-	spin_unlock(&tcon->open_file_lock);
+	spin_unlock(&tcon->open_files_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
 		_cifs_file_info_put(tmp_list->cfile, true, false);
@@ -939,7 +938,7 @@ cifs_aio_ctx_alloc(void)
 	if (!ctx)
 		return NULL;
 
-	INIT_LIST_HEAD(&ctx->list);
+	INIT_LIST_HEAD(&ctx->rw_list);
 	mutex_init(&ctx->aio_mutex);
 	init_completion(&ctx->done);
 	kref_init(&ctx->refcount);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index dbdabb83ea03..a64490c88bbd 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -846,7 +846,7 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 	struct cached_dirent *dirent;
 	int rc;
 
-	list_for_each_entry(dirent, &cde->entries, entry) {
+	list_for_each_entry(dirent, &cde->entries, head) {
 		if (ctx->pos >= dirent->pos)
 			continue;
 		ctx->pos = dirent->pos;
@@ -914,7 +914,7 @@ static void add_cached_dirent(struct cached_dirents *cde,
 
 	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
 
-	list_add_tail(&de->entry, &cde->entries);
+	list_add_tail(&de->head, &cde->entries);
 }
 
 static bool cifs_dir_emit(struct dir_context *ctx,
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index dd34b73eea97..57061394032e 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -199,7 +199,7 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 	 */
 	spin_lock(&ses->iface_lock);
 	iface = list_first_entry(&ses->iface_list, struct cifs_server_iface,
-				 iface_head);
+				 head);
 	spin_unlock(&ses->iface_lock);
 
 	while (left > 0) {
@@ -218,7 +218,7 @@ int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses)
 		}
 
 		list_for_each_entry_safe_from(iface, niface, &ses->iface_list,
-				    iface_head) {
+				    head) {
 			/* skip ifaces that are unusable */
 			if (!iface->is_active ||
 			    (is_ses_using_iface(ses, iface) &&
@@ -285,7 +285,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct cifs_server_info *server)
 
 	spin_lock(&ses->iface_lock);
 	/* then look for a new one */
-	list_for_each_entry(iface, &ses->iface_list, iface_head) {
+	list_for_each_entry(iface, &ses->iface_list, head) {
 		if (!iface->is_active ||
 		    (is_ses_using_iface(ses, iface) &&
 		     !iface->rss_capable)) {
@@ -294,7 +294,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct cifs_server_info *server)
 		kref_get(&iface->refcount);
 	}
 
-	if (!list_entry_is_head(iface, &ses->iface_list, iface_head)) {
+	if (!list_entry_is_head(iface, &ses->iface_list, head)) {
 		rc = 1;
 		iface = NULL;
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 9d63099ad26a..9a7b85e79cc8 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -93,7 +93,7 @@ cifs_find_mid(struct cifs_server_info *server, char *buffer)
 	struct mid_q_entry *mid;
 
 	spin_lock(&g_mid_lock);
-	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+	list_for_each_entry(mid, &server->pending_mid_q, head) {
 		if (compare_mid(mid->mid, buf) &&
 		    mid->mid_state == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(mid->command) == buf->Command) {
@@ -195,7 +195,7 @@ cifs_get_next_mid(struct cifs_server_info *server)
 			cur_mid++;
 
 		num_mids = 0;
-		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+		list_for_each_entry(mid_entry, &server->pending_mid_q, head) {
 			++num_mids;
 			if (mid_entry->mid == cur_mid &&
 			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 79b28a52f67e..31c1bad2e713 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -133,7 +133,7 @@ smb2_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 	cur = buf;
 
 	cifs_down_write(&cinode->lock_sem);
-	list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
+	list_for_each_entry_safe(li, tmp, &cfile->fid_locks->locks, head) {
 		if (flock->fl_start > li->offset ||
 		    (flock->fl_start + length) <
 		    (li->offset + li->length))
@@ -150,7 +150,7 @@ smb2_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 			 * We can cache brlock requests - simply remove a lock
 			 * from the file's list.
 			 */
-			list_del(&li->llist);
+			list_del(&li->head);
 			cifs_del_lock_waiters(li);
 			kfree(li);
 			continue;
@@ -162,7 +162,7 @@ smb2_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 		 * We need to save a lock here to let us add it again to the
 		 * file's list if the unlock range request fails on the server.
 		 */
-		list_move(&li->llist, &tmp_llist);
+		list_move(&li->head, &tmp_llist);
 		if (++num == max_num) {
 			stored_rc = smb2_lockv(xid, tcon,
 					       cfile->fid.persistent_fid,
@@ -175,7 +175,7 @@ smb2_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 				 * the file's list.
 				 */
 				cifs_move_llist(&tmp_llist,
-						&cfile->llist->locks);
+						&cfile->fid_locks->locks);
 				rc = stored_rc;
 			} else
 				/*
@@ -193,7 +193,7 @@ smb2_unlock_range(struct cifs_file_info *cfile, struct file_lock *flock,
 				       cfile->fid.volatile_fid, current->tgid,
 				       num, buf);
 		if (stored_rc) {
-			cifs_move_llist(&tmp_llist, &cfile->llist->locks);
+			cifs_move_llist(&tmp_llist, &cfile->fid_locks->locks);
 			rc = stored_rc;
 		} else
 			cifs_free_llist(&tmp_llist);
@@ -215,7 +215,7 @@ smb2_push_mand_fdlocks(struct cifs_fid_locks *fdlocks, const unsigned int xid,
 	struct smb2_lock_element *cur = buf;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 
-	list_for_each_entry(li, &fdlocks->locks, llist) {
+	list_for_each_entry(li, &fdlocks->locks, head) {
 		cur->Length = cpu_to_le64(li->length);
 		cur->Offset = cpu_to_le64(li->offset);
 		cur->Flags = cpu_to_le32(li->type |
@@ -275,7 +275,7 @@ smb2_push_mandatory_locks(struct cifs_file_info *cfile)
 		return -ENOMEM;
 	}
 
-	list_for_each_entry(fdlocks, &cinode->llist, llist) {
+	list_for_each_entry(fdlocks, &cinode->fid_locks_list, head) {
 		stored_rc = smb2_push_mand_fdlocks(fdlocks, xid, buf, max_num);
 		if (stored_rc)
 			rc = stored_rc;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 587362124842..6ce44c16adb1 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -154,7 +154,7 @@ smb2_check_message(char *buf, unsigned int len, struct cifs_server_info *server)
 
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&g_servers_lock);
-		list_for_each_entry(iter, &server->smb_ses_list, smb_ses_list) {
+		list_for_each_entry(iter, &server->ses_list, head) {
 			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
 				ses = iter;
 				break;
@@ -549,7 +549,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
 
 	lease_state = le32_to_cpu(rsp->NewLeaseState);
 
-	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+	list_for_each_entry(cfile, &tcon->open_files_list, tcon_head) {
 		cinode = CIFS_I(d_inode(cfile->dentry));
 
 		if (memcmp(cinode->lease_key, rsp->LeaseKey,
@@ -587,7 +587,7 @@ smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
 	struct cifs_pending_open *open;
 	struct cifs_pending_open *found = NULL;
 
-	list_for_each_entry(open, &tcon->pending_opens, olist) {
+	list_for_each_entry(open, &tcon->pending_opens, head) {
 		if (memcmp(open->lease_key, rsp->LeaseKey,
 			   SMB2_LEASE_KEY_SIZE))
 			continue;
@@ -619,14 +619,14 @@ smb2_is_valid_lease_break(char *buffer)
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-			list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-				spin_lock(&tcon->open_file_lock);
+	list_for_each_entry(server, &g_servers_list, head) {
+		list_for_each_entry(ses, &server->ses_list, head) {
+			list_for_each_entry(tcon, &ses->tcon_list, head) {
+				spin_lock(&tcon->open_files_lock);
 				cifs_stats_inc(
 				    &tcon->stats.cifs_stats.num_oplock_brks);
 				if (smb2_tcon_has_lease(tcon, rsp)) {
-					spin_unlock(&tcon->open_file_lock);
+					spin_unlock(&tcon->open_files_lock);
 					spin_unlock(&g_servers_lock);
 					return true;
 				}
@@ -639,14 +639,14 @@ smb2_is_valid_lease_break(char *buffer)
 					tlink = cifs_get_tlink(open->tlink);
 					memcpy(lease_key, open->lease_key,
 					       SMB2_LEASE_KEY_SIZE);
-					spin_unlock(&tcon->open_file_lock);
+					spin_unlock(&tcon->open_files_lock);
 					spin_unlock(&g_servers_lock);
 					smb2_queue_pending_open_break(tlink,
 								      lease_key,
 								      rsp->NewLeaseState);
 					return true;
 				}
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&tcon->open_files_lock);
 
 				if (tcon->crfid.is_valid &&
 				    !memcmp(rsp->LeaseKey,
@@ -700,11 +700,11 @@ smb2_is_valid_oplock_break(char *buffer, struct cifs_server_info *server)
 
 	/* look up tcon based on tid & uid */
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+	list_for_each_entry(ses, &server->ses_list, head) {
+		list_for_each_entry(tcon, &ses->tcon_list, head) {
 
-			spin_lock(&tcon->open_file_lock);
-			list_for_each_entry(cfile, &tcon->openFileList, tlist) {
+			spin_lock(&tcon->open_files_lock);
+			list_for_each_entry(cfile, &tcon->open_files_list, tcon_head) {
 				if (rsp->PersistentFid !=
 				    cfile->fid.persistent_fid ||
 				    rsp->VolatileFid !=
@@ -732,11 +732,11 @@ smb2_is_valid_oplock_break(char *buffer, struct cifs_server_info *server)
 
 				cifs_queue_oplock_break(cfile);
 
-				spin_unlock(&tcon->open_file_lock);
+				spin_unlock(&tcon->open_files_lock);
 				spin_unlock(&g_servers_lock);
 				return true;
 			}
-			spin_unlock(&tcon->open_file_lock);
+			spin_unlock(&tcon->open_files_lock);
 		}
 	}
 	spin_unlock(&g_servers_lock);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9d2064cf44d8..83856024fb79 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -347,13 +347,13 @@ __smb2_find_mid(struct cifs_server_info *server, char *buf, bool dequeue)
 	}
 
 	spin_lock(&g_mid_lock);
-	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+	list_for_each_entry(mid, &server->pending_mid_q, head) {
 		if ((mid->mid == wire_mid) &&
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == shdr->Command)) {
 			kref_get(&mid->refcount);
 			if (dequeue) {
-				list_del_init(&mid->qhead);
+				list_del_init(&mid->head);
 				mid->mid_flags |= MID_DELETED;
 			}
 			spin_unlock(&g_mid_lock);
@@ -536,7 +536,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	 * when the last user calls a kref_put on it
 	 */
 	list_for_each_entry_safe(iface, niface, &ses->iface_list,
-				 iface_head) {
+				 head) {
 		iface->is_active = 0;
 		kref_put(&iface->refcount, release_iface);
 	}
@@ -595,8 +595,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		 */
 		spin_lock(&ses->iface_lock);
 		iface = niface = NULL;
-		list_for_each_entry_safe(iface, niface, &ses->iface_list,
-					 iface_head) {
+		list_for_each_entry_safe(iface, niface, &ses->iface_list, head) {
 			ret = iface_cmp(iface, &tmp_iface);
 			if (!ret) {
 				/* just get a ref so that it doesn't get picked/freed */
@@ -631,11 +630,11 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			 le32_to_cpu(p->Capability));
 
 		spin_lock(&ses->iface_lock);
-		if (!list_entry_is_head(iface, &ses->iface_list, iface_head)) {
-			list_add_tail(&info->iface_head, &iface->iface_head);
+		if (!list_entry_is_head(iface, &ses->iface_list, head)) {
+			list_add_tail(&info->head, &iface->head);
 			kref_put(&iface->refcount, release_iface);
 		} else
-			list_add_tail(&info->iface_head, &ses->iface_list);
+			list_add_tail(&info->head, &ses->iface_list);
 		spin_unlock(&ses->iface_lock);
 
 		ses->iface_count++;
@@ -730,8 +729,8 @@ smb2_close_cached_fid(struct kref *ref)
 	 * Delete all cached dirent names
 	 */
 	mutex_lock(&cfid->dirents.de_mutex);
-	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
-		list_del(&dirent->entry);
+	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, head) {
+		list_del(&dirent->head);
 		kfree(dirent->name);
 		kfree(dirent);
 	}
@@ -2582,8 +2581,8 @@ smb2_is_network_name_deleted(char *buf, struct cifs_server_info *server)
 		return;
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+	list_for_each_entry(ses, &server->ses_list, head) {
+		list_for_each_entry(tcon, &ses->tcon_list, head) {
 			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				tcon->need_reconnect = true;
 				spin_unlock(&g_servers_lock);
@@ -2942,7 +2941,7 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
 		spin_lock(&g_servers_lock);
 		tcon = list_first_entry_or_null(&ses->tcon_list,
 						struct cifs_tcon,
-						tcon_list);
+						head);
 		if (tcon)
 			tcon->tc_count++;
 		spin_unlock(&g_servers_lock);
@@ -4558,8 +4557,8 @@ smb2_get_enc_key(struct cifs_server_info *server, __u64 ses_id, int enc, u8 *key
 	u8 *ses_enc_key;
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(server, &g_servers_list, server_head) {
-		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(server, &g_servers_list, head) {
+		list_for_each_entry(ses, &server->ses_list, head) {
 			if (ses->Suid == ses_id) {
 				ses_enc_key = enc ? ses->smb3encryptionkey :
 					ses->smb3decryptionkey;
@@ -5088,7 +5087,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 			} else {
 				mid->mid_state = MID_REQUEST_SUBMITTED;
 				mid->mid_flags &= ~(MID_DELETED);
-				list_add_tail(&mid->qhead,
+				list_add_tail(&mid->head,
 					&dw->server->pending_mid_q);
 				spin_unlock(&g_mid_lock);
 				spin_unlock(&g_servers_lock);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c514d405f9d0..a5e8c1ec3f92 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3804,11 +3804,11 @@ void smb2_reconnect_server(struct work_struct *work)
 	cifs_dbg(FYI, "Reconnecting tcons and channels\n");
 
 	spin_lock(&g_servers_lock);
-	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &pserver->ses_list, head) {
 
 		tcon_selected = false;
 
-		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+		list_for_each_entry(tcon, &ses->tcon_list, head) {
 			if (tcon->need_reconnect || tcon->need_reopen_files) {
 				tcon->tc_count++;
 				list_add_tail(&tcon->rlist, &tmp_list);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 5ac2dbffb939..2fa4f6d9fe7e 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -88,8 +88,8 @@ int smb2_get_sign_key(__u64 ses_id, struct cifs_server_info *server, u8 *key)
 
 	spin_lock(&g_servers_lock);
 
-	list_for_each_entry(it, &g_servers_list, server_head) {
-		list_for_each_entry(ses, &it->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(it, &g_servers_list, head) {
+		list_for_each_entry(ses, &it->ses_list, head) {
 			if (ses->Suid == ses_id)
 				goto found;
 		}
@@ -142,7 +142,7 @@ smb2_find_smb_ses_unlocked(struct cifs_server_info *server, __u64 ses_id)
 {
 	struct cifs_ses *ses;
 
-	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+	list_for_each_entry(ses, &server->ses_list, head) {
 		if (ses->Suid != ses_id)
 			continue;
 		++ses->ses_count;
@@ -169,7 +169,7 @@ smb2_find_smb_sess_tcon_unlocked(struct cifs_ses *ses, __u32  tid)
 {
 	struct cifs_tcon *tcon;
 
-	list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
+	list_for_each_entry(tcon, &ses->tcon_list, head) {
 		if (tcon->tid != tid)
 			continue;
 		++tcon->tc_count;
@@ -802,7 +802,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 	if (*mid == NULL)
 		return -ENOMEM;
 	spin_lock(&g_mid_lock);
-	list_add_tail(&(*mid)->qhead, &server->pending_mid_q);
+	list_add_tail(&(*mid)->head, &server->pending_mid_q);
 	spin_unlock(&g_mid_lock);
 
 	return 0;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 74ddf1201ab1..be2da4444731 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -169,7 +169,7 @@ cifs_delete_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&g_mid_lock);
 	if (!(mid->mid_flags & MID_DELETED)) {
-		list_del_init(&mid->qhead);
+		list_del_init(&mid->head);
 		mid->mid_flags |= MID_DELETED;
 	}
 	spin_unlock(&g_mid_lock);
@@ -749,7 +749,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	if (*ppmidQ == NULL)
 		return -ENOMEM;
 	spin_lock(&g_mid_lock);
-	list_add_tail(&(*ppmidQ)->qhead, &ses->server->pending_mid_q);
+	list_add_tail(&(*ppmidQ)->head, &ses->server->pending_mid_q);
 	spin_unlock(&g_mid_lock);
 	return 0;
 }
@@ -850,7 +850,7 @@ cifs_call_async(struct cifs_server_info *server, struct smb_rqst *rqst,
 
 	/* put it on the pending_mid_q */
 	spin_lock(&g_mid_lock);
-	list_add_tail(&mid->qhead, &server->pending_mid_q);
+	list_add_tail(&mid->head, &server->pending_mid_q);
 	spin_unlock(&g_mid_lock);
 
 	/*
@@ -928,7 +928,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct cifs_server_info *server)
 		break;
 	default:
 		if (!(mid->mid_flags & MID_DELETED)) {
-			list_del_init(&mid->qhead);
+			list_del_init(&mid->head);
 			mid->mid_flags |= MID_DELETED;
 		}
 		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
-- 
2.35.3

