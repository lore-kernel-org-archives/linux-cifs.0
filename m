Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB641714AA
	for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2026 01:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784079604; cv=none; b=YeGvpm0Nlztyv7tQ/4ofs+56fB2CAYzFs82T9jeduDL7AYMv0wFAfUZpgX3ESxQrrI7mhNQQrG6dVeKfzwIYEQ5BYcNgbPmV0S71SMfE5tMnGMJyFuZiqYHSaqgErXWL2o16nAInZYaMNa53X6EfTYhulawuW/UtIHMenPlHyTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784079604; c=relaxed/simple;
	bh=vX0DuoQxLY9K5pfEG3ZGgsMChv//W37bDdXUW5XweOY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MFUUSuqEmfi1h3fo7VPaR3tjgvOqq93MeZttLoMZNoLOqjqCfBR0gdrAuhodUguLFZbuTbqRmpKtrz4HVxqb944rrG7yr4MyCe1gJ7bLF05ZOuomdkaKCFi6QDYbTficvE/fr9RjeUp2JlkYdqwMhbEpdURBawy98wmrdeNwbq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XXPn1u5w; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XXPn1u5w"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784079599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iijbIxLISYtQisuW/r299FO8iyROB4Sz5U6j5OpaBw8=;
	b=XXPn1u5wYlwqVFv3MjHn0yIqil5k9DWnO8ItNa9w1W5+7kdWSNqOmydjONlBV6iMFTnTGr
	ZyvbsK3t9VXAJSZmx72Q9qVdwVRG2jav75ByrFoImxDVc4W7VlneEr5I7xZxCwA2BcmGVG
	FrhZoj8IvWuKkT/G2EKLxdLUDHH38ig=
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
Subject: [PATCH v2] smb/client: flush dirty data before punching a hole
Date: Wed, 15 Jul 2026 09:39:01 +0800
Message-ID: <20260715013901.156851-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Punching a hole after a large buffered write may leave the range
reported as data. Reproduce it with:

  xfs_io -f \
    -c "pwrite -b 3m -S 0x61 0 3m" \
    -c "fpunch 1m 1m" \
    -c "seek -h 0" \
    -c "seek -d 1m" \
    /mnt/test/repro

Punching 1 MiB at offset 1 MiB should produce:

  0          1 MiB       2 MiB       3 MiB
  |  DATA    |   HOLE    |   DATA    | EOF

Instead, the entire file is reported as data. SEEK_HOLE(0) returns EOF,
and SEEK_DATA(1M) returns 1M.

This happens because a dirty folio spanning the punched range can be
written back after the punch and refill the hole.

Fix this by flushing and waiting for dirty data in the punched range
before invalidating the page cache and issuing FSCTL_SET_ZERO_DATA.

The xfstests generic/539 pass against Samba/ksmbd with this change.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
Changes in v2:
- Rebased onto the cifs-2.6 for-next, No functional changes.

Link to v1:
https://lore.kernel.org/linux-cifs/20260714071339.137702-1-huiwen.he@linux.dev

 fs/smb/client/smb2ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 05f2ab6d345a..cbd51a08e97e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3519,6 +3519,15 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
+	/*
+	 * Flush dirty data first, otherwise a dirty folio spanning the punched
+	 * range may be written back after the ioctl and refill the hole.
+	 */
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto unlock;
+
 	/*
 	 * We implement the punch hole through ioctl, so we need remove the page
 	 * caches first, otherwise the data may be inconsistent with the server.
-- 
2.43.0

