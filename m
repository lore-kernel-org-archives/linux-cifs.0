Return-Path: <SRS0=CoXL=35=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619F6C352A1
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Feb 2020 01:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7782922522
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Feb 2020 01:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q61BSIdw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbgBIBpj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Feb 2020 20:45:39 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:36307 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727502AbgBIBpj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 Feb 2020 20:45:39 -0500
Received: by mail-io1-f66.google.com with SMTP id d15so3775406iog.3;
        Sat, 08 Feb 2020 17:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=MCQaQpg0y2itnJBTvG3xjWtDW7J07F5JpEm9F18Dlno=;
        b=q61BSIdwNFuESRBLf1qekdUkE4NIAnZnpkpNYj6ThHG/y4GYEZL3EsPWgETi74w1mj
         U73iXjNIZP+7y7DUmlUhC20FpaECDZdwq4KNTbOB8XglvudoXJf6uePwY0SpV0ytY5L7
         gsX6oHuG3sb8w29IC1Hbl70/U06bmbK2hsizl25kyunbOtKzVKIOxSw6zRnrHgGzBNAa
         efgd0fId1pbCkHi+rhw9S7CO11tzA6RU5yAzY18l/ghwpL2/6oTfq+TpcEWZ9ehFH+ZC
         KCfi9TFpuhTKtg6zebWSIVV1Np/YWPLOOfeZL1apTITLCbjKnylFIAZFw6DJ0qbyTZRz
         8geg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=MCQaQpg0y2itnJBTvG3xjWtDW7J07F5JpEm9F18Dlno=;
        b=Qk3xVXOfPdg6SvOmG9ZKd4GkN6biEOZ3xFxZc1Mren+0mNCFiehThqC9uOQA6jVZaR
         LTfEAo8qfwNQf5NnquZtUTYOXoLYzbGydUGA69WlP71rKbsJ7CkQB5viRBWgOUM5Uebr
         hreW4q+KU9ORtfTW5E9yUKzjxI4+CCGWUglievVos57Y6atItznA7mcDsZDh/JJPoY3x
         wZF6C97eMwyxr+QWJgf4M20CCcvvcRrE7gPrLrILG1viVR6JQrNzbtsYv7k8W7/3LnKG
         aaqfSqnumxarflQEQOqOX2p4EGUOxZaWRq7W0CDeZ1NbwJXNGCZEnMOYO9yHLdI5Ou0b
         wzYg==
X-Gm-Message-State: APjAAAX4r+xqJvF9uTowkbOQNU6vv//q4Uz8MgmBfwmPpjzfhU7slDPT
        gMngCQPddS2q63n8Du9Y0g0wMkPfBxlVvAWjBwPM2FZ9zEM=
X-Google-Smtp-Source: APXvYqw6LHx2aENMZsLdSsMP6GQzPN0w9vcXI01havkzcHcJUU5xSPnT3DYkygMeAVO5szcIHK4MEAandSHSPyYHXbA=
X-Received: by 2002:a5d:9419:: with SMTP id v25mr4324008ion.3.1581212737288;
 Sat, 08 Feb 2020 17:45:37 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 8 Feb 2020 19:45:26 -0600
Message-ID: <CAH2r5ms=hyEdeSLo2qN11rB41e-+yFn7Xg=8CVWwXVa1R0hooQ@mail.gmail.com>
Subject: [GIT PULL] CIFS/SMB3 Fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please pull the following changes since commit
94f2630b18975bb56eee5d1a36371db967643479:

  Merge tag '5.6-rc-small-smb3-fix-for-stable' of
git://git.samba.org/sfrench/cifs-2.6 (2020-02-01 11:22:41 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/5.6-rc-smb3-plugfest-patches

for you to fetch changes up to 51d92d69f77b121d8093af82eb3bd2e8e631be55:

  smb3: Add defines for new information level, FileIdInformation
(2020-02-06 17:32:24 -0600)

----------------------------------------------------------------
13 cifs/smb3 patches (most from testing at the SMB3 plugfest this week)

Important fix for multichannel and for modefromsid mounts.
Two reconnect fixes
Addition of SMB3 change notify support
Backup tools fix
A few additional minor debug improvements (tracepoints and additional
logging found useful during testing this week)

Unit test results:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/314

An additional set of important improvements for SMB3.1.1 POSIX
Extensions that was being worked on and tested at the recent SNIA test
event is still under testing and is not included in this pull request.
----------------------------------------------------------------
Amir Goldstein (1):
      SMB3: Backup intent flag missing from some more ops

Aurelien Aptel (3):
      cifs: make multichannel warning more visible
      cifs: fix channel signing
      cifs: fix mode bits from dir listing when mounted with modefromsid

Ronnie Sahlberg (2):
      cifs: fail i/o on soft mounts if sessionsetup errors out
      cifs: fix soft mounts hanging in the reconnect code

Steve French (7):
      smb3: fix problem with null cifs super block with previous patch
      cifs: log warning message (once) if out of disk space
      cifs: Add tracepoints for errors on flush or fsync
      cifs: add SMB3 change notification support
      smb3: add one more dynamic tracepoint missing from strict fsync path
      smb3: print warning once if posix context returned on open
      smb3: Add defines for new information level, FileIdInformation

 fs/cifs/cifs_ioctl.h    |   6 +++++
 fs/cifs/cifsacl.c       |  14 +++--------
 fs/cifs/cifsfs.c        |   2 +-
 fs/cifs/cifsglob.h      |   8 ++++--
 fs/cifs/cifsproto.h     |   8 ++++++
 fs/cifs/cifssmb.c       |   2 +-
 fs/cifs/connect.c       |   2 +-
 fs/cifs/dir.c           |   5 +---
 fs/cifs/file.c          |  21 ++++++++--------
 fs/cifs/inode.c         |   8 +++---
 fs/cifs/ioctl.c         |  18 +++++++++++++-
 fs/cifs/link.c          |  18 +++-----------
 fs/cifs/readdir.c       |   3 ++-
 fs/cifs/sess.c          |   2 +-
 fs/cifs/smb1ops.c       |  19 +++++++-------
 fs/cifs/smb2inode.c     |   9 ++-----
 fs/cifs/smb2ops.c       | 145
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------------
 fs/cifs/smb2pdu.c       |  36 +++++++++++++++++++++++++--
 fs/cifs/smb2pdu.h       |  16 ++++++++++++
 fs/cifs/smb2proto.h     |   2 +-
 fs/cifs/smb2transport.c |   5 ++--
 fs/cifs/trace.h         |  27 ++++++++++++++++++++
 22 files changed, 247 insertions(+), 129 deletions(-)


--
Thanks,

Steve
