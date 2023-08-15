Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B4AC001B0
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Aug 2023 17:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbjHORuy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Aug 2023 13:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbjHORum (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Aug 2023 13:50:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E9F10F4
        for <linux-cifs@vger.kernel.org>; Tue, 15 Aug 2023 10:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692121804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JZ9Ljr74bix6rm1ggzkF30XRKzVJSNHwWhldSX1eBVE=;
        b=fosc5aBM0QPIm5yppfOZaKHJ9cztqHv0Dumb+2gLuA3P5AWsLpbQXOQd9tdnY47KTeRaxT
        wehuYFR2woE0jkpaB5SAqdj5JZl/brdoOBg1V6G7oGQMY2PkrXwFyeWrDdnVb9uP+hMSFR
        vHzvtVGVFpIqkFIQsA2QJcDmUVzEitg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-i2rsF8NCMIe-kMXyn4_Plg-1; Tue, 15 Aug 2023 13:49:58 -0400
X-MC-Unique: i2rsF8NCMIe-kMXyn4_Plg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3C65185A791;
        Tue, 15 Aug 2023 17:49:57 +0000 (UTC)
Received: from aion.redhat.com (unknown [10.22.17.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BB8A2026D4B;
        Tue, 15 Aug 2023 17:49:57 +0000 (UTC)
Received: from [192.168.0.151] (localhost [IPv6:::1])
        by aion.redhat.com (Postfix) with ESMTP id 19E1A8957A;
        Tue, 15 Aug 2023 13:49:57 -0400 (EDT)
From:   Scott Mayhew <smayhew@redhat.com>
Date:   Tue, 15 Aug 2023 13:49:50 -0400
Subject: [PATCH] smb: client: fix null auth
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230815-fix-cifs-null-auth-v1-1-3cb785216d97@redhat.com>
X-B4-Tracking: v=1; b=H4sIAL2622QC/x2MWwqAIBAArxL73YKPougq0YfYWgtioRlBePekz
 4GZeSFRZEowNS9EujnxESrItgG7m7AR8loZlFBajLJHxw9adglD9h5NvnbshO2166TVaoAanpG
 q9U/npZQP88UmpWQAAAA=
To:     Steve French <sfrench@samba.org>,
        Paulo Alcantara <pc@manguebit.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     Steve French <stfrench@microsoft.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Scott Mayhew <smayhew@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1468; i=smayhew@redhat.com;
 h=from:subject:message-id; bh=QCTDZkn1Og5Nxkd5+Io8DqeQTLoIR10jIci1nQbfvUc=;
 b=owGbwMvMwCW21EY5XUtI9jjjabUkhpTbu46asa47y2vh9lEocHvGtrid2vrP1mRO2XBhbiXf5
 7SYhIMbOkpZGMS4GGTFFFl2XPsuLb3tp72U5KWJMHNYmUCGMHBxCsBEXPQZ/lcfMktbbXSZMf78
 +smpey9NdbO4vzG76ofr9/U1D5cK5Zcy/JWeahH+wK8qTEe3d+XERu17R6ZaRzF2RJ9KnP00W/f
 0E0YA
X-Developer-Key: i=smayhew@redhat.com; a=openpgp;
 fpr=B8D6F71B1BB6F93F1A19D291A53C23672A121DC7
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Commit abdb1742a312 removed code that clears ctx->username when
sec=none, so attempting to mount with '-o sec=none' now fails with
-EACCES.  Fix it by adding that logic to the parsing of the 'sec'
option, as well as checking if the mount is using null auth before
setting the username when parsing the 'user' option.

Fixes: abdb1742a312 ("cifs: get rid of mount options string parsing")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 4946a0c59600..67e16c2ac90e 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -231,6 +231,8 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 		break;
 	case Opt_sec_none:
 		ctx->nullauth = 1;
+		kfree(ctx->username);
+		ctx->username = NULL;
 		break;
 	default:
 		cifs_errorf(fc, "bad security option: %s\n", value);
@@ -1201,6 +1203,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	case Opt_user:
 		kfree(ctx->username);
 		ctx->username = NULL;
+		if (ctx->nullauth)
+			break;
 		if (strlen(param->string) == 0) {
 			/* null user, ie. anonymous authentication */
 			ctx->nullauth = 1;

---
base-commit: 91aa6c412d7f85e48aead7b00a7d9e91f5cf5863
change-id: 20230815-fix-cifs-null-auth-40c53f41c327

Best regards,
-- 
Scott Mayhew <smayhew@redhat.com>

