Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF18618A6A8;
	Mon,  6 Jan 2025 03:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736134807; cv=none; b=ueC8FqNClAwRTK5eBAYQVK9d2bEvoMFYzkv/msfn4Bs4v7/lwM3zpbnUWxfBCZEfrbPAQ+gZDFz8iOYfpBGhCPjachWbkYvrLhKZxfuyCNG9yfSPcFX/VSBUd/xN97zNRjQi5ZhuDf6E5PCoAipBzamFkStEDxwtgeJVKkwHkGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736134807; c=relaxed/simple;
	bh=831+LLrgqAoeCXD8udCajMbuCf+4W3nRQKEtuvTCw3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8FEX4viMVE+ZB968cmGcUrjo2cNmP1cHJu+3TodjvYlvoYTAGuoBXcYHtob5LGE5wDZ+0UWMOLR0OzD7b1NOYLrv85XlGz4zChKu+5yKIZIIOQ8znITCg044gJEfx6Xj7zVtDdqpDvmtFGnNf6imd9EidCdxsPMOC2lAh5QtCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H0HqvrXb; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H0HqvrXb"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso15651558a91.3;
        Sun, 05 Jan 2025 19:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736134805; x=1736739605; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MBawy8Fgo01NGKL+RGKl0s0P/slCwgV4k1+be4GVL4w=;
        b=H0HqvrXbJNOJXeHIvIdvLjxSCT4zDQSMnTs8k4FKJW5KWLfWIx0p10voi2g1NJvFAQ
         wUEDeXBxzBHza3reZKBB/l4g0UI6No5eVNp1PD5r1RfgdnGLQwKalKZhhIDGaOcQFSmr
         Ej9OpBrlo2slJHYOIF3wjA+giaze51xY9mp/5U6+ROlOogpIwJI6u4WqDpjnWIuI83Dm
         TAY+RuIGJiPS44Snwyryx3JSXe78NDRooN2iQHPVXQtNZbqyZow67cX9I76qr0c7uEdR
         uRYrUBPs4LOHIRH4AwtMGiwAqNzJSFoRVqOxvSyAFVmjcbaBi/YM6b1aEbzsebR0T5IR
         VTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736134805; x=1736739605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MBawy8Fgo01NGKL+RGKl0s0P/slCwgV4k1+be4GVL4w=;
        b=mqC/oW6dPFfM3MC54O3XxAvuRz3f2g79QXM0hHH0qsAaEc5GV+fW9eddNwLNeQwYDi
         4zP/grH+Wg0c7/4nMTYAAYUWLR4N5K+izGXmZXxYXq7NWTKzZMpseEP09EeOE00e+Kr7
         MMYlEuQkv86ixb4goR+W2ArrFpeyWVS2+d05Dcftc897S69t7aunKvxCuSKKVs8jBPtc
         VD4GnweTz81UYMAG3SkuETs3Bh3iq8prshNCySwyn1OiHJ1K6K66hSmQaC0/C8ZeUAp/
         zK8XRD3fxhk98dtoWRuV/Qz5ESKEc7+FzFxjMIaRXh8lui3iCC6bPFVRq/vGtXgEw40B
         CmbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3zIzyejQwp8q+gP6qoq1Uph3pslLOo10vB9fS8mJQBGyZDRSIdG0GEKzTgdTFhCIff3LkyC4FW0+gUMvc@vger.kernel.org, AJvYcCW8U6R+txjaHWAvPKABX1zSsnziL/mjZFU+IcvQA9BjMcNw1WMkFuSkHf0OQygTI82sBY/vhQLFPVQF@vger.kernel.org
X-Gm-Message-State: AOJu0YwLjpd7mirsRFVW5R4ECNzIYorrivZQDewYZkfH5JtKdxMaNEbZ
	f29XguLdIe3BZI9eorYWU+bj5K3390gXrPBQs1VcDhBEVV0hgNL5
X-Gm-Gg: ASbGnct4ObG8Y6MFN6+evVM0VMB9wQ/U1tQZC8QevBGoWdOf155cYRvn4TOPvqE9Gab
	jo+no8PQIVrI+kgsiqyPrqEkaLVfz7saLtV96o0qkJway64r0xcQw2oYEn+h/nlBf/+D5jvz/wE
	o5v3T5io+H5XfTpn7EENCEzyPDlHof+QFSKPRVy7ZzqScokzmaGA2hwUeKhCziik9j81doW7c98
	SefhPTsPvu/YBsh+z1f6J8BcXHm5MfmkViAgrd8Wk2cbnPmaTi9hVZK
X-Google-Smtp-Source: AGHT+IF0xx4ke/INErYy6rKF2W8XUnNFU9yJEO3n45dtc4SeTHYH4S+aYFcy7sgXbP1n7i91LV3VxQ==
X-Received: by 2002:a05:6a00:39a6:b0:729:1b8f:9645 with SMTP id d2e1a72fcca58-72abdebf1a1mr86721585b3a.24.1736134805002;
        Sun, 05 Jan 2025 19:40:05 -0800 (PST)
Received: from XHEGW.lan ([111.196.227.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad830adasm30232955b3a.44.2025.01.05.19.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 19:40:04 -0800 (PST)
From: He Wang <xw897002528@gmail.com>
To: 
Cc: He Wang <xw897002528@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked
Date: Mon,  6 Jan 2025 03:39:54 +0000
Message-ID: <20250106033956.27445-2-xw897002528@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106033956.27445-1-xw897002528@gmail.com>
References: <20250106033956.27445-1-xw897002528@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When `ksmbd_vfs_kern_path_locked` met an error and it is not the last
entry, it will exit without restoring changed path buffer. But later this
buffer may be used as the filename for creation.

Signed-off-by: He Wang <xw897002528@gmail.com>
---
 fs/smb/server/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 88d167a5f..40f08eac5 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1264,6 +1264,8 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 					      filepath,
 					      flags,
 					      path);
+			if (!is_last)
+				next[0] = '/';
 			if (err)
 				goto out2;
 			else if (is_last)
@@ -1271,7 +1273,6 @@ int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
 			path_put(parent_path);
 			*parent_path = *path;
 
-			next[0] = '/';
 			remain_len -= filename_len + 1;
 		}
 
-- 
2.46.2

