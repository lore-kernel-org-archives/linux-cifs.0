Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0FAC433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Nov 2022 18:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiKKSCZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Nov 2022 13:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbiKKSCY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Nov 2022 13:02:24 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5FC63BB0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Nov 2022 10:02:23 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id t10so5368252ljj.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Nov 2022 10:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s8TZd9ZjbF96jq3/grWR5CYW8loDqf4MfOJ/ysatC+k=;
        b=KpeceHP0WASJ4nP0T9ZP3U9+oQMGODAMSeu0o3/w48duveqof7V24HB30lVeQYZeU1
         ENEFWjbJ9YQoCoG8wti/tGu5VIFagDgTFw4aaBc4eu24MbvaX5BaLFi7zows8JmtDRwX
         kTPJNbHqKnOwajePzPnayRQHpJnodiBMfATxxKnyV8By+BnuxWdj/oOLKTfA/PFqGBRG
         On5AYaElARc4zT7v8h3Kpv9NZZuBmy0Kf9xuHBF/5pIsgm/XLU8ZNWKkOc8kNrzvO3AV
         AirrH0+O7RarrWoUM4nKoCJBh4M3sloETNn/bLcHevY3i8x321AT19lBkSQ64tNbek4o
         n5Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s8TZd9ZjbF96jq3/grWR5CYW8loDqf4MfOJ/ysatC+k=;
        b=F+lYBCKtAB1jfei2wZnvhothNyaRBRC3D90R0WYt8H3EuyxXdyDIOSm+HB2ZuY5pIX
         gxu03mS9Qg+JKmAbxLiobHdFcMRRadsqvF09IbJ4mQV4NqJLqr2KhpsTTsVrbcUmpDsF
         6YLmVhFFb3kTSIUYY+CX0qMdESn1RiaJWhrU+ilAZni2/qfG9XlWAgboN9BQwcbEE1AL
         0tGjDDK8srlbDYCaRA2gPd2kjwSgFyVaaXMod38iQm32ONQTkYKiGRbbT9SlNmXA41r6
         7Pi870vM/+skHhk72/kwkGSuxGLCYhBfI9nS3P+Li/kakCi7CXM0GVIxdePRmsJEp0nJ
         5mHQ==
X-Gm-Message-State: ANoB5pkaajejfJrzaf8W0EptzpnK9j7Po882fObWOC/7o0vhrHnmMGN2
        a4Fv1CcOHOIB7iz2Ae36Rk99FFSj9zhjTnQhdO8=
X-Google-Smtp-Source: AA0mqf6Kcl3vpDhyyrtjsjVerKB457mxEqrzxOd3NDFPeQV1V+eZAG6BHIgfXvejrGph16Ffre9lfFt4G8BgfFQnlWU=
X-Received: by 2002:a05:651c:508:b0:277:f0f:927e with SMTP id
 o8-20020a05651c050800b002770f0f927emr1101774ljp.138.1668189741543; Fri, 11
 Nov 2022 10:02:21 -0800 (PST)
MIME-Version: 1.0
References: <20221111071212.132722-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221111071212.132722-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Nov 2022 12:02:10 -0600
Message-ID: <CAH2r5mt0D7WAjvEVWmdZ_nMO_0LZXQWWhx_RFHszT-cVBSbo3Q@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: Fix connections leak when tlink setup failed
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
        palcantara@suse.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Fri, Nov 11, 2022 at 12:07 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> If the tlink setup failed, lost to put the connections, then
> the module refcnt leak since the cifsd kthread not exit.
>
> Also leak the fscache info, and for next mount with fsc, it will
> print the follow errors:
>   CIFS: Cache volume key already in use (cifs,127.0.0.1:445,TEST)
>
> Let's check the result of tlink setup, and do some cleanup.
>
> Fixes: 56c762eb9bee ("cifs: Refactor out cifs_mount()")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
> v2: goto error rather than only put connections.
>
>  fs/cifs/connect.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 1cc47dd3b4d6..9db9527c61cf 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3855,9 +3855,13 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>         uuid_copy(&cifs_sb->dfs_mount_id, &mnt_ctx.mount_id);
>
>  out:
> -       free_xid(mnt_ctx.xid);
>         cifs_try_adding_channels(cifs_sb, mnt_ctx.ses);
> -       return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +       rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +       if (rc)
> +               goto error;
> +
> +       free_xid(mnt_ctx.xid);
> +       return rc;
>
>  error:
>         dfs_cache_put_refsrv_sessions(&mnt_ctx.mount_id);
> @@ -3884,8 +3888,12 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
>                         goto error;
>         }
>
> +       rc = mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +       if (rc)
> +               goto error;
> +
>         free_xid(mnt_ctx.xid);
> -       return mount_setup_tlink(cifs_sb, mnt_ctx.ses, mnt_ctx.tcon);
> +       return rc;
>
>  error:
>         mount_put_conns(&mnt_ctx);
> --
> 2.31.1
>


-- 
Thanks,

Steve
