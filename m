Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2F46EB79
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 22:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746226442; cv=none; b=Wvx9GBU+gj+PBBFaxxOg6Fi7qtaWBWUbCFZ2KwL2tCMHfefSNspImghlByH0kFz/zdvV1gFU+OOprUp8dbVUr89yyY0eygdJ4tdGVeFpJJcF0v7MWfE7izLp0Q2y2XQSsYO9p1+QyMIK7CWKf7q6IxM/6e+xkVer6hte8UzOd8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746226442; c=relaxed/simple;
	bh=qzQoEK9PSfHNmgpgLhAmI3OTKqsKmhiZtZLXolF9VNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K5R57hBaE1OFuKmHKoCt9CyqHUUzc0UoWaakEaATtfeUHuOEpMxyCm2xXPXhBWB2CiIynoOLeqeDVMvr1Qu6y8nfLwGhT4rvsnGPMhlJFvtdjG5rok+/XZx2WJPpE6ITaSPKvfKgWIh3vngJ3RaqBL+S8kmYR1KsWTNwX4fwFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MtauUmd3; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MtauUmd3"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-39c1efc457bso1712102f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 02 May 2025 15:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746226438; x=1746831238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pb4YRvDo+VQJaWDUo/vJ1CCwVZvt+Xp+PnF4YD+Zxvo=;
        b=MtauUmd3Y1l8EpE9/f+ZTavTayBtRzsWL4H1me1ooG8Z9BhJr7C9/BiCJtH6H8j8HF
         r2V3qX8GxxEnOSv+lCu8LxJ4Bkz+ZFxgkMzKUOrsQ+Jr44ZMAZ5xWpL/mgwgB+6w85wp
         5TTM9IqSMzzwzlqDoSvA7QkNXkINT8YibuUBvUSxdKZfDRa1TG+us1ekG+uKLDmgvutL
         /yjcNWNPgWkNHEbjssyB/M14wNA4ZVUFEGVxecCh5K/Wd5jUfSAngR9bMugbI5hKtOuW
         bPWQ80WHV7IGYmSG8neuPeIJMhTTknhMTHWSjMG/ctcRYJdBxWgd6a2ZGxaMm1Zzqxud
         fS2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746226438; x=1746831238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pb4YRvDo+VQJaWDUo/vJ1CCwVZvt+Xp+PnF4YD+Zxvo=;
        b=CzSUhiZRvblOXhVDMd5K2lSx02sczMLcxW02+PsjkUbFZU3yHucaCZ7nY5q/eLzp7L
         GEoecV368q4ZcCONmJs7/OtGuxYC2pISQpEdqVy810qa6VL5wQOvKITSBorYQuMgzmBU
         +OENAEHhe0QlWsH6Qxv1do8MCYk2kPnZthJc7Ex/9QdgQ+kgoy2sZJClpmJH9OYgx/eC
         uOq8obPe1wsYRALACjuWbG5qYOpho8MO2L0mYeg0+Hx9K9RgIYfzjA6lCw0Kb5gwsVPh
         oz/VNds3EUYk2dEAAoBDVNcsDysfmudill7StkUBDAMq5su9mnKAyau6L8EnMABTKgrs
         FWtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxGaYG50zLe+9arOGyryKhrcasocxAizmODKpcTNbfDyNOPhg+Wk1fbsP+5i3Xo1iK+vuN530MpJVB@vger.kernel.org
X-Gm-Message-State: AOJu0YzKikfj/znTedfTlUwRDpPyBLQMejwNu8K9pCVt7uOUorP7j1pa
	AesTYClwB/teeMjBEGYB4onM/ZQ3pNtBXPRXzTZCVUUtn+9Hw47fiJPp9jXWpKA=
