Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE65C3D6CD9
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372416; cv=none; b=cPYc4yDJwod+BoKEr05xcAorAjn8VdzhvGxcx33FG9Z3jqZUEj3yVxi2PgINQmrmIakM3QDmVDdjpOdKANgHIzcFbvzKBGBYeISmW5NSVhm8sXFfkTUa/+zGagfd/KEawfV77BGQuX/Xi7q4vk+moC5tb5BNS8yJ/e4tA/txtas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372416; c=relaxed/simple;
	bh=qNvKBCUAVLtNiay7bcRRB4CohpGgHozg5QdXGLiOfVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1rCTNhVvTMA4n85zmWrvdIJgkE1dcXbWQrrn+w8XCLS8jF3zI64lJSDKq/yZy/tRS/jcQtcieE1xXZKpmaOtjKEQgPaqcPLR+YuGg6n8GpoRH7DoXLS6NMXOATLaRUuUQ3KOyJUqNxU3NCL4INJYRht+IZavjInCa8DBwzNPXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a7rRHTSJ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a7rRHTSJ"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-824c9da9928so2608077b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 07:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779372414; x=1779977214; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUmhfQn5vrV3Pj5ivnNPmEefYLysEFZ1gDRBRlEBFd8=;
        b=a7rRHTSJ3Np98wKX04xVFiizxKprX34Pq1fqhXyCswRN8avrFlSmB0uV1jdzi8sIcF
         2yW47y7GlL2VpEnR1mMP3RCNhuDF80L9X7eAHyPutdmvkP4S+zndiZ0l40r0AN3FtUrH
         4kfUZs8eUS+FOymwYF+ThDEizEx7nvMsnbQ/J5+NzTrpg+sVwF1eRXXDgtbc1eB7LsrN
         vTvl8+9xpnMPWN9KMF6yH2bQZ3AiHTuhy48Cii5T5pavIwM9NzFCzRXPN3y/7lK3ry4+
         yoZOTXB462zSOUGg+NxW3jMUEKhb3MlSCXFEnKGT0aaQtvXPsUmL64qpGbyAa8gQL1CP
         G30Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779372414; x=1779977214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XUmhfQn5vrV3Pj5ivnNPmEefYLysEFZ1gDRBRlEBFd8=;
        b=fo17dMfhS1juiOcPZoxN2Lc9Qc5hRMnhbMAQOLQhPZtWEKGyHAAppnnoWj6rz/8DAu
         SzO6SfU7opHGus1IJdDqREY1u+Du+4umahQQ/Kq++24BaSfSCI5+W9bseOVE9uJq4yrF
         77DF+gIeS75rZW4RhETWvdz0330//zdbPiY7wI0kOJWH55lruRMh2F+j0PteTXZOh2HL
         F80rb8LWA5G6XWWhQfluwOiL+qI11hGaJKygKTwFwUGwtUx/F/qpZqfxEyxXI6MZLKmo
         bTAVY8il2/hU0Lf2p/N6Je+aFH7Zla5EBU6eCFwOKhKmkKfVBoH33GVRFL283MX2asjL
         GNbQ==
X-Gm-Message-State: AOJu0YzyxqgwsEN5u2nGAeSLHMH+9/wk5MuTbBRkSaEmMJPcRPDfNyJp
	oC59RoMJhBEH3tbeoKjniSKUCawai72H9E88L+rv+DMrtcZpXCvP+19y
X-Gm-Gg: Acq92OENxkb/SSY90YANr+uoqHQ8O8x8Ct2Eexl9HRe1ECeUFYvyKU94zXgle+vsqEa
	I1heaZDXY/+OUXsqhNopF6attzNO8MT+XJbokifhAzpgWVpN1MzZVFMH1vIMt2wGQ4dy2dQaDHG
	uuZ/co+ZjSpsNtVTxIl+gNF5FwK7rnn6/5fiyeAmA+6rbKy5Qg2IT1TM+GXlOMKBoH3hwMJruEE
	KLca+1//4jS2FvtKgVuhVix9ttNq2PILcCgLGk1th+a9tK8yB6akptWV7OuvxYJ2jXrXE0pzLYE
	PvnKxJBbZ9KPvOGYf72IZkZnNGWWPisoi+GrSsWxebHQuzrRZE585gRM+sQ7PZc28/8QR+thyu9
	wzivY7Rihl+mpDgLI5cizk7cVnYaPGEGUd4r62QWfHjFDFvaH34zwoXb2v/zupMDsbv+qQ9rUBy
	MpApU+EhkkZ1BzACcZ7i0QnAP8Nd4q4GpWDzYu2Bxt/cmdg60H+7of8bH5djyY+PbK1IG3aZQb2
	L+Ec72mEQVOdQjEm4yrrxM=
