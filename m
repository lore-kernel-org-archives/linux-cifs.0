Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0BCC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 16:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiHBQUV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 12:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiHBQUS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 12:20:18 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A728F00
        for <linux-cifs@vger.kernel.org>; Tue,  2 Aug 2022 09:20:15 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id b124so3380124vsc.9
        for <linux-cifs@vger.kernel.org>; Tue, 02 Aug 2022 09:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgTltOOnRlwfQ6jAhgE2UGWwa0arTXWhTDk7J/T/c0Q=;
        b=Yfhgwsw8owWfuuVIorcI+K8cfREjcXktIXGnksqAcNjDHdyqxXXdpWkexDp4CU9i7a
         nZb8IzShARMh3uJQOgOYTcpaJSJkedvfED9bWTIuV5VvaHItrMjKJVDkAE7iI7nXOZ43
         jOEA9jHaTFUAqNy3DMz7uBbNtgTmendYoBafcqfpNslq8VDiOtHT9ycpHGYA0vMCTe5X
         OvRdUYKXtscyy6zx0kIbm6hvfIk1Qj3gNW9zrVEwzOqVmnCah2F+UHtYhLdA0rg2zSaI
         kkB1qjZJi9ArzdBT2EI0ltH7+PAVlvLLczYzGhlqfWUsbc0yFDidvG/RmvO+TZ4A79gv
         iaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgTltOOnRlwfQ6jAhgE2UGWwa0arTXWhTDk7J/T/c0Q=;
        b=iEGYPdld0qAeeVOxcKgOcJknhN+XkRLEuDo1rrf5GxeM30l0tTVkZ+1UaKOeYoooqD
         MSKc5TPXXslM4BHpRawrFMbaatYkEXYLa6Pyc16Ge8VGK4u37OVGCksxEO4+6xBhFb8h
         QO8pSiJREHHMN1JZAdEtCgm1AVmVOdrCYekUPzVwzLFCQnHqOW/zRAOWfoNtfYHh3pn3
         VyOc8fbKuwP5u28vQKWZ3jsL7eQrZcHHcCYfr5r61dvrbCvVdbHlY1AWJafwJa75aldo
         KkqVb6yCpQyEAdA0Xmho8103Th5XAUUzi2lEG/wq3hQ1IEj4hCV+MwjJ6c+zStE/rwHH
         vqtQ==
X-Gm-Message-State: ACgBeo29W3CjjRp/nGixW8swnjaogaG6h8yqQC/RhNHyRk0IqEsVMB2B
        /frIwpTsnq8lkGAIgmzJsDDTZbUa7JJ3sVq39rUCwbBr
X-Google-Smtp-Source: AA6agR7BeiBJ020Wpf5/eIbOc+uSRiv7patoTXwch0YYY9nRAjQrepUlIlZIbT4QVeApwoorXUZ+JXgA9JZWQMH2i8E=
X-Received: by 2002:a67:b401:0:b0:387:8734:a09 with SMTP id
 x1-20020a67b401000000b0038787340a09mr2194453vsl.61.1659457213903; Tue, 02 Aug
 2022 09:20:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220801190933.27197-1-ematsumiya@suse.de> <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
 <20220801201438.5db6emf6iddawrfl@cyberdelia> <cc925d11-df62-fd92-f21f-4aca10e3a68d@talpey.com>
 <20220802135201.4vm36drd5mp57nvv@cyberdelia> <CAH2r5muSREEiwehp0c0V0OFBbicJceiBxTBjasNyL36rQLqK6g@mail.gmail.com>
 <20220802155852.ae77gkacfrlmiv4t@cyberdelia>
In-Reply-To: <20220802155852.ae77gkacfrlmiv4t@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Aug 2022 11:20:03 -0500
Message-ID: <CAH2r5muL3FFbbcFswe6R5rry9YAECuAd7Uv5W8cV_96qa2QntA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Tom Talpey <tom@talpey.com>, Rowland Penny <rpenny@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

it may be ok to have the module name match what you can say on mount
(so "smb3.ko"):

e.g. we already can be encouraging users to use "mount -t smb3 ..."
not "mount -t cifs"
since we already have that as a module alias

