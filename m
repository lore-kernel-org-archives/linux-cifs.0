Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05507081F
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032321; cv=none; b=nxjvSr9uP9OV8o6CQdKk0je9ANPVaX9oiiNlMc4KtmwrW64+ArgK17nhF+YjNpHu5B7Z09XhqegKyoZcpalazfEqAmW89tWcf/782fdHwmPkNbtm02TM8dI7DXp4ihAAzIlNCQKoCVJilZiTS2CCjIm3+I6Mo0n5m6afg4Ik/2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032321; c=relaxed/simple;
	bh=IPj9u7dGaYETeW7dX1SNlOyX9Ol1NPhozZGLyinkLco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJLBS8+U/jklIoaC2OazqwammWq7BujJFLoOyTDrYzioDSekeracOcaI0nw/T3Rv+bdo+UBhdpa/+vO2z8dXpv78+zirqKcOVGdGNgij4AKCMuh6YX0IV2eSt1o/8D4ZrYqumXnhJJOg3UPv06y0On/EfY6VsWFw4/W+ZHs+kxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VLxxjFsu; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VLxxjFsu"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-235ea292956so1373665ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032317; x=1749637117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMGQPDcFr59LjLvr6Tvg4uIejOoy+nc/9tdvuibx8fw=;
        b=VLxxjFsupsXBARmZt3pxS3YfT4VLtNt/qLOIHQaobJzfX+Uwz9v0giGscOHavLf+2J
         Roxn2GJuGBaGk+B1RGp2+fn2tCc1uyT+X2KK+vzSWs8VzLnqUijh9fu1PqL4JtxoLTzO
         v6crTjRACvjrI/MrZkXew+thNP7/YOFuvc+YQ4Cejmsf3LxB0sll11yikAn9G7mr8b0I
         PRoXRibPCTe5bK5O9O5LeS0HjM5CfSzhTZOUVQ0SdeH2Pd5SO7LO/J2LqrKrlk2cFuZ2
         IhAvydliwCKU1tEhxvpqhrxN8zmfLFPOYLuOGyBpj496HVE1G2b7hwAU6c/28AyA+oBE
         rI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032317; x=1749637117;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMGQPDcFr59LjLvr6Tvg4uIejOoy+nc/9tdvuibx8fw=;
        b=q+UukpJsPzSHr8jlT+tJUrnuQo4Fc/oql2Onn/M37fqaDRJ7uvVAZIF3WZB4rwvS25
         qRFLXNH+VcAR6gkDv+3u992MAd9+yGFQ6mz3TI5LzUfd4JjuRAyCl5H/FWq5urSFOTDJ
         nhhM1NPvG7AwNndIx4kVpr/uuey/5MmgwIke5Ca93HByPwDIBbz7Dc86Ip1vjbuZo0bI
         yKwCLazqDmGttFAWLKE5u44HxRQXZFaM1PxpHST/XglopZ6S/2fT8pTUxv8PLNoQXHmH
         fMzVRcde2VYfiDZpzHDbFQg+uOT9hICQfVRoIpjqnmk7F9mlbZRtELChWTfkpyO9xigo
         oNDw==
X-Gm-Message-State: AOJu0YzUYccf7xqIjyU6Z9aiG63rVTdCgjLGRHLD01itzhYkukitxmEr
	Zcd/ILqpTQUs43OZdX5g0xAh889sCPyfAkU+ddThZlS5BHCs7ZsVWLATYW/91MhslgY=
X-Gm-Gg: ASbGncsroY70ilndL3Qe1W97DMem3Ot87baMctCRJHYscp9hExjRC5kexFGfpwXhmWf
	YEwvu5u7rHXUdoTanBTSUsIzbpEorSKrzHt9psWdbnjxI77vpbmoduNBSkFvrNCX3FACrdHvrAC
	0PIGiOulFY2TVzpoVoDZ7ek0DgVSeeinFkkP/ARcgsLvbhIHIqCCg1apUBXpuuA2T5MFCOCp+rc
	PR7G+QWS4cu0S9ewCFbIUN00//QOTdPsrp15zwD5/DdrPeKRzPh0sAv31NbFllRPWAbasPw1t1c
	YxIHVs5YXLoR325S6+u/eLFVIOEwRI77Ua3vo9actUg3xpZKQYSNZtB4CGqiC6OxPNCKJAf+t7j
	FfTI=
X-Google-Smtp-Source: AGHT+IEDzTgh4yVAUaM9S8O3WygY079J+XW1FqFH9Yvivbp8HFxks96cNGILoVFgW54Ui5v2wZSFYQ==
X-Received: by 2002:a17:903:1a30:b0:234:d431:ec9d with SMTP id d9443c01a7336-235e1015a0cmr37399355ad.5.1749032317416;
        Wed, 04 Jun 2025 03:18:37 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:36 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 7/7] cifs: add new field to track the last access time of cfid
Date: Wed,  4 Jun 2025 15:48:16 +0530
Message-ID: <20250604101829.832577-7-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604101829.832577-1-sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

The handlecache code today tracks the time at which dir lease was
acquired and the laundromat thread uses that to check for old
entries to cleanup.

However, if a directory is actively accessed, it should not
be chosen to expire first.

This change adds a new last_access_time field to cfid and
uses that to decide expiry of the cfid.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 6 ++++--
 fs/smb/client/cached_dir.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 4abf5bbd8baf..d432a40f902e 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -213,6 +213,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	 */
 	spin_lock(&cfid->fid_lock);
 	if (cfid->has_lease && cfid->time) {
+		cfid->last_access_time = jiffies;
 		spin_unlock(&cfid->fid_lock);
 		mutex_unlock(&cfid->cfid_mutex);
 		*ret_cfid = cfid;
@@ -365,6 +366,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	cfid->tcon = tcon;
 	cfid->is_open = true;
 	cfid->time = jiffies;
+	cfid->last_access_time = jiffies;
 	spin_unlock(&cfid->fid_lock);
 
 oshr_free:
@@ -741,8 +743,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry_safe(cfid, q, &cfids->entries, entry) {
 		spin_lock(&cfid->fid_lock);
-		if (cfid->time &&
-		    time_after(jiffies, cfid->time + HZ * dir_cache_timeout)) {
+		if (cfid->last_access_time &&
+		    time_after(jiffies, cfid->last_access_time + HZ * dir_cache_timeout)) {
 			cfid->on_list = false;
 			list_move(&cfid->entry, &entry);
 			cfids->num_entries--;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index 93c936af2253..6d4b9413aa67 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -39,6 +39,7 @@ struct cached_fid {
 	bool on_list:1;
 	bool file_all_info_is_valid:1;
 	unsigned long time; /* jiffies of when lease was taken */
+	unsigned long last_access_time; /* jiffies of when last accessed */
 	struct kref refcount;
 	struct cifs_fid fid;
 	spinlock_t fid_lock;
-- 
2.43.0

