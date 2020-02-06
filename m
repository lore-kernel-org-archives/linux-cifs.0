Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193E9C2D0B1
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 03:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3AEF20720
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 03:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O58UhhTa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgBFDzc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Feb 2020 22:55:32 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36781 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726687AbgBFDzb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Feb 2020 22:55:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580961330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=FUqbzqoJ4QRE38SEHau68F/Xl8rjOQzdDD9zxwv6TeQ=;
        b=O58UhhTaIuWowyvrdg+ZlXmcasCGObXIUNoBBFiByRqSQxprt+jMSgUBqf1jIL0A/ImZgb
        aL+vha25VUIRNjMyJdYlJyEQvwXKCUCqjWHxeJue+1EVOjwBScNRvjLhPtKTtdQZh3E5ph
        vWqRzczC79vApiplT2kXeaCE/z0iY7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-Ik-zYifBOcSGSuZ0b4imjw-1; Wed, 05 Feb 2020 22:55:28 -0500
X-MC-Unique: Ik-zYifBOcSGSuZ0b4imjw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B59ED1835A1B
        for <linux-cifs@vger.kernel.org>; Thu,  6 Feb 2020 03:55:27 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AFCD790CF;
        Thu,  6 Feb 2020 03:55:27 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix soft mounts hanging in the reconnect code
Date:   Thu,  6 Feb 2020 13:55:19 +1000
Message-Id: <20200206035519.29209-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1795423

This is the SMB1 version of a patch we already have for SMB2

In recent DFS updates we have a new variable controlling how many times we will
retry to reconnect the share.
If DFS is not used, then this variable is initialized to 0 in:

static inline int
dfs_cache_get_nr_tgts(const struct dfs_cache_tgt_list *tl)
{
        return tl ? tl->tl_numtgts : 0;
}

This means that in the reconnect loop in smb2_reconnect() we will immediately wrap retries to -1
and never actually get to pass this conditional:

                if (--retries)
                        continue;

The effect is that we no longer reach the point where we fail the commands with -EHOSTDOWN
and basically the kernel threads are virtually hung and unkillable.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index a481296f417f..3c89569e7210 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -260,7 +260,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 		if (server->tcpStatus != CifsNeedReconnect)
 			break;
 
-		if (--retries)
+		if (retries && --retries)
 			continue;
 
 		/*
-- 
2.13.6

