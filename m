Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC199C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Dec 2021 16:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245403AbhLCQYn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Dec 2021 11:24:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58716 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245119AbhLCQYn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Dec 2021 11:24:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638548478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WmwKI0Rrs6s+p5PMIOByDWLRKuoxB60ntIhXHHr7XFw=;
        b=Dyv2e9Fc/Q+bioGqQCzX/QMNLr5j/wksZ5rc4i/AI0PD/nzChl0xh4csNZn1Ht5zLxs+Dc
        D8ATFEWkgFGON7BLTIIvNJWq7/KnXQRuEIU/WiA8W5zk3UIzv7BZUUFgueszoIj+Fuv/8S
        wZotqDXxP9x8CpBb7Gjm6blSm0OtF+o=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-AhfXXUlaP1mEYPwyIRS_UA-1; Fri, 03 Dec 2021 11:21:17 -0500
X-MC-Unique: AhfXXUlaP1mEYPwyIRS_UA-1
Received: by mail-qt1-f200.google.com with SMTP id h8-20020a05622a170800b002acc8656e05so4105003qtk.7
        for <linux-cifs@vger.kernel.org>; Fri, 03 Dec 2021 08:21:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WmwKI0Rrs6s+p5PMIOByDWLRKuoxB60ntIhXHHr7XFw=;
        b=0X0HfNWDNX1JkNbv0ghXXGKCxorAFdREwWLrRoJG0py0Ll0QA4+k9rXW+Bw+LV4zaY
         skS+qcvs6uhdL7yoVhByKYxYzgHfgAfSKaSxSJ3Cr7VOFABIA2JEg2fAohC3UH3+UEkq
         wQ2SX2yk6uOOiOk+K5mMx9j9pgSVl5gmT6RWai1EFEw4na94xbAg5Vz2pvdLfQZaH/Y6
         rmjThjD0Sv5CJ9nNf6ANqmwkI95g0SQ+znfdcDtXS1lRI1NEkjVU5iIGszLrYzlbDzvy
         FmIR8RVRybnJBi91AgEZV6XguJXV+4IWXEz4UDNnnEp6JiictG2BLGhNDCXjB0lp9Ifk
         J05g==
X-Gm-Message-State: AOAM531hUfW3YLQnvOePGSx6CwRIQTYz+gzPx+vy4+Udp4l4/nvJRA+f
        WujQ78P9cy+s9gGovLe5aQjPDiVx2gubrS5Yt0f9+1WnCEKazpfoNzeNugGsE8YfgnrUZuWVurL
        gspIKt4QOORfoiQr8NEKX2Q==
X-Received: by 2002:a37:712:: with SMTP id 18mr18618342qkh.366.1638548476900;
        Fri, 03 Dec 2021 08:21:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytQeHHjaOvWbjY3ttJKV9uzms29bDNbIS2T0Gm6yNwfaWmDh0HATyYXYPHOuRSyahKw5mlKw==
X-Received: by 2002:a37:712:: with SMTP id 18mr18618322qkh.366.1638548476666;
        Fri, 03 Dec 2021 08:21:16 -0800 (PST)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id e20sm2692363qty.14.2021.12.03.08.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 08:21:16 -0800 (PST)
Message-ID: <88b88564292f84714c83bfe14cae75691e4387c5.camel@redhat.com>
Subject: Re: [PATCH] cifs: wait for tcon resource_id before getting fscache
 super
From:   Jeff Layton <jlayton@redhat.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        linux-cachefs@redhat.com
Date:   Fri, 03 Dec 2021 11:21:15 -0500
In-Reply-To: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
References: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 2021-12-03 at 14:52 +0530, Shyam Prasad N wrote:
> The logic for initializing tcon->resource_id is done inside
> cifs_root_iget. fscache super cookie relies on this for aux
> data. So we need to push the fscache initialization to this
> later point during mount.
> 
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/connect.c | 6 ------
>  fs/cifs/fscache.c | 2 +-
>  fs/cifs/inode.c   | 7 +++++++
>  3 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6b705026da1a3..eee994b0925ff 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3046,12 +3046,6 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
>   cifs_dbg(VFS, "read only mount of RW share\n");
>   /* no need to log a RW mount of a typical RW share */
>   }
> - /*
> - * The cookie is initialized from volume info returned above.
> - * Inside cifs_fscache_get_super_cookie it checks
> - * that we do not get super cookie twice.
> - */
> - cifs_fscache_get_super_cookie(tcon);
>   }
> 
>   /*
> diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
> index 7e409a38a2d7c..f4da693760c11 100644
> --- a/fs/cifs/fscache.c
> +++ b/fs/cifs/fscache.c
> @@ -92,7 +92,7 @@ void cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
>   * In the future, as we integrate with newer fscache features,
>   * we may want to instead add a check if cookie has changed
>   */
> - if (tcon->fscache == NULL)
> + if (tcon->fscache)
>   return;
> 

Ouch! Does the above mean that fscache on cifs is just plain broken at
the moment? If this is the routine that sets the tcon cookie, then it
looks like it just never gets set?

>   sharename = extract_sharename(tcon->treeName);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 82848412ad852..96d083db17372 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1376,6 +1376,13 @@ struct inode *cifs_root_iget(struct super_block *sb)
>   inode = ERR_PTR(rc);
>   }
> 
> + /*
> + * The cookie is initialized from volume info returned above.
> + * Inside cifs_fscache_get_super_cookie it checks
> + * that we do not get super cookie twice.
> + */
> + cifs_fscache_get_super_cookie(tcon);
> +
>  out:
>   kfree(path);
>   free_xid(xid);
> 

-- 
Jeff Layton <jlayton@redhat.com>

