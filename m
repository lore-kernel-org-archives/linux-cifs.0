Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784830E83F
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jun 2026 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780585451; cv=none; b=iQ4j/mHPW9RMlh84xlcfDDrnaCLnJx567HRqvPuB6lvK9m+zQVuQ7q/9GfTAZAPlqedlTTWd9sAhYD9sjGgCIBXvmOO6cEuuzS5OtY4JkNiyhdiH3KRHFXjFdj8G5m1tyJ6wJYKap/wQkpAWpM2WNdDDP+Qzrxb5Vkhob02FEh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780585451; c=relaxed/simple;
	bh=N4TKyqniH/HTcRmhxtDV6cOPQhsMR3J5wjgqOnn+U/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jf54oo/kPdX4AcVoEKpy+BFmxpsSmRlk6EFsi1BADCxMvL3zCEPnNZv626wML6yb69WCfCeDaduuFFv3pc8/XcrFjkYrYPtAF48g5Re/XxhkGcMhhJ6hcHkXAwMligkYjAEsle5w5CcuDaOT9VGLDHn73SWyFqxsrQ/Tn8K9y9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KfG5ke//; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KfG5ke//"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780585446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zq7drzBiiFGb6eqjP+5+g7Eos8aotJeMs2RmInriCd8=;
	b=KfG5ke//NqltGsft0vQ5ZuGAl1n6wqHuxmKm1tR3p8XgAXcxoV8K8uaduzpcRQi3oQSkAx
	KBGACz2bitk09+gQ/MeCBvMBwj4n0I+IjIvuFAtN5ZyOQYxA4V8zygd9ZT0q714c9BExLQ
	HGO2VDCLuUtYgHNClKwvhJTTcpI0GSM=
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
Subject: [PATCH 0/3] smb: client: fix i_blocks accounting for swapfile xfstests
Date: Thu,  4 Jun 2026 23:03:46 +0800
Message-ID: <20260604150349.101716-1-huiwen.he@linux.dev>
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

Thanks,
Huiwen He

Huiwen He (3):
  smb/client: update i_blocks after contiguous writes
  smb/client: do not account EOF extension as allocation
  smb/client: refresh allocation size after fallocate

 fs/smb/client/cifsglob.h |  9 ++++++---
 fs/smb/client/file.c     | 31 +++++++++++++++++++++++++++++++
 fs/smb/client/inode.c    | 13 ++++++++++---
 fs/smb/client/smb2ops.c  | 15 +++++++++++++++
 4 files changed, 62 insertions(+), 6 deletions(-)

-- 
2.43.0

