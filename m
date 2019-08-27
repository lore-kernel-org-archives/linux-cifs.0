Return-Path: <SRS0=wCsU=WX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF97C3A5A3
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 15:46:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FB720656
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Aug 2019 15:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUZyKDla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbfH0Pqx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Aug 2019 11:46:53 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33713 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfH0Pqx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Aug 2019 11:46:53 -0400
Received: by mail-io1-f66.google.com with SMTP id z3so47467623iog.0;
        Tue, 27 Aug 2019 08:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jn4Zk1YEfNuZWrJiBEF7aJIJ61Ws8t1i4se+p36owVI=;
        b=LUZyKDlayR4pWIMzcszOZAyIVoE7X18xbsQ+g2Mbjg54iDvxggsn/nScfmZH84Ig5k
         OMoAX46BmbHtN9Aw/LXurfgimGCtFUvUAfTJnTVUpWf2s6lK7kMdmW1Yzy2r/6xqnfbf
         lNle6zklHGr76QK3r4/L87XCwM9nSB0T+fn7BUMzNPleWNE0P2B0WxmpNvfpFoOZXw5+
         Qr3sqimdNjt1vtd0guKpiZynJu1vn8tnVOZf21KpzaDbLdAkhP6mJt7sSr7dE4gjk8Xu
         D+4ADz5j8uvQekaMK+q758BxZFueKmLLXQ6bW/BiMd1MMty2G0UH7fJ1Tziir3xFGEml
         9NVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jn4Zk1YEfNuZWrJiBEF7aJIJ61Ws8t1i4se+p36owVI=;
        b=W1wKnkgAH4kb+PNxjKD6koZRmtJx812ObL2nT0nAs9QzACxPUhAJ7uMwFtq3Rqb5gX
         7mbfgMbswAczhzIY8Xm9kwonabY7GzA5JjHabgIaqmkwbWyNW4vriy/AmMpcolQHbK8h
         GDyQOZlDom3AjjzOSh18ui+8zn83bUvXnENFBuGchNNxuyd0ZgVi08BJMTtxvUDWWueO
         dmR3CjtN9v12Qg9t1KOQUkbQUCHhGVuau7K5ukYyrg3ryKPFfegqpJw7qd1Dx/osi3mW
         /pJ1w6+iUpKil7Xi8pHSbcOQGuP6K24G3/qk+MxchrcMbIfDEpRJKGWEi4BDaGY0px7n
         YxrQ==
X-Gm-Message-State: APjAAAXmqrqG3HE9bVkrHeJljeCJ+KcvfpOpmZpgMH+vwq8NCXUDtq0u
        MaRbyLFNNzFLCaQwvMN1n+kP3RFhKa+6YW9SGBM=
X-Google-Smtp-Source: APXvYqx79sSUk/Xxv5sBSR6GSI6Ao9kCciCfu5cTEkuGnr/Oly4C7LhXQyHQ+p4iI6jh4z0WFt2dk87f7/twPzLOUfY=
X-Received: by 2002:a02:ce49:: with SMTP id y9mr24372245jar.63.1566920812306;
 Tue, 27 Aug 2019 08:46:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190827105917.GA23038@mwanda>
In-Reply-To: <20190827105917.GA23038@mwanda>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 27 Aug 2019 10:46:41 -0500
Message-ID: <CAH2r5mtNVwt-Dp8YVvbVHbYEpUAG_bw=aqJqWdB1Wb-hY1e=NQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Use kzfree() to zero out the password
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Aug 27, 2019 at 6:02 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> It's safer to zero out the password so that it can never be disclosed.
>
> Fixes: 0c219f5799c7 ("cifs: set domainName when a domain-key is used in multiuser")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/cifs/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index e6cc5c4b0f19..642bbb5bee3a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3101,7 +3101,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
>                         rc = -ENOMEM;
>                         kfree(vol->username);
>                         vol->username = NULL;
> -                       kfree(vol->password);
> +                       kzfree(vol->password);
>                         vol->password = NULL;
>                         goto out_key_put;
>                 }
> --
> 2.20.1
>


-- 
Thanks,

Steve
