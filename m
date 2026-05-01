Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D933AB26C
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634447; cv=none; b=MrMtJOifocnKzsnGcUfCmLMnpEJHKxKTpDFDFf4wvQRLTtlTRWn7utWX5HHwuA9C471ec2luJgQzj8Vt9s7lOpPEwoF3GZD34Wf9Y7MchqbqSpHHli/MwPmcziGbV4ldcHPnm3pKZimMFda/jai3wg118xC4n+4zlZYXIam5yCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634447; c=relaxed/simple;
	bh=KrklyM46jEjug8lEQ/glvmg/6Li5t27U9mxLYKgqqpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InjaPOy/xmhmT+140nB8k0FEJySo98PMCi/2CYFwP8ZLn5f0a6iykLKTH+PJ5A6H+O1JATOZuLtCywFeIfJSvycxDGxhgPmsPAFDUwEqFKiwi9MKpuNHrvuP9njOvq2Kff1zKKlaSPZQko8tRovaART2lHI2w3J4KsyQzk93zr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d6uthFkw; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6uthFkw"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82ce2e2880cso1247830b3a.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634442; x=1778239242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rveh/HF8C3KXO4imN6PnFvTUaetb6aPc3faJz/Kya3Y=;
        b=d6uthFkwPihN73VWEXuH2C4c87ZX0RGbYGE5lYuqN5ytAw206HhzuQR63I7VWda4ZD
         ugNeBOaxe5NyX8WERlPPPhGWSxON7sP3839z60nzw8v1pkO49mA/MiSXd3/17UKJ+da0
         BYFDeTL+lvtoGjycIK8h2rkGrSDn4n9DwEwgawntg7DvK1MugE9MA3oJNSvelgbcaWKb
         csfWlGXksmU0dt579W/FasLy1+pFjzWS/Vr1RJH4FUvlozpaHc3U/LFOApGhT3hRbPT3
         JqYQ7CYhG3Ey9VT36fxY3JR84guOdX9XA4oFp49O+TcB8HZZzAIoOwMtzjs/8r1iCpc3
         ytsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634442; x=1778239242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rveh/HF8C3KXO4imN6PnFvTUaetb6aPc3faJz/Kya3Y=;
        b=eySy61bSwK02SWoGTDZ4LKo8Ox/GfEVTzDN3NXsD3ar1jYmbbziAfEsX7ocawZTCEM
         8OWWu+sF3YU7n/QmP+v2A685n1fwCja0TFLbqkV5mthwCgfauczDkTVA5rNwu4iCYjBT
         C7WggB2m1/Sexi6PsQSiP6go/HAJoVNc5P3YfKVWXJVeUH99jXpX1tixKfl+YzcNXJ+s
         t0c3rrfnJ2QuchhncWmYXxPJBB0DVR6VwMtbLmFW8Pbc8ZUjOtbU+GHMO6pAZJ0iZF/C
         2nHrBvuPKuJdW5Uc69IHPBH1vLizjwfsCoNQGdyAkieHUYlsyj5bhh6VKeR0nS15sFDj
         W1bA==
X-Gm-Message-State: AOJu0YzUduu03fLEW02WtWjVbRRR/LXM5PN1ANpjD2/JLmT5Kdde2eQI
	rtEvJwIQmJpCgZMw5GOnLgEoq3jtSbEF8qYCxNRs50//sPkSXVs3IS3g0zMCL6g/zrA=
X-Gm-Gg: AeBDieugMia2xbnielrglSdJ9SbVOkaeDFvbU1mOCjp64pFZ5ne3rcblztNxYg6euso
	HLq/Hdy5a5r5o0v+zJTzmYdEhCEIv2RzRpotZsimW521jj+cjYmFMXcXHyjexJm000RO9rMsDu4
	cXFroTgCLslImVSKOxEhLOjSbV03LJkmP7AO3Uaaho86SBhbbYqcxtg5YcxIrKlUaCi6+5tDDMV
	rGfddsFfuD6yODTAkN3z9gZm/nXBHaeI20tEXRJAQ8sGjbX9xt54La8S7noG0eSy2MOSbVgf8fa
	bEc/9Fp6xzd9bmEMEtUa1Ftu1x+eAZ0KBLM0pC7LuqI6VaZ2yqshC687x7Msd7HcaB09LCLQRB9
	oUyg/ASJrS+6e0FVZFjRop4aJAM0ABpm7KOerxKvkhPEfOAawUEU8WEoMbUZwH/GfZ3NcOyzwjV
	CBShc6HKc3N82f5D4G6rvK+qOkqNC62//flouX9nfQ2N1nK8cQ/8WHndMSmXSge0gp
X-Received: by 2002:a05:6a00:4407:b0:82c:6683:b866 with SMTP id d2e1a72fcca58-8351a0a5c0fmr2662533b3a.4.1777634441774;
        Fri, 01 May 2026 04:20:41 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:40 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 10/19] cifs: back cached_dirents with page cache
Date: Fri,  1 May 2026 16:50:13 +0530
Message-ID: <20260501112023.338005-10-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today the cached_dirents is a linked list with one entry per dentry.
This is very inefficient from the point of view of memory allocation
and memory management.

This change introduces a hybrid structure. cached_dirents will start
with maintaining a linked list for cached_dirents for small directories.
When the size of the directory (in terms of number of dirents) exceeds a
threshold (64), cached_dirents will now switch over to a folioq structure
to store the cached_dirents.

The idea is to reduce the number of memory allocations significantly for
large directories. Additionally, this change also tries to store short names
(names less than 64 bytes) in the folio itself, further reducing the
memory allocation calls. If the namelen is greater than 64 bytes or
if the folio does not have space to store more names, it falls back to kmalloc.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 1219 ++++++++++++++++++++++++++++++++----
 fs/smb/client/cached_dir.h |  141 ++++-
 fs/smb/client/cifsproto.h  |    1 +
 3 files changed, 1236 insertions(+), 125 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 614a241393b59..7cfbe50db66f5 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -6,22 +6,29 @@
  */
 
 #include <linux/namei.h>
+#include <linux/completion.h>
+#include <linux/kmemleak.h>
+#include <linux/hash.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
 #include "smb2proto.h"
 #include "cached_dir.h"
+#include "trace.h"
 
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
 
+#define CACHED_DIRENT_HASH_BITS	7
+
 struct cached_dir_dentry {
 	struct list_head entry;
 	struct dentry *dentry;
 };
 
