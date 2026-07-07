Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0856F3DA7DD
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418484; cv=none; b=iuM8+ubl3yRyN/WE5jvHzmhONkgdaPfaLE54AkdV1XS3DEbwyXtLltK2NejnGxB9Il3M81q5yESJwMlEpDaketfDpOOUpZqQKevhL78M4kdeGNmjMafDFfq+PwO2T49Jzi0POPjShdH3o0oUUzXzi1ZEICjXVvVkw6DZTZl2QNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418484; c=relaxed/simple;
	bh=zHZGcT4PsJtFQGuRDtfqs7NnDJGtX2nCD7LoDbDln8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXELMbGnBDiPDCKNv8kUv54R7ebUryMxfy59jxpbRthR5KWKOQhxZ0M6mloGfAz/QkdxDwsfphbv+quQYBMm8AfaW3B9vbrvqpsZaYeNB+Wh6OT6YGdDcINbP4xe4hM+WBe52k7xN6XTHguORwM1wUmtkw2hnleOvGN1kyvH0Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOGKFwQg; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOGKFwQg"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-493b7612475so37260605e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418481; x=1784023281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqyD7s8v59rZqpS2HHNgjzbP8UKr69GLNeJxoO1akUA=;
        b=dOGKFwQgUDPSW0q/YDrE1zO+l//v8NB6PGIdmOM3fnqvUMe8uXo6EcOMm+nyptCL3k
         YagwTGHUyJpO7VXiaYbmkiv+ZY7/GT0w5UKZNpgN+xF2FnO331VkzCzfrZgfQ9eyvukH
         D6GPrvJgmXphedf8f/knu15DDDQr7fW4yzV2nfeDIsucgLaRP9bPB7Qr53J6VhJtrl6E
         6G2fiZyXVKPJRERith4aaq3QJoc4PCAJiRfD1Aj4MFO3WI5ViToILtPV3S00AWJdBRyj
         p1Po4Gm7/48gNvqWTMjQU0ee3Qo2NzDG4FCYOvHc693h8MFmbA5Wef6O+p1I6rKWMblI
         5xEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418481; x=1784023281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NqyD7s8v59rZqpS2HHNgjzbP8UKr69GLNeJxoO1akUA=;
        b=Gk5giOBOJy9IBjRfeFMM+AjT8Z3ER9vHMA/zvRMhric2+Ex0XLAL9rdqFLBsn18fmE
         Ivh4t1dCQ4AZoZN3yYnt7ML1T0iF+0V6PjGMkqwo+qzLrnWnUI868yyG2oK/us3IutZa
         +aIdrwl3AdNqk89HuRp//JhVqvbMUKhi56AcYrHKQO+SmYjzgeG1PsI2+aBVnfbhIdht
         LvCIC8dtBz9DVjR90uGVEoWeJJIQtq4Lk4nDYf8Xf0d1s2H0bIqLHb9ojxt1xIR391CZ
         fx8DNXni9PW9cm2h/JvlCTiyZJNpMtuO4wkM3RAp8Tnf3sttUgNp0YDfkfLoSCUV4+ou
         SFQw==
X-Forwarded-Encrypted: i=1; AHgh+RqpIqqTUCLGu0aWXeNCJVyGGlCXZmjMWZVZPjR2ciOKRDHCeiXSRpjXhBu/zS3o2Jbtrlajsn6itTCG@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9ObCaKA+w9MiKLPCzwgVw25e/4csd1LErW/jSuofC/yw6Lhch
	rls/e7Rr2sdLnjmyMOdkn84RxFdbicDJ+qMIHOXct8abdKQ4GTDNv0F9
