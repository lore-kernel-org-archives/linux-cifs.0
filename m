Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234EDC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 21:25:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3BC360F8F
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 21:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhINV0c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Sep 2021 17:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhINV0c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Sep 2021 17:26:32 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1521CC061574;
        Tue, 14 Sep 2021 14:25:14 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id k4so1368418lfj.7;
        Tue, 14 Sep 2021 14:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=p9Di1H/sPScsBnJhT6+8DvY3hxXtr8Z+jopctHhwJjw=;
        b=TDQuSjwYOZvrYdxcQUXG6Bc4x1ic56uWkxXqM6+R/XWnVlf6OG6RAJjU5iHhRnKjBA
         6ytT+U9woL17V4ajqDtEKIm/rVcs+Se/JCPdQbbFVek/sAm1DI1boTYE92tHN20ETyNm
         2n83v9rnRxKCXNrNZSUW1zocXwsl/upZKFiyjycfyzF1EiVoczk+bWHG5ukWLr2YVdcT
         +V/jk241L4HEm6UGNr7D+vO3S95wc50copXCkiVqp36H2H3rMPzRte+p/7MNGdWHfsLH
         5XUQXkfvpFJVrU9vQ2H5LUo1bpORwM+0EINAXFmFapRLzrGDTZz0EhlYfw8SkY1xjFbg
         uL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=p9Di1H/sPScsBnJhT6+8DvY3hxXtr8Z+jopctHhwJjw=;
        b=P/HhP4oe3/7EG/vC+COli5g8FxGxBToNgQcyhYzs54te/26Tdp45zYnBEwWxRUYexr
         0VYnvahiM6j2jtaYUx1A3708tUj2SxXZ4Qc9PaWSYi6eAzwHWwELrAlY/2N9bzXljBTm
         sRfMiObkoJHnWtZU+XHtScFOuP/s0D8bdgc4PHL4S1lkJouurbqXKQ5/vwlQ3EmoxZrE
         PVx2Cdjg3QNSLhdIEaX1spa6rBpP5QHcJf81j+zXJyNCP8VUZXueQ+O2YNg3aC81zYKe
         +f4C0suTyxy086r0+odRShFAfzTvivdcOD/dvmTsMg9+qdUPLS55lMheXdH4KlB1yfXm
         4wSA==
X-Gm-Message-State: AOAM532+PsrzkfPfAWyxO4daAfP5FNbt6yVsqU2jfGcEJhP3yq2lhKY4
        yk2mdYRcec8BarCQJ+t/DEtAoqDa337c+77b2eDZTTRqNeo=
X-Google-Smtp-Source: ABdhPJwBG/ysp5mH3EGjmvFj84gBOsSjxyEzON0R1x21Vt7YYV49n6T4DGQZik0j7XNFrNAFtcWnz/6GLbn5Rxm+FjU=
X-Received: by 2002:a19:c388:: with SMTP id t130mr533170lff.601.1631654712244;
 Tue, 14 Sep 2021 14:25:12 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Sep 2021 16:25:01 -0500
