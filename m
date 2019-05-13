Return-Path: <SRS0=ZeIh=TN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC67C04AA7
	for <linux-cifs@archiver.kernel.org>; Mon, 13 May 2019 20:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 541E92085A
	for <linux-cifs@archiver.kernel.org>; Mon, 13 May 2019 20:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qzytrqHk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfEMUNw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 May 2019 16:13:52 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:40569 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfEMUNv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 May 2019 16:13:51 -0400
Received: by mail-pl1-f182.google.com with SMTP id b3so7020984plr.7
        for <linux-cifs@vger.kernel.org>; Mon, 13 May 2019 13:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=boi9NL6iSAzONGdXr76d7hDZm3DbVMV/BBfhBy+eMyM=;
        b=qzytrqHk7QCh/U9d0ETDI+K7oPTN3GhrHJ517iEujR4is77IJp32YBwi0iyc5O1RJe
         vNESXeKnm2bzchZwNsFLD8FmNCw7loCoJmhZLBzWwk+2+mpfSh+52BlgM+CNk11uWJBZ
         Ky/XiS52I4wT8latd2iJIv9mOHhoe/PflgTqg0DDzc7oqIQtGTBD7RzS21Ej6KJL8LHI
         phXt5MAfER28l6VQJ8P2VAzYrEZWUSf9MRI3zGrUUkslYPZ5TvCxJqP188nc2ezbmM2G
         IsnasKJq1yqFTzM9MOue8L2RFgcTmVC/iOZp7PUNRC8nu1l4O6maRfjMe65LT+z4+Kbq
         oEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boi9NL6iSAzONGdXr76d7hDZm3DbVMV/BBfhBy+eMyM=;
        b=qBi58MGt6QhLGtnpRQp7ds9yZXi2aCNZ0RqAqY9aJXG7a7DYbpxAN7CRnaUjenKLPO
         wO75WCff3r3ka9jDnR7zdnsY5dptEpS4QxEEBqq+5VSIkvfZ4Itb3r8Cvq6KRbw5jW1L
         Pe+/FEcbwlA2NrSZdWK64UkzQ1Z5Tv44HDcT36ezBTrbEjn7jZB1IDS6K9eKAYIUh9m6
         22TJZbtoLJRXlIBZicRHKpBW/mPx9YByxTtEiHOgYX8CsyiKt2R0IkLF8XSpJ80AhzMJ
         WA7JtebpCstn0A54OKCZ+V1ZeRBxthClP2RMf4OlzODzEikmZBqf6vDbg3Zb3gTZXLir
         ckBA==
X-Gm-Message-State: APjAAAWcAiOFwDe0TKJz7+DKkmLMZqiDNt7C9imuLCTlfuPoECNqc6QH
        jcfBFwQ4odGqyQMd0BM0YRHyceg8EFHEIjvlwmM=
X-Google-Smtp-Source: APXvYqxHMpNg7SQWZb67+kg1AXSqM4Ax1NS8i5mu0NhvE4EeMpMiv6wjhS3S3385eP0HeFCQj93U5BocjkvJkIChXz4=
X-Received: by 2002:a17:902:2beb:: with SMTP id l98mr31528634plb.290.1557778430736;
 Mon, 13 May 2019 13:13:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190510043845.4977-1-xzhou@redhat.com> <20190513143413.GA4568@dell5510>
In-Reply-To: <20190513143413.GA4568@dell5510>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 May 2019 15:13:39 -0500
Message-ID: <CAH2r5mvSS4crgid-srKr+hycN=uW-vPLGhF81RvA6UBP2T7K4A@mail.gmail.com>
Subject: Re: [LTP] [PATCH] safe_setuid: skip if testing on CIFS
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Murphy Zhou <xzhou@redhat.com>, ltp@lists.linux.it,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also note that we are working on patches to improve saving of mode
bits and ownership information even in cases where the server does not
support POSIX Extensions.

Currently mount options cifsacl and idsfromsid can be used for some
use cases but they are being extended.

On Mon, May 13, 2019 at 11:04 AM Petr Vorel <pvorel@suse.cz> wrote:
>
> Hi Murphy,
>
> > As CIFS is not supporting setuid operations.
> Any reference to this?
> fs/cifs/cifsfs.c and other parts of kernel cifs works with CIFS_MOUNT_SET_UID.
> Also samba_setreuid() from lib/util/setid.c from samba git (I guess used in
> samba libraries works with SYS_setreuid syscall or setreuid() libc wrapper.
> What am I missing?
>
> > diff --git a/lib/tst_safe_macros.c b/lib/tst_safe_macros.c
> > index 0e59a3f98..36941ec0b 100644
> > --- a/lib/tst_safe_macros.c
> > +++ b/lib/tst_safe_macros.c
> > @@ -111,6 +111,7 @@ int safe_setreuid(const char *file, const int lineno,
> >                 uid_t ruid, uid_t euid)
> >  {
> >       int rval;
> > +     long fs_type;
>
> >       rval = setreuid(ruid, euid);
> >       if (rval == -1) {
> > @@ -119,6 +120,13 @@ int safe_setreuid(const char *file, const int lineno,
> >                        (long)ruid, (long)euid);
> >       }
>
> > +     fs_type = tst_fs_type(".");
> > +     if (fs_type == TST_CIFS_MAGIC) {
> > +             tst_brk_(file, lineno, TCONF,
> > +                      "setreuid is not supported on %s filesystem",
> > +                      tst_fs_type_name(fs_type));
> > +     }
> I guess this check should be before setreuid() As it's in safe_seteuid() and
> safe_setuid()
> > +
> >       return rval;
> >  }
>
> Kind regards,
> Petr



-- 
Thanks,

Steve