On Tue, Aug 2, 2022 at 10:58 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 08/02, Steve French wrote:
> >What about just "fs/smb" but "fs/smb_client" is also a possibility -
> >but I agree "fs/smbfs" could get confusing due to the very old module
> >that was removed more than 10 years ago
>
> IMHO "fs/smb" is better than "fs/smb_client".
>
> Let me know if it's ok to resubmit a v2 of this rename series.
>
> Also, do we keep the module name as smbfs.ko?
>
> >On Tue, Aug 2, 2022 at 8:52 AM Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >>
> >> On 08/01, Tom Talpey wrote:
> >> >On 8/1/2022 4:14 PM, Enzo Matsumiya wrote:
> >> >>On 08/01, Rowland Penny wrote:
> >> >>>On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
> >> >>>wrote:
> >> >>>>Hi,
> >> >>>>
> >> >>>>As part of the ongoing effort to remove the "cifs" nomenclature from
> >> >>>>the
> >> >>>>Linux SMB client, I'm proposing the rename of the module to "smbfs".
> >> >>>
> >> >>>Hi, this has absolutely nothing to do with myself, but Linux used
> >> >>>'smbfs' before it started to use 'cifs', so you are going back to an
> >> >>>old term. This could be confusing.
> >> >>
> >> >>Hi Rowland, I'm aware of that. I had nothing to do with either
> >> >>(choosing initial "smbfs" nor "cifs"), but, IMHO, I think it should've
> >> >>stayed "smbfs". And TBH this is the most coherent name, of all
> >> >
> >> >I dug around the old tarballs and it looks like fs/smbfs was pulled from
> >> >the kernel after 2.6.36, in early 2011. This was different from fs/cifs,
> >> >which entered the kernel much earlier, so they previously coexisted.
> >> >
> >> >I don't think the name ambiguity is very important, but I do wonder if
> >> >git might uncover some conflicts, when a previously removed directory
> >> >suddenly reappears with new content? There wasn't a lot in fs/smbfs
> >> >though.
> >>
> >> I haven't considered that.
> >> Doing a "git log --follow -- fs/smbfs" does show the older commits for
> >> before the previous migration/rename:
> >>
> >> ----
> >> commit 1e20c73a2935be2d9f19ebc63ddee1afccc42b07
> >> Author: Enzo Matsumiya <ematsumiya@suse.de>
> >> Date:   Mon Aug 1 15:05:23 2022 -0300
> >>
> >>      smbfs: rename directory "fs/cifs" -> "fs/smbfs"
> >>
> >>      Update fs/Kconfig and fs/Makefile to reflect the change.
> >>
> >>      Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> >>
> >> commit be9eee2e8b87e335531a3ae13abb8d26e834c438
> >> Author: Christoph Hellwig <hch@infradead.org>
> >> Date:   Sun Oct 10 05:36:29 2010 -0400
> >>
> >>      smbfs: use dget_parent
> >>
> >>      Use dget_parent instead of opencoding it.  This simplifies the code, but
> >>      more importanly prepares for the more complicated locking for a parent
> >>      dget in the dcache scale patch series.
> >>
> >>      Note that the d_time assignment in smb_renew_times moves out of d_lock,
> >>      but it's a single atomic 32-bit value, and that's what other sites
> >>      setting it do already.
> >>
> >>      Signed-off-by: Christoph Hellwig <hch@lst.de>
> >>      Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> >> ...
> >> ----
> >>
> >> I don't know if that would cause a real problem though, someone more
> >> experienced with renaming modules/directories could provide their
> >> opinion.
> >>
> >> Could we have an empty commit between old commits and the new rename to
> >> serve as a marker maybe?
> >>
> >> >Either way, I think the module name is the question here, and it doesn't
> >> >have to be the same as the directory. I still prefer smbfs.
> >> >
> >> >Another possibility for the directory is "ksmb", which might rhyme with
> >> >the server, and keep it close alphabetically too? OTOH it might be
> >> >confusing to have two similar names.
> >>
> >> My original idea of "ideal" was to have:
> >>
> >> fs/smbfs/
> >> fs/smbfs/common
> >> fs/smbfs/client
> >> fs/smbfs/server
> >>
> >> Which aligns with e.g., drivers/nvme/ that has host/ and target/ subdirs
> >> to accomodate client and server code. This would make things way more
> >> manageable given the quantity of shared code between cifs.ko and
> >> ksmbd.ko.
> >>
> >> Another option is:
> >> fs/smbfs_client/
> >> fs/smbfs_common/ (already existing)
> >> fs/smbfs_server/
> >>
> >> But, personally, I'm not really a fan of the underscores.
> >>
> >> My 2c only though.
> >> Thoughts?
> >>
> >> >And sorry but I hate the idea of adding "-client". Should we rename
> >> >ksmbd to smb-server?? I don't think so.
> >>
> >> Agreed.
> >>
> >> >Tom.
> >>
> >> Cheers,
> >>
> >> Enzo
> >>
> >> >>available/known choices; you know the protocol (SMB), you know it isn't
> >> >>tied to any SMB version ("cifs", or "smb3" as sometimes suggested or
> >> >>used (as a module alias)), it's a Linux filesystem module ("FS").
> >> >>
> >> >>Also the "fs/smbfs_common" directory was renamed as recent as last year
> >> >>(from "cifs_common") (cf. commit 23e91d8b7).
> >> >>
> >> >>>Rowland
> >> >>
> >> >>Thanks for the input, though. As an RFC patch, I'm waiting for more
> >> >>feedback and suggestions.
> >> >>
> >> >>
> >> >>Cheers,
> >> >>
> >> >>Enzo
> >> >>
> >> >>>>
> >> >>>>As it's widely known, CIFS is associated to SMB1.0, which, in turn,
> >> >>>>is
> >> >>>>associated with the security issues it presented in the past. Using
> >> >>>>"SMBFS" makes clear what's the protocol in use for outsiders, but
> >> >>>>also
> >> >>>>unties it from any particular protocol version. It also fits in the
> >> >>>>already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
> >> >>>>
> >> >>>>This short patch series only changes directory names and
> >> >>>>includes/ifdefs in
> >> >>>>headers and source code, and updates docs to reflect the rename.
> >> >>>>Other
> >> >>>>than that, no source code/functionality is modified (WIP though).
> >> >>>>
> >> >>>>Patch 1/3: effectively changes the module name to "smbfs" and create
> >> >>>>a
> >> >>>>       "cifs" module alias to maintain compatibility (a warning
> >> >>>>       should be added to indicate the complete removal/isolation
> >> >>>>of
> >> >>>>       CIFS/SMB1.0 code).
> >> >>>>Patch 2/3: rename the source-code directory to align with the new
> >> >>>>module
> >> >>>>       name
> >> >>>>Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
> >> >>>>or
> >> >>>>       "cifs module" to use the new name
> >> >>>>
> >> >>>>Enzo Matsumiya (3):
> >> >>>>  cifs: change module name to "smbfs.ko"
> >> >>>>  smbfs: rename directory "fs/cifs" -> "fs/smbfs"
> >> >>>>  smbfs: update doc references
> >> >>>>
> >> >>>> Documentation/admin-guide/index.rst           |   2 +-
> >> >>>> .../admin-guide/{cifs => smbfs}/authors.rst   |   0
> >> >>>> .../admin-guide/{cifs => smbfs}/changes.rst   |   4 +-
> >> >>>> .../admin-guide/{cifs => smbfs}/index.rst     |   0
> >> >>>> .../{cifs => smbfs}/introduction.rst          |   0
> >> >>>> .../admin-guide/{cifs => smbfs}/todo.rst      |  12 +-
> >> >>>> .../admin-guide/{cifs => smbfs}/usage.rst     | 168 +++++++++-------
> >> >>>>--
> >> >>>> .../{cifs => smbfs}/winucase_convert.pl       |   0
> >> >>>> Documentation/filesystems/index.rst           |   2 +-
> >> >>>> .../filesystems/{cifs => smbfs}/cifsroot.rst  |  14 +-
> >> >>>> .../filesystems/{cifs => smbfs}/index.rst     |   0
> >> >>>> .../filesystems/{cifs => smbfs}/ksmbd.rst     |   2 +-
> >> >>>> Documentation/networking/dns_resolver.rst     |   2 +-
> >> >>>> .../translations/zh_CN/admin-guide/index.rst  |   2 +-
> >> >>>> .../translations/zh_TW/admin-guide/index.rst  |   2 +-
> >> >>>> fs/Kconfig                                    |   6 +-
> >> >>>> fs/Makefile                                   |   2 +-
> >> >>>> fs/cifs/Makefile                              |  34 ----
> >> >>>> fs/{cifs => smbfs}/Kconfig                    | 108 +++++------
> >> >>>> fs/smbfs/Makefile                             |  34 ++++
> >> >>>> fs/{cifs => smbfs}/asn1.c                     |   0
> >> >>>> fs/{cifs => smbfs}/cifs_debug.c               |  72 ++++----
> >> >>>> fs/{cifs => smbfs}/cifs_debug.h               |   4 +-
> >> >>>> fs/{cifs => smbfs}/cifs_dfs_ref.c             |   2 +-
> >> >>>> fs/{cifs => smbfs}/cifs_fs_sb.h               |   0
> >> >>>> fs/{cifs => smbfs}/cifs_ioctl.h               |   0
> >> >>>> fs/{cifs => smbfs}/cifs_spnego.c              |   4 +-
> >> >>>> fs/{cifs => smbfs}/cifs_spnego.h              |   0
> >> >>>> .../cifs_spnego_negtokeninit.asn1             |   0
> >> >>>> fs/{cifs => smbfs}/cifs_swn.c                 |   0
> >> >>>> fs/{cifs => smbfs}/cifs_swn.h                 |   4 +-
> >> >>>> fs/{cifs => smbfs}/cifs_unicode.c             |   0
> >> >>>> fs/{cifs => smbfs}/cifs_unicode.h             |   0
> >> >>>> fs/{cifs => smbfs}/cifs_uniupr.h              |   0
> >> >>>> fs/{cifs => smbfs}/cifsacl.c                  |   6 +-
> >> >>>> fs/{cifs => smbfs}/cifsacl.h                  |   0
> >> >>>> fs/{cifs => smbfs}/cifsencrypt.c              |   0
> >> >>>> fs/{cifs => smbfs}/cifsglob.h                 |  26 +--
> >> >>>> fs/{cifs => smbfs}/cifspdu.h                  |   6 +-
> >> >>>> fs/{cifs => smbfs}/cifsproto.h                |  10 +-
> >> >>>> fs/{cifs => smbfs}/cifsroot.c                 |   0
> >> >>>> fs/{cifs => smbfs}/cifssmb.c                  |  14 +-
> >> >>>> fs/{cifs => smbfs}/connect.c                  |  36 ++--
> >> >>>> fs/{cifs/cifsfs.c => smbfs/core.c}            |  49 ++---
> >> >>>> fs/{cifs => smbfs}/dfs_cache.c                |   2 +-
> >> >>>> fs/{cifs => smbfs}/dfs_cache.h                |   0
> >> >>>> fs/{cifs => smbfs}/dir.c                      |   2 +-
> >> >>>> fs/{cifs => smbfs}/dns_resolve.c              |   0
> >> >>>> fs/{cifs => smbfs}/dns_resolve.h              |   0
> >> >>>> fs/{cifs => smbfs}/export.c                   |   8 +-
> >> >>>> fs/{cifs => smbfs}/file.c                     |  16 +-
> >> >>>> fs/{cifs => smbfs}/fs_context.c               |  20 +--
> >> >>>> fs/{cifs => smbfs}/fs_context.h               |   0
> >> >>>> fs/{cifs => smbfs}/fscache.c                  |   0
> >> >>>> fs/{cifs => smbfs}/fscache.h                  |   6 +-
> >> >>>> fs/{cifs => smbfs}/inode.c                    |  10 +-
> >> >>>> fs/{cifs => smbfs}/ioctl.c                    |   6 +-
> >> >>>> fs/{cifs => smbfs}/link.c                     |   2 +-
> >> >>>> fs/{cifs => smbfs}/misc.c                     |  14 +-
> >> >>>> fs/{cifs => smbfs}/netlink.c                  |   0
> >> >>>> fs/{cifs => smbfs}/netlink.h                  |   0
> >> >>>> fs/{cifs => smbfs}/netmisc.c                  |   2 +-
> >> >>>> fs/{cifs => smbfs}/nterr.c                    |   0
> >> >>>> fs/{cifs => smbfs}/nterr.h                    |   0
> >> >>>> fs/{cifs => smbfs}/ntlmssp.h                  |   2 +-
> >> >>>> fs/{cifs => smbfs}/readdir.c                  |   4 +-
> >> >>>> fs/{cifs => smbfs}/rfc1002pdu.h               |   0
> >> >>>> fs/{cifs => smbfs}/sess.c                     |  10 +-
> >> >>>> fs/{cifs => smbfs}/smb1ops.c                  |   4 +-
> >> >>>> fs/{cifs => smbfs}/smb2file.c                 |   2 +-
> >> >>>> fs/{cifs => smbfs}/smb2glob.h                 |   0
> >> >>>> fs/{cifs => smbfs}/smb2inode.c                |   2 +-
> >> >>>> fs/{cifs => smbfs}/smb2maperror.c             |   0
> >> >>>> fs/{cifs => smbfs}/smb2misc.c                 |   0
> >> >>>> fs/{cifs => smbfs}/smb2ops.c                  |  32 ++--
> >> >>>> fs/{cifs => smbfs}/smb2pdu.c                  |  22 +--
> >> >>>> fs/{cifs => smbfs}/smb2pdu.h                  |   0
> >> >>>> fs/{cifs => smbfs}/smb2proto.h                |   0
> >> >>>> fs/{cifs => smbfs}/smb2status.h               |   0
> >> >>>> fs/{cifs => smbfs}/smb2transport.c            |   2 +-
> >> >>>> fs/{cifs => smbfs}/smbdirect.c                |   0
> >> >>>> fs/{cifs => smbfs}/smbdirect.h                |   2 +-
> >> >>>> fs/{cifs => smbfs}/smbencrypt.c               |   0
> >> >>>> fs/{cifs => smbfs}/smberr.h                   |   0
> >> >>>> fs/{cifs/cifsfs.h => smbfs/smbfs.h}           |  12 +-
> >> >>>> fs/{cifs => smbfs}/trace.c                    |   0
> >> >>>> fs/{cifs => smbfs}/trace.h                    |   0
> >> >>>> fs/{cifs => smbfs}/transport.c                |   4 +-
> >> >>>> fs/{cifs => smbfs}/unc.c                      |   0
> >> >>>> fs/{cifs => smbfs}/winucase.c                 |   0
> >> >>>> fs/{cifs => smbfs}/xattr.c                    |  18 +-
> >> >>>> 91 files changed, 414 insertions(+), 417 deletions(-)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/authors.rst (100%)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/changes.rst (73%)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/index.rst (100%)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/introduction.rst
> >> >>>>(100%)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/todo.rst (95%)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/usage.rst (87%)
> >> >>>> rename Documentation/admin-guide/{cifs => smbfs}/winucase_convert.pl
> >> >>>>(100%)
> >> >>>> rename Documentation/filesystems/{cifs => smbfs}/cifsroot.rst (85%)
> >> >>>> rename Documentation/filesystems/{cifs => smbfs}/index.rst (100%)
> >> >>>> rename Documentation/filesystems/{cifs => smbfs}/ksmbd.rst (99%)
> >> >>>> delete mode 100644 fs/cifs/Makefile
> >> >>>> rename fs/{cifs => smbfs}/Kconfig (72%)
> >> >>>> create mode 100644 fs/smbfs/Makefile
> >> >>>> rename fs/{cifs => smbfs}/asn1.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_debug.c (96%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_debug.h (98%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_dfs_ref.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_fs_sb.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_ioctl.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_spnego.c (98%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_spnego.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_swn.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_swn.h (95%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_unicode.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_unicode.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifs_uniupr.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifsacl.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/cifsacl.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifsencrypt.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifsglob.h (99%)
> >> >>>> rename fs/{cifs => smbfs}/cifspdu.h (99%)
> >> >>>> rename fs/{cifs => smbfs}/cifsproto.h (99%)
> >> >>>> rename fs/{cifs => smbfs}/cifsroot.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/cifssmb.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/connect.c (99%)
> >> >>>> rename fs/{cifs/cifsfs.c => smbfs/core.c} (98%)
> >> >>>> rename fs/{cifs => smbfs}/dfs_cache.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/dfs_cache.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/dir.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/dns_resolve.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/dns_resolve.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/export.c (91%)
> >> >>>> rename fs/{cifs => smbfs}/file.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/fs_context.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/fs_context.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/fscache.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/fscache.h (98%)
> >> >>>> rename fs/{cifs => smbfs}/inode.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/ioctl.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/link.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/misc.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/netlink.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/netlink.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/netmisc.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/nterr.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/nterr.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/ntlmssp.h (98%)
> >> >>>> rename fs/{cifs => smbfs}/readdir.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/rfc1002pdu.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/sess.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smb1ops.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smb2file.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smb2glob.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/smb2inode.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smb2maperror.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/smb2misc.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/smb2ops.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smb2pdu.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smb2pdu.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/smb2proto.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/smb2status.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/smb2transport.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/smbdirect.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/smbdirect.h (99%)
> >> >>>> rename fs/{cifs => smbfs}/smbencrypt.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/smberr.h (100%)
> >> >>>> rename fs/{cifs/cifsfs.h => smbfs/smbfs.h} (97%)
> >> >>>> rename fs/{cifs => smbfs}/trace.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/trace.h (100%)
> >> >>>> rename fs/{cifs => smbfs}/transport.c (99%)
> >> >>>> rename fs/{cifs => smbfs}/unc.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/winucase.c (100%)
> >> >>>> rename fs/{cifs => smbfs}/xattr.c (98%)
> >> >>>>
> >> >>>
> >> >>
> >
> >
> >
> >--
> >Thanks,
> >
> >Steve



-- 
Thanks,

Steve
