Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E847C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 22:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348319AbiEaWsx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 18:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbiEaWsw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 18:48:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F3695A0AE
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 15:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654037329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mifKYXMg1dnyQMoTFj4q6dEl8OiD9YQE1CTIl6LMyws=;
        b=C9uOpA++BQQW1ppiU57wnO3Hh0erOeLvjXNCJvqKlZKUKyRVksGfp9qXGcjWVsj+eoufnb
        uybWemh1YG+yJZc91YleJGy3tGzLAiXD1/BDKByypp0zBz7a0cc/av4HH7eQbp5LfXWQaa
        8U4Pm3T9dFiwFXjss/VxWq0fZzcecCA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-4FZLs62cPlKMTLojdhwAXA-1; Tue, 31 May 2022 18:48:46 -0400
X-MC-Unique: 4FZLs62cPlKMTLojdhwAXA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3B0B1C08987;
        Tue, 31 May 2022 22:48:45 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-17.bne.redhat.com [10.64.52.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12FB5492C3B;
        Tue, 31 May 2022 22:48:44 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: when extending a file with falloc we should make files not-sparse
Date:   Wed,  1 Jun 2022 08:48:38 +1000
Message-Id: <20220531224838.425356-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

as this is the only way to make sure the region is allocated.
Fix the conditional that was wrong and only tried to make already
non-sparse files non-sparse.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d7ade739cde1..03ab28c341c4 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3859,7 +3859,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
-		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
+		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 		eof = cpu_to_le64(off + len);
-- 
2.35.3

