Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E13314A6F
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787758349; cv=none; b=YxCdB44itYqx05IUIfF3esu1domF7gstA0M+ANK4nNziN/jN5Qx9vjCFVwcyZNYxOvZNqgnDDj0CImFzsD3eQo6DfdT/K2bCZL/tyethCWUfiw2ODijMf6vGvPdSIyeSpUqyraeZjDJe7/LPR+9fZhvP42kvFHSXz6LrDt1cdWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787758349; c=relaxed/simple;
	bh=EQdNja3K/YL4RoIsEKUiS6czgsqG0oVGhh2PuRzS0NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJl52iRrolcNcnWxkoWqbNaWQvHMgtVnHhwjiqS4RrbghMPml+CO6wcKX7zig4xfZGg2oW5dUj8ulqvS0+pEoWvbHLhekr5LPbbTZ2hNLcHlNCkpKDOtnPAafim7GlU5Mo7JpqoZ3GU24QH8zxW/udVVGZfM/7FT7VD9S3Fgk+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CmhN2eD3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rBCQRPHt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmhN2eD3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rBCQRPHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787758341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/9u1saGAdplFrmdEhSzZgWCpGlCV0QqNHCriRLqgre8=;
	b=CmhN2eD3caXMMlP1BwL6eZuvCudOH6cpnNBesNCVku8Z1Ytm1goix1NkEmcIvoy9QmT254
	73k44MtNXolL8oTtORYCd3+4mInUP+UmmpNzGRekMEj9xLzWr7LHREsUrTC6Pci5cfRbNt
	tUfNE6wjBJCQhV/uva4kRaZ+nwROMR4=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-rOuiQqC4N624Ibw1o2qfOg-1; Wed, 26 Aug 2026 11:32:20 -0400
X-MC-Unique: rOuiQqC4N624Ibw1o2qfOg-1
X-Mimecast-MFC-AGG-ID: rOuiQqC4N624Ibw1o2qfOg_1787758340
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-669864510f5so1627536d50.2
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787758340; x=1788363140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9u1saGAdplFrmdEhSzZgWCpGlCV0QqNHCriRLqgre8=;
        b=rBCQRPHt+mX09qvVZiw2l6ljOOJ8akv+d2zuIGisWSliGGwp6u1tTyh44yb/oywj38
         UwssZKbrk3dqvct6bGHFEuvbE9M8JPcBC23eA3OKP0Nh+MwLfOy305uiJ1qdkaUnGFxb
         KEjLDKjWg9KDMUdspvmRSske4ALaSi7h6FJ3tkuvEeKBmE7VEsLF7kwDK9VPdeWPbV9Z
         Xd2xlDE3HY2RHJe1vcYoVCrlnTtvTFzjqVEGOx2zNZ33XzcFGzJRQ/p3IIwHxkZGSclr
         SXfS3gsVzEpWHT3CSJSbmRN5Z4RwM4T4TXW4Zh1KRh94Ozb+7xxJtJkzhkcfkBb3C3Va
         OiDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787758340; x=1788363140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/9u1saGAdplFrmdEhSzZgWCpGlCV0QqNHCriRLqgre8=;
        b=Da4imN2IjizmwNmlcIlF55d2c8VwcBnwpcYt+1eKVLk/Iew/Rsyg+pMawVs/0BMkko
         8VQVi7DSQJQMR8qcV+Uqug34oUet1n7UVp/4961LsVZLkkgSTplvH2WRr9cR+yd8NyTJ
         XGyW74MVXIjymePjVhzados71/M38amn0o5FC+J/ounFO0AzD171riwDXKddI9cZMVhX
         P401WNjhWS0LQse2ItqS3/7tfHgMuKEBQiNImnTdKquIqFRCWLArs1kd8GB32sdTNZ8A
         Nyf40E1vSQQIFMNWEf+Q1ycHT1wF3umpGt2navWL2zfoXWLvth7LwM3cjGPqLDiQmdh/
         6HkA==
X-Gm-Message-State: AFuF++kEdnR9Tu+fUDjpTS5/om+RuNQMyZ4TKS3i9g+g0GtP6B7edHW6
	TE7fMxSFmPv6QNp3MSP/wbCNAko/B26Ulci6iFmtD0l9M+gOybMYBcKuaIG9oSCFutN4eMobhdx
	zqokh1eFfOIY1wzkgqKteq29Dh1xFGCF+/u7+xuAvRsnyU40dANIwsPhw0r40x8Xxu6oIkf3bvb
	AsBMLSwsrw9AEO1p8kol9Su3jVGQCbqWVxJcx43h2KCMzC8yo=
X-Gm-Gg: AR+sD11ebpTbndwm5FYuEMjcF5ZVf9gDgqWUBhvlvGZVZawqj1iDwd+kgir2dilRYK6
	pDd5AmdS+nH21Lf3TO+/42FmhoZTUYF9hSykhT6LaPoChQ0gqvp4borg+qXye77gMnBvq9dAh01
	gasD/gY1nXOrpzI2/6az5pLz9QP+xntOtBu6VRyPS0FOuUmbBrkeCePu0i/BU/4b+SODeIM+mqT
	UjSNXGQJDtFDLjDg7jTsNTlUxeuzKHnjV9AprKh97FB927LSQqTaS336/b4eY9W0RnyQgS5wZwx
	/iifPZaKjVGMVlBiUJGppPge9fFdFhdzcwGwzikk8aw7uBfR/mBfgU7KChwFmoDQEoTbmLZw5Yg
	et89EboZeKVcQthd5e+HgLmEBTyqsqjX/biWXIi0uE/KoEG+n315UOUZ1VrMzQVvBug==
X-Received: by 2002:a05:690e:140d:b0:66c:a3e8:be00 with SMTP id 956f58d0204a3-66d257ca593mr2111685d50.45.1787758339573;
        Wed, 26 Aug 2026 08:32:19 -0700 (PDT)
X-Received: by 2002:a05:690e:140d:b0:66c:a3e8:be00 with SMTP id 956f58d0204a3-66d257ca593mr2111660d50.45.1787758338829;
        Wed, 26 Aug 2026 08:32:18 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66d24592f24sm1598209d50.6.2026.08.26.08.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:32:18 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 06/11] smb: client: fix OOB struct field reads in move_smb2_ea_to_cifs()
Date: Wed, 26 Aug 2026 10:31:42 -0500
Message-ID: <20260826153147.4112943-7-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826153147.4112943-1-sorenson@redhat.com>
References: <20260826153147.4112943-1-sorenson@redhat.com>
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
 fs/smb/client/smb2ops.c | 25 +++++++++++++++++--------
 fs/smb/client/trace.h   |  1 +
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9065c94e5ec6..efc68c7aef8a 100644
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

