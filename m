Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885CEC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 21:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbiJKVy4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 17:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJKVyz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 17:54:55 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DC315FC1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 14:54:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b2so34283684eja.6
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 14:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VuGg7FLDCZzHmC1WA2CzQkwfWLoBkDNcul7V+Ge0IS4=;
        b=qL+e+Z8gxhA+G4CKbQnoacm2gA/RDiccCGn/2JsnhYMBOylAhC3kA5Bye0XuFox9yy
         DJkc/8+6zEWStCyDGY3vCb3Vjyx0BD0Aq5rLVuXGzge5kDoSSPsf5iJfMqKk51ffZyLk
         TgIvjNO6FNzAMRhRQfiHpm2bBhrqML71+elhqghboypMMcvzQya7UwUMJFvfZWqzPGoW
         +oy3oHLc8QS1XXUQR7QvKKkgpfQYdGyJTSKGTJQLTg0svpgNFW5BBS+O0AyPZW67vW5c
         6AtgLU1nzDOUSr/MMbCrr6JXD4U6UrP4Xw+05dtPQLsMCsJOsugwC25Hnrc1u9uTKpW2
         3OCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VuGg7FLDCZzHmC1WA2CzQkwfWLoBkDNcul7V+Ge0IS4=;
        b=0Ip/biz+nZ2MJQQCPoUlfY2yAk8wDoIxZw7prUUAOl9Ex6jOAD3Sb2XqF56bzutuFV
         7zXnAiqtqiUpXwPR1Waq1zPVxCqlOpwglOg6dqZno3KeXvYZ92GA2cQNavCJQdzK7hjI
         R3Nk+IZjPLqTPLqwkelBb/C+7ivbYVtwKlKKISRM2/WYum7NQ7sBREXsHW7ARAI/szdP
         2wLfeIy9+ESsAMyi7if9FVFC+OU1pGQLcBabP+Frn3Ns3GVaEp1hLJ1V8SOv8W/8HLSz
         HqhjiPTpBnbRvY/aXepgNTrtGavPO9fdNGWV7zn53XuW1h8B/mYTY03CBQiGesABCV6V
         ICPw==
X-Gm-Message-State: ACrzQf0qJ2/dkH8pPN/TUK4yaqAI3QPils2yEV9CqEeHttNw6oCammkT
        PhNQGhNzCSuoDK5URfSY1RtKnKcc0cECvLg2eqho3E++
X-Google-Smtp-Source: AMsMyM45EYWzQMBNfCtw1BXf6bGj7RGmeesWsR2Rb9uvqc4/Cddi0Jfb9gWXU7jMvDb3kdMEz0iw0rpGok2YE9JGuRI=
X-Received: by 2002:a17:907:9717:b0:78d:9fb4:16dd with SMTP id
 jg23-20020a170907971700b0078d9fb416ddmr13112748ejc.720.1665525291912; Tue, 11
 Oct 2022 14:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221011064611.1428646-1-lsahlber@redhat.com> <20221011064611.1428646-2-lsahlber@redhat.com>
 <f2d94342-c316-21d3-4dc8-7a969a102c2d@talpey.com>
In-Reply-To: <f2d94342-c316-21d3-4dc8-7a969a102c2d@talpey.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 12 Oct 2022 07:54:39 +1000
Message-ID: <CAN05THR-WMM0KX06UuH0QSan=S4=zaO9KYC9zcbY4R0NPdhhwQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
To:     Tom Talpey <tom@talpey.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, 12 Oct 2022 at 02:40, Tom Talpey <tom@talpey.com> wrote:
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

I think if an application does an lseek() to a position we did not
previously tell
the application about, then what happens is undefined.
What happens in this patch is that we just "skip" to the next entry
with a "valid" pos
and start returning data from there.
I.e. we just skip over the "hole" but that should be fine since the
application should never
have lseek()ed to somewhere inside the hole to begin with.

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
