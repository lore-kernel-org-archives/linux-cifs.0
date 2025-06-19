Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D7735963
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 10:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750328003; cv=none; b=EODq64iD2BnRMaZGb6umviIRJuD9FWLMDs1XJdrxNR0OLLI0IvBSo3sLEhbwIj8izUce5yp4QqT3ySYMPXUIgRvzncGZ8QwW03z1dWWrxkOQqkVu6fq5nh+GyuWDDLLru6rQoDMsIOgIpmIEJ3ch/8Em4RXSN7GOZug2+YtJsAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750328003; c=relaxed/simple;
	bh=KGjQvLLlaxYhjkH6rLlcNybrta8dWCXilSdwt628PM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JNdFIt7H4w4iu2RyUmMqykUDFj4PEKT7fck2CjXv+APwQlavGxNjlMSfEuQ+wmMP4ol7nybv9aE8XeoYMrwyceLKlTjyOLjQw0sQfs8DJX4dYjKt1ZMHQpK9DKP1UtyFwD6R919JqzYfi5r3N6gN9oVEJqWkzKXeasoKfg9USN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=macz29xL; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="macz29xL"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748d982e97cso524338b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 03:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750328001; x=1750932801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZAte7L8hzdbt7d8+zDuMBApfKhsfqdf2+yGz7Me/xo=;
        b=macz29xLuUsVU5H8a7Mmhn9amvpzNn6JCje2Pj5VtMmhmX6pfHjEGvpV8SRQL3F6bi
         +5rPhGdRYyJKR99+lFVchBkkoS5xYDfmoB2uNWIuSMBowXGV4TNLslMPewApEhF1hPIn
         sijE3MYWi8l4bRMrWyC0spwfnmYD7u56SZQWVlq8Ph3jt5+7Bh3Ou2L1cOtgTBRRSDED
         E+NdZiTlmZk8yKbkktxHe6xeNrDYmbuS7bQnsyiWdP/11PS9DlnMMqtCOfK6+rqLAAOu
         pp0c40MwnQIhljQCEvy2O7i3ZabMZ5caJbrQkqTT4lV4Qmu1W7wTKyCNegQnK9DoeW2f
         g3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750328001; x=1750932801;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ZAte7L8hzdbt7d8+zDuMBApfKhsfqdf2+yGz7Me/xo=;
        b=QTKe/DUuRHdzI2jDhDivu0yKjBO6gu4IIWfnL/CpW4p43aIb6wyql1eseUyZYwbusr
         BzaGRbUFWlr8wOT00f5qKXXmLiMsBj9i/IBnBZwXAL/l+1Waejvr5kZjcBWELF3AzV8s
         tSUC5iweuRoUli3qmshKEwDT2piO+Kk2esSUXfdpMSKW8ZbKNf2hMHkhIjaGmTpne3Up
         YiRV1CcJJsNemkV4I030Gfla/DgYTDyTKnmxXoGiCaXM4XWpcFNMljeBFk9q5zn825WP
         aI/o/pf7cAE4A8QfHBKc56JPgEGizrPULMRAJzzAlwGNW1P/gKF9SDuuK3l+gNI9GloW
         W2Dw==
X-Gm-Message-State: AOJu0YyWBQNeTIc8d60iJg29K00fFm6nL+GEktqYsbPng30VVHuIL+Gb
	+0NJMKt2z3a5jIrjhmz9bK8BaukcwJa+zDtTLhyJUHp/b6yh5nhkBmZOvx6j9tfgFQg=
X-Gm-Gg: ASbGncsBtOvsB4/wGpvZq7d7F7vOtxbM0AF4jl9kB3gbx0ZN6ZXnd1YI3W6s4aEqxWC
	kMDKAzoM/a/7BOypfOBDIsOTisRZ3I1uCMLS0oTYYzkJqaRKzXqBmj2x8SHb5Fhs66TJyaU3k/A
	gantsJnYo/YWF/Tg7PxGEeKn2Hexz4/lfMd67u6IJgSIQY4vkomnKucAyQEDnMZmQmSTwKE0r1u
	u8Q/C3q0/JgNuij/cH174rmQU4s+uZWwNsEg2R35Uqz9eKydouhpKl/kKONYcnib66P4oyIVCR4
	2LaThcgsje3Ct2oc7feRDLgn06aqpoQHqz+ctEWv+RzAbp+7PsY4/LpRktItSyX0ba/H2zRpONX
	QPppJNY+oufoHcg==
X-Google-Smtp-Source: AGHT+IFhdKDzmcpBwy30vlGsAa93tu5u8ZZ8+oc/FaxcLWw7DUSv/wsNRCYOqUhXJ5U8g1spDPphlA==
X-Received: by 2002:a17:90b:35cc:b0:30e:3718:e9d with SMTP id 98e67ed59e1d1-313f1d5077fmr32251620a91.35.1750328000690;
        Thu, 19 Jun 2025 03:13:20 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a3188a3sm1783403a91.36.2025.06.19.03.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 03:13:20 -0700 (PDT)
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
Date: Thu, 19 Jun 2025 15:42:59 +0530
Message-ID: <20250619101314.750228-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
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
index 9b5bbb7b6e4b..9c9a348062d3 100644
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
@@ -413,12 +421,15 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		}
 		spin_unlock(&cfid->fid_lock);
 		spin_unlock(&cfids->cfid_list_lock);
+		mutex_unlock(&cfid->cfid_mutex);
 
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	} else {
+		mutex_unlock(&cfid->cfid_mutex);
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
 	}
+
 	kfree(utf16_path);
 
 	if (is_replayable_error(rc) &&
@@ -462,6 +473,9 @@ smb2_close_cached_fid(struct kref *ref)
 					       refcount);
 	int rc;
 
+	/* make sure not to race with server open */
+	mutex_lock(&cfid->cfid_mutex);
+
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
@@ -482,6 +496,7 @@ smb2_close_cached_fid(struct kref *ref)
 		if (rc) /* should we retry on -EBUSY or -EAGAIN? */
 			cifs_dbg(VFS, "close cached dir rc %d\n", rc);
 	}
+	mutex_unlock(&cfid->cfid_mutex);
 
 	free_cached_dir(cfid);
 }
@@ -696,6 +711,7 @@ static struct cached_fid *init_cached_dir(const char *path)
 	INIT_LIST_HEAD(&cfid->entry);
 	INIT_LIST_HEAD(&cfid->dirents.entries);
 	mutex_init(&cfid->dirents.de_mutex);
+	mutex_init(&cfid->cfid_mutex);
 	spin_lock_init(&cfid->fid_lock);
 	kref_init(&cfid->refcount);
 	return cfid;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index bc8a812ff95f..b6642b65c752 100644
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

