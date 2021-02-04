Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31855C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9A6964F59
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 08:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhBDIOi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 03:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhBDIOW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 03:14:22 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B510EC061573
        for <linux-cifs@vger.kernel.org>; Thu,  4 Feb 2021 00:13:41 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id y4so2286667ybk.12
        for <linux-cifs@vger.kernel.org>; Thu, 04 Feb 2021 00:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BPgwAV2obMa1xppckZBrZIuKT+7tU9wODGCUL7FGj4k=;
        b=A1U+2AXsOdT67+4tgoMa/Y6699ihEVxZwyHXxOtfLSi2pmAGCjnlCkjrTTopbbLiv0
         qSNPzXvuHZbqM6A0MY1Q3pWm1PJ8bSaSBN/q6EpKoZbFtjUN1BFIGHRK0y42e3udJsTt
         +NFGcaSqPawE8UBqdvF8EvsfdGZtYRk/1Qsb/RgsznbY9fZoUFOK/01cI4zREEwbKO4i
         oHmN4sgjHv7Sj2tvec1q8/DxIMs8GCX5/Gi4A8+zLIoDoMXGt//VgjAtmyQzv0p7zAz5
         /wrEx4/pi5qZWkD4zxB2gHbP/wBQ6crOBG8+YFgrtmTY5mIRrKWqQWvWgXzp0gE75yE/
         Pzow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BPgwAV2obMa1xppckZBrZIuKT+7tU9wODGCUL7FGj4k=;
        b=cYzJeEUVBQdMkCXyHcJ0Kg+1MOGYLuNCATxcBgVeuaqWGWDzISC4Zi9Cz+RCKSjm22
         ViD5Jeph65mH94roLjk4bSNqE9ALDW1U/WGmWSPXb5MhK0ES2b/kKtXinOqAdMHIztEc
         IijW0XRSPc+l7xEQmATZw0kZPhKmSShdF0UoNvj52SMcsdArPTWzOsKwnBqDUOyzSpzL
         M+yyK5MF4WG7Cy0o2FnHA1xsdP0T9sb5LrL/YMWvPSLFgkzD6lQK0rjcam4kUwGXvQpg
         /0lyxkBuJQE0IPrY3loDoRthbTmuYYgyBxaW78esDkRg1S+6hHpr1UTS7cU0tiMc6c2s
         84rw==
X-Gm-Message-State: AOAM533R7gpNw0XAD/hgAS19+r78nTBk0FNH1jHk/OSeRs1N14iYLCnH
        dpMa+xJf0Vk2DMSXhdPIE6kpyIp9IGJgUkngzS0=
X-Google-Smtp-Source: ABdhPJwmNrJyn9OF5r4jvV0AMfn16UkFLJ3hwl+RFC+DJRP1PzfCG8w8KFfuhvncUyoqSGbXA6vzForcxmQVe4znSV0=
X-Received: by 2002:a25:83cc:: with SMTP id v12mr10201116ybm.293.1612426420941;
 Thu, 04 Feb 2021 00:13:40 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rUagVpf1aKEDVqL-DiY2+ceYUE7mLD1pGrajN-uopRig@mail.gmail.com>
In-Reply-To: <CANT5p=rUagVpf1aKEDVqL-DiY2+ceYUE7mLD1pGrajN-uopRig@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 4 Feb 2021 00:13:30 -0800
Message-ID: <CANT5p=og=n36LmWroyomC7nNdJvVHFpSQqLXtH0XGY1OzvVsCQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] cifs: Identify a connection by a conn_id.
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

@@ -97,17 +99,25 @@ smb2_add_credits(struct TCP_Server_Info *server,
-       if (server->tcpStatus == CifsNeedReconnect
-           || server->tcpStatus == CifsExiting)
-               return;

@Pavel Shilovsky This check prevented a tracepoint from getting
printed. I do not see much value in these lines, since all we do is
print the tracepoint and exit. Hence removing it. Please let me know
if that is not okay.

On Thu, Feb 4, 2021 at 12:09 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
