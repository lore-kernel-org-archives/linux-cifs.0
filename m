Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F28C40B6EF
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782919362; cv=none; b=e4oD5jpquIcIUnFRJrvwyD9+DLtI1n24NkIaAtD8WsubNN8BIuctHKmeftPesoDCzhEwR2as1mLXIwmG1oZZsM444bjpaq/4wIRRNw59gcEnLP043sdIr2MOZYUEiLAtR9v+ca2Xx7zwNtm/HK0zikWeZLJgF8cR0Kryi8n6mnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782919362; c=relaxed/simple;
	bh=M8t459XHvewCFHKh1uMHnr6aziei1YJSYWwIC1BBxwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lgOoOoA8nUP6YMbhTTxhqEAXkdNv/IlejoTZSJOASLuebVQe0tFTYjI/hhyiUHUWUZEqhb2S/IzhE48iBBVCspa34V2iGA94lxeN4Vut+lpj2R8yCRvnQDsrqjthX7fbxCWrBUtw9ls3LKI+ThvbZFN72JJo3N96wAN3ddzSelE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/T+dF1H; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/T+dF1H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782919358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vu6Zg888dOBxCwONLMBFX2gXUDGGjwmNrtjCg2lEWJE=;
	b=o/T+dF1HjDgYFIIBbHMXHRrP88bBGN3WIrCyeCHTsMrPyX7jKYAOEcpb3H8wSx0wZ6nFpJ
	O6a4oevgahrfivd6Bln7iaqE0YIX7XEcCCT7uHE0kvY2ANu+vSbVjqyb3TMMSmEns2PuZ1
	j6sqnWWUf93moAlyHJGPefXW90xO6rQ=
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
Subject: [PATCH v6 0/5] smb: fix fallocate and allocation accounting
Date: Wed,  1 Jul 2026 23:21:52 +0800
Message-ID: <20260701152157.822207-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes in v6:

- Rework patch 4 to remove the client-side statfs ENOSPC precheck. The
  server should report ENOSPC from the real allocation attempt; this fixes
  the xfstests generic/103 regression and keeps the generic/213 ENOSPC
  failure exposed with Samba "strict allocate = no".

- Add patch 5 to fix generic/213 on ksmbd by mapping SET_INFO
  -ENOSPC/-EFBIG to STATUS_DISK_FULL.

Link to v5:
https://lore.kernel.org/linux-cifs/20260630104010.571140-1-huiwen.he@linux.dev

Thanks,
Huiwen

Huiwen He (5):
  smb/client: refresh allocation size after duplicate extents
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small EOF-extending mode 0 fallocate ranges
  smb/client: refresh allocation after EOF-extending fallocate
  smb/server: map SET_INFO ENOSPC to disk full

 fs/smb/client/smb2ops.c   | 116 +++++++++++++++++++++++++++++++++++---
 fs/smb/client/smb2pdu.c   |  19 +++++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 fs/smb/server/smb2pdu.c   |   2 +
 fs/smb/server/smb2pdu.h   |   4 --
 6 files changed, 136 insertions(+), 13 deletions(-)

-- 
2.43.0

