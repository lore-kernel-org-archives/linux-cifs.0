Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC2B35E92B
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 02:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377589; cv=none; b=Ol7o6cf5uhawjEGr5w3NcWAsDp3RwZhT5A9UXqIEPCjSzZ5PK2Nxbp2W7gThRYaKaPdZepQvUCfK9c9JXijGMG+YsCAS9BBDroB+GzX9hpxjO3bTc9t45nOl7sa9ePoyR5gZ18hL0l9jAs3OGUcfxdPAP5KvLmBUGxMiLSkcErI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377589; c=relaxed/simple;
	bh=0B9SV2I/JPTZyxKHpZsmHoN5aU8hk3Su8ncN4fExLlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBIUDqn2A12sqR8RvkWjqBaqhcz5mvVd6fX/gzJq6y1rp/nOU1xWOakEcZsaIm26FkbJgRAOIqJHFfrX7VBiCHqHRsBvTGEbJN+ZWGKmay4qzzmYy6szFkjTUciBAw6yIf2glf1HuvLIjANFF9ltFZk+TBOM8a9pQIaXs/h1KRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=SxZ25Kwv; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="SxZ25Kwv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785377582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q/rl2lV6giy63DdfkQLB0WbMcA2ZbZPUIhAy8rUDxlY=;
	b=SxZ25Kwv7RmMpIaXWZo2RTQZ9FxtXoypX89VRoqNXOjF/maI6MmnwrGMXtoI1qL8FbPod1
	kzyVqXdxJ7ORf1JdupMRvilPIDUmMY8rzNhupR2UEf8ourzVKRV3JwQ2Z+/hao7RwYeoA4
	fy7ruDhvFhlAtRwrZdspUvRp4TsSUL0mF45f2FyuDtRhFggMgAe61Jt9kG8nf4R0Bxx9xQ
	dTTyvd+Ale9zqs+RdwLBYiq61aABz4bxHUHlbKAcmHILvay23KGK+rC0bKidUWkuqtXkc4
	ZgklKZbq9R6vwj4hCaYrIMcqzs1QnfDkWnXZoxMLqsHUC3IuKKJjrmkMEBg2aA==
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
	hch@infradead.org,
	zlang@kernel.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 1/2] generic/002: add test to hardlink group
Date: Thu, 30 Jul 2026 02:12:37 +0000
Message-ID: <20260730021238.51634-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
References: <20260730021238.51634-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The test creates and removes hard links, so add it to the hardlink
group.

Suggested-by: Zorro Lang <zlang@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 tests/generic/002 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/002 b/tests/generic/002
index 6df57a7a..a0773e22 100755
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -7,7 +7,7 @@
 # simple inode link count test for a regular file
 #
 . ./common/preamble
-_begin_fstest metadata udf auto quick
+_begin_fstest metadata udf auto quick hardlink
 
 # Import common functions.
 . ./common/filter
-- 
2.43.0

