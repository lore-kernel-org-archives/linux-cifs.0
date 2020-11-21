Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25427C388F9
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Nov 2020 11:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A116020732
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Nov 2020 11:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgKULS2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Nov 2020 06:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbgKULS1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Nov 2020 06:18:27 -0500
X-Greylist: delayed 380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 Nov 2020 03:18:27 PST
Received: from mail.archlinux.org (mail.archlinux.org [IPv6:2a01:4f9:c010:3052::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D632C0613CF
        for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2020 03:18:27 -0800 (PST)
Received: from mail.archlinux.org (localhost [127.0.0.1])
        by mail.archlinux.org (Postfix) with ESMTP id 58D6B23A911;
        Sat, 21 Nov 2020 11:12:06 +0000 (UTC)
From:   Jonas Witschel <diabonas@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=archlinux.org;
        s=mail; t=1605957126;
        bh=Sc1q0JViwidBv8pj7NcKF86KTr1AD+dIct32kmAbf+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=nP96ONqMyrGXhKxWlGKcwG1fz9hLJXTGEjj3qx4v440IuerDriv2YKSpV0iR9Q5ng
         q1bzYnsGXlqXpYAgsQLhcWeDBWFilNiqaY2OU3i6te7PZ4TJVIFyuqxtZMRcFwAsI0
         uVweNqCk2+zGR+aQl4V5nZVx6bgGDxSaEEBN3T2fZqk1+GfAVIJNYQ/yUMRlrxmq6c
         rbDwUy3PTNhhOsrGVWMCZf7wFAc4/kpur0rGt9kTst8YRP4LKI4WekRJETuRvD5adm
         8KLlJFVxPoN+joBlxma3aPHTI2tw1JUPxF3LZM/GWL8bQ+0ARmAhp0RaXfU64Oqs1L
         GonECAOK2GWXukfJhPaWWkdWmb76epYk3DOBGKAviGoJ8WnSBtxVpHMlTflnXcbb9V
         2MVnJURssBjFQCK7ErejGLfwVaFYK5Vm29T5cbUAOWpzzDIeFsvxIzrM3UOlZObwGS
         8LX7G+ezViDTbMqguRk5EhaW1AhvtSOxQfowkXdhbwvpZf0zWGQrAaWjfYOOReAs7w
         +Jj9csl9vHyFs8W6wRH5Tc7QDHlm79QdjHAjlu9PiMhHmm7OObTsTKGKFQLjAX3gDq
         ysU4GKKTXgki4li0Vbli6EOISmbfRQl4Zd5Ya7S9C90xhB/71HV/jaZE25GQ2ltTYK
         proJFynWUfwV9moFpo86bjqE=
To:     linux-cifs@vger.kernel.org
Cc:     Jonas Witschel <diabonas@archlinux.org>
Subject: [PATCH 2/2] cifs.upall: update the cap bounding set only when CAP_SETPCAP is given
Date:   Sat, 21 Nov 2020 12:11:45 +0100
Message-Id: <20201121111145.24975-3-diabonas@archlinux.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201121111145.24975-1-diabonas@archlinux.org>
References: <20201121111145.24975-1-diabonas@archlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

libcap-ng 0.8.1 tightened the error checking on capng_apply, returning an error
of -4 when trying to update the capability bounding set without having the
CAP_SETPCAP capability to be able to do so. Previous versions of libcap-ng
silently skipped updating the bounding set and only updated the normal
CAPNG_SELECT_CAPS capabilities instead.

Check beforehand whether we have CAP_SETPCAP, in which case we can use
CAPNG_SELECT_BOTH to update both the normal capabilities and the bounding set.
Otherwise, we can at least update the normal capabilities, but refrain from
trying to update the bounding set to avoid getting an error.

Signed-off-by: Jonas Witschel <diabonas@archlinux.org>
---
 cifs.upcall.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 1559434..af1a0b0 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -88,6 +88,8 @@ typedef enum _sectype {
 static int
 trim_capabilities(bool need_environ)
 {
+	capng_select_t set = CAPNG_SELECT_CAPS;
+
 	capng_clear(CAPNG_SELECT_BOTH);
 
 	/* SETUID and SETGID to change uid, gid, and grouplist */
@@ -105,7 +107,10 @@ trim_capabilities(bool need_environ)
 		return 1;
 	}
 
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