+/* Generic helpers */
 bool cached_dir_is_valid(struct cached_fid *cfid)
 {
 	bool valid;
@@ -53,50 +60,689 @@ bool cached_dir_copy_lease_key(struct cached_fid *cfid,
 	return valid;
 }
 
+/* Cached mapping helpers */
+static inline const char *cached_dirent_name(const struct cifs_cached_dir_mapping *cached_mapping,
+					     const struct cached_dirent *de)
+{
+	if (de->external_name)
+		return de->name;
+
+	return ((const char *)cached_mapping) + de->inline_name_off;
+}
+
+static inline struct cifs_cached_dir_mapping *cached_dir_mapping(struct folio *folio)
+{
+	return folio_address(folio);
+}
+
+static inline size_t cached_dirent_array_bytes(unsigned int entries)
+{
+	return struct_size((struct cifs_cached_dir_mapping *)NULL, entries, entries);
+}
+
+static inline bool cached_dirent_has_space_for_record(const struct cifs_cached_dir_mapping *cached_mapping,
+						      size_t record_bytes)
+{
+	return cached_dirent_array_bytes(cached_mapping->entries_count + 1) + record_bytes <=
+		cached_mapping->name_tail_offset;
+}
+
+/* for short names, try to place them inside the folio */
+static bool cached_dirent_try_inline_name(struct folio *folio,
+					  struct cifs_cached_dir_mapping *cached_mapping,
+					  struct cached_dirent *de,
+					  const char *name,
+					  unsigned int namelen,
+					  const char **stored_name)
+{
+	char *base;
+	u32 tail;
+
+	if (namelen > CIFS_CACHED_INLINE_NAME_LEN)
+		return false;
+
+	/* try to fit cached_dirent+name in the same folio (inline) */
+	if (!cached_dirent_has_space_for_record(cached_mapping, namelen))
+		return false;
+
+	base = folio_address(folio);
+	if (!base)
+		return false;
+
+	tail = cached_mapping->name_tail_offset - namelen;
+	memcpy(base + tail, name, namelen);
+	de->external_name = false;
+	de->inline_name_off = tail;
+	de->name = NULL;
+	cached_mapping->name_tail_offset = tail;
+	*stored_name = base + tail;
+	return true;
+}
+
+static unsigned int cached_dir_folio_count(struct cached_dirents *cde)
+{
+	struct folio_queue *fq;
+	unsigned int count = 0;
+
+	for (fq = cde->folioq; fq; fq = fq->next) {
+		count += folioq_count(fq);
+	}
+
+	return count;
+}
+
+/* insert cursor helpers to aid fast appends to cached_dir */
+static void cached_dir_reset_insert_cursor_locked(struct cached_dirents *cde)
+{
+	cde->insert_cursor_fq = cde->folioq;
+	cde->insert_cursor_slot = 0;
+	cde->insert_cursor_folio_index = 0;
+}
+
+static void cached_dir_set_insert_cursor_locked(struct cached_dirents *cde,
+						struct folio_queue *fq,
+						unsigned int slot,
+						unsigned int folio_index)
+{
+	cde->insert_cursor_fq = fq;
+	cde->insert_cursor_slot = slot;
+	cde->insert_cursor_folio_index = folio_index;
+}
+
+static bool cached_dirents_use_folioq_locked(struct cached_dirents *cde)
+{
+	return cde->folioq != NULL;
+}
+
+static void cached_dir_init_new_folios(struct cached_dirents *cde,
+				       unsigned int old_folio_count)
+{
+	struct folio_queue *fq;
+	unsigned int folio_index = 0;
+
+	for (fq = cde->folioq; fq; fq = fq->next) {
+		for (int s = 0; s < folioq_count(fq); s++, folio_index++) {
+			struct folio *folio = folioq_folio(fq, s);
+			void *base;
+
+			if (folio_index < old_folio_count)
+				continue;
+
+			base = folio_address(folio);
+			if (base) {
+				memset(base, 0, folio_size(folio));
+				cached_dir_mapping(folio)->name_tail_offset = folio_size(folio);
+			}
+		}
+	}
+}
+
+/*
+ * Expand the folioq backing store for a cached directory by one PAGE_SIZE.
+ * Called by add_cached_dirent_folioq_locked() when no free slot is found in
+ * the existing folios, and by convert_cached_dirents_list_to_folioq_locked()
+ * when initializing folioq mode for the first time.
+ *
+ * After growing, newly added folios are zeroed and their name_tail_offset is
+ * set to folio_size so that inline name packing starts from the tail.
+ * The insert cursor must be reset by the caller after this returns.
+ */
+static int grow_cached_dirents_folioq_locked(struct cached_dirents *cde)
+{
+	unsigned int old_folio_count;
+	size_t old_size, target_size;
+	int rc;
+
+	old_folio_count = cached_dir_folio_count(cde);
+	old_size = cde->folioq_size;
+	target_size = old_size + PAGE_SIZE;
+
+	cifs_dbg(FYI,
+		 "cached_dir folioq alloc: old_size=%zu target_size=%zu\n",
+		 old_size, target_size);
+
+	rc = netfs_alloc_folioq_buffer(NULL, &cde->folioq,
+				      &cde->folioq_size,
+				      target_size, GFP_NOFS);
+	if (rc < 0)
+		return rc;
+
+	cached_dir_init_new_folios(cde, old_folio_count);
+
+	return 0;
+}
+
+/* lookup cached_dirent by traversing the list */
+static struct cached_dir_lookup_entry *lookup_cached_dirent_list_locked(struct cached_dirents *cde,
+							 const char *name,
+							 unsigned int namelen)
+{
+	struct cached_dir_lookup_entry *entry;
+	u32 name_hash;
+
+	name_hash = full_name_hash(NULL, name, namelen);
+
+	list_for_each_entry(entry, &cde->entry_list, list_node) {
+		if (entry->name_hash == name_hash &&
+		    entry->dirent &&
+		    entry->dirent->name_len == namelen &&
+		    memcmp(entry->dirent->name, name, namelen) == 0)
+			return entry;
+	}
+
+	return NULL;
+}
+
+/* lookup cached_dirent in folioq by using the hash table */
+static struct cached_dir_lookup_entry *lookup_cached_dirent_locked(struct cached_dirents *cde,
+								   const char *name,
+								   unsigned int namelen)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct hlist_head *bucket;
+	u32 name_hash;
+
+	if (!cde->lookup_ht)
+		return NULL;
+
+	name_hash = full_name_hash(NULL, name, namelen);
+	bucket = &cde->lookup_ht[hash_32(name_hash, CACHED_DIRENT_HASH_BITS)];
+
+	hlist_for_each_entry(entry, bucket, hash_node) {
+		if (entry->name_hash == name_hash &&
+		    entry->dirent &&
+		    entry->dirent->name_len == namelen &&
+		    memcmp(entry->dirent->name, name, namelen) == 0)
+			return entry;
+	}
+
+	return NULL;
+}
+
+/* lookup wrapper to decide if the entry is in list or folioq */
+static struct cached_dir_lookup_entry *lookup_cached_dirent_entry_locked(struct cached_dirents *cde,
+								  const char *name,
+								  unsigned int namelen)
+{
+	if (cached_dirents_use_folioq_locked(cde))
+		return lookup_cached_dirent_locked(cde, name, namelen);
+
+	return lookup_cached_dirent_list_locked(cde, name, namelen);
+}
+
+/* lookup the last cached_dir_mapping in the folioq */
+static struct cifs_cached_dir_mapping *last_cached_dir_mapping_locked(struct cached_dirents *cde)
+{
+	struct folio_queue *fq;
+	unsigned int slot;
+	struct cifs_cached_dir_mapping *last = NULL;
+
+	lockdep_assert_held(&cde->de_mutex);
+
+	if (!cde->folioq)
+		return NULL;
+
+	/* Fast path: the insert cursor tracks the most recent append location. */
+	if (cde->insert_cursor_fq) {
+		slot = cde->insert_cursor_slot;
+		if (slot < folioq_count(cde->insert_cursor_fq)) {
+			last = cached_dir_mapping(folioq_folio(cde->insert_cursor_fq, slot));
+			if (last && last->entries_count)
+				return last;
+		}
+	}
+
+	for (fq = cde->folioq; fq; fq = fq->next) {
+		for (int s = 0; s < folioq_count(fq); s++) {
+			struct cifs_cached_dir_mapping *cached_mapping;
+
+			cached_mapping = cached_dir_mapping(folioq_folio(fq, s));
+			if (cached_mapping && cached_mapping->entries_count)
+				last = cached_mapping;
+		}
+	}
+
+	return last;
+}
+
+/* emit dirents from the cache, starting with the current position of ctx */
 static bool emit_cached_dirents(struct cached_dirents *cde,
 				struct dir_context *ctx)
 {
-	struct cached_dirent *dirent;
+	struct folio_queue *fq;
 	bool rc;
 
 	lockdep_assert_held(&cde->de_mutex);
 
-	list_for_each_entry(dirent, &cde->entries, entry) {
-		/*
-		 * Skip all early entries prior to the current lseek()
-		 * position.
-		 */
-		if (ctx->pos > dirent->pos)
-			continue;
-		/*
-		 * We recorded the current ->pos value for the dirent
-		 * when we stored it in the cache.
-		 * However, this sequence of ->pos values may have holes
-		 * in it, for example dot-dirs returned from the server
-		 * are suppressed.
-		 * Handle this by forcing ctx->pos to be the same as the
-		 * ->pos of the current dirent we emit from the cache.
-		 * This means that when we emit these entries from the cache
-		 * we now emit them with the same ->pos value as in the
-		 * initial scan.
-		 */
-		ctx->pos = dirent->pos;
-		rc = dir_emit(ctx, dirent->name, dirent->namelen,
-			      dirent->fattr.cf_uniqueid,
-			      dirent->fattr.cf_dtype);
-		if (!rc)
-			return rc;
-		ctx->pos++;
+	/* if folioq is empty, this is a small dir; dirents will be found in list */
+	if (!cde->folioq) {
+		struct cached_dir_lookup_entry *entry;
+
+		list_for_each_entry(entry, &cde->entry_list, list_node) {
+			struct cached_dirent *dirent = entry->dirent;
+
+			if (dirent->tombstone)
+				continue;
+			if (ctx->pos > dirent->ctx_pos)
+				continue;
+
+			ctx->pos = dirent->ctx_pos;
+			rc = dir_emit(ctx, dirent->name, dirent->name_len,
+				      dirent->fattr.cf_uniqueid,
+				      dirent->fattr.cf_dtype);
+			if (!rc)
+				return rc;
+			ctx->pos++;
+		}
+
+		return cde->is_valid;
 	}
+
+	/* large dir; emit from folioq */
+	for (fq = cde->folioq; fq; fq = fq->next) {
+		for (int s = 0; s < folioq_count(fq); s++) {
+			struct folio *folio = folioq_folio(fq, s);
+			struct cifs_cached_dir_mapping *cached_mapping;
+
+			cached_mapping = cached_dir_mapping(folio);
+			if (!cached_mapping)
+				return false;
+
+			for (u32 i = 0; i < cached_mapping->entries_count; i++) {
+				struct cached_dirent *dirent = &cached_mapping->entries[i];
+				const char *name;
+
+				if (dirent->tombstone)
+					continue;
+
+				name = cached_dirent_name(cached_mapping, dirent);
+
+				/*
+				 * Skip all early entries prior to the current lseek()
+				 * position.
+				 */
+				if (ctx->pos > dirent->ctx_pos)
+					continue;
+				/*
+				 * We recorded the current ->pos value for the dirent
+				 * when we stored it in the cache.
+				 * However, this sequence of ->pos values may have holes
+				 * in it, for example dot-dirs returned from the server
+				 * are suppressed.
+				 * Handle this by forcing ctx->pos to be the same as the
+				 * ->pos of the current dirent we emit from the cache.
+				 * This means that when we emit these entries from the cache
+				 * we now emit them with the same ->pos value as in the
+				 * initial scan.
+				 */
+				ctx->pos = dirent->ctx_pos;
+				rc = dir_emit(ctx, name, dirent->name_len,
+					      dirent->fattr.cf_uniqueid,
+					      dirent->fattr.cf_dtype);
+				if (!rc)
+					return rc;
+				ctx->pos++;
+			}
+
+			if (cached_mapping->folio_is_eof)
+				return true;
+		}
+	}
+	return true;
+}
+
+/* release the lookup hashtable */
+static void release_lookup_table_locked(struct cached_dirents *cde)
+{
+	int bucket;
+
+	if (!cde->lookup_ht)
+		return;
+
+	for (bucket = 0; bucket < (1 << CACHED_DIRENT_HASH_BITS); bucket++) {
+		struct cached_dir_lookup_entry *entry;
+		struct hlist_node *tmp;
+
+		hlist_for_each_entry_safe(entry, tmp, &cde->lookup_ht[bucket], hash_node) {
+			hlist_del(&entry->hash_node);
+			kfree(entry);
+		}
+	}
+
+	kfree(cde->lookup_ht);
+	cde->lookup_ht = NULL;
+	cde->lookup_bytes = 0;
+}
+
+/* release all cached_dirents in list */
+static void release_cached_dirents_list_locked(struct cached_dirents *cde)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dir_lookup_entry *tmp;
+
+	list_for_each_entry_safe(entry, tmp, &cde->entry_list, list_node) {
+		list_del(&entry->list_node);
+		if (entry->dirent) {
+			if (entry->dirent->external_name)
+				kfree((void *)entry->dirent->name);
+			kfree(entry->dirent);
+		}
+		kfree(entry);
+	}
+
+	cde->entry_list_count = 0;
+}
+
+/* release all cached_dirents in folioq */
+static void release_cached_dirents_folioq_locked(struct cached_dirents *cde)
+{
+	struct folio_queue *fq;
+
+	lockdep_assert_held(&cde->de_mutex);
+
+	for (fq = cde->folioq; fq; fq = fq->next) {
+		for (int s = 0; s < folioq_count(fq); s++) {
+			struct folio *folio = folioq_folio(fq, s);
+			struct cifs_cached_dir_mapping *cached_mapping;
+
+			cached_mapping = cached_dir_mapping(folio);
+			if (!cached_mapping)
+				continue;
+
+			for (u32 i = 0; i < cached_mapping->entries_count; i++)
+				if (cached_mapping->entries[i].external_name)
+					kfree((void *)cached_mapping->entries[i].name);
+		}
+	}
+
+	if (cde->folioq) {
+		cifs_dbg(FYI, "cached_dir folioq free: old_size=%zu target_size=%d\n",
+			 cde->folioq_size, 0);
+		netfs_free_folioq_buffer(cde->folioq);
+		cde->folioq = NULL;
+	}
+
+	cde->folioq_size = 0;
+}
+
+/* release wrapper for cached_dirents */
+static void release_cached_dirents_locked(struct cached_dirents *cde)
+{
+	lockdep_assert_held(&cde->de_mutex);
+
+	if (cached_dirents_use_folioq_locked(cde))
+		release_cached_dirents_folioq_locked(cde);
+	else
+		release_cached_dirents_list_locked(cde);
+
+	release_lookup_table_locked(cde);
+
+	cde->entries_count = 0;
+	cde->external_name_bytes = 0;
+	cde->lookup_bytes = 0;
+	cde->bytes_used = 0;
+	cde->dir_inode = NULL;
+	cached_dir_reset_insert_cursor_locked(cde);
+}
+
+/* invalidate cached_dirents and release resources, but keep the cache structure for reuse */
+static void fail_cached_dir_locked(struct cached_dirents *cde)
+{
+	cde->is_failed = 1;
+	release_cached_dirents_locked(cde);
+	/*
+	 * Reset the file pointer so the next cifs_readdir from position 0
+	 * can claim this slot and repopulate the cache.
+	 */
+	cde->file = NULL;
+}
+
+/* insert cached_dirent into lookup hashtable */
+static int insert_cached_dir_lookup_locked(struct cached_dirents *cde,
+					   const char *name,
+					   unsigned int namelen,
+					   struct cached_dirent *dirent,
+					   bool pending_dcache)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct hlist_head *bucket;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	entry->name_hash = full_name_hash(NULL, name, namelen);
+	entry->dirent = dirent;
+	entry->pending_dcache = pending_dcache;
+	init_completion(&entry->dcache_complete);
+
+	bucket = &cde->lookup_ht[hash_32(entry->name_hash, CACHED_DIRENT_HASH_BITS)];
+	hlist_add_head(&entry->hash_node, bucket);
+	cde->lookup_bytes += sizeof(*entry);
+	return 0;
+}
+
+/* add cached_dirent to folioq */
+static bool add_cached_dirent_folioq_locked(struct cached_dirents *cde,
+					    loff_t ctx_pos,
+					    const char *name,
+					    unsigned int namelen,
+					    const struct cifs_fattr *fattr,
+					    bool pending_dcache)
+{
+	struct cached_dirent *de;
+	struct cifs_cached_dir_mapping *cached_mapping = NULL;
+	const char *stored_name;
+	struct folio *target_folio = NULL;
+	struct folio_queue *fq;
+	unsigned int cur_folio;
+	unsigned int start_slot;
+	int rc;
+	bool grew = false;
+
+	if (!cde->lookup_ht) {
+		cde->lookup_ht = kcalloc(1 << CACHED_DIRENT_HASH_BITS,
+					 sizeof(*cde->lookup_ht), GFP_KERNEL);
+		if (!cde->lookup_ht) {
+			fail_cached_dir_locked(cde);
+			return false;
+		}
+	}
+
+	/* Grow phase: ensure folioq exists */
+	if (!cde->folioq) {
+		rc = grow_cached_dirents_folioq_locked(cde);
+		if (rc < 0) {
+			fail_cached_dir_locked(cde);
+			return false;
+		}
+		cached_dir_reset_insert_cursor_locked(cde);
+	}
+
+	if (!cde->insert_cursor_fq)
+		cached_dir_reset_insert_cursor_locked(cde);
+
+retry_insert:
+	/* Insertion phase: try to find space in current folios */
+	de = NULL;
+	fq = cde->insert_cursor_fq;
+	start_slot = cde->insert_cursor_slot;
+	cur_folio = cde->insert_cursor_folio_index;
+	if (!fq) {
+		fq = cde->folioq;
+		start_slot = 0;
+		cur_folio = 0;
+	}
+
+	for (; fq && !de; fq = fq->next) {
+		for (int s = start_slot; s < folioq_count(fq) && !de; s++, cur_folio++) {
+			struct folio *folio = folioq_folio(fq, s);
+
+			cached_mapping = cached_dir_mapping(folio);
+			if (!cached_mapping)
+				continue;
+
+			if (cached_mapping->folio_full)
+				continue;
+
+			if (cached_dirent_has_space_for_record(cached_mapping, 0)) {
+				target_folio = folio;
+				de = &cached_mapping->entries[cached_mapping->entries_count];
+				cached_dir_set_insert_cursor_locked(cde, fq, s, cur_folio);
+				break;
+			}
+
+			cached_mapping->folio_full = 1;
+		}
+		start_slot = 0;
+	}
+
+	/* If no space found and haven't grown yet, grow and retry once */
+	if (!de && !grew) {
+		rc = grow_cached_dirents_folioq_locked(cde);
+		if (rc < 0) {
+			fail_cached_dir_locked(cde);
+			return false;
+		}
+
+		cached_dir_reset_insert_cursor_locked(cde);
+		grew = true;
+		goto retry_insert;
+	}
+
+	if (!de) {
+		fail_cached_dir_locked(cde);
+		return false;
+	}
+
+	memset(de, 0, sizeof(*de));
+	de->name_len = namelen;
+	de->ctx_pos = ctx_pos;
+	memcpy(&de->fattr, fattr, sizeof(*fattr));
+	stored_name = NULL;
+	if (!cached_dirent_try_inline_name(target_folio, cached_mapping, de,
+					      name, namelen, &stored_name)) {
+		de->name = kstrndup(name, namelen, GFP_KERNEL);
+		if (!de->name) {
+			fail_cached_dir_locked(cde);
+			return false;
+		}
+		kmemleak_not_leak((void *)de->name);
+		de->external_name = true;
+		cde->external_name_bytes += (size_t)namelen + 1;
+		stored_name = de->name;
+	} else {
+		de->external_name = false;
+	}
+	de->name = stored_name;
+
+	if (insert_cached_dir_lookup_locked(cde, stored_name, namelen,
+				   de,
+				   pending_dcache) < 0) {
+		if (de->external_name)
+			kfree((void *)de->name);
+		memset(de, 0, sizeof(*de));
+		fail_cached_dir_locked(cde);
+		return false;
+	}
+
+	cached_mapping->entries_count++;
+	cde->entries_count++;
+	cde->bytes_used = cde->folioq_size + cde->external_name_bytes +
+				  cde->lookup_bytes;
+	return true;
+}
+
+/* add cached_dirent to list */
+static bool add_cached_dirent_list_locked(struct cached_dirents *cde,
+					  loff_t ctx_pos,
+					  const char *name,
+					  unsigned int namelen,
+					  const struct cifs_fattr *fattr)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dirent *de;
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return false;
+
+	de = kzalloc(sizeof(*de), GFP_KERNEL);
+	if (!de) {
+		kfree(entry);
+		return false;
+	}
+
+	de->name = kstrndup(name, namelen, GFP_KERNEL);
+	if (!de->name) {
+		kfree(de);
+		kfree(entry);
+		return false;
+	}
+
+	de->name_len = namelen;
+	de->external_name = true;
+	de->ctx_pos = ctx_pos;
+	memcpy(&de->fattr, fattr, sizeof(*fattr));
+
+	entry->dirent = de;
+	entry->name_hash = full_name_hash(NULL, name, namelen);
+	entry->pending_dcache = false;
+	list_add_tail(&entry->list_node, &cde->entry_list);
+
+	cde->entry_list_count++;
+	cde->entries_count++;
+	cde->external_name_bytes += (size_t)namelen + 1;
+	cde->bytes_used = cde->external_name_bytes +
+			  cde->entry_list_count * (sizeof(*entry) + sizeof(*de));
 	return true;
 }
 
