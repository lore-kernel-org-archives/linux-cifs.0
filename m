Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F24C1D5ABA;
	Wed, 25 Feb 2026 01:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982841; cv=none; b=iF4H2dd6RjAlYUNB7Qnnjv7D5cfkRf51jLQaXWtg1lQfCm3I93iIFH26FXvcdcx1oymbBTKwJmq9v87kMOoKTeQzZmTloJwhKdn0WfL4+JreTWWFLz+VdHISl72bdzXnu9tZjJJMXWuqEJPDQKZpaNXY57H8g8n9MFv9lAmN8gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982841; c=relaxed/simple;
	bh=tT0GO0+iu3OG6ayOPJ42YszUOOsYD5i0ba682GVLIXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICaZDGoz9agBUz/+RZb5vO6GMrP9lA2+x8XUKu0xUXGOXDaLp5edG8ufSIjjFbpx9Ez5T6fOUA4HERKjW9vfYP+5lyChoiGCJvtPbllduC1S3ytdg3ZWa1DBbIH6XQntxlRstcnfqQpb5PUvhAOnhclHICW7GRaqADp60KM4W5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BS8UJfp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BS8UJfp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071ABC116D0;
	Wed, 25 Feb 2026 01:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982841;
	bh=tT0GO0+iu3OG6ayOPJ42YszUOOsYD5i0ba682GVLIXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS8UJfp5Vdh0MHVb8B4VsAMaA4UQb0t52D9HYBEZ1aaAXX2qL6AUVHEM3zxK4NKxY
	 QjWs0LQjOCV00LmE+cekZYrIR19Hn7O2nk6e/X/CYToRk3D0fonQM8R4Zljd++WKuy
	 C61/LO/aGN8iOdmLJ9W2W2TgyWhdp6z7v3MBQIMk=
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
Subject: [PATCH 6.19 033/781] smb: client: fix potential UAF and double free in smb2_open_file()
Date: Tue, 24 Feb 2026 17:12:22 -0800
Message-ID: <20260225012400.515913903@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2dd08388ea873..1f7f284a78449 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -179,6 +179,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
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



