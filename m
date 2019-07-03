Return-Path: <SRS0=Wa1n=VA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4BCC0650E
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 16:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54FF8218A0
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 16:31:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m8KinkxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfGCQbD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jul 2019 12:31:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37927 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfGCQbC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jul 2019 12:31:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id z75so1511749pgz.5;
        Wed, 03 Jul 2019 09:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BupW8djDuFe89cHMmRkInscHcPGdbc7VTC98zH01S3U=;
        b=m8KinkxPC+pzBURKLRIVZhFrk0msuXXzw46KVzKl5hT0vtQMAmO0XE7gYTVNKhX0KB
         0rTP9eTaAjOch9pVE4RThGvROv1kVUXG0QDbI7CUu+QtcZH1FdEgteMmSSP1/8ey5Tqn
         dvsZJwDaj37WZsth4bdzMBEAC8i43AMxFyEO/3EofBlAF4HszFuKsyzoKuRa7wlRqY3m
         nmocrMiDgGKNh7pUi8vpMkXAdY8bl2ILWycSQz505Su9S+ToXAds+WatABepWWRSR29v
         CgtvwRApZDl4lIgytR/0upLZO7/eGMWzd49R6T/oqVzBIZXykLCsaf7sgyNc8wxxFzrE
         0wvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BupW8djDuFe89cHMmRkInscHcPGdbc7VTC98zH01S3U=;
        b=UczH6oqw8yx388sKRNNRS0ZozvwmPfBrc+FohG6Y6u4kg2YIR7JzMsywWzdeYGMT37
         Mg85p5xDtaocsl8m3mkaVGS5/6KJzSixS+HUX6dvDwg9t2r3fEHndvvMIMPziX9FHUfg
         19PYG0voiARmC2wVJUeVNxGcCAM+apZL5iYhQz2PGqc2QsVCdmvSX0KGgZP32iTlEkrA
         E5p3GaKptJVrtqaiNk3msp9t+4xCvafbXxOrB0EoRJfPKJg2fODJbHP7+voTnQnaNai0
         tR9sk9zbySShgwxn53hjsbqHlvKJmGN3XDGG1aMDpoSsugG3F4rZwIaH+xb+yP+zETZ5
         DZWg==
X-Gm-Message-State: APjAAAUZWFDiFocCppB87k2C1uuV9GfhB0uCFs1LU9XyipfiyC6J/Eqw
        rfDfsP2S42Y5/WWLwsWjc7/Hy+BvmUI=
X-Google-Smtp-Source: APXvYqxaavQzYeHjjLCFemiIHIKk5tCet9e/YcV/odaiBQtb8oEyDBqbY3gJE/TnQDWKPT0GXgdMMA==
X-Received: by 2002:a63:fa0d:: with SMTP id y13mr37846873pgh.258.1562171462276;
        Wed, 03 Jul 2019 09:31:02 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id 137sm6206838pfz.112.2019.07.03.09.30.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:31:01 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 26/35] cifs: Use kmemdup rather than duplicating its implementation
Date:   Thu,  4 Jul 2019 00:30:50 +0800
Message-Id: <20190703163050.577-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

 fs/cifs/smb2pdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 75311a8a68bf..ab8dc73d2282 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2550,12 +2550,11 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
 		 * indatalen is usually small at a couple of bytes max, so
 		 * just allocate through generic pool
 		 */
-		in_data_buf = kmalloc(indatalen, GFP_NOFS);
+		in_data_buf = kmemdup(in_data, indatalen, GFP_NOFS);
 		if (!in_data_buf) {
 			cifs_small_buf_release(req);
 			return -ENOMEM;
 		}
-		memcpy(in_data_buf, in_data, indatalen);
 	}
 
 	req->CtlCode = cpu_to_le32(opcode);
-- 
2.11.0