+/* convert cached_dirents from list to folioq format, freeing list entries */
+static int convert_cached_dirents_list_to_folioq_locked(struct cached_dirents *cde)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dir_lookup_entry *tmp;
+	unsigned long restored_entries = 0;
+
+	if (cde->folioq)
+		return 0;
+
+	release_lookup_table_locked(cde);
+	cde->entries_count = 0;
+	cde->external_name_bytes = 0;
+	cde->lookup_bytes = 0;
+	cde->bytes_used = 0;
+
+	list_for_each_entry_safe(entry, tmp, &cde->entry_list, list_node) {
+		if (!add_cached_dirent_folioq_locked(cde, entry->dirent->ctx_pos,
+						   entry->dirent->name,
+						   entry->dirent->name_len,
+						   &entry->dirent->fattr, false)) {
+			return -ENOMEM;
+		}
+
+		restored_entries++;
+		list_del(&entry->list_node);
+		kfree((void *)entry->dirent->name);
+		kfree(entry->dirent);
+		kfree(entry);
+	}
+
+	cde->entry_list_count = 0;
+	cde->entries_count = restored_entries;
+	cde->bytes_used = cde->folioq_size + cde->external_name_bytes +
+			  cde->lookup_bytes;
+	return 0;
+}
+
+/* add cached_dirent, deciding whether to put it in the list or folioq */
 static bool add_cached_dirent(struct cached_dirents *cde,
 			      struct dir_context *ctx, const char *name,
 			      int namelen, struct cifs_fattr *fattr,
 			      struct file *file)
 {
-	struct cached_dirent *de;
+	int rc;
 
 	lockdep_assert_held(&cde->de_mutex);
 
@@ -105,32 +751,36 @@ static bool add_cached_dirent(struct cached_dirents *cde,
 	if (cde->is_valid || cde->is_failed)
 		return false;
 	if (ctx->pos != cde->pos) {
-		cde->is_failed = 1;
+		fail_cached_dir_locked(cde);
 		return false;
 	}
-	de = kzalloc_obj(*de, GFP_KERNEL);
-	if (de == NULL) {
-		cde->is_failed = 1;
-		return false;
+
+	if (!cached_dirents_use_folioq_locked(cde)) {
+		if (cde->entry_list_count < CIFS_CACHED_DIRENT_LIST_THRESHOLD)
+			return add_cached_dirent_list_locked(cde, ctx->pos, name,
+						     namelen, fattr);
+
+		rc = convert_cached_dirents_list_to_folioq_locked(cde);
+		if (rc < 0) {
+			fail_cached_dir_locked(cde);
+			return false;
+		}
 	}
-	de->namelen = namelen;
-	de->name = kstrndup(name, namelen, GFP_KERNEL);
-	if (de->name == NULL) {
-		kfree(de);
-		cde->is_failed = 1;
+
+	if (!add_cached_dirent_folioq_locked(cde, ctx->pos, name, namelen, fattr,
+					     true)) {
+		fail_cached_dir_locked(cde);
 		return false;
 	}
-	de->pos = ctx->pos;
 
-	memcpy(&de->fattr, fattr, sizeof(struct cifs_fattr));
-
-	list_add_tail(&de->entry, &cde->entries);
-	/* update accounting */
-	cde->entries_count++;
-	cde->bytes_used += sizeof(*de) + (size_t)namelen + 1;
 	return true;
 }
 
+/*
+ * emit cached dirents for the current ctx position if the cache is valid.
+ * If there is no ongoing population for this directory (ctx->pos == 0) then
+ * make the ongoing readdir call responsible for populating the cache
+ */
 bool emit_cached_dir_if_valid(struct cached_fid *cfid,
 			      struct file *file,
 			      struct dir_context *ctx)
@@ -146,7 +796,15 @@ bool emit_cached_dir_if_valid(struct cached_fid *cfid,
 	 */
 	if (ctx->pos == 0 && cfid->dirents.file == NULL) {
 		cfid->dirents.file = file;
+		cfid->dirents.dir_inode = file_inode(file);
 		cfid->dirents.pos = 2;
+		cached_dir_reset_insert_cursor_locked(&cfid->dirents);
+		/*
+		 * A previous population attempt may have failed and left
+		 * is_failed set.  Clear it now so add_cached_dirent() will
+		 * accept new entries from this readdir pass.
+		 */
+		cfid->dirents.is_failed = 0;
 	}
 
 	if (!cfid->dirents.is_valid) {
@@ -161,6 +819,155 @@ bool emit_cached_dir_if_valid(struct cached_fid *cfid,
 	return true;
 }
 
+/* update the cached dir position during a readdir population pass */
+static void update_cached_dirents_count(struct cached_dirents *cde,
+					struct file *file)
+{
+	if (cde->file != file)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+
+	cde->pos++;
+}
+
+/* mark the cached_dirents as valid if readdir population pass completed successfully */
+static void finished_cached_dirents_count(struct cached_dirents *cde,
+					  struct dir_context *ctx,
+					  struct file *file)
+{
+	struct cifs_cached_dir_mapping *cached_mapping;
+
+	if (cde->file != file)
+		return;
+	if (cde->is_valid || cde->is_failed)
+		return;
+	if (ctx->pos != cde->pos)
+		return;
+
+	cached_mapping = last_cached_dir_mapping_locked(cde);
+	if (cached_mapping)
+		cached_mapping->folio_is_eof = 1;
+
+	cde->is_valid = 1;
+}
+
+/* update the cached_dirent for a given name in list */
+static bool update_cached_dirent_list_locked(struct cached_dirents *cde,
+						     const char *name,
+						     unsigned int namelen,
+						     const struct cifs_fattr *fattr)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dirent *dirent;
+
+	entry = lookup_cached_dirent_list_locked(cde, name, namelen);
+	if (!entry)
+		return false;
+
+	dirent = entry->dirent;
+	if (!dirent)
+		return false;
+
+	memcpy(&dirent->fattr, fattr, sizeof(dirent->fattr));
+	dirent->tombstone = false;
+	return true;
+}
+
+/* update the cached_dirent for a given name in folioq */
+static bool update_cached_dirent_folioq_locked(struct cached_dirents *cde,
+						       const char *name,
+						       unsigned int namelen,
+						       const struct cifs_fattr *fattr)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dirent *dirent;
+
+	entry = lookup_cached_dirent_locked(cde, name, namelen);
+	if (!entry)
+		return false;
+
+	dirent = entry->dirent;
+	if (!dirent)
+		return false;
+
+	memcpy(&dirent->fattr, fattr, sizeof(dirent->fattr));
+	dirent->tombstone = false;
+	return true;
+}
+
+/* update wrapper to decide if the entry is in list or folioq */
+static bool update_cached_dirent_locked(struct cached_dirents *cde,
+						const char *name,
+						unsigned int namelen,
+						const struct cifs_fattr *fattr)
+{
+	if (cached_dirents_use_folioq_locked(cde))
+		return update_cached_dirent_folioq_locked(cde, name, namelen,
+							  fattr);
+
+	return update_cached_dirent_list_locked(cde, name, namelen,
+							 fattr);
+}
+
+/* invalidate a cached_dirent by name in list */
+static bool invalidate_cached_dirent_list_locked(struct cached_dirents *cde,
+						 const char *name,
+						 unsigned int namelen)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dirent *dirent;
+
+	entry = lookup_cached_dirent_list_locked(cde, name, namelen);
+	if (!entry)
+		return true;
+
+	dirent = entry->dirent;
+	if (!dirent)
+		return true;
+
+	dirent->tombstone = true;
+	return true;
+}
+
+/* invalidate a cached_dirent by name in folioq */
+static bool invalidate_cached_dirent_folioq_locked(struct cached_dirents *cde,
+						   const char *name,
+						   unsigned int namelen)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dirent *dirent;
+
+	entry = lookup_cached_dirent_locked(cde, name, namelen);
+	if (!entry)
+		return true;
+
+	dirent = entry->dirent;
+	if (!dirent)
+		return false;
+
+	dirent->tombstone = true;
+	if (entry->pending_dcache) {
+		entry->pending_dcache = false;
+		complete_all(&entry->dcache_complete);
+	}
+
+	return true;
+}
+
+/* invalidate wrapper to decide if the entry is in list or folioq */
+static bool invalidate_cached_dirent_locked(struct cached_dirents *cde,
+						const char *name,
+						unsigned int namelen)
+{
+	if (cached_dirents_use_folioq_locked(cde))
+		return invalidate_cached_dirent_folioq_locked(cde, name,
+							      namelen);
+
+	return invalidate_cached_dirent_list_locked(cde, name, namelen);
+}
+
+/* append a dirent to the cached_dir */
 bool add_to_cached_dir(struct cached_fid *cfid,
 		       struct dir_context *ctx,
 		       const char *name,
@@ -168,96 +975,258 @@ bool add_to_cached_dir(struct cached_fid *cfid,
 		       struct cifs_fattr *fattr,
 		       struct file *file)
 {
-	size_t delta_bytes;
+	unsigned long old_entries;
+	unsigned long new_entries;
+	u64 old_bytes;
+	u64 new_bytes;
+	long entry_diff;
+	long long bytes_diff;
 	bool added = false;
 
 	if (!cfid)
 		return false;
 
-	/* Cost of this entry */
-	delta_bytes = sizeof(struct cached_dirent) + (size_t)namelen + 1;
-
 	mutex_lock(&cfid->dirents.de_mutex);
+	old_entries = cfid->dirents.entries_count;
+	old_bytes = cfid->dirents.bytes_used;
 	added = add_cached_dirent(&cfid->dirents, ctx, name, namelen,
 				  fattr, file);
+	new_entries = cfid->dirents.entries_count;
+	new_bytes = cfid->dirents.bytes_used;
 	mutex_unlock(&cfid->dirents.de_mutex);
 
-	if (added) {
-		/* per-tcon then global for consistency with free path */
-		atomic64_add((long long)delta_bytes, &cfid->cfids->total_dirents_bytes);
-		atomic_long_inc(&cfid->cfids->total_dirents_entries);
-		atomic64_add((long long)delta_bytes, &cifs_dircache_bytes_used);
+	entry_diff = (long)new_entries - (long)old_entries;
+	bytes_diff = (long long)new_bytes - (long long)old_bytes;
+
+	if (entry_diff > 0) {
+		atomic_long_add(entry_diff, &cfid->cfids->total_dirents_entries);
+	} else if (entry_diff < 0) {
+		atomic_long_sub(-entry_diff, &cfid->cfids->total_dirents_entries);
+	}
+
+	if (bytes_diff > 0) {
+		atomic64_add(bytes_diff, &cfid->cfids->total_dirents_bytes);
+		atomic64_add(bytes_diff, &cifs_dircache_bytes_used);
+	} else if (bytes_diff < 0) {
+		atomic64_sub(-bytes_diff, &cfid->cfids->total_dirents_bytes);
+		atomic64_sub(-bytes_diff, &cifs_dircache_bytes_used);
 	}
 
+
 	return added;
 }
 
-static void update_cached_dirents_count(struct cached_dirents *cde,
-					struct file *file)
+/* update the cached_dir position during a readdir population pass */
+void update_pos_cached_dir(struct cached_fid *cfid,
+				      struct file *file)
 {
-	if (cde->file != file)
-		return;
-	if (cde->is_valid || cde->is_failed)
+	if (!cfid)
 		return;
 
-	cde->pos++;
+	mutex_lock(&cfid->dirents.de_mutex);
+	update_cached_dirents_count(&cfid->dirents, file);
+	mutex_unlock(&cfid->dirents.de_mutex);
 }
 
-static void finished_cached_dirents_count(struct cached_dirents *cde,
-					  struct dir_context *ctx,
-					  struct file *file)
+/* signal completion of cached_dir population after a readdir pass */
+void complete_cached_dir(struct cached_fid *cfid,
+					struct dir_context *ctx,
+					struct file *file)
 {
-	if (cde->file != file)
-		return;
-	if (cde->is_valid || cde->is_failed)
-		return;
-	if (ctx->pos != cde->pos)
+	struct cached_dirents *cde;
+
+	if (!cfid)
 		return;
 
-	cde->is_valid = 1;
+	cde = &cfid->dirents;
+	mutex_lock(&cfid->dirents.de_mutex);
+	finished_cached_dirents_count(cde, ctx, file);
+	mutex_unlock(&cfid->dirents.de_mutex);
 }
 
-void update_pos_cached_dir(struct cached_fid *cfid,
-				      struct file *file)
+/*
+ * lookup a cached_dirent by name, returning -ENOENT if not found or if the
+ * entry is a tombstone.  The result struct is filled in with the fattr of the
+ * found entry, and flags indicating whether the entry was found, whether the
+ * cache was fully populated at the time of lookup, and whether there was an
+ * active lease on the directory at the time of lookup.
+ */
+int lookup_cached_dir(struct cached_fid *cfid,
+				 const char *name,
+				 unsigned int namelen,
+				 struct cached_dirent_lookup_result *result)
+{
+	struct cached_dir_lookup_entry *entry;
+	struct cached_dirent *dirent;
+	bool lease_active;
+
+	if (!cfid || !name || !namelen || !result)
+		return -EINVAL;
+
+	memset(result, 0, sizeof(*result));
+
+	spin_lock(&cfid->cfid_lock);
+	lease_active = is_valid_cached_dir(cfid);
+	spin_unlock(&cfid->cfid_lock);
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	result->under_active_lease = lease_active;
+	result->fully_populated = cfid->dirents.is_valid;
+
+	entry = lookup_cached_dirent_entry_locked(&cfid->dirents, name, namelen);
+	if (!entry || !entry->dirent) {
+		mutex_unlock(&cfid->dirents.de_mutex);
+		return -ENOENT;
+	}
+
+	dirent = entry->dirent;
+	if (dirent->tombstone) {
+		mutex_unlock(&cfid->dirents.de_mutex);
+		return -ENOENT;
+	}
+
+	result->found = true;
+	memcpy(&result->fattr, &dirent->fattr, sizeof(result->fattr));
+
+	mutex_unlock(&cfid->dirents.de_mutex);
+	return 0;
+}
+
+/*
+ * Invalidate all cached_dirents for a cached_fid. We generally
+ * try to invalidate specific entries by name. This is used as
+ * a last resort when we can't invalidate specific entries
+ */
+void invalidate_cached_dir_contents(struct cached_fid *cfid)
 {
 	if (!cfid)
 		return;
 
 	mutex_lock(&cfid->dirents.de_mutex);
-	update_cached_dirents_count(&cfid->dirents, file);
+	fail_cached_dir_locked(&cfid->dirents);
 	mutex_unlock(&cfid->dirents.de_mutex);
 }
 
-void complete_cached_dir(struct cached_fid *cfid,
-					struct dir_context *ctx,
-					struct file *file)
+/*
+ * Update a cached_dirent for a given name.  Returns true if the entry was
+ * found and updated, false if the entry was not found or if the cache is not
+ * valid.
+ */
+bool update_dirent_in_cached_dir(struct cached_fid *cfid,
+				  const char *name,
+				  unsigned int namelen,
+				  const struct cifs_fattr *fattr)
+{
+	bool updated = false;
+
+	if (!cfid || !name || !namelen || !fattr)
+		return false;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	updated = update_cached_dirent_locked(&cfid->dirents, name,
+						      namelen, fattr);
+	mutex_unlock(&cfid->dirents.de_mutex);
+	return updated;
+}
+
+/*
+ * Invalidate a cached_dirent for a given name.  Returns true if the entry was
+ * found and invalidated, false if the entry was not found or if the cache is
+ * not valid.
+ */
+bool invalidate_dirent_in_cached_dir(struct cached_fid *cfid,
+				      const char *name,
+				      unsigned int namelen)
 {
+	bool invalidated = false;
+
+	if (!cfid || !name || !namelen)
+		return false;
+	if (!cached_dir_is_valid(cfid))
+		return false;
+
+	mutex_lock(&cfid->dirents.de_mutex);
+	if (!cfid->dirents.is_valid || cfid->dirents.is_failed)
+		goto out_unlock;
+
+	invalidated = invalidate_cached_dirent_locked(&cfid->dirents,
+							 name, namelen);
+
+out_unlock:
+	mutex_unlock(&cfid->dirents.de_mutex);
+	return invalidated;
+}
+
+/*
+ * Signal completion of dcache population for a specific dirent.
+ * Called after cifs_prime_dcache returns, on both sync and async paths.
+ * Clears the pending_dcache flag and unblocks any waiting lookups.
+ */
+void cifs_complete_pending_dcache(struct cached_fid *cfid,
+		const char *name, unsigned int namelen)
+{
+	struct cached_dir_lookup_entry *entry;
+	bool uses_folioq;
+	int ret = -ENOENT;
+
 	if (!cfid)
 		return;
 
 	mutex_lock(&cfid->dirents.de_mutex);
-	finished_cached_dirents_count(&cfid->dirents, ctx, file);
+	uses_folioq = cached_dirents_use_folioq_locked(&cfid->dirents);
+	entry = lookup_cached_dirent_entry_locked(&cfid->dirents, name, namelen);
+	if (entry) {
+		if (uses_folioq && entry->pending_dcache) {
+			entry->pending_dcache = false;
+			complete_all(&entry->dcache_complete);
+		}
+		ret = 0;
+	}
 	mutex_unlock(&cfid->dirents.de_mutex);
+	cifs_dbg(FYI, "Dcache population of %.*s. status: %d\n",
+					namelen, name, ret);
 }
 
-struct cached_dirent *lookup_cached_dirent(struct cached_dirents *cde,
-				   const char *name,
-				   unsigned int namelen)
+/*
+ * Signal completion of dcache population for a specific dirent.
+ * Wait for async dcache population to complete for a specific dirent.
+ * Returns: 0 on completion or entry not pending, -ETIMEDOUT on timeout,
+ *          -ENOENT if entry not found in the cache.
+ */
+int cifs_wait_for_pending_dcache(struct cached_fid *cfid,
+		const char *name, unsigned int namelen)
 {
-	struct cached_dirent *entry;
+	struct cached_dir_lookup_entry *entry;
+	bool uses_folioq;
+	struct completion *comp = NULL;
+	int ret = -ENOENT;
 
-	if (!cde)
-		return NULL;
+	if (!cfid)
+		return -ENOENT;
 
-	lockdep_assert_held(&cde->de_mutex);
+	mutex_lock(&cfid->dirents.de_mutex);
+	uses_folioq = cached_dirents_use_folioq_locked(&cfid->dirents);
+	entry = lookup_cached_dirent_entry_locked(&cfid->dirents, name, namelen);
+	if (entry) {
+		ret = 0;
+		if (uses_folioq && entry->pending_dcache)
+			comp = &entry->dcache_complete;
+	}
+	mutex_unlock(&cfid->dirents.de_mutex);
 
-	list_for_each_entry(entry, &cde->entries, entry) {
-		if (entry->namelen == namelen &&
-		    memcmp(entry->name, name, namelen) == 0)
-			return entry;
+	if (comp) {
+		if (wait_for_completion_timeout(comp, CIFS_DCACHE_WAIT_TIMEOUT) == 0) {
+			cifs_dbg(FYI, "Timeout waiting for dcache population of %.*s\n",
+					namelen, name);
+			ret = -ETIMEDOUT;
+		} else {
+			cifs_dbg(FYI, "Dcache population completed for %.*s\n",
+					namelen, name);
+			ret = 0;
+		}
 	}
 
-	return NULL;
+	return ret;
 }
 
 static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
@@ -682,7 +1651,9 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			      struct cached_fid **ret_cfid)
 {
 	struct cached_fid *cfid;
+	struct cached_fid *trace_cfid = NULL;
 	struct cached_fids *cfids = tcon->cfids;
+	int rc = -ENOENT;
 
 	if (cfids == NULL)
 		return -EOPNOTSUPP;
@@ -702,13 +1673,15 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
 			cfid->last_access_time = jiffies;
+			rc = 0;
+			trace_cfid = cfid;
 			spin_unlock(&cfid->cfid_lock);
 			spin_unlock(&cfids->cfid_list_lock);
-			return 0;
+			return rc;
 		}
 	}
 	spin_unlock(&cfids->cfid_list_lock);
-	return -ENOENT;
+	return rc;
 }
 
 static void
@@ -853,10 +1826,10 @@ void close_all_cached_dirs(struct cifs_sb_info *cifs_sb)
 }
 
 /*
- * Invalidate all cached dirs when a TCON has been reset
- * due to a session loss.
+ * Queue all cached dirs for invalidation on laundromat without waiting.
+ * Safe for callers that hold cifs_tcp_ses_lock.
  */
