From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately
Date: Wed,  7 Aug 2013 09:04:07 -0400
Message-ID: <1375880647-22512-1-git-send-email-jlayton@redhat.com>
References: <51F92F0B.7030504@cam.ac.uk>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F92F0B.7030504-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

David reported that commit c2b93e06 (cifs: only set ops for inodes in
I_NEW state) caused a regression with mfsymlinks. If a mfsymlink dentry
was instantiated at readdir time, then it would not be properly tossed
out of the cache and reinstantiated when a stat or readlink call came
about.

This patch addresses this by simply skipping instantiating dentries
when we *know* that they will need to be immediately revalidated. The
next attempt to use that dentry will cause a new lookup to occur
(which is basically what we want to happen anyway).

Reported-by: David McBride <dwm37-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index ab87784..69d2c82 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -111,6 +111,14 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
 			return;
 	}
 
+	/*
+	 * If we know that the inode will need to be revalidated immediately,
+	 * then don't create a new dentry for it. We'll end up doing an on
+	 * the wire call either way and this spares us an invalidation.
+	 */
+	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
+		return;
+
 	dentry = d_alloc(parent, name);
 	if (!dentry)
 		return;
-- 
1.8.3.1
