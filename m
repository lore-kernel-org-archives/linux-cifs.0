Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2F4C0032E
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Oct 2023 23:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjJTXIW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Oct 2023 19:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjJTXIW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Oct 2023 19:08:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBB3D69
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 16:08:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4021C433CA
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 23:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697843296;
        bh=c/vK59QfMRcbHZ1Jf1/CyKdPuD17plRx82IAJpzO+no=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Cts7QqItdMypVB33/JzoLOn4ZkImGOxPTpH/qagHGtsNoqfZvutEf0m87IjjO/8QU
         uoZdqev5aaE7SpmT+8mysK5AtPFqXr1oaOJhQmNhv+OHLqK5cqr+m6b2fbYk21MjU6
         6fP31Q31L4nK0BjGTResasxIvv9UA5VOpcx/5aQ4F3a6Z2wkv+oLrn+ppH8Xt6PVzv
         jbT7+Mc4+RjXfH94Flh9TyEf6T7wn82Hgpn9/918VmpdPsJpl2LHKNYMKi8EXMfqqV
         LUkgGs/xNhQM4+8eCvYshSauA56IUmjG4xSAHrsqjs1I/voNtgJsApaVzkcENs+ET0
         7uNXQ9Z/tmYJA==
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-584042e7f73so781734eaf.2
        for <linux-cifs@vger.kernel.org>; Fri, 20 Oct 2023 16:08:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YzrprpzMUMuKeaIyLKZHqR3Q7jSIm8SAyjoGoFPryC6sS6JhmSF
        zKapDfRPJstWiRduDBcrMjMZU1FBaEEu7Bat7Is=
X-Google-Smtp-Source: AGHT+IGAAXDm2l6EGss2ZTmQ9ZpcBFNcBx7+o3Rwy+EL0RZHmN2FLn5WwhC78w7FvmXfvRMPeOG9lz/EHFtgdqt/eHg=
X-Received: by 2002:a4a:de93:0:b0:57b:eee7:4a40 with SMTP id
 v19-20020a4ade93000000b0057beee74a40mr3684795oou.7.1697843295963; Fri, 20 Oct
 2023 16:08:15 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:347:0:b0:4fa:bc5a:10a5 with HTTP; Fri, 20 Oct 2023
 16:08:14 -0700 (PDT)
In-Reply-To: <05cca6e5-350c-422c-abae-81f2855cf73a@talpey.com>
References: <6d41a4df-e0ab-47e5-a476-f5b6620bfe8d@gmail.com>
 <CAKYAXd8tPdomxriZbLMVOyG6f-mb+cfWb4HPGrywGvOZhnbD6A@mail.gmail.com> <05cca6e5-350c-422c-abae-81f2855cf73a@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sat, 21 Oct 2023 08:08:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_WSWp8Q3_DmrTLw4R7GmEe3+BAnOwmDauAbnyvrKL2gA@mail.gmail.com>
Message-ID: <CAKYAXd_WSWp8Q3_DmrTLw4R7GmEe3+BAnOwmDauAbnyvrKL2gA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix missing RDMA-capable flag for IPoIB device
 in ksmbd_rdma_capable_netdev()
