Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CBC2EDD62
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391753; cv=none; b=G2HrkLUOdss99AVpDYqGjXyCJCb4oCFiDF+mEWxqEBSK9vAIfI7cvKRPBPJMRnuQxpxdfMQZ3AAgWN3QcbogsaQfx40PW/kbL3tNHDnmgpWGHk90jBFz6ZV35wXEzB7iHshuj4NQ8up/C/T5WpZp2HZfZvoDnAeDSuUyrAJpuSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391753; c=relaxed/simple;
	bh=n0BQfxQVbZ+HUT/SKFdr6DJY0aUqo6UQMG5FhqOIK7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tfzADUCh2e1jJByJzs56FCZmZKITpNNY7qBsh0D6RDFtVVIqhhozq59wgT1FU1IP4kriC4rVnt4iO5A/5XTgElObV/+e2+XqPh7O3IlMUtqi2zdJq6ncaq8Z/xEEaPvF7F5T7h+EvBAb9Phd4+XpkRKamofo0JlGoxJVUMRMRHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HklPJ3fv; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HklPJ3fv"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso160709725e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391750; x=1777996550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=abklTRLGHL23wDOsvqEZ5hRcvaVhgj6AyTo/Z7WVkRs=;
        b=HklPJ3fvEUKPMIz6l8NooW1MXVQKRDf7D7huS5jLePLUr8rTqnXsLjIEa3NKxZJUry
         zgOlSG4WckSVYuZ7rUwJZfOR6IEAqHAs8qyoWFBztDKSrBCcNbFeUKIothlcTjBwOZ2X
         jXT28o9A1whyail9Fq0gKrD2O1mAEY0LEXuf4u1SYv42Vg2RWfgJFW1QcSfsp6MC+Fy8
         RCxwim6/nYomISrHNtNybVq0xvsQEiYzbA0J5JibSD+EHzZyhXO8EhZurKpd7/vZ1g5Z
         aLl+707kXMgOO2loVVhkSTy4FS5HnP2O0PVOySfA/CvZ6OrlUZ082R05ziwblq2uwn8I
         uXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391750; x=1777996550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abklTRLGHL23wDOsvqEZ5hRcvaVhgj6AyTo/Z7WVkRs=;
        b=n8HxxI/RpAZmiyiPxkD/0GCRJKglALmBGUqYifF0PWEElxho0MAC/A6dsR/i9FEBJs
         yNgEKxU28FqPR6ziWtT21mD6gHChCqVYTN1amxQqxwFYLOjIBhO7zjkY0zJsz04XhiJw
         gBiHpUgdsynRjYCE6i6x824KauU99xR6S62Fl/Z9tXyNukd3aFovS2I+rblwwl7uRpWH
         Rs/z/6xD4dEEju8X9d8R5X3ZoxnqVwOiPtki+Nkx/4aId3p9XDCkXV4u1GQLmIZPckNw
         HATM23+SbYSwKCRhoFc/jACwhMIZw94kULzKR8V4rPiXrS6uyxWWBIXV5i68a2Mn8b+g
         /ttA==
X-Gm-Message-State: AOJu0Yzlf8LYYBuenn1UdDRE3gGjOtSf68iWU5DaQ58Yzypv3KeLzOvk
	IlQf4giTq2JXE6uFBVydOmFHdLnf6RerSVgHy2ozAA49DklegRvZlV8arIi4jWXkAMVz9CBOWDO
	EzpFta1hx5A==
X-Gm-Gg: AeBDievrW0YstvgutISQ7Ivf2Jl205fMK/fvuIFgap+6QL3uJB2cH+jBYuYLytqZaum
	t70MoGSeBVo6xTFsFfa6ZWGVuVIpnoGry//s/SUxvcGnOXujSIrIteg/1o7k2XNSYQ6kFl11A6f
	g7vU7B78rPGCkN+Uhbup5TLHQtFOXd/2hpgj+S+doR1dBdTuQkons5fHkMuWM6ixUyUrtPaD0HT
	zdRLO837K9D9fT1BprktSrHVD1L1NBQWtYQuYfNCyxCd5n7rzxY+z7r8YC7VPvJ2NMt1qHRp3Nj
	acJVWqnWGwLGgA0Dxe45zucfvUTcSlaMG5FHRU1Sb/NoECX4hB1dlp+IYBzT0cDVzDukkq+6+fI
	fnvaxI2j//CQfGS++ry4tvePrpZr5QLe0tYXoGVStHmDwKpxUfdD4s9eavB0H53xNvimns728Gm
	Nyy3irmyzjKJxyiUZMeaAf4HNIjt91/VdEaANiqtf+lNd0
