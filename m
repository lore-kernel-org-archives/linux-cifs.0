Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029544D6AC
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 12:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783514255; cv=none; b=GDQpFgnPrcP5b2EotOH6oziXPW9YpOaUy01Oke2KHK7BHedL68keit0SgGeyto6AsSPkDn1jDu3BY5BR9BH0BdD073kLKPtfryzntEiHgYFwjmxXKxY4Yu7FCZ+MNXizygX7IqoTYgPuVVREQGMSa1rFCGbVEGP4+GElwDa31Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783514255; c=relaxed/simple;
	bh=04uYqpWZQ/plXMmcyu7t94cu7k6D3kzwu3oIbsQumfk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uQk8r2EzMMKOPV4oZHzxDPcqsrfr5rWiziCsfn5Cb5ipm4VZO+hh9S4nDYotjo3oGMu7bNZw+jEpA/jcH9UPROVNotbKmujWkjjCpfS3q+lB5pW/aqXlHBtK6+v+0AogO3CUknGsWK4GEP320lmoDCdVrUFxB/Oqtk2O2clbRH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hFVG+Qtx; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hFVG+Qtx"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cc97653887so6894785ad.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 05:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783514252; x=1784119052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8PAS6PBBdlQD0VB+aSPh5lpk2Y8XtUDXkF4ggRU1JMc=;
        b=hFVG+QtxPWOZLG6c3pjDZSoplmTskK4BnkmQmU6hqcsRHu/CFt9v8FvJpOaLvd5awF
         em8N+2CTdRdno+a0xvhrAjMN+2sE63p+fWLsBaQOdp9FdHFU+c73PRGu1/Kk/Hjr9Jf5
         lBrImB++JczyThCVJqe60zT/VwT+yZ4eO5AmIlWcmxOZXUyWpaeEvD/xVXRyBZpWAgMa
         oQuXg5piT2Yl4uBpP3ZpQtvr90BjQQ8v2jox7ueU2JedaaphYr/BoSTXhDw1Kd1dQozJ
         pQPj+YeBNTX8RhAfidwaDcDe1pLoE7xDPPE4BIiUpqaBpm/4LT32JT/gNg5+hHpCZKkO
         8Usw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783514252; x=1784119052;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PAS6PBBdlQD0VB+aSPh5lpk2Y8XtUDXkF4ggRU1JMc=;
        b=qUTWQPkv/6+mLuTkgLt20BD+sQDqPMdwoPLI6a+Mr7iu7D1rVO2yemC7SmudqA55uj
         /bqfLJX6r8gFCaS0G7HEtmxKKdJHqzQ5skYPDLddjQRstHTvS0hX+2jmTjNrMd3Ojnov
         5DFMpFHIX1UCwzi5hv5qEUTJRAbilWY8C68zdwnCp3CBGjD5DOpFSAeyLfqof80wYi9J
         n3Kex9MUZycJJycBNsCUFrxEZwC49dMe7gQvaq9XJjs+UI+bAK/Wg8avtoFUU67brGKM
         XY7BOV5h41iccPTZImga4EJzMtBt5RX5JpMQho9D5ibmbGcs0uIMUNXtKldHIiV48fqs
         xUzA==
X-Forwarded-Encrypted: i=1; AHgh+Rr9B5Do4ALqki9q2Xlb+YKRsMDz5jR5F2fBeb1/GmKsjWjzXvoZg+DBYpM3OZHJ6sr5lVCYUhw8t0r/@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7FOxZPS+uYDYT25jeTAadCofyeR/ThlwPfrbH2K0obikWUQYn
	lBBnrC+EMSBIs5tjP1uy+FIc0hW53YdlZpMbod2+ns8OUmQXrfKwYIR2
X-Gm-Gg: AfdE7ckP15XaHXRwL/cQdUy0GXQWAqBnJjBBC19rvm0A9TyS9tsbW9UkOQrhwsYsK53
	LHO0/giZBZUcN/+S7c3l7ybATsV8ljV4FNkO/cG0NgxUUjSx7xNG0HhMP5QpWhMzfVZVLzo8eLX
	biUHWWW4B+9HqFY2Uo6R+30IFLeQdKoy6NzgScMHb90RRrQzLo0GXSMtr0Ww63uzkWVjoRsz2R2
	zzEG7eHC2O2TjXZ9ei2jJ4oS/wlMJus/OCt3D//x0X1WcpPCH2naLfBV0IPxu8PQjgOzET70FAM
	/7Ot7J3pS7wqavC+TPw/tI1BfKbayGRBMaJLn7CNus3PvdbSbegQjHIGNgeWI+GdBPhJJkXx468
	ajbG8SUA3Bv7V0tWTr1edlxP6KFucsfke7rRwCLDYGL/T9PziTnaTzVC1PSii6Cpa8qO9xsU=
X-Received: by 2002:a17:903:1247:b0:2ca:ecf6:910e with SMTP id d9443c01a7336-2ccea1d220amr26916725ad.0.1783514251703;
        Wed, 08 Jul 2026 05:37:31 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d5bd2fsm27285895ad.78.2026.07.08.05.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 05:37:31 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] smb: client: fix overflow in passthrough ioctl bounds check
Date: Wed,  8 Jul 2026 20:35:20 +0800
Message-ID: <20260708123520.761116-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_ioctl_query_info() validates the PASSTHRU_FSCTL response payload
before copying it to userspace.

The payload offset and length both come from 32-bit fields. The bounds
check currently adds OutputOffset and qi.input_buffer_length directly, so
the addition can wrap in 32-bit arithmetic before the result is compared
against the response buffer length.

A malicious server can use a large OutputOffset and a small OutputCount
to make the wrapped sum pass the bounds check. The later copy_to_user()
then reads from io_rsp + OutputOffset, outside the response buffer.

Use size_add() for the offset plus length check so overflow is treated as
out of bounds.

Fixes: 2b1116bbe898 ("CIFS: Use common error handling code in smb2_ioctl_query_info()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 06e9322a762a..fd2d55df2c86 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1772,8 +1772,8 @@ smb2_ioctl_query_info(const unsigned int xid,
 		if (le32_to_cpu(io_rsp->OutputCount) < qi.input_buffer_length)
 			qi.input_buffer_length = le32_to_cpu(io_rsp->OutputCount);
 		if (qi.input_buffer_length > 0 &&
-		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
-		    > rsp_iov[1].iov_len) {
+		     size_add(le32_to_cpu(io_rsp->OutputOffset),
+			     qi.input_buffer_length) > rsp_iov[1].iov_len) {
 			rc = -EFAULT;
 			goto out;
 		}
-- 
2.43.0

