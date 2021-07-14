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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11688C07E9A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 04:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F007E61279
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 04:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbhGNE5n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 00:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhGNE5m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jul 2021 00:57:42 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8275EC0613DD
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 21:54:50 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i18so1078247yba.13
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 21:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNgZf0AJpN6lSY4+dp9m5YXUeIHa5+jBOk1VvW4pgiA=;
        b=mMjkc3r6Ryvx74P62DI1AB7ClBQszD4n9Os50dsaUDTygfoF+Q6uMvDjPDYHBeyLSn
         strsVSt6tNZ9+2EAnqPalKyLMYKwuPiFjgqxScMDVDXu1JwMPIE3gPGh1iIDuIgW48I4
         FkLMNYMHgsuUXnxwAc3S+6Wh0SWfgpJbawdeA4g74EIlyj2P48zybs+YfsTm/ERDHeGR
         hMBHyzdvhRrs2C3FxpNzFXAQ539vC7VlEbmM0gDrkeO1qxrdf159p7QgohOGdz/gyq4p
         YPL6jWsp83skIxH/OtiOx2j0c+XbZu3z0gd5xT8arLrO37GeE2ltQIjMa5HzpeL+2KFp
         ojOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNgZf0AJpN6lSY4+dp9m5YXUeIHa5+jBOk1VvW4pgiA=;
        b=o23rptw0f4eYtRAWM/esJXKAJ0+tfZCgJWSduulKLrv6aWHjtYDgKIxHKzByw3hBqZ
         /kZfZPPDnsdPGt6o6ww5GcSDZXrGVckHmhg26NhSpUBfa/nwDe4Ibs5w67QsZaPGvEaY
         312rW16XZz4KngiJi4FVKshcbOlBMiIzsydSwErAsbUDpnNLaCM5DvR2sIfKfxuuThe9
         6KWEKzj7oqH6R+dmCv0BvwiJ0QKugNMpahJfQ5Xd1iajfz/G7dvwQDgZWV8YeZLyJhC7
         XHLWroq5QZqtxmEnRkbBN3Otn0HA+H49z9oNsbJFWMWtLNEeB0Jyu2NBEluZ2cxlqov/
         eplA==
X-Gm-Message-State: AOAM533pTEK9V6u8AXmQZDWCIZuL7RYwKeFykp+EBUYUUtJuTzxkxRi/
        /iVmA1UL4XclNXTItyp0Xoi602+mmPRMv411pmY=
X-Google-Smtp-Source: ABdhPJyXYceWCqhGaFOCtDhu3kfUZnYE61FiSVq7XHriZG7EW9Q3wHl5LOjN2q1UvIhdJVmzzinyVJg7YwwUXsZpn9w=
X-Received: by 2002:a25:4209:: with SMTP id p9mr9977697yba.3.1626238489586;
 Tue, 13 Jul 2021 21:54:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtHpjjVVKFYKEkAZHG5U=-_umHwMhF2KDJjDSNgoa=Fxw@mail.gmail.com>
In-Reply-To: <CAH2r5mtHpjjVVKFYKEkAZHG5U=-_umHwMhF2KDJjDSNgoa=Fxw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 14 Jul 2021 10:24:38 +0530
Message-ID: <CANT5p=rOkJ=R1sLHPBuuV350ox7F8u1r6PEZ+nN-gGVcdJ32bg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix missing null session check in mount
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 14, 2021 at 6:19 AM Steve French <smfrench@gmail.com> wrote:
>
> Although it is unlikely to be have ended up with a null
> session pointer calling cifs_try_adding_channels in cifs_mount.
> Coverity correctly notes that we are already checking for
> it earlier (when we return from do_dfs_failover), so at
> a minimum to clarify the code we should make sure we also
> check for it when we exit the loop so we don't end up calling
> cifs_try_adding_channels or mount_setup_tlink with a null
> ses pointer.
>
> Addresses-Coverity: 1505608 ("Derefernce after null check")
> Reviewed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index db6c607269f5..463cae116c12 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3577,7 +3577,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb,
> struct smb3_fs_context *ctx)
>   rc = -ELOOP;
>   } while (rc == -EREMOTE);
>
> - if (rc || !tcon)
> + if (rc || !tcon || !ses)
>   goto error;
>
>   kfree(ref_path);
>
> --
> Thanks,
>
> Steve

Hi Paulo,

Doesn't it make sense to check rc, tcon and ses values right after
mount_get_conns call?

        rc = mount_get_conns(ctx, cifs_sb, &xid, &server, &ses,
&tcon);          <<<<<<<<<<<<<<<<<<<
        /*
         * If called with 'nodfs' mount option, then skip DFS
resolving.  Otherwise unconditionally
         * try to get an DFS referral (even cached) to determine
whether it is an DFS mount.
         *
         * Skip prefix path to provide support for DFS referrals from
w2k8 servers which don't seem
         * to respond with PATH_NOT_COVERED to requests that include the prefix.
         */
        if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS) ||
            dfs_cache_find(xid, ses, cifs_sb->local_nls,
cifs_remap(cifs_sb), ctx->UNC + 1, NULL,
                           NULL)) {
                if (rc)
                        goto error;
                /* Check if it is fully accessible and then mount it */
                rc = is_path_remote(cifs_sb, ctx, xid, server, tcon);
                if (!rc)
                        goto out;
                if (rc != -EREMOTE)
                        goto error;
        }

Why don't we check for all rc values that we don't expect, and call
dfs_cache_find only when it's an expected error?

-- 
Regards,
Shyam
