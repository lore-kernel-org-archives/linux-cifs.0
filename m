Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E02C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Jun 2022 18:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiF3SMG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Jun 2022 14:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbiF3SMF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Jun 2022 14:12:05 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943D13C70B
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 11:12:00 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id q6so40467769eji.13
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jun 2022 11:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=xe6JlwKWMvDR30RwJaP438YAumqHugMjkwmqjeu+0YI=;
        b=hQAI+Ct8l+EkSkAepaaKU3aGRedrceBzIgZsgxo6t7PU8n0Skrb/FOZNdRgHWVHlN5
         L0vfL70bBet0aBTwGKglc4ZYPctg6CMgCcPvQpXBtL6xuAdOng/ynxVxhoJh9R7J9/wv
         Mt4wq9ahSZiMKlKqCw7MtjCYU0tYNdywRFODxzXLEVfRrxbtlEYCS9oAhtOLZoD8pdEe
         fbEkkPE/L1MGoLirY6SexaaQ6BXu5oAkV66AONdbvFEgDsavo5O6O45ItwZgYKt4Mw3J
         mYrxAR1s4Z5ke/nzSTGnzrgpC8K8jRXvc5a2PFb7x5RJTrNxB2GV3ok6dfY64e5u3JTq
         W/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=xe6JlwKWMvDR30RwJaP438YAumqHugMjkwmqjeu+0YI=;
        b=nMFqNVBDfyi4/SOaZQd9e9mcTyuOjNVdvrueSB/TTAF4pX7GSnGSSTNDCnR583FNHr
         P/4xnS8H5gnnsqOvpqptVGkyiSHm/e4Djg6cko3FliMa3UIMBdmaI/2YSjWLzLGgwoij
         ba3ajQjYCuiW/eW4jDHF6KMNtEtF/ezicK8L1zglacTZ3x9axLkqWCpEhqJpAJH3asHg
         uhjgTbZUmiD0RUzp2pxJNZgRSXOVP3UefqbPUGbp/sd+xUUcz2kLLa2JAg89O0+tsfAD
         th58Uf1rb6IkjIKU4S48tCi298VraacNVjJ2L3DOS5H6Kpgj31qW/imalTX7KMEIfbi+
         jy+A==
X-Gm-Message-State: AJIora8KSxBq2ytcuDKn/whvwfQXnr32w7O5m+HHKz3U+qq20AHj4b9K
        Pdr0G7mYob5BMvX9Vr+QDSAKi5K+FN0vymXn
X-Google-Smtp-Source: AGRyM1v+EwIq4qGI4/JOok74O/TKoUStuDzrK4HheY/dc2+Xrnm0bTQKHRZ799sudRTkCTHy03Iljw==
X-Received: by 2002:a17:906:9b8b:b0:726:b6da:e570 with SMTP id dd11-20020a1709069b8b00b00726b6dae570mr10044386ejc.365.1656612719095;
        Thu, 30 Jun 2022 11:11:59 -0700 (PDT)
Received: from ?IPV6:2a02:908:1987:1a80::835b? ([2a02:908:1987:1a80::835b])
        by smtp.gmail.com with ESMTPSA id q2-20020a170906a08200b006fed93bf71fsm9483988ejy.18.2022.06.30.11.11.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 11:11:58 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------PEvaKjkb016OHIR1MaOXtoea"
Message-ID: <10efd255-16ea-6993-5e58-2d70e452a019@gmail.com>
Date:   Thu, 30 Jun 2022 20:11:57 +0200
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
From:   Julian Sikorski <belegdol@gmail.com>
In-Reply-To: <87h7423ukh.fsf@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a multi-part message in MIME format.
--------------PEvaKjkb016OHIR1MaOXtoea
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 30.06.22 um 19:55 schrieb Paulo Alcantara:
> Julian Sikorski <belegdol@gmail.com> writes:
> 
>> Not much is there:
>>
>> Jun 30 18:19:34 snowball3 kernel: CIFS: Attempting to mount
>> \\odroidxu4.local\julian
>>
>> Jun 30 18:19:34 snowball3 kernel: CIFS: VFS: cifs_mount failed w/return
>> code = -22
>>
>>
>> I tried reverting 16d5d91 as it was the only commit referencing smb, but
>> it did not help unfortunately.
> 
> Could you please run
> 
> 	echo 'module cifs +p' > /sys/kernel/debug/dynamic_debug/control
> 	echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynamic_debug/control
> 	echo 1 > /proc/fs/cifs/cifsFYI
> 	echo 1 > /sys/module/dns_resolver/parameters/debug
> 	dmesg --clear
> 	tcpdump -s 0 -w trace.pcap port 445 & pid=$!
> 	mount ...
> 	kill $pid
> 	dmesg > trace.log
> 
> and then send trace.log and trace.pcap.

