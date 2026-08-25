Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C302E2EEE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 22:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787695988; cv=none; b=Ug5tiZjHxWx+GjvCuwqmFFtKK1RdrpMFaL60+DPomyxr0AkMiBcg8VH31JL7gafGPONmKSloZQ2F268CrDF7lTYxqgCK4ENuuQt3rylhKXV91K3PpDaaRVZCc/vFS5rPcWQThhc1V+Qa13UyE7hEJSR7k9EaEFjCgiqZkf7QMgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787695988; c=relaxed/simple;
	bh=gm26qQiiwKEYhHZMZb8w7wMtSk6o3tA87DkPepM1DIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQt6eV6PNwNgSUoB8LS3655CpJ4ne4rxjpWcNqIGmZtuc2Gz8duoNrZ34tAb5IdneUWJmsJaH+/OJN8Ajy1AuSg62U/0DmACAIZxVvfcVcQ7yAvck9tSxLiUqudcsx+Aq4Ii9CBPBMxYfPUIStuB/q0VzLRlpvGW4owEYyfNDHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rjgg/4lJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4l98uqC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rjgg/4lJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4l98uqC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787695985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xHn5uWyTj2Tgmniq47Pv+Rn61JDZfNSE6Z8AvHiyjIQ=;
	b=Rjgg/4lJ2KJCK8VgPZqxBFx+xbF60cIelN6LPzBUZxWJ7mK3nWoBogTA+lJIf5SjmjD/QA
	4Ac12lIppMjFjbQqJp9P5mAiTacAaXy1rgRkRWmAJFTD1AaDNK9jawOsYl6bQu8jYFXYA4
	R5XwqqksUCmDyWeZYPXaX/HE2x+j6c0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-c8WIf3PVMV6lpPALMppsmQ-1; Tue, 25 Aug 2026 18:13:03 -0400
X-MC-Unique: c8WIf3PVMV6lpPALMppsmQ-1
X-Mimecast-MFC-AGG-ID: c8WIf3PVMV6lpPALMppsmQ_1787695983
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52e2d1bdce2so3958451cf.0
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 15:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787695983; x=1788300783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xHn5uWyTj2Tgmniq47Pv+Rn61JDZfNSE6Z8AvHiyjIQ=;
        b=Y4l98uqCMiFyjZopsME6j5ty6F6mo2VotlzmAEotDoalBa6EfTyUuly6eikBhSlDrP
         x+hK3qoO941yGB60FxfJlc0HmbKfZX+cig3omt2ag0e0A43zX2VcyNSbbN7WOr/2AsJq
         9gLz7nLK4SV/tIpGIJmvV9PtL13RVn9JITs75VAe/W0y6fVnhCNULYYVKwMGNbxQ1aK+
         8jY7EiQmZKIBXCO1g4uuyA4Y2Xr6qS9rzS4lN3zYAJ+HnZ8wluz2xw3doGaVN1RAxPMU
         YIFUQzWQjGD3kzMj0WKrUZBia2CxLPmEw0drgMPGKgMUZHvSG2g0bQXbzq8y5HikMUiz
         iEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787695983; x=1788300783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xHn5uWyTj2Tgmniq47Pv+Rn61JDZfNSE6Z8AvHiyjIQ=;
        b=DHUpeN95ejgedGWDJuh+AAWvtaBn1VtTmWMwC7MIuP/lZ47uIvz9KDTntf83a+1DQs
         6H22WOz065y8I6aOE9cd7+SlCb0vZxdHNizKYTNNBimT4QG0cUr0hv9RHrvXBcUz0XDh
         BOmMNl2w8LGS7riEC8vwqc8Hiim1woItYShdh+Ra2X9WSPZW0ZUnJb6uyprCNejN0Ihg
         oP+S6jaZOUEfrW2GPV2307r6joBFFyIJofxZgB3gCKgY/k4UULTMLxxttIrAtKnSdBER
         /++aX8UUGsayBD/jm3HR89Ssu6XutA59lzR45RbPZ7W6eQELxV4L53siIFTZbOS7arMB
         MJ8w==
X-Gm-Message-State: AFuF++nvOBwaEpl0WOtH0Ccu5gI2OOe40OQYZZ4rezCqfbr9c0pUcmcK
	ER0kqLGgysZrXJG5Xwg0+w3K8e6aWvQq1eGuAJef1a9K7rnMrbrUY+yE2YCHb/YtqzSQh+l5bvi
	taQI+/Ha/nuXWVXjW8h3ubCIxnlYJfbBT4ODVHTU0EL7PXgOabgWtd6TVuQCvYzmZ051V0fV/xL
	Kgv63fm+E5+34ieJdj5NZ+9qotbHJAQqCMxv88dpxkErHrgDk=
X-Gm-Gg: AR+sD119FOvRb/emqdH+k2fT/pzPOMcSdGomoOl6lcjWsa222H4rvr7vIrmuKRaIOI4
	B5VfrRKnMubIB4dIIPg/DBYFB8fzTGR0f3HOPFy168i4rU8oozTfgxpvpwdDAWLzCfk9VNIIePl
	DG7oRi/1xqGMr2AKwtYojv3Tzz6+BkJza60nUesLhkh7kDmLtA+nPQ4k0rJ9EnLB/ELJW4EnGYC
	MWJIl8GExRDIzOaWnIh4sieqAurvXzFByY0NNVzCFJ8PrpUh5mUJFtL38b+35UUJglnuCnplLnY
	kXjT5oz/E09x0tHo04hdhjJtL+nd12z+kaU1cPdQSEZJlljN9yVFl5tDWvbb2DFGQylAxdqTzT4
	1uCU2KBMIDVE5PD3dKpaZxe0sPf+81uSX2tP01Nsokc8V8PwZYf23IDV9P6GB
X-Received: by 2002:ac8:5dc7:0:b0:52d:6c36:db32 with SMTP id d75a77b69052e-52e423f7e4fmr18394371cf.41.1787695983292;
        Tue, 25 Aug 2026 15:13:03 -0700 (PDT)
X-Received: by 2002:ac8:5dc7:0:b0:52d:6c36:db32 with SMTP id d75a77b69052e-52e423f7e4fmr18393941cf.41.1787695982767;
        Tue, 25 Aug 2026 15:13:02 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e4270a6ecsm4998291cf.17.2026.08.25.15.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 15:13:02 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Tue, 25 Aug 2026 17:13:00 -0500
Message-ID: <20260825221300.3860212-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260823185807.3115901-7-sorenson@redhat.com>
References: <20260823185807.3115901-7-sorenson@redhat.com>
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

Require src_size >= sizeof(*src) before reading any struct field,
and reject next_entry_offset values that are smaller than
sizeof(*src) or that leave fewer than sizeof(*src) bytes remaining
after advancing.

For calls where the server returns an EA list with an invalid
next_entry_offset, the error returned to userspace changes from
-ENODATA (getxattr) or -ERANGE (listxattr) to -EIO, correctly
signalling a server protocol error rather than "attribute not present"
or "output buffer too small".

Fixes: 95907fea4fd8 ("cifs: Add support for reading attributes on SMB2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
v2 changes:
 -  reject next_entry_offset values that leave fewer than
    sizeof(*src) bytes remainint after advancing.

 fs/smb/client/smb2ops.c | 25 +++++++++++++++++--------
 fs/smb/client/trace.h   |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 4dd9dd55ab4d..c866d7c8c7dd 100644
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

