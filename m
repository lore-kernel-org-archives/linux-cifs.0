Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43383F54AD
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161515; cv=none; b=tN+EoRcsVYt3HIcaCUV0y8SZShA3+G42W9PKyDydrnpot3kGK3mT9oIt+AnfGWN8/3No+/nGks1cmDU7sjMs01ey+9pLX4wg3uHbP7wPSNF6q1376Wkciqo6AizjCffu0NX5jJo0XRNOt2F44joe9D2fmibusAj6e71dAuvbt5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161515; c=relaxed/simple;
	bh=YZc6dnL6ScN6M9zfwr03lJvePA6UD9W9i/GwXSHIKEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gts7HL39BB6LFnmbfwxuDNsjwrCouRx22MN6f3pi4FNI5FMsc3QARRaYWwhQORdF7p7RFpVqGNBfolrb7KW4YcpVRTVqnNoHQ/zBsicVzognpPHzmTFkXfqXWeavng+rCQrvGv1tyXfeuc/04wCPCbpolaWPaUq+dpZw83obSaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I5IvvLol; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5IvvLol"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-366330b6751so162078a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161513; x=1778766313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZv6TKeVYbBMMgwVmFzJrgb9YvlsmZ81FdayKJqs7qY=;
        b=I5IvvLolenKLxk4DS2wRjC40ztySLCYoMGf5vvbH8OVar/s9Qy+/PWY+cZEqo9YqU8
         6oKOxZtei1cPvTjmOJ9XgaJAKxNqQX0KxgIfIspu4cevaZGYPzGx2QoqDc/hyj09m+jX
         Sy3x3otFcwIgyfEFcg/RyFgoMLC84sqdujBJrLBLXkgaARUvwqABpWZ18SKBvvPYntVx
         SW4BU8N+AZ8k/fLumbIfn1L4XsrhlDx85N/PoemCN+dAIpy+EiABX4hEbdTn9MaOqVha
         wibHg98uIgLPgMFN0mumc9NZJuP6L3qul+AXK043to4VuLed83VuET8aiMHzz7jaCfmQ
         gtlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161513; x=1778766313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZv6TKeVYbBMMgwVmFzJrgb9YvlsmZ81FdayKJqs7qY=;
        b=fgKArszOD/jp0XPWHeO/FrpQxXih/iK1LsZA40gtmULGjvtCTPLnz6a7RFX7uAKR6+
         GJO41grpmsvZm3ggg/KmBYIpgjWLkdADhx+lXAKMs5syVeIwYgoT9uY1ZtokFdCVHGMV
         ZLyz5rwjzCcmpySe77UTW3BY4ja2vyBUHrWEgap5QBIEeV6tIvOJwip6b3fdR/zTVjm/
         g1aFl47o/Gky0M8S6rabsIg8s4xptshNQZrZKn39aZ3+1EFSSyNsOWXKYKSZDCtcoJHn
         ay9xI5Q2tjp7mpYKXNp7Sufggisy1A5kh34yFeiCExIacFaXG88K7bwacrUC3a2/JBQI
         bGXA==
X-Gm-Message-State: AOJu0YzhggizuMlYCDusMjeT0roFy8xsMvzXl+bRUFjtCgE8XIe/DOUb
	df7hz0IPFmJspFBSM64RDJNMINMGMpiTYsCaPYHhCUFG2iCK6SjUKpXdsJKUIA==
X-Gm-Gg: AeBDiesGHU+HbJdg4NPpfCQDf3hiifAUS+6ChhAWdm35HO/9FH0/wnoLJYXIBH1cKwQ
	ONCrsqd+D0ygtSmE896Tnn4K8KilPvDeV2jsNFwkDx38QQPba6PADmLZxs014rfFfkMZqPVTL+9
	muuYHVEPNmCQvMk+Qn1072q+R6CyH9q5v8tgly2RMj38OlfhcJCtFTZeVHK81BnnYyofYMyKwMY
	Aic7wloeU6w9QFNXiC44Q3IP3XPF5Npr63DQLsp4RY4bt09zKMBrx0WIb9A58sgBU/BnD4cbXjs
	EBjbw7ZPD7sq9zk0ZDgno6rG2qyYr0k0VkMtJDJz4XihHbG2ZAC32Mr11P8sdoesGMfJtmJOx9i
	gkdoQ5/cC6BaMlnVsWa7z0IHnu3t2xUldZIj2OUF1YwhRadfn8pkr7qSOKeRzZqsLqjIoNPBo7A
	CGP3OoIo1JQpZJyr7B6sIMKLNA0nLX+MxDnyAfS5jCmimKEoXQ5lx19npvbbSTNwHbfMeDJrENH
	LWPXKi2felj28Z9D1AZbyHE5gvwVBwhtA==
X-Received: by 2002:a17:90b:2691:b0:359:fe72:3559 with SMTP id 98e67ed59e1d1-365ac46dc62mr8522471a91.21.1778161512574;
        Thu, 07 May 2026 06:45:12 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:45:11 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 6/8] smb: client: allow nolease option to be reconfigured on remount
Date: Thu,  7 May 2026 13:44:46 +0000
Message-ID: <20260507134448.168602-7-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
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
 
diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 972d3969f7e7..01c57adb0ef1 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -35,6 +35,7 @@
 #include "nterr.h"
 #include "rfc1002pdu.h"
 #include "fs_context.h"
+#include "cached_dir.h"
 
 DEFINE_MUTEX(cifs_mount_mutex);
 
@@ -1286,6 +1287,7 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 		spin_lock(&tcon->tc_lock);
 		tcon->retry = ctx->retry;
+		tcon->no_lease = ctx->no_lease;
 		/*
 		 * Note: this updates the limit for new cached dir opens
 		 * but does not resize or evict existing cached dirents.
@@ -1294,6 +1296,26 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
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
index b99ec5a417fa..cec34e69e191 100644
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
@@ -185,6 +186,7 @@
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
 	EM(netfs_trace_tcon_ref_put_cached_close,	"PUT Ch-Cls") \
+	EM(netfs_trace_tcon_ref_put_cached_inval_sb,	"PUT Ch-IvS") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close,	"PUT Cn-Cls") \
 	EM(netfs_trace_tcon_ref_put_cancelled_close_fid, "PUT Cn-Fid") \
 	EM(netfs_trace_tcon_ref_put_cancelled_mid,	"PUT Cn-Mid") \
-- 
2.43.0

