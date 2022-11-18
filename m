Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7553AC43217
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Nov 2022 11:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbiKRLsI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Nov 2022 06:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241560AbiKRLsG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Nov 2022 06:48:06 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C733A9208A;
        Fri, 18 Nov 2022 03:48:05 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id 5so3469463wmo.1;
        Fri, 18 Nov 2022 03:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=puywXNDYXSd6DOzYL6X0dBASfGfJfFJZcaCdFAGPGnM=;
        b=qvEhemKuv1YTSZxdMmVZcpNGHK81orvQSg9IJ5zu5X6x5tRzk1B8xEB4iUUYhkLjMq
         xRHm9VeteUzX1f576K/0kPPiRiRjipG1h7ienao+bPQJJEGERMNQrVC7dbQxPX8bN5Lw
         5we3OaXp6iLAEKxuNQArLUlfJ9k6+iKMzcjW40nyV+R7Pj/tEceylVNekDvbmmOd5UsE
         xWjcMp5JmhfDKC31InI2fwBClseazQSDx1k7LWniQ7B935ZfT/H871PDeg1UCCyP55/k
         CjqbvqT4ecB8pYG6ii4Wf6bJJ1z2Sjyq1vsrHfDhkbD3On1dZs0gktCDHiOEExP7jnxm
         gAgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=puywXNDYXSd6DOzYL6X0dBASfGfJfFJZcaCdFAGPGnM=;
        b=WUcoYWgoNgjLFz4u1W8FtxJJ7tML2KwAMcf4BURog0u+katS7Fe6Ya1m1KS9pKVi/q
         ZyLLew19QuNo9QO/xT88I5vcuNcTfDszEWh4dMmQk7O0/mSY96y+J4Tb1Xoh5WkQ8mih
         /N6smICi6LecXBkC2wgRXf9QZFWzaEBjIduKsyB6qXOcEcEwrcQVbzB9YJxmE3c1GbNR
         XEU+FqPKPNjmY4DlDeX2h5UHEzwccCuJ0KhZ5GZz9Tp4+sBDsIA3KYiyMKHGlIwXll/C
         eaqU/yHRImcPeRYY85oCNt4/PyhRKumZRXIu+Msh/lKy8FqvaGlcEm0varesisx4GHh8
         OJ9g==
X-Gm-Message-State: ANoB5pkL2lrM5kNTL3ZI6tVSjY/QBQ3cDAyYXZjIlCsZ/2sm6ji3T8Oo
        O4AJDT5Sx8CSZKr76TlWVNJPAXeKR4N40A==
X-Google-Smtp-Source: AA0mqf5230MzRSqYS5Yekl4d3DsVgYyrbzvnhgwpOfs3v0u3hpStdf2fetzOeFKy5HoHQe7hQsUI/Q==
X-Received: by 2002:a05:600c:805:b0:3c6:c13f:1194 with SMTP id k5-20020a05600c080500b003c6c13f1194mr4588783wmp.132.1668772084119;
        Fri, 18 Nov 2022 03:48:04 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id he5-20020a05600c540500b003cfd4e6400csm4388203wmb.19.2022.11.18.03.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 03:48:03 -0800 (PST)
Date:   Fri, 18 Nov 2022 14:48:00 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steve French <sfrench@samba.org>
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: Use after free in debug code
Message-ID: <Y3dw8KLm7MDgACCY@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This debug code dereferences "old_iface" after it was already freed by
the call to release_iface().  Re-order the debugging to avoid this
issue.

Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/cifs/sess.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 92e4278ec35d..9e7d9f0baa18 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -302,14 +302,14 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 	/* now drop the ref to the current iface */
 	if (old_iface && iface) {
-		kref_put(&old_iface->refcount, release_iface);
 		cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
 			 &old_iface->sockaddr,
 			 &iface->sockaddr);
-	} else if (old_iface) {
 		kref_put(&old_iface->refcount, release_iface);
+	} else if (old_iface) {
 		cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
 			 &old_iface->sockaddr);
+		kref_put(&old_iface->refcount, release_iface);
 	} else {
 		WARN_ON(!iface);
 		cifs_dbg(FYI, "adding new iface: %pIS\n", &iface->sockaddr);
-- 
2.35.1

