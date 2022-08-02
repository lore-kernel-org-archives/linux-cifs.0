Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC97BC00144
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 00:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbiHBAnH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 20:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiHBAnG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 20:43:06 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E06193CB
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 17:43:04 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 125so13033682vsd.5
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 17:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LWWYr28czfw+bXxOV1I/HYKobD+nw65mPR7JUy86+Jg=;
        b=Qd2PEY6tkzBCFGEBbY5WbcfWJrIrxAUzOdOWzvEj8tmKkAkoN9h3OQQvOpMfj5etUU
         OyDbyYPJPy/vW66l32Tyk3fnumpeQNEk9zVG8/21oDcKTCtmwT5Uyc8avhWA4D23o0q/
         LDUQIOgVvoDeBUbgRSrvsHS/vTxCqaeY63dm4Hu3BDfBmeavUP3PtLjh9jTMMs5M0Nuh
         4Lch5qSmQuWqD5MaQbrtVBu6qeKUqFuYcRkaRS5rrh82HjJm8jYsaMy/cx2SvdJuI36N
         ABYoJZjMTUL5ncYFLEkhi9QHhFdC7HjWe7QA0x6HZEQuAnoSBPfoNOmc/a7pRzv4PIA0
         vO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LWWYr28czfw+bXxOV1I/HYKobD+nw65mPR7JUy86+Jg=;
        b=UBjytZoM872L3pDp/ZHWoCRibxb0GyQsv9Ws/2o8LdQqSI1iQLOaeAJscjh4HRkrN2
         fzonpUcPSuOnMPV2+Q73vlCtQMGnV2sE6SLpiWZDa1T8WK+z8cmGm+VBFU9x/0krF/QQ
         Vh/JHet0okr0pKwdvhbm2isoB7NVLAhNhba1oxlNHI/m/laWfooUWl02Bs3ypUVa/p4t
         UhuB7SQwz6dn0Ipi9VijbT4Z2g6pBfw76/UR8zgW8QscmrxQMsCIvCEiK0CCpNLrNKMW
         C1Cj6AS9/vkyVMf3/LPDCNWeK2sZ4tk08ktLJZH4ErhaaRpDQsoVQsB2ta+IFhTmXgAR
         nqOA==
X-Gm-Message-State: ACgBeo0PpZr8C4hWC3AA3b8odrGWHYIMlYzz7JvFHDZul8iI3mSPvyuC
        A462psqTPkWlMdjuQ+UYNc8Y4+i+e9f/ie4r+LLcLlWs
X-Google-Smtp-Source: AA6agR6snOzEjzYuWQU4togqTV4sFaj/w4TzGiKexqbMC8VgNQ3GkhRc40XUYIEGH2Pe7/82gM5B14Xt0JSN3IXAyck=
X-Received: by 2002:a67:b401:0:b0:387:8734:a09 with SMTP id
 x1-20020a67b401000000b0038787340a09mr989372vsl.61.1659400983797; Mon, 01 Aug
 2022 17:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220801190933.27197-1-ematsumiya@suse.de> <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
 <20220801201438.5db6emf6iddawrfl@cyberdelia> <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
In-Reply-To: <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Aug 2022 19:42:52 -0500
Message-ID: <CAH2r5msDPE+7c15i1qP9DPmTgz9kfaFASq_ZbqWzHjkySd_Bwg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
To:     Tom Talpey <tom@talpey.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        Rowland Penny <rpenny@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We don't have to rename the directory in this release.  Linus suggested doing it
in a "quiet" merge window, but there are a lot of lines of code
changed in this one
so we can wait to 5.21 kernel (or 6.1 kernel or whatever the release after
next is called) to do the fs/cifs --> fs/smb-something

