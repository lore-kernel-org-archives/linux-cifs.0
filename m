Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE5C3C1414
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787210154; cv=none; b=NQtRzMXkQCez8nu1n4iVc24weGLdIEUsIOFREu3DU+xvKqM7E9T2ZevVw8IN7uvXOtdqEu4gBqM3ZN/HXilRkGgoG5nmuWIhykaMtO38PJOKWh7r0qypabpAVylD6w1qYNtxGB3DipezNdAa/tef9GkLbv06vACCiIQcrOlPiuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787210154; c=relaxed/simple;
	bh=eaKPQ0lrpTvAw1naS3k22QikSAa6dEg50jDij93ae9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UPLMqip33ekwjv1Vs4KzS0HJZ5U2JeZBd6C8YajXfYX3ej83ckQJSNNh+sSqNC9ARsPNAVHuWdoI4ztYNXyD7jNo7vITyFgsHdNU8JNs7tcJH6bbDEVKCkpnTFXiKC3zlgVkQFsSz6k+tFhJ4uyP+jTDmaGAMgLwOYA/QPLY9i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oLtm3m9A; arc=none smtp.client-ip=91.218.175.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oLtm3m9A"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eaKPQ0lrpTvAw1naS3k22QikSAa6dEg50jDij93ae9Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787210149; v=1; x=1787814949;
 b=oLtm3m9AC3Dkuxq4fsOKge1mWKjXpq0wlRfy/2DHjDEsrQOCOYi7y1nZvxOGUzapYE1L/fRf
 7ZhrPzo/47rw+R0TCODLMwnTmcrd/+lBwdeSOmlXaQSydEdhLZXhzDy7IMTEgb3SxKn/NCWVUzE
 cGnfMdmJzVADLWtE8lzyZ7QU=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from harry-WUJIE-Series.. (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 9bb3bf81686e4a1c;
	Thu, 20 Aug 2026 07:15:49 +0000
X-Mizu-Trace-ID: 9bb3bf81686e4a1c
X-Migadu-Flow: FLOW_OUT
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
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v2 0/6] smb/client: fix emulated insert/collapse range issues
Date: Thu, 20 Aug 2026 15:15:20 +0800
Message-ID: <20260820071526.826926-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

This series fixes the SMB3 FALLOC_FL_INSERT_RANGE and
FALLOC_FL_COLLAPSE_RANGE emulation.

Patch 1 validates the new EOF for insert range, which previously allowed
RLIMIT_FSIZE to be bypassed.

Patch 2 validates the new EOF for zero range when it extends the file.

Patch 3 marks the file sparse before emulating insert range so the
inserted range becomes a real hole, fixing xfstests generic/064 against
Samba and ksmbd.

Patch 4 fixes data corruption in emulated insert range by copying
overlapping ranges from EOF backwards.

Patch 5 fixes integer truncation when the collapse-range copy exceeds
INT_MAX bytes.

Patch 6 fixes stale page cache after the range emulation, where reads
returned zeroes instead of the shifted data.

Changes in v2:

- update patch3 to propagate SET_SPARSE fails.
- Add patch2 and patch4-6.
 
Link to v1:
https://lore.kernel.org/linux-cifs/20260813132136.366532-1-huiwen.he@linux.dev/

Thanks,
Huiwen

Huiwen He (6):
  smb/client: validate new EOF for insert range
  smb/client: validate new EOF for zero range
  smb/client: mark file sparse before emulating insert range
  smb/client: fix data corruption in emulated insert range
  smb/client: fix integer truncation in collapse range
  smb/client: fix stale page cache in insert/collapse range

 fs/smb/client/smb2ops.c | 202 +++++++++++++++++++++++++++++++++-------
 1 file changed, 168 insertions(+), 34 deletions(-)

-- 
2.43.0

