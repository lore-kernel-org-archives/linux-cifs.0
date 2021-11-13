Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC8BC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 15:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94AD0604D1
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Nov 2021 15:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235939AbhKMPkr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Nov 2021 10:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbhKMPkq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Nov 2021 10:40:46 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34230C061766
        for <linux-cifs@vger.kernel.org>; Sat, 13 Nov 2021 07:37:54 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id r8so21021745wra.7
        for <linux-cifs@vger.kernel.org>; Sat, 13 Nov 2021 07:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=j0Tu6bKw0UVKEJmJf3tpm7xlhpAc/qcMrjHItIQoPx4=;
        b=PhNQK3H35IEJ4JRwq6DF2ZqPU8xizj+m5fZFUwQKhQlKy7jWtkOdw7++d0DmlllBM1
         FxkwW1iS1UnT836/bteDW1EZJR320tgaDTDFK3pSx8uFCUqEA2QaU3ifrrUZS5Vxnxfu
         qOq1u4i/YBmz6eS9h6ZxB1t6sQ+Dl48Vapqa/DrjosDYJTQbHV9Jl/+qKulyZmJdNRLU
         6ZJEJXuDBROr/o8LNYklg7CNEw3OqHKLUL21pV5ipn0G5OVUQTI/vVofeAZAuhWIQppA
         8rT3WMwrV1M6FoAO0BpN4Ys0SxR+4LzgCNYfifZjn/FLrn06IK/LtBBp2NfTHIoQ735r
         bLTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=j0Tu6bKw0UVKEJmJf3tpm7xlhpAc/qcMrjHItIQoPx4=;
        b=1xXu8Y7dk5YnT1IpnSk3NZ1yKt3AdMzPYKbxT9qW4P/bV/jtexRd4CNswnnOIzsvuO
         fDDlJu98A0Fc+3SlUISnMhl9Mte72FH58D0YNF6Lxs0ghdsT4PgHNhrxcbgEL4g5GNBj
         P77ahy2iJf2+3Osg6BPyrbn8jY55UNhIa2AxxKUDIMwx11QwW2j+uEX93MIJbb2uKmg6
         t8FGPV6XLX8llJ7VJBRTsQyaMrnpXfVYWrb0I2pahjJkH9RbqOnRJW+zKjB0bXLmpUFs
         Lx0/cCrblZZbQZR9sbzAI6Di3YykgM7BcrPNVUOEvNOoNRLzw9wGJ7WlkwVpyVCFUnVx
         j27Q==
X-Gm-Message-State: AOAM530GrykRiAYiEuXle+dRoJl/hAeGmibclWWcw5rc+MPqJ9QB/28R
        pYV+X+Oj3eLykok8t5Y48lA6qZg9cY2yAg==
X-Google-Smtp-Source: ABdhPJwc/CvNor/r61UWFne1kXmA9snhULHcqBCwNo7eBBKFd4S7maQy6kRKDXlSVhqM3A9XnpjLYg==
X-Received: by 2002:a5d:6d86:: with SMTP id l6mr28795748wrs.304.1636817872729;
        Sat, 13 Nov 2021 07:37:52 -0800 (PST)
Received: from ?IPV6:2a02:908:1980:7720::d962? ([2a02:908:1980:7720::d962])
        by smtp.gmail.com with ESMTPSA id r17sm10230277wmq.11.2021.11.13.07.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Nov 2021 07:37:52 -0800 (PST)
Message-ID: <65be73d3-b8c9-e919-3dda-240c0497efff@gmail.com>
Date:   Sat, 13 Nov 2021 16:37:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Permission denied when chainbuilding packages with mock
Content-Language: en-US
From:   Julian Sikorski <belegdol@gmail.com>
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
 <c9af96be-bb75-9487-4f9c-1a53b41e9210@gmail.com>
In-Reply-To: <c9af96be-bb75-9487-4f9c-1a53b41e9210@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 10.11.21 um 12:23 schrieb Julian Sikorski:
> W dniu 10.11.2021 o 08:56, Steve French pisze:
>> Fix for the kernel client attached
>>
>>
>> On Tue, Nov 9, 2021 at 6:54 PM Jeremy Allison <jra@samba.org> wrote:
>>>
>>> On Tue, Nov 09, 2021 at 10:26:59AM +0100, Julian Sikorski wrote:
>>>> Am 09.11.21 um 09:10 schrieb Steve French:
>>>>> Yes - here is a trivial reproducer (excuse the ugly sample 
>>>>> cut-n-paste)
>>>>>
>>>>> #include <stdio.h>
>>>>> #include <stdlib.h>
>>>>> #include <unistd.h>
>>>>> #include <string.h>
>>>>> #include <fcntl.h>
>>>>> #include <sys/types.h>
>>>>> #include <sys/stat.h>
>>>>>
>>>>> int main(int argc, char *argv[]) {
>>>>> char *str = "Text to be added";
>>>>> int fd, ret, fsyncrc, fsyncr_rc, openrc, closerc, close2rc;
>>>>>
>>>>> fd = creat("test.txt", S_IWUSR | S_IRUSR);
>>>>> if (fd < 0) {
>>>>> perror("creat()");
>>>>> exit(1);
>>>>> }
>>>>> ret = write(fd, str, strlen(str));
>>>>> if (ret < 0) {
>>>>> perror("write()");
>>>>> exit(1);
>>>>> }
>>>>> openrc = open("test.txt", O_RDONLY);
>>>>>          if (openrc < 0) {
>>>>>                  perror("creat()");
>>>>>                  exit(1);
>>>>>          }
>>>>> fsyncr_rc = fsync(openrc);
>>>>> if (fsyncr_rc < 0)
>>>>> perror("fsync()");
>>>>> fsyncrc = fsync(fd);
>>>>> closerc = close(fd);
>>>>> close2rc = close(openrc);
>>>>> printf("read fsync rc=%d, write fsync rc=%d, close rc=%d, RO close
>>>>> rc=%d\n", fsyncr_rc, fsyncrc, closerc, close2rc);
>>>>> }
>>>>>
>>>>
>>>> I can confirm this fails on my machine without nostrictsync:
>>>>
>>>> $ ./test
>>>>
>>>> fsync(): Permission denied
>>>>
>>>> read fsync rc=-1, write fsync rc=0, close rc=0, RO close rc=0
>>>>
>>>> and works with nostrictsync:
>>>>
>>>> $ ./test
>>>>
>>>> read fsync rc=0, write fsync rc=0, close rc=0, RO close rc=0
>>>>
>>>> So is the bug in the Linux kernel?
>>>
>>> Yes, it's in the kernel cifsfs module which is forwarding an 
>>> SMB_FLUSH request
>>> (which the spec says must fail on a non-writable handle) to
>>> a handle opened as non-writable. Steve hopefully will fix :-).
>>
>>
>>
> Thank you. I can confirm that 5.15.1 kernel with this patch applied [1] 
> works both with the test case you provided earlier as well as with mock 
> chainbuilds without the need for the nostrictsync mount option. Fedora 
> kernel-5.14.16-301.fc35.x86_64 was failing without it.
> 
> Tested-by: Julian Sikorski <belegdol@gmail.com>
> 
> Best regards,
> Julian
> 
> [1] https://gitlab.com/belegdol/kernel-ark/-/commits/fedora-5.15-cifs-fix/

Hi,

may I ask what the usual process of getting the patch into the Linus's 
tree and to the stable branches is? If it takes longer, I am going to go 
back to nostrictsync for now.

Best regards,
Julian
