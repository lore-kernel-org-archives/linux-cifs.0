From: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/10] fs, fscache: convert fscache_operation.usage from atomic_t to refcount_t
Date: Thu,  2 Mar 2017 12:43:14 +0200
Message-ID: <1488451397-3365-8-git-send-email-elena.reshetova@intel.com>
References: <1488451397-3365-1-git-send-email-elena.reshetova@intel.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
        viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
        eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org,
        john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org,
        Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
        David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488451397-3365-1-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cachefiles/rdwr.c          |  2 +-
 fs/fscache/operation.c        | 38 +++++++++++++++++++-------------------
 fs/fscache/page.c             |  2 +-
 include/linux/fscache-cache.h |  4 ++--
 4 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index afbdc41..c987de6 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -692,7 +692,7 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,
 			     struct cachefiles_cache, cache);
 
 	_enter("{OBJ%x,%d},,%d,,",
-	       object->fscache.debug_id, atomic_read(&op->op.usage),
+	       object->fscache.debug_id, refcount_read(&op->op.usage),
 	       *nr_pages);
 
 	if (!object->backer)
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index de67745..eb84c95 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -38,7 +38,7 @@ void fscache_operation_init(struct fscache_operation *op,
 			    fscache_operation_release_t release)
 {
 	INIT_WORK(&op->work, fscache_op_work_func);
-	atomic_set(&op->usage, 1);
+	refcount_set(&op->usage, 1);
 	op->state = FSCACHE_OP_ST_INITIALISED;
 	op->debug_id = atomic_inc_return(&fscache_op_debug_id);
 	op->processor = processor;
@@ -60,19 +60,19 @@ EXPORT_SYMBOL(fscache_operation_init);
 void fscache_enqueue_operation(struct fscache_operation *op)
 {
 	_enter("{OBJ%x OP%x,%u}",
-	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       op->object->debug_id, op->debug_id, refcount_read(&op->usage));
 
 	ASSERT(list_empty(&op->pend_link));
 	ASSERT(op->processor != NULL);
 	ASSERT(fscache_object_is_available(op->object));
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_IN_PROGRESS);
 
 	fscache_stat(&fscache_n_op_enqueue);
 	switch (op->flags & FSCACHE_OP_TYPE) {
 	case FSCACHE_OP_ASYNC:
 		_debug("queue async");
-		atomic_inc(&op->usage);
+		refcount_inc(&op->usage);
 		if (!queue_work(fscache_op_wq, &op->work))
 			fscache_put_operation(op);
 		break;
@@ -156,7 +156,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 	_enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
 
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
@@ -183,11 +183,11 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		object->n_exclusive++;	/* reads and writes must wait */
 
 		if (object->n_in_progress > 0) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 			fscache_start_operations(object);
@@ -203,7 +203,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
 		op->object = object;
 		object->n_ops++;
 		object->n_exclusive++;	/* reads and writes must wait */
-		atomic_inc(&op->usage);
+		refcount_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
 		fscache_stat(&fscache_n_op_pend);
 		ret = 0;
@@ -238,10 +238,10 @@ int fscache_submit_op(struct fscache_object *object,
 	int ret;
 
 	_enter("{OBJ%x OP%x},{%u}",
-	       object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       object->debug_id, op->debug_id, refcount_read(&op->usage));
 
 	ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
 	spin_lock(&object->lock);
 	ASSERTCMP(object->n_ops, >=, object->n_in_progress);
@@ -267,11 +267,11 @@ int fscache_submit_op(struct fscache_object *object,
 		object->n_ops++;
 
 		if (object->n_exclusive > 0) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 		} else if (!list_empty(&object->pending_ops)) {
-			atomic_inc(&op->usage);
+			refcount_inc(&op->usage);
 			list_add_tail(&op->pend_link, &object->pending_ops);
 			fscache_stat(&fscache_n_op_pend);
 			fscache_start_operations(object);
@@ -283,7 +283,7 @@ int fscache_submit_op(struct fscache_object *object,
 	} else if (flags & BIT(FSCACHE_OBJECT_IS_LOOKED_UP)) {
 		op->object = object;
 		object->n_ops++;
-		atomic_inc(&op->usage);
+		refcount_inc(&op->usage);
 		list_add_tail(&op->pend_link, &object->pending_ops);
 		fscache_stat(&fscache_n_op_pend);
 		ret = 0;
@@ -359,7 +359,7 @@ int fscache_cancel_op(struct fscache_operation *op,
 
 	ASSERTCMP(op->state, >=, FSCACHE_OP_ST_PENDING);
 	ASSERTCMP(op->state, !=, FSCACHE_OP_ST_CANCELLED);
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
 	spin_lock(&object->lock);
 
@@ -481,11 +481,11 @@ void fscache_put_operation(struct fscache_operation *op)
 	struct fscache_cache *cache;
 
 	_enter("{OBJ%x OP%x,%d}",
-	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       op->object->debug_id, op->debug_id, refcount_read(&op->usage));
 
-	ASSERTCMP(atomic_read(&op->usage), >, 0);
+	ASSERTCMP(refcount_read(&op->usage), >, 0);
 
-	if (!atomic_dec_and_test(&op->usage))
+	if (!refcount_dec_and_test(&op->usage))
 		return;
 
 	_debug("PUT OP");
@@ -569,7 +569,7 @@ void fscache_operation_gc(struct work_struct *work)
 		       object->debug_id, op->debug_id);
 		fscache_stat(&fscache_n_op_gc);
 
-		ASSERTCMP(atomic_read(&op->usage), ==, 0);
+		ASSERTCMP(refcount_read(&op->usage), ==, 0);
 		ASSERTCMP(op->state, ==, FSCACHE_OP_ST_DEAD);
 
 		ASSERTCMP(object->n_ops, >, 0);
@@ -599,7 +599,7 @@ void fscache_op_work_func(struct work_struct *work)
 	unsigned long start;
 
 	_enter("{OBJ%x OP%x,%d}",
-	       op->object->debug_id, op->debug_id, atomic_read(&op->usage));
+	       op->object->debug_id, op->debug_id, refcount_read(&op->usage));
 
 	ASSERT(op->processor != NULL);
 	start = jiffies;
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c8c4f79..352393c 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -774,7 +774,7 @@ static void fscache_write_op(struct fscache_operation *_op)
 	void *results[1];
 	int ret;
 
-	_enter("{OP%x,%d}", op->op.debug_id, atomic_read(&op->op.usage));
+	_enter("{OP%x,%d}", op->op.debug_id, refcount_read(&op->op.usage));
 
 	spin_lock(&object->lock);
 	cookie = object->cookie;
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index dcec7b3..0093158 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -103,7 +103,7 @@ struct fscache_operation {
 #define FSCACHE_OP_KEEP_FLAGS	0x00f0	/* flags to keep when repurposing an op */
 
 	enum fscache_operation_state state;
-	atomic_t		usage;
+	refcount_t		usage;
 	unsigned		debug_id;	/* debugging ID */
 
 	/* operation processor callback
@@ -161,7 +161,7 @@ typedef int (*fscache_pages_retrieval_func_t)(struct fscache_retrieval *op,
 static inline
 struct fscache_retrieval *fscache_get_retrieval(struct fscache_retrieval *op)
 {
-	atomic_inc(&op->op.usage);
+	refcount_inc(&op->op.usage);
 	return op;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
