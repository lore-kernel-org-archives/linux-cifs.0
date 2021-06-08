Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495B9C4743F
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 21:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B616128E
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Jun 2021 21:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhFHVI3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:08:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhFHVI3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Jun 2021 17:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623186395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qikh23JQj0rOROM36I+xJmZ0dRjFa9wyjTVsnQCQJc=;
        b=Z6Q+clfw7smvInX7AwswK2iYmbvesS0Oxdx8bAMxghV5kYssW2rzTXPYaEaSuLUuH/RW2u
        VOQTcBeaqO1xHYbd3ClxjjtQaRO5U3FHSvKyoO2A3CWREEoMbTAlEGPucWu8GqNxiZZIYy
        inzYzhVjthd+PQPsrPLoSktLsOiCHLQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-y6ELecgBMayC74OjwvdGew-1; Tue, 08 Jun 2021 17:06:31 -0400
X-MC-Unique: y6ELecgBMayC74OjwvdGew-1
Received: by mail-il1-f197.google.com with SMTP id z6-20020a92cd060000b02901eb52fdfd60so7153481iln.14
        for <linux-cifs@vger.kernel.org>; Tue, 08 Jun 2021 14:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7qikh23JQj0rOROM36I+xJmZ0dRjFa9wyjTVsnQCQJc=;
        b=JQH+5TOsWA0oRRIBpq9G5ku5wsu+TEJPsATNF6NhajWfn5rqU/KyFRtDUaK9FfB3Oz
         a150xCcEuYz3adONEtFC+TuxINanaeXVwXHKx+s5r21/ggoP0KK5xP0ai0L8IZ8D9ynY
         xxdB2u+Tjon0xXu48N4PgATWZ0l0v3BmisdTmMpO2Wj43uM9u2j0irRzA6d9wsQlYwOV
         bb68w94JLhewPgIkF8f2ZWtABDi33mw5J0+jTVaDzzMumxqe3ejZ/bpgP40QYv0zYPDT
         kEs1hOj+MvgPSw5sutamtkzIVZt0/gLUYsg4tXl0zyXlKoR6F6NgltlfW/SHXA9RYI/E
         bCAg==
X-Gm-Message-State: AOAM530UyEpFdc+5zU0pqq4C6acfQN/KOlMVskQzCZuh5FkEiOJPzv+A
        InaV6WDND3XE0CSUbGfnF1MBsDjK37CZd9Z6REDxBof654OG6/Xd7I+1KUanrv+05iYOnvdsINx
        AQuyxOKg31ixP8mIpnpXytEbM49UJyy0yuDeKBw==
X-Received: by 2002:a92:c705:: with SMTP id a5mr20822431ilp.36.1623186391213;
        Tue, 08 Jun 2021 14:06:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPlJ3clujIQ13+n5JELKQhbjZ0YSViAsoCnIB1CIWy/ekJ0Gr0mf1G/mdwsIQlBaMZ/VjAhfKUDPJenEOXaXU=
X-Received: by 2002:a92:c705:: with SMTP id a5mr20822396ilp.36.1623186390733;
 Tue, 08 Jun 2021 14:06:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAK-6q+hS29yoTF4tKq+Xt3G=_PPDi9vmFVwGPmutbsQyD2i=CA@mail.gmail.com>
 <6b4027c4-7c25-fa98-42bc-f5b3a55e1d5a@novek.ru>
In-Reply-To: <6b4027c4-7c25-fa98-42bc-f5b3a55e1d5a@novek.ru>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 8 Jun 2021 17:06:19 -0400
Message-ID: <CAK-6q+gm0C2t50myG=qNJMOOBnM7-UjfNMHK_cyPdWY5nSudHQ@mail.gmail.com>
Subject: Re: quic in-kernel implementation?
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     netdev@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, smfrench@gmail.com,
        Leif Sahlberg <lsahlber@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Vadim,

On Tue, Jun 8, 2021 at 4:59 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> On 07.06.2021 16:25, Alexander Ahring Oder Aring wrote:
> > Hi,
> >
> > as I notice there exists several quic user space implementations, is
> > there any interest or process of doing an in-kernel implementation? I
> > am asking because I would like to try out quic with an in-kernel
> > application protocol like DLM. Besides DLM I've heard that the SMB
> > community is also interested into such implementation.
> >
> > - Alex
> >
>
> Hi!
> I'm working on test in-kernel implementation of quic. It's based on the
> kernel-tls work and uses the same ULP approach to setup connection
> configuration. It's mostly about offload crypto operations of short header
> to kernel and use user-space implementation to deal with any other types
> of packets. Hope to test it till the end of June with some help from
> Jakub.

Thanks, sounds interesting. Does this allow the kernel to create a quic socket?

- Alex

