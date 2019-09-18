Return-Path: <SRS0=9D0L=XN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E81C7C4CEC4
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Sep 2019 06:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B058E20882
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Sep 2019 06:49:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ddt8MsME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfIRGtS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Sep 2019 02:49:18 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:35107 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfIRGtS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Sep 2019 02:49:18 -0400
Received: by mail-io1-f45.google.com with SMTP id q10so13695226iop.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 Sep 2019 23:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d1S2r4TSO4MpkEjLMzLAOQJwUwnnPclM0BYEpkUy4ao=;
        b=ddt8MsMEiomC15L0EiVjiuX3boRGGW7vC+GPeOYVtqxo2yvMri6D9GoUAEM8WWRdIn
         G/jNiviWdmkQfPDr934m5HhYG0wILaNdITu31pEEaSw67zYv/dDEyPbV9XJ4yJLwFiKX
         gYqRqUSoIu6RnuCMefS3VAcCX8HF7ngqVXPEfDxCOVNE+UCCdefxcCPwHqZb0bAFBdD4
         jpO0OXjIr5V2sp9cJKNFQDafsm4g+xMPE90Px3dYJwrA8aOt0xendKH0z7g/1Ctkg5Ak
         U01nmIYrYsgM1HT5WzZKWxEUhlSuvwxfhAOwrhIsPRFThd/CgrirCnzJzsk5C5GXPNx+
         Asrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d1S2r4TSO4MpkEjLMzLAOQJwUwnnPclM0BYEpkUy4ao=;
        b=jwcbUMn9g+kA9eC8znh4io/htcV9GxwNmAQDLPsAKAKaSwvrt3YdJ1B9bg/abm3mnq
         095HiUX3Xi7pNM6KPingXvj1R7I/4hDKWZJUYIy/a2feDLbl+7q0QAI2ewkC5xWxtBgJ
         WyBkVLcPRpoppgy80Isnrbl/E8y7Uh+/L61s5CIvx6+PITx58aK42KrPgPhnQba+2L9q
         TcFfKgxui/bAv9ojulSbJSgcQ8I+0HTZxh4wYpEbCPErsDGc7/+K5tsoghBHjIHnoMgD
         8kE1NnAvIqvWkMOYKkvErPYGyJovXMWQN649TlbdVPdIQy27ufua5WD3dTa2g+XViiQ/
         YpVg==
X-Gm-Message-State: APjAAAXpCY+6LY6funBPN+fy3e2bysuZsIPYX2h1sc0PnbtDquJmhv9p
        0RSCgYIk/M32MweMp3OzkziM0RX/CxPJZLhHVW4=
X-Google-Smtp-Source: APXvYqxojRAJpas1kFqFzJ9rirKFDesWcW34ugR+M9G3JHVJz+J7dsgDso9wok53viGRBOEr+W88rl65uPGI496wSrs=
X-Received: by 2002:a02:5dca:: with SMTP id w193mr3172973jaa.94.1568789356042;
 Tue, 17 Sep 2019 23:49:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
 <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
 <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com>
 <87pnkh7jh2.fsf@suse.com> <CAE78Er_ea5mtp-6VxyNPzCSDuPym7cXcD3=Udcpv=jGo80XhZg@mail.gmail.com>
 <CAKywueT2mr1i3Y6iNQOzXEc1CePMozfvoJUz=TJAmbnskdofhw@mail.gmail.com>
 <CAE78Er97k7O-GDGdMtp0qXtQ-q-1nS_d1AE6HHH+Kz6PV_G2uQ@mail.gmail.com> <CAE78Er_L5fY31JdVaSUgbd7uyXpMAb+81adcVFD3GBQfMeWX0g@mail.gmail.com>
In-Reply-To: <CAE78Er_L5fY31JdVaSUgbd7uyXpMAb+81adcVFD3GBQfMeWX0g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 18 Sep 2019 16:49:04 +1000
Message-ID: <CAN05THRrUB0T5Zho+HjbmTzp4X6-Sx+N+QqaV5A4SDHrkqKWTA@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     James Wettenhall <james.wettenhall@monash.edu>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 18, 2019 at 4:16 PM James Wettenhall
<james.wettenhall@monash.edu> wrote:
>
> Thanks Pavel,
>
> We've been running Kernel v5.2.14 over the past week (updated using
> Ukuu) and it seems to have improved the situation considerably.

Thank you for the feedback.
This is very good news.


>
> I assume that the "nohandlecache" mount option recommendation was just for v5.0.
>
> Cheers,
> James
