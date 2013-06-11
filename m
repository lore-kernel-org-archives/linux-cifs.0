From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 06/14] locks: don't walk inode->i_flock list in locks_show
Date: Tue, 11 Jun 2013 07:09:00 -0400
Message-ID: <1370948948-31784-7-git-send-email-jlayton@redhat.com>
References: <1370948948-31784-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, matthew-Ztpu424NOJ8@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370948948-31784-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we convert over to using the i_lock to protect the i_flock list,
that will introduce a potential lock inversion problem in locks_show.
When we want to walk the i_flock list, we'll need to take the i_lock.

Rather than do that, just walk the global blocked_locks list and print
out any that are blocked on the given lock.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/locks.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index e451d18..3fd27f0 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2249,8 +2249,10 @@ static int locks_show(struct seq_file *f, void *v)
 
 	lock_get_status(f, fl, *((loff_t *)f->private), "");
 
-	list_for_each_entry(bfl, &fl->fl_block, fl_block)
-		lock_get_status(f, bfl, *((loff_t *)f->private), " ->");
+	list_for_each_entry(bfl, &blocked_list, fl_link) {
+		if (bfl->fl_next == fl)
+			lock_get_status(f, bfl, *((loff_t *)f->private), " ->");
+	}
 
 	return 0;
 }
-- 
1.7.1
