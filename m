Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ED24C11F64
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Jun 2021 23:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF97961CF1
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Jun 2021 23:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhF1XzC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Jun 2021 19:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbhF1Xy5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Jun 2021 19:54:57 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D034CC061574;
        Mon, 28 Jun 2021 16:52:30 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id k10so35820204lfv.13;
        Mon, 28 Jun 2021 16:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=0mhGyeclUmRPe+XYJKNXM5ZGwYfGJsYXJxWFl3k8OrY=;
        b=bPgBoW2VqfbuS9v1KRayMGZAZOotrCmKS/hP/Y4ISyci+Bo/MGR1lvNwq1aAtXQ80N
         it8SIqJm31HsEDFnIHOpAGC+h70FKUYI//XmbW/5g2E0JCZ6PIde/SPWbFITupOoto74
         zhNFcQ38fcdzsK03yBn7j6eIU5B6fBIOKm07eEpobNlFNCzAALdsTCuWCk5qXn4PMI/X
         uSAYfkhojS8LzMa4SPA9Bo+nZYMWL09v2NqQGxfEao/qEpmAROrknMJFl5WLfPSjoWLt
         7hAoLy4DXjt5ql1jeA8vqh1nzHhED83tU3PvzyjMz/U0v4zVTUFhVHx3FlnPmo1HYZjB
         m9Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=0mhGyeclUmRPe+XYJKNXM5ZGwYfGJsYXJxWFl3k8OrY=;
        b=aeDN0qZrWdsVBuwWEQSQJY8KOWh8hiFu0uS3j2bJwo2MMo9+Ri9r0v+HmKDnyQi65i
         njiKIrS2z2QO/Qpfq9LKgCTIDTxQ7t2gvODOqGyX6KPIZ03aXVAtz7ACG9DcaPy4B328
         rP9enb6XhDgw35hwR7R0V/0keFUH279hx9K62rhrCNkmLefq04m06ZdSEPCIyNuKSky/
         aa2PLoIvRAh6s4u155pYEonsCULW3WSYJT7cGQNSbFcVuH0sHUabxlyvQ/FWm2G5Xug3
         Vze1s+yZWg6xDOpn/yiuGXS95g3pIZ/jolL+URlKyxilHGzWxEbfa8RfttLZfacycQ13
         +eTg==
X-Gm-Message-State: AOAM531ICRMLDJkQqwJwbvc0RY9k6MjQBOLUaAdehAIJDiV/1E4Asv1E
        o3217bx9mXygxWdLWKX2Djm+f0gFh9J+lywISojtY2FqIG3zlQ==
X-Google-Smtp-Source: ABdhPJyCF923I6WEbPeCYFm+7q2qwF+0/iTZj1HJoqhgJsOyeXTIqA552KVqTErWT8vOMzUHaIT+pkk/PQ51/VMM66o=
X-Received: by 2002:a19:6712:: with SMTP id b18mr21151829lfc.184.1624924348611;
 Mon, 28 Jun 2021 16:52:28 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 28 Jun 2021 18:52:17 -0500
