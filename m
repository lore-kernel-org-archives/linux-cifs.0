Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ACEBC4338F
	for <linux-cifs@archiver.kernel.org>; Sat, 31 Jul 2021 16:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D2861019
	for <linux-cifs@archiver.kernel.org>; Sat, 31 Jul 2021 16:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhGaQCl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 31 Jul 2021 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhGaQCl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 31 Jul 2021 12:02:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8815FC06175F
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 09:02:33 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id p5so15516771wro.7
        for <linux-cifs@vger.kernel.org>; Sat, 31 Jul 2021 09:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wwTvHhfnUN/PQHvh/8/17CUmUVgHE07Uf5QZzpMjaAE=;
        b=GJYI98K/UEBVgABWb5gAMO45+Qpo1dCPVDlDqcdWC67YbaUFfblOUhGYnHZlMKo1Jm
         hgfZxQyGTMuaFaRG5lL8z7sFyXkn5kPgRcvINyo0i1ZH4fU72GWMTQUCV3Ix14hYS1oW
         80/eGlduNXO3/MzlSQaLUUz9HCSsCYEQcgTti9Ah47Vj3Xipsc8KBfcygtF2soY52R6k
         cQ+puVFEJYJmOeyJdleTJFw5m26rM63quRDYOZn/n6EO322knwndeVblyvzdKNz88JAI
         cq+VQAI5RQbzbdEa1zDZO74rpxCShOggCQbOCE3jv/e8R/76sOD+neVMGoTx63xn0+W1
         lW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wwTvHhfnUN/PQHvh/8/17CUmUVgHE07Uf5QZzpMjaAE=;
        b=owVm0dCSr2fqivnQrdSuFvqe9flGyBS1f/C2NvvfqMp4HkqElcwHvZXuz1YY/LaDRU
         Bna7c61oax1x2BiXdzbe2Dsljqo3E6t1BCT9lN8iM1B3eG8JNeWPsw0YQTgWMsMWbfQY
         lzDwqNyRfWdRcKBDNFIAYYZHChLI/eWuiYmaL9TrBZygqz8tAke5bgOtqdpUmhtP396Z
         5yKDlBibQgdXVoX/ChVS0gJKoI6uBliEKTPEqk+PPYMqfyWI8hO+59ASV5kIrllkyodb
         SWsL9wmEy/yofc/v68aDzQS3ahoFRCjVf1J7gB7vmpkZdHt/RDSOumhgrVTFLrmqHGNV
         bpJA==
X-Gm-Message-State: AOAM5320+SUUGqU7tj5mLfXpadCt6zkxKJgbVLNWY5lXsk0nFFG5GeEg
        eyneoP6/j0req2+Y0qg8eNiij47pAuNJveAtzVmlueg1YaR9
X-Google-Smtp-Source: ABdhPJzH2wncc32zBgbCoGMOOBKaqC8vWfa0YkF7jQ/aXBJEHYN5garg4XAhYrwhftL5vw+pr6rbpV+JhXwcTzTBH/g=
X-Received: by 2002:adf:f1cd:: with SMTP id z13mr9055400wro.210.1627747352064;
 Sat, 31 Jul 2021 09:02:32 -0700 (PDT)
MIME-Version: 1.0
From:   Stef Bon <stefbon@gmail.com>
Date:   Sat, 31 Jul 2021 18:02:21 +0200
Message-ID: <CANXojcy9sAY6Sd62Xs2nnjPNHWuUWQwcSpAAyAoT+VPDWizhOQ@mail.gmail.com>
Subject: Question about parsing acl to get linux attributes.
To:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I'm working on a FUSE filesystem to browse and access SMB networks.
I'm using libsmb2 for that. It's not online yet, but my software is here:

https://github.com/stefbon/OSNS

Now I found out that smb2/3 do not support posix like file attributes,
but do (almost?) everything with acl's.
Now I see the function parse_dacl in fs/cifs/cifsacl.c, which
determines the permissions from the acl. I see also that when there
are no acl's, the default is 0777. I made the same choice in my
filesystem.
I've got some questions:

a. what does the sid_unix_NFS_mode stand for? Is it part of the "unix
extensions module for Windows"?

b. can you assume some order in the acl's, so you participate on that?
I want to know there are optimizations possible.

Thanks in advance,

Stef Bon
