Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C07714884D;
	Fri,  4 Oct 2024 10:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728037874; cv=none; b=o1JDBELUPb7MdqT1HAxyjSiHvN2ZPN+F0woD2vAcDKVs5DVMDsLOSefhN1bWHRdt2ZXQF5RCZedq/N1FeyzGacWO+jyJTOsQUEuSuAdvm1N+JbLKWU2fe6FoLNCUFDde7SSG9BdhXi1ewmwvmEwe1U2x3L7l6aKYZRUYVB4Y78s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728037874; c=relaxed/simple;
	bh=divJE67Ubr8PC2NRoBfkagwgqttequOKzDKDErTfwcA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u6NHSNYsJM7118CvpzwpjCt/2gtrJIF34uQl0gBIzNAq9dsKDGoUZ2XR4RKccbt2R3I3IKbTEm/GW8TbmboEfjWNTHUA6YNRO7X6G3HH5zzUIV2aM8jop5QsQ/gUpzTjP6In0Wmx+hG0aOi8BAMVQceRLsSHbbpg/ajBE+zE6YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hh2qXfBo; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hh2qXfBo"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71dd2b6cbe6so1632945b3a.1;
        Fri, 04 Oct 2024 03:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728037873; x=1728642673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y9YF4Qs0IPa4oKPvVx7Hv7ooYcAeECqPtJ8bxat5WgY=;
        b=hh2qXfBoWzfrNz+QS/bjH0LWdcqpMreGJwaaTctL3qipsFr/DMcuYNOdJF/Xp8jJS5
         t8KKfTKJR1Wh3PkeO5bN9DhoZpUWSaNYjcDRXzEbaQaTlTXFbiJPgaiBpcLDIiAN0dPV
         bntkA2zg1ghti3J6TNzvhfvPHonNEKo9QOaXS4EdII/ks2C0+0lNLibuRj7V8YZQWF73
         lxZJLulj7Mb2bnJI28qOw4dmLpfhB04II3o5UdMRzJ3Kc5Lm4H+D/1E0WHu79R8vH5EB
         rofbW35ih9aQiQcy7yTR0yAX1NHY8niRaphiaTVCZhr3mE+aNj3rgdv6/Aef5A/+GaQi
         flbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728037873; x=1728642673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y9YF4Qs0IPa4oKPvVx7Hv7ooYcAeECqPtJ8bxat5WgY=;
        b=G/ykPY4xorSBClKdumqfhELSgzFZI+kE98jpCZxagI8svi1yGxarBZux0QPkRTajef
         wgII1B+GcToltVaIYagN0u5gY8YlWllaxfYNm1nHDGdLggN1eNUN9rP3A31qKGVmanzN
         dYlnBQD7Sn0G+OgRzpwstYrvWyQuP+s7cIpD1vGg99J9n//h21dg7b/Ew1tzaw88a54z
         ugmF/oxD8EYRQMwLUMLGi0PHqaqbKhzxXuUnPc0AgPfsdAFeUKD6umVT92Zybkb0Kfiy
         V7ANxQKH0Bup5LMy6z8TrsdrArGasSFCL0aG7ELX2aYihuuacSXTily7lvjLHnPtQVIm
         bjdA==
X-Forwarded-Encrypted: i=1; AJvYcCXKxfRIf54vxH0bCAOt3Ji3rZ4cYhBS10NjkiKwLylIoCAfcB+/ZU/A2+DbJvCzyA6QRxrAowZHstpV8Xw=@vger.kernel.org
X-Gm-Message-State: AOJu0YykavbyPlz/6glQgl/eel/yt70ayEjApl6qVVLw5wYOIrTjWXOr
	Y2LTHzh/QRKT2dhkgF7/7vbjP7b9E+UWnBbo9xKfuXI8f4ZTcqrqP/NBw0Zk
X-Google-Smtp-Source: AGHT+IEV84KXrWKzPAXE9oR9QWAIhciy20oY421EqGnBkA/QJsb2O47VOOySsWCh5mbkrE4POsAQ+g==
X-Received: by 2002:a05:6a20:c68e:b0:1d3:b30:44a2 with SMTP id adf61e73a8af0-1d6dfa25a50mr4320240637.7.1728037872752;
        Fri, 04 Oct 2024 03:31:12 -0700 (PDT)
Received: from advait-kdeneon.. ([2405:201:1e:f1d5:9681:ce03:a7e1:2f99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71dd9df0b50sm2972570b3a.171.2024.10.04.03.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 03:31:12 -0700 (PDT)
From: Advait Dhamorikar <advaitdhamorikar@gmail.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	anupnewsmail@gmail.com,
	Advait Dhamorikar <advaitdhamorikar@gmail.com>
Subject: [PATCH] Fix logically dead code
Date: Fri,  4 Oct 2024 16:00:51 +0530
Message-Id: <20241004103051.43862-1-advaitdhamorikar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The if condition in collect_sample: can never be satisfied
because of a logical contradiction.

Fixes: 94ae8c3fee94 ("smb: client: compress: LZ77 code improvements cleanup")
Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
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
2.34.1

