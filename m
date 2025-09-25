Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE382FF157
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 12:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758802910; cv=none; b=OqVldgGOjB52d6DqwlVFI22AU2cy+RmSo8uG0cVJicLax9Jntf6Bz8hsmCm4/ZWY2pymzyD1hi+FmkyjrUOVZrcydxSlTwh6psdxVzmr/4f1rAmX4qHqPmRCqRo47wmftSmv/z4nwKDa19qC0IVyHRCh6UVqW1LVo4jehdV51NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758802910; c=relaxed/simple;
	bh=2I4rRX+vHLnpVUpHZ52/ykhAF7hUwEqE6pqhZQ+q65Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lLWBRqRWcltMQCP1v+PEkjt1N3O21dEgMNqVx0zUK8C9eN34hxm8o3TG4BtduTbjtCb35vzmxH6OtgLNovEqG73QF/PPbM6q7rR9fhmqJDJmD9Afqvh6HW1OpJJBrfJfZmfF1q6i6xJOYham0bFxnUIFZwZOfPe7ytSjQ/ah9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-781060b3ab6so329721b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 05:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758802907; x=1759407707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlcgilQcU/iztVKDPeoaAjeDA8k6PGgltKQ1SKbC3bM=;
        b=g+hUZEdhd9bFBvEjzOSdANp9T7ZaiKb0VhFL9BVQ+n6OYJ/sGHQqxy1KA222TY/iyV
         I3b3e5hC6yGFbNUXsB6JyhJWbx8fagtu897Kq4i57YdgXR/tmDg9v6AhRDMgZMXIeFrd
         2RWadK+08G9j7DPlhHeiftsu78AgLnevgBDiyqvg7AJDmnR+vcKaKMCgW8EZRTEm7V7H
         MBkLkj3RJnvhXOzyH37eNpnMb2tk3fGTJKRUGMht/P9vRMCupnaivgT2lbMWlG8KXRI+
         5h59CvhHJqUmm5uZlozNTiuF4S4MiQsLz9WPDKMFDxZ3mDcunFo4VHg9Thbqw3z2a3za
         6u8w==
X-Gm-Message-State: AOJu0Yy0+iF/AqTARtjPCLiS1IjAZcJwxkP/P8F6fEQW3+DGjjL3gnFl
	7hxH8VwZeDsy2mN9VqohPSLebcSn6GrrAEVQKxZ2RNr/022zR7LN2ojco5wU/g==
X-Gm-Gg: ASbGncs0gzmC+1sQWL+ZE4SVi9Z63FX5zwm6xuZWkP1tOGonfHLNfCsL8p5InkQfI11
	8ZgsddCXJH1EF4NxJ9FxwZ8aFAxwJ1p0VYIe30kwLc7FgwmRRxUuCaePxEeVcD0lev+Fu09cpX1
	qFKf1fTmNeiEX+M4+tGqousUz+jEt7/PAIo0ZW1O9Wnaa+kk9sdYqBPG8Lrw4gt4vQYc3vupA+b
	uzy7W84m47XRzBR/U6/8Sd0+ozS4PCU35Y/pwVt4LV1N+kvPv/D8y/uSJsNOvQnlko719BtIjed
	O9DqPlIuImDehQF0pfJXEGaZM+8sQ3aB9P1MHZzQ3wiWNiDKstwg0TMJvW5tB4lqSbaF3GTclJs
	M6S55bhX0R44WVncDvEElOCVFJP7keZTEpqkW4DaAKo40KMtp
X-Google-Smtp-Source: AGHT+IEdj9M8aWL98wtj09mcKOiHdca+GNCEK/3DIEi6RdSYWEDx/q/i3UqLLuGWG04MsbRk3y4hjg==
X-Received: by 2002:a05:6a00:3243:b0:77f:5cbb:16a3 with SMTP id d2e1a72fcca58-78100f21ab2mr1615813b3a.5.1758802907235;
        Thu, 25 Sep 2025 05:21:47 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238d309sm1843628b3a.7.2025.09.25.05.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 05:21:46 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: copy overlapped range within the same file
Date: Thu, 25 Sep 2025 21:21:18 +0900
Message-Id: <20250925122118.11082-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250925122118.11082-1-linkinjeon@kernel.org>
References: <20250925122118.11082-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs.ko request to copy overlapped range within the same file.
ksmbd is using vfs_copy_file_range for this, vfs_copy_file_range() does not
allow overlapped copying within the same file.
This patch use do_splice_direct() if offset and length are overlapped.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 04539037108c..2040a7d85e14 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -20,6 +20,7 @@
 #include <linux/sched/xacct.h>
 #include <linux/crc32c.h>
 #include <linux/namei.h>
+#include <linux/splice.h>
 
 #include "glob.h"
 #include "oplock.h"
@@ -1830,8 +1831,19 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 		if (src_off + len > src_file_size)
 			return -E2BIG;
 
-		ret = vfs_copy_file_range(src_fp->filp, src_off,
-					  dst_fp->filp, dst_off, len, 0);
+		/*
+		 * vfs_copy_file_range does not allow overlapped copying
+		 * within the same file.
+		 */
+		if (file_inode(src_fp->filp) == file_inode(dst_fp->filp) &&
+				dst_off + len > src_off &&
+				dst_off < src_off + len)
+			ret = do_splice_direct(src_fp->filp, &src_off,
+					dst_fp->filp, &dst_off,
+					min_t(size_t, len, MAX_RW_COUNT), 0);
+		else
+			ret = vfs_copy_file_range(src_fp->filp, src_off,
+					dst_fp->filp, dst_off, len, 0);
 		if (ret == -EOPNOTSUPP || ret == -EXDEV)
 			ret = vfs_copy_file_range(src_fp->filp, src_off,
 						  dst_fp->filp, dst_off, len,
-- 
2.25.1

