Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA0F621
	for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2024 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719187810; cv=none; b=NviaZDF70JqK6MbUVesNRzsRIcmEK7GPnZZ5HSm0VPJ8p50T3hztlW6QW8Sjl6ryClXtaoKxe4pr/JgVN2Hvs9Jlo96PDnDgyIROuX6Yf8eOWPPWuAnPOIG4iEkoTwVMPc8VRgpR41waLyBk+HO7wuUKM5epm/gu4WjbdGoX2TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719187810; c=relaxed/simple;
	bh=uaNWFo0ehpLpjnOr6rygwjH9GAkbHWLb9yMJew/LIcI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PzXdtRZFhYe5oT3Z/aT9iX9QHZTz3JW0UkxpcCvYWA8Jhw/lKFq4PiW1XKM8Y1JKM5ec5LXK9IHoWEnJ6nK9J9R6hVv81MXqUnMUt8HGxWYlVyRzWT0z6CFO4y+dVNItjD6FyGMD1ySz4fnrT++lxS0k3Y2RbJEjtW71xBMXnEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70670188420so739206b3a.2
        for <linux-cifs@vger.kernel.org>; Sun, 23 Jun 2024 17:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719187808; x=1719792608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JMhRAlSsBmPHd5v7IY6bSIOtuUGx6pZbRux35I0O9mw=;
        b=Befma8y80r5J2MxaLfYRc4/BXntKtRxHoUqx2ZtLENg2/RSCQyZpZG/YzylutOMeUn
         cbxHO4KQ1M0WsMtuasuOaNQbyvgt2zur1M7v6P+ffoUdGyKF/96mfA6W+xLID3kpoL0+
         vJdFT2wNmVewaI1QJmgz0YX0J//2jeJJAyesn74WQXhg8gB2C7Wl/C3Fp26LvuZvJ+CU
         gaUSiqkrMJ73UeYDL1Y+Yvw1ZYOEJSfy63yXsWUUA6lvH2qZVwgpNJYPC9/YRkIU58Xz
         yDI9B43QKoag8Q1n/BOH8fXfaWDfld5o0TavStJHwICFkQlsKFPlMM7KA6Kq1of3aWYF
         ojTQ==
X-Gm-Message-State: AOJu0YxR0B2gJouuG/acPMNS1LZoX4nfCF8CdXhQWjdr6hACg/GlkMS+
	uPNlDeX+EpfZewDVNHPu1h5DjM2edoFKjBMflcUuVZQ37iSvzQFceI7Vpw==
X-Google-Smtp-Source: AGHT+IGFgiaGP2iIXBlh8XHk4rfwodE2MhasjAV/qvMP8HJYSIcTjVzCBB3w54AVrcCTxWFMUKg6lQ==
X-Received: by 2002:a05:6a20:2105:b0:1bc:feb5:887d with SMTP id adf61e73a8af0-1bcfeb58bb8mr1545096637.25.1719187807947;
        Sun, 23 Jun 2024 17:10:07 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f02e3sm50516295ad.62.2024.06.23.17.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jun 2024 17:10:07 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH] ksmbd: return FILE_DEVICE_DISK instead of super magic
Date: Mon, 24 Jun 2024 09:09:39 +0900
Message-Id: <20240624000939.3926-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

MS-SMB2 specification describes setting ->DeviceType to FILE_DEVICE_DISK
or FILE_DEVICE_CD_ROM. Set FILE_DEVICE_DISK instead of super magic in
FS_DEVICE_INFORMATION. And Set FILE_READ_ONLY_DEVICE for read-only share.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smb2pdu.h | 34 ++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.c |  9 +++++++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 8d10be1fe18a..c3ee42188d25 100644
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
index e7e07891781b..786cd45fe18f 100644
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
2.25.1