To:     Tom Talpey <tom@talpey.com>
Cc:     "Kangjing \"Chaser\" Huang" <huangkangjing@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-10-21 5:27 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 10/20/2023 10:45 AM, Namjae Jeon wrote:
>> 2023-10-20 22:02 GMT+09:00, Kangjing "Chaser" Huang
>> <huangkangjing@gmail.com>:
>>> Physical ib_device does not have an underlying net_device, thus its
>>> association with IPoIB net_device cannot be retrieved via
>>> ops.get_netdev() or ib_device_get_by_netdev(). ksmbd reads physical
>>> ib_device port GUID from the lower 16 bytes of the hardware addresses on
>>> IPoIB net_device and match its underlying ib_device using ib_find_gid()
>>>
>>> Signed-off-by: Kangjing Huang <huangkangjing@gmail.com>
>>> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
>> Can you fix the warnings from checkpatch.pl ?  You need to run it like
>> this. ./scripts/checkpatch.pl [patch]
>>
>> WARNING: Block comments use a trailing */ on a separate line
>> #148: FILE: fs/smb/server/transport_rdma.c:2256:
>> +			 * check for matching infiniband GUID in hw_addr */
>>
>> WARNING: From:/Signed-off-by: email name mismatch: 'From: "Kangjing
>> \Chaser\ Huang" <huangkangjing@gmail.com>' != 'Signed-off-by: Kangjing
>> Huang <huangkangjing@gmail.com>'
>>
>> total: 0 errors, 2 warnings, 54 lines checked
>>
>>
>> And have you made this patch on linux 6.6-rc6 kernel ? because I can't
>> apply this patch with the following error.
>>
>> checking file fs/smb/server/transport_rdma.c
>> Hunk #1 FAILED at 2140.
>> Hunk #2 FAILED at 2241.
>> 2 out of 2 hunks FAILED
>>
>> Thanks.
>
> With these glitches addressed, please add my
>
> Reviewed-by: Tom Talpey <tom@talpey.com>
Thanks for your review!
>
> Thanks for the update.
>
>>>
>>> v2 -> v1:
>>> * Add more detailed description to comment
>>> ---
>>>    fs/smb/server/transport_rdma.c | 39
>>> +++++++++++++++++++++++++---------
>>>    1 file changed, 29 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/smb/server/transport_rdma.c
>>> b/fs/smb/server/transport_rdma.c
>>> index 3b269e1f523a..a623e29b2760 100644
>>> --- a/fs/smb/server/transport_rdma.c
>>> +++ b/fs/smb/server/transport_rdma.c
>>> @@ -2140,8 +2140,7 @@ static int smb_direct_ib_client_add(struct
>>> ib_device
>>> *ib_dev)
>>>    	if (ib_dev->node_type != RDMA_NODE_IB_CA)
>>>    		smb_direct_port = SMB_DIRECT_PORT_IWARP;
>>>
>>> -	if (!ib_dev->ops.get_netdev ||
>>> -	    !rdma_frwr_is_supported(&ib_dev->attrs))
>>> +	if (!rdma_frwr_is_supported(&ib_dev->attrs))
>>>    		return 0;
>>>
>>>    	smb_dev = kzalloc(sizeof(*smb_dev), GFP_KERNEL);
>>> @@ -2241,17 +2240,37 @@ bool ksmbd_rdma_capable_netdev(struct net_device
>>> *netdev)
>>>    		for (i = 0; i < smb_dev->ib_dev->phys_port_cnt; i++) {
>>>    			struct net_device *ndev;
>>>
>>> -			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
>>> -							       i + 1);
>>> -			if (!ndev)
>>> -				continue;
>>> +			if (smb_dev->ib_dev->ops.get_netdev) {
>>> +				ndev = smb_dev->ib_dev->ops.get_netdev(
>>> +					smb_dev->ib_dev, i + 1);
>>> +				if (!ndev)
>>> +					continue;
>>>
>>> -			if (ndev == netdev) {
>>> +				if (ndev == netdev) {
>>> +					dev_put(ndev);
>>> +					rdma_capable = true;
>>> +					goto out;
>>> +				}
>>>    				dev_put(ndev);
>>> -				rdma_capable = true;
>>> -				goto out;
>>> +			/* if ib_dev does not implement ops.get_netdev
>>> +			 * check for matching infiniband GUID in hw_addr */
>>> +			} else if (netdev->type == ARPHRD_INFINIBAND) {
>>> +				struct netdev_hw_addr *ha;
>>> +				union ib_gid gid;
>>> +				u32 port_num;
>>> +				int ret;
>>> +
>>> +				netdev_hw_addr_list_for_each(
>>> +					ha, &netdev->dev_addrs) {
>>> +					memcpy(&gid, ha->addr + 4, sizeof(gid));
>>> +					ret = ib_find_gid(smb_dev->ib_dev, &gid,
>>> +							  &port_num, NULL);
>>> +					if (!ret) {
>>> +						rdma_capable = true;
>>> +						goto out;
>>> +					}
>>> +				}
>>>    			}
>>> -			dev_put(ndev);
>>>    		}
>>>    	}
>>>    out:
>>> --
>>> 2.42.0
>>>
>>>
>>
>
