Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F169F38385;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734879572; cv=none; b=dxkasNMbzF/PUw3N4d3ZW1yWHgrVbFGb0P+wO1F1keCrP5NlBJ4FRYrHd2g4U6IBdaJYQzqWN/6pGLjyeTopsTR42y/gk2xO39gJum/P9fIV3pL0LDzE8eqvbUgV7nsxqyHFD/7U22jcUpsYrf6PdtyGllnZADBf4JbQbE0Zda0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734879572; c=relaxed/simple;
	bh=wwqBsWcxZC84pRk3Bl1cSD+E6PrIZa85GEnwzxufZKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrsBwEeub+qdTkmsZ8MLaAt7iu8X1Q1yABpcpfssQds/VOEonc5EOqYed4fcmd3qRbvzrikBHGqt5Y9v+I4LiZYxNflimBbjJLt9bZ/wiaaLFLiZDPuBrTvl3YLb33yan0L+4vAd1KzHHXGg4qFFii5Jux1SDRfe21TBalQaEzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHuYvL2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHuYvL2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691B6C4CECD;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734879571;
	bh=wwqBsWcxZC84pRk3Bl1cSD+E6PrIZa85GEnwzxufZKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHuYvL2F0rbjMT3L/GH1PWeTxTOz/OmZPs3e2dyb9/fQtVJCHFOJcX8hLgSIAcZwZ
	 MQzcWnbei8vJfi9DbCv8KqtsFVGGTBDj1W23laSVVr2iqlgism0oOoFww6dB8VrtAZ
	 QPY3VerPtMlhnrFv0zpZcaPSPnnMpBjDh/g0/XTV/CK/mIFiyqOPd9cMAND0ls2RX8
	 ndi3zBJHEOH9C9QE0pFx7WrQ33MmoFfySXd0EqZjIvcHVJJ84SqrF39cJt7w5Qf4Df
	 i3B50nuh1uyjRG5RiVC/KwY9000uzmiScdMx/yKgo0WWFo8xuIDCSjYclXY1beAVYr
	 1yjIKGpEEspqg==
Received: by pali.im (Postfix)
	id B56B2B9A; Sun, 22 Dec 2024 15:59:21 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes
Date: Sun, 22 Dec 2024 15:58:43 +0100
Message-Id: <20241222145845.23801-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222145845.23801-1-pali@kernel.org>
References: <20241222145845.23801-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If the reparse point was not handled (indicated by the -EOPNOTSUPP from
ops->parse_reparse_point() call) but reparse tag is of type name surrogate
directory type, then treat is as a new mount point.

Name surrogate reparse point represents another named entity in the system.

From SMB client point of view, this another entity is resolved on the SMB
server, and server serves its content automatically. Therefore from Linux
client point of view, this name surrogate reparse point of directory type
crosses mount point.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c    | 13 +++++++++++++
 fs/smb/common/smbfsctl.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 19b6d68007fb..b26403e6fc2c 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1215,6 +1215,19 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			rc = server->ops->parse_reparse_point(cifs_sb,
 							      full_path,
 							      iov, data);
+			/*
+			 * If the reparse point was not handled but it is the
+			 * name surrogate which points to directory, then treat
+			 * is as a new mount point. Name surrogate reparse point
+			 * represents another named entity in the system.
+			 */
+			if (rc == -EOPNOTSUPP &&
+			    IS_REPARSE_TAG_NAME_SURROGATE(data->reparse.tag) &&
+			    (le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY)) {
+				rc = 0;
+				cifs_create_junction_fattr(fattr, sb);
+				goto out;
+			}
 		}
 
 		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 4b379e84c46b..3253a18ecb5c 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -159,6 +159,9 @@
 #define IO_REPARSE_TAG_LX_CHR	     0x80000025
 #define IO_REPARSE_TAG_LX_BLK	     0x80000026
 
+/* If Name Surrogate Bit is set, the file or directory represents another named entity in the system. */
+#define IS_REPARSE_TAG_NAME_SURROGATE(tag) (!!((tag) & 0x20000000))
+
 /* fsctl flags */
 /* If Flags is set to this value, the request is an FSCTL not ioctl request */
 #define SMB2_0_IOCTL_IS_FSCTL		0x00000001
-- 
2.20.1

