Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A87EC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 15:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiJCPs4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJCPsz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 11:48:55 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E004C2F3BF
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 08:48:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gYSegg0Lk3bMqYYMzhkHLPJL4ACySIrnQ6BMcHLFzy1sAyPXlE/gbhjGCFaLXYdAg6+1mUK7T/TI1GDZWX9A2qmauo+ZdANaWxJw9jG6ubyfNy1wlgkhoDzq1Kxj3/z9cnHyhl3rXLaL3wM9p+JXgVT9hG7j6khcHWtv4uetb2lvT6RfMgM5AVCBvLUfCJhypw772Nu/SlY7MNZIUK7cQrenomIE2aUSDEj99K0wC6FCFCqy7SidYiM+yDEiPZcD27168RfK/B7EboBQ9S4FufQ6Y09ZeIzvxAp2mLXGlFbFlS4fK1pH33PYHb/GfDkirYovxM7hM9BPhXjY8sgJJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+dFN4g5Zw9MGNz9alL25TDQWSFfj02dbc+wyxMnu2Y=;
 b=WX1s4kU9y7w3ZhicZ+zfdf+PwgF4fYx91Os5KGJ7BqZ7/urfiWuABVfcF+VBCciU1XHjSATc9pG8USWaiv/GV0QyTmVQhbhKPEgrHMNdZ8Pos6EDuhgmMGI6TtOLZsq4gTDhMSQu4yoH5DtNlNON5c0SfVJLh4pcfOHcKV9xLjb2kQeA0UN306KRtPPCymPXmVTyGStEXVIMnms5tCwzBrFtqcD6xppmguyU1OKadDQnEx9VrlBupym57jOk4UF/M7Jp7c1u8X/19EMx6cAEOB+m7HKSS9VBHWWtRlohKd8HTVavTezZgoRpVpxO483e9l4q4DDxTwazIauZUNq3Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5818.prod.exchangelabs.com (2603:10b6:5:1dd::24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Mon, 3 Oct 2022 15:48:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 15:48:51 +0000
Message-ID: <3bc8a8d1-45b7-8b2b-7400-2264c4197d8c@talpey.com>
Date:   Mon, 3 Oct 2022 11:48:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] ksmbd: call ib_drain_qp when disconnected
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20221002030123.11409-1-linkinjeon@kernel.org>
 <7e06ff88-baa5-c2c1-9184-2cb48d6182a5@talpey.com>
 <CAKYAXd-OVVSkCnMYxTrS06NA5+=dK8D7PHeCLbqxQL6MmJR4qg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-OVVSkCnMYxTrS06NA5+=dK8D7PHeCLbqxQL6MmJR4qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR12CA0014.namprd12.prod.outlook.com
 (2603:10b6:208:a8::27) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 640bdd59-29e3-48c9-f9d0-08daa556c472
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CUAZ3KoTlrt0mgo34UyrjNn5SSSMPecFazNiup9pMXM3g4w2M8jtg5WdDyAZl82h0Dk9c01V9V2bUMfFmqHN4w+Dh9CANcpopH0RstQMSJvd3H+DVv1Qx7Hi1qXc/NTXpR/mHqAyLA6+eMoU6W0E5CfrM7A9AAZoBdH0eok+NA6iZMonRzZYwgETgkeOqJJIhEgRDkXmFBEbjPoJdWRcgVgvNRBiaf4OJpOf33tnj/VgyWVvuccd1rjG+Ewki6Wd2bwbGQrNrDS9vGfRdJ/78JDPLmZ3d4jn4e5khWRbE9/XMopN7QxYkxAMtKY1ttQFuPooGBek1Cxrawqe4JnH7Xvq1Xm8yRlp90yQIqyT7U2JAPZZD+45nBOF7HEtnuB1/PaI2JjLGulbmpAlIitJDzkxVFTtJ37sQc6d30sAfRFsCp87x+YPb25BvrYzdKKfR5jJDesaSUK7ltBku7c+MGi4lbeVKMIB92W1CjamOBu6eYzqVmEchaEaDgn6XccL2DGb3RogA9ekpIP9lpQzuNuCgTw7eVGdUOV2Jq2vP385M4/zjd1Wukh1J/aFYtClo2G/IazuXnivu2K9402o6u4vfERxDF09qtbHAuVRNt7S4frgFRk324F0NtcwJqwbVckn3241hAO0//XAXiP21RJuGG+dEe5v2aPPz8ZGwYEk6CBkZgsb6edEuH+FProO7J52ijukWhcI0GQ6DJOWAqtk7k6NcRcZByRadw9zHbdXWRV5lRXUnSXJHkpoR9oM8cpaq55gkKZm+4970x8gdxt96irN5+sgWJscO7JAgi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39830400003)(366004)(346002)(451199015)(2616005)(86362001)(31696002)(83380400001)(38350700002)(38100700002)(5660300002)(41300700001)(66946007)(8936002)(66556008)(4326008)(66476007)(2906002)(26005)(6506007)(6512007)(478600001)(52116002)(53546011)(186003)(316002)(8676002)(6666004)(6916009)(6486002)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czdYYVVFaWRYR3JsYTZ3NDlBZjI2bXdERmVla0FjODE1dmJ6UjJndzJOMTJS?=
 =?utf-8?B?U1BJL0Y4Q20zTDRZT2RQV3ZpNTJkRkdnUlYxbDErZmV3eTQzZkFKeUNaUHpj?=
 =?utf-8?B?dFJkVE1FdGNKN1lhYTUyL3RQM0JzbUxXRUZPMitDVkFvWWdOZWRWdEVIbVlM?=
 =?utf-8?B?alU0Y2g4WjR6YnAxUDdSL3RZcXRjdVM5cmRSNUVJaEl6MmdnL1grbVZkMGlD?=
 =?utf-8?B?UHYyV1o4dldpbHV5SjJIVmd3WG9JSnVhQytJdCtxdGhsa1Y1eHdVRldPN3RO?=
 =?utf-8?B?QlptdFZheDNZY2xyS3htZ05teGxvdDd4TU9uVEdYUVM2MHZEcHA1YmhIdFkw?=
 =?utf-8?B?bUxaQ3FsRk43WjlrWEpteGFCQTdSTnFyS3lMT09ZbDRkVlV6R0M5ektMQjVu?=
 =?utf-8?B?cjhLdFV3ZDhQdEtJVXZmTkh3TjlmblhuWjloRDgyNHNOOURBQTVEbWQ0Z01E?=
 =?utf-8?B?bkdIRVVnMEZWUWdLVFd3eUorS3QxLzJUWEllcVpBemdLZUdsMVVOZUFLZVJ3?=
 =?utf-8?B?dkNreCs5RlZranVSd2llSG5vcU9aZWtqZXNDdUhrYURDeWd0U3I4Yk82TWRa?=
 =?utf-8?B?L1lnQ0tFaTJqRE1QOWFLbmJMSHBTZGlXdlZ0SitjRE9qNFdNTU9xWUhHSXd5?=
 =?utf-8?B?cWtlRXdwOFJQRXVaVlhBYndUUWxWMENJTXA4blQ2THVtNS9KTE9nemIvVzc2?=
 =?utf-8?B?aXBZZGhQU1lwUStka1pLN2VlRzduTlpDZEdKU0YxR28rWFdEREoxdDUwTG15?=
 =?utf-8?B?N255NWFQUlJGR2xydHFYQ2o1Q3I1OFFKb2tIWk56anVwcnBETWI2VG1aSnlq?=
 =?utf-8?B?RTVZSFFHTkxlRjBYQXpGUkdLU1JiN281SUYrTHlKYWt1RlEwRDBiN3k4dEto?=
 =?utf-8?B?OFlvbHlNRUUxVU1tZHZ1SWRCLzJmYjhHcmFTZUMrd2VyTzN5T3A2OTNpd1gz?=
 =?utf-8?B?VjVGaDFaT3ZvRmk4anJGUGppUnY2Z095bWh5Y0ptelI5RXhPV2RWcm9zRDhj?=
 =?utf-8?B?YXBrRHFuTWNNcTRCRWxLWDJvcnJpYVk5Z1RkSktLVzlJOXkwM2dWbm14bktv?=
 =?utf-8?B?MktNcU03L3FnZUZjd0dwYUx1VFR4RERnMU5mSVFKOGFHdzk3dXBWWm0wSHcx?=
 =?utf-8?B?QUl2UzJiWE9JNkZCM2paZWFJMC9NN2lacHBxYmM2K1VvYUhnWVU3UGhoQ0tI?=
 =?utf-8?B?Y2V1QVg5eEt5VHVaWmdzeTBUdThlcDFrWFZuK3E4aThrbHFNalAzQXZVZVpq?=
 =?utf-8?B?QkpnZlFBdjkzWDFPWHlXSXp5UGtZZlJHR1BQa3RoRzdBaFVOYVljYTIwM0J2?=
 =?utf-8?B?UkRHUC9HaCtDczdpTktVMFpYQ2YxSG9ZR05XM3pXWWNGbzFNWG5vWmJqWlVX?=
 =?utf-8?B?UThBRHNNYWVjZUJyWXJvN2NTNWxPWjJWSzE3Mnd2U1NPK3dIaTVuMW9JQ0xD?=
 =?utf-8?B?QXNQdlRHU3B1L1JwTHlaQmU3T3hTUkNqSTdFRW96WkdJZ0ltYWl5d3lFb0pY?=
 =?utf-8?B?SVhMdmVrQzdjeWZOYnJYbjdLbDVjZ3FwdXpsdDVLNnNnUEcxejBnQTBhOS9v?=
 =?utf-8?B?Ui9rT1RHRVNjejRBU2hmZW1YUytxdFlBUWlRSHlYMkdIa01BZEh3T09ucEx6?=
 =?utf-8?B?bHZDUmxvYkxWR0VtWmNwUUhMemtrakhrdDJkemZxZlkyK3RRSDBDd2I3M1Q0?=
 =?utf-8?B?TG40RWw1TXo5R2kvUEFBQ2pCWlZ5ZUJhUkpxZ3FTbVIyaXJyVmx6VXQ0TEpX?=
 =?utf-8?B?MURQNjlicTJCQWs4clZJM200Kzl2M1dKa0F2cmZYNkxLL2ptNzlZMWY3Z2pT?=
 =?utf-8?B?Q2JUb1FaMGFLQ3VNNmdJQ3ZSVXZ0OGNHRmkyNDVDa2V4MXhUQk9pL2xETGFp?=
 =?utf-8?B?NTk4NW1TU1NPN2g1Q3JnMUdXOVJxYVEza2JZV0QyTUNIYW9RbC9JUzdWL1da?=
 =?utf-8?B?WkdKN1FRQm9xdGQ2TWRXQUlLSlB3Z1dleUFHSDJmWGdKZWUxeExiWlhSUHZJ?=
 =?utf-8?B?OGMxNmNQN0VzWjNNN1o4VFB0MkZxRk1YWVo4MHZRN3ZmcnorVmN5MUtFSDBz?=
 =?utf-8?B?aDlUT1R3b0wxT3Y4ZWFuNGhRdm5yWmNoSHZwSXhwUkFMcllNS0ZMelpKRllp?=
 =?utf-8?Q?1KQcFStqYp+uaPn7+LxbdWz4w?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640bdd59-29e3-48c9-f9d0-08daa556c472
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:48:50.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fETDCW1t9sRHrvF//+OGA14uUxqmitjgQmpHwPit5xXTsO/vfE6jL8PWZiuPRHV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5818
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/3/2022 10:31 AM, Namjae Jeon wrote:
> 2022-10-03 3:11 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 10/1/2022 11:01 PM, Namjae Jeon wrote:
>>> When disconnected, call ib_drain_qp to cancel all pending work requests
>>> and prevent ksmbd_conn_handler_loop from waiting for a long time
>>> for those work requests to compelete.
>>>
>>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/ksmbd/transport_rdma.c | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>> index 0315bca3d53b..096eda9ef873 100644
>>> --- a/fs/ksmbd/transport_rdma.c
>>> +++ b/fs/ksmbd/transport_rdma.c
>>> @@ -1527,6 +1527,8 @@ static int smb_direct_cm_handler(struct rdma_cm_id
>>> *cm_id,
>>>    	}
>>>    	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>>>    	case RDMA_CM_EVENT_DISCONNECTED: {
>>> +		ib_drain_qp(t->qp);
>>> +
>>>    		t->status = SMB_DIRECT_CS_DISCONNECTED;
>>>    		wake_up_interruptible(&t->wait_status);
>>>    		wake_up_interruptible(&t->wait_reassembly_queue);
>>
>> Because we're now flushing the cancelled work requests, don't
>> we need to also wake up &t->wait_send_pending, to abort any
>> waiters on the send wq?
> Could you please elaborate more how it could be a problem ?
> send_pending is decreased and wake_up &t->wait_send_pending if it is
> zero in send_done().

I took another look at __ib_drain_sq() and yes it does put the
qp into ERR, and only steals the single WR that it itself posted.
As long as we're not using IB_POLL_DIRECT (which ksmbd isn't), we're
good.

Reviewed-by: Tom Talpey <tom@talpey.com>
