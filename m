Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD8E3D9530
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 05:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789883832; cv=none; b=czFlsx7i2TjS4bobjpw5D0GHIyHvNi1jWKQxeXDxiZliuWwD/XiWn5cpqAGavWWgYf1uHLv3lBs31/ms/Mfsb9LBMq7IwWpmXrJQYsvIcPWzHf2e6Mh660NYuIVxlu5JfqbI2A4943A+QDpMBXLqDP9iQwjkJ1u3TLkX/HJ1rAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789883832; c=relaxed/simple;
	bh=x/jowf17k34VhP+APDcHIR55WAYZSasBktoXUd/7gBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GC3lnEm8nMhROG+x8QpqnA7qCj1XBNCHvch1uBdsib8QlBBGzxzw5A42xwGfHvxquv98SnCnAj06eqr5mmX+ylUx9ncAqOTYDbCXCGNcaNS7Sxnr/FnJ44yqWQePyTO77OErS9b//6MWjzSu/2s79x30fizyueDrbxgzjA9sreI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P8+LmDRF; arc=none smtp.client-ip=91.218.175.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P8+LmDRF"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=x/jowf17k34VhP+APDcHIR55WAYZSasBktoXUd/7gBo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789883824; v=1; x=1790488624;
 b=P8+LmDRFQugd57/5CKrHIYUa+Oso/euopjGdPZfHJaf1pocFiGR6E/Ob0P450fCSJfJtYjWq
 pYJitT5DPkmBP9q4wfMhhKjQcseA9NGf6a4tL4Ga5uxt9mJR8vZyL3zmuUQ6dUWSU6IKeQoEvDa
 GbfyhxwuEGvY8UgUST5YNxf8=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 35361253f3b4e45b;
	Sun, 20 Sep 2026 05:57:04 +0000
X-Mizu-Trace-ID: 35361253f3b4e45b
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 2/3] smb/client: update POSIX extension specification references
Date: Sun, 20 Sep 2026 13:56:52 +0800
Message-ID: <20260920055653.114794-3-zhang.guodong@linux.dev>
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
 fs/smb/client/smb2pdu.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index ab6c667bebc0..b37a1e3941a1 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -224,8 +224,7 @@ struct smb2_file_id_extd_directory_info {
 extern char smb2_padding[7];
 
 /*
- * See POSIX-SMB2 2.2.14.2.16
- * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb3_posix_extensions.md
+ * See POSIX-SMB2 2.1.3.2.1
  */
 struct create_posix_rsp {
 	u32 nlink;
@@ -238,6 +237,7 @@ struct create_posix_rsp {
 #define SMB2_QUERY_DIRECTORY_IOV_SIZE 2
 
 /*
+ * See POSIX-FSCC 2.2.1
  * SMB2-only POSIX info level for query dir
  *
  * See posix_info_sid_size(), posix_info_extra_size() and
@@ -256,13 +256,17 @@ struct smb2_posix_info {
 	__le64 Inode;
 	__le32 DeviceId;
 	__le32 Zero;
-	/* beginning of POSIX Create Context Response */
+	/*
+	 * Beginning of POSIX Create Context Response
+	 * See POSIX-SMB2 2.1.3.2.1
+	 */
 	__le32 HardLinks;
 	__le32 ReparseTag;
 	__le32 Mode;
 	/*
 	 * var sized owner SID
 	 * var sized group SID
+	 * End of POSIX Create Context Response
 	 * le32 filenamelength
 	 * u8  filename[]
 	 */
-- 
2.55.0

