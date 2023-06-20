Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6E36EB64D7
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Jun 2023 14:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbjFTOC1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jun 2023 10:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjFTOCZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Jun 2023 10:02:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DC2A4
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 07:02:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzmQiwW6bqYOMCliUbPt2ZpXwVf6HoZ+P1KNcx6BXbhB0RgUfY9qqm+dy5td5ldzyUrg9EkLRRBGpEaDoQ0NWAULEqZAPCRRetvg/wIytNM6hXBrz1QP6jboY0mFUr8vKy7ajN5R4Upix/sWJ+M2wDPupHhKDWuV8M+VPQf6nXqeu8Q0QmSTcoazxZAZe6H5S5h4Nig1MsCWexB/oiZEs/+qdv+sycGxwntBZT1Nd4C7ZR/UNF6MPBUZx7zDF79vWiXys8PTtC8cQSwM2UzXuwFC/3gZMNntX+y8+Rle+6BTWIJe83mvd+dQv54kOImwy5sQcyjuS/qpC6UtlI3sRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bt+1vTuvin8z+n/4V0cef/Ws+5YE+oYKw7VlG8H2bu4=;
 b=JEU/87Pif8ydTVpK+SPS6aWzXYN1Rlg8gMbNnOIIRxbiJC6YA4zGQldGKAMfTvgBtr76nWXhiPtlfDazsSRKy3lIejHs6rIMvHTZdXg/Kh7XgAzdhCLuDgVkyLrrCeqR72jKrtkM05eyLU7pV5ygVBAJTzo2omWHecR0ItYMKFODmmS5VkC0pK8S0As6mcrf0UVHRsHftLssqVMSzYnCPHg2NgnOgyPEVEAHA4KP/R/d0znMVkmw7eoYvPgEqSyo8wRkWyKUQjgSlwhf2A8m742cVXzmOG9HcdYbqvcJxvMtULLuWk4ssv7EXxnnMPpXb0zY6uK0IQ+zgZBxfKKATw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA1PR01MB6670.prod.exchangelabs.com (2603:10b6:806:1a8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Tue, 20 Jun 2023 14:02:20 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 14:02:20 +0000
Message-ID: <26be4fc6-ec99-891c-e9e8-1f770847bf2a@talpey.com>
Date:   Tue, 20 Jun 2023 10:02:20 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        Steve French <smfrench@gmail.com>, sfrench@samba.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
 <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com>
 <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
 <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com>
 <CANT5p=p8Cx1AgHZVWDjVLrndXQ=aRymLbQiuERFVZFg=w-LgSA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=p8Cx1AgHZVWDjVLrndXQ=aRymLbQiuERFVZFg=w-LgSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0090.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::35) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA1PR01MB6670:EE_
