From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v4 03/14] locks: make generic_add_lease and
	generic_delete_lease static
Date: Fri, 21 Jun 2013 08:58:11 -0400
Message-ID: <1371819502-26363-4-git-send-email-jlayton@redhat.com>
References: <1371819502-26363-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        cluster-devel@redhat.com, sage@inktank.com,
        samba-technical@lists.samba.org, Trond.Myklebust@netapp.com,
        linux-kernel@vger.kernel.org, piastryyy@gmail.com,
        linux-afs@lists.infradead.org, dhowells@redhat.com, smfrench@gmail.com,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        akpm@linux-foundation.org
To: viro@zeniv.linux.org.uk, matthew@wil.cx, bfields@fieldses.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1371819502-26363-1-git-send-email-jlayton@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: J. Bruce Fields <bfields@fieldses.org>
---
 fs/locks.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index d732e22..804bb9e 100644
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
