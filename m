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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6D6C07E9A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 05:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAF26136E
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 05:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhGNFcy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237802AbhGNFcy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jul 2021 01:32:54 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A34C0613DD
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 22:30:02 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ga14so1294125ejc.6
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 22:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w0oxelNJwT6/4qp2Iouj7pjKoRpgMwP+WG57kdzNunU=;
        b=FOLA1ugQgLQzj4WnO7CDwtXgpStZMNfOaPVfzut/px7spZ+7j/Ho/Dgmfkwv/5svVD
         Yse7Qe4DOYDt2Hejw5f86+1L6WhOKzIezXotN3Up+3VzMjP+1ZbaabCqKHuNBkkT06tl
         jqLJgtN9btdbXagcK0gEeIsycfKXHam9wO2SA+bi4YbvOy8163C6m8M3Ya6wINyFTLfz
         4HXNs9mzxajSV5hl6Tc1BnT2oPs0yPq8i375HNZjTH8fqpNXgnQv6/udCnvUtE36B7/N
         bfPRPZFm9QiOMr/bq+EEc3jGHvW6HM7DjXGoT3/HDR6qGffbI9shy0FvBvzdjetiBh/E
         /PAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w0oxelNJwT6/4qp2Iouj7pjKoRpgMwP+WG57kdzNunU=;
        b=IsXTOEi09wmd0tqv3DGdJZBTlraCqPHuPvvXFMtHDxbvaPJq9ZlX2Bf0HCH/jDcM90
         muz7AE4Qz7WE7zruDC7UxsL05rax3mXPq05/7WTvEsyDO8upA/FpBdgSjp6CwHFd2o2a
         eZxD89E8bM8tLiLctJ86lm0uqFHeWzE6JYB9zXZHe/piVHtbiZOmnF5s8rxgWD4J/QaC
         QzupJEAPosvq9uNkX2bli4QQfsAywDWiOhLY3iOpfTKm9IRsW2H49K7g63O3/WCnCTmT
         Skw0qwUDyiajJuwcKO+m8j+oUfVLIcdiUFKWZbf1tdXbdHQb4+F/OCElMTKrVA51VCDl
         02hA==
X-Gm-Message-State: AOAM533zfd57Z4BR+eEnv8O3DmTfbPwmimictHanUxPKY7WtrgnbCf7r
        LLVuQp5w2PxFtG/Hr8wcj01w1KNJRou8plelIXQ=
X-Google-Smtp-Source: ABdhPJzNPtSIBdRdnHKBVU+pqtSVUhGVEGRnAXrwCRGCrXAV3C4dq3+KOqZkm7CCa9XE5Wtjad2hd6UMs4JuYUSrm+I=
X-Received: by 2002:a17:906:14cf:: with SMTP id y15mr9914604ejc.124.1626240601510;
 Tue, 13 Jul 2021 22:30:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtHpjjVVKFYKEkAZHG5U=-_umHwMhF2KDJjDSNgoa=Fxw@mail.gmail.com>
 <CANT5p=rOkJ=R1sLHPBuuV350ox7F8u1r6PEZ+nN-gGVcdJ32bg@mail.gmail.com>
In-Reply-To: <CANT5p=rOkJ=R1sLHPBuuV350ox7F8u1r6PEZ+nN-gGVcdJ32bg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 14 Jul 2021 15:29:50 +1000
Message-ID: <CAN05THTiFLgQxbQ22PVZppGMkD=nAn0tg5VEdnojBu2-W0oX1Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix missing null session check in mount
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 14, 2021 at 2:55 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Wed, Jul 14, 2021 at 6:19 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Although it is unlikely to be have ended up with a null
> > session pointer calling cifs_try_adding_channels in cifs_mount.
> > Coverity correctly notes that we are already checking for
> > it earlier (when we return from do_dfs_failover), so at
> > a minimum to clarify the code we should make sure we also
> > check for it when we exit the loop so we don't end up calling
> > cifs_try_adding_channels or mount_setup_tlink with a null
> > ses pointer.
> >
> > Addresses-Coverity: 1505608 ("Derefernce after null check")
> > Reviewed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> >  fs/cifs/connect.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index db6c607269f5..463cae116c12 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3577,7 +3577,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb,
> > struct smb3_fs_context *ctx)
> >   rc = -ELOOP;
> >   } while (rc == -EREMOTE);
> >
> > - if (rc || !tcon)
> > + if (rc || !tcon || !ses)
> >   goto error;
> >
> >   kfree(ref_path);
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi Paulo,
>
> Doesn't it make sense to check rc, tcon and ses values right after
> mount_get_conns call?

Or check rc, but to make mount_get_conns an easy to use api,
maybe make sure and specify that IF it returns error then the output
arguments are
guaranteed to be NULL.

>
>         rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses,
> &tcon);          <<<<<<<<<<<<<<<<<<<
>         /*
>          * If called with 'nodfs' mount option, then skip DFS
> resolving.  Otherwise unconditionally
>          * try to get an DFS referral (even cached) to determine
> whether it is an DFS mount.
>          *
>          * Skip prefix path to provide support for DFS referrals from
> w2k8 servers which don't seem
>          * to respond with PATH_NOT_COVERED to requests that include the prefix.
>          */
>         if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
>             dfs_cache_find(xid, ses, cifs_sb->local_nls,
> cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
>                            NULL)) {
>                 if (rc)
>                         goto error;
>                 /* Check if it is fully accessible and then mount it */
>                 rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
>                 if (!rc)
>                         goto out;
>                 if (rc != -EREMOTE)
>                         goto error;
>         }
>
> Why don't we check for all rc values that we don't expect, and call
> dfs_cache_find only when it's an expected error?
>
> --
> Regards,
> Shyam
