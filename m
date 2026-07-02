Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4CB38E8B7
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 10:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.21.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782987898; cv=none; b=XWGgwxEmFRgs3w9I2G451zW3oY7MQbxH/FqzITc2TmQTE5lVPnnk7wqtrz9zNMEk2s+1Iq7Mn5acqUA6iIjia/ZQsUJY0fv8A1PxrExC7d7LrOzsMcUNKJ/GmsKjLaPp3iewhLiS5YDf9Vbj0zC0UCbium4pV6zomC9+HwE6+OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782987898; c=relaxed/simple;
	bh=9db5oDxyLhET0pGQqLTUPBibyzK+Scne6yKzowN9d8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h0oxJ2fkape6fYm4+c1IH0rnvNRxcXK3Z7Pvt+PifI1wtVwB7CQI+s62Tq/H5iDV29SxGtefCCaJoUfFX77Wj9Ngssdu7V4KQk/b7PU/0pH4YNHHbZKcaN4bIXsTE+CsYyTKo194vwiAzeAdFgJliPF4MmFdtDxD4dPFlM6z9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=206.189.21.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [123.114.53.210])
	by app1 (Coremail) with SMTP id ygmowABnicMSPEZqFdDSAA--.39404S2;
	Thu, 02 Jul 2026 18:23:15 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	aaptel@suse.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	xizh2024@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH v2 1/1] smb: client: check posix_info_parse() in cifs_posix_to_fattr()
Date: Thu,  2 Jul 2026 18:23:09 +0800
Message-ID: <061cc31baf926e6c981268a629fdd72f3eee7410.1782933403.git.xizh2024@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABnicMSPEZqFdDSAA--.39404S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFWxCw4kJr4rKr1UZF18Xwb_yoW5Jr15pF
	ZxW3WfurZrXr18ua1xGa409w43tr15Gr1SqFnxG34S93Z3W392vFy8KrZ09w1fKr4UGFWr
	tFn0vFWDtFn0krDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVWUtVW8ZwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaV
	Av8VW8WwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdOz3UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEQCWpGH1cCbQAAsS

From: Zihan Xi <xizh2024@lzu.edu.cn>

cifs_posix_to_fattr() always called sid_to_id() with parsed owner/group
SIDs even when posix_info_parse() failed, allowing use of uninitialized
stack data for ID mapping on malformed SMB_FIND_FILE_POSIX_INFO entries.

Only call sid_to_id() after a successful parse. Fill the fixed
smb2_posix_info fields first so a malformed trailing payload still
yields usable inode metadata.

Fixes: 9934430e2178 ("SMB3.1.1: Fix ids returned in POSIX query dir")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <xizh2024@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
changes in v2:
  - Only call sid_to_id() after posix_info_parse() >= 0; still populate
    fixed smb2_posix_info fields when trailing SID payload is malformed
    (Steve French review)
  - v1 Link: https://lore.kernel.org/all/60461bf5482d51ebd950fc84fd19ece9ac1917fb.1782898568.git.xizh2024@lzu.edu.cn/

 fs/smb/client/readdir.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index e860fa08b5e3..91182dce7248 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -245,8 +245,6 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 {
 	struct smb2_posix_info_parsed parsed;
 
-	posix_info_parse(info, NULL, &parsed);
-
 	memset(fattr, 0, sizeof(*fattr));
 	fattr->cf_uniqueid = le64_to_cpu(info->Inode);
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
@@ -282,8 +280,12 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 		 le32_to_cpu(info->ReparseTag),
 		 le32_to_cpu(info->Mode));
 
-	sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
-	sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	if (posix_info_parse(info, NULL, &parsed) >= 0) {
+		sid_to_id(cifs_sb, &parsed.owner, fattr, SIDOWNER);
+		sid_to_id(cifs_sb, &parsed.group, fattr, SIDGROUP);
+	} else {
+		cifs_dbg(VFS, "Invalid POSIX info payload\n");
+	}
 }
 
 static void __dir_info_to_fattr(struct cifs_fattr *fattr, const void *info)
-- 
2.43.0

