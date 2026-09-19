Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5271C3AC0E5
	for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 12:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789820963; cv=none; b=Zo49rjhMGZdt2BKbKi94x75Qj5A+Y81X3AX1xnNjJW1qmHS/5t2cHvW/j/5k7c48+S3jj/Xp9QXAzfuEfrMptqzghLneuQyf4M7gHc3fn3+Tmqs4lrFCdKYZlqRAfXC1k6+lYajShy/askrSTvpkd7ONui+x9q8JiTpTtKoM5YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789820963; c=relaxed/simple;
	bh=FhGfaaadKfzqjzMrtMZhUZWMDMTEWbLfalyZGog9s6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEJJk6angzItW7NpQmWuM3Am7p+vRGqSsNywz5H8Cnfi2nCZ9y7uUO2IFluaI5GejkQLohUegYIJ2ytOSBkiBGglwixLx6fltA2MlfxfITmpp1iWuXmLIcjM/HWnXrvSgTTiQtYSJ/RiWjjsaaIVp06sL4//yJD3+lvdA1ypME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WmMpPVn+; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WmMpPVn+"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ee1f38so15696605ad.2
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 05:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789820961; x=1790425761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XPC4j42sEiqe2ttq3KiBybhSYel2jntiYfyU4eCdyfk=;
        b=WmMpPVn+Tsy63lN3cuByXt7Hf86Zpif1GySU492uFRiydzb1NZU7c3/Z9HEtEE/v4N
         nSLVDBVhImQiOLM20iyZFCbVMXeuD34mz5nEXGdn83WVvJb6pJr6LV/XCTYOJegRg2Mz
         quFeA5wG1uKrTKWwOtHysu54P8p5HmmYYr1g/rJuX1GwwqnmJcklseS9+TnRKkewwAqK
         SwDBzqVf1UqDzNRgtQK8cKRIOiG4lUxSN4bzbNya+OG4EvBb/p03dXJ7GauL22GS+Uhq
         WaGxk/PF87Gl5nOEUeynDUJ7/eK+SPYuK9yCTYB59sDS6IE0Iu+PRh7fDJL1BCA8ds+x
         2+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789820961; x=1790425761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XPC4j42sEiqe2ttq3KiBybhSYel2jntiYfyU4eCdyfk=;
        b=J18kFwF4YqvlL4dLFBlRyhZy86lzTUgYgTSHM53tTJta6wl7lG1gvBgfJ1V5OMRAb+
         M0Ii4Vz/UOA3FhsEe3uryh6b6f0z2YJF2u6sWfryN7gy25ob29My7cB8pqgJsXJqojIP
         FZD7o4QKAXVqF0unKzLwysgk2nYepU5iw7R0Ei89fOD7p6aJ5kv/LoDBqdNXiv/7/fn0
         Nd/4wI0Ie2hIXq1jfIM2Ap3UJh6YNsvc43PLHvCSebg2eKPtLCi82ir2ZmizBQpN5LF/
         IOuA0Z10v0TjDex9C9HH4j3rdKVhcU7XShFR3NLDgQHUiY9B4e5GeMdIyXY4EyCwOiVJ
         j+gQ==
X-Forwarded-Encrypted: i=1; AKwUvBz80/9r9T/rxi0Sfd70jPc1lYB08JL8mJ2Qyo+gISBT0eOzUq0U3iHZi2w1rcijFFVlMZBF+oAYPcQj@vger.kernel.org
X-Gm-Message-State: AFuF++ksCp5xUg+iVjOAyjj8uvlRJq2SnTpxouF8Xu8owA4jV15buQXZ
	KWcuB35gYzCYmmOAtMd+mDZrTHGF5ROiwMHkqwv/HjJKBNe0TlgD5BkQ
X-Gm-Gg: AYBFou3oHqUpm/KtHkTXmXw3jy/ORYFM/78D3Of4+amVFbyc9UyPBii4rUNK9lsooR/
	8y0oujYwScMlP1CtBsQbVj9b/v7QAPhv6mKsTEdn0JFCWvP2p1758A8cgwVMSn+fJw255WybL2z
	FB5JC6sBSyIKKXt9xjgOkR0pXrmpLfT8K3cM70IAaBikhOXVyjvnk3IjNTdF19eNEqdOTif8YyH
	JgeaDFwA9ZqFu+SnBud6fPIkO+UVtjLmemZ+bHLu9S3hxNUGXq9HQYqhX+M5H5Zp9jsMoe+5lmK
	Y6USC3ebG06XVn98snHANXHZn+kSJFJ9+H3jfgxAtoiuKsE8l7ntrFBpNyyOQ4Xk3Au4PsUYEPc
	6CedJ/yqKQFAO6L28SoZ8BDgzuxTcqGeNJ10B+f4aubYItUqdNFRN72I6Go2O09HZ1TkXTfT1yU
	mQmlrj7igxk0TtFqw8qEpXUjHlN+RGCRkWVCZVV7evqJMb2BfERTAMw3JEYL/iBEBNf372hYSCJ
	JHR+VU=
