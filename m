Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0EC260565
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 01:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765242735; cv=none; b=Al8FnhLge8WO8MpQkvMJqrK/Cegnv53EFmFCCM9UaJep12EYRsT7LGm42zd/AWgrjIawaFLTwREXBCgw8fG02kccX2U5cAsrcCcxZxVps1S0EFt32PPSa+CLp5t2JthxCdTbDbRP1PfeRqIYjIChJWW39hsSYfpDl9X+9PXzDYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765242735; c=relaxed/simple;
	bh=zQVQ1OhKYgq5ksWyUs8XX+9+H7XRSXXHTPr97cJ8m3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pm0X0TFXNm3dRH917/rYVWXQxWmNszsVByfLxEKvEXdJurGN1GfWDTtmrVRSstB6wABmcKMlsTyVBhGedawyvhtx+NMqPoUxXOoqcRoJ/3osVZAGOD2yvKicKjISNOp7Q8iTz/Rue3clhiWVS/WQUondt7fNYyZ7wK1KBB/p3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HaWLb7JE; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HaWLb7JE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765242730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGEW81wNEXzSzt2Du/jA8DJwQWelbNPZh3BXLxJa3cQ=;
	b=HaWLb7JEe1FrbjLKlyn5JWrvNzkpJuAalllIRIk6JK99zHodKH0Sa3XO1UZWpNczH/JGUL
	0AvnyIjUjHOimwvY5tJCuvgyYXDMS1XrssWFDPgoSfn1i9ZNt9TRwoL1rciVcCIXqFurxB
	GHK9ev7N22JHrlsYlOZYdYdWHd7w4QU=
From: chenxiaosong.chenxiaosong@linux.dev
To: sfrench@samba.org,
	smfrench@gmail.com,
	linkinjeon@kernel.org,
	linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhengyuan@kylinos.cn,
	huhai@kylinos.cn,
	liuyun01@kylinos.cn,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 10/13] smb/client: remove DeviceType Flags and Device Characteristics definitions
Date: Tue,  9 Dec 2025 09:10:16 +0800
Message-ID: <20251209011020.3270989-11-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ZhangGuoDong <zhangguodong@kylinos.cn>

These definitions are already in common/smb2pdu.h, so remove the duplicated
ones from the client.

Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/client/cifspdu.h | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index e10392eb80e7..758ea29769da 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -2003,40 +2003,6 @@ typedef struct {
 
 #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for new QFSInfo */
 
-/* DeviceType Flags */
-#define FILE_DEVICE_CD_ROM              0x00000002
-#define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
-#define FILE_DEVICE_DFS                 0x00000006
-#define FILE_DEVICE_DISK                0x00000007
-#define FILE_DEVICE_DISK_FILE_SYSTEM    0x00000008
-#define FILE_DEVICE_FILE_SYSTEM         0x00000009
-#define FILE_DEVICE_NAMED_PIPE          0x00000011
-#define FILE_DEVICE_NETWORK             0x00000012
-#define FILE_DEVICE_NETWORK_FILE_SYSTEM 0x00000014
-#define FILE_DEVICE_NULL                0x00000015
-#define FILE_DEVICE_PARALLEL_PORT       0x00000016
-#define FILE_DEVICE_PRINTER             0x00000018
-#define FILE_DEVICE_SERIAL_PORT         0x0000001b
-#define FILE_DEVICE_STREAMS             0x0000001e
-#define FILE_DEVICE_TAPE                0x0000001f
-#define FILE_DEVICE_TAPE_FILE_SYSTEM    0x00000020
-#define FILE_DEVICE_VIRTUAL_DISK        0x00000024
-#define FILE_DEVICE_NETWORK_REDIRECTOR  0x00000028
-
-/* Device Characteristics */
-#define FILE_REMOVABLE_MEDIA			0x00000001
-#define FILE_READ_ONLY_DEVICE			0x00000002
-#define FILE_FLOPPY_DISKETTE			0x00000004
-#define FILE_WRITE_ONCE_MEDIA			0x00000008
-#define FILE_REMOTE_DEVICE			0x00000010
-#define FILE_DEVICE_IS_MOUNTED			0x00000020
-#define FILE_VIRTUAL_VOLUME			0x00000040
-#define FILE_DEVICE_SECURE_OPEN			0x00000100
-#define FILE_CHARACTERISTIC_TS_DEVICE		0x00001000
-#define FILE_CHARACTERISTIC_WEBDAV_DEVICE	0x00002000
-#define FILE_PORTABLE_DEVICE			0x00004000
-#define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
-
 /******************************************************************************/
 /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer formats */
 /******************************************************************************/
-- 
2.43.0

