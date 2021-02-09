Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E9DC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 20:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F248264E6B
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 20:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbhBIUzq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 15:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbhBIUlm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 15:41:42 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C40C0698C3
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 12:08:02 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id y18so25515450edw.13
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 12:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tc8WDG0ciUkBSgA1XzvZaxmv0vpt+IyIJse7qt3PmL8=;
        b=WRIRk/yfvCbyT5exqadvkEUvvSFQwvoKn4RI0/QR2C8askLLHY1xkchQ2ZkdygDAaB
         pJc6NgMasiRy81IHvjIkokix5MARr6jyBMBA/OEo+jDxOvHSvi83LyV69wEGdYsjgA7W
         T+YdGRMhZv+xO8XwdazD7Q1um3x+pLDWPt7jK2kVgHvUNCwv4XVCu8XLADMvupW7yGrL
         FgspqzGkTI56kM0HEQe8z+9knf23akhFLux7/jFc3QePd0k13tmAJEHSbJ1cuwwaGBh3
         VcVrZSoL/mqPSzZbmLSFNGAuik6UAXSb3z7eoReWIGkokKqAweVpJ6qy+OaYirQznjL8
         ULxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tc8WDG0ciUkBSgA1XzvZaxmv0vpt+IyIJse7qt3PmL8=;
        b=j6NJouAG1H+fw0w3DsTm0ywxLIrDpp1SVrimfI/F5tga+uue98BbmJmBsBA6Iwx4gl
         +YRSnJzzEVhmzRDFR9OsCPrRIfHBJB0pof9QJC+ulEE65ZSUe6ooTxH1GdYLTdv2ycBl
         39oYL+IFCZweAmbGBxQIFKFdW8cNvTtmcMzEWcc+HKnKOLovQtCTws3mW4UjFIL31ZUk
         qihW/tT++mWy3myKNdRKijdIV2JBDulGqavJirmWTT76YWwxmpFyKEMMA0AeOR3VCGZg
         Md0MuYEx+FlanpJK9j8r1cJk1Bc3HsvOFMFUA1QYXzu3XGsWblNcSs2xlEuconw+fnnF
         vs+Q==
X-Gm-Message-State: AOAM532JgpuJVjQqgU4jtQ2IClHFqXBh4vqSd2N5KWJqw5XjDrQDalhf
        UXAEVE7BAYtA8E9m8KYENCDN+T3vdlO93vqCMQ==
X-Google-Smtp-Source: ABdhPJxafSlIGc7wijYNtJ4VNTHHQr5OT9tDo69R6tg0gShRAUG/RRXuBCxaxXPxDW4zcOzb1aEi9H9HA6KkUaPLWGM=
X-Received: by 2002:a05:6402:1cc1:: with SMTP id ds1mr10187853edb.10.1612901280920;
 Tue, 09 Feb 2021 12:08:00 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com> <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
 <87blctmqo0.fsf@suse.com> <CAKywueRd1u_7F6qRkSRCtg5exPeNBSXANUiFTrUfcigJGMeP3Q@mail.gmail.com>
 <CAH2r5msowQaXTi+3K0UeyFdVVzHz_LLk-Cdr5XBANYz6SmqymQ@mail.gmail.com>
In-Reply-To: <CAH2r5msowQaXTi+3K0UeyFdVVzHz_LLk-Cdr5XBANYz6SmqymQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 9 Feb 2021 12:07:49 -0800
Message-ID: <CAKywueTxA6URL-2YEkuJAr1=XXPtA1PTzqwioFR6k47Y2Rri-A@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, missed them in the first place. Then I would suggest to list them
in order to avoid confusion.
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 9 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 12:06, Steve =
French <smfrench@gmail.com>:
>
> On Tue, Feb 9, 2021 at 1:58 PM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
> >
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index 50fcb65920e8..1a1f9f4ae80a 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -1704,7 +1704,8 @@ static inline bool is_retryable_error(int error)
> >  #define   CIFS_ECHO_OP      0x080    /* echo request */
> >  #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
> >  #define   CIFS_NEG_OP      0x0200    /* negotiate request */
> > -#define   CIFS_OP_MASK     0x0380    /* mask request type */
> > +#define   CIFS_SESS_OP     0x2000    /* session setup request */
> > +#define   CIFS_OP_MASK     0x2380    /* mask request type */
> >
> > Why skipping 0x400, 0x800 and 0x1000 flags?
>
> They were already reserved.  See cifsglob.h
>
> #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
> #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sendin=
g */
> #define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
>
>
>
> --
> Thanks,
>
> Steve
