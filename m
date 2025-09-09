Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA09258EE9
	for <linux-cifs@vger.kernel.org>; Tue,  9 Sep 2025 20:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449838; cv=none; b=BikyWqaJu0peRP8QAzB7nM0SCVLpj2S9pREl0x0up56jXFFIXA+gxZiVd9pT5sqPTNKLHYlPwxT0HaiIPSODu5uv/PpqLM8KR2T8T/iHbHBUB/4EQdEbZ5n2usd1XxgUSKG2kGKijFUYRbilpuZTl/WJNjpVNvo8v8s6+yW9Sq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449838; c=relaxed/simple;
	bh=9rZo4/N+H4o1CU2KJuozNET5QIOSGtktiu/q+gl9TBk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IN3JiBzqQ4wYQIU0gQAQDb4c+W5A4e8eKz0s6TRApbD0kJTiIA0LRFCbAnAWpoO/5o5AQqJWEmClQrj1avMDEGr2QKGNOn0DlEgBKOcTFUbodN6YzMMiIpcTLoFk/MPpHNOtmWPHYaK0dGCOYID0OMWF5C67LvQ4g3vwXDspIJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NqG5fjKW; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NqG5fjKW"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3e7512c8669so950262f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 09 Sep 2025 13:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757449834; x=1758054634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibeh22deR57LT1xlTRcFSIHTIlIUMdyvrZyHblfrOMI=;
        b=NqG5fjKWCwZCkGGLC6eo1KV1Vp0D0MpjWbQHCaK+kVm1ssAo+mENgC0lwINLiGa2Ar
         oY4cxG8J4ftAnQ2XpAkt5KHTwBBx2GRBncbG56xdTLM4yoYRpxLLYgHokGyXt/EJsEcN
         edPZ0cT1esoFYnwtnAE60xvoa645Cf5p+lRaKatAc+/FaNcZg9y41nitE+MEbyni2Tad
         B6XgrRaPalxovipaoTmXzjIMeNC9Pf3uZZnkDR2mKxUlWbRHZWxSSDiUSd4sFSVnX2or
         ZCHErkGKr3z4T1QDd46YBnhp531u34/CZlsluMbZ4+oRCe5NBsMihMh+xw7wnyLhvbYL
         EbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757449834; x=1758054634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ibeh22deR57LT1xlTRcFSIHTIlIUMdyvrZyHblfrOMI=;
        b=XNeEqhAsEdr79oRlEo+qtbBa1e6ZnG+NWwPqM8ZHzxTpqU2ziNQHYdIeB+wYs8tpDF
         WfG8xxcWK6HF9FjFaeXIpsm78IYdKX/wAeD8X58dCbaLkt3IetYFzxIemPet5ZAqtQ5Y
         DZK5gedzLENHKsULJLBMZhQdJjJPlCPs59xPGzPzsBzjznmoDlgY4ouHkp3ym2Bsv0aE
         io0C5ehge2F0pnpLy1ZqslPIRYrjhtE1WJ9X6gooMEmLSgv1QqGVX7WUp4HnaWwol8+D
         ul5VGXQLbquS71fgGSmj/qwqJuJdvMKK+Dbq/1Bgva72F2oP7m4TcVWxpE0o+Mamt/s0
         S6OA==
X-Forwarded-Encrypted: i=1; AJvYcCUzogc/Ctg7wqbIhjraLRKGU2K1BjK8e5cHGgInDYLxuaCMX9hNKyd/O2BSjr5og1mEtMQSMdvx/3Yk@vger.kernel.org
X-Gm-Message-State: AOJu0YxCXhFzqcjmqY4o9g2YbVUM8a7g80nGxuu82XKPVCLb47p8X4c+
	rPzwjhNIiz1iXBObQJ5/FCw7sjjfNuZximMr++BIsnsaPlWbebfc5Vsgg5E09P8W0JA=
X-Gm-Gg: ASbGncthPrqcaP2WIWlTAcre51hmNO0xHJB0ToyrO1WJzc2iI9E2lRVf2sy5lAZ6oSA
	XHRADedmlMedyhNntk07berZQK8YNLGcprvvkY7hDfVV0MIZ6aU0ZDxaYONj3xd2k0icrn24U+S
	/1gaNDM4Vi9UnGe1IIeHCGi1qFh3r/aWOHE1cY2tkJ3ePP8EWDj5Zq7elJlkQ8t5aJg7akKzaUv
	R9l/7YW/Rc2bA5sk6/pzHv97ZgogfBO+4Cd9K2x2TVxRByYhvY8O0PIT9CiGeUNqkYmllpP/GH/
	22Veo/7lNW+mreAG9St7L/+E/RzTR1NMvPCTvqOtJssH3IHCSVvgWizW6yKR3kZEcvF7VKfmX/w
	nt/nkeRZ47HDoIolOgTmCfReD9WR28+5/KeDy2xwYDmW6r/Sgp7lo
X-Google-Smtp-Source: AGHT+IEa5sHD1L6N19anEqAAHQciex4DxWqwZ04mGvxLRxrKxLDVn94wjV412kpt6eqS5/cmf7bnzw==
X-Received: by 2002:a05:6000:40dd:b0:3d4:a64:6725 with SMTP id ffacd0b85a97d-3e636d901d5mr5460410f8f.10.1757449834489;
        Tue, 09 Sep 2025 13:30:34 -0700 (PDT)
Received: from precision ([2804:7f0:bc01:dbd7:ec48:e5b6:7564:d345])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-774662f7f1csm2964550b3a.97.2025.09.09.13.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 13:30:33 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: smfrench@gmail.com
Cc: ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: client: skip cifs_lookup on mkdir
Date: Tue,  9 Sep 2025 17:27:49 -0300
Message-ID: <20250909202749.2443617-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For mkdir the final component is looked up with LOOKUP_CREATE |
LOOKUP_EXCL.

We don't need an existence check in mkdir; return NULL and let mkdir
create or fail with -EEXIST (on STATUS_OBJECT_NAME_COLLISION).

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 5223edf6d11a..d26a14ba6d9b 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -684,6 +684,10 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	void *page;
 	int retry_count = 0;
 
+	/* if in mkdir, let create path handle it */
+	if (flags == (LOOKUP_CREATE | LOOKUP_EXCL))
+		return NULL;
+
 	xid = get_xid();
 
 	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
-- 
2.50.1