Message-ID: <CAH2r5msxj6Wy_2KJYECdVxdMPupKsvjPKRzk9B3+a1AA4ayvPg@mail.gmail.com>
Subject: [GIT PULL] rename fs/cifs source directory to fs/smbfs_client
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f:

  Linux 5.15-rc1 (2021-09-12 16:28:37 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git
tags/5.15-rc1-cifs-smbfs_client-rename

for you to fetch changes up to c1abf13059571edd59d42d676ffe593fb987c019:

  cifs: rename uapi/linux/cifs directory to uapi/linux/smbfs_client
(2021-09-14 00:22:02 -0500)

----------------------------------------------------------------
4 cifs fixes, all relating to renaming fs/cifs source directory to the
less confusing name "fs/smbfs_client":

- rename the fs/cifs directory to fs/smbfs_client, and the corresponding
    include/uapi/linux/cifs directory
- remove the path name from the headers of various cifs/smb3 files
    (also fixes a checkpatch warning)
- fix the kernel-doc format of two files (to avoid kernel test robot warnings
    due to the move)

In a future release we could consider renaming cifs.ko itself but that requires
broader changes than renaming the source code directory.
----------------------------------------------------------------
Steve French (4):
      cifs: remove pathname for file from SPDX header
      cifs: fix incorrect kernel doc comments
      cifs: rename fs/cifs directory to fs/smbfs_client
      cifs: rename uapi/linux/cifs directory to uapi/linux/smbfs_client

 Documentation/admin-guide/cifs/changes.rst               |  2 +-
 Documentation/admin-guide/cifs/usage.rst                 | 14 +++++++-------
 Documentation/filesystems/cifs/cifsroot.rst              |  2 +-
 Documentation/userspace-api/ioctl/ioctl-number.rst       |  2 +-
 MAINTAINERS                                              |  4 ++--
 fs/Kconfig                                               |  2 +-
 fs/Makefile                                              |  2 +-
 fs/{cifs => smbfs_client}/Kconfig                        |  0
 fs/{cifs => smbfs_client}/Makefile                       |  0
 fs/{cifs => smbfs_client}/asn1.c                         |  0
 fs/{cifs => smbfs_client}/cache.c                        |  2 +-
 fs/{cifs => smbfs_client}/cifs_debug.c                   |  1 -
 fs/{cifs => smbfs_client}/cifs_debug.h                   |  0
 fs/{cifs => smbfs_client}/cifs_dfs_ref.c                 |  0
 fs/{cifs => smbfs_client}/cifs_fs_sb.h                   |  1 -
 fs/{cifs => smbfs_client}/cifs_ioctl.h                   |  1 -
 fs/{cifs => smbfs_client}/cifs_spnego.c                  |  2 +-
 fs/{cifs => smbfs_client}/cifs_spnego.h                  |  2 +-
 fs/{cifs => smbfs_client}/cifs_spnego_negtokeninit.asn1  |  0
 fs/{cifs => smbfs_client}/cifs_swn.c                     |  2 +-
 fs/{cifs => smbfs_client}/cifs_swn.h                     |  0
 fs/{cifs => smbfs_client}/cifs_unicode.c                 |  1 -
 fs/{cifs => smbfs_client}/cifs_unicode.h                 |  0
 fs/{cifs => smbfs_client}/cifs_uniupr.h                  |  0
 fs/{cifs => smbfs_client}/cifsacl.c                      |  1 -
 fs/{cifs => smbfs_client}/cifsacl.h                      |  1 -
 fs/{cifs => smbfs_client}/cifsencrypt.c                  |  1 -
 fs/{cifs => smbfs_client}/cifsfs.c                       |  1 -
 fs/{cifs => smbfs_client}/cifsfs.h                       |  1 -
 fs/{cifs => smbfs_client}/cifsglob.h                     |  3 +--
 fs/{cifs => smbfs_client}/cifspdu.h                      |  1 -
 fs/{cifs => smbfs_client}/cifsproto.h                    |  1 -
 fs/{cifs => smbfs_client}/cifsroot.c                     |  0
 fs/{cifs => smbfs_client}/cifssmb.c                      |  1 -
 fs/{cifs => smbfs_client}/connect.c                      | 13 ++++++++++---
 fs/{cifs => smbfs_client}/dfs_cache.c                    |  0
 fs/{cifs => smbfs_client}/dfs_cache.h                    |  0
 fs/{cifs => smbfs_client}/dir.c                          |  1 -
 fs/{cifs => smbfs_client}/dns_resolve.c                  |  1 -
 fs/{cifs => smbfs_client}/dns_resolve.h                  |  4 ++--
 fs/{cifs => smbfs_client}/export.c                       |  1 -
 fs/{cifs => smbfs_client}/file.c                         |  1 -
 fs/{cifs => smbfs_client}/fs_context.c                   |  0
 fs/{cifs => smbfs_client}/fs_context.h                   |  0
 fs/{cifs => smbfs_client}/fscache.c                      |  2 +-
 fs/{cifs => smbfs_client}/fscache.h                      |  2 +-
 fs/{cifs => smbfs_client}/inode.c                        |  1 -
 fs/{cifs => smbfs_client}/ioctl.c                        |  3 +--
 fs/{cifs => smbfs_client}/link.c                         |  1 -
 fs/{cifs => smbfs_client}/misc.c                         |  1 -
 fs/{cifs => smbfs_client}/netlink.c                      |  2 +-
 fs/{cifs => smbfs_client}/netlink.h                      |  0
 fs/{cifs => smbfs_client}/netmisc.c                      |  1 -
 fs/{cifs => smbfs_client}/nterr.c                        |  0
 fs/{cifs => smbfs_client}/nterr.h                        |  0
 fs/{cifs => smbfs_client}/ntlmssp.h                      |  1 -
 fs/{cifs => smbfs_client}/readdir.c                      |  1 -
 fs/{cifs => smbfs_client}/rfc1002pdu.h                   |  1 -
 fs/{cifs => smbfs_client}/sess.c                         |  1 -
 fs/{cifs => smbfs_client}/smb1ops.c                      |  0
 fs/{cifs => smbfs_client}/smb2file.c                     |  1 -
 fs/{cifs => smbfs_client}/smb2glob.h                     |  1 -
 fs/{cifs => smbfs_client}/smb2inode.c                    |  1 -
 fs/{cifs => smbfs_client}/smb2maperror.c                 |  0
 fs/{cifs => smbfs_client}/smb2misc.c                     |  1 -
 fs/{cifs => smbfs_client}/smb2ops.c                      |  0
 fs/{cifs => smbfs_client}/smb2pdu.c                      |  1 -
 fs/{cifs => smbfs_client}/smb2pdu.h                      |  1 -
 fs/{cifs => smbfs_client}/smb2proto.h                    |  1 -
 fs/{cifs => smbfs_client}/smb2status.h                   |  1 -
 fs/{cifs => smbfs_client}/smb2transport.c                |  1 -
 fs/{cifs => smbfs_client}/smbdirect.c                    |  0
 fs/{cifs => smbfs_client}/smbdirect.h                    |  0
 fs/{cifs => smbfs_client}/smbencrypt.c                   |  0
 fs/{cifs => smbfs_client}/smberr.h                       |  1 -
 fs/{cifs => smbfs_client}/trace.c                        |  0
 fs/{cifs => smbfs_client}/trace.h                        |  0
 fs/{cifs => smbfs_client}/transport.c                    |  1 -
 fs/{cifs => smbfs_client}/unc.c                          |  0
 fs/{cifs => smbfs_client}/winucase.c                     |  1 -
 fs/{cifs => smbfs_client}/xattr.c                        |  1 -
 fs/smbfs_common/smbfsctl.h                               |  2 +-
 include/uapi/linux/{cifs => smbfs_client}/cifs_mount.h   |  1 -
 include/uapi/linux/{cifs => smbfs_client}/cifs_netlink.h |  0
 84 files changed, 36 insertions(+), 69 deletions(-)
 rename fs/{cifs => smbfs_client}/Kconfig (100%)
 rename fs/{cifs => smbfs_client}/Makefile (100%)
 rename fs/{cifs => smbfs_client}/asn1.c (100%)
 rename fs/{cifs => smbfs_client}/cache.c (97%)
 rename fs/{cifs => smbfs_client}/cifs_debug.c (99%)
 rename fs/{cifs => smbfs_client}/cifs_debug.h (100%)
 rename fs/{cifs => smbfs_client}/cifs_dfs_ref.c (100%)
 rename fs/{cifs => smbfs_client}/cifs_fs_sb.h (99%)
 rename fs/{cifs => smbfs_client}/cifs_ioctl.h (99%)
 rename fs/{cifs => smbfs_client}/cifs_spnego.c (98%)
 rename fs/{cifs => smbfs_client}/cifs_spnego.h (92%)
 rename fs/{cifs => smbfs_client}/cifs_spnego_negtokeninit.asn1 (100%)
 rename fs/{cifs => smbfs_client}/cifs_swn.c (99%)
 rename fs/{cifs => smbfs_client}/cifs_swn.h (100%)
 rename fs/{cifs => smbfs_client}/cifs_unicode.c (99%)
 rename fs/{cifs => smbfs_client}/cifs_unicode.h (100%)
 rename fs/{cifs => smbfs_client}/cifs_uniupr.h (100%)
 rename fs/{cifs => smbfs_client}/cifsacl.c (99%)
 rename fs/{cifs => smbfs_client}/cifsacl.h (99%)
 rename fs/{cifs => smbfs_client}/cifsencrypt.c (99%)
 rename fs/{cifs => smbfs_client}/cifsfs.c (99%)
 rename fs/{cifs => smbfs_client}/cifsfs.h (99%)
 rename fs/{cifs => smbfs_client}/cifsglob.h (99%)
 rename fs/{cifs => smbfs_client}/cifspdu.h (99%)
 rename fs/{cifs => smbfs_client}/cifsproto.h (99%)
 rename fs/{cifs => smbfs_client}/cifsroot.c (100%)
 rename fs/{cifs => smbfs_client}/cifssmb.c (99%)
 rename fs/{cifs => smbfs_client}/connect.c (99%)
 rename fs/{cifs => smbfs_client}/dfs_cache.c (100%)
 rename fs/{cifs => smbfs_client}/dfs_cache.h (100%)
 rename fs/{cifs => smbfs_client}/dir.c (99%)
 rename fs/{cifs => smbfs_client}/dns_resolve.c (98%)
 rename fs/{cifs => smbfs_client}/dns_resolve.h (71%)
 rename fs/{cifs => smbfs_client}/export.c (98%)
 rename fs/{cifs => smbfs_client}/file.c (99%)
 rename fs/{cifs => smbfs_client}/fs_context.c (100%)
 rename fs/{cifs => smbfs_client}/fs_context.h (100%)
 rename fs/{cifs => smbfs_client}/fscache.c (99%)
 rename fs/{cifs => smbfs_client}/fscache.h (98%)
 rename fs/{cifs => smbfs_client}/inode.c (99%)
 rename fs/{cifs => smbfs_client}/ioctl.c (99%)
 rename fs/{cifs => smbfs_client}/link.c (99%)
 rename fs/{cifs => smbfs_client}/misc.c (99%)
 rename fs/{cifs => smbfs_client}/netlink.c (97%)
 rename fs/{cifs => smbfs_client}/netlink.h (100%)
 rename fs/{cifs => smbfs_client}/netmisc.c (99%)
 rename fs/{cifs => smbfs_client}/nterr.c (100%)
 rename fs/{cifs => smbfs_client}/nterr.h (100%)
 rename fs/{cifs => smbfs_client}/ntlmssp.h (99%)
 rename fs/{cifs => smbfs_client}/readdir.c (99%)
 rename fs/{cifs => smbfs_client}/rfc1002pdu.h (98%)
 rename fs/{cifs => smbfs_client}/sess.c (99%)
 rename fs/{cifs => smbfs_client}/smb1ops.c (100%)
 rename fs/{cifs => smbfs_client}/smb2file.c (99%)
 rename fs/{cifs => smbfs_client}/smb2glob.h (98%)
 rename fs/{cifs => smbfs_client}/smb2inode.c (99%)
 rename fs/{cifs => smbfs_client}/smb2maperror.c (100%)
 rename fs/{cifs => smbfs_client}/smb2misc.c (99%)
 rename fs/{cifs => smbfs_client}/smb2ops.c (100%)
 rename fs/{cifs => smbfs_client}/smb2pdu.c (99%)
 rename fs/{cifs => smbfs_client}/smb2pdu.h (99%)
 rename fs/{cifs => smbfs_client}/smb2proto.h (99%)
 rename fs/{cifs => smbfs_client}/smb2status.h (99%)
 rename fs/{cifs => smbfs_client}/smb2transport.c (99%)
 rename fs/{cifs => smbfs_client}/smbdirect.c (100%)
 rename fs/{cifs => smbfs_client}/smbdirect.h (100%)
 rename fs/{cifs => smbfs_client}/smbencrypt.c (100%)
 rename fs/{cifs => smbfs_client}/smberr.h (99%)
 rename fs/{cifs => smbfs_client}/trace.c (100%)
 rename fs/{cifs => smbfs_client}/trace.h (100%)
 rename fs/{cifs => smbfs_client}/transport.c (99%)
 rename fs/{cifs => smbfs_client}/unc.c (100%)
 rename fs/{cifs => smbfs_client}/winucase.c (99%)
 rename fs/{cifs => smbfs_client}/xattr.c (99%)
 rename include/uapi/linux/{cifs => smbfs_client}/cifs_mount.h (96%)
 rename include/uapi/linux/{cifs => smbfs_client}/cifs_netlink.h (100%)

-- 
Thanks,

Steve
