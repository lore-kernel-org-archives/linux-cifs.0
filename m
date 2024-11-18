Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E751AA1E7
	for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 15:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731944141; cv=fail; b=MrrDOQ0V6mQVcKs6GVmz0SG4vnyWam/K73CV5bQPb4A9RHARlyeZsET7pmR7hp1CzfX7yNOETErx51ZS9XpmP/6bv8FovX+OZSdrVeYa25l7UQT0ZZIc0Nb1bNWFH2R5xKCgZXFKD6PG1n2jxLiB/c8Qqo5dCtArwt5MItRrtts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731944141; c=relaxed/simple;
	bh=KioX2BUz5l1UgYKt068YvXnO6NEjPm5yK/pokJh/Bfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocpYWPMNkJEJgajl+eT3lGJ+9T+Yl1MDIjQHWgBIM4ldty8Lw4MOc0Q19IKCa5toi13YGOOSROY2WtivXwdOB5nK1HyP2mJEURGnxS2+IOmXlEZcZ5UQySB1Jey1Cq63CpyYJeSoA6VvXWp/tzj9tlvSmNy6DOANessMypEAn5E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=V5iHtbFX; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="V5iHtbFX"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731944129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pmAI3VN/eB0b4w2t7LMBHbJ0j2zGdpXDdSoTNmjs8CU=;
	b=V5iHtbFXLLxsjr+EqYBLseBCns2NLkbEqRdz2IlmtdUvI12/P7veYF9+iafQCp3pyEEbKA
	Mv5iIF0K0RwrpnFZSqN7FURs9TuAAzVffN7gFADFXP3GpwQ5+hjmQVQXj5gNyX0Vqj/ysj
	s2p26oiEtn2wiTBUeFy9cTGsITK00XooYYKor29wARYgodtPR2d0OdvstUlEM6XIIkfxDr
	NQUSXnmbOhlW0EqmwsJzppvR0u6rdX9TVNDMu/7n0af4zwB9P0+Qel46GwmeJXRTG8glEB
	VoMbOlUy3hGFXCbVMgFGiOmyTdjGgCxTYy+67/RiRZH4LY7lrtX+kSB0zZ0qZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731944129; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pmAI3VN/eB0b4w2t7LMBHbJ0j2zGdpXDdSoTNmjs8CU=;
	b=Ctn8ncO+KatMQzwrAEVZkTOiwHpbY35EtTA8lVCbxCacuwVb46X+lc78UzNYFl7jKu65br
	js+P6VO/QFE+897ESvTzlCgfJhu+1U4eFQYe1Sm/v+DQeejX+Ytcm8YlDR5Vb4LsS68kiu
	+fiXiqlUApOcygvdA+PeFTf057KLXmhZpmQiXb8SWmt5C00c3uol9JZujq54FzP27ai52I
	AJQb0h9/ukj9d+D8fFEzTDYDyHAWhgCFvDO9KN9WV1OIu/mD2peEbXV4SUwpYm/eem1nkU
	dTd7A/0GiUS4Huoe+6HCoLaJ0Dfuv27EgQLhtD43w35teKpgJpKazK+JhcqAQA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731944129; a=rsa-sha256;
	cv=none;
	b=K0HSsNArQHE3jMMBD4u5TRhRqG7dZF9o7LGF0WKIM0Fp9xj1+1MTFT4b8bvHQUjrsdKG7t
	YULfL1HY5T97ALBLXN0u7A8/A91tIb3KT/TDC8ocnIu/UNMvtuwCse84ZpqpH9iBEPdm7L
	5p05sDeybBjVZFEIJdNnZcKlhSQ9Ic8VlbejJL6XR6K2ZCDuSgT+4I/cunv0VJCZ52/Li1
	DEtpFOx+W0YLXrGJ3UvNDZt9WSU/c1ZQkorjoZxDZyBaYnwkCgQnQO1BulDQYQfDkN3LH9
	JAcIpYDBZ8TiKUlS0caq98qcngO9RDmV79BXfYDN/dQ5FhWUapgQzWuR82gnPQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] smb: client: handle max length for SMB symlinks
Date: Mon, 18 Nov 2024 12:35:16 -0300
Message-ID: <20241118153516.48676-3-pc@manguebit.com>
In-Reply-To: <20241118153516.48676-1-pc@manguebit.com>
References: <20241118153516.48676-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can't use PATH_MAX for SMB symlinks because

  (1) Windows Server will fail FSCTL_SET_REPARSE_POINT with
      STATUS_IO_REPARSE_DATA_INVALID when input buffer is larger than
      16K, as specified in MS-FSA 2.1.5.10.37.

  (2) The client won't be able to parse large SMB responses that
      includes SMB symlink path within SMB2_CREATE or SMB2_IOCTL
      responses.

Fix this by defining a maximum length value (4060) for SMB symlinks
that both client and server can handle.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/reparse.c | 5 ++++-
 fs/smb/client/reparse.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 74abbdf5026c..90da1e2b6217 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -35,6 +35,9 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	u16 len, plen;
 	int rc = 0;
 
+	if (strlen(symname) > REPARSE_SYM_PATH_MAX)
+		return -ENAMETOOLONG;
+
 	sym = kstrdup(symname, GFP_KERNEL);
 	if (!sym)
 		return -ENOMEM;
@@ -64,7 +67,7 @@ int smb2_create_reparse_symlink(const unsigned int xid, struct inode *inode,
 	if (rc < 0)
 		goto out;
 
-	plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
+	plen = 2 * UniStrnlen((wchar_t *)path, REPARSE_SYM_PATH_MAX);
 	len = sizeof(*buf) + plen * 2;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf) {
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 158e7b7aae64..2a9f4f9f79de 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -12,6 +12,8 @@
 #include "fs_context.h"
 #include "cifsglob.h"
 
+#define REPARSE_SYM_PATH_MAX 4060
+
 /*
  * Used only by cifs.ko to ignore reparse points from files when client or
  * server doesn't support FSCTL_GET_REPARSE_POINT.
-- 
2.47.0

