Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCAB4C25B06
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Aug 2022 00:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236090AbiHLA4p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 20:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiHLA4n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 20:56:43 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE019AFFC
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 17:56:42 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id t21so7560141uaq.3
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 17:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=VOjHJhmfJVl8m7HzgluOc7sjh71DibWzlcAmW2qfY6I=;
        b=fQJznr6WW7fpahvOk4ZwNntCEiFoGfp649oaE6dvG0JuH0+h3gB8Nq4DitIRO+Wz8T
         G6W2Yw1Iayl5uZRU4w829jVDDTKcR5S717Baglyucm1nZ0SXD4f2CEfWSZTwytvUiikM
         sQYOH/2AOIfei+SipgHocS8g1w+B6lddWaI219IjSPPwggX7wkfLftVrHqoww/ji9ppa
         zyBh+EpcqKiF0jRbj3SCJ0yNDI/JZmjRjSC7cwJDy6swtpgQDdQ8soPx+T0RYI3nke/+
         s4TiVBx6VzbuhOY6fVKt+42m58emFTZ4vefOaBVpzn7ISRj3E0YmWm6jCYapTF5MF3ru
         fvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=VOjHJhmfJVl8m7HzgluOc7sjh71DibWzlcAmW2qfY6I=;
        b=blSxh8xrhiDfs5p/iwUhDy6iMj6Drgy2jwl9FwqhLy4/XN5TubSFIBhzh51AhSRzMW
         1sv3dWzMCcr0etWku93tUkz91MNDZfhNLGrX8TeX6LW5FiX24zTm0/JRvfNK9560Drga
         4QmajBs7Dljtg5Wxg7gCsmZrjAp5R2pcEDkj94x6l0GnS6cfL/FamEA5tQ7jOWThalGC
         VTsKvlnk8CRP67ui4AIyCTk33jFXqqNWXJ2LYC50u2xnkFgpiiUTVd+Mgqr49ALaTJCi
         6jGBuTe82qTaBO+KDnphpSeZgYMSujw+nzhGdb8QLYpUqn4NHajHXoG3KF/n0U3MhCcW
         U9HA==
X-Gm-Message-State: ACgBeo2QlQhuFT63b9beliHlIfB1NSpOu0tRD9JDqZOT65zR3wqwixom
        L17abXzSpWYJWTpBmcuW4GyAVqJbs+cneCsOWHw=
X-Google-Smtp-Source: AA6agR70Sifz0yIAPqzR8fpztYBwRJTavcIObnu+mcUGdmPEB6gOpEUsdXw+yTzJ3LAR96vhKqJ8jAmh9gcfM/XAGTo=
X-Received: by 2002:ab0:6894:0:b0:384:d360:14b7 with SMTP id
 t20-20020ab06894000000b00384d36014b7mr880032uar.84.1660265801630; Thu, 11 Aug
 2022 17:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-6-lsahlber@redhat.com>
 <87leruudal.fsf@cjr.nz>
In-Reply-To: <87leruudal.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 19:56:30 -0500
Message-ID: <CAH2r5mvCuJM5z5nzfXW6Mkqgo4CWxoORUhsNT4ZtrjS=tVSJxg@mail.gmail.com>
Subject: Re: [PATCH 5/9] cifs: Do not access tcon->cfids->cfid directly from is_path_accessible
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tentatively merged this patch (after rebasing it and fixing a minor
checkpatch problem).  Added Paulo's RB

Skipped adding patch 4 though (cifs: Make tcon contain a wrapper
structure cached_fids instead of cached_fid) - let me know if problem
skipping that patch in the short term

On Thu, Aug 11, 2022 at 8:20 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > cfids will soon keep a list of cached fids so we should not access this
> > directly from outside of cached_dir.c
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cached_dir.c | 10 ++++++----
> >  fs/cifs/cached_dir.h |  2 +-
> >  fs/cifs/readdir.c    |  4 ++--
> >  fs/cifs/smb2inode.c  |  2 +-
> >  fs/cifs/smb2ops.c    | 18 ++++++++++++++----
> >  5 files changed, 24 insertions(+), 12 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