X-Gm-Gg: AfdE7cmIGKieEqDT8pUJGBNKnktjS4la1hPOkBb1xgzti0lQjBlBwPlcd02M28u53zG
	+siBQKsLf4jw71sLf53JbqtQc/jU66/KrJ2gDSNmTsnJ0+kQnVTkreG/i+h6TvoFcP5KfPgpUSX
	TZv3CT1bZljhdFARnhlMLCsFMJYJt1TkO19Y95Rbe0IifsXs1arN77OjPpP/bjyg8iPFwcBiiOd
	rebxmr0NsHL/6I1m4hCGVLVKvf2XlEAshVE+X1K2kW9F4GI48c+QjPRWs9AzIRCqy2w8GjyLJr0
	0udEV2nNx/sL8n2TfTJNKEH+TRs36y+1z1OdzAMlZR7SVo2jRPO7Nt6J6d8ItL1tHCRcTRM9GJz
	ne5oNxE91dhE1OBjbLbwcpqwf4NYdUPuCVXlLDFsTjznwzK9o+bzntgPXrl+7Mml+KNlEcxIAir
	HwaP8Fka57ys3mPSnZrg1I1Rs+s44sRVEpxFI=
X-Received: by 2002:a05:600c:55d5:b0:493:bb0e:2832 with SMTP id 5b1f17b1804b1-493df0a0266mr34298845e9.37.1783418481213;
        Tue, 07 Jul 2026 03:01:21 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:20 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 7/7] ksmbd: fix COPYCHUNK for ADS streams
Date: Tue,  7 Jul 2026 11:55:07 +0200
Message-ID: <20260707100033.47512-8-g.blivet@me.com>
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

ksmbd_vfs_copy_file_ranges() unconditionally returned -EBADF whenever
either the source or destination of a server-side COPYCHUNK was a
stream handle. This breaks copying files that carry alternate data
streams (e.g. duplicating a file with a resource fork, or an
AFP_AfpInfo stream) via COPYCHUNK, since vfs_copy_file_range() doesn't
work on xattr-backed streams to begin with -- the copy needs to read
the source xattr's value and write it to the destination directly.
Implement that path instead of failing outright, and echo back
TotalBytesWritten as the sum of the chunk lengths the client sent
(macOS reuses the main file's chunk list for stream copies, so the
requested total reflects the file size rather than the stream size,
and returning the stream's actual size would look like a mismatch to
the client).

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/vfs.c | 46 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index c491574d5..be93a8ec9 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -1821,8 +1821,50 @@ int ksmbd_vfs_copy_file_ranges(struct ksmbd_work *work,
 		return -EACCES;
 	}
 
-	if (ksmbd_stream_fd(src_fp) || ksmbd_stream_fd(dst_fp))
-		return -EBADF;
+	if (ksmbd_stream_fd(src_fp) || ksmbd_stream_fd(dst_fp)) {
+		/*
+		 * ADS stream copychunk: copy xattr from src to dst directly.
+		 * vfs_copy_file_range doesn't work on xattr-backed streams.
+		 */
+		char *buf = NULL;
+		ssize_t buf_len;
+		int sret;
+
+		if (!ksmbd_stream_fd(src_fp) || !ksmbd_stream_fd(dst_fp))
+			return -EINVAL;
+
+		buf_len = ksmbd_vfs_getxattr(file_mnt_idmap(src_fp->filp),
+					     file_dentry(src_fp->filp),
+					     src_fp->stream.name, &buf);
+		if (buf_len < 0)
+			return buf_len;
+
+		if (buf_len > 0) {
+			/*
+			 * vfs_setxattr(NULL, 0) removes the xattr on Linux, so
+			 * skip it for empty streams: the Open already created
+			 * the empty xattr via smb2_set_stream_name_xattr.
+			 */
+			sret = ksmbd_vfs_setxattr(file_mnt_idmap(dst_fp->filp),
+						  &dst_fp->filp->f_path,
+						  dst_fp->stream.name,
+						  buf, buf_len, 0, false);
+			kfree(buf);
+			if (sret < 0)
+				return sret;
+		}
+
+		/*
+		 * macOS reuses the main file's chunk list for stream copies,
+		 * so req_total equals the file size, not the stream size.
+		 * Echo back TotalBytesWritten = sum(chunks) so macOS doesn't
+		 * treat the size mismatch as an error.
+		 */
+		*chunk_count_written = chunk_count;
+		for (i = 0; i < chunk_count; i++)
+			*total_size_written += le32_to_cpu(chunks[i].Length);
+		return 0;
+	}
 
 	smb_break_all_levII_oplock(work, dst_fp, 1);
 
-- 
2.43.0

