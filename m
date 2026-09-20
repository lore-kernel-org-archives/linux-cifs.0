Received: from mta0.migadu.com (out-109.mta0.migadu.com [91.218.175.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D06A3D9531
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789883832; cv=none; b=uxKjJY1HgicgNoX/YjZkfGYjKrufghweOZohs52f06T5qkkFeNqyuRqMr4oLtBNBwk/042W+hzEIsKJk+UPznBU85TxLG+GMTKBZbnwNRga+lu7WZ8V0aFb3uyN3IbrWupFNA3wLyeXhkK15l07M5cUBGFARn8fs/YQ9wMpbaig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789883832; c=relaxed/simple;
	bh=LLDIeb/IRRHXpqQAcDqvh2JtuFdpd2KAw4EIlBAEiv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbtBMaHEnaP6Oiq8x1frdADChTqbUbqnBMadcKwAPMnW6dP+CF9UAuBWFnNyYtLtITPBNacIOPGkqOJNXo4I6qak9iPLprZ9EdLtKISj4J/Ykm8qTOzKVIC6LHsRjMjtUDJ6DDR+PBTzCpuk6FJFhUe9ftB7x9ylWgKWvhEw7sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NPIQIPoV; arc=none smtp.client-ip=91.218.175.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NPIQIPoV"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LLDIeb/IRRHXpqQAcDqvh2JtuFdpd2KAw4EIlBAEiv4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789883826; v=1; x=1790488626;
 b=NPIQIPoVaZEF8mcxH/ECcO/t35qzwOLmmHLAm1r6MaLTnRp6mnch2YNhQj5q/wfx2OOgxa/R
 8J/+stjYLzM9edSMDeZyMa1+t5HxltPdChkWIVqrTOROW2J0H0b+JJWdHzXeKhX5kGkCAl41Vxr
 PZA4UXErqRHuHGk+N8n27PvM=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 4bab649c30269cd9;
	Sun, 20 Sep 2026 05:57:06 +0000
X-Mizu-Trace-ID: 4bab649c30269cd9
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 3/3] smb/common: update POSIX extension specification references
Date: Sun, 20 Sep 2026 13:56:53 +0800
Message-ID: <20260920055653.114794-4-zhang.guodong@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260920055653.114794-1-zhang.guodong@linux.dev>
References: <20260920055653.114794-1-zhang.guodong@linux.dev>
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
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
---
 fs/smb/common/fscc.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
index e46d3379b779..61bb1f8e4a64 100644
--- a/fs/smb/common/fscc.h
+++ b/fs/smb/common/fscc.h
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

