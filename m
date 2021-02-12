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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B50F5C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 21:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79F5664E3D
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Feb 2021 21:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBLVeV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Feb 2021 16:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhBLVeH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 12 Feb 2021 16:34:07 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560E3C061574;
        Fri, 12 Feb 2021 13:33:26 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id v30so1489178lfq.6;
        Fri, 12 Feb 2021 13:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OTiDc9b60nDnEkcXvALMS6CXk45Ph7HNsD2AVZPb1gE=;
        b=csofcK7Co/QAvcx0ppmBhV9QWtY+cwgwfFq3bRAVXxCUk5qOuQYCdWr5Y7c7II4CFW
         RxH6upNV/XA3pFnCLxakKL0cax4D3di0WPBGgsQrfhNy29VKvirZDf+/rQQfBB7ck4zo
         hF1gEdfxrxx/IBAgexMN1OUjh7tXhFGz3Gslc0rcqC79hr5INQHy5yr6ZKwiW9YcqnXR
         w5U1SeneMCsC4jmZFF60i6FcGj3sSR7yPoAEdqxhmKxw7vm+ASKeLW1LPdgwsK0fBpb9
         gAMBCNC9jnIwl0Zr0hOIPovTL2fVLX8nIULbqrvRkmRl819uLFCy6N6eL2+OhqAnRpyA
         CxRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OTiDc9b60nDnEkcXvALMS6CXk45Ph7HNsD2AVZPb1gE=;
        b=cOFS1qjUwN8GzyZso2xloZhr0mbqeOZ/YXx+2UasMxshdIwA0SpR7CYW7/HzqcC7iU
         cmRsg3TTomWRhYi8tsyoo9fRuTFru2oWEAl0pEhPB9HNlSH3USuc3cwdtdG4Il79yBxf
         GsrqUxZZtY8xTGWIwdLknhQY2saPX/GJh1X1jVmTBLZywbiV6/qbhAOkBXy6wvC6Fm3W
         A3bDbZO59c4DTObl2ov6KnwWImM+J8MFrjqeZ+s9GTt+3YsjVSs4vzOXQIHQlMee0i2p
         PVcRZlHC2Eak+5zaKpeuxmUITDTIft5DFLg//DzK7zIAwDwAJqvY8OA6y5Ffp5kC/KS+
         4Avw==
X-Gm-Message-State: AOAM533dXkdMI1Ic1Rw3teX2uDCC5q05EL4Klbg0PdPG6ICwlyPd4wDV
        jEUdBYxrRet4UANK4mfqyAz6XqbJup4sLPhwzhoHtTcdY60gtA==
X-Google-Smtp-Source: ABdhPJwSULxLUaCGDZHgu+ClA1sitnbJsUgT+lZYG5vGqaulIgPf7/nkAF3NqjyKV0PvBs8ZGJedPObUBM1gwdoZ/+0=
X-Received: by 2002:a05:6512:31c1:: with SMTP id j1mr2594750lfe.313.1613165604799;
 Fri, 12 Feb 2021 13:33:24 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtYEj+WLy+oPSXEwS5sZ8+TNk_dU3PVx3ieBz2DFS94Sg@mail.gmail.com>
 <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
In-Reply-To: <CAHk-=wja1Y8r5UKrmXcMFrS=VPkTPbkyK-vt8B9MBkEU4+-WLw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 12 Feb 2021 15:33:13 -0600
Message-ID: <CAH2r5ms9zL3qZM+7NzDMgsm=no=4K44C-u5E0yD58dbp7SfL-Q@mail.gmail.com>
Subject: Re: [GIT PULL] cifs fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The branch also was mirrored to github so could be pulled from there
if you prefer - see below (presumably the admins for samba.org, who
live in Germany, are not online - and so I am not sure when samba.org
servers will be restarted).

The following changes since commit 92bf22614b21a2706f4993b278017e437f7785b3:

  Linux 5.11-rc7 (2021-02-07 13:57:38 -0800)

are available in the Git repository at:

  git://github.com/smfrench/smb3-kernel.git tags/5.11-rc7-smb3-github

for you to fetch changes up to a738c93fb1c17e386a09304b517b1c6b2a6a5a8b:

  cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting
cifs_sb->prepath. (2021-02-11 11:08:32 -0600)

----------------------------------------------------------------
4 small smb3 fixes to the new mount API

----------------------------------------------------------------
Ronnie Sahlberg (3):
      cifs: fix dfs-links
      cifs: do not disable noperm if multiuser mount option is not provided
      cifs: In the new mount api we get the full devname as source=

Shyam Prasad N (1):
      cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.

 fs/cifs/cifsfs.c     |  2 +-
 fs/cifs/connect.c    |  9 +++++++++
 fs/cifs/fs_context.c | 20 +++++++++++++++++---
 fs/cifs/fs_context.h |  1 +
 4 files changed, 28 insertions(+), 4 deletions(-)


On Fri, Feb 12, 2021 at 2:05 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Feb 12, 2021 at 10:16 AM Steve French <smfrench@gmail.com> wrote:
> >
> >   git://git.samba.org/sfrench/cifs-2.6.git tags/5.11-rc7-smb3
>
> It looks like git.samba.org is feeling very sick and is not answering.
> Not git, not ping (but maybe icmp ping is blocked).
>
> Please give it a kick, or provide some other hosting mirror?
>
>            Linus



--
Thanks,

Steve
