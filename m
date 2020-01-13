Return-Path: <SRS0=lfmE=3C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F00C33CA9
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jan 2020 20:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA9024672
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jan 2020 20:58:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TdIuIK9E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgAMU6h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jan 2020 15:58:37 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45092 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgAMU6h (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jan 2020 15:58:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id j26so11704720ljc.12
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jan 2020 12:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mwekb1LgC988L3q1vOiyS22U7syJGiJavBGDl6qnnxw=;
        b=TdIuIK9Ej0NBaSSE4UpFh6W4GDGDSF+82GKgLfQH7R4UJY708A4AxxAjcvnUJqmABK
         YAudYA5C0piqxUMsFxC+lLYTQUj6JkIHl2GQUrpb/pWAKn4OW+3Q4sOEIdQZoXFGCGSq
         Od8Ga5o/tWOeXsKc1ucB1xzpcnT7UzU5929tZpSlP9/uy7Aw14SL6UFs/y3FCrIujazc
         hUjjUFz/oU/2t2zAMbTW4SBLAFqyhEX1vrQfH2ChE3qbWnqOlC/yvUR1G8sgKpR5VgoZ
         jzTQeyOA+uC316VS4ORegSAa3jOhPFoujaiMKkqNolJYiSRVA6ScV6Yj+aVa6NpK3BEh
         DElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mwekb1LgC988L3q1vOiyS22U7syJGiJavBGDl6qnnxw=;
        b=AAUPBDKGq7Ky5cG9w6TdGHa1waeHH9ajddYX8gkYxL4Mizka+eqYR5ol/y/l0GaDgd
         X0kHAZNIadegfodOmvLXvVfDpfrtyppOuASWfCduNTH4e49lvbIYtoJ2c7CtMXg5EnEh
         g+67HrVIhI7aZ4qCFYO6CZu/ubVA7BDi/DY395FEoElGWX5Yp6PtG2NGOE6YnC0Cjam3
         29NrfBxtG75fjZaqziuy1CMjMDU0bB7ILAAGsdw8Vy6Oifq3rTd+9+th7Xo4crnCS2GQ
         dQ0IyEOrfnQwUgPxCtOMF7pce0t6iYOZhKvyEzXwZQUKom6P7a/N3F/D3Hy91CnpVCEI
         bmRQ==
X-Gm-Message-State: APjAAAU/chNNzRdF0RJaOZl3/fmvdPfbfuIv0ytXvnv6uZgcgqgoAONm
        72hrd52qnwM5uya1DYPThv/nnJC+Cw0yuTzkQg==
X-Google-Smtp-Source: APXvYqwffOuOoRn60D6HWJBNWM3XFRD4oM00Hg39fzvMw/YY5D5dyfEUzKzpmHsBjGc3s410gRn2+Gt/fiMjHxv8jUQ=
X-Received: by 2002:a2e:854b:: with SMTP id u11mr12262239ljj.90.1578949115247;
 Mon, 13 Jan 2020 12:58:35 -0800 (PST)
MIME-Version: 1.0
References: <20200113204659.4867-1-pc@cjr.nz>
In-Reply-To: <20200113204659.4867-1-pc@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 13 Jan 2020 12:58:23 -0800
Message-ID: <CAKywueSnatSmp-=w1J7Jf=9dab70SjV8JgfFoys37-sgGqOD_Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory allocation in __smb2_handle_cancelled_cmd()
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 13 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 12:47, Paulo Alcan=
tara (SUSE) <pc@cjr.nz>:
>
> __smb2_handle_cancelled_cmd() is called under a spin lock held in
> cifs_mid_q_entry_release(), so make its memory allocation GFP_ATOMIC.
>
> This issue was observed when running xfstests generic/028:
>
> [ 1722.589204] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72064 cm=
d: 5
> [ 1722.590687] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72065 cm=
d: 17
> [ 1722.593529] CIFS VFS: \\192.168.30.26 Cancelling wait for mid 72066 cm=
d: 6
> [ 1723.039014] BUG: sleeping function called from invalid context at mm/s=
lab.h:565
> [ 1723.040710] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 308=
77, name: cifsd
> [ 1723.045098] CPU: 3 PID: 30877 Comm: cifsd Not tainted 5.5.0-rc4+ #313
> [ 1723.046256] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS r=
el-1.12.0-59-gc9ba527-rebuilt.opensuse.org 04/01/2014
> [ 1723.048221] Call Trace:
> [ 1723.048689]  dump_stack+0x97/0xe0
> [ 1723.049268]  ___might_sleep.cold+0xd1/0xe1
> [ 1723.050069]  kmem_cache_alloc_trace+0x204/0x2b0
> [ 1723.051051]  __smb2_handle_cancelled_cmd+0x40/0x140 [cifs]
> [ 1723.052137]  smb2_handle_cancelled_mid+0xf6/0x120 [cifs]
> [ 1723.053247]  cifs_mid_q_entry_release+0x44d/0x630 [cifs]
> [ 1723.054351]  ? cifs_reconnect+0x26a/0x1620 [cifs]
> [ 1723.055325]  cifs_demultiplex_thread+0xad4/0x14a0 [cifs]
> [ 1723.056458]  ? cifs_handle_standard+0x2c0/0x2c0 [cifs]
> [ 1723.057365]  ? kvm_sched_clock_read+0x14/0x30
> [ 1723.058197]  ? sched_clock+0x5/0x10
> [ 1723.058838]  ? sched_clock_cpu+0x18/0x110
> [ 1723.059629]  ? lockdep_hardirqs_on+0x17d/0x250
> [ 1723.060456]  kthread+0x1ab/0x200
> [ 1723.061149]  ? cifs_handle_standard+0x2c0/0x2c0 [cifs]
> [ 1723.062078]  ? kthread_create_on_node+0xd0/0xd0
> [ 1723.062897]  ret_from_fork+0x3a/0x50
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Fixes: 9150c3adbf24 ("CIFS: Close open handle after interrupted close")
> ---
>  fs/cifs/smb2misc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 0516fc482d43..0511aaf451d4 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -743,7 +743,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, _=
_u16 cmd, __u64 mid,
>  {
>         struct close_cancelled_open *cancelled;
>
> -       cancelled =3D kzalloc(sizeof(*cancelled), GFP_KERNEL);
> +       cancelled =3D kzalloc(sizeof(*cancelled), GFP_ATOMIC);
>         if (!cancelled)
>                 return -ENOMEM;
>
> --
> 2.24.1
>

Good catch!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

The patch 9150c3adbf24 was marked for stable, so, this one should be marked=
 too.

--
Best regards,
Pavel Shilovsky
