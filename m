Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAF13446B0;
	Sat, 28 Feb 2026 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302048; cv=none; b=nMnjFHJsUM3RMj28mb5Xp2GkHuNg6KNcSfGW+YX+4JQKnwZiRD+Ff/dDxTcNL29TaHOVk8ChRRfQW7OlifBDp7c+OgFnfdgVhxKiJXiyFHxw6GtSVS3D2kIMuGN0DGh82puzOe0VWeK/1G3T/5WXyUQkDEXDTZ08OAkGxAc9OUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302048; c=relaxed/simple;
	bh=kjLW5FoeNvKfnh4AnGeR8DLJWVR9/HO0025+MoELJ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhXQy6cIpTNkDRCZX/iTUNL1nypgWGLu56E30cUxmz4oLjdykiXC9LqYKXCWobHcqRUkO7v40k3ouw+fIa5GxAO3D3ql3s5Qopjju1+Jye0Kpigf2A8xXIAAgAc4ypaK3EeXKwC35m8jnkpRq++kqrNpLeH8aygqmPtM08JHpfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H6n4+aSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H6n4+aSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF40C19423;
	Sat, 28 Feb 2026 18:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302048;
	bh=kjLW5FoeNvKfnh4AnGeR8DLJWVR9/HO0025+MoELJ3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6n4+aSA8ge8dd5QRFPwABUA7Bys78STslTNaM6ejKiYM+srfWRY0K6JL3xgqO/1u
	 o9ZlSXG+fUNq69n06MDDhjeaXh21BETT1fSpBm3SEUVY/8ivrb424s+4zXO6TH5zUJ
	 erQsfck0qLIRTjOjOvCbwXI+yKsWN7VuBl5sBdCsZIv/F2uSMau1Haah2TfuLBJRPH
	 kG9tLMRqopcWGJnsPQXZjQJRBNo5t7yqNmqKcJGcp2JmRK8han9F93Y9glSDC/GPxx
	 OFjewUUiEB6vK1cDkMjYhQGmqkS9rgALDobaEDgsHEYWcAQShoOUWIYAUsbcqxHbkF
	 5s1bYLlZ9Xocg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/283] smb: client: fix potential UAF and double free in smb2_open_file()
Date: Sat, 28 Feb 2026 13:02:44 -0500
Message-ID: <20260228180709.1583486-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index d436057ed77e3..4e7d5c612256d 100644
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

