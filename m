Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB05CC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 21:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 920A720854
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 21:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rf/+WRrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfCMVxh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 17:53:37 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:45097 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfCMVxh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 17:53:37 -0400
Received: by mail-pg1-f171.google.com with SMTP id 125so2440928pgc.12;
        Wed, 13 Mar 2019 14:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6eCsmeoAoFlU+udQMKiADuIbR+nVv1uwRiLFljK6kSQ=;
        b=rf/+WRrDGTv5SacBVVcd8F/3eaR0OTCDcwHl2sLDE81Jcu7/Sof/EToCQFg9l0kBHQ
         giTqymVeFLqIVChlFpiyNVSk01W/OJyWOFbNpqiMF6UdOF7CpS97HEbcoVxgFvrHkI3A
         qExWDbLY0x38C30P936ez3PWDnfbSHoMoG9wvNAK8wFjqyQ3ubUS6Ad3XtNt9Ezd55N6
         fsdf+ImVWIeaKxB8QmXgnMPlh+htUxxw2lry8yn1aZ0NTi8x14Km9bhgMfER562l2uMU
         YysLwCGO8dtGBcOrjpuKFyUTrcxp0OczFi1yOuEz4jWWFLtucD6iczh/u8MXhG7whvpv
         UW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6eCsmeoAoFlU+udQMKiADuIbR+nVv1uwRiLFljK6kSQ=;
        b=GoiYaoyyq6wA5fmdQ6WfzUpKwX8RDpZnPNmhGtwa3OxRTz1Yp48gWdzD3FbB0zu3kk
         d/RMqOHeue3qLVZTFjp2LL1YU6bPeefVhCGQlftZEu9kdHEvziJQLNOzmisQY5U39Ibp
         R/aTse6V+xGO1uBTobWnVrlh1yQsYYT6yd14kIPTjWOYQVelhln+TOBKTNLEAb6BDU1Q
         TnaIywPkTdAQd8NHOe0AXEbNZ2hZvDXd+YTBtGaE1y2tkUvS24MRZ42GwAdFdqYXzsln
         xBbacxp1LqSyP/Z7DN4NjoPD+oFRPt1xo26//C9NAgHJMw0CX8c5ieoTYH9oeiBTeQNB
         yUpA==
X-Gm-Message-State: APjAAAVbND8hMeulKxJZtVTebLSRm8fvu5OkZ8/6JX1MtdWaBl6PmSW9
        0TAKAzAkYfsLApfwkyEybcotkmKsqFc3fpAkQ48fjxRr
X-Google-Smtp-Source: APXvYqyh9Bj35JCpeAhccUx6peGH1wax+N+fvUHrvvY+GBvZ0Do/9EKYFBKzXlHChCLZdSTF41irBnoU7ONc/s+VYyU=
X-Received: by 2002:a63:2c50:: with SMTP id s77mr25188055pgs.440.1552514015827;
 Wed, 13 Mar 2019 14:53:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Mar 2019 16:53:24 -0500
Message-ID: <CAH2r5muaceyqkrbXB7Bt-qv_vtVqZEmpafJa6B2+8kyRsK7ftQ@mail.gmail.com>
Subject: [PATCH] [CIFS] Remove unneeded statements pointed out by Coverity
To:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs: remove unused value pointed out by Coverity

Detected by CoverityScan CID#1438719 ("Unused Value")

buf is reset again before being used so these two lines of code
are useless.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/connect.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index b95db2b593cb..a8e9738db691 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1191,10 +1191,6 @@ cifs_demultiplex_thread(void *p)
             continue;
         }

-        if (server->large_buf)
-            buf = server->bigbuf;
-
-
         server->lstrp = jiffies;

         for (i = 0; i < num_mids; i++) {

-- 
Thanks,

Steve
