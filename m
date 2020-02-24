Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A908C11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EA7A20828
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="evV/kRFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbgBXNQA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:16:00 -0500
Received: from hr2.samba.org ([144.76.82.148]:41900 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727299AbgBXNP7 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:15:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=Lnzk87gzlPDD2Ke8eoX8So/Qf8ffZufw/NezDqjHb7Y=; b=evV/kRFAi7dm0GyIe9s2WxTWNV
        MDzupPqXFxiuAKfGybrdZ9gMEzZAl6Xjh/azNY386ZXPQwTLv98CvyhM0XiarVBRgZDq8vN4D1nAD
        THj5//nSQqHVKti9JhJzhIHqMELVdil43fWlhD+jCdLBvzbxlKrMWjA19D9O4iVh3wbKggNvH+OaX
        oCikVRdH7IRJaXENkYovIkWzDHpsha6N4siBNsEl8yn/fyw7HgPjUwQHMoWMEKh2W4aOhZ9nWiWCs
        dKRVYHLRFyicfTs9fZ/wtOB0p3WZLQh0H68N2Zbpu8rQjQNdV6m0k/xLeJ3SoT54x5ny6cxoP1xml
        BbIRBlQwaJwUpWA7pV79fez0zEPOlSCQNd9rI+1vcZ4deSjMc5S6O9p03iZwX6ENXCZhIBKFhVnF4
        FOE0kQcu32j/azkYFQo4xsdkCri2gmcXrDTrVW4xcpDghZyEb1Aqp7CP9WDSlpqm9E9X8DEf828vG
        j1ts967OKA3DMSPMy1YjZxTy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaP-00061e-Ov; Mon, 24 Feb 2020 13:15:49 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 02/13] cifs: use mod_delayed_work() for &server->reconnect if already queued
Date:   Mon, 24 Feb 2020 14:14:59 +0100
Message-Id: <20200224131510.20608-3-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

mod_delayed_work() is safer than queue_delayed_work() if there's a
chance that the work is already in the queue.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1234f9ccab03..2495c3021772 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -378,7 +378,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon)
 	}
 
 	if (smb2_command != SMB2_INTERNAL_CMD)
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 
 	atomic_inc(&tconInfoReconnectCount);
 out:
@@ -3558,7 +3558,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 
 	if (server->tcpStatus == CifsNeedNegotiate) {
 		/* No need to send echo on newly established connections */
-		queue_delayed_work(cifsiod_wq, &server->reconnect, 0);
+		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		return rc;
 	}
 
-- 
2.17.1

