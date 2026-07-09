Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD5C8472
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555622; cv=none; b=r4SqrFH5ryoMec+kJCVB/mTwEMv5XAju6D7TvG5IfkxsxipmlxXWW5TCSp9PCj+D1F/FykrTLIDUDZ+a+DZ4LfZU6N3HD8ZJFYbbjPOf/xN0AlV9AZbsLIZO+3CqSCIBuErcMNzuCAspFoNQRmQIYjWntrvUQrGoTWl5dP4S+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555622; c=relaxed/simple;
	bh=dYOkI8GIpJITr7RHKZFtLkikywLeyF0Rz1jRqohLQMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W590zvqs/ax6aVYG1ytlmbNvdIxe+26C/0fyS5bexJy16jPFzAnavCQDFoTS418AQXwazmR6Txv5Xk8MwrxacDGvQvwsHr1ryYWQMy5i/k4MlEPb6TOrk+xEevH5AcLsd4Om/4VQTSgVffRiKhjGeWoCl1SPkrn8g6JScx17R9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KIcNvWzv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIcNvWzv"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c59f740cso9264165e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555619; x=1784160419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DiuPGJ4ZyD9TZ89WcTfzkSS6wWAyPy9ZoGAj9o+p0LA=;
        b=KIcNvWzvTBO7byFL6DV0BY+G4uIPmRB5xk/MkcOutsaDZ/11WrTFPG0AAORLeQnv8t
         WGuHXlNz9LkGX8z1jTfl13BW4nBe1P/yBb9iU/yWTNx2ixUu2EjheBSCrvvGiY2/DXDd
         fGegBRapEsd4YG8KW5MFj1dhKnKOHBeNJpwRsWluaQnuP63jkfibBxVn4MLrSfc7kL0l
         0290/6zKRaGfzUKAPLH3lF+tXPPTaWR7A0e+KSV49xhv7hHxS3vb1JKAMKfjseHdsyVO
         6o0XxzZuvnz+vSBFzb8ezoATXLerh05RnjqpBpRfTlvIP55oxUAvbpLEm+cqYzMsJE57
         xnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555619; x=1784160419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DiuPGJ4ZyD9TZ89WcTfzkSS6wWAyPy9ZoGAj9o+p0LA=;
        b=i2HmIuvwAqIzP7cQa7KMdh+U6ucD0qqNXrAZ9sHI2B9o1JuGcieBqkyqps0kNdvTU0
         XvFC7OOHk1fcgFOSyjfRpbHzuRcNbR12M3Zp0BXjsQBoeF9CM7jiDWYBtXLClewDxH9Y
         rPYiptWJH2Z+JbfCWuHtXe0ruJGy6WpKPGyNGte/X3JScO8tf/4oqJ1aRTdF6r8275cV
         WoZD+aPu45iDkewiqLaky+y/U74+8zdBOiYVnM6+BYz3rw0WhMAakaRyjnVcV9HRQvUp
         VwxksiJhz7rVm8OMZHwwvByHVHz8ZAQAr1TMQ4C/kasrawvO01EAiyuQ+df2u1w+chLd
         Pq2w==
X-Forwarded-Encrypted: i=1; AHgh+RootEhN70rWaAPRHHbzZoN4SDw3zLYivs8MP9jlqeJXZy5I7RT+xbMux27XqTtN+f090jmNC2WPI2/0@vger.kernel.org
X-Gm-Message-State: AOJu0YwFLWmxI/rIeh3mMPKJFu1p0zKzvpPYnFEEjQazh9sFK1SlMV6N
	LaBX3g/7MUhc8BR2QqQS2gYQ7AgX0dBdepvXQXMHsE54ia8mxv8e8tOf
X-Gm-Gg: AfdE7cnQ2hVfT4lmMp/UdELUgGgNdj5JTfQRDs6dnbARJIixvI/+L1xqKEjFhte5XnI
	xIpEM2mXeiwvINsbGMBfEMbfDvuSkvsH2GMxi/oe+lLDRv/xh9B5qK4/MU+mDoSmdsKOa8NDjFV
	byisURLVbmhPh75o4ts2hejy1q0EoWMcZ2I05Ahr9Rf3YjYjLeflUOBNQLsygpIOUQEl19O//bM
	Ay35RfciO5fpW7Eve51uNELkMBO7cxCvvjaIprai9EFZFMpzY/qkVbmSwP0TmSwFa0KoYQk8Vo1
	tKHDJC4Tkt1CnweHC8IrXI6vtwzQYnbDF4d9ovLcuz0FXTRFyl29Y4/ayqEzDrYhXhKBIslBGVj
	mBWEyEzinXg2SYSoJUjJUufv7wEPx+gXzwggzLFSj39YkQvqUXWaD1SMDRTx5vIojVftxArcU95
	dVuLQyONkebM9IFzrKO7ZafqWFG8/W8/i7npU=
