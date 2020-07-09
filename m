Return-Path: <SRS0=36sk=AU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B0DC433E4
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 10:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 075BC206DF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 10:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LaHKFDlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGIKkB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jul 2020 06:40:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbgGIKkB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jul 2020 06:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594291200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=iEge0bD9npePtmFhMcLKrZH6hVoCxkvDiPfFNlXYDHc=;
        b=LaHKFDlkSQ/y/svNks6OFQ+hg77Jho4Pj+nWlqN/VRaAIqCCiqVpkeFnu27JzfnunSNlD4
        TRIpsIBJjc5d7daTaE7KfRLkEb0Qdd4iXKvkKmLYBS51IygkftwD/ebKkmOM8Fq1Kv1u2w
        6KEnFrb+rTQxZpaMNDuU0YgOMnx5jzU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-w8vZH5NSNQCjMjZE_p4TXA-1; Thu, 09 Jul 2020 06:39:58 -0400
X-MC-Unique: w8vZH5NSNQCjMjZE_p4TXA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2487788C7A3
        for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2020 10:39:58 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-135.bne.redhat.com [10.64.54.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACC0A1001925;
        Thu,  9 Jul 2020 10:39:57 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix reference leak for tlink
Date:   Thu,  9 Jul 2020 20:39:49 +1000
Message-Id: <20200709103949.29944-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Don't leak a reference to tlink during the NOTIFY ioctl

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/ioctl.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 4a73e63c4d43..dcde44ff6cf9 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -169,6 +169,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	unsigned int xid;
 	struct cifsFileInfo *pSMBFile = filep->private_data;
 	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb;
 	__u64	ExtAttrBits = 0;
 	__u64   caps;
@@ -307,13 +308,19 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 				break;
 			}
 			cifs_sb = CIFS_SB(inode->i_sb);
-			tcon = tlink_tcon(cifs_sb_tlink(cifs_sb));
+			tlink = cifs_sb_tlink(cifs_sb);
+			if (IS_ERR(tlink)) {
+				rc = PTR_ERR(tlink);
+				break;
+			}
+			tcon = tlink_tcon(tlink);
 			if (tcon && tcon->ses->server->ops->notify) {
 				rc = tcon->ses->server->ops->notify(xid,
 						filep, (void __user *)arg);
 				cifs_dbg(FYI, "ioctl notify rc %d\n", rc);
 			} else
 				rc = -EOPNOTSUPP;
+			cifs_put_tlink(tlink);
 			break;
 		default:
 			cifs_dbg(FYI, "unsupported ioctl\n");
-- 
2.13.6

