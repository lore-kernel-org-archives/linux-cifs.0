Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5569FC00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 19:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiHAT6J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 15:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiHAT6J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 15:58:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79BA2F02F
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 12:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:To:From:Message-ID:CC;
        bh=mm9ky4+qxXfxjKVitebVHWamV/qPfTMFN6xr5FIbok0=; b=lZRZWy0Mdo3FvyrzTmLE3bsNPw
        MzapkjJfWspAbZT55o84jdc79fPQ6x5pbN8t449xYHjzQA7wKu6O0z1AVRRq/bojKMNjgtslEK4gW
        U7h4GR7MZJNFIe8OPjPE9ji3zIq8bIAovQdjd5Jg/PEd8QPufC7XV2DcRU/11D7nT3gLx/bK+cfps
        MVZrdJOEoJZZg77/CKSMXY7sSABTgf2eFF6PDVI6apKVAJeZF/wqPXvYzMIHCa9wxeJvTuJRAK8nS
        /g5UHP6412H05uZZOP2NFlSC7zErmraT5V3N98fUnttRw2pk4djitXyAY1muBc0z8VY7Pjm4reW+S
        tf3Npft/b69w8XkbGkabzuLWkX6FYIivmjM49wVjZr+9dzJI9rX7W1kfKN6+lzq9a52mk/6kMCll0
        aqb5kiUqCLno1o463DGlYY2IkkUnxOSBxkjZUFcbNwXaEt00gg3chVJ6CjRV6B9okOeEpqDXUUpds
        7KLptvwANDZP9GBeCgu9bGoi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oIbYD-007dFC-HC; Mon, 01 Aug 2022 19:58:05 +0000
Message-ID: <012fa69c76bac824c2e2dcc8dfaf9250723e502b.camel@samba.org>
Subject: Re: [RFC PATCH 0/3] Rename "cifs" module to "smbfs"
From:   Rowland Penny <rpenny@samba.org>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Date:   Mon, 01 Aug 2022 20:58:04 +0100
In-Reply-To: <20220801190933.27197-1-ematsumiya@suse.de>
References: <20220801190933.27197-1-ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 2022-08-01 at 16:09 -0300, Enzo Matsumiya via samba-technical
wrote:
> Hi,
> 
> As part of the ongoing effort to remove the "cifs" nomenclature from
> the
> Linux SMB client, I'm proposing the rename of the module to "smbfs".

Hi, this has absolutely nothing to do with myself, but Linux used
'smbfs' before it started to use 'cifs', so you are going back to an
old term. This could be confusing.

Rowland

