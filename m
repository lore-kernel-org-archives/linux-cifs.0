Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9B6416CE8
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jun 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780677342; cv=none; b=bAKpgfuD1PP5KA+xh/QM0W/CL6v30bhUbdK2wtYoUTOYFv/VqZj7zeDcbPWDE0mWM8D9EEDTt1WKYCZoHAeOcFkCNKvrIcYy8rva/QUizOtw0w+RoWFsQ5GdVITFa1RQqCpYQKZuGXDu5R4CLVRvk9p9hyD/T5IIzDh83WRU+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780677342; c=relaxed/simple;
	bh=A2Ns3HWRS7T1zPXkWrUMa87ncvAwj3wAGY1WdUKcNLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVnHr9Ef8TzedKHrYH07YF/OPaq3sRjDbgwWgWHVkudE8j4TIAN1VjPjl5vQ4984knYG1hTSSk2Le3Ghah6JU01jHlJiBorQPKpkuovh5pmWWzmHaFXV4DkrJVSUdsATMeTEsnOywc+43t6F4H+IvSC9TrSmO1XT3YRXs2OlhNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FVetK1f8; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FVetK1f8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780677337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FOTVR/2RU1e6zHgQn5DlC/4XzTq53sdhuZ0qUCCytgE=;
	b=FVetK1f8LHV/v1GYuhLj1C4kAX9uOXg6MVht3jMGY3RBeqMuQq6oxzBL3iPBkN1rp6okJV
	jNWCDRoeVFpeawHLuM/slLpsN2WZjXe3B6n5/NZm7bmlumm4FsqLvwVQ5h/WV7u/peoWVB
	pihTtNLor6AxfDRA97karqxDiNHXSUc=
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
Subject: [PATCH v2 0/3] smb: client: fix i_blocks accounting for swapfile xfstests
Date: Sat,  6 Jun 2026 00:35:16 +0800
Message-ID: <20260605163519.169916-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

This series fixes CIFS swapfile xfstests failures caused by incorrect local
i_blocks accounting while cached inode attributes can be used.

The patches cover three cases:

  1. Update i_blocks after contiguous writes, so fully written swapfiles do
     not look sparse.

  2. Do not grow i_blocks on EOF extension, since extending EOF does not
     prove that the range was allocated.

  3. After EOF-extending fallocate, refresh i_blocks from the
     server-reported AllocationSize.

In my setup, the write-created swapfile tests pass with the cifsacl mount
option:

        generic/472 generic/494 generic/497
        generic/569 generic/636 generic/643

generic/496 also passes with this series when the server really allocates the
fallocated range, for example with Samba:

        [scratch_share]
        strict allocate = yes

generic/495 depends on the server-reported allocation unit matching the page
size.  In my Samba setup this requires:

        [global]
        block size = 4096

---
Changes since v1:
- Patch 1 was updated to cover more CIFS write paths and to use common
  helpers for local i_blocks accounting.
- Patches 2 and 3 are unchanged.

Link to v1:
https://lore.kernel.org/linux-cifs/20260604150349.101716-1-huiwen.he@linux.dev/
---

Thanks,
Huiwen He

Huiwen He (3):
  smb/client: update i_blocks after contiguous writes
  smb/client: do not account EOF extension as allocation
  smb/client: refresh allocation size after fallocate

 fs/smb/client/cifsfs.c   |  4 ++--
 fs/smb/client/cifsfs.h   |  1 +
 fs/smb/client/cifsglob.h |  9 ++++---
 fs/smb/client/file.c     | 52 ++++++++++++++++++++++++++++++++++++++++
 fs/smb/client/inode.c    | 13 +++++++---
 fs/smb/client/smb2ops.c  | 15 ++++++++++++
 6 files changed, 86 insertions(+), 8 deletions(-)

-- 
2.43.0

