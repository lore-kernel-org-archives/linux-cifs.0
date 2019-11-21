Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E9CC432C0
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC9D2063A
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsTLSwcy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKUTpX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:45:23 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:39095 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfKUTpW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 14:45:22 -0500
Received: by mail-io1-f66.google.com with SMTP id k1so4892177ioj.6
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 11:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VDV5SFTANrZELkVvyrQ/CoJfbVsj9L2xX8wzNmZyhwg=;
        b=UsTLSwcyAffZeI84h9lZtz3vhZN+O2Q/U+8AeG4BuixweX8Z+w+F29ImxFdzT4ox8D
         RIGrVb08SotTOxxYXQz5J944mhOJEHG49FtYPm40u1BkvD9CfbcyQSyB/OBdZ1oi28Zd
         hqdU5aDwkcrAWag+Sgut0zqQVpfCL47lylKUaOJ5aDoLGi1VQrmnF+wRtMZWvaEGJ1fX
         yInaP05elu1Mw4YZ7zkwttU0N5E9R+aDs7GywRZSbqgW27nt5tx8YWtfZppWZGfkMWRe
         RoznsitHq7MA7bAH4B+KodQbBHF/jGy4NGLPomgqZfqQ6JN0KPJctxnNW/KXnQ+HO0n1
         gyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VDV5SFTANrZELkVvyrQ/CoJfbVsj9L2xX8wzNmZyhwg=;
        b=P0olmtI+HQnL7I/DnJ8iFtSZP043QjtcRmJl539p+oUL7m+HOWB59VdjcIkHQLuFnX
         v9NxREUaz/g9G//43LUUp58m/FCiZUXs6jK3DfTJHVetFqT1u8gpXk2Omwjw0/EV6e6N
         f27nR8LZzUeFjZodIVrBWP4atDF8S8I974ojQvc+OlFjiMB1mHzszZ/YV1NdIvHJH0Hw
         SqNtJjgAG+dIyIYtpGPar7AcdFbmD7GXT5kCNWnKFeqLgjUmBFjAA1unavSj9m9ya92k
         yd8UgTQkuivAKCGEw87W5qz8I2EqbGvAMxnoLUrIyLVb7yxM0m9tfP1JhVTQ08deozXP
         Vp/w==
X-Gm-Message-State: APjAAAWB2c/9lWvv75wdbxJG5IKmMkaw/Jofew285xwIymbsZeVlX1FO
        PMurHsrz3gdNsG8gewTBknlY9X8Wg0FwjSb+MMI=
X-Google-Smtp-Source: APXvYqxmXvBaBFkXgSp0UMVHzFTy9OB8Qd0CLC8OUW4BjWYUzrFWhZ1djruaYtKpSY5oqImjXtefVOCnemZ0J6eE52Q=
X-Received: by 2002:a05:6638:68f:: with SMTP id i15mr10375587jab.37.1574365521970;
 Thu, 21 Nov 2019 11:45:21 -0800 (PST)
MIME-Version: 1.0
References: <20191121193514.3086-1-pshilov@microsoft.com> <20191121193514.3086-3-pshilov@microsoft.com>
In-Reply-To: <20191121193514.3086-3-pshilov@microsoft.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 22 Nov 2019 05:45:10 +1000
Message-ID: <CAN05THRvYO05OMH-VH28PA7Bvnrfma8NvJD1AOxN=YGx15x7bw@mail.gmail.com>
Subject: Re: [PATCH 3/3] CIFS: Do not miss cancelled OPEN responses
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Frank Sorenson <sorenson@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Very nice.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com
>

On Fri, Nov 22, 2019 at 5:35 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> When an OPEN command is cancelled we mark a mid as
> cancelled and let the demultiplex thread process it
> by closing an open handle. The problem is there is
> a race between a system call thread and the demultiplex
> thread and there may be a situation when the mid has
> been already processed before it is set as cancelled.
>
> Fix this by processing cancelled requests when mids
> are being destroyed which means that there is only
> one thread referencing a particular mid. Also set
> mids as cancelled unconditionally on their state.
>
> Cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/connect.c   |  6 ------
>  fs/cifs/transport.c | 10 ++++++++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index e63d16d8048a..59feb2de389e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1229,12 +1229,6 @@ cifs_demultiplex_thread(void *p)
>                 for (i = 0; i < num_mids; i++) {
>                         if (mids[i] != NULL) {
>                                 mids[i]->resp_buf_size = server->pdu_size;
> -                               if ((mids[i]->mid_flags & MID_WAIT_CANCELLED) &&
> -                                   mids[i]->mid_state == MID_RESPONSE_RECEIVED &&
> -                                   server->ops->handle_cancelled_mid)
> -                                       server->ops->handle_cancelled_mid(
> -                                                       mids[i]->resp_buf,
> -                                                       server);
>
>                                 if (!mids[i]->multiRsp || mids[i]->multiEnd)
>                                         mids[i]->callback(mids[i]);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index bb52751ba783..987ffcd5ca3a 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -93,8 +93,14 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
>         __u16 smb_cmd = le16_to_cpu(midEntry->command);
>         unsigned long now;
>         unsigned long roundtrip_time;
> -       struct TCP_Server_Info *server = midEntry->server;
>  #endif
> +       struct TCP_Server_Info *server = midEntry->server;
> +
> +       if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
> +           midEntry->mid_state == MID_RESPONSE_RECEIVED &&
> +           server->ops->handle_cancelled_mid)
> +               server->ops->handle_cancelled_mid(midEntry->resp_buf, server);
> +
>         midEntry->mid_state = MID_FREE;
>         atomic_dec(&midCount);
>         if (midEntry->large_buf)
> @@ -1115,8 +1121,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>                                  midQ[i]->mid, le16_to_cpu(midQ[i]->command));
>                         send_cancel(server, &rqst[i], midQ[i]);
>                         spin_lock(&GlobalMid_Lock);
> +                       midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
>                         if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
> -                               midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
>                                 midQ[i]->callback = cifs_cancelled_callback;
>                                 cancelled_mid[i] = true;
>                                 credits[i].value = 0;
> --
> 2.17.1
>