Attached.

> 
> What SMB server and version?

Openmediavault 6.0.30 running on top of armbian bullseye. The samba 
package version is 4.13.13+dfsg-1~deb11u3.

Best regards,
Julian
--------------PEvaKjkb016OHIR1MaOXtoea
Content-Type: text/x-log; charset=UTF-8; name="trace.log"
Content-Disposition: attachment; filename="trace.log"
Content-Transfer-Encoding: base64

WyAgODYyLjkxMDM2NF0gQ0lGUzogZnMvY2lmcy9mc19jb250ZXh0LmM6IENJRlM6IHBhcnNp
bmcgY2lmcyBtb3VudCBvcHRpb24gJ3NvdXJjZScKWyAgODYyLjkxMDM4MV0gQ0lGUzogZnMv
Y2lmcy9mc19jb250ZXh0LmM6IENJRlM6IHBhcnNpbmcgY2lmcyBtb3VudCBvcHRpb24gJ2lw
JwpbICA4NjIuOTEwMzg3XSBDSUZTOiBmcy9jaWZzL2ZzX2NvbnRleHQuYzogQ0lGUzogcGFy
c2luZyBjaWZzIG1vdW50IG9wdGlvbiAndW5jJwpbICA4NjIuOTEwMzkxXSBDSUZTOiBmcy9j
aWZzL2ZzX2NvbnRleHQuYzogQ0lGUzogcGFyc2luZyBjaWZzIG1vdW50IG9wdGlvbiAndmVy
cycKWyAgODYyLjkxMDM5NV0gQ0lGUzogZnMvY2lmcy9mc19jb250ZXh0LmM6IENJRlM6IHBh
cnNpbmcgY2lmcyBtb3VudCBvcHRpb24gJ25vc3RyaWN0c3luYycKWyAgODYyLjkxMDQwMF0g
Q0lGUzogZnMvY2lmcy9mc19jb250ZXh0LmM6IENJRlM6IHBhcnNpbmcgY2lmcyBtb3VudCBv
cHRpb24gJ3VpZCcKWyAgODYyLjkxMDQwNV0gQ0lGUzogZnMvY2lmcy9mc19jb250ZXh0LmM6
IENJRlM6IHBhcnNpbmcgY2lmcyBtb3VudCBvcHRpb24gJ2dpZCcKWyAgODYyLjkxMDQwOF0g
Q0lGUzogZnMvY2lmcy9mc19jb250ZXh0LmM6IENJRlM6IHBhcnNpbmcgY2lmcyBtb3VudCBv
cHRpb24gJ3VzZXInClsgIDg2Mi45MTA0MTFdIENJRlM6IGZzL2NpZnMvZnNfY29udGV4dC5j
OiBDSUZTOiBwYXJzaW5nIGNpZnMgbW91bnQgb3B0aW9uICdwYXNzJwpbICA4NjIuOTEwNDE2
XSBDSUZTOiBmcy9jaWZzL2NpZnNmcy5jOiBEZXZuYW1lOiBcXG9kcm9pZHh1NC5sb2NhbFxq
dWxpYW4gZmxhZ3M6IDAKWyAgODYyLjkxMDQyMl0gQ0lGUzogZnMvY2lmcy9jb25uZWN0LmM6
IFVzZXJuYW1lOiBqdWxhcwpbICA4NjIuOTEwNDI1XSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3Qu
YzogZmlsZSBtb2RlOiAwNzU1ICBkaXIgbW9kZTogMDc1NQpbICA4NjIuOTEwNDMxXSBDSUZT
OiBmcy9jaWZzL2Nvbm5lY3QuYzogVkZTOiBpbiBtb3VudF9nZXRfY29ubnMgYXMgWGlkOiA0
IHdpdGggdWlkOiAwClsgIDg2Mi45MTA0MzVdIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBV
TkM6IFxcb2Ryb2lkeHU0LmxvY2FsXGp1bGlhbgpbICA4NjIuOTEwNDQxXSBDSUZTOiBmcy9j
aWZzL2Nvbm5lY3QuYzogZ2VuZXJpY19pcF9jb25uZWN0OiBjb25uZWN0aW5nIHRvIDE5Mi4x
NjguMC4yMjA6NDQ1ClsgIDg2Mi45MTA0NjJdIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBT
b2NrZXQgY3JlYXRlZApbICA4NjIuOTEwNDY0XSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzog
c25kYnVmIDE2Mzg0IHJjdmJ1ZiAxMzEwNzIgcmN2dGltZW8gMHgxYjU4ClsgIDg2Mi45MTY5
NzNdIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBjaWZzX2dldF90Y3Bfc2Vzc2lvbjogbmV4
dCBkbnMgcmVzb2x1dGlvbiBzY2hlZHVsZWQgZm9yIDYwMCBzZWNvbmRzIGluIHRoZSBmdXR1
cmUKWyAgODYyLjkxNjk3N10gQ0lGUzogZnMvY2lmcy9jb25uZWN0LmM6IERlbXVsdGlwbGV4
IFBJRDogNDU2OApbICA4NjIuOTE2OTgyXSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogVkZT
OiBpbiBjaWZzX2dldF9zbWJfc2VzIGFzIFhpZDogNSB3aXRoIHVpZDogMApbICA4NjIuOTE2
OTg2XSBDSUZTOiBmcy9jaWZzL2Nvbm5lY3QuYzogRXhpc3Rpbmcgc21iIHNlc3Mgbm90IGZv
dW5kClsgIDg2Mi45MTY5OTRdIENJRlM6IGZzL2NpZnMvc21iMnBkdS5jOiBOZWdvdGlhdGUg
cHJvdG9jb2wKWyAgODYyLjkxNzAwM10gQ0lGUzogZnMvY2lmcy90cmFuc3BvcnQuYzogd2Fp
dF9mb3JfZnJlZV9jcmVkaXRzOiByZW1vdmUgMSBjcmVkaXRzIHRvdGFsPTAKWyAgODYyLjkx
NzAyM10gQ0lGUzogZnMvY2lmcy90cmFuc3BvcnQuYzogU2VuZGluZyBzbWI6IHNtYl9sZW49
MjM2ClsgIDg2Mi45NjQyMzldIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBSRkMxMDAyIGhl
YWRlciAweDQ5ClsgIDg2Mi45NjQyNjldIENJRlM6IGZzL2NpZnMvc21iMm1pc2MuYzogU01C
MiBkYXRhIGxlbmd0aCAwIG9mZnNldCAwClsgIDg2Mi45NjQyNzNdIENJRlM6IGZzL2NpZnMv
c21iMm1pc2MuYzogU01CMiBsZW4gNzMKWyAgODYyLjk2NDI3OV0gQ0lGUzogZnMvY2lmcy9z
bWIyb3BzLmM6IHNtYjJfYWRkX2NyZWRpdHM6IGFkZGVkIDEgY3JlZGl0cyB0b3RhbD0xClsg
IDg2Mi45NjQzNzldIENJRlM6IGZzL2NpZnMvdHJhbnNwb3J0LmM6IGNpZnNfc3luY19taWRf
cmVzdWx0OiBjbWQ9MCBtaWQ9MCBzdGF0ZT00ClsgIDg2Mi45NjQ0MDFdIENJRlM6IGZzL2Np
ZnMvc21iMm1hcGVycm9yLmM6IE1hcHBpbmcgU01CMiBzdGF0dXMgY29kZSAweGMwMDAwMDBk
IHRvIFBPU0lYIGVyciAtMjIKWyAgODYyLjk2NDQxNl0gQ0lGUzogZnMvY2lmcy9taXNjLmM6
IE51bGwgYnVmZmVyIHBhc3NlZCB0byBjaWZzX3NtYWxsX2J1Zl9yZWxlYXNlClsgIDg2Mi45
NjQ0MzFdIENJRlM6IGZzL2NpZnMvY29ubmVjdC5jOiBWRlM6IGxlYXZpbmcgY2lmc19nZXRf
c21iX3NlcyAoeGlkID0gNSkgcmMgPSAtMjIKWyAgODYyLjk2NDQ0Ml0gQ0lGUzogZnMvY2lm
cy9kZnNfY2FjaGUuYzogY2FjaGVfcmVmcmVzaF9wYXRoOiBzZWFyY2ggcGF0aDogXG9kcm9p
ZHh1NC5sb2NhbFxqdWxpYW4KWyAgODYyLjk2NDQ1MV0gQ0lGUzogZnMvY2lmcy9kZnNfY2Fj
aGUuYzogZ2V0X2Rmc19yZWZlcnJhbDogZ2V0IGFuIERGUyByZWZlcnJhbCBmb3IgXG9kcm9p
ZHh1NC5sb2NhbFxqdWxpYW4KWyAgODYyLjk2NDQ3OF0gQ0lGUzogZnMvY2lmcy9jb25uZWN0
LmM6IFZGUzogbGVhdmluZyBtb3VudF9wdXRfY29ubnMgKHhpZCA9IDQpIHJjID0gMApbICA4
NjIuOTY0NDgyXSBDSUZTOiBWRlM6IGNpZnNfbW91bnQgZmFpbGVkIHcvcmV0dXJuIGNvZGUg
PSAtMjIK
--------------PEvaKjkb016OHIR1MaOXtoea
Content-Type: application/vnd.tcpdump.pcap; name="trace.pcap"
Content-Disposition: attachment; filename="trace.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAAAABAABAAAAJue9YjfWCgBKAAAASgAAAAAeBjJgdqSxwd1aJwgA
RQAAPHspQABABjyywKgAtMCoANyodgG9GDQqZwAAAACgAvrwgw8AAAIEBbQEAggKqxML1AAA
AAABAwMHJue9YkjuCgBKAAAASgAAAKSxwd1aJwAeBjJgdggARRAAPAAAQABABrfLwKgA3MCo
ALQBvah2r9125Bg0KmigEv6INyoAAAIEBbQEAggKfIxIVqsTC9QBAwMHJue9YrvuCgBCAAAA
QgAAAAAeBjJgdqSxwd1aJwgARQAANHsqQABABjy5wKgAtMCoANyodgG9GDQqaK/dduWAEAH2
gwcAAAEBCAqrEwvafIxIVibnvWKn7woALgEAAC4BAAAAHgYyYHakscHdWicIAEUAASB7K0AA
QAY7zMCoALTAqADcqHYBvRg0Kmiv3XblgBgB9oPzAAABAQgKqxML2nyMSFYAAADo/lNNQkAA
AAAAAAAAAAAKAAAAAAAAAAAAAAAAAAAAAADWEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAACQAAQABAAAAdwAAAFSzMGZAHUlaqIZBm5yo4FVoAAAABAAAABEDAAABACYAAAAAAAEA
IAABAExWLL1H4KoFVrzBdWxhrqC4m9cH0YcNAuW3lfo7OSgsAAACAAgAAAAAAAMAAgAEAAEA
AAEQAAAAAACTrSVQnLQR57Qjg96Wi818BQAeAAAAAABvAGQAcgBvAGkAZAB4AHUANAAuAGwA
bwBjAGEAbAAAACbnvWKy/woAQgAAAEIAAACkscHdWicAHgYyYHYIAEUQADRXREAAQAZgj8Co
ANzAqAC0Ab2odq/dduUYNCtUgBAB/GGLAAABAQgKfIxIXKsTC9om571iOqcLAI8AAACPAAAA
pLHB3VonAB4GMmB2CABFEACBV0VAAEAGYEHAqADcwKgAtAG9qHav3XblGDQrVIAYAfzmWQAA
AQEICnyMSIerEwvaAAAASf5TTUJAAAAADQAAwAAAAQABAAAAAAAAAAAAAAAAAAAA1hEAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAJAAAAAAAAAAAm571imqcLAEIAAABCAAAAAB4G
MmB2pLHB3VonCABFAAA0eyxAAEAGPLfAqAC0wKgA3Kh2Ab0YNCtUr913MoAQAfaDBwAAAQEI
CqsTDAl8jEiHJue9YtejDQBCAAAAQgAAAAAeBjJgdqSxwd1aJwgARQAANHstQABABjy2wKgA
tMCoANyodgG9GDQrVK/ddzKAEQH2gwcAAAEBCAqrEwyLfIxIhybnvWIexA0AQgAAAEIAAACk
scHdWicAHgYyYHYIAEUQADRXRkAAQAZgjcCoANzAqAC0Ab2odq/ddzIYNCtVgBEB/F/XAAAB
AQgKfIxJEKsTDIsm571iVcQNAEIAAABCAAAAAB4GMmB2pLHB3VonCABFAAA0ey5AAEAGPLXA
qAC0wKgA3Kh2Ab0YNCtVr913M4AQAfaDBwAAAQEICqsTDJR8jEkQ

--------------PEvaKjkb016OHIR1MaOXtoea--
