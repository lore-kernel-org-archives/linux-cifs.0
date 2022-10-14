Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2681C4332F
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Oct 2022 16:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiJNQkX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Oct 2022 12:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiJNQkW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Oct 2022 12:40:22 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7620A27B18
        for <linux-cifs@vger.kernel.org>; Fri, 14 Oct 2022 09:40:19 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1DB277FD02;
        Fri, 14 Oct 2022 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1665765617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AlaMxTTg4xri0z/EoGCjp3NcRII3zkG6Ewl/ze1XPi4=;
        b=SvEpzW/gVK5Im6ioN1MUV7n7bwHO4Dsy3sWz1zKMCPkEU4ztj7dmbJx1IaGbCkGunS8cnH
        1sXqI5rw3dHFX6QSQV0znlx0rtAmA8q54ItxAQOLt0gvulGyXBRU9wswWqRBVGe+bplAnz
        hoRHkwESOtMg5mslfC3fU6rFoIRYzKGmQnsvg0mTgcLP5/ZfwNFxbmKggADaRXxUvETxPo
        +scifmjfQ+wZpEs1uvcxWg0iioZBOFr5HEKJw5LcjdoYE8FN0g7au4pr+6MGmWH8hREN8J
        sWSRXhYP2YQrWTXCqgt6SvOOIwAcVUxhvFil6IoWj4WoP3EE+u++PAlc/evGVQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Dan Carpenter <dan.carpenter@oracle.com>, pc@cjr.nz
Cc:     linux-cifs@vger.kernel.org
Subject: [PATCH] cifs: fix static checker warning
Date:   Fri, 14 Oct 2022 13:40:42 -0300
Message-Id: <20221014164042.22805-1-pc@cjr.nz>
In-Reply-To: <Y0kt42j2tdpYakRu@kili>
References: <Y0kt42j2tdpYakRu@kili>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove unnecessary NULL check of oparam->cifs_sb when parsing symlink
error response as it's already set by all smb2_open_file() callers and
deferenced earlier.

This fixes below report:

  fs/cifs/smb2file.c:126 smb2_open_file()
  warn: variable dereferenced before check 'oparms->cifs_sb' (see line 112)

Link: https://lore.kernel.org/r/Y0kt42j2tdpYakRu@kili
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/smb2file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 4992b43616a7..ffbd9a99fc12 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -123,7 +123,7 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 
 		if (unlikely(!err_iov.iov_base || err_buftype == CIFS_NO_BUFFER))
 			rc = -ENOMEM;
-		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK && oparms->cifs_sb) {
+		else if (hdr->Status == STATUS_STOPPED_ON_SYMLINK) {
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 &data->symlink_target);
 			if (!rc) {
-- 
2.37.3

