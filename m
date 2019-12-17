Return-Path: <SRS0=5M6x=2H=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B520AC2D0D1
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Dec 2019 18:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 986002072D
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Dec 2019 18:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfLQSCo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Dec 2019 13:02:44 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43140 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfLQSCo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Dec 2019 13:02:44 -0500
Received: by mail-lj1-f194.google.com with SMTP id a13so11968728ljm.10
        for <linux-cifs@vger.kernel.org>; Tue, 17 Dec 2019 10:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=eR7hH7e1+A41saiufOcY2Fe0QJqgAJElsGPj2Ebh++c=;
        b=ms6d4yxgHg7v3nVUnlSOXO3WgcIdWYokD4XxibEfoR7qzr/gz3ZkNQUWa0naiAWdPC
         oMBf2nMZ5Si4CYfKhyPjSxPemf+IX+j5oMR8Kvz3YmJafZ522zIuY2kE4a3ZJywVbOwx
         auVistcLdagBxvE06L42uRd77gU2cWPHZpS2jZbBOEgQo96990xX1udpdY7OW3xusIro
         bcR/E2Nu6+kIjlA4YvSOQU5ypMY4SEfCpgGg4SE1Kf5LFpa/YFqaoEfUjjRrZD62t6Do
         NxD+bPaznMWGCufixhS5QdcTdJ8Jv9rNqv/tfToTkvn/ExkDGa8C8TgkAPcaChqP3hVf
         wloQ==
X-Gm-Message-State: APjAAAXEzuOqBASRseBj2erICs/b/eUko83CW0WiMYUHBcnOGeSLNME5
        wES8vjt2HMgZxc/hxjGpIff9umTAhcISn7C7PQ==
X-Google-Smtp-Source: APXvYqydgpVokeo2s9tEH+JFJ4Rf0I8A/ZSIxIrZAm6CGnCCA0RMxyv6qxo73DTfailIx1ILbChet4pdVrLU5vQFS90=
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr4276735ljg.168.1576605759951;
 Tue, 17 Dec 2019 10:02:39 -0800 (PST)
MIME-Version: 1.0
From:   Pavel Shilovsky <pshilovsky@samba.org>
Date:   Tue, 17 Dec 2019 10:02:28 -0800
Message-ID: <CAKywueT2dwCaaA4J9n1aC5kT4NHC1j0hcVEuvttPo5ZcX_PWcQ@mail.gmail.com>
Subject: cifs-utils release 6.10 ready for download
To:     samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org, linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

New version 6.10 of cifs-utils has been released.

Highlighted changes:

- smb3 alias/fstype is added
- smb2-quota tool is added to display quota information
- smb2-secdesc UI tool to view security descriptors is added
- smbinfo is enhanced with capabilities to dump session keys and
get/set compression of files
- smbinfo bash completion is supported
- getcifsacl tool is improved to support multiple files

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary

Detailed list of changes since 6.9 was released:

5ff5fc2 cifs-utils: bump version to 6.10
2b426e5 Rename secdesc-ui.py to smb2-secdesc
eba990a Properly install mount.smb3 helper files
f64814b Install smb2-quota and its manpage
b10aaef smb2-quota: Simplify code logic for quota entries.
be37d3d Add program name to error output instead of static mount.cifs
67b0fe3 Add support for smb3 alias/fstype in mount.cifs.c
74a1ced smbinfo.rst: document new `keys` command
f9085c4 mount.cifs.rst: remove prefixpath mount option.
9f7dd4e smb2quota.rst: Add man page for smb2quota.py
49fd975 smb2quota.py: Userspace helper to display quota information
b9e63c4 smbinfo: add bash completion support for setcompression
07c5812 smbinfo: Add SETCOMPRESSION support
6df98da smbinfo: print the security information needed to decrypt
wireshark trace
d563a0e mount.cifs: Fix invalid free
d7d78d7 mount.cifs: Fix double-free issue when mounting with setuid root
5a468f3 Zero fill the allocated memory for new `struct cifs_ntsd`
cb3dc2f Zero fill the allocated memory for a new ACE
bf7f48f mount.cifs.c: fix memory leaks in main func
13c3704 smbinfo: add bash completion support for getcompression
43f389b getcifsacl: Add support for -R(recursive) option.
1e4fca2 smbinfo: add GETCOMPRESSION support
f2955af getcifsacl: Fix usage message to include multiple files
dfe497f smbinfo: Add bash completion support for smbinfo.
9beaa8c getcifsacl: Add support to accept more paths
12c2f08 smbinfo: Improve help usage and add -h option.
0009157 secdesc-ui.py: a UI to view the security descriptors on SMB2+ shares
7c0af93 Update authors list

Summary:

Aurelien Aptel (1):
      smbinfo.rst: document new `keys` command

Jiawen Liu (1):
      mount.cifs.c: fix memory leaks in main func

Kenneth D'souza (10):
      smbinfo: Improve help usage and add -h option.
      getcifsacl: Add support to accept more paths
      smbinfo: Add bash completion support for smbinfo.
      getcifsacl: Add support for -R(recursive) option.
      smb2quota.py: Userspace helper to display quota information
      smb2quota.rst: Add man page for smb2quota.py
      mount.cifs.rst: remove prefixpath mount option.
      Add support for smb3 alias/fstype in mount.cifs.c
      Add program name to error output instead of static mount.cifs
      smb2-quota: Simplify code logic for quota entries.

Paulo Alcantara (SUSE) (2):
      mount.cifs: Fix double-free issue when mounting with setuid root
      mount.cifs: Fix invalid free

Pavel Shilovsky (7):
      Update authors list
      getcifsacl: Fix usage message to include multiple files
      smbinfo: add bash completion support for getcompression
      smbinfo: add bash completion support for setcompression
      Properly install mount.smb3 helper files
      Rename secdesc-ui.py to smb2-secdesc
      cifs-utils: bump version to 6.10

Ronnie Sahlberg (4):
      secdesc-ui.py: a UI to view the security descriptors on SMB2+ shares
      smbinfo: add GETCOMPRESSION support
      smbinfo: Add SETCOMPRESSION support
      Install smb2-quota and its manpage

Steve French (1):
      smbinfo: print the security information needed to decrypt wireshark trace

misku (2):
      Zero fill the allocated memory for a new ACE
      Zero fill the allocated memory for new `struct cifs_ntsd`

 AUTHORS                 |   1 +
 Makefile.am             |  16 +++
 bash-completion/smbinfo |  44 +++++++++
 configure.ac            |   8 +-
 getcifsacl.c            | 106 +++++++++++++-------
 getcifsacl.rst.in       |   3 +
 mount.cifs.c            |  76 ++++++++------
 mount.cifs.rst          |  18 ++--
 setcifsacl.c            |   4 +-
 smb2-quota              | 190 +++++++++++++++++++++++++++++++++++
 smb2-quota.rst          |  70 +++++++++++++
 smb2-secdesc            | 436
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.c               | 174 ++++++++++++++++++++++++++++++--
 smbinfo.rst             |  13 ++-
 14 files changed, 1072 insertions(+), 87 deletions(-)
 create mode 100644 bash-completion/smbinfo
 create mode 100755 smb2-quota
 create mode 100644 smb2-quota.rst
 create mode 100755 smb2-secdesc

Thanks to everyone who contributed to the release!

Best regards,
Pavel Shilovsky
