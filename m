From: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 4/4] dcache: don't need to take d_lock in prepend_path()
Date: Fri,  5 Apr 2013 12:57:41 -0400
Message-ID: <1365181061-30787-5-git-send-email-Waiman.Long@hp.com>
References: <1365181061-30787-1-git-send-email-Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, autofs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Chandramouleeswaran, Aswin" <aswin-VXdhtT5mjnY@public.gmane.org>,
	"Norton, Scott J" <scott.norton-VXdhtT5mjnY@public.gmane.org>,
	Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>,
	Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365181061-30787-1-git-send-email-Waiman.Long-VXdhtT5mjnY@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

The d_lock was used in prepend_path() to protect dentry->d_name from
being changed under the hood. As the caller of prepend_path() has
to take the rename_lock before calling into it, there is no chance
that d_name will be changed. The d_lock lock is only needed when the
rename_lock is not taken.

Signed-off-by: Waiman Long <Waiman.Long-VXdhtT5mjnY@public.gmane.org>
---
 fs/dcache.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 9477d80..e3d6543 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2529,6 +2529,7 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @buflen: pointer to buffer length
  *
  * Caller holds the rename_lock.
+ * There is no need to lock the dentry as its name cannot be changed.
  */
 static int prepend_path(const struct path *path,
 			const struct path *root,
@@ -2555,9 +2556,7 @@ static int prepend_path(const struct path *path,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
 		error = prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
 		if (!error)
 			error = prepend(buffer, buflen, "/", 1);
 		if (error)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
