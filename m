Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B849B26BDB4;
	Mon, 24 Feb 2025 11:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740395995; cv=none; b=dbE4V7btUy2an+ATwqmTfDzoqgqM5i8xTbtZyvYEF1RpRIG2TOBJQo/W7qP9xgXkzvmu+QPyZsBMbPAmFRYVKSjH7NQJJHx+vXCwLV5mojVN4hhQA+pAGNGpFWipoKJFmrgVh4BOyFU7TMmzP+nTb/cQanwbkatHUwJScysifSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740395995; c=relaxed/simple;
	bh=osZaV4rm0G40kP39LS28Emu7FAgBMz4vabpiAjNoTTE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aO/uU/mvfdQg8bA9AeUOnXqOPzDN37ftbeFjj6HMwg2MT74DJBvOOJyhjw2Cua5ERHfGTNyzD7w9aN7cRRjb1XzLH6g1i1lg+4/R6wecSC+iAQ8p8UT4qUawHCzzWKp4y+Ls90lWEzO2s7s+S6+0Vefg2YUphlVLwZGVx9QywYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKBJtPbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKBJtPbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD6EC4CED6;
	Mon, 24 Feb 2025 11:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740395995;
	bh=osZaV4rm0G40kP39LS28Emu7FAgBMz4vabpiAjNoTTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKBJtPbDm7dq9VtV/69rwHg/wJzRPGV2a/+HsfhzrH+uoSep3y51lQkkV7O7Es2nQ
	 mD9Y/h8pY5bt+OhUpCY/0PkGBZ06GRJUZiWKlVGYxjk6E7KtufWNTOsn5zqHCbtZtv
	 9owtghrvgq978XVfIpiLHaIKr9JwcRZ/4ltW3SfI8Q1p3LU2PS6ddKJlrbuNJF1R4V
	 cnNa0AIoFg74ENq9ItwjazQCYj2wMvQWC6EpqQErKPZBue7rVZflLd20/iSR1Y8xoG
	 Gxh7v+o3XlvUGMhpoNZXz4xTUzObr26icdrJylLVO/Rqqp/KKFdypP1+9rVuFkMPxm
	 d8sGmQ11roIMQ==
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
Subject: [PATCH AUTOSEL 6.6 17/20] cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes
Date: Mon, 24 Feb 2025 06:19:10 -0500
Message-Id: <20250224111914.2214326-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250224111914.2214326-1-sashal@kernel.org>
References: <20250224111914.2214326-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.79
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
index b3e59a7c71205..55d6e926cd8cb 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1132,6 +1132,19 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
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
index a94d658b88e86..6eff3a8bde096 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -158,6 +158,9 @@
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

