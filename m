Received: from mta1.migadu.com (out-131.mta1.migadu.com [95.215.58.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E3A30F526
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787497896; cv=none; b=bHD5X7oN4d/xjqOEp2B3Jo6NnMIySep9dFAe35TjV0j0oxGlMyhosGqb/K8iYVjsohk0FLXnaRQC3+RQPhPzGyxz1R6lNj1eHanYnGoPjPL/KvVlpBms5i37S6xQMcCIaCNgnNQA1N83IGKbVDCK0pGkzLsddivTZmAR+ydyTcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787497896; c=relaxed/simple;
	bh=pRfutF+Kh/8R3OPs3EPdlEybtWbnyikSaUIhqhRRYTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fsUBvAY/S6k0YLyiuJ5FXRbXayNl4LBZp7O5o2W/GRr0sjn5nfD3NcJ2BliX9pkTK4gwjqARWwuwKrIp1EqUwVWRQ2mxOxOYisx7a496z/c5SN48SsoRSSZDAwu7Lft1zwY0uQSt1Rfn57bKWKUaqIXVD4SgIwX+TqUE+sOkDvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NbhKjOQ8; arc=none smtp.client-ip=95.215.58.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NbhKjOQ8"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pRfutF+Kh/8R3OPs3EPdlEybtWbnyikSaUIhqhRRYTo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787497892; v=1; x=1788102692;
 b=NbhKjOQ8ZIw7cm7nXJ8bc3P8eBIPz4L6ueysQEp7eQT3Q7OszISvxw5f3c9hN048bQN3Ny/B
 KI4U+nnZWvxjZ+4G+2bBBsW4r401iVn7tpv3oqfLRGRFR3yiSWGcvK1ZRyJGgEeLDrQUD5ZFuiF
 MFGrT1r3H1uDdKc80vuDJn6s=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from localhost.localdomain (2408:8352:470:269e:918b:d2e0:eaa5:de79)
	by smtp.migadu.com with ESMTPS id 1a8a513c5bdbbea7;
	Sun, 23 Aug 2026 15:11:22 +0000
X-Mizu-Trace-ID: 1a8a513c5bdbbea7
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v3 0/7] smb/client: fix fallocate range operation issues
Date: Sun, 23 Aug 2026 23:10:46 +0800
Message-ID: <20260823151053.935889-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

This series fixes several issues in SMB3 fallocate range operations,
including insert range, collapse range, zero range, and punch hole.

Changes in v3:

- Update patch 6 to use page-aligned truncate_pagecache_range() instead
  of invalidate_inode_pages2_range(), avoiding possible -EBUSY failures.
- Add patch 7 to invalidate FS-Cache for zero range, punch hole, insert
  range, and collapse range.

Link to v2:
https://lore.kernel.org/linux-cifs/20260820071526.826926-1-huiwen.he@linux.dev

Thanks,
Huiwen

Huiwen He (7):
  smb/client: validate new EOF for insert range
  smb/client: validate new EOF for zero range
  smb/client: mark file sparse before emulating insert range
  smb/client: fix data corruption in emulated insert range
  smb/client: fix integer truncation in collapse range
  smb/client: fix stale page cache in insert/collapse range
  smb/client: invalidate fscache for fallocate range operations

 fs/smb/client/smb2ops.c | 201 +++++++++++++++++++++++++++++++++-------
 1 file changed, 167 insertions(+), 34 deletions(-)

-- 
2.43.0

