Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9FFC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 05:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E261C64DE1
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Feb 2021 05:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhBJFsN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Feb 2021 00:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbhBJFsM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Feb 2021 00:48:12 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77076C061574
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 21:47:32 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id y128so837694ybf.10
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 21:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TtI3FtkexQqpy83umNRCLrI8GvDpyGeyaweccnG7kYk=;
        b=e4KJC/hhFCQGAlf+fK7UznhSqrNTpq3BbkuQiDLI/7iutXDsU4cedYc1Ipq5wp5mmB
         y8hvWa4ULezA3ZOZ10UHnrNId0WWSSxDKYqCzdaavWE5xzXkkiO8K+VEABsw2Fcc3SaL
         u9k+tbesLsXHMOVZYYlrMBRKc7NJadzbv0STUC3WRMXPbT/NFANLMnaKFI407KGsbPsn
         GiSYUdR4hzJh9/2eZ3EPFYx/bZIN9yML64eIMRMKCt62nIpJ1Cbldt10wP5XP3jp/L5k
         muSkcHl6mPvVADA6js/uqIPZPdVk+foSBXLqyRR25eM7IEcd6gnTTvpyLRURXlC/TB8L
         BQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TtI3FtkexQqpy83umNRCLrI8GvDpyGeyaweccnG7kYk=;
        b=DyfPsOa5g6jThVv5w7JjrcFZ4yfeQOk3g4tNmx8mc7rq91HNyz8LZCZGK05wWTNvoJ
         49p0jnjNTBsLgSrEhnfTnYBh3rU3F4U2Q81EeZqwYephHpNJsiOpd0MLVXFLK7OIVJTz
         yFVPxkIzaoP/CJj/VAiAXZ8TYr3Ii1SdHCdWyDaSU+x/TaB2NMt1aJRFpbcjeDLNu3j3
         1DxY+g8zuPMlK0Lqz++aqZra4iK8rQHpRE94l/pFZB71Y69xKSHKzS3sVK4eDHJwG3Vd
         tbcFmdklbQm7RZdC97xdzYfWSRVL7Q34LLqn5wg2CWAXUiz1hmnr5LM8AwY9t92W+RZe
         v0Sw==
X-Gm-Message-State: AOAM532nw76dFFZHhaNJNj8ZQvtOYEHnbgJUa8Wzkj6vFrOE1ieSTww6
        imgQJxaKoY/w4h/5sU51A4VXKOcA13MLBHouZzQ=
X-Google-Smtp-Source: ABdhPJwZ+kamMH9FI1/69jxkVe8uHXsb7DTAEehnpjX3fvW9S4HnaLJ9XCNjGCXpx+f2BTIjxeDUeR5HrO8uL+HQG8c=
X-Received: by 2002:a25:442:: with SMTP id 63mr2005709ybe.131.1612936051708;
 Tue, 09 Feb 2021 21:47:31 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com> <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
 <87blctmqo0.fsf@suse.com> <CAKywueRd1u_7F6qRkSRCtg5exPeNBSXANUiFTrUfcigJGMeP3Q@mail.gmail.com>
 <CAH2r5msowQaXTi+3K0UeyFdVVzHz_LLk-Cdr5XBANYz6SmqymQ@mail.gmail.com> <CAKywueTxA6URL-2YEkuJAr1=XXPtA1PTzqwioFR6k47Y2Rri-A@mail.gmail.com>
In-Reply-To: <CAKywueTxA6URL-2YEkuJAr1=XXPtA1PTzqwioFR6k47Y2Rri-A@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 9 Feb 2021 21:47:20 -0800
Message-ID: <CANT5p=qSaXShm0_iZmWJzUNkSc=xSjtr-w43UQVJnvoiFsFeHg@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes. I'll put a comment to avoid confusion.

Regards,
Shyam

On Tue, Feb 9, 2021 at 12:08 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> Yes, missed them in the first place. Then I would suggest to list them
> in order to avoid confusion.
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=82, 9 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 12:06, Stev=
e French <smfrench@gmail.com>:
> >
> > On Tue, Feb 9, 2021 at 1:58 PM Pavel Shilovsky <piastryyy@gmail.com> wr=
ote:
> > >
> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > index 50fcb65920e8..1a1f9f4ae80a 100644
> > > --- a/fs/cifs/cifsglob.h
> > > +++ b/fs/cifs/cifsglob.h
> > > @@ -1704,7 +1704,8 @@ static inline bool is_retryable_error(int error=
)
> > >  #define   CIFS_ECHO_OP      0x080    /* echo request */
> > >  #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
> > >  #define   CIFS_NEG_OP      0x0200    /* negotiate request */
> > > -#define   CIFS_OP_MASK     0x0380    /* mask request type */
> > > +#define   CIFS_SESS_OP     0x2000    /* session setup request */
> > > +#define   CIFS_OP_MASK     0x2380    /* mask request type */
> > >
> > > Why skipping 0x400, 0x800 and 0x1000 flags?
> >
> > They were already reserved.  See cifsglob.h
> >
> > #define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
> > #define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before send=
ing */
> > #define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response *=
/
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Regards,
Shyam
