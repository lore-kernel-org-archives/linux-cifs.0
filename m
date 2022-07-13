Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99232C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jul 2022 21:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiGMVZJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jul 2022 17:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237498AbiGMVZH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Jul 2022 17:25:07 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C831F63E
        for <linux-cifs@vger.kernel.org>; Wed, 13 Jul 2022 14:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1657747500;
        bh=CjB29r93bNbPmonVbDrc50I5ZUn0O/7q6hUkCsgbLcw=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=M6X7Z9F/NtxdcluS7HZ1av7f+ltXARIcjs/c/iKvEgusNuYAlaaVG5aWbNMg6L+qh
         3cj4FVkdM+wWK+b1U15PgNS4s9fo/UhbXGp1jzp8v2Zg7kBz0jwRxtsRoBcS5WVNqK
         8Vf/Nh327cdjntbyHy4eXquDVMEMxNcZ4drnhPuY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.15.55] ([109.104.41.236]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MSbx3-1o0UWD2baj-00Stuo; Wed, 13
 Jul 2022 23:25:00 +0200
Message-ID: <eee1b9a7-cbbe-ea55-5da4-c4a1fc709145@gmx.net>
Date:   Wed, 13 Jul 2022 23:25:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: kernel-5.18.8 breaks cifs mounts
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Julian Sikorski <belegdol@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Jeremy Allison <jra@samba.org>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <211885e7-1823-9118-836b-169c7163d7c2@gmail.com>
 <CAN05THTbuBSF6HXh5TAThchJZycU1AwiQkA0W7hDwCwKOF+4kw@mail.gmail.com>
 <fee59438-7b4a-0a24-f116-07c2ac39a3ad@gmail.com> <87h7423ukh.fsf@cjr.nz>
 <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com> <87edz63t11.fsf@cjr.nz>
 <4c28c2f8-cda6-d9b4-d80f-1ffa3a3be14c@gmail.com>
 <20220630203207.ewmdgnzzjauofgru@cyberdelia>
 <CAH2r5mtVwZggJ9Fi0zsK5hCci4uxee-kOSC3brb56xpb0_xn7w@mail.gmail.com>
 <56afe80b-bf6a-2508-063a-7b091cdbbe0f@gmail.com>
 <CAH2r5mvoyhZGjf_wgvjgmkCz=+2iDxCSpbyJ79NMtpE1Ecjdnw@mail.gmail.com>
 <fccdb4af-697e-b7fc-6421-f16e9b35bb8e@samba.org>
 <11b3feeb-7ddb-1297-5080-7c2fc986475a@gmail.com>
 <5936fdc6-3ab2-35d7-ff79-19a4a3768f19@gmail.com>
 <CAH2r5mv5bFG2tAEtbft-Zo+2jOqFfpr9B9TtWpgc5jhR-OiaZQ@mail.gmail.com>
From:   =?UTF-8?Q?Georg_M=c3=bcller?= <georgmueller@gmx.net>
In-Reply-To: <CAH2r5mv5bFG2tAEtbft-Zo+2jOqFfpr9B9TtWpgc5jhR-OiaZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:k9oJwIrMm02YJdb8US3KmQFZdVgGpM6XV7+wWKAznw6YXcm/sGK
 m1KEe2uAZuKs+FvUPzyfhtGsWs6JoGGIrXm6/ifZa5NcaE2tQ63lSXriZt8O01kjdUU6YsR
 1+nffzUW72F180Z3DKuBN0rTcx19rIi8eXyxvupU8q93TQu7oSIM/tGBlOR0WvrBqfVmPjG
 seQ048CVBiIUTrFfNNPeg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3ZEv/vPCOCI=:d7mosP0fJfhUyMPuauKCgf
 onaPHRcCVEOHTXtAD8gbZ7CPgPdYLo+DJCXbL5IdzsEwJWoiadLHLiHS9y6hNIPpblzQWtgGf
 QNyL/SBerd5QP1Ie5H7ILHiXqPG/PAgHU4djtrBeL40xMmSs7THwc0+ul2bVn3usCf541c+3/
 xRIqVnzo3omzAPg/pysHQct85iugqmJHB2yJcMqQVQU6tlRkS0BTDGmTBGUWzrP0E7Ro8vk6x
 SBDKlRACr4sa+84Fpvxsokd9uD7dwgn9qZc/WFMgtc1H/zuB5DqQQP+1Ch4fafzlTgAc9ofjH
 VJGXXDJ3uO+Lytoboi7FEHNjorOSMy0PdfJSv4e7p9f2lcz+ElSrVJAAlNUTyVLjU5QyaYWG7
 CSa4HDQGhi1CeJQ5056rhRuY50x/Pwc11CFfmDde78HJwpIPrgwiWEfQIVYfOoW9XdGQNXGmT
 4aOHIie15aRU2UzcLTRu++M0Z89z6ILW516GkJIddtH4LeLXOCNzT3onT621zo9Y4hsXzlMzM
 KM2wnLcG9SdUqnZW6/chFzOoOQGaVIjTlNeG9VckRND3Of1hzDBXPUURCU0+wGx2agv6u0KwJ
 d/f8kYN8+ZQqx0njTXlQjbamnUYoh7nQ8BV/ylHtYIeS3KTiV1W8tWMveP2zbrUENdhKuPceZ
 n2TVsZzwufTgxPQ4yMg4jLEzX7w9Ktr8q2AjvTr44ySoX2bJtshnM16CoeOMD4fC9GgIR8SNB
 ZYY/HOw+9Fr1N5YxYlCreB0t0Frw7lQ7E27UV1y9CjJpKNqWMFFQukLzocnOrFBFywaXTfwJ2
 XxblwtUGyOt7It8XY7LMV8KzPC95bOgJPuUhcLu3OhhGXJjnaOal0ZGTABpErixFulsphgFue
 wpM2ATxoy9S6FxsdVkvZgd5gM0kZSN2OfpxpCF7dAiKbpsDiuKvyBMUrV8B3Q1G3/VaaKOB+y
 rtamiRWHB3IdvfgziD4YVcCioZ0FStJP9Jw9GwidIDTtAZ13tEEqCJ7YC8bKXyzPrR52fPpg9
 2TTJMDjM0ZMUoB3OYbHUR1uBMP5d1XIolbO8mEY52y1loSvWsMAtTufmYHAfApoL33iVtIpuO
 5Ho/vptksKEc+Kivt5S0yhGNl/Tsq031xN/RnoYIMFFcwow7SG6TlpPPw==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Am 12.07.22 um 06:36 schrieb Steve French:
> I was able to reproduce it to older Samba server (4.12.5) and could
> workaround the Samba server bug by using mount option "compress" on
> the client (which won't do anything different since it is not
> supported but  interestingly it avoids the problem by adding another
> context at the end).


The general problem might be solved by just moving the now optional hostna=
me
context in fs/cifs/smb2pdu.c back between build_encrypt_ctxt and build_pos=
ix_ctxt.

I encounter the issue with a Synology Diskstation, and there might be
much more people running into the problem when this kernel becomes more
common...


> On Wed, Jul 6, 2022 at 6:18 AM Julian Sikorski <belegdol@gmail.com> wrot=
e:
>>
>> Am 04.07.22 um 18:29 schrieb Julian Sikorski:
>>>
>>>
>>> Am 03.07.22 um 19:51 schrieb Stefan Metzmacher:
>>>> Am 03.07.22 um 07:01 schrieb Steve French:
>>>>> I lean toward thinking that this is a Samba bug (although I don't se=
e
>>>>> it on my local system - it works to samba for me, although I was
>>>>> trying against a slightly different version, Samba 4.15.5-Ubuntu).
>>>>>
>>>>> Looking at the traces in more detail they look the same (failing vs.
>>>>> working) other than the order of the negotiate context, which fails
>>>>> with POSIX as the 3rd context, and netname as the 4th, but works wit=
h
>>>>> the order reversed (although same contexts, and same overall length)
>>>>> ie with POSIX context as the fourth one and netname context as the
>>>>> third one.
>>>>>
>>>>> The failing server code in Samba is in
>>>>> smbd_smb2_request_process_negprot but I don't see changes to it
>>>>> recently around this error.
>>>>>
>>>>> Does this fail to anyone else's Samba version?
>>>>>
>>>>> This is probably a Samba server bug but ... seems odd since it doesn=
't
>>>>> fail to Samba for me.
>>>>>
>>>>> Jeremy/Metze,
>>>>> Does this look familiar?
>>>>
>>>> Maybe this one:
>>>>
>>>> https://git.samba.org/?p=3Dsamba.git;a=3Dcommitdiff;h=3D147dd9d58a429=
695a3b6c6e45c8b0eaafc67908a
>>>>
>>>>
>>>> that went only into 4.15 and higher.
>>>>
>>>> metze
>>>
>>> Nice catch, I can confirm that adding this patch to debian samba
>>> 2:4.13.13+dfsg-1~deb11u3 package makes the mounts work again. How do w=
e
>>> get this patch into debian?
>>>
>>> Best regards,
>>> Julian
>> I have now filed a bug against debian samba package:
>> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1014453
>>
>> Best regards,
>> Julian
>
>
>
