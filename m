Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C9C263C9E;
	Mon, 24 Feb 2025 11:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740395875; cv=none; b=efL/LRJ+9Rj1QCc6XSAky5Rv0zpeeuZviZHeL3Qiu1yKznFxqRXORPZ7Hoycj5YevRhZTs3b2OfISWRSu4mxVAQ58DHP4CuGfwkr6VbelcOzwI7cmfBZB9ekCoTP5Ux4EK0dITKJjVwxt3UzbLLjEgUYvHRqFKk3cC+QECqNbZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740395875; c=relaxed/simple;
	bh=AqC/SyyR7zEcSp96cB/NcX/G9sATLEdqTQn4kdPNpnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnZA8Wa1zKKXXMfA24cu6PqUHMl+36G2wlbuMCcOJKTtDJd5DZkmOnqd6mR6d+7LvPQsR+ywWr2D0W8CNZn6xq559ClJ3EytwUGrDex5Z6fNetx8RsTnXrj3kuHlL2GLWAx9vqSISNhG6euo2kDiLnpxjCkrqY1e/tIC3UzeiPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AoGhlDgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AoGhlDgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79386C4CED6;
	Mon, 24 Feb 2025 11:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740395874;
	bh=AqC/SyyR7zEcSp96cB/NcX/G9sATLEdqTQn4kdPNpnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoGhlDgVVwH3hhSDaDa1aVTlaFSOdkFXLyYYYIxo0pZZZZiJ5Xh9S8ge092dy9a6E
	 F2o6sJCXHIBbFFdwBWxAG1PgUA0WQdRhrrkNBU7Qy9hRg4KIWAXSp6OYOmjwzzFsuK
	 0Wj3pXf5D7Ka+RYDQ7W7/Z8Tdd9H9kDybk09uqVplJxVLiCNYXMcZENMEX4OeXPOii
	 qQCNX5SRgsqKkvvjpF2/nCUodKTH0RQtlWRR+55Qz1iCqfUMyMSU/rdG8knTDXvWgi
	 tNolv13bSiZj7s/Ldtj4O02W+yBQORm8ERVEUnfe1ICZVbBNkDtGBecTmwvq9yQUJs
	 uRdRYC5hz8vlg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linkinjeon@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.13 29/32] cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes
Date: Mon, 24 Feb 2025 06:16:35 -0500
Message-Id: <20250224111638.2212832-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250224111638.2212832-1-sashal@kernel.org>
References: <20250224111638.2212832-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.13.4
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b587fd128660d48cd2122f870f720ff8e2b4abb3 ]

If the reparse point was not handled (indicated by the -EOPNOTSUPP from
ops->parse_reparse_point() call) but reparse tag is of type name surrogate
directory type, then treat is as a new mount point.

Name surrogate reparse point represents another named entity in the system.

From SMB client point of view, this another entity is resolved on the SMB
server, and server serves its content automatically. Therefore from Linux
client point of view, this name surrogate reparse point of directory type
crosses mount point.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c    | 13 +++++++++++++
 fs/smb/common/smbfsctl.h |  3 +++
 2 files changed, 16 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index f146e06c97eb6..564f113bf739d 100644
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
 		break;
 	}
diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index 4b379e84c46b9..3253a18ecb5cb 100644
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
2.39.5

