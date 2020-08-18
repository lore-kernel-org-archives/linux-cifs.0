Return-Path: <SRS0=r6gO=B4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FCBC433DF
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Aug 2020 16:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E53F52067C
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Aug 2020 16:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zm+u7wCD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHRQXs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Aug 2020 12:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHRQXq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Aug 2020 12:23:46 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9438CC061389
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2020 09:23:46 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id i10so11661543ybt.11
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2020 09:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iPBgFopQ3+bMRXYoduwmftt10LHiXfbg4VtRn0dy1ws=;
        b=Zm+u7wCDhR0eyJukkPg2HHp39X7HgvnZ+VvTZni5X/L8Do950deJ4Nkz57ux5+BiEc
         q4zhQBUXKGXadhfP09KnzoR4F6DwxenIDgx8FD1h+npQ2/qNn3qL++R9Sb2tsCIAs4r0
         kRXh68j5zedKt3TbbZoPzk8eGb/HSUQpYE5MCi2N8YMPTKVeB69IyLsywMZOfwBc9AQj
         1eZJsyEiHLRz+Y4uolP88VI59W6vnWfuuLFjt9tfM8Nn+Lp2YdQGh8ULObac7wR5C0zl
         5KSFuvX4B+L/z2N4Zvnk15RqrHdRC4Rbthg7zoAcSKG/BW7stXGdDMBMDj1POjlvRRZ1
         OAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iPBgFopQ3+bMRXYoduwmftt10LHiXfbg4VtRn0dy1ws=;
        b=BZoQiXefITspAWqY/L6im0FVCBc232PiYzdd5qyLNR3VVUuZOvtXXu16nUjSqm66lC
         mJzHoptpczinnBE7nIXNZSS+aMBWucI+suVf9d/AKzGXUc5SaqjlVV8OUUnb5Nk+coRr
         63f19KYQIOuw7vYaAT5S3mDIVtg29TjITEMpwnbGCTMUpFD6OKvG/6d10G592sAxsTcx
         yfRJVh7GcpeF4LNLQU7EURv4QWBSh+WQdJtJ5PkOg98GFAvf0thTOhHOUCji9Zvv3amK
         zI4Zf2OQgL7CTqbc7eUZbe7X7FjkeT8zTDpePt7j7A42S8ICZYmKZUeT8pKtfyu3Wkcj
         j1eg==
X-Gm-Message-State: AOAM532/OUOxHmgImhfGxTGnIyc8yyfRORzN2l00cfAu5ZOJOMdG6azz
        n/GkgbhnkqquE6fD3vsCsLSpeXm30h0uHU+OwG/lMSSCAWs=
X-Google-Smtp-Source: ABdhPJyuHEb57UNUufL/WP8XoROq9NubvDQeJ7MiN3K6lXbu22BWQzTHCplLr/YWihvUGR8LI7FX7ZqiRuuwwja+WIU=
X-Received: by 2002:a25:2b89:: with SMTP id r131mr27689025ybr.131.1597767825650;
 Tue, 18 Aug 2020 09:23:45 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 18 Aug 2020 21:53:34 +0530
Message-ID: <CANT5p=p55m0D2VsoXUPDw3qQmVHWKTVtcyZuf7sNAbsFCqEn2Q@mail.gmail.com>
Subject: [PATCH][SMB3] cifs: Fix unix perm bits to cifsacl conversion for
 "other" bits.
To:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

Recently, I hit a bug while testing out the cifsacl mount option. The
"other" bits were getting replicated to "owner" and "group" bits,
after sometime (I'm thinking after actimeo expires).

Attaching patch with fixes for perm bits to DACL mapping and reverse mapping.
Please review and let me know what you think.

As indicated in the commit message, there could be further
optimizations to reduce the number of ACEs in the file DACL. I've not
yet figured out a good way to figure out the more "restrictive" perm.
-- 
-Shyam
