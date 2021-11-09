Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5143FC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 09:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 290096105A
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Nov 2021 09:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244894AbhKIJaG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Nov 2021 04:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbhKIJ3s (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Nov 2021 04:29:48 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E534BC061764
        for <linux-cifs@vger.kernel.org>; Tue,  9 Nov 2021 01:27:02 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso1758394wme.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 Nov 2021 01:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y13xS3bkhDD8sq/nkzPVK6NqULMv8SmJcWTNDrdqGrY=;
        b=CGX/lAIyxrXclxR+1+JgAm6+veL6nCwvVxVSYVqhCY0Yo2Cb90s0LXtEG2/7yiwOCG
         28Tv+e8gXhhLTdQ6i/Vf13DQ8dqbEn4BB3+ZuFDSpV/bldDkIH+LnpkGERN48lUAcoh/
         ezZRHL1hiv9J4Mj48k5z1u2UR2NOhj6sGbJuvIUe6fLlOhYsehvlt1Pcu+a+serW8UST
         PCY3sC9L/xkdcfgoIs1HSPueWztbjz1Deoedl5Qs8Bprpjs+VcZ1oqmN+wCSQAUBtIUq
         JBfZxhy56JpCYFW9281+VDXCBQpecIN9ObiwgIMLcuW7aSIJwwvkh1A/9cPmRl3awm03
         uhhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y13xS3bkhDD8sq/nkzPVK6NqULMv8SmJcWTNDrdqGrY=;
        b=CB8uEtJvXYiVZ5TXPgnC95SpVQ93bp/Lcou1E2YAE+ctU8fsuNHWVkdNIpHKpoqxSf
         pcu3mIi/YmAKeKvFMdNQIGOxABOFHuPXc9ApcnrcCZsh9mxGlx0u3ZkXsFz+9F/fAS1i
         Dg7kkbM0hW4OuXWUIM/qdVsarPLhImTKc04uvwyeVL1xHHvVBaKlm3deZtRCxJpcPo9U
         KoPocuELJyWxK2EUHWoEfzcuECQOUf+rmYjdSbVfYnMYJpiZ5GJDNqJxI1fWQFBcghQK
         szhcp3VxoFp1WJdHPiyOJn56lapR0m5fJFzyWhtVILQJU9OBoANWIvTJR04YQWM4iEk7
         5shQ==
X-Gm-Message-State: AOAM532cj6BKtnBHNhFm9hvmEQHudUvqxDjlHNXEUOsuc4bPxjr2JBvx
        ftYGTrA71XiMEGRtZy7Oqnw=
X-Google-Smtp-Source: ABdhPJw5jP+Zs6LhhkaDYLP6WXRgt1eNx3WCr10fs02JD2uiWps4Bt5ZenlgGetzVHy3qSjMCPUPhw==
X-Received: by 2002:a7b:cd90:: with SMTP id y16mr5651603wmj.84.1636450021508;
        Tue, 09 Nov 2021 01:27:01 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::cf8b? ([2a02:908:1980:7720::cf8b])
        by smtp.gmail.com with ESMTPSA id h18sm20820694wre.46.2021.11.09.01.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 01:27:01 -0800 (PST)
Message-ID: <eadd8209-7dcf-30fe-2c8e-cc0fd7c823a1@gmail.com>
Date:   Tue, 9 Nov 2021 10:26:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>, Jeremy Allison <jra@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <24b60b8a-febb-cee9-d96b-d7b8469309a4@gmail.com>
 <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
 <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
 <YYlUgc6UOyKfZr7d@jeremy-acer>
 <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 09.11.21 um 09:10 schrieb Steve French:
> Yes - here is a trivial reproducer (excuse the ugly sample cut-n-paste)
> 
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <string.h>
> #include <fcntl.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> 
> int main(int argc, char *argv[]) {
> char *str = "Text to be added";
> int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
> 
> fd = creat("test.txt", S_IWUSR | S_IRUSR);
> if (fd < 0) {
> perror("creat()");
> exit(1);
> }
> ret = write(fd, str, strlen(str));
> if (ret < 0) {
> perror("write()");
> exit(1);
> }
> openrc = open("test.txt", O_RDONLY);
>          if (openrc < 0) {
>                  perror("creat()");
>                  exit(1);
>          }
> fsyncr_rc = fsync(openrc);
> if (fsyncr_rc < 0)
> perror("fsync()");
> fsyncrc = fsync(fd);
> closerc = close(fd);
> close2rc = close(openrc);
> printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
> rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
> }
> 

I can confirm this fails on my machine without nostrictsync:

$ ./test

fsync(): Permission denied

read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0

and works with nostrictsync:

$ ./test

read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0

So is the bug in the Linux kernel?

Best regards,
Julian
