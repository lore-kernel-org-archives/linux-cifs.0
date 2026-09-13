Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569A52F28FC
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335929; cv=none; b=mhYQynh6Db1m3SLBZpDHjqvshvTzboLzcEJijJoYum8YrlQJPNzdm1weCyFprY+cCpeh6i779hlyFJjkUDmvxN8UxADRi0fnKn3Fzec+hRj0AA2zNRHtaHsRafIxzzHkMB/bF05Uw8D6KRzgY8W1hIONaAXVNj7VGgKI/v8NoN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335929; c=relaxed/simple;
	bh=nqfoL6Sp1nIQ19/slQDnpcHsImhTyPT0s8L8U0rdTI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGjVbFhZ+REkEY/QbEhaom5up5vrOL5h5kaVHvR8BTMX+M5cci1Ym3tY1aWIpy9r4TiX3csr0zmDUR3Nl/TohWGrYC64TRakyT1eltSTTCBeqMyaABmAD5O7p9NOFZiBddgaOQhXujbY1oEKmv2nwp+ZfGji86AxUCJ/YlSp5mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CG0Yt2GO; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDKQjoY4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CG0Yt2GO";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDKQjoY4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ABM2woyIBHuSZR/C0pNttPA7KR8KLBv44FjWRfwZWUU=;
	b=CG0Yt2GOgdTzfrfcrpp2yhiKbBLTjWT4ePsP+WIbsBfl7w+9cSc8M8562wbmPhzkppoq0y
	F+nsQQ4zpn2tLRwO9FQdBGmSpZd4bSNgNquN53dzBMbE+bVqHEBfJ9xzhHOBA9HekFVw/N
	5UhoejHkfQKgygnRHan/YdF0V18wwTw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-8_1Td3nMNdyDR7IDLQyNwQ-1; Sun, 13 Sep 2026 17:45:26 -0400
X-MC-Unique: 8_1Td3nMNdyDR7IDLQyNwQ-1
X-Mimecast-MFC-AGG-ID: 8_1Td3nMNdyDR7IDLQyNwQ_1789335926
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e7de22fddso60035196d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335926; x=1789940726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ABM2woyIBHuSZR/C0pNttPA7KR8KLBv44FjWRfwZWUU=;
        b=UDKQjoY4B/i/nAF9MhEaF3k2YKkIA5bYyM8ru6owLmlKeShDqyqjyo2LCgCkcj4Vr2
         FdlZ3TX6RD3aT/tq2q9QoiKf2n8vMztJ/AkElVgKZxQ+8NwbrKgZk6SFQdr3Yib2zGCa
         qPREGWlO3zThUeIpMD4R+LTvQJSuA33x8xKJ8bCgA5ilWG/HuQCLSFgdPeME4Zo9tlVO
         6h647TyW972wgUjGms4kCvDwbyschsxuGObpuSx0IXFn4t8CEC0Wz28hnJuaEPTZOTyH
         nfmT24TdXIjel5/k3YjGopbrXklfoim6x8eKC4er6IzYouRQ8O4+UgCLKfhgBkOuc/qV
         Phrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335926; x=1789940726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ABM2woyIBHuSZR/C0pNttPA7KR8KLBv44FjWRfwZWUU=;
        b=Qt22HLjcsfXeOz6E8IgnlSGnsP74hSpiy9aW1lcDH17lqXfiksBS6qurt7uY46r3mt
         2FiJ8RpgHBxBXY3iz+/fQ2u+jsOD3/iT7GUYqDcWok00ZHCATvXlAjMaRDjZ6yw/9He9
         v6l4BMjIJ3pk2k5u0zSnnCatPFRHdgVrKApM9QQ8e6HkRB4Q/YArWapDVl7CGbPYI6zX
         O3qyHFPIeRdRccpbdLewJ88PGY6Y/XL9oPMtPdPr/j2Ic1kJMsh/LWPYgMclHTjOZMYh
         s4CP4OkP7ooFhfQZy/ptooTZ2wmxh8+ZM086+2bCBhX+WUY0AlxEXzBuQVtwhRGg6B6N
         8Iow==
X-Gm-Message-State: AFuF++l3Hs8ffIbUyqHXJA9gzwxjq9JYIRnrr/AFfMHrhwdzZatR3Mbb
	pMJOi8P+mPQsIaf0DW9Hlm3a0BtMBmNsneJ1swY6CeIfFxTnBDNCJ8zEbyJPRefDMBgte/eSAzm
	uzvdOW9mssYKc3d274RDkjAeyu1Eq0XVbpeDilL6KM+8G7/qb75kx/voGLyNAq36LysyL87RJ9s
	+HFw+Z4xSgdilObJDp3RSd8FG7jtzATYhRsXFd7EqmaYo7mSw8sg==
