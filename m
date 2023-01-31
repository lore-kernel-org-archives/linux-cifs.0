Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 796A7C636D3
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 01:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjAaBxB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Jan 2023 20:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjAaBwv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Jan 2023 20:52:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0045727D65
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 17:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675129885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=UfeHCcpodxDcuJ+i38y0BxwyH+Lrn8GMrsUxCnUMTJuJwixySgq63HIW2VHj8dcRZcQqw/
        piAf43IPzWJRE6t/X18osfe/TZbGb5jIsbfPhTE8QLJNDBH649nzfWsBqCqvsRns9xML0M
        bRXE/5UJHNaBaF4J2g4JIQYIxyDeUgE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-193-y45-VkQpOi-9vbe3yLcWew-1; Mon, 30 Jan 2023 20:51:16 -0500
X-MC-Unique: y45-VkQpOi-9vbe3yLcWew-1
Received: by mail-pj1-f70.google.com with SMTP id jp14-20020a17090ae44e00b0022a03158ec6so5288883pjb.9
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 17:51:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mBv8DJNmeWTzhqoixUePfk7DvfX/r91Bih49ZwlSTgg=;
        b=vgp9MzMoWo0pPPdi0SfSjORilnILUGra6tp4OWEkjgvaXy2N4N84XXhqKwSvXL8Nah
         19eFpSxVl4qtEkU4Q/ZHgk4i569C/LI6KEmLciTUEznMtrx8KbIOB1GF2m7RRN/R7cQi
         UH8ilwksbr1kEMZiwj/4SzdF5qu8BEPIPWbpWQcsCUQ2k7KEDTxzOPBmEjjMBePvTS2q
         wibkFCVG77uBFQ2c5W0bAveVK1/gt60kBRzPFhdm/ktCPw0M8SFBtb9NZeWsl+tJnJjz
         l5VY3urVvDn7QbtSU3sO6LttUBaMkfm/e+HxMb5+hT9S1vX4aMUQo1G9lRZ3yohkkjZU
         cVRQ==
X-Gm-Message-State: AO0yUKXgmUnDvi/CvCe3l9YhJM+YxAbSbWgTQrF6UCzhSPdpZUtk/WRy
        88EQT3lfsZv7GbzpsgOODk6pbvccRnyBQluKo9GdJKPta3U9q2gP50K9b/6s6H7E+GUVN8uhwgL
        obshPtR168p1JugKqOCmWyw==
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574977plg.68.1675129875388;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
X-Google-Smtp-Source: AK7set8JSjJ+sRvtPcXP6fVdufCYZ8fk74MG4aecVDj2Iej+5W2CdxzxrzRUj04G/QWJkYRImmyA4Q==
X-Received: by 2002:a17:902:d487:b0:196:15af:e6de with SMTP id c7-20020a170902d48700b0019615afe6demr29574939plg.68.1675129875072;
        Mon, 30 Jan 2023 17:51:15 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b00196077ba463sm8430985plg.123.2023.01.30.17.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 17:51:14 -0800 (PST)
Message-ID: <ba3adefd-f2d8-d074-4dfc-5677c3cd71a3@redhat.com>
Date:   Tue, 31 Jan 2023 09:51:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 12/23] ceph: use bvec_set_page to initialize a bvec
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Mike Marshall <hubcap@omnibond.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        devel@lists.orangefs.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20230130092157.1759539-1-hch@lst.de>
 <20230130092157.1759539-13-hch@lst.de>
 <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP_b77Pq=hYmFMi1zGGRMee2uNjbAbHz_gCCoByOdbRqLw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 31/01/2023 02:02, Ilya Dryomov wrote:
> On Mon, Jan 30, 2023 at 10:22 AM Christoph Hellwig <hch@lst.de> wrote:
>> Use the bvec_set_page helper to initialize a bvec.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   fs/ceph/file.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 764598e1efd91f..6419dce7c57987 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -103,11 +103,11 @@ static ssize_t __iter_get_bvecs(struct iov_iter *iter, size_t maxsize,
>>                  size += bytes;
>>
>>                  for ( ; bytes; idx++, bvec_idx++) {
>> -                       struct bio_vec bv = {
>> -                               .bv_page = pages[idx],
>> -                               .bv_len = min_t(int, bytes, PAGE_SIZE - start),
>> -                               .bv_offset = start,
>> -                       };
>> +                       struct bio_vec bv;
>> +
>> +                       bvec_set_page(&bv, pages[idx],
> Hi Christoph,
>
> There is trailing whitespace on this line which git complains about
> and it made me take a second look.  I think bvec_set_page() allows to
> make this more compact:
>
>          for ( ; bytes; idx++, bvec_idx++) {
>                  int len = min_t(int, bytes, PAGE_SIZE - start);
>
>                  bvec_set_page(&bvecs[bvec_idx], pages[idx], len, start);
>                  bytes -= len;
>                  start = 0;
>          }
>
This looks better.

Thanks

