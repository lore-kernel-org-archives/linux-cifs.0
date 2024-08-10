Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B62E17E;
	Sat, 10 Aug 2024 01:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723253808; cv=none; b=uVjwtZg5FUbd/PZEISdmUCMtfVzwWC12HKdJiSWxLdmedT3LX8oQSl4MGaMkmX37UgriYKQ9IDyPlz2pKiKl7jER5e6BLkn0U1mUvcdAOi5BNuKTJleNvt3AwgqtQ5wuuciweyOLGB+vNsxCRZ86zQ7jzBGtTYC1Px4sZUN7cCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723253808; c=relaxed/simple;
	bh=ovDSjaWA4UZc2zFo0K9ugf1XYIcTGjplLNNDg8OESZY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=GlvUgxkMm7MAI/BcJ2iiANCgmJugY3l9PnfckytADd0yDcNB3FIIgOXeq0sYpb1AhTYeGiJpkM6+1HThlCVfM5/YwNo08gSsuk3EtoWIb4xiD/Ydj9ks9XSkaYORlq3V5cFZafV+1bAdUk4PVjkaWN36E08Q4boRB1Pxh5fmRu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ULLyWSP+; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ULLyWSP+"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52f01613acbso3965840e87.1;
        Fri, 09 Aug 2024 18:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723253805; x=1723858605; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ovcxFeZ04U+4eILq+6LEeB0Uyx+NNjKjhdMdT/I8qs=;
        b=ULLyWSP+/Nv5yPJYFcYdInEf8OrFPK4MbMXPADY0NJPX/qbW5bWbcSOrdCBMnjaiXj
         ZOaQrnFcXslUx+Iaen4dTfLww7STpTu3z/ArzyuWp9PNEvadfo2orK4AeXJW+g/bIptV
         MUoA7xyFO+R3ZPu681cXMD/42MQuo4mDAVDY2UFd3hR1DppY2EIU1BEhjOOa+gFvmivE
         SmC0g/l2wFyrj+qj7O4FNPfXfPk6ROzKwj3UO4huTOCgT4r2zOfjtlvaKd8RSyQZhMk/
         AEPIgjv/5Bx3U5SEYpwAS1z/83NceRcqMd6h7A/uINkeWhcuSsUu5jn3ohgeG30z6g7K
         9h/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723253805; x=1723858605;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ovcxFeZ04U+4eILq+6LEeB0Uyx+NNjKjhdMdT/I8qs=;
        b=ecSGbmcStAFd2A5ZBRKWkMjylooj9uEo13vZxYxhbvkjZn7crUGrmuL7P1Acu4JPWt
         pE1RHWbPndFMhAOuEtpE32NU61WKXOFZUd3lG7iLV7x4B0Oqvex9kb1M68UgoVA41MPm
         6jnGGJLke/plCu8F0S5n+r58l73owtEOfqojOa1dGzWODfIVJgOm5i1X/S+2AriMr8da
         d6J5n9zR/Uex53iuGtzPVKpzihATn1iLFqRLnmWf6byous3Ajjv6BDRm00xgB4Ywrlm4
         Ffa+3Gx5L7sIZO+l1HVd3gaPb0daLPRk32jXwkJA9+1y4F6XHRIBQj/Z2kF018PtViYd
         D3/A==
X-Forwarded-Encrypted: i=1; AJvYcCWOi2Hc8X/IRmUc7DhT0GKdSNyMY1QQoKGK302at9KN6SM/+F6rIkHrJXZhFTVZCYltEbP7mo0W5RrEuDePvr4jI2RODj30qX6c84FS
X-Gm-Message-State: AOJu0Yy4A9MKo/tmHxTcklj99QhRvk/L+joWfWPTuppb9CJCfCkr5NKL
	eAy2KyaKhVIbc/jbnSWap9V50nkpt6Evdz86k3CK6G6DY/PYQEq8GjRP92bXfmc/b5mAbWps0dJ
	wslG+Xh4HA7KQclYy1g8FTHLBR4KrspJL
X-Google-Smtp-Source: AGHT+IE41jtPDpv1dnbK9RrtdFpEgZFWEjqrcbIxnNXd643+dUxnMHVjwNgVe4sqPgPAJ+q2bRou7R/+b71hsHpVtZM=
X-Received: by 2002:a05:6512:31d3:b0:52b:bee8:e987 with SMTP id
 2adb3069b0e04-530ef5212ecmr990006e87.3.1723253804831; Fri, 09 Aug 2024
 18:36:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 Aug 2024 20:36:33 -0500
Message-ID: <CAH2r5muBCqScmD8xaiN87Dw3Gab-g4Ym8r9TB+uEq5ukkT=EJA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fxies
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed:

  Linux 6.11-rc2 (2024-08-04 13:50:53 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc2-smb3-client-fixes

for you to fetch changes up to 36bb22a08a69d9984a8399c07310d18b115eae20:

  cifs: cifs_inval_name_dfs_link_error: correct the check for fullpath
(2024-08-08 20:06:22 -0500)

----------------------------------------------------------------
Three small smb3 client fixes including two for stable
- DFS fix
- fix for security flags for requiring encryption
- minor cleanup
----------------------------------------------------------------
Gleb Korobeynikov (1):
      cifs: cifs_inval_name_dfs_link_error: correct the check for fullpath

Steve French (1):
      smb3: fix setting SecurityFlags when encryption is required

Xiaxi Shen (1):
      Fix spelling errors in Server Message Block

 Documentation/admin-guide/cifs/usage.rst |  2 +-
 fs/smb/client/cifs_debug.c               |  2 +-
 fs/smb/client/cifsglob.h                 | 12 ++++++------
 fs/smb/client/misc.c                     | 11 ++++++-----
 fs/smb/client/smb2pdu.c                  |  3 +++
 fs/smb/client/smbdirect.c                |  8 ++++----
 fs/smb/client/transport.c                |  2 +-
 7 files changed, 22 insertions(+), 18 deletions(-)


-- 
Thanks,

Steve