X-Gm-Gg: AYBFou267/Q0Vft/34tNNuBkFViszUPXl2asDcEPDILZO7wdYr11nNa/dvIGUG0SKuq
	JaCJiNDl32OZMYK0J9JLtXEZptrSqwsVSbMkSWCGISO5BoFmxuXdWjT7NqjZHooDLkasdZdgd6l
	esOBBKiIJs3JuwMsP4qwC3Nve6PEqqGsXXKahL++eK+r31DzfO6YTF6wkw19X+k7QRQqFKQqlkf
	iSvmnHRly7hUqpogODyPzJrf3NS/oKG9ZMSV/R1RFsAuFk3MLjQeLO5zhyd3C2hcLly8mP+eQVw
	0lY3FRNCh2gYSuWr3DTkZANA0BWPFMD+kIBNVsVFu3bbFeGeKEv/z2egwOXC9vBTZCpxCH500+8
	CtWfdDBjewuzRm10zoFxzx8PZV0oAtOwEKfltZyPWHaX7QWwSqnWX7EirOyIx59hrhg==
X-Received: by 2002:a05:6214:5287:b0:90c:e240:3e89 with SMTP id 6a1803df08f44-9122e501040mr24666d6.13.1789335925636;
        Sun, 13 Sep 2026 14:45:25 -0700 (PDT)
X-Received: by 2002:a05:6214:5287:b0:90c:e240:3e89 with SMTP id 6a1803df08f44-9122e501040mr24306d6.13.1789335925159;
        Sun, 13 Sep 2026 14:45:25 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:24 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 06/10] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Sun, 13 Sep 2026 16:45:04 -0500
Message-ID: <20260913214510.3071370-7-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260913214510.3071370-1-sorenson@redhat.com>
References: <20260913214510.3071370-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In move_smb2_ea_to_cifs(), the while (src_size > 0) loop condition is
insufficient. It allows iteration to continue even if the remaining
src_size is too small to contain a complete smb2_ea_info structure.
Consequently, reads of ea_name_length and ea_value_length can occur
out-of-bounds.

Fix this by ensuring src_size >= sizeof(*src) before attempting to read
any structure fields. Additionally, reject any next_entry_offset that is
smaller than sizeof(*src) or that would advance the pointer beyond the
available buffer.

Note that for calls where the server returns a malformed EA list, the
error returned to userspace changes from -ENODATA (getxattr) or
-ERANGE (listxattr) to -EIO. This correctly signals a server protocol
error rather than misleadingly indicating "attribute not present" or
"output buffer too small".

Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 25 +++++++++++++++++--------
 fs/smb/client/trace.h   |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index bda940cb3784..ee3c98e3f316 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1053,8 +1053,9 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 	char *name, *value;
 	size_t buf_size = dst_size;
 	size_t name_len, value_len, user_name_len;
+	u32 next_off;
 
-	while (src_size > 0) {
+	while (src_size >= sizeof(*src)) {
 		name_len = (size_t)src->ea_name_length;
 		value_len = (size_t)le16_to_cpu(src->ea_value_length);
 
@@ -1110,14 +1111,22 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
 		if (!src->next_entry_offset)
 			break;
 
-		if (src_size < le32_to_cpu(src->next_entry_offset)) {
-			/* stop before overrun buffer */
-			rc = -ERANGE;
-			break;
+		next_off = le32_to_cpu(src->next_entry_offset);
+		if (next_off < sizeof(*src) || src_size < next_off) {
+			cifs_dbg(FYI, "EA next_entry_offset %u out of range [%zu, %zu]\n",
+				 next_off, sizeof(*src), src_size);
+			rc = smb_EIO2(smb_eio_trace_ea_next_offset,
+				      next_off, src_size);
+			goto out;
+		}
+		src_size -= next_off;
+		src = (void *)((char *)src + next_off);
+		if (src_size > 0 && src_size < sizeof(*src)) {
+			cifs_dbg(FYI, "EA next_entry_offset %u left truncated entry (%zu bytes)\n",
+				 next_off, src_size);
+			rc = smb_EIO2(smb_eio_trace_ea_next_offset, next_off, src_size);
+			goto out;
 		}
-		src_size -= le32_to_cpu(src->next_entry_offset);
-		src = (void *)((char *)src +
-			       le32_to_cpu(src->next_entry_offset));
 	}
 
 	/* didn't find the named attribute */
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index b442cccd1530..bb8d0197cb54 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -27,6 +27,7 @@
 	EM(smb_eio_trace_copychunk_overcopy_c,		"copychunk_overcopy_c") \
 	EM(smb_eio_trace_create_rsp_too_small,		"create_rsp_too_small") \
 	EM(smb_eio_trace_dfsref_no_rsp,			"dfsref_no_rsp") \
+	EM(smb_eio_trace_ea_next_offset,		"ea_next_offset") \
 	EM(smb_eio_trace_ea_overrun,			"ea_overrun") \
 	EM(smb_eio_trace_extract_will_pin,		"extract_will_pin") \
 	EM(smb_eio_trace_forced_shutdown,		"forced_shutdown") \
-- 
2.55.0

