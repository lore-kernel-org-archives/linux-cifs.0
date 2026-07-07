Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9DA3D9DD3
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418481; cv=none; b=IOm0wsJln+gpNiLtzNz5dJSNbh+IOz4OwzVd2IWE2Kqwi+Vn/9JNBxc843fvjyoCq0O5+PSxripSN7EkDeRNndcm/9tR6fKaFlK0xs7FOvmtKgKMxZkjR7kJFWqcfIqhuXL1nzUICzAOwYFBd6Oba/9Ki5rVXf+Fs5SxSetIc2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418481; c=relaxed/simple;
	bh=gWxlI5a/m9Ugq8ETRqye2zV2aRcmRXwLWJhHRyaHm0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiYhz3vPV33/vMCXY7/GjoYFfvyXD3VmWe4LDMLWfBk3BYaUDOO2zyAM6FQFInuT1BN3ZwaxaUZ+7zE5PYAt016NMMj2T4W7TsE0zRdtP4c6b/r+exUIyU2+NMaIQHMqoY8MvkOIo4uGA/tPtBt0w9WyX7EZXpipin5/1QShrEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=US0hW8eL; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="US0hW8eL"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b7612475so37259855e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418478; x=1784023278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U/PwVP+zoEqj6drAwTOEqPXoYGYs3X1l0QWLHsWhgt8=;
        b=US0hW8eL0qJXcC+5UOexIq5DHtVi+mNVM65CSuyDeeW3WWAUtgPkYV1kGhExLtzRVD
         5MTPBGQJI7SL0LVqPQQXCX2z7+P3vKHNvB4m6agPKy3C5iYUhAJ1y8F1nY0lmalu5C5m
         PMKhDLuDuqWJPweLc13ZoDfs/pLvRXwopDG/Z05ZOGKFwzfPPNyTkGaqIx7u4ESax9la
         qp5WUF+mqFCnIhTDXtcbJCg1zNtuWudxqv+s925hNS6vrFfN8wmgvlRyQYSBbdu3wB9z
         DvVRW9i2IgZq9V+GbsOoEJA8GP2IpdZA8JsxpuZMJiAqLqe+Ol/BCr/CvGmqBcj7UWGS
         lZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418478; x=1784023278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U/PwVP+zoEqj6drAwTOEqPXoYGYs3X1l0QWLHsWhgt8=;
        b=o2EaiKDDXFwn3fhjqANHBcVRx4a+OI0jOejrhGalIhpUF2zu7Tf8OC0L2Fay27yqWD
         i0fNT/BB7tpAuyamNnl3y89P16fteEJFCBU3kgplKgdKUirpo+MOBqHiUBAjdtB/u+Zu
         TGESm4VzXWdMMxUsqjiQCKFH9Y0zhesKa9C/m6nh8nsTCflC9EHS94+WGOKkA6h0xiJY
         s1P084hDy6g07mAFywElL6gjq8LOVxuUju7sJSXOEUSq92O36vLBVFPmWYLfpw1VQ1Xv
         naropMKjqgR+GA2B3kDp4lv6WJE89o0nGQA+aBwTMcbgIl5AzfjOIgD3pVDVoZTscE14
         UGeg==
X-Forwarded-Encrypted: i=1; AHgh+Rq1wUKQae4g843gpzbWyVmDEeBciKOcRh9jROp/yQPsOvCgAo/p/vWrE8P9Ne1kpR9XAugE6Kmq2D2g@vger.kernel.org
X-Gm-Message-State: AOJu0YweLWT3b2gp0yfS4exRmOmKQUxs7KdxzbPS13MQsZ/hlgvpW1I9
	j0CFOYNZkX5Z5ZpZCeiEv4ZxlNU2oUO29/6YshifRh8KalQ0QSMqQ0JP
X-Gm-Gg: AfdE7cln1r9I7gXnMx5TojIzTi5/T8S4bfOnj+71IEVs5KbRjKCQEdVXXIddgiLzjkA
	2qc0stD5XkXEK5AYGRY9DYKDxCHHKaegnWN7ck8tEEKAnnJeNLLzRMSLQHCU7aCqIXTG1HI70Qx
	6A2lCrDXg/J6XaLKpFIszy43/S8YyylcPGe3SpY3fXerr3gfD0jCwQ8Ia+GFDy3MPCDAKuO/aCD
	Ux3HmrIFwdOmiLkwmRbFafcwucwt6T7tB5Q7Akmh+FIScPSqP+ODHzJHhrJFrJ6C1QWWMIK5VO/
	aiXuOHoE8XzcII0nYIpUsHxjkcZkmT5Ukcra0xwwjFyyVfEFKQrH0fkt3NYjaDtZvQtLbYL02el
	QSRLMx2bKSBwpMR4we4KfapnhNRUYIHLiiGUr9zhNSBxcYTmYwOOk/mShd7/ZaPQr4TRg/b0iJN
	Days+5HO2O3gHWVPqxXj3SsBjuWedhbYLSw4o=
