Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941A11A08DB;
	Tue, 16 Jul 2024 18:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721154809; cv=none; b=qx2PvoY41wXT2pllrNkd+KtnXX1g1ahUr/53fM+N44jFjpOcYJLLeJ9SFjGNvGPtjuGucJO7pKIudyt42qap0Dj7OFq6qNih6Qw56omA6FKKA7ph9gbj33pG0nQcbuPrtHJYhHimgmXplwpt3akvO/9tl43kk3VBRh44PMG/tPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721154809; c=relaxed/simple;
	bh=apg+f4AOfs9ttQraXX0QIty1m/VFNd/tNLm+Eu3cbd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8uiW10Qo07utYCmsl8E3Tf23AbLhM7foaOoPUF2/FQzBm0rMXFCr0KiIcjkfMowbSjcQ8y2MQJm58oKvUJYxx4c2nKoyaDtkVcjLAfCGtnXM860cYotfz2UQXaBRYKNDEQwDgw51dNXmEP4Oz216RibMq11zj2BpXN1lIyqNlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrSees5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrSees5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260F8C4AF13;
	Tue, 16 Jul 2024 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721154809;
	bh=apg+f4AOfs9ttQraXX0QIty1m/VFNd/tNLm+Eu3cbd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrSees5sGZjWC81Bxk9piEjN4b20Vuz4/jFlnRzHfCyIwN0ab1ynUxcB7uRmUbjfi
	 ODqaKKTvmoFdNUi8VfDEepGDVkFNFkQOZXMv3JV+ThmB8eozYZUJ8roMq8+4+HzUFM
	 G9CnXiFDdR4U0l50wm13QJC0PZPe8F3dM9daFCya6dezEqhZyRZISe+IkeHMQ9N5I8
	 AeoXUdWeZo8mYOyMwZkufFRRv7S5MxeyXSZTcMe9TmEUJgjANwFemKfHO9ENSI4KxS
	 fQsnZgtKEKCVzvXa/eX54ZcYuS/NS+DlLFd4fR/fMeHhRYuFbOZcVLMbT00HWB10zL
	 l+WpMCdIZ5Wrg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 2/8] ksmbd: return FILE_DEVICE_DISK instead of super magic
Date: Tue, 16 Jul 2024 14:32:59 -0400
Message-ID: <20240716183324.2814275-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716183324.2814275-1-sashal@kernel.org>
References: <20240716183324.2814275-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.40
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 25a6e135569b3901452e4863c94560df7c11c492 ]

MS-SMB2 specification describes setting ->DeviceType to FILE_DEVICE_DISK
or FILE_DEVICE_CD_ROM. Set FILE_DEVICE_DISK instead of super magic in
FS_DEVICE_INFORMATION. And Set FILE_READ_ONLY_DEVICE for read-only share.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smb2pdu.h | 34 ++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  9 +++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 8d10be1fe18a8..c3ee42188d252 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -917,6 +917,40 @@ struct smb2_query_directory_rsp {
 	__u8   Buffer[];
 } __packed;
 
+/* DeviceType Flags */
+#define FILE_DEVICE_CD_ROM              0x00000002
+#define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
+#define FILE_DEVICE_DFS                 0x00000006
+#define FILE_DEVICE_DISK                0x00000007
+#define FILE_DEVICE_DISK_FILE_SYSTEM    0x00000008
+#define FILE_DEVICE_FILE_SYSTEM         0x00000009
+#define FILE_DEVICE_NAMED_PIPE          0x00000011
+#define FILE_DEVICE_NETWORK             0x00000012
+#define FILE_DEVICE_NETWORK_FILE_SYSTEM 0x00000014
+#define FILE_DEVICE_NULL                0x00000015
+#define FILE_DEVICE_PARALLEL_PORT       0x00000016
+#define FILE_DEVICE_PRINTER             0x00000018
+#define FILE_DEVICE_SERIAL_PORT         0x0000001b
+#define FILE_DEVICE_STREAMS             0x0000001e
+#define FILE_DEVICE_TAPE                0x0000001f
+#define FILE_DEVICE_TAPE_FILE_SYSTEM    0x00000020
+#define FILE_DEVICE_VIRTUAL_DISK        0x00000024
+#define FILE_DEVICE_NETWORK_REDIRECTOR  0x00000028
+
+/* Device Characteristics */
+#define FILE_REMOVABLE_MEDIA			0x00000001
+#define FILE_READ_ONLY_DEVICE			0x00000002
+#define FILE_FLOPPY_DISKETTE			0x00000004
+#define FILE_WRITE_ONCE_MEDIA			0x00000008
+#define FILE_REMOTE_DEVICE			0x00000010
+#define FILE_DEVICE_IS_MOUNTED			0x00000020
+#define FILE_VIRTUAL_VOLUME			0x00000040
+#define FILE_DEVICE_SECURE_OPEN			0x00000100
+#define FILE_CHARACTERISTIC_TS_DEVICE		0x00001000
+#define FILE_CHARACTERISTIC_WEBDAV_DEVICE	0x00002000
+#define FILE_PORTABLE_DEVICE			0x00004000
+#define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
+
 /*
  * Maximum number of iovs we need for a set-info request.
  * The largest one is rename/hardlink
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6397f77b6750c..ac03ae34be015 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5314,8 +5314,13 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
 		info = (struct filesystem_device_info *)rsp->Buffer;
 
-		info->DeviceType = cpu_to_le32(stfs.f_type);
-		info->DeviceCharacteristics = cpu_to_le32(0x00000020);
+		info->DeviceType = cpu_to_le32(FILE_DEVICE_DISK);
+		info->DeviceCharacteristics =
+			cpu_to_le32(FILE_DEVICE_IS_MOUNTED);
+		if (!test_tree_conn_flag(work->tcon,
+					 KSMBD_TREE_CONN_FLAG_WRITABLE))
+			info->DeviceCharacteristics |=
+				cpu_to_le32(FILE_READ_ONLY_DEVICE);
 		rsp->OutputBufferLength = cpu_to_le32(8);
 		break;
 	}
-- 
2.43.0