X-MS-Office365-Filtering-Correlation-Id: adfc78eb-a3fa-44eb-3ce6-08db7196f6be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +H4fk4k9MR0pYr2sWmjeOWToNyeIAyyo/J2ZtURYIKdQbz6CDt0xclwfhj9W7CdvRf/qoKKvmdp7ePnJ9xhiKxTy2m54DqU+yBa8UBO/fJarBFqWW4aJcO1NqV/rRbbM+VaPbOoV0ekqHCFLHt7RoOEkyTZrx/9k79rGRrMKCFZx7ht4jFRLycuZm7LqF8oJQGsQNpdXryEuSLx8Zz7mW7ZSQHuYGRtM/EbpCx4hjF9HzMX71Cl6po2smWRFUh2LYS5IRQZ4o5JlgKv5xdumU9YZwqCRzYLFfL2ggB6UsVV7RXT1r5N5C3HFlWDnaMqkuKrmydnEG69eBD2zUR9sLcALtGeHC7WbfBb7mlALELEhmB0DZ9Eb7uHYSxkoLfPAHKrOY+v49g3s3m+eZznb1My7vvS/aUpCYxewYWCHGD/AOu6Ml8EOQijgO0q/PRWbUG5LzYEc3XVqywDuRmk0KMtUhlxu4MdNBLbAx+M3obuA97pRF0nLlZxEqc9/xFIJzIuPxHMaIyBsIHgXd2PzJ9evgejds5kjn/LimVsdWSn7Q9WeDWR/tA/lxeHf+6gagnNwR/gbBcYznFXWSeWeic6fGq593INeKktO5xk1UuQrHgLWPY0LMvDxUyVgVCxUTKzfeFwbrnorK5X2DZR6IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39830400003)(366004)(376002)(136003)(396003)(451199021)(41300700001)(31686004)(5660300002)(54906003)(2906002)(316002)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(6916009)(45080400002)(36756003)(478600001)(52116002)(6486002)(31696002)(38100700002)(38350700002)(53546011)(86362001)(2616005)(83380400001)(26005)(186003)(6512007)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTladUZ0OHp4R25BK0UxSjMzWlVPZEZDZ2lyRFBKUGcrVEJQZFljQVQxTlVH?=
 =?utf-8?B?OWk2d1Blb05qaTQyZVlvc0Y3bmY4cGhXeFNvdkRBQ0FJRjNLTUt6dUJML3ZO?=
 =?utf-8?B?MG1kekRyblBiQmhnYjFaMlZ5RUU0L1IrVTlKWVk1dmVvRFVqYysxeHhwVDBQ?=
 =?utf-8?B?Z2RMbU1jN0p3MnJMdjFORkpuMG51c1hYUDJQdUxFQ3dTR2N5QWx3YjFiekpV?=
 =?utf-8?B?QlphbEdXOC9hL1JIeFg4ZWwwVXJmaDVvd3R6Q2YyTW0zeUxaZndOa0ZzWnBx?=
 =?utf-8?B?THJXY3NBTkpONWx3OVNpTENLRkpPZGg5R1d5bS9rUGY0c3VEVFdhZGt3YmhL?=
 =?utf-8?B?clVXS3lhdjE5MXpvelgyTTBLUUlxNm1kNk43M1c2Z3NSVFc0YTk4Mnh1Z2lI?=
 =?utf-8?B?MkgwSGJVZFNoU2lYWFhuUzFFeXg2bVZYanRiRkRyRmFqVmVLdHlnVVNTcWRt?=
 =?utf-8?B?SkxDK1VUbFRyR1RYMVdTckhxWHZoT0t2ZXpRSXcvM0NkSnA2SkFWZk1JZ21i?=
 =?utf-8?B?NFM0YzRlNVBEdnEvekZ4ZUs2UzdTOStTQ2F2U0JYYS9hRXBFblJncDZXcEVx?=
 =?utf-8?B?M0tGV0dlZ3FoRHJBY1lScDJrR1JTdGZVT2dGQ3Z4VzlnK0M3Q1Z6MDZIR2pH?=
 =?utf-8?B?NTRFZHdSQi9NbnErdFRtMU43WHpYc2ZpQ0ZZRlUvSDdUeVRER214OHp6bUdk?=
 =?utf-8?B?RldMWkFKVnBsTGZQZis5NGFNQ0kyd0cwVEYrMGJ0Sno3M0o2T3hmc2RNNXhN?=
 =?utf-8?B?aG40dkpPcEMxaERCUDV4SUNmNVhXemNwYVBMVGdHTFdReHVDSm1LRktjc3g4?=
 =?utf-8?B?QzkzSkZNRWs1Ry9ZR2JLREhjZCszWEFySEdmNzRteVFPTk9hNXVnNDFhN0Ju?=
 =?utf-8?B?d2p2SDNHcFhVNG5RQ0l1cUZKZ1FBQ0xLWGgrcEFkWCtONXlKbnVIN3ZLSnNZ?=
 =?utf-8?B?WkZRZVRaNzNNUjdjR0pzQVRkdXA1dVAxVVBSMVJ5RFo4d2d1V2l0NzZaNG1V?=
 =?utf-8?B?RDh1R1NvUzVaM1paaVlHMEVmTnN6cHlNditaVUlJNjQvMTc1M3dVS1hrS1hM?=
 =?utf-8?B?U1doandabE9HZnNURUFNK28rb2tWWDdTMnRYdTBhV0d1aFdCV2JTdkVxanVX?=
 =?utf-8?B?bE9uQ3kxbUdySlpPcDB3K1lxRnAzODlTTk1IcTZRRTZEMk5yZnRSeHlqbjds?=
 =?utf-8?B?SkhJdTdVM0Y4T0RkNWhKZWxJWFJjS1JLYlFnMS9leVl1NDNWT056OCtvTmVB?=
 =?utf-8?B?RW5xUlVWdjRmWHlSRklHN0p0NGJ0QktZaGFBVE5jcHIwNXFJY05XajFkZDBP?=
 =?utf-8?B?QjA0Tm8vMDFHT0Q5U2Q5c0ptQmQzMVZqbCtmNW9tMGVKNXNDWVFaWmN1UU9m?=
 =?utf-8?B?NldxRnlEMDhNcGtacnF6ZTcwY1BZOFNlRHJ0MFl5dDc4Yk4xK20vWmRxVDk3?=
 =?utf-8?B?YWxkNEl0YXEvRVlzbXZnckFzVHlnWDU0OTRUZjdOakFWY1gxdHFXZlNVc3pJ?=
 =?utf-8?B?Rk85eHJKSUU3L0QwRjM4UmJORVVnU3dmL01ydFJwRE1KWWtTSGZ3YnRqbDlD?=
 =?utf-8?B?UHhOaDVBQjE2d1NMdHVOSGk1UWF3T3NpSUF0LzNtRUtDajBMZmlPL2gvOXV5?=
 =?utf-8?B?dmNQNDIwQzl6WnNCTzBSbThBZ3dPVTVRMXB1cnhrYWxCRzNLOHdCNmdFZGhy?=
 =?utf-8?B?YXFkQmhOMUc4LzZnbERGOVpLdUhXd2xlc3dBUWpzeHB6aFIxT01pd3p0ZDAv?=
 =?utf-8?B?Y2lSMlY5dkpyNHV5VitwaFVHaXdJdEdIOVRwS2EveFpTaTNSVjJ2aUdublRx?=
 =?utf-8?B?WDZGeExaa1I2V0JHbk9ibnNYU0J4QmRkN1lacEV6SG5mMFBqdS9LZEFVSlls?=
 =?utf-8?B?TDZGelMwYXZJNzN2OStJWTdDSHl3Nml6T1RISmMvTUpKZ3dnT29BTnZobmxF?=
 =?utf-8?B?UHdsVWZ2bHF2d3RYbkRwQmVaWFdsNXlkNlBFYnlLa2pNRVROeWVGRDRJU1F6?=
 =?utf-8?B?VWhmSzNsaVU4aVVxano4dDFnb1V2MjNHMFBJcFBtVlp0TmorUUhsUE1zTkVC?=
 =?utf-8?B?bmd1VE1UemFDMGRPMC9jYkQ3Z2htcFBJKytPeXgzV1JqMXpFQjFTQXg1UmJD?=
 =?utf-8?Q?Yy4f6KyD25FwvNKddLJFq0Sls?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adfc78eb-a3fa-44eb-3ce6-08db7196f6be
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 14:02:20.5405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynCed4Q9Kd1CTR95bMM7LZQN9G+KP8sNCnXO+6E5ZFmEkUNQEi4EzQeU5FGpf6np
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6670
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/20/2023 3:43 AM, Shyam Prasad N wrote:
> On Mon, Jun 19, 2023 at 11:11 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 6/19/2023 1:27 PM, Bharath SM wrote:
>>> Please find the attached patch with suggested changes.
>>
>> LGTM, feel free to add my previous R-B.
>>
>> Tom.
>>
>>> On Mon, Jun 19, 2023 at 5:40 PM Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>> On 6/19/2023 12:54 AM, Steve French wrote:
>>>>> tentatively merged into cifs-2.6.git for-next pending more testing
>>>>>
>>>>> On Sun, Jun 18, 2023 at 10:57 PM Bharath SM <bharathsm.hsk@gmail.com> wrote:
>>>>>>
>>>>>> In case if all existing file handles are deferred handles and if all of
>>>>>> them gets closed due to handle lease break then we dont need to send
>>>>>> lease break acknowledgment to server, because last handle close will be
>>>>>> considered as lease break ack.
>>>>>> After closing deferred handels, we check for openfile list of inode,
>>>>>> if its empty then we skip sending lease break ack.
>>>>>>
>>>>>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
>>>>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>>>>>> ---
>>>>>>     fs/smb/client/file.c | 7 +++++--
>>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>>>>>> index 051283386e22..b8a3d60e7ac4 100644
>>>>>> --- a/fs/smb/client/file.c
>>>>>> +++ b/fs/smb/client/file.c
>>>>>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
>>>>>>             * not bother sending an oplock release if session to server still is
>>>>>>             * disconnected since oplock already released by the server
>>>>>>             */
>>>>
>>>> The comment just above is a woefully incorrect SMB1 artifact, and
>>>> it's even worse now.
>>>>
>>>> Here's what it currently says:
>>>>
>>>>>         /*
>>>>>          * releasing stale oplock after recent reconnect of smb session using
>>>>>          * a now incorrect file handle is not a data integrity issue but do
>>>>>          * not bother sending an oplock release if session to server still is
>>>>>          * disconnected since oplock already released by the server
>>>>>          */
>>>>
>>>> One option is deleting it entirely, but I suggest:
>>>>
>>>> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
>>>>     an acknowledgement to be sent when the file has already been closed."
>>>>
>>>>>> -       if (!oplock_break_cancelled) {
>>>>>> +       spin_lock(&cinode->open_file_lock);
>>>>>> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
>>>>>> +               spin_unlock(&cinode->open_file_lock);
>>>>>>                    /* check for server null since can race with kill_sb calling tree disconnect */
>>>>>>                    if (tcon->ses && tcon->ses->server) {
>>>>>>                            rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
>>>>>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
>>>>>>                            cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
>>>>>>                    } else
>>>>>>                            pr_warn_once("lease break not sent for unmounted share\n");
>>>>
>>>> Also, I think this warning is entirely pointless, in addition to
>>>> being similarly incorrect post-SMB1. Delete it. You will be able
>>>> to refactor the if/else branches more clearly in this case too.
>>>>
>>>> With those changes considered,
>>>> Reviewed-by: Tom Talpey <tom@talpey.com>
>>>>
> 
> Hi Tom,
> 
> I'm leaning towards having the warning statement here. Although with
> more useful details about the inode/lease etc.
> If this condition is reached, it means that the cifs_inode still has
> at least one handle open.
> If that is the case, can the tcon/ses/server ever be NULL?

I don't agree, my reading is that this is a race condition with
an unmount, and the tree connect and/or session is being torn
down. So I don't see the point in whining to the syslog.

Besides, there's nothing the client can do to recover, or prevent
the situation. Why alarm the admin? What "useful" details would
impact this?

Tom.

> 
> Regards,
> Shyam
> 
>>>> Tom.
>>>>
>>>>>> -       }
>>>>>> +       } else
>>>>>> +               spin_unlock(&cinode->open_file_lock);
>>>>>>
>>>>>>            cifs_done_oplock_break(cinode);
>>>>>>     }
>>>>>> --
>>>>>> 2.34.1
>>>>>>
>>>>>
>>>>>
> 
> 
> 
