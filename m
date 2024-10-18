Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3202AD16;
	Fri, 18 Oct 2024 15:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729263642; cv=none; b=ll/pMg8AI8Pb4mOJQYbi2K+dFh7etARTXB0dWxj9VexeS/zYQBHQYM10Gls3S2VR0beT340eM0nCgCHFYzjmJzEF7gAP3jCmTe4yu2dESkDe9p4b8QnNidxY/8Kb4OjogpkCn5h7Lpeg36mj2PwdsDFXpmJzb60b76TgSQR0qdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729263642; c=relaxed/simple;
	bh=1pVbcKB5uGrnYq5PjyQqbovbftHfEmq3Zi/7Eb/j3aw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XJ923p0YiVyt9Gy4cCM3Ozux0imFxnMjpMGBg/x34BymTNwpOLD6ZboQxEzljBNNgjzuAknhWJW91ABxPXC3548tAFVgPqeAtuZAWjN7+dpUgwWU0UGkCHdccWqYLMl6WDoGXR4OO4EtwPtN67Zomm0kQ8WK8ux3hedfL8d+BiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i8P9/+fp; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i8P9/+fp"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-539eb97f26aso2709811e87.2;
        Fri, 18 Oct 2024 08:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729263638; x=1729868438; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dIKOdZ6mvFQDxiH7HbWkkYnZ6JyR6pvYOT67zOBxAXs=;
        b=i8P9/+fpTXAQd04ehNlGZayUolI3gjVTTWHQf0V85ampahhbyerpCnFshDVMQQGIhS
         8TuukK9VvYLvlL8MLVO+1p/djYzqMvPFKRxTTXYyG8NSENsixn80kgS6Nx33Sxn8p6Bl
         lfL1IObcDCPfXyVoiAmTqqRIDeGiPzDHLGuobvUvyjMICpXL0iL7PfJ7IscMeqAXr6Aj
         xZEt9GNzoTZCWIk8QArx6T3y0AwgRlDrD4lsapUSU/A1psE1MavQLYdaTCWtA4SdkPE2
         qEaVxl4/gpwL4wOP7OsGJ/D9NYMe6s/h9U6tFvJMm/d+4PWYv05bvgEkaIP2aT2T1LTn
         9Icg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729263638; x=1729868438;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dIKOdZ6mvFQDxiH7HbWkkYnZ6JyR6pvYOT67zOBxAXs=;
        b=eKH90vNZlmN2ws8ZItAqojDyGJgAJwBAI6tw5YhOomADYe1pQ0zyR9dA6xPMqv3/Ue
         jkiY4kOkit1+S7EZZBjFcrKxDtHEOT1n+NTTos4eiTLToJb5HzbUSd2y20TkZIvboKsT
         SAuX6nVZ2HLXuN5J/oWx2W6+JYSTkw+j25cOpiFcRsLpCAcpAn5yLQrZSE5u0lAMHylG
         IPtjmrcReCD9ShlWv+eM6KhA5xyHagzfDmQQJGqfx0DFxSXE2FOvZQ3kJ8so4FpjrbOF
         DqCuI4nGn7jRf/+nWKM3784v7jn66xbqoNznulR36Irdvd0Xx3JNVTHkXjwNWuS3Hlsp
         RSaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjPtDeLl8ICJteeMeeFzmwLwQBve9eIZoHJNIvqyWrXDW2sIsPHRAcL9YHNd6cb+8oUEsI6kHTZqTO@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+kN07dWnhW3+Hw8yBNsVoWdrpxghkw0scHMCetFc1z5dFlCml
	Hat0YNtzc5UREn5xg9iDcdITNRnXmUEdz7YzoYKO+wqazW5Xbli2k8oaYdtH/U0voXgf8EMNO6+
	RmTacUEKe9vqemBGB6VicXhv5LhDRzdLqYyY=
X-Google-Smtp-Source: AGHT+IHwXQ20b409yN7+yfUZ1sUfNSkZ5np1XrDl50YR+emCF7VvuE3bfUinG/w54J/aPOQKgrUTBkqs+N1w/JZ887E=
X-Received: by 2002:ac2:4c48:0:b0:539:f699:4954 with SMTP id
 2adb3069b0e04-53a1546ca04mr1887475e87.58.1729263638326; Fri, 18 Oct 2024
 08:00:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 18 Oct 2024 10:00:27 -0500
Message-ID: <CAH2r5mvOjw1o6RcYu8OHCANy+Z2+9ONS+tYjRFbX_o3QgT95Kg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8e929cb546ee42c9a61d24fae60605e9e3192354:

  Linux 6.12-rc3 (2024-10-13 14:33:32 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc3-smb3-client-fixes

for you to fetch changes up to 6aca91c416f626fc0c5146cc4450ea86b831f3dd:

  cifs: Remove unused functions (2024-10-16 00:30:52 -0500)

----------------------------------------------------------------
two fixes for stable, and two small cleanup fixes
- Fix possible double free setting xattrs
- Fix slab out of bounds with large ioctl payload
- Remove 3 unused functions, and an unused variable that could be confusing
----------------------------------------------------------------
Advait Dhamorikar (1):
      smb/client: Fix logically dead code

Dr. David Alan Gilbert (1):
      cifs: Remove unused functions

Paulo Alcantara (1):
      smb: client: fix OOBs when building SMB2_IOCTL request

Su Hui (1):
      smb: client: fix possible double free in smb2_set_ea()

 fs/smb/client/cifsproto.h |  9 ---------
 fs/smb/client/compress.c  |  4 ----
 fs/smb/client/connect.c   | 12 ------------
 fs/smb/client/sess.c      | 32 --------------------------------
 fs/smb/client/smb2ops.c   |  3 ++-
 fs/smb/client/smb2pdu.c   |  9 +++++++++
 6 files changed, 11 insertions(+), 58 deletions(-)


-- 
Thanks,

Steve
