Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3773C38145
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 05:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiIFFm5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 01:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiIFFm4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 01:42:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548AF5927D
        for <linux-cifs@vger.kernel.org>; Mon,  5 Sep 2022 22:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662442974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LvCzmMvEd5UNqPgEWUvOm+gghWdF00GrnxN8BuAHcF0=;
        b=Kd4+m6sr5ODYQAzw2XYg90j1aqq3KHSaIqVobK7LMekaY1ETPbFgQMDTCtCoWt+VuhjXoK
        vfXX8oyLUkQ5it9iBmn+dSYoMwFQJa4LMvloHmZMfZ6VhAlrt2KwBXfSaDFmgBmQ5PcPRq
        qfyaTtMlZEG/8+7u4pCx+l4+zWADm0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-XNKtRsa1PtWrFS3M5-7GRw-1; Tue, 06 Sep 2022 01:42:50 -0400
X-MC-Unique: XNKtRsa1PtWrFS3M5-7GRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BDB1185A79C;
        Tue,  6 Sep 2022 05:42:50 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D55740B40CB;
        Tue,  6 Sep 2022 05:42:49 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix buf in smb1 tree connect where we mount a share without suer security
Date:   Tue,  6 Sep 2022 15:42:40 +1000
Message-Id: <20220906054240.4148159-2-lsahlber@redhat.com>
In-Reply-To: <20220906054240.4148159-1-lsahlber@redhat.com>
References: <20220906054240.4148159-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Unconditionally alway set an empty password (length 1) for SMB1 Tree Connect password.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3da5da9f16b0..cab1be85dfa4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3926,12 +3926,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	pSMB->AndXCommand = 0xFF;
 	pSMB->Flags = cpu_to_le16(TCON_EXTENDED_SECINFO);
 	bcc_ptr = &pSMB->Password[0];
-	if (tcon->pipe || (ses->server->sec_mode & SECMODE_USER)) {
-		pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
-		*bcc_ptr = 0; /* password is null byte */
-		bcc_ptr++;              /* skip password */
-		/* already aligned so no need to do it below */
-	}
+
+	pSMB->PasswordLength = cpu_to_le16(1);	/* minimum */
+	*bcc_ptr = 0; /* password is null byte */
+	bcc_ptr++;              /* skip password */
+	/* already aligned so no need to do it below */
 
 	if (ses->server->sign)
 		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
-- 
2.35.3

