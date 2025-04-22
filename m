Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE2A25D539;
	Tue, 22 Apr 2025 02:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288244; cv=none; b=O8eW36rG1IqRwiz+GFwpP7YgeYA0L4Gz+nBzR300kce2DRRsP8p0qyT94VF2HihUT24qs9H/8ywe02UagB0DGGgQbRDTRlZr3zUN1QD8+LqqWfUwex5ySu3IsLoHiZBeaavOKcZuI3f8JkQFs6bpLc9i5WfL7f+ZarxO6W/Kk+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288244; c=relaxed/simple;
	bh=jjLRC7SqUn3P6gxPbFOGJfP6RXj0oceVDJWU6lA0vIw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PMyJVBrteQo7oP0MP68b5PneL6j4DQ43VNZk20lVNvRlgs8BcLanllD/mwUS2arF+PiVHMN8sT6MYmFKfPm7U/eMJt2pC4tGpYUHESmiZqTcLRw0QgYrQ56W423x6+ueRUTx0Z6PvV9duCjTSNq91ExKfvZf+RGbSBVTps6OW3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vw4VO1sL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vw4VO1sL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AABEC4CEE4;
	Tue, 22 Apr 2025 02:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288244;
	bh=jjLRC7SqUn3P6gxPbFOGJfP6RXj0oceVDJWU6lA0vIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vw4VO1sLyjEwHQh68lY7KfKjAcej77hz9Qw5eSiUAAHMZ9GnzOZJMzKlEqke5E6fW
	 nBlhVR2LPF19VliMpo6u05vWnEPe8Qhfq9MPUYhY8gwWQ2FlHj+IOovuCcdcvr3UKd
	 nGlWIKhSsufQ/LmT6xDSSH7RzuD+lp4W1LlCsID5RFZF0Mhcaj1kVpSVfAz+HW7uKB
	 kOBuKvuYAvbL+UJ6g7gLT2QaL6V1eCAAtMOOd9wle0QT9On/X/N1CX76AEagFTg/Sl
	 uzrDNu1qWjK/oOsuSI20x7YtN18iJKYytZRbzVBVWQsnRcujMtl8tTAKoBfDBOWt43
	 l15q6XAJ04VAQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 12/23] ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"
Date: Mon, 21 Apr 2025 22:16:52 -0400
Message-Id: <20250422021703.1941244-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021703.1941244-1-sashal@kernel.org>
References: <20250422021703.1941244-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.24
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1df0d4c616138784e033ad337961b6e1a6bcd999 ]

wait_event_timeout() will set the state of the current
task to TASK_UNINTERRUPTIBLE, before doing the condition check. This
means that ksmbd_durable_scavenger_alive() will try to acquire the mutex
while already in a sleeping state. The scheduler warns us by giving
the following warning:

do not call blocking ops when !TASK_RUNNING; state=2 set at
 [<0000000061515a6f>] prepare_to_wait_event+0x9f/0x6c0
WARNING: CPU: 2 PID: 4147 at kernel/sched/core.c:10099 __might_sleep+0x12f/0x160

mutex lock is not needed in ksmbd_durable_scavenger_alive().

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index a19f4e563c7e5..73577f868a00b 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -713,12 +713,8 @@ static bool tree_conn_fd_check(struct ksmbd_tree_connect *tcon,
 
 static bool ksmbd_durable_scavenger_alive(void)
 {
-	mutex_lock(&durable_scavenger_lock);
-	if (!durable_scavenger_running) {
-		mutex_unlock(&durable_scavenger_lock);
+	if (!durable_scavenger_running)
 		return false;
-	}
-	mutex_unlock(&durable_scavenger_lock);
 
 	if (kthread_should_stop())
 		return false;
@@ -799,9 +795,7 @@ static int ksmbd_durable_scavenger(void *dummy)
 			break;
 	}
 
-	mutex_lock(&durable_scavenger_lock);
 	durable_scavenger_running = false;
-	mutex_unlock(&durable_scavenger_lock);
 
 	module_put(THIS_MODULE);
 
-- 
2.39.5

