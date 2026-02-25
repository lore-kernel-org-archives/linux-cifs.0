Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACFB19FA93;
	Wed, 25 Feb 2026 01:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983739; cv=none; b=oyi6WAlaGHoDUdirznc8Zo951nHIjluQfhXh6cN8BYOxup1bBpAkcCVucYglqS4p56td/0+pLWlNZpTKoROvs5fDvLRkq2CmjDdxGF1Hn30/oDqK1fVdL5dZzJ2uUDr5Xg2cGIGwU4bEHXqB8ufE4DpgpVOvikATJJ9lfk0FDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983739; c=relaxed/simple;
	bh=mRDWBMAnhqCSP1o0aGyE9V6vYclyjrcECZ/0SvrOfmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUy65egoKTReOgKtntH+72PG0ruW9XNA7yopIanql+kJm4a+IBEKDduKGH/yfcd4GR2HlcQQ+Xb5e5eFm+lbyjv7nmYrE3Wge32OvXTXCR9KJrv3a4LxR4omlmC7Ehq8tqbJlwN7eLikWbekxdaiBpNk7bqWxs04+mFmg8rmKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLnj0O+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLnj0O+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F2AC116D0;
	Wed, 25 Feb 2026 01:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983739;
	bh=mRDWBMAnhqCSP1o0aGyE9V6vYclyjrcECZ/0SvrOfmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yLnj0O+k3PQ10JacVxQnBqkSlsqrC5N6jdu1SzXaVDzrI8W4zOTgeDY571yrHUcFx
	 4uBI/dEkuUIEAgPVUe29k1wucSRmT5pT7tOEbbfALAzNQt4bPpVNxYrpVtSpWbZreE
	 L30plxhgG6YR+AoGN2dxM5+AN6iClGfiRVEA8Y2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 032/641] smb: client: fix potential UAF and double free in smb2_open_file()
Date: Tue, 24 Feb 2026 17:15:58 -0800
Message-ID: <20260225012349.769920463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 03f90553d8319..e6cdf2efc7f4f 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -178,6 +178,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
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



