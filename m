Received: from mta0.migadu.com (out-216.mta0.migadu.com [91.218.175.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25B175A80
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 01:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789954901; cv=none; b=czbOeUu91W0RoujrunkDrzvdj9D11EACyj56k0btZ3o6B2sAKQnasH+Y7OZUpFouMSugX3CFdHipwPO5IZfNdzHrFDXpyqSkHcaXXVpAWYeoIdSoOr0iYtID6a14+qz4mOw7jTBlEQOAI6Sb05hXRXNgKDHo5iD/mZiIujGkMQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789954901; c=relaxed/simple;
	bh=x/jowf17k34VhP+APDcHIR55WAYZSasBktoXUd/7gBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ94/hfxNpYmGngXDKdXNbGmo+yGR2kakOuHXSud6T1ZhZve41YokktlGD9Bs0dhMwH7DR11Q34YepptRYUiqw5K+W4zWDzjncFDsyzi5m7OLTnm0GIKW4PlYytG/ODgzLNTM9sxraxoRID6UNMnVRc08kNmhCKq7sDnowjDHQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DFZUIblr; arc=none smtp.client-ip=91.218.175.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DFZUIblr"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=x/jowf17k34VhP+APDcHIR55WAYZSasBktoXUd/7gBo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789954897; v=1; x=1790559697;
 b=DFZUIblrKIX503A00/Xs6RD+8iVp51fPpwHcQknECOoUH4lLjHCen3/+LIn7Y7GGeFuP1DhY
 0Ht/DDXj7Q6iG5CRBGngmNoDsk+GvH709m3z/U4NcjiBCK+lZxwtKtZxElQUvCGadS5ZNMWgw/Y
 C3GaJR8N0+Kn2vjHtyw5j1eI=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 908077defbfa8079;
	Mon, 21 Sep 2026 01:41:37 +0000
X-Mizu-Trace-ID: 908077defbfa8079
X-Migadu-Flow: FLOW_OUT
From: ZhangGuoDong <zhang.guodong@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org
Cc: linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v2 2/3] smb/client: update POSIX extension specification references
Date: Mon, 21 Sep 2026 09:41:28 +0800
Message-ID: <20260921014130.147229-3-zhang.guodong@linux.dev>
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

