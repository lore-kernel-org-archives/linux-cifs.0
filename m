Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA11BC433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  6 May 2021 13:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9499A613F1
	for <linux-cifs@archiver.kernel.org>; Thu,  6 May 2021 13:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhEFNly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 May 2021 09:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhEFNlw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 May 2021 09:41:52 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749DBC061574
        for <linux-cifs@vger.kernel.org>; Thu,  6 May 2021 06:40:53 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u16so5508618oiu.7
        for <linux-cifs@vger.kernel.org>; Thu, 06 May 2021 06:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=35ROrp+RGUnvL/gfdGk5xVg0jL6Leh3OqdiWYgPyTvs=;
        b=SbCk1u4TaWZDg1fBOYjvnFb4TmHJzYrzFhV03NXjsm71zPpAHJcz6Fxx+Nhw3+f7gM
         BKspX1PauBLCsnhRpSqFFHj8GuvjhY5hU1p/IJvkGTntcv6Z6DFpZbvG3uWHRSLb6iIh
         uPt3lNPY+T4S2lWiHpqw+ykgJWwV+0cFCCd+BuUlAFh3dwUTP2uOFSuVWQb1RaD0Hfwr
         p+kmrYmswQEooRCZlnBQGUhktuJE4j5FciQR5Gu8K+Qdttt97o6x4r6RyheCEjKxlV8U
         iFw5b5rB67ZhwXo1mvx9BVfwmXnjPYUAfIz+KhJhHsra5gw27WfhvVYFNRCo4v+Uajea
         C5zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=35ROrp+RGUnvL/gfdGk5xVg0jL6Leh3OqdiWYgPyTvs=;
        b=aXc/XJB287GQilgQHpbZENIXHnot075X+5PmQM1BvhCtFIl2K0w3SGfqulnC5tNu/e
         JSsW45UTtbR/YUNZd/jpzB8sf41UCWteqy+1PFrC5ni6RG1fQnmbFHSLsn38OWYHm0ZS
         Ovc2iJbN7btK6n97Eve9arzR/FOVkmnQVn7WJaFZGDVnHNBP4CRbbeCRG5zAT+CxOZqf
         nb8n6cRgDEUrRIDfftIe5r8A4zeCV/PbtXK23d+aafs4w0av8QV6miMmA34wRNETAQuI
         d2wvdn2GvHZhiK2G/NfWQ9I9Hyi0Mz3f83zw5t6IiDCDVVJSdFNjup6PfYbzGGXixWX0
         tWiw==
X-Gm-Message-State: AOAM532SVjOfYOKXHe7hZq3/QBYeTn04Q7+l0n5OTA4xVQ6no2cY/jbM
        0L8cFNQ90/k+KXSP0VyOEjCisunHE73cSn4ECN0UM97cAdQvS1np
X-Google-Smtp-Source: ABdhPJxqXkr8Axn1EiGeTMzrNT0Omi1jk7V/BSKobsdUxpgoKzhtBSkpj/CwOWg8A4+U226vYB93jTAi8hc5qlejZvo=
X-Received: by 2002:a54:4f07:: with SMTP id e7mr3210013oiy.140.1620308452890;
 Thu, 06 May 2021 06:40:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAEVyU88zhTKVrbk-+YCrd4fTN=za8906CwFFGzDk0OovSD4=QA@mail.gmail.com>
 <877dkcuj8k.fsf@suse.com>
In-Reply-To: <877dkcuj8k.fsf@suse.com>
From:   Calvin Chiang <calvin.chiang@gmail.com>
Date:   Thu, 6 May 2021 15:40:42 +0200
Message-ID: <CAEVyU89=egaEAdvCD=FVkLwP4akzY3y8q=0hFW-hSryq0sxnxg@mail.gmail.com>
Subject: Re: Unable to find pw entry for uid
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hey Aurelien

aweseom thanks for this!
>You should try to attach gdb to the cifs.upcall process

stepping through with a debugger was the "next level" i was thinking
of attempting but couldnt work out how to get GDB to hook into the
process.

one more newbie question:

I guess after i make the change in the cifs.upcall.c file i need to
autoreconf /config /make /make install ?
is it correct that this will overwrite all the files from the
cifs-utils package on my machine?

Cheers

On Thu, 6 May 2021 at 14:42, Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>
> Hi Calvin,
>
> Calvin Chiang <calvin.chiang@gmail.com> writes:
> > Now oddly the strerror(errno) is actually returning SUCCESS
> > But the pw =3D getpwuid(uid); is failing.
> > Getpwuid(uid) is calling nss.
>
> ...
>
> > and the output from the sssd_nss.log is:
>
> ...
>
> >     (Mon May  3 13:05:12 2021) [sssd[nss]]
> > [cache_req_search_ncache_filter] (0x0400): CR #114: Filtering out
> > results by negative cache
> >
> >     (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_ncache_check_str]
> > (0x2000): Checking negative cache for
> > [NCE/USER/cyberloop.local/alice@cyberloop.local]
> >
> >     (Mon May  3 13:05:12 2021) [sssd[nss]]
> > [cache_req_create_and_add_result] (0x0400): CR #114: Found 1 entries
> > in domain cyberloop.local
>
> I don't know much about sssd but if it's finding 1 entry in the
> *negative* cache that means it knows it doesn't exist. (I'm assuming
> negative cache means cache of queries that have no results)
>
> That being said I've had issue with getpwuid() before that were solved
> by updating glibc. Could be totally unrelated to your problem though.
>
> You should try to attach gdb to the cifs.upcall process. You can do this
> by adding
>
>     syslog(LOG_ERR, "my pid is %d", getpid());
>     sleep(5);
>
> in cifs.upcall.c before the getpwuid() call. Then try triggering the
> mount. It should block because of the sleep(). In a different terminal,
> look at your system journal for the PID, and run gdb -p $pid. From there
> you will be able to step into the getpwuid (glibc), nss, sss, calls.
>
> If your linux distribution has a debug symbol server setup for gdb to
> use, gdb will dynamically fetch symbols and source code on the
> fly. Otherwise you will probably need to install debug and source
> packages for glibc, nss and sssd packages to be able to see function
> names and source code in gdb.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
