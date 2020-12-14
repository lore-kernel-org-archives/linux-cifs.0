Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936D0C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C5522583
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438781AbgLNGmF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438779AbgLNGmE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=MjACw1QkYDzfTUQl5ZtWqUJFFe5a225FPPNnccHGqBE=;
        b=KEf2yx2rxsRemb27O2hraFs+DgMZ/rcIgQlFMJfgfTCeR6XjUiFoHP8f1DFA507lNfxqts
        vGUxh1NXRO6eM63rb2NCCYr5/5IRZ/b6yYuprjrgQJh7W64tLBke6E3CIXS1khddgwH3jb
        NrJyrAPqAObqp+ROdmg9D80CWNuccWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-lbUhvnBEMUSOR7s6DNUikw-1; Mon, 14 Dec 2020 01:40:36 -0500
X-MC-Unique: lbUhvnBEMUSOR7s6DNUikw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F4BF800D62;
        Mon, 14 Dec 2020 06:40:35 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87A96100164C;
        Mon, 14 Dec 2020 06:40:34 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 12/12] cifs: fix uninitialized variable in smb3_fs_context_parse_param
Date:   Mon, 14 Dec 2020 16:40:27 +1000
Message-Id: <20201214064027.2885-12-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 84a86e91127b..a6ca0a3dee76 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -725,8 +725,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	 * we will need special handling of them.
 	 */
 	if (param->type == fs_value_is_string && param->string[0] == 0) {
-		if (!strcmp("pass", param->key) || !strcmp("password", param->key))
+		if (!strcmp("pass", param->key) || !strcmp("password", param->key)) {
 			skip_parsing = true;
+			opt = Opt_pass;
+		}
 	}
 
 	if (!skip_parsing) {
-- 
2.13.6

