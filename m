Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AC8C43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FD9920675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 00:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g1HIx/Mo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbfCFAHk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 19:07:40 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35925 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbfCFAHk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 19:07:40 -0500
Received: by mail-qk1-f196.google.com with SMTP id c2so5823468qkb.3
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 16:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u6Zl6vsgDDDimjJMKzJ1VBsZEFZSjBp0ewe1InEd0Ms=;
        b=g1HIx/Molj1PIUUdrDOCxqvBmip1xKaR5KIPDrfSavtIsuh3/DAbI7UlfubzgemtpJ
         7tATwUDSuYaTy+TIe87iekdebVn0TkKzse33lBirEyVxJvUNJ5MXcNA2lUSvbX5+Cy9Y
         IumOz9IyKM02eM8yTGVS2Wch+96lZGvO+WYKDcfDrtZPQ5lh3c12tqCaFl5GafBl6vKW
         eegJySZjfmAillNcXUbcx1Y3Y3QhsvNO7OBpTLjqwXYho4ODhQ0A46x/P2BEacLpkoUf
         Fy0oIK9O3mTyLf/8ZAYpVOGF/BEGCqOEitBPoLUuJlGc592nwut7BxQOPLPM4m05STHH
         BdMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u6Zl6vsgDDDimjJMKzJ1VBsZEFZSjBp0ewe1InEd0Ms=;
        b=hVyHAfV1RX2RA+0SpFfjyZ9ohwG1EsbhRRcdq/dKocQgypy25swgpyGRihlAm42uLN
         tEkkoymYZOPLHJxJck3LWVYBRZa07KB852Xb4RpxJK3G5H0sjI7PXmYG/90GG5jWUsJy
         RnkgDJBYwX3FvoaNgQ0jv20LS93g02gFf1EgaVUD80u6TSryBZzWnCkzbHBB2p5kqXL1
         +VFdXe273qTCpKHk/yEVR5UW4CSTGi091J9KQw334u0Um8EErHlRs9jT48knGfBuxJTE
         agIaKm7htti+6pbNS1oQ+J7h4/Qny+E7UTjcOj6q59g2wgjJ/C+ZdjU61LntEfSSFw6c
         Owyw==
X-Gm-Message-State: APjAAAVGkwTmxx5NX6ZslPKuZH1J8Z8duoSKXuvZmKzP07uU2fMvh7fv
        4GppsIBXTAyxs7rf1eOH4nXrWnj6SIzbIMZl0b0=
X-Google-Smtp-Source: APXvYqxnLkOVNIsqmmWWs/c6LF+iOAlTMDUT4Q/s4CqmqnLef4qYIQcbqMaWG+DIioiOXyyuY25cra3M059G4vRLEMA=
X-Received: by 2002:a37:491:: with SMTP id 139mr3718024qke.345.1551830858999;
 Tue, 05 Mar 2019 16:07:38 -0800 (PST)
MIME-Version: 1.0
References: <20190228062405.32107-1-lsahlber@redhat.com> <20190228062405.32107-5-lsahlber@redhat.com>
 <CAKywueSuZovHMSN32ANv5+0M-EvTHFDKx7OPssy2soo56OeHRQ@mail.gmail.com>
In-Reply-To: <CAKywueSuZovHMSN32ANv5+0M-EvTHFDKx7OPssy2soo56OeHRQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 6 Mar 2019 10:07:27 +1000
Message-ID: <CAN05THT6ijtAtwNgnU-S5hbh7Q50A2+cK3YZOrgQ3m_MZuLqFg@mail.gmail.com>
Subject: Re: [PATCH 4/5] cifs: prevent starvation in wait_for_free_credits for
 multi-credit requests
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Mar 2, 2019 at 11:41 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=81=D1=80, 27 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 22:26, Ron=
nie Sahlberg <lsahlber@redhat.com>:
> >
> > Reserve the last MAX_COMPOUND credits for any request asking for >1 cre=
dit.
> > This is to prevent future compound requests from becoming starved while=
 waiting
> > for potentially many requests is there is a large number of concurrent
> > singe-credit requests.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/transport.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index baf15194aa3d..4ff832fce2e9 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -520,6 +520,29 @@ wait_for_free_credits(struct TCP_Server_Info *serv=
er, const int num_credits,
> >                         }
> >
> >                         /*
> > +                        * For normal commands, reserve the last MAX_CO=
MPOUND
> > +                        * credits to compound requests.
> > +                        * Otherwise these compounds could be permanent=
ly
> > +                        * starved for credits by single-credit request=
s.
> > +                        *
> > +                        * To prevent spinning CPU, block this thread u=
ntil
> > +                        * there are >MAX_COMPOUND credits available.
> > +                        */
> > +                       if (!optype && num_credits =3D=3D 1 &&
>
> What if server decides to grants us credits gradually? E.g. granted
> only 2 during negotiate protocol and session setup. The tree connect
> will wait forever here.

Thanks. You are right.
That should be avoidable by checking for and only doing this if we
have <arbitrary large> number of credits already in flight.

I will send an updated series.

>
> > +                           *credits <=3D MAX_COMPOUND) {
> > +                               spin_unlock(&server->req_lock);
> > +                               cifs_num_waiters_inc(server);
> > +                               rc =3D wait_event_killable(server->requ=
est_q,
> > +                                       has_credits(server, credits,
> > +                                                   MAX_COMPOUND + 1));
> > +                               cifs_num_waiters_dec(server);
> > +                               if (rc)
> > +                                       return rc;
> > +                               spin_lock(&server->req_lock);
> > +                               continue;
> > +                       }
> > +
> > +                       /*
> >                          * Can not count locking commands against total
> >                          * as they are allowed to block on server.
> >                          */
> > --
> > 2.13.6
> >
>
>
> --
> Best regards,
> Pavel Shilovsky
