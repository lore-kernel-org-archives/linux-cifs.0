Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE55FC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 08:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E6B12073C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 08:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhA0IB7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 03:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317072AbhAZXUa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jan 2021 18:20:30 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41896C061756
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:19:34 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f1so68497edr.12
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+ToRPZyvBOx3d0OIHEZRtUJs4AK7hFBChC+h+y1Okqg=;
        b=hsHSXIvPdqTNAs2LDmYMBX++oCdU6ybJyBFQIzdldW5bNrS2Ivxgd22Ydoa/pZYuV0
         7oXODSIHliivBjCL52nxSzFR7UDIorcIrLh7UxRR5PmucXhswvizSaxY9K+3XUeA5hfq
         XsOfaTXv71m7toScxQpLGtRXoY5T06vum2Mh9IwJMho9fTkAqsEidStY102BLSaX8FGi
         uNsykN6UF8tsTBMpXjgAVEJCBmKtOB3bIWx1+rXKHgSmIhFOzsg0wOfgtPbWm3sx1FyU
         H+EErH3iLeTzT41aPkNH30vauRydJQHQwGh5gc/3XoDkOmtSWx49H4nfWKGgjHDMnL1K
         UQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+ToRPZyvBOx3d0OIHEZRtUJs4AK7hFBChC+h+y1Okqg=;
        b=ofJT3JWKMyCMKwWjEsB+gPRCrvXOHFsmCOmdqeumigKeCZqhLryNODC3EAO8iWCaNQ
         vPSVtDh0Cc2lzz8Ya6AMZi8EMTQgXlVh+DdH9OvrXRNZMY9Pjoj8yAbovAbCIjsUWRks
         7IIUAcrHCxOrUCqKu5BiFILYS8WOgIATZaXpkWxR/nHY1ZJsr2+HXRrEeyN7x8wpGa8j
         IxHN+LTSxVDKhwHmFNDQjKS7Mgvg/0dmqsg5ITxwxvJ6GOJWxB8Mi4/9eoXXYVYQeUNU
         vtWypZI6lV1EW0jSRQHTByW0QybwH6iGMp1t0J0MEJzHPbRj2DkNIrb8VGa+2ZKLOydE
         MrGg==
X-Gm-Message-State: AOAM5308JGzP1TA3vSyaD9IQmLE9O20rXRpugzHay8Cq0J2UJ+e4XNO5
        /qcr2bQ1LWFTTurPf7om053qGVy2PDuV27Hnig==
X-Google-Smtp-Source: ABdhPJx7rB3S7G+cRo9SFqU0+t1dGOVIAbJShLEjtOppbEDUgdw8L6PK7v4Pq6vbmjzY/mJHfCOitkSk1ygqymIcqQ0=
X-Received: by 2002:aa7:d78e:: with SMTP id s14mr6353759edq.329.1611703173063;
 Tue, 26 Jan 2021 15:19:33 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
 <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
 <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com>
 <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com>
 <CANT5p=qrRVaN4yrqHz5fS2fC6_K1XqAiR4Bv9rTX6oxgg3j8gg@mail.gmail.com> <CANT5p=oqqTimiNgheGB9ntjpGzCNZrS_CcwkU=zUk4gZ+yD7TA@mail.gmail.com>
In-Reply-To: <CANT5p=oqqTimiNgheGB9ntjpGzCNZrS_CcwkU=zUk4gZ+yD7TA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 26 Jan 2021 15:19:22 -0800
Message-ID: <CAKywueQ_VR8W25VAqZXuQWEJH-3Pq5ec0QYcfT_Gngk=b2ti_A@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 25 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 09:21, Shyam Prasa=
d N <nspmangalore@gmail.com>:
>
> One more point:
>         if (signal_pending(current) && (total_len !=3D send_length)) {
> <<<<< Shouldn't this be replaced by fatal_signal_pending too?
>                 cifs_dbg(FYI, "signal is pending after attempt to send\n"=
);
> -               rc =3D -EINTR;
> +               rc =3D -ERESTARTSYS;
>         }
>

At this point we are returning from the function anyway and would want
to return a proper error code if a signal is pending. So, I think
checking for any signal is correct here.

--
Best regards,
Pavel Shilovsky
