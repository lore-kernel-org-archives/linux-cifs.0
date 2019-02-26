Return-Path: <SRS0=zR3V=RB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B5CC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Feb 2019 02:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7F93217F5
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Feb 2019 02:32:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aga/ksuI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfBZCck (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 21:32:40 -0500
Received: from mail-qk1-f171.google.com ([209.85.222.171]:38073 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfBZCck (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 21:32:40 -0500
Received: by mail-qk1-f171.google.com with SMTP id p15so6713485qkl.5
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 18:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gAJevcOqW6oGizU0Pf1/HzG8G4haidzBOxh2Ad54ZEg=;
        b=aga/ksuIPklL7FPtf5pOk67QqE8z+n1N5ElJ+krO0PNF77KfvbXzUeYdUPxPDPPi5y
         GOmx0wRRmF4qWsADmIwf6ThiJmcKOK3DvciTE1MBMUd1NzoQ9klcnw66cF9seVJT45Io
         qtllc6p71ctEnLqdumWKeBqSz+B2bz6GteaWG4oflBj76iBYg/cY5bo3mXcIW5cQ0tTm
         iyTIs1hx0WByGvJEnI6za86WKwl2e+Zuf8nawupMtY2uACbcXH87vVM0wmXdWmFlSSJ/
         Jjh8q/iRHDvfnATe3iQ7D+v/TGBdrkdiwAyg74RzjKv4TqGoQ8MkyFzdkMxfvSYkXmd+
         rp3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gAJevcOqW6oGizU0Pf1/HzG8G4haidzBOxh2Ad54ZEg=;
        b=abHc1eOpcWoIfqoK//n4zyBXAO3Wna72uTD4KJj1II1qcsxkMQf4zQraX45HpHhIns
         LBc/HwfwELIrht+fsY6qzHdLCuYnRYjtYT/3GCWRZ0Vy8ILr+vAb95/sOf5QIJW7HCqP
         VZrCO4KMZL5XfTFfveAVMH85NEXylrHgMR6/+T13jMRTtqEPXZYleuJtlp6XlFiltJr0
         Ex6hyy0SuLvHkCg7qDSQf5JE4G/K6P9uj9ujfBUHkBZPSFA7uyYxy8wIpWpVMw7o258x
         AFKPo39YHC7D1kvCeHPyIQgUhw0UJmKWZWm1MrHt1LDEVPF2r0XeQodLh6MEfUp2j+X0
         dYSw==
X-Gm-Message-State: AHQUAuaVPejFzB1xDgcTM4xwGtoAiShUaPnKssTTTrEKBpI/j6Q1OoCc
        /mDLZKf8DVPpDk2LnTr8qrkxmZEDMGBFbfBsESQ=
X-Google-Smtp-Source: AHgI3IbMmti0Rr5FSsv54xb6bUfF7CH00s3htIBmukGInIAAtHBtwSXFabIr/TPswnP4hBy4TfzsurDhbe3SuQOJOp8=
X-Received: by 2002:a37:5156:: with SMTP id f83mr14864114qkb.126.1551148358809;
 Mon, 25 Feb 2019 18:32:38 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mtPFfn+wi1LEfe=po+DYMFO51w+ZVtOAiY2Ex7CJMxdug@mail.gmail.com>
In-Reply-To: <CAH2r5mtPFfn+wi1LEfe=po+DYMFO51w+ZVtOAiY2Ex7CJMxdug@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 26 Feb 2019 12:32:27 +1000
Message-ID: <CAN05THSue2W3VzjZAf5oz7G=+SSGF8uQ4PPbqhqPeFdfUjMo0Q@mail.gmail.com>
Subject: Re: Updated ftrace patches for read/write/query_dir
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In the first patch, do we really need different tracepoints for done
rc==0 and err rc!=0 ?

Othervise, for both:

Reweived-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Tue, Feb 26, 2019 at 6:53 AM Steve French <smfrench@gmail.com> wrote:
>
> Sample output (from "trace-cmd record -e  smb3_query* -e smb3_read* -e
> smb3_write*")
>
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>               ls-25909 [004] .... 91084.368421: smb3_query_dir_enter:
> xid=8 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0
> len=0x4000
>               ls-25909 [004] .... 91084.369413: smb3_query_dir_done:
> xid=8 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0 len=0x8
>               ls-25909 [004] .... 91084.369530: smb3_query_dir_enter:
> xid=9 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0
> len=0x4000
>               ls-25909 [004] .... 91084.370020: smb3_query_dir_done:
> xid=9 sid=0x45a21759 tid=0x821ad8fd fid=0x50da7b4 offset=0x0 len=0x0
>               dd-25915 [004] .... 91101.999225: smb3_read_enter: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x0 len=0x400000
>            cifsd-25891 [005] .... 91102.010600: smb3_read_done: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x0 len=0x400000
>               dd-25915 [004] .... 91102.015131: smb3_read_enter: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x400000
> len=0x3d0000
>            cifsd-25891 [005] .... 91102.026541: smb3_read_done: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x400000
> len=0x3d0000
>               dd-25915 [004] .... 91102.028261: smb3_read_enter: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x85b15605 offset=0x7d0000
> len=0x1000
>               dd-25919 [006] .... 91121.554908: smb3_write_enter:
> xid=0 sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x0
> len=0x400000
>               dd-25919 [006] .... 91121.556448: smb3_write_enter:
> xid=0 sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x400000
> len=0x3d0000
>            cifsd-25891 [005] .... 91121.559831: smb3_write_done: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x0 len=0x400000
>            cifsd-25891 [005] .... 91121.561798: smb3_write_done: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x402ee709 offset=0x400000
> len=0x3d0000
>               dd-25931 [007] .... 91161.643194: smb3_read_enter: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x0 len=0x400000
>            cifsd-25891 [005] .... 91161.650859: smb3_read_done: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x0 len=0x400000
>               dd-25931 [007] .... 91161.655470: smb3_read_enter: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x400000
> len=0x3d0000
>            cifsd-25891 [004] .... 91161.663517: smb3_read_done: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x400000
> len=0x3d0000
>               dd-25931 [001] .... 91161.664921: smb3_read_enter: xid=0
> sid=0x45a21759 tid=0x821ad8fd fid=0x115afb41 offset=0x7d0000
> len=0x1000
>
>
> --
> Thanks,
>
> Steve
