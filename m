Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC06C433E7
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 18:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B58D20760
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 18:21:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5XwH3ci"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732918AbgJOSVl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbgJOSVk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Oct 2020 14:21:40 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA2CC061755
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 11:21:39 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id cq12so4063834edb.2
        for <linux-cifs@vger.kernel.org>; Thu, 15 Oct 2020 11:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lrFcfb/9m83T4XSGQBFUK3XxUwBgjTG5OksZkwZIhbE=;
        b=s5XwH3ciQjsgYDpL3lfKHxYYbAPv8ZEUrXc28YSZNGIGh287VIS0g8bYoI6x/jfSu/
         YVn+pn2+Bcg9E9TnkVldonsFZSdIUOvydYvk6aU1U8GAFu0uwH7RPRRSQfB8vbTh+E4A
         Rrvk6tDEymFr1lSxOQEuJbM2alncyyM9unyuZ96OJ6VjMEZChtGJ49bgEMQ4j5NzKNNE
         CsxGS1DEg3qrBalUoUZnu3markYzhX38fSXAwIOHTxis0z/veDw71fPuLYNnJu1Uyv8q
         njMTzMk8fJ+hCzQN8m9fF/gWqjFFO3HQM81ithTgq++cQdxSGqWizqKW20vks1gdGlu3
         PvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lrFcfb/9m83T4XSGQBFUK3XxUwBgjTG5OksZkwZIhbE=;
        b=VBkaRr6qMA+gB+2+Cy0zcgvd5SXoBgwKsJH4XKvkNVkpSpPvqxyj3lNup7AueMuk7T
         yHcHvOupzd+e3PNJyGxuYK+3IQy8BsgJkjyuRbTL2AF5J4+x+7kb64BCE9Fh44Ftkl+p
         gRZ82Y2ayujvjbaUdERtaG9lmSi2sKEvyG1TNnbDKIr/v4BXdXbaIDi8pJFCLdV9qECN
         /UhdR1vmvoKrQtuWffOADOz+GvIPC/qBl9klYjl0AeGiJn6VD9rdGzNERwhwNy1hetNt
         tYBctATVsck9G0F+CcqgxraV4L1rjLZru5ir7A5oMtm6Iok5aCgoOLtBrzeXm93nwWzp
         2hXQ==
X-Gm-Message-State: AOAM5331qN9Z5Byv5bvnsioc/jYvb75WH5GHyQKqvfwVfRMujJGY7rbT
        nUCBHvpcyrrOjvDwg5HdgljduyGuWeG6p/OPZQ==
X-Google-Smtp-Source: ABdhPJyXghOSoQFJQbf1G2IKkN5UrEQZCjoxjyFZuPxt65uwDfa5LrP7jdRh2pzwHjHVntXnu8zFawqUHR93NrCxAn8=
X-Received: by 2002:aa7:c68b:: with SMTP id n11mr5557390edq.340.1602786096675;
 Thu, 15 Oct 2020 11:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
 <CAN05THShczOiSTD_bbRfPqHkOfOBLgNiaiibMu6GB+RzXsgK4A@mail.gmail.com>
 <CAH2r5mvZLCMtPVHFu1-Rb5EaP5-1ZiYFaNALm51e5Ui07x9taQ@mail.gmail.com>
 <CACdtm0bKJMuWPUisM8Ogfc8AH052-Y8Cgcdz5gNbVD2nLtJZ_w@mail.gmail.com> <CAH2r5mtO4yDukvQCZ1jS0SGOAsjk5ka9LPbGRd34zV=czSLLNg@mail.gmail.com>
In-Reply-To: <CAH2r5mtO4yDukvQCZ1jS0SGOAsjk5ka9LPbGRd34zV=czSLLNg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 15 Oct 2020 11:21:25 -0700
Message-ID: <CAKywueR-ngDPXXwMyVy7DtKzeRoXt3z-koqLSnGbOajrtVPCeg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Handle STATUS_IO_TIMEOUT gracefully
To:     Steve French <smfrench@gmail.com>
Cc:     Rohith Surabattula <rohiths.msft@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 27 =D1=81=D0=B5=D0=BD=D1=82. 2020 =D0=B3. =D0=B2 20:41, Steve=
 French <smfrench@gmail.com>:
>
> merged into cifs-2.6.git for-next
>
> On Fri, Sep 25, 2020 at 2:33 AM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
> >
> > As this status code is returned when there is an internal
> > unavailability. So for any transaction, this status code can be
> > returned and EJUKEBOX check needs to be added at many places to
> > support this.
> >
> > Respined the patch with signoff flag and attached.
> >
> > On Fri, Sep 25, 2020 at 11:42 AM Steve French <smfrench@gmail.com> wrot=
e:
> > >
> > > Ronnie also mentioned EJUKEBOX as a possibly better error mapping to
> > > return (and then check for).  EJUKEBOX implies waiting and then
> > > backoff.
> > >
> > > On Fri, Sep 18, 2020 at 1:20 AM ronnie sahlberg
> > > <ronniesahlberg@gmail.com> wrote:
> > > >
> > > > On Fri, Sep 18, 2020 at 4:08 PM rohiths msft <rohiths.msft@gmail.co=
m> wrote:
> > > > >
> > > > > Hi All,
> > > > >
> > > > > This fix is to handle STATUS_IO_TIMEOUT status code. This status =
code
> > > > > is returned by the server in case of unavailability(internal
> > > > > disconnects,etc) and is not treated by linux clients as retriable=
. So,
> > > > > this fix maps the status code as retriable error and also has a c=
heck
> > > > > to drop the connection to not overload the server.
> > > > >
> > > >
> > > > Do we need a new method for this? Wouldn't it be enough to just do =
the
> > > > remap-to-EAGAIN and have it handled as all other retryable errors?
> > > >
> > > >
> > > > > Regards,
> > > > > Rohith
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve
