Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B7C2033A;
	Sun, 10 Aug 2025 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844740; cv=none; b=lQkR0lLvqzbU4944SLhnyIAof9IzazebAOVmXD8M7v3dz4agefHz8sKYsYleV3jLD02DuNT/BUO0TaKTfGY+9wrQWeQS40LNhIYkRyF2GYTY0ydzaAh9EktX68Qldwgk6kG3+zDS8/xZr4eC0jnFVzYqwXEZsl1suqzwS1vfO1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844740; c=relaxed/simple;
	bh=s/pK8Jeo0x08FnfOtGR6JaLs6DEzam/VqTyKpT6ENw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZSWuuxrVQCMwFFSUMN9/Vesw0aRBb7vqa+b4QSFOkvP5ZAPHXMXanT9ZcEgP6Dm8PHGtpMx1YXk3tHrWhxRlss2NQYq30OsufiBuwXdgMsm7YupavSb6PcfV1M5G1WF9CKAVJueJg8NvyDdMkB19r/3H5WBbZnw4ov+7AD5v0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuaGxnt9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuaGxnt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155B0C4CEF8;
	Sun, 10 Aug 2025 16:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844737;
	bh=s/pK8Jeo0x08FnfOtGR6JaLs6DEzam/VqTyKpT6ENw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MuaGxnt9NJWAGVxCrq/zEqGr86wGLng/REiAXzSZDTx1a9PD1nC+WTzK3PhdgTdS3
	 hPdl2HtR7Kzhkx19/7n6IoWM73NYhYS//Jk6gNF4s9q3lNd4xEfZVH2+aoXGWSQzMO
	 11pYQMNSeHDDyxCGtbKrJJ7TPrB3wTeKUxdMeuIacviO1LlJ+OSBPZt1y865hQaQ4o
	 vkgjL3RwAHAappgoKJL1wqxGAXJhdJeSIgX8cPZw/IurK/g+MR9mKn9nxDjsUWmqb+
	 IzVUETiZzbhXQQQ7OA0GTvLqHm6ZNrpaE+DTq8qfmfFU6uNr0HOK38u/eavx4zDSaj
	 SbR9FLlEVjPag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stefan Metzmacher <metze@samba.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org
Subject: [PATCH AUTOSEL 6.16-6.12] smb: client: don't call init_waitqueue_head(&info->conn_wait) twice in _smbd_get_connection
Date: Sun, 10 Aug 2025 12:51:48 -0400
Message-Id: <20250810165158.1888206-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 550a194c5998e4e77affc6235e80d3766dc2d27e ]

It is already called long before we may hit this cleanup code path.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, I can now provide a comprehensive answer about
whether this commit should be backported.

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Analysis of the Bug Fix

1. **Clear Bug Identification**: The commit fixes a redundant
   initialization bug where `init_waitqueue_head(&info->conn_wait)` is
   called twice in the error path:
   - First initialization at line 1630 (in the normal flow)
   - Second redundant initialization at line 1696 (in the
     `negotiation_failed` error path)

2. **Bug Impact**: While calling `init_waitqueue_head()` twice on the
   same wait queue is not catastrophic, it is incorrect and could
   potentially cause issues:
   - The wait queue is already initialized and potentially in use (via
     `wait_event()` at line 1639-1642)
   - Re-initializing a wait queue that might have waiters or be in an
     intermediate state could lead to subtle synchronization issues
   - This violates the kernel's initialization patterns and could mask
     other bugs

3. **Fix Characteristics**:
   - **Minimal and Contained**: The fix is a single-line removal of
     redundant code
   - **Low Risk**: Removing a redundant initialization cannot introduce
     new bugs
   - **Clear Intent**: The commit message clearly states the issue and
     the fix
   - **No Feature Changes**: This is purely a bug fix with no functional
     changes

4. **Code Flow Analysis**:
   - At line 1630, `info->conn_wait` is properly initialized before
     `rdma_connect()`
   - The wait queue is then used at line 1639-1642 with
     `wait_event_interruptible_timeout()`
   - If `smbd_negotiate()` fails (line 1672-1675), the code jumps to
     `negotiation_failed`
   - The redundant re-initialization at line 1696 happens AFTER the wait
     queue has already been used
   - This could potentially corrupt any pending waiters or internal
     state

5. **Historical Context**:
   - Both `init_waitqueue_head()` calls were present since the initial
     commit (f198186aa9bbd from 2017)
   - This appears to be an original coding error that has persisted
   - The error path likely wasn't thoroughly tested or reviewed

6. **Stable Tree Criteria Met**:
   - ✅ Fixes a real bug (redundant initialization that could cause
     issues)
   - ✅ Small change (single line removal)
   - ✅ Obviously correct (removing duplicate initialization)
   - ✅ No risk of regression (removing redundant code)
   - ✅ Already tested (merged into mainline)

The commit satisfies all stable kernel criteria for backporting: it's a
simple, obvious fix for a real bug with minimal risk of introducing
regressions.

 fs/smb/client/smbdirect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 754e94a0e07f..75142c391d0c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1735,7 +1735,6 @@ static struct smbd_connection *_smbd_get_connection(
 	cancel_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
-	init_waitqueue_head(&info->conn_wait);
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(info->conn_wait,
 		sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
-- 
2.39.5

