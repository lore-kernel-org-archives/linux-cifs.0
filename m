Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86662353A90
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 15:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783005210; cv=none; b=Dbua0bK80FK2O7LB2pY+rXOWfOy0NCKISyCR8nOFHlFP0vJ2dM1kalyeuLZFhHAxsrqpknUurdgTuS7TmBKtmrmiUm4ggbz3bn0FjPuxZKXyTIIEjQ/XXbA6bT/8u13R0z8HsGBpqbf5fokaBZfwrntzu3TKSvWYVIg1AmkuiVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783005210; c=relaxed/simple;
	bh=U+9gf0ALC1vyUsVS2+B29qW+M8oiu/iCD5WqGshe/K0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gGipTJDcTTO7jZFb3xa+vcID6ABg3fjhoP37CtWWV7Obvlw3+qQg9gwRx+hhP+dw12AKNEObmzAFbhKQmBZC25TlQOHX2+y+u0QMcVCemAAVX6A77pwQcphJ6igP+UYynfUrAZpVTSZT3o/dQWonrrtjKNBgqqIaEG/8bWmb50k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iXQ3YK2I; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iXQ3YK2I"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783005206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Zf3sdG0yktCb1X8kLlgzvH0B0Jq/ULyLEwWh9M3sSUk=;
	b=iXQ3YK2IRxxPv7wdnRB0YYOpSsvMr1RbkukQyymA3GthUlTesyH7o2XU/tuTxUWxX1jFF9
	qvtLSxJzJYawdie6AIZJ1K+JMe6oBlAetKUKNtQucg/ZTDBynhZjpAxKOWwErfNJqnSNZi
	B2vYBrtlBDWCikBCuIb27MGnkdphlOc=
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
Subject: [PATCH v7 0/4] smb: fix fallocate and allocation accounting
Date: Thu,  2 Jul 2026 23:12:51 +0800
Message-ID: <20260702151255.886945-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Changes in v7:

- Rework Patch 1 to keeps the duplicate-extents QueryInfo result valid in
  the inode cache, avoiding duplicate revalidation when userspace stats
  the cloned file.

- Rework Patch 3 to no longer uses FSCTL_QUERY_ALLOCATED_RANGES for small
  fallocate ranges that start at or beyond EOF. These ranges are now
  zero-written directly because there are no old allocated ranges to
  preserve there.

The following patch merged into #ksmbd-for-next-next is not resent:
  - smb/server: map SET_INFO ENOSPC to disk full

The following patches are already in upstream and are not resent:
  - 898d280f4e4d smb/client: name the default fallocate mode
  - 2a4b3d2db5c6 smb/client: preserve errors from smb2_set_sparse()
  - 99cd0a6eeb6c smb/client: do not account EOF extension as allocation

Link to v6:
https://lore.kernel.org/linux-cifs/20260701152157.822207-1-huiwen.he@linux.dev/

Thanks,
Huiwen

Huiwen He (4):
  smb/client: refresh allocation size after duplicate extents
  smb/client: reduce fallocate zero buffer allocation
  smb/client: emulate small EOF-extending mode 0 fallocate ranges
  smb/client: refresh allocation after EOF-extending fallocate

 fs/smb/client/cifsfs.c    |  10 ++-
 fs/smb/client/smb2ops.c   | 147 ++++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c   |  19 +++++
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/common/fscc.h      |   5 ++
 fs/smb/server/smb2pdu.h   |   4 --
 6 files changed, 167 insertions(+), 21 deletions(-)

-- 
2.43.0

