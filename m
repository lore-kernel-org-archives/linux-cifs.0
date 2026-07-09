Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DFA22097
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555564; cv=none; b=Y96hIdckjgGr81zwVKx2TYc0wOQpaVoQPRhD32QmriiZSEyiBoaqlF8259U/wZQmMp5rUWhRJpwU/fnrQGXit6Ykj79SGsdRJEsj5gBTDgLg5/+Qiv3J7bdCZrkq8f4hwrqg2YKIWcbHe74MZgajCukWLcjGQ5TpMf4ClvodkZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555564; c=relaxed/simple;
	bh=825l/G7X133HlbsYhCPyq9fG7sEoksVJVeQ+eTWydQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cOLSDb7t/qC656Ki5K0m06ZurtfiaeExcPBeKjWDC2fMi5rNJ2yHeUhWzmN0pOsBC8qvpK1oRa/9PmT9rKP0x6YtElvWeM4e/AW4GxY2hq0oaAr8hhcT3KM1uF3Dvw9RI29GKUhBF8GeJysNzrWGMEvrMHM6+qOGhYnlRujj2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iZJBPD+W; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZJBPD+W"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-493d92b7db3so13132545e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555562; x=1784160362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=otlTSOVOkSR5teu+yFkx8ox/iY9uqY8IZ4H1i+AQ03Y=;
        b=iZJBPD+WTj6zm/L/PfYumJSY8ZdjdcXT3IglUmxoa5RkpHW6jFZXjfErFmYteNhkmd
         XFgkp+r6C240lQYw3DsiCUYiA6Hd5FQOdUjYbz2aWGAtlviz5gkI3qT81XdvTQ5qllv0
         N1NYk5aB1oKHTCYcArAI9FLKwNWwIyqCHOdsqTkxAQr3HsKl6UsgC2QEgvy2lZLpELeD
         2vvlovQWmykq3jjZDJRhp8CRt+MUXZ+mAX2bwNalzSM8ut3tsH0fEut5EV4WFF/nymKC
         k99EAR+yVi5KZ4t/LRpvVo9jJvOlJo5KY/agBFVqz5dhAVkAwAjLwcs4xyLMg9P32fN3
         arNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555562; x=1784160362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=otlTSOVOkSR5teu+yFkx8ox/iY9uqY8IZ4H1i+AQ03Y=;
        b=OuKnFnRO7rIWWBZNz7IziXwFcQVBs5y9/vKjNs5MSh8hSARkKW9/bg4Kv3Og7AlTLg
         qW3JSHXrLyGMFkeCAlhNWHsIkt+dV8qmuRNPtGkInsxLkdzWI6WTKAApdd/rBYsnhSkb
         Q5aOoHMNsGNVSH+Y6xRtIcBvT6eUmlE7qzE1q2Y+ghjp1K5ss/HSu6IO/7BoXEGixwxc
         1JKgJXIQQFTcHOu7qiAwFLq+0vxdCBoS+TmK51YiEJmEqfKIzzfBzu4GaTGy05bJDhf+
         Qnh2xdpQlbjbi1FtHbkZmpC7k2T48t/WXaoDMFWnn4X8Gi8+rhUU6ml3tryGtYwM8oWj
         DMqA==
X-Forwarded-Encrypted: i=1; AHgh+RpJ+RoX7g++QMeGsnyfCKUb7sIOB4Npkz2k4EpuYxQavsFPrHrOezN3D5imJMI9XlCjMPr75I75TM56@vger.kernel.org
X-Gm-Message-State: AOJu0YzGRqPEv/rc/NoSZeXYH7aCiEQYpyH87WwemcFjMJ7B9EethA12
	BI+aiuudn6oLBlX3Hvvm/zkU26kbaE0VW4USxnNDgSu38aZVKJYYDUsbCIpckaM7
X-Gm-Gg: AfdE7cl4ssUtDsO3HAtkW90HQE14E6Fd+k/ehgBUlC3b/heiLfY+77JidKBg8BPKeKS
	SwRir+uevsbkD9RS+dSZf2cE5NeMxW+mVehe6j2iL0EarLhbUL/9Knk93BCEl8rE8/E5AGdPivT
	MoK3B4cFlidNZN7nn13Vxjhln9ApWSXa4xZpgX8miu5KgwOtw/BB9vFRrkhV9InZiYojIEGWb1e
	J25au4DnvT90ycqu/3k4liHVIBj6gLIABHExBiQqudaSs03QdjnDsXORz+2OYtv9jnvzZUBZ0kc
	YyfMCNnYers7eTXCjtzNkQBDk1p+7crkdr/2VmhG66Vt6+ljunICKx3hYm0kJauNHZa89uRbtD9
	pzVJmqqhPjGQMqsMk6xoVfyRfXliSo523D619cHrUWM8xvI74uvAyhTstF/RZm4yHHNOCGgpnBH
	hAlZ7JEl2mqs5nde4dGIo4j8NCR0fyX1/8DSI=
