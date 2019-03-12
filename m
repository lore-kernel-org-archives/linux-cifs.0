Return-Path: <SRS0=AEBP=RP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B40C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 21:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30C432077B
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Mar 2019 21:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tZessrpg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfCLVvU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Mar 2019 17:51:20 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34922 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfCLVvU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Mar 2019 17:51:20 -0400
Received: by mail-lf1-f67.google.com with SMTP id h6so3255722lfc.2
        for <linux-cifs@vger.kernel.org>; Tue, 12 Mar 2019 14:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rtMb2vNdLeL+9PcNKq9MuIwBXaeHGfFYJrENnxkvS7g=;
        b=tZessrpgjmpg2wrq2+WWyz42o+/XrR5j6szI3PjNptCYR3WdzVfwfv8YOdfLKeGp5M
         jA+2p1LJc6e2vR4063uBsXvaCwmVIVO64tqaAQBZyyeMvEl1WBNJFVavl5I9dlts9wUs
         Cl5Gr/M/uJG4OVFhAaFZE+dxVjKRPJDgDTFtghRMgmvvwAbjm/QhhMufhsgzIVhy8iRX
         X24voYlKqP96pCzVUbepXfa7wpRSuS5ai63RQQoNcYdDMpeStdb5EjfJG6DnFC8FSeic
         oDq8ATGIuAuTh1FXk+3+ueSG47TIVdI2Hom/pxnnIWlS3GUwxW0jG9eaoxxOlN2jOPOm
         sMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rtMb2vNdLeL+9PcNKq9MuIwBXaeHGfFYJrENnxkvS7g=;
        b=IqYP+NfYR/4Ul1PLbhe4nfvuSv22jynRYNDbsUt1QWAIqxVdY589B6GoOR9HQpVYeY
         3LEMGq2dqS80zEUfZqWfb0ZALLqpFZ7GTuHpXPf59EGjtg2PtjiAv9LeT1Y5ZDuWyQZv
         0QNISTS8Bms/CRfnWA7wONBzX7N1VUpYkOebG2oQJE4Gl3p+TqiWZpotxokHD03CVYJS
         tTOg+ey1dEe5PvoIrZ9LelJphaR/2wj9Ztr6hUwt1OZmRggaBYdPcqcSf2lzT7jDTJG3
         pTyNoNideew71ANHWMDmYhjCqSnBwf9Gr5eZA5P4Ty0bWq3toKbMuCobCRupXQ25+ag+
         gjOg==
X-Gm-Message-State: APjAAAVMI3pUSyClx4yNkO9BbsTqu9OAuXfnCL9h6vslUwMJcb3btNzN
        /OgmvZcWoOju8r+nxiezMuKRnkF/z7Co7xKWrQ==
X-Google-Smtp-Source: APXvYqySJnAkBfnIn3LWLpAJfunUKAvyziAyLLdyPznKXUrEr3s4jsMZdfcKwfPKihrgIOiZOf6L0Niey5DB/gewLiA=
X-Received: by 2002:ac2:4474:: with SMTP id y20mr7575903lfl.42.1552427478388;
 Tue, 12 Mar 2019 14:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muY3xgVW03Mi8N-c4wyZFikzTeZgLDEuGLoXFXNZ-wFHA@mail.gmail.com>
 <CAKywueR9-_yYVA4YfycxfH_jog0xQKhgoQeFG6nhLws4TLC8Tg@mail.gmail.com>
 <CAH2r5mv+6N=p183kFpYnFGo7ixcu1TkCjBvWnct=1M91kH3_WA@mail.gmail.com>
 <CAH2r5mv2Cp8YseCF1rz0dH8tvPYZ1+dCykupzVv_S81f2gPMJg@mail.gmail.com>
 <CAN05THQt3se9xsbhKOsA4ZxhuZpe_SnkTAisTP0AnpKsb-jfOQ@mail.gmail.com> <CAH2r5mvVA6Ov2sL-crNgeT91MeLeAZTJtNW6dZSnhh=ATzvjTQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvVA6Ov2sL-crNgeT91MeLeAZTJtNW6dZSnhh=ATzvjTQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 12 Mar 2019 14:51:07 -0700
Message-ID: <CAKywueR=hkkkPHeR-jfj21bbcvgOBP6Y-QaHPP7wB4Neyk5mMQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Add various dynamic tracepoints for compounded operations
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I actually like the idea proposed in the patch: this way we will be
able to track logical operations better. In a case we need a deeper
logging we already have mid traces which contains MID, TID, SID and
CMD - everything you need to trace individual SMB packet regardless of
whether it is a part of compounding chain or not.

Now in order to match both logical operation and SMB packets traces we
need something common - like XID. Currently we do not propagate XID
down to the transport layer, let's do that - this way we can trace
individual system call from the very beginning to the completeness on
every layer inside cifs.ko.

=D0=B2=D1=82, 12 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 00:19, Steve Frenc=
h <smfrench@gmail.com>:
>
> The general feeling I am getting from tracing the compounding is that
> we have to have the more granular tracing available
> (similar to this patch), and also (with followon patch) add noisier
> optional trace points lower down (that are generic) that we turn on
> less frequently (in particular when the filename is not good enough
> and we must have the xid - even if it makes the trace very noisy)
>
>
> On Tue, Mar 12, 2019 at 1:06 AM ronnie sahlberg
> <ronniesahlberg@gmail.com> wrote:
> >
> > Hmm.
> >
> > I don't think this is the wrong layer to add the tracing.
> > Instead of adding the tracing in say smb2_compound_op(), where we
> > create the compound,
> > I think it will be better to add the tracing down in the leaf
> > functions, i.e. down in SMB2_open_init(), SMB2_query_info_init(), ...
> >
> > That way we know that we will always have tracing for all opens/closes/=
...
> >
> > But then what to do about the trace_smb3_..._err()/trace_smb3_..._done(=
) calls ?
> > These I think should be moved down and handled inside compound_send_rec=
v().
> > That way we can have one single place where we call the appropriate
> > _err()/_done() functions
> > and we know that we will catch every single completed function.
> >
> > I.e. just put it in a single place instead of in every single call-site=
.
> > In compound_send_recv we can just loop over all the responses, cast it
> > to a smb2_hdr structure, looka at both the command code as well as the
> > status code and call the appropriate xys_err() or xyz_done() functions
> > as needed.
> >
> > Let me show an example of what I mean for a open/query/close compound :
> >
> > trace_smb3_open_enter(xid=3D5, filename=3D"foo", ...)   from SMB2_open_=
init()
> > trace_smb3_query_info_enter(xid=3D5,... ) from SMB2_query_info_init()
> > trace_smb3_close_enter(xid=3D5, ...) from SMB2_close_init()
> > (maybe have additional tracing in compound_send_recv() that we are
> > about to send xid=3D5 to the wire)
> > trace_smb3_open_done(xid=3D5, ...) from compound_send_recv()
> > trace_smb3_query_info_done(xid=3D5, ...) from compound_send_recv()
> > trace_smb3_close_done(xid=3D5, ...) from compound_send_recv()
> >

As pointed above we already have a similar tracing inside
compound_send_recv and other transport layer functions - command level
tracing. The only problem is that we do not log failure cases when we
didn't send the packet - we only log server responses in
map_smb2_to_linux_error. This is another area of the tracing where a
fix is needed.

--
Best regards,
Pavel Shilovsky