-void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
+void invalidate_all_cached_dirs_nowait(struct cifs_tcon *tcon)
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid, *q;
@@ -890,8 +1863,22 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
-	/* run laundromat unconditionally now as there might have been previously queued work */
+	/* Run laundromat now as there might have been previously queued work. */
 	mod_delayed_work(cfid_put_wq, &cfids->laundromat_work, 0);
+}
+
+/*
+ * Invalidate all cached dirs when a TCON has been reset
+ * due to a session loss.
+ */
+void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
+{
+	struct cached_fids *cfids = tcon->cfids;
+
+	if (!cfids)
+		return;
+
+	invalidate_all_cached_dirs_nowait(tcon);
 	flush_delayed_work(&cfids->laundromat_work);
 }
 
@@ -980,7 +1967,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_WORK(&cfid->close_work, cached_dir_offload_close);
 	INIT_WORK(&cfid->put_work, cached_dir_put_work);
 	INIT_LIST_HEAD(&cfid->entry);
-	INIT_LIST_HEAD(&cfid->dirents.entries);
+	INIT_LIST_HEAD(&cfid->dirents.entry_list);
 	mutex_init(&cfid->dirents.de_mutex);
 	mutex_init(&cfid->cfid_open_mutex);
 	spin_lock_init(&cfid->cfid_lock);
