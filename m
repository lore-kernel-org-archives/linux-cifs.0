Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695123D9051
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 05:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781589272; cv=none; b=qPuc8jETeShklMT13H4XbiijpXbJKWomvBVpAptZA6WSjyF8N9riiENFU3Vu8qjBueIchBITQR44VWO61IYlQ8UDxhDJkjRgQsr6WwEGohuRCSQ/nWbQF22ZsYsmgLbV4DzPCw+ojziYp+JkIL//vIa/7LI7TSK9i85WL9BbKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781589272; c=relaxed/simple;
	bh=2lLZw3ZMQ6leErzWsEMZwn/IHKRDkqbTuQQVYqrRPLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azmhhwSkc4ZkuFt0SkZLqJTYq8tj9gL45qBcUgmZ720EBc1rn6ECVpMZEq76pAZLuMv19QWIIwiRgI1QI+AKu9fe5dhSIj4Ww8S9NBzH95MazrvKbUiLgJitnb2nSqjlAXKUbQdpv5OROcIit+n/c6DM1MzbK4ovvoURnjvKsoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MCu+IEy1; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCu+IEy1"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c0bb4a94b8so32401015ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 15 Jun 2026 22:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781589271; x=1782194071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8MgEgbtktAXxF9HGVthzpmm0Tdgj1AOffPOw08ZBgQ=;
        b=MCu+IEy1rJowyeQaV/LZRf5b8jlgwiOk4WlBybjg6sa+5Ok3zGVrGPWSk0wHSd3xXr
         8vL5fpY+WAHvoWLtbRBCpH4SkiMy0uALWLRgCHdVd5JU4EuTlpCQZ09PNno0IpNTB+WE
         7VFR7mWo7TMK3fCWqnHjB0cqx6n/OmlgZ7CvCI+BWCm5rX7cKqS5fayYsGOIt+sWpPUs
         3DEz4kFgfblYmYfIRGjbEpgYIvC/rCHdyKZkiJkH8taISDe0ukRuxeh73Rbucfy2/VVZ
         RAzVftGwW5BmwCgSVIjoPVRjgKqUkFs06awPpkyalmiGoCskgpmp1vXONvKabOm27AWv
         cpzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781589271; x=1782194071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v8MgEgbtktAXxF9HGVthzpmm0Tdgj1AOffPOw08ZBgQ=;
        b=FJAH9jHqYMkWnXaIK9FCLL+VXxr6C1iA6VDKykNyP2Oipn1OsFCpAk5uot1ygTc9jO
         /FTJuz3bfTcRynuBdvXmgU3uaxzLc+WFGsvCTotcQGof2OjD1mFAIAh3pwQcqkcbphFb
         f63Ioni8h+Z64qv8W6+hapc1tqGEkIHXxGVuGW/eREAMG6gOnAL1cGnQgJjEexRjpA+1
         DQCo/MuIfbWdbHiRMFDxJOEGXyCM06UyXuWHHBZKbMXdlWbSumBHc5+xlbn/zRf58xHi
         jPzkiqvSeqKKczGgv6CLDdl6MKng37tvDkpDu3LiMVdjQFbEAmLTsKjIrw/UuBF5DcfK
         KKYw==
X-Gm-Message-State: AOJu0Yx1nN7ypF7Nl1mXSWZd1eJewV7cIAJaWXTAP17V0KObMLESwYXb
	r4R/f2LAEFIZLfnHB7QO0yd9llEATAQMRu0JjmhPYSe+ECjDmI+6CfxF
X-Gm-Gg: Acq92OFanz5hHV9TJyfK5nY0Lko3cARkcMqxKacoA3oer31J9P//RjlmQeqzZbmyzUU
	JcskfwsKe2ihq0pDgjKvxMTPybTmCGzhJYDCQ9HmA5m7Nb7VGDhoKwOXqrypZXwKslEiOXNERer
	DdB7QCiy7pkuU1lvLNvZG/230iWQQed6WRQXsT2kykBhPfXWeqK1KhAXbJ1jCvp6VTh/BqGBU26
	+jqeFJi8FFXQlGOD8qoWqx/aA0xLty8za0oBUFSj5p0IZCW1uCvkeCLow2LW/6nIy+WVeJu3k0a
	eSNhbTu+7Qht6naNLk0U96FRBD7SWtXx6qs7xLSzia9v+QTSsFjsWttMLrKk93+pmFHjAlQrEkF
	rBUmd5Ti4Q/qS0PvSrLcDdoEahP3uanm9LlL+D6EHYSlkgNz0V6HQ/E+GE1nA11KxbHmvjKfkRb
	Iptm7tOaQLBhG5N4tCLU16i/tReZmY7//3aKPDFfkdA+mKf3/DdgjqpbHuP1ww7jBnFu5Lrv63y
	WJLx1rJlYtABvZ+ZoLzT3E=
X-Received: by 2002:a17:903:22d2:b0:2c6:a45a:4f7d with SMTP id d9443c01a7336-2c6a45a5157mr465155ad.29.1781589270741;
        Mon, 15 Jun 2026 22:54:30 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm120805275ad.7.2026.06.15.22.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:54:30 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v4 7/7] smb: client: allow nolease option to be reconfigured on remount
Date: Tue, 16 Jun 2026 05:53:57 +0000
Message-ID: <20260616055357.3798387-8-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616055357.3798387-1-rajasimandalos@gmail.com>
References: <20260616055357.3798387-1-rajasimandalos@gmail.com>
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

