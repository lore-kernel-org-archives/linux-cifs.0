Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64098C678D5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Mar 2023 18:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjCGSp4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Mar 2023 13:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233176AbjCGSpX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Mar 2023 13:45:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D55B9E07D;
        Tue,  7 Mar 2023 10:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BF4261552;
        Tue,  7 Mar 2023 18:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7DCC433EF;
        Tue,  7 Mar 2023 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214052;
        bh=9aSMdrE6eO87rmSUfXuG5Ak7lUktr+u5yI/oZLiPlTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvVryd5nhFo4QQ3cOk0gMkFDprZ7dVxxAUztT6BB+5S+pVye8xjUsgi9qY2oQf0+J
         KP1elV1Llp79ZhJ99LKNRc4DfTtD2oBdtSqv1sYVD6pjb4xcRNh5lY6bsj1ne/ZuNY
         /oa/1gBx1WDsjVTvlaJsccY57NTIQ3B1estFgPII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 675/885] cifs: dont try to use rdma offload on encrypted connections
Date:   Tue,  7 Mar 2023 18:00:09 +0100
Message-Id: <20230307170031.469276199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

commit 3891f6c7655a39065e44980f51ba46bb32be3133 upstream.

The aim of using encryption on a connection is to keep
the data confidential, so we must not use plaintext rdma offload
for that data!

It seems that current windows servers and ksmbd would allow
this, but that's no reason to expose the users data in plaintext!
And servers hopefully reject this in future.

Note modern windows servers support signed or encrypted offload,
see MS-SMB2 2.2.3.1.6 SMB2_RDMA_TRANSFORM_CAPABILITIES, but we don't
support that yet.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4081,6 +4081,10 @@ static inline bool smb3_use_rdma_offload
 	if (server->sign)
 		return false;
 
+	/* we don't support encrypted offload yet */
+	if (smb3_encryption_required(tcon))
+		return false;
+
 	/* offload also has its overhead, so only do it if desired */
 	if (io_parms->length < server->smbd_conn->rdma_readwrite_threshold)
 		return false;


