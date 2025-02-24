Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76089267B7C;
	Mon, 24 Feb 2025 11:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740395949; cv=none; b=bBLS+GvQIS0Vhe7uIUmvTtnfW9IoAZ2X9ZM6hC2e02EncDhxs5kSQTEt/qw8FON1ibiT1/FOHOsTgpxkmGmxZaFykNksDRyp8oHaZQnZ1Cb/CJaOlbu2yOUIOOvhDWliV4BLM5vOWt4NndquvIfr0kELd6gwwYOcx6CLJEhrREs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740395949; c=relaxed/simple;
	bh=gE5uRHqVDZjkgOWqgS95Cm71TIS3auiXFOzMFuV0Ot4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=be/qwof1+dOUlqH/9kqnEvaxHsphbl+Aq+0k+QEL+XPO3ZpY3oEbCTwe5tTEPnQr4Gk55d4qYOx2uI+E6WMnK7bwUxJXYjkghJcW2Ddl4pSi/NaCnCrOJgijDNbKLARPYIwOmBHnVZTuEy4BvoyTplnMltd0dUvL7atEPsqooM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MGOFre3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MGOFre3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE834C4CEE8;
	Mon, 24 Feb 2025 11:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740395948;
	bh=gE5uRHqVDZjkgOWqgS95Cm71TIS3auiXFOzMFuV0Ot4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGOFre3MS6BIh7QJVFfUTb+Pu2jhulU/qyWX7yKRPaH1As0OcRLMK9m91FLyYhmae
	 9hVWfJRg8EFEotcjXYVvpTdClEOctSjI/8fhAjTnZUGKqk2FxPf+ox3/VjloFicrfR
	 TxK/i4AE49P/PNNuNHrgR0UWLeLeiPDhjLWj4klAxPhS+SentrJdgPr87xjqPymC0+
	 nCZ2oxLxxsroc4GDqqUX+f8Zz9Y3INMAU2MOQIzTwYa1QuOV98LjtpqP2MTXw+jD7r
	 B5Tk/a2gKIyVG2YT0D5R4WDVPPWBc7lHxsCM6LiisuUeGHiJIThOmfSznfW0b5esGK
	 3Kx1tgc1t5jaQ==
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
Subject: [PATCH AUTOSEL 6.12 25/28] cifs: Treat unhandled directory name surrogate reparse points as mount directory nodes
Date: Mon, 24 Feb 2025 06:17:56 -0500
Message-Id: <20250224111759.2213772-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250224111759.2213772-1-sashal@kernel.org>
References: <20250224111759.2213772-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.16
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
index fafc07e38663c..295afb73fcdd6 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1193,6 +1193,19 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
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

