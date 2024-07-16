Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1451A2C04;
	Tue, 16 Jul 2024 18:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721154855; cv=none; b=OWG+hPjdS2NObfrtpdmV4RX+9RuHJBa8I89lsm5mF0Ij/86ZzNRuRvH9XxIikMitnAEMCAKvWTCcngt9n3XRkSLL7x5uSwL0OkUJDuj8R7zv3ul/PLQ8W3+fgNktkVoiYYVq49EzZyKvJ2pOLACps1kwIeFnF3HCqIlnjR713vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721154855; c=relaxed/simple;
	bh=4Pu9TiE6lBXR/e/lfKvIC9SzjKkhyM5s7/+Yl0k5q3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY4iKuidMYgIOjKd4ZeIdVfz1XtNF/vMGzTFaVgbz9AsawVxkE//vQDDrORUBFN2Hn6ZmnPpbR5Vbtj7mY+UWg6XMT1s95LdafFq/hRZUiUY4z4SRw7fawVAudBuOEv5ltURUxDxYxKKHIHepc/2fXBPA7VPJ9AxxJ/pFw/lj2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1zf3erg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1zf3erg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32F3C4AF0B;
	Tue, 16 Jul 2024 18:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721154854;
	bh=4Pu9TiE6lBXR/e/lfKvIC9SzjKkhyM5s7/+Yl0k5q3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1zf3erghwqv5litjYY3AxFBmwZ9QXXT2K0YURBALMKTItOGHuqZxVE0otdmqQiEA
	 ws8fWvwTv62DB6DaE+U/lGnkduKDL/AqfDRsbyKz649PCcIH8gohr5PxdTnfImOCKu
	 wRgm3LY9xzBRO6yISoCTGqrg92q4R4ardydM2cNwncsIDcJ0o4JZFlglQsQdlJwtiv
	 32pqrH0uRKOIQ3Vur5Z0VhzG3cXxmHUiBUYkc2PRX60Bb2F3F4fntuTUBo+KJAo6c8
	 o8q4SgFLCoDyKySAhCuyeqzgk1eizPiDITilOs35ODt1QqEILZLtdazBABylAsRHCV
	 qtfmnCmSsnXtw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.1 2/5] ksmbd: return FILE_DEVICE_DISK instead of super magic
Date: Tue, 16 Jul 2024 14:33:59 -0400
Message-ID: <20240716183409.2814531-2-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716183409.2814531-1-sashal@kernel.org>
References: <20240716183409.2814531-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.99
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
index 25383b11d01b9..7d69a2a1d3ba4 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -905,6 +905,40 @@ struct smb2_query_directory_rsp {
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
index 34d88425434ab..bd422e98231fb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5039,8 +5039,13 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 
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

