Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0644A711
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 14:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385353; cv=none; b=XHn/bMTbWaXVlRslw67vIloV86XfAjWoNgYHWOistfL6U2Kh37j8MU9PlTple+sqeSCTV+tgovzBPWQggcXkD9Lvx3Bn3+j3T+ptlZdEuu5TInfCoPUlDp3+CHPCp07tTRLvEhzSkfNRooY2KoHBDeTMq3t6WLoJju1i0BiuMwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385353; c=relaxed/simple;
	bh=4wj41cHrtYbOpRGT0t7PtOWHzkpMgKUVap56UoFLJIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/ICu6zIQAtMIX9fjO2nvsX9dXBMnN1LeV3Mdl97IYA4Tn9eCOXn1CPphOR3IhCzex8IU3tz8nVGagzOKdjbSujn+RPKkflr2LvzM77A1TPK9rxv/xvdBLYvJ7jW1rN8a+wgZAhttrcgcc3hsiHwKH+Qt349ypGqQmKUwMdC6mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A+mQ76Ep; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A+mQ76Ep"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35d99c906d5so1772409a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 07:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777385352; x=1777990152; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkJ08U6yZCRDKix+9y0PgVL7KcnbudlGjXHmuDGf9BQ=;
        b=A+mQ76EpoWEDPhZKKZtmBBKkp7SYakv6ALWIRj7PjT47LMCg8HAUXlsI0GS4lMswP1
         GwthRNhxoxBJY2qo1dBdKh+QjHBp9gZ4Idp2G7lPur2S+XiUWENRogy/AiIOhI2JBcIi
         ERC08CX9acZ0XJ2n8yMJPhtOSI2/coKfsyJfTWJjPz84Xro5HxcIkljdaftpOni3UdcG
         4omAK4542NKx/uYnj/p9Kkoll7OsRk0xEJzsLi/A/kPSATu1/kx2nu2WZ7dGhdt6CBhs
         3uuwvwyCIr1lfPo217VOmi1E3NB6/kf9tMEnRcziVqPkVxH8FvRIZClhH6GhblYgjWnY
         oJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777385352; x=1777990152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tkJ08U6yZCRDKix+9y0PgVL7KcnbudlGjXHmuDGf9BQ=;
        b=USbF5/i1agroOcug7DKqkHmfKhvdNdOKt94DKs2ZhgejnIMVfaUIDTIiJbQ7JqLMO2
         TJSm+QlwV5S7Kk9y6SokZ5nyso/1d9CNqggBa9u940fbp+Oopw0kUiErVjC1j4uHj2bv
         rquo9ulIFiWE2XqVcFErclyklGIaxAknAu5Y2Qot7JumWjYtwjVFT/1xEFxACuvlLi0B
         yIaDSyH4kSqMIsTyiVbYZKFH1IfkA3o6rp2W8NNM5jJsSOtMgy1joSYXnWvl/aVyd/Mz
         ru0TW/d9d7omxOWRnb9LP03TlgXbuHrK75oqAjdwrofLt96xC+MJdZgzaJtftL2SzjNd
         4FCA==
X-Forwarded-Encrypted: i=1; AFNElJ9EqLRglXbdlwRplR8Gj5SvvxqXZLcmrbUdjF04DBhk2I5O6hwiiUK/sYVqEbYrYXoN10Dj1bPZC5+l@vger.kernel.org
X-Gm-Message-State: AOJu0YwpAydHZIyJc7AFmmgSoK98abs3BjA0NUAJ8WqPYD9sXwUZurdB
	dOgV122CjJM0Tuo1aJfnmGOEHPqAPZ0BQMNxcNmxHEBOLOcFW3KeMTxQ
