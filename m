Return-Path: <SRS0=41bt=7X=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20A5C433DF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Jun 2020 17:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF3D206F4
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Jun 2020 17:28:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F3Y0ghWF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgFJR2b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgFJR2a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Jun 2020 13:28:30 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74680C03E96B
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2020 10:28:30 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id y13so1553302ybj.10
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jun 2020 10:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ck9JiIjjUN+vYI7kEd1vy4Kf+gkVWNHYz7bn9/Rg9FY=;
        b=F3Y0ghWFGuHkfCW/p9cyiVLnE/UqQjkAxMuDSMZ8XaQHsrItfzwp/2miINIdQIqOMw
         tGVXQRSuOq6hAl/Qz7wagn/I89IRzdE/YET8bVPOlOmycluqRFnJgCokyOdJqCz0Xz8b
         Wfgo7RiuMWbYkDd1RcjCs7VxIauYjme4JdPMoHzbrss99nuPitArIiV+s0/qRm83SIyO
         mWvPBcqswdm/5ecqzHwhUvXEmILiHYFf00qCcGnwfQOtLOx/wUtTeKL6n8hNa/EuWZh6
         MlUSc811Nbxwev/nK+cN+b4tnMGUVy+TnexSWmvrCDHVVdyKWYqvKx4J0qBVDMiQp0AD
         O/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ck9JiIjjUN+vYI7kEd1vy4Kf+gkVWNHYz7bn9/Rg9FY=;
        b=b/ZuOB4fLVYUXzRLxv+WexuTPYNJb0XHMkKoQindnN5yl5B/enmSHmfMLy5ocN3vbw
         KLcROVFg/lyaHIGk2odJB0P5TM8Qmr+fxLZ53dP2xD7+1gxjNSvpUfpfQZdvbuaTFxbU
         mAybF9BNxOFY/XItmUkZEIGjWVNegenZyChqWcCV4FzXnSSBDeXXgx39wgADeRv5xr0S
         jytzM3lnaNVIRHrD2FiIVEnuQWWp4jQdEpPWQNs1QL/VhPFlr/PM6gXIi5ehPsbB7FbM
         By/isteYf1yruOAAuMiy9Kaq9JDrUPh/2HXPoc9zLBiN7FhdbdSg1xoUUFfLOoHhPJhA
         83Fw==
X-Gm-Message-State: AOAM533ZjQQqbRjOIizMwRsKIESlhSKqJnzrm1+QnEybZKaqt/o+ZjIa
        mwmFErQffvk68WjYj99tscT36gCqLsds703E4qjW/Y3JMiM=
X-Google-Smtp-Source: ABdhPJxFwP3bck31YOHjt1zZGRurReciGH4AQGaBCX37ymZewBPIsV83K+WOJk3i0wFoAmDdSp8M+rsDc7U5FU+/bzc=
X-Received: by 2002:a25:73c3:: with SMTP id o186mr6596238ybc.230.1591810109126;
 Wed, 10 Jun 2020 10:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv-BZbqsDaTu+PX7Q+zxcosn=N5mM28Thr0LGyAKi9MRQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv-BZbqsDaTu+PX7Q+zxcosn=N5mM28Thr0LGyAKi9MRQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 10 Jun 2020 22:58:18 +0530
Message-ID: <CANT5p=r1gmrU3R6=TrmDMd8=wWp3n9WwG27=+VSgtD2ZQGyc4A@mail.gmail.com>
Subject: Re: [PATCH] smb3: fix typo in mount options displayed in /proc/mounts
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>


On Wed, Jun 10, 2020 at 6:25 AM Steve French <smfrench@gmail.com> wrote:
>
> Missing the final 's' in "max_channels" mount option when displayed in
> /proc/mounts (or by mount command)
>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifsfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 889f9c71049b..0fb99d25e8a8 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -623,7 +623,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>   seq_printf(s, ",actimeo=%lu", cifs_sb->actimeo / HZ);
>
>   if (tcon->ses->chan_max > 1)
> - seq_printf(s, ",multichannel,max_channel=%zu",
> + seq_printf(s, ",multichannel,max_channels=%zu",
>      tcon->ses->chan_max);
>
>   return 0;
>
> --
> Thanks,
>
> Steve



-- 
-Shyam
