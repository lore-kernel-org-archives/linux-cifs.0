Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7EFC7EE22
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 08:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjERIoA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 04:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjERIn7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 04:43:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AACD10CA
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 01:43:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so2629406a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 01:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684399437; x=1686991437;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bp5WPsDb211i+pHuWpeMerEHDizBNNl1nHAqX/zCTPk=;
        b=TEYyofaVoid3I4IWT3N57TB7It6BEa8CW1ZdPttehMsK9QDVs4hQkv0l7VnBZ6GenD
         W8L9DsIxCPoX2d4tba62I1EoUdjaI4tpEcd8rmS1pKGqCXl21UVmHv2v7jBUWO4YLy0Q
         d5E4dn2iGoTGsO5KoBM5F7YP9zULROFuZv4XQBUWDvOeiARFNPwFrP6Di+SXvrKmiSHx
         FMjD8BPLParsCsID5nXGQmqxGVYvXWP1U5FDpHt3rGqKl+4CbcONvMXg1suF1TdUaZn+
         /dysHRuQjUmQPH+7PflIr3nHbKDqwZHWGtYGo8cOp0NDMc77+29cXPvh/5ECifXo+e4w
         ZKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684399437; x=1686991437;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bp5WPsDb211i+pHuWpeMerEHDizBNNl1nHAqX/zCTPk=;
        b=dqiclrdj9TUocKqLNro4G5NKcE1ac6s2yA7amATthn6ScoC4Ig8nbpsBFwVLck5ZgD
         a7gqJP9sMw1L+KDwO5jRnQvy7CMNNU34M2qSJ8Kuq66bfHyHBErrczRA1zI1GTuOr8jW
         8rWtPjf0tOpB45nGVZYZrcIhrOPOdT0nfxuZQVyVQGyCFX2rchLJrjHcZJ+R5D23kGj2
         A/inSIISgXf+G6YsoXstPRF7XEbGshVadg73WZTIR3IkQoktSyOuauRV7QQwKLUA3FJD
         ODB1JKmqIT6yyZG3xrpiQuu2R/Gr8eL/c0FAhj8c7yVwDY0WlhNE03hqHHsHAAQH46N0
         QJ9g==
X-Gm-Message-State: AC+VfDzs6WIaOG8+CMqZljBgViL0HxyfpatA0u3LARQYYHWBcwUt++Sa
        HF1HAY11NcCFw1653/zcq6eZqtvXR9GAVOGzEbE=
X-Google-Smtp-Source: ACHHUZ4ScL9k12hJzZTjTyO1Iqz+3FfyWkL61IbV0mLyL+TsSAgpP6j7cQnbDn5WXyM6TUGT5WLv6u9wFY+f6gF13bc=
X-Received: by 2002:aa7:df0d:0:b0:50b:c42b:b737 with SMTP id
 c13-20020aa7df0d000000b0050bc42bb737mr4103114edy.37.1684399436593; Thu, 18
 May 2023 01:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230517095951.3476020-1-h3xrabbit@gmail.com> <20230517110505.GB20467@google.com>
 <20230517111325.GC20467@google.com> <CAF3ZFef4gmEVZR5riwdB1bkB4CccziGw3g18cyz7Sim4xw+ZDw@mail.gmail.com>
 <20230518003340.GD20467@google.com>
In-Reply-To: <20230518003340.GD20467@google.com>
From:   Hex Rabbit <h3xrabbit@gmail.com>
Date:   Thu, 18 May 2023 16:43:45 +0800
Message-ID: <CAF3ZFecyPN-4UP51K9e70LRkvtdRqSjAWJqJM7V2_4vEpGeCbg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix slab-out-of-bounds read in smb2_handle_negotiate
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linkinjeon@kernel.org, sfrench@samba.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

>    Oh, I see, is that what you did in your reproducer?

Yes, that's how I reproduce it.

>    I'm still puzzled by smb2_handle_negotiate+0x35d7/0x3e60 in the original
>    stack trace. 0x35d7/0x3e60 certainly doesn't translate to "start of the
>    function" to me, but what do I know :)

As you can see in the assembly below, the call to asan_report_*
functions is placed
at the bottom of the function, that's why the stack trace looks like that.

```
; smb2_handle_negotiate+0x216
.text:FFFFFFFF81FDA4F6                 test    dl, dl
.text:FFFFFFFF81FDA4F8                 setnz   al
.text:FFFFFFFF81FDA4FB                 test    cl, al
                  ; KASAN check
.text:FFFFFFFF81FDA4FD                 jnz     loc_FFFFFFFF81FDD80E  ;
jump to report

; smb2_handle_negotiate+0x352e
.text:FFFFFFFF81FDD80E loc_FFFFFFFF81FDD80E:
.text:FFFFFFFF81FDD80E                 mov     esi, 2
.text:FFFFFFFF81FDD813                 call    __asan_report_load_n_noabort
.text:FFFFFFFF81FDD818                 jmp     loc_FFFFFFFF81FDA503
.text:FFFFFFFF81FDD81D loc_FFFFFFFF81FDD81D:
.text:FFFFFFFF81FDD81D                 mov     esi, 4
.text:FFFFFFFF81FDD822                 call    __asan_report_store_n_noabort
.text:FFFFFFFF81FDD827                 jmp     loc_FFFFFFFF81FDAFA7
.text:FFFFFFFF81FDD82C loc_FFFFFFFF81FDD82C:
.text:FFFFFFFF81FDD82C                 mov     rdi, rcx
.text:FFFFFFFF81FDD82F                 call    __asan_report_load2_noabort
.text:FFFFFFFF81FDD834                 jmp     loc_FFFFFFFF81FDA558
```
