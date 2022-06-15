Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F468C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jun 2022 18:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358274AbiFOSxB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jun 2022 14:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358216AbiFOSxA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jun 2022 14:53:00 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E09B24BF0
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jun 2022 11:52:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DxQIU6vk0459JWInQz5MU+gjwWPRblqoEj4u5tGEp4HHnQWkbshYHEYVuuiFlbl7vKrMlwqg9Uz0srilERLXMqNecPmbbmKQ9NpuCpHkVOEZeynAtuJdWB+Rf2XWL0KwwR01vRsMiPkAchaMLMhsXD25DUerHcbSMJCrxY0jqzepQZ5s4dE6kwdDmyWJCIQJDRn0ENLt1ZykXxI7+hBvdKt0P216lKncjx9h8rVBE18n4rKxao9Vz1SSyYrvb8gn/qF0ZfHRXhIK9OH7vkTCasGoW64Ebo8lwOiUf/ZjzuKKL0ACsBspj5ij+TCJEMk2XJP/Kw83oxjaghe7GVCr+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ly9ndJu/ReMmKjCbWntXBhDj8WgdaRfPybeiJL4go7U=;
 b=eQGYWo/n8Wts2Pp5qXS5W+iK5TDHj52lrenPw7ktmMIFYRAKf1D0GlW5cxxfsryJe3/jXGEydLpXX9YB2KzLaYTk+WsRvv1YXIggvGX+hGABdIQevJ0zkKaBSjwMtMfxwfzhb5KIRUbBj8aWqc53Vzd1mHhcJ8Ik8DS8JCAy3OnPp/rR5TTqmMG3s9LsFoWcHmIpR75hdBA0yfh8NXoa2bdsi02Zbu42Jk8FsuyAcqlAG518+UpOEdYLgCsBnag8RhE31P6ondIbqtSam9coE3yOOdJKiASzsIBuHA2LqDFqqcuQZxI6EQlZeXC9XoVCI7TuCDeBT3vgjZQRyaBvXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4165.prod.exchangelabs.com (2603:10b6:a03:16::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.16; Wed, 15 Jun 2022 18:52:56 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1883:4cf0:e35d:b6f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1883:4cf0:e35d:b6f%6]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 18:52:55 +0000
