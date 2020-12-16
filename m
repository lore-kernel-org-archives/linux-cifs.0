Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A5DC4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 21:46:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27578235E4
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 21:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgLPVqC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 16:46:02 -0500
Received: from mail.archlinux.org ([95.216.189.61]:33816 "EHLO
        mail.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgLPVqC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 16:46:02 -0500
From:   Jonas Witschel <diabonas@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
        s=dkim-rsa; t=1608155121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AEiKb/JRJV0yS2RKeqbKZzBzkokEUdaooFyhuVWctEI=;
        b=ZjyvAZoIbQAoynvbwu8tZtZqmbFPVnWYdE2/fbs1ro1gIr1F2blI3djmvnm/WlijHdIJaP
        URTKe96JX1D5nIS9lZiNu0FoCdjWk/Qz7kUnom3aliGdJEM2DTC7Sh36/LRHyR2KJ1gfIf
        ZYBintL+aCQgVgYCVDolMukZCZDhfEym6EUtwI1+Ou69tjEdVIPm3zrWmGAr/vzV4yb10U
        D/r2PnHaHuSIUltx56UpDqPi96p7+jzfZ4F+3BSfrbGNSsG6fN/QNcm80QKPjqmI6m1Tx7
        Mme9vZsQtm2K0e/eH3w9hDCfbfKNGjqpzMtFpFvlmyYEKEOQiZD+4VTbDoDQFkvI3koY66
        /wwwM/HbC/Ghh8oAf61TsFTnwVNcJVFYFuVUBPmveDfllz2h2BIVcxFFehoMh+fAxsvKD7
        5qGPRYB/yOhNQsUq5KJeR3yNoEMGTrVHXXVpOJG1iIP23DT1vtlfCurh94QEitzOOLboJt
        tQ5s3lVLoSTrqoWmh23WwZ0l1JUGRtC4lC7sLE+39uUJJfC7zdAU+rwrZgkDYoT3YUa8rA
        Qq+pziKzQAKd4K5jGrBxAEFds8Rc7wf99BcrdOTkgjitVSocT8xM55RBHi6+QWJdQ2oqBi
        tGF9iu8Zsyquve2dqAAYOAXqQouGDwJZru67+dOxRX7FyUzlMwPrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
        s=dkim-ed25519; t=1608155121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AEiKb/JRJV0yS2RKeqbKZzBzkokEUdaooFyhuVWctEI=;
        b=jpu9fYk8cLtFtzYlmIe6DozeuCGR77NFDRURQSir8iamYBkJQN7ZXs1WgxDv2KIHnk0pmQ
        3EoqOOxmAs8A+aDA==
To:     linux-cifs@vger.kernel.org
Cc:     Alexander Koch <mail@alexanderkoch.net>,
        Jonas Witschel <diabonas@archlinux.org>
Subject: [PATCH] cifs.upcall: drop bounding capabilities only if CAP_SETPCAP is given
Date:   Wed, 16 Dec 2020 22:44:56 +0100
Message-Id: <20201216214455.41251-1-diabonas@archlinux.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: mail.archlinux.org;
        auth=pass smtp.auth=diabonas smtp.mailfrom=diabonas@archlinux.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Alexander Koch <mail@alexanderkoch.net>

Make drop_call_capabilities() in cifs.upcall update the bounding capabilities
only if CAP_SETCAP is present.

This is an addendum to the patch recently provided in [1]. Without this
additional change, cifs.upcall can still fail while trying to mount a CIFS
network share with krb5:

  kernel: CIFS: Attempting to mount //server.domain.lan/myshare
  cifs.upcall[39484]: key description: cifs.spnego;0;0;39010000;ver=0x2;host=server.domain.lan>
  cifs.upcall[39484]: ver=2
  cifs.upcall[39484]: host=server.domain.lan
  cifs.upcall[39484]: ip=172.22.3.14
  cifs.upcall[39484]: sec=1
  cifs.upcall[39484]: uid=1000
  cifs.upcall[39484]: creduid=1000
  cifs.upcall[39484]: user=username
  cifs.upcall[39484]: pid=39481
  cifs.upcall[39484]: get_cachename_from_process_env: pathname=/proc/39481/environ
  cifs.upcall[39484]: get_cachename_from_process_env: cachename = FILE:/tmp/.krb5cc_1000
  cifs.upcall[39484]: drop_all_capabilities: Unable to apply capability set: Success
  cifs.upcall[39484]: Exit status 1

[1] https://marc.info/?l=linux-cifs&m=160595758021261

Signed-off-by: Alexander Koch <mail@alexanderkoch.net>
Signed-off-by: Jonas Witschel <diabonas@archlinux.org>
---
 cifs.upcall.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 1559434..b62ab50 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -115,8 +115,13 @@ trim_capabilities(bool need_environ)
 static int
 drop_all_capabilities(void)
 {
+	capng_select_t set = CAPNG_SELECT_CAPS;
+
 	capng_clear(CAPNG_SELECT_BOTH);
-	if (capng_apply(CAPNG_SELECT_BOTH)) {
+	if (capng_have_capability(CAPNG_EFFECTIVE, CAP_SETPCAP)) {
+		set = CAPNG_SELECT_BOTH;
+	}
+	if (capng_apply(set)) {
 		syslog(LOG_ERR, "%s: Unable to apply capability set: %m\n", __func__);
 		return 1;
 	}
-- 
2.29.2

