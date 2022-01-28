Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0F8C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jan 2022 14:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348528AbiA1ONE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jan 2022 09:13:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348313AbiA1OND (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 28 Jan 2022 09:13:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643379183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Q15V1enNICpdsunAm5+OFO3L/rtlZ/km7x09FTqjsm8=;
        b=Oo9d5NbfohkBCjnoNPgH3kza9ABOSCsxab3TwskLVWDkSBEWrvPEdBoqzo/pgOFpC5q1ia
        pWi/VV0OBG08YOMGrSe42roelhdbKkhUjazF3pjMIiw41o8ukyamChdFKqb7x1kXx3n8Qg
        uHqdDApDkNFnXm3FprU1MoB5sh5/pGs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-nYw8M63kMimDG4RllMCLyg-1; Fri, 28 Jan 2022 09:13:01 -0500
X-MC-Unique: nYw8M63kMimDG4RllMCLyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09986760C0;
        Fri, 28 Jan 2022 14:13:01 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-22.bne.redhat.com [10.64.54.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93D5322E1F;
        Fri, 28 Jan 2022 14:13:00 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: add a warning that SMB 1.0 is deprecated and will be phased out in 12 months
Date:   Sat, 29 Jan 2022 00:12:53 +1000
Message-Id: <20220128141253.2558990-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SMB1.0 was deprecated a long time ago.
The code is very old, fragile and has fragile bufferhandling.
There is no support or maintenacne of this dialect since a long time.
Additionally, the protocol is much less rich than SMB2 and and has semantic differences
which leads to unreasonable maintenance burdens.

Examples are: Rename ontop of an open file that has Delete-on-close set.
Compounding support, encryption support.

Warn that this protocol version is deprecated and will be removed from cifs.ko
in 12 months time.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 7ec35f3f0a5f..80caddebdad8 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -342,6 +342,7 @@ cifs_parse_smb_version(struct fs_context *fc, char *value, struct smb3_fs_contex
 	switch (match_token(value, cifs_smb_version_tokens, args)) {
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	case Smb_1:
+		cifs_errorf(fc, "WARNING: SMB1 is deprecated and will be removed from CIFS.KO in 2023. Please migrate to SMB2 or later.\n");
 		if (disable_legacy_dialects) {
 			cifs_errorf(fc, "mount with legacy dialect disabled\n");
 			return 1;
-- 
2.30.2

