From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: make cifs_ioctl handle NULL filp->private_data correctly
Date: Mon,  8 Nov 2010 07:28:32 -0500
Message-ID: <1289219312-21396-1-git-send-email-jlayton@redhat.com>
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, kjella79-eZNTXLQAfP4@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 13cfb7334e made cifs_ioctl use the tlink attached to the
cifsFileInfo for a filp. This ignores the case of an open directory
however, which in CIFS can have a NULL private_data until a readdir
is done on it.

This patch re-adds the NULL pointer checks that were removed in commit
50ae28f01 and moves the setting of tcon and "caps" variables lower.

Long term, a better fix would be to establish a f_op->open routine for
directories that populates that field at open time, but that requires
some other changes to how readdir calls are handled.

Reported-by: Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/ioctl.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 2fa22f2..0c98672 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -38,10 +38,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	struct cifs_sb_info *cifs_sb;
 #ifdef CONFIG_CIFS_POSIX
 	struct cifsFileInfo *pSMBFile = filep->private_data;
-	struct cifsTconInfo *tcon = tlink_tcon(pSMBFile->tlink);
+	struct cifsTconInfo *tcon;
 	__u64	ExtAttrBits = 0;
 	__u64	ExtAttrMask = 0;
-	__u64   caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
+	__u64   caps;
 #endif /* CONFIG_CIFS_POSIX */
 
 	xid = GetXid();
@@ -62,6 +62,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			break;
 #ifdef CONFIG_CIFS_POSIX
 		case FS_IOC_GETFLAGS:
+			if (pSMBFile == NULL)
+				break;
+			tcon = tlink_tcon(pSMBFile->tlink);
+			caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
 			if (CIFS_UNIX_EXTATTR_CAP & caps) {
 				rc = CIFSGetExtAttr(xid, tcon, pSMBFile->netfid,
 					&ExtAttrBits, &ExtAttrMask);
@@ -73,6 +77,10 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			break;
 
 		case FS_IOC_SETFLAGS:
+			if (pSMBFile == NULL)
+				break;
+			tcon = tlink_tcon(pSMBFile->tlink);
+			caps = le64_to_cpu(tcon->fsUnixInfo.Capability);
 			if (CIFS_UNIX_EXTATTR_CAP & caps) {
 				if (get_user(ExtAttrBits, (int __user *)arg)) {
 					rc = -EFAULT;
-- 
1.7.2.3
