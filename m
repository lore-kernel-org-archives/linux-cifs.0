Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0DCC636CC
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Feb 2023 10:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjBPK6D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 05:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBPK57 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 05:57:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4585356ED8
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 02:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676544979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTgMQWhXxbdOB1s+iJ3y+3uVjK3VfEIrdExBYMmTzrk=;
        b=cgTA8yeBuLVrFQVUmlI+zpc+i1N1YJx/XupkVor1p/PDzbtkrCJaRFBHH5jm5w/+5d51X8
        Bn2kkqyd8oZGSVLCtonsceAAevnNU5H26m5PiLePfMmuSxCWYBhVrrk1glN+9V+nsIJyVa
        6qv75jzAEiTEOdI0A+bzz0LgINFEB2s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-353-5OD6McStPDG25ynv3xBmww-1; Thu, 16 Feb 2023 05:56:18 -0500
X-MC-Unique: 5OD6McStPDG25ynv3xBmww-1
Received: by mail-wr1-f72.google.com with SMTP id g8-20020a5d46c8000000b002c54a27803cso190273wrs.22
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 02:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uTgMQWhXxbdOB1s+iJ3y+3uVjK3VfEIrdExBYMmTzrk=;
        b=dqsRJm7lg+h+fPfU9EDJThUKBY16E2jdL04rdcUlf9KozaBKRLb73c3WL3fPTTQ+4w
         4/gM1hbwZLqAqySBy7UA+25bQAPCLTFHSPBfWMiDPhMX9hSyvSI83QvgkT3J6VAeh4al
         iiaIQ0kI1FrMtRes2yPm+WNCw73zxvPCmkrzE157KQlWsu3DPJBh1SVz7Lc1+0hQrRso
         uKkyJ7hGiZGP7kR2Ap2XYn9+qi7QLSLNkUAXoD4w0o89U6F75oUCo6bxZ+opWuU7mwy8
         scaZK0QqSsBrPkL0+gBv8r/HUnEwVpuR8rxaNZ6WL7EZQb03091nq6s9LyNYczVk4qqC
         FClQ==
X-Gm-Message-State: AO0yUKXj1PyP/iMOy6pUNaJESCaDxQ0DIp7soKua1BRXQRhMWZnsIDC0
        vHuJsvebtHjpKOqYXtjXOhoqF2i/uYcn6Uhd2nW7u8N1T/xQoZqRWumZ0ZB0Y4ZI04baZ7Dc6W9
        Z7Fnia5gzP4VewivwBUU4Tw==
X-Received: by 2002:adf:e701:0:b0:2c5:5331:5516 with SMTP id c1-20020adfe701000000b002c553315516mr4351124wrm.51.1676544976935;
        Thu, 16 Feb 2023 02:56:16 -0800 (PST)
X-Google-Smtp-Source: AK7set9ObTYOMWdJTcJUhFYm6zKW9Smmq8ZljjToRyJseQklHttx5j+GTfa92sWHSmEG8i4fOJ6xDQ==
X-Received: by 2002:adf:e701:0:b0:2c5:5331:5516 with SMTP id c1-20020adfe701000000b002c553315516mr4351100wrm.51.1676544976599;
        Thu, 16 Feb 2023 02:56:16 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:bc00:2acb:9e46:1412:686a? (p200300cbc708bc002acb9e461412686a.dip0.t-ipconnect.de. [2003:cb:c708:bc00:2acb:9e46:1412:686a])
        by smtp.gmail.com with ESMTPSA id h16-20020adffa90000000b002c5621263e3sm1221457wrr.19.2023.02.16.02.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 02:56:16 -0800 (PST)
Message-ID: <909d3cd5-eb64-6901-4e12-00ac5c69f4aa@redhat.com>
Date:   Thu, 16 Feb 2023 11:56:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] Revert "splice: Do splice read from a buffered file
 without using ITER_PIPE"
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        David Howells <dhowells@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-mm@kvack.org
References: <20230215-topic-next-20230214-revert-v1-2-c58cd87b9086@linaro.org>
 <20230215-topic-next-20230214-revert-v1-0-c58cd87b9086@linaro.org>
 <3055589.1676466118@warthog.procyon.org.uk>
 <71078188-1443-d84e-658c-967991f3b590@linaro.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <71078188-1443-d84e-658c-967991f3b590@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 16.02.23 10:10, Konrad Dybcio wrote:
> 
> 
> On 15.02.2023 14:01, David Howells wrote:
>> Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>>
>>> next-20230213 introduced commit d9722a475711 ("splice: Do splice read from
>>> a buffered file without using ITER_PIPE") which broke booting on any
>>> Qualcomm ARM64 device I grabbed, dereferencing a null pointer in
>>> generic_filesplice_read+0xf8/x598. Revert it to make the devices
>>> bootable again.
>>>
>>> This reverts commit d9722a47571104f7fa1eeb5ec59044d3607c6070.
>>> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
>>
>> Commit d9722a47571104f7fa1eeb5ec59044d3607c6070 was part of v13 of my
>> patches.  This got replaced yesterday by a newer version which may or may not
>> have made it into linux-next.
>>
>> This is probably a known bug fixed in the v14 by making shmem have its own
>> splice-read function.
>>
>> Can you try this?
>>
>> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-extract
> next-20230216 boots fine again, thanks!
> 
>>
>> (Also, can you include me in the cc list as I'm the author of the patch you
>> reverted?)
> Ugh.. I thought b4 would have done that for me.. weird..

Right, and usually it's nicer to comment on the problematic patches, 
asking for a fix or a revert, instead of sending reverts.

My 2 cents.

-- 
Thanks,

David / dhildenb

