Return-Path: <SRS0=WzOu=7R=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1857CC433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jun 2020 15:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C176C20772
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Jun 2020 15:44:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2zePNMF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgFDPou (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Jun 2020 11:44:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20650 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729346AbgFDPou (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Jun 2020 11:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591285489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LRcaIcouOf2JVU4h/dsUpjKWE6X8S8Y+03ecg4Nz4YI=;
        b=S2zePNMFsXugs1mnqqGbEGf/d8zz4VRvlxEvpBdsZ0dhVbSuXoyQ6wIZG3GBn/LYhaGI0h
        YaO72B5/gQFO1QLLveEvx/utlniZT5CETS7S3Oy2cJz+3b0Wf0JEnbfvkakTSylzRSWmQv
        9bb3gPQv7Tgo86vg7HtK8fyK9yVBKgg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-RVC3UFm6MgicDk2FbPgKkg-1; Thu, 04 Jun 2020 11:44:47 -0400
X-MC-Unique: RVC3UFm6MgicDk2FbPgKkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C54B3A0BD7;
        Thu,  4 Jun 2020 15:44:46 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.74.9.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFB7578F04;
        Thu,  4 Jun 2020 15:44:43 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, kdsouza@redhat.com, rbergant@redhat.com
Subject: [PATCH v2] cifs: dump Security Type info in DebugData
Date:   Thu,  4 Jun 2020 21:14:41 +0530
Message-Id: <20200604154441.23822-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently the end user is unaware with what sec type the
cifs share is mounted if no sec=<type> option is parsed.
With this patch one can easily check from DebugData.

Example:
1) Name: x.x.x.x Uses: 1 Capability: 0x8001f3fc	Session Status: 1 Security type: RawNTLMSSP

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
---
 fs/cifs/cifs_debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 916567d770f5..3ad1a98fd567 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -221,6 +221,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	int i, j;
+	const char *security_types[] = {"Unspecified", "LANMAN", "NTLM",
+                                       "NTLMv2", "RawNTLMSSP", "Kerberos"};
 
 	seq_puts(m,
 		    "Display Internal CIFS Data Structures for Debugging\n"
@@ -375,6 +377,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->ses_count, ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->status);
 			}
+
+			seq_printf(m,"Security type: %s\n",
+                                      security_types[server->ops->select_sectype(server, ses->sectype)]);
+
 			if (server->rdma)
 				seq_printf(m, "RDMA\n\t");
 			seq_printf(m, "TCP status: %d Instance: %d\n\tLocal Users To "
-- 
2.21.1

