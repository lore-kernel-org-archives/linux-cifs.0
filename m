Return-Path: <SRS0=5iq/=YC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2643C47404
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 05:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B009821835
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Oct 2019 05:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUD0XBWb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730535AbfJIF0D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Oct 2019 01:26:03 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:37501 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730451AbfJIF0D (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Oct 2019 01:26:03 -0400
Received: by mail-io1-f66.google.com with SMTP id b19so2254678iob.4
        for <linux-cifs@vger.kernel.org>; Tue, 08 Oct 2019 22:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=llQjwFCkWFvemKgvZMrQigMoqnfNyLyu1fyRmxHKrFk=;
        b=BUD0XBWb78SQaZJcN23hSv+OqFjyrQoSOvLoKmE8i/vJbEN6/LiUJha8QsDBpXK0PX
         j3rsYHoVMM0qkLz1xnxRfJHmrNaoFlnb3flbfkyi9iBWMt0swMyEWyVGhv4yY8/msX9P
         u5ev8YwRRWOsx2iu49ufxBsfembOOJkhQ+2sqKuSI3HUiBz0aUwB36+IVtBMNv8pcz7z
         kPxG+2XIm33XcNmWRhlIMY5FFfHfTdTCTqVfo3d61crJdm5kYaYTdYXdO+wnuTzRyFrg
         6mNbkkGwrqMyhq/K5Wg6dkmyLhSZq47T5JEhmYfjlER0far5M4nDQK2QS47mhjkBgLhi
         MTnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=llQjwFCkWFvemKgvZMrQigMoqnfNyLyu1fyRmxHKrFk=;
        b=bNswQrIPzO8Njch+YzML9ih1XaQWle0CqGbBZ78bkFainEqIBuAQ3p/CAZz5Fx5dOx
         8RArXXigg70hc9WW+/j+010ZUIW186cn0lamFtHjgcR1WOpYB4ExZVoy1QCHAFkMi3LV
         EUZMwweysZnN8hq7F+9hPwRRUiD1wvEjPg3gvRZ83ASMeaQE0JKvXzvIIUfF+e31a7yC
         LYkpXZTFmBl+Inr3U3G0mMe9tZqQYRLlZ0LzUqJst1LL3FXhIpXWcJl+d1sGw9BdXVxL
         uOn/1b47DR9R3Ef7/1lbliKX4MIONZaKR3Kj3IqqEHboLFv+mSqWmBIFDTV0YLNmteol
         XD2w==
X-Gm-Message-State: APjAAAUMtr8UL6Eib0+QSSglXFwFvNZdtlLx8vgLKxuVUGTCh8zzaT5i
        B+6PyreYDuG8QMWS08SYgb1Yb9NvkWqSQyQ4Ia4=
X-Google-Smtp-Source: APXvYqzoKJGpimqueLHBtcfPr/CNmcFiLbwx/Gz0yPgHHSjUae/KDhqOe5Xj/nn1GW8VNOqS4RLmYjXtZuNuxchztXI=
X-Received: by 2002:a5d:8b49:: with SMTP id c9mr1765424iot.209.1570598762203;
 Tue, 08 Oct 2019 22:26:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191009045136.5065-1-kdsouza@redhat.com>
In-Reply-To: <20191009045136.5065-1-kdsouza@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 9 Oct 2019 15:25:52 +1000
Message-ID: <CAN05THRJFytC1eVGz87k-8KfuNesVGmZuFV0i-nPvXtOZLP2yw@mail.gmail.com>
Subject: Re: [PATCH v2] mount.cifs.rst: update prefixpath mount option description.
To:     "Kenneth D'souza" <kdsouza@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 9, 2019 at 2:51 PM Kenneth D'souza <kdsouza@redhat.com> wrote:
>
> This option is ignored after kernel v3.10
>
> Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
> ---
>  mount.cifs.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index ee5086c..f1a57d1 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -590,7 +590,8 @@ prefixpath=arg
>    It's possible to mount a subdirectory of a share. The preferred way to
>    do this is to append the path to the UNC when mounting. However, it's
>    also possible to do the same by setting this option and providing the
> -  path there.
> +  path there. This option is provided for backward compatibility.
> +  It is ignored after kernel v3.10

3.10 is pretty old kernel. An alternative is to just delete this
option from the manpage.

>
>  vers=arg
>    SMB protocol version. Allowed values are:
> --
> 2.21.0
>
