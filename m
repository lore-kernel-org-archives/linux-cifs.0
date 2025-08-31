Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB93261B9C;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=NSfgjM5xD8LhSorzkUYmgT0VVi1ImIQOinziq8a2zD0u0Jdc3IeWnVznINC32G9FnJTCZhi936lpPVkkvfvNsJ15MCJYyT2a35tDWu5R9zKVCH+i/LSU/XU/jMWuJobC/I1Ys3MzcZoqRptqCVUtcmM+8IbTu56QELz8DZdiLQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=kC5DjeLp2/DF2gH6YKCu9BPP80cHs8gGhN3jPgrVOhM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X6GU6LQnPcicF4TF84jU9fY0LqDAQRng6vt80G/5STZDZ6xk/ID+8kM6FspBB0MFiG4MKxr9vcC1GY42Kgu7xHx2SpxqQ7DDuh32AdNXAcfJSx6C/gD6scEqsueR1Wlf3QVhILMCTGqSmoI1L7rbF6RMflOwa5b0DNF5hmHDhKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rG7HX2nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rG7HX2nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D567C4CEF9;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=kC5DjeLp2/DF2gH6YKCu9BPP80cHs8gGhN3jPgrVOhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG7HX2nmFUOHpmI5lSiNVGNEM1x/5RK7jIoI6qM+n2b0Mgtwth/ZwNs5bociYxySy
	 uFa3t1PWZpomgBDqMfRAIQlJUUTikqn+q2MtPsEoOAIH4ywK/nsRRy4rxYuUNseiF1
	 zwTPGdONtQi+HxcJh1WztNAMX2leC2B978sNbR2Jl8HN+eGVSHam0duRocfJHDDKTG
	 O6z1wiQ8xjURbMrJ+CNzzqyGeufFBJSojcv/4bAbPRI8+umyZeMcw0Gb8APvCKEHIX
	 gv6BtsacOlN63ARTXKrD0uCUHdrPm6EiKALBuP8WxLkyY7PQnS6gYwmc4rv0Gpznwz
	 HstsX5K38yDuQ==
Received: by pali.im (Postfix)
	id 291D91308; Sun, 31 Aug 2025 14:36:33 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 12/35] cifs: Fix DELETE comments in cifs_rename_pending_delete()
Date: Sun, 31 Aug 2025 14:35:39 +0200
Message-Id: <20250831123602.14037-13-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

DELETE_ON_CLOSE is a flag which is being set during the opening a file and
DELETE_PENDING flag is being set by SetFileDisposition() on the already
opened file. Those two flags are different and have different meaning.

There in the function cifs_rename_pending_delete() is being set
DELETE_PENDING flag on the already opened file.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index a37dfd50f33d..88d1d657cfb0 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1686,7 +1686,7 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 /*
- * Open the given file (if it isn't already), set the DELETE_ON_CLOSE bit
+ * Open the given file (if it isn't already), set the DELETE_PENDING bit
  * and rename it to a random name that hopefully won't conflict with
  * anything else.
  */
@@ -1805,7 +1805,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		goto undo_setattr;
 	}
 
-	/* try to set DELETE_ON_CLOSE */
+	/* try to set DELETE_PENDING */
 	if (!test_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags)) {
 		rc = CIFSSMBSetFileDisposition(xid, tcon, true, fid.netfid,
 					       current->tgid);
-- 
2.20.1

