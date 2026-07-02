Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFF93CAA59
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782992167; cv=none; b=JBKOprcROUeHZz0cEmW6v5R8lxiB8XMd7iyZaWM8cQEFSxgWa62aOV2VNpuWzSECNon8eqpEks1nf9Ssr7O9uYGI5kwKaTzX8qmP8jmUMwRi8MNgi1QW8eujmD0cEHFwm5wdLwEfuc2myGNA5stCEu7vzwTAxKXvIyBAKozNsxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782992167; c=relaxed/simple;
	bh=2lLZw3ZMQ6leErzWsEMZwn/IHKRDkqbTuQQVYqrRPLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQo9u8YaQT+iBkQzjKR3s+fI0VhoGGBGUY/Kli8xQtuzm3yBDrYoOJgrKFmTk10av+e/bsIPkMbOAK9tk2o9HLeP85r12IjuPXM8a1C9Y56XEKcnQIREoD7FkCB+ubrz2wDsjZrvMqGirkMtpd9hupQuqPvUnHOc7qPVeIuv6P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ae4gEdkK; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ae4gEdkK"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-37dedd62b90so538681a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 04:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782992163; x=1783596963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8MgEgbtktAXxF9HGVthzpmm0Tdgj1AOffPOw08ZBgQ=;
        b=Ae4gEdkKhe1HEqijG8c9zoS8sKyOntPouVruq/p/4TVOH63d7OY/KgeeA9282bs8dC
         xzPwXjv1xlwMYao5k0qPPAMU8JoDiPQrHbH1GVbO7GZhZzXghNKnTI6k9djlWQgROdOW
         MgEcJHmRlXjFPoscH0APlAB1uqv+QjQCFeQO9CKBfJpzp8xh/x4gE7ZHAy2ViS56Q48C
         wmnMK4EPhDKNI2cEa/0/C6b34+bz2U31Y/CnoJ+XqmqPasOwB0/TrVatVt02mV9ahtGP
         ifz0/FfQx0G1rhfa/5YKyViARYWyKUyXoLoWCAA7KdTiQDZ/ipHus42er+4XApmpRDLm
         2yog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782992163; x=1783596963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v8MgEgbtktAXxF9HGVthzpmm0Tdgj1AOffPOw08ZBgQ=;
        b=V43BNSCtsGKn94EiwyvnRFiLZpfC6v27+YJoVasPuh18HgYS1ISt+FgqV3JgrE1j1V
         iOR7H03fsodDL2cGxoMo8hogYcJItsJUxy4pbpLaaoGDegrwPIPRSR1QaRGzXtgWwXKg
         IuB7rSj9Pd2uHe64nG9v/JdWEqvJyU51faI/NavLpzF4Rv+cZFovxGJSzsfE6JgKSjiX
         UK4R6aIytwpE2QbnB0dtpwSNEjhu9Wq93M5c3TLQbCVDKAbilZ3REDaJ6hKnyhUUSK29
         TXNvpuYctBEGzUYjCMGZuf9UxI6VYwGmvkGwmq8y9yGO3lCdqBRdcAcSECHA5BIat2Yl
         8G8w==
X-Gm-Message-State: AOJu0YwiCQOfuB1ACMCWOtNTsxl6/6hH3zTJQpC6WVYqvaVIRzwZxykl
	DnjYIxII070nCT8HpZkv86GOXP2nU+4jW/sQLEztxxSp7qKVYDV0M+STufV5lQ==
X-Gm-Gg: AfdE7cnQT7QBt+DfJgMxa8gMlvKcwFfw7ySZ+9QLUuKkjjJUL1JfXmosyQrhAVJOWKM
	HqC+Ja6IcJFs4y1wYOnFECu7BR4iTbtNHcbEAd7ISHlyNe1EBKAtbl+N8xC5shBfJhay8sos7kh
	Bpw0ysDmuMpNaG8d+cWe9ZKqGUI7vWbfZiFJ1zVDl7Cr9dfHE6UfGPZql2oNFujFUibNiH+A550
	8KDzjdf5loCJQMqiT7CksRNu31HbRMxLEbEZlAknOD0131s2f/G93G2ottPvOn1hsmu1gx/3xoH
	kfKB7BRTEljs4wvwXHVuaPM8HceatMhICBssQ7vQ6S9owxGxm/WtPUi81J8LlfI9dUq+sWwVJ1a
	VnIX5LHn8L6voXoMSInV4h25zehN3LbbVvBqZrbDLCTyOU2J5wrHdq7n8teTDvfjOaOR0bWDY/G
	4Czg4ETibrIh53NAzUOO0bYgN6/EMguQOb1GtHfmdCujIK/6wJDhF1VoeSk1K2pzKAddF21W6lQ
	5md5KEQZ5rhY4qOF+uBZuM=
