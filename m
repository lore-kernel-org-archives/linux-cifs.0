Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4AC347BDC
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 08:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790410421; cv=none; b=c6QdRxVjgr2oDLoVInZ5ADcdOlvMGcsOqwvyirEJNjza9QIMG6Ga4J2hVw/of95XF4RRWChGekVIhJGZKiyjoo0CMRsILQl13mEz12fkDS4rocY6/kgJqUVocYgY4ApSu+OcoCwLUIiy7LFvPg6C/75u5bsYTTzo9X28klSup+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790410421; c=relaxed/simple;
	bh=ig3mWZg1JlZlBFwG9O95I6wXK9nFRyBhS7xFOG9iBpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rGG5b8Q4RfuYC6X6v2CXsSQYR0b+4yRiWmsV8OalIdV+RWXK0ofQuwH9Vf6AOIgIG6gmGBgpBu3SwucqwODrQkqKKG78lb+5Du3jY5zHx5z5HW0AsGBFy7HSzeLL/VulFGF8Lzwcx0tir+alWVRb1VY1xjBNbzkBORofNtwNINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nrxfZzGb; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrxfZzGb"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc7979d1dedso359490a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 01:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790410420; x=1791015220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RC+Pb5q4XmiSnvW+7RE10jsoQIna9GU2QDuK/YngZVE=;
        b=nrxfZzGbMI/Y3D3yVXQP3P0bTDq/TK0XlMnb6c9cgmwGauyAFN5xVocEXgjJp/AbAV
         8/f6FJ7P8zdiQAMy7E4XumX3Y6Kxfy3l9QY3VuwVPYFLplqDmfqrJ0f2wqAmOOh2OK5E
         jUVZFIEPzWkNmPm7mgkAFfNqaWnxRCo7txBP48+CbzlJcQyeXuuu5l/94wkZkr/hpXNh
         c7IvCf5JSMFLbZFLT8mrUI7cXcrhxFhr7j9vg028NNCoeVwxqNxF//l38t+xQJAhDd0D
         gdMwTf2JL+hgdiXL0Lhnoz1Yy1cyJHWz7bxYhT+vqk3u6eNbFyCDmHYXFO0TBYa3xXZr
         HREQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790410420; x=1791015220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RC+Pb5q4XmiSnvW+7RE10jsoQIna9GU2QDuK/YngZVE=;
        b=OD9cRSourAmMF61f8+mZ2weogr32/k1XCS7dUHbxRyZVV2wWJh4fzCE12cYDBH82RC
         916fbQ5xuDmf09ysJyaW3gvppObGeZDRyJpwzOciAf3KSscmFJicjDNhGJ7MWHyeKVg0
         5fpuV87e8bPgt675SQ9DkyAkV2gwRK6qt0MDYoegpRaDHPtE3OCziE/12H+U/iI6EUJ6
         6tw7MxYYN3LQvt6LONQ3F3DgAcXO1m5YcUxMjtfNWWgn8lWXGSbzY6cQ+r5APqRAzp2M
         XClaI+ufo04gqGqPrA8Pm2KpbHCbRxvEJAMgQgS7v0AcQju8EUwJU0D7QYZ1IxECBuFw
         KZZg==
X-Gm-Message-State: AFq9FYKVSri8iImhsJCUCttJ5Kan2TCPwfLXB/h6jZtD+/XoObk97KxU
	F3Yo0i0N75Rg5CMI2tQwT85Nf6kMvEu9b4MhdkenuzRWevQMWVL1wRGzAgvil4CgDwJYTg==
