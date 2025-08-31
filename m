Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61F226738B;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=XI2sGWDvwsdrH0vR1z9hwDJHyxHrzRi5JF8PnevGQ7n01Z7bkKPTy2Zpt1FGYwwbhnZ+IvG4ZAUNmqyqehl16rJ6mKD2dmpOsD3ZJbn9vQxOmnaD/aSCrD3mOhyKNjlBqowRq26kcP2CRWrBiBPLtyh86U2roBxOTUoFIw6/70s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=BXUcj05D0nzaBygjxeeEalRlR274ycVXMEtvJz86+vc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FGShzMQk6bNaTHU9IHNiItIHRr+FjYrWI8UEv7Sq+LRWYG71BWKWudSHpIktqQa6DMeKMJgWBycM+4cVDzDIf7E/OLjWpQByWzll3kd+LqMcQt6cqQQxwIBWO+wDByuSMRoMrdhk4cA9/aG/s1ROzwkj5bDKDzeelEb/fsvRWCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYsmgHwx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYsmgHwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CF9C4CEFB;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=BXUcj05D0nzaBygjxeeEalRlR274ycVXMEtvJz86+vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYsmgHwxRnzDZXYkUeNdrxqbkbWhEHx1l+62UWnV44irYXz970jrYPCFjF48Veynz
	 HY8FMM9LQfurcI4zGnP7xiVoCGi2pNhhW/i4f0C5O7RorFr84JGl7JLXTYVQomFawL
	 lLpQ9MmV2UMKCzVs9L2uxWRabWoLOfGrxCzTWaCF+5Ouwmxq78JqmDotwP3F4qyMyF
	 V6Jk/kRKYp1CM8Kp599sRgT5VT9ad0v1ef9EDrScHWEtOQ5DCECLNpcgUvt4OlzQBv
	 UJJkflc8chXFZmJMvOAHKkEFE2eY2zhoZ6HL1iUGzST/Axri+d6ITcM/EYSN9uKEpU
	 iG+wFH2GRoYKA==
Received: by pali.im (Postfix)
	id 629CE12A7; Sun, 31 Aug 2025 14:36:32 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/35] cifs: Improve SMB1 stat() to work also for paths in DELETE_PENDING state
Date: Sun, 31 Aug 2025 14:35:36 +0200
Message-Id: <20250831123602.14037-10-pali@kernel.org>
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

Windows NT SMB server may return -EBUSY (STATUS_DELETE_PENDING) from
CIFSSMBQPathInfo() function for files which are in DELETE_PENDING state.
When this happens, it is still possible to use CIFSFindFirst() fallback.
So allow to use CIFSFindFirst() fallback also for -EBUSY error.

This change fixes stat() to work also against Windows Server 2022 for files
in DELETE_PENDING state.

Depends on "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY".

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 55ab8a5b150c..176bc2a211bf 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -583,10 +583,11 @@ static int cifs_query_path_info(const unsigned int xid,
 
 	/*
 	 * Then fallback to CIFSFindFirst() which works also with non-NT servers
-	 * but does not does not provide NumberOfLinks.
+	 * but does not does not provide NumberOfLinks. Also it works for files
+	 * in DELETE_PENDING state (CIFSSMBQPathInfo() returns -EBUSY for them).
 	 * Can be used with backup intent flag to overcome -EACCES error.
 	 */
-	if ((rc == -EOPNOTSUPP || rc == -EINVAL ||
+	if ((rc == -EOPNOTSUPP || rc == -EINVAL || rc == -EBUSY ||
 	     (backup_cred(cifs_sb) && rc == -EACCES)) &&
 	    !non_unicode_wildcard) {
 		if (!(tcon->ses->capabilities & tcon->ses->server->vals->cap_nt_find))
-- 
2.20.1

