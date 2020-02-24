Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF69C35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A222072D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="j6+SQgpy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgBXNWx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:22:53 -0500
Received: from hr2.samba.org ([144.76.82.148]:44820 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBXNWx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=wSWRryOjWtaZVT9AdnqJqfSBDf5bBwvIdoPBvHak1I4=; b=j6+SQgpytt6Rn6Qq8Y7wbKEIZw
        ACCmNi0pT3kn1Yb7hlFgf42AA87SMSPqCRMVCcUb89DnZBFhhBelTqxVhDSwCliju4Z35rqeyVOBg
        7EyEea2TCYN6mrnrDmDEXXxUX98HkCRYPXM/IhRVzhmwdh5B0Y5CfUNNWn33VnxoYnymRhAemZfKr
        JgwGAna1A2ppDjGOKe4dDl7rQdXvqURIt1AUzAAE91jfMl14TBmP65LW1L4eTb4KCcOm7GkffHRUk
        1daiySnsDO+SGLGWYNHLuKvRaKda9I1vf1pkRHkgP+KcLjDi+7Bivb/ND8H18QWiCOs5oHAgDoR7I
        HHSVQ83aTX4sax/RvWxo27IJ6OWY40EN+3yz3nlMCrdPDgwwoY91SAybkAazeV2KrupPYgm/vvf2A
        UzQLneQoeXNB8IIqX8aFCGwMruVlr4gozY3LcrYcHGW/WP5ARc6YOGdQ9Q8rBTeuNv6DWEfBEngBC
        c3Q+Ogc195xbe9saNHgFCp29;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaS-00061e-Ni; Mon, 24 Feb 2020 13:15:52 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 11/13] cifs: use reconnect timer also for SMB1
Date:   Mon, 24 Feb 2020 14:15:08 +0100
Message-Id: <20200224131510.20608-12-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/cifssmb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2cf74028ce70..1ede3a5c6889 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -129,7 +129,7 @@ static int
 cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 {
 	struct cifs_tcon_reconnect_params params = {
-		.skip_reconnect = false,
+		.start_timer = true,
 	};
 
 	/*
@@ -662,6 +662,12 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "In echo request\n");
 
+	if (server->tcpStatus == CifsNeedNegotiate) {
+		/* No need to send echo on newly established connections */
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		return rc;
+	}
+
 	rc = small_smb_init(SMB_COM_ECHO, 0, NULL, (void **)&smb);
 	if (rc)
 		return rc;
-- 
2.17.1