X-Received: by 2002:a17:90b:3dcc:b0:380:9699:ae98 with SMTP id 98e67ed59e1d1-3809699bb0bmr7334770a91.8.1782992162574;
        Thu, 02 Jul 2026 04:36:02 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb7fd75sm9444824eec.19.2026.07.02.04.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 04:36:02 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: bharathsm@microsoft.com,
	msetiya@microsoft.com,
	smfrench@gmail.com,
	sfrench@samba.org,
	stfrench@microsoft.com,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH 7/9] smb: client: allow nolease option to be reconfigured on remount
Date: Thu,  2 Jul 2026 11:35:33 +0000
Message-ID: <20260702113535.4044308-8-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702113535.4044308-1-rajasimandalos@gmail.com>
References: <20260702113535.4044308-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Changing nolease via remount is silently accepted but has no effect:
the value is not propagated to the live tcons, and stale lease-bearing
state from before the switch keeps using the old behavior.

Make nolease take effect on remount:

 - Add smb3_sync_tcon_opts() which walks the tlink_tree under
   tlink_tree_lock and propagates ctx->no_lease to tcon->no_lease for
   every tcon under this superblock so future opens honor the new
   setting.  Call it from smb3_reconfigure() after the context has
   been updated.

 - On switch to nolease, drop deferred file handles via
   cifs_close_all_deferred_files_sb() (each holds an active lease).

 - On switch to nolease, evict cached directory fids via the new
   invalidate_all_cached_dirs_sb() helper (each holds a directory
   lease).

invalidate_all_cached_dirs_sb() mirrors cifs_close_all_deferred_files_sb():
take tc_count refs on every tcon under tlink_tree_lock, drop the lock,
then call invalidate_all_cached_dirs() per tcon (it can sleep).  Two
new tcon_ref trace tags are added for the audit trail.

Move tcon->no_lease out of the bitfield word into a plain bool.  As a
runtime writer it now shares storage with need_reconnect/need_reopen_files,
which the reconnect/reopen paths update locklessly; a bitfield write is a
read-modify-write of the whole word and could clobber a concurrent
need_reconnect update.  Its own memory location removes that race.

Existing open handles keep their leases until the server breaks them
or userspace closes the file -- nolease only governs new opens.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cached_dir.c | 44 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/cached_dir.h |  1 +
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/fs_context.c | 40 ++++++++++++++++++++++++++++++++++
 fs/smb/client/trace.h      |  2 ++
 5 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 88d5e9a32f28..58d68a8f4d41 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -637,6 +637,50 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync)
 		flush_delayed_work(&cfids->laundromat_work);
 }
 
+/*
+ * Invalidate cached directory entries across all tcons under a
+ * superblock.  Collect references on each tcon under tlink_tree_lock,
+ * then call invalidate_all_cached_dirs() outside the spinlock since it
+ * can sleep.  Holding a tc_count reference prevents the tcon from being
+ * freed by tlink_expire_delayed() between dropping the spinlock and
+ * the call.
+ */
+void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb)
+{
+	struct rb_root *root = &cifs_sb->tlink_tree;
+	struct rb_node *node;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	struct tcon_list *tmp_list, *q;
+	LIST_HEAD(tcon_head);
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(root); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR(tcon))
+			continue;
+		tmp_list = kmalloc_obj(struct tcon_list, GFP_ATOMIC);
+		if (!tmp_list)
+			break;
+		tmp_list->tcon = tcon;
+		spin_lock(&tcon->tc_lock);
+		++tcon->tc_count;
+		trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
+				    netfs_trace_tcon_ref_get_cached_inval_sb);
+		spin_unlock(&tcon->tc_lock);
+		list_add_tail(&tmp_list->entry, &tcon_head);
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	list_for_each_entry_safe(tmp_list, q, &tcon_head, entry) {
+		invalidate_all_cached_dirs(tmp_list->tcon, true);
+		list_del(&tmp_list->entry);
+		cifs_put_tcon(tmp_list->tcon, netfs_trace_tcon_ref_put_cached_inval_sb);
+		kfree(tmp_list);
+	}
+}
+
 static void
 cached_dir_offload_close(struct work_struct *work)
 {
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index fc756836da95..606ba2a0b64f 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -90,6 +90,7 @@ void close_cached_dir(struct cached_fid *cfid);
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *name, struct cifs_sb_info *cifs_sb);
 void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