X-Received: by 2002:a05:600c:620e:b0:492:4e09:9fc1 with SMTP id 5b1f17b1804b1-493ebe7afadmr5363255e9.15.1783555619111;
        Wed, 08 Jul 2026 17:06:59 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb670a41sm15981925e9.0.2026.07.08.17.06.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:58 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2 0/6] ksmbd: add macOS Time Machine / AAPL SMB2 extension support
Date: Thu,  9 Jul 2026 02:06:06 +0200
Message-ID: <20260709000618.66534-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Link to v1:
https://lore.kernel.org/linux-cifs/20260707100129.47563-1-g.blivet@me.com/

v2 addresses the CHANGE_NOTIFY CANCEL concern raised on v1:
smb2_cancel() calls each async request's cancel_fn() while holding
conn->request_lock, so cancel_fn must not sleep. Patch 4 now splits
this into inline lock-protected list/state manipulation (matching
every other cancel_fn in this file) plus a workqueue-deferred send of
the actual STATUS_CANCELLED response, which is the one part that
sleeps.

Separately: the corresponding ksmbd-tools userspace patch (aapl_model
field, "time machine"/"aapl model" config options) has been sent to
that project directly, since it's a different repository from this
kernel series.

New since v1: patch 6, AAPL READDIR_ATTR V2 support -- real macOS
clients negotiate V2 over V1 when both are offered, so v1-only left a
gap for current macOS versions.

Also new: patches 1, 3, and 6 are now additionally cross-checked
against Apple's published SMBClient kernel source
(apple-oss-distributions/SMBClient, smb_smb_2.c) -- everything matched
the network-derived understanding v1 was built on, except one
inaccurate assumption in patch 3, now corrected.

Patch 5 also gets a correctness fix: the synthesized ChunkCount=0
full-copy response was reporting ChunksWritten=1/ChunkBytesWritten=
<file size>, describing a chunk the client never actually sent (it
sent zero). Now reports 0/0, matching what's actually been validated
against a real client; only TotalBytesWritten carries a value.

Patches 1-4 are otherwise unchanged in substance from v1, re-derived
against the current tree (this branch has moved since v1).

Gael Blivet (6):
  ksmbd: add Apple AAPL kAAPL_SERVER_QUERY create context support
  ksmbd: synthesize empty AFP_AfpInfo xattr on first probe
  ksmbd: send inline FinderInfo in FIND responses when READDIR_ATTR
    negotiated
  ksmbd: defer CHANGE_NOTIFY completion instead of
    STATUS_NOT_IMPLEMENTED
  ksmbd: implement full-file copy for AAPL ChunkCount=0 COPYCHUNK
  ksmbd: add AAPL READDIR_ATTR V2 support

 fs/smb/common/smb2pdu.h       |   8 +
 fs/smb/common/smbglob.h       |   1 +
 fs/smb/server/connection.h    |   2 +
 fs/smb/server/ksmbd_netlink.h |   4 +-
 fs/smb/server/ksmbd_work.c    |   1 +
 fs/smb/server/ksmbd_work.h    |   2 +
 fs/smb/server/oplock.c        |  85 +++++++
 fs/smb/server/oplock.h        |   2 +
 fs/smb/server/server.h        |   2 +
 fs/smb/server/smb2ops.c       |   4 +
 fs/smb/server/smb2pdu.c       | 442 ++++++++++++++++++++++++++++++++--
 fs/smb/server/smb2pdu.h       |  76 ++++++
 fs/smb/server/transport_ipc.c |   9 +
 fs/smb/server/vfs.c           |  88 +++++++
 fs/smb/server/vfs.h           |   1 +
 fs/smb/server/vfs_cache.c     |  48 ++++
 fs/smb/server/vfs_cache.h     |   6 +
 17 files changed, 758 insertions(+), 23 deletions(-)

-- 
2.43.0

