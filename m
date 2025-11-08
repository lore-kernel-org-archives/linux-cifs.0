Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957052248B4
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762605381; cv=none; b=eggBQfetGK5XgDBj+t5Fb3L7OKdiW12tKWaJVyeqU/TcQsWW2cOy7jsvbYEiAEe0Jh0+TzGlmkYsXXgWcYOKr0S/ifKwCmoMUEh0ROlh7zgqKq3EXe5Ynh580hoIAc8RpFZTWrdGBDJfyO3Lhyq1JkVEfViNalTPDgCUVO1fILI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762605381; c=relaxed/simple;
	bh=uRVHkf74PN+NsgRpPhLx88tlLbm6OItPRVdDekAJNfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WbFLVXCwBaFG2B6AN/CmgrfEhaG6TskJW2uVq0b95uzfpD5wGD2Wvd5hhCZcWBolJbol+C18hStzsUP0EqEai07Ej9aw1qZ3RtIqePix5G3l9TPyW3vjrP1cIltwUw0sL7Z8vYD7WDTwJ6dGwOA2T6+QcZ2m1xUfCDs54F/NVdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SbZfQk2p; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbZfQk2p"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ba4ddb3f54aso106558a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 04:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762605378; x=1763210178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kb8819sRG4CMNnKbcxDJ79PlxuoIzXm9ZoWrsp3orTM=;
        b=SbZfQk2pS/PzjUrbA9LceOfFNNiwGZDO1+ZftxUBKKIigRfxtITCbQjrXobUAO78vj
         XPGhYREsChQoWpuSCejJa3n+PhWkXF1kpIDbn5mB25xct4cBcl9dAfeWxCC2eKpbL2Ue
         xyt3gGbaCLYA+6okZ8tQw+KQD+Anm9ts+Osvq5DmoSOTz/xiPr8tnsS9cpGcW4HAA8HM
         sPK4lBckeVNoB5Ghp/9vV8sZaa2N96HRxpapjCAnIWe4KiLWsp8q/6RlGtllrafXwyRf
         fApRQquKHVRb36aVyydfMxRxUzhVi5fEfyTtGDR+sqvIZe/mDHaQfypZzBY/V+P9Qxwa
         9Raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762605378; x=1763210178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kb8819sRG4CMNnKbcxDJ79PlxuoIzXm9ZoWrsp3orTM=;
        b=MuJybFT21j7f4Xe+hYi7adDotIIbEfgtzhF1A5NCNz8ufHtymhBQiVoiI1E421YZU2
         ddGtBF0kofvKDrq3cyw7TsufRROx3LfTAbYXtXU8N8mMGoaIK473a3bU48qXgfhwDT8Q
         3rjAvri/W3g5JZzkFqwuX1RrM4DdA7O3bwyHsGTU5t6KPVykX7fJy3B8y8CJYXGiOqb5
         tviv1TQQB6jCiLNlXXiBjFQ76sTggKqNRJ3zcZIBo2dEp1iYHuE5IPJfDTUHN+0wslEc
         9oJRjpZcWLg8iyhA0PUWEz6NzPfYwUe2BXbFg+Ew3iG+yRL+SX5aLeSWaIvq9fJrn1JG
         5uHg==
X-Forwarded-Encrypted: i=1; AJvYcCVHicpRyZFUyZNKaQbepmJIdzpbvhv1DLxsOuJfIeIZeO1R9mfhmV49zDMmfFa6Ie8BNyNWzT/Mjnw5@vger.kernel.org
X-Gm-Message-State: AOJu0YwyV/mmfPoNx6Ux8ltTXUQfL6037Dnq6eH738iyXZ4jfljF4sBJ
	tMIhqMRv5tYjogLhORfoXHaTMm8C/hSEfdxUFZrZDgZndcrh+eoNyVtB
