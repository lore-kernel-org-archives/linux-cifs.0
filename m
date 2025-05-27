Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B3280322
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 18:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748371447; cv=none; b=ewItBn6VcjCFNrry8oum3l+gizH6GfTnu0f6YG66XuFVLBGl/eH/ZJyn54kyT7cALnDHxqWlSU6KKMzCS3nIAgIe2yvbwY7nO/OaAknv6WF5n8On1plxXahisglv0nPx4G7yxNrTj2m4R9QxzRH4QSBKVwv7xeFNvqrTBOLywgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748371447; c=relaxed/simple;
	bh=VokCtBa1kLY0vOm42wV46Evt0IdZRJoRYG8K6QxUCi8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ni8nemPGMfygjI4Xn157Q+bn5uncmGpEcgcBgMhINdt5S5xVdy9UQ3jgZ1RoQBUduBaqMDQgmJiZWLWRZQkxdUFJ5JnxKZUSmCEj/B6/yx0fCBrs9x7AiLex8VvRaGeo6GATlodqxTkBfTS3aLFdpmqLunUx9rnC/yCfBE3ZJno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YBk8xzXy; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YBk8xzXy"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so96779f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1748371442; x=1748976242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HigszQqUCsYMquf6b3nev9gsaao67T0NCIFgOW6Bhyc=;
        b=YBk8xzXyB607/GFA0IHAvjyTdlUArmWbNH1D3Vjs4TBxqJY9nrjXQfMqD6cr/xkKHV
         yOD15mGEQdfdcf3Zbj843vcPek53TAOjIgvkNNX40kWVJ4P9J3Quh3CGKxhsXOww3Yt7
         P8rIv5ItcvgoBD74Ewm6UMnVYu21KhKdjWBTvTCLnm9MlSh0NKppL+i3kbk5GvFHEzUc
         ynuI0r6R/40x4uUPO2I4GagwV/P8ScSOaEXzV6UU8be3/Rpl1jXgKU40g/MSN6IsxY0q
         czpAN8dXfez+zryanO+trTG2fL2x2g6wIrims8TezC1cSsEJZSMAqoztA/62LjkRCZ/o
         Gmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748371442; x=1748976242;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HigszQqUCsYMquf6b3nev9gsaao67T0NCIFgOW6Bhyc=;
        b=tMnAnLfxeArkjLqBbIbW25KfrDVN4QeQ7qGBs+z6DzsXAyOdaNsbIaYkgRzQEnGAm0
         anzwpdX5jhAwzAw/upALX2eM47jcFfnt0pJ4UOfIYlGW9GbAmba6eg4du5+jRuezyMnx
         xN96ePsQ2+W3FATlvPz/CxiqLmlm0/x0qNqRlGcJExbvsi7+SsGqLoJ0ioUKSptNB1aL
         SxJuMDeLBo2Rdiv1NJbY0joU037IgL1o5UJqjPAzbzWh7EIAzdQ+y5TWDQopGvqZxkb5
         +Cou/69ehRzQVLezdDCihl87G/Z6RjoHzIAvAuIhh9hKbjbzOSemYAGESuSWBvKXj48Z
         1Q9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8t5mIDj9teq6rs6BfVZVva7annBwJE7bH0RKsDsuCamdGQTWaYLuP1h+3OCAEjjhP6y5RIlncDiuu@vger.kernel.org
X-Gm-Message-State: AOJu0YwGmP4FmpZc75ti1JkuurALL0KXF9HRmLnRj4yQLP2CwgIKzwP/
	R93dn2s+22zdRaCB8P1smf7bA4/sl+P6MNRSHOTbbjlf1i/BWQ1MeZ3dxWIrpht2aAo=
X-Gm-Gg: ASbGncvsu/KrHD2buqvEfAUxYIFxREW2/vEnXitqyUQoUcGOhShDl3eMUFT86EP8w3s
	HbB2TkryoBAQSac6dVjgVRAEWW88HMQnd2PQxXewJl52jF8vt5kBbAWPz9C7IEfXzktmSDeVmX4
	LshaFzTTTXadG5hucpqw8YKKQr+2N8UPMWkOKvYVgsrLRb0nVo5bCipDXXVEnULqdxkLeuTYD+F
	lr+F3CftPRY1s7L67p6DKqm5HYHq25eJU77sXc9E7pMCIEO+KHPbygCtD6WdJ7ysuHRokZ2kexC
	640sPsPtlXRsMQyQbdSWRUhHHegjtuDK/mX8d846LXrfOAi3wA2OtPtGPDLqQ73Uqrc5hYX1biF
	3
X-Google-Smtp-Source: AGHT+IGDmf8wErKg52er0rpJ6x3QMMltNHBqhEi0kEAztGL0LtvqlxSsDbk2VASwl+LSmoVp1+vyYQ==
X-Received: by 2002:a5d:5f55:0:b0:3a4:d685:3de7 with SMTP id ffacd0b85a97d-3a4e5e5d6d4mr1900935f8f.8.1748371442397;
        Tue, 27 May 2025 11:44:02 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc00:cf9d:7dfb:3497:3dc2:8e58])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-4e56758d2bbsm2422511137.9.2025.05.27.11.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 11:44:02 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	pc@manguebit.com,
	sprasad@microsoft.com,
	paul@darkrain42.org,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v3] smb: client: fix race in smb2_close_cached_fid()
Date: Tue, 27 May 2025 15:42:13 -0300
Message-ID: <20250527184213.101642-1-henrique.carvalho@suse.com>
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

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V2 -> V3: rebase, remove unneeded comments, modify commit subject
V1 -> V2: kept the original function names and added __releases annotation
to silence sparse warning

 fs/smb/client/cached_dir.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 89d2dbbb742c..09daf9500baf 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -365,11 +365,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -409,12 +409,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
 static void
 smb2_close_cached_fid(struct kref *ref)
+__releases(&cfid->cfids->cfid_list_lock)
 {
 	struct cached_fid *cfid = container_of(ref, struct cached_fid,
 					       refcount);
 	int rc;
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->on_list) {
 		list_del(&cfid->entry);
 		cfid->on_list = false;
@@ -449,7 +449,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
@@ -458,7 +458,7 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfids->cfid_list_lock);
 }
 
 /*
@@ -559,7 +559,7 @@ cached_dir_offload_close(struct work_struct *work)
 
 	WARN_ON(cfid->on_list);
 
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	close_cached_dir(cfid);
 	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
 }
 
@@ -683,7 +683,7 @@ static void cfids_invalidation_worker(struct work_struct *work)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		/* Drop the ref-count acquired in invalidate_all_cached_dirs */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 }
 
@@ -736,7 +736,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
 			 * Drop the ref-count from above, either the lease-ref (if there
 			 * was one) or the extra one acquired.
 			 */
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+			close_cached_dir(cfid);
 	}
 	queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
 			   dir_cache_timeout * HZ);
-- 
2.47.0

