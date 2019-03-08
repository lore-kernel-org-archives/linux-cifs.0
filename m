Return-Path: <SRS0=c5gJ=RL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAE9C43381
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Mar 2019 16:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD4E2146F
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Mar 2019 16:54:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PonC0iRS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfCHQyO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 11:54:14 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:35201 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfCHQyO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 11:54:14 -0500
Received: by mail-pf1-f174.google.com with SMTP id j5so14561836pfa.2;
        Fri, 08 Mar 2019 08:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sTVn5fgUvG+GIwC733X/NGFmVF4SAb1JPy7RcnKrDQM=;
        b=PonC0iRSOt71d03cuXAwPIn5opeTuqfSMvavm2iuaKQGb3IqY8K6zh91w/d3u+OYIu
         70BkIiKHzfDg0vYPsIFKqeafE4Ob6K6Hr3rZOjbl13w6SUgl4hFhuOI/kDw/nsQn6Ip1
         h95Mn9iXF/jlq66kgRyourrWrFp/Kj32mkK4XTnkr05i2v4YOyW6LW6Bjd+4iAOHDN3r
         t4Q2KodUWj5QtwxIEaJbzMzZseCEMCNEnnUshwBYMfmXJU6BD6P8fgR2lhUXeMtXKBd1
         AoJ0VXzE18KF+a4Nj82CxxMJ291PmZl+skW3tCIBxO3gQtgUSK+euQeFRC2J8Bw/RK8C
         lGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sTVn5fgUvG+GIwC733X/NGFmVF4SAb1JPy7RcnKrDQM=;
        b=k3QAJAJLfOyxa/6sF7VUwXvTKU/sGM0xxIN+6bjhSE+KqcTGGE3gcki4H4ZKqcwOQc
         9YWFacyxLiiEAS+96QDx269Xzxgp3BH+dTZYLJ8Iy93unmRkoeodQnInUYZLNjSOZLwh
         5JcHvnUKWWO3t4tTmAYzhrpbKTg9Gs09+zueS6XzeFcQaiY7DgUjVHianMUH1moTwc7L
         4sO68ennpspd5wyplf+RVm0YXZtawuuQQWJp0TQd+K5GICsLLTVhYWdfUhJL8F6rB98d
         z1EDxMjaIbg/jnu4ZYOlm0SzuQPEgSRg7m8w0Tiffb8V2U9euiDPpWdaqRfGx6/Nxx7A
         9oHw==
X-Gm-Message-State: APjAAAWMKlj1p1ZZ2HRKVHLdIr9oBXbLHrJQ+0RHlF4HubpA4I5nh7QS
        kk1ZT2cWRuWXiuyFnWAgQkBP6YGCjVHxpNYKGJJosiZX
X-Google-Smtp-Source: APXvYqwVGUB9BN7OurtgiO+qhdZ4zcIxo/n7d/fvSKYV5S4mQtsMM2DD+8UCUmYPdgglMhvfHMHalNH/j4gNp82mw4U=
X-Received: by 2002:a62:b2d9:: with SMTP id z86mr19538997pfl.255.1552064053098;
 Fri, 08 Mar 2019 08:54:13 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Mar 2019 10:54:02 -0600
