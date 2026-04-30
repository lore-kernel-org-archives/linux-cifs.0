Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943842BE62E
	for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 18:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777574857; cv=pass; b=EC/ICI4OD621Xo3xjbj3/kV7kEv0ASxq6oe5W+7u+UqWcneuOFdiwfvsn7/wb9UUYJQB0qzSuRxqf8hGnjUMcyCMn7VpOyUg4aBu98XGyqzt9XPHI2QLA+ux77JPUWnG7GXmjkGPrYZG+M2Vr2PSYVxdyW9pGBOdTOd3IDHXFcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777574857; c=relaxed/simple;
	bh=whbimYf3xnyspzjn+jpf03D0Pfx1ZZEOqFqyB0oj+Yk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UqPTSmNyAJlVfl6t2boJCa0txT8dUR7LJkf0aQyD7yzepQrMry9265kgP4NlJrfufa6BmTTUoGPHE5pAZ509msZT5P7H0aKgikrHCvYK2WMEsPWo39dx15+qcsQnO2ssZozTwNlxQAXGW1noFAREtR3tunoHzSoz6cUvO0JOf80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dc8clnM7; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dc8clnM7"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c70b5594f4so128820185a.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Apr 2026 11:47:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777574856; cv=none;
        d=google.com; s=arc-20240605;
        b=R7/0GYw8GwC965GcrQqVc77nqEyA39QnccerzjNUkoG4hb20Ishev0Ao7EzMPl9eGJ
         lx9UEyWs+BwGSNgdS2lbG6qSZUc+lJCUu2rVkWcQF2e0ch6hLG/lMMmDeK9UWM7pJZ1n
         ih6WjOoikOZhlHZbPmBqHJvhvbkv6otkeLS8EaP6jQKarbtBe24vPQzKRc55TDFETKYp
         DjBlv0F4rPGUbCJVmjfSU2n9fohwyUtdyLXMGxar46BwUqJtONSkiOfx1rlKx2NLjeIY
         NB9rOBl/381odW2GWYejIrODV8Ec9xvduhOQtjURdMRR4+2mj2k7rBQwb4uKFqK/HqtI
         Gkuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8jjRms+6/2Kl4H0IlXWig648U5BW8h1jU9qe+FFToz0=;
        fh=/3K/S22DMzYMjk9zGECm9PRgrnnP2c7bBcWz+3ynl0k=;
        b=bm6YQxRusx4NaWzJ9psEMdhJ9MMbfGAO+sKYTcxstfoS/YVT2zYGpZgFE6gKWCBgkg
         XClaB8Y7RE7TsazQWLX9+4sVQHdVuhMe1rDUhzcr6N1UrOhZ2PnVRa/YJg87c9hVS+YS
         xl3hLqLJOrfVDEJSya/zC7B45EhoLPZNEIEBKjXgF35EqhHGKthImHPcc/oBg5tOSZCy
         N7L2IWSStb6tqWwuvoH6G+BN4fWDm1IRoIhH1/qQsrOFX7/NzGreaWdt77BvbiQKlESD
         Y4QoUKO6fMrcLYdfvHcAAZVAxo0LiD2SXYALYkk9d5CzqhCgckYtDgkVUPd6WFxs8yLA
         bfbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777574856; x=1778179656; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8jjRms+6/2Kl4H0IlXWig648U5BW8h1jU9qe+FFToz0=;
        b=dc8clnM781GUvwbfsMhsZGFsYSkkIVaC6MS0N89PST4e4H/zqYqKL+2iJetVPnQw2o
         xFopvEQ6IWmRYei8gWyHxYG2yzN8eN3pQ7Wi8E2bzrgvewF54V8c0mT/EqtDS/2nGc4X
         0ubLTk8pjaud7FQ/NahqAgd9QyiY/lpJrZ+6/iwApEo7O5fFvOMiKceHL8tGtkYeXFvS
         MXTRMm2VTHwB0HzO1a/UWv5Kzaojtt4+bC1el7l2MPAVJZJ/qE6y3NKL3Jgmouxz2lYU
         b1stuLUeJhwVXSnK3ENfRu8fnE4g5aA+UFo9uoh0pAdXSGm9iwUgN9+6KN4SEAvURkmw
         Xtlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777574856; x=1778179656;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8jjRms+6/2Kl4H0IlXWig648U5BW8h1jU9qe+FFToz0=;
        b=c+NqAqgpRds/UrWrOHcOHY0yiZKVXIIs6KMsfWPV3+KY4bHMyRzMvGqyDoprQjG8Wb
         KCmzPe4hNEaNCw24XWvEN2GAu6CUH9DoC7Hi35OUJH9PEDFBPkEFCYiAS+6NFNfac2yV
         EdowAwrBgoTlixmSKwMLYYEgsxXlywR5TxI2T6rKwr0rQ8ohWN8dKixun1uBjHYL5Bxn
         H6k2SYEkNSt3G2oTjP//TvkDFJdQLMycVx5dZTmXfx7BVMfGRQn4Lx74b3k2pk9AkD2N
         M/MqxemgbW7E7PWJoDULwqt8J1apsnNf9ZODAgJ1YXFn/DJCeBkSvnwEwzq7WX7VedNL
         ClGA==
