Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0182311973
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 05:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785561607; cv=none; b=ldn8hr8jX7DJYXkD+fXZQ7RgjSE1JdfKYzg88t1jj92mJQfwnaN0Yiz42pgMHg45LyPo2LZZU0GC/GkRx3mytP1m9JMFNBK33O7vz95EOAeNtN2Jg9Pcw/kNgxSq1Rp9a+VquSJkXRRoW7e7crZ7qL2MjCcZ7LKTXBWC4e+gg9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785561607; c=relaxed/simple;
	bh=1pbenURxMlARh3pC8PA8B2dJzQ5BPvjm0RXy0W6EMcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqDEdXBwKL0+tuUDa3fWhtEm/Q7lb8fs52XX3Syg7bp8tkoN7k+NYhWtpNGgg1QUbwYjKV39INLcvBfUyND19zT+tiRMh4SAGCAxFwMLdwtCPGXYCVEpWz5blj7V1wA38Y9imGaH7iDDqYK4x6LaTz2OMmm1EoONfKFKseHQxTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NrAo2Z7C; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrAo2Z7C"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c15d111ca99so180102766b.0
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 22:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785561604; x=1786166404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ex6WPfpv+ZwZoIyM0LuSSyJsRcBd0SLh5T2sQDRpitE=;
        b=NrAo2Z7CfRm9FJU1LfirFsxiNVYxr5b5eTIb+bh7Slrnv09KuPm0VwjDFxCmslwW4P
         B3hPbDM0289Hfm/TqY2kTm0CH3m2vNVdUPCtJoGmw/rG0EFQ58X4e2shlAc9oImkV1af
         4TYK4dl+VFLgA9Vrk3nvwfqJTaOg5ccuyBZQ8WZOhTRpHTJFF3dwVhtplffL1IZR1U7M
         rchs7KeSaNbh/xdAN/G9HNotdWuXZ4155b6CNgXECMnrflryMfHxJOAZajkDuuBM6/DS
         tlFVFoXv/cn7z1YLOQI2RIdkHA9iSrYTJkWsyIUPyvABxy47mDrlRVcDc+C5SFfjgo7p
         ZNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785561604; x=1786166404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ex6WPfpv+ZwZoIyM0LuSSyJsRcBd0SLh5T2sQDRpitE=;
        b=o6zTknxQXgC7wxP9R+Lbqdj726YRP+61VB8wnghkPEiYncHOehesdXpE7rjmbOT9yt
         NpwxB55Xl3N+wBNSTiy9RHncF197SC2Wc0T+FtDC9b9Pe7XafCOYJ8l6apTnZOjXLxsO
         ej9pkGS1R4PA7f5deKIMLYxEq+pYBnDmBJzLEs9DR3cX0gLNARyFfEcBHCDsMPIbwN+y
         MQURSmyoeNqKa9gStzl/8yTaoQ6jjz+vfBNpTabUQyNacYLXQtQSnm8MB/1XNu8aa00v
         Y0N7BN76BiEK2hcK7YqDX9vwPMpv9BIBcC8G2EY/RiztFRYo3x1fCuOThIiBQ4cIumQ3
         gc4w==
X-Gm-Message-State: AOJu0YzaKvf1uF4RaB8jq9m12Zo9tzw4dVpHpuF0yyGDEZSBZ+Rbs3pI
	dmHfZ6+1HrtBZJa0gqz7HbIQToMJTAMSIKS+5/zYWYCSi5K/KRUKK7IS
X-Gm-Gg: AR+sD11rNVGiONcDI11TBkZ+qymj8q0yo3vLBLTrw3w0+0lAp5nK8qQi+sgROsavirQ
	T6CoNfu6Eg+EjWplHkfx6QP/ZGyvAS80lY1Z/gmPTmcup3G57pM1i1JU9w3NULo7DKDJV/8Xat9
	9dt3+0av3j//HtpduiVFPNcAkhvfwzHbefPB0mrvhLlH/R9MnnvVkN+ZsoFI7H/uuhtv16d35B6
	T2yQKSaFL9SP7JbAYr5WJgAP2V4z7p2VZQGsx9dWFQiorq4Ckw3jdvu8sMzcXuNotTjhg7Rsk2G
	jkwqjmh6ZQ8X7ivxK/uq+Bn+gH9cREoGdmkJczGDv9ygEgMc3yddvSov2+btWBlF7/jj5a8hJ4L
	ok/FTwgS0nIkaWXLhC5XqThbHBXxsuoJ5F/jmpymuiHSI8BWBAC33GiH1sTPRevvzgbC1jqEOFD
	BSVMVEziJtjEWME6ZX83SJmq5WM8dL4UynFLGQ+OK7OIvfDzIuSvM4Tfw+8EIGgGnXRbgQMZpS3
	l4=
