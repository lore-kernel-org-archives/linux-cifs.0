Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265CE402B91
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391196; cv=none; b=d7nZZ+oxxxe5fqhNYKqh0R9AuwTi1gRUtIvmeTOv0XYfDSu/JASo5V+btrtmPdXrVIgf1ShwFCLxEOled57IhL59IY75a23qMYw9jt0POG1LNzrg9USY9uThmUblGTIPzSQHlaYxE7Rd/XsDBSF5P5HNitzOBXes8DSjfvNufP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391196; c=relaxed/simple;
	bh=wpCW6zmv7Wg9MoVNQIgejUKJN2WVH7FkEuTn7DoU4NU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q7TJN8yekEr+bggHqklxkt25VUdjYKP9di1d3FML2plNHkSXYfLo8jQ9qtx1KdJZgxswdEUcCo9ZDnG3AuU/UhNQPX6nLaQ3uBynSoX9BZPTHHIviiUc4J+CJJJEiMnbmI7Dx+AStdX+77uoi5f7vtXoCMY4ZeI2wtpuXrgrA8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IaiFEVoX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IaiFEVoX"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso118376415e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391191; x=1777995991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p+bxAiS4imiLHEtofmKQKjC0diDILn1MPvhOMKuO7TI=;
        b=IaiFEVoXI6emfPpTIl+AF4i3u+5CaqS0K3XcaqRwJu7Wmnl86R09VxC3+YS8icVhYY
         Dc27AoQM+8lY6oRjBM9NFgLQizWdbq53VgBg0xqu+OZ8o3mGN3zPDnnhOH3lRBzpiE+q
         QnxDIvfifTkavjIT7ynXbTgc0JvSsLirB0YOH4d0REeo1N5ckNamR9cTRYqHOv3lc3DL
         vF6lKbrE0yhj92RDl3+a2BWn8Zz27Sps4BSpnzJziGRf0/zQi5OFqKL1b5OsQa5z6uyq
         CoCWji59Xl3JR9fpspey5ri/b/V3ajVy3buNUBYRA8MgWhOXPjT9Z1ttfRWFh2jqIYGV
         5b7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391191; x=1777995991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+bxAiS4imiLHEtofmKQKjC0diDILn1MPvhOMKuO7TI=;
        b=s1hDOtXX0nLU72fKjkD747yWScZl8KqIAoIK9nrsO6hOAffITIP7GsVib5A7ljAKAX
         jr0Nl5Xk9haoTT8Gmbq8AfGplVXf0RMHOhmQoKPx4mQW0dKUuw7EsCpgOaOjfRKj6pyq
         sjelZjqbSZEBHzZkUKD+jRdIkpvYIewZ4wNgxF87nCxoHfWUErQnKSfyvVJF4xLDwF4m
         HtRUJtdP5vUQxHQl12Rk1Ox4kCeL5UnTLr5DWs0JK6R1RD+H7eeUmhz1SCDHxBfMMn8u
         n+PCz24jgcYOjz2F1/JexOKtnaG5jMFiyIOhpnLvWC1ZhqCtUpZJoy8aoAdZ0e5TWSBT
         hF4Q==
X-Gm-Message-State: AOJu0YxLlKTy+LkNtzjnrDMl5SYZLZBnNkZreQ0FXLaKTy3Kn2EqWzs5
	LTuZgciTIkDZp4V3+l1ttxEPVvxoRXLxjrIzI/jCKGKtUVOM7tfLmmOvvfc4ApFUfghMRIHQ/p7
	Geb8fjexErw==
X-Gm-Gg: AeBDieuLdIrOKS6SRKDmjFrSO845+mtLpFGruNFw4XoX8XeUhPQFEyIVGrsF215roXC
	EjSu0EO80JpP7t8qjS0FUzHp/wCB7/0No8G+JtWkA2wv4A6SvZHjVK7nuBm/OOXCjJwUs9HtHiI
	usnzNptVKbkN2deftvNaCFjIIn3MddiM7qLkzaHj8/YLs1tlh04TX3Wxd0jpJkXV59ykPdaPEcF
	ytIBIWdfnFXJJJYLhSdQ20CFDfP8dzPzCZoHBDVv0Kw5hbStV3R4kBsE2155TTPAIbcUXKWxKwk
	J8UekHEDkwnhQ2f1CwV85FJMr5tJ7em9AwaT+uOHEU7kbTqRfVJyFWXo6njlxvzFfYDDt2UpCEO
	xCp6Qj9StWla3Ga+7bHI961maxjCLgQRVB37smVCjmYJ+KQk4tuvGVAs/IcpEcXL7Big5xFcktn
	j22YLydZQ+Uc5cfM4/mTiiRD+5MMwndarAykokPXqlMg/s
X-Received: by 2002:a05:600c:a404:b0:48a:65ab:8059 with SMTP id 5b1f17b1804b1-48a7ae01ba1mr12725355e9.13.1777391191075;
        Tue, 28 Apr 2026 08:46:31 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463d4fa52bsm7725384f8f.15.2026.04.28.08.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:46:30 -0700 (PDT)
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
Subject: [PATCH 00/11] smb: implement SMB over QUIC
Date: Tue, 28 Apr 2026 12:45:56 -0300
Message-ID: <20260428154604.222551-1-henrique.carvalho@suse.com>
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

Henrique Carvalho (11):
  smb: client: refactor negotiate context assembly
  smb: client: prepare connect path for QUIC transport
  smb: client: add QUIC mount and transport setup
  smb: client: squash
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
 24 files changed, 1773 insertions(+), 598 deletions(-)
 create mode 100644 Documentation/filesystems/smb/quic.rst
 create mode 100644 fs/smb/server/interface.c
 create mode 100644 fs/smb/server/interface.h
 create mode 100644 fs/smb/server/transport.c
 create mode 100644 fs/smb/server/transport.h
 create mode 100644 fs/smb/server/transport_quic.c
 create mode 100644 fs/smb/server/transport_quic.h

-- 
2.53.0

