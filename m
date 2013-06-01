From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v1 02/11] locks: make generic_add_lease and generic_delete_lease static
Date: Fri, 31 May 2013 23:07:25 -0400
Message-ID: <1370056054-25449-3-git-send-email-jlayton@redhat.com>
References: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
Cc: dhowells@redhat.com, sage@inktank.com, smfrench@gmail.com,
	swhiteho@redhat.com, Trond.Myklebust@netapp.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	cluster-devel@redhat.com, linux-nfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, piastryyy@gmail.com
To: viro@zeniv.linux.org.uk, matthew@wil.cx, bfields@fieldses.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1370056054-25449-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 7a02064..e3140b8 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1337,7 +1337,7 @@ int fcntl_getlease(struct file *filp)
 	return type;
 }
 
-int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
+static int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 {
 	struct file_lock *fl, **before, **my_before = NULL, *lease;
 	struct dentry *dentry = filp->f_path.dentry;
@@ -1402,7 +1402,7 @@ out:
 	return error;
 }
 
-int generic_delete_lease(struct file *filp, struct file_lock **flp)
+static int generic_delete_lease(struct file *filp, struct file_lock **flp)
 {
 	struct file_lock *fl, **before;
 	struct dentry *dentry = filp->f_path.dentry;
-- 
1.7.1

