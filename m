Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E94C10F00
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 19:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 280A6213A2
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 19:00:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVpcFSjY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfBYTAH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 14:00:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35209 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfBYTAG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 14:00:06 -0500
Received: by mail-lj1-f196.google.com with SMTP id t13so4044823lji.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 11:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7CmQW5NY+M9lyRMRUT/LyMWCLa3VfpETqNjrkysVdus=;
        b=JVpcFSjYYQph229+QGfi3pxPy/bAqNvOWXSalexCkYD+/U9aGYfwvoFYIY5emrKQIZ
         OMtwSa7hycw+OrSjPGiYKLOzPlr2HqHvxq5dKtLA+esg4073pyKPvEkraA35kIT0pEu3
         PBegpRrxHdoelFWtZacLYYnLfJJ+hbUHHgldqgdenVa8X0hvjjcUHItGbl+yGX5ZjNEH
         fJ682x6WsBKiWNTkNFhZzJYi83iydmjezYfzBsSIUu8f8CzdomDBWYNYtCou+vf7JYiS
         FMgFh5fGqr9O9NNghvQl5T9JOFWgc9w5gaY1YRA7TVKQvYVGCEnGeo0W3A0ZOgcSH/Vc
         TdrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7CmQW5NY+M9lyRMRUT/LyMWCLa3VfpETqNjrkysVdus=;
        b=B+i2aEK8ewxzi7149fBAj4Od64aaNRdpAEEPqgPx5SzHY8vF5XMYD0d5Bhtnw4lNo9
         WpKI3m6Ln6ioMerWHDN4XGGXrrPMBN+bv4HGLT/A1PYCyuWkJgPLctRZ9sZT0Cc6h8cO
         P7KWXQVE/E/VjT6eQx4d9WD6qep1khaPj6K+mrSEJz1/OfbqhPckcQZma39A2EOKJfht
         eyZgIVXCFBn1T6aI8gzgxIm40KfxC/VaLBDK+X9OYRZ+0epliC7yWjh+OSRAvwFTe8uH
         NAAstW/jjmH065c9f/a5oyUke2Xjo6mkoPcaHEumMPd+t/maCxMliGZ7tk3qw6li+KWw
         H6/g==
X-Gm-Message-State: AHQUAuaqtGq2onZUMbIGsscOnZKljcD4DofGPxiU3ogUzW4cM2ezVCXf
        J+sqXHUe3Vk8YYKvxSg0ywlzxGuMk5q/FQ24Jw==
X-Google-Smtp-Source: AHgI3IYXJrPMFu8dAPshPQvuVamMBRid8pOGWS5XIAffYsera6SICEcrWRq9+NJJcf4Tkdqvt/Ec4qpQhdNQETwaMQc=
X-Received: by 2002:a2e:124e:: with SMTP id t75mr11032442lje.23.1551121204317;
 Mon, 25 Feb 2019 11:00:04 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt4zNDMkqg1ioqfoiZpNmt2_VnbALG9X8piDeyx5hLdhw@mail.gmail.com>
 <CAKywueReYLOkUC0oxv5JrNGkXdSvBmrvj9jN8=nDDxMj81SMDg@mail.gmail.com> <CAH2r5muJQSuoz6w3ui8L+u1wH6=2GMyWaeHN3gd3buacemo4rQ@mail.gmail.com>
In-Reply-To: <CAH2r5muJQSuoz6w3ui8L+u1wH6=2GMyWaeHN3gd3buacemo4rQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 25 Feb 2019 10:59:53 -0800
Message-ID: <CAKywueQfPx=2RwVW2HYCMUFDcRzN-6oYMdObW1VaRQLFJiP+uQ@mail.gmail.com>
Subject: Re: [PATCH] smb3 tracepoints for read_enter, write_enter and query_dir_enter
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 25 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 10:52, Steve=
 French <smfrench@gmail.com>:
>
> On Mon, Feb 25, 2019 at 12:44 PM Pavel Shilovsky <piastryyy@gmail.com> wr=
ote:
> >
> > =D0=B2=D1=81, 24 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 23:11, S=
teve French <smfrench@gmail.com>:
> > >
> > > May be helpful to get timing info for large reads/writes/query_dirs o=
r
> > > to better find hangs or operations that trigger reconnects.   Sample
> > > output from various readdirs with the new tracepoints
> > >
> > > # trace-cmd show
> > > # tracer: nop
> > > #
> > > #                              _-----=3D> irqs-off
> > > #                             / _----=3D> need-resched
> > > #                            | / _---=3D> hardirq/softirq
> > > #                            || / _--=3D> preempt-depth
> > > #                            ||| /     delay
> > > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > > #              | |       |   ||||       |         |
> > >               ls-30820 [004] .... 77492.662476: smb3_query_dir_enter:
> > > xid=3D8 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0=
x0
> > > len=3D0x4000
> > >               ls-30820 [004] .... 77492.663906: smb3_query_dir_done:
> > > xid=3D8 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0=
x0 len=3D0x13
> > >               ls-30820 [004] .... 77492.664107: smb3_query_dir_enter:
> > > xid=3D9 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0=
x0
> > > len=3D0x4000
> > >               ls-30820 [004] .... 77492.664639: smb3_query_dir_err:
> > >  xid=3D9 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D=
0x0 len=3D0x0
> > > rc=3D0
> > >             bash-27628 [000] .... 77502.150630: smb3_query_dir_enter:
> > > xid=3D12 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D=
0x0
> > > len=3D0x4000
> > >             bash-27628 [000] .... 77502.151783: smb3_query_dir_done:
> > > xid=3D12 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D=
0x0
> > > len=3D0x13
> > >             bash-27628 [000] .... 77502.151855: smb3_query_dir_enter:
> > > xid=3D13 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D=
0x0
> > > len=3D0x4000
> > >             bash-27628 [000] .... 77502.152378: smb3_query_dir_err:
> > >  xid=3D13 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=
=3D0x0
> > > len=3D0x0 rc=3D0
> >
> > query_dir_ERR and rc=3D0 looks weird, should be query_dir_DONE.
>
> The reason I left it that way was it was slightly simpler (saved a few
> lines of code)
> but also allows us to distinguish the case of STATUS_NO_MORE_FILES
> (which is mapped to rc =3D 0 so is logged as smb3_query_dir_err with
> rc=3D0) ie the end of search example.
>
> Alternatively, I could move the smb2_query_done / smb2_query_err lines
> up (immediately after the send_rcv) but it could miss errors caught in
> "smb2_validate_iov"
>

I don't think we should hide STATUS_NO_MORE_FILES or any other status
code in tracing (even if we mask it off later). Let's trace
smb3_query_dir_err with the proper error code. Nobody except
developers is expected to look at the traces, so, should be fine.

--
Best regards,
Pavel Shilovsky
