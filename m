Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE2FC4320A
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 12:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18C256102A
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 12:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244539AbhIAMaf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:30:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244552AbhIAM3x (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 1 Sep 2021 08:29:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39198610CA
        for <linux-cifs@vger.kernel.org>; Wed,  1 Sep 2021 12:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630499329;
        bh=UmOC9vrMSIU8kL1l7KVyf02G+B11qc/8kVHQgX6V+q4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=TqCKsYxehx0R9DRuumpNE/0lRAJ4yAe2w8CMGEGOhn0CcXvRO5ufQnHJEvgdpOntO
         zS/TGGCbdgI6Zma2tJQmOlYicNdEgSWO9RnXwvETQX81o5oEUdmJNhbcTRkQdSr5T0
         dujiY4re4+ZmmuOZQ/hebsvcT6d+ZmlRHEZp9+h1DlUYd4xxdmfbhldzAVKs8E1aSc
         E6hIzRvBqeRiJupLdS+q1v8cmAQf6gUSfMMV6x+bOjEe/G/tJ+szNjHWO/qAVOPKkI
         5XU424+iokW5txPHEiBdBfrt8YvuB3LrByVukHvaeB4/8JALL6nVtVc3r/YIdNgTUD
         82wThrUsWo6zw==
Received: by mail-oo1-f41.google.com with SMTP id k20-20020a4ad114000000b0029133123994so772309oor.4
        for <linux-cifs@vger.kernel.org>; Wed, 01 Sep 2021 05:28:49 -0700 (PDT)
X-Gm-Message-State: AOAM531Frjh0YrEyDKpc5j1L3S4y+4WEBb5yP3ch1a7DfR36iJNFrDEr
        FBlOQSsI8Ev0p2Cr/rSurya+3uFtBLbVCVF5wKA=
X-Google-Smtp-Source: ABdhPJyK2JDpPhqv9dQkonCE2z9vxKGa4TgwF7SKZ7ulRG5wOAtwz4NTYZIXaHRy9rLqcyNpDBFH0Zt1eYUam4nyGjI=
X-Received: by 2002:a4a:b907:: with SMTP id x7mr17745821ooo.5.1630499328590;
 Wed, 01 Sep 2021 05:28:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:1bc6:0:0:0:0:0 with HTTP; Wed, 1 Sep 2021 05:28:47 -0700 (PDT)
In-Reply-To: <20210901102240.GA2129@kadam>
References: <20210901004537.45511-1-linkinjeon@kernel.org> <20210901004537.45511-3-linkinjeon@kernel.org>
 <20210901102240.GA2129@kadam>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 1 Sep 2021 21:28:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_mJqT1j2YiO4_kiKKMU6Wz2tLbyqUaMt99y+nBe1-Yag@mail.gmail.com>
Message-ID: <CAKYAXd_mJqT1j2YiO4_kiKKMU6Wz2tLbyqUaMt99y+nBe1-Yag@mail.gmail.com>
Subject: Re: [PATCH 3/4] ksmbd: add validation for ndr read/write functions
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-01 19:22 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Sep 01, 2021 at 09:45:36AM +0900, Namjae Jeon wrote:
>>  int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
>>  {
>> -	char *hex_attr;
>> -	int version2;
>> -
>> -	hex_attr = kzalloc(n->length, GFP_KERNEL);
>> -	if (!hex_attr)
>> -		return -ENOMEM;
>> +	char hex_attr[12];
>> +	unsigned int version2, ret;
>
> "ret" should be int.  It doesn't affect runtime but for correctness it
> should be int.
Ah, Right, I will fix it on v2.
Thanks for your review!
>
>>
>>  	n->offset = 0;
>> -	ndr_read_string(n, hex_attr, n->length);
>> -	kfree(hex_attr);
>> -	da->version = ndr_read_int16(n);
>> +	ret = ndr_read_string(n, hex_attr, sizeof(hex_attr));
>> +	if (ret)
>> +		return ret;
>
> regards,
> dan carpenter
>
>
