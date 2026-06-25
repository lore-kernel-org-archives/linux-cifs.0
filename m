Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321C7328B75
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 16:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782403353; cv=none; b=hhLcjcHrVEqD+kTlJbX0gc2tTLyJw7dxcIrh4bByr9GOIhT/xilDT1K6r0YGVbuuYivB1BzdNXgN3r0AhM7SDfXWRVIwCLoH2fzYpR90HOEwtg5AX90/zTPmAxH2weoxjGv/htMUu4azBvWz2Z9ebFA3gf44pHOJD8mjUKQ/qIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782403353; c=relaxed/simple;
	bh=qb2/9eY9/MAGyCsAeVdh9o2VYX4FDJ1S7uGWevimLwA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JIyRpwK/dV8k/wjl9ADINg/Ge6IwEmT70qt3pSJ++KNuAtNy/aMVJmYyQnM5BE2ermXEoVoBn6yjOAMXmZUpbWmzK4RrPM3WL2vRL8t/9vKaHD4sncxuqfHjAfoXv7hcjomWSXba2PRRnEmqe3Po2hRymyXlGfNWs3bcJebycwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fR9z5o28; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fR9z5o28"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782403344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jMHQEht9XCyEb1X5y9LAW/eDxru88Krw6H5sjjfAuqA=;
	b=fR9z5o28PtGQZ6ZuO15UXpaTkB5iVzJFTl4M4QUMQXrk6cPEqY6hpMMIQwRRCB4ifTJ0Jf
	Lkt2jmJqDutKp1HTCHKZbsZTf5+rwAHxCuHWchxXyTDW0dtszaMDEVZXA6nIT2bvlES4Yl
	0RL6zu/XbVXBbUHpZrQO88Pk7h2ptaQ=
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
Subject: [PATCH v3 0/9] smb/client: fix mode 0 fallocate handling
Date: Fri, 26 Jun 2026 00:01:45 +0800
Message-ID: <20260625160154.104450-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes in v3:

- Move the v2 patch 6 to patch 9, so AllocationSize verification runs after
  the zero-write emulation fixes.
- Extend the v2 patch 9 and move it to patch 8.  It now also handles small
  mode 0 fallocate ranges past EOF, preserving the intervening hole for the
  generic/213 case.
- Update the related commit messages and test notes.

Thanks,
Huiwen He

Link to v2:
https://lore.kernel.org/linux-cifs/20260624021550.1548952-1-huiwen.he@linux.dev

Huiwen He (9):
  smb/client: name the default fallocate mode
  smb/client: preserve errors from smb2_set_sparse()
  smb/client: handle smb2_set_sparse() failure in EOF-extending
    fallocate
  smb/client: handle smb2_set_sparse() failure in non-extending
    fallocate
  smb/client: do not account EOF extension as allocation
  smb/client: handle overlapping allocated ranges in fallocate
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small mode 0 fallocate ranges at or past EOF
  smb/client: verify allocation after EOF-extending fallocate

 fs/smb/client/inode.c     |  13 ++-
 fs/smb/client/smb2ops.c   | 183 ++++++++++++++++++++++++++++++--------
 fs/smb/client/smb2pdu.c   |  19 ++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 5 files changed, 184 insertions(+), 39 deletions(-)

-- 
2.43.0

