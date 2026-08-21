Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3092A4A2E2D
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322607; cv=none; b=LoyixVDfZXVh+d4XXXyboG4XP/457SJlWC6SxJPJ0II5yH7AoTOC5SSkE+rsuBLjWyoQ89UOMnY/IxHua1+M2umoClhRl+kCM+bRbQIQWZ+sxrqpcRNJcxiVMkN0VMtm577u7k3IoMRsB+WogT24jdpT9JoJ6fwMzs1nLG8FS6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322607; c=relaxed/simple;
	bh=MqTsNi+pWWcsqzilCVqeOt9X0DrwjNhs3WYgNXeE96E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XtQFGxoRX1HfXGBjomKW/a9UYfKkUPQRuIt7H47vNlO+x3Z+j6pYbSBUnkT6U69r9rkBJthINk7XXrfuEadNudgbAQRAdSvv9HkMBIu5yf9Rr09dwP0HsGCWg1I5ndBFFbiqG68iij3HxhNmR9FYb0a8E9Z33d/Dlod9mjv6HNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dl7GgBtb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kp3mrcbj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dl7GgBtb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kp3mrcbj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787322602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LoPUMEzF5v/31a3ileSqz/j7rdB/qcT6gvg1SqPd594=;
	b=Dl7GgBtbQm+zm8ezV7yNy4sREpRuE4HgNioBCJE5tx0xspOQH5xuSYQeHeqZmyQ2HWuLr8
	B2RrdA1mJ+PwaPoSG1fCgxoE9aXgXxX5DJzoA0EWtQmg2fO87jnoOn47UTySsg38n7GyBE
	6PZDgwGwincrbTFrUcfOOdN2hTCUzlk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-tCacHSl4ObuOQ-5c93t72g-1; Fri, 21 Aug 2026 10:29:51 -0400
X-MC-Unique: tCacHSl4ObuOQ-5c93t72g-1
X-Mimecast-MFC-AGG-ID: tCacHSl4ObuOQ-5c93t72g_1787322591
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c19493ac2so11606321cf.1
        for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 07:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787322591; x=1787927391; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LoPUMEzF5v/31a3ileSqz/j7rdB/qcT6gvg1SqPd594=;
        b=Kp3mrcbjdGVUSqjOfYR8hcz9un8uZ0Z8eJ7Un1rkInhXYl59R8djk9y0x9djG9iFD4
         IfB/YNhGk8qe3XgIXVDQZZHcsqjAa68RzI+YLb1171lI+vUyst6UDllEblpcUq+3G8ze
         KE1D8V82nT2TajrgJwUU//vBar+1e3wjWKztRdFSeqdA02fp0iqNZtn54T9WuDe2trIh
         /kS7fuRfXyJr5MY+NsrPa0nnsGp3pmuiJj8n658Dyy2Sqy+a3ut1QwbIokIQF5E8Xgfw
         s7q4JW/95A5Ngot03bETk7IvvURhBVkV7P1AFiY5Yr4Mo9X8HFfoXWESLid5MNO7rIjK
         kvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787322591; x=1787927391;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LoPUMEzF5v/31a3ileSqz/j7rdB/qcT6gvg1SqPd594=;
        b=OlfpKM2gqiI2BAKm1Il7KCZvvCHZ/GSmbNTu18GEMKEgRPVgZ0dzvftlA3FF0mnvHf
         2d3WncuPasSaWoUODuwSUQCNWC/n7WG0xnO2aZzenbPikXAq4zE0IvZmVW5VTVoma7mD
         T+UoK4daGaG31O/Fn7BuCpoZbnwv3luMS/R/IIlu3GE8wowAqN0WnhhTT5IyLrCM2qOc
         bBWh22DFNtS2d0+MEQfG8EEL4lkgU7XJqigB6Yp756DaIKafUVx1MBI7LoLXptAphLZM
         K8tgyJwafTTphSydWeXZxTtfMLx+5qodjVJGMGfYhtqyegucHQA4yoBRORmw+EeoVrFq
         Dgng==
X-Gm-Message-State: AOJu0YyDeixx2G8wzANq4CsdL+ydEFiwpBkNLki+/Ub0OC/NTLjdq1/q
	RuwV8Umpbijz+sQANwB6GYZo4t4b45dxxRidrB54UNdUT+7u89s6Sgn72IV3NcgPwDEPO16BxFN
	ZyCvFE0IuSc5qQJ/Ysf7aXIOI6enSriGwYB9sPeDEbyCmWJGg31EYdkM3an6iVN33gQZMy+Etv4
	lVjiLWgh1Gk6JjkfefYCPocujn8bkIzhLF8JTBR1gMb/BAqps=
X-Gm-Gg: AR+sD13weNNPTJOuStHQQxFsCF6PZ9g7Lyt4b/+7roBy4pRSV60iT9/gAxVap1H/Byn
	SrD55CooDjjrjVBkWDw43cTd5xXUD43RA0w+8caj1fpcSKgBv6HZ6wKnaD3m1LpKDU2myXpZoXd
	9Nt2YTjDPUdFMYJ8cMcqr6w5DAUZAazy0cTVKLzcMbO10BxKx8rHfJAEr3wgqtj6couSN/B0QYT
	I4+tENgBqQo46L2AxAi+e/+RGzcOwW3ujK+jc5x6f9/1vXtCzx8dgzjdM8C4/W28EZRTp/rPVH6
	19ZdqOGYrHGwhK/XcRW0dtITXQQ1Sg+aFetjLPKqFRpqukd/E90MGDey9f4TzW7aSTHXUFpOLYc
	dMIC0ihh/G7Cu8wEr3kC3m1P0PF5uvFkH+ZTKxpdr0h/nuz9/p/XcqXZzvHhSQJ1EyQ==
X-Received: by 2002:a05:622a:1f8e:b0:51c:2135:b00a with SMTP id d75a77b69052e-52df5bf8884mr63070981cf.40.1787322590793;
        Fri, 21 Aug 2026 07:29:50 -0700 (PDT)
X-Received: by 2002:a05:622a:1f8e:b0:51c:2135:b00a with SMTP id d75a77b69052e-52df5bf8884mr63069951cf.40.1787322590049;
        Fri, 21 Aug 2026 07:29:50 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2911a5sm63285396d6.30.2026.08.21.07.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 07:29:49 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix OOB array access in __smb2_calc_size() on unknown Command
Date: Fri, 21 Aug 2026 09:29:46 -0500
Message-ID: <20260821142946.1728452-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

has_smb2_data_area[] is indexed by the server-supplied shdr->Command
with no bounds check:

    if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)

The array has NUMBER_OF_SMB2_COMMANDS (0x13) entries; any Command value
>= 0x13 reads past the end into adjacent read-only data.

Add an upper-bound check before the lookup; commands outside the valid
range have no data area, so treat them as false.

Fixes: 093b2bdad322 ("CIFS: Make demultiplex_thread work with SMB2 code")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2misc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 9068175e57cd..26b41ea3b72b 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -451,7 +451,8 @@ __smb2_calc_size(void *buf, bool *have_data, bool *data_area_overlap)
 	 */
 	len += le16_to_cpu(pdu->StructureSize2);
 
-	if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
+	if (le16_to_cpu(shdr->Command) >= ARRAY_SIZE(has_smb2_data_area) ||
+	    !has_smb2_data_area[le16_to_cpu(shdr->Command)])
 		goto calc_size_exit;
 
 	smb2_get_data_area_len(&offset, &data_length, shdr);
-- 
2.55.0