X-Gm-Gg: AYBFou2cZM645ypJIpZt/zyadxUVeT8ZxG6mXq8smtweiGuvAVGrUwd28XnIjY84h2e
	Z/EXyDNCTHRYmnLc0x3Dp1W9Ak7wpcGLMuGA/3pZJelOKyl4Lotolx1seRNkmCVOjc/xGy6TVCR
	YvqrsVdSuZDNkSQORYSZ9jpK8grxsJXVbHLXzg4x5HJGudM+PbKijq9mYuWc9DLG4S+XCzNj7MH
	cxY8Z2A3XuvtDSjdKCMBMGJBQWTyVayl8Urk3pFqccXUIHm6IucbBizUAbV+J9fqfBLRTSX9wlO
	3SViSEcvHEEQ3iT9On/hf5YXd+HaTzoRqIHvSzRVkZ2+DhVmT/71OyZZRuUf8C778k+0v4UVY/1
	v0UNKbz9/ZWywSXMeZDYWAU67jnQyD39X9R9hTz3SDY4FsIerC83R29M0iJuoWKJG6fbTn25qqR
	Gt5IC/wrqgK2rUvGqsGtF+GuTctTSM4zvtcq2YwXwDj8OpuR3LbmGoxCigbMWzEsY/HAuW+I8=
X-Received: by 2002:a17:90b:4d09:b0:39f:d323:c988 with SMTP id 98e67ed59e1d1-3a098dff5e3mr6258618a91.48.1790410419831;
        Sat, 26 Sep 2026 01:13:39 -0700 (PDT)
Received: from localhost ([101.126.86.154])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b898cabesm8892556a91.0.2026.09.26.01.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 01:13:39 -0700 (PDT)
From: Dairui Zhang <zhangdairui@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [BUG] ksmbd: OOB read in ksmbd_validate_name_reconnect() via cross-share durable reconnect
Date: Sat, 26 Sep 2026 16:13:35 +0800
Message-ID: <20260926081335.1671600-1-zhangdairui@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

In ksmbd_validate_name_reconnect() (vfs_cache.c:1701) the name check
does:

	pathname = kmalloc(PATH_MAX, KSMBD_DEFAULT_GFP);		/* :1707 */
	ab_pathname = d_path(&fp->filp->f_path, pathname, PATH_MAX);	/* :1711 */
	...
	if (name && strcmp(&ab_pathname[share->path_sz + 1], name))	/* :1717 */

d_path() fills the buffer from the end, so the string ends at
pathname + PATH_MAX - 1. Nothing checks that ab_pathname is longer
than share->path_sz + 1, or that it starts with share->path. If the
file's real path is shorter, strcmp() reads past the end of the
4096-byte buffer; the distance is
share->path_sz + 1 - strlen(ab_pathname), which the client
influences through the choice of share.

The path can be shorter because the durable fp is not bound to its
original share: session_fd_check() clears fp->conn/fp->tcon
(vfs_cache.c:1647-1648), the reconnect looks the fp up globally by
persistent id or CreateGuid, and smb2_check_durable_oplock()
validates it against the *reconnecting* tree's share (smb2pdu.c:3773
-> oplock.c:2407) - it checks owner, ClientGUID and lease key, but
never the share. So:

  1. open a file on share A (short path) with a durable handle,
  2. drop the connection (the fp survives as durable-disconnected),
  3. reconnect to share B (long path), send CREATE with
     DURABLE_RECONNECT and the original ids,

and strcmp() reads roughly (share B path length) bytes past the
kmalloc buffer. With a long enough share B path that is likely
unmapped, so probably a kernel oops - a remote DoS. If it lands on a
mapped page, the strcmp result is also a byte-equality oracle on
adjacent heap: the reconnect succeeds exactly when the out-of-bounds
string equals the requested name.

There is also a 1-byte over-read in the same-share case when the
durable fp is the share root (strlen(ab_pathname) == share->path_sz,
so the index lands exactly one past the buffer).

Preconditions, as far as I can tell: durable handles enabled
(KSMBD_GLOBAL_FLAG_DURABLE_HANDLE) and the attacker can reach two
shares with different path lengths.

Suggested fix: check the prefix before indexing -
strlen(ab_pathname) > share->path_sz && ab_pathname[share->path_sz]
== '/' - and ideally bind the durable fp to its original share at
reconnect. Happy to write this up as a patch if that sounds right.

From code reading only, my second report here - if I've misread
something, please tell me.

Thanks,
Dairui Zhang
