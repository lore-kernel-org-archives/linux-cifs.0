From: Jeff Layton <jlayton@primarydata.com>
Subject: [PATCH v2 07/10] locks: remove i_flock field from struct inode
Date: Thu,  8 Jan 2015 10:34:22 -0800
Message-ID: <1420742065-28423-8-git-send-email-jlayton@primarydata.com>
References: <1420742065-28423-1-git-send-email-jlayton@primarydata.com>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	hch@infradead.org
To: linux-fsdevel@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1420742065-28423-1-git-send-email-jlayton@primarydata.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Nothing uses it anymore. Also add a forward declaration for struct
file_lock to silence some compiler warnings that the removal triggers.

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 include/linux/fs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 380717828ba1..7da02cb90b30 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -625,7 +625,6 @@ struct inode {
 	atomic_t		i_readcount; /* struct files open RO */
 #endif
 	const struct file_operations	*i_fop;	/* former ->i_op->default_file_ops */
-	struct file_lock	*i_flock;
 	struct file_lock_context	*i_flctx;
 	struct address_space	i_data;
 	struct list_head	i_devices;
@@ -886,6 +885,8 @@ static inline struct file *get_file(struct file *f)
 /* legacy typedef, should eventually be removed */
 typedef void *fl_owner_t;
 
+struct file_lock;
+
 struct file_lock_operations {
 	void (*fl_copy_lock)(struct file_lock *, struct file_lock *);
 	void (*fl_release_private)(struct file_lock *);
-- 
2.1.0

