Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE68434F24A
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335935; cv=none; b=lxvoY5yvklDfujhxIO8m2iJPRe1lCaO20I19LICSgOa1pgEIvpeskXpwQFoiHrwWLI3EX3T22NWzVqeaRQWv/r7hAQ3PrMugC4Hb7UsxSoQ0l5NHuMZfufDvQimi9NeLrPGbpyo8JGF6Yc7m7UTOWkLJw0zLi8pDpq9hvBY6hvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335935; c=relaxed/simple;
	bh=N/N75PTpR6eje2R7nmSe0Hk72+yIz46S4Yy31gQvFhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLw78lGUYf1r+XXo3WQjStVekNWcED3SHVsnKCzkPanjSgZpYM5aBWUvUIrufVSkhhnKUr3GunCX/AecObAb38CYR+FwPeYUYxQ52lWMKaWyPslu1dcp3e3Y/9njS0j3cu7Bl4SdCORb2YocBWydyzu0mHUewZvpTVBmJOlmogs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MPSP5Y+3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OnPuDKYZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MPSP5Y+3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OnPuDKYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789335932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WV7NW23j0Upl0DBt56PnTdjoLnNEhTrt48kDmiyvSlI=;
	b=MPSP5Y+34IWKPSVYN6EQ5ew+d42FtqoxEgb9szBPxomsQbMY1pujbeBNPdkWbMCgvn21Kr
	gtEfJBBuz/50bElkM49OvXvMxPbFrd8viC7d6pUHFydQOXwtCjsVMkpyO/HvfL62PwYoJT
	FAzbEm8iVDkcZ7gd3+uM/hd/7IVUnVM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-JwAY70ZKPN6JQ93P-_ggpQ-1; Sun, 13 Sep 2026 17:45:30 -0400
X-MC-Unique: JwAY70ZKPN6JQ93P-_ggpQ-1
X-Mimecast-MFC-AGG-ID: JwAY70ZKPN6JQ93P-_ggpQ_1789335930
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-90e869793d3so55431226d6.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 14:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789335930; x=1789940730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WV7NW23j0Upl0DBt56PnTdjoLnNEhTrt48kDmiyvSlI=;
        b=OnPuDKYZl8vpEJKbIubG3B1Z1sGgsHqQiRmq8E5m6mjLz88Ol+tXWwnJRjhcWagJYp
         Rrt2tJhq5cFgM601c/3dhWSNcA49SylAvOFmnoRtdsm9UecYbbn9vDsp8fQMeTMklsh7
         aAldiLdA/W+BtV70gJ5sT6gHYS4NurU/HIRVmjXAZ48nDwPRmQ2cH+kbRbKgOD57s5tZ
         gmq8HsSm9YCjUvJwy4MmzwQF5Ct4lZk39kVe1R3S8l8fogVC3UWALdriABwscOv4+6rG
         X12COCWopIiC7THz1VgDu1hiMOv+wlVUjhxDHNanexSRmHT38j7zF3znNKSZx5ZEvGB5
         ESFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789335930; x=1789940730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WV7NW23j0Upl0DBt56PnTdjoLnNEhTrt48kDmiyvSlI=;
        b=gCpGOXx5xCDqPBV53ays55dKvbc9sIy14ihHDDlAiZ551Ebzq5BCZlIdszKQ6bXdZl
         GRXQNBZBg9hXbCjL/kxshNOANaufvxlO/OUtKsXMW+Ck536aSq6cvB+914vuAL4euiLm
         eqIuUukBi1eDoYMajX0acI6NMidVAzRariksb/c4qGqFsEl/qo1Z1z/bp4Urur1SzKJz
         bY65CRitcCr1mk3GBdds9qmv8Z9ocpF9PByLfUAegGH8hWni5YYvwXYDTLHrT6nt9f52
         11Hv2FfUG/+iLn/2r4yr6LDsbjB+ad88hLyWEwylTDeVIf61W2AlNS79h/6QTpm0sgGZ
         BMnw==
