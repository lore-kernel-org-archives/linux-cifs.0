Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A443C13E2
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 10:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776854991; cv=none; b=eZVUF575/Mml5yX5AuvVCYDriMJhcpg5vuX44612iw4pN//Wb2cStSqSl8Kf2TJ0buabsZZ1XAxV9pmvBjHiX0MqzAKEwNplroc2MVQqN5MGMIVlMWaf1G0hQ6BaQC+Hd9fMCLPMCQoGaJvLMgbzsoNCPG2VCG84GP9zMo9Oycs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776854991; c=relaxed/simple;
	bh=vlgiSEfORgkql2UA0Sg6MobmjNDmnhEkC2HKKZhBBCI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ks/PTsSoqTP/QDixXGvbupqQskvMg1L4DkKBJsWKP37ZfnqIyxIM5EtIwnD1MhUwPA+JjHEjs4oL8ospno+Io37+jzjpcObJSQnPzigscmAgcy0lP2BG+5H66m+HM13ASvO9xJjSbuMxiIhTT9VV9POqMniSZeCsEqbXOmFSvio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b=VfTPc5ni; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20251104.gappssmtp.com header.i=@freebox-fr.20251104.gappssmtp.com header.b="VfTPc5ni"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso54633225e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 03:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20251104.gappssmtp.com; s=20251104; t=1776854987; x=1777459787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xKMCEhO2nnV4Zt7oDc/aEFo4lI6O5EgQJeaAOAvTaT8=;
        b=VfTPc5ni8g0bJTv/37q9DeoaewEQARxA/gjbtNXDP8vvs2f8uX1ggheMLHyi7aEUS8
         44yDI3vw3fKS9uVdl/Az6BEfA8SL0mGtjvK7HNsGRf8aJuvawGfsi0iVpB1tvEmU/x6Z
         ZujMDxJs7O+5DysCnZGErXylftIpxHjCgt6azQ0sTs2FyQcyHPLXQhCqDskFHz+M51F/
         9QuIgcNZlUGzzJQIS8WpMCq9V6/qrtTRqAmEPF7fnv46NvFXt9WSBVxuEOIoSHMZCcyT
         NauwIwiEV4l052C80cMtTfj0N7Rlu5s189a5G/bLukLIzUF8qB36k/mngqNxVOS6Aksh
         qx6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776854987; x=1777459787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKMCEhO2nnV4Zt7oDc/aEFo4lI6O5EgQJeaAOAvTaT8=;
        b=QH21RXBE87r/4ml5w3RRYWDpAvJAGZA8mj61TUoRnTL3XfVqUoVI2LIAc4nReMfBuU
         UmPV3frpe31M5skYOuK3vZzJZ/Kex2eA2phfGp8W5IQO6H4Kk+zL3ZYy25W7/gARICQJ
         2sqhR3Uv/a8Muzl1jr6fkK4iE4pjQI81yHS3eyR9NxaEZtfUAFbFK3W+Oa8bwN9wtUvB
         x77n4CGuk/uq7kqqyG+9uNQFznu92nvEsXp4q7+iCIIoGltDln1/5izeTOvjETLm4fEC
         LpKcElqXCuNhApSJqPTVFB6++GUAIEi1jG758WH9/iLtEDdrdKUTlHMBjPGZ+sgc0XMZ
         P29Q==
X-Gm-Message-State: AOJu0YwGzTZkXU3RkO4Y/wofu8DynTLoSYkti1dZ6d3XlN8oPt0Kwf3b
	sfBCi8vql5DDO/bwlay2fxSWXMSFG9CdH+A/z6yQ/WXjR2ZCzdzCtVGHIaPAymfc3bEvPJDSk9a
	i2Ie915E=
X-Gm-Gg: AeBDiesDzXm/8QOrPRwq+Quh6zKcZyFE8to9rAIT/XgJEOMaUFk2edsq1yGxnrzN2vE
	yvOEPGKIksTZ+UxzGTtZHK93IkqOmWr8A3xAHb18xXg/i6cP1Hrnb7fb90sGB5f6P2w/CIqcmMl
	oLpcDCnwbJdMlweTdJfVyxn0dPC3oIhuXL+f/CkIn8NAkEHsvtVsv0Jycs1pqIvGzOQWz+KfrHq
	QqINIYEb75rL3mD96ZD9wPQlwndgjb9uCtg6grJaxhm0erqPMnPhxMxe/ebZcSv03VtTLCw84AJ
	1bMywXh+CAHO8RSToPA8ArBubDNiPFHTzgjlV0M7GAEmfNA9j9s8uaoxYwEo+DeYDK2gES5vfxz
	DNkb0iOm9RBBNI6d/CxKS9ZeEaTXKDSr3n6nbVL8WKnJvLYn7rI6ckSu/XD2qGxPMClfxayxwMS
	2wFr8n8V/VlH6QjlZFl11CGtg+cXzPkudi+QTkYWDCR+NlEDYrQdFPcvzWZI0dikVr1+BlOgF1U
	OFNpgaFCzgvHL9Y+T/sTnqu/FafM4SASVf8sFRPpNg5czGz3dT9avY=
X-Received: by 2002:a05:600c:c082:b0:488:b043:5efd with SMTP id 5b1f17b1804b1-488fb75f7a6mr240468285e9.13.1776854986793;
        Wed, 22 Apr 2026 03:49:46 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm49131895f8f.6.2026.04.22.03.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 03:49:46 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org,
	linkinjeon@kernel.org
Cc: smfrench@gmail.com,
	tom@talpey.com,
	senozhatsky@chromium.org,
	Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] fs: smb: server: handle readdir_info_level_struct_sz() error
Date: Wed, 22 Apr 2026 12:49:00 +0200
Message-ID: <20260422104859.2599422-2-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

early exit in smb2_populate_readdir_entry() if the requested info_level
is unknown.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/smb2pdu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6622efdd55e3..07782f7205dc 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3947,7 +3947,13 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
 		goto free_conv_name;
 	}
 
-	struct_sz = readdir_info_level_struct_sz(info_level) + conv_len;
+	struct_sz = readdir_info_level_struct_sz(info_level);
+	if (struct_sz == -EOPNOTSUPP) {
+		rc = -EINVAL;
+		goto free_conv_name;
+	}
+
+	struct_sz += conv_len;
 	next_entry_offset = ALIGN(struct_sz, KSMBD_DIR_INFO_ALIGNMENT);
 	d_info->last_entry_off_align = next_entry_offset - struct_sz;
 
-- 
2.51.1

