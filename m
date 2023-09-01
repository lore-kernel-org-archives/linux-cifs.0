Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F52DCA0FE6
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 16:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346169AbjIAQZf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345900AbjIAQZ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 12:25:26 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5CE10EF
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 09:25:23 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2bcc331f942so1898831fa.0
        for <linux-cifs@vger.kernel.org>; Fri, 01 Sep 2023 09:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693585521; x=1694190321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m62goFXXkk94xnOepiXE2pkyF2JGrNYDPimntGBsMJg=;
        b=cP9r5XzTyXViBhJGNvnwgPls0t4oVNv1OM+P022T/Bo5gN7zWqNhMY4vqeOyla1K+h
         UveYBg2NhD5cyigySGtBNa4ZNRQTzxFOQtZaHDmSzGgCl0bsoxxSFavK9ukeJGsFIoJO
         ltS5meTNEMvgO0Fy0+eSVYHW0xSnXt3w0ePFNtAWw1gL5QHXrNqhVlIlP584GhbV8AJK
         bc2Oa9artLUamxMqVSIJkbY8eul7Dl9S0erdFYS1NJ6He04tPtLv26URrtYvxg8KBnBZ
         370ybl2RiddDkgovj12MG0d+j/iQuYh0IFOgDGwgj23VHsjRAqPObLeo9wv34YVPk3eE
         OhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693585521; x=1694190321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m62goFXXkk94xnOepiXE2pkyF2JGrNYDPimntGBsMJg=;
        b=IUkJtDiUbDIe2oafn46ooJS07qMrJtCRaFf8QhHypqc9PaIVnviZESRHuhm2SQEq8w
         vKcDpopSFjIJeBchPgrA64b9ez2YoeHBS3mGgYa9DY6cqBzZe7PJpkF4RpVIwDyPTRKl
         6lw5YXw9AHZNlPyM9V46Ic4sLdHb5PrAD8PQgsdazvXfnOlBO5aK5o0HKOjZeyFYoMVN
         LQlcaKNzI7ZZTtRmyl4NBwLN4ptnZDy9ykEFqy8KpzC0TSiApBIjmpHrV9qQq7p0sLZ7
         wUcLUww5oOUbscZhebQv2EfoMnNFNmRI3SZ44PeMCujjZxelSGLvTuGx0JSPn+qYYGc6
         mG1g==
X-Gm-Message-State: AOJu0YzZ4o4bpQoC89slA9qIPTCOYJzTpAFFq/1rlWI/sU4u0QnUz2Ry
        A1e7sYuOfO4a2TBAssufTFP8DeKwmAZfPh6BaG+Z5NSxw0Q5MROi
X-Google-Smtp-Source: AGHT+IFEIUMS+9NQijc6NZcjmOjWFiaE7PNMLCJUGPFvCbGmVTljTNIXvTXLEAKDA5xSSQzCPvR+HwuJHSN+jH5luQs=
X-Received: by 2002:a2e:b80a:0:b0:2bb:8bf1:7472 with SMTP id
 u10-20020a2eb80a000000b002bb8bf17472mr2149789ljo.12.1693585521131; Fri, 01
 Sep 2023 09:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221116031136.3967579-1-zhangxiaoxu5@huawei.com>
 <20221116031136.3967579-3-zhangxiaoxu5@huawei.com> <ca2f166ed7f54e22d07b07c4b43b98a6.pc@manguebit.com>
In-Reply-To: <ca2f166ed7f54e22d07b07c4b43b98a6.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 1 Sep 2023 11:25:10 -0500
Message-ID: <CAH2r5msd3JzDGR1pCCQFb4rP9dUEOSw5YxQj3o9OfNFDVk5mpA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] cifs: Move the in_send statistic to __smb_send_rqst()
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

That patch was already been merged last year

commit d0dc41119905f740e8d5594adce277f7c0de8c92
Author: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Date:   Wed Nov 16 11:11:36 2022 +0800

    cifs: Move the in_send statistic to __smb_send_rqst()

    When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
    in_send statistic was lost.

    Let's move the in_send statistic to the send function to avoid
    this scenario.

    Fixes: 7ee1af765dfa ("[CIFS]")
    Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

On Fri, Sep 1, 2023 at 10:25=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Hi Steve,
>
> Zhang Xiaoxu <zhangxiaoxu5@huawei.com> writes:
>
> > When send SMB_COM_NT_CANCEL and RFC1002_SESSION_REQUEST, the
> > in_send statistic was lost.
> >
> > Let's move the in_send statistic to the send function to avoid
> > this scenario.
> >
> > Fixes: 7ee1af765dfa ("[CIFS]")
> > Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> > ---
> >  fs/cifs/transport.c | 21 +++++++++------------
> >  1 file changed, 9 insertions(+), 12 deletions(-)
>
> Could you please pick this up?
>
> Thanks.



--=20
Thanks,

Steve
