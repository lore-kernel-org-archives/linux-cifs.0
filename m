Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AA7C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 03:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C89D7217F5
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 03:33:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="INAFYODf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfH1DdZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Aug 2019 23:33:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45089 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfH1DdZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Aug 2019 23:33:25 -0400
Received: by mail-io1-f66.google.com with SMTP id t3so2885054ioj.12
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 20:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxb2TT3Ghdyh0NT27Vkcv9FCWu4CmOHEvnwzBZ1Fibc=;
        b=INAFYODfSvWRlQsx98GQwit/btf6i5kOfngI+/IV1sLW4n5zTDsBb/lzlrIjOzjBdG
         yDSB6lVgnENT5rs1wlftWasETfIOIljpWYN6xv+WdNHqX3XNEaKWDMMwLV+IS56Znd8N
         DbafgDHDXhzuNIUQD006NaeMdQXZh1mNrovfgf0Cy7WGTYNc/r9ZdHf/MKXj/GmvDd1h
         5qwT+3DE1LpiIOC0/pL/ZwGoHRW+2r1JaBr3xVIvoOjrblu5Nitg+XKpz9OHyC5lfeD4
         efRJassbrVMGl86CFY4nvC3VvVbmHEVdDBUuCOmJnmQlCVlJO4XbFAHQDJI9CL9uL3qy
         Ou1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxb2TT3Ghdyh0NT27Vkcv9FCWu4CmOHEvnwzBZ1Fibc=;
        b=G5dEdO+JcxZ4bscw6nHz/p2fIbJaKVSyZVotcwmWO2pd6F3pDdvu+GFPk0aIsNZi6h
         Pu5ueRvRKEs204+VSunJpMGcmdbG43CevlJwJ3N/kSK5tGYwqiCVnHzQT3sC7q5fXU/A
         gP2xN3CtnGP+HCUk53BVQyLFVUaj+zXfdwWoJ3lr27+qDrFxKOgmF2xAOWH4YuJPNYUA
         JdElths/F4vGJ0L9sLP+acgD4tLqIF3nORM029Un6MNcvQldrpou1F8ftAK7NefMVFTa
         2cR0y/5BI/0kCL6/EN+M26wBFJMPeku9WVE7GR+ZgWBK/zMu8nlNwXFwJY4VuSfroXZE
         w5cg==
X-Gm-Message-State: APjAAAVoE1HwE9BK7F7JrZYfv6sFfK19RUd9CLAVHu7NdscU3Vx3haTK
        skv41g+YJZhmNEMvGWsZG+Bj6FZGX4juXaZPDurhAw==
X-Google-Smtp-Source: APXvYqx78kCW3mBFRTwZXkwXYzm1s67veGyWyPx10dfCctjIpp9XDqe5aZcv2uj7FkM4awYTQntAQVdKROlJEIGAtrQ=
X-Received: by 2002:a02:5246:: with SMTP id d67mr2354012jab.58.1566963204278;
 Tue, 27 Aug 2019 20:33:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190826233014.11539-1-lsahlber@redhat.com> <CAH2r5mvQ7YzkUjNJxC8sNCsbr-NXM9KC0tXYr2PgZ_zCR0Qu_A@mail.gmail.com>
 <CAHk-=wj=exJrhFY5vwvrhmYR-zEnoxTkS+SPV2-kc1Kp-iD-OQ@mail.gmail.com>
In-Reply-To: <CAHk-=wj=exJrhFY5vwvrhmYR-zEnoxTkS+SPV2-kc1Kp-iD-OQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 28 Aug 2019 13:33:12 +1000
Message-ID: <CAN05THS-Wtxp_hjew-qEd6YCR6rPW2hUVtaXo4gGsMkZVjsF6Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: replace various strncpy with memcpy and similar
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 28, 2019 at 11:00 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Aug 27, 2019 at 3:34 PM Steve French <smfrench@gmail.com> wrote:
> >
> > -       } else {                /* BB improve check for buffer overruns BB */
> > -               name_len = strnlen(name, PATH_MAX);
> > -               name_len++;     /* trailing null */
> > -               strncpy(pSMB->fileName, name, name_len);
> > +       } else {
> > +               name_len = copy_path_name(pSMB->fileName, name);
>
> Hmm. If you kept the PATH_MAX value as an argument, you could then ...
>
> > -               strncpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
> > -               bcc_ptr += strnlen(ses->user_name, CIFS_MAX_USERNAME_LEN);
> > +               len = strscpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
> > +               if (WARN_ON_ONCE(len < 0))
> > +                       len = CIFS_MAX_USERNAME_LEN - 1;
> > +               bcc_ptr += len;
>
> ... have used that function here too, instead of open-coding it just
> because the max length is now CIFS_MAX_USERNAME_LEN.
>
> Although I guess that case is slightly different because it only adds
> "len", not including the final NUL in the count.
>
> So who knows. The patch looks like a clear improvement, although I
> think the smb1 code could have used a helper that did the UTF16 cases
> too, because now all _that_ code is still duplicated and I'm not
> convinced that gets the final NUL any more right..

Good points.  I can do these improvements as a follow-on for 5.4

ronnie sahlberg
>
>               Linus
