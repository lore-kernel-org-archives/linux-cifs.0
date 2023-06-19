Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156DBEB64DA
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Jun 2023 17:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjFSRli (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Jun 2023 13:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjFSRlg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Jun 2023 13:41:36 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 357D61B6
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jun 2023 10:41:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cld1atYWE9BwtRXwOmU+L2RTa42S3NkM5aU9FNUm6WROwHQ46aQNcS1uLwPTjCtF4rl7PfgF98qUGDVe+hmLUwCRcecVJrLm2ZprqA3WFB4VfGGM8U6xc4Ao1KignvoKG23YA86jFsm6/H4egtI5u4tHarilkOLwUZ9Q76ZdoNZ2/iRez1EzaQP+YFsjP51J5SXzjqPrlt3p58aj6YM9VFGm0CaD6SC9wDFHsSkcoW0sL3EoPzqW6iizhUL2RburuZF1YWaM8/1d0MhYY5DqdN9yyxS2uI+YfoYejlaMaekbvCH6LMlE0+6Zmur//ZYNV5q/MQbndbL4doHfDJX6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GxFhmDmxLRhC8hvSnIVdEuxGhQj+V8bjfLusUe1VtM=;
 b=f4Votku9dc4eDEvluDCLBLQoT4li3DbvjBN1pVRfGujlDO3EJ9trP3xRy0WADA/hK7tn8n1+Pf5nR5ex+9oZzNlTtImd3p9VlaAoCP7jvoLxAgnB5fz6C/lY2gl+LwRDDhEQDLEthczYrV8UlqLmxmdJWCaPzfggdgEdD647lb2WY4p/xZBvXPFiz2y4ElTpihH5FzZP3t5Vdkwp23FqtqldQQayWroUOP+v9Q99n73HhWyoA2BM7ctGrPIigbW5prmWpnSNWUFPHDJjHR+7wCdqpzf1QzlVVgC46eZxUmrgVi1EVddnUO6SDAbGHtf9WuL8mifiPDHQ1Ko+iTcizg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6634.prod.exchangelabs.com (2603:10b6:510:7a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37; Mon, 19 Jun 2023 17:41:30 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6500.031; Mon, 19 Jun 2023
 17:41:30 +0000
Message-ID: <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com>
Date:   Mon, 19 Jun 2023 13:41:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
Content-Language: en-US
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     Steve French <smfrench@gmail.com>, sfrench@samba.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com,
        nspmangalore@gmail.com
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
 <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com>
 <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:208:23c::9) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a5bef89-cbc2-498f-6c83-08db70ec6a1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OFl9Ju8R2/nJ8VkT78CJTNwX2/nylT5D/Cxj3kMcjo9Pa3NJ8sQLLGwkPVr6tUOMnU6zaTdPpLrzxeM8CNbEq8zdD3Cgk/pO4ndNuTZdCtkQT2wrFb85pC/P8Z+hOuWR/aDzEm9J6XaFOXok/woqY8KsG6w/InuGwMgCQ11HPi+6b9L5N5kN4kgix5za1a8fI1rMfrkY99OPuMKhWEVvtwHQ3kOCy0A0AbOPkKVKLT0hwRS//AFy3cRnETUXJAJP8NSpgcFGIgdun3iZdULRwcPDhjbbr7pEkpJBlIIWMo5krEL4azq0uDZBGIF1aAh2ExBnMN9OsIhBVIUgPfmqTa+z0TVkyglUcUcE1HjIDFYNNYYV2bXu8ckvnLGvrqxbX07o2imfDWZPjOIRmX2hzS9Gi+q34c0Xghauo30GJa0ObkawnU2ggRRAO4tjPfUCP79zeh3XlSm061JiFtcKHxiUdocsB1NLWi0MXsV0BmQOb/Sj1JwThRWTwyhJu0D82FvVps5COi1TgvFYcxGnA5AJKoDg6ZZW1TYvEKMLr4QDwNhX0D0iLZTboWX0qjNgGd/Vm5Wa9mPbyzcdDZpHhqltOohEzg3wn66opqNk0pf91FcmHpvf454VzrRH6euFW7o/9omKOi8qVOHidpG5og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(346002)(396003)(39830400003)(451199021)(31696002)(478600001)(2906002)(52116002)(6486002)(2616005)(86362001)(36756003)(26005)(186003)(6506007)(6512007)(45080400002)(8936002)(8676002)(66476007)(66556008)(66946007)(53546011)(5660300002)(38100700002)(38350700002)(316002)(4326008)(6916009)(83380400001)(31686004)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1dMdjZRQ1cvWElBamhsTnFGZSt6b1dpMWs5eE05QzBxUUdRUXROZXJ0NTJx?=
 =?utf-8?B?K1pZTUUxQ1h0K3B1N0czNk1pNndtWmNzajdzSnFHU3phRDd6R2VWVk9iU1VR?=
 =?utf-8?B?dHZRMkRyRE5xc2dwc0wwYUlHZXcvRm5zMFZDWlpUSmNLU3piWG82Rm0rdVpM?=
 =?utf-8?B?UUpQQ3JEMVdmbDM2SktXcWhNVGc3QTlnL045QVplaGgxMVVyL1BZZ015TUZ2?=
 =?utf-8?B?QkplcG5NM09XblpYSHBTWW5Sd0h5MlpUNkRGdURYeTlXcUx5cXZqMGxCY2o5?=
 =?utf-8?B?bGNDOFRpdTkzcEtvN0dJNXIvWDNzMmVKNGJPclF1MUxIZnR3ZmZQOVNSY2gv?=
 =?utf-8?B?ZkZGUmkwalFSZmFlalVuT0czeEk3YXJTeHhmK0V6YzZ4amFUY3QxOUticjlr?=
 =?utf-8?B?WlhEWXpmdUFkeTEwWWdoN3dLOEJEeGZDdzNKbzJ5SWFlQVArNE9qdXdjcWc4?=
 =?utf-8?B?U3MydXd2YnJkTFNlcWl0ZFM2cFlHVzVldjlrcnVIRVo1SzEvbVh2V0FQTTIw?=
 =?utf-8?B?RURFVldvMGIvd3BIR2E2V1FvbDZJeFhPNDBEeTdYdUFzWWtOZW1LcUY3UFRK?=
 =?utf-8?B?dnIwQmNRWUJDREZPVWpYQUlZYnpYY3YrQTNIeThDVXd2RFAwZTVtYUNqT0du?=
 =?utf-8?B?M0RERndtRkRjd2dTNjd6dThvK2NoU2VYUi91SlNHUW5XS1BwWEplWVQ0SFln?=
 =?utf-8?B?L0xLN1lvdHgxd2Fxa0s0K2U1RGxGdzl4cWJ2Vm8yd3A5eE5TeEhtbCtXRWV4?=
 =?utf-8?B?aUJmRzhOS1BjMDdjMkJVTTJQVlFwY0YwSDd1Y3hIcURNZmlycEkrblRHL2ZU?=
 =?utf-8?B?amh1S1VPYm1CbHBuMytiNis3cGtVVDBzckUxcHFkbkVZL2pWUmdhbGtzRGFF?=
 =?utf-8?B?Qy9IQ2MwVXRVanRYc0JVWTVXS3N1cjgrbnYwcVlFRkI5Z01YdEZOY0NtMktt?=
 =?utf-8?B?WE5NY1R2ajhWSitleWNKb0kzS2VnUjFnNURqSjNrajBKQWRReWhvSTBNSko0?=
 =?utf-8?B?NHZtNXVNSCtjZE1WWW44alg5UzBhVmZ1dHBwQ1JCVGZEQ3pQUFpOd1IvaUhV?=
 =?utf-8?B?ZkZtZ1FxQnFuNG1QazRPN0RlaTlPejBCdVQ3ektzWlQ5aTBvcGNFd3RBZUhO?=
 =?utf-8?B?YmNHWG92d3dlZG0rRHJVQ0FkaFpQdk9Ybyt0Y0pUcUVHZC9nTjJQSzhIK0Jn?=
 =?utf-8?B?K0twNFNWNHRsM1FJKzR6MUJzYVFWQzZXTlpNb3Q4QS9OQS9PL3VWN1RZZ2FJ?=
 =?utf-8?B?TlBFT1ZKdmR4djc4MEdLbFc3OXNVV3laQnpYSkVkWEdyOU5wYTJFM25PMjlY?=
 =?utf-8?B?aURTdk9HZzFhNEVnZDg1ZXlDN1VPMmxZNERNWnlGNWtOVFRVc3MrUXVFY2Ja?=
 =?utf-8?B?SzBVTjdKS0NHU1MyWm0zUTBvQU92ZUY0RXlXLzFuTzBvTHNEZFhQUjlyQ1h0?=
 =?utf-8?B?WXN1aFMrRG4vckVJQndlTGNldG9Qb3d0QVE1NWhnMWhnaFc0a1Z1SEpJREFk?=
 =?utf-8?B?ZmluODB5V0FDM25HSCtpdzU5OUlWSERjajNGcXU5R3Z6L3hxVWNUYXVxcVdh?=
 =?utf-8?B?Umdzb3Mrc3lvN25PU2hUMDJjQWZ1QlRlWGZrRThNeVdRVEJnQ2hYdGo2N1Vk?=
 =?utf-8?B?YitublVML2lCUmVXQi9wWjNMOHZ3RE95Mk1qbUw2ZVNSeUNWQXF3NFZHMG5U?=
 =?utf-8?B?ODlyREl6dGpoYlNicnVjTkJVbDRHa2hPZnRwNTluSk9QR05mMmZ2aXc0dlBH?=
 =?utf-8?B?ZDlWZ1ZmSTQxdHZOUllma0hlWXJpMnIzeFFiSEpRK1BqN0dnRnlsRGhmaTli?=
 =?utf-8?B?Sjh4SnE1MUNrY2JkeWtjNjdEeGNma2g3MUorNWQ1Z2VhekJpUGZVemwvcVJ2?=
 =?utf-8?B?VjJmT2h6RGhWb2dYYXdQVHU5QkNySHdYb2NOd1pVOWh2V3Jid1R2VXlwL1M2?=
 =?utf-8?B?aUt0QUowaEc4VjBpM2FTWnNXd0l3YjFBWHNtSllqVVdFNFJkQU5UUHNFNFdD?=
 =?utf-8?B?VWNvZzdNZ0hwcFNWWTlnbHA2TXg0RnFnVzBVSnh1TFBNZ2dQNkEyYnE3eTRk?=
 =?utf-8?B?aTBzcEFTSkpRTzZDc3BJcmt6SG4xSTUvbS9lYXAybG5HbTI5NVAwQk5VWUM0?=
 =?utf-8?Q?sLEFHZFGHHoOm2QEUmGM7AHoF?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a5bef89-cbc2-498f-6c83-08db70ec6a1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 17:41:30.0633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YTwFVsdXuX2GAUoqKr4zVcfvVcbyoJ5+ZYd9O0cI/lpilX/c0rLG+GKQ/un7+OF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6634
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/19/2023 1:27 PM, Bharath SM wrote:
> Please find the attached patch with suggested changes.

LGTM, feel free to add my previous R-B.

Tom.

> On Mon, Jun 19, 2023 at 5:40 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 6/19/2023 12:54 AM, Steve French wrote:
>>> tentatively merged into cifs-2.6.git for-next pending more testing
>>>
>>> On Sun, Jun 18, 2023 at 10:57 PM Bharath SM <bharathsm.hsk@gmail.com> wrote:
>>>>
>>>> In case if all existing file handles are deferred handles and if all of
>>>> them gets closed due to handle lease break then we dont need to send
>>>> lease break acknowledgment to server, because last handle close will be
>>>> considered as lease break ack.
>>>> After closing deferred handels, we check for openfile list of inode,
>>>> if its empty then we skip sending lease break ack.
>>>>
>>>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
>>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>>>> ---
>>>>    fs/smb/client/file.c | 7 +++++--
>>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>>>> index 051283386e22..b8a3d60e7ac4 100644
>>>> --- a/fs/smb/client/file.c
>>>> +++ b/fs/smb/client/file.c
>>>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
>>>>            * not bother sending an oplock release if session to server still is
>>>>            * disconnected since oplock already released by the server
>>>>            */
>>
>> The comment just above is a woefully incorrect SMB1 artifact, and
>> it's even worse now.
>>
>> Here's what it currently says:
>>
>>>        /*
>>>         * releasing stale oplock after recent reconnect of smb session using
>>>         * a now incorrect file handle is not a data integrity issue but do
>>>         * not bother sending an oplock release if session to server still is
>>>         * disconnected since oplock already released by the server
>>>         */
>>
>> One option is deleting it entirely, but I suggest:
>>
>> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
>>    an acknowledgement to be sent when the file has already been closed."
>>
>>>> -       if (!oplock_break_cancelled) {
>>>> +       spin_lock(&cinode->open_file_lock);
>>>> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
>>>> +               spin_unlock(&cinode->open_file_lock);
>>>>                   /* check for server null since can race with kill_sb calling tree disconnect */
>>>>                   if (tcon->ses && tcon->ses->server) {
>>>>                           rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
>>>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
>>>>                           cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
>>>>                   } else
>>>>                           pr_warn_once("lease break not sent for unmounted share\n");
>>
>> Also, I think this warning is entirely pointless, in addition to
>> being similarly incorrect post-SMB1. Delete it. You will be able
>> to refactor the if/else branches more clearly in this case too.
>>
>> With those changes considered,
>> Reviewed-by: Tom Talpey <tom@talpey.com>
>>
>> Tom.
>>
>>>> -       }
>>>> +       } else
>>>> +               spin_unlock(&cinode->open_file_lock);
>>>>
>>>>           cifs_done_oplock_break(cinode);
>>>>    }
>>>> --
>>>> 2.34.1
>>>>
>>>
>>>
