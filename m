Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD63C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 23:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiCUXtB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 19:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbiCUXtA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 19:49:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A67E1890EE
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 16:47:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB2C61245
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 23:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ADDC340EE
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 23:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647906450;
        bh=xAYv9cyMt26TgMgx5loe24SEUn4Yq6Ky5QtAZTz5PwQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=T5hLS0Zkqqr9mO9U3bQCPWn4XU4pdtJW7LnCBMX13THobhyj/fFMcQqTtk1hDKRZl
         drx8iqbRVm7BSoafpfzIlLhWA6zc1W8BjYCgJ0F9wQomse1lK0ZtEvtczDBywW4R6c
         n0YnL6YsvA/57I510Kj173EKleQUyqr65FqMh6LO7LhN5ywRDZ8w9IeLp3fbcrEe/J
         lq9DKHw0EINURHV0Z0Xarmu0onnwQDuQISMWi7OW2ehVaPXpGOwRpL2bjIAjX/PSjW
         pRi/VKRINATIKRFLSDTtLcaMY2A6yVrKB6f8H3SyMVXJQZ+SJTLaE9Brt0+UyQbCgT
         1+8B1Zda9kHpQ==
Received: by mail-wr1-f45.google.com with SMTP id r13so7722542wrr.9
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 16:47:30 -0700 (PDT)
X-Gm-Message-State: AOAM532jq7sxXoTCfYKnMwCL/tGjvddxq/EDZ3I8SG2TWcXLkmFQ/iGL
        rQZZZPm4PUU8l/Iptu9Re0077HqzVdZhMeW1VGA=
X-Google-Smtp-Source: ABdhPJw/BRy1aAjhtlXo8bRlKqCwT2+zJt3TOg4XE0msTCmEDomX1fNy54RcM+BZtXtwXsJ+Bs8/djdv1Jj+lABpB4w=
X-Received: by 2002:adf:908e:0:b0:1e7:bea7:3486 with SMTP id
 i14-20020adf908e000000b001e7bea73486mr19501020wri.401.1647906448573; Mon, 21
 Mar 2022 16:47:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Mon, 21 Mar 2022 16:47:27
 -0700 (PDT)
In-Reply-To: <87zgljt1sv.fsf@cjr.nz>
References: <20220321160826.30814-1-pc@cjr.nz> <4fae4d1a-b6b0-d212-61fa-a6d6df8f2b6b@talpey.com>
 <87zgljt1sv.fsf@cjr.nz>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 22 Mar 2022 08:47:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-dSzOwKPqfM0ReWdYNe2vFUSWkv3fZxOihGXfVBR4t5Q@mail.gmail.com>
Message-ID: <CAKYAXd-dSzOwKPqfM0ReWdYNe2vFUSWkv3fZxOihGXfVBR4t5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] cifs: fix bad fids sent over wire
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-22 6:48 GMT+09:00, Paulo Alcantara <pc@cjr.nz>:
> Tom Talpey <tom@talpey.com> writes:
>
>> I agree this is the most practical way to address the issue, and
>> any potential static checker warnings.
>>
>> Have you tested on both endian clients I assume? Might be tricky
>> to catch all the ops/cases, especially that cancel.
>
> I did some quick tests on x86_64 and s390x under QEMU against Windows
> 2022 server and ksmbd and all seemed to work.  Hopefully Steve & Namjae
> can also help with more tests.
>
>> Reviewed-By: Tom Talpey <tom@talpey.com>
                      ^
Minor nit, B must be lowercase. This will cause a warning from checkpatch.pl.

And looks good to me too, Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks:)
>
> Thanks!
>