X-Received: by 2002:a05:600c:a210:b0:493:b549:3be0 with SMTP id 5b1f17b1804b1-493e68cc492mr29099235e9.17.1783555561428;
        Wed, 08 Jul 2026 17:06:01 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:00 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 0/8] ksmbd: follow-up fixes to previously-merged patches
Date: Thu,  9 Jul 2026 02:01:03 +0200
Message-ID: <20260709000548.66445-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Follow-ups to bugs found in patches from an earlier series ("ksmbd: fix
several independent bugs found while adding Time Machine/AAPL support",
already applied to this tree), plus a few additional issues found while
re-reviewing that same area of code. None of this depends on or touches
the AAPL/Time Machine feature series (sent separately as "ksmbd: add
macOS Time Machine / AAPL SMB2 extension support").

Patches 1, 2, and 4-8 are Sashiko (automated LLM-based patch review)
findings against the original series -- two triaged and fixed
already, the rest found on a closer re-read of that same review this
session:
 - Patch 1: commit 78380c12125a ("ksmbd: route stream
   FileDispositionInformation through stream delete flag") used an
   inode-wide flag to track a per-handle delete-pending state, so
   closing one stream handle could delete a different, unrelated
   stream on the same file.
 - Patch 2: commit bb682f1496f7 ("ksmbd: quiet mdssvc RPC log spam")
   silenced one of two log sites for the same rejected RPC pipe,
   missing a second, separate pr_err() in the caller.
 - Patch 4: two IOCTL response handlers (FSCTL_CREATE_OR_GET_OBJECT_ID,
   FSCTL_GET_REPARSE_POINT) write a fixed-size response without
   checking the actual remaining output buffer space first, unlike
   every comparable case in the same switch statement -- a compound
   SMB2 request that leaves little space for a trailing one of these
   IOCTLs can overflow past the end of the response buffer.
 - Patch 5: stream enumeration (FileStreamInformation) reports each
   stream's name length as its data size, the same bug class already
   fixed for EndOfFile/AllocationSize on an open stream handle, just
   missed at this second site.
 - Patch 6: a DOS attribute struct is used without zero-initializing
   it first; one of its fields is only populated by the on-disk NDR
   decoder for one xattr version, so an older-format xattr leaves
   uninitialized kernel stack memory copied into server state that's
   later exposed to clients via QUERY_INFO.
 - Patch 7: deleting a stream (not the file itself) on a directory
   incorrectly fails with -EBUSY if the directory happens to be
   non-empty, since the emptiness check doesn't distinguish a stream
   handle from the directory handle it's attached to.
 - Patch 8: opening a stream with an AllocationSize create context
   fallocates storage on the underlying base file's actual data,
   since streams don't have their own file and fallocate doesn't
   apply to them.

Patch 3 is unrelated to Sashiko: a 1000x units bug in the default
durable-handle-v2 timeout (60 instead of 60000 milliseconds) that
would make any client relying on the server's default timeout lose
the reconnect race after even a brief disconnect, found during a
separate investigation into durable-handle-v2 reconnect reliability.

Gael Blivet (8):
  ksmbd: route stream FileDispositionInformation through stream delete
    flag
  ksmbd: quiet mdssvc RPC log spam in create_smb2_pipe
  ksmbd: fix durable handle v2 default timeout units (60 -> 60000)
  ksmbd: validate out_buf_len before FSCTL_CREATE_OR_GET_OBJECT_ID and
    FSCTL_GET_REPARSE_POINT writes
  ksmbd: report actual xattr value length in stream enumeration
  ksmbd: zero-initialize xattr_dos_attrib in smb2_update_xattrs()
  ksmbd: don't check directory emptiness when deleting a stream
  ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream
    handle

 fs/smb/server/smb2pdu.c   | 77 ++++++++++++++++++++++++++++++++-------
 fs/smb/server/vfs_cache.c | 49 +++++++++++++++++--------
 fs/smb/server/vfs_cache.h |  7 ++++
 3 files changed, 104 insertions(+), 29 deletions(-)

-- 
2.43.0

