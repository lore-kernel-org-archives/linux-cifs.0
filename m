Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF75C00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 17:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiHBR4m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 13:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiHBR4l (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 13:56:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D03222B0
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 10:56:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 304B238144;
        Tue,  2 Aug 2022 17:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659462998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NkqQx2a0aSsdfdjzhGriDJmjOkJaAA0/t5GDPfRNyWk=;
        b=M3wgEU89rnkkh4DX/H+fm+z07nn1RDFHZA9HtjLxv65lR7SBzASzGz7Wi4jZRHEEYIZNAF
        f447FCnnLaM9zuoR8V+AxRCcqxEtQyJlucAzvrbMlOreMGll9XpL/eslQjPhHr58FXmm24
        61O/RxUlTnARgiR6TOFOWObnF5c/kk4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659462998;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NkqQx2a0aSsdfdjzhGriDJmjOkJaAA0/t5GDPfRNyWk=;
        b=iSlcr27dUzcSSbiglH+pMcxDICdICLG/TvGuhuhVJkESVfQGGJ7SeoxJO3S1HNl+CFWqtz
        6/QT44WkY0VIVPDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 659911345B;
        Tue,  2 Aug 2022 17:56:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fU8CClVl6WKDSQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 02 Aug 2022 17:56:37 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: distribute some bloat out of cifsglob.h
Date:   Tue,  2 Aug 2022 14:55:08 -0300
Message-Id: <20220802175507.15708-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Distribute structs, prototypes, and inline functions into file.h,
inode.h, and the new dir.h.

Delete unused "dir_notify_req" struct from cifsglob.h

dir.h holds functions and structs related to dir operations.
cifs_fattr was moved in there for convenience, but it should be
moved to somewhere else once a proper directory structure is in place.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
In hindsight, I should've sent this as a series to my previous patch
"cifs: distribute some bloat out of cifsfs.{c,h}", as this one depends
on that previous one.

Let me know if it's better doing that.

 fs/cifs/cifsacl.c  |   1 +
 fs/cifs/cifsglob.h | 397 +--------------------------------------------
 fs/cifs/connect.c  |   2 +
 fs/cifs/dir.h      |  77 +++++++++
 fs/cifs/file.h     | 239 +++++++++++++++++++++++++++
 fs/cifs/inode.c    |   1 +
 fs/cifs/inode.h    |  69 ++++++++
 fs/cifs/readdir.c  |   1 +
 fs/cifs/smb1ops.c  |   2 +
 fs/cifs/smb2misc.c |   2 +
 fs/cifs/smb2ops.c  |   1 +
 fs/cifs/smb2pdu.h  |   1 +
 12 files changed, 401 insertions(+), 392 deletions(-)
 create mode 100644 fs/cifs/dir.h

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index fa480d62f313..5d311eead824 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -20,6 +20,7 @@
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "fs_context.h"
+#include "inode.h"
 
 /* security id for everyone/world system group */
 static const struct cifs_sid sid_everyone = {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3070407cafa7..b9f449fd9cf0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -17,14 +17,15 @@
 #include <linux/workqueue.h>
 #include <linux/utsname.h>
 #include <linux/sched/mm.h>
-#include <linux/netfs.h>
-#include "cifs_fs_sb.h"
-#include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
 #include <uapi/linux/cifs/cifs_mount.h>
-#include "../smbfs_common/smb2pdu.h"
+#include "cifs_fs_sb.h"
+#include "cifsacl.h"
 #include "smb2pdu.h"
+#include "file.h"
+#include "inode.h"
+#include "dir.h"
 
 #define SMB_PATH_MAX 260
 #define CIFS_PORT 445
@@ -219,20 +220,10 @@ struct smb_rqst {
 
 struct mid_q_entry;
 struct TCP_Server_Info;
-struct cifsFileInfo;
 struct cifs_ses;
 struct cifs_tcon;
 struct dfs_info3_param;
-struct cifs_fattr;
 struct smb3_fs_context;
-struct cifs_fid;
-struct cifs_readdata;
-struct cifs_writedata;
-struct cifs_io_parms;
-struct cifs_search_info;
-struct cifsInodeInfo;
-struct cifs_open_parms;
-struct cifs_credits;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, struct smb_rqst *,
@@ -766,11 +757,6 @@ static inline void cifs_server_unlock(struct TCP_Server_Info *server)
 	memalloc_nofs_restore(nofs_flag);
 }
 
-struct cifs_credits {
-	unsigned int value;
-	unsigned int instance;
-};
-
 static inline unsigned int
 in_flight(struct TCP_Server_Info *server)
 {
@@ -1097,73 +1083,6 @@ cap_unix(struct cifs_ses *ses)
 	return ses->server->vals->cap_unix & ses->capabilities;
 }
 
-/*
- * common struct for holding inode info when searching for or updating an
- * inode with new info
- */
-
-#define CIFS_FATTR_DFS_REFERRAL		0x1
-#define CIFS_FATTR_DELETE_PENDING	0x2
-#define CIFS_FATTR_NEED_REVAL		0x4
-#define CIFS_FATTR_INO_COLLISION	0x8
-#define CIFS_FATTR_UNKNOWN_NLINK	0x10
-#define CIFS_FATTR_FAKE_ROOT_INO	0x20
-
-struct cifs_fattr {
-	u32		cf_flags;
-	u32		cf_cifsattrs;
-	u64		cf_uniqueid;
-	u64		cf_eof;
-	u64		cf_bytes;
-	u64		cf_createtime;
-	kuid_t		cf_uid;
-	kgid_t		cf_gid;
-	umode_t		cf_mode;
-	dev_t		cf_rdev;
-	unsigned int	cf_nlink;
-	unsigned int	cf_dtype;
-	struct timespec64 cf_atime;
-	struct timespec64 cf_mtime;
-	struct timespec64 cf_ctime;
-	u32             cf_cifstag;
-};
-
-struct cached_dirent {
-	struct list_head entry;
-	char *name;
-	int namelen;
-	loff_t pos;
-
-	struct cifs_fattr fattr;
-};
-
-struct cached_dirents {
-	bool is_valid:1;
-	bool is_failed:1;
-	struct dir_context *ctx; /*
-				  * Only used to make sure we only take entries
-				  * from a single context. Never dereferenced.
-				  */
-	struct mutex de_mutex;
-	int pos;		 /* Expected ctx->pos */
-	struct list_head entries;
-};
-
-struct cached_fid {
-	bool is_valid:1;	/* Do we have a useable root fid */
-	bool file_all_info_is_valid:1;
-	bool has_lease:1;
-	unsigned long time; /* jiffies of when lease was taken */
-	struct kref refcount;
-	struct cifs_fid *fid;
-	struct mutex fid_mutex;
-	struct cifs_tcon *tcon;
-	struct dentry *dentry;
-	struct work_struct lease_break;
-	struct smb2_file_all_info file_all_info;
-	struct cached_dirents dirents;
-};
-
 /*
  * there is one of these for each connection to a resource on a particular
  * session
@@ -1311,285 +1230,6 @@ cifs_get_tlink(struct tcon_link *tlink)
 /* This function is always expected to succeed */
 extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb);
 
-#define CIFS_OPLOCK_NO_CHANGE 0xfe
-
-struct cifs_pending_open {
-	struct list_head olist;
-	struct tcon_link *tlink;
-	__u8 lease_key[16];
-	__u32 oplock;
-};
-
-struct cifs_deferred_close {
-	struct list_head dlist;
-	struct tcon_link *tlink;
-	__u16  netfid;
-	__u64  persistent_fid;
-	__u64  volatile_fid;
-};
-
-/*
- * This info hangs off the cifsFileInfo structure, pointed to by llist.
- * This is used to track byte stream locks on the file
- */
-struct cifsLockInfo {
-	struct list_head llist;	/* pointer to next cifsLockInfo */
-	struct list_head blist; /* pointer to locks blocked on this */
-	wait_queue_head_t block_q;
-	__u64 offset;
-	__u64 length;
-	__u32 pid;
-	__u16 type;
-	__u16 flags;
-};
-
-/*
- * One of these for each open instance of a file
- */
-struct cifs_search_info {
-	loff_t index_of_last_entry;
-	__u16 entries_in_buffer;
-	__u16 info_level;
-	__u32 resume_key;
-	char *ntwrk_buf_start;
-	char *srch_entries_start;
-	char *last_entry;
-	const char *presume_name;
-	unsigned int resume_name_len;
-	bool endOfSearch:1;
-	bool emptyDir:1;
-	bool unicode:1;
-	bool smallBuf:1; /* so we know which buf_release function to call */
-};
-
-#define ACL_NO_MODE	((umode_t)(-1))
-struct cifs_open_parms {
-	struct cifs_tcon *tcon;
-	struct cifs_sb_info *cifs_sb;
-	int disposition;
-	int desired_access;
-	int create_options;
-	const char *path;
-	struct cifs_fid *fid;
-	umode_t mode;
-	bool reconnect:1;
-};
-
-struct cifs_fid {
-	__u16 netfid;
-	__u64 persistent_fid;	/* persist file id for smb2 */
-	__u64 volatile_fid;	/* volatile file id for smb2 */
-	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for smb2 */
-	__u8 create_guid[16];
-	__u32 access;
-	struct cifs_pending_open *pending_open;
-	unsigned int epoch;
-#ifdef CONFIG_CIFS_DEBUG2
-	__u64 mid;
-#endif /* CIFS_DEBUG2 */
-	bool purge_cache;
-};
-
-struct cifs_fid_locks {
-	struct list_head llist;
-	struct cifsFileInfo *cfile;	/* fid that owns locks */
-	struct list_head locks;		/* locks held by fid above */
-};
-
-struct cifsFileInfo {
-	/* following two lists are protected by tcon->open_file_lock */
-	struct list_head tlist;	/* pointer to next fid owned by tcon */
-	struct list_head flist;	/* next fid (file instance) for this inode */
-	/* lock list below protected by cifsi->lock_sem */
-	struct cifs_fid_locks *llist;	/* brlocks held by this fid */
-	kuid_t uid;		/* allows finding which FileInfo structure */
-	__u32 pid;		/* process id who opened file */
-	struct cifs_fid fid;	/* file id from remote */
-	struct list_head rlist; /* reconnect list */
-	/* BB add lock scope info here if needed */ ;
-	/* lock scope id (0 if none) */
-	struct dentry *dentry;
-	struct tcon_link *tlink;
-	unsigned int f_flags;
-	bool invalidHandle:1;	/* file closed via session abend */
-	bool swapfile:1;
-	bool oplock_break_cancelled:1;
-	unsigned int oplock_epoch; /* epoch from the lease break */
-	__u32 oplock_level; /* oplock/lease level from the lease break */
-	int count;
-	spinlock_t file_info_lock; /* protects four flag/count fields above */
-	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
-	struct cifs_search_info srch_inf;
-	struct work_struct oplock_break; /* work for oplock breaks */
-	struct work_struct put; /* work for the final part of _put */
-	struct delayed_work deferred;
-	bool deferred_close_scheduled; /* Flag to indicate close is scheduled */
-};
-
-struct cifs_io_parms {
-	__u16 netfid;
-	__u64 persistent_fid;	/* persist file id for smb2 */
-	__u64 volatile_fid;	/* volatile file id for smb2 */
-	__u32 pid;
-	__u64 offset;
-	unsigned int length;
-	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
-};
-
-struct cifs_aio_ctx {
-	struct kref		refcount;
-	struct list_head	list;
-	struct mutex		aio_mutex;
-	struct completion	done;
-	struct iov_iter		iter;
-	struct kiocb		*iocb;
-	struct cifsFileInfo	*cfile;
-	struct bio_vec		*bv;
-	loff_t			pos;
-	unsigned int		npages;
-	ssize_t			rc;
-	unsigned int		len;
-	unsigned int		total_len;
-	bool			should_dirty;
-	/*
-	 * Indicates if this aio_ctx is for direct_io,
-	 * If yes, iter is a copy of the user passed iov_iter
-	 */
-	bool			direct_io;
-};
-
-/* asynchronous read support */
-struct cifs_readdata {
-	struct kref			refcount;
-	struct list_head		list;
-	struct completion		done;
-	struct cifsFileInfo		*cfile;
-	struct address_space		*mapping;
-	struct cifs_aio_ctx		*ctx;
-	__u64				offset;
-	unsigned int			bytes;
-	unsigned int			got_bytes;
-	pid_t				pid;
-	int				result;
-	struct work_struct		work;
-	int (*read_into_pages)(struct TCP_Server_Info *server,
-				struct cifs_readdata *rdata,
-				unsigned int len);
-	int (*copy_into_pages)(struct TCP_Server_Info *server,
-				struct cifs_readdata *rdata,
-				struct iov_iter *iter);
-	struct kvec			iov[2];
-	struct TCP_Server_Info		*server;
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	struct smbd_mr			*mr;
-#endif
-	unsigned int			pagesz;
-	unsigned int			page_offset;
-	unsigned int			tailsz;
-	struct cifs_credits		credits;
-	unsigned int			nr_pages;
-	struct page			**pages;
-};
-
-/* asynchronous write support */
-struct cifs_writedata {
-	struct kref			refcount;
-	struct list_head		list;
-	struct completion		done;
-	enum writeback_sync_modes	sync_mode;
-	struct work_struct		work;
-	struct cifsFileInfo		*cfile;
-	struct cifs_aio_ctx		*ctx;
-	__u64				offset;
-	pid_t				pid;
-	unsigned int			bytes;
-	int				result;
-	struct TCP_Server_Info		*server;
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	struct smbd_mr			*mr;
-#endif
-	unsigned int			pagesz;
-	unsigned int			page_offset;
-	unsigned int			tailsz;
-	struct cifs_credits		credits;
-	unsigned int			nr_pages;
-	struct page			**pages;
-};
-
-/*
- * Take a reference on the file private data. Must be called with
- * cfile->file_info_lock held.
- */
-static inline void
-cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
-{
-	++cifs_file->count;
-}
-
-struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
-void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_hdlr,
-		       bool offload);
-void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
-
-#define CIFS_CACHE_READ_FLG	1
-#define CIFS_CACHE_HANDLE_FLG	2
-#define CIFS_CACHE_RH_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE_FLG	4
-#define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
-#define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
-
-#define CIFS_CACHE_READ(cinode) ((cinode->oplock & CIFS_CACHE_READ_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
-#define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
-#define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
-
-/*
- * One of these for each file inode
- */
-
-struct cifsInodeInfo {
-	struct netfs_inode netfs; /* Netfslib context and vfs inode */
-	bool can_cache_brlcks;
-	struct list_head llist;	/* locks helb by this inode */
-	/*
-	 * NOTE: Some code paths call down_read(lock_sem) twice, so
-	 * we must always use cifs_down_write() instead of down_write()
-	 * for this semaphore to avoid deadlocks.
-	 */
-	struct rw_semaphore lock_sem;	/* protect the fields above */
-	/* BB add in lists for dirty pages i.e. write caching info for oplock */
-	struct list_head openFileList;
-	spinlock_t	open_file_lock;	/* protects openFileList */
-	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
-	unsigned int oplock;		/* oplock/lease level we have */
-	unsigned int epoch;		/* used to track lease state changes */
-#define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
-#define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
-#define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
-#define CIFS_INO_DELETE_PENDING		  (3) /* delete pending on server */
-#define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
-#define CIFS_INO_LOCK			  (5) /* lock bit for synchronization */
-#define CIFS_INO_MODIFIED_ATTR            (6) /* Indicate change in mtime/ctime */
-#define CIFS_INO_CLOSE_ON_LOCK            (7) /* Not to defer the close when lock is set */
-	unsigned long flags;
-	spinlock_t writers_lock;
-	unsigned int writers;		/* Number of writers on this inode */
-	unsigned long time;		/* jiffies of last update of inode */
-	u64  server_eof;		/* current file size on server -- protected by i_lock */
-	u64  uniqueid;			/* server inode number */
-	u64  createtime;		/* creation time on server */
-	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for this inode */
-	struct list_head deferred_closes; /* list of deferred closes */
-	spinlock_t deferred_lock; /* protection on deferred list */
-	bool lease_granted; /* Flag to indicate whether lease or oplock is granted. */
-};
-
-static inline struct cifsInodeInfo *
-CIFS_I(struct inode *inode)
-{
-	return container_of(inode, struct cifsInodeInfo, netfs.inode);
-}
-
 static inline struct cifs_sb_info *
 CIFS_SB(struct super_block *sb)
 {
@@ -1710,14 +1350,6 @@ struct mid_q_entry {
 	bool decrypted:1;	/* decrypted entry */
 };
 
-struct close_cancelled_open {
-	struct cifs_fid         fid;
-	struct cifs_tcon        *tcon;
-	struct work_struct      work;
-	__u64 mid;
-	__u16 cmd;
-};
-
 /*	Make code in transport.c a little cleaner by moving
 	update of optional stats into function below */
 static inline void cifs_in_send_inc(struct TCP_Server_Info *server)
@@ -1751,20 +1383,6 @@ static inline void cifs_save_when_sent(struct mid_q_entry *mid)
 }
 #endif
 
