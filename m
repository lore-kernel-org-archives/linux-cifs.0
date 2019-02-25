Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A88C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 18:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49C342087C
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 18:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LgA54/PT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbfBYSoH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 13:44:07 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35939 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbfBYSoG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 13:44:06 -0500
Received: by mail-lj1-f196.google.com with SMTP id v10so8379715lji.3
        for <linux-cifs@vger.kernel.org>; Mon, 25 Feb 2019 10:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ojYvZZ+pqvfhLoS030AZf/JONam5uRJbLu0n0cb1yjA=;
        b=LgA54/PTmeFmtBgL1DZg6nlHwfqkAoIseGA2I8HmP60a7qW0Ex+cil29oIpgq/5oU/
         Aw0zOY2lcK2pghQ83rikOqLXTYlD9oYfvoCi/CfGDlsbphk1xE5GVNrQvG9FWFVw+adw
         f565DXqdMhmiuhTDoAtShj4EmOXIQdcKMZG6SQkyI2HgIl3fmQ/yMU4pCoocU2vz64RG
         L+/3bcqgPhF2KNnB59TITR4ibmWsGy+USvGdnjbLLAaBtHBFr2edXoA4XBe9QCszsFn/
         chiD46REUW5Alvu0xNMmRLTnahpseMETBjedqxB7yufx57lv9XzOPsSu/gB+Er+hhrCg
         /4wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ojYvZZ+pqvfhLoS030AZf/JONam5uRJbLu0n0cb1yjA=;
        b=N4UKUQ7axgeW25hZYIbH2huU6r//1QcqxfrzNOpGQqZ0KpGDLWvBccPT0/MnsI7YBf
         wXdJUMAUNolP6B3TJFsiCPwcXEmYUdSiRxC+teph9ZB3huK96CsrqSXP3NSZJHpaYxCc
         4Ihr+hLMwRy4uNJU3tDwwPo0k/IF8zaw82Vhw41Eg/28IApfk7BrarCEKaaA71t3WmyG
         Q7dhuPocO7UOKLpe5+RW2i9LJ+DpZBxJSySjG4Bua31AvBcVBdr3Rbylx/IsnAHVuWvP
         Ob3urkPySIDIHqnBZ+w3xi/u64S9N7cWzrdegEsC8kFsDjnL/x/45zDA2FopLNU323oJ
         nztg==
X-Gm-Message-State: AHQUAuaSCTLVjxH4MD8eqUGsYLJf6YEzP7xMYnu0eSGzSMx5BkR5ucrN
        kSQfHkULe6UnVKo5hyDlXeng1x8roF9jYBYQHA==
X-Google-Smtp-Source: AHgI3IYgQjGo+OmZZLag3RnfBkKs1lvbNeHhXGz/Oih1qrfholq3dSE+GomkVNvHguR12S2ZgoGTNz8HXg+maItSPl8=
X-Received: by 2002:a2e:8644:: with SMTP id i4mr10549991ljj.192.1551120244441;
 Mon, 25 Feb 2019 10:44:04 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt4zNDMkqg1ioqfoiZpNmt2_VnbALG9X8piDeyx5hLdhw@mail.gmail.com>
In-Reply-To: <CAH2r5mt4zNDMkqg1ioqfoiZpNmt2_VnbALG9X8piDeyx5hLdhw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 25 Feb 2019 10:43:52 -0800
Message-ID: <CAKywueReYLOkUC0oxv5JrNGkXdSvBmrvj9jN8=nDDxMj81SMDg@mail.gmail.com>
Subject: Re: [PATCH] smb3 tracepoints for read_enter, write_enter and query_dir_enter
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 24 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 23:11, Steve=
 French <smfrench@gmail.com>:
