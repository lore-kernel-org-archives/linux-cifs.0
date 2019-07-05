Return-Path: <SRS0=j5Ui=VC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49880C46499
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 20:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AB3B20856
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 20:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfGEUnR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 16:43:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60534 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfGEUnR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Jul 2019 16:43:17 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C05EE3082199;
        Fri,  5 Jul 2019 20:43:17 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-27.bne.redhat.com [10.64.54.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55683171AC;
        Fri,  5 Jul 2019 20:43:17 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: always add credits back for unsolicited PDUs
Date:   Sat,  6 Jul 2019 06:43:08 +1000
Message-Id: <20190705204308.10039-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 05 Jul 2019 20:43:17 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

not just if CONFIG_CIFS_DEBUG2 is enabled.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8c4121da624e..11adca981263 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1221,11 +1221,11 @@ cifs_demultiplex_thread(void *p)
 					 atomic_read(&midCount));
 				cifs_dump_mem("Received Data is: ", bufs[i],
 					      HEADER_SIZE(server));
+				smb2_add_credits_from_hdr(bufs[i], server);
 #ifdef CONFIG_CIFS_DEBUG2
 				if (server->ops->dump_detail)
 					server->ops->dump_detail(bufs[i],
 								 server);
-				smb2_add_credits_from_hdr(bufs[i], server);
 				cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 			}
-- 
2.13.6

