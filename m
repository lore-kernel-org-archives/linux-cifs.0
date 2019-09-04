Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DF7C3A5A7
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 03:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91FCA21897
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 03:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ci7J51DB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfIDDfc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 23:35:32 -0400
Received: from mail-io1-f51.google.com ([209.85.166.51]:41383 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbfIDDfc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 23:35:32 -0400
Received: by mail-io1-f51.google.com with SMTP id w15so1129587iol.8
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 20:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gqf2X2Yw6VPEtlZC3B8tXDT7SwvGFML/SqW4GoLkKYE=;
        b=Ci7J51DBfI/BytRbmh41vFjSurg1IBL7Qu3f3mruxBGay84qfinDCuzOT46L27xCnv
         TxRToORHWqWlB6b/K/pLeBF9IGnvPinNr8DCidY8kPxhL1rdr7Pu/P3PRi+GWzvvQ+k8
         /4NqfHJDY7f3r23LgiBWwnSps8zBUNAhCvZaehSdZbES/YypfgGoFMbPYsJuxca2IaEg
         PVexZvPaGpbkJ24enlKxFDnQ8NyR2W5SUWRj+36LMAr66GlH+qK2+wfUKK4lO8Q9R8Ca
         CGPiOsClc84AT5ENb5peB4Ur7mSpS8OxCjhYr9xe/b00+5VdXWSZUa1EegAzlfkaVqWz
         wogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gqf2X2Yw6VPEtlZC3B8tXDT7SwvGFML/SqW4GoLkKYE=;
        b=mpxyCpc0Dy9xjPzsRJjkKjnEJBS2Xx0/zlj3lXxV1gC77wVxMEPz/mg0RQXaILJoIk
         p4ZNREnjIZyT9ZQ8gF9Qp1AK5qqvvuY8rJXvcjSJqXp/iziMZihQ7prv63Fc0pSUya2a
         t7JFQaSaN4tsvSRdr+GGjHD3/Fau6FbD6yZhxmdQ2kujzBGTY3twIORu3ZyaqvfcipAW
         eNCQY2SQak+Ey+FI7iAUFAk/I//sPeKvwT7AE5K0Zjo71LOt+iEWt2/rw0JDWXI3XhdF
         QC+HsQ23PY5dSzArPHiZlisMSNVaSOvWjPSoMGmSaVqcGkC1ognFqPWG1EYy9TzLzPoX
         VBAw==
X-Gm-Message-State: APjAAAWkSgC+uAkZ/vXRNOe14wfpSL75/f3934tq2USL//qgy8i7d7Q0
        bqvs0V6snyCtiNjXJ2zqSaG1xZjS4Wx2cu/oQig=
X-Google-Smtp-Source: APXvYqw96LFmbUWnpZH6xQvNASWVRl+Ptyj0nS5wSwuzbDct8SSby3ANBk2RB5X4x918Q0r0knkgR7fKJ2SdLS1jJ+s=
X-Received: by 2002:a5d:9153:: with SMTP id y19mr553944ioq.109.1567568131358;
 Tue, 03 Sep 2019 20:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muznTsxD2BsyPBX8jfRP5SngyAYf-GFX-tEY+-1DfdMSg@mail.gmail.com>
 <CAN05THTAvysJEiXp3mXaxTSzZOyRSd3y22Pw2MMJe8gQXdwZhQ@mail.gmail.com>
 <CAH2r5msuaE_nuEBzxN0LLpriQzv8fYuBkZDUMo09eFqzyfUf9w@mail.gmail.com> <CAH2r5mv9UTz8CPWz1B3Rk-NdCziX-JmBieNypF9vgoV9T=Bwow@mail.gmail.com>
In-Reply-To: <CAH2r5mv9UTz8CPWz1B3Rk-NdCziX-JmBieNypF9vgoV9T=Bwow@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 4 Sep 2019 13:35:20 +1000
Message-ID: <CAN05THSdkvUZc1E=n46K_12BXEv6uifNk3hMEML6nrEmyx-ryA@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Allow skipping signing verification for perf
 sensitive use cases
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Wed, Sep 4, 2019 at 12:59 PM Steve French <smfrench@gmail.com> wrote:
>
> Updated patch
>
>
> On Tue, Sep 3, 2019 at 9:53 PM Steve French <smfrench@gmail.com> wrote:
> >
> > Ok. Will fix the bool. I don't think it belongs in mount mask since it is a server not superblock parm
> >
> > On Tue, Sep 3, 2019, 21:37 ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >>
> >> Change
> >> bool ignore_signature;
> >> to
> >> bool ignore_signature:1;
> >>
> >> And shouldn't this be part of CIFS_MOUNT_MASK too ?
> >>
> >>
> >> On Wed, Sep 4, 2019 at 12:25 PM Steve French <smfrench@gmail.com> wrote:
> >> >
> >> > Add new mount option "signloosely" which enables signing but skips the
> >> > sometimes expensive signing checks in the responses (signatures are
> >> > calculated and sent correctly in the SMB2/SMB3 requests even with this
> >> > mount option but skipped in the responses).  Although weaker for security
> >> > (and also data integrity in case a packet were corrupted), this can provide
> >> > enough of a performance benefit (calculating the signature to verify a
> >> > packet can be expensive especially for large packets) to be useful in
> >> > some cases.
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
>
>
>
> --
> Thanks,
>
> Steve
