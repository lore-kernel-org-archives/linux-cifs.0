Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6302AC43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 18:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37CC02087C
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 18:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ar4BNgLq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfBYSws (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:52:48 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35773 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfBYSws (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 13:52:48 -0500
Received: by mail-pg1-f195.google.com with SMTP id e17so2849504pgd.2
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 10:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p34gT0bxPHD4Czl1pGM4i2UIeXj9506JhYID6fRwebw=;
        b=Ar4BNgLqQKD1r5SSegMAJOMlvhwiv48VH7991kgjUrjCAKIv58jhqxd8kOKdiWkKNO
         bAqspLchJZTUAD/WuN7cE2mSoyeRPpkANRFfuER+yGipdP50khRhox27nvqoVUY2W7T7
         d1/L1kSxlKGL4haCgFsXugv337rApivcktDUjVu1qOWCMJyxsiBRWC/Xxc9SaGtYJpWA
         6g1w8G+jrrno6XHY77X3o7haH4aPzA/3e6htKuE7HS5RyuocJcio8A5TlQ1eDY9i/SJq
         Il0SwkiREfELBtzQjDTNsG5arjtV7/CMNKwCYgLatMVpT8QiSipUrMgHimliFWwLkkrv
         rsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p34gT0bxPHD4Czl1pGM4i2UIeXj9506JhYID6fRwebw=;
        b=NQtuR/IhEZYztq7JZbjZJSyRogGjlc4bDgdrEtw4BMAhkyiQel2Oa9B87gmITlsYzl
         r3MS1wQBAvBssdo9LVPe6vxH9yKvVmeufhtBmg4h+nBTNU6U4UcgBRelbttvtDisz2t3
         +T3INFmlJIqNORBKwjKz3OcqwDpnJeMEsdsWAkqTcAgIH/aeJ6OK0AkJJaggPf+SB5rh
         1RZax47qTu5GDZcU4DMNf25Bc1E2D4S0+Z45aDJRLtUw6DF1IYklxNMCTBHRHbolMjpg
         cixiRcEDqNtbGdp5aA4WH7L14DnGlID1cy3Ihkoy9u11HcY5v1SNu6pp4h6lvkjycx3f
         bJ4Q==
X-Gm-Message-State: AHQUAuajQ5h2c4HIBTgqDigFPoHO315DEMViTQd6vPbJ8/GlMi7t8FCL
        +ZiyplrJ+y0Twui0MURMmtkR4NJqTjfeTlDAOPc=
X-Google-Smtp-Source: AHgI3IZsFBhYSzvadnI42uf81V1zSijwfNE4v626+hGtTU8W+Nf+qZvjWlxNlL+3R4FXcOaknXL4RTOI+FY8S9ytplk=
X-Received: by 2002:a63:8743:: with SMTP id i64mr16375229pge.69.1551120767199;
 Mon, 25 Feb 2019 10:52:47 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt4zNDMkqg1ioqfoiZpNmt2_VnbALG9X8piDeyx5hLdhw@mail.gmail.com>
 <CAKywueReYLOkUC0oxv5JrNGkXdSvBmrvj9jN8=nDDxMj81SMDg@mail.gmail.com>
In-Reply-To: <CAKywueReYLOkUC0oxv5JrNGkXdSvBmrvj9jN8=nDDxMj81SMDg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 12:52:35 -0600
Message-ID: <CAH2r5muJQSuoz6w3ui8L+u1wH6=2GMyWaeHN3gd3buacemo4rQ@mail.gmail.com>
Subject: Re: [PATCH] smb3 tracepoints for read_enter, write_enter and query_dir_enter
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 25, 2019 at 12:44 PM Pavel Shilovsky <piastryyy@gmail.com> wrot=
e:
>
> =D0=B2=D1=81, 24 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 23:11, Ste=
ve French <smfrench@gmail.com>:
> >
> > May be helpful to get timing info for large reads/writes/query_dirs or
> > to better find hangs or operations that trigger reconnects.   Sample
> > output from various readdirs with the new tracepoints
> >
> > # trace-cmd show
> > # tracer: nop
> > #
> > #                              _-----=3D> irqs-off
> > #                             / _----=3D> need-resched
> > #                            | / _---=3D> hardirq/softirq
> > #                            || / _--=3D> preempt-depth
> > #                            ||| /     delay
> > #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> > #              | |       |   ||||       |         |
> >               ls-30820 [004] .... 77492.662476: smb3_query_dir_enter:
> > xid=3D8 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0
> > len=3D0x4000
> >               ls-30820 [004] .... 77492.663906: smb3_query_dir_done:
> > xid=3D8 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0=
 len=3D0x13
> >               ls-30820 [004] .... 77492.664107: smb3_query_dir_enter:
> > xid=3D9 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0
> > len=3D0x4000
> >               ls-30820 [004] .... 77492.664639: smb3_query_dir_err:
> >  xid=3D9 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x=
0 len=3D0x0
> > rc=3D0
> >             bash-27628 [000] .... 77502.150630: smb3_query_dir_enter:
> > xid=3D12 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x=
0
> > len=3D0x4000
> >             bash-27628 [000] .... 77502.151783: smb3_query_dir_done:
> > xid=3D12 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x=
0
> > len=3D0x13
> >             bash-27628 [000] .... 77502.151855: smb3_query_dir_enter:
> > xid=3D13 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x=
0
> > len=3D0x4000
> >             bash-27628 [000] .... 77502.152378: smb3_query_dir_err:
> >  xid=3D13 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0=
x0
> > len=3D0x0 rc=3D0
>
> query_dir_ERR and rc=3D0 looks weird, should be query_dir_DONE.

The reason I left it that way was it was slightly simpler (saved a few
lines of code)
but also allows us to distinguish the case of STATUS_NO_MORE_FILES
(which is mapped to rc =3D 0 so is logged as smb3_query_dir_err with
rc=3D0) ie the end of search example.

Alternatively, I could move the smb2_query_done / smb2_query_err lines
up (immediately after the send_rcv) but it could miss errors caught in
"smb2_validate_iov"


--=20
Thanks,

Steve
