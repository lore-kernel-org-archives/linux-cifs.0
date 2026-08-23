Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE993A4510
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511538; cv=none; b=anQIlGweb1/hZIV86xIJr2mEeC301HuqSOKq7NHgKWnEpd2b4iHc8hR2GZsnGQ+vRCNXLZtUT6MCFAdEcEok3sc4IyiVzZ7MYmfuZc8WxIPP0uhOePwAVYdcPbN+y4QPPJvINDNpXOVrrfmRDcsEbPVxDkdoiSi40fkhxI5pges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511538; c=relaxed/simple;
	bh=X46Y9UPqaWEp+RoT8wQkeUmW9xAe3RHJI41PgATF2Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiYPOq038BGQ27stnMACjh+PVuQNXiBt+kqJ47CSpvMY0Nd8NKXjg8LK1bT4cKoYAdxUkaURlQnQV9bQ+KwgHZeF/K9pJpCWYU4td0VGc1POePBTSpOg6FASOJElrp6ADvXgavVqktPDAX8CBDySBX6UKAoW3cYcWZD/1KEcOUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a/cjy3F7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oy/4/4DJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a/cjy3F7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oy/4/4DJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Dyg+7DU0ehSVNy9gSlT1aHAOzEStc2HXXCnV8WDG4E=;
	b=a/cjy3F78lEzdHbImaYBIT6gM3w4MYQ+kiPJ9THldfiXJJ+f01LoeTvfX/KQN4qsELsTY3
	VLhrJCcLpQO2yzib1Fh86cqVtZyDRzAei2JQEDYk9PlCW5rDxs4yZAmgQIxE4raHgwCoDb
	ZjWar43mO4EjQwxVOhZNr2Rs8Aax0B4=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-tkwtOwl4Mum5aLC8FGDksQ-1; Sun, 23 Aug 2026 14:58:54 -0400
X-MC-Unique: tkwtOwl4Mum5aLC8FGDksQ-1
X-Mimecast-MFC-AGG-ID: tkwtOwl4Mum5aLC8FGDksQ_1787511534
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f43c6b6d64so4343857a34.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511534; x=1788116334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3Dyg+7DU0ehSVNy9gSlT1aHAOzEStc2HXXCnV8WDG4E=;
        b=oy/4/4DJ+LGy4AQxaWI9lrLx99M7F9ZUu1v6v3G/er8ol5JfHJhPSjgYLExm9fISkj
         GfcYyfpxLQ6+62hxZ5bHeei2YV5DU3iJmTDwlrvAieB/cOJJGxC0Hewrr9Sz17G5QGps
         TEkSwtR2lrioRwSSwlYkvBe0Jjalpm+XwEe/TnrI4ltCvvEXEWsP72oLTJnnFx0ZeYV4
         pQtM90OtgHTRYPiaz5JHYcNUfWDgiIlt3h64PiOyotscDZru85KWGiz7kcq8PqHoMbqY
         qlEEoafpTj3jygLB/9x3Xi04ao10pkXvhueFmPvCwmKXz3RI0H32GMo/LgDPnmK7VSgo
         veQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511534; x=1788116334;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3Dyg+7DU0ehSVNy9gSlT1aHAOzEStc2HXXCnV8WDG4E=;
        b=i213OzFH1/A9+PkOjDNlDZt9qPCT+LaF1zXZzF5Gib1UxuzGHG8tNTzdXKF67TqtJt
         ti4NqbtFXUOUXgFlVa80s3uv0484P3gH+1qxp+8bNeNhYXVDgKT+KDexFZy7zI9btxyf
         HalrfBAGVMRaV8Km+krpJGGNPhlAOlxxwYlkm8OM7Mc5Y2Bg9M46Cq2C8elg6zBrH0sw
         TfPaZGl2wobTNlTxNrUAfqJpozQrreJnvPUMea9ZqTrCanyVYRzhNtcc73+4TRnvUQEl
         zG80K3ZfKbAFPCu5DGqFxin+0BehjB+ho90Ra/1qzxril8xhuLCa+p8UknYxOpD1zkH4
         4GlQ==
X-Gm-Message-State: AFuF++lVdzV6qTCZVVGsaKxscmjjqIs8haG84OnqVLy0sUtiZk13iy2d
	Ode+jpcbC3OMKDcNygD+KrYkRk09MrPlvu0GBl4sXdrctSzc7VW/rK0WQ7dHidNmSVi3Bh6HB6W
	YmoEMcyP4uhQ4rHLwxJpxwDUO1Rb00XouVhC+3vBKedc+YJzYniri2u88E/maunDSp4NPMTDqxM
	D3FNm4yQUyu8OemgMyUC4SqxfzMuFxe769hkQTFb1QribY7Uo=
