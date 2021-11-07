Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 136D5C433EF
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E0E6139E
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Nov 2021 22:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhKGW7A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Nov 2021 17:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbhKGW6Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Nov 2021 17:58:25 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DADCC06120B
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 14:55:41 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso10396882wme.3
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 14:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LBHhqjCXlQ4JT5o+KpkI5mrZBvK+q3zkHoCNu61+ows=;
        b=eCn4zNxUbMU6ZjGtWcjMhsGAfWIbJIK+dX8K82PzeWmYRYnACvO1vnE6NlGauIW3nN
         2k8uF8ZkeC68gY3fV08TtTs1FLxO5qv3E7aD7t5FHB7hiDZ5Xba9GARGCGa/f3cSUOa7
         KJO1s99QYO0JJtzoSLsnwod5ceK6IQJ/d0/TLcgtZhQrLwJfMIv+Ir8E1+E9e4X1a4Ag
         6BdqCkg3h2J8yGyJ4l7WV2ku/s6+R0WymLpnAWF0eZX6tvIYu4vfrKetpo+3jUkp04e4
         J3+Ku8lDLd4gtQxH3/N8/TMQh6nPq0+wQgTLt2FOHJyrmq7M1GE8/JgNd8ZF4O0nLl3l
         8AZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LBHhqjCXlQ4JT5o+KpkI5mrZBvK+q3zkHoCNu61+ows=;
        b=psZC4ouoDYfhvxsud+QqtAKYS6Klpi2/2AZZvad6WENZzraPA6Mt7Y4NcdZBvTxfmW
         kx9V2GWK8vUyZfuOeBHynd8on+gpdrIMzgn72lWlJGa5kd+CKe6wmW/2DcfgyiZOQZT+
         W0sGWOTv+U5FYjWO2Ygy4vflUFqi0gRccHNxvO7ZuN/2JlFe6x4LayC1uLG6dRbakCCk
         mdkQtII7P+VI/MHSaTbUBZGZQ06ChxDoqSToGphrztlo8z5vYoJeko4PAImlvXxdf4gH
         MGdsAvcIsYOYEiIh+dZCvYyVYKw/w40Sz/mFkLNus1/Qs+jKZMyNhHdKeZmaT3etEZDG
         grJA==
X-Gm-Message-State: AOAM532qJdACmMmzcm/iTRrt/HsSmIDjFysjItEQXZx12cTT/Y+vLjqg
        niLa7//TxH687MGK7wXat/kiaSHwvsloBw==
X-Google-Smtp-Source: ABdhPJzEJNCvzj+ARRb5gM1AFS6qAYalOmHYWPRvWvtFb0Dzc+HZ9rObR3PIGYwKBxdvFPCsOd6nxw==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr50015206wme.188.1636325739919;
        Sun, 07 Nov 2021 14:55:39 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::7039? ([2a02:908:1980:7720::7039])
        by smtp.gmail.com with ESMTPSA id o12sm18928077wrc.85.2021.11.07.14.55.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 14:55:39 -0800 (PST)
Message-ID: <d4f3344a-5054-9f0c-11aa-e941a8b5c9c9@gmail.com>
Date:   Sun, 7 Nov 2021 23:55:39 +0100
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
 <CAH2r5mvrPj5b460CeRT9+MNc1fOzwMixqsCN82v8KP_d+bgO2w@mail.gmail.com>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <CAH2r5mvrPj5b460CeRT9+MNc1fOzwMixqsCN82v8KP_d+bgO2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

W dniu 07.11.2021 o 23:50, Steve French pisze:
> That is interesting ... and weird.   Why would POSIX allow doing
> something write related (fsync) without write permission?
> 
> To work around this (especially if the server is reliable enough) -
> simply mount with "nostrictsync" (we will write out cached writes to
> the server on flush, but won't send the fsync).
> 
> Will look at it more.

Mounting with nostrictsync has made the problem go away. Thank you both!

Best regards,
Julian

> 
> On Sun, Nov 7, 2021 at 4:47 PM Jeremy Allison <jra@samba.org> wrote:
>>
>> On Sun, Nov 07, 2021 at 11:15:49PM +0100, Julian Sikorski wrote:
>>> Hi,
>>>
>>> thanks for responding. I am using loglevel 10. I have uploaded the
>>> logs to my dropbox as they are too big to attach:
>>>
>>> https://www.dropbox.com/sh/r4b7q7ti2zmtlu9/AACqFY0FW2oW41Vu8l3nLZJSa?dl=0
>>>
>>> The problem happens around 15:45:48. Do the logs show what access mask
>>> the fsp is being opened with you requested?
>>> I am using quite an old samba server (4.9.5+dfsg-5+deb10u1) due to the
>>> fact that openmediavault is based off debian 10 and there are no samba
>>> backports available. Having said that, this configuration can work, as
>>> shown by goffice/goffice-0.10.50-1.fc35.src.rpm rebuild and the fact
>>> that it was working before for months previously.
>>
>> The error is occurring on the file:
>>
>> /srv/dev-disk-by-label-omv/julian/kernel/results/fedora-35-x86_64/goffice-0.10.50-2.fc35/goffice-devel-0.10.50-2.fc35.x86_64.rpm
>>
>> this is a regular file, not a directory
>> opened with ACCESS_MASK: 0x00120089
>>
>> that is:
>>
>> SEC_STD_SYNCHRONIZE|
>> SEC_STD_READ_CONTROL|
>> SEC_FILE_READ_ATTRIBUTE|
>> SEC_FILE_READ_EA|
>> SEC_FILE_READ_DATA
>>
>> so indeed, this is being opened *without*
>> SEC_FILE_WRITE_DATA|SEC_FILE_APPEND_DATA
>> so smbd is correct in returning ACCESS_DENIED
>> to an SMB2_FLUSH call.
>>
>> Looks like this is a client bug, in that it
>> is passing a Linux fsync(fd) call directly
>> to the SMB2 server without checking if the
>> underlying file is open for write access.
>>
>> In this case, the SMB2 client should just
>> return success to the caller, as any SMB_FLUSH
>> call will always return ACCESS_DENIED on a
>> non-writable file handle, and according to
>> Linux semantics calling fsync(fd) on an fd
>> open with O_RDNLY should return success.
>>
>> Steve, over to you :-).
>>
>> Jeremy.
> 
> 
> 

