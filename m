Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE91C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 09:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB62D64E90
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 09:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhBYJm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 04:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbhBYJmM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 04:42:12 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A96C0698DA
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 01:33:58 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id c10so4330299ilo.8
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 01:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atS+6z0q77U4wFZOsjvxrTzG8Hq0xK3sBns9gBoqHJ8=;
        b=htHqj3ogDOj0J40UoKhF30pP7xNSk76Gl5/e+YsUXY2m9phxqUoOPFaG/OR8FGM532
         kOPA0mB2QO4gQ/DK04R3QwT+g2r2uJ5pQ2PNLmoC6jnlb7kxTT5jTr4wqRyqTZuWfc9O
         e8V2k+LzSd0vaX3C2QB6GtZGp65Zvq8Ghryt21Y54c5aXgipT6GMrSvC9KbKu4/aJTXC
         YFSGEgtgPnChuQU1CXBHjIwWM3wJ5y4dm/sOolAv3wzQutOBCgU3qamgrMHrGB186FPr
         4rwDbJkQDrJ1SsbkL08prvpw1rg2+vTnyMrKPqXAguGjF7NKhJrw0P+EyY2JpF81EpHD
         DLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atS+6z0q77U4wFZOsjvxrTzG8Hq0xK3sBns9gBoqHJ8=;
        b=ZU8D+i7pRLPFfZSjWVAD3IoUGQns474Zr2zkbPI/yL6SqnBD5At/dm5A0NB2j6Chu5
         uQsjLoeC5ul6A87TjjgniOLSnzUCs5TcQ6Lcu54ofe+K9rgHSagvjXF1o+83WwgqIMc1
         Jjm5/BEV5jJCNT0LufAO84GtAU6xkq6EOHMarNUxiIt3M7+n/+otJntGitE5tRp6Eu8n
         O3+Ye5aK0M2PlI46T4ZVMQ/kaFAws8VUVm/GJpVlSzYLZ3UJxgya8Fr2p3GoelEiQ6ZE
         Nn/C8LijSSLZg/ZqPx4yTtf86bemBSTqs0Wo67CDv+B+IejlVpKlIo1bBqq6OlfyGcmb
         G/Ng==
X-Gm-Message-State: AOAM533vCt2vlucWUvwsdIHgh1eStzIa97M0CkJadgt0ynNa1goMgmiy
        9mB69HkMIUNG2sUWZ/uz+gnoFMah0Tv213lsR2c=
X-Google-Smtp-Source: ABdhPJzeCEBkthoWemBVuSOWqc0tOfZ41rQIiHIvEbgdj7leFbTDTUAwQ+y6HBSk638JVu3tfdGqzft+L3ZV2ghrmng=
X-Received: by 2002:a92:ce4e:: with SMTP id a14mr1779857ilr.219.1614245637600;
 Thu, 25 Feb 2021 01:33:57 -0800 (PST)
MIME-Version: 1.0
References: <0736dea6-ab54-454d-a40b-adaa372a1f53@www.fastmail.com>
 <CAN05THRTEXjZ+TQB+X2kA_i8CgKctBDB1UhbifAu0WzqHOuNmw@mail.gmail.com> <cd9f90aa-53f0-43a2-9683-b5730d01ca90@www.fastmail.com>
In-Reply-To: <cd9f90aa-53f0-43a2-9683-b5730d01ca90@www.fastmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Feb 2021 19:33:46 +1000
Message-ID: <CAN05THQfXstKOvVMN-KGBk6bdkUaQCa_4CY9o5oXn_qDhdW9-w@mail.gmail.com>
Subject: Re: Using a password containing a comma fails with 5.11.1 kernel
To:     Simon Taylor <simon@simon-taylor.me.uk>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Feb 25, 2021 at 7:18 PM Simon Taylor <simon@simon-taylor.me.uk> wrote:
>
> On Thu, 25 Feb 2021, at 7:37 AM, ronnie sahlberg wrote:
> > Hi Simon,
> >
> > Looks like the special handling of escaped ',' characters in the
> > password mount argument was lost when we
> > switched to the new mount api.
> >
> > I just sent a patch for this to the list,  can you try that patch?
> >
> > Thanks for the report.
>
> Hi Ronnie,
>
> Thanks. Your patch resolved the issue.
>

That is good to hear.

Steve,  can you add a Tested-by for Simon and maybe we should have cc
stable so it gets into 5.11 ?


> Regards,
> Simon
