Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2EFC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 20 May 2022 06:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345698AbiETGBm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 May 2022 02:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345695AbiETGBl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 May 2022 02:01:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2975255A9
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 23:01:39 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id s28so9887422wrb.7
        for <linux-cifs@vger.kernel.org>; Thu, 19 May 2022 23:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9vKvj5ixse2ZnZgaoUH8EcMy54dSLmjq7AkgvKEB5JU=;
        b=ZaMgWAY+DGgeWycgksilKguNNHECWPtJSg+Nqc4zqcbkn3jpDlUFNYTDEPNzNB/pZM
         1GTru5aVHTutpBAgWmw4MkHsUDmtvX70v46Bne1NZ79iGLMJjzCz/83/eBRAZWen6sEl
         /MjTqIglcdamg68uiHiz3TghklQGQ9of549VVnbfBXcq8ybK7lhJqoj7gjEL78IijBEr
         IUF9J/KFMlIK/D9CS57hFVig9B2SKwBeyhnTLrModPhxSZh/1jTU2f3lCy60zRhgvR0b
         8UTBpwX4xhrg9dL+MkIotzffadinelSY2ycD5j2l8C40LheZ57ARN1y7kDVdYemOZemq
         XQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9vKvj5ixse2ZnZgaoUH8EcMy54dSLmjq7AkgvKEB5JU=;
        b=U+Yh8Xyri4ggHQuyKFAK9PyxrFwWsu5m5pcNY/+FgZX13ZXr3j8SPxhwvX6mQFvNnp
         MZP4awJNnqsMa0TZl1tq153ztckCdxGaV4kgnH17MX40g1iwtSyVLbQhvGH4JjW00Dg/
         NB7SfUbAMxnKK9FW5YHzkC27EzEulNMOKAOP7NrVL7I/VoyCwhDLVKbFothQXsLdaZbw
         81+d1j7RaFVKbuFV4w/m/XUyY35NAUOJkt0koPMYu38MmRaplFBn1qbm84/jRLgDDzK8
         rVVJe+hAOyBU643U7WJuoCmB5UL2OVrZpScJPzqHcQp9+TQslwadO5QdeAH2jo5/iHjj
         ciLQ==
X-Gm-Message-State: AOAM532Nnoqzj7avRrA9655H6IcfVB23ksVjuO4satMxzz+OriJxRTGM
        FHpwzY6rYDInUMb5Ioz7qjCimg/YwFjBNn2uZjQ=
X-Google-Smtp-Source: ABdhPJyKtqaC7sB5sj6QyLnAGS42X4xL0qPjrgJR0F6gocFIttNrJ5D1/cqDd5p+QdYepbJnSP4a2rPirbwK8Yq35qs=
X-Received: by 2002:a5d:4b92:0:b0:20e:5d73:7546 with SMTP id
 b18-20020a5d4b92000000b0020e5d737546mr7066615wrt.322.1653026498136; Thu, 19
 May 2022 23:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
In-Reply-To: <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Fri, 20 May 2022 15:01:27 +0900
Message-ID: <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
Subject: Re: RDMA (smbdirect) testing
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Steve,

Please refer to the page below to configure soft-ROCE:
https://support.mellanox.com/s/article/howto-configure-soft-roce

These kernel configs have to be turned on:
CONFIG_CIFS_SMB_DIRECT
CONFIG_SMB_SERVER
CONFIG_SMB_SERVER_SMBDIRECT

And you can mount cifs with SMB-direct:
mount -t cifs -o rdma,... //<IP address of ethernet interface coupled
with soft-ROCE>/<share> ...


2022=EB=85=84 5=EC=9B=94 20=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 8:06, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-05-20 5:41 GMT+09:00, Steve French <smfrench@gmail.com>:
> Hi Steve,
> > Namjae and Hyeoncheol,
> > Have you had any luck setting up virtual RDMA devices for testing ksmbd
> > RDMA?
> You seem to be asking about soft-ROCE(or soft-iWARP). Hyunchul had
> been testing RDMA
>  of ksmbd with it before.
> Hyunchul, please explain how to set-up it.
>
> Thanks!
> >
> > (similar to "/usr/sbin/rdma link add siw0 type siw netdev etho" then
> > mount with "rdma" mount option)
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



--=20
Thanks,
Hyunchul
