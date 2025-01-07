Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01B6E573;
	Tue,  7 Jan 2025 00:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736209403; cv=none; b=ctrwBC3tzoY2nWhiNsC2zhPaCGrBYNbfzt+EPf0Lp7j1hJYeheSznV/b1aK9vjVCRBSY/70e2S7eZFRldJqadIQxfzfMPqtfGiFy7Gl+YWUY80ubz9C+nzuqcn8AuiqE4K44vqtcXpyB8hlttqjt1tFKuARWq9Mu80AEeiW8R0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736209403; c=relaxed/simple;
	bh=zRhCz6iyJM2m46O09hFvFE9j7aVWCE7ne+mzKiYZTIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hhNsYMvEgoJfpGfGQTOI7JL2/nP58tnTvWvBA6o1nbcoeg2DTXcd/1SQptcSZOU7L2Q8erjrIGLp4cUtVNh54/jgDcgtR4o0ER/i+W5KR02CooXNHc462cDY/PPebO73ieSUtNTT8Piaz1tou35Qsy6rcFcCUAzesqPuSG7Rvrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPdWhzT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPdWhzT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610FAC4CED2;
	Tue,  7 Jan 2025 00:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736209403;
	bh=zRhCz6iyJM2m46O09hFvFE9j7aVWCE7ne+mzKiYZTIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uPdWhzT2VsYUBI39qhdPepVQeg7CqCzbdcgvCRxWCL/NgUzNIoSclbr1mUxD5BaLa
	 eSyfWfTpOG2atrxEqXqK2csXX8BE/hRqFJA8fFUbZXnERm4z5y0H1fIgSQ7CKE9pgU
	 op8e0uCiZrWhQ5BntEMlkMVfOcswOWXri1DSjCtaYdtsUwvALnfPUXfpyP39g/z+sr
	 ZZ3YLmZiQH6tCdZclTh5cfhRtxGead8uWm11bIGz5rd5HAanBnH6h2Wp4FTzeWcG5T
	 G7q+nfjb0KijxHU//2L37FrPTsrEQCBoV921jou/KNeBKLbph+oxvyfpFfywY4XEYZ
	 wIdBak97IrJZw==
Received: by pali.im (Postfix)
	id DA5A98AF; Tue,  7 Jan 2025 01:23:13 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: Improve SMB1 stat() to work also for paths in DELETE_PENDING state
Date: Tue,  7 Jan 2025 01:23:11 +0100
Message-Id: <20250107002311.28954-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-7-pali@kernel.org>
References: <20241231223642.15722-7-pali@kernel.org>
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

Signed-off-by: Pali Rohár <pali@kernel.org>
---
Changes in v2:
* Extend comment
* Update on top of the v2 change:
  cifs: Fix and improve cifs_query_path_info() and cifs_query_file_info()
---
 fs/smb/client/smb1ops.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index fef9d08d7bda..9805dd6fb1d0 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -582,9 +582,10 @@ static int cifs_query_path_info(const unsigned int xid,
 
 	/*
 	 * Then fallback to CIFSFindFirst() which works also with non-NT servers
-	 * but does not does not provide NumberOfLinks.
+	 * but does not does not provide NumberOfLinks. Also it works for files
+	 * in DELETE_PENDING state (CIFSSMBQPathInfo() returns -EBUSY for them).
 	 */
-	if ((rc == -EOPNOTSUPP || rc == -EINVAL) &&
+	if ((rc == -EOPNOTSUPP || rc == -EINVAL || rc == -EBUSY) &&
 	    !non_unicode_wildcard) {
 		if (!(tcon->ses->capabilities & tcon->ses->server->vals->cap_nt_find))
 			search_info.info_level = SMB_FIND_FILE_INFO_STANDARD;
-- 
2.20.1

