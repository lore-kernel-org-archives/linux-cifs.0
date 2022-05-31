Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6028FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 01:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiEaBxZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 May 2022 21:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiEaBxY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 May 2022 21:53:24 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407609154B
        for <linux-cifs@vger.kernel.org>; Mon, 30 May 2022 18:53:23 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id 68so12262070vse.11
        for <linux-cifs@vger.kernel.org>; Mon, 30 May 2022 18:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=psFSP3VPv08Y22xJMmD3Ac3eD4Nn8qeV033aVe5UV6Q=;
        b=iIvwXK5w4+3nUMBF8+J8KWJLebmoy+RJLNQ2IDynuJ7am4ZpUFkHJjaCXhk2OjNhOB
         7zBYcPJg9Mi2TpZbcV88otQE9hh6qopmVYSRFadb6Ee99dLJa50S/A4aCFv2trTO9nPY
         dNOdOz10/TaJg5LWTXeZbGcxLZM0MSu3UywY44oJhxlANhzWXM6ziAFhl0v9W1nZn8h9
         XUYkEk+7cqeJj66krR5fR/UyRriOMdGt4aLdwbqePJPf3QzT9FTcrdjQ0eYhDodBIbgY
         jjAHZS4urltF4bfDIWJPYjgdg1Duc49Ob+CdlQ1UBmTxhVeJdNdHI90fWZy2r7gka6w3
         MUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=psFSP3VPv08Y22xJMmD3Ac3eD4Nn8qeV033aVe5UV6Q=;
        b=pDlm8lDfLWvE7z3QlLLM0ivhWJeYtFsJQsMFH2hDFl+xuaTq7npZBy8hSINxesCDyM
         eEM66zho3lceiSL9HKWdL1rcb/21GArtqpXCU4fH9Qmwk/htcNnupXiBgfGo0V92EsW5
         7My+Gf7YGEdaeDHNpk8vaFdVoGe5++zfMjLu1OTwYv2LEazvhQRI+lTLqhacpfTVTH+T
         GDWGfL34tw388c+hKYQCBF+GBGFkhd8q9kYsmCdv5jPWviC2nKx07xBVGhdBnSTR0pyy
         LWhqq2/vkvePQxUoi3EDnDXgGTyk84QHAnDseYUH+2Npx7G8QA5kTq2I4I4CgrYVxO/c
         uyvQ==
X-Gm-Message-State: AOAM5309E3mxVYsP4lGP9F5gtZwIaef9UGm52b91gZA+VK9DVS8Io9vA
        SvQQkL4/VPUVWWjv7OMDa7CbccQZLsY05DtlSNrgBgJ+jx4=
X-Google-Smtp-Source: ABdhPJzxN0g2vAtiYWpJaeiZOZzXeHbRd273ZZc4Eql8P8JSMgrEhr3UbMkmDyYhzZPBXunv8ewhQJwxuJXgZSsctJI=
X-Received: by 2002:a67:1787:0:b0:337:d8cd:35b2 with SMTP id
 129-20020a671787000000b00337d8cd35b2mr13411234vsx.29.1653962002178; Mon, 30
 May 2022 18:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muLr-UKAhcoP-s2Hn=U=Hbe2PtTLKODD+biSzQS8FkfZg@mail.gmail.com>
 <CAKYAXd-k6t+CL3DiZCPNyW6F10JbGnBrXmddAEMsVxaBrzbsBw@mail.gmail.com>
In-Reply-To: <CAKYAXd-k6t+CL3DiZCPNyW6F10JbGnBrXmddAEMsVxaBrzbsBw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 May 2022 20:53:11 -0500
Message-ID: <CAH2r5mvATTm7izD_wR-Mz41J4sa5F8X+x9h5ADX3Njo=vHw-DA@mail.gmail.com>
Subject: Re: xfstests passed for current mainline against current ksmbd-for-next
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added four more tests to the last run (and 9 more just before that) ...

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/110

Improving regression testing ... there are a few bugs (e.g. test 615)
that if we fix we can add even more ... good progress.

On Sat, May 28, 2022 at 11:04 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2022-05-29 12:53 GMT+09:00, Steve French <smfrench@gmail.com>:
> > http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/108
> Thanks for your test!
>
> >
> > --
> > Thanks,
> >
> > Steve
> >



-- 
Thanks,

Steve
