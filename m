Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794656986;
	b=uu/jWdv960B4qICWcmA3uYAtmWfd9aO7pj3YwoHsE0Zta1zli30NXBA3wE6khpPiUVlZ
	 v7BmJA2qSusxhV9t3FEpA+wT40/igmZF2Ds9RajThiXXsswKpi39Hr865hpe5HUMfdeOz
	 +ezFsYioZrYtFs1eBY/ZFLjNgfa1mSZgKaa5AnN25ryTPDlVDBpKAY1W7LbTIpwQB3mqw
	 +dv3R3IOObIzT+LB5BsXNgPu8MHED/pz3XlFWa4FXA9cqjmGV0/WbVg9uOYBysRDw0Hs3
	 4fLlTzB8BtirUq3xoRtwoWfgxP3s8u4vMV+7KtZh34xsZZkcoXVKI1YOYgT4ut9N06g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794656986;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SBkUY1cm8FOuS3mONVtBT6+r4R8usLgyPQkAfTyHpLA=;
	b=hynH6xeySPtdakNCbxh+dCXalhrzAQc3F/q6b8N34NPRHBlRelYPiXZzsWxl4snzDPrB
	 ZkXYqZ+9M9Zkytn88v+67256IKgnDLsjgXSLtXcKM+JQYvaHJrGOVphZRXCsaMGK1a+pb
	 ANuJdwrcHrrkuMxF4CB7nb28d88RVo7P+Qy4XYuyS3WSp/Vl+BY4Fx71jXxPT7oBbVIqf
	 tN43ewtAsKRGiZ6cw6XtIvv4HG5D4tgtGdfJd3LMVGAOfQhGRRSTl1WNIFJ4351aXzM21
	 VD3/B8ZNjRO0iJXPNwZbx0g/lXLzk+lO9UXeo5BqTfEIrjpZWI5KMNHFYWLg4SFAO8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloudlinux.com;
	spf=pass smtp.mailfrom=cloudlinux.com;
	dkim=pass header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=FIw3qrkg;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071F1606A327
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 11:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 071F1606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudlinux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudlinux.com header.i=@cloudlinux.com header.a=rsa-sha256 header.s=google header.b=FIw3qrkg
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso23259445e9.1
        for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 03:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google; t=1794656984; x=1795261784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SBkUY1cm8FOuS3mONVtBT6+r4R8usLgyPQkAfTyHpLA=;
        b=FIw3qrkg9ux8aDhj3wVhldGBe0oC3O8T88z58kmruFvtu8y/JyWeYfZAuBdrirwOTa
         BMUpPg/d3evscMt70nBav/KGTQCiI1x/DbAlt2bB8wXoW6ldtJQbSQcfQ1wd+6aVKSYF
         HS0pzgm1L7apqlW+esJ1yRZAEgKaTeP4Yh4EKBlqoYCophxz0tnUML62lSPSQlUMsOPH
         1UhmU/6uLthLe+WlRwjPVZw1MgrotpGvMD8MKVMEFAiu2bN8nXMdmHfGgl/hP2lOAl8c
         rNm5fTm36WH8Qi5ArHZ8LvlZpmbIIQjTBh+VDoUAT8UhfFkh/WQGIFnHjc+kUfGsUFo6
         /KqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794656984; x=1795261784;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SBkUY1cm8FOuS3mONVtBT6+r4R8usLgyPQkAfTyHpLA=;
        b=BdlEw98JW/qNlBrDr/msSAUlrAvUp8hWNIRwuTYhHAz6XOjThLKcpMZXbicUax7Qzc
         tErVoX8B56QczpMopwGExgynKUAswgE2Hxr81XZgFNwPdGI3qgkQ0Nj77cEGI+GB5xKx
         /vtPB8NHRZf8+QDPPAx2VOzmSqeupzN2xD9XY+6TN1hpG6Kbl4x6WxaFPIbIesm/kE4G
         ic7N2nNx0cVnQd72mWTVnD8G2Dbo0BgIjfrl5O7Mr9Ght1nUpptLdylI3JELCR+D3QWO
         VAKbeLModpI0Vwu0L9aoQPlWTvm2vyYYYrwqJ7F+99RsCXfffrX3ediyaDOGRYbsbBAn
         cCxA==
X-Forwarded-Encrypted: i=1; AL+hErGwye5mypuxBM+4lwF52RE16+AtlKLcq5zguaylmSjomyLR3vg9V7AINCZIb/uJkhSJr2IRAXMQPudB@vger.kernel.org
X-Gm-Message-State: APuU4Z9g0c0kvigLMJe0eB/HMddGqql6MX31RAe8JuvzXqGUbPnYBzWr
	u+LYxETxASjjiwYQ52wcflS/Vlcz/j+nb2Yp8D0jd+tTMKuhjzvr8mw2Y45sbEqom8Y=
