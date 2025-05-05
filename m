Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4D6396ED1;
	Mon,  5 May 2025 23:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486393; cv=none; b=tjahWzzAArRlkYK82it+zmuuaGlq5FdGN/D7owcGqWFp+/DTnn6QZ6Rxdj4LOcc+JGNEjY64+RKeFE/pHkpo45qEYk5W6lT19hoBCFASqH3ntjH/nqOVILUY10dID2geSA4GrB8VwzgnJREtPfZhwTkfzCvo90qCCvM1SANSh7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486393; c=relaxed/simple;
	bh=3hwOv7gbaxyRN3tOB36daa+Al+L5PlzqQYd3rpcfSx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eu/29mGyaHXGY+CIh9tbn4jKwGYm81OW9QjelqHejzK0Sczkf9HGtZBrXsrWn4/5kKAVv+T006pXZed+vXe+JCMfRiHJOLvM/A3N9Yh7ii7Y/uDoyLGRxuoNQRHMBEUlCJd0EyJRLsirsQH5iSLgNVLcllOfHf8bxVzgnY+eVeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HsOG7yLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HsOG7yLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1689DC4CEF1;
	Mon,  5 May 2025 23:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486392;
	bh=3hwOv7gbaxyRN3tOB36daa+Al+L5PlzqQYd3rpcfSx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsOG7yLMrt2CuCIV77LlcJhFQ/1DuBZJB2AfXmI1XaMe6ZEKz8AdJEbe+WZKmTeDr
	 M/qqJsQ5Dp6cpjEQ7GgB4QRuM2eMKYlnPxdSiY5fRa2v/eWfmSdtPVdri72Uy/o8j5
	 kmxwK+gFtvk7cfcK/NDSE6lTX2nhzEDyIW3uGCXpA7AoVr+m7hfamfZzmigs7tdHQd
	 1JXV2nhMaEINFkzynuFy67uU1Sy1S3/eEpk4/wMzExwtn/HD0YbXjbwbgulipHwj2c
	 9WURxPTqsGm4eZKwjFnnHcCe2J5ZA5ar0v+dpAajAJfvqECUWeka9/cpS1iiE0oxDP
	 n8k7AKADEae9Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.1 003/212] cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
Date: Mon,  5 May 2025 19:02:55 -0400
Message-Id: <20250505230624.2692522-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit e255612b5ed9f179abe8196df7c2ba09dd227900 ]

Some operations, like WRITE, does not require FILE_READ_ATTRIBUTES access.

So when FILE_READ_ATTRIBUTES is not explicitly requested for
smb2_open_file() then first try to do SMB2 CREATE with FILE_READ_ATTRIBUTES
access (like it was before) and then fallback to SMB2 CREATE without
FILE_READ_ATTRIBUTES access (less common case).

This change allows to complete WRITE operation to a file when it does not
grant FILE_READ_ATTRIBUTES permission and its parent directory does not
grant READ_DATA permission (parent directory READ_DATA is implicit grant of
child FILE_READ_ATTRIBUTES permission).

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index a7475bc05cac0..afdc78e92ee9b 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -108,16 +108,25 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	int err_buftype = CIFS_NO_BUFFER;
 	struct cifs_fid *fid = oparms->fid;
 	struct network_resiliency_req nr_ioctl_req;
+	bool retry_without_read_attributes = false;
 
 	smb2_path = cifs_convert_path_to_utf16(oparms->path, oparms->cifs_sb);
 	if (smb2_path == NULL)
 		return -ENOMEM;
 
-	oparms->desired_access |= FILE_READ_ATTRIBUTES;
+	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES)) {
+		oparms->desired_access |= FILE_READ_ATTRIBUTES;
+		retry_without_read_attributes = true;
+	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 		       &err_buftype);
+	if (rc == -EACCES && retry_without_read_attributes) {
+		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
+			       &err_buftype);
+	}
 	if (rc && data) {
 		struct smb2_hdr *hdr = err_iov.iov_base;
 
-- 
2.39.5

