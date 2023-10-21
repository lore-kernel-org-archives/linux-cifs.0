Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09F0C0032E
	for <linux-cifs@archiver.kernel.org>; Sat, 21 Oct 2023 07:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjJUHhl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 Oct 2023 03:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjJUHhk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 Oct 2023 03:37:40 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF381BF
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 00:37:35 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-776f84c6cc7so97257985a.2
        for <linux-cifs@vger.kernel.org>; Sat, 21 Oct 2023 00:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697873855; x=1698478655; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1PNwebhZsyTeSw4VFNR+v2qrzlkUlH6KJNLIS0BJMm0=;
        b=WQCXBN4c33xYilWBEdUrYsWscgeHKKDpy/o/znmrFEEePe/TcASUx7ZYY3CVbmEU3k
         TOZ4uU4fNiZMGVi4AJ+kzgsxUIFpmRSlWJ6DitDBE2ACkIvUu89qDn1bwwfBrshkUnDW
         EmdmhO6q+RugGOh12jrmrKsNbcSC+0WWib23F5dPoDebNLaBn2BnNsV0YpefFADxQjk3
         JQmWPD9MA9PQnxlDAo4B3bq1cdyjaZH3qiJ45MH3cVFMVFYAQ1a/nVV3RwBB0kqs46UP
         ZpPEzn8ewG0oIxwgJM0w/Xdwvl4khcO6Yam6Ci9sfwOqnOZ2MydfPsNGnHx6nkEPh/L7
         TyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697873855; x=1698478655;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1PNwebhZsyTeSw4VFNR+v2qrzlkUlH6KJNLIS0BJMm0=;
        b=A7SqrhZIYsULLtmzfzJoJS4yrzkJ+WwZDZIrSbnlJMsBwRuQqrDiXMMg6vH629/kWR
         iPPbhve6xvMBhwDeEBzEkjNr/YZPTzSsIsQVZc6BmHC2GWlRsVNoZXS51wL11mfY1wgO
         gJSmx/dIyNlJS28/wCZUvmEBZHhKdiu7jvzVQDzYvY1hzIRklQVM18VpJ77mZzpuwXvg
         M2+FCeShGfqf3iVAD5DyRSKyhep9McoSQwwlYlsEtyPKwfUbkUuB1gg0Pqoc3NWqI2LS
         XuZGxbj7C0CjmjQ13kP3q50N11Y44gyioEn5UbU8rDphpwfhyO4DeRbw0cvKBzhWJ0h8
         d9ag==
X-Gm-Message-State: AOJu0YydMzpNjKchih2fEySyCMLEKgEhxuYYaUjHiJU1VMXwJtjbmfOG
        Tm26W17Fwp5eKijEBHP+MQ==
X-Google-Smtp-Source: AGHT+IHdvax6QuP6fqqRWN6VKqHJ1cy/+PzOJlW6qEH5qXSG6k9ed0CTaOzz2FbcR/9dZk0s+QjmZA==
X-Received: by 2002:a05:620a:4495:b0:775:7530:cbf8 with SMTP id x21-20020a05620a449500b007757530cbf8mr4963096qkp.39.1697873854799;
        Sat, 21 Oct 2023 00:37:34 -0700 (PDT)
Received: from ?IPV6:2607:fea8:1da0:b84::e1c? ([2607:fea8:1da0:b84::e1c])
        by smtp.gmail.com with ESMTPSA id ek17-20020ad45991000000b006365b23b5dfsm1300158qvb.23.2023.10.21.00.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Oct 2023 00:37:34 -0700 (PDT)
Message-ID: <0d91fb8e-b808-403a-a88c-59fd08df1a72@gmail.com>
Date:   Sat, 21 Oct 2023 03:37:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: fix missing RDMA-capable flag for IPoIB device
 in ksmbd_rdma_capable_netdev()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <6d41a4df-e0ab-47e5-a476-f5b6620bfe8d@gmail.com>
 <CAKYAXd8tPdomxriZbLMVOyG6f-mb+cfWb4HPGrywGvOZhnbD6A@mail.gmail.com>
 <05cca6e5-350c-422c-abae-81f2855cf73a@talpey.com>
 <CAKYAXd_WSWp8Q3_DmrTLw4R7GmEe3+BAnOwmDauAbnyvrKL2gA@mail.gmail.com>
