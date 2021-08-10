Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B26C4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 04:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 435DD61051
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 04:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbhHJEWO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbhHJEWD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 00:22:03 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A7FC0613D3
        for <linux-cifs@vger.kernel.org>; Mon,  9 Aug 2021 21:21:41 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id h11so11990006ljo.12
        for <linux-cifs@vger.kernel.org>; Mon, 09 Aug 2021 21:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w6WkDPqzd/kwRt6o+oG94Ag0q2rcddQRKTOa4z4ljtA=;
        b=t1gxl4owwmsBiPHWYjdDn99IaG04QoLJgox2eK8R0lja05XG9lWaWbyd45mE8LyG1m
         ZV5yy7dQvlwEjd48j4s3ThRdwsqECsyyJWxwgvRsyT4srtAEsiUTCondAgmkVgRBlwWA
         kZ2m2RbCjlUY76Yie/SJWoyena7nWfHZsPFbp1iz9dOiJxkavuXN+UMtuWSZ+nvEZyUH
         NlOPxCC5L0M+Zf56RdgFH+LaoGtM+1O8IokILz49Z1gSQVWQpFcfo27wessxVFbI8B3S
         8rgrYAQ4Pnbqk7bTguO7DKyprRvWWK/8ts8mm2TI6U8GJB31zu1sweDeEB+0ORK3CJwf
         wVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w6WkDPqzd/kwRt6o+oG94Ag0q2rcddQRKTOa4z4ljtA=;
        b=cxOmSxJqOiHZ0OgqhuxwebfLTHq2icjGfqwm7616/KEnvLlY2B1EiWAR8L2dy+rJu+
         3034sGVrQAGmG5vvplP43eUXK5l7GoeTaRQoMkCK1wZdXaSRb1UklKDlbPygUouuvryT
         9Y6Z39RykXRqXul5BXYYeEqFCuhzKk2g/m7brqVF5VU42YRLiT6MUacWwhBFZ9ME3HBt
         7xh6xIw5c4UjRUtAgmasjs/F3Kx/S2U2bytahTiX9XTXpbAt2vJNWl0kHHYN1DDDjkmX
         T312N4CY/JHOhZt8ZzuMfpnPH8hTPoNhHoaxzbXyVLvcp/njV9a8Z9KnWXrt98hkQRXv
         CDvg==
X-Gm-Message-State: AOAM533N9a9/j9vfRdmfkeSpDUtM4qz/VO7G4URIM0Tv1fUrbT481O8l
        R40AQF3LJFatMypyyNsy1lTJDjvAAh8wV4daFUE=
X-Google-Smtp-Source: ABdhPJzcjiary5FDyCg53GlQmH9L70YNOdUld57/IRmri+19YirPFwSrT+iBhBs3zo/o2niNeMJLbOVYX/3u6gJQ6E0=
X-Received: by 2002:a2e:a884:: with SMTP id m4mr17893499ljq.406.1628569300215;
 Mon, 09 Aug 2021 21:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210810023609.710993-1-lsahlber@redhat.com>
In-Reply-To: <20210810023609.710993-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 9 Aug 2021 23:21:29 -0500
Message-ID: <CAH2r5mv5WvNSjwG41vtSUhfSDdgUHu45OSdkv8rg4_nQ1T4TBA@mail.gmail.com>
Subject: Re: [PATCH] cifs: use the correct max-length for dentry_path_raw()
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/765

On Mon, Aug 9, 2021 at 9:36 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> RHBZ: 1972502
>
> PATH_MAX is 4096 but PAGE_SIZE can be >4096 on some architectures
> such as ppc and would thus write beyond the end of the actual object.
>
> CC: Stable <stable@vger.kernel.org>
> Suggested-by: Brian foster <bfoster@redhat.com>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 79402ca0ddfa..5f8a302ffcb2 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -100,7 +100,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
>                 pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
>
> -       s = dentry_path_raw(direntry, page, PAGE_SIZE);
> +       s = dentry_path_raw(direntry, page, PATH_MAX);
>         if (IS_ERR(s))
>                 return s;
>         if (!s[1])      // for root we want "", not "/"
> --
> 2.30.2
>


-- 
Thanks,

Steve
