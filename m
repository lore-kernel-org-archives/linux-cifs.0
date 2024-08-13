Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3576D17BA6;
	Tue, 13 Aug 2024 02:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723517839; cv=none; b=C3ZUEMUbXKS4X2XTTAAhXkv8wUoMlJdwvGzaBwzmJnPlbm1De5oa49k2ompVsF4dIbzBCY/TkAl11LvXLyc3B9s1QIUAhYx7E9rYkWlCYxfx+cHr80MMucktADiQHlPZL8Zc8FEfFFpCWAHdbxZbYhnlgkcj+8dCmaPRFosDqws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723517839; c=relaxed/simple;
	bh=NbuWSsfWO7OXBBd8+8YHEHbJ6H15j0Rc9ZOUpmvs5dY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FNgGxi+gvqsx6SvflBPeU9z/dquB3ILB3An+DJM+xIa5Twxdu7/bvBgw1CkN8mTPM1wyS2TsylEYkfs3hKsfX130v+YtU5KO9K5u/yyye3VlwmHVDteZbqG4aaPOrnLfQjRlc/NXcc0umS8Jl1brrWsLBxRS8tfIz6gNW3bdbbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iiZGm5wz; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iiZGm5wz"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-52efd855adbso6302409e87.2;
        Mon, 12 Aug 2024 19:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723517836; x=1724122636; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f6wH2+oLPen397N26sm4V5YXSI4rXx3+DYcxWeal5y4=;
        b=iiZGm5wz5wve8wbfX479csL6i2sc9Ai6cWcnPfvEcDx4/3gwJlqmAMxXj12h5Atf+J
         kr0bAXflf9tbnsbxJrJALg1XtimwXqCpsrYAmrhn5DGJYrwYL95rIh3ogx30/o5J0Ja6
         wE1WiF0yMmQdnzr0U/e/0M489VUAb47OC/IyuWPo0mScANZI3yDQ99Bb5LiU5i8om4LD
         P7UExXhTs3wqFDig82/J6vFcgVJHd/1xwDkzckqrHc4A/IHfHKaXFIBD4ljhdJIQOVDD
         sSdbd8D6aUjsDOIO92PnEOSqKMyu+r0s9V9uSzgOuAh+hODTCgREaC5MuMtZilLkCuh9
         1Ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723517836; x=1724122636;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f6wH2+oLPen397N26sm4V5YXSI4rXx3+DYcxWeal5y4=;
        b=iLZn7hAyZlaXgyzN4HnZDgAC0FnBKrUchJFUhDf/tpJgpbQFmL/JtV5uzkxg8eAuFH
         yYe2zelGT2yQMSMCMG+EPeWcGVoHz/YnEtBLjVRbCExP0TSQplcgfVmBrGto450uB9g6
         FUC8fMRIalNufn97l9bvchUoAvD6Ck/jK2/ZXNQNj9J0F99LX9Jgq6x3wet2WK8jAk4C
         /LLoutjStwGCQKBOAiaDlXNZC7aTI+9cRUTCNFDUfUESXAO+6xvHU46CZ1+yLyIf3qBG
         DIYISbkf1OS/aj46/Pc0zgRmUMwbk4dzlHTMlTpD25IYmwn7vNB/QGYSMapzLXbe04dS
         +Z9g==
X-Forwarded-Encrypted: i=1; AJvYcCXltiLax0icUZB3STTlEu9VRd6Hp26qL/klOyfw4yn4JQrc88UZZq3qRx3Fbr19OpVnCOPqduW1UdKSBkqq/K7Y4w99oY+SWY6NBQfE
X-Gm-Message-State: AOJu0YwiZY2HoGuex6Qcm8wF3oHnmkNzGGEDQjYdZmIz072QW0bXh6b7
	RFHY7T5RkPwvHC7G8V95yDmpJYpEFZxkUP+GcWf1Bu2Bp5JsJN+XGTedJg9+aNWUj/yZkDcaiSJ
	rZ/Islr26b0pEY+BtSSXB3zAKARNz2ZLj
X-Google-Smtp-Source: AGHT+IEPJVgxazoRtoq7E3354DYuPh4VoSBhQZ2Mw0kIncBcJ87Envj5B3ny1E10j7mV3H3KBYhJI/O+/HjXu7/GXsw=
X-Received: by 2002:a05:6512:4024:b0:52c:e312:2082 with SMTP id
 2adb3069b0e04-5321369454cmr1098872e87.54.1723517835745; Mon, 12 Aug 2024
 19:57:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 12 Aug 2024 21:57:04 -0500
Message-ID: <CAH2r5mse_XmxXZy8Xhav9S3K2pBvUTPFqf+jhJtOoCn3hM0stQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.11-rc3-ksmbd-fixes

for you to fetch changes up to f6bd41280a44dcc2e0a25ed72617d25f586974a7:

  ksmbd: override fsids for smb2_query_info() (2024-08-08 22:54:09 -0500)

----------------------------------------------------------------
2 smb3 server fixes for access denied problem on share path checks

----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: override fsids for share path check
      ksmbd: override fsids for smb2_query_info()

 fs/smb/server/mgmt/share_config.c | 15 ++++++++++++---
 fs/smb/server/mgmt/share_config.h |  4 +++-
 fs/smb/server/mgmt/tree_connect.c |  9 +++++----
 fs/smb/server/mgmt/tree_connect.h |  4 ++--
 fs/smb/server/smb2pdu.c           |  9 ++++++++-
 fs/smb/server/smb_common.c        |  9 +++++++--
 fs/smb/server/smb_common.h        |  2 ++
 7 files changed, 39 insertions(+), 13 deletions(-)

-- 
Thanks,

Steve
