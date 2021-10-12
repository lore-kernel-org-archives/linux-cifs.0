Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9B7C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8546060EE2
	for <linux-cifs@archiver.kernel.org>; Tue, 12 Oct 2021 01:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhJLBDY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 11 Oct 2021 21:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhJLBDU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 11 Oct 2021 21:03:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746D8C061570
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 18:01:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w14so22564194edv.11
        for <linux-cifs@vger.kernel.org>; Mon, 11 Oct 2021 18:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FE54yzqpeHMsrtWUNMW7qd0RQhbytreUrtaMZhUvR2g=;
        b=FWgwne86sNt/ftvp+1OIYCa3cjKIDdV2qVoXC2Cd1FYbcBZwqdn9ZVXRCw3DhYsZvm
         vkIp11cib+W/4MAjUsQg85e329p04bEnJ8FZyveJ7tGZCt/AFG0Ln1FfOKPsFwn+XtW7
         1pyb/u8YbwKQHkGp/wqTBkg56ne/pn/Y+ghk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FE54yzqpeHMsrtWUNMW7qd0RQhbytreUrtaMZhUvR2g=;
        b=bYXDe2wCSLsYSWuvtzmD+kcdnLEjUQtS67YZD22V5VEn4roFHS8GQNaBaamxICTnNe
         jAhaOa7R5XRs56V0faiTPFNd6kcTc2i64KUbiQ4BsMui7e2owQ1Pb5S1oZWTSUZIvsSv
         gFX+aay+fAZ6YFC/XV1TENDTzndNnYDcy81mR4js1qEHaoIegxDhVLe3M30i9VXbGjAY
         dA4H4GOw3hH0SWfP7W6pKq2N2xWKWgmocmpFF5W2JD1+8BVXGrRfbHWJRdK3ASFpRIWM
         7S18TsgYt+9sq+zvh+0DoT8OxMsP0jH7AMuU5+cNlukz0tOiG85e+C95+03Xjsn4W3qV
         LSdg==
X-Gm-Message-State: AOAM533g7xJG3TuSAOj4+UO7p356V8FQz3xUuz2LEw2P6FQI6p4hpmL9
        CQbrhjEmjL4iUk0OTaNFsDHU5xArkcL4k2DDZtW43w==
X-Google-Smtp-Source: ABdhPJxLr1zAhLHmAh5CcWYQtTO0CEdz7ybPGOEU0kNvtBjWloZ5ehaxWsa3Cnb1OccmCC56dOY2Cgy91MjNnC/5QS0=
X-Received: by 2002:a05:6402:21d2:: with SMTP id bi18mr45735016edb.21.1634000477476;
 Mon, 11 Oct 2021 18:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20211007223103.5340-1-linkinjeon@kernel.org>
In-Reply-To: <20211007223103.5340-1-linkinjeon@kernel.org>
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
Date:   Tue, 12 Oct 2021 10:01:06 +0900
Message-ID: <CA+_sPaq-HaWAieyGksXaBW42PPnUq5K0MOauojv7QP98018mCg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: limit read/write/trans buffer size not to exceed 8MB
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 8, 2021 at 7:31 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> ksmbd limit read/write/trans buffer size not to exceed 8MB like samba.
>

[..]

> @@ -284,6 +284,7 @@ int init_smb3_11_server(struct ksmbd_conn *conn)
>
>  void init_smb2_max_read_size(unsigned int sz)
>  {
> +       sz = min_t(u32, sz, SMB_MAX_IOSIZE);
>         smb21_server_values.max_read_size = sz;
>         smb30_server_values.max_read_size = sz;
>         smb302_server_values.max_read_size = sz;
> @@ -292,6 +293,7 @@ void init_smb2_max_read_size(unsigned int sz)
>
>  void init_smb2_max_write_size(unsigned int sz)
>  {
> +       sz = min_t(u32, sz, SMB_MAX_IOSIZE);
>         smb21_server_values.max_write_size = sz;
>         smb30_server_values.max_write_size = sz;
>         smb302_server_values.max_write_size = sz;
> @@ -300,6 +302,7 @@ void init_smb2_max_write_size(unsigned int sz)
>
>  void init_smb2_max_trans_size(unsigned int sz)
>  {
> +       sz = min_t(u32, sz, SMB_MAX_IOSIZE);
>         smb21_server_values.max_trans_size = sz;
>         smb30_server_values.max_trans_size = sz;
>         smb302_server_values.max_trans_size = sz;

Does SMB2 support max request size of 8MB or does it support requests
of only up to 64k in size?
