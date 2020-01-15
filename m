Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D5FC32771
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 20:50:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0CAE2084D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 20:50:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EwN0/awa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbgAOUuO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:50:14 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:44042 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728939AbgAOUuN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jan 2020 15:50:13 -0500
Received: by mail-il1-f195.google.com with SMTP id z12so16064608iln.11
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jan 2020 12:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=so8CCxn95K3SOxcbo8bAqXC1wGetwwBVYKxO6ujxFpA=;
        b=EwN0/awaABpxnpFXK9WbMY2v24ipaGYydoQXONS2RQmznJplCo+2j3fRv7UQVxqqXi
         85Mm6qWQf624urUh/kd3gzMVAmoMVGChNQM7lgSM9byf3B//0BpIle5oejEhbIrlvIYT
         YHxtH7+bkup5VGQQHZ3YbYia8N1JOXL8b4sJKbDYDD2qH9+64GGpPu+//mEtzn5VMRkN
         A0alqpRZXJvQhVgeg6+1NQGYOTVAkbIjTctedmo3kd7/Fptt9xVjkS0PxJy5hHpC3Vv1
         vopnhEXyuYRLC1+3frEIG9UuYAXRgcRa+Lm1kwefVeGXudjP189oyFUsWBykIIUD56Fm
         9Gag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=so8CCxn95K3SOxcbo8bAqXC1wGetwwBVYKxO6ujxFpA=;
        b=pGZwyiiEC+14yf0GWcmyt8t3dlh9lpND00zMvmxtyClXQWyKg0DHxGlTXx7vngvLue
         nUc+p7RMSWN2brqRxKVDQbDwm4bRKZ3xjbhI97o1tt1QpE0sRPq+dVfnHphDIWmWGVVn
         J2GK/QVE65WMXVTQ4GlvLQUvqTTA9DicxN0/+Cd++dXRQyJAnftHBkVqNK0D1p2LXQfK
         1p167Lxtp6Y7ILDY7Mv+65v7tiIl54B8i6EzzDcP5Eh5pghr6AVIzZ7tmleT0uWXC7SZ
         xnw4Na4MGhC//Y1dUkv3mYdoHLISobgFRPW/wSsxb6ZR0+czkbDGhO4vCgoFDxLS/a3H
         jsvA==
X-Gm-Message-State: APjAAAUoD1Sy4obUl96jPL+v40kt7mWufcDUYoGNc561tdPpmyn9iEs7
        XyK2JVdfpsqmywCv3MN0UhYNBimaf2mMhrcNhBY=
X-Google-Smtp-Source: APXvYqx8ofCRxRxUp1Jh+gpF8gZlw9OLCHUn5cUK/WGh9+eG5aFx5jw/unsMLwvDcqFtwZVD0sqtQ3hyLPhvBYdb7bw=
X-Received: by 2002:a92:cb8c:: with SMTP id z12mr379685ilo.5.1579121412829;
 Wed, 15 Jan 2020 12:50:12 -0800 (PST)
MIME-Version: 1.0
References: <20200108030807.2460-1-lsahlber@redhat.com> <CAKywueRmjCYPGnZvVbM01Pc1kibKZQKit4mPfsE8ou+t=wOGXw@mail.gmail.com>
In-Reply-To: <CAKywueRmjCYPGnZvVbM01Pc1kibKZQKit4mPfsE8ou+t=wOGXw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jan 2020 14:50:02 -0600
Message-ID: <CAH2r5mv26iGyJjpye2_84hyDOBEN_Gv+bNvBGVP9tZ8B3W1rhg@mail.gmail.com>
Subject: Re: [PATCH 0/4] cifs: optimize opendir and save one roundtrip
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next (and added cc:stable for
the last patch in the series) pending more testing.

On Wed, Jan 8, 2020 at 6:34 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> =D0=B2=D1=82, 7 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 19:08, Ronnie Sah=
lberg <lsahlber@redhat.com>:
>
> >
> > Pavel, Steve
> >
> > Please find an updated version of these patches.
> > It addresses Pavels concerns and adds an extra patch to set maxbufsize
> > correctly for two other functions that were found during review.
>
>
> Looks good overall, thanks!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> Do we need a stable tag on the last patch?
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
