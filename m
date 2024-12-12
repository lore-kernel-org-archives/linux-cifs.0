Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC0E1547F5;
	Thu, 12 Dec 2024 23:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734047243; cv=none; b=W0HetMS/EywzyfWEorNhcz/fbYvsIlUPqKaWGiVWvYlSND+65zn/zj3hfEwHkh+iXDlhGGew4QEpCcz1+tipNNdXji1SSxOFG0ojrLoU4lCZ0TNXoPBVN+Gn+Ysh/8KdJbO+V956uZti84+G8UzRXDkQOUKsjVrQuREUvp4yYAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734047243; c=relaxed/simple;
	bh=W+GyH4n6hltq6Xcckc8FpOPXVWn2UOdDDh6hMamzOJY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=UYzRR8pDJ1N9oUDNtCFXybsCbLufDtbWCRzlDYTOPFDb4D/Nwh/CzCk2CcT9h+oFyr/UQLnbR1dlfSpxk3GfErGUwqF4gGLwWEqSUs3vBGnZdzO3ZPJovACFrNznHdeHIp+vAoCu0giqzdwyfN6K3JCjvyAx+955YteKtiT8+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOAwAruC; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOAwAruC"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-53f22fd6832so1223164e87.1;
        Thu, 12 Dec 2024 15:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734047240; x=1734652040; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8eKJ8tH0Hqwf99KrK3AkhgJ+9ohNcCvPCUChB8kS0C0=;
        b=OOAwAruCRhX6MpCToG3PH9OuXG6whV3Z4H1FjTr4wSYfYRpicRF2oo/9u6ibfNOlRU
         wUzHb1wn/9H21yWNYPuhyt+ynAzQFXRZ+PJmmJuO5WhFc1gJ8T6kA8xeXYYRFaUeM3fn
         Wo+/Iu/1KlreoURbnVIEjV9F+Et6ARhzg6oVHLRBKcSH6DqP2yyg7c8jxrRAsLSgJfLx
         0eaJUig3TYlkUdXc0nvCQbTLdiGmcuoWB5VkY09vSsuqnZDgs5DwXGWKVjlcOuGgqooW
         xf3KATA9PSIVn+ESlOYtItalvnoYtd2LqDu9VouO1JmlDFru8N/oA4dY9iKdvRqBAzub
         MdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734047240; x=1734652040;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8eKJ8tH0Hqwf99KrK3AkhgJ+9ohNcCvPCUChB8kS0C0=;
        b=h2pZmaKIXz2esIEfrXkkTTT2F8yjef035KX0SWDEpkFPspUPegsapY53N+pIN/9taq
         hb19gUYo9NvMa6gBw5ZdGLPV2SXsBtrL6p8piaidN9rZeMJqxeQocNJq2rSpCRXOIhxD
         5MZe9qXfzZDPZculvCgwoLkhQrO4cdIBVrcmIUzZn6Fe4mJkPkIwlZ+e/3nV6IM2HULZ
         Ynue73wYYdGYGp0dKMCbO2xFt/scjObSvfolyifVLGr0XDsPQ7gItWmYfDER7wFd7Byn
         0lj/7K9XHB70iF2aqL0fkAq5K9vK2rNgNQVgz22/Hs1PHvnLlokYRj0ZWR+CpXTWXMFW
         rqmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFR3gEjmN7O34Vb5QVqUYKnRL+8Igm9nd8Svgx5kJX4zsjhG2W7n/YnytDsps5xM/LnKOh/tdDbmO6@vger.kernel.org, AJvYcCX9VNhY8RSS0h4YTNr6QnDkJ8QrGepA90OQcrERkSu5aIhn+Q5gS3c/A+74unNEyPLNhxMqlfRWGeL1j21z@vger.kernel.org
X-Gm-Message-State: AOJu0YxQalYzmpN3+3baK/4vou9i5XW0rWjteJUfb4zNtyMWv9cePYWX
	7USYushpDi9BNtl3eTY0mYHIsyN76W7VfPgNpcYnjU/+at9A5UamgBxuAYjDzUZDr3UJGrrspFw
	3lxR0IPhgbg5lq9vrWWwrA9Cg6jE=
X-Gm-Gg: ASbGncvbPVtVJgiztLoYM3K1qfvDSaGAbrqQgDXZmMdz3IsNFKwOb0Nffp1cfXpg4my
	+FsglfBQK2wco1MTM2IY5mSUtgsNXdKUVPVn+S+3tktB+g9+67s1twDWiqRactrgIg1CktvSc
X-Google-Smtp-Source: AGHT+IGZ+cpzOQ+i6a1wdmruBhdRzrBXTFDMebgACcdAi8rqhcpiGMCbmIj9W+yxBvw938xK7y2+5Kc4lF+I/Qcao3M=
X-Received: by 2002:a05:6512:401b:b0:540:1f7d:8bc0 with SMTP id
 2adb3069b0e04-54099b6d6afmr61211e87.49.1734047239787; Thu, 12 Dec 2024
 15:47:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 12 Dec 2024 17:47:08 -0600
Message-ID: <CAH2r5msa=s5=5tsTP5H1=8ruzKTaHs59xyORk0URRsWTb4Xg7w@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
fac04efc5c793dccbd07e2d59af9f90b7fc0dca4:

  Linux 6.13-rc2 (2024-12-08 14:03:39 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.13-rc2-ksmbd-server-fixes

for you to fetch changes up to 21e46a79bbe6c4e1aa73b3ed998130f2ff07b128:

  ksmbd: set ATTR_CTIME flags when setting mtime (2024-12-10 17:48:06 -0600)

----------------------------------------------------------------
Three kernel server fixes:
- fix ctime setting in setattr
- fix reference count on user session to avoid potential race with
session expire
- fix query dir issue
----------------------------------------------------------------
Hobin Woo (1):
      ksmbd: retry iterate_dir in smb2_query_dir

Namjae Jeon (2):
      ksmbd: fix racy issue from session lookup and expire
      ksmbd: set ATTR_CTIME flags when setting mtime

 fs/smb/server/auth.c              |  2 ++
 fs/smb/server/mgmt/user_session.c |  6 +++++-
 fs/smb/server/server.c            |  4 ++--
 fs/smb/server/smb2pdu.c           | 49
++++++++++++++++++++++++++++---------------------
 fs/smb/server/vfs.h               |  1 +
 5 files changed, 38 insertions(+), 24 deletions(-)

-- 
Thanks,

Steve
