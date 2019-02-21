Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B34C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 21:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF84B20836
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 21:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbZsOO1+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfBUVyp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 16:54:45 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36005 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfBUVyp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 16:54:45 -0500
Received: by mail-pf1-f194.google.com with SMTP id n22so77300pfa.3
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 13:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vWNVAeHQehJXBAQnhcwDGf80+3se5M+YyQnOz4hvPWg=;
        b=WbZsOO1+3eaMGTpdZGzJf12kQyUh8Jr1rakrruoU46YVgZ0BucQjOTeMt93y4T4ObV
         PYMP+g41uL3SXYPvP/sX0jFyMwBNHIqtL1IJaYFSsSkL0DcutHv9i6ZBq2lc9gpQBso4
         Fy2on+wiyThM9qgBDNlJh5skNYqufi9rfpTGVNgBG9XV8QMfROSKz84qsA+KfQzTDbqs
         l6IgQgKZdpppllvhEBbbOe15wz71AdMLBRd4Ut0UEEqO3DFXYSMLAyTJE3Ce+aSOL5nB
         CId1XmI1zAWxwEHUPtPExvUB1fSfVeKMgmntTPhQAj3p/x6G0d21+bfj+Evl+xnHMnQs
         o1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vWNVAeHQehJXBAQnhcwDGf80+3se5M+YyQnOz4hvPWg=;
        b=ST5xSARf2mdqCpKAPAFbEdMrljvWCBwFyr5xgnbwlVo9HUNBEC6f+pOZ0ivyCr2xoJ
         fMMTP3uH17kQLvxpX85xplX0iNEf/6q7xAvK/MjHa3RMe6/lb51POGdToUbUA/8cHa73
         XgWiY230yHDhBXqOjoRs2hwHRXUSnOAoXEsSBDNQqEDKY6WwUaVH7tMm9ubiXqq5bTpi
         XArWQJYPDyOy6ghVwbUaj6Gfb4mvuBOeznumRCdzG0E3DAFeoNocCXIWJsJapi1rrt03
         Lld3ir3hfnYsBYsK1Og88qtO72QwQjNYhdD3vFjUO9s20gCHYZAXzBWv/oXuQATsUOpv
         mdyQ==
X-Gm-Message-State: AHQUAuaNMLnbhliZMA6wDJK+uSiY1IBWxMaqe3znDKMjVsPQ9oUrYLne
        /7+EHCi+TQ3rryJUlyN3KXWQuKRM3l1yb2Qtl+n8Sw==
X-Google-Smtp-Source: AHgI3IYgqgv1l15++caoYqHPiDyZUn1pShmLAKACc3IgVOV7ovywHH0Ov5GOp9K9Gash2LXyv/OPlR0VjgC7mCmKTxk=
X-Received: by 2002:a65:6684:: with SMTP id b4mr656346pgw.55.1550786084259;
 Thu, 21 Feb 2019 13:54:44 -0800 (PST)
MIME-Version: 1.0
References: <1550705753-15443-1-git-send-email-pshilov@microsoft.com>
 <CAN05THTJLY4iBOHSC4h7DEgCXvmNbKr6WDqMQwZEBcpL3AhSsA@mail.gmail.com>
 <CAKywueSHtEdXb_YcvFNO5BRggWRxNCtgzUsXmc6TJfVgm633=Q@mail.gmail.com> <CAKywueSCikggX4YsOsELsK5j7L8DBmzBbGHGk9e6zs0DZUpMVw@mail.gmail.com>
In-Reply-To: <CAKywueSCikggX4YsOsELsK5j7L8DBmzBbGHGk9e6zs0DZUpMVw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Feb 2019 15:54:33 -0600
Message-ID: <CAH2r5mvoTGaLY7Ua7DSz8vBTUoFWS2PVT-r_Cjfm94VW5terTQ@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Reset current mid to next value in sequence on send failures
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged into cifs-2.6.git for-next


On Thu, Feb 21, 2019 at 2:15 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=87=D1=82, 21 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 12:04, Pav=
el Shilovsky <piastryyy@gmail.com>:
> >
> > =D1=81=D1=80, 20 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 16:06, r=
onnie sahlberg <ronniesahlberg@gmail.com>:
> > >
> > > Awesome!
> > >
> > > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > >
> >
> > Thanks for the review. I posted the V2 today and changed the title to
> > more self-explanatory one:
> >
> > [PATCH v2] CIFS: Do not skip SMB2 message IDs on send failures
>
> Changes since V1:
> - respect MTU requests in setup_sync_request (this is for the future,
> we don't do MTU for sync requests now);
> - properly revert MID for SMB 2.0 or ECHO command failures (since they
> have CreditCharge as 0).
>
> --
> Best regards,
> Pavel Shilovsky



--
Thanks,

Steve
