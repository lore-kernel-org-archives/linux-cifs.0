Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3276231845
	for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766076519; cv=none; b=uClRAiip+De+JjCBZqsHW+oX2nIxQBtvZoxxG4U2oJyqlKP5iYb+xafMCQq9d+1p5owi3aCXpBR2FAP/PoEPhZgSlru1j8nG0sO0ECoG5wqW1FjjBkTEDd/8Mx1r35qWUDx6lRnYzErV1cmFKIxAFLGHtjKq8ZQeThxk5AfGZzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766076519; c=relaxed/simple;
	bh=Kk018iHIf5ZFmooGRmZFOCt43CRly+SvfgKpMRht6LY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=WDjnxKxCWiHNxMXmwwfnHtxDmZP8k/wKRdmpXVXGluzZfcIyvR7Cxus6Tf7Zdh87nbp4l2aUaTSwEXpSvt8e5ytB6uob7uADCHjefK9LvPN00dJbveOgMMMYjLRFVvCEcVQtdjD+7aW98f/YdsNFx82re1K6c+JmAZW0IgQCpp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8Ey1XbV; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8Ey1XbV"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b2a4b6876fso130315485a.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 08:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766076515; x=1766681315; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MLpoJSmCfWycvShqEwJzCH9EVU1nJAFYZqCQsxXxh70=;
        b=Q8Ey1XbVgN8xIao0Nj72PNrRwff0xEYQBRFlgL9UF9wBD6A7AmJ36pt3tTBgDNGM9H
         /Pgn+5gP0Fqk8rweYzgmgGeDidHaWdcxwENPZYBhKnYhEHSDZeEo7opHx81gk6IVtnxn
         +KnamniUNi4Kqo95fzXWzpbZQIS0S3U11KpltFKhUtud1n+dDYElYmt76Utyq70aB5i7
         yQ9z+Ufw5+qHZb0nSQBfoYTQLbpUBXkTFP2H6Y09pvNcSfv3MHJ6PSQJRggJ1+ICDq7c
         NgrcCnWehVYVgZ83llTxeyXJP1KXEenz5vY7GKVFUK9XliAIq5SjRattdRKjm74wjVqu
         uHAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766076515; x=1766681315;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MLpoJSmCfWycvShqEwJzCH9EVU1nJAFYZqCQsxXxh70=;
        b=Dr8TueB8eR8r13UO1T4fPKeFY5NBHXtTs771xnRrcsea7lHI8hyUwUicVZcjhmN+qx
         zLA3Wwj1S3OOi2WkBvwN1gnNDudMSOx5dVYd5pa//hGUz1lhzmAvRnU0UppLWLhLn6i5
         9VcCdD47X/uuf1oyMDsQG1t3KBAUmnesKMkSWY+TAsCGpQuw2X22gx0Df8zHcB0KE71g
         W1P0NowTbf9f+SV5xq1kTpDHJJhiojaSjztCCq1Zsc+IBAmanbTE+fQ4zMvD5MAiUeHn
         n/6/+UJB/yT64rIVfbfdBnfYC+GbRvFEE1cLDh1oafaOdcaSlIqOqy+eA5Hmv+q36oEu
         wF7w==
X-Gm-Message-State: AOJu0YyyyRJ46QliBT32Z1Db4oa2zBemznJsms3gO9w1j0raa2/J8JvR
	vxoSHkt/bJfGbKu86fIM4LwmYyqziQg7dowAw8oe7uVAYC9OrGdiHgkl0BXX0BdB95/ck8j/+nw
	Nia+tTI+Jx0zlC52BBBO1K4Wn/fILKjg=
X-Gm-Gg: AY/fxX59D7symusqL4cxv8wShNU/WSitiUWohmAV1KsO2n4ANhEEAtsVK0OGFti447F
	KdQc4yzzmQxCcRzgzFenMYxWZ2q85olID601XNBWop0TC017pH9fvbgpuOlBfpB65mUxs3dh5iu
	besWzWo31OoWFgydyNlkkfSnAFYCH9b5+/z0fIBc6uyLg/amHpgM8jaaOsRkIKLthLUf4KiL61M
	OkW8zlz6rToDChd3U9036VY6jVmA7nq5L7+pvhJ3hjXH1DZfupXsQGASJVWSyNaERChw7DECvgr
	KF0Pf4bLdNe/2e/zNEibXMS8sr9UxmY3busx6ctwIkTIXCpJiwBiwQe4SRv/0aGJQL7pfqIT/mI
	uGDfuqs7IgNPcdCDgOuWGZEu0CMexwW0v/j2q5cKZix8d/m32HFM=
X-Google-Smtp-Source: AGHT+IFx1mI4k+UL84MzSOrCwSrXOX1KoyNVUlYQxw//z+bwcxyexunq+mTAZGNMPUCMdW0i9+pvj6UnB2xJ6p8B/RU=
X-Received: by 2002:a05:620a:198e:b0:8b2:f9ac:a896 with SMTP id
 af79cd13be357-8c08f67b906mr45284185a.32.1766076514719; Thu, 18 Dec 2025
 08:48:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 18 Dec 2025 10:48:23 -0600
X-Gm-Features: AQt7F2rrXbIXC5a-ScQkjTgX-JnYGivLkhlci4bAZDH88wUR4d2nR6b_cBkN_HU
Message-ID: <CAH2r5mtxKs7+wFMoE2m9gMZLc9vr3Jj9eEm21JZCNsunuiydDQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8f0b4cce4481fb22653697cced8d0d04027cb1e8:

  Linux 6.19-rc1 (2025-12-14 16:05:07 +1200)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc1-smb3-client-fixes

for you to fetch changes up to d8a4af8f3d9d3367b2c49b0d9dee529556bdd2f4:

  cifs: update internal module version number (2025-12-16 17:43:02 -0600)

----------------------------------------------------------------
3 smb3 client fixes
- important fix for reconnect problem
- minor cleanup
----------------------------------------------------------------
Bharath SM (1):
      smb: align durable reconnect v2 context to 8 byte boundary

Steve French (1):
      cifs: update internal module version number

ZhangGuoDong (1):
      smb: move some SMB1 definitions into common/smb1pdu.h

 fs/smb/client/cifsfs.h     |  4 ++--
 fs/smb/client/cifspdu.h    |  2 +-
 fs/smb/common/smb1pdu.h    | 56
++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/smb/common/smb2pdu.h    | 41 +----------------------------------------
 fs/smb/common/smbglob.h    |  2 --
 fs/smb/server/smb_common.h |  1 +
 6 files changed, 61 insertions(+), 45 deletions(-)
 create mode 100644 fs/smb/common/smb1pdu.h


-- 
Thanks,

Steve