X-Received: by 2002:a05:6a00:44c7:b0:837:fe75:104e with SMTP id d2e1a72fcca58-8414ac683b2mr3303444b3a.5.1779372414259;
        Thu, 21 May 2026 07:06:54 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841549c46c9sm1719329b3a.10.2026.05.21.07.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 07:06:53 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 7/9] smb: client: allow nolease option to be reconfigured on remount
Date: Thu, 21 May 2026 14:06:42 +0000
Message-ID: <70c810c08e1aecbd4b78103ae3ca5711f9514018.1779372325.git.rajasimandal@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779371115.git.rajasimandal@microsoft.com>
References: <cover.1779371115.git.rajasimandal@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

Changing nolease via remount is silently accepted but has no effect:
the value is not propagated to the live tcon, and stale lease-bearing
state from before the switch keeps using the old behavior.

Make nolease take effect on remount:

 - Propagate ctx->no_lease to tcon->no_lease in smb3_sync_tcon_opts()
   so future opens honor the new setting.

 - On switch to nolease, drop deferred file handles via
   cifs_close_all_deferred_files_sb() (each holds an active lease).

 - On switch to nolease, evict cached directory fids via the new
   invalidate_all_cached_dirs_sb() helper (each holds a directory
   lease).

invalidate_all_cached_dirs_sb() mirrors cifs_close_all_deferred_files_sb():
take tc_count refs on every tcon under tlink_tree_lock, drop the lock,
then call invalidate_all_cached_dirs() per tcon (it can sleep).  Two
new tcon_ref trace tags are added for the audit trail.

Existing open handles keep their leases until the server breaks them
or userspace closes the file -- nolease only governs new opens.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/cached_dir.c | 44 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/cached_dir.h |  1 +
 fs/smb/client/fs_context.c | 22 +++++++++++++++++++
 fs/smb/client/trace.h      |  2 ++
 4 files changed, 69 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 47a51b6b397e..60a483454bf2 100644
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
 
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index f09ad5d470f3..7164dda715ca 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -35,6 +35,7 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fs_context.h"
+#include "cached_dir.h"
 
 DEFINE_MUTEX(cifs_mount_mutex);
 
@@ -1295,6 +1296,7 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 		spin_lock(&tcon->tc_lock);
 		tcon->retry = ctx->retry;
+		tcon->no_lease = ctx->no_lease;
 		/*
 		 * Note: this updates the limit for new cached dir opens
 		 * but does not resize or evict existing cached dirents.
@@ -1303,6 +1305,26 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 		spin_unlock(&tcon->tc_lock);
 	}
 	spin_unlock(&cifs_sb->tlink_tree_lock);
+
+	/*
+	 * When switching to nolease, close deferred file handles and
+	 * invalidate cached directory entries.  Both hold leases from
+	 * before the switch; without cleaning them up, those handles
+	 * continue using lease-based caching despite nolease being set.
+	 *
+	 * Note: files already open with leases (e.g. RWH) by applications
+	 * are not affected -- nolease only governs new opens.  Existing
+	 * handles retain their leases until the server sends a lease break
+	 * or the application closes the handle.
+	 *
+	 * Both _sb() helpers iterate all tcons internally and handle
+	 * their own locking.  They can sleep, so they must be called
+	 * outside tlink_tree_lock.
+	 */
+	if (ctx->no_lease) {
+		cifs_close_all_deferred_files_sb(cifs_sb);
+		invalidate_all_cached_dirs_sb(cifs_sb);
+	}
 }
 
 /*
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

