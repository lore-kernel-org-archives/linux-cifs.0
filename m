Return-Path: <SRS0=yoc9=RJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F24C43381
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 02:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562CB20675
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Mar 2019 02:15:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsreNnLz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfCFCPd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 21:15:33 -0500
Received: from mail-lf1-f48.google.com ([209.85.167.48]:40297 "EHLO
        mail-lf1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfCFCPd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 21:15:33 -0500
Received: by mail-lf1-f48.google.com with SMTP id a8so7708749lfi.7
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 18:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wmbKxK6Ab2itu8YlNix7kjF+lyqmYVzUUO5WcZubwI4=;
        b=LsreNnLzxfEuZh1xSbX845taLXAfrwUscOX9oo6ZLqenWCbD3Nqitwa2CYEaCnV4s2
         d+fT5AmLDJipOpS2TwnYm0I8XUmIMmZRPrIM80rSi2PCOsWxQfgmgFBi6FbjWXd4BBdR
         veGmjIw9rnGPP6vx6o5jaC/DC01viISS70XBZeBoxi5BX/VvTIciIeXUGO2SotM9dbhZ
         lMSFB+OqG9mR3yKp3uOgy0p8jll1uWp0ZESGaDxphdyXZkfKa6U7KhAl7hK1s1sV5J5v
         9eWsf7eZZIHGkIr/DxlVVmWQXX2pE/nfcC40Yk71lIGUoZdwe3iBfV87QgiCeL1v8Z9n
         DlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wmbKxK6Ab2itu8YlNix7kjF+lyqmYVzUUO5WcZubwI4=;
        b=YMT4sxgrXqcnFZnHgn1fvlTpygzqM8GdLjBEUVZ4RkJQn2j4wXBn7v/z8EWXlTGqHX
         zcrKmutKbKOl2vpXkRrIwU1ssYFXoNpdMbZybNLO26hxbL2KdQx/TJs5He2LuD8TzVOk
         Pu3E3pQdfou9yUSAHBqcwh0Gxkc7WEJwstUzze4lFLuHLoiK0bROti3Rz0lkd6bnPaOo
         gyx8+jKf7lWTfGFo1Ctda5W5BSwyqBSLyEv1aVDL/gc6+a9qbc3otpypPrVtbcVF4MqY
         YSewy9r7CMQh2dtokFh5HbD4UNF2kxZmnNFbAs3XPwbC5S6z/KOqpi/PUCVMSYtOHXSi
         TrUQ==
X-Gm-Message-State: APjAAAVfGJ2xoi9kCguQD7kEK+zXWSxIcWK85AudfRfKIkcPVOSzZm/r
        B6eHEYFlauWoKDD3k7HAim1s75ZdFJ0bnCBGpfsm
X-Google-Smtp-Source: APXvYqy2zQSjVCGM4clL7kbtsn/y8M5LJkWAEtcOuPp0MYuzuoGZ3G1L/aFujWFp0sZlGkArGP7NxFT4jo3ODuUHsYU=
X-Received: by 2002:a19:520e:: with SMTP id m14mr2430107lfb.64.1551838530225;
 Tue, 05 Mar 2019 18:15:30 -0800 (PST)
MIME-Version: 1.0
References: <20190220061145.28241-1-lsahlber@redhat.com> <20190220061145.28241-2-lsahlber@redhat.com>
 <CAKywueQEnaPfdCBRz4AJk8FAFDTfr5UC60wiM=7av3f9U050=A@mail.gmail.com> <CAN05THRN=QaC_taKTHyVF8m=bJPLtQCgBe6_qnhhXzWUh=p_Hg@mail.gmail.com>
In-Reply-To: <CAN05THRN=QaC_taKTHyVF8m=bJPLtQCgBe6_qnhhXzWUh=p_Hg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 5 Mar 2019 18:15:18 -0800
Message-ID: <CAKywueQDpS8h236Kw4YD14Qq8c=u68Fp4eGDQ7CRwRiHF7_Qnw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: change wait_for_free_request to take number of
 requests to wait for
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Jeremy Allison <jra@samba.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 27, 2019 at 09:12 PM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Thu, Feb 21, 2019 at 11:39 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
> >
...
> >
> > Waiting for more than one credit without a timeout is a source of
> > possibility to be stuck. We already have 'timeout' argument which
> > contains some part of flags passed to transport layer from PDU. We
> > might consider renaming 'optype' argument into flags and use 'timeout'
> > with its true meaning - timeout of the waiting for credits.
> >
> > Once implemented, we can define some default period of time which we
> > can *afford* to wait for credits and then fall back to sequential code
> > if we timed out.
> >
> > I also suggest to add another function wait_for_compound_credits and
> > make wait_for_free_request calls it - doesn't require changes to all
> > the places where the latter is being used.
>
> Thanks, I am reworking it and will resend shortly.
> Passing flags down into these functions instead of timeout/optype
> makes sense and I will do that.
>
> I am not sure we need to add a timeout to represent a deadline after
> we return -EAGAIN or similar.
> But for sure we need to prevent waiting atomically for >1 credits to
> block forever.

(adding Jeremy to comment and cc'ing samba-technical)

Thanks for taking a look at this.

If we don't set a timeout on waiting for several credits at once, we
may end up waiting forever. It is only a matter of what is a
possibility to be stuck. We can try to guess if the server is going to
grant us more or not in future by analyzing the number of requests in
flight or other parameters but we can't say for sure because the spec
doesn't say anything about minimal number of credits. This means that
under certain conditions the server may end up giving us a very few
credits that won't be enough to do compounding.

Those conditions might be different but from the top of the head I can
give an example of a highly loaded file server with thousands of
active connections that experiences CPU and/or memory pressure and
decides to limit the number of credits per connection. That's why I do
think that the ability to set a timeout on waiting is essential. We
can start with something between 100ms and 1s (and even making it
auto-tunable - let's say a couple round trips to the server) and then
decide what is the best (or even make it configurable).

> This could happen in two scenarios, the first would be if the number
> of free credits are persistently pegged at <=1 credits
> due to persistent and massive number of threads causing single credits
> SMB2 I/O.
> I.e. we are constantly starved for multi-credit requests.
>
> The second would be if we get stuck at <=1 available credits even when
> the session is idle.
> This would be a bug and the best is probably to let the reconnect
> eventually happen and thus force the credits to be in sync again
> between server and client.
> So I don't think we need t do anything explicit for that case here.
>
> The first case is a genuine case, but I think we can handle that in a
> different way instead of switching back to a "grab one credit at a
> time" like we have now.
> In that scenario we would have a different problem that is  there
> could be so many concurrent calls for compounded operations requiring
> >=3 credits each
> that we eventually consume MAX_CREDITS number of credits across these
> threads. Each thread having already allocated one of more credits less
> that it needs for the full compound
> and the the threads are now all deadlocked each waiting for one or
> more credits that will never become available.
> Making the allocation of credits for a compound allocate all of them
> atomically solves this type of deadlock, but would be prone to the
> credits starvation issue.

The approach of grabbing one credit in a time was a temporary work
around that didn't require a lot of code changes and was easier to be
pushed to stable kernels. There are no doubts that it left a
possibility to be stuck and we need a proper solution to handle
compound requests.

> The way I propose to solve the credits starvation problem for
> compounds is something like this (I haven't coded it yet so I dont
> know exactly what it will look like)
> * After the session has been fully established, we should be able to
> assume we WILL have a whole bunch of credits available.
> Modulo a hypothetical situation where the sever will just never grant
> us more than 1 or 2 credits in total. I don't think this is a
> reasonable situation we need to worry too much about and maybe the
> right thing to do here is just to block all compound
> operations until we get a session reconnect where hopefully the server
> will be more reasonable.
> * We can define a new MAX_CREDITS_FOR_COMPOUND which would be the
> largest number of credits that we will ever create a single compound
> for.
> I think that would be 4 at this stage.

Note, that we reserve 1 credit for echo request and 1 credit for
oplock/lease break ack, so those operations won't be stuck waiting for
credits. If the maximum number of requests in the compounded chain is
4, then 5 credits granted by the server will make our client useless
for certain operations.

> * In the loop in wait_for_free_credits(), If this is a request for a
> single credit AND iff it is a normal operation, i.e. &CIFS_OP_MASK ==
> 0
> then we will NOT grant the single credit but continue looping.
>
> I.e. basically reserving the last MAX_CREDITS_FOR_COMPOUND credits
> before we completely run out to only be available for compounds.
> That way we do guarantee that compound requests will be making
> progress and will not be completely starved by non-compound requests..
>

Trying to reserve MAX_CREDITS_FOR_COMPOUNDING increases latency of
single-credit requests. In some workloads compounding won't be even
used (let's say it is pure IO workload), so instead of using all the
bandwidth available to the client (and the credit bandwidth might be
pretty narrow for highly loaded servers) we will end up using only a
part of it.

But it is not only about latency of a single-credit request, it is
also about latency of a compounded request itself. Instead of waiting
for all the credits for a long period of time we can start making
progress by doing sequential operations. If the round trip time is
small, the penalty of indefinite waiting instead of going sequential
will be rather substantial. That's why waiting only for some
reasonable period of time seems like a good option to try: if we have
already waited for some reasonable time, let's stop waiting, return
special error code and let the upper layer process the request
sequentially.

So, I think that compounding is a great optimization and it is
important to try using it as much as possible across the client code.
In the same time, the SMB3 client should be capable to handle any
workload or scenario that doesn't contradict the spec.

Thoughts?


--
Best regards,
Pavel Shilovsky
