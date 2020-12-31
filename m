Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF02CC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Dec 2020 20:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B9620855
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Dec 2020 20:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgLaUJJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Dec 2020 15:09:09 -0500
Received: from mail-ed1-f54.google.com ([209.85.208.54]:42259 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgLaUJJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Dec 2020 15:09:09 -0500
Received: by mail-ed1-f54.google.com with SMTP id g24so18973720edw.9
        for <linux-cifs@vger.kernel.org>; Thu, 31 Dec 2020 12:08:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3qjojYqJjWiq2QQdPJtZl0cxzUMaT76U9P8AUbsxFeE=;
        b=lJ92eGdMbPg75+vtg1aS0jlzgOAOxFBYAiSihvcjslaftAo/ZaJDEts2QQLJB1SxGk
         yyDZttZqaSHBNb1pDalP22mbz/i3dtoh6Bab11onEZqd1+iZ71ks5BKpDD5NVnvMBXL3
         0lKP9Q+xA6qlDQNHLnTBdvaaghHqR0Jzy6dbzfKIuDzecmbuLx2vkqCyzT8bSRlAkZoM
         YsCjdYXJzRoVisY5feapqe7v6ZAMe8g9NdNIlJF1Kray6VGkpUuw7UenCtUK6TWpQDKz
         Ind7i55APsLGpZh0m9ePu3heiboHI3p0FZGJBH8ANcBTfnDhx8pkpBF6gHlb7aoTjpN0
         OPjQ==
X-Gm-Message-State: AOAM531dyk/y5+eW5QRLhNxzzVb8VFzKC+wsSBmKZLSrhkC8tO2+3ADr
        vIF/XQM5BRzMf6eDbdn39Gj4f4FwfSnB3DzLHsdxiTg/Rr/3
X-Google-Smtp-Source: ABdhPJyQNfgXeiOBFoEBO6DsQpvA3LPa99vz1fymtEV2grZIOk8mCfzMiKU+bdAdC7K/axpLzigqPrNwuAD2mSd5Wb0=
X-Received: by 2002:a50:8b66:: with SMTP id l93mr55163346edl.384.1609445306785;
 Thu, 31 Dec 2020 12:08:26 -0800 (PST)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Thu, 31 Dec 2020 12:08:15 -0800
Message-ID: <CAKywueSZyJtH_V8MVa5bznPN=RdjbphY7xo74ABWn=bMAud+ZQ@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 6.12 ready for download
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Boris Protopopov <pboris@amazon.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 6.12 of cifs-utils has been released today.

Highlighted changes:

- get/setcifsacl tools are improved to support changing owner, group and SACLs
- mount.cifs is enhanced to use SUDO_UID env variable for cruid
- smbinfo is re-written in Python language

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary

Detailed list of changes since 6.11 was released:

73008e3 cifs-utils: bump version to 6.12
16af2c4 smbinfo: fix fsctl-getobjid output
85a7865 smbinfo: fix list-snapshots output and installation
207f192 cifs.upcall: drop bounding capabilities only if CAP_SETPCAP is given
1a15076 mount.cifs: use SUDO_UID env variable for cruid
7156c6e mount.cifs: fix max buffer size when parsing snapshot option
8f46aaa Add missing position handling to mount parameters
gid/backup_gid/snapshot
4205fdc cifs.upcall: update the cap bounding set only when CAP_SETPCAP is given
e406fb1 mount.cifs: update the cap bounding set only when CAP_SETPCAP is given
c3f8e81 Extend cifs acl utilities to handle SACLs
6da2dd3 getcifsacl: return error if input path doesn't exist
1f37d9c Fix mount error when mount point has an extra trailing slash.
1252355 mount.cifs: ignore comment mount option
ff54e6f setcifsacl: fix quoting of backslash in man page
c6507ce Separate binary names using comma in mount.cifs.rst
aeaa786 cifs-utils: fix probabilistic compiling error
c608a7f cifs-utils: Don't create symlinks for mans if mans are disabled
a00e843 cifs-utils: Respect DESTDIR when installing smb3 stuff
b9d94cd mount.cifs.rst: add nolease mount option
3d399e4 Add support for setting owner and group in ntsd
a138fd1 Convert owner and group SID offsets to LE format
9bd8c8d smbinfo: remove invalid arguments to ioctl method
422f0e9 smbinfo: rewrite in python

Summary:

Alexander Koch (1):
      cifs.upcall: drop bounding capabilities only if CAP_SETPCAP is given

Aurelien Aptel (1):
      smbinfo: rewrite in python

Bjoern Jacke (1):
      setcifsacl: fix quoting of backslash in man page

Boris Protopopov (3):
      Convert owner and group SID offsets to LE format
      Add support for setting owner and group in ntsd
      Extend cifs acl utilities to handle SACLs

Jonas Witschel (2):
      mount.cifs: update the cap bounding set only when CAP_SETPCAP is given
      cifs.upcall: update the cap bounding set only when CAP_SETPCAP is given

Martin Schwenke (1):
      mount.cifs: ignore comment mount option

Mikhail Novosyolov (2):
      cifs-utils: Respect DESTDIR when installing smb3 stuff
      cifs-utils: Don't create symlinks for mans if mans are disabled

Pavel Shilovsky (6):
      mount.cifs.rst: add nolease mount option
      getcifsacl: return error if input path doesn't exist
      mount.cifs: fix max buffer size when parsing snapshot option
      smbinfo: fix list-snapshots output and installation
      smbinfo: fix fsctl-getobjid output
      cifs-utils: bump version to 6.12

Rohith Surabattula (1):
      Fix mount error when mount point has an extra trailing slash.

Ronnie Sahlberg (1):
      smbinfo: remove invalid arguments to ioctl method

Sergio Durigan Junior (1):
      Separate binary names using comma in mount.cifs.rst

Shyam Prasad N (1):
      mount.cifs: use SUDO_UID env variable for cruid

Simon Arlott (1):
      Add missing position handling to mount parameters gid/backup_gid/snapshot

lizhe (1):
      cifs-utils: fix probabilistic compiling error

 Makefile.am       |   15 +-
 cifs.upcall.c     |   14 +-
 cifsacl.h         |   55 +++++--
 configure.ac      |    2 +-
 getcifsacl.c      |  239 +++++++++++++++++++++---------
 getcifsacl.rst.in |    4 +-
 mount.cifs.c      |  106 +++++++++++---
 mount.cifs.rst    |   12 +-
 setcifsacl.c      |  848
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------
 setcifsacl.rst.in |   58 ++++++--
 smbinfo           |  792
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.c         | 1296
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
 12 files changed, 1827 insertions(+), 1614 deletions(-)
 create mode 100755 smbinfo
 delete mode 100644 smbinfo.c

Thanks to everyone who contributed to the release!

Best regards,
Pavel Shilovsky
