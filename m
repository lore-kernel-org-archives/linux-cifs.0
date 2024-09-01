Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C1A1DA23;
	Sun,  1 Sep 2024 03:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725162111; cv=none; b=catglZtNtf5iA2kXDjiRixNb9+Rw+iHbCgkf42G6QIDuv6F6P1TuwdR4cL8y+JWsfH0peximqG1/BDU/CmIqwbRg2fAIoUMwVsMsfMnVeykhOLbmK/e8L5hYF0yt0aUpyyg3WFqiurACJgJOAe6HUvqgxks/l3F8/QSvZOHv9aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725162111; c=relaxed/simple;
	bh=UbHbmYdZN85OTNJcwDRV7i/N446ooQIH7A2dQJ1zbTo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ke7A9D4gabIRpLnXpL7L/5YJvsEBYfGvoHtu2zEpfeIIdMHI2jKGVwP14qsPkzq1wpm1bEmqi+zXlEd5eE0aoTThQ1TBStzQuaC5+w/GYd3roeE2dzKU1poC+KmtMpsEB5kJxCZ+Sqdx6EH4rycLa7B7ZH0hwO5AYu+s8NnDug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c3KZTeOn; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3KZTeOn"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-533488ffaebso3787803e87.0;
        Sat, 31 Aug 2024 20:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725162107; x=1725766907; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5LNp9eqIe03UDsSrL0b4OTI1ve1dbXw928LMQVgGBoY=;
        b=c3KZTeOnvpy/jCkwasJa5cXY+ZeGlg5rNxpR1NoHI8YSJvm0Kp7wyUwcUs6rGvD4z1
         KJ8LxNwBVnEpevaS2lIkZge5aVjbb1t3O/KAI3u9PNh/E0GzdS1wVb79tpUugnO3hkxz
         d18u1KdLzoVNVazdhA0I8GZU8PE62dFBAQ0+E3lm5mBokMmLdpEo6DzeGhNYj3XbjymA
         doZ9EfE56VYCPm6xeY8w1OakmrgeqSHXIdKw5jeke4SQhuWIMJ+K7L8YvCavkujgkY3h
         GeZ3HOfK+0xoVkoEOOdjLbbucy11psIF7Xwf72rm/T/ERn4DvVpBxlvpBVs1QsI/IzTJ
         raUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725162107; x=1725766907;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5LNp9eqIe03UDsSrL0b4OTI1ve1dbXw928LMQVgGBoY=;
        b=hv7L2N31QlV7HVIdyGjNvKTDlImj01sHfQ4F/7NejpWQ8Zdtf+T0ELKTx6CK15WpYS
         VoDxW64rRxKGR7Bv8h9aLe3KGGPyLyW/D4yysQgP9XRD7u3k+silGKgAC6ggQMdx9vV7
         flvPQ3LdwnuewgcTyx/FAOKjExhcvqRc7XapfmtJj/sXqF8Pq7LadH1WrnMHB3Q18Ozp
         XkkulsUfs++WTMBwqw0cDXwVomJvilwEeEwEIHMrrczKp3pIRxOgTfExb38mUUSx4nG8
         cfK4DoApoWDtrjl8FWqvZp4+kouIg7xNvTBdy+TMosn5wrkWsoBp/hf5Y6N/Q37rvc+r
         gWrw==
X-Forwarded-Encrypted: i=1; AJvYcCWLpFjzCTH7fl3vOv8mzjj4XffHL2Mv86IFSuDAlYSE84nMy2olaOPhUT/RAe7fa7E01XezSspiKme6aZA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAc56H63ewBl553aVp2ve/7UflnAPSA4M1kCypt9S/UU0WgCnl
	PKO8LHcCca5HkguPdrkJvaJoFCIxlJAdC3EldPYfToHEXQ/v0uXPPnz67UNjOtQ24647tBZnk5C
	JzpF+7RNa4AtgB+KyuloQvf/48NIsMozu
X-Google-Smtp-Source: AGHT+IG6zB4cwXelEIrZXUpKes9Owr+xL90iO4tPEKOSzvJ2IwVcY0YbUiE9XN5reRq7KaDl4y+8kM8KEpnChf1gImc=
X-Received: by 2002:a05:6512:68b:b0:52e:f367:709b with SMTP id
 2adb3069b0e04-53546b93fb3mr4833485e87.42.1725162107059; Sat, 31 Aug 2024
 20:41:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 31 Aug 2024 22:41:35 -0500
Message-ID: <CAH2r5msC4LbpzLmJVvkg-9xGXT051dNc0PwbY2dOobvQRb2O_A@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
86987d84b968b69a610fd00ab9006c13db193b4e:

  Merge tag 'v6.11-rc5-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2024-08-28 15:05:02 +1200)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc5-smb-client-fixes

for you to fetch changes up to 91d1dfae464987aaf6c79ff51d8674880fb3be77:

  cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target
region (2024-08-28 16:52:17 -0500)

----------------------------------------------------------------
Four cifs.ko client fixes
- copy_file_range fix
- two read fixes including read past end of file rc fix and read retry
crediting fix
- falloc zero range fix

----------------------------------------------------------------
David Howells (4):
      cifs: Fix lack of credit renegotiation on read retry
      netfs, cifs: Fix handling of short DIO read
      cifs: Fix copy offload to flush destination region
      cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region

 fs/netfs/io.c            | 19 +++++++++++++------
 fs/smb/client/cifsfs.c   | 21 ++++-----------------
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 37 +++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2ops.c  | 18 +++++++++++++++---
 fs/smb/client/smb2pdu.c  | 41 ++++++++++++++++++++++++++---------------
 fs/smb/client/trace.h    |  1 +
 include/linux/netfs.h    |  1 +
 8 files changed, 94 insertions(+), 45 deletions(-)


--
Thanks,

Steve
