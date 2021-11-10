Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30E2C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 11:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81E04610D2
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Nov 2021 11:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhKJL0P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhKJL0O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Nov 2021 06:26:14 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FEDC061764
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 03:23:27 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id z200so1838260wmc.1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Nov 2021 03:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=E/a7NBNUUGrso9VrT9R4pv0jidhMMgrlfWyjSHPZaGY=;
        b=Gps8TUQhHKS5RQmlP1C7XkXbzI0hCiK2u4PNoLK4puOIaSmuCZgPM4mgzdDgKU4nkj
         6cYTQCaUoVriFYOdo40BSlEVVEeWLXSUfJwYeVjFqwditBIclLE+NXl6nlokwdkkjEMa
         tasctnHsAy+4FE//YLGZvDDBYtk17/nz/6I+vVyCShLIkTreEkeTEyXA60HpDvmj9R9F
         rAv0hzgACZVRhAIehlDsTQxpMWLxyvS5m5quS4qtkeGIzeD4Wdx12cv8D//ELy79Xze5
         SQYtG7spcS3ukt/Ak0ehtRpN8eDdF80J7XB5kUt7S6Cs2wT2BrX0XPcEpMYT9aFSg0xT
         2atA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=E/a7NBNUUGrso9VrT9R4pv0jidhMMgrlfWyjSHPZaGY=;
        b=zI/D7tPrNPaTAQEL0o2U8Xbl22fHvp80+eZaY6jw/f4hVuDyouNM2nw5EJVqFWRGD+
         iNKjd0Qic/ceFDsANvw5zc2nPSx1NwfMxF1EP8wiRS519L8azQsTYtfyY0a6oMB3pFv2
         IyEJwaOXhJrhvCv6ktvgt5bkx2knayVUVDHU9oXbi8Vkxy20eO/gud/OdXcZqi9GT1w2
         GQhPKinVz7Q4iiOqFF9JOnoqZjDop4DBEmgRWZe0y/npMC5L+ro2AQceUyhlrS1kY3Yl
         OxhSnBxGeK4ekmZlEJotS2Hhbg1R2OWtVSmJyTkouY6xT66hCAuiIK3P3UkjpOJTXycy
         XcDQ==
X-Gm-Message-State: AOAM530ZYtjsIwALf/7wz7h8PHPboWlUH4/Ivfdk7mOjgymHd6cPZqTA
        Rr29bBOHFdDFA6Zbxy1ElQxb4qAFdWEDRw==
X-Google-Smtp-Source: ABdhPJxH0F/rRSPuf2qtxwIbu4sk8dObtB2kKDncfQHBkZsxcUDVXM1l1axc19bC3Wo+zaSPCsmPWA==
X-Received: by 2002:a05:600c:1549:: with SMTP id f9mr15739267wmg.118.1636543405669;
        Wed, 10 Nov 2021 03:23:25 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::7039? ([2a02:908:1980:7720::7039])
        by smtp.gmail.com with ESMTPSA id c6sm6551082wmq.46.2021.11.10.03.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 03:23:24 -0800 (PST)
Message-ID: <c9af96be-bb75-9487-4f9c-1a53b41e9210@gmail.com>
Date:   Wed, 10 Nov 2021 12:23:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>, Jeremy Allison <jra@samba.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <YYhI1bpioEOXnFYf@jeremy-acer> <YYhJ+8ehPFX1XDhv@jeremy-acer>
 <7abcce96-9293-cd47-780b-cdc971da07e5@gmail.com>
 <YYhXjG46ZZ1tqpxJ@jeremy-acer>
 <5c25c989-1e58-fb23-810f-a431024da11e@gmail.com>
 <YYiCAcxxnIbHz4xv@jeremy-acer>
 <cd649ed2-60d3-72e3-e09a-9f0074af99cc@gmail.com>
 <YYlUgc6UOyKfZr7d@jeremy-acer>
 <CAH2r5muWLJu_Yhx1pv0rCaTRPqeEd_8X8DP2cipUVaMekU9xFg@mail.gmail.com>
 <eadd8209-7dcf-30fe-2c8e-cc0fd7c823a1@gmail.com>
 <YYsYKvyevyXjHgku@jeremy-acer>
 <CAH2r5mtNxiw8gOTPJe0GopBnkkMspHvsMD+0_K2+kc2VbrgdBw@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CAH2r5mtNxiw8gOTPJe0GopBnkkMspHvsMD+0_K2+kc2VbrgdBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

W dniu 10.11.2021 o 08:56, Steve French pisze:
> Fix for the kernel client attached
> 
> 
> On Tue, Nov 9, 2021 at 6:54 PM Jeremy Allison <jra@samba.org> wrote:
>>
>> On Tue, Nov 09, 2021 at 10:26:59AM +0100, Julian Sikorski wrote:
>>> Am 09.11.21 um 09:10 schrieb Steve French:
>>>> Yes - here is a trivial reproducer (excuse the ugly sample cut-n-paste)
>>>>
>>>> #include <stdio.h>
>>>> #include <stdlib.h>
>>>> #include <unistd.h>
>>>> #include <string.h>
>>>> #include <fcntl.h>
>>>> #include <sys/types.h>
>>>> #include <sys/stat.h>
>>>>
>>>> int main(int argc, char *argv[]) {
>>>> char *str = "Text to be added";
>>>> int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
>>>>
>>>> fd = creat("test.txt", S_IWUSR | S_IRUSR);
>>>> if (fd < 0) {
>>>> perror("creat()");
>>>> exit(1);
>>>> }
>>>> ret = write(fd, str, strlen(str));
>>>> if (ret < 0) {
>>>> perror("write()");
>>>> exit(1);
>>>> }
>>>> openrc = open("test.txt", O_RDONLY);
>>>>          if (openrc < 0) {
>>>>                  perror("creat()");
>>>>                  exit(1);
>>>>          }
>>>> fsyncr_rc = fsync(openrc);
>>>> if (fsyncr_rc < 0)
>>>> perror("fsync()");
>>>> fsyncrc = fsync(fd);
>>>> closerc = close(fd);
>>>> close2rc = close(openrc);
>>>> printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
>>>> rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
>>>> }
>>>>
>>>
>>> I can confirm this fails on my machine without nostrictsync:
>>>
>>> $ ./test
>>>
>>> fsync(): Permission denied
>>>
>>> read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0
>>>
>>> and works with nostrictsync:
>>>
>>> $ ./test
>>>
>>> read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0
>>>
>>> So is the bug in the Linux kernel?
>>
>> Yes, it's in the kernel cifsfs module which is forwarding an SMB_FLUSH request
>> (which the spec says must fail on a non-writable handle) to
>> a handle opened as non-writable. Steve hopefully will fix :-).
> 
> 
> 
Thank you. I can confirm that 5.15.1 kernel with this patch applied [1] 
works both with the test case you provided earlier as well as with mock 
chainbuilds without the need for the nostrictsync mount option. Fedora 
kernel-5.14.16-301.fc35.x86_64 was failing without it.

Tested-by: Julian Sikorski <belegdol@gmail.com>

Best regards,
Julian

[1] https://gitlab.com/belegdol/kernel-ark/-/commits/fedora-5.15-cifs-fix/
