Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE7FFC07545
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Oct 2023 13:42:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbjJYNm1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbjJYNm0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Oct 2023 09:42:26 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E90131
        for <linux-cifs@vger.kernel.org>; Wed, 25 Oct 2023 06:42:21 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40853c639abso41821595e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Oct 2023 06:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698241340; x=1698846140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xek/D1c/3ZtFYXMJxxDYFmlYYDLtkPgvYXa4SHLOo8w=;
        b=FSIneL1bGbsFhYElHdkebl2vwX3SfP9cd6vGBtIy12Z8zZTEqMGnogIbSAubPLOojt
         6n+u+adRRE3Evx694M62+hLDld8JwoLers/A/ok2PAd6xGBnQOFGRRKnJoi4oULcrLCz
         wAbIx3d7jw172xAtnVSKOdDG9ldrDxeERz2rPopOrFp3ySXhttkhCOpUEDz0c1xKcesP
         YYRDhO+aqmKVXklnZsGLx/nFyOSVJo6+212hLDiMNtFCjZikhixwEF89wJwZDPEdIY3u
         qnvgC3hfju4H+Ydp+o13iqEz+cXUjDZzfsFiWqfJ2oINDFv5m6tWQJfzbpiUfNfzV9yN
         XAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698241340; x=1698846140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xek/D1c/3ZtFYXMJxxDYFmlYYDLtkPgvYXa4SHLOo8w=;
        b=vw2wyibOcg3+v291154O9+kCW4BGPnfO1wJ3G5LiMRSBGcHNd9yAfwLsqW+bqgLjH/
         2rG3TqrzPY4kjYLwev0WgapMsRVKnRsJvyrY+F50118mO+QXb82NF9uHzphzRxxnqWtE
         sGsFLKYQcjPZ9zmacHfvtxRLJtQc8jmKcrKuLya8voSmfNDoI2jiNdAK6IslbG+ukHca
         4JGk1XduIu5KHEc3IRVQewaejHTgNHtpPwHBI36hR7WmFzrKCwnVquWblvf4PilclQ52
         yvck6poZvbX6QtK03P0k0H2oUI8SKx2WDMD28FJxytJ9Vd1GKTHa2ZIApn4xcVQ62Zpc
         S4Kw==
X-Gm-Message-State: AOJu0YztSzDa8NG1OWfCEfCVTSSiQzbbMYD+yDgg/C+k3lPJptp8EiZM
        nlaAhhXQlwLP7J6gABCeS7qUbNejS2Eu+SSJwio=
X-Google-Smtp-Source: AGHT+IFc5YkiNLcgpT8QYigQ5Nt8Xc4O1/4mLxIVz39cLajUukfrAkwjz6VEnI7fS0dLukPpD6CHFw==
X-Received: by 2002:adf:db48:0:b0:32d:9d80:4038 with SMTP id f8-20020adfdb48000000b0032d9d804038mr11438583wrj.49.1698241339709;
        Wed, 25 Oct 2023 06:42:19 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id a6-20020adfeec6000000b0032da8fb0d05sm12112029wrp.110.2023.10.25.06.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 06:42:19 -0700 (PDT)
Date:   Wed, 25 Oct 2023 16:42:15 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ksmbd: prevent some integer overflows
Message-ID: <a6aacc23-a24b-4f4e-af8e-30bf574c110c@kadam.mountain>
References: <205c4ec1-7c41-4f5d-8058-501fc1b5163c@moroto.mountain>
 <CAKYAXd_vhTswRUQMGXXMKOO4i_cuyZte28qDZ3AzfOKd76jdAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd_vhTswRUQMGXXMKOO4i_cuyZte28qDZ3AzfOKd76jdAQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 25, 2023 at 10:11:41PM +0900, Namjae Jeon wrote:
> > @@ -757,7 +756,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioctl(struct
> Hi Dan,
> 
> > ksmbd_session *sess, int handle
> >  	struct ksmbd_rpc_command *req;
> >  	struct ksmbd_rpc_command *resp;
> >
> > -	msg = ipc_msg_alloc(sizeof(struct ksmbd_rpc_command) + payload_sz + 1);
> > +	msg = ipc_msg_alloc(size_add(sizeof(struct ksmbd_rpc_command) + 1,
> > payload_sz));
> >  	if (!msg)
> >  		return NULL;
> There is a memcpy() below as follows.
>  memcpy(req->payload, payload, payload_sz);
> 
> Doesn't memcpy with payload_sz cause buffer overflow?
> Wouldn't it be better to handle integer overflows as an error?

In the original code, then the memcpy() is the issue I was concerned
about.  I don't think it can be easily used for privelege escalation but
it can definitly crash the system.

The danger over integer overflows is that you do some math and the size
becomes small and the allocation succeeds.  But then we do an memcpy()
with no math and the size is very large.  We're trying to memcpy() a
large thing into a small buffer and it overflows.

What size_add() does is that if there is an integer overflow then
instead of wrapping to a small number then it just gets stuck at
ULONG_MAX.  The allocation will fail.  The allocation will actually
fail pretty quickly but even if it didn't that's fine because we
optimize for the success case (and not for hackers).

The rules with size_add() are that you have to be careful with the
results.  You can't add use it for math again except through the
size_add/mul() helpers.  You also must always save the result to size_t
or unsigned long.

regards,
dan carpenter
