Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E2145B26;
	Sat, 17 Aug 2024 21:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723931578; cv=none; b=JfvDuzKcq2YyuLoVNJvZ5hMZBNLXYt9nkCBdQPyLNW0LgbJklCuHDPuxP9hY8V6/LnWZkrGdDZrRryU2o3b/oBD0HsFaICAc41C7oUT19R7lBjJlHB8NtExMfH7URvtBhXxDI3qXSyKL9XZm79/Ur+1QTSu4Z9GylPwf91DkyqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723931578; c=relaxed/simple;
	bh=ze9ch3YZzCfYoeKWUNaWCiaBI8bFGWp1iPa0i7rZnx8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dnfd+ISVJ5N7Yoo33wt2P1GfsINLmhKxf056CakbQD4Xeu9U+lx2Rf2XCZiO2vGlM9BtL78xjd4JQhEovLzQsKsUXllQWGQ58ZWm/gyiSx3NTR4F56dz4JvD/ZPYmvaDK7o+dgcU+ptdnaVL0A88mdk9120J0ym3eQvmNEwpPWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIR35SMq; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIR35SMq"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52f0277daa5so4068780e87.0;
        Sat, 17 Aug 2024 14:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723931574; x=1724536374; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f+fGjjDilP5f8PC3j0wUi71bYLunoVbG2PgMeSDaZTc=;
        b=YIR35SMqjPVSaTioy2uMeYaXQdWmoa1c8IC0Txwgpcbfike3RrYb6E1GB42/fY51u3
         CCDVi+gKfqUQYL1sWscY0Q1md1TsQmfDFTT6P1EVrzWiZQiSLu6p45enR64TvOipOFJH
         eVG6CrAT+ERUVLxWayRyJuequwY9aAN1TNZ2VmNUGIihDFq39dlzQR/HVviY1uaDXsAU
         G83XXsvXCjTGyDJbwb2BiN45VgAfCJcaOfeu5HXDYxionnIEDFNYqWoh9/x0pkEc4A3H
         nYnbDlkq4li33xY01KlnZtr6O8mOSiXN2TTe362uTazKco5cpZnU1z2IzvfqexRzqcN6
         7DgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723931574; x=1724536374;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f+fGjjDilP5f8PC3j0wUi71bYLunoVbG2PgMeSDaZTc=;
        b=ZiNd89Q+1wnOCLZMFrcZSY22PVR4zs5NXygXh2WJm/iZIqd2dwU+QRAbe9WIOpZQx0
         5L1vrQrwNdSlPafmggqUZM0LXZbCSU/4CxXyRkqzioncTcIvM3dAd7wkCnZr8xwSQxmf
         jmHh31Lvwqlz8lDoz38mzMchS4oWJB2y7PNKuN3JqT7du7DgQiPvHf+eM5DdzFweYEzM
         1DKnFpZz5s4Q1EdSyjLk2aSUw33gONXjDkAFfyNwpEPfCnC0yQ0T396oEo8zTdQzNr5O
         NoRztSRYybjC0Q8t4Zrjmfxc87F/oTkJqcxIVwuZucEGVXTzCTSBovHHzRe4A3PTtgho
         Fe6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVlFVQE4w1qRALXGSQSV4XQj+yqA9x+noOa6HJCNYMvdhvne3cjF8OKwp0aCovFoTEjuxXURXT9ajPoDgVLL8ddPQST8+Pisi/rLg==
X-Gm-Message-State: AOJu0Yy6JiUh8tijgxipZLCIRLIVDQ9m51A8KH7A0uHlh25zl+caKKs8
	Pwa0uLG/+PlUMdFRvLs2Wl3z0TlUDLR9I4BN6V1rQhGs+vWU3c8NPzVfIZdWMDWnLlEuM3X0P7r
	wSCxZsODIqrVfpGZOG4q8Cwkgfs5Z7nW+
X-Google-Smtp-Source: AGHT+IGWU0Xhmz9pFeGBWh371YNtvP9B8oKAvaOF8np+VIx1fMCQTh/ecvtRtPcUKE9q9QH2eS/Dq92vTVJL7O/Qlz4=
X-Received: by 2002:a05:6512:2386:b0:533:97b:e272 with SMTP id
 2adb3069b0e04-5331c6dc80bmr5070881e87.41.1723931574146; Sat, 17 Aug 2024
 14:52:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 17 Aug 2024 16:52:43 -0500
Message-ID: <CAH2r5mtMOk4B+Chvd=an04wjx0zG4NA_b0uSmsBV00qC+T52Cw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
7c626ce4bae1ac14f60076d00eafe71af30450ba:

  Linux 6.11-rc3 (2024-08-11 14:27:14 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc3-smb3-client-fixes

for you to fetch changes up to 5b4f3af39b6588e8de4444d8e1ccf759b40f9414:

  smb: smb2pdu.h: Use static_assert() to check struct sizes
(2024-08-15 16:06:55 -0500)

----------------------------------------------------------------
Three client fixes, including two for stable
- fix for clang warning - additional null check
- fix for cached write with posix locks
- flexible structure fix

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      smb: smb2pdu.h: Use static_assert() to check struct sizes

Steve French (1):
      smb3: fix lock breakage for cached writes

Su Hui (1):
      smb/client: avoid possible NULL dereference in cifs_free_subrequest()

 fs/smb/client/file.c    | 21 +++++++++++++++------
 fs/smb/common/smb2pdu.h |  2 ++
 2 files changed, 17 insertions(+), 6 deletions(-)


-- 
Thanks,

Steve
