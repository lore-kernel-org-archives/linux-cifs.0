Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCC8C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 12:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347536AbiCUM4c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343693AbiCUM4a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 08:56:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E3B4E3A0
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 05:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGS7M/wl23BVjmvQd5JWJ+BbD5NJaH3pRIdIQejHzxWpsnHAtCsW+byu92VeYu3V32sVZCibufsEdl5R7QgAojawEvK4loAQU7QG+eREC8kdXo+TYG9Rdxy3VS7P02owKq8GXUEzxBiJNtYbpDr64iUmcd12eqQWgYS/efziB8YxWZkK1Vp2EgYtN77sB0oWgszKOY7+qsFcil+sQw14fETvvriZAhjkDewQYSFF/m6v5X8GlN7R3vPOte8B3p4UOxmVDWBpPvh2ASQAPM3nW6ANaHkMBHE0XX5ydlYjNJQUyMQ4lmJRgdxDJIB2oyinNExp46CoWg5ga6SYWIAZZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irzrdg7Y7trdWYfQSJUheyttcIgKGHdx1FLYAgtahLA=;
 b=AoKMoTCT70mvwO8MIVXaFT0QvvlzwgR7vU2VtTzw9VrKo6m8x6BjV18HJXexx8OCJ+jfofsuYSIcBffR3vh7Nr2OblxDXgWOB6Dh+VAx1ZA+vYHfJ6jqS9ekPRm4XtRAUHkaifZoM6rxHWWK9d7XDG2/9OE3KFVkKCdrqIvO+l0Q2y7Wh954LkcMSjso+JIyDoICkaOzCwbzX5UWMMLZLEqP+4hZKIVJYrba2jHVxdV2MZHnekoJqWWzf7sKi7GBcCGtpu8XA0X2s2z0ZtZq0Hq//5bmpKNovIYpnjjdFVQjR7+Csrel5TSDCXsgoyIjtcDc335MM4qYEPRHzcpR4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH0PR01MB6921.prod.exchangelabs.com (2603:10b6:610:102::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.15; Mon, 21 Mar 2022 12:55:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 12:55:02 +0000
Message-ID: <2962692d-a0b5-25f2-3053-7e21620639c9@talpey.com>
Date:   Mon, 21 Mar 2022 08:55:00 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
References: <20220321002007.26903-1-pc@cjr.nz>
 <6ef3f7db-a6ed-62c7-226e-b2a20ef5b294@talpey.com> <878rt3v66c.fsf@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <878rt3v66c.fsf@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:208:32a::7) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b415fbaf-4f7c-470a-df7e-08da0b3a037f
