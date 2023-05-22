Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0480DC7EE23
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 14:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjEVOmR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 10:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbjEVOmP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 10:42:15 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB92F1
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 07:42:06 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-510ede0f20aso7067318a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 22 May 2023 07:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684766525; x=1687358525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IYLhEFduMkQIrDdERDUb/k8J0ClJ1iqXTRtRrT8Z60A=;
        b=PBiU285SYm0CosNInpUEA8/2JreDjkBahjYW5x9yntRuq+ZagSXx7uTNIHXjKzWfgM
         CZJve7A3edOagyZiBamOGob5kyH1Kff2T0F8SYKF2Sunjo8zE13ysGfXTo8iBVXXEt4S
         9De3ZbmKvVLGpYF4rDlpq5n2oLCjgVh1ciU7x0QWi0KztJDIZup82OEIIfJSqGb60a2H
         0d+LSWjgsfD/kdIYErVQtLio7tceiLF9KWkeJoiKJDE5Qf4APyGUBmJB1av3kCnC4qEM
         X1JfyK/LM659EEIEFqqliys3zZcUzdZtPPWsFJWB2lYXYgJ0vjlG9XKENJ0sXryfPxXe
         QzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684766525; x=1687358525;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IYLhEFduMkQIrDdERDUb/k8J0ClJ1iqXTRtRrT8Z60A=;
        b=HXGPlwESNX/VtUVPOax0+WjepNb9i0xhsPtFmwyDL+CjGkpEv1QuDSzFgv/dGFnNxm
         S5LIRFj3tHbk7CkM4USNDI3UJfDx+g5jwXgL+OR1tKpUL8JnQ2EJpk0khnHWr4HvEgW6
         2iTR7PSEWb8m9X4wh9z0Dus0b0KIx6plTj7kyhpVICLOCAoG4c9Wh/uMJB41kFjzu/au
         uxxcFIYuKs9cXom8NPMEwIYS//SbBW4svVciuOUVwYQazblRUxCh2kke/sGZun9cpMW1
         OqXEn5N7ftvVGL7pPRASXB6/DbvnJkScoOAtwQTbx1L9xaMZjBQpXd+xqy69PvU2Ja3U
         VSUg==
X-Gm-Message-State: AC+VfDyivChuqxFN3Vw/N/QCSWobD77i5NPnGEjLAPQXkWaYWT6/ic7/
        9mKO5PO+xmr8TvR5d1Hrj0pujvSrqEoRd9ayVGpLDop2km4=
X-Google-Smtp-Source: ACHHUZ5mAsmJ73Pmyi6b17NdcEMwYeXA4qR7zZE5u6B+J8wAbQDsQ0sJUC/tWGfWzcEVGjANvfGS4BBGUfi5o81X2ns=
X-Received: by 2002:aa7:c509:0:b0:50b:c275:6c56 with SMTP id
 o9-20020aa7c509000000b0050bc2756c56mr8720951edq.16.1684766525037; Mon, 22 May
 2023 07:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com> <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
In-Reply-To: <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 23 May 2023 00:41:53 +1000
Message-ID: <CAN05THQZFo+eD=+cBe9D2va0RchOBVunEAfbGaY1JGRSj=qGKQ@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We want to expose ADS to the applications?
Maybe FCNTL is a better interface to do this than magix xattrs.
An application could open a file, and then use fcntl to
list/open/create/delete streams?

We should talk to the NTFS maintainers too as this is an ntfs feature
and they might alwo want to expose ADS to apps.
So we get a solution that we can use across multiple filesystems.

regards
ronnie s



On Mon, 22 May 2023 at 16:40, Steve French <smfrench@gmail.com> wrote:
>
> On Sun, May 21, 2023 at 11:33=E2=80=AFPM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > A problem  we have with xattrs today is that we use EAs and these are
> > case insensitive.
> > Even worse I think windows may also convert the names to uppercase :-(
> > And there is no way to change it in the registry :-(
>
> But for alternate data streams if we allowed them to be retrieved via xat=
trs,
> would case sensitivity matter?  Alternate data streams IIRC are already
> case preserving.   Presumably the more common case is for a Linux user
> to read (or backup) an existing alternate data stream (which are usually
> created by Windows so case sensitivity would not be relevant).
>
> > On Mon, 22 May 2023 at 12:09, Steve French via samba-technical
> > <samba-technical@lists.samba.org> wrote:
> > >
> > > Looking through code today (in fs/cifs/xattr.c) I noticed an old
> > > reference to returning alternate data streams as pseudo-xattrs.
> > > Although it is possible to list streams via "smbinfo filestreaminfo"
> > > presumably it is not common (opening streams on remote files from
> > > Linux is probably not done as commonly as it should be as well).
> > >
> > > Any thoughts about returning alternate data streams via pseudo-xattrs=
?
> > > Macs apparently allow this (see e.g.
> > > https://www.jankyrobotsecurity.com/2018/07/24/accessing-alternate-dat=
a-streams-from-a-mac/)
> > >
> > >
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> > >
>
>
>
> --
> Thanks,
>
> Steve