X-Gm-Gg: ASbGncvhPFHNErs0++jU+LYxEWxfsW2nfjaELU5ncmUDKkNI9klq6H4MuYQeha95twF
	NAokSvEtEHHfuovjlp3afPiGdxKUYO2bd+nF+36LoypuvuK7xL+z5KfgCIXypYYED0Fo5i9Uco0
	wIjU2g0CZQz38DU96S1cgxopzL8zTVbdKQnCKvB6c/R5Cen+h/4Dm50one5i946SqLqvM5/lA2q
	8NwlqZbjp6MTkBsoEzE5cweYbXUh0mbqn5KVwbatVJ3D2oyNp6N3U98WTKBko8k5tO1zRNvVoTE
	uKpBGXlEF8UL7/oW2GpGDx0ZB61LF+WDeqeVyH+jPkxbrm1lVeTviApV6H+1i6Mp73a1kNVLjhJ
	VQRqjbs3uTPcg8UFIw7JhDpASUomdejWXgzee2r2irCuuElTgfwCSWYRVYhh68JGrL8UJg0IFa/
	eWimm9OXl2bLV6ohWEn/1cMP6DOXgyQU4CRzyuirUCSWtqjtNyP/JWMw/CJphc66MtFd0YTs489
	LJsUHGygCg=
X-Google-Smtp-Source: AGHT+IHbxRfdUT4HVX6GH+hFiYMSSiTWIZoTQpxma32JqxsfSwUnqkfo6IFizDS0NzlaG/f8uasiNg==
X-Received: by 2002:a17:902:e847:b0:296:549c:a1e with SMTP id d9443c01a7336-297e5649f22mr15677755ad.3.1762605378467;
        Sat, 08 Nov 2025 04:36:18 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba901959a47sm7648305a12.28.2025.11.08.04.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 04:36:18 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: gregkh@linuxfoundation.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: vfs: fix truncate lock-range check for shrink/grow and avoid size==0 underflow
Date: Sat,  8 Nov 2025 21:36:09 +0900
Message-Id: <20251108123609.382365-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2025110803-retrace-unnatural-127f@gregkh>
References: <2025110803-retrace-unnatural-127f@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_vfs_truncate() uses check_lock_range() with arguments that are
incorrect for shrink, and can underflow when size==0:

- For shrink, the code passed [inode->i_size, size-1], which is reversed.
- When size==0, "size-1" underflows to -1, so the range becomes
  [old_size, -1], effectively skipping the intended [0, old_size-1].

Fix by:
- Rejecting negative size with -EINVAL.
- For shrink (size < old): check [size, old-1].
- For grow   (size > old): check [old, size-1].
- Skip lock check when size == old.
- Keep the return value on conflict as -EAGAIN (no noisy pr_err()).

This avoids the size==0 underflow and uses the correct range order,
preserving byte-range lock semantics.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/vfs.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2..e7843ec9b 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -825,17 +825,27 @@ int ksmbd_vfs_truncate(struct ksmbd_work *work,
 	if (!work->tcon->posix_extensions) {
 		struct inode *inode = file_inode(filp);
 
-		if (size < inode->i_size) {
-			err = check_lock_range(filp, size,
-					       inode->i_size - 1, WRITE);
-		} else {
-			err = check_lock_range(filp, inode->i_size,
-					       size - 1, WRITE);
+		loff_t old = i_size_read(inode);
+		loff_t start = 0, end = -1;
+		bool need_check = false;
+
+		if (size < 0)
+			return -EINVAL;
+
+		if (size < old) {
+			start = size;
+			end   = old - 1;
+			need_check = true;
+		} else if (size > old) {
+			start = old;
+			end   = size - 1;
+			need_check = true;
 		}
 
-		if (err) {
-			pr_err("failed due to lock\n");
-			return -EAGAIN;
+		if (need_check) {
+			err = check_lock_range(filp, start, end, WRITE);
+			if (err)
+				return -EAGAIN;
 		}
 	}
-- 
2.34.1