+void invalidate_all_cached_dirs_sb(struct cifs_sb_info *cifs_sb);
 void invalidate_all_cached_dirs(struct cifs_tcon *tcon, bool sync);
 bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
 
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 38e27ba6d8f6..713ca152b0ea 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1262,9 +1262,9 @@ struct cifs_tcon {
 	bool need_reopen_files:1; /* need to reopen tcon file handles */
 	bool use_resilient:1; /* use resilient instead of durable handles */
 	bool use_persistent:1; /* use persistent instead of durable handles */
-	bool no_lease:1;    /* Do not request leases on files or directories */
 	bool use_witness:1; /* use witness protocol */
 	bool dummy:1; /* dummy tcon used for reconnecting channels */
+	bool no_lease;    /* Do not request leases on files or directories */
 	__le32 capabilities;
 	__u32 share_flags;
 	__u32 maximal_access;
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 0a72e1089ff7..53f986d8e9e0 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -35,6 +35,7 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fs_context.h"
+#include "cached_dir.h"
 
 DEFINE_MUTEX(cifs_mount_mutex);
 
@@ -1287,6 +1288,43 @@ static void smb3_sync_ses_chan_max(struct cifs_ses *ses, size_t max_channels)
 	spin_unlock(&ses->chan_lock);
 }
 
+/*
+ * Propagate ctx->no_lease to every tcon under this superblock so future
+ * opens honor the new setting after a remount.  When switching to nolease,
+ * also drop deferred file handles and invalidate cached directory fids,
+ * since each holds an active lease from before the switch.
+ *
+ * Existing open handles keep their leases until the server breaks them
+ * or userspace closes the file -- nolease only governs new opens.
+ */
+static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
+				struct smb3_fs_context *ctx)
+{
+	struct tcon_link *tlink;
+	struct cifs_tcon *tcon;
+	struct rb_node *node;
+
+	spin_lock(&cifs_sb->tlink_tree_lock);
+	for (node = rb_first(&cifs_sb->tlink_tree); node; node = rb_next(node)) {
+		tlink = rb_entry(node, struct tcon_link, tl_rbnode);
+		tcon = tlink_tcon(tlink);
+		if (IS_ERR(tcon))
+			continue;
+		tcon->no_lease = ctx->no_lease;
+	}
+	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	/*
+	 * Both _sb() helpers iterate all tcons internally and handle
+	 * their own locking.  They can sleep, so they must be called
+	 * outside tlink_tree_lock.
+	 */
+	if (ctx->no_lease) {
+		cifs_close_all_deferred_files_sb(cifs_sb);
+		invalidate_all_cached_dirs_sb(cifs_sb);
+	}
+}
+
 /*
  * Synchronize server-level options that are stored on TCP_Server_Info
  * at mount time.  These fields are consulted at runtime (retry logic)
@@ -1483,6 +1521,8 @@ static int smb3_reconfigure(struct fs_context *fc)
 #endif
 	if (!rc)
 		smb3_sync_server_opts(cifs_sb);
+	if (!rc)
+		smb3_sync_tcon_opts(cifs_sb, cifs_sb->ctx);
 
 	return rc;
 
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 5b21ad3c15fb..1e61a36759ed 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -173,6 +173,7 @@
 	EM(netfs_trace_tcon_ref_free_ipc,		"FRE Ipc   ") \
 	EM(netfs_trace_tcon_ref_free_ipc_fail,		"FRE Ipc-F ") \
 	EM(netfs_trace_tcon_ref_free_reconnect_server,	"FRE Reconn") \
+	EM(netfs_trace_tcon_ref_get_cached_inval_sb,	"GET Ch-IvS") \
 	EM(netfs_trace_tcon_ref_get_cached_laundromat,	"GET Ch-Lau") \
 	EM(netfs_trace_tcon_ref_get_cached_lease_break,	"GET Ch-Lea") \
 	EM(netfs_trace_tcon_ref_get_cancelled_close,	"GET Cn-Cls") \
@@ -186,6 +187,7 @@
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
 	EM(netfs_trace_tcon_ref_put_cached_close,	"PUT Ch-Cls") \
+	EM(netfs_trace_tcon_ref_put_cached_inval_sb,	"PUT Ch-IvS") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close,	"PUT Cn-Cls") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
-- 
2.43.0

