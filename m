Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931171D2B35;
	Mon,  7 Oct 2024 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728314628; cv=none; b=areFl4ohZHedBJQCcFseopCAfCj4imlFZWnCY8spJ4YCeZDiL/k8Y2id6lgVJG/EfJw6nx7yplYHoNlm++nRUa7ccuw8o1y+zA6RdVP/+evpXJcWy0cAxUOzvWSOycZYSYmWfT0C5wgfuX7a+R47DUHTkN9QXjkT3a+yY2QRZd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728314628; c=relaxed/simple;
	bh=TTFnVdLY+kjqE2jnagn7CS4/81gqLSWXjiYK9I9eonI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RV6dR4RLi2B8oaOux5CRKoCYC8gN4h2MHBg2XT4nld1WDjVU1hs1L65XsYTpaur+Qgw/eR9WMFwcihA7mHEXK7hiX0vMrPNO3wn4EtYHcT8oMod1HoTXdnCdZACyQxb2htrlBqYgP++8T4lHhyQUREwVVIF6f9BmOFEKQ2R4igw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IcHmUB4l; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IcHmUB4l"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20b5affde14so34226495ad.3;
        Mon, 07 Oct 2024 08:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728314625; x=1728919425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8rED7FaHD2bMlnhS7lunCOo9L+DmtUpPt70xJxObJAQ=;
        b=IcHmUB4lheD8zykM8C8eP4X6kH2H3oN3jlHctgw5cEr/uDIbTojh90Crpunr2LVLOl
         BQk+RJ9HJXvaKqs5s8NiBlEV/Ixhcy1FjwEqIqZOoBCMW0tAeU9i7CClYze8ITwc2BYN
         A1yQw//VrEN3tYAdjEWsEeASqfIcQYCEIOKO72qrCYDWu7eGk+W1fIJ0++7Yn1E27IA0
         +hpBNf8VS9EQXOTO3ZdTWStw3UMo8gEs9CHFZHYpTvyuvJdvYQ4MbM06BOUf+m8BBViD
         BRu8CIsds4Cbp8cDHDAopRRnSg18ZvTDc2JAaBG8mZeWqd9fLh+UwVFzl4gUE/aJCR0j
         1Hgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728314625; x=1728919425;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8rED7FaHD2bMlnhS7lunCOo9L+DmtUpPt70xJxObJAQ=;
        b=SZLtWYJPGu9lhi7P4fFvhsaJgDNC10vSAMdi3fd6nLTcNV0nqptXfHCOZvXCbFUmvN
         Ymn10Qr/lGpiLPjuJBP36pFl8dmuQ07mgBsQz8zslmJovRcs0aNMnzrevuM/lFj+h2is
         /kBzRS+cz5LHHzsxbtsVRQlhpxae2tySo/4zLJEy0sT93j+QsD5oIQFNTo+QjLiQ5JFP
         vLSTR22BG8tnTpuazPEwD44ado41/CrER0rotznmX1lngxTPM+siZnqghduuMC9/yQ4M
         OrtvZorbvfcxGHolL0Nae0bxBQi0ud1Ru4HGY7xi/JUagsFwegZyY23BkU/lWY35HK+F
         3h1g==
X-Forwarded-Encrypted: i=1; AJvYcCVf9zHNT9yzPhvApQ86sXlHBWGXsO3oqAEgJ9oYb2ofYaI7FgcMnEDFDA6bud0EEun8jDx2Ar+luKR0ZRY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwsp3B8mpYTcuqYOD3BFGgWiEwgfYMipoLHeCQLOBlvhnvQbcN
	2eJAaycEax8qy9liDtoKJ1Pr2oMnIadV30V4Y9R/RopXWdu1OaUh
X-Google-Smtp-Source: AGHT+IHxs1GqL+ZpFAtWRanCieNM9jVs+kXQCqs6Ly/+GlBb86c8Cgkmm0la8cbUbreuCecbOUwJyQ==
X-Received: by 2002:a17:903:187:b0:20b:54e8:8b35 with SMTP id d9443c01a7336-20bfe39ebf9mr186482635ad.33.1728314624658;
        Mon, 07 Oct 2024 08:23:44 -0700 (PDT)
Received: from advait-kdeneon.. ([2405:201:1e:f1d5:ffb9:ea:f539:1909])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c138cec92sm40953195ad.101.2024.10.07.08.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 08:23:44 -0700 (PDT)
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
	smfrench@gmail.com,
	Advait Dhamorikar <advaitdhamorikar@gmail.com>
Subject: [PATCH v2] smb/client: Fix logically dead code
Date: Mon,  7 Oct 2024 20:53:34 +0530
Message-Id: <20241007152334.11780-1-advaitdhamorikar@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The if condition in collect_sample: can never be satisfied
because of a logical contradiction. The indicated dead code
may have performed some action; that action will never occur.

Fixes: 94ae8c3fee94 ("smb: client: compress: LZ77 code improvements cleanup")
Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
---
v1->v2: update short log and changelog

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