> 
> As it's widely known, CIFS is associated to SMB1.0, which, in turn,
> is
> associated with the security issues it presented in the past. Using
> "SMBFS" makes clear what's the protocol in use for outsiders, but
> also
> unties it from any particular protocol version. It also fits in the
> already existing "fs/smbfs_common" and "fs/ksmbd" naming scheme.
> 
> This short patch series only changes directory names and
> includes/ifdefs in
> headers and source code, and updates docs to reflect the rename.
> Other
> than that, no source code/functionality is modified (WIP though).
> 
> Patch 1/3: effectively changes the module name to "smbfs" and create
> a
> 	   "cifs" module alias to maintain compatibility (a warning
> 	   should be added to indicate the complete removal/isolation
> of
> 	   CIFS/SMB1.0 code).
> Patch 2/3: rename the source-code directory to align with the new
> module
> 	   name
> Patch 3/3: update documentation references to "fs/cifs" or "cifs.ko"
> or
> 	   "cifs module" to use the new name
> 
> Enzo Matsumiya (3):
>   cifs: change module name to "smbfs.ko"
>   smbfs: rename directory "fs/cifs" -> "fs/smbfs"
>   smbfs: update doc references
> 
>  Documentation/admin-guide/index.rst           |   2 +-
>  .../admin-guide/{cifs => smbfs}/authors.rst   |   0
>  .../admin-guide/{cifs => smbfs}/changes.rst   |   4 +-
>  .../admin-guide/{cifs => smbfs}/index.rst     |   0
>  .../{cifs => smbfs}/introduction.rst          |   0
>  .../admin-guide/{cifs => smbfs}/todo.rst      |  12 +-
>  .../admin-guide/{cifs => smbfs}/usage.rst     | 168 +++++++++-------
> --
>  .../{cifs => smbfs}/winucase_convert.pl       |   0
>  Documentation/filesystems/index.rst           |   2 +-
>  .../filesystems/{cifs => smbfs}/cifsroot.rst  |  14 +-
>  .../filesystems/{cifs => smbfs}/index.rst     |   0
>  .../filesystems/{cifs => smbfs}/ksmbd.rst     |   2 +-
>  Documentation/networking/dns_resolver.rst     |   2 +-
>  .../translations/zh_CN/admin-guide/index.rst  |   2 +-
>  .../translations/zh_TW/admin-guide/index.rst  |   2 +-
>  fs/Kconfig                                    |   6 +-
>  fs/Makefile                                   |   2 +-
>  fs/cifs/Makefile                              |  34 ----
>  fs/{cifs => smbfs}/Kconfig                    | 108 +++++------
>  fs/smbfs/Makefile                             |  34 ++++
>  fs/{cifs => smbfs}/asn1.c                     |   0
>  fs/{cifs => smbfs}/cifs_debug.c               |  72 ++++----
>  fs/{cifs => smbfs}/cifs_debug.h               |   4 +-
>  fs/{cifs => smbfs}/cifs_dfs_ref.c             |   2 +-
>  fs/{cifs => smbfs}/cifs_fs_sb.h               |   0
>  fs/{cifs => smbfs}/cifs_ioctl.h               |   0
>  fs/{cifs => smbfs}/cifs_spnego.c              |   4 +-
>  fs/{cifs => smbfs}/cifs_spnego.h              |   0
>  .../cifs_spnego_negtokeninit.asn1             |   0
>  fs/{cifs => smbfs}/cifs_swn.c                 |   0
>  fs/{cifs => smbfs}/cifs_swn.h                 |   4 +-
>  fs/{cifs => smbfs}/cifs_unicode.c             |   0
>  fs/{cifs => smbfs}/cifs_unicode.h             |   0
>  fs/{cifs => smbfs}/cifs_uniupr.h              |   0
>  fs/{cifs => smbfs}/cifsacl.c                  |   6 +-
>  fs/{cifs => smbfs}/cifsacl.h                  |   0
>  fs/{cifs => smbfs}/cifsencrypt.c              |   0
>  fs/{cifs => smbfs}/cifsglob.h                 |  26 +--
>  fs/{cifs => smbfs}/cifspdu.h                  |   6 +-
>  fs/{cifs => smbfs}/cifsproto.h                |  10 +-
>  fs/{cifs => smbfs}/cifsroot.c                 |   0
>  fs/{cifs => smbfs}/cifssmb.c                  |  14 +-
>  fs/{cifs => smbfs}/connect.c                  |  36 ++--
>  fs/{cifs/cifsfs.c => smbfs/core.c}            |  49 ++---
>  fs/{cifs => smbfs}/dfs_cache.c                |   2 +-
>  fs/{cifs => smbfs}/dfs_cache.h                |   0
>  fs/{cifs => smbfs}/dir.c                      |   2 +-
>  fs/{cifs => smbfs}/dns_resolve.c              |   0
>  fs/{cifs => smbfs}/dns_resolve.h              |   0
>  fs/{cifs => smbfs}/export.c                   |   8 +-
>  fs/{cifs => smbfs}/file.c                     |  16 +-
>  fs/{cifs => smbfs}/fs_context.c               |  20 +--
>  fs/{cifs => smbfs}/fs_context.h               |   0
>  fs/{cifs => smbfs}/fscache.c                  |   0
>  fs/{cifs => smbfs}/fscache.h                  |   6 +-
>  fs/{cifs => smbfs}/inode.c                    |  10 +-
>  fs/{cifs => smbfs}/ioctl.c                    |   6 +-
>  fs/{cifs => smbfs}/link.c                     |   2 +-
>  fs/{cifs => smbfs}/misc.c                     |  14 +-
>  fs/{cifs => smbfs}/netlink.c                  |   0
>  fs/{cifs => smbfs}/netlink.h                  |   0
>  fs/{cifs => smbfs}/netmisc.c                  |   2 +-
>  fs/{cifs => smbfs}/nterr.c                    |   0
>  fs/{cifs => smbfs}/nterr.h                    |   0
>  fs/{cifs => smbfs}/ntlmssp.h                  |   2 +-
>  fs/{cifs => smbfs}/readdir.c                  |   4 +-
>  fs/{cifs => smbfs}/rfc1002pdu.h               |   0
>  fs/{cifs => smbfs}/sess.c                     |  10 +-
>  fs/{cifs => smbfs}/smb1ops.c                  |   4 +-
>  fs/{cifs => smbfs}/smb2file.c                 |   2 +-
>  fs/{cifs => smbfs}/smb2glob.h                 |   0
>  fs/{cifs => smbfs}/smb2inode.c                |   2 +-
>  fs/{cifs => smbfs}/smb2maperror.c             |   0
>  fs/{cifs => smbfs}/smb2misc.c                 |   0
>  fs/{cifs => smbfs}/smb2ops.c                  |  32 ++--
>  fs/{cifs => smbfs}/smb2pdu.c                  |  22 +--
>  fs/{cifs => smbfs}/smb2pdu.h                  |   0
>  fs/{cifs => smbfs}/smb2proto.h                |   0
>  fs/{cifs => smbfs}/smb2status.h               |   0
>  fs/{cifs => smbfs}/smb2transport.c            |   2 +-
>  fs/{cifs => smbfs}/smbdirect.c                |   0
>  fs/{cifs => smbfs}/smbdirect.h                |   2 +-
>  fs/{cifs => smbfs}/smbencrypt.c               |   0
>  fs/{cifs => smbfs}/smberr.h                   |   0
>  fs/{cifs/cifsfs.h => smbfs/smbfs.h}           |  12 +-
>  fs/{cifs => smbfs}/trace.c                    |   0
>  fs/{cifs => smbfs}/trace.h                    |   0
>  fs/{cifs => smbfs}/transport.c                |   4 +-
>  fs/{cifs => smbfs}/unc.c                      |   0
>  fs/{cifs => smbfs}/winucase.c                 |   0
>  fs/{cifs => smbfs}/xattr.c                    |  18 +-
>  91 files changed, 414 insertions(+), 417 deletions(-)
>  rename Documentation/admin-guide/{cifs => smbfs}/authors.rst (100%)
>  rename Documentation/admin-guide/{cifs => smbfs}/changes.rst (73%)
>  rename Documentation/admin-guide/{cifs => smbfs}/index.rst (100%)
>  rename Documentation/admin-guide/{cifs => smbfs}/introduction.rst
> (100%)
>  rename Documentation/admin-guide/{cifs => smbfs}/todo.rst (95%)
>  rename Documentation/admin-guide/{cifs => smbfs}/usage.rst (87%)
>  rename Documentation/admin-guide/{cifs => smbfs}/winucase_convert.pl
> (100%)
>  rename Documentation/filesystems/{cifs => smbfs}/cifsroot.rst (85%)
>  rename Documentation/filesystems/{cifs => smbfs}/index.rst (100%)
>  rename Documentation/filesystems/{cifs => smbfs}/ksmbd.rst (99%)
>  delete mode 100644 fs/cifs/Makefile
>  rename fs/{cifs => smbfs}/Kconfig (72%)
>  create mode 100644 fs/smbfs/Makefile
>  rename fs/{cifs => smbfs}/asn1.c (100%)
>  rename fs/{cifs => smbfs}/cifs_debug.c (96%)
>  rename fs/{cifs => smbfs}/cifs_debug.h (98%)
>  rename fs/{cifs => smbfs}/cifs_dfs_ref.c (99%)
>  rename fs/{cifs => smbfs}/cifs_fs_sb.h (100%)
>  rename fs/{cifs => smbfs}/cifs_ioctl.h (100%)
>  rename fs/{cifs => smbfs}/cifs_spnego.c (98%)
>  rename fs/{cifs => smbfs}/cifs_spnego.h (100%)
>  rename fs/{cifs => smbfs}/cifs_spnego_negtokeninit.asn1 (100%)
>  rename fs/{cifs => smbfs}/cifs_swn.c (100%)
>  rename fs/{cifs => smbfs}/cifs_swn.h (95%)
>  rename fs/{cifs => smbfs}/cifs_unicode.c (100%)
>  rename fs/{cifs => smbfs}/cifs_unicode.h (100%)
>  rename fs/{cifs => smbfs}/cifs_uniupr.h (100%)
>  rename fs/{cifs => smbfs}/cifsacl.c (99%)
>  rename fs/{cifs => smbfs}/cifsacl.h (100%)
>  rename fs/{cifs => smbfs}/cifsencrypt.c (100%)
>  rename fs/{cifs => smbfs}/cifsglob.h (99%)
>  rename fs/{cifs => smbfs}/cifspdu.h (99%)
>  rename fs/{cifs => smbfs}/cifsproto.h (99%)
>  rename fs/{cifs => smbfs}/cifsroot.c (100%)
>  rename fs/{cifs => smbfs}/cifssmb.c (99%)
>  rename fs/{cifs => smbfs}/connect.c (99%)
>  rename fs/{cifs/cifsfs.c => smbfs/core.c} (98%)
>  rename fs/{cifs => smbfs}/dfs_cache.c (99%)
>  rename fs/{cifs => smbfs}/dfs_cache.h (100%)
>  rename fs/{cifs => smbfs}/dir.c (99%)
>  rename fs/{cifs => smbfs}/dns_resolve.c (100%)
>  rename fs/{cifs => smbfs}/dns_resolve.h (100%)
>  rename fs/{cifs => smbfs}/export.c (91%)
>  rename fs/{cifs => smbfs}/file.c (99%)
>  rename fs/{cifs => smbfs}/fs_context.c (99%)
>  rename fs/{cifs => smbfs}/fs_context.h (100%)
>  rename fs/{cifs => smbfs}/fscache.c (100%)
>  rename fs/{cifs => smbfs}/fscache.h (98%)
>  rename fs/{cifs => smbfs}/inode.c (99%)
>  rename fs/{cifs => smbfs}/ioctl.c (99%)
>  rename fs/{cifs => smbfs}/link.c (99%)
>  rename fs/{cifs => smbfs}/misc.c (99%)
>  rename fs/{cifs => smbfs}/netlink.c (100%)
>  rename fs/{cifs => smbfs}/netlink.h (100%)
>  rename fs/{cifs => smbfs}/netmisc.c (99%)
>  rename fs/{cifs => smbfs}/nterr.c (100%)
>  rename fs/{cifs => smbfs}/nterr.h (100%)
>  rename fs/{cifs => smbfs}/ntlmssp.h (98%)
>  rename fs/{cifs => smbfs}/readdir.c (99%)
>  rename fs/{cifs => smbfs}/rfc1002pdu.h (100%)
>  rename fs/{cifs => smbfs}/sess.c (99%)
>  rename fs/{cifs => smbfs}/smb1ops.c (99%)
>  rename fs/{cifs => smbfs}/smb2file.c (99%)
>  rename fs/{cifs => smbfs}/smb2glob.h (100%)
>  rename fs/{cifs => smbfs}/smb2inode.c (99%)
>  rename fs/{cifs => smbfs}/smb2maperror.c (100%)
>  rename fs/{cifs => smbfs}/smb2misc.c (100%)
>  rename fs/{cifs => smbfs}/smb2ops.c (99%)
>  rename fs/{cifs => smbfs}/smb2pdu.c (99%)
>  rename fs/{cifs => smbfs}/smb2pdu.h (100%)
>  rename fs/{cifs => smbfs}/smb2proto.h (100%)
>  rename fs/{cifs => smbfs}/smb2status.h (100%)
>  rename fs/{cifs => smbfs}/smb2transport.c (99%)
>  rename fs/{cifs => smbfs}/smbdirect.c (100%)
>  rename fs/{cifs => smbfs}/smbdirect.h (99%)
>  rename fs/{cifs => smbfs}/smbencrypt.c (100%)
>  rename fs/{cifs => smbfs}/smberr.h (100%)
>  rename fs/{cifs/cifsfs.h => smbfs/smbfs.h} (97%)
>  rename fs/{cifs => smbfs}/trace.c (100%)
>  rename fs/{cifs => smbfs}/trace.h (100%)
>  rename fs/{cifs => smbfs}/transport.c (99%)
>  rename fs/{cifs => smbfs}/unc.c (100%)
>  rename fs/{cifs => smbfs}/winucase.c (100%)
>  rename fs/{cifs => smbfs}/xattr.c (98%)
> 

