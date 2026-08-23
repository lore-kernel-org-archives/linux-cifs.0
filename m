Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2ABA37F74C
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511528; cv=none; b=hPTKMGKlUvZUuF8RpTIk21AWVqXfsW4FzSFBGie/9egikNnk0r2w6ilXwSWpSBDMSIJGeC2XE3w2OzBTTq/qDtEzYqit3T2RTzpgmo8gei7/f9or2jMC9XOtuLQlTddS4oCmX+bWwgIoIQ65zeXq4yPsRJl1vRCQw7Kj2ykTmV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511528; c=relaxed/simple;
	bh=CgzoOK9/s6xhHxffiIF0WFe/KBzgPdD2uGmwabCs0BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgcYkQD3qYT1UEQIJGeMM7LzIBdn+qgbGVpL1mPpt37bDvu5bHSkBbAFkrGYeFQxcYr0Oy3z8qQ6DxB9062UBGYnjLZ8JzBytgJ52+i1oLpsyCllxzfgreliPiRk9Uz3EWD/zwvS5zcQWxvRiryJH7Gi2a5abdOH7MkESe7vuyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VUkxrMWc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=miXss9X2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VUkxrMWc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="miXss9X2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E5UevZjhTBT7sxxqgaSLqVklHimE7Mj9i3tECTnpgmA=;
	b=VUkxrMWcifK8/CE8e7Id5ftQQHtPzo8hG4jBgrtnlv+ReqNcebULDMUElR/V8vV0zCfBzb
	goiPaMm91NRj8X/oI1Cx+TbmQPwK0k/418Nh4b+MpGQRHRn9yucKzJOR6xBuD1JxfdnEMn
	h3fC6Bznnl6iMDcQ+OXEfZuQBB/dogo=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-vONU_X8BPtCGsMXQm5kgvQ-1; Sun, 23 Aug 2026 14:58:43 -0400
X-MC-Unique: vONU_X8BPtCGsMXQm5kgvQ-1
X-Mimecast-MFC-AGG-ID: vONU_X8BPtCGsMXQm5kgvQ_1787511523
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7eb6a8c61deso2581849a34.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511523; x=1788116323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E5UevZjhTBT7sxxqgaSLqVklHimE7Mj9i3tECTnpgmA=;
        b=miXss9X2d60v07V8v5NV7lryuF8aJaI6mLHRaX1QtuAGx1YtxDyOhybGKlCMdvtNGf
         a/Ks/I9SkO6pjP7DBaaFKxVNzjtUhXqY0nV4l4ZiVp7o4YASTp6Z3TjZfGi7psZanSeT
         OUuT65jkx94DdrPohsPYPrr5LIYI0wsSel0vqlVBWNSXzd2GosL96no2rQtYqKhzbhSG
         E+xcZGL5gKaHY0XRbVxs/lkqonWG3XtHUfFS4HEamj8dRQwEdJ37X9k/cLgRxI/6cQ1D
         4OdERutXATgbV7W+OjCOKZx0J68ouyPaX0pbvWMwfUIIIGvJIRDiFyZiMkUzi/scyDW+
         5pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511523; x=1788116323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=E5UevZjhTBT7sxxqgaSLqVklHimE7Mj9i3tECTnpgmA=;
        b=hZcV/8JLMVko/J6tnywOEe8PbLYS2V/hEaKQsWIQXGbdzWaS487Lt0IhV8UM1eYxB6
         iqOmW4xTuiJpRpl5cqrj+qouPrTMf1DzGYAWQLGA4CqJOxIaBgkoPXGRGwb3yRt5rzFU
         X1HtJkMAbNP8XPou4GaLvAng00MQUpbs9oTohXYL3+oCP1EGkeuXXJz2YZuPo3VsJPfA
         YLlZEcE7z9+bfgjnI/FpofkBqEZLLm+NyIEv+h74z3s9audhLXG678X4IpqckK9i8uPT
         QAvEqVPKbSsJls2ZQzX76dgtQ5nV58CkOZaaSpykDOQsvxfcbu4kcKsJfk3NWd9PijsM
         CFlw==
X-Gm-Message-State: AFuF++m7ACHceMFgUNyDXX8lM7ysWayJkSZqmtiuHb24OUhvwL+FFh4d
	eO2Mpf+sKVo1Fyh4aRtq3/EgDtGGLH+sgcRO9tiWofZjLFL/SbVN8seCccmqlUjpBJQ6exNVUNI
	lShtTwuNJrOuz4p3RvC6NW8MT2lrZlDjI+eeJ/l445SGWmq7LxLLz+7O4/udqGONiyt08FT5mBN
	IvBUVvytmspLKptICoefkVpdT9Vm5pcbaK1EbWHKXogAp44aM=
X-Gm-Gg: AR+sD10pO/51cGgblvB0Va6bePoFEsuN/Cz92/D75oQW4sqV/eSad4INGuqe2vFCo3C
	aUFGu3YKnkukcKm5fgpcrJHx/SR9HT29INlfzZIWttDG3pr78GPJb6D9P8F+aq/8+H3nXAuD+AJ
	u15hzGaDfw3EsbbjBewgb6AXXM+T3iUA1hFHW+J+PkWufq1cPr9mTqJZSsv95PovEHbwNwpJICa
	pgZELKZliSyy6cuHjvYNsELvXGsN5O1jbhtchvocLpFZNsBQotaVqF3E780usNbew4SKPwaC8s3
	oFPqyoICHwhZD5MLY/whNLbWAkNkxDKj/wakKVPRr/J+UwJHfvpxA2HpmGTykk6aWQ7w62mRmub
	dbaUnirqpQuNmn0Y0i2YNwRALW6ga8IvhEOAXr0VrBNqG77/tryptL7GcACeisPsP5A==
X-Received: by 2002:a05:6830:6d4a:b0:7e9:cce4:803b with SMTP id 46e09a7af769-7f47644defbmr14079268a34.8.1787511523167;
        Sun, 23 Aug 2026 11:58:43 -0700 (PDT)
X-Received: by 2002:a05:6830:6d4a:b0:7e9:cce4:803b with SMTP id 46e09a7af769-7f47644defbmr14079224a34.8.1787511522621;
        Sun, 23 Aug 2026 11:58:42 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:41 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 06/11] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Sun, 23 Aug 2026 13:58:02 -0500
Message-ID: <20260823185807.3115901-7-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-1-sorenson@redhat.com>
References: <20260823185807.3115901-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The while (src_size > 0) loop guard allows iteration after
next_entry_offset advances src past the point where a full struct fits
in src_size.  Reads of ea_name_length and ea_value_length on the next
iteration are then out-of-bounds.

Require src_size >= sizeof(*src) before reading any struct field, and
reject next_entry_offset values smaller than sizeof(*src).

For calls where the server returns an EA list with an invalid
next_entry_offset, the error returned to userspace changes from
-ENODATA (getxattr) or -ERANGE (listxattr) to -EIO, correctly
signalling a server protocol error rather than "attribute not present"
or "output buffer too small".

Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2ops.c | 19 +++++++++++--------
 fs/smb/client/trace.h   |  1 +
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9065c94e5ec6..37c1144f3d57 100644
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
 
@@ -1110,14 +1111,16 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
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
 		}
-		src_size -= le32_to_cpu(src->next_entry_offset);
-		src = (void *)((char *)src +
-			       le32_to_cpu(src->next_entry_offset));
+		src_size -= next_off;
+		src = (void *)((char *)src + next_off);
 	}
 
 	/* didn't find the named attribute */
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 12241abb8e2e..6da395abae14 100644
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

