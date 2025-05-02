Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EB83D6F
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746209057; cv=none; b=YgLljW4xdERDFsWGJ/CAEoxYXhQo5jGOy6vmMbjldCfGM+H083llRw04yjH04mIFftudNxp8lEaRMO4BFxSlb9yUZvf90pVUPcRg1X2UQUV2LAlRbwH3/Zg4Fr0JhuIkZfahoazdcAKQh9bYqT7rrdfoZYpyDJgX5QW3N0QOyT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746209057; c=relaxed/simple;
	bh=N5xWWuk7ptUK4YiPTtRDmeiKwFghtL1R9t7cbNQC/s0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iEft8L5BaxOBaZGNb/H2dvE27EoaNHWpHX8kw8nn1VJyjp79qHaJU4r3PwlRHVXsYEEUVbkoxXhmCG67GxKCyIF/f3l4oTKVRHjLOEdONj7vCDnbWTCOWaUzu59Pu2rD71Z0iVgDOO+NCMed6x0fndE6xqYeDGw25W4YSifjAMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BjWT/sjp; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BjWT/sjp"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-39ac9aea656so2340943f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 11:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746209052; x=1746813852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u74gHssQlc7SVMCSRVbSMQOAkk02ZtQ0BFhWtrg5hpI=;
        b=BjWT/sjpW6/OoV8pBe3/ZLXp4z8vcUU4eUZibKlJzxS1saXiOMQo4wToUk8m80kTwE
         V2JesEQqs3WoA9qT2XQJ+VMHDD/Bi13YPPZnTTL66V5vd7BmZ8Q1SMm/n3ykIo34WzJU
         XXjhTOQaurTph5x7Eo0ikyBu4XxnCnciMYmEX/rZ//00+Ie8clXYH3n9zxZ4BCnv3t4X
         GqA7xeLOzDkrqAExIBim+v2Nk24y8fWJ/UtrafwxPmqKKo5NrB179VOybVzBEjHq1rdS
         LrLW01sKjTAfgbFEVlCNbzAxkJM7RKpWsYU5gSSq1CldSFdV4TNf0Ritzk9iRntCk/5l
         +TlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746209052; x=1746813852;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u74gHssQlc7SVMCSRVbSMQOAkk02ZtQ0BFhWtrg5hpI=;
        b=SajCz0C/MChHre+Fo44xPFyDVuk3kQSk3zXnQXX0hkPOldWg5k8kKVCMUXg5NM4rFm
         5VRrn+koP9rkrWAIVHF5MUAKnIPIMXU1RkYX3nnKrvafuiCDJj3HskM50CY2Bop6xuFX
         7A/PS6A7Oh/R9ikpmwhWp6GyFg/vGiSm+p8ll8QWun0mDwegJK1XkaImAc9QfkidCuJk
         1FbNg6znPTorpKGWBBSzSegpkjl92ccdYKRzBs+QdJDYyusNNfYGmE44vrAMUpI1qWL+
         oyFjmkkpFAZ/09c4oF1GiGbcavHhH6os55qJuM/SwNQ0FVb5fEctkI4MxQ4JzWWUEJe/
         klpw==
X-Forwarded-Encrypted: i=1; AJvYcCXYQqV6XnVPolBwHi4vCJf81279MdVkStVFVLKRSuVJROi3/T5lgmVpGJWdjDj8/L6SzZHz78xuTHmJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzTJFwfVTi0FaVcx2UdvUJhFrQ5xxkHSRMGTr+v98EX4jzBftlw
	ETKexKvzEotmW4XXVOrQfaz4CPFIaVaz7+wD2L8trLvfJGwA2OkhqjFqNcHpMm4=
X-Gm-Gg: ASbGncu9EqqQZwzFGBqWMUMn3ZJIOi4IYz+RDPTFSsoIg6HZqXy4gC9m1lXiZkQcfGq
	EJzKFZO54M0EKH5QMA3wpUiYf4F5ywoCE4zQkv9s5VSYoelz+Uy+vlt6REim1fZHk71x5TVHi3s
	PO2wRiVHpRdHt1As1yfAEqUABtHmIDAKobKJ/D301xo0ojwk1G5MCKsZGBPUaeNH14h3n7xMPl6
	kNborB5lSKI5Zz+Gafg4KBuH5adIRuRPR+p3bjBYKicp3AmpJ2afe3nA5ATA1jUebwSSebMwmPP
	ooRfzu0IlgwF4UALHfDlGUaRavgfF6Rw1hd7tQdYJCbht9dTAH2/O/EZkx2oaPCZE3E=
X-Google-Smtp-Source: AGHT+IEWKjM0G5/OWmPMygitbKqDbSiVdLNFhvnfcsJNATijcxyv/E3n+9gfKngOd7ieiP8l9QZeAw==
X-Received: by 2002:a05:6000:400c:b0:39e:cbe3:17c8 with SMTP id ffacd0b85a97d-3a099ad308cmr2969207f8f.12.1746209051948;
        Fri, 02 May 2025 11:04:11 -0700 (PDT)
Received: from precision.tendawifi.com ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905d4b2sm1943446b3a.132.2025.05.02.11.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 11:04:11 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ematsumiya@suse.de,
	sfrench@samba.org
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	paul@darkrain42.org,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: cached_dir.c: fix race in cfid release
Date: Fri,  2 May 2025 15:01:36 -0300
Message-ID: <20250502180136.192407-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