X-Gm-Gg: AYBFou1lEUrZJpnafcSxjpYFW63FEX5M9o7hes4E4xcleMNaToSh3bYcv0enQiZjxaO
	aVBO/KeFWSmjNBIC6hABcmAIj+5H+anuZqy+6FtnR9iEL+38ZhSMdak0zJtf2vZ7qYlmgdZoIpX
	7kO6ZG07inuqHSay5Sl5+3MmLlrSPpGDTbtNZUBUCYl5CeGDLoZrHmzy/2AGfxZi9dXTdQgxKQG
	7/Kz3KUZ8PDtgMNNONxOitiaPfTLKBgvScxfzeuIQpB//FvsqQ2L6+/izcq4y+FpQrLr/yBbm+/
	b890Rc7LC3FYIIou8x6VEmnUzKUAsEJfAfT5Gjae3jSN/PQXR536aLXC9a2tVkcP80bB+cA5s6J
	OX2YAt67Tj0ZLaga1Mc37l1TB4VqWA0PP5EGtWzCvZj48w73ITUzB3E07O37KMUSKy1OO1Sk5x9
	j5Hf1tCuGZa5HXOk3jljQp5UaEa/ukwfXCmhpEQpP/7E3rEC1BLMyuOXF90RnbXUyUsczg50Xlx
	6Hlp32jS2LlzwTyY00Uvb3yPfs86LIenacEjVdeK2HssZJz6Lj5VpNKPJ+Ah8qwXxDnMludFTn8
	DFOHtwXJ1fbBNV2/tvjH6d4LdCGoV3687DIreiqw+lRTldglL/LtRK0CiE6+qYrB2OHH+vEspKx
	LvGTc
X-Received: by 2002:a05:600c:3d92:b0:4ba:e7:ef3d with SMTP id 5b1f17b1804b1-4bb559f7044mr107872145e9.1.1794656984431;
        Sat, 14 Nov 2026 03:49:44 -0800 (PST)
Received: from localhost.localdomain (static.16.56.4.46.clients.your-server.de. [46.4.56.16])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5671059bsm79079895e9.1.2026.11.14.03.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 03:49:44 -0800 (PST)
From: Jaskaran Singh <jsingh@cloudlinux.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	linkinjeon@kernel.org,
	sfrench@samba.org,
	stfrench@microsoft.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	mmakassikis@freebox.fr,
	linux-cifs@vger.kernel.org,
	jsingh@cloudlinux.com
Subject: [PATCH 6.1.y] ksmbd: fix NULL pointer dereference in opinfo_put()
Date: Sat, 14 Nov 2026 11:49:43 +0000
Message-Id: <20261114114943.5122-1-jsingh@cloudlinux.com>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit e1b21e606661 ("smb: server: fix use-after-free in smb2_open()")
is the 6.1.y backport of upstream commit 1e689a561738 ("smb: server: fix
use-after-free in smb2_open()"). It calls opinfo_put(opinfo)
unconditionally at the end of smb2_open(). Upstream
opinfo_put() returns early on a NULL opinfo since commit ee426bfb9d09
("ksmbd: add refcnt to ksmbd_conn struct"), which is not in 6.1.y, so
here it dereferences NULL whenever the open got no oplock info.

smb_grant_oplock() allocates none for a directory opened without a v2
lease, which is how clients open the share root, so the first
"smbclient -c ls" or cifs mount against ksmbd oopses:

  BUG: kernel NULL pointer dereference, address: 000000000000003c
  RIP: 0010:opinfo_put+0x5/0x30 [ksmbd]
  Call Trace:
   smb2_open+0xbf9/0x1f80 [ksmbd]
   handle_ksmbd_work+0x164/0x430 [ksmbd]
   process_one_work+0x1c7/0x380
   worker_thread+0x4d/0x380

Return early from opinfo_put() on a NULL opinfo, as upstream does.

The problem does not exist upstream; this fix is for 6.1.y only.

Fixes: e1b21e606661 ("smb: server: fix use-after-free in smb2_open()")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jaskaran Singh <jsingh@cloudlinux.com>
---
 fs/smb/server/oplock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 932e31a20216..f4ed5bbbeb6e 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -196,6 +196,9 @@ static void opinfo_conn_put(struct oplock_info *opinfo)
 
 void opinfo_put(struct oplock_info *opinfo)
 {
+	if (!opinfo)
+		return;
+
 	if (!atomic_dec_and_test(&opinfo->refcount))
 		return;
 
-- 
2.43.7

