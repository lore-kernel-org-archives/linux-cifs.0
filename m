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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AA2C0650E
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 13:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7987D218A0
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 13:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R6O/Y4Nx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfGCNR0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jul 2019 09:17:26 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41807 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfGCNR0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jul 2019 09:17:26 -0400
Received: by mail-pf1-f193.google.com with SMTP id m30so1269869pff.8;
        Wed, 03 Jul 2019 06:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2qYNVGbyIIWNOL5rTJJVjT4gxxFnB3Ik8dlI0/WbQj4=;
        b=R6O/Y4NxQUD6zKrHnbUDo1Azr14C08OSSYr/bMB4XOd0Y94vf1ZJ6e7FYeOn8t0uJD
         TvcGaxV1sVIc1dZrVQEeJWEw8f9LlV2nyNsGYDwYmkWl5fP+Rd0XaUSupzBzDsyFlLPE
         d8ZPJtnAoUE0MJVq+18mFHC8aZWNENe8EGCb8L7Hu3iqUWAs+04H/vRf33rn0u2nwsHG
         YjaXwJ4eu1Htwy9IrCr5iss0Ih2JrmaWENPQOfmGSJQBjovjSerfG/7rVGEizQyBp9hE
         lHN/aG9G3F/YkdLwHo8WZh/s2VI1PduDhNssaag2fQh5f4k0o1jy2upBX7NtfQbNmw2c
         rnVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2qYNVGbyIIWNOL5rTJJVjT4gxxFnB3Ik8dlI0/WbQj4=;
        b=iN4kWSxc4W6cuwxjRVr/YxQK4YkwZyTfv0EMLJ7qkFIMcZPgI7l+A5Ta/NQRdJyVe9
         yQZ+ccEWek53xQizqQjXV40QnCF/0oWYnrOB00PxLHqur0wR14C46l3xQGTHuvBpaLlD
         4MgrGU5m5FbO5PSiFI+LCffaZnMuFLvhhEp4Hh6GTWY2oVm1pLuzyzxP4pqfyhROiNWf
         9RfpAV2UkiSb7UV042evUwaKdqOZTBoERsFDFE/ETs/V63FpJe4ThRYdjdMHwYumCDaQ
         3UGJ09ZZ9V6zomEopmLR98ZmnA9UXoqm8LusZ6+9xllKKOv/s7AiEf/jXNomcc9HtT+W
         0X5A==
X-Gm-Message-State: APjAAAVvYVV1b/V1TJHbzqlABGQ7mngc9IkHnwTwpZvZ9ljVqI76WLQf
        BDb+q0yyLzpI0cG46BJGj9I=
X-Google-Smtp-Source: APXvYqyPMoOHdWfD2mYmRHdO63X6csCqLGJlHSZ6wY7B6QcMT+GDa43g06FtHQq+Kk8UhkwRp+t/5A==
X-Received: by 2002:a17:90a:1b4c:: with SMTP id q70mr12417346pjq.69.1562159845497;
        Wed, 03 Jul 2019 06:17:25 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id m5sm2552932pfa.116.2019.07.03.06.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:17:25 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 22/30] cifs: Use kmemdup rather than duplicating its implementation
Date:   Wed,  3 Jul 2019 21:17:16 +0800
Message-Id: <20190703131716.25689-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
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

