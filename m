Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177BFC433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 10 May 2021 23:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E6A61584
	for <linux-cifs@archiver.kernel.org>; Mon, 10 May 2021 23:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhEJXC6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 May 2021 19:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhEJXC6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 May 2021 19:02:58 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD83C061574
        for <linux-cifs@vger.kernel.org>; Mon, 10 May 2021 16:01:51 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id y9so22809215ljn.6
        for <linux-cifs@vger.kernel.org>; Mon, 10 May 2021 16:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=iYWRrcpr+cx0tsvSmF4HR7IGABDRGTF18gQhrMFWq2Y=;
        b=uruCfMcbDRlz4RXmVeoYO3xBZ990opIY8xC6mjkuhAhKQk6QDCxC9v2sgT16ZHrEs0
         rj7+bhSxFlfuBvKsfIJPQzD+sEhYs8s6WmgXMae35vjhAU9uWUEiZEk3eBeSQnY5RjHH
         ySX15cfjUUSAta3AJYsA4qh7lzf7w5ctj3iX/kKXMkFnKYm983LRkvUAtgSn4H9+BxAt
         YKzca1jruNIMvBRfdFx647GT2t9QnfrG0J+lz0Y0vKU1Z9uV/+HMhZdV+nM5wzBzPgGX
         /ZCJHfMed0Rr9YZ8dP+ilCe0YWR4RYZUtYmdJ7E2Eam+QwhewVGSTx3YmFm1V4PmGgYL
         upNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=iYWRrcpr+cx0tsvSmF4HR7IGABDRGTF18gQhrMFWq2Y=;
        b=NlZnqGAlduSH3O4b/1kuy2mCc+cVA8hMqCQ12gRIGkA1E0xf+7FENoLHb+5SX0ssaI
         5bPyBLSV1ZIhRKcC76R/BIGUFOLjjRpdnexzSf0e+khBLqKX1m2LyED2Xy/VjRnLaxIZ
         mS+uccw6zErfVe89R4ChIaSuIm58f80NIuIJ2Z4LviMrG78hdR0eAdI2VTWSJzmgcZzT
         +4ScDSTIi2WHxfrpWoAXE35xfa9IxOAUs5rhN17YMlwC60BA0cORr9vDFb88yjh+B+3Y
         6qYB7FMnBwa8JjI23Xoub3/XgV1B+IRkCuOnC12eZFxU3OTdm8xXg5I068ghgdG2pSrq
         /JAQ==
X-Gm-Message-State: AOAM532XkeN5hrzAnc+9A0PPrIBRAJiAkUcMA1ghZTgEOKCemZ095CHe
        ksV68RXEjPj5q+W6gam3Py+P3rX+7gHubLteaY95POyv9kp6jA==
X-Google-Smtp-Source: ABdhPJzfAN/sBXTxvjYsIIZwECcyr2kpfwnGqMibMXJWAB1I65VcgM4hZDicHryVG/tNBrKXfhgLf7De6b2FyaTEU5w=
X-Received: by 2002:a2e:7819:: with SMTP id t25mr800031ljc.406.1620687710044;
 Mon, 10 May 2021 16:01:50 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 10 May 2021 18:01:39 -0500
Message-ID: <CAH2r5mviZ9SHbTZFJZDnQkJJ=XWrf88PvmYsVqoXwpBjd0xrjg@mail.gmail.com>
Subject: Add seven more xfstests to the main regression test group for the client
To:     CIFS <linux-cifs@vger.kernel.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

FYI - with the features added to the client now in 5.13-rc1, I have
added 7 more xfstests to the main regression testing group (test
targets include various servers: Samba, Windows, Azure), and also to
the narrower test groups.   I do still need to check that they work to
ksmbd (the kernel server) and update that ksmbd test group later.  See

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/635

-- 
Thanks,

Steve
