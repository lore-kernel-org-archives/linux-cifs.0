From: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Subject: [PATCH 02/10] nfsd: fix potential lease memory leak in nfs4_setlease
Date: Sat, 23 Aug 2014 10:41:10 -0400
Message-ID: <1408804878-1331-3-git-send-email-jlayton@primarydata.com>
References: <1408804878-1331-1-git-send-email-jlayton@primarydata.com>
Cc: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408804878-1331-1-git-send-email-jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

It's unlikely to ever occur, but if there were already a lease set on
the file then we could end up getting back a different pointer on a
successful setlease attempt than the one we allocated. If that happens,
the one we allocated could leak.

In practice, I don't think this will happen due to the fact that we only
try to set up the lease once per nfs4_file, but this error handling is a
bit more correct given the current lease API.

Cc: J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/nfsd/nfs4state.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fd5ff4b17292..29fac18d9102 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3774,7 +3774,7 @@ static struct file_lock *nfs4_alloc_init_lease(struct nfs4_file *fp, int flag)
 static int nfs4_setlease(struct nfs4_delegation *dp)
 {
 	struct nfs4_file *fp = dp->dl_stid.sc_file;
-	struct file_lock *fl;
+	struct file_lock *fl, *ret;
 	struct file *filp;
 	int status = 0;
 
@@ -3788,11 +3788,14 @@ static int nfs4_setlease(struct nfs4_delegation *dp)
 		return -EBADF;
 	}
 	fl->fl_file = filp;
-	status = vfs_setlease(filp, fl->fl_type, &fl);
+	ret = fl;
+	status = vfs_setlease(filp, fl->fl_type, &ret);
 	if (status) {
 		locks_free_lock(fl);
 		goto out_fput;
 	}
+	if (ret != fl)
+		locks_free_lock(fl);
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
 	/* Did the lease get broken before we took the lock? */
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