X-Gm-Gg: AR+sD12rhIYDjT1sqcBS4Xe1GmVMruYdtRyqeWMfEZtGWUhacrs8GglQJPkbHoPF20c
	uf6YMInB4AOQh1CP2B3Qpns00E3NZf0X/VJPijeOrQkbywinLMds80Xeij6urkhDMz9fo9YEA2n
	thMyo4ME7ymv10fcM0E0bnispztbB/i20KrGWZUHEMF8AIuOLAPICi2hPevi1c11bmHIQxZuRIL
	OcgjTGdc16/EpPXRKz7mmsykMPMMmW8CqtsF4GQqldugw1x8MC7M9HzGq69f83hrVR3by9s5569
	1bv+0sqETkFncI+BbmSbPeLkB5Gcr1OXVAlkWd5NQPmc91ljHUSlPqhFefjs3xOm0mZJVClyv4c
	aF5gDzw5fOZAfahii9vEL5R4DRu51OBIiuMNEHUH3i9jF7r1GyhUJLh8f98De2tgfPQ==
X-Received: by 2002:a05:6830:230f:b0:7f1:ddf1:c731 with SMTP id 46e09a7af769-7f461783f38mr22246363a34.13.1787511534089;
        Sun, 23 Aug 2026 11:58:54 -0700 (PDT)
X-Received: by 2002:a05:6830:230f:b0:7f1:ddf1:c731 with SMTP id 46e09a7af769-7f461783f38mr22246331a34.13.1787511533539;
        Sun, 23 Aug 2026 11:58:53 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:52 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 11/11] smb: client: fix NameOffset and Next field validation in smb2_parse_contexts()
Date: Sun, 23 Aug 2026 13:58:07 -0500
Message-ID: <20260823185807.3115901-12-sorenson@redhat.com>
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

Three related bounds issues in smb2_parse_contexts():

NameOffset: the existing 'noff + nlen > doff' check doesn't prevent
the name from starting inside the context header or extending past rem.
Replace it with noff >= sizeof(*cc) and noff + nlen <= rem, keeping
the name-before-data guard only when DataLength is non-zero.

Next: a non-zero Next smaller than sizeof(*cc) passes the existing
upper-bound check but creates an overlapping context pointer.  Add
off < sizeof(*cc) to reject it.

Dispatch: when DataLength is zero, calling a handler that reads the
data area (parse_lease_buf, parse_query_id_ctxt, parse_posix_ctxt)
reads stale memory past the declared context.  A rogue server can
craft a zero-DataLength context whose name matches a known tag (e.g.
'RqLs') and bypass the name-vs-data-offset guard, causing
parse_lease_buf to record a lease key and state from uninitialized
kmalloc content.  Gate all three dispatch paths on dlen > 0.

Fixes: af1689a9b770 ("smb: client: fix potential OOBs in smb2_parse_contexts()")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2pdu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index dea05aeb53a1..dda7a1a88b44 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2459,22 +2459,23 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 
 		noff = le16_to_cpu(cc->NameOffset);
 		nlen = le16_to_cpu(cc->NameLength);
-		if (noff + nlen > doff)
+		if (noff < sizeof(*cc) || noff + nlen > rem ||
+		    (dlen && noff + nlen > doff))
 			return -EINVAL;
 
 		name = (char *)cc + noff;
 		switch (nlen) {
 		case 4:
-			if (!strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
+			if (dlen && !strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
 				*oplock = server->ops->parse_lease_buf(cc, epoch,
 								       lease_key);
-			} else if (buf &&
+			} else if (dlen && buf &&
 				   !strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4)) {
 				parse_query_id_ctxt(cc, buf);
 			}
 			break;
 		case 16:
-			if (posix && !memcmp(name, smb3_create_tag_posix, 16))
+			if (dlen && posix && !memcmp(name, smb3_create_tag_posix, 16))
 				parse_posix_ctxt(cc, buf, posix);
 			break;
 		default:
@@ -2488,7 +2489,7 @@ int smb2_parse_contexts(struct TCP_Server_Info *server,
 		off = le32_to_cpu(cc->Next);
 		if (!off)
 			break;
-		if (check_sub_overflow(rem, off, &rem))
+		if (off < sizeof(*cc) || check_sub_overflow(rem, off, &rem))
 			return -EINVAL;
 		cc = (struct create_context *)((u8 *)cc + off);
 	}
-- 
2.55.0