X-Gm-Gg: AeBDietc7UOvtS7cTVkLa54nnvr7rTEnzxjSuH1BJTCwjjAUb+umEr+xPOMlK0OSqhb
	aPIGcuGjQcTuwRNlGV2w2UOx2NWQ4niCLcAf7VI54RF2vt+EYFo+fTWBAp/RNOyEI5IJMGuMXfB
	vVr84BzIDCKms5cUYP5cDh5D702uScB0cX92PfeLGYMKoc8q/jwXqDJb0NU30YGZxGNLpoDq01g
	5GQlPDH1MRY+mNL15pYmQkk+5NWF6MMPKcLEUzqnmVsCFRNKiPlePdGrnbUckC6b5mzbWC5gpUa
	FfanjWmiZyw4FeKmcDa+gxu8CxkRowy9nwp/g0+DaoMuN8j6a2itQ7m1vT3tO7ZfOZ/u1oAmn2r
	bZLWH3oVbMp9JxO92V6aU+jq/OuNB8K31zEgN/odykISdPTaMxy9cHJ1CY815OoLj/8AATu1ZUa
	3wr2c0E3nmWNnN7lo48ZaEMUBMcvk=
X-Received: by 2002:a05:6a21:104:b0:3a2:d3c3:39a9 with SMTP id adf61e73a8af0-3a39889bc54mr2419585637.0.1777385351601;
        Tue, 28 Apr 2026 07:09:11 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fcade0f56sm2190526a12.21.2026.04.28.07.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 07:09:11 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2 3/3] ksmbd: close durable scavenger races against m_fp_list lookups
Date: Tue, 28 Apr 2026 23:08:56 +0900
Message-ID: <20260428140856.941847-4-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260428140856.941847-1-charsyam@gmail.com>
References: <20260428140856.941847-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_durable_scavenger() has two related races against any walker
that iterates f_ci->m_fp_list, including ksmbd_lookup_fd_inode()
(used by ksmbd_vfs_rename) and the share-mode checks in
fs/smb/server/smb_common.c.

(1) fp->node list-head reuse.  Durable-preserved handles can remain
linked on f_ci->m_fp_list after session teardown so share-mode checks
still see them while the handle is reconnectable.  The scavenger
collected expired handles by adding fp->node to a local
scavenger_list after removing them from the global durable idr.
Because fp->node is the same list_head used by m_fp_list,
list_add(&fp->node, &scavenger_list) overwrites the m_fp_list links
and corrupts both lists.  CONFIG_DEBUG_LIST can report this on the
share-mode walk path.

(2) Refcount race against m_fp_list walkers.  The scavenger qualifies
an expired durable handle with atomic_read(&fp->refcount) > 1 and
fp->conn under global_ft.lock, removes fp from global_ft, then drops
global_ft.lock before unlinking fp from m_fp_list and freeing it.
During that gap fp is still linked on m_fp_list with f_state ==
FP_INITED.  ksmbd_lookup_fd_inode() under m_lock read calls
ksmbd_fp_get() (atomic_inc_not_zero on refcount that is still 1) and
takes a live reference; the scavenger then unlinks and frees fp
while the holder owns a reference, leading to UAF on the holder's
subsequent ksmbd_fd_put() and on any field reads performed by a
concurrent share-mode walker that iterates m_fp_list without taking
ksmbd_fp_get() (smb_check_perm_dleases-like paths).

Fix both:

  * Stop reusing fp->node as a scavenger-private list node.  Remove
    one expired handle from global_ft under global_ft.lock, take an
    explicit transient reference, drop the lock, unlink fp->node
    from m_fp_list under f_ci->m_lock, then drop both the durable
    lifetime and transient references with atomic_sub_and_test(2,
    &fp->refcount).  If the scavenger is the last putter the close
    runs there; otherwise an in-flight holder that already raced
    through the m_fp_list lookup owns the final close via its
    ksmbd_fd_put() path.  The one-at-a-time disposal can rescan the
    durable idr when multiple handles expire in the same pass, but
    durable scavenging is a background expiration path and the final
    full scan recomputes min_timeout before the next wait.

  * Clear fp->persistent_id inside __ksmbd_remove_durable_fd() right
    after idr_remove(), so a delayed final close from a holder that
    snatched fp does not re-issue idr_remove() on a persistent id
    that idr_alloc_cyclic() in ksmbd_open_durable_fd() may have
    already handed out to a brand-new durable handle.

  * Bypass the per-conn open_files_count decrement in
    __put_fd_final() when fp is detached from any session table
    (fp->conn cleared by session_fd_check() at durable preserve --
    paired with the volatile_id clear at unpublish, so checking
    fp->conn alone is sufficient).  The walker that owns the final
    close runs from an unrelated work->conn whose
    stats.open_files_count never tracked this durable fp; without
    this guard the holder would underflow that unrelated counter.

