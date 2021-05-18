Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55313C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 18 May 2021 22:40:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B2C16100C
	for <linux-cifs@archiver.kernel.org>; Tue, 18 May 2021 22:40:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhERWlk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 May 2021 18:41:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230251AbhERWlj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 18 May 2021 18:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621377620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tPap8YqNRF6+L2LnaqMHQ4uSs+UQocshACyvtShjZAM=;
        b=e8gAJ0i4gVZ7ZqWFu1lF2IkAzI+iLPMLzc7kA9Kdqr3BIzS2IYx+5DjPD54dXRgZ1qckEa
        d7bTjIzHtl2eQauV375tB9cn+Ty52yKL09SYIehDKa0PBxQ2XOEY3wuRVKQUOK4I8eg21t
        kYVUxsL5ok/ORRhBd7zBcopYlfnNlDk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-600-ncesXLNVM0-Bl8PHZ86gQw-1; Tue, 18 May 2021 18:40:18 -0400
X-MC-Unique: ncesXLNVM0-Bl8PHZ86gQw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2624D8049C5;
        Tue, 18 May 2021 22:40:18 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-178.bne.redhat.com [10.64.54.178])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96B4310016FF;
        Tue, 18 May 2021 22:40:17 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix memory leak in smb2_copychunk_range
Date:   Wed, 19 May 2021 08:40:11 +1000
Message-Id: <20210518224011.663856-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When using smb2_copychunk_range() for large ranges we will
run through several iterations of a loop calling SMB2_ioctl()
but never actually free the returned buffer except for the final
iteration.
This leads to memory leaks everytime a large copychunk is requested.

Fixes: 9bf0c9cd431440a831e60c0a0fd0bc4f0e083e7f
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 19b8e5b5ab28..21ef51d338e0 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1861,6 +1861,8 @@ smb2_copychunk_range(const unsigned int xid,
 			cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk));
 
 		/* Request server copy to target from src identified by key */
+		kfree(retbuf);
+		retbuf = NULL;
 		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
 			true /* is_fsctl */, (char *)pcchunk,
-- 
2.30.2

