Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B70DC00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 20:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiHAU14 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 16:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbiHAU1z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 16:27:55 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCC82F3A0
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 13:27:53 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id b2so6165152vkg.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 Aug 2022 13:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I0pLGtfsTtAVrAHuPWHSBGRsLSpaTefjaVBJcobYSqA=;
        b=Ba9KOroyTF5t3lqkhU8ntudiGNbv6gejjSY0ARYn6ANSwoQmT/LmTmrgNynuCp9JlE
         7ytn830AG6P96wJ/R59szrNFiGvmtGdr5Mkj1MNv/9nUELGKsVSq/JcJODjTogaWrz6q
         x+O/sx44nYOJRv4L3apFD/yz45n/ulmA1wf7y0m2kQAFbTbSKl9db7YS3J2bsjmSZ8qC
         4abpv9blLI0VAhVIbUcz1JUlWCUZwQx4zvBU/PGCo4/5cvXPrVv7sdGOyKaKNt6zDuzP
         F+Yma4DYVYLTLgs5k1p9oS0uIjL82mIKoHWatai8DkiZbFV/AvOurZkrZ1TTcG3awz9r
         utKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I0pLGtfsTtAVrAHuPWHSBGRsLSpaTefjaVBJcobYSqA=;
        b=h9ZmlYnW2YurhVi4Gj+cVvcFeEHFj9CVhX/j8PT9B/ZhDbyMVqgn7MKjH5NFO3iTQm
         l/yl/BK5+joS+nQwKQGByX1xmFy+xhtNeNPbz6xEzG/VaqoUQGk2WqRxmxmh2vNSbqUV
         IQZXADXzxHNgC5WhrtcrvUiDG6EHFU8wvNzUQ6yylxH43nyDQOwN6soDKCSmbttFLBZM
         z/a9e5K41OJmnzOXP9fKDkH5t1sFjElynWNwiks6vt/3nqqSujRYnvpRwpAhhmX/Z8ZE
         ifL7dcpH4GxWO4Js0cpPwexbDgX8IWr0XSGHJCA8iSAk/8JcQj56ZXvpRR1MZyJuo9Qj
         4tsQ==
X-Gm-Message-State: AJIora+ELLai8hE0oOJs5+RpGIjJ2uJPBcire+t+jC+KrRObE3nT7FMb
        E09hYWCFeEVJavXczgPD6Fl3rJ20GQnFXXtPAy4a9/rw
X-Google-Smtp-Source: AGRyM1uNd+Esri0bmT4i2MCpWpR1VBB2gltcmaRd4kh3+6s/k9+KH8hZdZJIAlfesKUOaxdvZB8d0ud60q63WfVYueM=
X-Received: by 2002:a1f:a486:0:b0:377:9b:7480 with SMTP id n128-20020a1fa486000000b00377009b7480mr6438705vke.38.1659385672768;
 Mon, 01 Aug 2022 13:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220801190933.27197-1-ematsumiya@suse.de> <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
 <20220801201438.5db6emf6iddawrfl@cyberdelia>
In-Reply-To: <20220801201438.5db6emf6iddawrfl@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 1 Aug 2022 15:27:42 -0500
Message-ID: <CAH2r5msdcmgBP5VGN579nig5VBFHvVUJ26r_ie_mBNsW+Owsfw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Rowland Penny <rpenny@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In an earlier note, Linus had also suggested an alternative directory
name for the rename
(and suggested delaying the rename to a "calm cycle") to
"fs/smb-client" as one idea.

