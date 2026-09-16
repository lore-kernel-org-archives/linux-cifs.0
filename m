Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF8C469838
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594475; cv=none; b=U8lFboQj2yz3Szoh8oP9ijVT0NC05aXZEaNA9OgsWjqO2Y6wHh8jjsG4GsiwnnFP12R3kRgXl00kLzDRDywayAC9hAtHBiRbOdtZDvePzM/E5BbxD3E7wvMZ6Mc39VCZeglirGWJBtKihNzmFQpoaDHX1jHuccFhzLlxdrZc0ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594475; c=relaxed/simple;
	bh=nqfoL6Sp1nIQ19/slQDnpcHsImhTyPT0s8L8U0rdTI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQQpWlOOampj9WNKZEzlMt+cueZFLVVhWfKBOuUtA9TOK01O8q4yV/Cu9kKwMNCaj+at/f+iiLMk3KFE/vCo5Mrs4VjRCdOmNIssYWzklngG4IgjQLlgRLjHTmFJXi+qCq5YHkoD44xwdnMWZUPBhIBzf63JO1Mx8pMVDyv+ljg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WziT30g4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=f9KLW3eH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WziT30g4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="f9KLW3eH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789594461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ABM2woyIBHuSZR/C0pNttPA7KR8KLBv44FjWRfwZWUU=;
	b=WziT30g4vzLcLgYhyYp/Z72xTNSFlpbflim7zDFxImISre0yOsAQFzUUYXy9QdYFmktgJW
	ZTCQRBCvZMi8v8c8xVmZl3J/2g5wNIVLxOCUdWlXQY9r9cAcr1EboM6qu39Ot0c3rjYytx
	nzIOQ27YwFaM3D6EKZ8SaK+IYrKupOQ=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-WaxRDEt5PuOU0wKHJxvCew-1; Wed, 16 Sep 2026 17:34:19 -0400
X-MC-Unique: WaxRDEt5PuOU0wKHJxvCew-1
X-Mimecast-MFC-AGG-ID: WaxRDEt5PuOU0wKHJxvCew_1789594459
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-52ffe24490bso2058061cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 14:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789594459; x=1790199259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ABM2woyIBHuSZR/C0pNttPA7KR8KLBv44FjWRfwZWUU=;
        b=f9KLW3eH22J34clq06grgOcshS7N+qoY4Y1roPOhyiEVWGsf8R/gcnJHSy1pxDiC/F
         +djJa3ezyVHZVAxC0Y1s+hPIXpvOCO5qTPs6yCsPFVXkDS8Ku1zVKOx5t1TLbrL2Xjj+
         MxCINbtaFvQIkPYNLN7953RwkbMD5B4K13zBBr4lMXw9yuzQHo/jvsW9YKX4vYkH/Z0K
         f/4sTIw4B7T3ZLiZdgJvhQuqL1h8sEaSNBjvR9y31NouGksEzpcLJNq/zadJ7FgeOv4s
         awutUfVmuI7BxnLFUN8FcYrJCC30ypOLHO37/FX0tdloEXfY7IGtty0/ZL9tTBWg3H0j
         fMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594459; x=1790199259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ABM2woyIBHuSZR/C0pNttPA7KR8KLBv44FjWRfwZWUU=;
        b=XrJI+e1c2E5rsujjqdsMH4h29L4ydi1ffmxVLFqjtakPO4B2UCo7aDamqP+VbyS7Dw
         oSaxh3d2hFOenJlg3y3srqPuYa9V8ffCh8RpcNFgt9B+rbYRZn/MF6ll1zIpu7wLaz6k
         RW562aQ+O50f0fO/WZ9zk/n1UJMdk0xc11cXb3x//GkEfDevNhZSSydaFynt7Kml74e5
         Cf5abX2JbX6qkRUCC4WJRebBT808I3BfAizoEZGHT/OI811fiJ8MQw+J+Q8OuutVNh8r
         4fdSbFNOfAnIXJtuMLNDCf84jHEmlhF/+9KzXwcKE6w4b3KXGdouAPXZyb8J8yaZFIsp
         NiXQ==
X-Gm-Message-State: AFuF++kLyYz3QjXmVuqEjKLBLisddZ4P1iSJH+dX+q4zv7br37ErVcax
	zM1HXZyMzETvf5Y8lSN9lIwxqSwp0T+LZJ9GTR9JFdEq1kkwKpdJOeomoV9mGMtNYY7WJD3tTF2
	abv8/SZJr5HhfLkIAsKumuj95LUGuIS/zQiMxvI6AyBxupf5W/b2zciftHKJCApOx9dVXAfK+MR
	eC477J51IEaeFwvAmLDs4tUmtgAe8i0r/JiftBXs8CQRzkbwc=
X-Gm-Gg: AYBFou23gYBkHYd0CPNfr6ZfwTMyGF4bBMHz6hfirOq9YgrURnxx857Inm4s8EkSpO7
	VJZDqWQy7Lvief5NjF2yV3ML1Wpo+sp1Bg8fh8mm86XqYGnEXkRAQs9uZlqTDj63IKcWtt6mP0O
	ksGftfHBbFBLviXTId2Dx+1c3IYU8XKEKioNnqtayl0bJ8gKkfhaBeuI7mymkdAPZptBT0Y6sSj
	7VXt+6DBFbBU6KfjPQLIkS1rLvFTUroKbM3g4VN7FyKHHAOY7ERNmT3Z/ukzb82DbdlGRiNHACl
	w3TIbUb3ek02RSuXLciOmrXhNiOKd7SK5m2x8x3VYln72b6ChojXoO8QqDLezlWZZTzvob2vcKB
	RE3NpkAvHBqm7A1N/XYJcRCb6jzC1cFbn0J5d4eld6kY1jFwLaizRC+SvLwM/aU29ww==
X-Received: by 2002:a05:622a:e19a:10b0:532:8c34:2e3c with SMTP id d75a77b69052e-5328c342fabmr21013651cf.40.1789594459280;
        Wed, 16 Sep 2026 14:34:19 -0700 (PDT)
X-Received: by 2002:a05:622a:e19a:10b0:532:8c34:2e3c with SMTP id d75a77b69052e-5328c342fabmr21013201cf.40.1789594458689;
        Wed, 16 Sep 2026 14:34:18 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532620d4cbbsm32447431cf.28.2026.09.16.14.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 14:34:17 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v5 6/9] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Wed, 16 Sep 2026 16:33:57 -0500
Message-ID: <20260916213406.1496960-7-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
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

