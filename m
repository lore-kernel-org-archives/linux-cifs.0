Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526FA1F37DA
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 03:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757646430; cv=none; b=bSFMv2CdDbjA+PubCq/2mYcLgetOhbRkQF0tErlxaVamcl6Z1wRicZdkpWaOtYGbV4ewj1L/cSRLfumIylqrO8QMyNRsuSyBRgt3rvDnd+L+4TGIoB6VCVCW9D/ldvIKb764h20qM9lQieYyI59TcsTZDre+lQvj2bGjYGJKw+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757646430; c=relaxed/simple;
	bh=IfF/hI9lhmkpYCouTi4ehbxXGIBbx16OJD14AfpkqXY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AwB97+RzBAAEnh5dGM1JGBjbbUKonL/RsKpAwlHe+QTtQlGJMl9FMv+w9mRECIEEq9o5S6JJh0rdHpB48O+PNrIT94dx8b75pXScrVfyr9Z5PHwyCZPXgrIsa0FsVDsVyACkLkzPP+yP4ujQAjx4A8q+XDETnHHvX+k7O/mkaD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cal3f4WE; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cal3f4WE"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-72631c2c2fbso15207586d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 20:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757646428; x=1758251228; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nT8Y466Uxi+WHOhvi7Em/wp+AvYruQ2l8K6jEQK6cFo=;
        b=cal3f4WEwrPri7JLpV5mELMDJGzOkPGGJKa4n5/6KYrM+nCLOOhYpBVCBWNYqbK6o6
         Xmj8fuz8EUvtAPxUKpUHDFbkO62JIVcYen4K2bCTbpvGhgVtidqhqj7w0P/4hg5fvpXb
         XrktCwVtt6RMNDpazhX338QChlzKAZWWzd8Kmz8n0kDHrYYqau22wW3dojKayc82hVJ0
         lmjCJF0IUvzH9dh6/bPSpcZ8JezQYxXVie3c9OScvvVk5QsG1xr4w9H8fLu6gYhtbiBd
         xjNtum3FVjpq/wqDJy0++8sOw6zLIH6HIXWdTa7z3tHCD90xC0PalV7YXg4/YamtfeN7
         Zgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757646428; x=1758251228;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nT8Y466Uxi+WHOhvi7Em/wp+AvYruQ2l8K6jEQK6cFo=;
        b=mB9woW7RImkrM7R1dqW6uvs/WXIxMUU0XwtgagZ4WzFKMXg/k6oimgzOKA2Fv4W6c6
         tfPTnfAVyuUR29TPvS0rJfLwk+TJenSXpKaajQMPRJGvzpWhW/Do4kP5ryPlEcz5uFM8
         2t7XfawMXyN0ITokXBrg+zp6Cr8F8/q2HidXScrl2MppFLs/0of4oHt0hl676nFBaYC5
         EgCBDmuqu/DavJ+juvAqCQVFk/hqgz0B+2/biofXlmCSXPZy03dO3PLwyL/XJgYh0aLE
         sdwe6ixOdbD8ereRcaTrd5TfTWcwgELQBcp3kw7F7IeKT4GXfIW0njofpB3ygVOB9fPV
         Im4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVh/dCvIh/vuZqH1PqEKdq97cc+NgJgpM83uLCQRD5JBHmXdoC81H8oyrsXXt8u0Fg4D4n7wrcHMqzU@vger.kernel.org
X-Gm-Message-State: AOJu0YzxwtvO24qx+0HMZMGlUNrFEmiHHMfyoNxf22qj3ED3A9ephPwA
	XxUOPO7F02lYhdxkiz6N0Gw0QHq5WTvnOKw3nCSX2/QI0kIdIHA2KABQSSpc3Z6+mPpUR4y3ucP
	Ix/V95lv/9VVFfg/9fT5V7NZFMyV9ctaNW58K
X-Gm-Gg: ASbGncvDKkLPOz+E8vDGvnNSNOo3kk3LR3sTDWSzzxPxGFE1lTlV7m+s+PPRAQ7VnfK
	TGVtIp+qoW2NJCUSlc3WKdKUaKCd44TmQ92uSWK9Eoyui1+rJgIqiuGD1UbbDcUL0ifAMrN8zWy
	Z+Jtw38umyweGlrHN0S9zYM8AXEXMO2ECQQ0SyGVFlYSJlWPjo51uHqRMD7DlFJ6YQUEnZPmuTZ
	MYgSfg+l8CBacVRpPho7sW+qnYiYeVgXYQMp2HjSFilJHyaHqEr9diiQgLdND6HnYwSvC4sWa1d
	9iHxt3GgqCRhjGii7TQhMAMHiukTlwvEBrqik/SxABPrFMyAiqLn42iPvlflSANgIcoPxYrVqj9
	m
X-Google-Smtp-Source: AGHT+IF/yMtPWmsvOyJI97PAV8q1eS7/H3+F6/EEhH6Ne7jU0CDWHGKFau1VtqIwSlIwhZJcLUxO8YgUyJh3kSTJn74=
X-Received: by 2002:a05:6214:1d24:b0:70d:fa79:baf0 with SMTP id
 6a1803df08f44-767c1f71e51mr20165386d6.38.1757646428228; Thu, 11 Sep 2025
 20:07:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Sep 2025 22:06:56 -0500
X-Gm-Features: AS18NWAzmGzBaUXHsLEBDRX5cmmgqXeSIlG88se-7P2p7Q2LtZ1MM64C6LXorIY
Message-ID: <CAH2r5mteAcfR8sgQuCEKHxWn2H32BEQ0pJcTuiRmAs4Yo0dYJw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17-rc5-smb3-client-fixes

for you to fetch changes up to c5ea3065586d790ea5193a679b85585173d59866:

  smb: client: fix data loss due to broken rename(2) (2025-09-09 18:39:58 -0500)

----------------------------------------------------------------
Two smb3 client fixes, both for stable
- Fix encryption problem with multiple compounded ops
- Fix rename error cases that could lead to data corruption
----------------------------------------------------------------
Paulo Alcantara (2):
      smb: client: fix compound alignment with encryption
      smb: client: fix data loss due to broken rename(2)

 fs/smb/client/cifsglob.h  |  13 ++-
 fs/smb/client/file.c      |  18 +++-
 fs/smb/client/inode.c     |  86 +++++++++++++++----
 fs/smb/client/smb2glob.h  |   3 +-
 fs/smb/client/smb2inode.c | 204 +++++++++++++++++++++++++++++++++++----------
 fs/smb/client/smb2ops.c   |  32 ++++++-
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/client/trace.h     |   9 +-
 8 files changed, 293 insertions(+), 75 deletions(-)


-- 
Thanks,

Steve
