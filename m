Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FB645BE6
	for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 14:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710339109; cv=none; b=A2fUpOD0G1fPqYi+pY1bSnxTwW4/tIw5riEBI319YqnUXDMWb1iwqiP61SkGz7ssd4u+e+yAzTubula7i8nBQyK/XxEQRICGveFKnKePpiMK2l6SHYv1CdCHafd+jFwoKZt4nEiP663woI8RcBYJiKZFlAwUchcxmQhrjyUID1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710339109; c=relaxed/simple;
	bh=9T3C0aa27y5k+7FrDv5hllGIIlEWNU6Lkdw+0jB1mMs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iv6F2yvIwDNYAke89dJoaBHz0KTcSuEOBEpch5NnQdrAHHEeZ1oOLII8N+JmKq70o8w3wP4KQ0LecftK1L8dxeOYUmz24D5XriiwnMUtfyxt48hsysx4iLXsMEQzGXL8MgAOARHXj/iJdRqLQZN4Dk+WneGDY4CP/nl3sHeVa9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr; spf=pass smtp.mailfrom=freebox.fr; dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b=X0s0wSCq; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freebox.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebox.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebox-fr.20230601.gappssmtp.com header.i=@freebox-fr.20230601.gappssmtp.com header.b="X0s0wSCq"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-412e784060cso5968145e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2024 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1710339104; x=1710943904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZrUHPThWGTFJPHWz0t8ElMw4VsZhGieGjvbI9yAYrtE=;
        b=X0s0wSCqx0RUdtgyU4ajBCJdgbvYf2kzhNlFa66+52+JhKPc3ZPOoV6ytmYiuBqM3H
         3vBBqmqiceRMvfc03TY8Vfrqq/F7vxTAhHraAaIs4cOlgSoMX+FCxo05vewy8BD79Hiz
         R0733MKuyjfHq+5nd4JY9TqinuIfDVVMV9nbcH7Dom1WSx2eUKXFXPJVEZOHWyvSPcPD
         DRfjrDFKeS4b3jIS9EBp8pRUnRH+0PD2WF1CiWmbXjbDsju4MdifxU9PT0lTpPfMz6Hi
         ORv/SaokRJIFkujCgnGklw8VpaI+5hCqcv8W+kgmw4ieDwXCHRnNYTfuvLr2znBQNbTr
         XClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710339104; x=1710943904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZrUHPThWGTFJPHWz0t8ElMw4VsZhGieGjvbI9yAYrtE=;
        b=FbElCgwEdCTo0L7kOTs7gdCuDQuGNauls9kVWuBuNcxjOr2keYIgk8cKRrCF9SbTJq
         zk72W1KM+pd+AXxyrjhCBXk4mrD0ADtNYMR3grOrLm/7NgzQSjA1qSfcrcfX6ssDIixN
         0tRU4SY04/smsM1ZXXo3BYPNPUFpVQIBnIrFYLBCdaodgmYTHGDjiRiiZpy0Zd4yOTZG
         cReBxatzJqeZZywMIshd/LtQsVUi+83OtIEBzuNlDUiUoD1TheIpi3tm7wBzTC9k9p0p
         Hgy4b4CrDMxisJ9pnhlgILu1WWRKrSJ6bQZv2VBKUQ+MimOCz+hPGXO6vuAOq0kSIegp
         ZGQQ==
X-Gm-Message-State: AOJu0YxczMZUK7LI0Y2YakGtQ+ocVo9NrGT0bavCXfZ7UUXprfPVpuI0
	PKWOOGjooyvDHvMc5Gw/iSUd4MqDDJYI0BMKrCJtWQ9PXNqPrRHofn3Ba5W5gO5yMov/phHx+QB
	n
X-Google-Smtp-Source: AGHT+IFiEqkpj0kLSWtkl5L4ejJ6NsdSixRrNQvFQARjVTZj8Y0JhGVoEZvLhNpOfIbvI7GxFbNYhQ==
X-Received: by 2002:a05:600c:45cf:b0:413:119:33e2 with SMTP id s15-20020a05600c45cf00b00413011933e2mr2633579wmo.14.1710339104516;
        Wed, 13 Mar 2024 07:11:44 -0700 (PDT)
Received: from odysseia.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id fb4-20020a05600c520400b00413e4ff2884sm2397682wmb.40.2024.03.13.07.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 07:11:44 -0700 (PDT)
From: Marios Makassikis <mmakassikis@freebox.fr>
To: linux-cifs@vger.kernel.org
Cc: Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: fix possible null-deref in smb_lazy_parent_lease_break_close
Date: Wed, 13 Mar 2024 15:11:38 +0100
Message-Id: <20240313141138.3058492-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rcu_dereference can return NULL, so make sure we check against that.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/oplock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 53dfaac425c6..7daa7909801f 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1142,7 +1142,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 	opinfo = rcu_dereference(fp->f_opinfo);
 	rcu_read_unlock();
 
-	if (!opinfo->is_lease || opinfo->o_lease->version != 2)
+	if (!opinfo || !opinfo->is_lease || opinfo->o_lease->version != 2)
 		return;
 
 	p_ci = ksmbd_inode_lookup_lock(fp->filp->f_path.dentry->d_parent);
-- 
2.34.1

