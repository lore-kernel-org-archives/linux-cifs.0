Return-Path: <SRS0=Llk7=DC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3116C4741F
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 06:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96928235F8
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Sep 2020 06:12:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h+LDvMiA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgIYGMx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Sep 2020 02:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgIYGMv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Sep 2020 02:12:51 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BD5C0613CE
        for <linux-cifs@vger.kernel.org>; Thu, 24 Sep 2020 23:12:50 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 67so1225662ybt.6
        for <linux-cifs@vger.kernel.org>; Thu, 24 Sep 2020 23:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qsPBTIzvnk7pW0tr1pvC1SgO3bd75tFQ1idGJWhZLtM=;
        b=h+LDvMiAdDEUtUCGlJV5oeblFHiWyQhuBm8/c6riyvZYyobYRNwSQo5W/gGSzztnkq
         vrRXHOIC6kdv8MBlzc6Q3zvvhXNaWiXGksX/Yz5O47rB4P8RZ6PuVs0+AJGm0Y7GVLkA
         Hbk7gSA9+dWl5gXAgRQcjTYL1Ku2S7FncWOG6FeL40ToduVnTW2cTc2QkKgmtAK/7wd0
         pmQQ76tJjF+FQUL/LXDNGajg89NhVmhBUeWLbmYvWDkdaMnd7jk4nMggF6CCeWKoNYjk
         eRjpDiX+pnKl4ZxTjZRgiipG0ISU/uUlGQZp9d/na6QxFjx80fXWYdWTQmI5n1Kp6cta
         +0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qsPBTIzvnk7pW0tr1pvC1SgO3bd75tFQ1idGJWhZLtM=;
        b=FPje9D01F3LOIzF0ezOtiIReh4zuQB7gBBhe92qAmWYGdm2tsXZypHtcbwiyCR5VkQ
         AMys/r9Wsqkzc/OrDuuOQ3zhjYBjTiwr+fDloDw/BuQFBy4ezrN50nc6BMTkuTQlO2to
         bkoqPZ1NuUDoz8KGRC8jt7gEMbyX2gkCRV5JIx8nd6beGbQ8gAOx4qYdV+rDoKlE7ixG
         htPA7em0RkRY6ZwRxhv/MRy0vlcZJUZi14Hiiwi+x+b5oDIzkIdPz6T8kFUiVD/khT6F
         z1h/DUTyhm7ax6ATbCcJeInrBliFAJPf4O4Ejz9WWo0Cq+/7LyYIrvHlKHkVospLX7VB
         bbxw==
X-Gm-Message-State: AOAM5338LVg20+bV50dJbm/7mdinl32UK0XLwL29RzhVRN6NBc4vodEs
        NrjIUYqWaRXafRq4q+je2Heu0IZptAHxT2IOoEQ=
X-Google-Smtp-Source: ABdhPJxVivgS72ahnQwBybIEFoOqSm/v1YyMIQmX/0w72dk4gLF2+KRTA6rKAwyGr+Jiz7jSJcPNirmjsu+dKT5VywI=
X-Received: by 2002:a25:d34b:: with SMTP id e72mr3215517ybf.167.1601014370074;
 Thu, 24 Sep 2020 23:12:50 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
 <CAN05THShczOiSTD_bbRfPqHkOfOBLgNiaiibMu6GB+RzXsgK4A@mail.gmail.com>
In-Reply-To: <CAN05THShczOiSTD_bbRfPqHkOfOBLgNiaiibMu6GB+RzXsgK4A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 25 Sep 2020 01:12:39 -0500
Message-ID: <CAH2r5mvZLCMtPVHFu1-Rb5EaP5-1ZiYFaNALm51e5Ui07x9taQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Handle STATUS_IO_TIMEOUT gracefully
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     rohiths msft <rohiths.msft@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie also mentioned EJUKEBOX as a possibly better error mapping to
return (and then check for).  EJUKEBOX implies waiting and then
backoff.

On Fri, Sep 18, 2020 at 1:20 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, Sep 18, 2020 at 4:08 PM rohiths msft <rohiths.msft@gmail.com> wrote:
> >
> > Hi All,
> >
> > This fix is to handle STATUS_IO_TIMEOUT status code. This status code
> > is returned by the server in case of unavailability(internal
> > disconnects,etc) and is not treated by linux clients as retriable. So,
> > this fix maps the status code as retriable error and also has a check
> > to drop the connection to not overload the server.
> >
>
> Do we need a new method for this? Wouldn't it be enough to just do the
> remap-to-EAGAIN and have it handled as all other retryable errors?
>
>
> > Regards,
> > Rohith



-- 
Thanks,

Steve
