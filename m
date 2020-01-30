Return-Path: <SRS0=B7dF=3T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D69C2D0DB
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 19:53:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB4C20708
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jan 2020 19:53:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJLNrhUU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgA3TxH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jan 2020 14:53:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52667 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727089AbgA3TxH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Jan 2020 14:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580413986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=O8fR5fBMbXMyTqXIuDbXcBf1wFDQ/6p9nfakWulBS70=;
        b=BJLNrhUU5QkmYtFcRkGWP0w+X8J2N+1u4nRDCQkta5ZPleyxpqMccwTT6dYBaSiQnTycTo
        gM/kNdOq0WIcwhaVcea+Nh8JYtfeHz4Qt5JzJfW4e+r1B/RCjRVb0B8aamZpRfsm094Op1
        jN4+DtYsIPj7f7AG40TX9iP7oFMKwcw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-YsDFRZLlNLaCaVCk42WQCw-1; Thu, 30 Jan 2020 14:53:04 -0500
X-MC-Unique: YsDFRZLlNLaCaVCk42WQCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 254D8107ACC7;
        Thu, 30 Jan 2020 19:53:03 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-71.bne.redhat.com [10.64.54.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF59F5C1B2;
        Thu, 30 Jan 2020 19:53:02 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <palcantara@suse.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix soft mounts hanging in the reconnect code
Date:   Fri, 31 Jan 2020 05:52:51 +1000
Message-Id: <20200130195251.15789-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1795429

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

Fixes: a3a53b7603798fd8 (cifs: Add support for failover in smb2_reconnect())
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 7edba3e6d5e6..14f209f7376f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -312,7 +312,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 		if (server->tcpStatus != CifsNeedReconnect)
 			break;
 
-		if (--retries)
+		if (retries && --retries)
 			continue;
 
 		/*
-- 
2.13.6

