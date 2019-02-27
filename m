Return-Path: <SRS0=LBnX=RC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8778BC43381
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F0762133D
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Feb 2019 19:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S8vAfOZW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbfB0TSs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Feb 2019 14:18:48 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35161 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfB0TSr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Feb 2019 14:18:47 -0500
Received: by mail-lj1-f193.google.com with SMTP id t13so10529492lji.2
        for <linux-cifs@vger.kernel.org>; Wed, 27 Feb 2019 11:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n/+ff/0maiZc8d6m/71qUayLVD18+66JUVgQBPAHUJ8=;
        b=S8vAfOZWZsbaTHVVYpkSFfhxhxs7nWrFPpmjd6ECziR30pQEpfmLny3eKnuDpjxDIB
         i3OiCIMcNQzdoDklPJAOJPxWFMPBoIGHFs8QYyBhyf7mVA6AkU9oiEg1b5fZx45njsX7
         9PnprsrweZTBFKnaVq4emMHnFbA4mepwkTi1Q+nJO7+TTn3Y1suylYpPIDps79Wsupyv
         AJQFkJZ0ho5FAC8ntHwpFj67xsglP4Ph/t2enJgI9if5dQQYAdNcW13hknx2g+n4zig/
         7J3Z1jTJzQEj105fep6QbLzmaS66P9HKhBVpCaP8ill2ctDWo37GW+SdXmFSG6IjMOuD
         Mpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n/+ff/0maiZc8d6m/71qUayLVD18+66JUVgQBPAHUJ8=;
        b=aVsoIYebcG89QoINwf8zKtzNTP4rgiMT3d7Qr/adqsirTlV1C40hODjb0x/e06gLd9
         DYWpzX3XVvzNLuubj7B2VPcRn/OFMluMkI/iueDZ8gHiroNyzF/owJvFAeianmcWUEgj
         IzYOi74fV9qiCeOYr1tFi1E9UHCOYZgBvIJVIMfIzpMGMd0DJfTEsgaO+UJOFBBI9E2o
         xcyKI0ajExPwJRP86xDgSI8T8vswdh0P38dUyifeoPVhqAWF8B4Etr3LjiDwuloDdrfh
         x4af2q/WN2coYcWchV5dlK5oBnsvZgxMrNv90zyaIIrHG/DoUBBK25fOYoVZwRn4vU/t
         3Y1Q==
X-Gm-Message-State: AHQUAuZIy2UbZX/bbfTe4ffzJWI/xN6cla5Y69a4EBpRGr7Faoe9Ve9+
        nAFVVMOvRRxiKiLCcJkxKdAc1QI39Zn7rWKEgA==
X-Google-Smtp-Source: AHgI3IYXVHaVQJP4WP8s2hfGFsGt2I0vaxI3Ra4wF24nS5dqkaRKc745ntE547VLcsE2nfWEwATcVOtoDxQBgofIXqw=
X-Received: by 2002:a2e:9056:: with SMTP id n22mr2337369ljg.132.1551295125715;
 Wed, 27 Feb 2019 11:18:45 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt3CWn08J-iS8qQEN5LukVSCO5QUvYoFfqkUP-+Ynn59A@mail.gmail.com>
In-Reply-To: <CAH2r5mt3CWn08J-iS8qQEN5LukVSCO5QUvYoFfqkUP-+Ynn59A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 27 Feb 2019 11:18:34 -0800
Message-ID: <CAKywueSRUeHsRXL1se_PcBONFK1NvCKr4S1hAcQMzyWMGQhkdA@mail.gmail.com>
Subject: Re: [PATCH] smb3: add dynamic trace point for query_info_enter/done
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 26 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 20:05, Steve=
 French <smfrench@gmail.com>:
>
> Adds dynamic trace points for the query_info_enter
> and query_info_done (no error) case.  We only had one on query_info
> errors in existing code.  These two tracepoints are for the
> non-compounded query_info paths.
>
> Sample output (after doing: trace-cmd record -e smb3_query_info*)
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
>               ls-24140 [001] .... 27811.866068: smb3_query_info_enter:
> xid=3D7 sid=3D0xd2d00587 tid=3D0xb5441939 fid=3D0xcf082bac class=3D18 typ=
e=3D0x1
>               ls-24140 [001] .... 27811.867656: smb3_query_info_done:
> xid=3D7 sid=3D0xd2d00587 tid=3D0xb5441939 fid=3D0xcf082bac class=3D18 typ=
e=3D0x1
>       getcifsacl-24149 [005] .... 27854.759873: smb3_query_info_enter:
> xid=3D15 sid=3D0xd2d00587 tid=3D0xb5441939 fid=3D0x99896e72 class=3D0 typ=
e=3D0x3
>       getcifsacl-24149 [005] .... 27854.761730: smb3_query_info_done:
> xid=3D15 sid=3D0xd2d00587 tid=3D0xb5441939 fid=3D0x99896e72 class=3D0 typ=
e=3D0x3

Don't we need to trace errors after smb2_validate_and_copy_iov (the
same way we do for query_dir)? Other than that the patch looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