The two races are folded into one patch because patch (1) alone
cleans up the corrupted list but leaves a deterministic UAF window
for m_fp_list walkers that the transient-reference and
persistent_id discipline in (2) close; bisecting onto an
intermediate state would land on a UAF that pre-patch chaos merely
made less reproducible.

Validation:
  * CONFIG_DEBUG_LIST coverage for the list_head reuse path.
  * KASAN-enabled direct SMB2 durable-handle coverage that exercised
    ksmbd_durable_scavenger() and non-NULL ksmbd_lookup_fd_inode()
    returns while durable handles expired under concurrent rename
    lookups, with no KASAN, UAF, list-corruption, ODEBUG, or WARNING
    reports.
  * checkpatch --strict
  * make -j$(nproc) M=fs/smb/server

Fixes: d484d621d40f ("ksmbd: add durable scavenger timer")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/vfs_cache.c | 102 ++++++++++++++++++++++++++++----------
 1 file changed, 76 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dc4037ef1834..354c4d8a1cfb 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -418,6 +418,14 @@ static void __ksmbd_remove_durable_fd(struct ksmbd_file *fp)
 		return;
 
 	idr_remove(global_ft.idr, fp->persistent_id);
+	/*
+	 * Clear persistent_id so a later __ksmbd_close_fd() that runs from a
+	 * delayed putter (e.g. when a concurrent ksmbd_lookup_fd_inode()
+	 * walker held the final reference) does not re-issue idr_remove() on
+	 * an id that idr_alloc_cyclic() may have already handed out to a new
+	 * durable handle.
+	 */
+	fp->persistent_id = KSMBD_NO_FID;
 }
 
 static void ksmbd_remove_durable_fd(struct ksmbd_file *fp)
@@ -521,6 +529,20 @@ static struct ksmbd_file *__ksmbd_lookup_fd(struct ksmbd_file_table *ft,
 
 static void __put_fd_final(struct ksmbd_work *work, struct ksmbd_file *fp)
 {
+	/*
+	 * Detached durable fp -- session_fd_check() cleared fp->conn at
+	 * preserve, so this fp is no longer tracked by any conn's
+	 * stats.open_files_count.  This happens when
+	 * ksmbd_scavenger_dispose_dh() hands the final close off to an
+	 * m_fp_list walker (e.g. ksmbd_lookup_fd_inode()) whose work->conn
+	 * is unrelated to the conn that originally opened the handle; close
+	 * via the NULL-ft path so we do not underflow that unrelated
+	 * counter.
+	 */
+	if (!fp->conn) {
+		__ksmbd_close_fd(NULL, fp);
+		return;
+	}
 	__ksmbd_close_fd(&work->sess->file_table, fp);
 	atomic_dec(&work->conn->stats.open_files_count);
 }
@@ -1033,24 +1055,37 @@ static bool ksmbd_durable_scavenger_alive(void)
 	return true;
 }
 