X-Received: by 2002:a17:902:d4c2:b0:2d8:de9f:9a44 with SMTP id d9443c01a7336-2ddb1c15766mr80621275ad.19.1789820960541;
        Sat, 19 Sep 2026 05:29:20 -0700 (PDT)
Received: from RyzenBox.localdomain ([137.59.96.253])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c331aef9bsm5978411eec.25.2026.09.19.05.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 05:29:20 -0700 (PDT)
From: Omkar Chandorkar <omkar0926@gmail.com>
X-Google-Original-From: Omkar Chandorkar <gotenksIN@aospa.co>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Namjae Jeon <linkinjeon@samba.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Omkar Chandorkar <gotenksIN@aospa.co>
Subject: [PATCH v1 1/3] smb: compress: relax trailing flags in chained decompression
Date: Sat, 19 Sep 2026 17:59:08 +0530
Message-ID: <20260919122910.2382-2-gotenksIN@aospa.co>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919122910.2382-1-gotenksIN@aospa.co>
References: <20260919122910.2382-1-gotenksIN@aospa.co>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In SMB 3.1.1, clients such as Windows 11 send chained compressed
write requests containing multiple payload segments (for example,
None + Pattern_V1) when transferring zero-heavy or compressible
files.

According to MS-SMB2 section 2.2.42.2.1, the first payload header in
a chained compression transform MUST have SMB2_COMPRESSION_FLAG_CHAINED
(0x0001) set. Trailing payload headers in the chain correspond to
subsequent payloads, where the specification defines
SMB2_COMPRESSION_FLAG_NONE (0x0000).

However, Windows clients do not always explicitly zero the 16-bit
Flags field on subsequent payload headers during chunk construction
(as described in MS-SMB2 section 3.1.4.4 step 2), leaving residual
bits in the Flags field.

smb_decompress_chained() currently enforces:
    (!first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE))
returning -EINVAL if any trailing payload has non-zero flags. When
this occurs during large file writes (such as copying VHDX files),
ksmbd breaks the connection receive loop and abruptly terminates
the TCP connection with ECONNRESET (-104), causing Windows clients to
fail with error 0x8007003B (ERROR_UNEXP_NET_ERR).

Fix this by relaxing the flags requirement on trailing payloads in
smb_decompress_chained(). Conforming chains still strictly require
SMB2_COMPRESSION_FLAG_CHAINED on the first payload header, but for
subsequent payloads, only reject headers that attempt to initiate an
invalid nested chain (SMB2_COMPRESSION_FLAG_CHAINED). All payload
lengths, decompression algorithms, and total uncompressed output sizes
continue to be strictly validated against the transform's
OriginalCompressedSegmentSize.

Assisted-by: OpenCode:gpt-6-astra
Signed-off-by: Omkar Chandorkar <gotenksIN@aospa.co>
---
 fs/smb/common/compress/compress.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
index a4123c8f1..434743005 100644
--- a/fs/smb/common/compress/compress.c
+++ b/fs/smb/common/compress/compress.c
@@ -130,12 +130,19 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
 		len = le32_to_cpu(payload->Length);
 
 		/*
-		 * CHAINED marks only the first payload. Requiring NONE on every
-		 * later payload rejects ambiguous or independently chained data.
+		 * The first payload header MUST specify SMB2_COMPRESSION_FLAG_CHAINED.
+		 * Subsequent payload headers in a conforming chain should carry
+		 * SMB2_COMPRESSION_FLAG_NONE, but clients (such as Windows) may omit
+		 * zeroing the flags field for trailing segments. Do not reject
+		 * valid payloads as long as they do not initiate an unhandled nested chain.
 		 */
-		if ((first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) ||
-		    (!first && flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)))
-			return -EINVAL;
+		if (first) {
+			if (flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
+				return -EINVAL;
+		} else {
+			if (flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
+				return -EINVAL;
+		}
 
 		src += SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
 		remaining -= SMB2_COMPRESSION_PAYLOAD_BASE_LEN;
-- 
2.55.0

