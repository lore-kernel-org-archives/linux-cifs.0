Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0266C4CEC6
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 17:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84AC420830
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 17:01:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G5DMqSGW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfILRBn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 13:01:43 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42069 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbfILRBn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 13:01:43 -0400
Received: by mail-lf1-f67.google.com with SMTP id c195so5063636lfg.9
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 10:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=64fN2rtceaicXHef8d5h29l48Y1Ix1viewj86XSlBxA=;
        b=G5DMqSGWw/Q3s0FSCAMNzG1DPFTWKkLH5MwTMexmOdE25p5O4w79XcG45iVN6O6Qxy
         ue+baBbYxsLrS8u3az2jFrEe+SJujtp0kmrNczc0ZTmaVcp6F58hkIbK32zbFdMzmmKY
         NoqgpRiCRggRgLydzuWFqYq0QUYwZfwsMfnr72YDiU4hxYC6LTbQk3rZib3PEDy/WbdI
         iKkwX/0FnhL9+QP8+DhGOLH2x0c6SfUd06F7nfi7o7awfVA7RXd5OuuhOjW+cGWAlzyY
         RuEf/acbpofFvagdSu8h4r+P+b2uS8BpvCbUkj3xiPVpCIizXDytWpkonBRXnWMn7nBV
         ifbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=64fN2rtceaicXHef8d5h29l48Y1Ix1viewj86XSlBxA=;
        b=mGmFB43bamGy7Vm7f2tuJ0SHVpEI8VVoplyC/JSvj/8DOKPJuVeLtiMycb2lI9a0td
         2WPk1Th1iq+o0+6+ug6Dhdqp7litbCc+v7lBALUZIcDYCDpuLuhbp2mNdTXeRPop47Nm
         sRCpmz2KnEoHT3LGQ4WYn4S5EAAK9TvFXZ9YMPAv8mB7XG4+2sRUPnnvveLVHBPyTX32
         I5hqy/giglAHkCeAE1j1R0yCN5TdOnTuAWqdy7rV9Bqc0ctsI+xIENWpmh+tmkR2H6oF
         i4kR0530obV627tQVOIn0YeRP1QnXRlyU9N9wxb9QZVaziTzysjO5fobMm2xqZSud6kp
         f/7g==
X-Gm-Message-State: APjAAAWFubqmk/G3+K2edFU8Qp7sn38KsDS5170j2d2SmYIzxjekJJHd
        aIUCeMq4qsegmL4izo4FDw9iUvZMCqDGxga5fg==
X-Google-Smtp-Source: APXvYqyfxMPPtk/7o2dcD2OXDC378dolDFY2UzJv4wzIq4xIxqhbN16MDUCQJnLL/M8lqrbvxUD/sY4LOZepeeZ8HJs=
X-Received: by 2002:a05:6512:304:: with SMTP id t4mr29251091lfp.15.1568307701517;
 Thu, 12 Sep 2019 10:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
 <CAN05THSjpqqgXgfvDndFyZS2TwyvKDCNMSfxxgMApQVECk=cSA@mail.gmail.com>
 <CAKywueR6Z1QbkbA3RxXrBEZOvHxECnAGV1ko+DnLgTusv2tEhA@mail.gmail.com> <CAN05THSBw-6WMJK8Sb_nXevrCceqkjuYRumF1pjqPoeg90aMtg@mail.gmail.com>
In-Reply-To: <CAN05THSBw-6WMJK8Sb_nXevrCceqkjuYRumF1pjqPoeg90aMtg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Sep 2019 10:01:29 -0700
Message-ID: <CAKywueQUOyNPG7QKEAeiJY7=pCqfHZhkPKTT0r404vgh8-HJSA@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Fix share deleted and share recreated cases
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We need to skip TreeDisconnect command if tcon->need_reconnect is
true. Steve, could you add this to the patch?
--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 11 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 15:10, ronni=
e sahlberg <ronniesahlberg@gmail.com>:
>
> On Thu, Sep 12, 2019 at 3:08 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > can this error code be returned on any operation?
>
> Not sure.
> I think it is only returned by TreeConnect and possibly also
> SessionSetup, but not sure.
>
>
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > =D0=B2=D1=82, 10 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 22:26, r=
onnie sahlberg <ronniesahlberg@gmail.com>:
> > >
> > > Looks good.
> > >
> > >
> > > We also need to handle the case where the share is deleted but is
> > > never added back.
> > >
> > > On Wed, Sep 11, 2019 at 3:15 PM Steve French <smfrench@gmail.com> wro=
te:
> > > >
> > > > When a share is deleted, returning EIO is confusing and no useful
> > > > information is logged.  Improve the handling of this case by
> > > > at least logging a better error for this (and also mapping the erro=
r
> > > > differently to EREMCHG).  See e.g. the new messages that would be l=
ogged:
> > > >
> > > > [55243.639530] server share \\192.168.1.219\scratch deleted
> > > > [55243.642568] CIFS VFS: \\192.168.1.219\scratch BAD_NETWORK_NAME:
> > > > \\192.168.1.219\scratch
> > > >
> > > > In addition for the case where a share is deleted and then recreate=
d
> > > > with the same name, have now fixed that so it works. This is someti=
mes
> > > > done for example, because the admin had to move a share to a differ=
ent,
> > > > bigger local drive when a share is running low on space.
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
