Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEB917993
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763218130; cv=none; b=eR1LPpf4+TuzJ1vqKbm+XTdizxI3mzeci6BhfgvETVpGpTndz6I7RR8mSO/RX3CieiVaB38vM5+JzLLRKssvWQ9d48qktpHxm1vam6tLwkeZ5emaTJpbfM9JAIomN2D4R46xhwe6IVN4PPZlx8rzLpGyascUtNESnUb4WcygAMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763218130; c=relaxed/simple;
	bh=NZH79oJQrUr0+yLUGXyMSbz2UGtduLS0AKXdFUHNmfs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=caqFZRhFhr1bN6iFYA8I7FT2iNBJEqNEa8lm4vU8VsR/Bbj6DBgd4U7g0lSq/rqLvQAliVNR5Oi1IsZjPP+mgek7rr4SpQy1/OLBZ3yEakLAGEnOI5ZxwshStd0yfKfMZVfufZ53KyjX35u5vmmInQQntd/R2sKG0dPoZ817CRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcTQ6xjT; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcTQ6xjT"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-29800ac4ef3so6753355ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 06:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763218129; x=1763822929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eblm4oH8WMKHd2tfTsYGfp0Iegef7142gb8GNo8dgAM=;
        b=BcTQ6xjTMx83ipuCQjbXHesHqtNHc2mzHQcCsbJdroB3ZUkrHKKPnWumQk+TA/LnFe
         lQM/cW7NOCutIm7bGSk/yUigzvA22swD+MqHRtwaAPJfYZRrSUwam5Ta1omFpx59BXsW
         IdvEQHh5wZ4ULKMhFQEnFsMGnM4QoZvs9clcH8bR5UXlJ23Bvv94fXkG+1JwKoMaJIAz
         sZBUdbnanDHXn6L8N2459cLxJUSmLrW/WSEkP05bNZSM+xzz+IC4anFvC59XeksFOgDH
         ePuL2kHVr/vD9NPkY5cem4jHTlRfFBVNDhbZ89KFwhuZtYUopRghK8uGA7FYjkN+Qbj0
         Nmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763218129; x=1763822929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Eblm4oH8WMKHd2tfTsYGfp0Iegef7142gb8GNo8dgAM=;
        b=NP27rRFc+OAyoAklNmnz7vkRu5ggl1ly/8oDKPQXxqyDldmIUbet9Nzrr23EO+xSKn
         xFiWGWPNIFRijA7IX2ZnvnSRaO1WoJ54q8tFAqdtnitViGNoJEPTkIzO/eycJhYHVyRJ
         0BnmztgiNa0ioLLcasnZ5DDzIYSSQqRe6jFEb2E2e1VyExvPQFiB2UzjxbXf5GDw5f45
         gPBqr1xZafn4O8WHAluE+EF2khA1IbbC0BMT76kHYt+rWeZDD+KEQVHi5VnVNfRRYSCV
         olqCbWver1UIIyEA9FZovFBIbPZ6LqZ5EbcyWTln4vj2JcnXe+d2Mz4Qcs3eu4vLbPn2
         rNzg==
X-Forwarded-Encrypted: i=1; AJvYcCXXUO7UigwIG+sZdWiPnkkNE0zEztW6yf2CE/6bk0CZqaK3r29qiKS70dv/jkGyda2judtr2hTP8M9Z@vger.kernel.org
X-Gm-Message-State: AOJu0YwUGLHcB9mQpNH3mBpn5IzG47aPtLiDey/MBC8xgpa+/dKcShJM
	CWJbivJvbSM0C7MMPqKabKXBpBdAMM4yW1Qg9TPX5fChtaCO4z8dMiY5