Message-ID: <26e088a7-ddf0-8c18-69c8-49fb53813f8d@talpey.com>
Date:   Wed, 15 Jun 2022 14:52:54 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] ksmbd: smbd: handle RDMA CM time wait event
Content-Language: en-US
To:     Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
References: <20220613230119.73475-1-hyc.lee@gmail.com>
 <20220613230119.73475-2-hyc.lee@gmail.com>
 <6b74f448-947b-0b42-f22d-8f3e5db10e50@talpey.com>
 <CANFS6bbNima0zLDWVboq3gd4Szbio7owAs09cesf7SFUHPjWyQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANFS6bbNima0zLDWVboq3gd4Szbio7owAs09cesf7SFUHPjWyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0207.namprd13.prod.outlook.com
 (2603:10b6:208:2be::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84a6c334-f82c-4d6c-3f0a-08da4f004214
X-MS-TrafficTypeDiagnostic: BYAPR01MB4165:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB416519BED46FBEAB4E316729D6AD9@BYAPR01MB4165.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /snQXAYFyPX1EfOiN5DKJgZ9Y2Pj3Acqsw1Wou3r4IkHm2VTOkd85biootcQVMoVYCqK9J1WVOB7N0yNhF4+sl5G1CheUzPYv3UlAzHJaxHO9eJA1RMCqCzVHG2++z3Y1qCapuWpOLdOiHETp3LTROjF+d5u16loESp7tcFzj2gEoydBap9K/SLucHug+sd/YIheV7ZA+aSft+mdBrupZfFZRVNuQX0qHDbJGwftv8cteUxPaDLbCb7QpE78LU5sUOOIAyxDgRzM+SyLq3K/eBLvLHqPaSi62PLPVQZBi8eMVLlGeiIAuNLkUk1zdcjk/92GkYQiiP+cLDXKZ2/QxajRbx0KTep+c767jVTHtMhxu2Y+d6eruTyQ3IoXBIVqfgcDl1TzDU+Ply5NcU8aTsQzzp5JUd/xx1w8CGxfv6BHS+60d+IGhmX0KevsLUN/V/LjQBt+BlzOTJjSLNM4Xy3aBLN+obvYJTmhJqrGBT3yQpqx7Vut2JVDi7ZUiHyo239xOmqNIY8YRegwQpVZ5ANBZ5CaJ2521aJKYZY5ORtazrr0fB8Fi6/eTlUClH/ypFCxpzA3gJJ+yqUlHd/in9GTShDur9b6EBywi6J/bxnqsKTqn+zCweVtHZx6NXkyGoKbZwmCLWy4wxonyijUHND6Hsl+RCHQyMUCdgfjTAR6PVm5lnFmhYZ/h+gWePexnimRmRDppwdU04tpZvh2mDKfFr7Nl8AHr9g9wOkkPDc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39830400003)(366004)(396003)(36756003)(86362001)(8676002)(31686004)(66476007)(5660300002)(4326008)(6486002)(66946007)(2906002)(66556008)(508600001)(2616005)(8936002)(26005)(6512007)(38100700002)(316002)(53546011)(6506007)(186003)(31696002)(38350700002)(83380400001)(54906003)(41300700001)(52116002)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzZUd2lGZDJ1UVhoSmJBcHJNbGo0dWpYZzdES0lNOERvVG1mVkJnZm9Cc1Zy?=
 =?utf-8?B?VGxvSTVRZHIyaTB2cFdHY0VLdm9EWXo1TW5pb0JXVVNLdzcwWENKRjlSK0Rj?=
 =?utf-8?B?WE1leEp4WFp0UERLc2dVL3BWeGorNGNFR1NDU3U0YUtOczJWU2NWUkdvbUlL?=
 =?utf-8?B?UDJES1pyekNQQ3VFSGdxNDc0OFhXSUltcnVOL1lHNWRJbFVGQzRkTDJnVnJt?=
 =?utf-8?B?dTFHS3B1Wm1kaE1BT0VIRGMzdDFIc2ZUdGlmUjd3NjV0aVI2aTJGOW5IanF5?=
 =?utf-8?B?OEdvM3dYWDJhRStBRXlZcUtHUVl1MlBCYnB1WldjVEdWZXI0dnMxYWZHb1J0?=
 =?utf-8?B?M1NjSXB4UUpIdVU5UGZjOWxJM2t6VjhnWGlUelpTclA3N1BJUWNZMnZTZTVv?=
 =?utf-8?B?RVFlZVN0ekt4UDhJRC9YMWFEUmljQXVtaXJyaDlRa1p6QWdwUmZqNmxEdE1V?=
 =?utf-8?B?eGJtbkViTm9YcFVUSjEweWtQaHdrUGdPTTR0blJXcVVNWUdHOEF2SUFOS2FB?=
 =?utf-8?B?eUF2aWxNL0dkdFFsMEo4YTVacWZiSkcvb3RGQ1Z1WWdTblFWT0FERXllQjMw?=
 =?utf-8?B?R0ZrR0JPUG0wbG95NFpidFVwcVBudldTZFJjYnBDU0F0bGVyMThzdGpHNndo?=
 =?utf-8?B?SlpZSjJrNjhXSThKMDdiLzBnb3gyR3E0WmlrcnlrS0lrK0NkVmlLMTllMVRL?=
 =?utf-8?B?STJFS0MvOVFyTUR5QU1RazVrREVtbUFCa3VoUVh6UEI0RkgwaEdLQWV2ZVd5?=
 =?utf-8?B?Qm02RUZqQU1hM1hCcFZPMVlRdmg1YkxBL0t3T2lGcWxkZzc5a0ZnUUJ6LzdT?=
 =?utf-8?B?SjYrcEh6WUloMGswU2h3SmgxRlN1Mlp1QzliWUVIQXNqdFB3RFNhOWFwVlNE?=
 =?utf-8?B?eW1FOFJsODE0UE5tTnplSDg2UWY0S1MzZWQ0Y0hHNGtobUEwLzJCK2czOGlH?=
 =?utf-8?B?YlN4TElUZHM0Z0ZMQ3VhQUVtb0JBZFUrcEdVS3Q0bmk5enpwRnpWZzRkTU5t?=
 =?utf-8?B?Z3FQcGxkZlJBZmFGWWtmSFZraTBRcm5xbUR5Rzh4QzJIWk50Q0dQM015Q2Zq?=
 =?utf-8?B?dnZtTWNOVnZiVjZpcTg5bVp4b2JiUmltdVBXbHZIeTRlWUMzT2Z2a1lsbWtZ?=
 =?utf-8?B?Z0VENzB2VWdjUEhnWldGL3pvZHJXcEF6S2ROZWNNVEFpdGFORGFQNGUrOVg5?=
 =?utf-8?B?VTFrWjQxUHlpeTk5SVVRN2xISU9RcXFaSStGenFuWGdEdVFWdUZyN3hDc0Nm?=
 =?utf-8?B?YjEvenJqTndsWDQvdHVLdHgzMFVHTjRMcDV1ekU2NnR4OW0xdHQ3eUk5QXA5?=
 =?utf-8?B?MlBCZEZTcDVrbUJ2Wi95YmFldmhYODlCZkhFZTV3ODBOalUzbFVMRXBtM0FL?=
 =?utf-8?B?Y1VmcFI1d3ZOKzZMU2JOSDhEWWFFOFFLMkg1ZktIT0xIc2oxdlBocGRUdjh3?=
 =?utf-8?B?OTZNYklaV1pVM0h2V3ZDdXcvU0c4Vm90VURTUkgvZUVMVzVndWZyYzM5a2NF?=
 =?utf-8?B?dFJUaGFkK2ZJWUxKeVhvVkl6ZDVFS3hLRldpMWliaXpoTGFKS0N5RFRLbS9p?=
 =?utf-8?B?TzhhSnJtYUZHenVrWjAxdmFRc2g3RjlXRHZYZDFhR3RzU3Z0L29qbXB3ZWNJ?=
 =?utf-8?B?dkJIZWJMVklWK3Qrak55d010UkxqUUFLcGp2bExvZW1oNHBML292dm9Pdnc0?=
 =?utf-8?B?WnBHdEExMkFHSkRFbzFMTlppdmpubXpJTjE3YUorWU9OV3ZycWdBbGJSVmJB?=
 =?utf-8?B?ZVBGWlpjVDJzMG8zQWwrTndGTFFKbDk1R2JkOUpHYW1FcUgzRXcxeSt1WXZF?=
 =?utf-8?B?bzlzRjRHRzQrQUxGSmFiTStiR1BwdlVXMmRISUJPZzZnVW10VEdqdGZyVmVU?=
 =?utf-8?B?U2c4SDFZYTR3NzJCSGE3T3VDVzliWEttaURzSU5mU1NZTm5HMWZzUU5ma1dR?=
 =?utf-8?B?akNrTG8zd3JXckdQcVFmdGdUeDlQRVVvS1hvQnJGUFdzS3VBbi8rYW15dmo2?=
 =?utf-8?B?UURTQTFNdS9wSnhsN1BvbFBFY1RmOWRzUS9UNFBDSmNzdXd6cHRvdk81YlVT?=
 =?utf-8?B?Ym93bU9mM2Z0QysxZmVMNGNIWkttY2FaZGhzYUl2MnFXS0txeUFEMGIvL0tY?=
 =?utf-8?B?cVBjZUdOekdBenpHalcyMVpOM3pnMVc5NDEydmVwWVUwNTc0VnoyY3dZTGVY?=
 =?utf-8?B?ZGRiSWMzMW9jcUhQWUc3aG9wVlZ1VjRyNG5YOHgwcjFrVmRXMU5XditTaFZk?=
 =?utf-8?B?eVFVQWgzakYzNXFIZ1FMTTV2U0NzYkliRFBlSEFFelRYL0o0WHdVMndaY3ps?=
 =?utf-8?Q?wnIHB7hmNERoLbJWnx?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84a6c334-f82c-4d6c-3f0a-08da4f004214
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 18:52:55.5907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUrHtyuqJ+QKVSS81wfTC77/mGRiadXe9f2Ke5Ix1xToVSukDskaiu7KvTlOWtUN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4165
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 6/14/2022 10:14 PM, Hyunchul Lee wrote:
> 2022년 6월 14일 (화) 오후 8:56, Tom Talpey <tom@talpey.com>님이 작성:
>>
>>
>> On 6/13/2022 7:01 PM, Hyunchul Lee wrote:
>>> After a QP has been disconnected, it stays
>>> in a timewait state for in flight packets.
>>> After the state has completed,
>>> RDMA_CM_EVENT_TIMEWAIT_EXIT is reported.
>>> Disconnect on RDMA_CM_EVENT_TIMEWAIT_EXIT
>>> so that ksmbd can restart.
>>>
>>> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
>>> ---
>>>    fs/ksmbd/transport_rdma.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
>>> index d035e060c2f0..4b1a471afcd0 100644
>>> --- a/fs/ksmbd/transport_rdma.c
>>> +++ b/fs/ksmbd/transport_rdma.c
>>> @@ -1535,6 +1535,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
>>>                wake_up_interruptible(&t->wait_status);
>>>                break;
>>>        }
>>> +     case RDMA_CM_EVENT_TIMEWAIT_EXIT:
>>>        case RDMA_CM_EVENT_DEVICE_REMOVAL:
>>>        case RDMA_CM_EVENT_DISCONNECTED: {
>>>                t->status = SMB_DIRECT_CS_DISCONNECTED;
>>
>> Is this issue seen on all RDMA providers? Because I would normally
>> expect that an RDMA_CM_EVENT_DISCONNECTED will precede the TIMEWAIT
>> event. What scenarios have you seen this not occur?
>>
> 
> There was an issue that ksmbd got stuck after attempting to shutdown.
> We are trying to reproduce it, but we haven't reproduced it yet,
> but It seems to be related to the TIMEWAIT event.

I don't think it's appropriate to add this case to SMB. I think it's
quite unlikely that it will address anything, because an RDMA provider
must have indicated a CM_EVENT_DISCONNECTED prior to any TIMEWAIT.
So, the QP (and connection) will already have been torn down by ksmbd
at the earlier event. Perhaps ksmbd did not properly drain the QP at
the initial disconnect.

 > And other drivers such as nvme have disconnected on the TIMEWAIT event.

NVME is a completely different upper layer, and has different client/
server transport behavior. The SMB session insulates its peers from
most transport errors, and should not be requesting timewait for
its connections, and definitely not waiting for timewait to expire
before initiating teardown (or recovery). The NFS/RDMA client and
server ignore this event, btw.

>> Unless ksmbd wishes to reuse its QP's, which is not currently the
>> case (right?), there's pretty much no reason to manage QP state and
>> hang around for TIMEWAIT.
> 
> Right, ksmbd doesn't reuse QP.

Then there appears to be no good justification for the change. Sorry,
but it's a NAK from me.

Tom.
