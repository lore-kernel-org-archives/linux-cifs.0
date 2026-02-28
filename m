Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCE3377004;
	Sat, 28 Feb 2026 18:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301631; cv=none; b=JturFjju2IEkiy3tnUOWQvqNl3IQifuxwqV5YkCtm6c9734GEOQigct9l0W4SNQC6CzGoBkcD2GfOvShC9jY+JTCoUPnV2rNZztFVL4T/tiN+up/vBYMJBoU8WZhfaaSLQS1vhLtko+DuAO5TPj7e0t+QtJSnVxL+K5I0S693Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301631; c=relaxed/simple;
	bh=Z/H2YQ21e6j0Z8rR2xy8AUo036S7N3nslq+HKNSSQrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1KlK0u42r+ycMxs5LM2CSHDfHK+N50va+6fdeEVrPUOqqvV6p8R/DqZBH9o5TRVrn1r796LaqYs6yKpjphmmbcTsrpgeAJMhJbwDRv1LoREyPC04PucW3xl1wwuspUDXG7VwuMt/DXJvGCC1945NcgKV9tcnj8kahUcmVIQuyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwD6OzM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwD6OzM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FA2C19423;
	Sat, 28 Feb 2026 18:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301631;
	bh=Z/H2YQ21e6j0Z8rR2xy8AUo036S7N3nslq+HKNSSQrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwD6OzM3BIaNFZkVKTd/RheJ979PUQ0WE/hRk2cUhHyoua7ihgOFeMasAbU2BK43P
	 DMwj2CfIr39AmBjd5PMhdfaWXf7hPGT5qqOzb9uJOoGB0UbnWlr0oF5FZqOAW/hOHk
	 uWASwd1U4OuNJGmMK5r4x1aRY5ScoBoZO9Tj+oyZqUR4ug0jmhwQH/2K4D2l1udWoI
	 7fu90bmqW7LIE07etv2ZON8MV6k34COSU9bQx0xubIn9nPqUhs71nmwzmSeqb+yIgV
	 7Uhw9G7SCdr46p2zzgCMLkeO2m1SxxlPwVLT3O52oB+2Da+o0qQzrFsN0IDalm/ZyB
	 WtpgIndwdvbHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/385] smb: client: fix potential UAF and double free in smb2_open_file()
Date: Sat, 28 Feb 2026 12:54:05 -0500
Message-ID: <20260228180011.1568201-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit ebbbc4bfad4cb355d17c671223d0814ee3ef4eda ]

Zero out @err_iov and @err_buftype before retrying SMB2_open() to
prevent an UAF bug if @data != NULL, otherwise a double free.

Fixes: e3a43633023e ("smb/client: fix memory leak in smb2_open_file()")
Reported-by: David Howells <dhowells@redhat.com>
Closes: https://lore.kernel.org/r/2892312.1770306653@warthog.procyon.org.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 414242a33d61a..b7ab18d4bedca 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -123,6 +123,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
+		memset(&err_iov, 0, sizeof(err_iov));
+		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 			       &err_buftype);
-- 
2.51.0

