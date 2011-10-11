From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/3] cifs: warn about deprecation of /proc/fs/cifs/OplockEnabled
 interface
Date: Tue, 11 Oct 2011 21:28:10 +0530
Message-ID: <4E946792.1060405@suse.de>
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

The plan is to deprecate this interface by kernel version 3.4.

Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifs_debug.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 2fe3cf1..b9c06a8 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -526,6 +526,9 @@ static ssize_t cifs_oplock_proc_write(struct file *file,
 	char c;
 	int rc;
 
+	printk(KERN_WARNING "CIFS: The /proc/fs/cifs/OplockEnabled interface "
+	       "will be removed in kernel version 3.4. Please migrate to "
+	       "using the 'enable_oplocks' module parameter in cifs.ko.");
 	rc = get_user(c, buffer);
 	if (rc)
 		return rc;