-/* for pending dnotify requests */
-struct dir_notify_req {
-	struct list_head lhead;
-	__le16 Pid;
-	__le16 PidHigh;
-	__u16 Mid;
-	__u16 Tid;
-	__u16 Uid;
-	__u16 netfid;
-	__u32 filter; /* CompletionFilter (for multishot) */
-	int multishot;
-	struct file *pfile;
-};
-
 struct dfs_info3_param {
 	int flags; /* DFSREF_REFERRAL_SERVER, DFSREF_STORAGE_SERVER*/
 	int path_consumed;
@@ -1775,11 +1393,6 @@ struct dfs_info3_param {
 	int ttl;
 };
 
-struct file_list {
-	struct list_head list;
-	struct cifsFileInfo *cfile;
-};
-
 static inline void free_dfs_info_param(struct dfs_info3_param *param)
 {
 	if (param) {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index abb65dd7471f..cf393e97e44b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -34,6 +34,8 @@
 #include <linux/bvec.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
+#include "file.h"
+#include "inode.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
diff --git a/fs/cifs/dir.h b/fs/cifs/dir.h
new file mode 100644
index 000000000000..df6997e2886a
--- /dev/null
+++ b/fs/cifs/dir.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Routines related to dir operations
+ */
+#ifndef _CIFS_DIR_H
+#define _CIFS_DIR_H
+
+#include <linux/fs.h>
+
+/*
+ * common struct for holding inode info when searching for or updating an
+ * inode with new info
+ */
+
+#define CIFS_FATTR_DFS_REFERRAL		0x1
+#define CIFS_FATTR_DELETE_PENDING	0x2
+#define CIFS_FATTR_NEED_REVAL		0x4
+#define CIFS_FATTR_INO_COLLISION	0x8
+#define CIFS_FATTR_UNKNOWN_NLINK	0x10
+#define CIFS_FATTR_FAKE_ROOT_INO	0x20
+
+/* XXX: this probably doesn't belong here */
+struct cifs_fattr {
+	u32		cf_flags;
+	u32		cf_cifsattrs;
+	u64		cf_uniqueid;
+	u64		cf_eof;
+	u64		cf_bytes;
+	u64		cf_createtime;
+	kuid_t		cf_uid;
+	kgid_t		cf_gid;
+	umode_t		cf_mode;
+	dev_t		cf_rdev;
+	unsigned int	cf_nlink;
+	unsigned int	cf_dtype;
+	struct timespec64 cf_atime;
+	struct timespec64 cf_mtime;
+	struct timespec64 cf_ctime;
+	u32             cf_cifstag;
+};
+
+struct cached_dirent {
+	struct list_head entry;
+	char *name;
+	int namelen;
+	loff_t pos;
+
+	struct cifs_fattr fattr;
+};
+
+struct cached_dirents {
+	bool is_valid:1;
+	bool is_failed:1;
+	struct dir_context *ctx; /*
+				  * Only used to make sure we only take entries
+				  * from a single context. Never dereferenced.
+				  */
+	struct mutex de_mutex;
+	int pos;		 /* Expected ctx->pos */
+	struct list_head entries;
+};
+
+struct cached_fid {
+	bool is_valid:1;	/* Do we have a useable root fid */
+	bool file_all_info_is_valid:1;
+	bool has_lease:1;
+	unsigned long time; /* jiffies of when lease was taken */
+	struct kref refcount;
+	struct cifs_fid *fid;
+	struct mutex fid_mutex;
+	struct cifs_tcon *tcon;
+	struct dentry *dentry;
+	struct work_struct lease_break;
+	struct smb2_file_all_info file_all_info;
+	struct cached_dirents dirents;
+};
+#endif /* _CIFS_DIR_H */
diff --git a/fs/cifs/file.h b/fs/cifs/file.h
index 943dfa512f41..09fd31d3c8bd 100644
--- a/fs/cifs/file.h
+++ b/fs/cifs/file.h
@@ -5,6 +5,236 @@
 #ifndef _CIFS_FILE_H
 #define _CIFS_FILE_H
 
+#include <linux/scatterlist.h>
+#include <linux/writeback.h>
+#include <linux/uio.h>
+#include "../smbfs_common/smb2pdu.h"
+
+#define CIFS_OPLOCK_NO_CHANGE 0xfe
+
+struct cifs_pending_open {
+	struct list_head olist;
+	struct tcon_link *tlink;
+	__u8 lease_key[16];
+	__u32 oplock;
+};
+
+struct cifs_deferred_close {
+	struct list_head dlist;
+	struct tcon_link *tlink;
+	__u16  netfid;
+	__u64  persistent_fid;
+	__u64  volatile_fid;
+};
+
+struct cifs_fid {
+	__u16 netfid;
+	__u64 persistent_fid;	/* persist file id for smb2 */
+	__u64 volatile_fid;	/* volatile file id for smb2 */
+	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for smb2 */
+	__u8 create_guid[16];
+	__u32 access;
+	struct cifs_pending_open *pending_open;
+	unsigned int epoch;
+#ifdef CONFIG_CIFS_DEBUG2
+	__u64 mid;
+#endif /* CIFS_DEBUG2 */
+	bool purge_cache;
+};
+
+struct close_cancelled_open {
+	struct cifs_fid         fid;
+	struct cifs_tcon        *tcon;
+	struct work_struct      work;
+	__u64 mid;
+	__u16 cmd;
+};
+
+/*
+ * One of these for each open instance of a file
+ */
+struct cifs_search_info {
+	loff_t index_of_last_entry;
+	__u16 entries_in_buffer;
+	__u16 info_level;
+	__u32 resume_key;
+	char *ntwrk_buf_start;
+	char *srch_entries_start;
+	char *last_entry;
+	const char *presume_name;
+	unsigned int resume_name_len;
+	bool endOfSearch:1;
+	bool emptyDir:1;
+	bool unicode:1;
+	bool smallBuf:1; /* so we know which buf_release function to call */
+};
+
+struct cifsFileInfo {
+	/* following two lists are protected by tcon->open_file_lock */
+	struct list_head tlist;	/* pointer to next fid owned by tcon */
+	struct list_head flist;	/* next fid (file instance) for this inode */
+	/* lock list below protected by cifsi->lock_sem */
+	struct cifs_fid_locks *llist;	/* brlocks held by this fid */
+	kuid_t uid;		/* allows finding which FileInfo structure */
+	__u32 pid;		/* process id who opened file */
+	struct cifs_fid fid;	/* file id from remote */
+	struct list_head rlist; /* reconnect list */
+	/* BB add lock scope info here if needed */ ;
+	/* lock scope id (0 if none) */
+	struct dentry *dentry;
+	struct tcon_link *tlink;
+	unsigned int f_flags;
+	bool invalidHandle:1;	/* file closed via session abend */
+	bool swapfile:1;
+	bool oplock_break_cancelled:1;
+	unsigned int oplock_epoch; /* epoch from the lease break */
+	__u32 oplock_level; /* oplock/lease level from the lease break */
+	int count;
+	spinlock_t file_info_lock; /* protects four flag/count fields above */
+	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
+	struct cifs_search_info srch_inf;
+	struct work_struct oplock_break; /* work for oplock breaks */
+	struct work_struct put; /* work for the final part of _put */
+	struct delayed_work deferred;
+	bool deferred_close_scheduled; /* Flag to indicate close is scheduled */
+};
+
+struct cifs_fid_locks {
+	struct list_head llist;
+	struct cifsFileInfo *cfile;	/* fid that owns locks */
+	struct list_head locks;		/* locks held by fid above */
+};
+
+struct cifs_io_parms {
+	__u16 netfid;
+	__u64 persistent_fid;	/* persist file id for smb2 */
+	__u64 volatile_fid;	/* volatile file id for smb2 */
+	__u32 pid;
+	__u64 offset;
+	unsigned int length;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+};
+
+struct cifs_aio_ctx {
+	struct kref		refcount;
+	struct list_head	list;
+	struct mutex		aio_mutex;
+	struct completion	done;
+	struct iov_iter		iter;
+	struct kiocb		*iocb;
+	struct cifsFileInfo	*cfile;
+	struct bio_vec		*bv;
+	loff_t			pos;
+	unsigned int		npages;
+	ssize_t			rc;
+	unsigned int		len;
+	unsigned int		total_len;
+	bool			should_dirty;
+	/*
+	 * Indicates if this aio_ctx is for direct_io,
+	 * If yes, iter is a copy of the user passed iov_iter
+	 */
+	bool			direct_io;
+};
+
+/* XXX: move this to something server-related later */
+struct cifs_credits {
+	unsigned int value;
+	unsigned int instance;
+};
+
+/* asynchronous read support */
+struct cifs_readdata {
+	struct kref			refcount;
+	struct list_head		list;
+	struct completion		done;
+	struct cifsFileInfo		*cfile;
+	struct address_space		*mapping;
+	struct cifs_aio_ctx		*ctx;
+	__u64				offset;
+	unsigned int			bytes;
+	unsigned int			got_bytes;
+	pid_t				pid;
+	int				result;
+	struct work_struct		work;
+	int (*read_into_pages)(struct TCP_Server_Info *server,
+				struct cifs_readdata *rdata,
+				unsigned int len);
+	int (*copy_into_pages)(struct TCP_Server_Info *server,
+				struct cifs_readdata *rdata,
+				struct iov_iter *iter);
+	struct kvec			iov[2];
+	struct TCP_Server_Info		*server;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	struct smbd_mr			*mr;
+#endif
+	unsigned int			pagesz;
+	unsigned int			page_offset;
+	unsigned int			tailsz;
+	struct cifs_credits		credits;
+	unsigned int			nr_pages;
+	struct page			**pages;
+};
+
+/* asynchronous write support */
+struct cifs_writedata {
+	struct kref			refcount;
+	struct list_head		list;
+	struct completion		done;
+	enum writeback_sync_modes	sync_mode;
+	struct work_struct		work;
+	struct cifsFileInfo		*cfile;
+	struct cifs_aio_ctx		*ctx;
+	__u64				offset;
+	pid_t				pid;
+	unsigned int			bytes;
+	int				result;
+	struct TCP_Server_Info		*server;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	struct smbd_mr			*mr;
+#endif
+	unsigned int			pagesz;
+	unsigned int			page_offset;
+	unsigned int			tailsz;
+	struct cifs_credits		credits;
+	unsigned int			nr_pages;
+	struct page			**pages;
+};
+
+struct file_list {
+	struct list_head list;
+	struct cifsFileInfo *cfile;
+};
+
+/*
+ * This info hangs off the cifsFileInfo structure, pointed to by llist.
+ * This is used to track byte stream locks on the file
+ */
+struct cifsLockInfo {
+	struct list_head llist;	/* pointer to next cifsLockInfo */
+	struct list_head blist; /* pointer to locks blocked on this */
+	wait_queue_head_t block_q;
+	__u64 offset;
+	__u64 length;
+	__u32 pid;
+	__u16 type;
+	__u16 flags;
+};
+
+#define ACL_NO_MODE	((umode_t)(-1))
+struct cifs_open_parms {
+	struct cifs_tcon *tcon;
+	struct cifs_sb_info *cifs_sb;
+	int disposition;
+	int desired_access;
+	int create_options;
+	const char *path;
+	struct cifs_fid *fid;
+	umode_t mode;
+	bool reconnect:1;
+};
+
 extern const struct file_operations cifs_file_ops;
 extern const struct file_operations cifs_file_direct_ops; /* if directio mnt */
 extern const struct file_operations cifs_file_strict_ops; /* if strictio mnt */
@@ -35,4 +265,13 @@ ssize_t cifs_user_readv(struct kiocb *, struct iov_iter *);
 ssize_t cifs_strict_readv(struct kiocb *, struct iov_iter *);
 int cifs_file_strict_mmap(struct file *, struct vm_area_struct *);
 int cifs_file_mmap(struct file *, struct vm_area_struct *);
+
+/*
+ * Take a reference on the file private data. Must be called with
+ * cfile->file_info_lock held.
+ */
+static inline void cifsFileInfo_get_locked(struct cifsFileInfo *cifs_file)
+{
+	++cifs_file->count;
+}
 #endif /* _CIFS_FILE_H */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 9c20e09cf00f..746754903fc0 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -26,6 +26,7 @@
 #include "fs_context.h"
 #include "cifs_ioctl.h"
 #include "inode.h"
+#include "dir.h"
 
 extern const struct inode_operations cifs_dfs_referral_inode_operations;
 
diff --git a/fs/cifs/inode.h b/fs/cifs/inode.h
index 5fe93ae79232..febddffd8b01 100644
--- a/fs/cifs/inode.h
+++ b/fs/cifs/inode.h
@@ -4,7 +4,66 @@
  */
 #ifndef _CIFS_INODE_H
 #define _CIFS_INODE_H
+
 #include <linux/fs.h>
+#include <linux/netfs.h>
+#include "../smbfs_common/smb2pdu.h"
+
+#define CIFS_CACHE_READ_FLG	1
+#define CIFS_CACHE_HANDLE_FLG	2
+#define CIFS_CACHE_RH_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_HANDLE_FLG)
+#define CIFS_CACHE_WRITE_FLG	4
+#define CIFS_CACHE_RW_FLG	(CIFS_CACHE_READ_FLG | CIFS_CACHE_WRITE_FLG)
+#define CIFS_CACHE_RHW_FLG	(CIFS_CACHE_RW_FLG | CIFS_CACHE_HANDLE_FLG)
+
+#define CIFS_CACHE_READ(cinode) \
+	((cinode->oplock & CIFS_CACHE_READ_FLG) || \
+	 (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RO_CACHE))
+#define CIFS_CACHE_HANDLE(cinode) \
+	(cinode->oplock & CIFS_CACHE_HANDLE_FLG)
+#define CIFS_CACHE_WRITE(cinode) \
+	((cinode->oplock & CIFS_CACHE_WRITE_FLG) || \
+	 (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
+
+/*
+ * One of these for each file inode
+ */
+struct cifsInodeInfo {
+	struct netfs_inode netfs; /* Netfslib context and vfs inode */
+	bool can_cache_brlcks;
+	struct list_head llist;	/* locks helb by this inode */
+	/*
+	 * NOTE: Some code paths call down_read(lock_sem) twice, so
+	 * we must always use cifs_down_write() instead of down_write()
+	 * for this semaphore to avoid deadlocks.
+	 */
+	struct rw_semaphore lock_sem;	/* protect the fields above */
+	/* BB add in lists for dirty pages i.e. write caching info for oplock */
+	struct list_head openFileList;
+	spinlock_t	open_file_lock;	/* protects openFileList */
+	__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, compressed, system */
+	unsigned int oplock;		/* oplock/lease level we have */
+	unsigned int epoch;		/* used to track lease state changes */
+#define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
+#define CIFS_INODE_PENDING_WRITERS	  (1) /* Writes in progress */
+#define CIFS_INODE_FLAG_UNUSED		  (2) /* Unused flag */
+#define CIFS_INO_DELETE_PENDING		  (3) /* delete pending on server */
+#define CIFS_INO_INVALID_MAPPING	  (4) /* pagecache is invalid */
+#define CIFS_INO_LOCK			  (5) /* lock bit for synchronization */
+#define CIFS_INO_MODIFIED_ATTR            (6) /* Indicate change in mtime/ctime */
+#define CIFS_INO_CLOSE_ON_LOCK            (7) /* Not to defer the close when lock is set */
+	unsigned long flags;
+	spinlock_t writers_lock;
+	unsigned int writers;		/* Number of writers on this inode */
+	unsigned long time;		/* jiffies of last update of inode */
+	u64  server_eof;		/* current file size on server -- protected by i_lock */
+	u64  uniqueid;			/* server inode number */
+	u64  createtime;		/* creation time on server */
+	__u8 lease_key[SMB2_LEASE_KEY_SIZE];	/* lease key for this inode */
+	struct list_head deferred_closes; /* list of deferred closes */
+	spinlock_t deferred_lock; /* protection on deferred list */
+	bool lease_granted; /* Flag to indicate whether lease or oplock is granted. */
+};
 
 extern void cifs_setsize(struct inode *, loff_t);
 extern int cifs_truncate_page(struct address_space *, loff_t);
@@ -29,4 +88,14 @@ int cifs_create(struct user_namespace *, struct inode *, struct dentry *,
 		umode_t, bool);
 int cifs_atomic_open(struct inode *, struct dentry *, struct file *,
 		     unsigned, umode_t);
+
+struct cifsFileInfo *cifsFileInfo_get(struct cifsFileInfo *cifs_file);
+void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_hdlr,
+		       bool offload);
+void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
+
+static inline struct cifsInodeInfo *CIFS_I(struct inode *inode)
+{
+	return container_of(inode, struct cifsInodeInfo, netfs.inode);
+}
 #endif /* _CIFS_INODE_H */
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 384cabdf47ca..5c92970e9312 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -21,6 +21,7 @@
 #include "cifsfs.h"
 #include "smb2proto.h"
 #include "fs_context.h"
+#include "dir.h"
 
 /*
  * To be safe - for UCS to UTF-8 with strings loaded with the rare long
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index f36b2d2d40ca..7b5b62815a0d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -14,6 +14,8 @@
 #include "cifspdu.h"
 #include "cifs_unicode.h"
 #include "fs_context.h"
+#include "file.h"
+#include "inode.h"
 
 /*
  * An NT cancel request header looks just like the original request except:
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 818cc4dee0e2..cf57e85a3e69 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -16,6 +16,8 @@
 #include "smb2status.h"
 #include "smb2glob.h"
 #include "nterr.h"
+#include "file.h"
+#include "inode.h"
 
 static int
 check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 82dd2e973753..7ccacefdab3b 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -27,6 +27,7 @@
 #include "smbdirect.h"
 #include "fscache.h"
 #include "fs_context.h"
+#include "dir.h"
 
 /* Change credits for different ops and return the total number of credits */
 static int
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f57881b8464f..ef19306c52a1 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -12,6 +12,7 @@
 #define _SMB2PDU_H
 
 #include <net/sock.h>
+#include "../smbfs_common/smb2pdu.h"
 #include "cifsacl.h"
 
 /* 52 transform hdr + 64 hdr + 88 create rsp */
-- 
2.35.3

