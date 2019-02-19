Return-Path: <SRS0=jMYF=Q2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6541CC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 01:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391D7217D9
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Feb 2019 01:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbfBSBnp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Feb 2019 20:43:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732665AbfBSBnp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 18 Feb 2019 20:43:45 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7B7E11B793;
        Tue, 19 Feb 2019 01:43:45 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.1.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50DAC5D717;
        Tue, 19 Feb 2019 01:43:44 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, smfrench@gmail.com
Subject: [PATCH] getcifsacl: Do not go to parse_sec_desc if getxattr fails.
Date:   Tue, 19 Feb 2019 07:13:43 +0530
Message-Id: <20190219014343.29526-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 19 Feb 2019 01:43:45 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add more to the error message by printing the filename and error.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 getcifsacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index f08cdea..7f6e673 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -399,7 +399,12 @@ cifsacl:
 			bufsize += BUFSIZE;
 			goto cifsacl;
 		} else
-			printf("getxattr error: %d\n", errno);
+		{
+			fprintf(stderr, "getxattr failed on %s: %s\n", filename, strerror(errno) );
+			free(attrval);
+			ret = -1;
+			goto out;
+		}
 	}
 
 	parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
-- 
2.20.1

