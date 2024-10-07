Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F871D8E1D;
	Mon,  7 Oct 2024 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728315498; cv=none; b=LQwKfIHQXGUtJLlvLJ7hsSbhDZwhrUF5TUm8frF+Tj/Qt5ZLpX6tuo3O46qf+dY2ihoCfrWstfW6hciYzy2gdkWD7sKGmaPhzD1IVWHKZRO+k6UzbZYNG3mpMAiQymmxxMv09tAkHEMz6+JMcOV9eXS5MaPO+6Thw+WibAH25XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728315498; c=relaxed/simple;
	bh=/NfcI8nWjzkLuCgH0CbeT/uXDcCgjG0KSPH2q98N29Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=uythLdQ9JOj5F6jPajE7WrASpLsCOUoiRnoF1DTjkwlSdIGea3ywMjjzD28ZjZbeIYD7xH27fkGR/92eqYq0ibCi2HQMHPw8roxiYZ9467NUy8r2nc77UymMlROsuUxPYVAqZhypaN8JfUKnoHlVj1dtZ6+rMECnXhsKnws31q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AQhnJhmo; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AQhnJhmo"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2faccccbca7so38405091fa.2;
        Mon, 07 Oct 2024 08:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728315495; x=1728920295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ygq16Q5Bxyqojdl5nXMAWjtB5mU7RJB2IzsdM/iUgnM=;
        b=AQhnJhmo5AB4nvtrX4m3FqQXDpDWyIr86cJZRM9grjVhYHcNnVqMJmVpLhPyNFrt6G
         iS2++/1R0WnND5iBit4pAhl1orkUr8jE/UfqvQUZvEyqK8kFskjf/EOMgf8YOJiDEvPS
         2Cem55U5ymaOuJoIdIy17Dxmz+tSIAms4nJrnscBmWXdQGME+Wim4OttYLhDUWgf14GI
         cPUOWcwTsCMB/1S8Dj4sZqAkJC0HqrkqCvQYW9bDiywLpXFW2rd5r9v2k6ZKyPh95afg
         OjxQMJB3FPCjM5hZiToolXdG7QdDywSVXx7hjEWwwVXMHZBPL5rMsUYEgMOP8M4IMQhI
         LRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728315495; x=1728920295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ygq16Q5Bxyqojdl5nXMAWjtB5mU7RJB2IzsdM/iUgnM=;
        b=puoHntXdFI95J57/TG4GytHny5EUcNAiLWtRzyN4V+nhyeNnTpRLZcIDUck1MWx//9
         oQwsNJhaXrbmRoBTf6XjzbpMP51TEb39lRPAudxb0yAMBzCvMbSn0XG1EYrUzFWoDYb8
         S3FmMGkmc/qz4MTBmlX4TjjxFYdTfpsfnWpBAnXC5dthh94cYwvrLrFzSGw2QSebTUQQ
         8p7hkRZ0Ik1GBfIwnwBI+g+bDAGOL+B+t0A7Ru5Y6/dnrmgfB5H1/87IMVutSNnKN3L9
         XXyQEdOzSJExlGkdhf0Q4FuPAQF4V0sPQbjnBlRZl1jmGPg9QtkRa6gtzA9Sw/XqhjCF
         YIHA==
X-Forwarded-Encrypted: i=1; AJvYcCV+ytLPVfNRQmA8hbsB481RcXA4xCbZ731pCWTOfooUKeeoDJI0NJhnl3vS8fbKAwSCTu5N37hm3jDX@vger.kernel.org, AJvYcCWScs6Hk6bdhGAaIP8bWv0LYkRA49s6CS/+p75Bv3ZPqZjtmB+U1i4MOMkIw4x9Y48rnz47N4HTDyJsB3qG@vger.kernel.org
X-Gm-Message-State: AOJu0YylGFB7i3FP7WRSjFR8wj5otM76ZpAHGneQXFwWIJpvsNZNVHMh
	DY/7Cs408fdGIkzHPm11UpGtVHFvIBaEVMv/ak5HhZNwnCbUoqUgt9yTBP+W
X-Google-Smtp-Source: AGHT+IGpOsbD/YdAeMFiZrjbHGFYrB8KG6icb2u841+DQSmpmriv8TPQqU3mw6w9e+2FtZyPQKPxvw==
X-Received: by 2002:a05:651c:19a2:b0:2fa:f5f1:2542 with SMTP id 38308e7fff4ca-2faf5f12921mr45040131fa.12.1728315495071;
        Mon, 07 Oct 2024 08:38:15 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05f3bf0sm3285990a12.88.2024.10.07.08.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 08:38:13 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] smb: client: remove deadcode check on ret < 0
Date: Mon,  7 Oct 2024 16:38:12 +0100
Message-Id: <20241007153812.1204605-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

The variable ret is assigned zero and never changed in function
collect_samle, hence the check for ret < 0 is always false. Fix
this by removing ret and the check on ret since these are redundant.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 fs/smb/client/compress.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
index 63b5a55b7a57..766b4de13da7 100644
--- a/fs/smb/client/compress.c
+++ b/fs/smb/client/compress.c
@@ -166,7 +166,6 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
 	loff_t start = iter->xarray_start + iter->iov_offset;
 	pgoff_t last, index = start / PAGE_SIZE;
 	size_t len, off, foff;
-	ssize_t ret = 0;
 	void *p;
 	int s = 0;
 
@@ -193,9 +192,6 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
 				memcpy(&sample[s], p, len2);
 				kunmap_local(p);
 
-				if (ret < 0)
-					return ret;
-
 				s += len2;
 
 				if (len2 < SZ_2K || s >= max - SZ_2K)
-- 
2.39.5

