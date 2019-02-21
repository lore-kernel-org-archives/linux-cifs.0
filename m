Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B891C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 20:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 680342080F
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 20:15:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hQDQYLK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfBUUPY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 15:15:24 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45679 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfBUUPX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Feb 2019 15:15:23 -0500
Received: by mail-lf1-f68.google.com with SMTP id h10so21113601lfc.12
        for <linux-cifs@vger.kernel.org>; Thu, 21 Feb 2019 12:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rUr1LRSI5NKMdGBA1Z4QHumL2fgKu4Ld6aM/v67P2KU=;
        b=hQDQYLK5Fa7mTSX5FcORtutjZt90v6TRoSaEIzXx0sspyOSLDk7v8Q2/AUK7cFI0+8
         anhjruaBWC3u2DxGkfhIBx2CorgugXl26lH1KU12cpwryV8fAchK4ejswvnyf2ajzbBn
         8u9ck+K1Mv1gUk/XgG7BPDj0A5x9xgyev86DJPqond8ev710/p3sB4WjqcO0if4m7fcj
         uiTs6f0td3q96FwLxo+NI0NqpheIyMLozszf6lq7UvnOu5fY8pgXTwWSziqX9VGT8En0
         zistAoj0kwRTw36OunJYQJ4G7LwfU2RtmxtoVFirzI25Tva1Nz826dGbRg4QaV8/Y0s6
         a+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rUr1LRSI5NKMdGBA1Z4QHumL2fgKu4Ld6aM/v67P2KU=;
        b=dGzzmeiDugefcDOjclvofQO1RMglznyLOojwC3F7J7TRMWoOmId91JCw2NaehLclt/
         Gy9aHoNBDOmzynHgXDTPoRQXcyGiSfMWZCiLkTY5AdKH0ReRGur2ThvNLd7K72M4o3zA
         ZCMffR91Vd7GOxcxVzW42KxmSNjdUtT8O+XXqIpTPt1bb1uX9voinw2IYmb2lfnXuQov
         06OGxg5N17pyvPIUPTBHxWhKFQMZ5gSSShcbJ7JK94FpOppoesM1FKwCQUyjglgd3kiy
         4xZ7Rsxc0B0PJMc49NVeLq6hC+M/eB7smbf6qSCIEUYRWieno7Qo9ZAjMidZX0XufG9X
         jtJg==
X-Gm-Message-State: AHQUAuZBPdRfQY4uIMFyTzImJT4EZssHXQxUFMK21r/NFm1jbSd3WTmr
        o2pkIeUqmcLrmdsNXzSjgchrouNpYL8mKXOjwg==
X-Google-Smtp-Source: AHgI3IbD2S9UIutkh6pXLGxJY2Jp2hzKnvnjNcjyD9E8bl39YspZU+dwI0onQ0cfsTvH3GqT+9uBTtqF690mMAJPqoM=
X-Received: by 2002:a19:2242:: with SMTP id i63mr171759lfi.39.1550780121459;
 Thu, 21 Feb 2019 12:15:21 -0800 (PST)
MIME-Version: 1.0
References: <1550705753-15443-1-git-send-email-pshilov@microsoft.com>
 <CAN05THTJLY4iBOHSC4h7DEgCXvmNbKr6WDqMQwZEBcpL3AhSsA@mail.gmail.com> <CAKywueSHtEdXb_YcvFNO5BRggWRxNCtgzUsXmc6TJfVgm633=Q@mail.gmail.com>
In-Reply-To: <CAKywueSHtEdXb_YcvFNO5BRggWRxNCtgzUsXmc6TJfVgm633=Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 21 Feb 2019 12:15:10 -0800
Message-ID: <CAKywueSCikggX4YsOsELsK5j7L8DBmzBbGHGk9e6zs0DZUpMVw@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Reset current mid to next value in sequence on send failures
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 21 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 12:04, Pavel=
 Shilovsky <piastryyy@gmail.com>:
>
> =D1=81=D1=80, 20 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 16:06, ron=
nie sahlberg <ronniesahlberg@gmail.com>:
> >
> > Awesome!
> >
> > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >
>
> Thanks for the review. I posted the V2 today and changed the title to
> more self-explanatory one:
>
> [PATCH v2] CIFS: Do not skip SMB2 message IDs on send failures

Changes since V1:
- respect MTU requests in setup_sync_request (this is for the future,
we don't do MTU for sync requests now);
- properly revert MID for SMB 2.0 or ECHO command failures (since they
have CreditCharge as 0).

--
Best regards,
Pavel Shilovsky