X-Gm-Gg: ASbGncuXK5mUXZ9/aAdZCOtfAe0cQ7iZvAzc7DpjHAtSGipav9jww51GxHaRPH7Dvny
	QBqs0Vwv0v/u2ESB1RBHAvDLN/4UtRQtjVMhr/FpAXrFNNFDcuGAMcMA3DocSLFPpQFN/j8vr6U
	8Ln2XZf2j4PcMnwHrVnMvzO3TV0E79iaLbIhJPDw6EyYP4thCkdlgViq2CxHEYy08qti95yyeju
	jPDZXIApmeQA83Tn1uEUntrGhTMir1uQei8svJp6eDBGRsHQc3TemxEqJNb6eOvBHPjrwI9+0O4
	gPsZhalByTotMt/SMM6uSGG7jHqCNqSptXW7f44ECaATzYpPbiwJm63A1PHK3RdZLx0=
X-Google-Smtp-Source: AGHT+IE66j4CglcpEbpZtxLcNKD84x+8bOrKDqRNGkSpzIIkxSDgzDBVi6CykeAIY8SSJlToIpJvSA==
X-Received: by 2002:a05:6000:1446:b0:39e:f641:c43 with SMTP id ffacd0b85a97d-3a099af0eb8mr3220522f8f.53.1746226438524;
        Fri, 02 May 2025 15:53:58 -0700 (PDT)
Received: from precision.tendawifi.com ([138.121.131.123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7405905cfdfsm2149761b3a.123.2025.05.02.15.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 15:53:57 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: ematsumiya@suse.de,
	sfrench@samba.org,
	smfrench@gmail.com
Cc: pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	paul@darkrain42.org,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 1/2] smb: cached_dir.c: fix race in cfid release
Date: Fri,  2 May 2025 19:52:10 -0300
Message-ID: <20250502225213.330418-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

find_or_create_cached_dir() could grab a new reference after kref_put()
had seen the refcount drop to zero but before cfid_list_lock is acquired
in smb2_close_cached_fid(), leading to use-after-free.

Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
held, closing that gap.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V1 -> V2: kept the original function names and added __releases annotation 
to silence sparse warning

 fs/smb/client/cached_dir.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fe738623cf1b..fc19c26bb014 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -370,11 +370,18 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
+
+			/*
+			 * Safe to call while cfid_list_lock is held.
+			 * If close_cached_dir() ever ends up invoking smb2_close_cached_fid()
+			 * (our kref release callback) recursively, the reference‑counting logic
+			 * is already broken, so that would be a bug.
+			 */
+			close_cached_dir(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);
 
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	} else {
 		*ret_cfid = cfid;
 		atomic_inc(&tcon->num_remote_opens);
@@ -414,12 +421,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
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
@@ -454,7 +461,14 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+
+		/*
+		 * Safe to call while cfid_list_lock is held.
+		 * If close_cached_dir() ever ends up invoking smb2_close_cached_fid()
+		 * (the release callback) here, the reference‑counting logic
+		 * is already broken, so that would be a bug.
+		 */
+		close_cached_dir(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
@@ -463,7 +477,9 @@ void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
 
 void close_cached_dir(struct cached_fid *cfid)
 {
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	kref_put_lock(&cfid->refcount,
+		      smb2_close_cached_fid,
+		      &cfid->cfids->cfid_list_lock);
 }
 
 /*
@@ -564,7 +580,7 @@ cached_dir_offload_close(struct work_struct *work)
 
 	WARN_ON(cfid->on_list);
 
-	kref_put(&cfid->refcount, smb2_close_cached_fid);
+	close_cached_dir(cfid);
 	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
 }
 
@@ -688,7 +704,7 @@ static void cfids_invalidation_worker(struct work_struct *work)
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		/* Drop the ref-count acquired in invalidate_all_cached_dirs */
-		kref_put(&cfid->refcount, smb2_close_cached_fid);
+		close_cached_dir(cfid);
 	}
 }
 
@@ -741,7 +757,7 @@ static void cfids_laundromat_worker(struct work_struct *work)
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