>
> May be helpful to get timing info for large reads/writes/query_dirs or
> to better find hangs or operations that trigger reconnects.   Sample
> output from various readdirs with the new tracepoints
>
> # trace-cmd show
> # tracer: nop
> #
> #                              _-----=3D> irqs-off
> #                             / _----=3D> need-resched
> #                            | / _---=3D> hardirq/softirq
> #                            || / _--=3D> preempt-depth
> #                            ||| /     delay
> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
> #              | |       |   ||||       |         |
>               ls-30820 [004] .... 77492.662476: smb3_query_dir_enter:
> xid=3D8 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0
> len=3D0x4000
>               ls-30820 [004] .... 77492.663906: smb3_query_dir_done:
> xid=3D8 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0 l=
en=3D0x13
>               ls-30820 [004] .... 77492.664107: smb3_query_dir_enter:
> xid=3D9 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0
> len=3D0x4000
>               ls-30820 [004] .... 77492.664639: smb3_query_dir_err:
>  xid=3D9 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xfc37e912 offset=3D0x0 =
len=3D0x0
> rc=3D0
>             bash-27628 [000] .... 77502.150630: smb3_query_dir_enter:
> xid=3D12 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x0
> len=3D0x4000
>             bash-27628 [000] .... 77502.151783: smb3_query_dir_done:
> xid=3D12 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x0
> len=3D0x13
>             bash-27628 [000] .... 77502.151855: smb3_query_dir_enter:
> xid=3D13 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x0
> len=3D0x4000
>             bash-27628 [000] .... 77502.152378: smb3_query_dir_err:
>  xid=3D13 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x26e379e1 offset=3D0x0
> len=3D0x0 rc=3D0

query_dir_ERR and rc=3D0 looks weird, should be query_dir_DONE.

>               ls-30821 [001] .... 77502.156573: smb3_query_dir_enter:
> xid=3D15 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x4f5cedcd offset=3D0x0
> len=3D0x4000
>               ls-30821 [001] .... 77502.157308: smb3_query_dir_done:
> xid=3D15 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x4f5cedcd offset=3D0x0 =
len=3D0x3
>               ls-30821 [001] .... 77502.157364: smb3_query_dir_enter:
> xid=3D16 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x4f5cedcd offset=3D0x0
> len=3D0x4000
>               ls-30821 [001] .... 77502.157880: smb3_query_dir_err:
>  xid=3D16 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x4f5cedcd offset=3D0x0
> len=3D0x0 rc=3D0
>               ls-30821 [001] .... 77502.159819: smb3_query_dir_enter:
> xid=3D18 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xcb88f96d offset=3D0x0
> len=3D0x4000
>               ls-30821 [003] .... 77502.160591: smb3_query_dir_done:
> xid=3D18 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xcb88f96d offset=3D0x0 =
len=3D0x3
>               ls-30821 [003] .... 77502.160651: smb3_query_dir_enter:
> xid=3D19 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xcb88f96d offset=3D0x0
> len=3D0x4000
>               ls-30821 [003] .... 77502.161106: smb3_query_dir_err:
>  xid=3D19 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0xcb88f96d offset=3D0x0
> len=3D0x0 rc=3D0
>               ls-30821 [003] .... 77502.162653: smb3_query_dir_enter:
> xid=3D21 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x9ca0a6bc offset=3D0x0
> len=3D0x4000
>               ls-30821 [003] .... 77502.163334: smb3_query_dir_done:
> xid=3D21 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x9ca0a6bc offset=3D0x0 =
len=3D0x3
>               ls-30821 [003] .... 77502.163382: smb3_query_dir_enter:
> xid=3D22 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x9ca0a6bc offset=3D0x0
> len=3D0x4000
>               ls-30821 [003] .... 77502.163894: smb3_query_dir_err:
>  xid=3D22 sid=3D0x2fa2c9ab tid=3D0x1377432b fid=3D0x9ca0a6bc offset=3D0x0
> len=3D0x0 rc=3D0
>

Other than the comment above, the patch looks fine

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
