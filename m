Return-Path: <SRS0=Llk7=DC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06EAC4346E
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 01:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571542083B
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 01:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=meltin.net header.i=@meltin.net header.b="DhZ5MdTs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgIYBcG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Sep 2020 21:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYBcF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 24 Sep 2020 21:32:05 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA49C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 24 Sep 2020 18:32:05 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4ByDss4hjkz9sSJ;
        Fri, 25 Sep 2020 11:32:01 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=meltin.net; s=202004;
        t=1600997521; bh=B1gDqm6X860KDYsF37E54Nv4HdBvz+r/6OIzO1w3HSM=;
        h=Date:From:To:Subject:From;
        b=DhZ5MdTsC8T+ovxkKQs7I+MY4yP74Qn5pMh8REFkmu7SonfgzuZ7j0dYUExYoJhbB
         lLyJ10JyXBNEfG7xaYlptSFYMsZGREn99hUkNWb5WxblElzkU5/DCmzHHq7PtvNcAK
         duku/0MkqBOclo6cGEHnkw0/m1doUE86LQhz1fCbSX7DOIASqINffOvmOhnlsDInRa
         8CSofsp+aAhVQRCdjKN+9n7XMvJoQoZKPnQ3HDhw5FNIVMIqGCRTKnu8bmOv57V2gs
         UoiS8m77vpAaNmt2QAyGrIdpv+nwkfPNs6HnAs7klwTg+efGuVac/9kvxmakrKYVDB
         GaEZOvcw0qElQ==
Date:   Fri, 25 Sep 2020 11:32:00 +1000
From:   Martin Schwenke <martin@meltin.net>
To:     linux-cifs@vger.kernel.org
Subject: [PATCH] mount.cifs: ignore comment mount option
Message-ID: <20200925113200.371db298@martins.ozlabs.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/zYa2VsE/VS43kWB_AshZQU1"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--MP_/zYa2VsE/VS43kWB_AshZQU1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mount.cifs currently complains about the "comment" option:

  CIFS: Unknown mount option "comment=foo"

mount(8) on Linux says:

  The command mount does not pass the mount options unbindable,
  runbindable, private, rprivate, slave, rslave, shared, rshared,
  auto, noauto, comment, x-*, loop, offset and sizelimit to the
  mount.<suffix> helpers.

So if mount.cifs decides to re-read /etc/fstab it should ignore the
comment option.

A lot of online posts say to use comment=x-gvfs-show as an option to
have a Linux file manager display a mountpoint for a user mountable
filesystem.  While the "comment=" part is superfluous when combined
with an x-* option, the problem is still difficult to debug.

Patch attached...

peace & happiness,
martin

--MP_/zYa2VsE/VS43kWB_AshZQU1
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-mount.cifs-ignore-comment-mount-option.patch

From 97a071f7f1bf5274c027ee92fc0f6ca629ecdd65 Mon Sep 17 00:00:00 2001
From: Martin Schwenke <martin@meltin.net>
Date: Fri, 25 Sep 2020 11:16:39 +1000
Subject: [PATCH] mount.cifs: ignore comment mount option

mount.cifs currently complains about the "comment" option:

  CIFS: Unknown mount option "comment=foo"

mount(8) on Linux says:

  The command mount does not pass the mount options unbindable,
  runbindable, private, rprivate, slave, rslave, shared, rshared,
  auto, noauto, comment, x-*, loop, offset and sizelimit to the
  mount.<suffix> helpers.

So if mount.cifs decides to re-read /etc/fstab it should ignore the
comment option.

A lot of online posts say to use comment=x-gvfs-show as an option to
have a Linux file manager display a mountpoint for a user mountable
filesystem.  While the "comment=" part is superfluous when combined
with an x-* option, the problem is still difficult to debug.

Signed-off-by: Martin Schwenke <martin@meltin.net>
---
 mount.cifs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mount.cifs.c b/mount.cifs.c
index 4feb397..5d43c00 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -777,6 +777,8 @@ static int parse_opt_token(const char *token)
 		return OPT_BKUPGID;
 	if (strcmp(token, "nofail") == 0)
 		return OPT_NOFAIL;
+	if (strcmp(token, "comment") == 0)
+		return OPT_IGNORE;
 	if (strncmp(token, "x-", 2) == 0)
 		return OPT_IGNORE;
 	if (strncmp(token, "snapshot", 8) == 0)
-- 
2.28.0


--MP_/zYa2VsE/VS43kWB_AshZQU1--