-static void ksmbd_scavenger_dispose_dh(struct list_head *head)
+static void ksmbd_scavenger_dispose_dh(struct ksmbd_file *fp)
 {
-	while (!list_empty(head)) {
-		struct ksmbd_file *fp;
+	/*
+	 * Durable-preserved fp can remain linked on f_ci->m_fp_list for
+	 * share-mode checks.  Unlink it before final close; fp->node is not
+	 * available as a scavenger-private list node because re-adding it to
+	 * another list corrupts m_fp_list.
+	 */
+	down_write(&fp->f_ci->m_lock);
+	list_del_init(&fp->node);
+	up_write(&fp->f_ci->m_lock);
 
-		fp = list_first_entry(head, struct ksmbd_file, node);
-		list_del_init(&fp->node);
+	/*
+	 * Drop both the durable lifetime reference and the transient reference
+	 * taken by the scavenger under global_ft.lock.  If a concurrent
+	 * ksmbd_lookup_fd_inode() (or any other m_fp_list walker) snatched fp
+	 * before the unlink above, that holder owns the final close via
+	 * ksmbd_fd_put() -> __ksmbd_close_fd().  Otherwise the scavenger is
+	 * the last putter and finalises fp here.
+	 */
+	if (atomic_sub_and_test(2, &fp->refcount))
 		__ksmbd_close_fd(NULL, fp);
-	}
 }
 
 static int ksmbd_durable_scavenger(void *dummy)
 {
 	struct ksmbd_file *fp = NULL;
+	struct ksmbd_file *expired_fp;
 	unsigned int id;
 	unsigned int min_timeout = 1;
 	bool found_fp_timeout;
-	LIST_HEAD(scavenger_list);
 	unsigned long remaining_jiffies;
 
 	__module_get(THIS_MODULE);
@@ -1060,8 +1095,6 @@ static int ksmbd_durable_scavenger(void *dummy)
 		if (try_to_freeze())
 			continue;
 
-		found_fp_timeout = false;
-
 		remaining_jiffies = wait_event_timeout(dh_wq,
 				   ksmbd_durable_scavenger_alive() == false,
 				   __msecs_to_jiffies(min_timeout));
@@ -1070,23 +1103,39 @@ static int ksmbd_durable_scavenger(void *dummy)
 		else
 			min_timeout = DURABLE_HANDLE_MAX_TIMEOUT;
 
-		write_lock(&global_ft.lock);
-		idr_for_each_entry(global_ft.idr, fp, id) {
-			if (!fp->durable_timeout)
-				continue;
+		do {
+			expired_fp = NULL;
+			found_fp_timeout = false;
 
-			if (atomic_read(&fp->refcount) > 1 ||
-			    fp->conn)
-				continue;
-
-			found_fp_timeout = true;
-			if (fp->durable_scavenger_timeout <=
-			    jiffies_to_msecs(jiffies)) {
-				__ksmbd_remove_durable_fd(fp);
-				list_add(&fp->node, &scavenger_list);
-			} else {
+			write_lock(&global_ft.lock);
+			idr_for_each_entry(global_ft.idr, fp, id) {
 				unsigned long durable_timeout;
 
+				if (!fp->durable_timeout)
+					continue;
+
+				if (atomic_read(&fp->refcount) > 1 ||
+				    fp->conn)
+					continue;
+
+				found_fp_timeout = true;
+				if (fp->durable_scavenger_timeout <=
+				    jiffies_to_msecs(jiffies)) {
+					__ksmbd_remove_durable_fd(fp);
+					/*
+					 * Take a transient reference so fp
+					 * cannot be freed by an in-flight
+					 * ksmbd_lookup_fd_inode() that found
+					 * it through f_ci->m_fp_list while we
+					 * drop global_ft.lock and reach the
+					 * m_fp_list unlink in
+					 * ksmbd_scavenger_dispose_dh().
+					 */
+					atomic_inc(&fp->refcount);
+					expired_fp = fp;
+					break;
+				}
+
 				durable_timeout =
 					fp->durable_scavenger_timeout -
 						jiffies_to_msecs(jiffies);
@@ -1094,10 +1143,11 @@ static int ksmbd_durable_scavenger(void *dummy)
 				if (min_timeout > durable_timeout)
 					min_timeout = durable_timeout;
 			}
-		}
-		write_unlock(&global_ft.lock);
+			write_unlock(&global_ft.lock);
 
-		ksmbd_scavenger_dispose_dh(&scavenger_list);
+			if (expired_fp)
+				ksmbd_scavenger_dispose_dh(expired_fp);
+		} while (expired_fp);
 
 		if (found_fp_timeout == false)
 			break;
-- 
2.43.0
