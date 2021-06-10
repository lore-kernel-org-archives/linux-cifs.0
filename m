Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66459C47094
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Jun 2021 16:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D93C60FDA
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Jun 2021 16:46:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhFJQsK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Jun 2021 12:48:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58297 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbhFJQsG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Jun 2021 12:48:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lrNoh-0003Ye-TB; Thu, 10 Jun 2021 16:46:04 +0000
From:   Colin King <colin.king@canonical.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-cifsd-devel@lists.sourceforge.net
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] cifsd: fix kfree of uninitialized pointer oid
Date:   Thu, 10 Jun 2021 17:46:03 +0100
Message-Id: <20210610164603.554691-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently function ksmbd_neg_token_init_mech_type can kfree an
uninitialized pointer oid when the call to asn1_oid_decode fails
when vlen is out of range. All the other failure cases in
function asn1_oid_decode set *oid to NULL on an error, so fix the
issue by ensuring the vlen out of range error also nullifies the
pointer.

Fixes: 8bae4419ce63 ("cifsd: add goto fail in neg_token_init_mech_type()")
Addresses-Coverity: ("Uninitialized pointer read")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 fs/cifsd/asn1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifsd/asn1.c b/fs/cifsd/asn1.c
index 2c63a3e5618b..b014f4638610 100644
--- a/fs/cifsd/asn1.c
+++ b/fs/cifsd/asn1.c
@@ -66,7 +66,7 @@ static bool asn1_oid_decode(const unsigned char *value, size_t vlen,
 
 	vlen += 1;
 	if (vlen < 2 || vlen > UINT_MAX / sizeof(unsigned long))
-		return false;
+		goto fail_nullify;
 
 	*oid = kmalloc(vlen * sizeof(unsigned long), GFP_KERNEL);
 	if (!*oid)
@@ -102,6 +102,7 @@ static bool asn1_oid_decode(const unsigned char *value, size_t vlen,
 
 fail:
 	kfree(*oid);
+fail_nullify:
 	*oid = NULL;
 	return false;
 }
-- 
2.31.1

