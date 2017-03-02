From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 06/10] fs, fscache: convert fscache_cache_tag.usage from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:13 +0200
Message-ID: <1488451397-3365-7-git-send-email-elena.reshetova@intel.com>
References: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-cachefs@redhat.com, linux-cifs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com, sfrench@samba.org,
        eparis@parisplace.org, konishi.ryusuke@lab.ntt.co.jp,
        john@johnmccutchan.com, rlove@rlove.org, paul@paul-moore.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
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
 fs/fscache/cache.c            | 8 ++++----
 include/linux/fscache-cache.h | 3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/fscache/cache.c b/fs/fscache/cache.c
index 56cce7f..ca6e282 100644
--- a/fs/fscache/cache.c
+++ b/fs/fscache/cache.c
@@ -33,7 +33,7 @@ struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
 
 	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
 		if (strcmp(tag->name, name) == 0) {
-			atomic_inc(&tag->usage);
+			refcount_inc(&tag->usage);
 			up_read(&fscache_addremove_sem);
 			return tag;
 		}
@@ -47,7 +47,7 @@ struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
 		/* return a dummy tag if out of memory */
 		return ERR_PTR(-ENOMEM);
 
-	atomic_set(&xtag->usage, 1);
+	refcount_set(&xtag->usage, 1);
 	strcpy(xtag->name, name);
 
 	/* write lock, search again and add if still not present */
@@ -55,7 +55,7 @@ struct fscache_cache_tag *__fscache_lookup_cache_tag(const char *name)
 
 	list_for_each_entry(tag, &fscache_cache_tag_list, link) {
 		if (strcmp(tag->name, name) == 0) {
-			atomic_inc(&tag->usage);
+			refcount_inc(&tag->usage);
 			up_write(&fscache_addremove_sem);
 			kfree(xtag);
 			return tag;
@@ -75,7 +75,7 @@ void __fscache_release_cache_tag(struct fscache_cache_tag *tag)
 	if (tag != ERR_PTR(-ENOMEM)) {
 		down_write(&fscache_addremove_sem);
 
-		if (atomic_dec_and_test(&tag->usage))
+		if (refcount_dec_and_test(&tag->usage))
 			list_del_init(&tag->link);
 		else
 			tag = NULL;
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 4c467ef..dcec7b3 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -21,6 +21,7 @@
 #include <linux/fscache.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/refcount.h>
 
 #define NR_MAXCACHES BITS_PER_LONG
 
@@ -37,7 +38,7 @@ struct fscache_cache_tag {
 	struct fscache_cache	*cache;		/* cache referred to by this tag */
 	unsigned long		flags;
 #define FSCACHE_TAG_RESERVED	0		/* T if tag is reserved for a cache */
-	atomic_t		usage;
+	refcount_t		usage;
 	char			name[0];	/* tag name */
 };
 
-- 
2.7.4