find_or_create_cached_dir() could grab a new reference after kref_put()
had seen the refcount drop to zero but before cfid_list_lock is acquired
in smb2_close_cached_fid(), leading to use-after-free.

Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
held, closing that gap.

While we are at it:
* rename the functions smb2_close_cached_fid() and close_cached_dir()
  for clarity;
* replace the calls to kref_put() for cfid_put().

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 28 ++++++++++++++++------------
 fs/smb/client/cached_dir.h |  2 +-
 fs/smb/client/inode.c      |  4 ++--
 fs/smb/client/readdir.c    |  4 ++--
 fs/smb/client/smb2inode.c  |  2 +-
 fs/smb/client/smb2ops.c    |  8 ++++----
 6 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fe738623cf1b..ff4f9f8150cf 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -14,7 +14,7 @@
 
 static struct cached_fid *init_cached_dir(const char *path);
 static void free_cached_dir(struct cached_fid *cfid);
-static void smb2_close_cached_fid(struct kref *ref);
+static void cfid_release(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
 
 struct cached_dir_dentry {
@@ -370,11 +370,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+
+			/* If this cfid_put calls back cfid_release the code is wrong anyway. */
+			cfid_put(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		cfid_put(cfid);
 	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -413,13 +415,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 }
 
 static void
-smb2_close_cached_fid(struct kref *ref)
+cfid_release(struct kref *ref)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
 	int rc;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
 		cfid->on_list = false;
@@ -454,16 +455,19 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+
+		/* If this cfid_put calls back cfid_release the code is wrong anyway. */
+		cfid_put(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
-	close_cached_dir(cfid);
+	cfid_put(cfid);
 }
 
 
-void close_cached_dir(struct cached_fid *cfid)
+void cfid_put(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	struct cached_fids *cfids = cfid->tcon->cfids;
+	kref_put_lock(&cfid->refcount, cfid_release, &cfids->cfid_list_lock);
 }
 
 /*
@@ -564,7 +568,7 @@ cached_dir_offload_close(struct work_struct *work)
 
 	WARN_ON(cfid->on_list);
 
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	cfid_put(cfid);
 	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
 }
 
@@ -688,7 +692,7 @@ static void cfids_invalidation_worker(struct work_struct *work)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		/* Drop the ref-count acquired in invalidate_all_cached_dirs */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		cfid_put(cfid);
 	}
 }
 
@@ -741,7 +745,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			 * Drop the ref-count from above, either the lease-ref (if there
 			 * was one) or the extra one acquired.
 			 */
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			cfid_put(cfid);
 	}
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1dfe79d947a6..f4fc7818dda5 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -73,7 +73,7 @@ extern int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 extern int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 				     struct dentry *dentry,
 				     struct cached_fid **cfid);
-extern void close_cached_dir(struct cached_fid *cfid);
+extern void cfid_put(struct cached_fid *cfid);
 extern void drop_cached_dir_by_name(const unsigned int xid,
 				    struct cifs_tcon *tcon,
 				    const char *name,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 75be4b46bc6f..c3ef1f93a80d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2610,10 +2610,10 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 
 	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
 		if (cfid->time && cifs_i->time > cfid->time) {
-			close_cached_dir(cfid);
+			cfid_put(cfid);
 			return false;
 		}
-		close_cached_dir(cfid);
+		cfid_put(cfid);
 	}
 	/*
 	 * depending on inode type, check if attribute caching disabled for
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 50f96259d9ad..1e1768152803 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -1093,7 +1093,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 	 * find_cifs_entry in case there will be reconnects during
 	 * query_directory.
 	 */
-	close_cached_dir(cfid);
+	cfid_put(cfid);
 	cfid = NULL;
 
  cache_not_found:
@@ -1199,7 +1199,7 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 
 rddir2_exit:
 	if (cfid)
-		close_cached_dir(cfid);
+		cfid_put(cfid);
 	free_dentry_path(page);
 	free_xid(xid);
 	return rc;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 57d9bfbadd97..f805d71a8d19 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -975,7 +975,7 @@ int smb2_query_path_info(const unsigned int xid,
 						     cfid->fid.volatile_fid,
 						     &data->fi);
 			}
-			close_cached_dir(cfid);
+			cfid_put(cfid);
 			return rc;
 		}
 		cmds[num_cmds++] = SMB2_OP_QUERY_INFO;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2fe8eeb98535..97c4d44c9a69 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -889,7 +889,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	if (cfid == NULL)
 		SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
 	else
-		close_cached_dir(cfid);
+		cfid_put(cfid);
 }
 
 static void
@@ -940,10 +940,10 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = open_cached_dir(xid, tcon, full_path, cifs_sb, true, &cfid);
 	if (!rc) {
 		if (cfid->has_lease) {
-			close_cached_dir(cfid);
+			cfid_put(cfid);
 			return 0;
 		}
-		close_cached_dir(cfid);
+		cfid_put(cfid);
 	}
 
 	utf16_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
@@ -2804,7 +2804,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
 	if (cfid)
-		close_cached_dir(cfid);
+		cfid_put(cfid);
 	kfree(vars);
 out_free_path:
 	kfree(utf16_path);
-- 
2.47.0

