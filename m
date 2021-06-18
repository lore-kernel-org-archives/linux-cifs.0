Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971C1C2B9F4
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 00:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7252A60BBB
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 00:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbhFRBAt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Jun 2021 21:00:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233042AbhFRBAs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Jun 2021 21:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623977920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PPCsAmdOpMxMgKyLhthboiHE+4wrc5tU8EfmGqXZN1k=;
        b=GWKqZvIXSQYAI/tTxuII3ivDzZRGy3XZpyL9OxJuXsS/ypMUBpaitX6XLkQAnso45gdlVC
        3Z5qJ1gmttRuDWO8d2C4vr1hoQJQzkj0HGGSghono8bOsqqE7YXFLfHb192JzAGd465Iar
        4Nipwa2K1GtgahmaZYql/TQglTFrtKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-03RSU6ZfM0mugLmk-hY7Gw-1; Thu, 17 Jun 2021 20:58:38 -0400
X-MC-Unique: 03RSU6ZfM0mugLmk-hY7Gw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7392E1084F40;
        Fri, 18 Jun 2021 00:58:37 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-174.bne.redhat.com [10.64.54.174])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCF445C22A;
        Fri, 18 Jun 2021 00:58:36 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: avoid extra calls in posix_info_parse
Date:   Fri, 18 Jun 2021 10:58:30 +1000
Message-Id: <20210618005830.1819887-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In posix_info_parse() we call posix_info_sid_size twice for each of the owner and the group
sid. The first time to check that it is valid, i.e. >= 0 and the second time
to just pass it in as a length to memcpy().
As this is a pure function we know that it can not be negative the second time and this
is technically a false warning in coverity.
However, as it is a pure function we are just wasting cycles by calling it a second time.
Record the length from the first time we call it and save some cycles as well as make
Coverity happy.

Addresses-Coverity-ID: 1491379 ("Argument can not be negative")

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c205f93e0a10..4a244cc4e902 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4498,7 +4498,7 @@ int posix_info_parse(const void *beg, const void *end,
 
 {
 	int total_len = 0;
-	int sid_len;
+	int owner_len, group_len;
 	int name_len;
 	const void *owner_sid;
 	const void *group_sid;
@@ -4521,17 +4521,17 @@ int posix_info_parse(const void *beg, const void *end,
 
 	/* check owner sid */
 	owner_sid = beg + total_len;
-	sid_len = posix_info_sid_size(owner_sid, end);
-	if (sid_len < 0)
+	owner_len = posix_info_sid_size(owner_sid, end);
+	if (owner_len < 0)
 		return -1;
-	total_len += sid_len;
+	total_len += owner_len;
 
 	/* check group sid */
 	group_sid = beg + total_len;
-	sid_len = posix_info_sid_size(group_sid, end);
-	if (sid_len < 0)
+	group_len = posix_info_sid_size(group_sid, end);
+	if (group_len < 0)
 		return -1;
-	total_len += sid_len;
+	total_len += group_len;
 
 	/* check name len */
 	if (beg + total_len + 4 > end)
@@ -4552,10 +4552,8 @@ int posix_info_parse(const void *beg, const void *end,
 		out->size = total_len;
 		out->name_len = name_len;
 		out->name = name;
-		memcpy(&out->owner, owner_sid,
-		       posix_info_sid_size(owner_sid, end));
-		memcpy(&out->group, group_sid,
-		       posix_info_sid_size(group_sid, end));
+		memcpy(&out->owner, owner_sid, owner_len);
+		memcpy(&out->group, group_sid, group_len);
 	}
 	return total_len;
 }
-- 
2.30.2

