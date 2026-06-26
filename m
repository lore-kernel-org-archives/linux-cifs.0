Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F25D384CE4;
	Fri, 26 Jun 2026 04:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782446986; cv=none; b=bhiuwaMtOoiyRZ8uAd5gEOe82lkQAySNw8KMH+GA1FPSULHXGCQdh66t1xTcVei99KZSWU8R+s2k9IYMZ/tNm/He/CkhvfZnRXhxZh1yHeDLRT10SEHbILOx3HJuedmeAEs0LyovNHHfzQO2dTy9N4f4qjmEiduYbRCIKwG5eA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782446986; c=relaxed/simple;
	bh=HUHt5Iesxh/HFhTTn6FbEYV3bkOJ6T1dwkhzi+80qfo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IgjBo92bxephcWSYfeQoIuebQjPi58izVmPZCBs7+PCBv0QyeXiM/kEIVnUHc9OuSoWejNR98MDbUdEk2Ois4NityMLW+KlemO8VWIq3hQ8OYVsnfcPmRoLQG2LS26kmYn7182zfzWi/y5zSod/MOcwTQAwZ9uwC/vr9kKMQLLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=eO09I3mE; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="eO09I3mE"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 43d830c30;
	Fri, 26 Jun 2026 12:04:29 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	runyu.xiao@seu.edu.cn,
	jianhao.xu@seu.edu.cn
Subject: [PATCH] ksmbd: annotate oplock list traversals under m_lock
Date: Fri, 26 Jun 2026 12:04:22 +0800
Message-Id: <20260626040422.1631299-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f0219bc7c03a1kunm53b858b687add
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQk9DVkwdQxlPTk4aGE5PS1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=eO09I3mEy5jx/B2d6T4RA6a2YX2Kh/BEGVvLqDjjhB/vBiendalV2jDmoWgYsiZ5B6aHYzFgP98Fk9oukVRgWNGbzWa5BWYsH7lrFDe5qMPgPNx4FH2GlPiPgKn2Ho/URTwMlFgYJn/68VhH3JK1zXqSBx8ERqkboz13Ninb0tU=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=fbK+6HOOWnvbu6Jhjhe2/Ulut57sxvDmrIXMTyCLZjY=;
	h=date:mime-version:subject:message-id:from;

session_fd_check() and ksmbd_reopen_durable_fd() walk ci->m_op_list with
list_for_each_entry_rcu() while holding ci->m_lock for write. That is
the local inode/oplock serializer, but the RCU-list iterator does not
currently tell lockdep about it.

Pass lockdep_is_held(&ci->m_lock) to these iterators so
CONFIG_PROVE_RCU_LIST can see the rwsem protection already in place.

This was found by our static analysis tool and then manually reviewed
against the current tree. The dynamic triage evidence is a
target-matched CONFIG_PROVE_RCU_LIST warning; the change is limited
to documenting the existing protection contract.

This is a lockdep annotation cleanup. It does not change oplock list
lifetime or durable-handle behavior.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 fs/smb/server/vfs_cache.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 6ef116585af6..a3c0bb2a5279 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -909,7 +909,8 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
 	conn = fp->conn;
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
-	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
+	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
+				lockdep_is_held(&ci->m_lock)) {
 		if (op->conn != conn)
 			continue;
 		if (op->conn && atomic_dec_and_test(&op->conn->refcnt))
@@ -1012,7 +1013,8 @@ int ksmbd_reopen_durable_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
 
 	ci = fp->f_ci;
 	down_write(&ci->m_lock);
-	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry) {
+	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
+				lockdep_is_held(&ci->m_lock)) {
 		if (op->conn)
 			continue;
 		op->conn = fp->conn;
-- 
2.34.1

