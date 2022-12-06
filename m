Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853E8C4708C
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Dec 2022 01:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiLFBN7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Dec 2022 20:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbiLFBN6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Dec 2022 20:13:58 -0500
Received: from sender4-of-o54.zoho.com (sender4-of-o54.zoho.com [136.143.188.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B31EC44
        for <linux-cifs@vger.kernel.org>; Mon,  5 Dec 2022 17:13:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1670289227; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=HvY68duDqFiPRrfJZhjPRpWlEXx87dV69po3uV+GHWuYNlCFviY+Rw8liXpkhU3J+2HM1tYOYV/z+UagQle2cjW5kRsaRbcc/s56vpQ3rqcv+3BOkr7K5h1evy2Wgz8KXU3jAuSRYEtAjcVQTJ1w07vP335c1xc19ThvjInsLZ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1670289227; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=DQBxAls7om1tGpaxotFZTf6IAJJsu6taovLcsDSY21c=; 
        b=XRS9RoxSpGSTyobCHU2eswHUJD+D1jgFdgQKBndsgRnFkbo1M0HP/SjUTxVilkZIWL1G9YQEAAZfFb8S+va9XBS98kbkJLpKQnJPfmSiU6fmQES4Pbwum4FwNewDcYKycwlt57F9hPDtCgz6jO7dJc/ch60jqCxgLXmg+avsjYI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=business@elijahpepe.com;
        dmarc=pass header.from=<business@elijahpepe.com>
Received: from mail.zoho.com by mx.zohomail.com
        with SMTP id 1670289225405698.2931764119958; Mon, 5 Dec 2022 17:13:45 -0800 (PST)
Date:   Mon, 05 Dec 2022 17:13:45 -0800
From:   Elijah Conners <business@elijahpepe.com>
To:     "samba-technical" <samba-technical@lists.samba.org>,
        "linux-cifs" <linux-cifs@vger.kernel.org>
Cc:     "tom" <tom@talpey.com>, "pc" <pc@cjr.nz>,
        "sfrench" <sfrench@samba.org>, "sprasad" <sprasad@microsoft.com>,
        "lsahlber" <lsahlber@redhat.com>
Message-ID: <184e4fef6ac.ef8cabb03371505.6462526642609891535@elijahpepe.com>
In-Reply-To: <184e4ae599e.dafedd623365931.2204914765704117230@elijahpepe.com>
References: <184e4ae599e.dafedd623365931.2204914765704117230@elijahpepe.com>
Subject: [PATCH] cifs: fix tabbing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Elijah Conners <business@elijahpepe.com>
---
 fs/cifs/cifsroot.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsroot.c b/fs/cifs/cifsroot.c
index f0aba7c824dc..46aaa731723d 100644
--- a/fs/cifs/cifsroot.c
+++ b/fs/cifs/cifsroot.c
@@ -37,9 +37,9 @@ static void __init parse_srvaddr(char *start, char *end, struct in6_addr *out6,
 	addr[i] = '\0';
 
 	if (inet_pton(AF_INET6, addr, &in6) > 0) {
-    *out6 = in6;
-  } else {
-    *out32 = in_aton(addr);
+		*out6 = in6;
+	} else {
+		*out32 = in_aton(addr);
   }
 }
 
-- 
2.29.2.windows.2



