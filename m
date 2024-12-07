Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD3126BF9;
	Sat,  7 Dec 2024 22:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733610178; cv=none; b=u9hHY8Z5bgEIHQTihARzLgnQAVJBdM/o46hfSyBQBBARWugWlwzkpr5zkQR7yDSboh+AobemZObPvV9pY/yvbE/4FYVboQKm3Bgn+WgBeYq2EunZKi/KUJFYDvOWa+V9CYGNGUMcrrf/CYzYei5MFds1T1rmBnKR6FLT5TkgYxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733610178; c=relaxed/simple;
	bh=AJELeyno/lxCErGWfe1uIuBsCiCosW9aJknx5oSLG4Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=f23uI7va5lwJP4IOrvIlf+szzZIoHE86vih+J+izNo8lhBmcAN9cmVHRRT13L/UvBfjxeM3xdPGpovzMPLoWe+me9lsOEVXjXgBB9uXoFt2y9Jkt4Amz0DzSbrEgc5eFIzk0SlLqw3Q4dXdNfwWdaLl/6frmf1F7wd+X1OM1HIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGzkS/Dr; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGzkS/Dr"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5401bd6cdb4so58495e87.2;
        Sat, 07 Dec 2024 14:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733610174; x=1734214974; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FYcS3kK1mI+zB2no3lgHwxCym7Ppt8Og1OLk8bPMxlw=;
        b=nGzkS/Drnmy8Bn7c6gWUmco/ihjJGwSZ1Ur4TPDBSASfX5vT860DjQRAXWmaTS0lJx
         3pVMYH2u3CPPb1c9E/6toF9V9QpJr284DYylRCGrWEKu3mQUlcb+AgP+QO7mXKP03NMK
         V9WcUVnTh5BktiRaqkIy7pXgB/KckdRPbTUruklRxzWOC0jTm5A7rBlyhfvXB6U7cV0C
         fidW1sKPq0FIdEjyLI3mDfeM81BcTRwzfHOzJUXmp5HOXEG7FaUwL9HZenr2Oilr7a4I
         kRChLE3RlYK2lcvSfvgahAI7trT6cs72bKqJyiZtPofuI8XYaT3KXNXNviMENvhomnWW
         8lww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733610174; x=1734214974;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FYcS3kK1mI+zB2no3lgHwxCym7Ppt8Og1OLk8bPMxlw=;
        b=vyEkG+h7X7HMtxqtIP9LQ3PK8s57DGWY+ByG9GH5iLDWKOonpUa+DwsafpzoJRFYDo
         iAM8G3ZKyEVoqeCDB8HVOsE9qbGG3jonF8aJl6bg5C/OF0ts6ny3QBqW31g9VbW+Wi80
         8/P4sQVxAoV4Ve5stoxzsfqjggC5j+1APXXnepqlWsNyv9yjtFXhgV5cm3SI5ftBMKBB
         lMDRysJNxgXK3JTQpDofYml4FW6jwYHZr5prDGhqu3QW7y8qQFXtxhlIu3qa27XcIBtr
         KOTrBwB6MR24VmesnixXHwJ09Qh1CwsNcHQY3oTZRixay5A64ETaPv7Zy8/y0TEusZvH
         UtuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi4cOmj0fsUAJe3gQY+YwYsC2DmP7F8AglkgizODwgvvYjmf8oIUTsnM/seSG5Ee5Oom5WsYH3dnYHO3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZNGcXew8QIvcco2BJG/ESeejGnYP48O+zug5JeRz6ndIfOmbn
	M6aIlV/9vkyNfuEVY3iTY3Svt9Ne5T/+Zt9/D1paxe57ES5u77xFJCscMS383Ts/yptwlfwoiea
	wpC1aDgq3/1g1uNjm9FPrv3H0ank1p74H
X-Gm-Gg: ASbGncunt/Sqi1V1TNTRr7GAnb/Gc33PxIbTiBFhUpTiHisc6X2mVVF3JnVfCBDg0e7
	s8095IJn4dV9qTB4Ufvo4W+uRk3uZCA2wyGXnft3VmOV79PsWL0LNbTb0YcOWA259kw==
X-Google-Smtp-Source: AGHT+IElkYwue1sraAIl6xu+fWssvIR7Ss5w6WER45aGlKBABtxcHRHEWxPOe+eO0fSlr1ekngeW5El/JkQLcS7hoP4=
X-Received: by 2002:a05:6512:3051:b0:53e:398c:bf9e with SMTP id
 2adb3069b0e04-53e398cc127mr1306066e87.55.1733610174199; Sat, 07 Dec 2024
 14:22:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 7 Dec 2024 16:22:42 -0600
Message-ID: <CAH2r5mus1UqScCCqqWoPO_9Zu0yr6=DMf4cu+YOusFn9HVX3nQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
40384c840ea1944d7c5a392e8975ed088ecf0b37:

  Linux 6.13-rc1 (2024-12-01 14:28:56 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc1-smb3-client-fixes

for you to fetch changes up to c32b624fa4f7ca5a2ff217a0b1b2f1352bb4ec11:

  smb: client: fix potential race in cifs_put_tcon() (2024-12-06 09:14:38 -0600)

----------------------------------------------------------------
Five SMB3 client fixes, also for stable
- DFS fix (for race with tree disconnect and dfs cache worker)
- Four fixes for SMB3.1.1 posix extensions
       - improving special file support e.g. to Samba, retrieving the
file type earlier
       - reducing roundtrips (e.g. on ls -l, in some cases)
----------------------------------------------------------------
Paulo Alcantara (1):
      smb: client: fix potential race in cifs_put_tcon()

Ralph Boehme (3):
      fs/smb/client: avoid querying SMB2_OP_QUERY_WSL_EA for SMB3 POSIX
      fs/smb/client: Implement new SMB3 POSIX type
      fs/smb/client: cifs_prime_dcache() for SMB3 POSIX reparse points

Steve French (1):
      smb3.1.1: fix posix mounts to older servers

 fs/smb/client/cifsproto.h |  1 +
 fs/smb/client/connect.c   |  4 +--
 fs/smb/client/inode.c     | 94
++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/smb/client/readdir.c   | 54 +++++++++++++++++++++-------------
 fs/smb/client/reparse.c   | 84
++++++++++++++++++++++++++++++++---------------------
 fs/smb/client/smb2inode.c |  3 +-
 6 files changed, 175 insertions(+), 65 deletions(-)

-- 
Thanks,

Steve
