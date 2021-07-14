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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0E1C07E9A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 06:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4171F613A9
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 06:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhGNGk7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbhGNGk7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jul 2021 02:40:59 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A83FC061574
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 23:38:07 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id k184so1430543ybf.12
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 23:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EYhb7n9KJixnBJFlgOOVAQVUKO+2NZprfJgA77Ho7gY=;
        b=ugu366VlKbMhAdQzmIiI1PCstyH4xtkI/XhpyTMHqkBbhMf7WQSTWky++Lqj8aRxeX
         izWBlXLp+dNZjp828AEYQOsUqmKw1xNtJA159QqOkmudynr46+2bkXqTRc6BxAhK/xcO
         Pc+qkwTpPbcO1o5vrf5H6RJqBMqZjro9oJ9cZF+1FV+Sk6icfOSRtHZZ3FmIz9xvZlSP
         gKgNnp1H8Sx7k5XiLWo4C5hku9cbLwHR50tW4VXhAirtNQKqLB+MPyuf5h24Qx3Pxz7z
         kEKVHBRv71JvDPgixOp3XbDp5hUlO/ubFVQhfjz+7oeTxdXTs5bxcEHcXoffgwtT5l7g
         ZZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EYhb7n9KJixnBJFlgOOVAQVUKO+2NZprfJgA77Ho7gY=;
        b=GLjNfVL4YeyuzpOYIlZrxRiUbf3kP+A755GtqRIyaZP0e/x4pBRD2dbuGoe0/H1fxQ
         toV75S9HSkkWMFrYvv8AO/kz9KTdSkF1zAjXz/sZfZJbxP52oCizj3YaUsy6ieGHrgNk
         k97uJLW04GVgbTf+PcHCTs08EONhZqNh3YM3jA4qrxg+zlJkM/ACZ7FRHL43s4likY++
         Y9HwNHx9wRoMM/GL2XayDXJnln1K/K/0mmlJdOtVtaNlu5p+Jl6yGP/6uK9gw19Q7Rn8
         I1lqp9HgOj9HURn/35ssPJg+E2yIbxDmSZ1mKuG9eU3oXtpGQcBXfSCdl6jPl5+cCRQA
         ax4g==
X-Gm-Message-State: AOAM532NK8B6wpPEh+hc1UaY4ahwzeexGwbgdoEo5kMZWDWAs2sPuDSt
        ME+tzsoVmfg9mDqvz8x8A0ComkDz5SZ5hmQXJaA=
X-Google-Smtp-Source: ABdhPJxjdw0zr1nk+Iy5h01eScPFWj7q8B0uzyoox+wTf0DKm6mIOI1s3nbBcV+iuw1Ao0JPGAVwJtUJ4CUOK07eA4c=
X-Received: by 2002:a25:9243:: with SMTP id e3mr6883370ybo.97.1626244686612;
 Tue, 13 Jul 2021 23:38:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtHpjjVVKFYKEkAZHG5U=-_umHwMhF2KDJjDSNgoa=Fxw@mail.gmail.com>
 <CANT5p=rOkJ=R1sLHPBuuV350ox7F8u1r6PEZ+nN-gGVcdJ32bg@mail.gmail.com> <CAH2r5muxBkcsssK0p-NQSVOUkX0kn=E-XjKX1MPBasxNtU=mSw@mail.gmail.com>
In-Reply-To: <CAH2r5muxBkcsssK0p-NQSVOUkX0kn=E-XjKX1MPBasxNtU=mSw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 14 Jul 2021 12:07:55 +0530
Message-ID: <CANT5p=ohrjSeEHyuDL40yU__wBngAjcQWyaYE1S15iHxRK8zwg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix missing null session check in mount
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 14, 2021 at 10:32 AM Steve French <smfrench@gmail.com> wrote:
>
> But isn't it the return from do_dfs_failover the issue ... we checked
> right before we called it on line 3561 ... but if it fails to populate
> ses ... then we break out of the loop - we could change it to "goto
> error" but the change in the patch is a little broader (wait until we
> exit the while loop)
>
Yes. That too.
We need to check return value from mount_get_conns and do_dfs_failover.
As Ronnie suggested, we need to make sure that when these functions
return error, none of the pointers get allocated.

> On Tue, Jul 13, 2021 at 11:54 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > On Wed, Jul 14, 2021 at 6:19 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > Although it is unlikely to be have ended up with a null
> > > session pointer calling cifs_try_adding_channels in cifs_mount.
> > > Coverity correctly notes that we are already checking for
> > > it earlier (when we return from do_dfs_failover), so at
> > > a minimum to clarify the code we should make sure we also
> > > check for it when we exit the loop so we don't end up calling
> > > cifs_try_adding_channels or mount_setup_tlink with a null
> > > ses pointer.
> > >
> > > Addresses-Coverity: 1505608 ("Derefernce after null check")
> > > Reviewed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > ---
> > >  fs/cifs/connect.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > index db6c607269f5..463cae116c12 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -3577,7 +3577,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb,
> > > struct smb3_fs_context *ctx)
> > >   rc = -ELOOP;
> > >   } while (rc == -EREMOTE);
> > >
> > > - if (rc || !tcon)
> > > + if (rc || !tcon || !ses)
> > >   goto error;
> > >
> > >   kfree(ref_path);
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > Hi Paulo,
> >
> > Doesn't it make sense to check rc, tcon and ses values right after
> > mount_get_conns call?
> >
> >         rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses,
> > &tcon);          <<<<<<<<<<<<<<<<<<<
> >         /*
> >          * If called with 'nodfs' mount option, then skip DFS
> > resolving.  Otherwise unconditionally
> >          * try to get an DFS referral (even cached) to determine
> > whether it is an DFS mount.
> >          *
> >          * Skip prefix path to provide support for DFS referrals from
> > w2k8 servers which don't seem
> >          * to respond with PATH_NOT_COVERED to requests that include the prefix.
> >          */
> >         if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
> >             dfs_cache_find(xid, ses, cifs_sb->local_nls,
> > cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
> >                            NULL)) {
> >                 if (rc)
> >                         goto error;
> >                 /* Check if it is fully accessible and then mount it */
> >                 rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
> >                 if (!rc)
> >                         goto out;
> >                 if (rc != -EREMOTE)
> >                         goto error;
> >         }
> >
> > Why don't we check for all rc values that we don't expect, and call
> > dfs_cache_find only when it's an expected error?
> >
> > --
> > Regards,
> > Shyam
>
>
>
> --
> Thanks,
>
> Steve



-- 
Regards,
Shyam
