Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A5E264636;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=eKaCWfqbn0AHflVuRiIjKTKBeN0YGfsHEI/vEbgHnJPIF1zVFSH7G3SkJtVIEQvAaIjEZBo8L+MhtbA2vozOoGDjTzyzMDdE1TAoXsIbTzp/xskGz+BTn8+X3AGveyOVD88t5nDIzc3bjgS78IJnjrPDBM9IRrQaubJuQ31ygoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=OZ8Nhb8bdpAwvT+5qtyxnSoZYNOZJt10537C8Kt76O0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZRy4E+mgbTIWWZDPqWjP44ca49Ewu+EfiIaxPVbnYtpxj3UW20fSt+u/qtNihxhT9N88aq4NKRjVkp2+tyJU5iTNS2N7hscydUu5u6MVkw3g25EpdqnHmvpEGuYvswtJvw+QwO5QD+NDepVMQw7OtlS8qWnMFfkMRF2LtdxdQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZqNXy8IA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZqNXy8IA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D5AC4CEFB;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643796;
	bh=OZ8Nhb8bdpAwvT+5qtyxnSoZYNOZJt10537C8Kt76O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqNXy8IAgbgNCAOItd6y5Z7Z8P5AF019nyyTE+9Vgecdf/czYUFab4mIUlEnSxC9d
	 JrrBSvunZqsqN0OS8FyT7vkScgWcP9jI+zD17k9TsLAyExp/SW9VSkJyvdIYVvl/aR
	 oJ6rwEwQ+o3w3EJJLKkuwiILMeWH8HARybCz+09ZU6i1qXTpFo+Ov4nchwP5PUzpaZ
	 2aOzriLfi6MaZwh3YSRL7XRhtpR3dsVSJ3vUclQiZvE++IhIrCwzCtPXXHThJDORfv
	 Odiq6jFcgREWNuynohFvR1B1DOKiiesUuUsixuUbVM9Qz/3zVwGctG+JjvYbc/imFD
	 a/AT3JztUGpjQ==
Received: by pali.im (Postfix)
	id DEF3B1857; Sun, 31 Aug 2025 14:36:33 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 16/35] cifs: Add comments for DeletePending assignments in open functions
Date: Sun, 31 Aug 2025 14:35:43 +0200
Message-Id: <20250831123602.14037-17-pali@kernel.org>
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

On more places is set DeletePending member to 0. Add comments why is 0 the
correct value. Paths in DELETE_PENDING state cannot be opened by new calls.
So if the newly issued open for that path succeed then it means that the
path cannot be in DELETE_PENDING state.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c   | 4 ++--
 fs/smb/client/smb2inode.c | 2 +-
 fs/smb/client/smb2pdu.c   | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f12bc0f4d0c1..6dabff82f6ae 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1163,7 +1163,7 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 				cpu_to_le64(le32_to_cpu(pSMBr->EndOfFile));
 			pfile_info->EndOfFile = pfile_info->AllocationSize;
 			pfile_info->NumberOfLinks = cpu_to_le32(1);
-			pfile_info->DeletePending = 0;
+			pfile_info->DeletePending = 0; /* successful open = not delete pending */
 		}
 	}
 
@@ -1288,7 +1288,7 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 		buf->AllocationSize = rsp->AllocationSize;
 		buf->EndOfFile = rsp->EndOfFile;
 		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0;
+		buf->DeletePending = 0; /* successful open = not delete pending */
 	}
 
 	cifs_buf_release(req);
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 460e75614ef1..6c9da150a402 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -698,7 +698,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		idata->fi.EndOfFile = create_rsp->EndofFile;
 		if (le32_to_cpu(idata->fi.NumberOfLinks) == 0)
 			idata->fi.NumberOfLinks = cpu_to_le32(1); /* dummy value */
-		idata->fi.DeletePending = 0;
+		idata->fi.DeletePending = 0; /* successful open = not delete pending */
 		idata->fi.Directory = !!(le32_to_cpu(create_rsp->FileAttributes) & ATTR_DIRECTORY);
 
 		/* smb2_parse_contexts() fills idata->fi.IndexNumber */
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2df93a75e3b8..58800490142e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3277,7 +3277,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		buf->EndOfFile = rsp->EndofFile;
 		buf->Attributes = rsp->FileAttributes;
 		buf->NumberOfLinks = cpu_to_le32(1);
-		buf->DeletePending = 0;
+		buf->DeletePending = 0; /* successful open = not delete pending */
 	}
 
 
-- 
2.20.1

