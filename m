From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 02/10] fs, cachefiles: convert cachefiles_object.usage from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:09 +0200
Message-ID: <1488451397-3365-3-git-send-email-elena.reshetova@intel.com>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
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
 fs/cachefiles/bind.c      |  2 +-
 fs/cachefiles/interface.c | 18 +++++++++---------
 fs/cachefiles/internal.h  |  3 ++-
 fs/cachefiles/namei.c     |  2 +-
 4 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index 3ff867f..341864e 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -109,7 +109,7 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 
 	ASSERTCMP(fsdef->backer, ==, NULL);
 
-	atomic_set(&fsdef->usage, 1);
+	refcount_set(&fsdef->usage, 1);
 	fsdef->type = FSCACHE_COOKIE_TYPE_INDEX;
 
 	_debug("- fsdef %p", fsdef);
diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index e7f16a7..d3f87c3 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -51,7 +51,7 @@ static struct fscache_object *cachefiles_alloc_object(
 	ASSERTCMP(object->backer, ==, NULL);
 
 	BUG_ON(test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
-	atomic_set(&object->usage, 1);
+	refcount_set(&object->usage, 1);
 
 	fscache_object_init(&object->fscache, cookie, &cache->cache);
 
@@ -182,13 +182,13 @@ struct fscache_object *cachefiles_grab_object(struct fscache_object *_object)
 	struct cachefiles_object *object =
 		container_of(_object, struct cachefiles_object, fscache);
 
-	_enter("{OBJ%x,%d}", _object->debug_id, atomic_read(&object->usage));
+	_enter("{OBJ%x,%d}", _object->debug_id, refcount_read(&object->usage));
 
 #ifdef CACHEFILES_DEBUG_SLAB
-	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+	ASSERT((refcount_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
 #endif
 
-	atomic_inc(&object->usage);
+	refcount_inc(&object->usage);
 	return &object->fscache;
 }
 
@@ -261,13 +261,13 @@ static void cachefiles_drop_object(struct fscache_object *_object)
 	object = container_of(_object, struct cachefiles_object, fscache);
 
 	_enter("{OBJ%x,%d}",
-	       object->fscache.debug_id, atomic_read(&object->usage));
+	       object->fscache.debug_id, refcount_read(&object->usage));
 
 	cache = container_of(object->fscache.cache,
 			     struct cachefiles_cache, cache);
 
 #ifdef CACHEFILES_DEBUG_SLAB
-	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+	ASSERT((refcount_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
 #endif
 
 	/* We need to tidy the object up if we did in fact manage to open it.
@@ -319,16 +319,16 @@ static void cachefiles_put_object(struct fscache_object *_object)
 	object = container_of(_object, struct cachefiles_object, fscache);
 
 	_enter("{OBJ%x,%d}",
-	       object->fscache.debug_id, atomic_read(&object->usage));
+	       object->fscache.debug_id, refcount_read(&object->usage));
 
 #ifdef CACHEFILES_DEBUG_SLAB
-	ASSERT((atomic_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
+	ASSERT((refcount_read(&object->usage) & 0xffff0000) != 0x6b6b0000);
 #endif
 
 	ASSERTIFCMP(object->fscache.parent,
 		    object->fscache.parent->n_children, >, 0);
 
-	if (atomic_dec_and_test(&object->usage)) {
+	if (refcount_dec_and_test(&object->usage)) {
 		_debug("- kill object OBJ%x", object->fscache.debug_id);
 
 		ASSERT(!test_bit(CACHEFILES_OBJECT_ACTIVE, &object->flags));
diff --git a/fs/cachefiles/internal.h b/fs/cachefiles/internal.h
index cd1effe..61771e6 100644
--- a/fs/cachefiles/internal.h
+++ b/fs/cachefiles/internal.h
@@ -21,6 +21,7 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/security.h>
+#include <linux/refcount.h>
 
 struct cachefiles_cache;
 struct cachefiles_object;
@@ -43,7 +44,7 @@ struct cachefiles_object {
 	loff_t				i_size;		/* object size */
 	unsigned long			flags;
 #define CACHEFILES_OBJECT_ACTIVE	0		/* T if marked active */
-	atomic_t			usage;		/* object usage count */
+	refcount_t			usage;		/* object usage count */
 	uint8_t				type;		/* object type */
 	uint8_t				new;		/* T if object new */
 	spinlock_t			work_lock;
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 41df8a2..e3bc512 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -197,7 +197,7 @@ static int cachefiles_mark_object_active(struct cachefiles_cache *cache,
 		cachefiles_printk_object(object, xobject);
 		BUG();
 	}
-	atomic_inc(&xobject->usage);
+	refcount_inc(&xobject->usage);
 	write_unlock(&cache->active_lock);
 
 	if (test_bit(CACHEFILES_OBJECT_ACTIVE, &xobject->flags)) {
-- 
2.7.4
