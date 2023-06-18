Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39005EB64D7
	for <linux-cifs@archiver.kernel.org>; Sun, 18 Jun 2023 17:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjFRRFA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Jun 2023 13:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjFRRFA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Jun 2023 13:05:00 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC79B7
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jun 2023 10:04:59 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-62ffb475be0so20572226d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 18 Jun 2023 10:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687107898; x=1689699898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UbVgteLTK1kaVWUK7w0K9TrQ2F6c9jLElhoYIBIF+/4=;
        b=ZYCXHbiAWd/ie4pdqqXTlwiGWT74QKiGacwAwcwgKi1GvtLnFo5DgcZbeMUxLoaDDo
         N3Aqoqw01442HheOax5rXdLBzf5E5xf+ckVDhFpNr0hvQYa0njGIOdP5OOKI6wZPr6Ja
         1Oh7+t8HepDL/FJITeuMDMLXjhJLrKtZITj07o/5SN7IS56fHW7/dFvwS7vdwPuw/5qn
         Z7PV2iKS4T5Jw8jXK+V/8clQSsScccHOd60J4fshuZG6JfW4kAQvER2a2kHkC9uNYS4I
         xftCKLIwxc+gZch+JkXBEvUOZ86xGSDs9UaTLulCrlxxqTgdEiR8u+IvOpA0DJv9nlaC
         VpCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687107898; x=1689699898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UbVgteLTK1kaVWUK7w0K9TrQ2F6c9jLElhoYIBIF+/4=;
        b=T6Wv70mGUYhyKXuvbaTYhHHCmbEeDFhUihXOi4yToqUHtUechdh5ugRlf54XCd2JuZ
         Tv3AL4mTHhH2IZfz6kDkPHuknRnE1t7ylPJ977xw6tXk3YoaL4W3dBIY2POcPPxab4TA
         o1dT+Ra++fPBK61TydYXGjXg2Ki5Jem0/MTAuIWyrGB/rDDDgS1Unwj+It+lj2/9evFg
         rT/eCc9Hb3QwayQY8bT7qfne/Qb+0btBpTGKJvzjTlyspwFsq3unW3vPY5eZPg8vHi0J
         3OmTlx5NQ5koleyPoUitDNj+BndcZredxp3vQPs/TGOrz3dzAEbyYyJxobCTkX8Fbl0k
         BScA==
X-Gm-Message-State: AC+VfDyKLMU4XhEqWDbRgQGrji+la6WCU6LZ2lJpjSPsKWQjUuI2ll+w
        t20QsvzLypvJHQ6wufFkjj/t0uuJHVzu8qMUp60=
X-Google-Smtp-Source: ACHHUZ7LD1I4BoJnKvBj1mHunTomnFE50YdMFSOIxcGQR1piZ9kJugtfNBVRROa83GzCKwazcT1Zo/Y+il+uPBMd7J8=
X-Received: by 2002:a05:6214:f08:b0:623:6b1a:c5f1 with SMTP id
 gw8-20020a0562140f0800b006236b1ac5f1mr9268321qvb.4.1687107898495; Sun, 18 Jun
 2023 10:04:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230616103746.87142-1-sprasad@microsoft.com> <CAH2r5ms9MwXs3hBY=OJWRdcTH629Db4rKDGx70MKdqu71yUisA@mail.gmail.com>
In-Reply-To: <CAH2r5ms9MwXs3hBY=OJWRdcTH629Db4rKDGx70MKdqu71yUisA@mail.gmail.com>
From:   Bharath SM <bharathsm.hsk@gmail.com>
Date:   Sun, 18 Jun 2023 22:34:47 +0530
Message-ID: <CAGypqWyLyECY+UXH7Y67kOYqugN9eHoL6=oGBKX8rbSm3X14VA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: print nosharesock value while dumping mount options
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, pc@cjr.nz, ematsumiya@suse.de,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> On Fri, Jun 16, 2023 at 5:37=E2=80=AFAM Shyam Prasad N <nspmangalore@gmai=
l.com> wrote:
> >
> > We print most other mount options for a mount when dumping
> > the mount entries. But miss out the nosharesock value.
> > This change will print that in addition to the other options.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > ---
> >  fs/smb/client/cifsfs.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> > index 43a4d8603db3..86ac620a9615 100644
> > --- a/fs/smb/client/cifsfs.c
> > +++ b/fs/smb/client/cifsfs.c
> > @@ -688,6 +688,8 @@ cifs_show_options(struct seq_file *s, struct dentry=
 *root)
> >                 seq_puts(s, ",noautotune");
> >         if (tcon->ses->server->noblocksnd)
> >                 seq_puts(s, ",noblocksend");
> > +       if (tcon->ses->server->nosharesock)
> > +               seq_puts(s, ",nosharesock");


Reviewed by Bharath.
