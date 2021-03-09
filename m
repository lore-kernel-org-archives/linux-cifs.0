Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66708C433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:41:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3963E65287
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhCIAkq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhCIAkO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 19:40:14 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4936C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  8 Mar 2021 16:40:14 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id i18so10574060ilq.13
        for <linux-cifs@vger.kernel.org>; Mon, 08 Mar 2021 16:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+i/vNDTNwVcEqLifkidqN8CQmv9H6mgFlj1YVr/n/uw=;
        b=AcVh29IJIoouCgfrLCuuaniFz8j676ZZcY9c/s3l/tMO3Jbc+M3MaGsSnKfbXt2bRa
         IdisX561oGYmo5ea5DkUL7D/VXdNlk2ZMYc7s9yw9Dc00x/CgDu3YUlljEVpCWI06wfU
         S0gZRf9Ve0V9FtxKPEKjWF85tOPs3YxCQDx+stbSb0Yiwj/pHY0mv+wcL3B3jhk8VvIB
         TT7g8zA52a2+k5yAMAAC8oT1ZI8KMgMrZ6z9adcbI9MMHFWAkPi844gg7OoA8d/N9xQa
         WJPwHHqo+yFP1gDPixuzfsZULiq4RhmG8tero2RKkCt7uMvNCX+1pG1dDtNs0ThHc/Tk
         TVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+i/vNDTNwVcEqLifkidqN8CQmv9H6mgFlj1YVr/n/uw=;
        b=TH0aXAWmI3NCnT83z2zuc6M7aKAdLBz2K6Bw6VAnw68zZ0WU3TAn6FU7FLY1enTa5E
         +idu1sU5qlas1BRpe076JzpZhFmIWk5uku76ATvSwsaHSa53wnptsQWNQ4VFoH66gn2Y
         p+O6qjeSunl6oxd4zjdukTPmG4ZSWQ0grKCbt55Uzpyzg51JqXM3W+UbmQdw9YHybsqQ
         xoiv7dKEbv5neuiQmCSvAAHOROmS6DpYjyDhfKmgj6HxkedLhbyU2oES5DtVPG9JqcX5
         RQYTXs/gnTb3ACZLxmbc6N2vWhl0ATSHQanHZVsTnogOpjOsFuqaBb7nLe8c6mHZBnEp
         4WGg==
X-Gm-Message-State: AOAM531dau2KZyyqCekbjasyw2Z0NFqSY0gsHPq4j0i2P8oZ7mvya1YB
        OEOr5IYrOIImQ2t3ljjiBAIInkGN4wammh4s2UV4S2KA
X-Google-Smtp-Source: ABdhPJykE6b3K3GnvlM5wWMzzwzPMCiFrZpla4N7WpQm8g1m7XXchvsvtJSbxAttX3CzwnRRhhiKgvpCx6FzlDtZozM=
X-Received: by 2002:a05:6e02:10d1:: with SMTP id s17mr22448851ilj.159.1615250414291;
 Mon, 08 Mar 2021 16:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20210308150050.19902-1-pc@cjr.nz> <20210308150050.19902-2-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-2-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 9 Mar 2021 10:40:03 +1000
Message-ID: <CAN05THS0e8-c_2WNpy5UZUbbCjPwSQ+N6jM0O9834TGv_5c4Qg@mail.gmail.com>
Subject: Re: [PATCH 2/4] cifs: change noisy error message to FYI
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Tue, Mar 9, 2021 at 1:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> A customer has reported that their dmesg were being flooded by
>
>   CIFS: VFS: \\server Cancelling wait for mid xxx cmd: a
>   CIFS: VFS: \\server Cancelling wait for mid yyy cmd: b
>   CIFS: VFS: \\server Cancelling wait for mid zzz cmd: c
>
> because some processes that were performing statfs(2) on the share had
> been interrupted due to their automount setup when certain users
> logged in and out.
>
> Change it to FYI as they should be mostly informative rather than
> error messages.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 7bb1584b3724..f62f512e2cb1 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -1248,7 +1248,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         }
>         if (rc != 0) {
>                 for (; i < num_rqst; i++) {
> -                       cifs_server_dbg(VFS, "Cancelling wait for mid %llu cmd: %d\n",
> +                       cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
>                                  midQ[i]->mid, le16_to_cpu(midQ[i]->command));
>                         send_cancel(server, &rqst[i], midQ[i]);
>                         spin_lock(&GlobalMid_Lock);
> --
> 2.30.1
>
