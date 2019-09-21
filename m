Return-Path: <SRS0=rQDn=XQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7B0C49ED7
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 11:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60708208C0
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Sep 2019 11:04:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EONTNvmz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407491AbfIULEX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Sep 2019 07:04:23 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35082 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407428AbfIULEX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Sep 2019 07:04:23 -0400
Received: by mail-io1-f67.google.com with SMTP id q10so22192042iop.2
        for <linux-cifs@vger.kernel.org>; Sat, 21 Sep 2019 04:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JWt1IASd9oF0mgCyt/zQRwS7Xn2utBJAoi3D1m5FgXc=;
        b=EONTNvmzspA8GDk8wVeZRyMlo6P7thhQuHjG4ZM6VHHzMPHaQVnDGw/zmekZ+V9plP
         JtMQpCgTPie5ZYmVXNIi+yTasFxRWsiumsVkd7fH5EX21kMBI08IHgf8hZfVVWU0Bg15
         uslqySoq9ZV2arn8Os8IK6dBnVI3TtvzQ5OY849Mr6QrXX12GGOHmSQ78gB9w8hkmS+X
         Y9BKYhaNrHFZe7xHrfknKDIUafgqNPfRifFep9uAu0nkbZp3sV3d3pV6XRyra90MMqb3
         mv5Tt5YAo1irU78mYIWIDFfmHwkHVIDWnntW510Z3GRfx3WE54GZGgUhDGgt5n63r/Yz
         LaSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JWt1IASd9oF0mgCyt/zQRwS7Xn2utBJAoi3D1m5FgXc=;
        b=DgX9XBteo/5Bpo7buhIZLxnDV4GQnH2VH27GXAJYfLWh65Srx1WnWXx/GODskWpqrQ
         rroZEf2Lib8vj2mdzXOrPG+zW0wOsdvvNjJiKQSjyZ7gJTihtNCu6+eQ4F0XKdB4feQD
         pD8guJ+8nNXGk7BmzPbBjNZtejfJyRqKQxpMxHRhZvUIf7UrsrecEYOIPLWMJxMUKEUy
         qdUbTVA+8rAmpgFwueLSQG0qBmXNlCVE5C6y0Z62KfLOh7V8cUYCA+/KhQVzhW5rRA1e
         7t0d6eCDz+ZvXZfERMPRl30T/qp8XLLfNy/5uXsa+y+XYBMXvvx2+mw1YJMxx6+Fim+r
         nrHQ==
X-Gm-Message-State: APjAAAUepdU2Zm/QZIAEsGZadDHVkrLLMT1jrWa8kCQ667nqdDc1pXYz
        zYRta26XX98/30ZrLxrSxhyCPsLsQvFZi3qcgMY=
X-Google-Smtp-Source: APXvYqzKy2PW37yoPXK+m9YutDBZh0VmN/C63ia969R0SnpE/I2otkAjxhHSupUsFWZJHdwswH/ILzSMHAuHymPuWAg=
X-Received: by 2002:a6b:5f11:: with SMTP id t17mr3768051iob.169.1569063862753;
 Sat, 21 Sep 2019 04:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvcRuSihH58GgrzXTAHuXnQ9a0N-d8AkLLOigQrqincKg@mail.gmail.com>
 <CAH2r5mvAw3ShBpy39OodU8EgXqR0rFBmAk0TXJbug1N22R8o4w@mail.gmail.com> <CAKywueQW84FxiG1QEmWSJdJiUAiVbYr+0hYVPc4ypW8OAtTZYQ@mail.gmail.com>
In-Reply-To: <CAKywueQW84FxiG1QEmWSJdJiUAiVbYr+0hYVPc4ypW8OAtTZYQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 21 Sep 2019 06:04:11 -0500
Message-ID: <CAH2r5mtpobejtzvmnE5fUhNfYvVRb8zgPEEm+aJu9HTzLmYVNA@mail.gmail.com>
Subject: Re: [SMB3][PATCH] dump encryption keys to allow wireshark debugging
 of encrypted
To:     Pavel Shilovsky <pavel.shilovsky@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 20, 2019 at 12:14 PM Pavel Shilovsky
<pavel.shilovsky@gmail.com> wrote:
>
> Thanks, this is very useful functionality! A couple comments below.
>
> kernel patch:
>
> + cifs_dbg(VFS, "ioctl dumpkey\n"); /* BB REMOVEME */
>
> please remove this or change to FYI.

Good catch - removed and repushed
