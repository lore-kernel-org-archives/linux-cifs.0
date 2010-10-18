From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: update comments - [s/GlobalSMBSesLock/cifs_file_list_lock/g]
Date: Mon, 18 Oct 2010 23:52:18 +0530
Message-ID: <4CBC905A.5060007@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

GlobalSMBSesLock is now cifs_file_list_lock. Update comments to reflect this.

OTOH, isn't there is a cleaner way instead of acquiring spin_lock and doing
spin_unlock in succession in cifs_oplock_break to ensure we already grabbed
the reference? Is this really needed?

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---

 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/file.c     |    2 +-
 fs/cifs/misc.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 18ee0ad..06906ef 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -669,7 +669,7 @@ require use of the stronger protocol */
  *  GlobalMid_Lock protects:
  *	list operations on pending_mid_q and oplockQ
  *      updates to XID counters, multiplex id  and SMB sequence numbers
- *  GlobalSMBSesLock protects:
+ *  cifs_file_list_lock protects:
  *	list operations on tcp and SMB session lists and tCon lists
  *  f_owner.lock protects certain per file struct operations
  *  mapping->page_lock protects certain per page operations
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a3634e4..b06943b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2381,7 +2381,7 @@ void cifs_oplock_break(struct work_struct *work)
 	/*
 	 * We might have kicked in before is_valid_oplock_break()
 	 * finished grabbing reference for us.  Make sure it's done by
-	 * waiting for GlobalSMSSeslock.
+	 * waiting for cifs_file_list_lock.
 	 */
 	spin_lock(&cifs_file_list_lock);
 	spin_unlock(&cifs_file_list_lock);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index de6073c..0ef002f 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -587,7 +587,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				 * cifs_oplock_break_put() can't be called
 				 * from here.  Get reference after queueing
 				 * succeeded.  cifs_oplock_break() will
-				 * synchronize using GlobalSMSSeslock.
+				 * synchronize using cifs_file_list_lock.
 				 */
 				if (queue_work(system_nrt_wq,
 					       &netfile->oplock_break))
