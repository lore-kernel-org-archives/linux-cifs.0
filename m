Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167E0C141
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 03:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763003107; cv=none; b=chTihTMDCUZTA9vhN+s6dhn6+m7lmALCEWGX9EIMhT+20EiyyuaXxnOfeliPgvkOlJ1AQrp9JHXaicCU6/7wqiDVm9gB8la9Wxbq3JJv5EagO8LpxUEUa22FIe5ogEVZ1C964pa3DUJ8W7FF1qkxoAbZD7+c/JFxyrcC0hAGlEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763003107; c=relaxed/simple;
	bh=O9zV8bAoUVd2ZzjVizrq0aVJWNKCtlsakqD1EEwfl7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0V0Euhi00kxkjixNSxmUQuG7ftMpJJ/XLDTlMAALksVNfn802eTNsSNiJihpIH1FMtODkx4CvFzxYiCBsH9aUhhi/HmC/Ap08IUW3NhBvbXwtClUeOe5Z9CcGsx9/jRu0GhFwdwTdlKxydjPKYbovBSF6hWl1pnAW42XmM/G3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REJHIpeQ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REJHIpeQ"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2960771ec71so444985ad.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 19:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763003105; x=1763607905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79ZFMgyqh7NLEU0bjPwPQ0uTiSQzLvP0WrsYbbAHZdM=;
        b=REJHIpeQMqCyfBtuqBxxYToslfUaJjbaFtZz5LA1BkKaq31+IeB3Jvot6lc7oTh8dp
         N5v4UFmTRDFJx7ISkKvslA/ySRIhVewBJ8qPZk76bAgxgkQj5ATGEgEzwWVb3S3TWISb
         evA8YWqeqgy5RO+c8aw3FK8GLXvj/xcxXQtIqpiUgKY+C2ZYDVSh8sVWfFIjPLi9UYo2
         rAJKukHDY0JQVbtyBbmACUbHzS1KtmwLOQc6TZOEDZ77IOCUeQjSq0EVwKxXBmrRK5vJ
         Bk1xdp9iGrjBqvP0BG6iPTRAy2LeOO5NHyELTzxS3M4OAVBWlF+PoljBx+D6BjJENoPx
         +1iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763003105; x=1763607905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=79ZFMgyqh7NLEU0bjPwPQ0uTiSQzLvP0WrsYbbAHZdM=;
        b=oXxhSeScyVUhdupmA+J7vTXw124vQJqYz7N/IBGckGH5uWiRPtvhNP91VUQEZEn9WR
         WFEQpCUkhc2bpd6d0NYVU/ApfOFqcDdQMYYX/nEJJeUCv4kQRnCU0JoW35F+gTUKMeRX
         0zH+qqCfLS+8DtNOPUMYBW9PbGLtJDGy/34qqbGMulNRqNskEBa9AzTRg5F3dZKbFNv+
         6udVAwfEi4UXu4Jts9DkKbYI5iPe94RVBrZEERv5iyDgiJ2BgSyBELNaPsYFqBh2ktTT
         +eOHFO7gfkB7zdxJXWqKTH1ubuP55AwnMzBDLbtrbpAHrgcKNOtRY3Q/05LzYgLY6sas
         vYuw==
X-Forwarded-Encrypted: i=1; AJvYcCWgMI/SFDX99l2fgzGkbtbTKOzV2tqYqYKleYJSdwnQByfJcqKdco6VL5OB3KG6rLraPl9n4kFlEgBF@vger.kernel.org
X-Gm-Message-State: AOJu0YyZCK5B9PB/W2CHuLP6N9xNq3V4EDlauaHToUCOJXLW3AH12GtM
	VuC6jK6b+aTnl/+AXcRqcX89LhvKlg6jsROvN14RxQZDPm4QkCDkjViuyclfnM1IxOU=
X-Gm-Gg: ASbGnctrf+eKs4AMa5wD/xKl3IuI1s2hfnZbQb/YWuk13DNXkUNGsXErMlGcxmhOZOh
	cHV/4PlzeNkqEmcWIDuIMBB2qpHIeGZWfbrBgTryAyG/7Ff/k4Rhl/R3dL8of4HTkaueuap2stb
	a5hram8bdCDU5700Q3bwMV4M/ofr0QrAP7YQFKUClTl2406f2Yz23Ol66LEK9cLaY5q4Bsr1vFD
	Iwp2s3oDgUnmWkYCJWwrgUSbs8nFZ1uOvOB67mAKzteFjak5TCQbaiQ74L+ohTsBkIav7ZF3Y+B
	3m+83n36Nl4l9dXYgjclfVGoJnvSy2rV3CemJHK6P0jMGmSnYCTxda+J3vvIbGSiiNZH4rQM0VY
	Oqgg95nIzhDU5RTL7luv3+YoHr510x1yKdu9Bu+KsZbvJiQljYFSq2D77NTNcYFBXezYXZSL5QN
	tkZZv2E5ZgtOp0cbySp3KxkFW1eHeIsyY1w0w+ZuXPm1hdiXtgUi2Go4s2tLJMDA==
X-Google-Smtp-Source: AGHT+IEw90g2Hzt/8ufbJVQWlDjtChK6HX/U5OEBYjDIouhOWonfZhzrah1NQrxITRslczO8iIzXZQ==
X-Received: by 2002:a17:902:db04:b0:295:247c:fb7e with SMTP id d9443c01a7336-2984edfb282mr36630385ad.11.1763003105365;
        Wed, 12 Nov 2025 19:05:05 -0800 (PST)
Received: from poi.localdomain (KD118158218050.ppp-bb.dion.ne.jp. [118.158.218.50])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346dasm6739945ad.7.2025.11.12.19.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 19:05:04 -0800 (PST)
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
Subject: [PATCH] ksmbd: vfs_cache: avoid integer overflow in inode_hash()
Date: Thu, 13 Nov 2025 12:04:53 +0900
Message-Id: <20251113030453.526393-1-pioooooooooip@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2025111234-synthesis-wimp-7485@gregkh>
References: <2025111234-synthesis-wimp-7485@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

inode_hash() currently mixes a name-derived hash with the super_block
pointer using an unbounded multiplication:

    tmp = (hashval * (unsigned long)sb) ^
          (GOLDEN_RATIO_PRIME + hashval) / L1_CACHE_BYTES;

On 64-bit kernels this multiplication can overflow for many inputs.
With attacker-chosen filenames (authenticated client), overflowed
products collapse into a small set of buckets, saturating a few chains
and degrading lookups from O(1) to O(n). This produces second-scale
latency spikes and high CPU usage in ksmbd workers (algorithmic DoS).

Replace the pointer*hash multiply with hash_long() over a mixed value
(hashval ^ (unsigned long)sb) and keep the existing shift/mask. This
removes the overflow source and improves bucket distribution under
adversarial inputs without changing external behavior.

This is an algorithmic-complexity issue (CWE-190/CWE-407), not a
memory-safety bug.

Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
---
 fs/smb/server/vfs_cache.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index dfed6fce8..ac18edf56 100644
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
+	return hash_long(hashval ^ (unsigned long)sb, inode_hash_shift) &
+		inode_hash_mask;
 }
 
 static struct ksmbd_inode *__ksmbd_inode_lookup(struct dentry *de)
-- 
2.34.1

