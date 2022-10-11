Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB952C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 21:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJKVic (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 17:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJKVia (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 17:38:30 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BB1895F4
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 14:38:27 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id 3so15685554vsh.5
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 14:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IAGtRtICh4vIy5b0raEC5TMJ+Ueis46B/krZ/pXSSX8=;
        b=cinXSao8CJuYC5vAE/PxTtnKtobhkss0uoDQERSYXEJyhN7Ci2HjORgwG4nu8a8CYH
         nn5JYSYyBUN36KOL1Z+tj7y68HPaefXfpCjd1J+srUc2BfDTfVCIkbT6gq+Kqq7FVYl9
         o6UwTcWna28/1gcggpV1bxL1uEnIYAI5NNOuAb96RNMWg3wXZoFwdBmy+tQD8zAjp6fL
         umY8cUPF47v9WRH+j7TbYLuaU2mdWPCtuP3zG6XblzB6jtidMT86lkHd1Y9Q4cbofIk9
         SRdrQ7upK93kYo9CX7FGEeaq3Ab83kdmETbU8Ms953OKXibnuZgq3muoo3FfDynupcqq
         hxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IAGtRtICh4vIy5b0raEC5TMJ+Ueis46B/krZ/pXSSX8=;
        b=7RNHGM84YOHdrQYqA5LEfNbgpYubmkAwzz/gef7c4mIHhp+y2fG35Gb5bL1pXiXMK+
         POMqwSQNL8JcrzPV0i8UVglg4UfZSNGnrhfP66QhUYvRxj7cNkQK2ePBwjgDI68EXp2k
         fSmjToy1DYaxlIFC3RcZ8Sjgi+RA45U7meKNPV/joyjeBTStxei48cUwhEMhBgTWptGR
         c+geCMxNszSTyD2EomEznc0ozKvXcAZSHBYeZYFrYmtPYHCie2GlgLV9+jni5FIxzJZh
         F9tGQRZLgjizbKM/RgT5XT//FSQiCqRlWRBCkabs0DG+k2AEZ+1c4w5beYeZaW1D9e/1
         UpdA==
X-Gm-Message-State: ACrzQf1wjJ60Yt1NhdzPT14zdtlgdysCy+qPH33RuJXtFSKEAky+LXYC
        CpgtIn3tMKFuTJafrBhsTEoLQLNYHcsRJmDfGPw=
X-Google-Smtp-Source: AMsMyM5jdFiKEZMxfzRhhqs1cj8gkWX4N79oaQnHLK9kxSFi/qim0DK2RbmA5WKwHA0SzODNkXq2ksjBJJZzWNlff1I=
X-Received: by 2002:a05:6102:23dc:b0:3a7:9b0c:aa8e with SMTP id
 x28-20020a05610223dc00b003a79b0caa8emr4417585vsr.60.1665524306049; Tue, 11
 Oct 2022 14:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <20221011064611.1428646-1-lsahlber@redhat.com> <20221011064611.1428646-2-lsahlber@redhat.com>
 <f2d94342-c316-21d3-4dc8-7a969a102c2d@talpey.com>
In-Reply-To: <f2d94342-c316-21d3-4dc8-7a969a102c2d@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 Oct 2022 16:38:15 -0500
Message-ID: <CAH2r5mt=CRMf9=W0tJYkOkqrHnf-_Q1b35FCU1Z4o4en31mHjg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I ran the buildbot on this and it looks like this version of the patch
fixed the tests which failed with the earlier version of the patch

On Tue, Oct 11, 2022 at 11:38 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 10/11/2022 2:46 AM, Ronnie Sahlberg wrote:
> > When application has done lseek() to a different offset on a directory fd
> > we skipped one entry too many before we start emitting directory entries
> > from the cache.
> >
> > We need to also make sure that when we are starting to emit directory
> > entries from the cache, the ->pos sequence might have holes and skip
> > some indices.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/readdir.c | 15 ++++++++++-----
> >   1 file changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index 8e060c00c969..7170614434a1 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -847,14 +847,19 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
> >       int rc;
> >
> >       list_for_each_entry(dirent, &cde->entries, entry) {
> > -             if (ctx->pos >= dirent->pos)
> > +             if (ctx->pos > dirent->pos)
> >                       continue;
> > +             /*
> > +              * There may be holes in the ->pos sequence
> > +              * so always force ctx->pos to the current position.
> > +              */
>
> The comment is a bit vague by referring to "->pos", because
> it's the same name in both ctx and dirent.
>
> But I have a second question, does squeezing out the holes
> affect a later possible lseek on the dirhandle? I'm having
> trouble tracking down where that might happen.
>
> >               ctx->pos = dirent->pos;
> >               rc = dir_emit(ctx, dirent->name, dirent->namelen,
> >                             dirent->fattr.cf_uniqueid,
> >                             dirent->fattr.cf_dtype);
> >               if (!rc)
> >                       return rc;
>
> It's weird that "rc" is an integer, but dir_emit() returns a bool.
> It's also confusing that this isn't coded as
>
>                 if (!rc)
>                         return false;
>
> Other than those questions, it looks like a clever fix.
>
> Tom.
> > +             ctx->pos++;
> >       }
> >       return true;
> >   }
> > @@ -1202,10 +1207,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
> >                                ctx->pos, tmp_buf);
> >                       cifs_save_resume_key(current_entry, cifsFile);
> >                       break;
> > -             } else
> > -                     current_entry =
> > -                             nxt_dir_entry(current_entry, end_of_smb,
> > -                                     cifsFile->srch_inf.info_level);
> > +             }
> > +             current_entry =
> > +                     nxt_dir_entry(current_entry, end_of_smb,
> > +                                   cifsFile->srch_inf.info_level);
> >       }
> >       kfree(tmp_buf);
> >



-- 
Thanks,

Steve
