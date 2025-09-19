Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7561531B127
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295829; cv=none; b=THNjGv/AXapf71ZM7q5rpwQIM5BjOtFb3xgLKjuynxcavp/xP5ygZTQtmZNWQ+maGjIbwJuTHzrsBkhs/5a6Ux1cx7SL9QPJpW6rX5V3FIk/Yetx9omHjsJw4thJaNWCeRBBKLI7gkEEFf1QjG7f2Qsnzq9fNQm3Wx/IJoSUpt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295829; c=relaxed/simple;
	bh=0FbXAceI9Ar8NhVs7qIPXnm8xBTAkMhdYoRJx+5Omf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdxbBsGYGeTbUEeoHTWh87lQc3aHVrEwkU5srErqPdJZ6YOTAfrjxsYMbw1Sz8z3SrOybKupQra0aeoToGwYtrb+ifO1Icb+w557eIEfopxnyYzwVO6NCsIQwLdef+glysYCbqIX++y6eg0DNkHSy54ms7N3/E6lFH9H/MVK+BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KXooVn6Z; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KXooVn6Z"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3ecde0be34eso1761478f8f.1
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 08:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758295826; x=1758900626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVpNRh3q3zhloDjyzhHf9HotrINSQMr+IJkE8EJWUeo=;
        b=KXooVn6ZbP+f22grQQjoCzAzb43OEVlDki2yjSGa74X5MYTdSkqIcYlwr08+NKRufb
         eBVEo7osv8I/xSg6KIX5MInS0ITbMnoVvFU+RXfUTf4gZ5mB1l4jjFvO7fCUqJwcBepN
         VHvIRXGgBcTwTjA3tn7iJvxDwG5MpUyahg3uW7fRqbiPTQ9aQidVogwdMQVHl2qwiCF4
         NKmMBZuWKJ6YRrhaisV2G7yElieUbYmjTGt2rmS8GB6FLwgWT7Cm4OYHDjdgJpS1CXZ1
         WlDnCnCf0hmvPHIQT3Xzo+VnFKSqm6db8VQVd7dX1LlGvU9mJolQ5povXXuQwlUeP/Iy
         t9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758295826; x=1758900626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eVpNRh3q3zhloDjyzhHf9HotrINSQMr+IJkE8EJWUeo=;
        b=T4joPHYPJ1OJI2CG/2ozxj5QS1DqSm1B+PqJMKNY+Pn7qFt/33yADNCUFBgY6YDntX
         IqmQqlkPU8s02oVdO4+KLPtAn9sqNNNipEdzVJC0AhEotGapPF0RpV8cqt8e3T3veagR
         Y9lyB0Nl/og6WN2oufH/3C277Krx+wLa43zJay6pbma+cvD8oYcXja9eCVqFHEvjLA79
         iFeJ2Hny+WtPTTs9cAP1wKiaEPWcq6Sg5y+BLilNkAqLvtS7Kf0GRJinK4i45olqjw7H
         M/D7lSh+aq0++nyoWedK9pB2Om1RDmHEPd6SgF8Lldf5+ZorE1MkbeczE2oOZbpY72hX
         9L4Q==
X-Forwarded-Encrypted: i=1; AJvYcCX8L/AfcjOgZ1q4Yb0kJVlJUTgn0Hv2eaq3PpbcQ0J8WHAeaslUeg6pLQEdi8RDtEi4uRyh/n5NP3qi@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7VjzKDoJHAndxqUndf66QoY6Lq/71wTwG40yzMYtJJHf9957x
	68wVIjYiuNRiyiahb+f6LPyLcIyfa3OkKSJsr+rHy/NjoKWEr/TNqJoqGMOsEmrH6yngmvqkmZL
	07GIz
X-Gm-Gg: ASbGncvAVkCkvnnPa8Qjzek1r9GMayzUEARUXrIZqyAbgQed7xWLR8t6YHpWzuz88wG
	/Lt8QJaekEJQ4UQJR+7Rwzf8IIhIzAhWTGsi2kHwk60zZpgTpBNBTGYz0/6A/IwKfZFA2Gj0yh+
	d1Td+xprcy6zNjKxlkNfa925fmsFpiExNIRS6Ah2f9r/pDjXAUJjQdFu2UpVNKT07hf+m20CorZ
	4zcVIeTJaq3hnoPJliO/zjQRNZZG6VBCTgwzBiTG5J4eDilzftEBiQ7es8j9AbeRIiHJkfO6vpu
	CGJz+VhJuhP1SWVcCZMp74VHLzJbr0hwVaGTBGCiMz4r4e9kIDF9nyNeENCnLt4cnSkB5q3cnG+
	Xj7Wb1e7Aofbl
X-Google-Smtp-Source: AGHT+IEVYoFd7sALpdPEDI1s093o2uwDJhxgTyMMjpuJeYHLAdbxVxpZpooum89a2S6Ole3WJxvCpg==
X-Received: by 2002:a5d:5d12:0:b0:3f1:aff4:1c77 with SMTP id ffacd0b85a97d-3f1aff41ec9mr1269192f8f.16.1758295825659;
        Fri, 19 Sep 2025 08:30:25 -0700 (PDT)
Received: from precision ([2804:14c:658f:8614::1cfe])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ecc735627sm5129683a91.1.2025.09.19.08.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 08:30:24 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 2/6] smb: client: short-circuit in open_cached_dir_by_dentry() if !dentry
Date: Fri, 19 Sep 2025 12:24:36 -0300
Message-ID: <20250919152441.228774-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919152441.228774-1-henrique.carvalho@suse.com>
References: <20250919152441.228774-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dentry is NULL, the current code acquires the spinlock and traverses
the entire list, but the condition (dentry && cfid->dentry == dentry)
ensures no match will ever be found.

Return -ENOENT early in this case, avoiding unnecessary lock acquisition
and list traversal.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 63dc9add4f13..df6cabd0966d 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -416,9 +416,12 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 	if (cfids == NULL)
 		return -EOPNOTSUPP;
 
+	if (!dentry)
+		return -ENOENT;
+
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (dentry && cfid->dentry == dentry) {
+		if (cfid->dentry == dentry) {
 			if (!is_valid_cached_dir(cfid))
 				break;
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
-- 
2.50.1

