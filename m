Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8F7C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Sep 2021 00:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBC060E74
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Sep 2021 00:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245324AbhICAB1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 20:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232087AbhICAB1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Sep 2021 20:01:27 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22ECC061575
        for <linux-cifs@vger.kernel.org>; Thu,  2 Sep 2021 17:00:27 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id m4so6718829ljq.8
        for <linux-cifs@vger.kernel.org>; Thu, 02 Sep 2021 17:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0oIehYRhPCdKbQvgSbubi5fd64Du+rg7Kofv777bWg=;
        b=l3+8PaMBe1Zg1OC3PjjFjCH2OuLe7GJaTQIP3ZbhNdNLB98pDd2p2zkxWqThCnmPU8
         lg1m5hjW1H+M8BbLHvQ4Mhc+HgRf2A53Q+wmbGFuQBM+aCzef2qVNURnAwRkfAIVg0Lg
         YJ32UFkimtcyB7FXFdHUw9CGZNbevWA0fegBWEJx70lSbiFKeVHjdhs0MPBfLgx52Lxa
         GPXB1nz4/hMx2+Y3k2GkHmoSkpWcvILpV9RPABdc+UXYjtl0qwU7AzXHj+D7yRGop938
         rIsIou0Aej1Y5ZARXEwVCdW7Q84psaiGNzdjs3Ij9trBUAnDmQf4D8TQtsSTE1ytGGKV
         hmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0oIehYRhPCdKbQvgSbubi5fd64Du+rg7Kofv777bWg=;
        b=eIyd9ae5BWoV88UxCa/09gyaeMCaNcxv/LRkeW4hDeYnWgzB9cGlfxLIsRlEtJ8B4p
         vAL3UGYlQDgzN0y2Hu7WZIpB/Ix9uy4WyaWq2nfMOCOlSHcTPv+riNFWiMX9o6PGS8Fk
         u8dbKyrxcPGp4YlKEU4230qv2fEvgbMFNk5WLRgWy1Nte+cXJZ1ZN4aoPBegKEjavfjc
         wLWUD801/76dJeMrVvLJM9urZMQQmcsn02YWWlOc/s77xIHlGzgc6WhkO854TqmmL3yK
         RcbFNVHKKddHSSBKRDQfvwKTS5NxMFEbwrh+9DD1Id2kbR3tIfMcnm/TqOlHAS2p9MOL
         xS3Q==
X-Gm-Message-State: AOAM5311AJ0ELrPzG+UfA9qE2jQt65dmPFuXO1Po49Q67AYAWHpfuV6T
        RHNUOVtMWaCg+AG878PFR7KKT8/lxcawDn7ThfQi09KIt9s=
X-Google-Smtp-Source: ABdhPJxLijgp7q4dqHFnztVgY3Ql+6P5Bd8k3x9cI0JDuW0zDs86xUnpzHf7NxBRoUxKTgnzpImWtXr6KTswKAY2ZTc=
X-Received: by 2002:a05:651c:113b:: with SMTP id e27mr762978ljo.6.1630627226069;
 Thu, 02 Sep 2021 17:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210902233716.1923306-1-lsahlber@redhat.com>
In-Reply-To: <20210902233716.1923306-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 2 Sep 2021 19:00:15 -0500
Message-ID: <CAH2r5muXpRLNFPisye2NVHa1_G3U6BacZz75P9=kDmZH1Z9n7Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: create a common smb2pdu.h for client and server
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The smbfsctl.h should also be easy to move ... but the obvious
question is whether "common" headers belong in "fs/cifs_common" or in
include/linux ...
(as e.g. nfs does with common headers between server and client)

On Thu, Sep 2, 2021 at 6:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve,
>
> Here is an initial set of patches that starts moving SMB2 PDU definitions
> from the client/server into a shared smb2pd.h file.
>
> It moves the command opcode values into cifs_common,
> it renames cifs smb2_sync_hdr to smb2_hdr to harmonize with ksmbd naming
> and it moves the tree connect and disconnect PDU definitions to the shared
> file.
>
>
>


-- 
Thanks,

Steve
