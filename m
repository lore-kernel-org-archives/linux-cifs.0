From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 10/10] fs,
	cifs: convert tcon_link.tl_count from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:17 +0200
Message-ID: <1488451397-3365-11-git-send-email-elena.reshetova@intel.com>
References: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        paul@paul-moore.com, rlove@rlove.org, peterz@infradead.org,
        gregkh@linuxfoundation.org, Hans Liljestrand <ishkamiel@gmail.com>,
        sfrench@samba.org, linux-cachefs@redhat.com, viro@zeniv.linux.org.uk,
        konishi.ryusuke@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org,
        eparis@parisplace.org, David Windsor <dwindsor@gmail.com>,
        john@johnmccutchan.com, Elena Reshetova <elena.reshetova@intel.com>,
        Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-cachefs-bounces@redhat.com>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-cachefs>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Sender: linux-cachefs-bounces@redhat.com
Errors-To: linux-cachefs-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/cifs/cifsglob.h | 5 +++--
 fs/cifs/connect.c  | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1a90bb3..bd27f92 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -28,6 +28,7 @@
 #include "cifsacl.h"
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
+#include <linux/refcount.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #ifdef CONFIG_CIFS_SMB2
 #include "smb2pdu.h"
@@ -978,7 +979,7 @@ struct tcon_link {
 #define TCON_LINK_PENDING	1
 #define TCON_LINK_IN_TREE	2
 	unsigned long		tl_time;
-	atomic_t		tl_count;
+	refcount_t		tl_count;
 	struct cifs_tcon	*tl_tcon;
 };
 
@@ -996,7 +997,7 @@ static inline struct tcon_link *
 cifs_get_tlink(struct tcon_link *tlink)
 {
 	if (tlink && !IS_ERR(tlink))
-		atomic_inc(&tlink->tl_count);
+		refcount_inc(&tlink->tl_count);
 	return tlink;
 }
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 777ad9f..e0f37ab 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2839,7 +2839,7 @@ cifs_put_tlink(struct tcon_link *tlink)
 	if (!tlink || IS_ERR(tlink))
 		return;
 
-	if (!atomic_dec_and_test(&tlink->tl_count) ||
+	if (!refcount_dec_and_test(&tlink->tl_count) ||
 	    test_bit(TCON_LINK_IN_TREE, &tlink->tl_flags)) {
 		tlink->tl_time = jiffies;
 		return;
@@ -4302,7 +4302,7 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 		newtlink->tl_tcon = ERR_PTR(-EACCES);
 		set_bit(TCON_LINK_PENDING, &newtlink->tl_flags);
 		set_bit(TCON_LINK_IN_TREE, &newtlink->tl_flags);
-		cifs_get_tlink(newtlink);
+		refcount_set(&newtlink->tl_count, 1);
 
 		spin_lock(&cifs_sb->tlink_tree_lock);
 		/* was one inserted after previous search? */
@@ -4380,11 +4380,11 @@ cifs_prune_tlinks(struct work_struct *work)
 		tlink = rb_entry(tmp, struct tcon_link, tl_rbnode);
 
 		if (test_bit(TCON_LINK_MASTER, &tlink->tl_flags) ||
-		    atomic_read(&tlink->tl_count) != 0 ||
+		    refcount_read(&tlink->tl_count) != 0 ||
 		    time_after(tlink->tl_time + TLINK_IDLE_EXPIRE, jiffies))
 			continue;
 
-		cifs_get_tlink(tlink);
+		refcount_set(&tlink->tl_count, 1);
 		clear_bit(TCON_LINK_IN_TREE, &tlink->tl_flags);
 		rb_erase(tmp, root);
 
-- 
2.7.4
