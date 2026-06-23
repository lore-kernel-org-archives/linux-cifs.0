Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F95A12C534
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782182844; cv=none; b=T8C670aDmepSHxYKtq+JLai4QJuxslrBIYKeMUq48xI7b+TvkSkr+K+K5r5PJ7N9BdZN+LkKaq3crOfpFs3yJ6Rv1h5Z/Bf770qF48J4i+Huqd9XIAepXB8wwT0naavdq1E/AH5J8q/IounY0KQTIG/i+0dqE3hyORwxBjtAXXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782182844; c=relaxed/simple;
	bh=sowyx7SPTtnsYWZ4/0uya3iiR2mupb+A7DBVV2ZZXYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fJfmKpSaJ7p/eUHZLAYZrGydOgEdcBsm7l0JsUgjdm+wYdBT3Q9C5deC+sENtnupZWraC6vEbtu6mON/BsM0SZuapDvIADQDYAjMr+SoyfihDr0rfZNEqiYfBVcnf5vwS85QsHwMFBG6dncNGFb25B3MOvIJHIW/ew51wNwg7W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dwQyKkUc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dwQyKkUc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782182841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lMNrxddZKkeqXAvHnrWJ7MB4s/bwsDSaCIDN4tuZbv4=;
	b=dwQyKkUcsXYLgbtZwr2T2Gv/+cRQ7IqDzuRz1ShT9NRSLTJVpQ8E7ejOd7jh9QbvSI5lRK
	Rc03rqZBMJP2v5Ft/u8MFrQAu+BMJ8wdrt3UevtMNmWfZ5NUm1wWxgtio36YIozU08kSEq
	gttGaLpBAPYb0buR5cCjsQFt0lgnmoU=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH 0/7] smb/client: fix fallocate allocation handling
Date: Tue, 23 Jun 2026 10:46:12 +0800
Message-ID: <20260623024619.1360127-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

CIFS fallocate can return success without allocating the requested space.
It can also derive i_blocks from EOF, making sparse files appear fully
allocated.

This series propagates sparse conversion failures, corrects i_blocks
accounting, and verifies server allocation after EOF-extending mode 0
fallocate. It also reduces the memory used by zero-write emulation and
supports small ranges starting at EOF.

General arbitrary-range preallocation remains unsupported because SMB2
provides no equivalent operation. Small ranges can be emulated by writing
zeroes.

Tested against Samba with xfstests. With `strict allocate=yes`,
generic/496, generic/568 and generic/701 pass with server allocation
verified. generic/495 was used to verify that EOF extension no longer
inflates i_blocks.

With `strict allocate=no`, requests whose allocation cannot be verified
fail instead of reporting false preallocation success.

Huiwen He (7):
  smb/client: name the default fallocate mode
  smb/client: handle smb2_set_sparse() failure in EOF-extending
    fallocate
  smb/client: handle smb2_set_sparse() failure in non-extending
    fallocate
  smb/client: do not account EOF extension as allocation
  smb/client: verify allocation after EOF-extending fallocate
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small fallocate ranges at EOF

 fs/smb/client/inode.c     |  13 +++-
 fs/smb/client/smb2ops.c   | 128 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c   |  19 ++++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 5 files changed, 151 insertions(+), 17 deletions(-)

-- 
2.43.0

