Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC841C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Nov 2021 07:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B420061A89
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Nov 2021 07:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhKOHPV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 Nov 2021 02:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbhKOHNu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 Nov 2021 02:13:50 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2C2C0613B9
        for <linux-cifs@vger.kernel.org>; Sun, 14 Nov 2021 23:10:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id s13so28636271wrb.3
        for <linux-cifs@vger.kernel.org>; Sun, 14 Nov 2021 23:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5MgMHJ2tNeA1fyUznpELwCeIOPG5Zbs1A1zNW+59tts=;
        b=j4rA6k4BRSCwNQvehwtHpEoB6/GV0nc30Tlv2vPU/22hemNTEh1ri3XP16nyMGKCNR
         XWkxAUFHmvhldX0bmt3WOihz4ZPp/z5Idi37SkG6CSSurd1NBs7b+YB+JXIpc/mhuhlJ
         VE3/6ldEZnHydDsNlxDwTUwDjc+9C+lnVJ8L+lsBGBEvaZ0m4m2UtguSR7Gay0V9YCKz
         fStVFBsrbBaMq1wIIDPX3N7ezHeuTprYnHAlxA5CbloHH/kySseHA6LVOosQxZw6alQG
         NyjtHbVZJH8P3V8kYILuIk/NTGlbWBO5nqBpJQaoltxUKtyh63bSBOv2Fhx5cLAhoVVN
         QAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5MgMHJ2tNeA1fyUznpELwCeIOPG5Zbs1A1zNW+59tts=;
        b=t9T289oxBn2IbBZ8Y3MrAp9RX7AxyweE5lut9EIryNnbw+mMoXbfw57ptZOqVrSsUZ
         QHRRRprC/r90Dzs8M8y96MQ5YhQM93mXRHaiP8rJarz3iyMAtdHpVokqGurx1aJAkQLi
         EvpKhfptCh9lF+7gjMZqjOH2F4HfSx5agGzcFz44iUZEPxjAVZOhvUl8Y7LMEHDCnbVM
         38qcHbNLazWBv9wunqJhlnOXbrBcVG8DIVjGqzHD4meuTsG6gpXiMEzqfj6Lx26IJHTI
         AvlET5ineq2wKldkLA01T7bMG7bUTCUwrRKn4EiotaPx1fyMlEeJMn8HUOmPwaPPiaqg
         QgZg==
X-Gm-Message-State: AOAM531ebHtyf6WjMmlZy+5xrlGiDBVYKiwSqdMhVUvfUkXbL3ZnBjgz
        CXX48PlV2RQKtWu4FrNljVM=
X-Google-Smtp-Source: ABdhPJwFED5lR5DbD08Ap5QHoFqsnFSXZjujq07KiNDXfOG0yHPna1Q8vMKHeUzXFTfHiBSkFfxhBg==
X-Received: by 2002:a05:6000:1a88:: with SMTP id f8mr44006182wry.54.1636960251651;
        Sun, 14 Nov 2021 23:10:51 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::d962? ([2a02:908:1980:7720::d962])
        by smtp.gmail.com with ESMTPSA id t9sm14220041wrx.72.2021.11.14.23.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 23:10:51 -0800 (PST)
Message-ID: <bc98153c-3a23-a527-10f2-9ea56cb7774c@gmail.com>
Date:   Mon, 15 Nov 2021 08:10:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>
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
 <c9af96be-bb75-9487-4f9c-1a53b41e9210@gmail.com>
 <65be73d3-b8c9-e919-3dda-240c0497efff@gmail.com>
 <CAH2r5mvPot1Xhsg6eVPz0h11-+FEL+cBrLL9ucLSUPrf_+7ywg@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CAH2r5mvPot1Xhsg6eVPz0h11-+FEL+cBrLL9ucLSUPrf_+7ywg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 15.11.21 um 04:25 schrieb Steve French:
> The patch is in Linus's tree, so you should be able to try it with the
> weekly kernel updates for various distros which have download sites
> for more current kernel packages (Ubuntu, Fedora etc.) or build kernel
> yourself if you prefer.
> 
> To get it into stable we will need to send a followup email as
> described in their process guide below:
> 
> "send an email to stable@vger.kernel.org containing the subject of the
> patch, the commit ID, why you think it should be applied"
> 
> but some of the distros will apply it automatically (it is still
> helpful to send the email to stable as a reminder)
> 
Thank you. I found the patch in the Linus' tree yesterday and I saw you 
have just sent the email to stable. So it looks like we are all set. 
Thank you again for fixing this so quickly.

