Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85AFAC61DA4
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Feb 2023 08:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjBWIRD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Feb 2023 03:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbjBWIRA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Feb 2023 03:17:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C4B4C6F7
        for <linux-cifs@vger.kernel.org>; Thu, 23 Feb 2023 00:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677140149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AKMYONgMA/W4Xp2CmPvSHz2sn9JYXMHWS8dU6/4wH+A=;
        b=g4/o1RmsMvdARUQ7kK6k0iEJyTH8/AYsSRG92LwVluCGzYuEr3VH8ia/fyQe7siaIX2fv1
        bQxZiGmGkMpjT1d0JO2bb03ceJniZplnBdLo4AOsgbFLTNDOSoGhcMyi7G6bAsBdKvuD2V
        cv3yoR0EbwFORhsFm3KEwrp5NT6yj/Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-BOzk5WYFOVe9tUA_9GNWYA-1; Thu, 23 Feb 2023 03:15:47 -0500
X-MC-Unique: BOzk5WYFOVe9tUA_9GNWYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04A3F85A588;
        Thu, 23 Feb 2023 08:15:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DD0840C1423;
        Thu, 23 Feb 2023 08:15:45 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>,
        Stefan Metzmacher <metze@samba.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        linux-rdma@vger.kernel.org
Subject: [PATCH 2/2] cifs: Fix an uninitialised variable
Date:   Thu, 23 Feb 2023 08:15:39 +0000
Message-Id: <20230223081539.970487-3-dhowells@redhat.com>
In-Reply-To: <20230223081539.970487-1-dhowells@redhat.com>
References: <20230223081539.970487-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix an uninitialised variable introduced in cifs.

Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Tom Talpey <tom@talpey.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: linux-rdma@vger.kernel.org
---
 fs/cifs/smbdirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 55b6e319a61d..0362ebd4fa0f 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -837,7 +837,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
 	int data_length;
 	struct smbd_request *request;
 	struct smbd_data_transfer *packet;
-	int new_credits;
+	int new_credits = 0;
 
 wait_credit:
 	/* Wait for send credits. A SMBD packet needs one credit */

