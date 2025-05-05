Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CFD34A1AF;
	Mon,  5 May 2025 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484772; cv=none; b=UVP9KkZI79HR/dy3qVqj7B+ShzV0Bq/qW2R3imdh5D0CPD6qSFkk24XRVPVhBxwctmhNMG7zu1vBLMwdHTyHjjHRxWTN7DD+ADbNbgOl71Oy07VQMhSM3ZjWLBHvTTnNPAMkGCuJ0EcdFeh9mIsPqJcqfazrecGVQurNp+VSE9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484772; c=relaxed/simple;
	bh=yWMCmv7uQ+rdyt+vw6a/XoR0X8LwQy74V4WaGWSqQus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqDS0chwm1uHBCzsi+C7/uXvD12jo60RoVs7oKSbvFtDLshWnO1e4NehtDhldCtg5YzFIOJGrbsvYxM70unkerHBxwyR2fgTW1sRBVklMnjBQe46ghmglZb0kdZyBndCzWDKwQsPZD4KJP/ux4GDeB8EHO+81BS7alfHVEijErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekk5Ld+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekk5Ld+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AADFC4CEE4;
	Mon,  5 May 2025 22:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484772;
	bh=yWMCmv7uQ+rdyt+vw6a/XoR0X8LwQy74V4WaGWSqQus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekk5Ld+sN1FdsdnVVUidnXkCpz8nrF/hjp1Qm/Dv2iL/Mvk+8e/q6znzb0VzcHO9u
	 4c9FLchcRaTihwI2Wc2nPvNoPgoW2SQjkM55JAdx/TYAn41s5/8wzI8gH4MmK7lAuL
	 5EYvukoKQEpDRSIXu3nZsuFTglQPnpyojAcRmGotu18lYTsmXNUPZxxfB1jKgAFqhz
	 wmZSBnJYjT9Rp6HY7cXVvMHdWBiQDFg+EOYFwhcstWAV+weKDu9O0AiDnYiouf2TUm
	 R65H1ZWXS42DtTVIqVMnBfCAN3Sh0rZGbocRf+ojj7cHhVNh+M4aOwZmpZ2ZucmD6D
	 wOxG/qL+mZDDg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 004/486] cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
Date: Mon,  5 May 2025 18:31:20 -0400
Message-Id: <20250505223922.2682012-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index e836bc2193ddd..b313c128ffbab 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -107,16 +107,25 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
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

