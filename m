Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E25DC4320E
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 17:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29CA660FDA
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 17:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhHZRQb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Aug 2021 13:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbhHZRQb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Aug 2021 13:16:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7884BC061757
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 10:15:43 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id x11so7998724ejv.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 10:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K6bSFB4nxADhB8ty9onWCoYUwJpc69tnhaaKDUDCZqA=;
        b=d9wxWIyXCRYmLbZC7/UX6OFXBR5p9oqtswnF4NfHLwPeJqsawBcnkcD7nJZeneriKW
         SruFCdo3/W4ma1sqKOeoQ/20zqmyB3ZPayfQKmVL6Zns/TVp9OrZZSvktpGVlP0qC42z
         dJxKqMyVCckX09c4eXCZuwuHEUzsP17cf0JhIVcPo5nxxWHdwnQdgADpuBDUNIkXhxix
         KL6kCbuxf0Adk91pU7QnlPWNaNj2uvh6LuBTikL42aqQde+idxrIAAtLR83pOQ4i2Zax
         GG6Hz+wkE9Y1VkRhvAsy/n35Df7sl6OQ4QGcZaT3GTDQfgsZzvlfD8ScvGQwQczFArAY
         ej9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K6bSFB4nxADhB8ty9onWCoYUwJpc69tnhaaKDUDCZqA=;
        b=EwqZLJ4yS4NMte9jSgNsUS6Ni7GVKgA17jhKsdMx+emHWyflZPNuuLTcYz4YusXePp
         gCTU0i2UvftM3zxl7/Oj+N4vD3LeyuNp7dgdTldq7YAMS98dE5RJVVZQRe0y5cbcKU+5
         Binp9QaXYNX6Kp0HJGsjdcBfcpLXCfVLtAT02UyvTRwI3Zvgk7g+WdNulqoF+/mY7VTQ
         dbDF2WmUlk4J5RXA3jpu5qDqgtnaLaj6RxReLZtol7eQmiQsvTsrNZsX3Oyb5T66PMIL
         pbk6J1CNSwxbY5qDsYmizOb/hDGPtegDRW4py7c9YMGPZwDD8Jomg5R8fu63h9fwD1PW
         fVwQ==
X-Gm-Message-State: AOAM530MJ3IY4isZAqPT5pUNHJ9w1Po00twNPBVq/HtjNj3UH0DF2VP7
        OH/VHrdF5OeEnUqUN1fK6Z7xIN7x/yuc+VFKRBtSAI9oCNHy1Q==
X-Google-Smtp-Source: ABdhPJxB5fnMZVKuEeyc+uRtMqNqRWuT57UQMrXrDJZcgFiev/bq0H2sumWusrW/zKbkSxyK4rWrp6rvO6+nAbVtRU0=
X-Received: by 2002:a17:906:aada:: with SMTP id kt26mr5448867ejb.199.1629998141870;
 Thu, 26 Aug 2021 10:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210825111656.1635954-1-lsahlber@redhat.com> <20210825111656.1635954-2-lsahlber@redhat.com>
 <CAH2r5ms2KzVf-7ei2+m_GbwcvZ7PHTCbv33bhNaH9dXXWcVO1w@mail.gmail.com>
In-Reply-To: <CAH2r5ms2KzVf-7ei2+m_GbwcvZ7PHTCbv33bhNaH9dXXWcVO1w@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 26 Aug 2021 22:45:30 +0530
Message-ID: <CANT5p=pU449WrEOpC5iGSrZAMqmM223vZSwxfLf51pN9=B0Sng@mail.gmail.com>
Subject: Re: [PATCH] cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Aug 26, 2021 at 2:39 AM Steve French <smfrench@gmail.com> wrote:
>
> lightly updated to add short sleep before retry
>
>
> On Wed, Aug 25, 2021 at 6:17 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > RHBZ: 1994393
> >
> > If we hit a STATUS_USER_SESSION_DELETED for the Create part in the
> > Create/QueryDirectory compound that starts a directory scan
> > we will leak EDEADLK back to userspace and surprise glibc and the application.
> >
> > Pick this up initiate_cifs_search() and retry a small number of tries before we
> > return an error to userspace.
> >
> > Cc: stable@vger.kernel.org
> > Reported-by: Xiaoli Feng <xifeng@redhat.com>
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/readdir.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > index bfee176b901d..4518e3ca64df 100644
> > --- a/fs/cifs/readdir.c
> > +++ b/fs/cifs/readdir.c
> > @@ -369,7 +369,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
> >   */
> >
> >  static int
> > -initiate_cifs_search(const unsigned int xid, struct file *file,
> > +_initiate_cifs_search(const unsigned int xid, struct file *file,
> >                      const char *full_path)
> >  {
> >         __u16 search_flags;
> > @@ -451,6 +451,23 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
> >         return rc;
> >  }
> >
> > +static int
> > +initiate_cifs_search(const unsigned int xid, struct file *file,
> > +                    const char *full_path)
> > +{
> > +       int rc, retry_count = 0;
> > +
> > +       do {
> > +               rc = _initiate_cifs_search(xid, file, full_path);
> > +               /*
> > +                * We don't have enough credits to start reading the
> > +                * directory so just try again.
> > +                */
> > +       } while (rc == -EDEADLK && retry_count++ < 5);
> > +
> > +       return rc;
> > +}
> > +
> >  /* return length of unicode string in bytes */
> >  static int cifs_unicode_bytelen(const char *str)
> >  {
> > --
> > 2.30.2
> >
>
>
> --
> Thanks,
>
> Steve

Hi Ronnie,

EDEADLK is returned in wait_for_compound_request, when num of credits
is 0, but there are no in flight requests to get more credits from.
Why did we reach here in the first place? If we already found
STATUS_USER_SESSION_DELETED, why are we waiting for another request?

-- 
Regards,
Shyam
