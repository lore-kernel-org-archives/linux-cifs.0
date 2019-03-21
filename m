Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE6D1C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 04:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92A1E2146E
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 04:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfCUE71 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 00:59:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfCUE71 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Mar 2019 00:59:27 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF8ADC057F3E;
        Thu, 21 Mar 2019 04:59:26 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-57.bne.redhat.com [10.64.54.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77D7E5C57B;
        Thu, 21 Mar 2019 04:59:26 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: allow guest mounts to work for smb3.11
Date:   Thu, 21 Mar 2019 14:59:02 +1000
Message-Id: <20190321045902.14326-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 21 Mar 2019 04:59:26 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix Guest/Anonymous sessions so that they work with SMB 3.11.

In git commit 6188f28 tightened the conditions and forced signing for
the SMB2-TreeConnect commands as per MS-SMB2.
However, this should only apply to normal user sessions and not for
Guest/Anonumous sessions.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/smb2pdu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c399e09b76e6..8e4a1da95418 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1628,9 +1628,13 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	iov[1].iov_base = unc_path;
 	iov[1].iov_len = unc_path_len;
 
-	/* 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1 */
+	/*
+	 * 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1
+	 * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
+	 */
 	if ((ses->server->dialect == SMB311_PROT_ID) &&
-	    !smb3_encryption_required(tcon))
+	    !smb3_encryption_required(tcon) &&
+	    !(ses->session_flags & (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)))
 		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
-- 
2.13.6

