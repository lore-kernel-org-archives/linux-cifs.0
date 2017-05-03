From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/2] cifs: fix CIFS_ENUMERATE_SNAPSHOTS oops
Date: Wed,  3 May 2017 17:39:08 +0200
Message-ID: <20170503153909.5783-2-ddiss@suse.de>
References: <20170503153909.5783-1-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503153909.5783-1-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As with 618763958b22, an open directory may have a NULL private_data
pointer prior to readdir. CIFS_ENUMERATE_SNAPSHOTS must check for this
before dereference.

Fixes: 834170c85978 ("Enable previous version support")
Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/ioctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 7f4bba574930..4d598a71cf84 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -213,6 +213,8 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 			rc = smb_mnt_get_fsinfo(xid, tcon, (void __user *)arg);
 			break;
 		case CIFS_ENUMERATE_SNAPSHOTS:
+			if (pSMBFile == NULL)
+				break;
 			if (arg == 0) {
 				rc = -EINVAL;
 				goto cifs_ioc_exit;
-- 
2.12.0
