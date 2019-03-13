Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66D9C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 05:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E199217F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 05:38:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XbxnaBcE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfCMFig (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 01:38:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34063 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbfCMFig (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 01:38:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id k2so589365qtm.1
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2019 22:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FHc20TygElVCBxqBs4cwi1IRkNsGDYQPoqAEOnVPNd8=;
        b=XbxnaBcEhkZ9uDRcmEAZAXWtCB79aI+/R+/zwR301Q7U2B5G7xak5AsCaS7DNcWjnx
         24SMHBG1AWiE/nm2qrSgvHNpDZq2xYtXKbRtxbT21KMj0Z9S4j9sjh6HQ8pa84ovP83f
         faaVOijLfwxO8ZZun8Y+7i45JR47d6ukp/qFFPUkZaiJQYx+R37bo7oN5mYPrM8YIgYN
         vZaAnbUib89TGmmOAlqJ6eILfiInyYzrRd5m6XF/HXpcddZAqMDE7pUQLMHd/Kn7ISal
         M2nwPxIGlpQRxD3lzPeoAR7zVV17Ajz9dioQRrWe+Qk/VUCLYTu3HL+U45ADUHUoMQxF
         oHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FHc20TygElVCBxqBs4cwi1IRkNsGDYQPoqAEOnVPNd8=;
        b=cnmZs2Jaa11pOii8M1wdG0Fq7A6sku4y0I7RtDgw9UEO/7F9bjDxtnQybuwJJJ/hpJ
         jV16bzX5fGeFXw+w7lrUrbDQ5K6wUC6QrLeU3OxZlS98wrKUJaAc35uesHr80hVmbmzU
         PGv4FNLQYFxWJlJMNZ+G78p2/Vun9h7SHyAiiJhzNsRKafM9hmc4PyomYq6puvipMSWc
         VTyTQQQUT3ptyKiRqwsTEZVcxTB1+5LD/iRPZs0syAbU+bjoq8QLcWveBZPAorAiVro1
         5XTUdzJFKKz44BJwJo1NPk2UPe/NBMCr5sU3qIGMmQqhFPhoaHAavZIeQdwlFLVhyq3T
         sZ3w==
X-Gm-Message-State: APjAAAVQF7DZ3wnllRLmdWVvEHpo+hxL93Tl3w0DRLWqC5IYbup8ovDY
        HlEim9VsqpHnVnuQDKb8AOoK9Co99hQT8kpRmyA=
X-Google-Smtp-Source: APXvYqyHNCuFYbUiWQNzECcY4oI1hOPW+Kmo1L4XKDRuDbb2epD8y4SpSClwVw/0O4xZtp5uitm0lxGnjf9XTeENorA=
X-Received: by 2002:ac8:7642:: with SMTP id i2mr17373560qtr.287.1552455515470;
 Tue, 12 Mar 2019 22:38:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
 <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
 <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
 <CAH2r5mv2Cp8YseCF1rz0dH8tvPYZ1+dCykupzVv_S81f2gPMJg@mail.gmail.com>
 <CAN05THQt3se9xsbhKOsA4ZxhuZpe_SnkTAisTP0AnpKsb-jfOQ@mail.gmail.com>
 <CAH2r5mvVA6Ov2sL-crNgeT91MeLeAZTJtNW6dZSnhh=ATzvjTQ@mail.gmail.com>
 <CAKywueR=hkkkPHeR-jfj21bbcvgOBP6Y-QaHPP7wB4Neyk5mMQ@mail.gmail.com> <CAH2r5msK48GgjKgJWJf0QA1N6ZV_+3fShmJJSBbmQ87Kk30+mw@mail.gmail.com>
In-Reply-To: <CAH2r5msK48GgjKgJWJf0QA1N6ZV_+3fShmJJSBbmQ87Kk30+mw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 13 Mar 2019 15:38:24 +1000
Message-ID: <CAN05THRfS+LA0FNhkGpQje-oOQRrG7ynUqB+8ZqXsVyrFUTPPw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by me.

Only issue is that it is very verbose like this :
+ if (rc)
+ trace_smb3_rmdir_err(xid,  ses->Suid, tcon->tid, rc);
+ else
+ trace_smb3_rmdir_done(xid, ses->Suid, tcon->tid);

We can do this late but this pattern can be simplified to a single
line with a macro.
It is always rc that decides which tracepoint we use, and the error
path tracepoint has a small subset of the arguments,except for rc,
than the _done tracepoint have.
So the macro could take both rc as well as all the arguments for _done as t=
his :

TRACE_SMB3_RMDIR_END(rc, xid, suid, tid)

which then expands to the four lines of code.
We can do that later, just to reduce the amount of emacs real-estate
these lines take up.


On Wed, Mar 13, 2019 at 3:03 PM Steve French <smfrench@gmail.com> wrote:
>
> Version 3 of the patch attached.   Sample output below:
> (trace-cmd  record -e *query_info_co* -e smb3_hardlink* -e
> smb3_rename* -e smb3_set_eof* -e smb3_set_info_co* -e smb3_mkdir* -e
> smb3_delete* -e smb3_rmdir*)
>
>            mkdir-17927 [003] .... 447434.636544:
> smb3_query_info_compound_enter: xid=3D7 sid=3D0x7dc5fd6f tid=3D0xc7968732
> path=3D\newdir
>            mkdir-17927 [003] .... 447434.637240:
> smb3_query_info_compound_err: xid=3D7 sid=3D0x7dc5fd6f tid=3D0xc7968732
> rc=3D-2
>            mkdir-17942 [000] .... 447446.807606:
> smb3_query_info_compound_enter: xid=3D8 sid=3D0x7dc5fd6f tid=3D0xc7968732
> path=3D\newdir
>            mkdir-17942 [000] .... 447446.808233:
> smb3_query_info_compound_err: xid=3D8 sid=3D0x7dc5fd6f tid=3D0xc7968732
> rc=3D-2
>            mkdir-17942 [000] .... 447446.808251: smb3_mkdir_enter:
> xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732 path=3D\newdir
>            mkdir-17942 [000] .... 447446.809161: smb3_mkdir_done:
> xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732
>            mkdir-17942 [000] .... 447446.809178:
> smb3_query_info_compound_enter: xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732
> path=3D\newdir
>            mkdir-17942 [000] .... 447446.809979:
> smb3_query_info_compound_done: xid=3D9 sid=3D0x7dc5fd6f tid=3D0xc7968732
>            rmdir-17943 [001] .... 447451.374029:
> smb3_query_info_compound_enter: xid=3D10 sid=3D0x7dc5fd6f tid=3D0xc796873=
2
> path=3D\baddir
>            rmdir-17943 [001] .... 447451.379621:
> smb3_query_info_compound_err: xid=3D10 sid=3D0x7dc5fd6f tid=3D0xc7968732
> rc=3D-2
>            rmdir-17944 [001] .... 447456.088795:
> smb3_query_info_compound_enter: xid=3D11 sid=3D0x7dc5fd6f tid=3D0xc796873=
2
> path=3D\newdir
>            rmdir-17944 [001] .... 447456.089615:
> smb3_query_info_compound_done: xid=3D11 sid=3D0x7dc5fd6f tid=3D0xc7968732
>            rmdir-17944 [001] .... 447456.089640: smb3_rmdir_enter:
> xid=3D12 sid=3D0x7dc5fd6f tid=3D0xc7968732 path=3D\newdir
>            rmdir-17944 [001] .... 447456.090651: smb3_rmdir_done:
> xid=3D12 sid=3D0x7dc5fd6f tid=3D0xc7968732
>            touch-17945 [006] .... 447460.575789:
> smb3_set_info_compound_enter: xid=3D14 sid=3D0x7dc5fd6f tid=3D0xc7968732
> path=3D\file
>            touch-17945 [006] .... 447460.576571:
> smb3_set_info_compound_done: xid=3D14 sid=3D0x7dc5fd6f tid=3D0xc7968732
>               ln-17946 [001] .... 447468.254480:
> smb3_query_info_compound_enter: xid=3D16 sid=3D0x7dc5fd6f tid=3D0xc796873=
2
> path=3D\linkedfile
>               ln-17946 [001] .... 447468.255082:
> smb3_query_info_compound_err: xid=3D16 sid=3D0x7dc5fd6f tid=3D0xc7968732
> rc=3D-2
>               ln-17946 [001] .... 447468.255118:
> smb3_query_info_compound_enter: xid=3D17 sid=3D0x7dc5fd6f tid=3D0xc796873=
2
> path=3D\file
>               ln-17946 [001] .... 447468.255715:
> smb3_query_info_compound_done: xid=3D17 sid=3D0x7dc5fd6f tid=3D0xc7968732
>               ln-17946 [001] .... 447468.255760:
> smb3_query_info_compound_enter: xid=3D18 sid=3D0x7dc5fd6f tid=3D0xc796873=
2
> path=3D\linkedfile
>               ln-17946 [001] .... 447468.256254:
> smb3_query_info_compound_err: xid=3D18 sid=3D0x7dc5fd6f tid=3D0xc7968732
> rc=3D-2
>               ln-17946 [001] .... 447468.256277: smb3_hardlink_enter:
> xid=3D19 sid=3D0x7dc5fd6f tid=3D0xc7968732 path=3D\file
>               ln-17946 [001] .... 447468.256954: smb3_hardlink_done:
> xid=3D19 sid=3D0x7dc5fd6f tid=3D0xc7968732
>            gmain-2225  [004] .... 447468.257130:
> smb3_query_info_compound_enter: xid=3D20 sid=3D0x7dc5fd6f tid=3D0xc796873=
2
> path=3D\linkedfile
>            gmain-2225  [005] .... 447468.257788:
> smb3_query_info_compound_done: xid=3D20 sid=3D0x7dc5fd6f tid=3D0xc7968732
>
> On Tue, Mar 12, 2019 at 4:51 PM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > I actually like the idea proposed in the patch: this way we will be
> > able to track logical operations better. In a case we need a deeper
> > logging we already have mid traces which contains MID, TID, SID and
> > CMD - everything you need to trace individual SMB packet regardless of
> > whether it is a part of compounding chain or not.
> >
> > Now in order to match both logical operation and SMB packets traces we
> > need something common - like XID. Currently we do not propagate XID
> > down to the transport layer, let's do that - this way we can trace
> > individual system call from the very beginning to the completeness on
> > every layer inside cifs.ko.
> >
> > =D0=B2=D1=82, 12 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 00:19, Steve F=
rench <smfrench@gmail.com>:
> > >
> > > The general feeling I am getting from tracing the compounding is that
> > > we have to have the more granular tracing available
> > > (similar to this patch), and also (with followon patch) add noisier
> > > optional trace points lower down (that are generic) that we turn on
> > > less frequently (in particular when the filename is not good enough
> > > and we must have the xid - even if it makes the trace very noisy)
> > >
> > >
> > > On Tue, Mar 12, 2019 at 1:06 AM ronnie sahlberg
> > > <ronniesahlberg@gmail.com> wrote:
> > > >
> > > > Hmm.
> > > >
> > > > I don't think this is the wrong layer to add the tracing.
> > > > Instead of adding the tracing in say smb2_compound_op(), where we
> > > > create the compound,
> > > > I think it will be better to add the tracing down in the leaf
> > > > functions, i.e. down in SMB2_open_init(), SMB2_query_info_init(), .=
..
> > > >
> > > > That way we know that we will always have tracing for all opens/clo=
ses/...
> > > >
> > > > But then what to do about the trace_smb3_..._err()/trace_smb3_..._d=
one() calls ?
> > > > These I think should be moved down and handled inside compound_send=
_recv().
> > > > That way we can have one single place where we call the appropriate
> > > > _err()/_done() functions
> > > > and we know that we will catch every single completed function.
> > > >
> > > > I.e. just put it in a single place instead of in every single call-=
site.
> > > > In compound_send_recv we can just loop over all the responses, cast=
 it
> > > > to a smb2_hdr structure, looka at both the command code as well as =
the
> > > > status code and call the appropriate xys_err() or xyz_done() functi=
ons
> > > > as needed.
> > > >
> > > > Let me show an example of what I mean for a open/query/close compou=
nd :
> > > >
> > > > trace_smb3_open_enter(xid=3D5, filename=3D"foo", ...)   from SMB2_o=
pen_init()
> > > > trace_smb3_query_info_enter(xid=3D5,... ) from SMB2_query_info_init=
()
> > > > trace_smb3_close_enter(xid=3D5, ...) from SMB2_close_init()
> > > > (maybe have additional tracing in compound_send_recv() that we are
> > > > about to send xid=3D5 to the wire)
> > > > trace_smb3_open_done(xid=3D5, ...) from compound_send_recv()
> > > > trace_smb3_query_info_done(xid=3D5, ...) from compound_send_recv()
> > > > trace_smb3_close_done(xid=3D5, ...) from compound_send_recv()
> > > >
> >
> > As pointed above we already have a similar tracing inside
> > compound_send_recv and other transport layer functions - command level
> > tracing. The only problem is that we do not log failure cases when we
> > didn't send the packet - we only log server responses in
> > map_smb2_to_linux_error. This is another area of the tracing where a
> > fix is needed.
> >
> > --
> > Best regards,
> > Pavel Shilovsky
>
>
>
> --
> Thanks,
>
> Steve
