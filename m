Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FB472621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046187; cv=none; b=SSXXYAo4GmmK+lJQJteq2FhpVAd/H3lAib/9uqJLshBSciv+OfS19gPoIq3Nz0WYyGSeq3hbsbl5hP7sGr42+dP0mrgYK+FVWoAwYIePUFtGYupDLOkktOMlzVW+wPD2yqG70K7jkXjyFcJw5a9sr0SswlMLtgO7GtwEmeFGWOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046187; c=relaxed/simple;
	bh=Lr8vnxql9Hd0hwIni25KgnfYV93AtxbFnkhoHdUXnPQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LnxUjBgj3EBCyLjsH23nj6fAWWucLmB/t78y8hBwo8YRyYFqb/R5TwKi5jK6cjB7E0BPmpjJv9YDq1fnVFxl2Re00nm69dHnhOuY35XLqjkw3q5ct+lmh37/IZOBBKavVVOD/lY6mkdzlNwg9zVjfGRdgwM/XPUpUFwuOpuitA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBtBSrJh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBtBSrJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734CB1F000E9;
	Sun, 21 Jun 2026 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046186;
	bh=pGISEUkqXLgm+WmvYDpoe6X4fbrDEJdcrcNx5RvXQHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IBtBSrJh3HeoPYHE7NuQJZU0XXCJ5r6a6l1tvt2BWGhufCSPnOPxazr7X2vG6m9ib
	 XMU+l3jPBTMTDCqhUY0yUzCmFRfltrkmOjYvfp4TCGU5qkS0pLCfvbbpf2SwD1FtCr
	 du2l86gxL8E4v7HO+w0GkDNKzJc46vE8UdfMNcsHBkGNNBqAV/CfKcXura8pPh4O4H
	 SQ5ovTgU3twMhCFAHylal3+oRS4IlUO1rJeAG5Es4yBZF4gZDNab7DkkmtJHjbmEQF
	 c9U/+nt0o3HpqyyHzaCHGVsCE637PCgpqtGfAbpQ/CRxLiWk6hMZYdIrJVW+qMhczV
	 xR18bzNmidDGg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 28/29] ksmbd: sleep interruptibly in the durable handle scavenger
Date: Sun, 21 Jun 2026 21:48:43 +0900
Message-Id: <20260621124844.6235-28-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The durable handle scavenger kthread waits up to DURABLE_HANDLE_MAX_TIMEOUT
(300 seconds) between scans using wait_event_timeout(), which sleeps in
TASK_UNINTERRUPTIBLE. When there are no durable handles pending expiry the
task stays in D state far longer than 120 seconds, so the hung task
detector prints a bogus "task ksmbd-durable-s blocked for more than 120
seconds" warning with a backtrace, even though the thread is only idle.

Use wait_event_interruptible_timeout() so the thread sleeps in
TASK_INTERRUPTIBLE, which the hung task detector ignores. This also suits
the already-freezable kthread. Treat a negative return (e.g. -ERESTARTSYS)
like a timeout when recomputing the next wake interval.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 7495166b0262..fde22742d193 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1344,10 +1344,10 @@ static int ksmbd_durable_scavenger(void *dummy)
 		if (try_to_freeze())
 			continue;
 
-		remaining_jiffies = wait_event_timeout(dh_wq,
+		remaining_jiffies = wait_event_interruptible_timeout(dh_wq,
 				   ksmbd_durable_scavenger_alive() == false,
 				   __msecs_to_jiffies(min_timeout));
-		if (remaining_jiffies)
+		if ((long)remaining_jiffies > 0)
 			min_timeout = jiffies_to_msecs(remaining_jiffies);
 		else
 			min_timeout = DURABLE_HANDLE_MAX_TIMEOUT;
-- 
2.25.1