On Mon, Aug 1, 2022 at 3:16 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 08/01, Rowland Penny wrote:
> >On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
> >wrote:
> >> Hi,
> >>
> >> As part of the ongoing effort to remove the "cifs" nomenclature from
> >> the
> >> Linux SMB client, I'm proposing the rename of the module to "smbfs".
> >
> >Hi, this has absolutely nothing to do with myself, but Linux used
> >'smbfs' before it started to use 'cifs', so you are going back to an
> >old term. This could be confusing.
>
> Hi Rowland, I'm aware of that. I had nothing to do with either
> (choosing initial "smbfs" nor "cifs"), but, IMHO, I think it should've
> stayed "smbfs". And TBH this is the most coherent name, of all
> available/known choices; you know the protocol (SMB), you know it isn't
> tied to any SMB version ("cifs", or "smb3" as sometimes suggested or
> used (as a module alias)), it's a Linux filesystem module ("FS").
>
> Also the "fs/smbfs_common" directory was renamed as recent as last year
> (from "cifs_common") (cf. commit 23e91d8b7).
>
> >Rowland
>
> Thanks for the input, though. As an RFC patch, I'm waiting for more
> feedback and suggestions.
>
>
> Cheers,
>
> Enzo
>
> >>
> >> As it's widely known, CIFS is associated to SMB1.0, which, in turn,
> >> is
> >> associated with the security issues it presented in the past. Using
> >> "SMBFS" makes clear what's the protocol in use for outsiders, but
> >> also
> >> unties it from any particular protocol version. It also fits in the
> >> already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
> >>
> >> This short patch series only changes directory names and
> >> includes/ifdefs in
> >> headers and source code, and updates docs to reflect the rename.
> >> Other
> >> than that, no source code/functionality is modified (WIP though).
> >>
> >> Patch 1/3: effectively changes the module name to "smbfs" and create
> >> a
> >>         "cifs" module alias to maintain compatibility (a warning
> >>         should be added to indicate the complete removal/isolation
> >> of
> >>         CIFS/SMB1.0 code).
> >> Patch 2/3: rename the source-code directory to align with the new
> >> module
> >>         name
> >> Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
> >> or
> >>         "cifs module" to use the new name
> >>
> >> Enzo Matsumiya (3):
> >>   cifs: change module name to "smbfs.ko"
> >>   smbfs: rename directory "fs/cifs" -> "fs/smbfs"
> >>   smbfs: update doc references
> >>
> >>  Documentation/admin-guide/index.rst           |   2 +-
> >>  .../admin-guide/{cifs => smbfs}/authors.rst   |   0
> >>  .../admin-guide/{cifs => smbfs}/changes.rst   |   4 +-
> >>  .../admin-guide/{cifs => smbfs}/index.rst     |   0
> >>  .../{cifs => smbfs}/introduction.rst          |   0
> >>  .../admin-guide/{cifs => smbfs}/todo.rst      |  12 +-
> >>  .../admin-guide/{cifs => smbfs}/usage.rst     | 168 +++++++++-------
> >> --
> >>  .../{cifs => smbfs}/winucase_convert.pl       |   0
> >>  Documentation/filesystems/index.rst           |   2 +-
> >>  .../filesystems/{cifs => smbfs}/cifsroot.rst  |  14 +-
> >>  .../filesystems/{cifs => smbfs}/index.rst     |   0
> >>  .../filesystems/{cifs => smbfs}/ksmbd.rst     |   2 +-
> >>  Documentation/networking/dns_resolver.rst     |   2 +-
> >>  .../translations/zh_CN/admin-guide/index.rst  |   2 +-
> >>  .../translations/zh_TW/admin-guide/index.rst  |   2 +-
> >>  fs/Kconfig                                    |   6 +-
> >>  fs/Makefile                                   |   2 +-
> >>  fs/cifs/Makefile                              |  34 ----
> >>  fs/{cifs => smbfs}/Kconfig                    | 108 +++++------
> >>  fs/smbfs/Makefile                             |  34 ++++
> >>  fs/{cifs => smbfs}/asn1.c                     |   0
> >>  fs/{cifs => smbfs}/cifs_debug.c               |  72 ++++----
> >>  fs/{cifs => smbfs}/cifs_debug.h               |   4 +-
> >>  fs/{cifs => smbfs}/cifs_dfs_ref.c             |   2 +-
> >>  fs/{cifs => smbfs}/cifs_fs_sb.h               |   0
> >>  fs/{cifs => smbfs}/cifs_ioctl.h               |   0
> >>  fs/{cifs => smbfs}/cifs_spnego.c              |   4 +-
> >>  fs/{cifs => smbfs}/cifs_spnego.h              |   0
> >>  .../cifs_spnego_negtokeninit.asn1             |   0
> >>  fs/{cifs => smbfs}/cifs_swn.c                 |   0
> >>  fs/{cifs => smbfs}/cifs_swn.h                 |   4 +-
> >>  fs/{cifs => smbfs}/cifs_unicode.c             |   0
> >>  fs/{cifs => smbfs}/cifs_unicode.h             |   0
> >>  fs/{cifs => smbfs}/cifs_uniupr.h              |   0
> >>  fs/{cifs => smbfs}/cifsacl.c                  |   6 +-
> >>  fs/{cifs => smbfs}/cifsacl.h                  |   0
> >>  fs/{cifs => smbfs}/cifsencrypt.c              |   0
> >>  fs/{cifs => smbfs}/cifsglob.h                 |  26 +--
> >>  fs/{cifs => smbfs}/cifspdu.h                  |   6 +-
> >>  fs/{cifs => smbfs}/cifsproto.h                |  10 +-
> >>  fs/{cifs => smbfs}/cifsroot.c                 |   0
> >>  fs/{cifs => smbfs}/cifssmb.c                  |  14 +-
> >>  fs/{cifs => smbfs}/connect.c                  |  36 ++--
> >>  fs/{cifs/cifsfs.c => smbfs/core.c}            |  49 ++---
> >>  fs/{cifs => smbfs}/dfs_cache.c                |   2 +-
> >>  fs/{cifs => smbfs}/dfs_cache.h                |   0
> >>  fs/{cifs => smbfs}/dir.c                      |   2 +-
> >>  fs/{cifs => smbfs}/dns_resolve.c              |   0
> >>  fs/{cifs => smbfs}/dns_resolve.h              |   0
> >>  fs/{cifs => smbfs}/export.c                   |   8 +-
> >>  fs/{cifs => smbfs}/file.c                     |  16 +-
> >>  fs/{cifs => smbfs}/fs_context.c               |  20 +--
> >>  fs/{cifs => smbfs}/fs_context.h               |   0
> >>  fs/{cifs => smbfs}/fscache.c                  |   0
> >>  fs/{cifs => smbfs}/fscache.h                  |   6 +-
> >>  fs/{cifs => smbfs}/inode.c                    |  10 +-
> >>  fs/{cifs => smbfs}/ioctl.c                    |   6 +-
> >>  fs/{cifs => smbfs}/link.c                     |   2 +-
> >>  fs/{cifs => smbfs}/misc.c                     |  14 +-
> >>  fs/{cifs => smbfs}/netlink.c                  |   0
> >>  fs/{cifs => smbfs}/netlink.h                  |   0
> >>  fs/{cifs => smbfs}/netmisc.c                  |   2 +-
> >>  fs/{cifs => smbfs}/nterr.c                    |   0
> >>  fs/{cifs => smbfs}/nterr.h                    |   0
> >>  fs/{cifs => smbfs}/ntlmssp.h                  |   2 +-
> >>  fs/{cifs => smbfs}/readdir.c                  |   4 +-
> >>  fs/{cifs => smbfs}/rfc1002pdu.h               |   0
> >>  fs/{cifs => smbfs}/sess.c                     |  10 +-
> >>  fs/{cifs => smbfs}/smb1ops.c                  |   4 +-
> >>  fs/{cifs => smbfs}/smb2file.c                 |   2 +-
> >>  fs/{cifs => smbfs}/smb2glob.h                 |   0
> >>  fs/{cifs => smbfs}/smb2inode.c                |   2 +-
> >>  fs/{cifs => smbfs}/smb2maperror.c             |   0
> >>  fs/{cifs => smbfs}/smb2misc.c                 |   0
> >>  fs/{cifs => smbfs}/smb2ops.c                  |  32 ++--
> >>  fs/{cifs => smbfs}/smb2pdu.c                  |  22 +--
> >>  fs/{cifs => smbfs}/smb2pdu.h                  |   0
> >>  fs/{cifs => smbfs}/smb2proto.h                |   0
> >>  fs/{cifs => smbfs}/smb2status.h               |   0
> >>  fs/{cifs => smbfs}/smb2transport.c            |   2 +-
> >>  fs/{cifs => smbfs}/smbdirect.c                |   0
> >>  fs/{cifs => smbfs}/smbdirect.h                |   2 +-
> >>  fs/{cifs => smbfs}/smbencrypt.c               |   0
> >>  fs/{cifs => smbfs}/smberr.h                   |   0
> >>  fs/{cifs/cifsfs.h => smbfs/smbfs.h}           |  12 +-
> >>  fs/{cifs => smbfs}/trace.c                    |   0
> >>  fs/{cifs => smbfs}/trace.h                    |   0
> >>  fs/{cifs => smbfs}/transport.c                |   4 +-
> >>  fs/{cifs => smbfs}/unc.c                      |   0
> >>  fs/{cifs => smbfs}/winucase.c                 |   0
> >>  fs/{cifs => smbfs}/xattr.c                    |  18 +-
> >>  91 files changed, 414 insertions(+), 417 deletions(-)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/authors.rst (100%)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/changes.rst (73%)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/index.rst (100%)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/introduction.rst
> >> (100%)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/todo.rst (95%)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/usage.rst (87%)
> >>  rename Documentation/admin-guide/{cifs => smbfs}/winucase_convert.pl
> >> (100%)
> >>  rename Documentation/filesystems/{cifs => smbfs}/cifsroot.rst (85%)
> >>  rename Documentation/filesystems/{cifs => smbfs}/index.rst (100%)
> >>  rename Documentation/filesystems/{cifs => smbfs}/ksmbd.rst (99%)
> >>  delete mode 100644 fs/cifs/Makefile
> >>  rename fs/{cifs => smbfs}/Kconfig (72%)
> >>  create mode 100644 fs/smbfs/Makefile
> >>  rename fs/{cifs => smbfs}/asn1.c (100%)
> >>  rename fs/{cifs => smbfs}/cifs_debug.c (96%)
> >>  rename fs/{cifs => smbfs}/cifs_debug.h (98%)
> >>  rename fs/{cifs => smbfs}/cifs_dfs_ref.c (99%)
> >>  rename fs/{cifs => smbfs}/cifs_fs_sb.h (100%)
> >>  rename fs/{cifs => smbfs}/cifs_ioctl.h (100%)
> >>  rename fs/{cifs => smbfs}/cifs_spnego.c (98%)
> >>  rename fs/{cifs => smbfs}/cifs_spnego.h (100%)
> >>  rename fs/{cifs => smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
> >>  rename fs/{cifs => smbfs}/cifs_swn.c (100%)
> >>  rename fs/{cifs => smbfs}/cifs_swn.h (95%)
> >>  rename fs/{cifs => smbfs}/cifs_unicode.c (100%)
> >>  rename fs/{cifs => smbfs}/cifs_unicode.h (100%)
> >>  rename fs/{cifs => smbfs}/cifs_uniupr.h (100%)
> >>  rename fs/{cifs => smbfs}/cifsacl.c (99%)
> >>  rename fs/{cifs => smbfs}/cifsacl.h (100%)
> >>  rename fs/{cifs => smbfs}/cifsencrypt.c (100%)
> >>  rename fs/{cifs => smbfs}/cifsglob.h (99%)
> >>  rename fs/{cifs => smbfs}/cifspdu.h (99%)
> >>  rename fs/{cifs => smbfs}/cifsproto.h (99%)
> >>  rename fs/{cifs => smbfs}/cifsroot.c (100%)
> >>  rename fs/{cifs => smbfs}/cifssmb.c (99%)
> >>  rename fs/{cifs => smbfs}/connect.c (99%)
> >>  rename fs/{cifs/cifsfs.c => smbfs/core.c} (98%)
> >>  rename fs/{cifs => smbfs}/dfs_cache.c (99%)
> >>  rename fs/{cifs => smbfs}/dfs_cache.h (100%)
> >>  rename fs/{cifs => smbfs}/dir.c (99%)
> >>  rename fs/{cifs => smbfs}/dns_resolve.c (100%)
> >>  rename fs/{cifs => smbfs}/dns_resolve.h (100%)
> >>  rename fs/{cifs => smbfs}/export.c (91%)
> >>  rename fs/{cifs => smbfs}/file.c (99%)
> >>  rename fs/{cifs => smbfs}/fs_context.c (99%)
> >>  rename fs/{cifs => smbfs}/fs_context.h (100%)
> >>  rename fs/{cifs => smbfs}/fscache.c (100%)
> >>  rename fs/{cifs => smbfs}/fscache.h (98%)
> >>  rename fs/{cifs => smbfs}/inode.c (99%)
> >>  rename fs/{cifs => smbfs}/ioctl.c (99%)
> >>  rename fs/{cifs => smbfs}/link.c (99%)
> >>  rename fs/{cifs => smbfs}/misc.c (99%)
> >>  rename fs/{cifs => smbfs}/netlink.c (100%)
> >>  rename fs/{cifs => smbfs}/netlink.h (100%)
> >>  rename fs/{cifs => smbfs}/netmisc.c (99%)
> >>  rename fs/{cifs => smbfs}/nterr.c (100%)
> >>  rename fs/{cifs => smbfs}/nterr.h (100%)
> >>  rename fs/{cifs => smbfs}/ntlmssp.h (98%)
> >>  rename fs/{cifs => smbfs}/readdir.c (99%)
> >>  rename fs/{cifs => smbfs}/rfc1002pdu.h (100%)
> >>  rename fs/{cifs => smbfs}/sess.c (99%)
> >>  rename fs/{cifs => smbfs}/smb1ops.c (99%)
> >>  rename fs/{cifs => smbfs}/smb2file.c (99%)
> >>  rename fs/{cifs => smbfs}/smb2glob.h (100%)
> >>  rename fs/{cifs => smbfs}/smb2inode.c (99%)
> >>  rename fs/{cifs => smbfs}/smb2maperror.c (100%)
> >>  rename fs/{cifs => smbfs}/smb2misc.c (100%)
> >>  rename fs/{cifs => smbfs}/smb2ops.c (99%)
> >>  rename fs/{cifs => smbfs}/smb2pdu.c (99%)
> >>  rename fs/{cifs => smbfs}/smb2pdu.h (100%)
> >>  rename fs/{cifs => smbfs}/smb2proto.h (100%)
> >>  rename fs/{cifs => smbfs}/smb2status.h (100%)
> >>  rename fs/{cifs => smbfs}/smb2transport.c (99%)
> >>  rename fs/{cifs => smbfs}/smbdirect.c (100%)
> >>  rename fs/{cifs => smbfs}/smbdirect.h (99%)
> >>  rename fs/{cifs => smbfs}/smbencrypt.c (100%)
> >>  rename fs/{cifs => smbfs}/smberr.h (100%)
> >>  rename fs/{cifs/cifsfs.h => smbfs/smbfs.h} (97%)
> >>  rename fs/{cifs => smbfs}/trace.c (100%)
> >>  rename fs/{cifs => smbfs}/trace.h (100%)
> >>  rename fs/{cifs => smbfs}/transport.c (99%)
> >>  rename fs/{cifs => smbfs}/unc.c (100%)
> >>  rename fs/{cifs => smbfs}/winucase.c (100%)
> >>  rename fs/{cifs => smbfs}/xattr.c (98%)
> >>
> >



-- 
Thanks,

Steve
