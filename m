Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F28137C37
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 05:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746162942; cv=none; b=kH3RN4eOTAiGgUF2IQwZbBvD4/ZJ+VIy1hpmYgTXSfAqZl7/8a7CTQ06PDF8qN4BKDabJ5Dg52idCWS77zmWFZVVgISgdfWS6X9+n0jtTBQsfGWOEhui5v8Ww3qBFdww9krbhBPRPMV9JRgina1GO/nFIu+pSjBWrS4ohQi5+tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746162942; c=relaxed/simple;
	bh=ZjfmKpz3KV2NEaA22iSvrTFQGECYuJ0RsrYPDo+evyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shORzI6LbmqX1bUX42HiMKwqUGIptjrPDfaIHGdBX5RFCYDdO3Mrywl87uK5M5NYoYK/SuhqCVHatNXF6zOe36YNUBpqaOVQSTNxH/wP3BdHyzdr4JZuIbsKldwhWSeXjvr1Z/UlmRoax22tvXH703+hBaTKrfZ+HLDsq4B+9Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQkE6mBC; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQkE6mBC"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-72d3b48d2ffso1902593b3a.2
        for <linux-cifs@vger.kernel.org>; Thu, 01 May 2025 22:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746162940; x=1746767740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuE1nKHTEbREWEBSD4+Z2sGhE59w0RMuFL+nlYdusEw=;
        b=YQkE6mBCIFePHuOU3NsCIEJtgl7WQ/HNLA0ElQegHvg8O0jkVPn5ZRYFcaObrmJUND
         mOT+fb7seSx/a9Fcgk6xEwBK32B/Gm/JGOwY4GtLmUjGC0oJyCRPAraQ/14HRbHBLECF
         QoFD2A2RA6tMOARCL1e+OSENoRM1pyg+D73FCE7Rws3CDzwhvarLmmG/Ne4aD54UCweS
         P0SaSejmgS4ZBupM7igxZUy6L4whIA7cHbGnDjSVDErqPQwEQaHHnLTVqmW7mNKCY7WK
         8qnuHmWCXe8MgvLOoM5bJBt6FfA4QUNprCD0jp/sp6GP5tAMVD7LEJ61aCfoxwKtrh+R
         F5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746162940; x=1746767740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuE1nKHTEbREWEBSD4+Z2sGhE59w0RMuFL+nlYdusEw=;
        b=Hqc8YgKl23aCPaqNF42bBzXykMtJsyFS+gnZu3yLW8H96gf4vK7pLHi0n5E0bNVAW/
         E2OW4ChaWAZSnc6oJiCY3ijQyE+tkTY5nmxmlOv1s8LJl2QgeQ3n9bD4YrCEVg4QGRQ2
         RXgpSiZhLlxpW267sND0AObm30L9VGiyzET1qaWsSD8wGNLjJPvQQCZQQeJH5E2dHrnO
         OzQD6miIn3L003QpT4nQDJXRmzhVTZxr4m9F/wbWaN4N+NHwIZ7Z1SxSiNf1VIKwfN64
         OYx0Syeie7vb/UZLtzwtXCi4BwbYeUFy9U9lZ1PSO6zqUcj9NRCXeoFxMts0fZYfRO+3
         eZ8g==
X-Forwarded-Encrypted: i=1; AJvYcCV8+aAMLLFYPnYwW84r0msji2pD4KatfWsD7xQj3co4u48valMeeSA1XfeXtQd19NZMKKQWuIrD9hcS@vger.kernel.org
X-Gm-Message-State: AOJu0YzWNc/zFmb80Dh7PRmeR6RF860FcvjWIawPML/vhoMEz5GcDTD9
	9yaL0YW5q1AdN8UntOCpW+Yaex+mq9+KfsTF8d4eLJT9/+NrplVmSJdZ7wMi
