Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1AAC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 19:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235669AbiF3TMI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiF3TMH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 15:12:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442C432EF3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 12:12:06 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id q6so40747951eji.13
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 12:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fw7mYKW1QskWa2TXXeLY5vR+92465+TewsvobOsXzKI=;
        b=gR8jnxRyBuDHxxBIbyf5xQLaOuLFab3eaZ2zPULCiCn1lWhcDy19VCIzWbd/Uy0BvG
         /ltYEcEF274uQd4HC3OfB8+MQfOtD9838VwDGeBvd4QZ71vbHUw9mn8127JN6GhiwxJp
         A6YxFfT4NuacTYZofuHpsJDONLXYwmc0HOD8+zwH0sqimtbNPyvyBShGaVO9DMW6smMZ
         fOithc9/jKRh+jftsntKE37sZgCWQnszBrQ8riDogdzrqF2cAs5sW6eKeiGeFxMy9Gwk
         A7YVSQ6I7u6vMA+i+29p90sTuoExslThXnmnRDDnK6Xl49rszaT93gsUaiaWMNYp68LV
         OLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fw7mYKW1QskWa2TXXeLY5vR+92465+TewsvobOsXzKI=;
        b=qUVFje/GCThgZs/Ia/M9eEeOkYG1PE5pmk9H6Lc/6CpXQAzx+csrcNXe19bKV1tdZX
         7XGMuP9k5yTPGSF4sgpzurkIFgILNRQgm5u8V9LSeapuRy2MokEFNfRbWLgpSYq0j0j6
         HqqOVxmt3pbJEDixKgVGT63uV9RcoW4DXpaFu6qI3Q7YGjUnGsHg7G5I/Bs6jbTXsXdE
         CB9830eMpoxIJz33mQo3Ik0EHstXQl80bsI+Vfbnz19WchaQ/TAKJ3J5TDC6/JLpMyMD
         t6lrJ02KratX0dHdqMXRG87ZksuJxVFC1uaMpEZXdIl0Np4BYdLeBRdD2J6xBbsgE6Uf
         p7Nw==
X-Gm-Message-State: AJIora9vbmNrR/te/QdUxmpTzVexv12BFC5tJB9x1N3IhyfinsToQNSp
        F+to+5hyDaXctqzMsN6R7d4=
X-Google-Smtp-Source: AGRyM1tfOBf7Kd5TnVpuAHREvl8k6cPsahwXvZa79cC5F88jD32h8QV9E9C8mPJULpZ5OOXhZoobug==
X-Received: by 2002:a17:906:1c5:b0:715:7c69:870e with SMTP id 5-20020a17090601c500b007157c69870emr10554791ejj.348.1656616324846;
        Thu, 30 Jun 2022 12:12:04 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::a7fd? ([2a02:908:1987:1a80::a7fd])
        by smtp.gmail.com with ESMTPSA id y24-20020a1709060a9800b006fe8a4ec62fsm9409535ejf.4.2022.06.30.12.12.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 12:12:04 -0700 (PDT)
Message-ID: <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com>
Date:   Thu, 30 Jun 2022 21:12:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: kernel-5.18.8 breaks cifs mounts
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com> <87edz63t11.fsf@cjr.nz>
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <87edz63t11.fsf@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 30.06.22 um 20:28 schrieb Paulo Alcantara:
> Julian Sikorski <belegdol@gmail.com> writes:
> 
>> Am 30.06.22 um 19:55 schrieb Paulo Alcantara:
>>> Julian Sikorski <belegdol@gmail.com> writes:
>>>
>>>> Not much is there:
>>>>
>>>> Jun 30 18:19:34 snowball3 kernel: CIFS: Attempting to mount
>>>> \\odroidxu4.local\julian
>>>>
>>>> Jun 30 18:19:34 snowball3 kernel: CIFS: VFS: cifs_mount failed w/return
>>>> code = -22
>>>>
>>>>
>>>> I tried reverting 16d5d91 as it was the only commit referencing smb, but
>>>> it did not help unfortunately.
>>>
>>> Could you please run
>>>
>>> 	echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
>>> 	echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
>>> 	echo 1 > /proc/fs/cifs/cifsFYI
>>> 	echo 1 > /sys/module/dns_resolver/parameters/debug
>>> 	dmesg --clear
>>> 	tcpdump -s 0 -w trace.pcap port 445 & pid=$!
>>> 	mount ...
>>> 	kill $pid
>>> 	dmesg > trace.log
>>>
>>> and then send trace.log and trace.pcap.
>>
>> Attached.
>>
>>>
>>> What SMB server and version?
>>
>> Openmediavault 6.0.30 running on top of armbian bullseye. The samba
>> package version is 4.13.13+dfsg-1~deb11u3.
> 
> Thanks!
> 
> So, it is failing very early during the negproto request:
> 
> 	SMB2 302 Negotiate Protocol Request
> 	SMB2 143 Negotiate Protocol Response, Error: STATUS_INVALID_PARAMETER
> 
> which seems related to these commits in v5.18.8
> 
> 	16d5d9100927 smb3: use netname when available on secondary channels
> 	ca83f50b43a0 smb3: fix empty netname context on secondary channels
> 
> Have you tried reverting both in v5.18.8 to see if it works?
> 
> I built v5.18.8 but couldn't reproduce it against w22 server, though.
Good catch! I only noticed

16d5d9100927 smb3: use netname when available on secondary channels

initally, and reverting it did not help. Reverting

ca83f50b43a0 smb3: fix empty netname context on secondary channels

makes the mounts work again.

Best regards,
Julian

