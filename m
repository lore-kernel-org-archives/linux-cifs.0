Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62293C54E94
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 16:20:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbjAYQU6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 11:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbjAYQUu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 11:20:50 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919955A373
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 08:20:25 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id e16so20921951ljn.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 08:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5/sKUD1Vp8HuiaLno+19QZM073FgzJlhTjpIXlts/ic=;
        b=fw0x/WgHO2/bo92FrufAXMQHnDSw+tKyemmQ6y2lYYPymup4XHiFsQDT5yogsN5TrM
         4Pt/sebpGchRsSCSgun6YGiA7s87UFhEggcIBtcBSMJNqNXdtJMMzGU9MhAQlyaJ1Tag
         DtpNtj0PjCxpIZJabvCeZWsgycFyudaSzURtzJxWAuyxdQua9uWovg6GlkF6oqQKjXC+
         D8xuzMdGAYZM7D2sTc8kvK9Z61dSEfzVFIBqd3IpD6Eou7xnmp2/C30BnPAS50njj5Nx
         9E/OzTVwAfpSgvgR2e9anzdgvjEGzfwsKrKMTUJsAo5edMA6JoMMo+413jsGvtSWu9Up
         POuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5/sKUD1Vp8HuiaLno+19QZM073FgzJlhTjpIXlts/ic=;
        b=4j408H7CICEKkQRRL698qKDW7fGPf4jDGxtkRLmG1Can5/Q9N/G5Lz476+OhgZFsaJ
         EfZqdFWP1E4zlxvSXCwtd1wd7GGaapwTiym5aSoOs5wFCC0TrEjb2Ymn4VCLsAv++2g4
         EeyLDF2MGJKnjSXYdzI++CzEfTw+58h9FJSSj6ml2sNVTXs+9ia63UDNdJI74aFmsB1O
         xTj2P62E0P9io70idHfqkeHbRTAgUk1k+z79LIA+Erf1oQS/4wv0AdsyaXHlPXoCy2jH
         18Vy/2d3asOAG1Rrep++hnXaluQj6PbH4+2qX4IWqp6naSYQ58ckdNU6AZjueZudgG6u
         lrlQ==
X-Gm-Message-State: AFqh2kp7goC4HUjhL/GUcf3aptUagWdFQgkpDwRnSdUpLEVfqQxW1YIS
        ILt18LwlpwWbR+oKpwflcu9WZO01n7kKTs+osX4=
X-Google-Smtp-Source: AMrXdXuiMD6mGMNAueWNE6EsgP7TPp9dX1ua/XivPAHugYwjniCEE/D5InO+Nhd2LYees93OgGZBFPvG0k5uohulDlY=
X-Received: by 2002:a05:651c:897:b0:283:e784:a344 with SMTP id
 d23-20020a05651c089700b00283e784a344mr2648080ljq.199.1674663623340; Wed, 25
 Jan 2023 08:20:23 -0800 (PST)
MIME-Version: 1.0
References: <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk>
In-Reply-To: <2132364.1674655333@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 25 Jan 2023 10:20:12 -0600
Message-ID: <CAH2r5mvtAEvVENWvF4XGwB0rSFJHKAtbCQzwA_4_HrXUe7gt0Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

minor cleanup of description and pushed to cifs-2.6.git for-next

On Wed, Jan 25, 2023 at 8:05 AM David Howells <dhowells@redhat.com> wrote:
>
> Hi Steve,
>
> That attached patch stops the kernel from oopsing, but it still tries
> endlessly to send with softRoCE.  I'm having better luck with softIWarp - with
> some other patches, I can run generic/001 to completion with that transport.
>
> David
>
> ---
> commit 820cb3802c6a73c54e2e215b674eb5870fd5d0e5
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Jan 25 12:42:07 2023 +0000
>
>     cifs: Fix oops due to uncleared server->smbd_conn in reconnect
>
>     In smbd_destroy(), clear the server->smbd_conn pointer after freeing the
>     smbd_connection struct that it points to so that reconnection doesn't get
>     confused.
>
>     Fixes: 8ef130f9ec27 ("CIFS: SMBD: Implement function to destroy a SMB Direct connection")
>     Signed-off-by: David Howells <dhowells@redhat.com>
>     cc: Long Li <longli@microsoft.com>
>     cc: Steve French <smfrench@gmail.com>
>     cc: Pavel Shilovsky <pshilov@microsoft.com>
>     cc: Ronnie Sahlberg <lsahlber@redhat.com>
>     cc: linux-cifs@vger.kernel.org
>
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 90789aaa6567..8c816b25ce7c 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
>         destroy_workqueue(info->workqueue);
>         log_rdma_event(INFO,  "rdma session destroyed\n");
>         kfree(info);
> +       server->smbd_conn = NULL;
>  }
>
>  /*
>


-- 
Thanks,

Steve
