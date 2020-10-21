Return-Path: <SRS0=ZNV/=D4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 614AEC5517A
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 05:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB98422242
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Oct 2020 05:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t36jz0Xn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440424AbgJUFVT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Oct 2020 01:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440423AbgJUFVS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Oct 2020 01:21:18 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5883DC0613CE
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 22:21:18 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id a28so1151394ljn.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2020 22:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R/RCjjhFdcbB6iZwnroNUnHaeGRk4718oXCX+bNL/cI=;
        b=t36jz0XnuGO5n2iYFnSbqkxjtqc4sNGxqHujaFS/7ny0rSR5S3jJIskc3JlLRka48S
         kTbPaiZ23QH8Z6E9k3ccfbAYtsBy3C/7FYogg1oBpTU6MaOyrGTpUb7MFqTWTSurKdwI
         s/jlXKsv0X5WdLIEcLV1tG4suUkjfDbUb9kUIJH9WMK8vaY1SEuP/0we44HBu+GwtpTj
         Y33I6xfFq4OMxWtrq69hW3gn2NgZ8fllk9jj4YwvayWAAQDN56dK9KDIM6/5blj9qwTU
         PmB8O8CJ+CUVJ7LZPm1zepwcK1WstyLaugaDUykyZdZsZRV/u4+iAwLgw9C+atEHFeKu
         c7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R/RCjjhFdcbB6iZwnroNUnHaeGRk4718oXCX+bNL/cI=;
        b=ukyD4MPhu+wEo6XQNV8c5I7qnbRdLdcEyw/lce6fRt05JmX1Qu/i5CqRB22srfjOrf
         Tc496JD+WATFqbaLLF4PcIcqOnrOZaeH/DbQ6r9Y3+gmlsAXzPNudF8oILlqkKJ27lep
         l5rquca2veT4VmIfiuP5Bd8Q0lsL/j4K7kc3kccBse3oaPBwx07bi8GWu2u574BfgZ5C
         FS+9FCH6bvjA1RoquQ1O1UxMH2hUAbHP8JS9B7aRZkRanthMXxqMOQ6yV50D68DGYmc4
         Kr1qODWaARe3Q9X285oPlBL+eoZIU+IVgoKw+PjLzYrX3G0ZUIsiKu2PLuQfrzAKPw2p
         fytg==
X-Gm-Message-State: AOAM5314/E0JZyS3tKR5okFdJO303GH4GuPLpnmAkDNxjHl6xyJ5TQ7T
        Owjr19WCQCFSHPK2YvaygFtEeqZHD56QJf50yv3CG4MjxPc=
X-Google-Smtp-Source: ABdhPJzbK0V7cF6PathH7Sarkc9Yuh5wIX2weOj8e66KGJej+nNY5MjlJDVd/XTfdlYIu/Lj3OrJYj2h5s1nhhEa5jA=
X-Received: by 2002:a2e:b009:: with SMTP id y9mr549643ljk.372.1603257675835;
 Tue, 20 Oct 2020 22:21:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu2s3Fu+_mWTiXFp+JYTAWZZrPCDyDNtWAhit2DjB890g@mail.gmail.com>
 <CAN05THT4zcQaB8HHEsYi_nA9=VQMuqd53h0=BTSi+FtxYMuiMA@mail.gmail.com>
In-Reply-To: <CAN05THT4zcQaB8HHEsYi_nA9=VQMuqd53h0=BTSi+FtxYMuiMA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Oct 2020 00:21:04 -0500
Message-ID: <CAH2r5mvv4MKEL=mGMLBBjLrOapG60N6O2EjjhpCdEYDnnwbx0w@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix stat when special device file and mounted with modefromsid
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We probably should if we could create special files to Windows using
reparse points (or just set them up manually).  I created these by
doing mknod and mkfifo over NFS to Windows and then doing directory
listings and stat over SM3 mounts

On Tue, Oct 20, 2020 at 11:19 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Receiver-by me.
>
> Should we set up a test for this in the buildbot?
>
> On Wed, Oct 21, 2020 at 2:05 PM Steve French via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > When mounting with modefromsid mount option, it was possible to
> > get the error on stat of a fifo or char or block device:
> >         "cannot stat <filename>: Operation not supported"
> >
> > Special devices can be stored as reparse points by some servers
> > (e.g. Windows NFS server and when using the SMB3.1.1 POSIX
> > Extensions) but when the modefromsid mount option is used
> > the client attempts to get the ACL for the file which requires
> > opening with OPEN_REPARSE_POINT create option.
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
