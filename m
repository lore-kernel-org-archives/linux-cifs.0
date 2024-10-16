Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F75C18C33A;
	Wed, 16 Oct 2024 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729058973; cv=none; b=cVX36Q/5HWJ9xVzOPVnf7W6dQ0LThZT/XZOx4NjgXz3vTMgOeKIHpYHf1NccM0T1zIe9XzSg8n+3hERH+WJZRQTyblaUsYj9vfXkWVn2vPXKTLKizIROgGxSp+EeWDuian7mnImmRl6FiMWU+BH2iuz7hGkGMeIIo7ltg96fLhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729058973; c=relaxed/simple;
	bh=qhsBlf2+S2sO/JVtsIgH+mKSli4krVuxldOb8EhaK50=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JP9szZnmnwkysdhV+6GxlPqCIxdqXxwfaZCp4gVZJKhL025Nr7Wo2Hh1zmakOrGaL6y0XFYVFC+11kx8PMFZpZp3exG9lKvkvRgNu5NA8hgDxtIsXm+Mh7lpb3xFtEHQKHCbmgUcG/w3QJMashnZOfsyZO7tyGJ1YFWtUae/8iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHSP6MWJ; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHSP6MWJ"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-539e1543ab8so7524980e87.2;
        Tue, 15 Oct 2024 23:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729058969; x=1729663769; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vvnzA8TFWQAJitSHNBjUQHpW603CnRtwgxX6JpJykO4=;
        b=VHSP6MWJKCq2EOq8qfJOgVcoylbmnbKq7u+mhpJJyQw4cHj7lgeMSpbiADHOjiApIS
         lm7ahetTnIZOtObPlBLRQEeIi+PhGcsYnDcGqbZZk4pv6v8GsT6FFk3Y4XliIhYNiZLD
         mUlHeaYMz5GpdcWfFeRfqtL9Xzody2cL3URbnxpqaH+RcblA+AY47cpezkkApw9a4b9p
         0Tit+ZNwhnP9PD/sZPYMFpuyA4zoWqkkrFecE9BgN72SQxfv/qNdEPguw2SlibPsa/L6
         y0DxjgAXCHN0ux3T/nWG3Jz4dy6nYkw/J5AxZ7BWZkYVQjCLGHVpUqdFbcTgn/7a2t+B
         S19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729058969; x=1729663769;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vvnzA8TFWQAJitSHNBjUQHpW603CnRtwgxX6JpJykO4=;
        b=HfrH3XdMT5QuI3AXTpLCH6sEP6CI4jWxlYYPB+vR6MDsNEDYqWH0NNOvVQ+mqv7Cmg
         p2fafAzPz2e4YbNtvfrxY/Rb9lYKTEV6svE+Z8dCjw3WoWJGdpxmTblGHLevsurC5c7V
         d3HucX5EWJhCq3usBKdw9zi6HnfRwH9RZP+fddJIvlL0PJSfkI7hpN1cobaXa6ySDd1P
         av0Jxjb8Lwr03mOZNN/ISBL623HbexDRvqlDjq7kyaawnL7W2nZWkGmFSNUzugVjVV65
         Ke0VjumYduMSIiyyKLhDPg9H272HaDCvxr3es3dqvFXTfFA6TCbFa0B4yaAKoM7uWeyS
         2hNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSCBA/pe/yLCR9R3HiQYvlL5COHWIBB8UJaVRYpztX8LcRshGB/UzQ5ETfyNOfTd419mqQ7frYbBIt@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/tI/ebVkfzd7q33Uaeyw2IBj0l/CXUJDwGPi/4g3gyfiVgMop
	D3s64EwoHZ9chxhGwlNHNWgGkyNAI12S8PisGGBs+Z2D3MgtOfl8F4CgjQb+RHYehozRxUNd3l1
	QpoEVlHQQ+/ExqG2qwTqxr7620A0=
X-Google-Smtp-Source: AGHT+IFgi1/XHt/WG6qU7tmxc4v39mnPA50T65uxm0BhAuQeA2OQlc5EM0Y+lf0swbR/gzvtVLwg1gwb24/K2ugt6/c=
X-Received: by 2002:a05:6512:1048:b0:539:e0a4:1ec0 with SMTP id
 2adb3069b0e04-539e55163f1mr7995506e87.29.1729058969252; Tue, 15 Oct 2024
 23:09:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 16 Oct 2024 01:09:18 -0500
Message-ID: <CAH2r5mutxO_PamhMp0KBVs-0vn7BC9kBq+5BM6=n_ODg1WnHCQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b:

  Linux 6.12-rc2 (2024-10-06 15:32:27 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.12-rc3-ksmbd-fixes

for you to fetch changes up to a77e0e02af1c2db5fc040511aa78a58a52e116ab:

  ksmbd: add support for supplementary groups (2024-10-11 11:02:14 -0500)

----------------------------------------------------------------
Two ksmbd server fixes
- fix race between session setup and session logoff
- add supplementary group support
----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: fix user-after-free from session log off
      ksmbd: add support for supplementary groups

 fs/smb/server/auth.c              |  6 +++-
 fs/smb/server/ksmbd_netlink.h     | 17 +++++++++++
 fs/smb/server/mgmt/user_config.c  | 45 +++++++++++++++++++++++------
 fs/smb/server/mgmt/user_config.h  |  5 +++-
 fs/smb/server/mgmt/user_session.c | 26 +++++++++++++----
 fs/smb/server/mgmt/user_session.h |  4 +++
 fs/smb/server/server.c            |  2 ++
 fs/smb/server/smb2pdu.c           |  8 +++++-
 fs/smb/server/smb_common.c        | 15 ++++++++--
 fs/smb/server/transport_ipc.c     | 64
+++++++++++++++++++++++++++++++++++++++---
 fs/smb/server/transport_ipc.h     |  2 ++
 11 files changed, 171 insertions(+), 23 deletions(-)


-- 
Thanks,

Steve