From:   Kangjing Huang <huangkangjing@gmail.com>
In-Reply-To: <CAKYAXd_WSWp8Q3_DmrTLw4R7GmEe3+BAnOwmDauAbnyvrKL2gA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/20/23 19:08, Namjae Jeon wrote:
> 2023-10-21 5:27 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 10/20/2023 10:45 AM, Namjae Jeon wrote:
>>> 2023-10-20 22:02 GMT+09:00, Kangjing "Chaser" Huang
>>> <huangkangjing@gmail.com>:
>>>> Physical ib_device does not have an underlying net_device, thus its
>>>> association with IPoIB net_device cannot be retrieved via
>>>> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
>>>> ib_device port GUID from the lower 16 bytes of the hardware addresses on
>>>> IPoIB net_device and match its underlying ib_device using ib_find_gid()
>>>>
>>>> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
>>>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>>> Can you fix the warnings from checkpatch.pl ?  You need to run it like
>>> this. ./scripts/checkpatch.pl [patch]
>>>
>>> WARNING: Block comments use a trailing */ on a separate line
>>> #148: FILE: fs/smb/server/transport_rdma.c:2256:
>>> +			 * check for matching infiniband GUID in hw_addr */
>>>
>>> WARNING: From:/Signed-off-by: email name mismatch: 'From: "Kangjing
>>> \Chaser\ Huang" <huangkangjing@gmail.com>' != 'Signed-off-by: Kangjing
>>> Huang <huangkangjing@gmail.com>'
>>>
>>> total: 0 errors, 2 warnings, 54 lines checked
>>>
>>>
>>> And have you made this patch on linux 6.6-rc6 kernel ? because I can't
>>> apply this patch with the following error.
>>>
>>> checking file fs/smb/server/transport_rdma.c
>>> Hunk #1 FAILED at 2140.
>>> Hunk #2 FAILED at 2241.
>>> 2 out of 2 hunks FAILED
>>>

Sorry about that. I did do it on v6.6-rc6. It may be my mail client's 
issue with plain text emails, I'm sending again together with the 
comment format fixed and the review tag using git send-email.


>>> Thanks.
>>
>> With these glitches addressed, please add my
>>
>> Reviewed-by: Tom Talpey <tom@talpey.com>
> Thanks for your review!
>>
>> Thanks for the update.
>>
>>>>
>>>> v2 -> v1:
>>>> * Add more detailed description to comment
>>>> ---
>>>>     fs/smb/server/transport_rdma.c | 39
>>>> +++++++++++++++++++++++++---------
>>>>     1 file changed, 29 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/smb/server/transport_rdma.c
>>>> b/fs/smb/server/transport_rdma.c
>>>> index 3b269e1f523a..a623e29b2760 100644
>>>> --- a/fs/smb/server/transport_rdma.c
>>>> +++ b/fs/smb/server/transport_rdma.c
>>>> @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct
>>>> ib_device
>>>> *ib_dev)
>>>>     	if (ib_dev->node_type != RDMA_NODE_IB_CA)
>>>>     		smb_direct_port = SMB_DIRECT_PORT_IWARP;
>>>>
>>>> -	if (!ib_dev->ops.get_netdev ||
>>>> -	    !rdma_frwr_is_supported(&ib_dev->attrs))
>>>> +	if (!rdma_frwr_is_supported(&ib_dev->attrs))
>>>>     		return 0;
>>>>
>>>>     	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
>>>> @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_device
>>>> *netdev)
>>>>     		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>>>>     			struct net_device *ndev;
>>>>
>>>> -			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
>>>> -							       i + 1);
>>>> -			if (!ndev)
>>>> -				continue;
>>>> +			if (smb_dev->ib_dev->ops.get_netdev) {
>>>> +				ndev = smb_dev->ib_dev->ops.get_netdev(
>>>> +					smb_dev->ib_dev, i + 1);
>>>> +				if (!ndev)
>>>> +					continue;
>>>>
>>>> -			if (ndev == netdev) {
>>>> +				if (ndev == netdev) {
>>>> +					dev_put(ndev);
>>>> +					rdma_capable = true;
>>>> +					goto out;
>>>> +				}
>>>>     				dev_put(ndev);
>>>> -				rdma_capable = true;
>>>> -				goto out;
>>>> +			/* if ib_dev does not implement ops.get_netdev
>>>> +			 * check for matching infiniband GUID in hw_addr */
>>>> +			} else if (netdev->type == ARPHRD_INFINIBAND) {
>>>> +				struct netdev_hw_addr *ha;
>>>> +				union ib_gid gid;
>>>> +				u32 port_num;
>>>> +				int ret;
>>>> +
>>>> +				netdev_hw_addr_list_for_each(
>>>> +					ha, &netdev->dev_addrs) {
>>>> +					memcpy(&gid, ha->addr + 4, sizeof(gid));
>>>> +					ret = ib_find_gid(smb_dev->ib_dev, &gid,
>>>> +							  &port_num, NULL);
>>>> +					if (!ret) {
>>>> +						rdma_capable = true;
>>>> +						goto out;
>>>> +					}
>>>> +				}
>>>>     			}
>>>> -			dev_put(ndev);
>>>>     		}
>>>>     	}
>>>>     out:
>>>> --
>>>> 2.42.0
>>>>
>>>>
>>>
>>