X-Received: by 2002:a17:907:e1ce:10b0:c12:9e83:643 with SMTP id a640c23a62f3a-c1fe80ba536mr86562966b.10.1785561603810;
        Fri, 31 Jul 2026 22:20:03 -0700 (PDT)
Received: from SHUANAT ([95.47.122.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c5b608sm287393766b.8.2026.07.31.22.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 22:20:02 -0700 (PDT)
From: Anatolii Shumak <anatoliy.shumak@gmail.com>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	Anatolii Shumak <anatoliy.shumak@gmail.com>
Subject: [PATCH 1/2] smb: compress: reject Pattern_V1 when not negotiated
Date: Sat,  1 Aug 2026 08:19:52 +0300
Message-ID: <20260801051953.74245-2-anatoliy.shumak@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.2
In-Reply-To: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
References: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pattern_V1 is an optional chained payload type selected during SMB 3.1.1
compression negotiate. conn->compress_pattern was only consulted when
building responses, so a peer that negotiated LZ77 with chained support
could still submit Pattern payloads on the receive path.

Pass allow_pattern through smb_compression_decompress() and reject
SMB3_COMPRESS_PATTERN in the chained decoder when it is false.

Link: https://github.com/namjaejeon/ksmbd/issues/529
Signed-off-by: Anatolii Shumak <anatoliy.shumak@gmail.com>
---
 fs/smb/common/compress/compress.c | 11 ++++++++---
 fs/smb/common/compress/compress.h |  3 ++-
 fs/smb/server/compress.c          |  1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index b07a317597a4..a4123c8f1c0a 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -95,6 +95,7 @@ static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
 }
 
 static int smb_decompress_chained(__le16 alg, bool allow_chained,
+				  bool allow_pattern,
 				  const struct smb2_compression_hdr *hdr,
 				  u32 slen, void *dst, u32 dlen)
 {
@@ -143,6 +144,8 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
 			rc = smb_decompress_none(&src, &remaining, &out,
 						 &out_remaining, len);
 		} else if (payload_alg == SMB3_COMPRESS_PATTERN) {
+			if (!allow_pattern)
+				return -EINVAL;
 			rc = smb_decompress_pattern(&src, &remaining, &out,
 						    &out_remaining, len);
 		} else if (payload_alg == alg && alg == SMB3_COMPRESS_LZ77) {
@@ -185,6 +188,7 @@ static int smb_decompress_unchained(__le16 alg,
  * smb_compression_decompress() - decode an SMB2 compression transform
  * @alg: negotiated general-purpose compression algorithm
  * @allow_chained: whether chained transforms were negotiated
+ * @allow_pattern: whether Pattern_V1 payloads were negotiated
  * @src: transform header followed by compressed payload data
  * @slen: total number of bytes available at @src
  * @dst: output buffer for the reconstructed SMB2 message
@@ -197,7 +201,8 @@ static int smb_decompress_unchained(__le16 alg,
  * Return: 0 on success, otherwise a negative errno.
  */
 int smb_compression_decompress(__le16 alg, bool allow_chained,
-			       const void *src, u32 slen, void *dst, u32 dlen)
+			       bool allow_pattern, const void *src, u32 slen,
+			       void *dst, u32 dlen)
 {
 	const struct smb2_compression_hdr *hdr = src;
 
@@ -207,8 +212,8 @@ int smb_compression_decompress(__le16 alg, bool allow_chained,
 		return -EINVAL;
 
 	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
-		return smb_decompress_chained(alg, allow_chained, hdr, slen,
-					      dst, dlen);
+		return smb_decompress_chained(alg, allow_chained, allow_pattern,
+					      hdr, slen, dst, dlen);
 
 	if (hdr->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE))
 		return -EINVAL;
diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
index 7ace3bf4b664..d6916669f887 100644
--- a/fs/smb/common/compress/compress.h
+++ b/fs/smb/common/compress/compress.h
@@ -20,7 +20,8 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
 }
 
 int smb_compression_decompress(__le16 alg, bool allow_chained,
-			       const void *src, u32 slen, void *dst, u32 dlen);
+			       bool allow_pattern, const void *src, u32 slen,
+			       void *dst, u32 dlen);
 int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
 				     const void *src, u32 slen,
 				     void *dst, u32 *dlen);
diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
index 95e48fa6b448..821299888ad3 100644
--- a/fs/smb/server/compress.c
+++ b/fs/smb/server/compress.c
@@ -69,6 +69,7 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
 	*(__be32 *)out = cpu_to_be32(out_size);
 	rc = smb_compression_decompress(conn->compress_algorithm,
 					conn->compress_chained,
+					conn->compress_pattern,
 					buf, pdu_size, out + 4, out_size);
 	if (rc) {
 		kvfree(out);
-- 
2.51.0.windows.2

