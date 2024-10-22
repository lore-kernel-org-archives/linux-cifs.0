Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994F01BC07B
	for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2024 18:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729621333; cv=none; b=QqMbk1f2NbQA/sRQ67rL+s/Wc9cCfyzoKYeqhpr6B1g97HPVqfWvYG+KQIxH3g9DivWFqk2+0F0Yex20B+mAfu81P2KAR8VzzZVygq/3xZBx2AMUAfcnRhEDQ6lYNBcQURddxHaq/D93SoHNyBtLYM9M9k9xU0DQHiQrdqWLuRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729621333; c=relaxed/simple;
	bh=N2JpDDwqsAmK0n3ZoN9yOGqFxkzAakjEVOW2ZjtinHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suFIz5jm7qC+P6qJL8VScy5uV8wCmuNX9XNTYbLBCu56k1VfM5+dayvlnJisd5NtOLETRuvfEcziPwkfpQ45TjYAkR7UAryWSlSomsqiDlUXHXkOcaj6GR2ZiyousZdOEENC1QNsI/WpA4vMvj65HzZ+Y6V+dOvjQ7NF8NSVcII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AVSbiIAx; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AVSbiIAx"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f75c56f16aso58079321fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2024 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1729621329; x=1730226129; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Llq4ObyVqZHpjTz8PNUBA4p8/Ji5HWWZgjci9ju2zy4=;
        b=AVSbiIAxAf4OEtxjjGm2AtzsrrL3O3La8DI7yHtUIbTBf99iVILMGQXzFebriBJ1Ef
         axvuVZWNElG2oGOBwxLsM8fe5MFNgYUc4Wlrb0FK4au2zZadvbbZBafJhX6LdGjYCC2d
         pH9nVYA2wncnFlNQSwflss67bPpDwQgQ0KWvlXCx9qqlp4xOznjQ6hqWJuChiDs0ZYYf
         oHl8lw0EugM4wdX8hcwY8yWGhVKmZs5ptFwgke6/IWtC33AOlyvo6I1baeBW9mJrCpuK
         a/UDIBw74v4djv6W7Xmjq4mfa9YW36xNbgYnlfYW9Lu8ENTwEVYRgCS88eXakdu0QqB5
         ZRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729621329; x=1730226129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Llq4ObyVqZHpjTz8PNUBA4p8/Ji5HWWZgjci9ju2zy4=;
        b=wtPCMJG4QIl/Edjs82OQxpK0ipkJoh08UXCF4fCbZh8DveyYePPz+totm+JSjzUpQ4
         AQwRU8HCo/Og93Zom/Vb6mBRfAuaKn2t5wwnUgewTKxz1twOqPHOKTpnlL3Kc+jwGSUr
         ZDKxAwBbJacydIYexvvglOHpvrSTGmPhkVw5jwP8R4HJvEMe7+tDrE7ghCdzlhl5RPWM
         Ris0qem+Arj8uxeWy4KpKVrv0ssnfeb7PKYMqqT5ae757Fp3PHJMAeGcxIkYr6SQDNlO
         AkpQqWdzuvW4gvthaI1WakFkpSwZBNqXX7rfqRTh9RixOC1PiY71fxyYC6o5BuoHMfqg
         /kAA==
X-Forwarded-Encrypted: i=1; AJvYcCVjn88grAZ4Eh4Daba6tXDCTa0x3J8oqCIeF0o9GXBtd3rUCAyzycAMqtrSuUCqWI9hMUGlmAM35g2H@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsjzw3brseQBQs5rz0QBjhpiRGyncUIj25w+qHx+xqg4L3CQ5x
	YYjIvE+SzNDWHeR6JmwOzRBPiQWPSQDKTmM43rgO1Q1ZzmA3Fqq0EX7ZuZ7wJfs=
X-Google-Smtp-Source: AGHT+IG1ncJ+dEzCqbmzr2Fqx9p+8N+YWNVOyCm+b+ePNWJlteVWxDGEfhm5gNRH/vmk4ryD2OWPsg==
X-Received: by 2002:a05:651c:1546:b0:2fa:e52f:4470 with SMTP id 38308e7fff4ca-2fc932e4026mr16678881fa.9.1729621328759;
        Tue, 22 Oct 2024 11:22:08 -0700 (PDT)
Received: from localhost.localdomain ([2804:7f0:bc02:9a54:2a00:afff:fe18:d85c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec13ea0e8sm5191209b3a.145.2024.10.22.11.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 11:22:08 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: bharathsm@microsoft.com,
	ematsumiya@suse.de,
	kernel-janitors@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	make24@iscas.ac.cn,
	markus.elfring@web.de,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v3] smb: client: Handle kstrdup failures for passwords
Date: Tue, 22 Oct 2024 15:21:26 -0300
Message-ID: <20241022182126.3353440-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241022171515.3330183-1-henrique.carvalho@suse.com>
References: <20241022171515.3330183-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In smb3_reconfigure(), after duplicating ctx->password and
ctx->password2 with kstrdup(), we need to check for allocation
failures.

If ses->password allocation fails, return -ENOMEM.
If ses->password2 allocation fails, free ses->password, set it
to NULL, and return -ENOMEM.

Fixes: c1eb537bf456 ("cifs: allow changing password during remount")
Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
V2 -> V3: Adjust commit subject.
V1 -> V2: Decoupled checks for ses->password and ses->password2. Ensured
ses->password is freed and set to NULL if ses->password2 allocation
fails. Corrected return value. Improved commit message.

 fs/smb/client/fs_context.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 28c4e576d460a..5c5a52019efad 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -920,8 +920,15 @@ static int smb3_reconfigure(struct fs_context *fc)
 	else  {
 		kfree_sensitive(ses->password);
 		ses->password = kstrdup(ctx->password, GFP_KERNEL);
+		if (!ses->password)
+			return -ENOMEM;
 		kfree_sensitive(ses->password2);
 		ses->password2 = kstrdup(ctx->password2, GFP_KERNEL);
+		if (!ses->password2) {
+			kfree_sensitive(ses->password);
+			ses->password = NULL;
+			return -ENOMEM;
+		}
 	}
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
-- 
2.46.0

