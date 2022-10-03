Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12AEC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 14:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiJCObw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 10:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJCObv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 10:31:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 490D8491FC
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 07:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1F50B80EFF
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 14:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D03C433C1
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664807507;
        bh=8u+IzeF4e0qIlS7VYSLJbVygVRIud3A1yVxcYNb2LBU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=fcZLnxr0+DSqx4y9uVtZ4WUlq/txtU4R4Hn+7m0nDlXTIFIehzC1Jp7vtuaxoa/PV
         4BzjNYNpNNQn8ZvzXXqYeLhYNOvnOQQ1k8wZFJ6BzKXqn9hhavfFeo/07MzBRr5BLi
         Z73XBGjbQmzANC/9alUgNeo2UY0V3eQbSTj+5kZ8qS3U3EMkQPj47S0mEamChWTQpr
         q/DpU2Scx+jgaKkCMvrY6EgkxikzE6DGmjtbOi4SoUn3tJePAEw9TXPJqCo2pdNSjQ
         s2cxR1TZhrhs+Y9b1NG+COWuvpxivDZ/RLTinSN8BXEA1RJYLkRwPDxhaLbjA+yDVo
         IABqzGx28eIZQ==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-131ea99262dso10874577fac.9
        for <linux-cifs@vger.kernel.org>; Mon, 03 Oct 2022 07:31:47 -0700 (PDT)
X-Gm-Message-State: ACrzQf0Y9ejyjwpymy0lrvzeCABLH/MbKPhJnjpWLGb0AS5Y/B/6dGKZ
        QrshylMMsFg2aeQKtGu9T213qCKSL/yZBhrTEHM=
X-Google-Smtp-Source: AMsMyM4oZY0CHq9Rzkem8OE7jlkOtq9XLJwVc1MzLNeZtKIhlJg+icdrOqoLeicacAWuM2xB3PQGKmzvgmV0yZuUjLc=
X-Received: by 2002:a05:6871:207:b0:132:7706:e74f with SMTP id
 t7-20020a056871020700b001327706e74fmr2299901oad.8.1664807506893; Mon, 03 Oct
 2022 07:31:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:ea0c:0:0:0:0 with HTTP; Mon, 3 Oct 2022 07:31:46
 -0700 (PDT)
In-Reply-To: <7e06ff88-baa5-c2c1-9184-2cb48d6182a5@talpey.com>
References: <20221002030123.11409-1-linkinjeon@kernel.org> <7e06ff88-baa5-c2c1-9184-2cb48d6182a5@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 3 Oct 2022 23:31:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-OVVSkCnMYxTrS06NA5+=dK8D7PHeCLbqxQL6MmJR4qg@mail.gmail.com>
Message-ID: <CAKYAXd-OVVSkCnMYxTrS06NA5+=dK8D7PHeCLbqxQL6MmJR4qg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: call ib_drain_qp when disconnected
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-10-03 3:11 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 10/1/2022 11:01 PM, Namjae Jeon wrote:
>> When disconnected, call ib_drain_qp to cancel all pending work requests
>> and prevent ksmbd_conn_handler_loop from waiting for a long time
>> for those work requests to compelete.
>>
>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/transport_rdma.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>> index 0315bca3d53b..096eda9ef873 100644
>> --- a/fs/ksmbd/transport_rdma.c
>> +++ b/fs/ksmbd/transport_rdma.c
>> @@ -1527,6 +1527,8 @@ static int smb_direct_cm_handler(struct rdma_cm_id
>> *cm_id,
>>   	}
>>   	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>>   	case RDMA_CM_EVENT_DISCONNECTED: {
>> +		ib_drain_qp(t->qp);
>> +
>>   		t->status = SMB_DIRECT_CS_DISCONNECTED;
>>   		wake_up_interruptible(&t->wait_status);
>>   		wake_up_interruptible(&t->wait_reassembly_queue);
>
> Because we're now flushing the cancelled work requests, don't
> we need to also wake up &t->wait_send_pending, to abort any
> waiters on the send wq?
Could you please elaborate more how it could be a problem ?
send_pending is decreased and wake_up &t->wait_send_pending if it is
zero in send_done().

>
> Tom.
>
