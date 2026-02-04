Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00F749620
	for <linux-cifs@vger.kernel.org>; Wed,  4 Feb 2026 00:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770164050; cv=pass; b=YlfJEHfsy4DR1f3d08L1KeGPlrkghL4z5BnZZ69zMxF5tVX6X0RY74u8GTh9CZrsrdXCdPkWFT1E0mSnW/qrB34HqsP2fN62PJniR+gLxZSiesqYJ9Yj7ERSmVdGm/C4/npYZ3FheUvm/Q3Evd3vZv+/Ig8o/0y2xsESuqRiZkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770164050; c=relaxed/simple;
	bh=uGiOKCRWfH/9tHeO8JA5iwxmIeC7MAPeGyQXc64CXyE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=o+/nNdWcae1vTSprn1Vxbs1hmE1UcOYfpUoz/KJGnalHA/SFUrKK0459QF0ToQf6uu723AZ/0gVcnzKZbBAnEYl+E33CFmyKz4goU5UABCSPvK3/yz/fLr5W2TyqjeEC3Ee3S9q+aLWdLAWOxfnnHU0oc02n/s4W6AywoxIc5H0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHwSqiFw; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHwSqiFw"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88888c41a13so79260366d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Feb 2026 16:14:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770164044; cv=none;
        d=google.com; s=arc-20240605;
        b=Dog+qvrysJdXMAo0rm6COLqwPeWR2lraHzChXmhldFD2YIUPo/i6Kcf1RMMTsGg57L
         nVBZTDC9aNtHU6M4RQMLyJsPG/Icx8nLjZ//4t+gb7m9LaajpSnBXw1suPAyvgCTVDA9
         Gf7Nn+fmuslzm9kCryuZWacGMQndaG6Hir/zMN8Q2JqUxOu31aDeTTxj0doTGvvI/wZS
         KhClDcEIWk30V3bhZj0E4VLIfqCg6GnSm4npdX61mLvKUbaVapuU2H4qQb7zKAhw5SOB
         wEiW1jDHh+8IUpnJThugWH8ahOFA0ok2KGN3d172hUZMfoibBN2mPzRUH18lxIMQEnSz
         Nh3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=a3AAjoBFTodYV/D5OWB3BRynbF+lKZvNt0SqMCyfKh0=;
        fh=Nf1mvuQ9XbZKOmPhacDz1X5aHl0t82a+aHbY+2n4zlg=;
        b=JJxUXgNyAuQWAz8F2d3a+W7e3Py0XGwBK12pKFMtWwmiXoaM79Dl5mb37HU7zlgmbR
         d8yYE3aK4p9KzKAS6uZ5M5ZbmuO/I9pGRyTY1DCLazfQnqlfhzDqWHUkyAwihWboP4r6
         QpaP17yBGXhJEu36pam7r0A7ebEsznS/SB73mqpuLqwPnOZmV245KWsAs/oOW2Ptd54p
         ujkv2bJupVF0Y2iM72ZtU+7ANU+S9BCzepWyk5I4uwKI5jfp6os3f+Nd07X7qHmpp++u
         a/4P9ujFfK+/2AoaEQrd2rismkwJFU5hO4/YGeuwNu6+Zg3SBeI4r25RY0CkRdB6ha4Y
         epTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770164044; x=1770768844; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a3AAjoBFTodYV/D5OWB3BRynbF+lKZvNt0SqMCyfKh0=;
        b=iHwSqiFwfm9FfwjsejE+Bynld/qv1qA5WMeibwR78nLFJD1sdIoEhYDMmAuZdKpbVJ
         UX3RDkHVeAQvxcb7NTdQ+bss+j9Xc0PyjiXZU9YvpMeIa/o5cPGcwZwo9RlSYMd8cbak
         jGTUpe7/sWUUQp+1AHD1Qllz6YiIDmwnMAEt7rKRF0aGPdKFQ2aX3kFEQyMeFLXD20Ad
         h70wSqHWgkRb2pyrKKeWvggG+9dyPd0xtMWXDzVqFJu9Fo/8PPcb0Ei9bVBySMwnpMJ2
         7dU5NoSlXYwUyW9GgKl2wEATSBZLrr0kxE+B/2BNhaEPgVDI++orGy31Th0Optbu/xKW
         YNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770164044; x=1770768844;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a3AAjoBFTodYV/D5OWB3BRynbF+lKZvNt0SqMCyfKh0=;
        b=vhFvFPB4+U8S173R4ZXjh2ADQ1XtG6m7gGlFbeYa6Bq7tbFT6/VgdALasD9BqBrlE2
         w0yXmsB/1eOldX1LIiTubjV2LKeZfqxZE7B7NXtQIeKUfkNzRpG5g24wDuqtpDs5DsGb
         mvNeNrj7Rcerr2DTIDSHPx1kzMqMFShuN+WgNnhzMSPLO0CCCaaSpaI9qGI7usIbWzB4
         Qm8WkIyc+TvKml2aKUcCekS7hMdP3tS6X5pWsfeVjDZi23EeP6j+Pz/ifmX130XC6Sy8
         bbzaT8n4/+MS1jHhU4+6JlARYb72ewiLRDOpuSNKuQnf1WRRPKftPyLTS9ZOmChbDkxp
         5ReQ==
