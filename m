Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDC5370D43
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 04:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784779953; cv=none; b=YNhkz6XYu2qY8Ri+/c5WFB6HDpXr8hq255nMCtZ4BybMjrrKG0u/Qu9hdR2H+nWYUcm/FXjIUD9A4PQ4ximv4ehhBV99sBeflYrCPXsme1W+DcWD0m2sCRjpnnCeTzPvBXzOyz3OfwCIl1eDpKBbe2fUY8m1fnHcPWDYmRXQwUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784779953; c=relaxed/simple;
	bh=B3XAlMsed83LmvvvqsTH7X963zfUJTrCb0UR1fn8GhI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CUU0yq3Hv6e+PgondTtpJkWLCLw9dLLfzXYU5A70XozbomDwJjpXA8yZcz9Vdhw0k4cjZgESjZae3LVczCpsYIs4TZAsU6TQ23gbvEM85ryJi9TH0uGotdoAX9TymkneB3eQ6J2R1JOAnKWSU5wjgeGumKMNl1xFf+j5maBv7Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=QQZbYeNb; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="QQZbYeNb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784779913;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qmsB+Lu10SkM7Sq1mpkbWP9UNPJcsnPrmZghiq5T/Zw=;
	b=QQZbYeNb5kGffzKwHCXUDgF66VwClvFhOqelugc2PuiIZfUS0FEZ9ugdBeFjmIc17+vK1P
	NCzSn0vK0TI64/vTCdSIZhcsQrIIbqPld62fJOgr/KC81PLokAt6cMX4DhZboPetZs9df5
	MJgvAkLf3NI4O6/RFRG7YqP5pSBpWPYlAH9VZFe452WzDOaPlPc//jt8CUmgeBnNABm6dP
	wMyTY3WvA6dtnQaGpDzH0dtT3DqqC8bvbXuv71LXZEMQtiqWNlt9egkRbZLMu63b0BBbxC
	CuFAxo+sXNuAm172nsvx+luoKLji6GR3GK3YI2+bl5FghLjsG3UTHBzQiAbQvA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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
	gael.blivet@gmail.com,
	andriy.shevchenko@linux.intel.com
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v3 0/3] smb/server: fix some bugs in preparation for change notify support
Date: Thu, 23 Jul 2026 04:11:28 +0000
Message-ID: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v2->v3:
  - Patch#01: use WARN_ON_ONCE(1).
  - Patch#02: use list_for_each_entry_safe().

v2: https://lore.kernel.org/linux-cifs/20260716001156.671587-1-chenxiaosong@chenxiaosong.com/

I have implemented the ksmbd change notify feature, please see the following link:
https://chenxiaosong.com/lkml/ksmbd-notify

However, to make this feature work properly, some pre-existing bugs need to be fixed first.

ChenXiaoSong (3):
  smb/server: fix signing when a response uses more than one iov
  smb/server: cancel async requests when closing connection
  smb/server: stop new async work when closing connection

 fs/smb/server/connection.c | 21 +++++++++++
 fs/smb/server/smb2pdu.c    | 75 ++++++++++++++++++++++++++------------
 2 files changed, 73 insertions(+), 23 deletions(-)

-- 
2.54.0

