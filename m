From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH] cifs: stuff the fl_owner into "pid" field in the lock request
Date: Tue, 24 May 2016 06:27:44 -0400
Message-ID: <1464085664-4391-1-git-send-email-jeff.layton@primarydata.com>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Right now, we send the tgid cross the wire. What we really want to send
though is a hashed fl_owner_t since samba treats this field as a generic
lockowner.

It turns out that because we enforce and release locks locally before
they are ever sent to the server, this patch makes no difference in
behavior. Still, setting OFD locks on the server using the process
pid seems wrong, so I think this patch still makes sense.

Signed-off-by: Jeff Layton <jeff.layton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsfs.c   |  3 +++
 fs/cifs/cifsglob.h |  1 +
 fs/cifs/file.c     | 14 +++++++++++---
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 08fa36e5b2bc..1ef5b8aee878 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -87,6 +87,7 @@ extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
 
 struct workqueue_struct	*cifsiod_wq;
+__u32 cifs_lock_secret;
 
 /*
  * Bumps refcount for cifs super block.
@@ -1271,6 +1272,8 @@ init_cifs(void)
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
+	get_random_bytes(&cifs_lock_secret, sizeof(cifs_lock_secret));
+
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
 		cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bba106cdc43c..8f1d8c1e72be 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1619,6 +1619,7 @@ void cifs_oplock_break(struct work_struct *work);
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
 extern struct workqueue_struct *cifsiod_wq;
+extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_mid_poolp;
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 9793ae0bcaa2..d4890b6dc22d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1112,6 +1112,12 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	return rc;
 }
 
+static __u32
+hash_lockowner(fl_owner_t owner)
+{
+	return cifs_lock_secret ^ hash32_ptr((const void *)owner);
+}
+
 struct lock_to_push {
 	struct list_head llist;
 	__u64 offset;
@@ -1178,7 +1184,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		else
 			type = CIFS_WRLCK;
 		lck = list_entry(el, struct lock_to_push, llist);
-		lck->pid = flock->fl_pid;
+		lck->pid = hash_lockowner(flock->fl_owner);
 		lck->netfid = cfile->fid.netfid;
 		lck->length = length;
 		lck->type = type;
@@ -1305,7 +1311,8 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
 			posix_lock_type = CIFS_RDLCK;
 		else
 			posix_lock_type = CIFS_WRLCK;
-		rc = CIFSSMBPosixLock(xid, tcon, netfid, current->tgid,
+		rc = CIFSSMBPosixLock(xid, tcon, netfid,
+				      hash_lockowner(flock->fl_owner),
 				      flock->fl_start, length, flock,
 				      posix_lock_type, wait_flag);
 		return rc;
@@ -1505,7 +1512,8 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 			posix_lock_type = CIFS_UNLCK;
 
 		rc = CIFSSMBPosixLock(xid, tcon, cfile->fid.netfid,
-				      current->tgid, flock->fl_start, length,
+				      hash_lockowner(flock->fl_owner),
+				      flock->fl_start, length,
 				      NULL, posix_lock_type, wait_flag);
 		goto out;
 	}
-- 
2.5.5
