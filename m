From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/3] cifs: add new module parameter 'enable_oplocks'
Date: Tue, 11 Oct 2011 21:28:00 +0530
Message-ID: <4E946788.3060101@suse.de>
Reply-To: sjayaraman-l3A5Bk7waGM@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thus spake Jeff Layton:

"Making that a module parm would allow you to set that parameter at boot
time without needing to add special startup scripts. IMO, all of the
procfile "switches" under /proc/fs/cifs should be module parms
instead."

This patch doesn't alter the default behavior (Oplocks are enabled by
default).

To disable oplocks when loading the module, use
 
   modprobe cifs enable_oplocks=0

(any of '0' or 'n' or 'N' conventions can be used).

To disable oplocks at runtime using the new interface, use

   echo 0 > /sys/module/cifs/parameters/enable_oplocks

The older /proc/fs/cifs/OplockEnabled interface will be deprecated
after two releases. A subsequent patch will add an warning message
about the deprecation.

Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsfs.c   |    5 +++++
 fs/cifs/cifsglob.h |    3 +++
 fs/cifs/dir.c      |    2 +-
 fs/cifs/file.c     |    4 ++--
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3e29899..675ab40 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -81,6 +81,11 @@ module_param(echo_retries, ushort, 0644);
 MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
 			       "reconnecting server. Default: 5. 0 means "
 			       "never reconnect.");
+unsigned int enable_oplocks = 1;
+module_param(enable_oplocks, bool, 0644);
+MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default:"
+				 "y/Y/1");
+
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 6255fa8..b3e229c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -936,6 +936,9 @@ GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 /* reconnect after this many failed echo attempts */
 GLOBAL_EXTERN unsigned short echo_retries;
 
+/* enable or disable oplocks */
+GLOBAL_EXTERN unsigned int enable_oplocks;
+
 GLOBAL_EXTERN struct rb_root uidtree;
 GLOBAL_EXTERN struct rb_root gidtree;
 GLOBAL_EXTERN spinlock_t siduidlock;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 81914df..6529b69 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -165,7 +165,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
 	}
 	tcon = tlink_tcon(tlink);
 
-	if (oplockEnabled)
+	if (oplockEnabled || enable_oplocks)
 		oplock = REQ_OPLOCK;
 
 	if (nd && (nd->flags & LOOKUP_OPEN))
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index bb71471..b76c31d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -369,7 +369,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
 		 inode, file->f_flags, full_path);
 
-	if (oplockEnabled)
+	if (oplockEnabled || enable_oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
@@ -493,7 +493,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
 		 inode, pCifsFile->f_flags, full_path);
 
-	if (oplockEnabled)
+	if (oplockEnabled || enable_oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