X-Received: by 2002:a05:600c:c101:b0:489:1d23:4524 with SMTP id 5b1f17b1804b1-48a7b512650mr2886575e9.5.1777391749841;
        Tue, 28 Apr 2026 08:55:49 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775f56fcsm23475685e9.25.2026.04.28.08.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:55:49 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 00/11] smb: implement SMB over QUIC
Date: Tue, 28 Apr 2026 12:55:38 -0300
Message-ID: <20260428155542.226234-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series introduces SMB over QUIC for cifs.ko and ksmbd.ko.

I'm sending this early for review as this work was rebased on top of
metze's recent transport and smbdirect changes -- at least some of it,
as well as on top of lxin's QUIC branch, and depends on these branches
being merged upstream.

The branch for this series is available at:
https://gitlab.com/hacr/linux/-/tree/smb-quic-v1

Changes in v2: nothing, I just sent the patches in wrong order in v1.

Henrique Carvalho (11):
  smb: common: add smb_tls struct shared by client and server
  smb: client: refactor negotiate context assembly
  smb: client: prepare connect path for QUIC transport
  smb: client: add QUIC mount and transport setup
  smb: server: split interface management from TCP in preparation for
    QUIC
  smb: server: add shared transport helpers in preparation for QUIC
  smb: server: reuse common transport helpers in TCP transport
  smb: server: add QUIC transport support
  smb: server: refactor TCP transport definitions
  smb: server: track TCP and QUIC listener state independently
  docs: smb: document SMB3 over QUIC setup for cifs.ko and ksmbd.ko

 Documentation/filesystems/smb/index.rst |   1 +
 Documentation/filesystems/smb/ksmbd.rst |   2 +-
 Documentation/filesystems/smb/quic.rst  | 332 +++++++++++++++
 fs/smb/client/cifsglob.h                |  19 +-
 fs/smb/client/connect.c                 | 234 ++++++++++-
 fs/smb/client/fs_context.c              |  37 ++
 fs/smb/client/fs_context.h              |   4 +
 fs/smb/client/smb2pdu.c                 | 133 +++---
 fs/smb/client/transport.c               |  40 +-
 fs/smb/common/smbglob.h                 |  12 +
 fs/smb/server/Makefile                  |   3 +-
 fs/smb/server/connection.c              |  11 +-
 fs/smb/server/connection.h              |  10 +-
 fs/smb/server/interface.c               | 235 +++++++++++
 fs/smb/server/interface.h               |  36 ++
 fs/smb/server/mgmt/tree_connect.c       |   2 +-
 fs/smb/server/server.h                  |   1 +
 fs/smb/server/smb2pdu.c                 |   1 +
 fs/smb/server/transport.c               | 344 ++++++++++++++++
 fs/smb/server/transport.h               |  40 ++
 fs/smb/server/transport_ipc.c           |   3 +-
 fs/smb/server/transport_quic.c          | 327 +++++++++++++++
 fs/smb/server/transport_quic.h          |  20 +
 fs/smb/server/transport_tcp.c           | 526 ++----------------------
 fs/smb/server/transport_tcp.h           |  10 +-
 25 files changed, 1785 insertions(+), 598 deletions(-)
 create mode 100644 Documentation/filesystems/smb/quic.rst
 create mode 100644 fs/smb/server/interface.c
 create mode 100644 fs/smb/server/interface.h
 create mode 100644 fs/smb/server/transport.c
 create mode 100644 fs/smb/server/transport.h
 create mode 100644 fs/smb/server/transport_quic.c
 create mode 100644 fs/smb/server/transport_quic.h

-- 
2.53.0

