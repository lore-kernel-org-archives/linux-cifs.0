Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A044922B8AC;
	Tue, 22 Apr 2025 02:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745288179; cv=none; b=kEgEsw7+vxZVpZ3D1njpMc2cXxM6CHX/Kk+CB2ioOCJJrh67oEhJdnjI5k8MD9fWswoHBGuJBFd44RKrcgy6fr8D2cogxpSriswt2WfcXIs7gnQVPXnZZkS4/DExSckCpfLzRG4eEGfqRvjZlPaQyQ+ROCJ8yTppnJHxHZu4StI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745288179; c=relaxed/simple;
	bh=FJMgANxdsDgKGAn/rJiLB9bthwkY2F8ru5xRoHJDE7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eXtRFIoqSyvCsJ1L/UO2dy/EyHUb4rfQ5LI9rUuFdSKdQOxAfO27wDxGurMDTQkijPHHAEcIrN8HP/Fa9EA1KJwHKSwJsp8wNBpwe++RDzDpjqU6Se1/3e5FcDzGT+lplyPImW5+lmato1zCDLlhXcoR8yPEMzkybOb8bT6OZbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJ1aHFCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJ1aHFCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BCCC4CEEC;
	Tue, 22 Apr 2025 02:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745288179;
	bh=FJMgANxdsDgKGAn/rJiLB9bthwkY2F8ru5xRoHJDE7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ1aHFCKW7q06BfOoI9IEC+UdXX+VfRJxbRmAxRQ+3xE903vs99ccIc0BOvDi9Bnp
	 UMn3RrBtymV12EN9egnz610Ty6s81yaYTe0h8i/JVttCX+YujnhPa49MbyimR13akn
	 pI/shCD1ECToOBTTTeXAKfYIsoUrXvHSatmcgd4jXhtOkomZNjBZUy9X1kuNsjnS82
	 t7RMHNs5q/MDHp4B+Q1QU9/GIkTDddKWYr6nbreyQOBLL0vkzw+yzi956IM7opeTKm
	 t0mXMva836rTfiro0YMCiE49imtPiuX/b6VPbXAHEhkIVm6sFsOgdB1RItB1YkuzPx
	 h65PXDKhyYWjQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 15/30] ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"
Date: Mon, 21 Apr 2025 22:15:35 -0400
Message-Id: <20250422021550.1940809-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250422021550.1940809-1-sashal@kernel.org>
References: <20250422021550.1940809-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.3
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
index 8d1f30dcba7e8..1f8fa3468173a 100644
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

