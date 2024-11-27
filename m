Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D91A23
	for <linux-cifs@vger.kernel.org>; Wed, 27 Nov 2024 00:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732667991; cv=none; b=CBnwZc1YsmGlRquQbCKvE1JmIeTJ7a/pJ3aLxBqFaPQHkUh/2DYqpznrjvsAsbIyRHSYXiKw1fiYgwdldwJpTb4aQTP6F+i50vjW+Wz4qpTL1tMMRmJXUTue7SOYQtfIALFQeLc0BKP4qSt5DxRKwPrx7izUT0xpaENtaw7d720=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732667991; c=relaxed/simple;
	bh=Q/YfQLOCGTL3L39mt0p4APO+9BY1fmkrvbA+7d5d8UM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SccNQcwoQ7iuFI1Dh2FwDYZ9gZQzWxPF83RCCswcox/zvln278wM6BOJcu8S8XWl1JeYzqFR7dTlvP1c1tVcdML0SMu3xZdFmHHeMNOiNCRxNozSVYDn55lIP6IYObv4dSLiOSERUsW+uKBIw70+8MIyYI/Ly/CLSqg3iwpJu64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L9NNJI7z; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9NNJI7z"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-53de880c77eso1941164e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 16:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732667988; x=1733272788; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KzqWT2DOkXmCIyj6kOUztLAUeOl4sshbIpRfnJWCllU=;
        b=L9NNJI7zclDsYqUq5ROFTCktqqgHvsITLL1NvKBrZU6Eqj7khvqqSBYjTFJhAScnN0
         ETarPLjBmZ94iNHgS1WXeqVuJOj26RU2177BfUSEfm2wt0fyBO80SQ7rLnKPMvGPOvU7
         M1QEM3uvctzRdTCZyoDxlg3scXAq1+mkdH4Nu10yoznEkNSBKOddeYHQGGMOWssOX+uF
         fNXNYB0m/e3zB/C/mAAZBR4LLEDIATvWnVrcrWWtXmDCvTc/A8wkIjGCukOWtlTNuFJP
         IoMrHWP3jPT3x96FapQCSJ/X2D5HAbFVw5SN3er6bweGEu7XONCWvTg1CB1z9yMOGavB
         XT2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732667988; x=1733272788;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KzqWT2DOkXmCIyj6kOUztLAUeOl4sshbIpRfnJWCllU=;
        b=KS3Fse7AGKxl3nOdGuIXukVHbegO/CuNgxz8tV9sDSuGYKc0OyhkAxhDRjNIVKbiuX
         H2rqo1/qEpazLRNvlUrIgYY/OC/9mhMu86e7GKVAbaTXtFRmLIbwjUzPSbp/SMQfiuCr
         bXbctTLHzugGcO1MGDw80E6mBYQjWQCkRl36QcnCGz0WYg3U1BxHkGyPFcDezF3Tsiix
         N9B5KF8jaBIYknibopNyfqVgoEKXll3xIHBx8qT97bdoVsfuxsXx4Iasp122kihyRVOI
         z82NE9fNRNkEyeTlmMfVyzDJJRHBv6Hr2OBa3NYb9NYswAG9QR08w2msB+SnsSXuFIWl
         Vw1A==
X-Gm-Message-State: AOJu0Yym/HI9O8IfRLOTv74hb4v2DY9t1DOCnSU7AN8GL7ReHFkju3jO
	q9449dZoaF7VKRhupiSf0PcHOJmh9KVRa96d43VB60ZypPACwebhH38zuTxAOeeUPDpCED7HjSD
	Oo02J51Jg5ihOL3mK1ADH2xZF8n4=
X-Gm-Gg: ASbGncs7MoEmub3nn+TGu8MU6IjCZaZpitLFl1sh17Yi8TvAuzC1CdgXS/5WKcMN5my
	/HECy6AIzOPgcQE8xOUMdjVxx3QvPpV/gdvqPaY5zKs5w8z36oxTL4WlTW4qSowl2
X-Google-Smtp-Source: AGHT+IGZNTYF8x1/GyGLHWOp7xbgOYpLRXNPGMOy3F+NO3yNowmkyP9B4TVWapV+jqVH/Q1U0pFJ5qapFu0ENHJ05pQ=
X-Received: by 2002:a05:6512:2347:b0:53d:6b50:f5f9 with SMTP id
 2adb3069b0e04-53df01046fcmr520109e87.38.1732667987637; Tue, 26 Nov 2024
 16:39:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 26 Nov 2024 18:39:36 -0600
Message-ID: <CAH2r5mu3aR1x99s6Dfj_dxR0=0F4TKtHdoN0=3zSQPipASWcaQ@mail.gmail.com>
Subject: [PATCH] smb: client: don't try following DFS links in cifs_tree_connect()
To: Paulo Alcantara <pc@manguebit.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Is there an easy repro scenario for this? Does it break any valid
interlink use cases?

https://git.manguebit.com/linux.git/commit/?h=cifs.fixes&id=a236b07af6214a4e48317e9676cab66dc6f4774d

-- 
Thanks,

Steve