Best regards,
Julian

> On Sat, Nov 13, 2021 at 9:37 AM Julian Sikorski <belegdol@gmail.com> wrote:
>>
>> Am 10.11.21 um 12:23 schrieb Julian Sikorski:
>>> W dniu 10.11.2021 o 08:56, Steve French pisze:
>>>> Fix for the kernel client attached
>>>>
>>>>
>>>> On Tue, Nov 9, 2021 at 6:54 PM Jeremy Allison <jra@samba.org> wrote:
>>>>>
>>>>> On Tue, Nov 09, 2021 at 10:26:59AM +0100, Julian Sikorski wrote:
>>>>>> Am 09.11.21 um 09:10 schrieb Steve French:
>>>>>>> Yes - here is a trivial reproducer (excuse the ugly sample
>>>>>>> cut-n-paste)
>>>>>>>
>>>>>>> #include <stdio.h>
>>>>>>> #include <stdlib.h>
>>>>>>> #include <unistd.h>
>>>>>>> #include <string.h>
>>>>>>> #include <fcntl.h>
>>>>>>> #include <sys/types.h>
>>>>>>> #include <sys/stat.h>
>>>>>>>
>>>>>>> int main(int argc, char *argv[]) {
>>>>>>> char *str = "Text to be added";
>>>>>>> int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
>>>>>>>
>>>>>>> fd = creat("test.txt", S_IWUSR | S_IRUSR);
>>>>>>> if (fd < 0) {
>>>>>>> perror("creat()");
>>>>>>> exit(1);
>>>>>>> }
>>>>>>> ret = write(fd, str, strlen(str));
>>>>>>> if (ret < 0) {
>>>>>>> perror("write()");
>>>>>>> exit(1);
>>>>>>> }
>>>>>>> openrc = open("test.txt", O_RDONLY);
>>>>>>>           if (openrc < 0) {
>>>>>>>                   perror("creat()");
>>>>>>>                   exit(1);
>>>>>>>           }
>>>>>>> fsyncr_rc = fsync(openrc);
>>>>>>> if (fsyncr_rc < 0)
>>>>>>> perror("fsync()");
>>>>>>> fsyncrc = fsync(fd);
>>>>>>> closerc = close(fd);
>>>>>>> close2rc = close(openrc);
>>>>>>> printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
>>>>>>> rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
>>>>>>> }
>>>>>>>
>>>>>>
>>>>>> I can confirm this fails on my machine without nostrictsync:
>>>>>>
>>>>>> $ ./test
>>>>>>
>>>>>> fsync(): Permission denied
>>>>>>
>>>>>> read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0
>>>>>>
>>>>>> and works with nostrictsync:
>>>>>>
>>>>>> $ ./test
>>>>>>
>>>>>> read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0
>>>>>>
>>>>>> So is the bug in the Linux kernel?
>>>>>
>>>>> Yes, it's in the kernel cifsfs module which is forwarding an
>>>>> SMB_FLUSH request
>>>>> (which the spec says must fail on a non-writable handle) to
>>>>> a handle opened as non-writable. Steve hopefully will fix :-).
>>>>
>>>>
>>>>
>>> Thank you. I can confirm that 5.15.1 kernel with this patch applied [1]
>>> works both with the test case you provided earlier as well as with mock
>>> chainbuilds without the need for the nostrictsync mount option. Fedora
>>> kernel-5.14.16-301.fc35.x86_64 was failing without it.
>>>
>>> Tested-by: Julian Sikorski <belegdol@gmail.com>
>>>
>>> Best regards,
>>> Julian
>>>
>>> [1] https://gitlab.com/belegdol/kernel-ark/-/commits/fedora-5.15-cifs-fix/
>>
>> Hi,
>>
>> may I ask what the usual process of getting the patch into the Linus's
>> tree and to the stable branches is? If it takes longer, I am going to go
>> back to nostrictsync for now.
>>
>> Best regards,
>> Julian
> 
> 
> 
