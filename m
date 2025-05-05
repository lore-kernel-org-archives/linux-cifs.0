Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ABC36BA41;
	Mon,  5 May 2025 22:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485802; cv=none; b=P/8cPmXZ4wwBlav3jR37KwNjHws5I0/bhxHbg/TKKdVq2dEwBYBdHelkeARp2d1fkCkecd6E+Az/lqJK5aE2OR3o+mCrbaJAwSJyLj6RR/kYmWOj3bBfYwofWansbrqU0kQY7500kG+mDyD7HUzVvnREDjfprKak3lT9FcIqzUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485802; c=relaxed/simple;
	bh=NExX+sV9c7ACCiBDLWmSOzI/gw/YZSqNC7438RfxQeI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCZy4PjSOOQtIFY0iQpLvcyKVikeuYPcVBlpEOpt222ZmyXRieGICWcNffqYmWecPDTS+rQfeh1biTr92BbqwcD4/WHnyEGfGjWn93tGbh2qVnFoj4lm8IIH33rHJ4J8FulvL1N5mcLit7pgV/hvRonU/qxjfJI2PzxS2VjwWm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I4cbeU3y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I4cbeU3y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7259AC4CEE4;
	Mon,  5 May 2025 22:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485802;
	bh=NExX+sV9c7ACCiBDLWmSOzI/gw/YZSqNC7438RfxQeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4cbeU3ymR6DE08hFGPSZSfpxPospX9YA+tfcHy8u6xrjhdeUc+AY89CJ9Q9IuctB
	 T6B18El1GAx9M72vmpjrFLeUuYImsER9gOumsyehpSAJuYJWL8uqp0P7V3CbpsWYVL
	 IaDQ86+bGyHtP5YMGSD4u4v8CiZEYyA+V0v1bi6j1JrJHEq/bzrcnFCI7x7s3eQT0a
	 WrMtMuGiDzIUuDQv9Sl+syt7rsV7wd9ehywezYEYw50ApUR1MDM/lzKwb1oLqxruxk
	 hbpEnf2U39/olu1tGJ5VLgJ8mwzzEF9Y72Tmfy+OxvhQSNHKC16zO6PsCRZ9WJ/VPr
	 cyUSvUWjvW+ig==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 003/294] cifs: Add fallback for SMB2 CREATE without FILE_READ_ATTRIBUTES
Date: Mon,  5 May 2025 18:51:43 -0400
Message-Id: <20250505225634.2688578-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505225634.2688578-1-sashal@kernel.org>
References: <20250505225634.2688578-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.89
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
index db9c807115c60..d7f2835e0b1cc 100644
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

