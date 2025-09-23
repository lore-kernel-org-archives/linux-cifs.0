Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBBD1DE2A0
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 08:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758615498; cv=none; b=RSlI7PM2V3BJG4xV7b3hBIgsRev4YRnvIUKZLpX2gMVuRqU7WLZElVvFK4+c+fDlDnDSTzU7KsdjJkotgsr3TKw0tn6dd7NCZwBbdTb5oBFLRgoWNDnPsFm+U+cmsb6AyDow0MkUpG3+YxIOm1n1F/MtuVFqHa9DdHV1ePPPAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758615498; c=relaxed/simple;
	bh=z0Kwgtiq66it4UMXF0pNQ3Se0nVNIVZkH+W1aJZyaAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lgCxQxlDmurOy9in8+74eoNVG+uUlPE3zWBcH0W4GAjzOsH49vzrATz2KPmb5hSgJ7PMM9cH8VbFQtHKySo3NnA9L4GXVLUbjOWP84vxiT0FQg1oi3nG95derF+y0klMUngWJjis2LZP1uvFlHEfnn4wjtOoNHo/l4xkL+PZyHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BDnca5Tk; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BDnca5Tk"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3322e6360bbso2501118a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 01:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758615496; x=1759220296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YUkaPyyL6AFfnJMjIpQqWCA2oE1zoPDVeRYEUkwFkPw=;
        b=BDnca5TkuDKDHsuYMg0PkAFjAoABIy53a2VL47Ws2dRoxPlB3FEQnkF24mJquCFOga
         5cxzD6inaRbwi9lBT5fCemPAyKpXjvKXk7SWHti1oSLQUXhw6gqU9BaFXKpAhmEoc9mL
         kQBISqtNB+ZnT2Q2D/x+WdHLg4g+6sk45TiumIDcy1Biz+M7VQVJ50L5duyJ9M1F8xGE
         o2vw/q3C926v/eIQO/3Q3Ha4My517LkCl/pRe2Dc6+adtARJxahbU9gD34zrnkf50agt
         HmaZgbo79295d84HhjHcz9hFQRMi/yuZKfTe3jtTEOdBBrO/NaOf+fYrhZAfiV8yhBqj
         1LpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758615496; x=1759220296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YUkaPyyL6AFfnJMjIpQqWCA2oE1zoPDVeRYEUkwFkPw=;
        b=sae0Jrt6DWmDLbp3e8aXbNeAuBnf0c1o9gGwHNG6Xbdv/YrrnZTio2k2/PGFzn3nZm
         bkrctPV/M9ZFx9+Sn3HwbmZYkBNYKqWqmB8of75OVRu1ddG8QdzLqEqQp/JSviMLM7+j
         ibnfhGSAVCb7KZRQI6eBZZdqKoTJs9I+k3CGO+aqwmO/ZeIMpXPjZF4XkynCxpjTixxF
         aB2aY2qOHWn6Ox/LbtDUVcfShAwDIoq7cNeJ0rjailbBo33fFQoz3VytBMLGAY0s2Iq8
         G69rr/InrV1ntyPOe64jBZqM/xQlFY8Kfh12HUdWxayvvZVNfG4oZZlrwc/tpb5GUFwj
         /I5A==
X-Gm-Message-State: AOJu0YxuUy+8/PLD6BudsPRixkLz08eseMQECFievW06zvt2wWJoE/A1
	Mg47arXbiWDf1oXUdKUwQMTaVgJG349WM9P+4r6a1KFJDQFyrdmd4QvN
X-Gm-Gg: ASbGncvE6S8a02Bk1oO56cczotELygI897iqCM/0Mvv1asMleR786QVVd6V4H92RmHm
	5KGYe4MtwIcofjgA2i6UFpOjL7m6hR0LZElI5mj0fMAJ0vwt60KDrvTlkTEYn65/3fumjUQcfC3
	zD3W9vcl9ZWmfTWhUc/JLVdpuSvMY1snFBjY0edf3d6Goh38Ge79F7aQ9PHzfMy50DPMeNBC3++
	XuJYGcafAKjvMK8yUJdLp+6CS/5pDdxLirTmK2rGsCLD1ROis5VDcyyyDMoiZEWyETdO1rH+KDL
	733mFJ4bpGjdjNQUM4LyiX7iZq4O+f9CpghfxLfqCfSkHk1VBXOsffsiuKLymiqVdKd1U2PZuL6
	Pt6iYodaiSM9JXiE7bDi7nHyuiHE=
X-Google-Smtp-Source: AGHT+IHnv2PpiWhjp44rVS3D6dWwp8LFZeraFg84N/MTZ+hM3oMgyC+K8cNvHd4Kp+eTcsGcgpYfSQ==
X-Received: by 2002:a17:90b:3ec6:b0:327:b2a1:2964 with SMTP id 98e67ed59e1d1-332a953388amr2531198a91.15.1758615496385;
        Tue, 23 Sep 2025 01:18:16 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f335995cbsm5955477b3a.63.2025.09.23.01.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 01:18:16 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH] smb: client: fix wrong index reference in smb2_compound_op()
Date: Tue, 23 Sep 2025 17:16:45 +0900
Message-ID: <20250923081645.269534-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In smb2_compound_op(), the loop that processes each command's response
uses wrong indices when accessing response bufferes.

This incorrect indexing leads to improper handling of command results.
Also, if incorrectly computed index is greather than or equal to
MAX_COMPOUND, it can cause out-of-bounds accesses.

Fixes: 3681c74d342d ("smb: client: handle lack of EA support in smb2_query_path_info()") # 6.14
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
I was unable to reproduce this issue in my environment, but the code
flow clearly looks like typo error. I have not added stable cc-ing yet,
leaving it to the reviewers' judgment, but IMHO i think it should be needed.

I would be happy to help with testing if anyone can provide reproduction
steps or additional help on triggering this code path. Always thanks for
your consideration.
---
 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e32a3f338793..0985db9f86e5 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -687,7 +687,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	for (i = 0; i < num_cmds; i++) {
-		char *buf = rsp_iov[i + i].iov_base;
+		char *buf = rsp_iov[i + 1].iov_base;
 
 		if (buf && resp_buftype[i + 1] != CIFS_NO_BUFFER)
 			rc = server->ops->map_error(buf, false);
-- 
2.43.0

