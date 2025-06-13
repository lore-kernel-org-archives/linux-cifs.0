Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF52E406
	for <linux-cifs@vger.kernel.org>; Fri, 13 Jun 2025 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749826600; cv=none; b=Z2JyySBBeVivwVxEYuJLI/YGkNFeXyhQtbibBKUArTsb3q8tHR2EHkK9RFrcUkw9O+zgIU7yOka39tJvi01Y7Kz0e2aUc5q4OfG2M8CKNBfplly6oXCG6nkzw3jgXzgEM3UrA6rHFk87x3T+GwYZif6i/XIx/OsfOyCC8V4BFaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749826600; c=relaxed/simple;
	bh=0BfaTR+OfJ68rs6rVTLVSvtR15PzNVvyxvmqetZKjWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHBCLuucqlQ9O0foBKUEiyyF75JDAop3DpVDjhwGnAHKMNlnoWhoqdT+hvWNnHXv7wj/CKRD2bMskZFjMJ0qc0cgcODSPqibI9pjmH6m41/I9xoDfqsjtPozGHb6eN1KZs9Z2vUZwB72OUIJyZa5wPQq1cqNaDa2rBNzATuca58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Efg6K5nt; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Efg6K5nt"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2363497cc4dso20030075ad.1
        for <linux-cifs@vger.kernel.org>; Fri, 13 Jun 2025 07:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749826597; x=1750431397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwPmGfIpQHPdAkRMo5fAeP7k3Y1poRqqIur+4uhAxlc=;
        b=Efg6K5ntoiAI/PWZXlc2k/DGC6F7L+r4m/s+sZj3zQlM5tXMQOSS+s92i1ZZXzWl42
         Ab2yIsu/UXoeUOXAqDw3yfWkS1nYEH5IJ/uUJIjselp7BLA3U0vOkl0manBl+VBnYWWv
         r4s+L1Phmmy6S5cPMuKW1vYUVv82Id9kqqXku78/nxCQtPqFH1kXAD44q/IZRVA9dLG6
         F8diuB8KfkNZCW58fxTuhvXbzzUebj64aq81pFFKEvRYEZcRjtdNuGFG4k/kIMYukLZ5
         eF2qm8hiwjDStwQl40+2Sij+MdZiFabUR9eMPQVeiZYQktMAEgIPAeWn54YMECdYYGXK
         URrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749826597; x=1750431397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TwPmGfIpQHPdAkRMo5fAeP7k3Y1poRqqIur+4uhAxlc=;
        b=JOYODcE5qrWMa57DxLF8YRJsvVJRwN5V8VhEN8VC3y6Ar76JrhUly3Gn6Dj6d6pum5
         677wC7Sqir75PeAdHx4Y9yYY1DLEcxTmqaHWh53j4ijvtJ2JPS/1tmy1f78U0fVnX+i7
         /HIPW3Khq3bx9CYtFbXXa/I8sUoSGxkmbo36KCKZlu2mJVe9lu0tAv7zBjwZDrqC+ZUH
         kdLpOO0XMZc7XV46IuvJSHBYmWqIJyHZcVGY00da28WD98pKMygwJjxFCESFdh7ErE2/
         ZBuVItwZ8eV+kQpPQ7utZmfOQfOZpLJmt12+6ToTiQGQyMXzGCvGVKXeTPE6FIzH+fRQ
         NSWg==
X-Gm-Message-State: AOJu0YxvZngBlTvCTEUdzmBOmHq5CkvBREWwCUBkhrNhmNPvnzwOJNGO
	jR9PIPtlqTtWsMbxl4soVJzVTTZoJy5I1CHvjwQYWm9F4mpoHFhbRzXgZ1a4qPp+
X-Gm-Gg: ASbGncvc1M5U3W6zbgXJKFN3voWxb947wdCPPWtIWfd57F9zKcW+X706SZbrK1LfDZM
	9VCTMH0R+x3WnvmkIM55PYS6eTLT/wbyloEf3mUtV4n3jS573Rn0IAeCcesJ61ArApxT61hYBRa
	0spJHDUahf3ZfeTFVaQCcQYLJGkuCOO08eI5O5HoifLJ/qz1n0sYOO7Zxo17H+gX62G3xJf8dXD
	Ay7wSwokrRVJLoRWNampxosEysWuAxm6QEASL0K0Pv3N/eHyKULTkVbDoIu3IRSmSzbqFsJCmJj
	6nE8NTW2IADdlxyfHZNWknOx24/zHYlQBgXcoTco02xvub3KVNAvKUp5ek4OzOboDkV4Dnu/tRM
	9XVJ+I85lYkhQTo+o
X-Google-Smtp-Source: AGHT+IFH0WMRL3YjW3O3d4HRol5TBQN0Vi005vGwxVq6wu/YNGavxycKgryY9CebhpceIhvlDBCalA==
X-Received: by 2002:a17:903:1b30:b0:223:653e:eb09 with SMTP id d9443c01a7336-2365d8965e7mr41614485ad.7.1749826597547;
        Fri, 13 Jun 2025 07:56:37 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365decad8dsm15132595ad.214.2025.06.13.07.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 07:56:37 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 4/6] cifs: serialize initialization and cleanup of cfid
Date: Fri, 13 Jun 2025 20:26:02 +0530
Message-ID: <20250613145627.987042-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250613145627.987042-1-sprasad@microsoft.com>
References: <20250613145627.987042-1-sprasad@microsoft.com>
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
 fs/smb/client/cached_dir.c | 15 +++++++++++++++
 fs/smb/client/cached_dir.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 9b5bbb7b6e4b..d26a06cdde64 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -199,6 +199,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -209,11 +215,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -419,6 +427,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
+	mutex_unlock(&cfid->cfid_mutex);
+
 	kfree(utf16_path);
 
 	if (is_replayable_error(rc) &&
@@ -462,6 +472,9 @@ smb2_close_cached_fid(struct kref *ref)
 					       refcount);
 	int rc;
 
+	/* make sure not to race with server open */
+	mutex_lock(&cfid->cfid_mutex);
+
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
@@ -482,6 +495,7 @@ smb2_close_cached_fid(struct kref *ref)
 		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
 			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
+	mutex_unlock(&cfid->cfid_mutex);
 
 	free_cached_dir(cfid);
 }
@@ -696,6 +710,7 @@ static struct cached_fid *init_cached_dir(const char *path)
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

