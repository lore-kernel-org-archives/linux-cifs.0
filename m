From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH v2 04/14] locks: make "added" in
	__posix_lock_file a bool
Date: Tue, 11 Jun 2013 07:08:58 -0400
Message-ID: <1370948948-31784-5-git-send-email-jlayton@redhat.com>
References: <1370948948-31784-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        cluster-devel@redhat.com, sage@inktank.com,
        samba-technical@lists.samba.org, Trond.Myklebust@netapp.com,
        linux-kernel@vger.kernel.org, piastryyy@gmail.com,
        linux-afs@lists.infradead.org, dhowells@redhat.com, smfrench@gmail.com,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        akpm@linux-foundation.org
To: viro@zeniv.linux.org.uk, matthew@wil.cx, bfields@fieldses.org
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <1370948948-31784-1-git-send-email-jlayton@redhat.com>
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

...save 3 bytes of stack space.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: J. Bruce Fields <bfields@fieldses.org>
---
 fs/locks.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 1e6301b..c186649 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -791,7 +791,8 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 	struct file_lock *left = NULL;
 	struct file_lock *right = NULL;
 	struct file_lock **before;
-	int error, added = 0;
+	int error;
+	bool added = false;
 
 	/*
 	 * We may need two file_lock structures for this operation,
@@ -885,7 +886,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 				continue;
 			}
 			request = fl;
-			added = 1;
+			added = true;
 		}
 		else {
 			/* Processing for different lock types is a bit
@@ -896,7 +897,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 			if (fl->fl_start > request->fl_end)
 				break;
 			if (request->fl_type == F_UNLCK)
-				added = 1;
+				added = true;
 			if (fl->fl_start < request->fl_start)
 				left = fl;
 			/* If the next lock in the list has a higher end
@@ -926,7 +927,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 				locks_release_private(fl);
 				locks_copy_private(fl, request);
 				request = fl;
-				added = 1;
+				added = true;
 			}
 		}
 		/* Go on to next lock.
-- 
1.7.1
