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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5C5C07E9A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 05:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7858D613B0
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 05:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbhGNFF1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhGNFF1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jul 2021 01:05:27 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F06C0613DD
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 22:02:36 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id t17so1474884lfq.0
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 22:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I7sRWBdw2rcymoGIboyvXWQEZAyq5maHcczpCYjuo7s=;
        b=rbbjXsdsXHQot0o0mBI6iY+yLskhbQ1woJx0592sT5846+PZfL8tL8LD1Jw5nNqXhW
         LqJGUk1TjROUyRR+dFC8drK43iAZLrFDQebtlCl4H3ntmV+HZkuC/T7VQObAoGV0Az78
         Fp0bGobHc/Ee7xGexhBGNkYAm01c1UrZ6GQZCF7Rt2Nyl9kSty6YuGz2gbXnD+TdhYLA
         ZI0E4Qln8RcL6Qr5YHa4VmwkjzdvtAo9oZ0X76ogz6QrO6yGqcJmuIv7X3xiaW5m0iEN
         SEYvFvvDtQGdecD2h0hJiXs52wd94bi1BP+lAjIvggEcv1R6/sos5PdCcj1Rs8PmrkTQ
         4aSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I7sRWBdw2rcymoGIboyvXWQEZAyq5maHcczpCYjuo7s=;
        b=Fhdqn3GnTwaqytQ3rSiajmwxfkIa90o4HAeN/D/0wPzBRceTy44MQvPKPtK9u9uup5
         Q7CBLIgZo9fV+ojyA3sgdr0gs2VpKuJa5Zu0XVWtudUEX08+g9ki+axnQxLnGbq3F8Xl
         E+LLu86ooW3eS1eY90h+PortYSjwTyPYgeRiM8aWY7L6qN6RIhiWor12zV0sRsODNGmW
         OGEtQLfZorigWTsQbO/2QFWgsFLxsX085bfcBZLlyKBVkt5tmFL/65PV/2B9+1Q+ky+1
         RzPUhljcyhszOjQdGeA5iGejD/i4i7pSCG5L1QjzUnrtDH2JP8HqRUPTATmnMRui0f2A
         oB6A==
X-Gm-Message-State: AOAM532biXGncO/qcyFudUKtdwFpMCz9xKaBi591bVS/Odaj2JJeqo6z
        YEOjtRnXm2Tb2kJsxeYXCKlL/36uzkYUPvlWbU4=
X-Google-Smtp-Source: ABdhPJzq23p4ivQo8aeyGxSCt2ZCRi3h24dilcb5Akiez79E9RCn2VCbLNFfBxVb6cTszG9HOmiCHwa3AN+2XP0ou5A=
X-Received: by 2002:ac2:419a:: with SMTP id z26mr6611567lfh.307.1626238954730;
 Tue, 13 Jul 2021 22:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtHpjjVVKFYKEkAZHG5U=-_umHwMhF2KDJjDSNgoa=Fxw@mail.gmail.com>
 <CANT5p=rOkJ=R1sLHPBuuV350ox7F8u1r6PEZ+nN-gGVcdJ32bg@mail.gmail.com>
In-Reply-To: <CANT5p=rOkJ=R1sLHPBuuV350ox7F8u1r6PEZ+nN-gGVcdJ32bg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 14 Jul 2021 00:02:24 -0500
Message-ID: <CAH2r5muxBkcsssK0p-NQSVOUkX0kn=E-XjKX1MPBasxNtU=mSw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix missing null session check in mount
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

But isn't it the return from do_dfs_failover the issue ... we checked
right before we called it on line 3561 ... but if it fails to populate
ses ... then we break out of the loop - we could change it to "goto
error" but the change in the patch is a little broader (wait until we
exit the while loop)

On Tue, Jul 13, 2021 at 11:54 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
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



-- 
Thanks,

Steve