X-Gm-Gg: ASbGnctfLuupK3LL3YjwIcKo82fYbGRzPaaoleAmQd3QB+0gHkBcCy9uy3d4fP8rMxr
	dpX3n5hZFhnzMBbKOz3eONNjGDLBjL1VibfeMtRMbe4ODgDrSt8uCw9fW0zE9WxuYgCHyBz6/7p
	+5Apkr+APQW91xzQjuidriCPzr49XcgzKie5GMt0IzGHIWbfqd8G4J82k65flW4wC8ColBxaABi
	f1rmfa3cUznk+RumWqBgjiUvanxxB6dTZl0u4ILpvEXCM182ganP2fzhhaDmh0Q+O4E5Wz0pMG3
	0kGswtLW+FzY4UeY/9THyRznoI34EvCnek3LXNaq0wS6KI9Paxb8o2d6IMeBycsDu1vHaHYCFjM
	Q/reyknD09Ww4Jg==
X-Google-Smtp-Source: AGHT+IFryWlxzAfHA8cQzBRR4m4ukPa1C+yH2U5J4Qr/KAUQxEmRFhLgyJCgd66xR6AAzXbQo1z/dg==
X-Received: by 2002:a05:6a21:648c:b0:1f3:1eb8:7597 with SMTP id adf61e73a8af0-20ce02eb5b6mr2573147637.35.1746162940195;
        Thu, 01 May 2025 22:15:40 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82ba71asm425397a12.45.2025.05.01.22.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 22:15:39 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	ematsumiya@suse.de,
	pc@manguebit.com,
	paul@darkrain42.org,
	ronniesahlberg@gmail.com,
	linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/5] cifs: serialize initialization and cleanup of cfid
Date: Fri,  2 May 2025 05:13:42 +0000
Message-ID: <20250502051517.10449-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250502051517.10449-1-sprasad@microsoft.com>
References: <20250502051517.10449-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today we can have multiple processes calling open_cached_dir
and other workers freeing the cached dir all in parallel.
Although small sections of this code is locked to protect
individual fields, there can be races between these threads
which can be hard to debug.

This patch serializes all initialization and cleanup of
the cfid struct and the associated resources: dentry and
the server handle.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 16 ++++++++++++++++
 fs/smb/client/cached_dir.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d307636c2679..9aedb6cf66df 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -197,6 +197,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		return -ENOENT;
 	}
 
+	/*
+	 * the following is a critical section. We need to make sure that the
+	 * callers are serialized per-cfid
+	 */
+	mutex_lock(&cfid->cfid_mutex);
+
 	/*
 	 * check again that the cfid is valid (with mutex held this time).
 	 * Return cached fid if it is valid (has a lease and has a time).
@@ -207,11 +213,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease && cfid->time) {
 		spin_unlock(&cfid->fid_lock);
+		mutex_unlock(&cfid->cfid_mutex);
 		*ret_cfid = cfid;
 		kfree(utf16_path);
 		return 0;
 	} else if (!cfid->has_lease) {
 		spin_unlock(&cfid->fid_lock);
+		mutex_unlock(&cfid->cfid_mutex);
 		/* drop the ref that we have */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 		kfree(utf16_path);
@@ -228,6 +236,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	npath = path_no_prefix(cifs_sb, path);
 	if (IS_ERR(npath)) {
+		mutex_unlock(&cfid->cfid_mutex);
 		rc = PTR_ERR(npath);
 		goto out;
 	}
@@ -389,6 +398,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
+	mutex_unlock(&cfid->cfid_mutex);
+
 	kfree(utf16_path);
 
 	if (is_replayable_error(rc) &&
@@ -432,6 +443,9 @@ smb2_close_cached_fid(struct kref *ref)
 					       refcount);
 	int rc;
 
+	/* make sure not to race with server open */
+	mutex_lock(&cfid->cfid_mutex);
+
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
@@ -454,6 +468,7 @@ smb2_close_cached_fid(struct kref *ref)
 	}
 
 	free_cached_dir(cfid);
+	mutex_unlock(&cfid->cfid_mutex);
 }
 
 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
@@ -666,6 +681,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->cfid_mutex);
 	spin_lock_init(&cfid->fid_lock);
 	kref_init(&cfid->refcount);
 	return cfid;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 1dfe79d947a6..93c936af2253 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -42,6 +42,7 @@ struct cached_fid {
 	struct kref refcount;
 	struct cifs_fid fid;
 	spinlock_t fid_lock;
+	struct mutex cfid_mutex;
 	struct cifs_tcon *tcon;
 	struct dentry *dentry;
 	struct work_struct put_work;
-- 
2.43.0