Message-ID: <CAH2r5mst=W==ug8Xdt93P3iE1HqeXEjaxYj25TYTs9_1XLfCVg@mail.gmail.com>
Subject: [GIT][PULL] smb3 fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
1c163f4c7b3f621efff9b28a47abb36f7378d783:

  Linux 5.0 (2019-03-03 15:21:29 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.1-rc-smb3-fixes

for you to fetch changes up to 50cfad780bcf9e03d11aaf0a7296a4c0ed336b54:

  fs: cifs: Kconfig: pedantic formatting (2019-03-06 21:55:12 -0600)

----------------------------------------------------------------
smb3/cifs fixes including for large i/o error cases, fixes for 3
xfstests, improved crediting (smb3 flow control); improved tracing

----------------------------------------------------------------
Enrico Weigelt, metux IT consult (1):
      fs: cifs: Kconfig: pedantic formatting

Louis Taylor (1):
      cifs: use correct format characters

Namjae Jeon (1):
      cifs: Accept validate negotiate if server return NT_STATUS_NOT_SUPPORTED

Pavel Shilovsky (24):
      CIFS: Fix leaking locked VFS cache pages in writeback retry
      CIFS: Do not reset lease state to NONE on lease break
      CIFS: Do not skip SMB2 message IDs on send failures
      CIFS: Always reset read error to -EIO if no response
      CIFS: Do not log credits when unmounting a share
      CIFS: Count SMB3 credits for malformed pending responses
      CIFS: Respect SMB2 hdr preamble size in read responses
      CIFS: Set reconnect instance to one initially
      CIFS: Respect reconnect in MTU credits calculations
      CIFS: Respect reconnect in non-MTU credits calculations
      CIFS: Check for reconnects before sending async requests
      CIFS: Check for reconnects before sending compound requests
      CIFS: Adjust MTU credits before reopening a file
      CIFS: Remove custom credit adjustments for SMB2 async IO
      CIFS: Reopen file before get SMB2 MTU credits for async IO
      CIFS: Find and reopen a file before get MTU credits in writepages
      CIFS: Move unlocking pages from wdata_send_pages()
      CIFS: Move open file handling to writepages
      CIFS: Return error code when getting file handle for writeback
      CIFS: Try to acquire credits at once for compound requests
      CIFS: Fix read after write for files with read caching
      CIFS: Only send SMB2_NEGOTIATE command on new TCP connections
      CIFS: Return -EAGAIN instead of -ENOTSOCK
      CIFS: Mask off signals when sending SMB packets

Ronnie Sahlberg (3):
      cifs: replace snprintf with scnprintf
      cifs: add credits from unmatched responses/messages
      cifs: return -ENODATA when deleting an xattr that does not exist

Steve French (13):
      smb3: fix bytes_read statistics
      smb3: make default i/o size for smb3 mounts larger
      smb3: request more credits on tree connect
      cifs: update internal module version number
      smb3: Update POSIX negotiate context with POSIX ctxt GUID
      smb3: add tracepoints for query dir
      smb3: Add tracepoints for read, write and query_dir enter
      smb3: add missing read completion trace point
      smb3: improve dynamic tracing of open and posix mkdir
      smb3: add dynamic trace point for smb3_cmd_enter
      smb3: add dynamic trace point for query_info_enter/done
      smb3: for kerberos mounts display the credential uid used
      smb3: request more credits on normal (non-large read/write) ops

Yao Liu (1):
      cifs: Fix NULL pointer dereference of devname

 fs/cifs/Kconfig         | 120
++++++++++++++++++++++++++++-----------------------------
 fs/cifs/cifs_dfs_ref.c  |   4 +-
 fs/cifs/cifs_fs_sb.h    |   1 +
 fs/cifs/cifsfs.c        |   3 +-
 fs/cifs/cifsfs.h        |   2 +-
 fs/cifs/cifsglob.h      |  65 ++++++++++++++++++++++++-------
 fs/cifs/cifsproto.h     |   8 +++-
 fs/cifs/cifssmb.c       |  54 +++++++++++++++++---------
 fs/cifs/connect.c       |  66 +++++++++++++++++++++++++++-----
 fs/cifs/file.c          | 269
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
 fs/cifs/inode.c         |   2 +-
 fs/cifs/link.c          |  14 +++----
 fs/cifs/smb1ops.c       |   8 ++--
 fs/cifs/smb2misc.c      |  24 +++++++-----
 fs/cifs/smb2ops.c       | 115
++++++++++++++++++++++++++++++++++++++++++++++---------
 fs/cifs/smb2pdu.c       | 179
+++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------
 fs/cifs/smb2pdu.h       |   4 +-
 fs/cifs/smb2transport.c |  25 +++++++++++-
 fs/cifs/smbdirect.c     |   6 +--
 fs/cifs/trace.h         |  89 ++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/transport.c     | 208
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 21 files changed, 929 insertions(+), 337 deletions(-)


-- 
Thanks,

Steve
