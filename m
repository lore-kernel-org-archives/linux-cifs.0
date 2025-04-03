Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC7F15575C;
	Thu,  3 Apr 2025 23:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743722001; cv=none; b=Adxap7aj0bZga0f/QARFx5aG0UWwqj5P8XF2lXj9jmRm8bvzlZlfBrs1j+jQQzEFbSZqzzhtgEJAtgcz38PPVOKvCmJbHzcIFmuYrCN7IBRlrvf0z5tzI/O7staVTqjmpv1Sd8nOnq56nohLl1T1k8pcFSaX4FzCW/YBbzVE1I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743722001; c=relaxed/simple;
	bh=e3nY7G1MnkqvZI4wdI4XXWDUwIsle1hoW3aHxtZgBek=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k9jtsoXD50ZpQ2swPg5ao1t0ZslvDTPiVoji9sLzU8eRxMhCUAc2EJvPoQkE8nZq12bT9sISWwKGbv/TzVerexqxuSfVOLlfBUEhExthRreBeTptweNXMcnHGGnGIZiVlbrW69RO0c6OPtp1gLKILM9cj2FxX+TKbTkZga/erwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bhxgSiGN; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhxgSiGN"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-549b116321aso1643908e87.3;
        Thu, 03 Apr 2025 16:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743721997; x=1744326797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=75t25IppdmPk7Flb4RStCXZL6ax8PX9bZxFUqFFVCRc=;
        b=bhxgSiGN3Yw+wZmU6FzWXftdGt4C+NB8EQ9uyLu5KOqqAXQNyOJpeEFfLn1tMqTMWT
         jWIxmD88Ctim0A2jqssJAvtNdA+EyNUKovmBO+3U3ogGGwur17/QQu/+obRCZtCda0aV
         nWuANvh6L+ciKOCDJ5W8udmrnLhFoaiqm3UdN2aXHtCUkGpeAnFOiF4vAURkwvRvpL2F
         PxuI5JCs/1oghh8973fI/IzNBNFxsT4FgvQRY8iB4Yl6HpgIx8iqyn6+gLm4nULJ+5Ya
         MISNWW04rCyQXcsXTBd7otxCHTvnPrjsyCaBvRH+XUHTrpa/zOD/AQn2iTGrFrxMZdka
         Hp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743721997; x=1744326797;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=75t25IppdmPk7Flb4RStCXZL6ax8PX9bZxFUqFFVCRc=;
        b=rzOx9Or+hN72aB5WUPY01RYgHoc/gq+oISt1VKfVolItcn3H3/U6KiKIMteR5/AV81
         kFrEOjN4euui9VhhkntjGKiLONjm1OB9j9AAakkGGZ/7gnONNWnvA9aR3gKfVTywnJd8
         IY+z/p+krktdCUq24gFKFHaDvTYaK0PZodk4LOa9Yd8WSzBj+38GWJrDz8WxCXOG20PC
         7IH7b4rotrVXy7cw9BsrCuU8GQTk7TJI0aYFv/6JTbDGAu4QAL0BJvzNYDnn+Jh1Lgfh
         PjXfp+PKEz7+kvd7g3qivMJBpplzYCoKfzoxoISZq+i6Ci4gh94xNepd7DY+8YROmdio
         W91w==
X-Forwarded-Encrypted: i=1; AJvYcCUZGNZDYPFnBdl7BXJRSbYZHBPbwo9G2gvHL2i36fUyHWK7Cr9AHdcpvYA+Nnq/UpKnOgYIEszIIWD6@vger.kernel.org
X-Gm-Message-State: AOJu0YyfBjxsp4zidzUu8yYSgwjoIWaIfbWm3oeUwKlV6eMRvAXSi1+E
	8N1d4ydMpksdiRd2gwJDBtcgIfBVUQYkcoQ1K52BcISYIX5+dzk3omDBQb/9mkTOIVu2SomAdUB
	rxyvDCJ4ykMn1pyc37oIhUW2zYpM=
X-Gm-Gg: ASbGncsIvCB3TJ/Nki5YSxZR5fpcnR8E5ixL6KvhgSGwu5gC6euK3ZkEvb81mNUNZcp
	uQvVRjHQYRwJLQCJvkAXtM9uBeaHnJWQQBiprxFKbV13U9i2P6jp3rgqstQdVcEzXDSAwLv/e+w
	b46+ZgfHNnx57Di+01PiXiVa2nM3BJSRhu6vdY/7Q1IAPuswfUiKFioMGtght5
X-Google-Smtp-Source: AGHT+IGBf0w8rFulXBQj7/kYTyuyUjqPntBQYLIUddiMFsXgfVckjcKBPtV9eoNlMZBwrYGk7ehp+VUNPVL8VltCUU8=
X-Received: by 2002:ac2:4e0b:0:b0:549:39d8:51ef with SMTP id
 2adb3069b0e04-54c22767e8fmr256125e87.6.1743721996769; Thu, 03 Apr 2025
 16:13:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Apr 2025 18:13:05 -0500
X-Gm-Features: ATxdqUF03A5YwM4j0Y943KSqXPeRdhdzMJYXJnpm7aTB6sFMIrvzhCdsY7gJYFc
Message-ID: <CAH2r5mufSJAwwbVgNTy5eFLtEUNZGuRt9K8-LnKBTKd8A+Cu2w@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f64a72bc767f6e9ddb18fdacaeb99708c4810ada:

  Merge tag 'v6.15rc-part1-ksmbd-server-fixes' of
git://git.samba.org/ksmbd (2025-03-31 17:42:26 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.15rc-part2-ksmbd-server-fixes

for you to fetch changes up to c8b5b7c5da7d0c31c9b7190b4a7bba5281fc4780:

  ksmbd: fix null pointer dereference in alloc_preauth_hash()
(2025-04-01 23:02:20 -0500)

----------------------------------------------------------------
4 ksmbd SMB3 server fixes, all also for stable
- FIx two ACL bounds check issues
- Fix two important session setup issues: one for malformed negprot
and one for race with session destroy
----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: fix session use-after-free in multichannel connection
      ksmbd: fix null pointer dereference in alloc_preauth_hash()

Norbert Szetei (2):
      ksmbd: fix overflow in dacloffset bounds check
      ksmbd: validate zero num_subauth before sub_auth is accessed

 fs/smb/server/auth.c              |  4 ++--
 fs/smb/server/connection.h        | 11 +++++++++++
 fs/smb/server/mgmt/user_session.c | 18 ++++++++++--------
 fs/smb/server/smb2pdu.c           | 21 +++++++++++++++------
 fs/smb/server/smbacl.c            | 21 +++++++++++++++++----
 5 files changed, 55 insertions(+), 20 deletions(-)

-- 
Thanks,

Steve
