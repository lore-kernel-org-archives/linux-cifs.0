Return-Path: <SRS0=C86/=DB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 190BEC4363D
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Sep 2020 00:36:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C80602176B
	for <linux-cifs@archiver.kernel.org>; Thu, 24 Sep 2020 00:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="cbiF+lyq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgIXAgz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Sep 2020 20:36:55 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:17217 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXAgv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Sep 2020 20:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600907811; x=1632443811;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ZLtcKnkW1hgaXo6LlKs3XfJcfQeYRx1KJ76Vj1DJQqQ=;
  b=cbiF+lyqFCfOS6p7hGuiM390CCBuoulzfeHHx7StHiozCcMoE2k2kqfm
   u3lsEP+WIyEPulmFSw/uHpc6jfrXIqDT8pXXQ4+YZrZf+9ww7ks7Nv68S
   s4x2Bx7NMtcz3iiIuD5seaYLsnaixE2GyOcSYyltDXtl0czv4q5ka0Nvj
   4=;
X-IronPort-AV: E=Sophos;i="5.77,296,1596499200"; 
   d="scan'208";a="78792326"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 24 Sep 2020 00:36:46 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 21AF9C0AAA;
        Thu, 24 Sep 2020 00:36:44 +0000 (UTC)
Received: from EX13D11UEE004.ant.amazon.com (10.43.62.104) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 24 Sep 2020 00:36:44 +0000
Received: from EX13MTAUEE002.ant.amazon.com (10.43.62.24) by
 EX13D11UEE004.ant.amazon.com (10.43.62.104) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 24 Sep 2020 00:36:43 +0000
Received: from dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (10.1.57.236)
 by mail-relay.amazon.com (10.43.62.224) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Thu, 24 Sep 2020 00:36:44 +0000
Received: by dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (Postfix, from userid 5360108)
        id 1EF97ADC0A; Thu, 24 Sep 2020 00:36:44 +0000 (UTC)
From:   Boris Protopopov <pboris@amazon.com>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        "Boris Protopopov" <pboris@amazon.com>
Subject: [PATCH] Convert trailing spaces and periods in path components
Date:   Thu, 24 Sep 2020 00:36:38 +0000
Message-ID: <20200924003638.2668-1-pboris@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When converting trailing spaces and periods in paths, do so
for every component of the path, not just the last component.
If the conversion is not done for every path component, then
subsequent operations in directories with trailing spaces or
periods (e.g. create(), mkdir()) will fail with ENOENT. This
is because on the server, the directory will have a special
symbol in its name, and the client needs to provide the same.

Signed-off-by: Boris Protopopov <pboris@amazon.com>
---
 fs/cifs/cifs_unicode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 498777d859eb..9bd03a231032 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		else if (map_chars == SFM_MAP_UNI_RSVD) {
 			bool end_of_string;
 
-			if (i == srclen - 1)
+			/**
+			 * Remap spaces and periods found at the end of every
+			 * component of the path. The special cases of '.' and
+			 * '..' do not need to be dealt with explicitly because
+			 * they are addressed in namei.c:link_path_walk().
+			 **/
+			if ((i == srclen - 1) || (source[i+1] == '\\'))
 				end_of_string = true;
 			else
 				end_of_string = false;
-- 
2.18.4

