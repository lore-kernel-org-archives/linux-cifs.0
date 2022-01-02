Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F81C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Jan 2022 16:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiABQcd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Jan 2022 11:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiABQcc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Jan 2022 11:32:32 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563F7C061761
        for <linux-cifs@vger.kernel.org>; Sun,  2 Jan 2022 08:32:32 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id c4so18005303iln.7
        for <linux-cifs@vger.kernel.org>; Sun, 02 Jan 2022 08:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GIVbZ1XBMOWPL/zoXI8aDKLYQ4VBp0+MVfN0Sqp5lrM=;
        b=KBH8UcLCmcUTGTUCuUhRyudc9sjnquQRVNEpDv7t5zgVbquCG7YPESPSQK9InvWkAq
         Xj7qZDSI5fuR0mnNsC16wR8RKNkKb52TPZ2mVfxYDWi900m66ho8FUglcfp7J+5VypEg
         SqcH2CrwjrBJ7xaKBkM4ifxR/SqL8gs3cYGTNsZcvANXyZ54eWhGNRJ8b9i/3mXfIPwc
         2sv3EWionc9C7UHvZhgjDNg4dPl6DZmmpADG9kQGjoMlODF8GtO9Cg4/YUhcZZ8UK4GJ
         d3d2EJDw3q+4qu90Rg1uzJYhyFGFh8CJZIbNWBvr2V8aKbFNs2AxU/zJQggb7I1KEznL
         3DUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIVbZ1XBMOWPL/zoXI8aDKLYQ4VBp0+MVfN0Sqp5lrM=;
        b=KJrxDuM8Nd2VbGKSIv/E9/A7L8eyNKstQebMsE8tlmvmfKJduPygJWoKdiDV+qvEUf
         HYqMmcC+cs8xKNP6uB/eByj7LEMO06fHoQq1jD2ENyeIpHPC96pPNgHa1Qu+9VMnq4S7
         N+LgUUmA9FHL1hJiOYy+CxbJUh3zCdhiA7hjzSgTY4XmxvXc5uVx7fQYcgHyDmk1HRtB
         /JoCeqdvjKRCC2YAc1TNYT3PPjl22OkJMaQytgBuLDeJIq9xufL2tMCxUH9AdBkQVgr2
         wriM8gKUJl6QplKEY1+3fX3g5H9fAov2Vn45w3hEi0yQd7CyXoR0hsHFzisdtpFi0lYu
         agEA==
X-Gm-Message-State: AOAM530TYZ7v5EKO6g3E44txg5lE4yjD8WujyKX/jYBSmJ20s5MNRBoO
        MajDyKAJDSNEU59fLQuTvlGpl7KlY9uDAGhNcC4=
X-Google-Smtp-Source: ABdhPJyBRzhrP7CgiBkh9HUXZLdVv9UpzELyeRkiz2YG+JnCtpxRjTpTv173XGEccxr1D/XLaMySf4h7Sjh8We4K5YE=
X-Received: by 2002:a92:c24b:: with SMTP id k11mr21117391ilo.198.1641141151531;
 Sun, 02 Jan 2022 08:32:31 -0800 (PST)
MIME-Version: 1.0
References: <CAKywueSZyJtH_V8MVa5bznPN=RdjbphY7xo74ABWn=bMAud+ZQ@mail.gmail.com>
In-Reply-To: <CAKywueSZyJtH_V8MVa5bznPN=RdjbphY7xo74ABWn=bMAud+ZQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 2 Jan 2022 18:32:20 +0200
Message-ID: <CAOQ4uxg2K-hgEvh==yrG49fRshHr3ahSKecOoCok5mafkZtSSw@mail.gmail.com>
Subject: Re: [ANNOUNCE] cifs-utils release 6.12 ready for download
To:     Pavel Shilovsky <pshilovsky@samba.org>,
        Boris Protopopov <pboris@amazon.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        samba@lists.samba.org,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 31, 2020 at 10:09 PM Pavel Shilovsky via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> New version 6.12 of cifs-utils has been released today.
>
> Highlighted changes:
>
> - get/setcifsacl tools are improved to support changing owner, group and SACLs
> - mount.cifs is enhanced to use SUDO_UID env variable for cruid
> - smbinfo is re-written in Python language
>
> webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
> tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
> git: git://git.samba.org/cifs-utils.git
> gitweb: http://git.samba.org/?p=cifs-utils.git;a=summary
>
> Detailed list of changes since 6.11 was released:
>
> 73008e3 cifs-utils: bump version to 6.12
> 16af2c4 smbinfo: fix fsctl-getobjid output
> 85a7865 smbinfo: fix list-snapshots output and installation
> 207f192 cifs.upcall: drop bounding capabilities only if CAP_SETPCAP is given
> 1a15076 mount.cifs: use SUDO_UID env variable for cruid
> 7156c6e mount.cifs: fix max buffer size when parsing snapshot option
> 8f46aaa Add missing position handling to mount parameters
> gid/backup_gid/snapshot
> 4205fdc cifs.upcall: update the cap bounding set only when CAP_SETPCAP is given
> e406fb1 mount.cifs: update the cap bounding set only when CAP_SETPCAP is given
> c3f8e81 Extend cifs acl utilities to handle SACLs
> 6da2dd3 getcifsacl: return error if input path doesn't exist
> 1f37d9c Fix mount error when mount point has an extra trailing slash.
> 1252355 mount.cifs: ignore comment mount option
> ff54e6f setcifsacl: fix quoting of backslash in man page
> c6507ce Separate binary names using comma in mount.cifs.rst
> aeaa786 cifs-utils: fix probabilistic compiling error
> c608a7f cifs-utils: Don't create symlinks for mans if mans are disabled
> a00e843 cifs-utils: Respect DESTDIR when installing smb3 stuff
> b9d94cd mount.cifs.rst: add nolease mount option
> 3d399e4 Add support for setting owner and group in ntsd
> a138fd1 Convert owner and group SID offsets to LE format
> 9bd8c8d smbinfo: remove invalid arguments to ioctl method
> 422f0e9 smbinfo: rewrite in python
>
> Summary:
>
> Alexander Koch (1):
>       cifs.upcall: drop bounding capabilities only if CAP_SETPCAP is given
>
> Aurelien Aptel (1):
>       smbinfo: rewrite in python
>
> Bjoern Jacke (1):
>       setcifsacl: fix quoting of backslash in man page
>
> Boris Protopopov (3):
>       Convert owner and group SID offsets to LE format
>       Add support for setting owner and group in ntsd
>       Extend cifs acl utilities to handle SACLs
>

Guys,

I realize this question is in a year delay, but how is setting group SID
via smb3_ntsd/smb3_ntsd_full expected to work with this kernel code:

                                switch (handler->flags) {
                                case XATTR_CIFS_NTSD_FULL:
                                        aclflags = (CIFS_ACL_OWNER |
                                                    CIFS_ACL_DACL |
                                                    CIFS_ACL_SACL);
                                        break;
                                case XATTR_CIFS_NTSD:
                                        aclflags = (CIFS_ACL_OWNER |
                                                    CIFS_ACL_DACL);
                                        break;

Shouldn't aclflags include CIFS_ACL_GROUP?
BTW, CIFS_ACL_GROUP was not set even before
smb3_ntsd_full patches.

What am I missing?

Thanks,
Amir.
