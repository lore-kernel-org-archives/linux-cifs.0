Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526E4225409;
	Fri, 11 Jul 2025 13:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240101; cv=none; b=NKuPKGF8E04Vj8+ak9JZd0Odtwvoy5FTR9BKV16yglkF6ZsKZ+TRFheJqp95Vfi2JETEkTRplJrBpKA0R1FARHsou0YJiLdkB81eguoC9ZauB727zFCz+jq3nGxT/u/IVp7dvQsOYLeN+9lOMsu/aLYRwYDYYqpXJnatwcTID8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240101; c=relaxed/simple;
	bh=dSNAMnuv+BkI95d4Dm8/FiNySCqZ9pAGdkc7mtVgEZ0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=m3qgEaPk3R1BOzayPCZCkku4ZtZo16U3/zD47hLuo1Emj2n89xqTmPNJK3vFtLMSY0eXpe1rKJqUZklYmHJhDw5QLDC2zslulgw1HQ13r4zdHloGL9h38FobR/LE1GeB11CKtSMERQ+7wTpZWrCYUfkWO3Phx9rsuYOdOdTdR8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Job6neyJ; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Job6neyJ"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6facba680a1so24743486d6.3;
        Fri, 11 Jul 2025 06:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752240099; x=1752844899; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EuX3ICAYnUTpsZWVFSGh4CguXQXupO9Qh6aMnKpy4og=;
        b=Job6neyJYNTbG7SP8ICGIB/3EtP+gldt68BP8mX8i7rvZIhL4aArMeBadfUHEP0PY/
         32v4MGPB2lQhv50rZIIL/6rDLYIwGIU9uq/FuneXA8RkCfiUr3oLDmSZBk1lLDV3KpRk
         Xg//p8Mri2SmHMoDjUPaSnFbc2kR7kkIGHm5ZC5rJWOHQVSMIuqHb4Q3EGRHdl0MkcMa
         jG5zeGwIPoKaI2lT3uekyBMksoWz297z95bLv1OxF13E3ohWGfbhtumklJK4GN2QBWEJ
         rL5jt1vWLJwig6yeLxdZhEidwumGxb3VEAj2sTI8dfEZfvjZQn3a1hkYrNBWePhW9gVw
         7PRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752240099; x=1752844899;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EuX3ICAYnUTpsZWVFSGh4CguXQXupO9Qh6aMnKpy4og=;
        b=LhwMExnKIKLnRlRCZ5rDl0GNCN69GpabJZIb6bt7asFy4RdrWFKFvDNrUFdtmEaFnl
         X9oJXa7X0PYCeyWBz2S/wtMX2Q3SFYFZ0683vRsZFVI5QS01HXzbNiIbSHX6fx0gXnG/
         uxaHmcMzbSnz29ojPncOTV9drJx6WAnrEvujcgFDbLMdT+wdGjw2cJey3U4e24Wag5xm
         pHSDLsh3gJLvIAnOjNR33R8InemR8EE5R4gCSVzNKS5zyQcWWWAKRN9tRjHglzj9v8aU
         JoyxyWrtGQ0QlBgO0hIboet3uuKDgDh3By5gXh+tn/5juPTm1XTgKYygDVP8m2I1YxVf
         51ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBbzyzpyBAbIZon7T20XNy0NftKv+bYEpXWNc1mA6GMwKDIBPXqQoNiQ7n03oQ7ds3vLhH6HMz+x0V@vger.kernel.org
X-Gm-Message-State: AOJu0YxsuekWEgg8sU/5bgGZ0NxMlipirKjEoHas6nZunx2cVlZwC4Ik
	iSfrLhjzcY9rKuxaCXlbra+pvPRfc7INFKhSSEzy46XK/R1bfAucHqG0mxh9x0GDfTgKitPt7FW
	NFrnk9XrHyfdLvJOq7JbLJ2IM6HOo0g4=
X-Gm-Gg: ASbGncugGpbEOo8HzIon2+XunZIfeURfaGueBC0VOwA1Y66Dt4ujLdPvajrccaEwzyj
	ucgZaFv5hQQAwaoxfFV/3/9A+/YRimd+pJmoS0UDaGhyDO+V1AQ2JoTrqnt/oAh3eyf2OSGawI5
	Wi4JiGqTP+tTuyQqBQiksaH3tZrlGBUtsbF6dOkgZkHz5u1jCP9hMvH9TZcWQVm30b3NVjKER/9
	EMfeVV0S45ytIf6eT9BGpmqK57tJIdkZmloJZEd
X-Google-Smtp-Source: AGHT+IGm5UFwGN+IqEb9j/2jjIxWU24Nptwg28TwetWgtXr2Ofq9kPhrZzWZgzFxysg3OmZFNeVAW3hATnNP7aGRqCk=
X-Received: by 2002:a05:6214:1d2d:b0:704:8916:dbc5 with SMTP id
 6a1803df08f44-704a4084244mr54191016d6.12.1752240099144; Fri, 11 Jul 2025
 06:21:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 11 Jul 2025 08:21:27 -0500
X-Gm-Features: Ac12FXynEwK470HqD-sPgNDYwSbpIEiGKBvZ7NK9L9Vz4cMZWpeAFoXdS_4b4GY
Message-ID: <CAH2r5mvKVofnEbFwtqAMcA=R6Q3Prp9hzqzBPEoAdyvJGgL06Q@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
d7b8f8e20813f0179d8ef519541a3527e7661d3a:

  Linux 6.16-rc5 (2025-07-06 14:10:26 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.16-rc5-ksmbd-server-fixes

for you to fetch changes up to 50f930db22365738d9387c974416f38a06e8057e:

  ksmbd: fix potential use-after-free in oplock/lease break ack
(2025-07-08 11:25:44 -0500)

----------------------------------------------------------------
Three ksmbd server fixes
- fix use after free in lease break
- small fix for freeing rdma transport (fixes missing logging of cm_qp_destroy)
- fix write count leak
----------------------------------------------------------------
Al Viro (1):
      ksmbd: fix a mount write count leak in ksmbd_vfs_kern_path_locked()

Namjae Jeon (1):
      ksmbd: fix potential use-after-free in oplock/lease break ack

Stefan Metzmacher (1):
      smb: server: make use of rdma_destroy_qp()

 fs/smb/server/smb2pdu.c        | 29 +++++++++--------------------
 fs/smb/server/transport_rdma.c |  5 +++--
 fs/smb/server/vfs.c            |  1 +
 3 files changed, 13 insertions(+), 22 deletions(-)

-- 
Thanks,

Steve