X-Gm-Message-State: AOJu0YzTbIpnM4wrP2TFcmDOBUDH2Y4ABwaLepjQHB9P9O/sT3RKtzyH
	sSHBtevI+qI6h2+FRgXzNhm3UaxtPEyMfRGq2CTLaYHd/eY597hIyLOL++45GXsL5ePBfCEhJCw
	neVKX5LeNqliqWJtxoCpFO5TvzL6urZ8=
X-Gm-Gg: AZuq6aLys7kNnUc9MBaVR7hHGvdrsNB0K9Kb4uYWnopczRMkMTHGQlrSHfMosKPuw7s
	3hVr/swxiWP8ZySvODcUex2zwh1+7UkB4ziZHFaHQk7iI+nl+leYJY5UKCN5aA06e0BC6OiKHax
	vOKuC1/nTU6i3W7TH3kvMCqxF5TkSjvmsDPPKbLoIXU9Mf5PY1rl1rzkh9913BhAjk2lU1jWSmY
	FWER4Tw3aOfXTfHaKkKCaH34H93s3/B0z3RA7qSjr9em7PkldMwP8JePW44s5t78BRfcLHU6ZNY
	7ZGFGVGDjBjQe6WPZNiriC7z9jmRQTxNxGJyXUUtdjLCbWRYY8fFyN5SsfAG4g+5M1wDFJNllkq
	6k/AbQd0k3Nnp1vIi/uQzsIEoyBG4esWY0adN6PuNtVAKgMJmpw==
X-Received: by 2002:a05:6214:f24:b0:894:7852:9bdf with SMTP id
 6a1803df08f44-8952211bc25mr17389686d6.16.1770164044012; Tue, 03 Feb 2026
 16:14:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Feb 2026 18:13:51 -0600
X-Gm-Features: AZwV_Qhxn41M54xaHij0Xmtlzf0sE7cDHHibJ468GfNsDM0F5YY8sIpwq1x2X4M
Message-ID: <CAH2r5muFeTGASj_7gRrhJq+=k8SA5aEz=oOHzxOfpHojLBsSHg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
63804fed149a6750ffd28610c5c1c98cce6bd377:

  Linux 6.19-rc7 (2026-01-25 14:11:24 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19rc8-smb3-client-fixes

for you to fetch changes up to 67b3da8d3051fba7e1523b3afce4f71c658f15f8:

  smb/client: fix memory leak in SendReceive() (2026-02-02 10:13:57 -0600)

----------------------------------------------------------------
Two small client memory leak fixes

----------------------------------------------------------------
ChenXiaoSong (2):
      smb/client: fix memory leak in smb2_open_file()
      smb/client: fix memory leak in SendReceive()

 fs/smb/client/cifstransport.c | 4 +++-
 fs/smb/client/smb2file.c      | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
Thanks,

Steve
