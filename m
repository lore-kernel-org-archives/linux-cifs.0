Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEBB256D;
	Sat,  8 Feb 2025 02:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982053; cv=none; b=FhEK2aIzfKNpVktaYQS79Zu8FrWjCjm8mMUkBRnPMp2+HSeipkEeK/mw2uR021Mjqan27cbsQNQg735+w9mbhu1O61O0acYVG3ZfyPUiyZ9whft0p6phG4lAviHDFIg/lPGPwywfjZeV6yKEVWKScSAERmr/XcnFtn5thbE9VkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982053; c=relaxed/simple;
	bh=qOKbebqeuHt6n1mII4i0W7EGKZGE7zmeY9ANZz+TJJ0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Dal6fwuawcPTwFnBsl1uZ4D9wpsS1VxICT7/kuegBcMuPTqe2JT68+/pIdnkv+CfEu6S7n4yDeP6cNci3uNnZlfR6kfyTDecScdObmwGMXbHEbYGevuDTo1wzPnjCs4BOK8fH4A8zd9H0VZuwPCal1NlsWqYNZOF8A21PliF4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REqeOSVt; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REqeOSVt"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-545054d78edso142281e87.1;
        Fri, 07 Feb 2025 18:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738982050; x=1739586850; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nZaYFCzff4k2SD5IfCIdhLDV0dnYZaKQU4mSsfsSgdg=;
        b=REqeOSVtiBCPljJijsbvLNVx0BPrpXyMgxrwMBWDRimMsdmFHLxDJOw5FwpziE8Up9
         tcdA1OABKzIHXvtj1UYc4lvV/R7ItQfQinVmw6AZ2CqvLkpjC3sFQQ0ET8XXwE5MD2Ir
         /VJEs+jWHsmx86jK72R6oK4dqMkpL8mBB5cUgwQzWD8H5FiPr6bgcf9PrwYkwaAzDlRo
         zmSXSS7r9/piWEOjkOUtBDoKI9LipGpsa8Mw8Ldk6VrfwahGtN18BkILy03wjUmFCwhy
         3G4muhairjuilTaGVtGsVRlxepRjMY5OiMkAV6CYCkrg3mgWGSPcmr7teLOnP2XejZgS
         TGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738982050; x=1739586850;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZaYFCzff4k2SD5IfCIdhLDV0dnYZaKQU4mSsfsSgdg=;
        b=bzbJuPiY3BxO4EDCp/BGFIlNWrDS+ZAGuHmKSrCGR6EEnyPjBndjl8E5Fe8oiwPy+9
         x1rGqiFOubUI4ZDYE5n6pnuyO2b21TNQkNZCevUTDrXmFBLUsBpUCxqkhop48X0B/J5H
         tydJ0pP69mAMLt62O30/Z0Rl01yklL0YPk9On6sswaOEs3xvb57tX0mr4nHYQppbg/Kw
         7DD38azl4VoekeDyhC42Lylx8B2sBZ/F5hR7ApySolaeEKr+fanEhxbt6af3R57Px9/3
         sOD7Z6ZkUCJ6pZrYn+8PyMbJT7IMamHRZIW8KPeuc4fwwKlyPl8leRbvKs4t/f5ackPa
         eN9A==
X-Forwarded-Encrypted: i=1; AJvYcCXB+C0r0ZQhPniDbAbK8cND3+0kCSyUb26svksxnpRQHiEQp919YuNKFSBlys7tYx/LvktsisxZHe1Ni7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiYnlMCYwoMNMYFOKE7QNGzy+JR9SMbPoY79H7T+rL54bohsbc
	oB+zlwdx7d8HwuLwJ4oeeMKjxsASDCTjYlYLstDs+OrJ0v9KcPALrJ0cDAsrsvZCIwHpA5oWvjV
	OKVJRqEWj7KOTjBy+EbA+2rNq2YGeJ9/r
X-Gm-Gg: ASbGncuwtnG3iw7QBoE1l1Vawx+Ov/IUPM0GPEslTp+am/HGjFFOsTxQoT5V1Ue1Fxx
	SoeHCOUToCxMZmdgLnD1pf7m71rMd+IDgWsi3x0aqaZeA4oNMD8B+8Ivb21VlcFgD3ri08nZZ9g
	uscS+PRK4BJkxsWzz0XlYFov/wlw65TW0=
X-Google-Smtp-Source: AGHT+IHW8j47nmEFiep+HgERFjJG/gtUINHiQX5PAdjaIhY1IbOuBhnuKb5SVO3B/0z9gdIDlBuyoaPAQWu81Jr+eGM=
X-Received: by 2002:a05:6512:4006:b0:53e:39e6:a1c1 with SMTP id
 2adb3069b0e04-54414ae5f15mr1827578e87.43.1738982049984; Fri, 07 Feb 2025
 18:34:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 7 Feb 2025 20:33:58 -0600
X-Gm-Features: AWEUYZnQmzc2cx-7HcScyM-PBSLDZBXxMLz0X6rdHPeXxaTaOYHfVyrRZMkq94c
Message-ID: <CAH2r5muMvrt2ZT1OAF=mWxNssTg-fHcO-Zqc6r3OeZ1nrhMTgQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
2014c95afecee3e76ca4a56956a936e23283f05b:

  Linux 6.14-rc1 (2025-02-02 15:39:26 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14rc1-smb3-client-fixes

for you to fetch changes up to 57e4a9bd61c308f607bc3e55e8fa02257b06b552:

  smb: client: change lease epoch type from unsigned int to __u16
(2025-02-06 10:01:22 -0600)

----------------------------------------------------------------
Four SMB3 client fixes
- Three DFS fixes: DFS mount fix, fix for noisy log msg and one to
remove some unused code
- SMB3 Lease fix
----------------------------------------------------------------
Meetakshi Setiya (1):
      smb: client: change lease epoch type from unsigned int to __u16

Paulo Alcantara (3):
      smb: client: don't trust DFSREF_STORAGE_SERVER bit
      smb: client: fix noisy when tree connecting to DFS interlink targets
      smb: client: get rid of kstrdup() in get_ses_refpath()

 fs/smb/client/cifsglob.h  | 14 +++++++-------
 fs/smb/client/dfs.c       | 30 ++++++++++++++++--------------
 fs/smb/client/dfs.h       |  7 +++++++
 fs/smb/client/dfs_cache.c | 27 +++++----------------------
 fs/smb/client/smb1ops.c   |  2 +-
 fs/smb/client/smb2ops.c   | 18 +++++++++---------
 fs/smb/client/smb2pdu.c   |  4 ++--
 fs/smb/client/smb2proto.h |  2 +-
 8 files changed, 48 insertions(+), 56 deletions(-)


-- 
Thanks,

Steve
