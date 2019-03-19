Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF64C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 05:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8076320857
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 05:07:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvINq5+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbfCSFHS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 01:07:18 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:41704 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfCSFHS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 19 Mar 2019 01:07:18 -0400
Received: by mail-pf1-f176.google.com with SMTP id d25so12856297pfn.8
        for <linux-cifs@vger.kernel.org>; Mon, 18 Mar 2019 22:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ILg2ptGpTxHzYrWdHcVNCWBOX1d5ysnWOQFA4zc1Puc=;
        b=DvINq5+ccPPpm4LbQve3xO72YscnJEO/0Z39UNHA4DNF1QdpAEIkeoFONyHhg+KN2E
         yqqHSWLXWiFhGcT0oJ0Ahouxv5j4kXLw3qDqySRA7I01FbufzmJG+ckV910TiEuePGRv
         HlYP8gry9wR/vBEjwHFTGZpSSlmpSIgYNKJ2pfftZJ0h9DcEsKfjG3KtuGQdTM1iGtaQ
         NlgRB2EA1T+Wzv85tZpkzF+NLhN+b4Lbl2unbuFEH6gjXiENYkC8Afcw9XpR7YXsyuel
         ggq/saUjUDgDA5351KJnVqKmOtGGneWs9g0gRn9f+bHQi/e4Jsk273OnKVRzawqPENvG
         3/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ILg2ptGpTxHzYrWdHcVNCWBOX1d5ysnWOQFA4zc1Puc=;
        b=HAwh7hKCYQGO0wTyLGqqTvsdTtswRd0kY3Twdq9anSeLEqhl7ENDXa/6/dcpfy2ZeI
         j8nCbwB65VITbJCjwlqFJfKqRc7xVod+nFNbuXIJaGDWFJ0S+J/R4WcKgVGdddJ0As9A
         9H+FzalQTIsrjCMejcC8mwqXclB1jTQjNYEJCRP/0QVhtTh2KpFadDSgkDMcJEazy1CA
         wi5F4YTOxzdXZEtWXRilFz+ij1dbCvhzUaR5C9Ltsgs5/GKmNrPJRVbPJXyTt27NVxVx
         1HTwsMUMRH7dDFyp59nMKHswcPfH7zYpt6To6eDxr/ztxuVlW07FN3skGCXOgqcU4IUp
         U5pg==
X-Gm-Message-State: APjAAAVfQaxEF9K/eo1/hz7Ec1sZ4CxSZ1GgN3jrnDJ22T77WG6a6Jta
        GR9hRtwzHYU+nCVBFfTn2q1+xxY7pZEp7rN54w1fqT7A
X-Google-Smtp-Source: APXvYqx1KHE5SgdD+vEFe5zwBGLfoob8lvL1UKMXA/S8GNU3/5bITayoJV/qH1XeOrejrveJFf8pUXc3IuLoCwfsPuQ=
X-Received: by 2002:a63:540c:: with SMTP id i12mr74510pgb.69.1552972037674;
 Mon, 18 Mar 2019 22:07:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 19 Mar 2019 00:07:06 -0500
Message-ID: <CAH2r5mvrw8X-t4ojH-3LsQfrwJpFfUB8QgVWPrT2hGtwMjCTTQ@mail.gmail.com>
Subject: FIFOs in "Services for Unix" format in Windows
To:     CIFS <linux-cifs@vger.kernel.org>, mkoeppe@gmx.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Found a note from Martin Koeppe from about 13 years ago which
mentioned the format of FIFOs in Windows's older 'Service for Unix'
format (cifs.ko enables this by mount option 'sfu').   The other parts
of this (device and char files for examples are implemented in
cifs.ko's 'sfu' mount option), but not FIFOs.
Excerpt from Martin's note follows:
             ---------------------------------------------
addressing the "missing feature p)" in TODO, I found out,
how special files are stored by SFU/Interix. It's rather simple,
and no extended attributes are needed. You can (theoretically)
create such files with simple DOS commands.

1. FIFOs:
If a file has 0 bytes and has the System attribute set,
Interix considers it as a FIFO special file.
<snip>

Wonder why we implemented the other parts of this (in cifs.ko) but not FIFOs?
-- 
Thanks,

Steve