X-Gm-Gg: ASbGncvKXhe71R6L4s3li+sXbNjEv/HB9Pw7FhRfeavPfAjFNkJX5/tNVY8POyWGK4W
	TEQV/Swj9ZdBqq67z5BEydP2eXjs6MO8jI2oNXvA1M8XsarAD/95rhR967wYUMpRgDjNtw+gc8j
	/TFFDAuURIO1yI3iOksGj/afmfZGjFaRB3YaGxZQ4jzhqKChpy7/gsHVnbAfeu+V0Snba6WSscF
	WxgFe1VF9YeIz3+wz+x30FdeshObt5LGKHu13/EeCaDkGWx8fHEdq+cAVQFt6OCyrtY7z/0QwB7
	vdqTU37R/Aw+TMQyOjOeVGfbJbS4rJnwfI/v5pa+NCuV18o5KqkkCj8Jmmt5tcRjh5oY7hSk0Tf
	rBk+F7pJ3pa3G9cnvmGGRfnPlXud4PCkcYooxVbFLU+DOqxMUFOGFzf0RlTzjRCjoJX3PaB8Y7V
	65ABwXnbMI4hCcPVvBH9hFMmINa5r5R96Y6sO3y2eN83+CifwHpiTeQmAXQxxLnu2rMkcjcIvD6
	arpNug457k=
X-Google-Smtp-Source: AGHT+IEFPRicWDHAlwZaQ/FpL1TsXLtWQwGVzqmxdM7jo4UhyoPLcjUWPuif+VXkEX1VRD7+udJK9Q==
X-Received: by 2002:a17:902:d483:b0:295:54cd:d2e2 with SMTP id d9443c01a7336-2986a5edceemr42293645ad.0.1763218128806;
        Sat, 15 Nov 2025 06:48:48 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c25a688sm88392485ad.49.2025.11.15.06.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 06:48:48 -0800 (PST)
From: Qianchang Zhao <pioooooooooip@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: gregkh@linuxfoundation.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhitong Liu <liuzhitong1993@gmail.com>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] ksmbd: vfs_cache: avoid integer overflow in inode_hash()
Date: Sat, 15 Nov 2025 23:48:36 +0900
Message-Id: <20251115144836.555128-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAKYAXd-_S184kK0NUyuCgOTvCvq382c3Fxt=ytes-ekydwGLuQ@mail.gmail.com>
References: <CAKYAXd-_S184kK0NUyuCgOTvCvq382c3Fxt=ytes-ekydwGLuQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inode_hash() currently mixes a hash value with the super_block pointer
using an unbounded multiplication:

    tmp = (hashval * (unsigned long)sb) ^
          (GOLDEN_RATIO_PRIME + hashval) / L1_CACHE_BYTES;

On 64-bit kernels this multiplication can overflow and wrap in unsigned
long arithmetic. While this is not a memory-safety issue, it is an
unbounded integer operation and weakens the mixing properties of the
hash.

Replace the pointer*hash multiply with hash_long() over a mixed value
(hashval ^ (unsigned long)sb) and keep the existing shift/mask. This
removes the overflow source and reuses the standard hash helper already
used in other kernel code.

This is an integer wraparound / robustness issue (CWE-190/CWE-407),
not a memory-safety bug.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/vfs_cache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce8..a62ea5aae 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -10,6 +10,7 @@
 #include <linux/vmalloc.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/hash.h>
 
 #include "glob.h"
 #include "vfs_cache.h"
@@ -65,12 +66,8 @@ static void fd_limit_close(void)
 
 static unsigned long inode_hash(struct super_block *sb, unsigned long hashval)
 {
-	unsigned long tmp;
-
-	tmp = (hashval * (unsigned long)sb) ^ (GOLDEN_RATIO_PRIME + hashval) /
-		L1_CACHE_BYTES;
-	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> inode_hash_shift);
-	return tmp & inode_hash_mask;
+	unsigned long mixed = hashval ^ (unsigned long)sb;
+	return hash_long(mixed, inode_hash_shift) & inode_hash_mask;
 }
 
 static struct ksmbd_inode *__ksmbd_inode_lookup(struct dentry *de)
-- 
2.34.1

