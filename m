Return-Path: <SRS0=yxYd=DF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4F9C4741F
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Sep 2020 03:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4A052100A
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Sep 2020 03:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DqYux/TC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgI1DlR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 27 Sep 2020 23:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgI1DlQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 27 Sep 2020 23:41:16 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAEEC0613CE
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2020 20:41:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h9so6871334ybm.4
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2020 20:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OzRLL2zBwPy3g+ij52R97NdWcU/SLLMc8mHmh3T7ci8=;
        b=DqYux/TC3Y+6B2LayG5+knf6WQupkuMvZFg1JuZU5Dv1pK174e58djDzBB58CF82+9
         SBcMNzjN+3dhNEgCVCIKuyQC5hwngkgeQa+lKObpOvd0hYYpE7rYxnl5ZX5l+SkuCqgs
         xY/bRAbXikq1W48fEHiiPeINXRSO7LFPm0p30KMqm+cvOAPZFrD3bLF1jRAlJfYXvVX5
         iF3srlORxFH8RGRO1XHmAnN8oSDl8PJzON8NFj3QCnfXq27J4edxOIqR1UwT81iB06j8
         KZmkdOPdziZI8PCOuJBkloQAqonxHA0TzBYvXDBy7aLieBxKjyvsE31eM5OCwoPDXkj6
         ZynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OzRLL2zBwPy3g+ij52R97NdWcU/SLLMc8mHmh3T7ci8=;
        b=EY2Z21qGXzHJMMT50Cntn4Ol1+EeYYONXupOkCR7X6GUfWu+hxORWrT84pf0cN1+V2
         R3sV81bEXs4Lc+xE4bkMAb2tuxzZg6Je1KqiWWSarq9ckwlFU9RqzFFjtqN8ZLMhDi0a
         GhHa5DtJ8HHR+lo1yDDd7MIMb8Ak56CU3B55tkv0UIY4fiR1tOPmc79QOmsZxWJ3gPFT
         IraOP7R+5cNEPxw2BDwqwVNb51wocoebvMRVIPMrWqPBPdTJ8kSmdNCEIn3Mw41XhMx5
         Gs25PvJ0hnV2igf971qUPoLokAe/ea8ana8jFRVJT8qASPY6YrqslLgrNqX5KnurBfi2
         FA9w==
X-Gm-Message-State: AOAM5308rA/NQF7vIUhOprhBdJGKZnwdebb06JuJiou7pyTyBoH32nQ+
        EKDN6NwNtt3mwu0lMMyv/e7eR8ijfPlWeicVuWVIgRt0T0w=
X-Google-Smtp-Source: ABdhPJwKuOmu4JmZZEP7mzT3MlO8fFOehMn+R7FahXiloreqIHf7ECJm/87h8b1JxtMqGRBAuKdIF1yhy94gQdTnADw=
X-Received: by 2002:a25:ce52:: with SMTP id x79mr12641611ybe.183.1601264475874;
 Sun, 27 Sep 2020 20:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0YSSsH=MOX6BTimj=uppBDxO66yJWK5ikkyd+knhBXKmw@mail.gmail.com>
 <CAN05THShczOiSTD_bbRfPqHkOfOBLgNiaiibMu6GB+RzXsgK4A@mail.gmail.com>
 <CAH2r5mvZLCMtPVHFu1-Rb5EaP5-1ZiYFaNALm51e5Ui07x9taQ@mail.gmail.com> <CACdtm0bKJMuWPUisM8Ogfc8AH052-Y8Cgcdz5gNbVD2nLtJZ_w@mail.gmail.com>
In-Reply-To: <CACdtm0bKJMuWPUisM8Ogfc8AH052-Y8Cgcdz5gNbVD2nLtJZ_w@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 27 Sep 2020 22:41:04 -0500
Message-ID: <CAH2r5mtO4yDukvQCZ1jS0SGOAsjk5ka9LPbGRd34zV=czSLLNg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Handle STATUS_IO_TIMEOUT gracefully
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com, linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Sep 25, 2020 at 2:33 AM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> As this status code is returned when there is an internal
> unavailability. So for any transaction, this status code can be
> returned and EJUKEBOX check needs to be added at many places to
> support this.
>
> Respined the patch with signoff flag and attached.
>
> On Fri, Sep 25, 2020 at 11:42 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Ronnie also mentioned EJUKEBOX as a possibly better error mapping to
> > return (and then check for).  EJUKEBOX implies waiting and then
> > backoff.
> >
> > On Fri, Sep 18, 2020 at 1:20 AM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > On Fri, Sep 18, 2020 at 4:08 PM rohiths msft <rohiths.msft@gmail.com> wrote:
> > > >
> > > > Hi All,
> > > >
> > > > This fix is to handle STATUS_IO_TIMEOUT status code. This status code
> > > > is returned by the server in case of unavailability(internal
> > > > disconnects,etc) and is not treated by linux clients as retriable. So,
> > > > this fix maps the status code as retriable error and also has a check
> > > > to drop the connection to not overload the server.
> > > >
> > >
> > > Do we need a new method for this? Wouldn't it be enough to just do the
> > > remap-to-EAGAIN and have it handled as all other retryable errors?
> > >
> > >
> > > > Regards,
> > > > Rohith
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
