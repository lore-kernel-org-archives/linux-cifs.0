Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A153C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  9 May 2022 23:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiEIXs0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 May 2022 19:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbiEIXrn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 May 2022 19:47:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE6AF1FCD7
        for <linux-cifs@vger.kernel.org>; Mon,  9 May 2022 16:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652139747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F48/Y3uQOD7Eu5H015Rw4xIjlnPb9WEBVNhMztY2aDA=;
        b=JZx14KmpX+OziGOto6pkL1RDCUBg5FWE+Jm2uRMDxkzYc/HDV4uURDvbni6T2frv+H+WFy
        7pIPeIQ+eYRgXnNdm7J5kM9sFjF5nuSOAPUcPaH27edKeae16XzAWpNXxsmVHgHCxuM5dZ
        ri6EpwPvcNHmVD1qBdce4ZYgFyUT6zM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-CdAfgujrOmKfcjXC5FqroA-1; Mon, 09 May 2022 19:42:24 -0400
X-MC-Unique: CdAfgujrOmKfcjXC5FqroA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02DA51C05AA4;
        Mon,  9 May 2022 23:42:24 +0000 (UTC)
Received: from thinkpad (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2B2B62166B2F;
        Mon,  9 May 2022 23:42:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/4] cifs: check for smb1 in open_cached_dir()
Date:   Tue, 10 May 2022 09:42:05 +1000
Message-Id: <20220509234207.2469586-3-lsahlber@redhat.com>
In-Reply-To: <20220509234207.2469586-1-lsahlber@redhat.com>
References: <20220509234207.2469586-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Check protocol version in open_cached_dir() and return not supported
for SMB1.  This allows us to call open_cached_dir() from code that
is common to both smb1 and smb2/3 in future patches without having to
do this check in the call-site.
At the same time, add a check if tcon is valid or not for the same reason.

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d6aaeff4a30a..2c93ee27d54d 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -776,7 +776,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid *pfid;
 	struct dentry *dentry;
 
-	if (tcon->nohandlecache)
+	if (tcon == NULL || tcon->nohandlecache ||
+	    is_smb1_server(tcon->ses->server))
 		return -ENOTSUPP;
 
 	if (cifs_sb->root == NULL)
-- 
2.30.2

