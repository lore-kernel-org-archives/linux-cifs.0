Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cbVdDIio"
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF0E93;
	Mon, 11 Dec 2023 20:44:45 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id 2adb3069b0e04-50bf4f97752so6752443e87.1;
        Mon, 11 Dec 2023 20:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702356283; x=1702961083; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iIHkL66LFa2jiwaKlsxw7JsD4efvV/JqZ9e9EFR+iVw=;
        b=cbVdDIioEum1OHKpWpsVZQABdqjodZkcwbvoOi85bk/P3rsOQtVqtSjM2Je8nI1DON
         DlHP8c7bTSUZsuWVeLlkdkHf2cXBvi1MVjG606g7JlwGJTZGENNoAH9eCNwudIWIRQ2O
         LpvkKS2MBmP4xjMGhKqQS++Yfsd7ZT+QEfbSqTiR0o+BybjGwN5vw/2yeMp0nEQnhFUv
         k7T/t7wQ5zQEDq/YGHdqc1eMeRsJX6PrT0MmpaTQufodzJd+nR/o0QGRpLX6j1KiiPOA
         H9wnYoKbuRGyPUiY0YtLZQRSrwhmiuefHzJZozNZDl2ad3qJN9tqMnatKMnkM5GUBOE7
         IFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702356283; x=1702961083;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iIHkL66LFa2jiwaKlsxw7JsD4efvV/JqZ9e9EFR+iVw=;
        b=LX4NBemn51z49K8Z0DYZ9hM2YRv8ZZTEdYsX5XSL3+U9fFmnqzk5ahCl68VOBbtlR+
         vTc1nFrwfBNqJxMLdEzZF+nEGZfJmb7x3aewXytXrjewxFlEfFq1zQ4egwa/4QUIC33y
         Nkw7GlFBc2HKHSSkJfBx8skM/Oh7iSOKl9WghkTPIBfkDMDciwl4jMGDk8dTbeHEeD90
         ch2DIHQcdmtNmYCIvNkrnpp87VddjQCZhN7e7C6BMBFuUdWI8G9NgKQ66jLHnzvFLDpd
         oTLtNUGV1y2z6N/ybg6s96FzagagLg8ybf1gCsq46p33y9X3iZAhLGe49RQrqmbb0n65
         J3WA==
X-Gm-Message-State: AOJu0Yzg788iIMTUZi2r2bS7hrXCJki9dvMFHaj/RtUIk1TZAe6uyjcL
	h1yPMZn8EpsHzCWAyHcKU2+z5tiORvyfwDwNcSo=
X-Google-Smtp-Source: AGHT+IErdha9WKQ1NIW/F1zJJqzgS19pFjxcUoJrisvbevXs6kjF4Axp1rEgMKQ/GEbaF2dBZg65cdSW+mIZ+WA+0bI=
X-Received: by 2002:ac2:5631:0:b0:50b:f859:8294 with SMTP id
 b17-20020ac25631000000b0050bf8598294mr2154143lff.32.1702356283233; Mon, 11
 Dec 2023 20:44:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 Dec 2023 22:44:32 -0600
Message-ID: <CAH2r5mscEZygkgAK49pr0Tf89eJAhngE35AUo+Rmt1800m9TnQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
33cc938e65a98f1d29d0a18403dbbee050dcad9a:

  Linux 6.7-rc4 (2023-12-03 18:52:56 +0900)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.7-rc5-ksmbd-server-fixes

for you to fetch changes up to 13736654481198e519059d4a2e2e3b20fa9fdb3e:

  ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE (2023-12-08
10:11:33 -0600)

----------------------------------------------------------------
Nine smb3 server fixes
- Memory leak fix (in lock error path)
- Two fixes for create with allocation size
- FIx for potential UAF in lease break error path
- Five directory lease (caching) fixes found during additional recent testing

----------------------------------------------------------------
Namjae Jeon (8):
      ksmbd: set epoch in create context v2 lease
      ksmbd: set v2 lease capability
      ksmbd: downgrade RWH lease caching state to RH for directory
      ksmbd: send v2 lease break notification for directory
      ksmbd: lazy v2 lease break on smb2_write()
      ksmbd: avoid duplicate opinfo_put() call on error of
smb21_lease_break_ack()
      ksmbd: fix wrong allocation size update in smb2_open()
      ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE

Zizhi Wo (1):
      ksmbd: fix memory leak in smb2_lock()

 fs/smb/common/smb2pdu.h   |   3 +-
 fs/smb/server/oplock.c    | 115
+++++++++++++++++++++++++++++++++++++++++++------
 fs/smb/server/oplock.h    |   8 +++-
 fs/smb/server/smb2ops.c   |   9 ++--
 fs/smb/server/smb2pdu.c   |  62 ++++++++++++++------------
 fs/smb/server/vfs.c       |   3 ++
 fs/smb/server/vfs_cache.c |  13 +++++-
 fs/smb/server/vfs_cache.h |   3 ++
 8 files changed, 171 insertions(+), 45 deletions(-)

-- 
Thanks,

Steve
