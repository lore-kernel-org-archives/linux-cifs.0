Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5271DEB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 06:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjFZGdY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjFZGdV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 02:33:21 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4A7E4C
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 23:33:20 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f76a0a19d4so3696757e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 25 Jun 2023 23:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687761199; x=1690353199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBlnCpj0wEoln3oQAmSpSbo06fIEg/xWoX+5YCVl1Sg=;
        b=iNv4ndXW7yA34vzKBgb9LU5Cy+ZGxPpJT7NbQt518Fccw428PRAAgZ3mWNs87LxH9K
         n+fgeetGUmr35qk2+Kia9b5/dFcQ+q/JJ2imc0FHXBv0FNQavEmhuuFmsrfdio3hNeoc
         S29Knd8r1boI+cQcd6f6Em3YiQkK4tI1lcEp54KEB5XcGA+mH9ELxEHTf/+hcrbtfA4k
         AzfCJ2659ZVZy4BX/hfnlZ53Gy9mtlOWbWJlmBSPUHJQwL0KUtlXQce6bt2wjMug6ShN
         bthQfcu2vMRbXe8m3N577igrfKGhKRGVCzxERqLAr5Ch2oGegAzGwYSDyhJwgWvbANbw
         B0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687761199; x=1690353199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lBlnCpj0wEoln3oQAmSpSbo06fIEg/xWoX+5YCVl1Sg=;
        b=iJVBI9yJSXDix8Lq3xxhydFEEDt5Bjldm0GoqtYVEI0CoXQS2SGYqmavO2LiEMur3i
         IAnKs7Hvj44Ez1mjMFgKxo8hC4Foc5ztpZDgxQTm7aXnG5Zq6CZaU/ThsmC12aspX7GD
         h0fqpM+RYArPxAE1ijPXgEeq2gfFGiVzGXWuWL9aAAVC+NijiHT8wkPbjSGim9m0Fvph
         o+ArHZnXwHQUJvjOAaiLNBeddliX+K+V9eAAS7BgUGc18Mk4DbtiWQfcdgHz7crjbF8/
         BdwSMo2rZ9Netn2W145D+Z0JDJU1/XpKtnMHsw3X8j0QvpadOgxEGRrmvo1ril3VoLN4
         IpQg==
X-Gm-Message-State: AC+VfDxRxgjjIYlmaxhslXQBVsqS8qxBErrxgiTRPt/Dpq6kaCNh0E0h
        iigO8JAMjFax17g87YtfXeF4FZmqT316xXAc7Kg=
X-Google-Smtp-Source: ACHHUZ49JRRYJNIO5OKdDtKfwTXiopBWxYvGboYLk0xfs/jjWTUmTV487jfOUEzxy62cJg1a6MrRbLK8m/0rzpb/yxo=
X-Received: by 2002:a05:6512:32b0:b0:4f8:5f19:4b4e with SMTP id
 q16-20020a05651232b000b004f85f194b4emr14355592lfe.51.1687761198587; Sun, 25
 Jun 2023 23:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230609174659.60327-1-sprasad@microsoft.com> <20230609174659.60327-3-sprasad@microsoft.com>
 <CAH2r5mtKozDLH+y-6ASL1mb_v5g9=TxjekRGO=L_AxJjfhrKnQ@mail.gmail.com>
 <CANT5p=pa39qfZxu0jDp01L1AtvQTqoGdk1cB3jwq-rGOY-2+hg@mail.gmail.com> <9a9b5fc2-8905-7169-90d9-d0ee3454f5a6@talpey.com>
In-Reply-To: <9a9b5fc2-8905-7169-90d9-d0ee3454f5a6@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 26 Jun 2023 12:03:06 +0530
Message-ID: <CANT5p=p62mGd8uwgNEHeAa9pEnC0TcJSx-pXDCwzFSCaX16O5g@mail.gmail.com>
Subject: Re: [PATCH 3/6] cifs: add a warning when the in-flight count goes negative
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jun 23, 2023 at 9:52=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 6/11/2023 4:01 AM, Shyam Prasad N wrote:
> > On Sun, Jun 11, 2023 at 1:19=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
> >>
> >> should this be a warn once? Could it get very noisy?
> >>
> >> On Fri, Jun 9, 2023 at 12:47=E2=80=AFPM Shyam Prasad N <nspmangalore@g=
mail.com> wrote:
> >>>
> >>> We've seen the in-flight count go into negative with some
> >>> internal stress testing in Microsoft.
> >>>
> >>> Adding a WARN when this happens, in hope of understanding
> >>> why this happens when it happens.
> >>>
> >>> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >>> ---
> >>>   fs/smb/client/smb2ops.c | 1 +
> >>>   1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> >>> index 6e3be58cfe49..43162915e03c 100644
> >>> --- a/fs/smb/client/smb2ops.c
> >>> +++ b/fs/smb/client/smb2ops.c
> >>> @@ -91,6 +91,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
> >>>                                              server->conn_id, server-=
>hostname, *val,
> >>>                                              add, server->in_flight);
> >>>          }
> >>> +       WARN_ON(server->in_flight =3D=3D 0);
> >>>          server->in_flight--;
> >>>          if (server->in_flight =3D=3D 0 &&
> >>>             ((optype & CIFS_OP_MASK) !=3D CIFS_NEG_OP) &&
> >>> --
> >>> 2.34.1
> >>>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> > Makes sense. We can have a warn once.
>
> Which sounds great, but isn't this connection basically toast?
> It's not super helpful to just whine. Why not clamp it at zero?
>
> Tom.

So there's no "legal" way that this count can go negative.
If it has, that's definitely because there's a bug. The WARN will
hopefully help us catch and fix the bug.
We could also have a clamp at 0. I'll send an updated patch.

--=20
Regards,
Shyam
