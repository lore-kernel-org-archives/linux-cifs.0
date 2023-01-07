Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B66C46467
	for <linux-cifs@archiver.kernel.org>; Sat,  7 Jan 2023 20:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjAGUBx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 7 Jan 2023 15:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAGUBw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 7 Jan 2023 15:01:52 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D2C11812
        for <linux-cifs@vger.kernel.org>; Sat,  7 Jan 2023 12:01:49 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 759FF7FC01;
        Sat,  7 Jan 2023 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673121707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Lbohn13YaeIO2SMROjzeMvCs2dk9ZZ5TN/7K28kadw=;
        b=yW3RHYsQIhBpEoEc3zDuod1tzyshtV+ZnwCI7/+fp20lUwyGDOvYCxIDEkWCncr+nTBzQ9
        QLmr5asBQGa8w56QnnzcP2pxVal2PwfxEKFF4OwVUlXatlPtaCk888zxnYYE2k2JSynq3U
        gwgIU+gNpFHmaCe78EgS64WQ1nlY8DTr5JE6Ez1rdBIKxMU6l14XzFLJsttK7ueLWC5kmi
        c8mmOpDFP+Xg73hgKc8XEiDU0aE/mbDpqfYm4XiHR6S8AaGu4uafhSkHL4Vc9sz2h4YkSG
        qeF7U38wOrclMnG3vKv4yMI4he25rJDe4mFaL5UvMIHv/Vi25p9RA+3MrdVrfA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: fix file info setting in cifs_query_path_info()
Date:   Sat,  7 Jan 2023 17:01:33 -0300
Message-Id: <20230107200134.4822-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We missed to set file info when CIFSSMBQPathInfo() returned 0, thus
leaving cifs_open_info_data::fi unset.

Fix this by setting cifs_open_info_data::fi when either
CIFSSMBQPathInfo() or SMBQueryInformation() succeed.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=216881
Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb1ops.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 50480751e521..5fe2c2f8ef41 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -562,17 +562,20 @@ static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if ((rc == -EOPNOTSUPP) || (rc == -EINVAL)) {
 		rc = SMBQueryInformation(xid, tcon, full_path, &fi, cifs_sb->local_nls,
 					 cifs_remap(cifs_sb));
-		if (!rc)
-			move_cifs_info_to_smb2(&data->fi, &fi);
 		*adjustTZ = true;
 	}
 
-	if (!rc && (le32_to_cpu(fi.Attributes) & ATTR_REPARSE)) {
+	if (!rc) {
 		int tmprc;
 		int oplock = 0;
 		struct cifs_fid fid;
 		struct cifs_open_parms oparms;
 
+		move_cifs_info_to_smb2(&data->fi, &fi);
+
+		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
+			return 0;
+
 		oparms.tcon = tcon;
 		oparms.cifs_sb = cifs_sb;
 		oparms.desired_access = FILE_READ_ATTRIBUTES;
-- 
2.39.0

