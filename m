Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C30319F130
	for <linux-cifs@vger.kernel.org>; Mon, 30 Jun 2025 18:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751309455; cv=none; b=L6aY0x9ryAhj7O4MsATkWfjLfTq7fncEvqe9pCcX40aN5a2ln3hzhovvJAptc80YMuz8Ag6nCn0vFmhpz3VVJtjndEtLr2+tjCJBMiPvLRp+q+e0NgbH9LiXkOb3jOwh652w+iyqxVlt5wh6EMy1Xk5Bt+94KqtU3TgdwwPZbHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751309455; c=relaxed/simple;
	bh=JVg+LGkQJLiGd0vkD1vYmONMUqm/OpaKsOYYUa2N9Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OfvEuqRs759gAsz/zZfa7txc81m08uTPmREuPyo54qHaodhxPFL/JqfHQdDSvaLbWpliHnfx/3qyF/QrTflV8/oLcWjMIPGrYysbmXzobMgyFaA2b0+sQkhHxS5ecv3jQtFfKAiO5U1xbPPpD1INlLGv+KDdTf5gQciYJi4tRwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDhcyctk; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDhcyctk"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-74af4af04fdso3499811b3a.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jun 2025 11:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751309453; x=1751914253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=flGgDAQfpc5Dlq2D8RMKPGCUgASqDg2cf6ecShzqFRc=;
        b=JDhcyctkGNKjNHFl6cFHgZqptXTDYV70UH8wfK6gFZh98KPq9kAVHJcEGElfcobwps
         ttiSQ48VZTbJ2jFye72DELrNRvF37kIiY7s2VnSYPl8RjkBI664s6VigNz7+sob4sLuA
         jW4SnOkunfBLldfw7EPdytbOuFcnun0b6jYZ+Rf2TQh1dzS1k5uBqqvzcHNesZdyHl4y
         8cwOX8YEEi/GVFvC4FsCzJqMUQVkBz3TqtUTaFBWxiHEUs8+CZsqAIubDbVsgGxgF+sR
         FzbPzyPuOwzmMzWvf5pQMLyzzZpQwPDo7G4b58cvipHu6hkz/yXfV+T5kdm09bsvOpAz
         vZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751309453; x=1751914253;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=flGgDAQfpc5Dlq2D8RMKPGCUgASqDg2cf6ecShzqFRc=;
        b=nyRMs+o2WSM0LBg3gWAki8U32tBX1JSvkyuNxwFGnCl237Do1Wm013ux69rfBJqlrE
         gWimsLbiPExsUzjJeE0h0Ad4sVlJinYZhQniZYEzhoC7rxQ6yjiD8ErNahwK0LvGYuJI
         ivFOCTJMtWY4btPIh4wjddQ3SzLOX+pybPlPSfie2QowYRZO/lWBbwn9r8gyQgcaDCYN
         bSemPu7R8FAbS+tg3qrxLvqWPf1ueqCm0xJy9JVwfUtEuDAdCraW1yY5nc9jShrWKTes
         jTvAXpDEtp3+0v9P69E7fPm+zwtue6L5he+M4ssE4uXwZm0cICQDUwxjZGa0Uf6zL3Q1
         62TA==
X-Gm-Message-State: AOJu0Yzy9r48iKxaPGqp+9EaqpbUiz2ch/tOOmWeZ9ZLbCD+1maD0wca
	LXR/aUgFc3E5qnckCxNXugFqiCOJrAcWIi3iYRAfQ0Yd6cymClvLkVv4+4wEj2sp
X-Gm-Gg: ASbGncvvX83bdg5TAyZpB7zG2yqWY+0+mzKhPktutRYdNF2IHypu22g7t7YDs8+WCpB
	6FdcMjt0Zcl8pvTKOMj4Ax/lz/tce2O+xk+GpFE1MknfF0KeVRXPjksTIyg5hBvB1ckNleubfpy
	8HbrZa5ubwgEch4tpWDBK+xlqpxpS2Quz9RoIYTwEGrlXFxLay1Bzmyctf1VdsHAARrIU50nfk7
	h5zBZt0Nn9HQhlpgcKUJPrx60a1G4TMWF9rQGr4QUbOEw/ND9uXOL50Xv0hVnKd0hK2hJFy0yFy
	eNVB4f/JyTUNemhJ7BH5wDAlbpKnUGIXwgLHzwnl87CLwgq66dLFUSR7S9ZvymwSLRtDIJNOXYf
	CfGeZRw7bICwd
X-Google-Smtp-Source: AGHT+IES5mP2WbaDDQ3xjSyf7bWxEPH+Ti0q18uMv9Hb8qX5waeH3f/G5j92nn0EZMhaeTGvcRNHsw==
X-Received: by 2002:a05:6a20:3ca3:b0:220:9512:9213 with SMTP id adf61e73a8af0-222c9a1b938mr834041637.15.1751309453486;
        Mon, 30 Jun 2025 11:50:53 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.2.189])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-74af541cc81sm9626090b3a.58.2025.06.30.11.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:50:53 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 1/2] smb: change return type of cached_dir_lease_break() to bool
Date: Tue,  1 Jul 2025 00:19:32 +0530
Message-ID: <20250630184932.12067-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cached_dir_lease_break() has return type as int but only
returning true or false. change return type of this function
to bool for clarity.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cached_dir.c | 2 +-
 fs/smb/client/cached_dir.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 373e6b688fe3..211a6f35541b 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -613,7 +613,7 @@ static void cached_dir_put_work(struct work_struct *work)
 	queue_work(serverclose_wq, &cfid->close_work);
 }
 
-int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
+bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 {
 	struct cached_fids *cfids = tcon->cfids;
 	struct cached_fid *cfid;
diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
index bc8a812ff95f..650d727bcea8 100644
--- a/fs/smb/client/cached_dir.h
+++ b/fs/smb/client/cached_dir.h
@@ -80,6 +80,6 @@ extern void drop_cached_dir_by_name(const unsigned int xid,
 				    struct cifs_sb_info *cifs_sb);
 extern void close_all_cached_dirs(struct cifs_sb_info *cifs_sb);
 extern void invalidate_all_cached_dirs(struct cifs_tcon *tcon);
-extern int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
+extern bool cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16]);
 
 #endif			/* _CACHED_DIR_H */
-- 
2.43.0

