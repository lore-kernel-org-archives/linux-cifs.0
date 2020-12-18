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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 873E5C2BBD4
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 01:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BD76238A0
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Dec 2020 01:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgLRBG1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Dec 2020 20:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729123AbgLRBG0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Dec 2020 20:06:26 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E85C0617A7;
        Thu, 17 Dec 2020 17:05:46 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id a9so1275735lfh.2;
        Thu, 17 Dec 2020 17:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=iZu+5kJkRj6Y0M+8l83j2qU98UklsMnUJt7avozApts=;
        b=uuZxvDf5Ll7LoUr5/ipS58rPk5pPIyD/YZ+TxG2wdxCfFNyaZXHfHA3lWs3sWxJfPM
         oDnM+yFMt2dE4EUefv8qMq1HLPre8F7oCbavaUcx0+65l2YjuCBMrR2Coivg0kKtt8+u
         xFbIt7EU9RIZ2Yp+zdQLYnI3ZD+NHdPgMu0tl/DB5s/1mU97268+FOGLXKKS8KsCSaQv
         c7HMMnfpjmbbAI8f8KyOV74wR73El+681a9Ezd95OEfghJMh+uMdYhKuqAusbEQkp9jn
         rpOuFcV84sIuhQLZeBSR/IEEnOd7AAd2IPwsv1FM9cNsWMdNemWJvz+oPYY6g/qx4W56
         EvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=iZu+5kJkRj6Y0M+8l83j2qU98UklsMnUJt7avozApts=;
        b=Doou19Zp3V8X5tkVMeJiNiYs/G1ub3Fhmh/YTlg24Q3NPvuSgGgqDRkrYBB8mHJ3i+
         1x8rxWTCOQxXDHN4o9mhTie2n1gNvCKBNLO+xZXMn+1Krw3VT1q3sHmrfoiwFtw2+naO
         V2+f4mKaaE2p9P7xufBoRb5emuLKGeKhQM2jq8tAm0zU0941fzoXb0Blhjdk9mWJlyU0
         cxrtO52uQD5wQLe3amOPztmSYp55zuqb5/Z8VB5yeASb9f8RMNKAtb6P3qxocMcqSO1e
         fOVzkB3W/O2hhp+q4NO2TTPsbnw+7p6ND1vdnfH83OuP3A7K5jVdgQspL9rHWasieQit
         qDRQ==
X-Gm-Message-State: AOAM530bRecMy1YwzaudbKTOdHa0DzFL+8VHYFGxCMLQ9LcjSGPBvc+U
        FkTYjVjyaOL4IJnFGQMJ1N+2HmnJ3rxDwlhiqiqfInHz2mg=
X-Google-Smtp-Source: ABdhPJwIT7vphf5EFJqxgGb9x6u5SmeZUSM4N0tkdB1WmxRzimO2eMdUNcWsVl3lncxDJpZJopZU+4Ey3FwJavxFM6U=
X-Received: by 2002:a2e:9250:: with SMTP id v16mr792023ljg.256.1608253544639;
 Thu, 17 Dec 2020 17:05:44 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Dec 2020 19:05:32 -0600
Message-ID: <CAH2r5mtnwFY4dYMzOij1ZhkQVaF+d9sGcwV3Vx2VywMsVaahQA@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes and Improvements for 5.11-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
2c85ebc57b3e1817b6ce1a6b703928e113a90442:

  Linux 5.10 (2020-12-13 14:41:30 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc-smb3

for you to fetch changes up to afee4410bc6c50e1422c5a45d633ad0e478ea960:

  cifs: update internal module version number (2020-12-16 21:56:42 -0600)

----------------------------------------------------------------
cifs/smb3 changes: the largest part are for support of the newer mount
API which has been needed for cifs/smb3 mounts for a long time due to
the new API's better handling of remount, and better error reporting.
There are three additional small cleanup patches for this being
tested, that are not included yet.

This series also includes addition of support for the SMB3 witness
protocol which can provide important notifications from the server to
client on server address or export or network changes. This can be
useful for example in order to be notified before the failure - when a
server's IP address changes (in the future it will allow us to support
server notifications of when a share is moved).

It also includes three patches for stable e.g. some that better handle
some confusing error messages during session establishment.

Testing results:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/462

There are three small patches from Dan Carpenter and also some
unrelated (ie unrelated to this PR) multichannel and GCM256 (SMB3
encryption) fixes that are being investigated that are not included in
this PR but I hope to finish off reasonably soon.

Note that this series has a trivial merge conflict with a recent
treewide change which Stephen Rothwell resolved in linux-next with a
small patch:
     [PATCH] fixup for "treewide: rename nla_strlcpy to nla_strscpy."
If you need me to send that or add it to my tree let me know.
----------------------------------------------------------------
Dmitry Osipenko (1):
      cifs: Add missing sentinel to smb3_fs_parameters

Gustavo A. R. Silva (1):
      cifs: Fix fall-through warnings for Clang