X-Gm-Message-State: AFuF++kZUbIpVQ7Hi9OwUgyXYNlovnGkPWIMCYU3S7ih7y7my8zA2fPI
	pgW4rwVrhY3OhfhLUDbTwfpvPOliio/z+cyxlxXjXu1/Bx9nXIihLiLVFHmB/INeEJMjjKZQaDS
	Zn6EUoVqC+eYKC1YjUu7X3cAoVsidl5+MfdpB6iob4cW/9gmYuLYePKQv+zqRmmwXV/v4ADNVp6
	aWeZLE7hU2wbgCmAQCfdqIbkaNc/uL/Xx8/iWenxSJNMfFI8Q=
X-Gm-Gg: AYBFou2vDLemIGwE1RIsYd/7qrsP1K3KUYpgR5TAD3i+g9krUmVlr6L+sS6T6as9qCI
	tjqGwnWUyrzLYBazCXz3+z9FRJPqjbdBbitoV0Gtawqy64ekv9UfsGHuhTwi29t9SYxqCJTB0xS
	VPaVPPcyL9Qv3ZLG9FzKaVhnfJ0/+mw6ObmXl8u0xW/0QcKH4sQ/n1ARc8KKSvd3ik1FPnplFsE
	gFluKZpqmp8sxKtcpYWM+yFROibtitjGdnqE2nQ1AnfGPj+L6uNsiUo9PO2CBhm30jBRjhBexFR
	Brh3owqW96LeaJLpaDFzOQCsR/DIv+dJVaSlEkqmhtqDc9Mt3rqoLMxrwgXRc7foVqBA0o1Rf6Z
	Wpy/cpETLLBdMlhearDplIfXBiRVVOV3XS+p+IQvmeVmdtWUaI+paP44UxvfmUdnMmA==
X-Received: by 2002:a05:6214:1315:b0:90e:9a7c:e5a0 with SMTP id 6a1803df08f44-912120f0444mr213952056d6.17.1789335930237;
        Sun, 13 Sep 2026 14:45:30 -0700 (PDT)
X-Received: by 2002:a05:6214:1315:b0:90e:9a7c:e5a0 with SMTP id 6a1803df08f44-912120f0444mr213951596d6.17.1789335929572;
        Sun, 13 Sep 2026 14:45:29 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f49444bsm78581126d6.29.2026.09.13.14.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:45:29 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	stable@vger.kernel.org
Subject: [PATCH v4 08/10] smb: client: fix underflow in is_valid_oplock_break() notify offset check
Date: Sun, 13 Sep 2026 16:45:06 -0500
Message-ID: <20260913214510.3071370-9-sorenson@redhat.com>
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

The bounds check intended to validate data_offset against the received
frame length:

    if (data_offset > len - sizeof(struct file_notify_information))

suffers from an integer underflow if len is smaller than the size of the
file_notify_information structure. This allows a malicious or malformed
packet to bypass the check and construct pnotify using an invalid,
unchecked data_offset.

Fix this by explicitly checking that len is at least the size of
struct file_notify_information before evaluating the data_offset.

Fixes: 097f5863b1a0 ("cifs: read overflow in is_valid_oplock_break()")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb1misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1misc.c b/fs/smb/client/smb1misc.c
index cdfbbff24b72..a39c9140ceca 100644
--- a/fs/smb/client/smb1misc.c
+++ b/fs/smb/client/smb1misc.c
@@ -86,7 +86,8 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 		if (get_bcc(buf) > sizeof(struct file_notify_information)) {
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
 
-			if (data_offset >
+			if (len < sizeof(struct file_notify_information) ||
+			    data_offset >
 			    len - sizeof(struct file_notify_information)) {
 				cifs_dbg(FYI, "Invalid data_offset %u\n",
 					 data_offset);
-- 
2.55.0

