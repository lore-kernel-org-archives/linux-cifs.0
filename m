Return-Path: <SRS0=xrBw=D2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16552C433E7
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 11:17:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D072223C
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Oct 2020 11:17:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="inH0EnxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgJSLRe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Oct 2020 07:17:34 -0400
Received: from mail-m963.mail.126.com ([123.126.96.3]:35030 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgJSLRd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Oct 2020 07:17:33 -0400
X-Greylist: delayed 1888 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2020 07:17:33 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=tf1tYidOBEpo0RQqsy
        W8IneEYixUEEXf10m+wditqME=; b=inH0EnxSNLdJtjz5/eY5mW/XhIDXDIv5ar
        wX2VOgM95iacKeCYMBOpW2fe7ZDSEg76cEDY6mrM65kbSSJi8/L4xNyMtxf6cCrb
        iy2SwycF0xkXMQfiEs66d86p2tw2KTUgJpb+eacgh1/RASjLxp12kIHYX+1y1Hkv
        5wIE/ASrY=
Received: from localhost.localdomain (unknown [36.112.86.14])
        by smtp8 (Coremail) with SMTP id NORpCgC3nmxQbo1fL1G+Kg--.434S2;
        Mon, 19 Oct 2020 18:45:37 +0800 (CST)
From:   Defang Bo <bodefang@126.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Defang Bo <bodefang@126.com>
Subject: [PATCH] cifs : fix memory leak on error path
Date:   Mon, 19 Oct 2020 18:45:23 +0800
Message-Id: <1603104323-4438-1-git-send-email-bodefang@126.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: NORpCgC3nmxQbo1fL1G+Kg--.434S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruryDZrWUWrWDXryUArWrKrg_yoWfXFX_Ww
        4DZ397G3yj9a17Kw4UAw4avr1kWF48KwnxGwsaqF4xCFWfCw45Aw4kt34FqFy0grWkur9x
        A34DtF9a9rnI9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0YiiDUUUUU==
X-Originating-IP: [36.112.86.14]
X-CM-SenderInfo: pergvwxdqjqiyswou0bp/1tbitRLC11pECOipVQAAsw
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In SMB2_open_init() , if  smb2_plain_req_init() fails, then the memory assigned to req  will be leaked. It's similar to SMB2_open() which is fixed by the commit
<b7a73c84eb96> ("cifs: fix memory leak in SMB2_open()").

Signed-off-by: Defang Bo <bodefang@126.com>
---
 fs/cifs/smb2pdu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2f4cdd2..a1f584a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2703,9 +2703,10 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 
 	rc = smb2_plain_req_init(SMB2_CREATE, tcon, server,
 				 (void **) &req, &total_len);
-	if (rc)
+	if (rc) {
+		cifs_small_buf_release(req);
 		return rc;
-
+	}
 	iov[0].iov_base = (char *)req;
 	/* -1 since last byte is buf[0] which is sent below (path) */
 	iov[0].iov_len = total_len - 1;
-- 
1.9.1