Ronnie Sahlberg (23):
      cifs: rename smb_vol as smb3_fs_context and move it to fs_context.h
      cifs: rename dup_vol to smb3_fs_context_dup and move it into fs_context.c
      cifs: move the enum for cifs parameters into fs_context.h
      cifs: move cifs_parse_devname to fs_context.c
      cifs: switch to new mount api
      cifs: remove the devname argument to cifs_compose_mount_options
      cifs: add an smb3_fs_context to cifs_sb
      cifs: get rid of cifs_sb->mountdata
      cifs: remove [gu]id/backup[gu]id/file_mode/dir_mode from cifs_sb
      cifs: remove actimeo from cifs_sb
      cifs: move cifs_cleanup_volume_info[_content] to fs_context.c
      cifs: move [brw]size from cifs_sb to cifs_sb->ctx
      cifs: add initial reconfigure support
      cifs: we do not allow changing username/password/unc/... during remount
      cifs: simplify handling of cifs_sb/ctx->local_nls
      cifs: don't create a temp nls in cifs_setup_ipc
      cifs: uncomplicate printing the iocharset parameter
      cifs: do not allow changing posix_paths during remount
      cifs: remove ctx argument from cifs_setup_cifs_sb
      cifs: move update of flags into a separate function
      cifs: update mnt_cifs_flags during reconfigure
      cifs: fix uninitialized variable in smb3_fs_context_parse_param
      cifs: fix use after free in cifs_smb3_do_mount()

Samuel Cabrero (11):
      cifs: Make extract_hostname function public
      cifs: Make extract_sharename function public
      cifs: Register generic netlink family
      cifs: add witness mount option and data structs
      cifs: Send witness register and unregister commands to userspace daemon
      cifs: Set witness notification handler for messages from userspace daemon
      cifs: Add witness information to debug data dump
      cifs: Send witness register messages to userspace daemon in echo task
      cifs: Simplify reconnect code when dfs upcall is enabled
      cifs: Handle witness client move notification
      cifs: Fix some error pointers handling detected by static checker

Shyam Prasad N (3):
      cifs: Fix unix perm bits to cifsacl conversion for "other" bits.
      cifs: Enable sticky bit with cifsacl mount option.
      cifs: Tracepoints and logs for tracing credit changes.

Steve French (16):
      SMB3: avoid confusing warning message on mount to Azure
      SMB3.1.1: remove confusing mount warning when no SPNEGO info on
negprot rsp
      SMB3.1.1: update comments clarifying SPNEGO info in negprot response
      SMB3.1.1: do not log warning message if server doesn't populate salt
      cifs: minor kernel style fixes for comments
      cifs: cleanup misc.c
      cifs: minor updates to Kconfig
      cifs: remove various function description warnings
      cifs: remove some minor warnings pointed out by kernel test robot
      cifs: update super_operations to show_devname
      smb3: remind users that witness protocol is experimental
      cifs: fix rsize/wsize to be negotiated values
      cifs: correct four aliased mount parms to allow use of previous names
      cifs: handle "guest" mount parameter
      cifs: Fix support for remount when not changing rsize/wsize
      cifs: update internal module version number

 fs/cifs/Kconfig                        |   25 +-
 fs/cifs/Makefile                       |    4 +-
 fs/cifs/cache.c                        |   24 -
 fs/cifs/cifs_debug.c                   |   13 +
 fs/cifs/cifs_dfs_ref.c                 |   19 +-
 fs/cifs/cifs_fs_sb.h                   |   12 +-
 fs/cifs/cifs_swn.c                     |  694 +++++++++++++++++++
 fs/cifs/cifs_swn.h                     |   25 +
 fs/cifs/cifsacl.c                      |  238 +++++--
 fs/cifs/cifsacl.h                      |    4 +
 fs/cifs/cifsencrypt.c                  |    5 +
 fs/cifs/cifsfs.c                       |  174 ++---
 fs/cifs/cifsfs.h                       |    6 +-
 fs/cifs/cifsglob.h                     |  106 +--
 fs/cifs/cifspdu.h                      |    2 +-
 fs/cifs/cifsproto.h                    |   39 +-
 fs/cifs/connect.c                      | 2125
+++++++++++----------------------------------------------
 fs/cifs/dfs_cache.c                    |  115 +---
 fs/cifs/dfs_cache.h                    |    2 +-
 fs/cifs/dir.c                          |    7 +-
 fs/cifs/file.c                         |   26 +-
 fs/cifs/fs_context.c                   | 1529
++++++++++++++++++++++++++++++++++++++---
 fs/cifs/fs_context.h                   |  225 +++++-
 fs/cifs/fscache.c                      |    1 +
 fs/cifs/fscache.h                      |    1 -
 fs/cifs/inode.c                        |   74 +-
 fs/cifs/misc.c                         |    5 +-
 fs/cifs/netlink.c                      |   89 +++
 fs/cifs/netlink.h                      |   16 +
 fs/cifs/readdir.c                      |   19 +-
 fs/cifs/sess.c                         |   71 +-
 fs/cifs/smb1ops.c                      |   13 +-
 fs/cifs/smb2misc.c                     |   31 +-
 fs/cifs/smb2ops.c                      |   63 +-
 fs/cifs/smb2pdu.c                      |    7 +-
 fs/cifs/smb2pdu.h                      |   14 +-
 fs/cifs/smbdirect.c                    |    1 +
 fs/cifs/trace.h                        |    4 +
 fs/cifs/transport.c                    |   15 +
 fs/cifs/unc.c                          |   71 ++
 include/uapi/linux/cifs/cifs_netlink.h |   63 ++
 41 files changed, 3623 insertions(+), 2354 deletions(-)
 create mode 100644 fs/cifs/cifs_swn.c
 create mode 100644 fs/cifs/cifs_swn.h
 create mode 100644 fs/cifs/netlink.c
 create mode 100644 fs/cifs/netlink.h
 create mode 100644 fs/cifs/unc.c
 create mode 100644 include/uapi/linux/cifs/cifs_netlink.h


--
Thanks,

Steve
