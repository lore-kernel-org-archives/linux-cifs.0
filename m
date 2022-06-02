Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9CC5C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 04:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiFBEtR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Jun 2022 00:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiFBEtQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Jun 2022 00:49:16 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDF82838C4
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 21:49:15 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id k19so4854737wrd.8
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 21:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ImzeGOjmlS56yZozKHVae+J8y7xLXmmIu+c2HjehkgA=;
        b=kgGlxZ0Ymu43SE3/ua8/vMf9+brBYJ6FOmhbu31Po0ogCRa8Hw1EQ5wWwLOrgLVEOv
         IG2bYMtumsS49vFxLLZ2vHy1qbMj7DRlQ7Tf0jBORkivBbBD0223O/QisYoPDLlSw+OV
         8Y3D5mj3KYl6YD0S7l2tlfsIRX070UbYjs0YWLmqBeZFvQ0uFUrx/7hDQtSejjFc00yP
         aoKlBUVyhhpKXayztJHiAXW25k4hnOpuEzCxCd2V/R3Ft4Eq39FO4A0RaNwnBdVnGHrQ
         mF9cVqrTU3BghkS7yxsxV11p7g9xgZjOQMMhwBbF9Q8KioIDm90Y7ZvCtKHDwVKOxret
         1cfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ImzeGOjmlS56yZozKHVae+J8y7xLXmmIu+c2HjehkgA=;
        b=L6zVI7QpzNlyHDvSbTiYXgUNG/wpqnJc/UpziRPDPzSKI/TIFsOgws8nKOVSBLI3e+
         o9TV01BlfKYImO+PAdASZSArLtLd1sQGP3DezCiEP4SQj/r/srzPwKkRNqHE4HVX9XgW
         doigGcRAXOiLMPRASDpbVcTNgXFwhhb77plAftx+vvla2AHiYd4u80imlP2W7f1wa1/y
         eIrdWL1I6o8PVd7XdnMJbxKY2LMf3itQqsyrdKmZirbl80UaL89jmhUR8D9CanbJBq2E
         E306LSvdZ+vkQjUq4Qle3mwq3aUWSrD3OUUwJ96WMBP3T4kpKdqjBOa674+hpuujMhy1
         trpw==
X-Gm-Message-State: AOAM533ysH4/W61yPyHOREZ8Aq7L5FYPKO23sbi+V0aZaL/ggaQSxUVc
        9bOsvoG9IdanFa/C0I0uQsdtzldD+T+nZ72wJTI=
X-Google-Smtp-Source: ABdhPJwO7QmEu9MWLJ+KQA2WPgVYAuO4GoVe3w4eyGD4iO1Kl090mpGTAqod4Cvgo83lbKctycEx6vEQ8YypuBTfAPg=
X-Received: by 2002:a5d:6da7:0:b0:20f:eb44:f3c3 with SMTP id
 u7-20020a5d6da7000000b0020feb44f3c3mr1947825wrs.621.1654145353812; Wed, 01
 Jun 2022 21:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220602011313.56110-1-linkinjeon@kernel.org>
In-Reply-To: <20220602011313.56110-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Thu, 2 Jun 2022 13:49:02 +0900
Message-ID: <CANFS6bbYeNP1WWyVGJXc5SBoyZ4Gx=F1Rx3XZZt_erkW0tr8RQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: use SOCK_NONBLOCK type for kernel_accept()
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 6=EC=9B=94 2=EC=9D=BC (=EB=AA=A9) =EC=98=A4=EC=A0=84 10:13, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> I found that normally it is O_NONBLOCK but there are different value
> for some arch.
>
> /include/linux/net.h:
> #ifndef SOCK_NONBLOCK
> #define SOCK_NONBLOCK   O_NONBLOCK
> #endif
>
> /arch/alpha/include/asm/socket.h:
> #define SOCK_NONBLOCK   0x40000000
>
> Use SOCK_NONBLOCK instead of O_NONBLOCK for kernel_accept().
>
> Suggested-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/transport_tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
> index 8fef9de787d3..143bba4e4db8 100644
> --- a/fs/ksmbd/transport_tcp.c
> +++ b/fs/ksmbd/transport_tcp.c
> @@ -230,7 +230,7 @@ static int ksmbd_kthread_fn(void *p)
>                         break;
>                 }
>                 ret =3D kernel_accept(iface->ksmbd_socket, &client_sk,
> -                                   O_NONBLOCK);
> +                                   SOCK_NONBLOCK);
>                 mutex_unlock(&iface->sock_release_lock);
>                 if (ret) {
>                         if (ret =3D=3D -EAGAIN)
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
