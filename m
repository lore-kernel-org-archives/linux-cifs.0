Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26AB39859
	for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 10:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596015; cv=none; b=g+T6U5sd30CTA1Ue8bzNKlSsMjxYxGVnwdn7ovrDXgx/vMinf4g68evVrfl3uvpYL2rT9qd4TOmqmTBsVbi7LsqMYYgsDqPwmrthpsPYz77zXQKyXdpPgpuw3JuV+WG8kqoOlpWRfCEG7exHYfUSSeMSgfgH5Q2Q96sohB0qI8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596015; c=relaxed/simple;
	bh=ZsrKRM16oFvQ3T5f/mGExpUGQzK13ZeZm0gvRF9Ru1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FEfmjnZBVLSqDUVafEJF9KzzdgLCQXLoma3ZMH1yhq59vR5L4a8vd+9nFKvQ01Q7O7Y5wMLBujBEW+qA6vosJ2SXx52skzqIR9n8HkyAbAwCkQ8MmZObc89OWH0TgrkiG6avTXuzrH/A4VXCHf1xSHO5x7IWtqMdsoG5Nz+BZDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=RGWZ1s0z; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="RGWZ1s0z"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2d2305589a2so19064271fa.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Feb 2024 02:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1708596010; x=1709200810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ehA4aIv0XNKFBN1MEYMzna/Hvxh8jJ2rpDlUw0onI6o=;
        b=RGWZ1s0z374UTDNYTyTWDq5HOJopEHzfG5OgmZhe5svrHY0Ex9IJkmhF919or/5WFI
         kllKCtazsFUI7f9qWN1oP1r0jQmBEWRVAQoVnM2mPmne6UDHmLBCsvV+VMCVhchQdSHQ
         2kXIJk52FdV0ksRVJQp1F3xAhrEvLRNwPaROeaXSt3pBcm+m1IGkYYllWAnSs6MeCS9w
         8Ggu0XpW7D/WhZdvup5D8c0J9f0Q3Wp5PkYcHjFRJ+JiO9ZNbh/9LsRfHei7FzkAyw85
         qYu4ZHKld3rws7y5r+YocdXfNwKXdLWJ8YUPb6jdsSNDag4ZcHQFkKHCHu+0C/COMMdc
         sUzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708596010; x=1709200810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ehA4aIv0XNKFBN1MEYMzna/Hvxh8jJ2rpDlUw0onI6o=;
        b=YUeuS3pmhCsEOlW4Z7cL7V5x1rosPcZS2rfgWho7j8sKkTJmJMEF7pHG0J9mxTs1N3
         KQbld1mjRL+xocm32v4xq1f0Fd8jNzfduuZBx8eMa+0E+XXNUf2qovYbKp7XMedcmql0
         c5t6dP2eh41HgYBGhunBNlh/jwYtalCYFAT2b5VzGtNptagDEZcbIarzt+qD1J6rIPaR
         vT67n10V/AUZlEEJa5dkhXGvVHDitgeD1Pa8CanO7o4braYVqHI/jBpu8SkgLgXw1tuE
         uyMDF6aKBrRIHqLvPBVhUmqTouRSTMeF7eykjgHFJORDHXWj9FUEGsqJEiQJOBE+VhaT
         Oa8Q==
X-Gm-Message-State: AOJu0Yxl1MZBdGI3jWDedIRoaD6JqIVeOn+Vsxkoogv4l7boQNCVo0Jd
	TIt5m3MPLVtsrFE+sjrMDJu9u7KoVxB3qpcuWk8/lAzVD7epm/rbA8bCBf95b9nxm25g6b2Qh9x
	Q
X-Google-Smtp-Source: AGHT+IF1Q+wmjdffYutJ/m38gPYvRyfUDAhEdylAWC9aZGob1Swj83lL/2v9j+dVY6icLWkqBwgSjw==
X-Received: by 2002:a2e:a547:0:b0:2d2:427b:8abc with SMTP id e7-20020a2ea547000000b002d2427b8abcmr8014249ljn.34.1708596010012;
        Thu, 22 Feb 2024 02:00:10 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id az10-20020adfe18a000000b0033d90b314e7sm1505769wrb.101.2024.02.22.02.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 02:00:09 -0800 (PST)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH v2 2/2] ksmbd: retrieve number of blocks using vfs_getattr in set_file_allocation_info
Date: Thu, 22 Feb 2024 10:58:21 +0100
Message-Id: <20240222095819.2188726-2-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240222095819.2188726-1-mmakassikis@freebox.fr>
References: <20240222095819.2188726-1-mmakassikis@freebox.fr>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use vfs_getattr() to retrieve stat information, rather than make
assumptions about how a filesystem fills inode structs.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
changes in v2:
 - reword commit message to remove XFS reference.
 - fix build

 fs/smb/server/smb2pdu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f6cc5d2730ff..199c31c275e5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5809,15 +5809,21 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 
 	loff_t alloc_blks;
 	struct inode *inode;
+	struct kstat stat;
 	int rc;
 
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
+	rc = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
+			 AT_STATX_SYNC_AS_STAT);
+	if (rc)
+		return rc;
+
 	alloc_blks = (le64_to_cpu(file_alloc_info->AllocationSize) + 511) >> 9;
 	inode = file_inode(fp->filp);
 
-	if (alloc_blks > inode->i_blocks) {
+	if (alloc_blks > stat.blocks) {
 		smb_break_all_levII_oplock(work, fp, 1);
 		rc = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
 				   alloc_blks * 512);
@@ -5825,7 +5831,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < inode->i_blocks) {
+	} else if (alloc_blks < stat.blocks) {
 		loff_t size;
 
 		/*
-- 
2.34.1