X-MS-TrafficTypeDiagnostic: CH0PR01MB6921:EE_
X-Microsoft-Antispam-PRVS: <CH0PR01MB6921F6A09820C2A9C0564A06D6169@CH0PR01MB6921.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x1mzl2sgHSQXwQ/qND64jyzdFOAX706tEoYnPOEHT5oyD0aPg5Y7HmJFuPSRAI05wDjrZnUTOIsCMQ9wVbP+okUmifivjoQg+0WGTDXiN1vHg+1IOMiUpqrsj4VNf86fwvxUKpVsy/1M2cX0fP8lsYGPihenqQ+x1tBwQ95xb6Np4QN1OoxuAPoldCT1ObUew3Px0TUj4wYmkg+PqyBNUEpgRtBDyscakNZqSpbShpd2VxJw7iky5YMWYSbhTBqafB0zePJ7d9uDvHLEYto7ZcemJdzDcMoqTmiKhYh/hvynWb+44NiFp2b5xIsqBjZWJsRtfRKu/QJVbm0loAhXm5QYiBhWaCWVCmOiBqQfqSH12aK5VMiW9EJsD5j3+51X4WnzBMQMBlpDgyAfmJggtQ7HpE0nWBPDsVIEw/YwujP7huuRfh/wH2xydPlTFpEhgmzh9pNZ3a6YPKfkQXK8enZhyVsXq3KSdKcO2W3u1G/jlS2P8kdF7gMo12x/5yBesbEm9BXPEhRLF7IGCDRc4DWaO1ggGOM3ApudGUAm9J8slSjOkxIXwhECC/BO/Wf0Si2VKjODXC2fKFZnmIxmTZxa5H4mFKKnWaPymWcos2VmHCMP5TS7YRjS2k8WS3mWnSbSu1AzURc7z+yHMgjUMQl5xbDKjoTPgUq3ihq9Zii2c6rpSUnBvc2z0XNjZP6A9rcoeYZQ57oCXEmvOzmxs3e0l/pYCzdftS3PRJrmI5M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(376002)(136003)(39830400003)(396003)(66476007)(66556008)(66946007)(2906002)(8676002)(38350700002)(83380400001)(36756003)(38100700002)(53546011)(52116002)(31686004)(6506007)(508600001)(6512007)(6486002)(26005)(186003)(5660300002)(316002)(31696002)(86362001)(2616005)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW1zb1JQb3haeEZGQ01YcExOK3dWdnVIMGJqRE5KQXdSMDlWYkdvRU5lRUov?=
 =?utf-8?B?NW01azlYcFEwVDlIOXlROVJRdUowaDY4VFRsYU91RnBmdktMWHBLNGw2TGJq?=
 =?utf-8?B?L0hTUGl5UGZUUlFNY0RPNzR6ek9SN0trcGJpMjlJaVZXVG02bXBCWDErZkR2?=
 =?utf-8?B?WnpySDBHZUh0MkVsSHpxRUtYRFRnMVhzakVMVytrdG4vSk1aaldoSUI3Ulp4?=
 =?utf-8?B?Z1lNN1pzalQxbFdXOUlvelFRYlVQb1BhYkNNdTRGWFl4Z3JseUtySFk5RWxi?=
 =?utf-8?B?SDRlSTRGZDErT0djQmUybSsrNG8xV2liZlB0Mmg1bnU1UC8zUFN2bE1Uckhr?=
 =?utf-8?B?eElCVHRGQ0RPL0xDYUVwdHlrcGptT3RhY2d6UXB6U0NoN2lKTDRFc0xHQkVM?=
 =?utf-8?B?QjBxN3NqM2o3MzlqZ0ZmQkpUYythclVWVS9ZSGJXVmtwRFdxSHJpV1B1eHRw?=
 =?utf-8?B?RU5hZHpocmhCYmYvWHNNcFhRaEh6WVVyc3dTbGlFTkx5NCsyRHVuZlRmdEpL?=
 =?utf-8?B?UjRRc1l5QlordTZzdTJSQ0o0K3k1N3B0UHQwWU4zcm41dlJQWjh0V1VOOFph?=
 =?utf-8?B?Mk12Z1lodTJXWDhZdXZUWFh2Qys2ZlFCNUVWbkZTRzg0b28vQnBPaXlLVnRU?=
 =?utf-8?B?cEhKemx6dEhNRDJMaU9yODRmeWc4TkxPbGJxS0htNjdKUDRwVkl4WUpTUU9B?=
 =?utf-8?B?VGVRK2lEbytyMGZKWHEwSmdOVmp5NWx2bzc1emFJeWk4OGdhU3BJUm9lTmtR?=
 =?utf-8?B?V0VtN3VyRndNQ0JoVnhiWEQxQnVab3M4aDRQVDNoSmUzd1YvU05vay91QjFF?=
 =?utf-8?B?NEVIVjVMTHJYWWQ2UGJvQ2RNWFYyZlBhQ1FDblg0L0JoTXh0eFFlR29wNUpY?=
 =?utf-8?B?MGlRV1Jram01QWJuWWx1STlUaHk1R3ptVW43SVl6NXEydWNxbWdhUWY5SUF4?=
 =?utf-8?B?d2o2b0ZwWDFReUdycFQxeEY2U3A2TWFxSDNyM2JvQW5IS094Y0IwUSs1eXAy?=
 =?utf-8?B?ZDZzSk5sNnM1Nmc4VkhVMkxDTnlOV2pmQ21aUUVlVG5qVGtDNVNZUHdvK1dy?=
 =?utf-8?B?Z1A0NVJvNjN4VEF5RWFTVmk2cUx5TC9OQ2dYeWVXeEw0YjBFeE1yQytCa2JF?=
 =?utf-8?B?Rk9sTXFaZGo2eldNN0dCOU02WjVVV01wQ1QvQTVwbFIwQnJ0ZkxuK3pxRC9I?=
 =?utf-8?B?SDE0U3o2WDlRVW85Qmg2b2FacStva3lGaHh5S3lVeXN5T0kvcHArRmhsWWR2?=
 =?utf-8?B?Znp5MEZ0a1BiSzRDM29pdVMyMWxhUHpSVm0xZE9CV2k4VGVybmY1aHFLeFVV?=
 =?utf-8?B?YmltRGxlUVhBRktmZlg3SElGODVOcUVBUnJxc21yY2NOcjhKQUYxN0RrSUVM?=
 =?utf-8?B?SG1ZQU90TmNxN204ZTBRV04yVkc1R2U5dm1Ccy8rR1BsR2VMUGNPSURqUjUw?=
 =?utf-8?B?Rk9ldmxNMGNtV1VNcGNDL1ZSK3A2bXdhM0Z6RGVmNHVEeC9iTzhlZHBLQjFE?=
 =?utf-8?B?bS9iMUppeU5kTnFEeVhsYVN3L1V3NE11WVZSaWdXdTd5Y3lNeHdMdUo0aU5h?=
 =?utf-8?B?cFRwSGVxT0FpLzJDVm0zeTE2MGpvV2g2dmZOeXVOcmZkZ3lmdXJsaENCR1R3?=
 =?utf-8?B?elBSejRpNlB3RHlEUlY2by9Wc2ZzekZ0MDRTd1MzTlUyZHdRRU9XK28vUHhL?=
 =?utf-8?B?SnJXUklrMkJQR09iODVJWWRPK1NJRFNMZ2ZQdFgwaTVJODUzWFNYQ3hHNFo0?=
 =?utf-8?B?R0dJS1dEZlI1U1F2MnBnWmZSMlNvNkhtRWVDTVFpdEZPTEt0N3RURFVTS1VU?=
 =?utf-8?B?U2p0eU9Zcyszb2xRUWl6T3RyTnhwenpjQXY4V3lNZDBIZWg4Sm9kZnFhTU02?=
 =?utf-8?B?TDFkRXczM2tVcUZ0Q1gveHdySDRGVEhtTCtLWkprM2loM2lGU2tNZ1NRbUVS?=
 =?utf-8?Q?Zqli60sx+aw=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b415fbaf-4f7c-470a-df7e-08da0b3a037f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 12:55:02.2473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ws7JsdDpewEAEn25C30tQRH004iuoZSUvylbgZMUkEH6mePtTQgX2Ift6fGxE2ai
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6921
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/21/2022 8:30 AM, Paulo Alcantara wrote:
> Tom Talpey <tom@talpey.com> writes:
> 
>> On 3/20/2022 8:20 PM, Paulo Alcantara wrote:
>>> The client used to partially convert the fids to le64, while storing
>>> or sending them by using host endianness.  This broke the client on
>>> big-endian machines.  Instead of converting them to le64, store them
>>> verbatim and then avoid byteswapping when sending them over wire.
>>>
>>> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>>> ---
>>>    fs/cifs/smb2misc.c |  4 ++--
>>>    fs/cifs/smb2ops.c  |  8 +++----
>>>    fs/cifs/smb2pdu.c  | 53 ++++++++++++++++++++--------------------------
>>>    3 files changed, 29 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
>>> index b25623e3fe3d..3b7c636be377 100644
>>> --- a/fs/cifs/smb2misc.c
>>> +++ b/fs/cifs/smb2misc.c
>>> @@ -832,8 +832,8 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
>>>    	rc = __smb2_handle_cancelled_cmd(tcon,
>>>    					 le16_to_cpu(hdr->Command),
>>>    					 le64_to_cpu(hdr->MessageId),
>>> -					 le64_to_cpu(rsp->PersistentFileId),
>>> -					 le64_to_cpu(rsp->VolatileFileId));
>>> +					 rsp->PersistentFileId,
>>> +					 rsp->VolatileFileId);
>>
>> This conflicts with the statement "store them verbatim". Because the
>> rsp->{Persistent,Volatile}FileId fields are u64 (integer) types,
>> they are not being stored verbatim, they are being manipulated
>> by the CPU load/store instructions. Storing them into a u8[8]
>> array is more to the point.
> 
> Yes, makes sense.
> 
>> If course, if the rsp structure is purely private to the code, then
>> the structure element type is similarly private. But a debugger, or
>> a future structure reference, may once again get it wrong
>>
>> Are you rejecting the idea of using a byte array?
> 
> No.  That would work, too.  I was just trying to avoid changing a lot of
> places and eventually making it harder to backport.
> 
> I'll go with the byte array then.

If you want to reduce a bit of code change, you could let the
compiler generate the loads and stores via memcpy, with (perhaps)
a struct { u8[8] } instead of the bare array.

Tom.
