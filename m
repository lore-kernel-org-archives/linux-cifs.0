Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407EE3A3834
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 18:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787511536; cv=none; b=SjUz8fl9FSEPnlmiOJkTK8lb3l0Ze5O+n8dWhkkceqIil4U1//4uyBqIlUWXybau9o2v88xx4OL1xhduijMm479cop94OapAeIkPHws+2yQbrYekz4JUye815lWoKAAmony2whc1o/9V104ZgYmysmlKxncAk3fUNLsQqctWyGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787511536; c=relaxed/simple;
	bh=34K/FoU7abAOYLlPQo+u98BXpk6bD/cNXKkoSIw24xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yxpqt8TH4gBxSzY5IrqGP4MELvhaOT/ftbk2ElYh5ixeIS9N6+ckl1QwroeMUpFUVlr4Mv3mfwMNXh7uJALhrPvSeMrYW7cAE1xzip7J52A+wKCa8t1dnJDuRY4+BHsBM53J5C7u06kJY+Uho7jxKRR4csnurYTTdPyu2RZLKJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X/nyJGXU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=m4F5QXUa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X/nyJGXU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="m4F5QXUa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787511534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MsXHiYkvLJ5Dfkmh4RbCEqIEWI8MfAZu25u27dTcaQk=;
	b=X/nyJGXUV1YwPwkIuJHK3gPD9pzOUASS07sm/YsvLBa0mxxX9iHGYg8G3rHEXnxBc+02DB
	bRxM37Fyfrv1ZUj/tt91nEy2qChjiL1SoTr/uuZX5qw/l89r/dDKe3Wuo9m2ByX8QBAe4X
	b0YPh4FpPbbdN5fDyGzUpbL7+SKqi7Q=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-LJAbQ50bNaeRojiueQoPuQ-1; Sun, 23 Aug 2026 14:58:52 -0400
X-MC-Unique: LJAbQ50bNaeRojiueQoPuQ-1
X-Mimecast-MFC-AGG-ID: LJAbQ50bNaeRojiueQoPuQ_1787511532
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7ec6685adabso6015138a34.0
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 11:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787511532; x=1788116332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MsXHiYkvLJ5Dfkmh4RbCEqIEWI8MfAZu25u27dTcaQk=;
        b=m4F5QXUaoYegkjQ8ZC53OzDS+SnoON7wOW3DM1Lj/xoR7TMULb4QkrQP6whDnEEzWh
         tOAk4p8XBPHtufjK0xiaEqcB89RL3s+3YPKRFxjGluwL8FPPm/jfihCFG1lXDw7TKtVt
         e/gOFRu71Ob/t++EVhVjafzFi01gV3uDG1tYA4fcJgQvTNYr2E+ffLJcfO1pnvfEm2ci
         BW/9h5RTiI5cyNTuD2sHGjtbLLyGlCbgmoxeTVpJSnxZvavV4xkvFqmKbUemNc7vbyQR
         oZo5ByKY5rZ2IZqJOutdUyjbYIsNiwgKnG4nBIXs/W4d6NZ6Y8Dq/MMMNNBCFJ3WZclP
         8NBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787511532; x=1788116332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MsXHiYkvLJ5Dfkmh4RbCEqIEWI8MfAZu25u27dTcaQk=;
        b=TmmfRZVG0z49bXrcGUCKRX4ZhBJmX2k57o7Vp8rrUtWwm6CReS424F8x5gsYrPAVWv
         eX03vV1HuIGwKd8l2aJpcG4On2n9n4WdZAMs6Zuc/qxri4Ap7AD9aEeq6Y7RWE6tykCW
         aBCv4C65Q2H5dqbmeVoTf0R3ZiwgRKB/TjEhqt5eb5fJQxOvqEeu7UKOtC/QgV/xGnNu
         FCtmbAIHVCRkjJKo8F4jBuH+VN/BdiJRka9kQ00DDE6R4hkQkPBJU139ySV2GjhDgP4V
         A7zMbGJP/bZfFFyma0ic+y8LAwFePdZTf9KIXWApqALHtsFAzo5CpyTrIBZXT+BXB3X+
         j6Bg==
X-Gm-Message-State: AFuF++lVtGPeKnTcrv1xH6r24WGZ9S+hGwq4zEVtUy0cln/RRMuRN44B
	uF27bBQiDlpdVKoKxKcWKeAraesY/gEVsd67Pmv7Lbl4ZTHAG2Bz3Z4ZiOZT8CeX3ITiI5gKBIq
	hgOYt4qAwIz1grne3bE6aR7RC9Kv8RP6ttVcorLYewsl1piUCIB0U4lg0M+L9MY+N3DO+g/TUNO
	Ywip/NJGvX6U8Enzbx0tpXpTbDyAqk+8nNmFeuNj3SncVAIRY=
X-Gm-Gg: AR+sD11fuGXrlv3sf7LtIR0YDUFTF7xp/P+7/TW9Uiec7QcaIZ8ImmPVlC/1GIIsvcj
	YsXJOB9jq7W+LlSDXOv8vzb/wlEUh7+9Y7xnhO4Id7KHoNj0BL7RdvdN/UZyVugR//AWTM9XC/L
	QXwNKqR4jOLljFcQxJXdpSOEZqjqNLftc2bF6IzoJ1JJxSLBaYM1rIxG8l4yMlwBnZeFdF8+z1f
	4PAA0lWCLT1pBsLworW2VeAR1ytMJeYpYh3insWUG9G4uX/Pw+EJwWobbBtPtoBLZ4Jf4Q0/H6w
	B8cs6wzLHuxPdcvdDwx6yATft18LJp0WVpiGcg3ZqcwiUd0OEpoNhq2EXZPeGlsVcMcDNxrl3+v
	ILqRrk/bVU40Xr+a2bMem+urcXHRwBfe3BtZxyCsbe96udzflvY5Ghf08nDLs3xtHxQ==
X-Received: by 2002:a05:6830:6aa1:b0:7e6:e385:4c1e with SMTP id 46e09a7af769-7f461311b5fmr23973825a34.4.1787511531989;
        Sun, 23 Aug 2026 11:58:51 -0700 (PDT)
X-Received: by 2002:a05:6830:6aa1:b0:7e6:e385:4c1e with SMTP id 46e09a7af769-7f461311b5fmr23973794a34.4.1787511531571;
        Sun, 23 Aug 2026 11:58:51 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f48fb1db63sm2518710a34.12.2026.08.23.11.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 11:58:50 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 10/11] smb: client: fix incomplete bounds check on reparse buffer in cifs_query_reparse_point()
Date: Sun, 23 Aug 2026 13:58:06 -0500
Message-ID: <20260823185807.3115901-11-sorenson@redhat.com>
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

The start >= end check before casting to struct reparse_data_buffer *
ensures the pointer is in range but not that end - start >= sizeof(*buf).
A server-supplied DataOffset leaving fewer than 8 bytes passes the check
but allows OOB reads of ReparseTag and ReparseDataLength.

Fold the minimum-size check into the existing condition using `end`.

Fixes: c13b779d26b3 ("cifs: Fix validation of SMB1 query reparse point response")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..acb533383a3e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3064,7 +3064,7 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
-	if (start >= end) {
+	if (start >= end || (size_t)(end - start) < sizeof(*buf)) {
 		rc = smb_EIO2(smb_eio_trace_qreparse_data_area,
 			      (unsigned long)start - (unsigned long)io_rsp,
 			      (unsigned long)end - (unsigned long)io_rsp);
-- 
2.55.0

