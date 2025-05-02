Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D287A188907
	for <linux-cifs@vger.kernel.org>; Fri,  2 May 2025 05:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746162949; cv=none; b=CORuYpltCbYsBpn4PBnR0KTUZIZhNsmAnCBDRqbU4oT7IUmedmFOyWie0r/KdH1pjfk2HJuFwPb0w0bgLO0LMTXu1rvE2KLL9/GKL+kLFpMVLngD9lKuTfRcNY7iNXve1PSvoYEJYJB4o9aAI2d+j5SCWGZo/DrwiZQneDtrQ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746162949; c=relaxed/simple;
	bh=co4zOfCPFFFFZs/70+uIhIU5Tghseu0cVBTHjWcH6XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMpsj8zfc8VsC1oxLGLE180eChnZJ0xWzJSyQskd0+c19tjadkhKfGPpRKGTD6f7HmwHKCNCLfnfNuSwUY2S3EgxLRGfB/z3uqkBweRloOPGLHw59S7z1xSnFsT9xkhR4hye0SsnzAWHqC7VLJw9iPLGS+Erfum1QB6jilKLzj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lXrUN3v+; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lXrUN3v+"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-736ab1c43c4so1719549b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 01 May 2025 22:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746162947; x=1746767747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaNJ86ve7diX2gi2pIMUpFuvasHBdH0abk/UlcKAn00=;
        b=lXrUN3v+N6x+rpd1WUZl+XMBCwg9SU1T/6cd0HVQZF2ZJm864cZmkSkb+bBXpQxWfq
         07aJPMwIg1F2H/Te/cZlo2EOf6FShVoohyDW8/lKlrhIaXCc0v5kkyEL3WDg3iqTXq2E
         RYWG1+1ETacWB8ThRSmCV2fvCKc0l62+CugW5NpGivM6Pn7voWYAxikLEg1qN7h7oMrK
         3ihehDaW9ZaOj6ksxlJPIHTRddOqvpUukGJ6oR/ElqHMHHLaODOHWrecbGTWGyLV19gV
         IVjmJHA25BXs2hXT5e1kFZNefBSaVAMzSBzFvrllTLdST7oKFQlfHVpMKOqbzpSkph7Y
         8veg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746162947; x=1746767747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaNJ86ve7diX2gi2pIMUpFuvasHBdH0abk/UlcKAn00=;
        b=BZs8cvn2QVDdVRWcBeQZXnHw56Kxu54HnkId5xLgGrxHja5dJH26+97iOxm8MPtvF7
         M2Vgx1sMBzR6+G2+Io5eOnR96NrYi3cvgNwUWoxVD5y2rzw2PXHjgp28zta5L3vlFNtm
         wAX73Ibd59pfKQKxhlhuhThjP0CBaswb/qdmc3s5bbychAByFB2Y49IvvWB0zbpxyOe5
         Ko9bQEtc5X4zVXOOyVjuy/Zap1dbWeE6IQ4yyWAYA2p9jN0cOGUAz6zGQer6mZEdJwKW
         67cRoXazBNpexZ0FvZ8Tvnxf8tv68lp9MdVdqwNQ0lyFpLoMoGirOGyjmv0hUGYWoyHP
         Idhg==
X-Forwarded-Encrypted: i=1; AJvYcCUMZprYvg6MeFWXEzOFhkNUdEvDqhMZU1W5Eg4+FjNoTtmUjT3M40L/cNS2gVJ/k+tFrH5bbJ3Wgi2o@vger.kernel.org
X-Gm-Message-State: AOJu0YyFjfbZ6cfprRiYuPyEBkLfnPx8Crxe2PHvS0lBllQ7aM3Am7Tu
	ad1dTnPYbEC3EorTTDrvoMDK5a3bRv4uIzpvCpaaqh98nH+qUQkQ
X-Gm-Gg: ASbGnctJz5Dify615/nAZ0eo3rFrAwI4v6uuo42UFSYaLaEF3KfH3V8E2197zzkjye4
	qgI9TKAWfxfoXJMGTW+5AenUTsyoI+xJwAlgTAL+vQqXiInynnplZNtFFeHMxi4ZBRAbc9DuHuU
	vap3DTvY7JWgStLf7O7VeAzWt9N4BCx6NTA2QqPHkOFAHzEgiNoAGSZ9/TvIOZeT5HEvVsgLDcy
	l8HP0NQMXhWSdDa+Lctc1lvpf7KwLuH3fJQfDVEcL6laFiycKsPFSXNW1DqLRc5BetG6868fT1Y
	BEx8sFdPcdb+G2UFTMzziZmR2+JzBHG47RXcznBVMQS1YKe6lfUl3UxujXcbwJXyFRPRpCGG+nW
	NF+Y=
X-Google-Smtp-Source: AGHT+IHBUDlPh7Uqkgiz/0r5dKbDdeRP24hrNbNeKC7oPDy1XgSP3PTBFIWvTlg/uCvKyRmr3EWvHQ==
X-Received: by 2002:a05:6a20:1589:b0:1fa:9819:b064 with SMTP id adf61e73a8af0-20cde95638fmr2314688637.18.1746162946875;
        Thu, 01 May 2025 22:15:46 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fa82ba71asm425397a12.45.2025.05.01.22.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 22:15:46 -0700 (PDT)
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
Subject: [PATCH 5/5] cifs: add new field to track the last access time of cfid
Date: Fri,  2 May 2025 05:13:44 +0000
Message-ID: <20250502051517.10449-5-sprasad@microsoft.com>
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
index 9aedb6cf66df..34d21b7d701e 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -212,6 +212,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
@@ -739,8 +741,8 @@ static void cfids_laundromat_worker(struct work_struct *work)
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

