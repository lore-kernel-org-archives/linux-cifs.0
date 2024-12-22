Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE518FDB1;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734888267; cv=none; b=XFwrFBxEkVkvHpPOnHkHBMJcmTxhLbgyPAgp5jXzooP64oc99Us8314Jjak3W2pLmWsDIiBugFjrxlkkRuOM+CZcZA/+OvHmBGnFeGielTXyu/DHX1GF3mYOU1HmEv9plF1CvzGN/EWM5aLzbnfDY8zrQa/G7nrVD5UUr4YnvP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734888267; c=relaxed/simple;
	bh=aIYOqhz5FdfkYztJgvxKEqV4kx6kHrQ16z83tQXRv80=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnJtQJbhFsrvRk3CGYATYRWcooiHVrS5rDOJM5dBjH8ncUxwCNICGWv3u4VgFjYvhyjpxzSFvGHzClp8Z5ffbMhOHLZaqDBB1i9049bBfC44wX6l1oCZqHaM+MUSPNWf/O9LptRwGX/SOSi+q/6294YDH56Yj6SWp9mbEuYNQqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEc1UHZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEc1UHZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18171C4CEDD;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734888267;
	bh=aIYOqhz5FdfkYztJgvxKEqV4kx6kHrQ16z83tQXRv80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEc1UHZ0fhGYVavg/Mzx3CZAg16dt/RNEVm/lrvvfDUjUeUGOhdfWtkDRnS0mljCn
	 TMgvNIDwSTtWvygTAgcpZOTD5tXHd1f7jPEda5zT3WoLFCGfhUvI4Jtz9OqkXSAdsD
	 1aixNq7xTnspkgaFgg50ZD5BfMCH1oztzVx8lCLct89geWUevG53jQIN0dZocxcBIp
	 oIuFP2eo1PVpra5yycCCPvw+npZaWZMcZjjPoUuX2xWFB7xzzUPK8uOtKLByKIOsVP
	 /XkC2su2cQzPoF44tjbUC1C7hcsFbHzuuw1Sa6bzKy/X16XV/cUUQh4lw7SN6DiI+y
	 qAsl4j0b6qKBA==
Received: by pali.im (Postfix)
	id 5122C982; Sun, 22 Dec 2024 18:24:17 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] cifs: Remove struct reparse_posix_data from struct cifs_open_info_data
Date: Sun, 22 Dec 2024 18:24:02 +0100
Message-Id: <20241222172404.24755-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222172404.24755-1-pali@kernel.org>
References: <20241222172404.24755-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux SMB client already supports more reparse point types but only the
reparse_posix_data is defined in union of struct cifs_open_info_data.
This union is currently used as implicit casting between point types.

With this code style, it hides information that union is used for pointer
casting, and just in mknod_nfs() and posix_reparse_to_fattr() functions.

Other reparse point buffers do not use this kind of casting. So remove
reparse_posix_data from reparse part of struct cifs_open_info_data and for
all cases of reparse buffer use just struct reparse_data_buffer *buf.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h | 5 +----
 fs/smb/client/reparse.c  | 5 ++---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b56fca6dd195..5045ead02c43 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -262,10 +262,7 @@ struct cifs_open_info_data {
 			struct kvec iov;
 		} io;
 		__u32 tag;
-		union {
-			struct reparse_data_buffer *buf;
-			struct reparse_posix_data *posix;
-		};
+		struct reparse_data_buffer *buf;
 	} reparse;
 	struct {
 		__u8		eas[SMB2_WSL_MAX_QUERY_EA_RESP_SIZE];
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index f01214d6c5d4..40070e99fc8a 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -486,7 +486,7 @@ static int mknod_nfs(unsigned int xid, struct inode *inode,
 
 	data = (struct cifs_open_info_data) {
 		.reparse_point = true,
-		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
+		.reparse = { .tag = IO_REPARSE_TAG_NFS, .buf = (struct reparse_data_buffer *)p, },
 		.symlink_target = kstrdup(symname, GFP_KERNEL),
 	};
 
@@ -1165,8 +1165,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_fattr *fattr,
 				   struct cifs_open_info_data *data)
 {
-	struct reparse_posix_data *buf = data->reparse.posix;
-
+	struct reparse_posix_data *buf = (struct reparse_posix_data *)data->reparse.buf;
 
 	if (buf == NULL)
 		return true;
-- 
2.20.1

