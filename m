Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE731EB64D7
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Jun 2023 16:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjFUQIe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Jun 2023 12:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjFUQI2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Jun 2023 12:08:28 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2083.outbound.protection.outlook.com [40.107.100.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E06C19AF
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jun 2023 09:08:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQNZCWzdoJTvWTDuk8YKA1uI8GleJcL50WE57NS07Kx5XfOKKwInZ3Vn3rdi6haiGFLZZcUTr+n1o+IpegnMsVRiqt8zTydSHU1YdNUwyKtxShXucMBqdovXYGozHQHp0VrD9JCE8MzPdECYRbGH1oxsUNrq+MSwu3n0zmYzstkUyjGNWZ91/DiMWDak4ExgPv3l940zLg9VXXzt9/TH0F0/kuurGy2Hgo4ybI52Gpp9aMC+KfTrQuz3lSVrVR1RNukI2tFcYgz865zz0lOttr0tc+ofBtlo/E8BJG8QwlTM/dsUjN9dKiFkXr9VcJxozvuUpyaSRoebfTIKCASU3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvC/XI7z4y/DTyJkuk/ePXaT75zSj7UeXDCIXXUZ3Uo=;
 b=nd5huuGrf93s18PSjhHSEjQO00jlWvvzK1gDVnV5Uh3mWgIzVLg11jQ8L9wTRyDIWs1NvJtg+e/jOArjjncripNQ5BXAw73/YLOxQM1oeVr1lAT6KPVkt0rH2n9d6nQYgHoly8aHEe8NsNu7I4qZ3GFrmOj47ax6QTeqN6lKht+rdriicaIXz9lRYZw1DA/xZ3/rZ7mdSLaKWjWiiqBd2jAy46tfoo+ZfJ9YsbE8E3wcrqxohrMCNqjKUnGgMKG2KmC6xJt3PhjoF/5Vp6CDQKRAJqFgrN5JNzlCqUpkLEodX8R9QtY0yyphLnyygLJ7rMezXWPvMxSDaTtNP4BtCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB7443.prod.exchangelabs.com (2603:10b6:510:da::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.21; Wed, 21 Jun 2023 16:08:12 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 16:08:11 +0000
Message-ID: <a9eb31cd-fd3e-a399-5325-88bc6d3c85bd@talpey.com>
Date:   Wed, 21 Jun 2023 12:08:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] SMB3: Do not send lease break acknowledgment if all file
 handles have been closed
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>, sfrench@samba.org,
        pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
        linux-cifs@vger.kernel.org, bharathsm@microsoft.com
References: <20230619033436.808928-1-bharathsm@microsoft.com>
 <CAH2r5msQ_FXVuhhp6FzeVr3rVR5pw=_dQ2da=k+jtqqpouKWZg@mail.gmail.com>
 <5a83a490-dc32-901c-5ea5-85458f815e0d@talpey.com>
 <CAGypqWyyL-1OU2XZyOPtKdvTi_M+hRdJXO+Y5VizvoE+0pwN7g@mail.gmail.com>
 <793436e4-01ce-a552-03b9-7b45b0a9e020@talpey.com>
 <CANT5p=p8Cx1AgHZVWDjVLrndXQ=aRymLbQiuERFVZFg=w-LgSA@mail.gmail.com>
 <26be4fc6-ec99-891c-e9e8-1f770847bf2a@talpey.com>
 <CAH2r5mt=w2uo5Z1Sb0pz4S573nJDQxjrKO23AOpXk5q88BLA-Q@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mt=w2uo5Z1Sb0pz4S573nJDQxjrKO23AOpXk5q88BLA-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB7443:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a4100a7-4de1-412e-47db-08db7271b62a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EsfrPbhkSl3gfz8g2DmTvPtnCZf6QhDQa6xH9IR+Kt8JL6PUM5gGqD6jRo/O24Zl6Ma/jlGRYDxqqWZXnKc60bYAhyM37zxIf53NTUmAHJu4mqDWSV3DT5kPjeaSk+I2pAxGh2qghjmgC1uXcgKTlVUaNhX5V7jUafU34FfJuI7EYlJWsZv4SMoGabD8rulbB6q+PzG4UP8Po2J32fOWBu3+Hb0orllvO6a60NQ+2P6A9dYN0zVXhu5UXndLIm1CfRiNsZzxAo9Ot8+M7PI3ZcAfMLDNM3jaxMrAf1mSY0tJmFQH5ASiLX6wa0SLzI5J3cNiIvBI1ftsTw/5aBBc8jmUm292R0Yd1RI5zdWDDb7yh8WIGmMs1A9jER0X2ptMWRcV9+CEGVTbNe0wtI+du1BMhkAfH7y4dsau6rO/PYsH/u9RazNEF+Kmfmi0maFExge2S/VDNwF09Gzis5ZfFk3UZNesrT89MxCG+8lVbvuT98Bd3lkTpUhqyCGt26hyXXwUahIYoVtFpS6ACsl37/qqi70+wW3P81VLw7DUKl0kNPOOQld0KAn8SREMsrgUv+YN38Fu/JflMogWpYdWuF9iMzx52DtsKYaVRSVd3OLLYt+sV2XaZ2T7oD1Qx8Yteo3fdc0v9SXKxHVJto5lGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39830400003)(366004)(346002)(136003)(396003)(451199021)(66476007)(6916009)(66946007)(4326008)(66556008)(316002)(41300700001)(2906002)(54906003)(8676002)(31686004)(8936002)(5660300002)(478600001)(45080400002)(52116002)(6486002)(186003)(53546011)(2616005)(6512007)(26005)(83380400001)(6506007)(38100700002)(86362001)(31696002)(38350700002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUp5UzRPamZuTnBkckVQbno0NDRYc3Fmd0Y0Rk50RjZjN2Y0Um9oYUZqN3Zm?=
 =?utf-8?B?QjMrK1VXb0RTNTd6Y0FxeHBHTnVMT3I4Tkorc2FFNDFobkJBTEl2V3hOWTl5?=
 =?utf-8?B?SkJxTEJMaG1GUnhTOWlLbTk5QmJmYjdZU2lTUW1IYk80SmIxRmtnVEI5Yi9D?=
 =?utf-8?B?YjJKaHM5ZHk2U0h2bTRzQnNXdUFLSFJBaTcxekVOQjBoRkVoMUhyVGEvcDYw?=
 =?utf-8?B?aENwUlNPd3BTc05iWmdqTjZNWmRKY1J6dlYzbnZPV0JzczFQUlYyRTdUVWxH?=
 =?utf-8?B?YlRyQ1RlMjVwQS9qS3NoSlZGTVBBTmlhM2RDWUxYdUhOeHBNN0dSZkJ4cVdS?=
 =?utf-8?B?b0Y5Rng2TWRNN1pxUVZMYkEyZmdjSkxiaG1Ja3NMekpxdlVjbVdvVWxyTW1M?=
 =?utf-8?B?b2h6RkVWUVU2cjF6R3M3eDF2RVprZ1BFNDZvK003Q2JmbklrSkhNeGcwTmh6?=
 =?utf-8?B?WlJBMkNRRFF3c055cEVad0FlWmNvMG9PZmQrZ2ZDS092YlVGWm95U1FLN1FX?=
 =?utf-8?B?ZGxZUlJpd0g4d0c4ZkpxNHRPLzBTUXVxeDBJYzVoYnpqVmhXdEFKZ3R0L2Q2?=
 =?utf-8?B?TWd6b2crYWxHYWg5SEJIdnNBdDNyV1hJMDFwRzdJM3VwTUxjY09nWjY3V3NW?=
 =?utf-8?B?QmF6dkhVUStjM2IxTFhqWkhKUzhPWlhUTDM3T2JRU1ZNM2tramhrekc0d3dW?=
 =?utf-8?B?UGNReGJnV0RaRzZKRTRGVlBWaS94SmhOalFMemR0VzkxU1h6ckM0aUNybWdJ?=
 =?utf-8?B?blpYdmhJbXFZQUZMcDd3QVV2SjY5ZnpqQ1N6Q0VnOURIMjJ0ZWd2bzFqeGhW?=
 =?utf-8?B?NmtENVQ1b0RnZUdTVXU5QVoyOHl1Z0lNT3dxYUJOSUM2enExK3B2Uk1PR2Nn?=
 =?utf-8?B?NklLeUY0Nk5xbDE0Y2FXbWpIMjhnMkF1NmFoRnV4WExrQjZFNnRJY2lPM3M4?=
 =?utf-8?B?YW1lS3ZBNjY2alVlTWgvUHZNbW5kSG1BeURQbVRTcm0zL1ZtWmtPaUFaZlE3?=
 =?utf-8?B?dG03azJPYkc1M21rMHprVGZSdzVteXVyanR4cVB0WmY4UWJuc1JSdnhlMDgr?=
 =?utf-8?B?N3dWc09vR24rTk56M29lRFZPeGRCdEhPdDdKbk1hYXhjL1pUanV1d3pKclF4?=
 =?utf-8?B?b2FWR2dhSWNLWHpVVllqNG1tYnlDcjBJRzRnMi9ISC9IcFNlTTR5R0Z2aHhK?=
 =?utf-8?B?RXZEaUdRNklVWE5Gc0xMZHJML3E3ckZySWJCTzNwMGI2SWNzQ0hERDlZSnZo?=
 =?utf-8?B?dk5YQjlKVnk4MEd3ejl2OVF4UDBPWHBFRWp6dVMwYldRRUdRa1piY3EyRlNw?=
 =?utf-8?B?cHJXK1VCR21xdk1uNUhLaG5IRUNGYUFveExYa0k3K09kNi9Dd29DLzkzSmtv?=
 =?utf-8?B?MGlJOFREbENyL2YrK1N0VnppdEorTWI1TXM3TE9DYjI0ZGVXT3ZUWUJ5YTFS?=
 =?utf-8?B?Y1JHK0dGb2l5WHNzR0xsNmtEQzZzZHRUb1ZoUStGclBXZlJBdU55Rm5aZUlW?=
 =?utf-8?B?MnpUVzBLaEh2MkhxbVFFcTEyanU4T0FsUFhkQUp6eXc5L0FHQ3VMcnArdHhE?=
 =?utf-8?B?a3dKL0pLT0R1NWJkTkNvQkJRajZLZWpFYVExazBQZkxpTUtIdXEycVdVaG5s?=
 =?utf-8?B?MS9wRmcwTGVQWndiZmYxbVE3Y2VnMVlmWDQrRGo2SnB6bDJ5VVRyMmVQNitN?=
 =?utf-8?B?ZjVsT1pqRzN6c1A2NXU3WkdFM2lvRVVUdzg0NTA2NC94RlNoaERzREg1bWxX?=
 =?utf-8?B?QUpYZWlyY0pjbGx2aEhIbUVUWWJ4V0VnRi9McmFDVmlUUUdoUW5YYWRZbncw?=
 =?utf-8?B?L3FKZDB6M1lZcEZ3eGdFckZWLzNwMzF3TDRvUU9DZVBuWEpWUmJQMi9DZjYr?=
 =?utf-8?B?UGRleUpiYTFya05tR1h1a1djVURlalUrejF0REs2RVd4bEN5bUJqSklBZEVx?=
 =?utf-8?B?ZEpZUCtIZnJna2NwVHVEdm1UVDVRZHNTNEdIRGhSb0JzSW9sdWo0S1FZNVJH?=
 =?utf-8?B?ZVZEd3NWR3QzZGRGRGVYUFF6a0s2MWZIbEJBWjhpdDlmcHBwcUNlWHJiZEJ3?=
 =?utf-8?B?WGVjYWQxOGw1eWtWZzF2QWw0VDJlNU5ubWRpT2pwR0RUTE1FU1JlYUNrQldH?=
 =?utf-8?Q?f/18Hn7TrJW6t15OzvyxF+oq5?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4100a7-4de1-412e-47db-08db7271b62a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 16:08:11.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q28phoL25++Sa/PcsPs+5+45EYUNdbIgbcpdJsGUabSVjLo+t3O0SW0i9vIHQXo6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7443
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/20/2023 11:34 PM, Steve French wrote:
> We could make the unlikely error condition (lease break race with
> umount) log as cifsFYI so no one would see it by default?

You guys obviously want the noise to stay. So, yes I'd agree that
a cifsFYI is better than a pr_warn_once. The FYI is silenced by
default, and it will appear every time if wanted.

Tom.

> On Tue, Jun 20, 2023 at 9:02 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 6/20/2023 3:43 AM, Shyam Prasad N wrote:
>>> On Mon, Jun 19, 2023 at 11:11 PM Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>> On 6/19/2023 1:27 PM, Bharath SM wrote:
>>>>> Please find the attached patch with suggested changes.
>>>>
>>>> LGTM, feel free to add my previous R-B.
>>>>
>>>> Tom.
>>>>
>>>>> On Mon, Jun 19, 2023 at 5:40 PM Tom Talpey <tom@talpey.com> wrote:
>>>>>>
>>>>>> On 6/19/2023 12:54 AM, Steve French wrote:
>>>>>>> tentatively merged into cifs-2.6.git for-next pending more testing
>>>>>>>
>>>>>>> On Sun, Jun 18, 2023 at 10:57 PM Bharath SM <bharathsm.hsk@gmail.com> wrote:
>>>>>>>>
>>>>>>>> In case if all existing file handles are deferred handles and if all of
>>>>>>>> them gets closed due to handle lease break then we dont need to send
>>>>>>>> lease break acknowledgment to server, because last handle close will be
>>>>>>>> considered as lease break ack.
>>>>>>>> After closing deferred handels, we check for openfile list of inode,
>>>>>>>> if its empty then we skip sending lease break ack.
>>>>>>>>
>>>>>>>> Fixes: 59a556aebc43 ("SMB3: drop reference to cfile before sending oplock break")
>>>>>>>> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
>>>>>>>> ---
>>>>>>>>      fs/smb/client/file.c | 7 +++++--
>>>>>>>>      1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>>>>>>>> index 051283386e22..b8a3d60e7ac4 100644
>>>>>>>> --- a/fs/smb/client/file.c
>>>>>>>> +++ b/fs/smb/client/file.c
>>>>>>>> @@ -4941,7 +4941,9 @@ void cifs_oplock_break(struct work_struct *work)
>>>>>>>>              * not bother sending an oplock release if session to server still is
>>>>>>>>              * disconnected since oplock already released by the server
>>>>>>>>              */
>>>>>>
>>>>>> The comment just above is a woefully incorrect SMB1 artifact, and
>>>>>> it's even worse now.
>>>>>>
>>>>>> Here's what it currently says:
>>>>>>
>>>>>>>          /*
>>>>>>>           * releasing stale oplock after recent reconnect of smb session using
>>>>>>>           * a now incorrect file handle is not a data integrity issue but do
>>>>>>>           * not bother sending an oplock release if session to server still is
>>>>>>>           * disconnected since oplock already released by the server
>>>>>>>           */
>>>>>>
>>>>>> One option is deleting it entirely, but I suggest:
>>>>>>
>>>>>> "MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
>>>>>>      an acknowledgement to be sent when the file has already been closed."
>>>>>>
>>>>>>>> -       if (!oplock_break_cancelled) {
>>>>>>>> +       spin_lock(&cinode->open_file_lock);
>>>>>>>> +       if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
>>>>>>>> +               spin_unlock(&cinode->open_file_lock);
>>>>>>>>                     /* check for server null since can race with kill_sb calling tree disconnect */
>>>>>>>>                     if (tcon->ses && tcon->ses->server) {
>>>>>>>>                             rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
>>>>>>>> @@ -4949,7 +4951,8 @@ void cifs_oplock_break(struct work_struct *work)
>>>>>>>>                             cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
>>>>>>>>                     } else
>>>>>>>>                             pr_warn_once("lease break not sent for unmounted share\n");
>>>>>>
>>>>>> Also, I think this warning is entirely pointless, in addition to
>>>>>> being similarly incorrect post-SMB1. Delete it. You will be able
>>>>>> to refactor the if/else branches more clearly in this case too.
>>>>>>
>>>>>> With those changes considered,
>>>>>> Reviewed-by: Tom Talpey <tom@talpey.com>
>>>>>>
>>>
>>> Hi Tom,
>>>
>>> I'm leaning towards having the warning statement here. Although with
>>> more useful details about the inode/lease etc.
>>> If this condition is reached, it means that the cifs_inode still has
>>> at least one handle open.
>>> If that is the case, can the tcon/ses/server ever be NULL?
>>
>> I don't agree, my reading is that this is a race condition with
>> an unmount, and the tree connect and/or session is being torn
>> down. So I don't see the point in whining to the syslog.
>>
>> Besides, there's nothing the client can do to recover, or prevent
>> the situation. Why alarm the admin? What "useful" details would
>> impact this?
>>
>> Tom.
>>
>>>
>>> Regards,
>>> Shyam
>>>
>>>>>> Tom.
>>>>>>
>>>>>>>> -       }
>>>>>>>> +       } else
>>>>>>>> +               spin_unlock(&cinode->open_file_lock);
>>>>>>>>
>>>>>>>>             cifs_done_oplock_break(cinode);
>>>>>>>>      }
>>>>>>>> --
>>>>>>>> 2.34.1
>>>>>>>>
>>>>>>>
>>>>>>>
>>>
>>>
>>>
> 
> 
> 
