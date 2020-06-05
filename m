Return-Path: <SRS0=0I05=7S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E26C433DF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 15:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4EBD206DB
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jun 2020 15:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bniJkoK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgFEPR6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:17:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726675AbgFEPR6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jun 2020 11:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591370276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=b6oaoc9BFGC0KbruyF/VyfbgSlVPGz9/S7qC1xpplAs=;
        b=bniJkoK93JxzrIh0aYP+9XfegxYN1tJJqggd8NPpWHSg/JRlxnln3o9SZGhRS74o2xs5Et
        XQdEIcv8E+b3uvTo/qAp/p8aI7vSQ1BUfNRBKFuVdQXHkCQAlTl8/eZPHgENBWzfbJe8F/
        63saROl+0PYVG9Yls+02NyHruqXjCZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-Nea1pxbjMEO7BDzAsfnrHA-1; Fri, 05 Jun 2020 11:17:55 -0400
X-MC-Unique: Nea1pxbjMEO7BDzAsfnrHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28212107ACCA;
        Fri,  5 Jun 2020 15:17:54 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.74.9.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF31D5C6DE;
        Fri,  5 Jun 2020 15:17:50 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, kdsouza@redhat.com, rbergant@redhat.com
Subject: [PATCH v3] cifs: dump Security Type info in DebugData
Date:   Fri,  5 Jun 2020 20:47:46 +0530
Message-Id: <20200605151746.18743-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently the end user is unaware with what sec type the
cifs share is mounted if no sec=<type> option is parsed.
With this patch one can easily check from DebugData.

Example:
1) Name: x.x.x.x Uses: 1 Capability: 0x8001f3fc Session Status: 1 Security type: RawNTLMSSP

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
---
 fs/cifs/cifs_debug.c |  4 ++++
 fs/cifs/cifsglob.h   | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 916567d770f5..9caca784376b 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -375,6 +375,10 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				ses->ses_count, ses->serverOS, ses->serverNOS,
 				ses->capabilities, ses->status);
 			}
+
+			seq_printf(m,"Security type: %s\n",
+					get_security_type_str(server->ops->select_sectype(server, ses->sectype)));
+
 			if (server->rdma)
 				seq_printf(m, "RDMA\n\t");
 			seq_printf(m, "TCP status: %d Instance: %d\n\tLocal Users To "
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 39b708d9d86d..d8ef01039e71 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1994,6 +1994,24 @@ extern struct smb_version_values smb302_values;
 extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
 
+static inline char *get_security_type_str(enum securityEnum sectype)
+{
+       switch (sectype) {
+       case RawNTLMSSP:
+               return "RawNTLMSSP";
+       case Kerberos:
+               return "Kerberos";
+       case NTLMv2:
+               return "NTLMv2";
+       case NTLM:
+               return "NTLM";
+       case LANMAN:
+               return "LANMAN";
+       default:
+               return "Unknown";
+       }
+}
+
 static inline bool is_smb1_server(struct TCP_Server_Info *server)
 {
 	return strcmp(server->vals->version_string, SMB1_VERSION_STRING) == 0;
-- 
2.21.1

