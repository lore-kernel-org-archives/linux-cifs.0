Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3553A2BDC3F
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 12:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246431; cv=none; b=ukat24bn9ln39LNrZ1WNOVFV8z9535qSsSJ2MDghljJEEppAuegcfAtx2vurqhjq6BjFuoqRyYpyZqgRxwXM0Gx8vn+3rGFzYX1u16VslYQWk3qZ9KP5TaR3c0dvfCDEGAK/bExU0UgviVyyR+lH89w+8vqhqC5Aq/dgwmTd4sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246431; c=relaxed/simple;
	bh=GhVq6uSn5RaWMTsZxzMiWgV+Auc8xzOn19mSRt51ar8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Wu7XV5bXbdzTUFr1c4UfCBvNMzwP1LtBqEk2cgSZ4CQiByEVksYuwKQQ4ZlQrr8z+L+IXwvR6OmhGJwl8ydzRNpr+aOGdpBFD612DyWDDryZkS8Yl7j4f9Rr690PPLIWUPrmyr7pQYGABWCYn6I/3LRAyp82RPDKE34NAKIxnQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i5lqCoEM; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5lqCoEM"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-297ea936b39so2378455ad.1
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 04:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764246429; x=1764851229; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VBrweXDCkzKL99FGdZJb4s2u6Q85xoJBbuuJYA1XKX4=;
        b=i5lqCoEMCzW3IG+qnCEmjLE/5G6c2n6ruk30OLkXuyz8GS3Zi2tFpJjp7d1yYl4KF5
         kU2RQhWiJa/KziyHxF+Ly05NNnTrIVHODZqz1zx/e/EyMUX8qaFjIhU7VM3MT8s++CLM
         +97WYQ5XAhkKA/bXSWHzSd1PUkvnguU5etbc+IvYb4hrvITb8KXqwr2jsAfnEBUjW6y3
         H35en4xtJdTyBmxuORS0EwLcxfGsf9bwV/263R+fjaxwXLbdRWAuPJyf4NKkPYmgEDyp
         9fNCx6uRrvFCpVb7b9CONVRludXz8SkJv9xme8fg2xXOcgCMayw7XBz1e8eHMOoEdkzj
         w1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246429; x=1764851229;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBrweXDCkzKL99FGdZJb4s2u6Q85xoJBbuuJYA1XKX4=;
        b=w4or1CejO+fDd/3uTlLlgywlE5kZUthirmVeeUG5+q7gKMY7Dh5kUVnrc7N3VAeye2
         TV/FweMEaP4HOCnCfQoCbPCLOgGmv2EfJ7/JUkRV6f6L+jjcwvwFIzVVMjibN+Yy8+ts
         /rM56X8GoqQZswPasMMNxKeXr7Eb0xew9V4f2SMr84hJDTc4FmA+IJS2rZFA5Z/RMhzQ
         CHbKvnwIn8N2s3mwLtkO511PFrXCLbSd/k29ThkLyz2R3RT3PKKedusDwlqNm/tsTaDN
         lB4FMSvqThI6G2V0b7dNU1Xlzyt9De+/IxpVAp0zwO0hIsECxtS8GzJVdcYmhD/mkir2
         mzJg==
X-Forwarded-Encrypted: i=1; AJvYcCVh7SPkvxGM+XogK+plusZVAhO7ZGcjbTsXnIrTFtqrwiHQ0S1kCBm/Ok7i7M7HXr3U5gWSnsEekSkm@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2aqecNtaco7h3CZ8auXx1YtqK6sI8AZ84dd3WryMnXKDRe64o
	/0mHVFIcovAidr4m4XYRkvlzP0uT3npsYukjn8d2RrhpWSxxIjIxqci5
X-Gm-Gg: ASbGnct0XyGh4hLZr5AjUV6tEgsVyFrhZeGva8kNnv+IgTrZ9VB7X+MLXGW+n/rwvfq
	FG9yKfb15KaCkoAvaQ3q7YB1wFYyhpyEXmx1zTgjZzkCj1GvTStcyUCc3XtB0TPv/soV2b6UmJV
	J4BYp8PVkYS45IVT4qrr2+7znkBaixpErbgoriSEh3yE4L/RwvzUSBQbx5mNeGGhcQKOfiUDTYR
	YjKXIsfbfqwlhkD5+iFAZ4RAcYCe8USAzchhL5l9BMGngX8dWgJ/BcBJcGil41NBFXgwwFrShZM
	NXBmJse9sAHVTNNisIscnGqsNU/BYYWArO95VkvsqZbdJaHfQKGM9ENeIrdKimAueyELs1OfYFY
	+8hL6rQf3bBvw7QBueImFEvMD95gZZdvF0wmr+Xl36p5GqN9OSsj868od/y7Q6hfbJpG/IHpVQs
	WJyTUnTIJ95jOD3NibSwjVXS2ebGwy
X-Google-Smtp-Source: AGHT+IFFSz0gxCcLoQEe2IoqmHI/7A23cwj5j2pf9jMsj2EshBK94+Uduzwctn4OkLsfVFb6T6pNlQ==
X-Received: by 2002:a17:903:388d:b0:299:db45:c5a9 with SMTP id d9443c01a7336-29b702764c5mr131269475ad.9.1764246429393;
        Thu, 27 Nov 2025 04:27:09 -0800 (PST)
Received: from morax ([2401:4900:be78:dfa0:1977:daf6:20e6:4457])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29bcec452a9sm16942955ad.12.2025.11.27.04.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 04:27:08 -0800 (PST)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bharathsm@microsoft.com,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH] ksmbd: Add check in cifs_mkdir() for SMB2/3
Date: Thu, 27 Nov 2025 17:56:37 +0530
Message-ID: <20251127122637.2094566-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a version check in cifs_mkdir(). The check skips a function call to
cifs_mkdir_qinfo() for SMB 2/3.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
 fs/smb/client/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cac355364e43..f6f223a5a97b 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2314,9 +2314,9 @@ struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
 		goto mkdir_out;
 	}
 
-	/* TODO: skip this for smb2/smb3 */
-	rc = cifs_mkdir_qinfo(inode, direntry, mode, full_path, cifs_sb, tcon,
-			      xid);
+	if (server->vals->protocol_id == SMB10_PROT_ID)
+		rc = cifs_mkdir_qinfo(inode, direntry, mode, full_path, cifs_sb,
+				tcon, xid);
 mkdir_out:
 	/*
 	 * Force revalidate to get parent dir info when needed since cached
-- 
2.52.0

