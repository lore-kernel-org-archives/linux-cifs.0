Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C55231ED83
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780934304; cv=none; b=TU41TqB4U5+fPyceZpzBlCXNyjFQNbLROkYipUYkeFYZXD/h9tw48yrWnPILcXkNDEUAFNRa1L6RjrKmIEG0xYNNYIh74DoSur2ZjWkS2v1Gm1iV+2YRRPuaFjQClR6pT3/iltWxaLrNLLSJLBnUYrJyZ7JmYDj9emZd4tRkCDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780934304; c=relaxed/simple;
	bh=sFiROHxVmt3EUiuSrDRn0yrnVOATkKtwTj4UmXId0N4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kkrlQfjvQ+Ybjp6nGh4YpWQG4n4PKVXEKuQLYzmyqE/6c6RQCtudRezXE5OvW4Mdm7Qag+E6h9scluBwiJH7+Vs6QTLkBvDm5P8vH+GqE3knOMB9ojQedjQjhlBRP+u0RDwdVrKe7wgljYHoYB1Y78f0GrJAgtL8iMnCPzWcoPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jLzUdfSn; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jLzUdfSn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780934301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vB1XtJNB49NnJXJ+jCi7gYTUbchiMQCbLspuVWD8aGA=;
	b=jLzUdfSngnkFxCii4sJIXpLW+gKxx8zK2FP4KMmVwIS3Rf3zvwIDHuA6RTdZeXqthYzVe3
	z2hazFF2iEuFPfHNpn1h80ONqUJcS/E89injFkbNiH9eV8BzKVt/lMWCKLcyJzM/hfanGq
	sisYsuwKorr4sr3deBrm9DsRcanBp/Q=
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
Subject: [PATCH v2 0/3] smb: client: fix file compression flag ioctls
Date: Mon,  8 Jun 2026 23:57:28 +0800
Message-ID: <20260608155731.634984-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

v1->v2:
- Patch 1 is unchanged.
- Patch 2 now requests FILE_READ_ATTRIBUTES for the temporary by-path
  handle, only falls back to by-path open for -EBADF from
  cifs_get_writable_file(), removes the thin set_compression wrapper, and
  moves the temporary cifsFileInfo off the stack to fix the LKP
  frame-size warning.
- Patch 3 now returns -EOPNOTSUPP for unsupported FS_IOC_SETFLAGS bits and
  is adjusted for the helper cleanup in patch 2.

Link to v1:
https://lore.kernel.org/linux-cifs/20260606144316.183032-1-huiwen.he@linux.dev

Thanks,
Huiwen He

Huiwen He (3):
  smb/client: always return a value for FS_IOC_GETFLAGS
  smb/client: use writable handle for FS_IOC_SETFLAGS compression
  smb/client: allow FS_IOC_SETFLAGS to clear compression

 fs/smb/client/cifsglob.h  |   2 +-
 fs/smb/client/cifssmb.c   |   4 +-
 fs/smb/client/ioctl.c     | 153 ++++++++++++++++++++++++++++++++++----
 fs/smb/client/smb1ops.c   |   5 +-
 fs/smb/client/smb1proto.h |   2 +-
 fs/smb/client/smb2ops.c   |   4 +-
 fs/smb/client/smb2pdu.c   |   6 +-
 fs/smb/client/smb2proto.h |   3 +-
 8 files changed, 153 insertions(+), 26 deletions(-)

-- 
2.43.0

