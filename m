Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4463AC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 23:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1526E64DD0
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 23:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhA0X17 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 18:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbhA0X0N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 18:26:13 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A84EC06174A
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 15:25:33 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id z18so3307781ile.9
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 15:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S8lsbIj/lUXv/MGJZmQD2R/A8KLMNWjXXFTNHbGX/ug=;
        b=iGgURttVEm/FMvfBLLB3brxRSlewQVkWoiQSRTeblqIjhZw0zyYJhlgzYfypS3KGRc
         gwc0xb5rh7SSY4EuNls8dgJ5ADT93E/ozVPAbmIZphD2/rqi1iRq1aYQlOqF3FFLIS1L
         hnMXz0b0Orl64twzKcJhglTq0ZH8CNn1S1fKw5RyMzHODowxrxlj4o+eCw8qQctt3/qJ
         ut0lGSNQK7UEy3yEJxdCbYpIzaAJbr2K6LhmR3OeyyQW5dxIfoH+je9pPuR7P8uWuVoJ
         5i5vpAyxCWnNVE+fapYJG3fH9K6JGlQxWdKwV42791M2QqzG5wSdJ+Z+Vl57rx7yMjoW
         z2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S8lsbIj/lUXv/MGJZmQD2R/A8KLMNWjXXFTNHbGX/ug=;
        b=tWokmLbHuwRVnFDg1PzBbY8iqTwmTWidKaEXclRztRBjiiN1Usl6dsIhowdhVq+JVP
         Jo3K6lQ4O1wgNmBehrOmdY4PRPyQsPGKup/hRHVPeOpDZhJRf0OBiLtjMKl+fjo+OlQ0
         9FKv0DyncLW6AE2RZEkX/nNwTvtiOxVhap/ENtu2WfZWn2UQTtSpNe85ola2UAf+SLBB
         jQXHXnXUke/lLqyq4SFXOknGbU+tqok3cBeI6hSxSBJTcVc1CJPlTWsvdbZ23vK3UtiS
         EaOS6dGSuDLiJE9NLKSTMWnQXVAQpgMTLHPDl5eI6+epNtjj7+v/kZR9qDuzMShBdDHR
         4UEw==
X-Gm-Message-State: AOAM532Pe+TmTIC0wFGGxv4zIUUjEe7NTdq3Y+9ZYtROHyvnSVUU5pXt
        ZykKu/crLoFqaYSr3BJasu1aB4owCjNUnMBAis4=
X-Google-Smtp-Source: ABdhPJw6lO7Xt2EzwY3JicNkjFLcTG9gnM5ryiGfbBiwp/zub2iHP/eYkOSpx4h7e20k/x3eK3HutkufmmQQeaIMVJc=
X-Received: by 2002:a05:6e02:ca9:: with SMTP id 9mr10835503ilg.159.1611789932800;
 Wed, 27 Jan 2021 15:25:32 -0800 (PST)
MIME-Version: 1.0
References: <CADajX4DzoNehHZGqpd+3Bh0yM2U=B6AwL6bJ2EM6t6hkvr7L4Q@mail.gmail.com>
 <20210127214434.3882-1-adam@adamharvey.name> <CAH2r5ms5FXALbcfvfXo7bR7WXEzCk-jeosoQWk28DdUad++qEA@mail.gmail.com>
In-Reply-To: <CAH2r5ms5FXALbcfvfXo7bR7WXEzCk-jeosoQWk28DdUad++qEA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 28 Jan 2021 09:25:21 +1000
Message-ID: <CAN05THRXHYkXCe79n3caKjRt+ojZ+-LONvfDH=2aQ7RVDRVnZQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: ignore auto and noauto options if given
To:     Steve French <smfrench@gmail.com>
Cc:     Adam Harvey <adam@adamharvey.name>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Jan 28, 2021 at 9:19 AM Steve French via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> The patch looks harmless, but am curious if other people can repro
> this.  I tried it on 5.11-rc4 (cifs-utils version 6.11).  I tried it
> with and without the mount helper (mount.cifs).  I couldn't get it to
> fail with 'noauto'
>
> Anyone else able to repro the problem?
>
> On Wed, Jan 27, 2021 at 3:44 PM Adam Harvey <adam@adamharvey.name> wrote:
> >
> > In 24e0a1eff9e2, the noauto and auto options were missed when migrating
> > to the new mount API. As a result, users with noauto in their fstab
> > mount options are now unable to mount cifs filesystems, as they'll
> > receive an "Unknown parameter" error.
> >
> > This restores the old behaviour of ignoring noauto and auto if they're
> > given.
> >
> > Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> > Signed-off-by: Adam Harvey <adam@adamharvey.name>
> > ---
> >  fs/cifs/fs_context.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index 076bcadc756a..62818b142e2e 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -175,6 +175,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
> >         fsparam_flag_no("exec", Opt_ignore),
> >         fsparam_flag_no("dev", Opt_ignore),
> >         fsparam_flag_no("mand", Opt_ignore),
> > +       fsparam_flag_no("auto", Opt_ignore),
> >         fsparam_string("cred", Opt_ignore),
> >         fsparam_string("credentials", Opt_ignore),
> >         {}

We probably also want to add
fsparam_string("prefixpath", Opt_ignore),

> > --
> > 2.30.0
> >
>
>
> --
> Thanks,
>
> Steve
>
