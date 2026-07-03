Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23243630B0
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783056842; cv=none; b=QpfWLDX1/Df8XUoLHZzX/REux+UcMjD/Q5ZcyJ//kM2VZ8wA6p5SyVXV+KZUyKodfOOr5/g4WptdapXZUKKOuEatIW+SiR3RC4mMKLjWMGBR/j+3RqyjvhyoeIhes6wpu7hG3dkYymoHdEznspymJv/4Y6ADoFazXmB4Kmu8AhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783056842; c=relaxed/simple;
	bh=aH/tTZbYmkIqJhCyCKsAnILbTFsxbE9Gv1SZ5WVt2dg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=opPmq7YF+bKffC4DMmM7JYKi0sxK2pnsJEvgpdqI8cwKrLbzo5PhiLSXz6Yd8jHP76H8EzYCs3y9HmRpK5o9HjNKB9UdxWfGqFd2I5xHuIKc4PvD4DeOBGKH2C9z+vqb9diBaZiS2wTFSQ6c2SO+3EYQbLr3KeRuIaKmpIv5Xzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uDo83A5M; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uDo83A5M"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783056835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3SAO8rpaNKA4OegAsTKxRQZNaOEu+sakZXCmxYFgHuU=;
	b=uDo83A5M9dcW9DoHjmdrArv8g6UZJVpOKz0iUkSMsj0J9g69HTTIuXwV0mwHCVVs2Q1M6t
	ndSielsjh2cvq1kmiztBKiKidaB35QoTAdyN6osE5BrEukpd4ooPlZLJLIAfCRAE2Bf6Gk
	vCxF6uFBrnTwsds6AJG9v3fWXRsb/V8=
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
Subject: [PATCH v8 0/5] smb: fix fallocate and allocation accounting
Date: Fri,  3 Jul 2026 13:32:54 +0800
Message-ID: <20260703053300.913371-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes in v8:

- Add back the overlapping allocated-range fix as patch 2. This patch
  was dropped after v5, but it addresses Shashiko's review comments
  about overlapping allocated ranges and malformed range lengths.

  Although I could not reproduce this locally, a malicious or unusualserver
  could theoretically return such a range.

- Rebase the later patches on top of the restored patch 2. No other
  behavior change is intended.

The following patch merged into #ksmbd-for-next-next is not resent:
  - smb/server: map SET_INFO ENOSPC to disk full

The following patches are already in upstream and are not resent:
  - 898d280f4e4d smb/client: name the default fallocate mode
  - 2a4b3d2db5c6 smb/client: preserve errors from smb2_set_sparse()
  - 99cd0a6eeb6c smb/client: do not account EOF extension as allocation

Link to v7:
https://lore.kernel.org/linux-cifs/20260702151255.886945-1-huiwen.he@linux.dev

Thanks,
Huiwen

Huiwen He (5):
  smb/client: refresh allocation size after duplicate extents
  smb/client: handle overlapping allocated ranges in fallocate
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small EOF-extending mode 0 fallocate ranges
  smb/client: refresh allocation after EOF-extending fallocate

 fs/smb/client/cifsfs.c    |  10 ++-
 fs/smb/client/smb2ops.c   | 172 +++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb2pdu.c   |  19 +++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 fs/smb/server/smb2pdu.h   |   4 -
 6 files changed, 185 insertions(+), 28 deletions(-)

-- 
2.43.0

