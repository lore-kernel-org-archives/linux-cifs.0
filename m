Return-Path: <SRS0=n6BV=SH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8262CC282CE
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 18:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19E582146F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Apr 2019 18:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="iNCbEniw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731542AbfDESmg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Apr 2019 14:42:36 -0400
Received: from hr2.samba.org ([144.76.82.148]:54002 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731589AbfDESmg (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Apr 2019 14:42:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Date:Message-ID:From:Cc:To;
        bh=/vZSnkMt3bwzHS6mIzf9lmM95pV++bJ3f04ne6Uls1M=; b=iNCbEniwaAZXCwQgMnZd5SB7+h
        CDiCyj0qu3844QaMuBOWBj0OZEuhA9mAVMxyUrn0nDl+D5Qnq6z5pXr7P5LcemS4wOnvsDXwypuZO
        9kfoG8qSupCrsDTuUGeA0RzczzBD/aHtPJyOSGWiOe38fU2GuYGAmDdDkFkds7rsl8z0=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hCTnM-0000ao-ES; Fri, 05 Apr 2019 18:42:32 +0000
To:     samba@lists.samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Paulo Alcantara <paulo@paulo.ac>,
        Steve French <smfrench@gmail.com>,
        Hank Leininger <hlein@korelogic.com>,
        Kenneth D'souza <kdsouza@redhat.com>,
        Alexander Bokovoy <ab@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
From:   Pavel Shilovsky <pshilovsky@samba.org>
Subject: cifs-utils release 6.9 ready for download
Message-ID: <c7904840-d370-10ca-1db5-c874cccd2da7@samba.org>
Date:   Fri, 5 Apr 2019 11:42:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a big release that contains many functional changes that are 
aligned with the recent work done in the Linux SMB3 kernel client. These 
changes mostly aim to improve user experience by unlocking new features
available in modern SMB3 servers:

- smbinfo utility is added to query various kinds of information from 
the server (objectId, snapshots, different FileInfo* classes and other 
metadata)
- server IP change is supported by expiring DNS key resolver entries
- get/setcifsacl tools are improved to handle unexpected behavior
- share snapshot are allowed to be specified by a GMT token or SMB 
100-nanoseconds time
- various new mount option are documented: bsize, handletimeout, 
handlecache, rdma, max_credits and others

webpage:    https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball:    https://download.samba.org/pub/linux-cifs/cifs-utils/
git:        git://git.samba.org/cifs-utils.git
gitweb:     http://git.samba.org/?p=cifs-utils.git;a=summary

Detailed list of changes since 6.8 was released:

9a8c21a cifs-utils: bump version to 6.9
aee01e0 smbinfo: use constant for input buffer length
204c6b6 Fix authors and maintainers
70f3cda mount.cifs.rst: mention kernel version for snapshots
cbdd655 Update man page for mount.cifs to add new options
c52be34 mount.cifs: detect GMT format of snapshot version
b6cb671 mount.cifs: add more options to help message
83c6472 mount.cifs Add various missing parms from the help text
9890747 smbinfo: make argument order consistent
74ae053 smbinfo: Add ability to query snapshots (previous versions)
49eb190 smbinfo: missing help for fsctl-getobjid
2244e10 cifs.upcall: fix a compiler warning
fb33ba3 smbinfo: add fsctl-getobjid support
f9f5d42 smbinfo: fix code style
0feb1a8 setcifsacl: fix adding ACE when owner sid in unexpected location
1191a6c smbinfo: decode the ACEs
ea9b99c getcifsacl: Improve help usage and add -h option.
670f416 getcifsacl: Do not go to parse_sec_desc if getxattr fails.
b3f78f6 mount.cifs.rst: update vers=3.1.1 option description
d93cabc Update mount.cifs with vers=default mount option and SMBv3.0.2
3f197a3 Added rst2man.py to the search list.
3a00449 mount.cifs: be more verbose and helpful regarding mount errors
b101af7 cifs: Allow DNS resolver key to expire
7090217 smbinfo: add FileFsFullSizeInformation
858ac4d smbinfo: Update the usage text with the new infolevels
db9d117 smbinfo: update help text
0ca46db smbinfo: Add more File*Information classes
f0c95ea smbinfo.rst: document kernel version
3eb33a1 smbinfo: add a utility to display smb specific information about 
objects
3c7e8c3 mount.cifs.rst: document vers=3.02 mount option
439cd76 mount.cifs.rst: document vers=3 mount option
06503ef mount.cifs.rst: more cleanups
77b028c checkopts: report duplicated options in man page
a389756 cifs-utils: support rst2man-3
7325a01 mount.cifs.rst: document missing options, correct wrong ones
97209a5 checkopts: add python script to cross check mount options
03a3296 manpage: update mount.cifs manpage with info about rdma option
bfcbfaa mount.cifs.rst: document new (no)handlecache mount option
81dcfb2 docs: cleanup rst formating

Summary:

Alexander Bokovoy (1):
       cifs-utils: support rst2man-3

Aurelien Aptel (6):
       docs: cleanup rst formating
       mount.cifs.rst: document new (no)handlecache mount option
       checkopts: report duplicated options in man page
       mount.cifs.rst: more cleanups
       smbinfo.rst: document kernel version
       mount.cifs: be more verbose and helpful regarding mount errors

Aurélien Aptel (2):
       checkopts: add python script to cross check mount options
       mount.cifs.rst: document missing options, correct wrong ones

Hank Leininger (1):
       Added rst2man.py to the search list.

Kenneth D'souza (3):
       Update mount.cifs with vers=default mount option and SMBv3.0.2
       getcifsacl: Do not go to parse_sec_desc if getxattr fails.
       getcifsacl: Improve help usage and add -h option.
       manpage: update mount.cifs manpage with info about rdma option

Paulo Alcantara (1):
       cifs: Allow DNS resolver key to expire

Pavel Shilovsky (12):
       mount.cifs.rst: document vers=3 mount option
       mount.cifs.rst: document vers=3.02 mount option
       mount.cifs.rst: update vers=3.1.1 option description
       smbinfo: fix code style
       cifs.upcall: fix a compiler warning
       smbinfo: make argument order consistent
       mount.cifs: add more options to help message
       mount.cifs: detect GMT format of snapshot version
       mount.cifs.rst: mention kernel version for snapshots
       Fix authors and maintainers
       smbinfo: use constant for input buffer length
       cifs-utils: bump version to 6.9

Ronnie Sahlberg (6):
       smbinfo: add a utility to display smb specific information about 
objects
       smbinfo: Add more File*Information classes
       smbinfo: Update the usage text with the new infolevels
       smbinfo: add FileFsFullSizeInformation
       smbinfo: decode the ACEs
       smbinfo: add fsctl-getobjid support

Steve French (6):
       smbinfo: update help text
       setcifsacl: fix adding ACE when owner sid in unexpected location
       smbinfo: missing help for fsctl-getobjid
       smbinfo: Add ability to query snapshots (previous versions)
       mount.cifs Add various missing parms from the help text
       Update man page for mount.cifs to add new options

  AUTHORS            |    3 +-
  Makefile.am        |    8 +-
  README             |    2 +-
  checkopts          |  253 +++++++++++++++++++
  cifs.idmap.rst.in  |   71 ++----
  cifs.upcall.c      |   83 +++++--
  cifs.upcall.rst.in |  203 ++++++----------
  cifscreds.rst      |   92 +++----
  configure.ac       |   14 +-
  getcifsacl.c       |   35 ++-
  getcifsacl.rst.in  |   40 +--
  idmapwb.rst.in     |   19 +-
  mount.cifs.c       |   80 +++++-
  mount.cifs.rst     |  259 +++++++++++++-------
  pam_cifscreds.rst  |   61 ++---
  setcifsacl.c       |   29 ++-
  setcifsacl.rst.in  |  143 +++--------
  smbinfo.c          | 1134 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  smbinfo.rst        |  108 +++++++++
  19 files changed, 2067 insertions(+), 570 deletions(-)
  create mode 100755 checkopts
  create mode 100644 smbinfo.c
  create mode 100644 smbinfo.rst

Thanks to everyone who contributed to the release!