Message-ID: <CAH2r5mursRhnq7Cgk-kG-kKeV=F-NL9XaGsEREo4WR-NBAhGPA@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
13311e74253fe64329390df80bed3f07314ddd61:

  Linux 5.13-rc7 (2021-06-20 15:03:15 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.14-rc-smb3-fixes-part1

for you to fetch changes up to 0fa757b5d3ea6e3d3d59f0e0d34c8214b8643b8f:

  smb3: prevent races updating CurrentMid (2021-06-25 14:02:26 -0500)

----------------------------------------------------------------
38 cifs/smb3 fixes including:
- improvement to fallocate emulation
- 9 DFS fixes
- 2 minor multichannel fixes
- Various cleanup patches, many to address Coverity warnings

There are various features still being tested that are not included
in this PR but that should be ready soon, including some important
multichannel fixes, support for the new signing negotiate context as
well as an important multiuser uid fix.  We are also still working on
the switchover to netfs for readahead so that is not included in this
series yet.
----------------------------------------------------------------
Aurelien Aptel (1):
      cifs: fix ipv6 formating in cifs_ses_add_channel

Baokun Li (3):
      cifs: fix doc warnings in cifs_dfs_ref.c
      cifs: convert list_for_each to entry variant in smb2misc.c
      cifs: convert list_for_each to entry variant in cifs_debug.c

Colin Ian King (1):
      cifs: remove redundant initialization of variable rc

Dan Carpenter (1):
      cifs: fix NULL dereference in smb2_check_message()

Hyunchul Lee (1):
      cifs: decoding negTokenInit with generic ASN1 decoder

Kees Cook (1):
      cifs: Avoid field over-reading memcpy()

Paulo Alcantara (9):
      cifs: do not send tree disconnect to ipc shares
      cifs: get rid of @noreq param in __dfs_cache_find()
      cifs: keep referral server sessions alive
      cifs: handle different charsets in dfs cache
      cifs: fix path comparison and hash calc
      cifs: set a minimum of 2 minutes for refreshing dfs cache
      cifs: do not share tcp servers with dfs mounts
      cifs: avoid starvation when refreshing dfs cache
      cifs: fix check of dfs interlinks

Rikard Falkeborn (1):
      cifs: Constify static struct genl_ops

Ronnie Sahlberg (2):
      cifs: improve fallocate emulation
      cifs: avoid extra calls in posix_info_parse

Shyam Prasad N (1):
      cifs: missed ref-counting smb session in find

Steve French (15):
      cifs: remove duplicated prototype
      cifs: enable extended stats by default
      cifs: use SPDX-Licence-Identifier
      cifs: fix unneeded null check
      smb3: fix uninitialized value for port in witness protocol move
      cifs: fix SMB1 error path in cifs_get_file_info_unix
      smb311: remove dead code for non compounded posix query info
      smbdirect: missing rc checks while waiting for rdma events
      SMB3: Add new info level for query directory
      cifs: remove two cases where rc is set unnecessarily in sid_to_id
      cifs: missing null check for newinode pointer
      smb3: fix possible access to uninitialized pointer to DACL
      cifs: missing null pointer check in cifs_mount
      cifs: fix missing spinlock around update to ses->status
      smb3: prevent races updating CurrentMid

Thiago Rafael Becker (1):
      cifs: retry lookup and readdir when EAGAIN is returned.

YueHaibing (1):
      cifs: Remove unused inline function is_sysvol_or_netlogon()

 fs/cifs/Kconfig                       |    6 +-
 fs/cifs/Makefile                      |    8 +-
 fs/cifs/asn1.c                        |  623 ++-----------------
 fs/cifs/cache.c                       |   14 +-
 fs/cifs/cifs_debug.c                  |   24 +-
 fs/cifs/cifs_debug.h                  |    2 +-
 fs/cifs/cifs_dfs_ref.c                |    2 +-
 fs/cifs/cifs_fs_sb.h                  |   18 +-
 fs/cifs/cifs_ioctl.h                  |   11 +-
 fs/cifs/cifs_spnego.c                 |   14 +-
 fs/cifs/cifs_spnego.h                 |   14 +-
 fs/cifs/cifs_spnego_negtokeninit.asn1 |   40 ++
 fs/cifs/cifs_swn.c                    |   10 +-
 fs/cifs/cifsacl.c                     |   18 +-
 fs/cifs/cifsacl.h                     |   15 +-
 fs/cifs/cifsencrypt.c                 |   14 +-
 fs/cifs/cifsfs.c                      |   14 +-
 fs/cifs/cifsfs.h                      |   14 +-
 fs/cifs/cifsglob.h                    |   20 +-
 fs/cifs/cifspdu.h                     |   14 +-
 fs/cifs/cifsproto.h                   |   14 +-
 fs/cifs/cifssmb.c                     |   16 +-
 fs/cifs/connect.c                     |  159 +++--
 fs/cifs/dfs_cache.c                   | 1079 +++++++++++++++------------------
 fs/cifs/dfs_cache.h                   |   45 +-
 fs/cifs/dir.c                         |   27 +-
 fs/cifs/dns_resolve.c                 |   14 +-
 fs/cifs/dns_resolve.h                 |   14 +-
 fs/cifs/export.c                      |   14 +-
 fs/cifs/file.c                        |   14 +-
 fs/cifs/fscache.c                     |   14 +-
 fs/cifs/fscache.h                     |   14 +-
 fs/cifs/inode.c                       |   19 +-
 fs/cifs/ioctl.c                       |   14 +-
 fs/cifs/link.c                        |   14 +-
 fs/cifs/misc.c                        |   14 +-
 fs/cifs/netlink.c                     |    2 +-
 fs/cifs/ntlmssp.h                     |   14 +-
 fs/cifs/readdir.c                     |   16 +-
 fs/cifs/rfc1002pdu.h                  |   14 +-
 fs/cifs/sess.c                        |   16 +-
 fs/cifs/smb2file.c                    |   14 +-
 fs/cifs/smb2glob.h                    |   11 +-
 fs/cifs/smb2inode.c                   |   14 +-
 fs/cifs/smb2maperror.c                |   14 +-
 fs/cifs/smb2misc.c                    |   52 +-
 fs/cifs/smb2ops.c                     |  140 +++++
 fs/cifs/smb2pdu.c                     |   49 +-
 fs/cifs/smb2pdu.h                     |   53 +-
 fs/cifs/smb2proto.h                   |   16 +-
 fs/cifs/smb2status.h                  |   14 +-
 fs/cifs/smb2transport.c               |   26 +-
 fs/cifs/smbdirect.c                   |   14 +-
 fs/cifs/smberr.h                      |   14 +-
 fs/cifs/smbfsctl.h                    |   14 +-
 fs/cifs/transport.c                   |   14 +-
 fs/cifs/xattr.c                       |   14 +-
 include/linux/oid_registry.h          |    8 +
 58 files changed, 974 insertions(+), 1949 deletions(-)
 create mode 100644 fs/cifs/cifs_spnego_negtokeninit.asn1
-- 
Thanks,

Steve
