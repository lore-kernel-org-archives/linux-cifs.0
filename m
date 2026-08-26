Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400A133B6F9
	for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 19:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787771459; cv=none; b=M+CEc5BSbkCLEFpQljmFvpXLjSNeJtMwFwfwkv2lmx3IMpJlUrFJIqq/xih8iJAYe7gQFrun731Xbu6gJ5gmVZ1AnIcSXlhZHAVW8Z5XrntscpRqvv/+6wvvJeuVt/zgjPIPSyEB9P/o1C1EdJndTATee6H1fjr/HIzKlrBP+UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787771459; c=relaxed/simple;
	bh=XxNAZCalPh6e6X9eCvw85ifGWwF8EfX6vFvqgKgWTDk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JhSbVxHsvW5fG8IT/zJd9VI5/sH6UCp3df0rEt+4jgEF/6MI/IxhmBn6D+sW1NUvTqmwE4PZLmHZka+hbSXgHJMVVk43d4QSqMmTntFEiwsbrngWu7pHrr8pfvXpKOKVY3oys6hOh7qU+J21oknmwLB+lKN90uPFJcxgMkceI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0FTCG7J; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0FTCG7J"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-43b7e186a0cso801718fac.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 12:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787771450; x=1788376250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U0kyZvIf4PveC2J2iGIydryLHHNVkmbY4dqDOyGBcDI=;
        b=a0FTCG7JUEaJ12dO6g3LtbdkLMhN+drO37ApXc9/7tbGcHZ1ti0II8iwJYHtaJ9n0M
         o3kQg92FH4b2zouRW+RU0c+wOen2QhFDOeL/bjcvTayQKacPF4G9UliLi5FyF/N1JD/S
         mXHLjyR5deolIzXTjfgOh5X3s3yQcMnOm3EGW3BvVG4MDVwxn3n6xB678Ow9AjrcILLA
         vPijnpgnVk6iQ3/P2Wf20J8Q9+kpGUlQPDJKioKfvKe9KcBmIl9Oj4ACY84R7cKpHGtl
         UxJlsS+lunjCzAMyqBJZqQ++no26/tfK9ZDF9j4uQPVxZjbcxBqBj3hTskfTaaIrLzIH
         +q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787771450; x=1788376250;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U0kyZvIf4PveC2J2iGIydryLHHNVkmbY4dqDOyGBcDI=;
        b=eL0ZDaMRP+Vx+LSWahnLbNBdB6On5ZV5StPEV/EEf704YbEDCmhU3v0ICQLY31eyCL
         vukaopY6GBC/mXh9tS2CODSd4KNUbwBpOSDjpRTxWeB4cgGY2TtYDXxWo4IKBT7eKYgj
         Xxl/dmHOzc6ceQDO4RMZ2cyE3EEUtpVWGywEqEPOI9aOgJGZl0w/rbmlInKYOo6bGBlB
         qUjwrK/FFte2C3bYL9eFDjzGK8+6070Lw5g+VqrPOT9pVLN2TZLxvZiaL8bJNpIsFR5G
         6tk4ydpijrxxxRBMAGYr+ajA+oE9C5ltnLskcmzzeTAaRStMVIIAj6rVIJcnyN09RANB
         ph7w==
X-Forwarded-Encrypted: i=1; AHgh+Rq/xplcDWV3pPP8yalS0zCzeK9IMhDFuCElPC19zsfenv6pwJtoSZyYDJiW1nPPxMiV9lvzqNgxq87/@vger.kernel.org
X-Gm-Message-State: AFuF++kM61Q67IDvgzQ9aLsabog85L+HrBUJ2L4uHkZA5Waf3veVsNB/
	xdpue7raXZs4KalF1PpGl2vFrva2Y+PxyuFE7saXlbPhMjN8PUoBD9mL2865AgJW
X-Gm-Gg: AR+sD10i9KTTRg9AzxoU2mOwwrirhaV1JbrK46capMq4jYhILX9/1uk4C7EeVlRX75e
	QJmvgvTR2MmjfRG7EUNYKBiWsUJ/APMZioN1WVaOr5LlnPPAPG0oo0slDLseEdN24WGIFUZqdNh
	kw7xhx3fi9gFtUNOq5E7w5kbXIR/G9l80UiuV679YBvc9CV5jSMTZE+z4LaSUnd69gWobqr5IlE
	rkPLIaN9xW/y19OA7vDJ4Ipn5kMgB1Hkw3DQt7seWr7RCUMUxTidOpW83nJ+U4h1nCZO6sVmPGs
	l+vZYtetRmb1xLJBHJYg/jMcXs4/YBHW5SoIqAYMfFgDjbXNtqMfsip00hDoRe8nwWEFbDw3pZQ
	0nyw0S00pF3HboGjghbiQQSOouzER5p9phvFI77S5ueVeW19WWQtjnvPrqxqdSCP2M2OLjS7gUh
	BaF/l0Nxzqx28nCparZcdfXyoK31+O65kkPKjaX77ZvovCCe/xorGbdGo00u5vEYwYQufpGnfrr
	jJu
X-Received: by 2002:a05:6870:e08c:b0:456:cda4:be23 with SMTP id 586e51a60fabf-465961b8941mr9942326fac.0.1787771450512;
        Wed, 26 Aug 2026 12:10:50 -0700 (PDT)
Received: from FredPC.lan ([2600:382:3107:46eb:31a7:8fef:9fc6:7e8b])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-465ad9ecc2fsm3060369fac.4.2026.08.26.12.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 12:10:50 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH 0/2] smb: client: improve copy_ref_data() robustness
Date: Wed, 26 Aug 2026 12:10:31 -0700
Message-ID: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

 1. Avoid setting the metadata of the cache
    before updating the cache.

 2. Harden copy_ref_data() against an empty ref
    array.

Fredric Cover (2):
  smb: client: fill cache fields after populating cache in
    copy_ref_data()
  smb: client: prevent out-of-bounds dfs_info3_param access in
    copy_ref_data()

 fs/smb/client/dfs_cache.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

-- 
2.53.0

