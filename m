Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26335A935;
	Sun,  5 Oct 2025 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759674043; cv=none; b=BI8YQ3a302+dbKP2Cvoak4uxSJCqSLJosVSywVX/Fu6mdqoPrcvNR6Q3tEshewAOYdYp9z5I/TW7GetjagOViMe6OHjTIXva5ZM7VzIzgAn29cewQgqLijNiCUaDM9gmn2yEptrA5JO6UM2H3BzeFGZoF6uJLiKA97dpS0H+q6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759674043; c=relaxed/simple;
	bh=ONq0PNi6UwOCafQyksxAYfcB2UsExegLXKe1F8+JDa4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IfN01z7Vfn37siojIp994uX+WnwyMPPrYV1lS81yKZen08/D/0ytksD8YO+otWz3nVufri5D/fTCeNXfwhuAJJ0WC0Fk6gbNWZChRWoxjsc96wYk+XUq6DJHLpvyZqdZiuj2Biv9mLQ0iuNfdbb8lQ9KIPeqkcZUwbfmT4GwkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: Fushuai Wang <wangfushuai@baidu.com>
To: <sfrench@samba.org>, <pc@manguebit.org>, <ronniesahlberg@gmail.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <bharathsm@microsoft.com>
CC: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<linux-kernel@vger.kernel.org>, Fushuai Wang <wangfushuai@baidu.com>
Subject: [PATCH v2] cifs: Fix copy_to_iter return value check
Date: Sun, 5 Oct 2025 22:19:25 +0800
Message-ID: <20251005141925.35461-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc13.internal.baidu.com (172.31.4.11) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM

The return value of copy_to_iter() function will never be negative,
it is the number of bytes copied, or zero if nothing was copied.
Update the check to treat !length as an error, and return -1 in
that case.

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 058050f744c0..577ac2e11e77 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4764,8 +4764,8 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		/* read response payload is in buf */
 		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
 		length = copy_to_iter(buf + data_offset, data_len, &rdata->subreq.io_iter);
-		if (length < 0)
-			return length;
+		if (!length)
+			return -1;
 		rdata->got_bytes = data_len;
 	} else {
 		/* read response payload cannot be in both buf and pages */
-- 
2.36.1