@@ -990,38 +1977,34 @@ static struct cached_fid *init_cached_dir(const char *path)
 
 static void free_cached_dir(struct cached_fid *cfid)
 {
-	struct cached_dirent *dirent, *q;
+	unsigned long entries_count = 0;
+	u64 bytes_used = 0;
 
 	WARN_ON(work_pending(&cfid->close_work));
 	WARN_ON(work_pending(&cfid->put_work));
 
+
 	dput(cfid->dentry);
 	cfid->dentry = NULL;
 
-	/*
-	 * Delete all cached dirent names
-	 */
-	list_for_each_entry_safe(dirent, q, &cfid->dirents.entries, entry) {
-		list_del(&dirent->entry);
-		kfree(dirent->name);
-		kfree(dirent);
-	}
+	mutex_lock(&cfid->dirents.de_mutex);
+	entries_count = cfid->dirents.entries_count;
+	bytes_used = cfid->dirents.bytes_used;
+	release_cached_dirents_locked(&cfid->dirents);
+	mutex_unlock(&cfid->dirents.de_mutex);
 
 	/* adjust tcon-level counters and reset per-dir accounting */
 	if (cfid->cfids) {
-		if (cfid->dirents.entries_count)
-			atomic_long_sub((long)cfid->dirents.entries_count,
+		if (entries_count)
+			atomic_long_sub((long)entries_count,
 					&cfid->cfids->total_dirents_entries);
-		if (cfid->dirents.bytes_used) {
-			atomic64_sub((long long)cfid->dirents.bytes_used,
+		if (bytes_used) {
+			atomic64_sub((long long)bytes_used,
 					&cfid->cfids->total_dirents_bytes);
-			atomic64_sub((long long)cfid->dirents.bytes_used,
+			atomic64_sub((long long)bytes_used,
 					&cifs_dircache_bytes_used);
 		}
 	}
-	cfid->dirents.entries_count = 0;
-	cfid->dirents.bytes_used = 0;
-
 	kfree(cfid->path);
 	cfid->path = NULL;
 	kfree(cfid);
@@ -1041,7 +2024,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		spin_lock(&cfid->cfid_lock);
-		if (cfid->last_access_time &&
+		if (dir_cache_timeout && cfid->last_access_time &&
 		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
 			list_move(&cfid->entry, &entry);
@@ -1083,8 +2066,9 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			 */
 			close_cached_dir(cfid);
 	}
-	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
-			   dir_cache_timeout * HZ);
+	if (dir_cache_timeout)
+		queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
+				   dir_cache_timeout * HZ);
 }
 
 struct cached_fids *init_cached_dirs(void)
@@ -1099,8 +2083,9 @@ struct cached_fids *init_cached_dirs(void)
 	INIT_LIST_HEAD(&cfids->dying);
 
 	INIT_DELAYED_WORK(&cfids->laundromat_work, cfids_laundromat_worker);
-	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
-			   dir_cache_timeout * HZ);
+	if (dir_cache_timeout)
+		queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
+				   dir_cache_timeout * HZ);
 
 	atomic_long_set(&cfids->total_dirents_entries, 0);
 	atomic64_set(&cfids->total_dirents_bytes, 0);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 0767350b40fba..0726f25b9144a 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -8,16 +8,107 @@
 #ifndef _CACHED_DIR_H
 #define _CACHED_DIR_H
 
+#include <linux/completion.h>
+#include <linux/build_bug.h>
+#include <linux/list.h>
+#include <linux/netfs.h>
+
 struct cifs_search_info;
 
+/* Timeout for waiting on async dcache population to complete */
+#define CIFS_DCACHE_WAIT_TIMEOUT	(HZ / 10)
+
+#define CIFS_CACHED_INLINE_NAME_LEN	64
+#define CIFS_CACHED_DIRENT_LIST_THRESHOLD	64
+
 struct cached_dirent {
-	struct list_head entry;
-	char *name;
-	int namelen;
-	loff_t pos;
+	const char *name;
+	u32 name_len;
+	bool external_name;
+	bool tombstone;
+	u32 inline_name_off;
+	loff_t ctx_pos;
 	struct cifs_fattr fattr;
 };
 
+/*
+ * Folio-backed cached directory entry storage:
+ *
+ * Directory entries are stored in a folio_queue managed by cached_dirents.
+ * Each folio's virtual address points to a cifs_cached_dir_mapping structure,
+ * which combines directory metadata and a variable-length array of cached_dirent
+ * entries in a single folio allocation.
+ *
+ * Layout within each folio:
+ *   [cifs_cached_dir_mapping] [cached_dirent[0]] ... [cached_dirent[n]]
+ *                             ^                                            ^
+ *                             |-------- entries_count ---------|
+ *                             |-------- name_tail_offset (growing downward) ---------|
+ *                             Inline name data (packed at tail of the folio)
+ *
+ * Field meanings:
+ *   name_tail_offset: Current start offset of inline-name storage in the folio.
+ *                     This moves downward as inline names are packed from tail.
+ *   folio_full: Set when this folio cannot accept another cached_dirent record
+ *               (record array would collide with inline-name tail region).
+ *   folio_is_eof: Set when this folio contains the last emitted dirent for the
+ *                 cached directory stream; readers stop when this folio is seen.
+ *
+ * Inline name optimization:
+ *   Names <= CIFS_CACHED_INLINE_NAME_LEN are packed at the tail of the folio,
+ *   after the last dirent entry. This avoids per-name allocation. For longer names,
+ *   external_name is set and a separate kstrndup'd pointer is used.
+ *
+ * Tracking and lookup:
+ *   A hash table (lookup_ht) in cached_dirents indexes all entries by name.
+ *   Each hash entry (cached_dir_lookup_entry) records:
+ *     - name pointer (points into inline region or external memory)
+ *     - dirent pointer (points to cached_dirent in folio or list allocation)
+ *   This enables O(1) lookups during dirent reservation and update operations,
+ *   while also allowing list-backed staging to reuse cached_dirent directly.
+ *
+ * Sequencing and position tracking:
+ *   last_pos tracks the directory position (ctx->pos) of the last entry added
+ *   to this folio. When adding the next entry, we use last_pos + 1 to maintain
+ *   consistent incrementing positions used for directory iteration.
+ */
+struct cifs_cached_dir_mapping {
+	u64 last_cookie;
+	u32 entries_count;
+	u32 name_tail_offset;
+	u32 folio_full:1;
+	u32 folio_is_eof:1;
+	struct cached_dirent entries[];
+};
+
+struct cached_dir_lookup_entry {
+	struct hlist_node hash_node;
+	struct list_head list_node;
+	struct completion dcache_complete;
+	struct cached_dirent *dirent;
+	u32 name_hash;
+	bool pending_dcache;
+};
+
+/*
+ * Per-directory dirent cache using a two-mode storage strategy:
+ *
+ * Small directories (up to CIFS_CACHED_DIRENT_LIST_THRESHOLD entries):
+ *   Entries are stored as individually allocated cached_dirent structs linked
+ *   via cached_dir_lookup_entry nodes in entry_list. Each entry carries its
+ *   own name allocation. This avoids folio overhead for short-lived or small
+ *   directories.
+ *
+ * Large directories (above the threshold):
+ *   The list is converted to folio-backed storage. Entries are packed into
+ *   folios managed by folioq, with names <= CIFS_CACHED_INLINE_NAME_LEN stored
+ *   inline at the tail of each folio to reduce per-name allocations. A hash
+ *   table (lookup_ht) provides O(1) name lookup in this mode.
+ *
+ * The active mode is determined by whether folioq is non-NULL. All CRUD
+ * operations (insert, lookup, update, invalidate, release) dispatch to the
+ * appropriate list or folioq implementation via mode-dispatching helpers.
+ */
 struct cached_dirents {
 	bool is_valid:1;
 	bool is_failed:1;
@@ -25,9 +116,23 @@ struct cached_dirents {
 			    * Used to associate the cache with a single
 			    * open file instance.
 			    */
+	struct inode *dir_inode;
 	struct mutex de_mutex;
 	loff_t pos;		 /* Expected ctx->pos */
-	struct list_head entries;
+	struct folio_queue *folioq;
+	struct list_head entry_list;
+	unsigned int entry_list_count;
+	/*
+	 * Insertion cursor used by add_cached_dirent() to avoid rescanning folioq
+	 * from the head on every append.
+	 */
+	struct folio_queue *insert_cursor_fq;
+	unsigned int insert_cursor_slot;
+	unsigned int insert_cursor_folio_index;
+	size_t folioq_size;
+	unsigned long external_name_bytes;
+	struct hlist_head *lookup_ht;
+	unsigned long lookup_bytes;
 	/* accounting for cached entries in this directory */
 	unsigned long entries_count;
 	unsigned long bytes_used;
@@ -57,6 +162,13 @@ struct cached_fid {
 	struct smb2_file_all_info file_all_info;
 };
 
+struct cached_dirent_lookup_result {
+	bool found;
+	bool under_active_lease;
+	bool fully_populated;
+	struct cifs_fattr fattr;
+};
+
 /* default MAX_CACHED_FIDS is 16 */
 struct cached_fids {
 	/* Must be held when:
@@ -115,12 +227,25 @@ void update_pos_cached_dir(struct cached_fid *cfid,
 void complete_cached_dir(struct cached_fid *cfid,
 					struct dir_context *ctx,
 					struct file *file);
-struct cached_dirent *lookup_cached_dirent(struct cached_dirents *cde,
-				   const char *name,
-				   unsigned int namelen);
+int lookup_cached_dir(struct cached_fid *cfid,
+				 const char *name, unsigned int namelen,
+				 struct cached_dirent_lookup_result *result);
+void invalidate_cached_dir_contents(struct cached_fid *cfid);
+bool update_dirent_in_cached_dir(struct cached_fid *cfid,
+				  const char *name,
+				  unsigned int namelen,
+				  const struct cifs_fattr *fattr);
+bool invalidate_dirent_in_cached_dir(struct cached_fid *cfid,
+				      const char *name,
+				      unsigned int namelen);
+void cifs_complete_pending_dcache(struct cached_fid *cfid,
+				  const char *name, unsigned int namelen);
+int cifs_wait_for_pending_dcache(struct cached_fid *cfid,
+				 const char *name, unsigned int namelen);
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *name, struct cifs_sb_info *cifs_sb);
 void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
+void invalidate_all_cached_dirs_nowait(struct cifs_tcon *tcon);
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
 bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
 
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index bbbee0ef09443..1bf34a97f051f 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -179,6 +179,7 @@ void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
 void cifs_dir_info_to_fattr(struct cifs_fattr *fattr,
 			    FILE_DIRECTORY_INFO *info,
 			    struct cifs_sb_info *cifs_sb);
+void cifs_inode_to_fattr(struct inode *inode, struct cifs_fattr *fattr);
 int cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr,
 			bool from_readdir);
 struct inode *cifs_iget(struct super_block *sb, struct cifs_fattr *fattr);
-- 
2.43.0