On Mon, Aug 1, 2022 at 7:40 PM Tom Talpey <tom@talpey.com> wrote:
>
> On 8/1/2022 4:14 PM, Enzo Matsumiya wrote:
> > On 08/01, Rowland Penny wrote:
> >> On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
> >> wrote:
> >>> Hi,
> >>>
> >>> As part of the ongoing effort to remove the "cifs" nomenclature from
> >>> the
> >>> Linux SMB client, I'm proposing the rename of the module to "smbfs".
> >>
> >> Hi, this has absolutely nothing to do with myself, but Linux used
> >> 'smbfs' before it started to use 'cifs', so you are going back to an
> >> old term. This could be confusing.
> >
> > Hi Rowland, I'm aware of that. I had nothing to do with either
> > (choosing initial "smbfs" nor "cifs"), but, IMHO, I think it should've
> > stayed "smbfs". And TBH this is the most coherent name, of all
>
> I dug around the old tarballs and it looks like fs/smbfs was pulled from
> the kernel after 2.6.36, in early 2011. This was different from fs/cifs,
> which entered the kernel much earlier, so they previously coexisted.
>
> I don't think the name ambiguity is very important, but I do wonder if
> git might uncover some conflicts, when a previously removed directory
> suddenly reappears with new content? There wasn't a lot in fs/smbfs
> though.
>
> Either way, I think the module name is the question here, and it doesn't
> have to be the same as the directory. I still prefer smbfs.
>
> Another possibility for the directory is "ksmb", which might rhyme with
> the server, and keep it close alphabetically too? OTOH it might be
> confusing to have two similar names.
>
> And sorry but I hate the idea of adding "-client". Should we rename
> ksmbd to smb-server?? I don't think so.
>
> Tom.
>
> > available/known choices; you know the protocol (SMB), you know it isn't
> > tied to any SMB version ("cifs", or "smb3" as sometimes suggested or
> > used (as a module alias)), it's a Linux filesystem module ("FS").
> >
> > Also the "fs/smbfs_common" directory was renamed as recent as last year
> > (from "cifs_common") (cf. commit 23e91d8b7).
> >
> >> Rowland
> >
> > Thanks for the input, though. As an RFC patch, I'm waiting for more
> > feedback and suggestions.
> >
> >
> > Cheers,
> >
> > Enzo
> >
> >>>
> >>> As it's widely known, CIFS is associated to SMB1.0, which, in turn,
> >>> is
> >>> associated with the security issues it presented in the past. Using
> >>> "SMBFS" makes clear what's the protocol in use for outsiders, but
> >>> also
> >>> unties it from any particular protocol version. It also fits in the
> >>> already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
> >>>
> >>> This short patch series only changes directory names and
> >>> includes/ifdefs in
> >>> headers and source code, and updates docs to reflect the rename.
> >>> Other
> >>> than that, no source code/functionality is modified (WIP though).
> >>>
> >>> Patch 1/3: effectively changes the module name to "smbfs" and create
> >>> a
> >>>        "cifs" module alias to maintain compatibility (a warning
> >>>        should be added to indicate the complete removal/isolation
> >>> of
> >>>        CIFS/SMB1.0 code).
> >>> Patch 2/3: rename the source-code directory to align with the new
> >>> module
> >>>        name
> >>> Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
> >>> or
> >>>        "cifs module" to use the new name
> >>>
> >>> Enzo Matsumiya (3):
> >>>   cifs: change module name to "smbfs.ko"
> >>>   smbfs: rename directory "fs/cifs" -> "fs/smbfs"
> >>>   smbfs: update doc references
> >>>
> >>>  Documentation/admin-guide/index.rst           |   2 +-
> >>>  .../admin-guide/{cifs => smbfs}/authors.rst   |   0
> >>>  .../admin-guide/{cifs => smbfs}/changes.rst   |   4 +-
> >>>  .../admin-guide/{cifs => smbfs}/index.rst     |   0
> >>>  .../{cifs => smbfs}/introduction.rst          |   0
> >>>  .../admin-guide/{cifs => smbfs}/todo.rst      |  12 +-
> >>>  .../admin-guide/{cifs => smbfs}/usage.rst     | 168 +++++++++-------
> >>> --
> >>>  .../{cifs => smbfs}/winucase_convert.pl       |   0
> >>>  Documentation/filesystems/index.rst           |   2 +-
> >>>  .../filesystems/{cifs => smbfs}/cifsroot.rst  |  14 +-
> >>>  .../filesystems/{cifs => smbfs}/index.rst     |   0
> >>>  .../filesystems/{cifs => smbfs}/ksmbd.rst     |   2 +-
> >>>  Documentation/networking/dns_resolver.rst     |   2 +-
> >>>  .../translations/zh_CN/admin-guide/index.rst  |   2 +-
> >>>  .../translations/zh_TW/admin-guide/index.rst  |   2 +-
> >>>  fs/Kconfig                                    |   6 +-
> >>>  fs/Makefile                                   |   2 +-
> >>>  fs/cifs/Makefile                              |  34 ----
> >>>  fs/{cifs => smbfs}/Kconfig                    | 108 +++++------
> >>>  fs/smbfs/Makefile                             |  34 ++++
> >>>  fs/{cifs => smbfs}/asn1.c                     |   0
> >>>  fs/{cifs => smbfs}/cifs_debug.c               |  72 ++++----
> >>>  fs/{cifs => smbfs}/cifs_debug.h               |   4 +-
> >>>  fs/{cifs => smbfs}/cifs_dfs_ref.c             |   2 +-
> >>>  fs/{cifs => smbfs}/cifs_fs_sb.h               |   0
> >>>  fs/{cifs => smbfs}/cifs_ioctl.h               |   0
> >>>  fs/{cifs => smbfs}/cifs_spnego.c              |   4 +-
> >>>  fs/{cifs => smbfs}/cifs_spnego.h              |   0
> >>>  .../cifs_spnego_negtokeninit.asn1             |   0
> >>>  fs/{cifs => smbfs}/cifs_swn.c                 |   0
> >>>  fs/{cifs => smbfs}/cifs_swn.h                 |   4 +-
> >>>  fs/{cifs => smbfs}/cifs_unicode.c             |   0
> >>>  fs/{cifs => smbfs}/cifs_unicode.h             |   0
> >>>  fs/{cifs => smbfs}/cifs_uniupr.h              |   0
> >>>  fs/{cifs => smbfs}/cifsacl.c                  |   6 +-
> >>>  fs/{cifs => smbfs}/cifsacl.h                  |   0
> >>>  fs/{cifs => smbfs}/cifsencrypt.c              |   0
> >>>  fs/{cifs => smbfs}/cifsglob.h                 |  26 +--
> >>>  fs/{cifs => smbfs}/cifspdu.h                  |   6 +-
> >>>  fs/{cifs => smbfs}/cifsproto.h                |  10 +-
> >>>  fs/{cifs => smbfs}/cifsroot.c                 |   0
> >>>  fs/{cifs => smbfs}/cifssmb.c                  |  14 +-
> >>>  fs/{cifs => smbfs}/connect.c                  |  36 ++--
> >>>  fs/{cifs/cifsfs.c => smbfs/core.c}            |  49 ++---
> >>>  fs/{cifs => smbfs}/dfs_cache.c                |   2 +-
> >>>  fs/{cifs => smbfs}/dfs_cache.h                |   0
> >>>  fs/{cifs => smbfs}/dir.c                      |   2 +-
> >>>  fs/{cifs => smbfs}/dns_resolve.c              |   0
> >>>  fs/{cifs => smbfs}/dns_resolve.h              |   0
> >>>  fs/{cifs => smbfs}/export.c                   |   8 +-
> >>>  fs/{cifs => smbfs}/file.c                     |  16 +-
> >>>  fs/{cifs => smbfs}/fs_context.c               |  20 +--
> >>>  fs/{cifs => smbfs}/fs_context.h               |   0
> >>>  fs/{cifs => smbfs}/fscache.c                  |   0
> >>>  fs/{cifs => smbfs}/fscache.h                  |   6 +-
> >>>  fs/{cifs => smbfs}/inode.c                    |  10 +-
> >>>  fs/{cifs => smbfs}/ioctl.c                    |   6 +-
> >>>  fs/{cifs => smbfs}/link.c                     |   2 +-
> >>>  fs/{cifs => smbfs}/misc.c                     |  14 +-
> >>>  fs/{cifs => smbfs}/netlink.c                  |   0
> >>>  fs/{cifs => smbfs}/netlink.h                  |   0
> >>>  fs/{cifs => smbfs}/netmisc.c                  |   2 +-
> >>>  fs/{cifs => smbfs}/nterr.c                    |   0
> >>>  fs/{cifs => smbfs}/nterr.h                    |   0
> >>>  fs/{cifs => smbfs}/ntlmssp.h                  |   2 +-
> >>>  fs/{cifs => smbfs}/readdir.c                  |   4 +-
> >>>  fs/{cifs => smbfs}/rfc1002pdu.h               |   0
> >>>  fs/{cifs => smbfs}/sess.c                     |  10 +-
> >>>  fs/{cifs => smbfs}/smb1ops.c                  |   4 +-
> >>>  fs/{cifs => smbfs}/smb2file.c                 |   2 +-
> >>>  fs/{cifs => smbfs}/smb2glob.h                 |   0
> >>>  fs/{cifs => smbfs}/smb2inode.c                |   2 +-
> >>>  fs/{cifs => smbfs}/smb2maperror.c             |   0
> >>>  fs/{cifs => smbfs}/smb2misc.c                 |   0
> >>>  fs/{cifs => smbfs}/smb2ops.c                  |  32 ++--
> >>>  fs/{cifs => smbfs}/smb2pdu.c                  |  22 +--
> >>>  fs/{cifs => smbfs}/smb2pdu.h                  |   0
> >>>  fs/{cifs => smbfs}/smb2proto.h                |   0
> >>>  fs/{cifs => smbfs}/smb2status.h               |   0
> >>>  fs/{cifs => smbfs}/smb2transport.c            |   2 +-
> >>>  fs/{cifs => smbfs}/smbdirect.c                |   0
> >>>  fs/{cifs => smbfs}/smbdirect.h                |   2 +-
> >>>  fs/{cifs => smbfs}/smbencrypt.c               |   0
> >>>  fs/{cifs => smbfs}/smberr.h                   |   0
> >>>  fs/{cifs/cifsfs.h => smbfs/smbfs.h}           |  12 +-
> >>>  fs/{cifs => smbfs}/trace.c                    |   0
> >>>  fs/{cifs => smbfs}/trace.h                    |   0
> >>>  fs/{cifs => smbfs}/transport.c                |   4 +-
> >>>  fs/{cifs => smbfs}/unc.c                      |   0
> >>>  fs/{cifs => smbfs}/winucase.c                 |   0
> >>>  fs/{cifs => smbfs}/xattr.c                    |  18 +-
> >>>  91 files changed, 414 insertions(+), 417 deletions(-)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/authors.rst (100%)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/changes.rst (73%)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/index.rst (100%)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/introduction.rst
> >>> (100%)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/todo.rst (95%)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/usage.rst (87%)
> >>>  rename Documentation/admin-guide/{cifs => smbfs}/winucase_convert.pl
> >>> (100%)
> >>>  rename Documentation/filesystems/{cifs => smbfs}/cifsroot.rst (85%)
> >>>  rename Documentation/filesystems/{cifs => smbfs}/index.rst (100%)
> >>>  rename Documentation/filesystems/{cifs => smbfs}/ksmbd.rst (99%)
> >>>  delete mode 100644 fs/cifs/Makefile
> >>>  rename fs/{cifs => smbfs}/Kconfig (72%)
> >>>  create mode 100644 fs/smbfs/Makefile
> >>>  rename fs/{cifs => smbfs}/asn1.c (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_debug.c (96%)
> >>>  rename fs/{cifs => smbfs}/cifs_debug.h (98%)
> >>>  rename fs/{cifs => smbfs}/cifs_dfs_ref.c (99%)
> >>>  rename fs/{cifs => smbfs}/cifs_fs_sb.h (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_ioctl.h (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_spnego.c (98%)
> >>>  rename fs/{cifs => smbfs}/cifs_spnego.h (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_swn.c (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_swn.h (95%)
> >>>  rename fs/{cifs => smbfs}/cifs_unicode.c (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_unicode.h (100%)
> >>>  rename fs/{cifs => smbfs}/cifs_uniupr.h (100%)
> >>>  rename fs/{cifs => smbfs}/cifsacl.c (99%)
> >>>  rename fs/{cifs => smbfs}/cifsacl.h (100%)
> >>>  rename fs/{cifs => smbfs}/cifsencrypt.c (100%)
> >>>  rename fs/{cifs => smbfs}/cifsglob.h (99%)
> >>>  rename fs/{cifs => smbfs}/cifspdu.h (99%)
> >>>  rename fs/{cifs => smbfs}/cifsproto.h (99%)
> >>>  rename fs/{cifs => smbfs}/cifsroot.c (100%)
> >>>  rename fs/{cifs => smbfs}/cifssmb.c (99%)
> >>>  rename fs/{cifs => smbfs}/connect.c (99%)
> >>>  rename fs/{cifs/cifsfs.c => smbfs/core.c} (98%)
> >>>  rename fs/{cifs => smbfs}/dfs_cache.c (99%)
> >>>  rename fs/{cifs => smbfs}/dfs_cache.h (100%)
> >>>  rename fs/{cifs => smbfs}/dir.c (99%)
> >>>  rename fs/{cifs => smbfs}/dns_resolve.c (100%)
> >>>  rename fs/{cifs => smbfs}/dns_resolve.h (100%)
> >>>  rename fs/{cifs => smbfs}/export.c (91%)
> >>>  rename fs/{cifs => smbfs}/file.c (99%)
> >>>  rename fs/{cifs => smbfs}/fs_context.c (99%)
> >>>  rename fs/{cifs => smbfs}/fs_context.h (100%)
> >>>  rename fs/{cifs => smbfs}/fscache.c (100%)
> >>>  rename fs/{cifs => smbfs}/fscache.h (98%)
> >>>  rename fs/{cifs => smbfs}/inode.c (99%)
> >>>  rename fs/{cifs => smbfs}/ioctl.c (99%)
> >>>  rename fs/{cifs => smbfs}/link.c (99%)
> >>>  rename fs/{cifs => smbfs}/misc.c (99%)
> >>>  rename fs/{cifs => smbfs}/netlink.c (100%)
> >>>  rename fs/{cifs => smbfs}/netlink.h (100%)
> >>>  rename fs/{cifs => smbfs}/netmisc.c (99%)
> >>>  rename fs/{cifs => smbfs}/nterr.c (100%)
> >>>  rename fs/{cifs => smbfs}/nterr.h (100%)
> >>>  rename fs/{cifs => smbfs}/ntlmssp.h (98%)
> >>>  rename fs/{cifs => smbfs}/readdir.c (99%)
> >>>  rename fs/{cifs => smbfs}/rfc1002pdu.h (100%)
> >>>  rename fs/{cifs => smbfs}/sess.c (99%)
> >>>  rename fs/{cifs => smbfs}/smb1ops.c (99%)
> >>>  rename fs/{cifs => smbfs}/smb2file.c (99%)
> >>>  rename fs/{cifs => smbfs}/smb2glob.h (100%)
> >>>  rename fs/{cifs => smbfs}/smb2inode.c (99%)
> >>>  rename fs/{cifs => smbfs}/smb2maperror.c (100%)
> >>>  rename fs/{cifs => smbfs}/smb2misc.c (100%)
> >>>  rename fs/{cifs => smbfs}/smb2ops.c (99%)
> >>>  rename fs/{cifs => smbfs}/smb2pdu.c (99%)
> >>>  rename fs/{cifs => smbfs}/smb2pdu.h (100%)
> >>>  rename fs/{cifs => smbfs}/smb2proto.h (100%)
> >>>  rename fs/{cifs => smbfs}/smb2status.h (100%)
> >>>  rename fs/{cifs => smbfs}/smb2transport.c (99%)
> >>>  rename fs/{cifs => smbfs}/smbdirect.c (100%)
> >>>  rename fs/{cifs => smbfs}/smbdirect.h (99%)
> >>>  rename fs/{cifs => smbfs}/smbencrypt.c (100%)
> >>>  rename fs/{cifs => smbfs}/smberr.h (100%)
> >>>  rename fs/{cifs/cifsfs.h => smbfs/smbfs.h} (97%)
> >>>  rename fs/{cifs => smbfs}/trace.c (100%)
> >>>  rename fs/{cifs => smbfs}/trace.h (100%)
> >>>  rename fs/{cifs => smbfs}/transport.c (99%)
> >>>  rename fs/{cifs => smbfs}/unc.c (100%)
> >>>  rename fs/{cifs => smbfs}/winucase.c (100%)
> >>>  rename fs/{cifs => smbfs}/xattr.c (98%)
> >>>
> >>
> >



-- 
Thanks,

Steve
