Received: from mta1.migadu.com (out-88.mta1.migadu.com [95.215.58.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447051DA23
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789954903; cv=none; b=oyeNPf2iIZDp8k33MX53BjCvhnZpQMBncLvntmvuFlEJ4szr3EARscxKuZkdSJxsWtjvk/B1bT/wMMzDZKZeDg31RvlMKsJlVR+CKUp4RQ7jDPwaJNfKC4VEGfhDl8iNzuYEE1OncVZokvYYuyTPWf+4k8i+F+sY0cn/f6WRmeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789954903; c=relaxed/simple;
	bh=ruJjqjyALORsF1S5ppsRYZ7g6ehEOx8k2RFyOK+32uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlwLs8r7P03y2lDDZmdrLJM4n/QV7Z3DQL24VIKjoAVtP4dv3ja4bYWAK38CAB8NBwzWMzUa5ia/BBAAqiIRHZNYryiGc0LWEJeTTYpQulRhqb3oTNQANHR57A59lP83SRKMUkkk1BJ6jVh7Z1zqjyZr3psWnw9vR44xJUdIJYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jxYp5eOr; arc=none smtp.client-ip=95.215.58.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jxYp5eOr"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ruJjqjyALORsF1S5ppsRYZ7g6ehEOx8k2RFyOK+32uo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789954899; v=1; x=1790559699;
 b=jxYp5eOrOS3tHpJ12hQLr0aGtxKWgCvDNZI5J/FXnks4TJpYewW7tiIRZNgFlu4C0HhIzrfi
 AyshlJM8uECSqWFzF65bMsKExL6HqZTZPMjSyzLXXoYJR0J9DM1S8CCXn+zhOKOdC7OSlZ4Yl8w
 7mkVyphdSFXDRotQB1se8H9Q=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f9855efdbf87c42a;
	Mon, 21 Sep 2026 01:41:39 +0000
X-Mizu-Trace-ID: f9855efdbf87c42a
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 3/3] smb/common: update POSIX extension specification references
Date: Mon, 21 Sep 2026 09:41:29 +0800
Message-ID: <20260921014130.147229-4-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921014130.147229-1-zhang.guodong@linux.dev>
References: <20260921014130.147229-1-zhang.guodong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ZhangGuoDong <zhangguodong@kylinos.cn>

The POSIX extension specifications have now been published:
https://smb3posix.org/

Suggested-by: Paulo Alcantara <pc@manguebit.org>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/common/fscc.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index e46d3379b779..00f09e1a3afe 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
@@ -399,7 +399,7 @@ static_assert(offsetof(struct smb2_file_rename_info, FileName) == sizeof(struct
 #define FS_OBJECT_ID_INFORMATION	8 /* Query, Set */
 #define FS_DRIVER_PATH_INFORMATION	9 /* Query */
 #define FS_SECTOR_SIZE_INFORMATION	11 /* SMB3 or later. Query */
-/* See POSIX Extensions to MS-FSCC 2.3.1.1 */
+/* See POSIX-FSCC 2.3 */
 #define FS_POSIX_INFORMATION		100 /* SMB3.1.1 POSIX. Query */
 
 /* See MS-FSCC 2.5.1 */
@@ -575,8 +575,7 @@ struct file_notify_information {
 } __packed;
 
 /*
- * See POSIX Extensions to MS-FSCC 2.3.2.1
- * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/fscc_posix_extensions.md
+ * See POSIX-FSCC 2.3.1
  */
 typedef struct {
 	/* For undefined recommended transfer size return -1 in that field */
-- 
2.55.0