X-Received: by 2002:a05:600c:6c07:b0:493:bc4a:9547 with SMTP id 5b1f17b1804b1-493df0a08dcmr34901455e9.39.1783418477669;
        Tue, 07 Jul 2026 03:01:17 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:17 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/7] ksmbd: report actual xattr value length for stream EndOfFile/AllocationSize
Date: Tue,  7 Jul 2026 11:55:03 +0200
Message-ID: <20260707100033.47512-4-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
References: <20260707100033.47512-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

fp->stream.size holds the byte length of the mangled xattr *name*
string (it's used as the attr_name_len argument when looking up the
xattr), not the size of the stream's actual data. CREATE and every
QUERY_INFO handler that reports EndOfFile/AllocationSize for a stream
handle used fp->stream.size directly, so clients received a bogus
size derived from the internal xattr key name length instead of the
stream's real content length.

Add ksmbd_stream_eof() to query the xattr's actual value length via
ksmbd_vfs_casexattr_len(), and use it at every site that reports a
stream handle's size: the CREATE response, get_file_standard_info(),
get_file_all_info(), get_file_network_open_info(), and
find_file_posix_info().

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 55 ++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e6d0f58d2..735c3eb72 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2828,6 +2828,22 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 	return 0;
 }
 
+/*
+ * fp->stream.size is the byte length of the mangled xattr *name*
+ * (used as attr_name_len when looking the xattr up), not the size of
+ * the xattr's value. Reporting it as EndOfFile/AllocationSize for a
+ * stream handle is wrong -- query the xattr's actual value length
+ * instead.
+ */
+static loff_t ksmbd_stream_eof(struct ksmbd_file *fp)
+{
+	ssize_t slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
+					       fp->filp->f_path.dentry,
+					       fp->stream.name,
+					       fp->stream.size);
+	return slen < 0 ? 0 : (loff_t)slen;
+}
+
 static int smb2_remove_smb_xattrs(const struct path *path)
 {
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
@@ -4112,10 +4128,17 @@ int smb2_open(struct ksmbd_work *work)
 	 * using the raw on-disk block count, which can include filesystem
 	 * preallocation and metadata rounding.
 	 */
-	if (!S_ISDIR(stat.mode) && stat.size > fp->allocation_size)
-		fp->allocation_size = round_up(stat.size, stat.blksize);
-	rsp->AllocationSize = cpu_to_le64(fp->allocation_size);
-	rsp->EndofFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	if (ksmbd_stream_fd(fp)) {
+		loff_t seof = ksmbd_stream_eof(fp);
+
+		rsp->AllocationSize = cpu_to_le64((u64)seof);
+		rsp->EndofFile = cpu_to_le64((u64)seof);
+	} else {
+		if (!S_ISDIR(stat.mode) && stat.size > fp->allocation_size)
+			fp->allocation_size = round_up(stat.size, stat.blksize);
+		rsp->AllocationSize = cpu_to_le64(fp->allocation_size);
+		rsp->EndofFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	}
 	rsp->FileAttributes = fp->f_ci->m_fattr;
 
 	rsp->Reserved2 = 0;
@@ -5456,8 +5479,10 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 		sinfo->AllocationSize = cpu_to_le64(fp->allocation_size);
 		sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
-		sinfo->AllocationSize = cpu_to_le64(fp->stream.size);
-		sinfo->EndOfFile = cpu_to_le64(fp->stream.size);
+		loff_t seof = ksmbd_stream_eof(fp);
+
+		sinfo->AllocationSize = cpu_to_le64((u64)seof);
+		sinfo->EndOfFile = cpu_to_le64((u64)seof);
 	}
 	sinfo->NumberOfLinks = cpu_to_le32(get_nlink(&stat) - delete_pending);
 	sinfo->DeletePending = delete_pending;
@@ -5535,8 +5560,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
-		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
-		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
+		loff_t seof = ksmbd_stream_eof(fp);
+
+		file_info->AllocationSize = cpu_to_le64((u64)seof);
+		file_info->EndOfFile = cpu_to_le64((u64)seof);
 	}
 	file_info->NumberOfLinks =
 			cpu_to_le32(get_nlink(&stat) - delete_pending);
@@ -5813,8 +5840,10 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
 	} else {
-		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
-		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
+		loff_t seof = ksmbd_stream_eof(fp);
+
+		file_info->AllocationSize = cpu_to_le64((u64)seof);
+		file_info->EndOfFile = cpu_to_le64((u64)seof);
 	}
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
@@ -5945,8 +5974,10 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		file_info->EndOfFile = cpu_to_le64(stat.size);
 		file_info->AllocationSize = cpu_to_le64(fp->allocation_size);
 	} else {
-		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
-		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
+		loff_t seof = ksmbd_stream_eof(fp);
+
+		file_info->EndOfFile = cpu_to_le64((u64)seof);
+		file_info->AllocationSize = cpu_to_le64((u64)seof);
 	}
 	file_info->HardLinks = cpu_to_le32(stat.nlink);
 	file_info->Mode = cpu_to_le32(stat.mode & 0777);
-- 
2.43.0