X-Forwarded-Encrypted: i=1; AFNElJ94S63ipoqhjc3qruJHXRtHwk12TYKGucMRwLfsd9F3rNgFMUyELD2QKwnNGRir2iBqjDoazjuCOPt9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+dh44K6MmHW5OaTQ27k4Uza5TOOF5jtKp3MR4OwVh/XvMdkFt
	AYwAwD7U93zeVoZT/zwnP2htqcg5xYQ4OH/U+KIr1/xmSmLt508vM/RRTlqVHDkh9amiLAZrTSN
	z9HNXaup2JwV1VFJdLbVgRSRQ3cgDIro=
X-Gm-Gg: AeBDietSIOtXIMHRSaAKuN61uK+TaPNjOk6RUwb+MksAExJ/715fYIND6j8T+3VM7i9
	zwLic0d2/yMqDyjhtC83BVhE/fuvKGRvQfThHvQpS8Ozjh3HCydcrM/cxINLV3adFOipzC894qV
	+Lw2J46pH4X29XUOSgo6MD5k74S1+HQFWuUMMdQlO9DI/Wib8GHu7h3HE4Q+odilApKsTm/OTM7
	N+HQaT1kGxRyf/tAZQJpPFvjwIAij1KN4M29yYamnYiveoSrskT6w7596plm41qDJ7RQ96jfttM
	gwPOYA1JLjZX1vLosFUSPsIlJBRdRFtOYfPbqqt7aBhQhwPll5G/PK9JRk8SFZLW4Ve3+7xDZj9
	Jk1l1qFYQR0Z3DFWJ5tiirA1/dk9rCfSNqGf7QBbgRHS12E4dk4K+Nd2CRHmuk5SXjdv1Xqg=
X-Received: by 2002:a05:620a:708c:b0:8f0:c513:8cd9 with SMTP id
 af79cd13be357-8fab90ea9f2mr484513685a.16.1777574855596; Thu, 30 Apr 2026
 11:47:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Apr 2026 13:47:23 -0500
X-Gm-Features: AVHnY4JJ8TA6nEtiCmpy13eJgdhS4SSxt3tl3wTVCBUVz6QCxJxwYcDVkQTLA1c
Message-ID: <CAH2r5mugZbZGTBudyymjUYWkXSEBdAB_NaS=QN2upcb3FWGVCg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc2-smb3-client-fixes

for you to fetch changes up to c208a2b95811d6e1ebae65d0d2fc13f73707f8e7:

  cifs: change_conf needs to be called for session setup (2026-04-29
17:26:37 -0500)

----------------------------------------------------------------
three smb3 client fixes
- multichannel crediting fix
- memory allocation improvement for smb2_compound_op
- remove some dead code
----------------------------------------------------------------
David Disseldorp (1):
      smb/client: remove unused smb3_parse_opt()

Fredric Cover (1):
      smb: client: change allocation requirements in smb2_compound_op

Shyam Prasad N (1):
      cifs: change_conf needs to be called for session setup

 fs/smb/client/cifsproto.h  |  1 -
 fs/smb/client/fs_context.c | 31 -------------------------------
 fs/smb/client/smb2inode.c  |  2 +-
 fs/smb/client/smb2ops.c    | 11 +++++++++++
 4 files changed, 12 insertions(+), 33 deletions(-)

-- 
Thanks,

Steve
