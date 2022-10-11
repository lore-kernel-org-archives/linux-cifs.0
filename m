Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6F6C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 23:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiJKXMZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 19:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJKXMZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 19:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4237B9DF9F
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 16:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665529943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=7OC31dkJkO8yVywTvBWiAJRSd6xZbL1IHpQEmJ9HJJc=;
        b=G1/ixngGQldB0cEJGdKylq28ANkS78UNoQWlSHjKXnTb1mjl+caeRJTmBzsUgyNy+lBM83
        csuq6VbVPrI/W5I2BsVrrJmGa/r0F81T8JlmEjqR97p3/3mHRaWWhVm7c9EmAeZJrygICo
        g3wW9ovmgj7BAaBKT7iHVtG7POkCaEk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-JC38Hl6MNB-kRzMSmkQFZA-1; Tue, 11 Oct 2022 19:12:22 -0400
X-MC-Unique: JC38Hl6MNB-kRzMSmkQFZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2AA48027F5;
        Tue, 11 Oct 2022 23:12:21 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2052F414A818;
        Tue, 11 Oct 2022 23:12:20 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix regression in very old smb1 mounts
Date:   Wed, 12 Oct 2022 09:12:07 +1000
Message-Id: <20221011231207.1458541-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

BZ: 215375

Fixes: 76a3c92ec9e0668e4cd0e9ff1782eb68f61a179c ("cifs: remove support for NTLM and weaker authentication algorithms")
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 93e59b3b36c7..c77232096c12 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3922,12 +3922,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
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

