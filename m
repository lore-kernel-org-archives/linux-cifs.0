Return-Path: <SRS0=j5Ui=VC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE07EC46499
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 21:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9147A20449
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Jul 2019 21:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tq26O8K8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfGEVI3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Jul 2019 17:08:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43071 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbfGEVI3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 Jul 2019 17:08:29 -0400
Received: by mail-io1-f66.google.com with SMTP id k20so21737333ios.10
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2019 14:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHPZs46MZLP/nb1nFED/utSRLX8tkXM5+Opy01eL4Z8=;
        b=Tq26O8K8RKVVTuvbdYTqa16w75JaZVIx7KUru0Ls8p47gKPPzmc6kzrML52gWCuSpb
         hLoyZ1ou5SY9QsitPDTDDJG8RVZ2pGsp4ejPRKqEzpfcl0xiBiZItCO0gibqNVD5qy83
         AC4xjbuD/zAIJQBpTx2iHEj/Gs9bJRWr+kKrAOOi9RJgCV5El0XLdwu35Lmmyd4dJMk7
         01MiJHt0v49JcSweqC4bQ5724xGf1BLsxhJhOm8/qCoC38chvv5As48ri0yK2P1wx056
         KSubE5dF/St4zTq6vx2H0IeyD9pYC5kDJX/F4AnI57mSENPZuetMfb1qQEwiTFWiozYO
         kOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHPZs46MZLP/nb1nFED/utSRLX8tkXM5+Opy01eL4Z8=;
        b=j4kscAkRp5sFbiFVm1TRKZAQU65uLhg8Xwl6fjF5BWOIJjB8CbIIgPYwWZHrbuMmy8
         hi3Pbp7nF/rMfEcJTllXQSNWa+Enu5lJsTzk1carwdTyCPgzGbBfXOnzga4BsuQahFEG
         rzlb0yzKoTIp5Yx1oEJaGMZD6TLZxJ1pPZoUvHyGoNSPXA2yLsDbbYtwBlgz3kyCiELd
         Dpwd6cwbzH09Lr6XBsAFD71/CqJp7i2MLKIfjjYJpdN/ekjf4wxPp7bVn8mYJ0moPppZ
         K3/Ww3/tMTVaM5/A8OHL4GB/GXeQSb8HAYy1ggAVn323gY4MDVr4qKXr7hUwzPfwLoRQ
         daOg==
X-Gm-Message-State: APjAAAWe7sPHXttazfPeQHXwmfix/tdqPdh9GR+au5tc59WjNBn+bQ/T
        88odOJda+Uz/qheFh4Gt/3JbqZbRT2BAR3X7qjg=
X-Google-Smtp-Source: APXvYqzsgVu3+BquHCjiome1tQNICc2Y5WxB2myx4Uh+xViDTAbiTLAkl+O9hs/LyQjuXVNj1NjOTMJa48VIMb7D5jA=
X-Received: by 2002:a6b:3883:: with SMTP id f125mr6406815ioa.109.1562360908409;
 Fri, 05 Jul 2019 14:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190705204308.10039-1-lsahlber@redhat.com> <CAH2r5msoNnX0ZQ2GKMzoa8_-J1kukbQ=uiAC4m=w7XM86b-uZA@mail.gmail.com>
In-Reply-To: <CAH2r5msoNnX0ZQ2GKMzoa8_-J1kukbQ=uiAC4m=w7XM86b-uZA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 6 Jul 2019 07:08:17 +1000
Message-ID: <CAN05THTONV2j-6r1rF--9BQfOdfA-8Ou2O1hmTNwcB=xd7gYqA@mail.gmail.com>
Subject: Re: [PATCH] cifs: always add credits back for unsolicited PDUs
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Jul 6, 2019 at 7:04 AM Steve French <smfrench@gmail.com> wrote:
>
> Thoughts on stable?

Yeah, maybe. It should be very rare that this would trigger but it
could and would lead to a hung connection.

>
> On Fri, Jul 5, 2019 at 3:43 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > not just if CONFIG_CIFS_DEBUG2 is enabled.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/connect.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8c4121da624e..11adca981263 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -1221,11 +1221,11 @@ cifs_demultiplex_thread(void *p)
> >                                          atomic_read(&midCount));
> >                                 cifs_dump_mem("Received Data is: ", bufs[i],
> >                                               HEADER_SIZE(server));
> > +                               smb2_add_credits_from_hdr(bufs[i], server);
> >  #ifdef CONFIG_CIFS_DEBUG2
> >                                 if (server->ops->dump_detail)
> >                                         server->ops->dump_detail(bufs[i],
> >                                                                  server);
> > -                               smb2_add_credits_from_hdr(bufs[i], server);
> >                                 cifs_dump_mids(server);
> >  #endif /* CIFS_DEBUG2 */
> >                         }
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
