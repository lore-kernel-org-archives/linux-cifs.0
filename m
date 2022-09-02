Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF11FC6FA82
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 13:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238365AbiIBNEm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238728AbiIBNDr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 09:03:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC59210F096
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 05:41:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTtBNhifNsLAoTAvaxerSk/Qh8ThzCfxu7e+QMd4in1VDEer0CGuekuGz5+GC4RGrtUvHt4wEht8+QBBswcBXU8ZPM5QwFMvcnjZGhmPjH//NvERqx9AOT9QaW90MWbGnI9R0+9ipQ1mAb6AFxaStjAxaAoNakVCNx5bEZK5KiKUUjw837H4g2SGIBYRMvW3HtgegEd8qpZfmRBEEUy7YnUqo8sWY4QLCS2oTFYtJWDpBIxPO3dT2RfegYt2o8O1eLHYAinYfZ8InFjnsTAOrHo1E9Jp7KJUaXkweiP8P24ibdRg6ZQGzLReBCjbOUj2Vujt6DR6m83cKPXuTV2rmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WbDXpUxz+ez8KXXmXCLrlwWgS9LNacDrmadQ0D0XgPw=;
 b=X5+CqVlGVFvCqgd00/g7x/iV0dBZFwo9P6tUUnPd+a2L389JRBz9WR3HPubF025hdypEvAtC3HhJ4M1NnqKCnJRPWhWN62N3h6IvQOlQ6Y03cA99v6TxY89pKP9hX/X4ZZqnvteABrQbq9etszeLys31G8i+GCEX7oTeZOURf0LrbK0cxGyPR5s4S7ZPaNfGZs63vNvrUBRvY7nAgWvzhR02aopNpR6+eqW6+3YaGHrQrzBFqlL7Sykxi2PPLJpciMV3Ej3i4lBV2LMdEvC7j7Wjk4jWpAgd7b5gpNBpaxiCV2b0cKWJItyxxSO1sB5xdcYHN8XI26axMQfcCrBRwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 CO6PR01MB7465.prod.exchangelabs.com (2603:10b6:303:140::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.12; Fri, 2 Sep 2022 12:35:26 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 12:35:26 +0000
Message-ID: <f681c94e-b402-6e44-c6d0-f853d773e341@talpey.com>
Date:   Fri, 2 Sep 2022 08:35:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <YxDaZxljVqC/4Riu@jeremy-acer>
 <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer>
 <CAN05THRgWMEejOMTozrf0F4sENxJEQYu2i-9CKWO+Qh0kvjveg@mail.gmail.com>
 <CAH2r5mvUzbp8RcM7+XFbJsoiba964vpKQiMRmGeQovGabe+j=Q@mail.gmail.com>
 <YxEot6I5d4PWtrz9@jeremy-acer>
 <CAKYAXd8SSQ+GpL=Na0OSFxOGSy-r7TW8Q+X-ZLaH-uLZQ1XauQ@mail.gmail.com>
 <YxFmTIpsYTcCHSwn@jeremy-acer>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <YxFmTIpsYTcCHSwn@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:208:160::47) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17811f8b-4228-41b4-637b-08da8cdf9c92
X-MS-TrafficTypeDiagnostic: CO6PR01MB7465:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xvtr1obhMTdxkjMhbbHkkNdrcyjxqi8zP4YgrXCbI5Zk1zsslPUgIlvYE73p+IHsBlsGHb8VbUc9HOrbuDH8PglcTT0vmEOy9ncgG8PjgU8opMDD/HUBRpQPu+MlO8dQMXzpZDvAwRAtdC9Lh0gAVR5D82e6ZE7Ipd5fV6cnLk9sT/LVmunxqL8iV6WdoRONNAU+Bd3AuD/nn959oHixw28aBnFO9ayNJag75ki0D5rxH8eax6vCl0Zl+EeuXaxRV8rXJdleiGupjeuuEgJ/7o8OTyOPMvATKYqaQC8tBjuyN/XQgxRhoxnvqgKVv0ZBMxmfG3ed8gQ74rfAsounn7s12Nb7aVuD5x9cZvLrX4N7SUj+6e5KClSoBK4bf2AhP7Nfvg2ODCVthG8wmSESSm6b5T2+LdPoMhh37I0/tx3DL12dBq3dAGhC2q/w/K5ginjIDqaZ4ea2LNMsXlYd+i6CIshObojtTF5QRf/YLZIpETo0cFeqsglRM3cVQ5kPR8j1/Tf8olaUO6Z9pl7i+L8xukStU+CmliZ5PgmT4I7LGVO+4haLY3j8nhT5anjXt3Pl5I6YLIzGMu943u/2bysvqV6xpNfQ/cs2RgipOTv2G3PNTvvN7wcQ+Ie142wZxhy6cW9xrw/+m1wADJYx7FrPivzGbllk7sMof7MCLbiE0JSr3cbkRIgbPER1hFKaZr9dv5xZvYQUwnjP8mwNDOFWVZYAATH66dRdtc034AHbcS3sqXUDn2RfGTnyLRgfyqSf3aXD5NnEDNSndFBVfIFQJsE800dfyfM6tvOWCfY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(39830400003)(376002)(366004)(396003)(52116002)(53546011)(6512007)(26005)(38100700002)(186003)(38350700002)(83380400001)(2616005)(15650500001)(31686004)(8936002)(5660300002)(4326008)(66476007)(66946007)(66556008)(2906002)(36756003)(31696002)(8676002)(478600001)(6506007)(6486002)(41300700001)(86362001)(54906003)(110136005)(6666004)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czBuS0M4YlY1ZGxmR0RXR0tkZmNzZElwZmNTYzVxd2c1YTN6dFB4c2V5UnVC?=
 =?utf-8?B?cWlkYkJzdlB5U0RsVGFMRlUxN2p4TlJpZS9XOGdaQkZsVlU3SFpJSXhWUzhM?=
 =?utf-8?B?YnJZZ1NqTForbC9uYUJRcXlvUnNYdm1pMG85YTZidWVXeG9uVkNvbWZOcXV2?=
 =?utf-8?B?UHNJbkFGTGhPQ0dWbTNDbWxNTkhHWmdtUitDdnZYTDdJODVrYkM5SmJLanpt?=
 =?utf-8?B?QjN0Wmx0anAzS0g2UGZFUitLT2lzLzlKNThEY0I1M1BkZXo1TFlYZy9BdDhN?=
 =?utf-8?B?YXBqcFBhZTlSWVhPbW54QlR2alkwaG1KQnFpVWR1YXgxY2FPTm5XSFkzYTZM?=
 =?utf-8?B?NmI3bHpyemdyR0NxV3lCTk5KTVdEL2E4Z2JsejdlS0ZjYittdzkvbWxreUtZ?=
 =?utf-8?B?UnR1NURBOU1SYU5NNElCbjJ3ODhtY1YxbmkvNWVoSjM0T0lYZ3VONXVjZVYx?=
 =?utf-8?B?Y2pzSGx0bm5LU21Zd3ZWSjB3L2FYK2VqM2M4Wi9WVTFxNERHZyt4Q2tPVG1u?=
 =?utf-8?B?dHFiNnluYTRWNWRtRmpMcXNJZlhuUjBma1NLMnFJcElxYnpKZlgxZlkrTFFw?=
 =?utf-8?B?SUhrZHN2d2krbEMrRzA0MXVkOXV0R0ROQWliQ0EvZjhoOWx1K3l0L3BHKzlB?=
 =?utf-8?B?WlI1aGsxTGVhK2lIZ0NFY01yc3lFUTJqYW0xcStyVEVweU9pbzFQVFNVNXd3?=
 =?utf-8?B?ZExZOHhPWUdxWXJ1aU0zZ3VRSmlSVFd0WWwwRzQyUWkyT3dBZlRVSHhxdG05?=
 =?utf-8?B?UkkwbGNGbG4xQi9EY280WmRZd1pwK3hUN1oyTURCZDBMaTdsL1djR1RHcWRl?=
 =?utf-8?B?cll2cklMK1p6aFlBTEdMNmc5d3BEd0M1OEpDQXVUbUlWWGtqNjNuU3VORmlj?=
 =?utf-8?B?SGRhcUh3NUc1dDhOWHBVRVZCYlY1WFZrRi9iVEt0T0RKdEpOQlNwb0ZEYkR1?=
 =?utf-8?B?SUUyTlhjV082QWRyNXBKeGpDVlRlZWNnWnAvZFMvY0ExUmJmRko3R1NDUjdx?=
 =?utf-8?B?MjNFQUxTWTdNeTE5RUF4QmVEV0RQOFBLUWkvTjRhOUpZUnVjdDRUMk1jQm50?=
 =?utf-8?B?UXQ4cEtnVThoR2o0QzhiZGl2WnlROE5ING5FcWN0RUlZS00xT0FGQXJFQkVl?=
 =?utf-8?B?UWpTb3BFZk14VDFISnNrdjRFRU9vUHphQWlMVncvVTRGNmFXUnM3Q0FFdHoy?=
 =?utf-8?B?MGRjNzVQSmVmMkIwa3g4ZTYyZ2VGMmtLT1pwNmVjblE4cUtEcE9Zb3FveWgx?=
 =?utf-8?B?MHlZaGt0YVdCT2VoM3hmNG8xdXpDay9xRWh1RXZ3emxnVUM4aCtwTjdLN3Ar?=
 =?utf-8?B?YURFa3FSTGIzVDBXWW1yQWRUSnpXbVlkTVR1dG9pVCtrNkVxS2lSQmhzOUYv?=
 =?utf-8?B?UWlXaXhIL0lGcUpQQTVIaHQyNlBuQWp3R3JERXY3S0RmMTJkWmhYVFV3Qlpy?=
 =?utf-8?B?Ym8wNlVUYVVGd01jemtTVjVuZzRpWi81TkhDSlE4VTlhbUNVOUlIMjZjbGd4?=
 =?utf-8?B?Y29RZFJ5Y2NBYzBhTkc0YkhwSHRnMnppRUlMbDc2Z1RCS2VNUHVKR0htMGEv?=
 =?utf-8?B?U0xhemhBSWE2d2E5dndBZHRvUzUxVkJuY3QvdCt5d0dzTGo5bDVWZWIxTVNS?=
 =?utf-8?B?dnc1RC9iRDJnSERKajFHS29IdWdxVW01T0h4UmR5VXQxWGNvRmJaK0FseW1r?=
 =?utf-8?B?R3Ira1dGQmlid1ZEamowa1UzWk9HSHk5Z0F4T3BqMkw1Zlo5ZTRGNFVoWXBn?=
 =?utf-8?B?VXlDYlc4ZHZVd2VndUpPMVBiczdaTnIyRldhbnFxZG9aTE5WU243Z2h1aFhD?=
 =?utf-8?B?QXhDVUt5T3RudWJjZXNKYklrWm13S2FqU3UvZFllV3VwVVY5UGN5T2F1dndQ?=
 =?utf-8?B?L1QvbjFzM1lWK0dPQ05OdTByeXFKYm9KSXZLSk9Ocmt4VHdXQ1ZnN2V6NElx?=
 =?utf-8?B?MzBhWHJSQWphRnlkZXJVdTBnaGk5eHpPelNzLzJKc1pkaW5qaUVjWFJFRnpx?=
 =?utf-8?B?azlJQ2NCaTJQeTBYTm5YTHo4dVo3K2ZmTTVtOWRDUGd1OWVicWZHbWJDOFRQ?=
 =?utf-8?B?cW8vUzdzOGQ3dFI3S1BMcGo4NVNVZ3A1QW5yQVVQQ3VNaUEzQ0lLM3RxcVZT?=
 =?utf-8?Q?FtzwONRGKqsvrkstxsT0Xdauq?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17811f8b-4228-41b4-637b-08da8cdf9c92
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 12:35:26.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4vqk92i3RFNjd5kH805K9owfPUmee/j2IkxFVgPJMMaY457f1vII9V7XMhCbkdr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR01MB7465
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/1/2022 10:11 PM, Jeremy Allison wrote:
> On Fri, Sep 02, 2022 at 09:56:57AM +0900, Namjae Jeon wrote:
>> 2022-09-02 6:48 GMT+09:00, Jeremy Allison <jra@samba.org>:
>>> On Thu, Sep 01, 2022 at 04:37:21PM -0500, Steve French wrote:
>>>>
>>>> I do like that Namjae et al made the format of the .conf file very 
>>>> similar
>>>> to the format of Samba's smb.conf file though.   I realize there some
>>>> users complain that there are too many smb.conf parameters for Samba,
>>>> but he seemed to pick a reasonably subset of them for ksmbd.
>>>> Samba is a much larger project with many more smb.conf parameters
>>>> but it does reduce confusion making the parameter names similar
>>>> where possible e.g. "workgroup", "guest account", (share) path, read 
>>>> only,
>>>> etc.
>>>> and fortunately the default directories for the two smb.conf files are
>>>> different so at least the daemons don't use the same file.
>>>
>>> Sure, I think the formats and parameter names being as close
>>> as possible is a great idea to allow users to move between
>>> servers as they wish. But making the files the same name
>>> is not a good idea.
>> This is the first time I've heard that it is problem that ksmbd's
>> config filename is same with samba's one. Reading the mail threads, I
>> don't understand exactly what the real problem is... I thought that
>> using same smb.conf name make users aware that it was forked from
>> samba's one. I'm a little surprised, I thought that you will say that
>> we should use the same name. This seems to contradict your previous
>> opinion that ksmbd's dos attribute and stream xattr format should be
>> the same with samba's one. It's not difficult to change config
>> filename of ksmbd if you agree with it. If we think about adding the
>> ksmbd integration feature in samba recently, I think it would be
>> better to use the same name for future.
> 
> Well as Tom said, it gets very confusing to have the
> same name config file.
> 
> The file system attributes etc. certainly should be
> the same, to allow a user to swap between the two
> servers based on need and not lose any meta-data.
> 
> But as the features diverge, trying to keep a common
> config will get harder and harder.
> 
> Better to take the pain now, rather than try and
> postpone for later. It'll hurt *worse* later :-).

The name collision was always a minor thing for me, but when it
goes front and center in the manpage namespace, potentially
coming up for a user when they expected Samba's, it is working
cross-purposes. Ksmbd should forge its own identity, for clarity
and for the future.

Namjae, you should be excited that this kind of issue comes up.
As interest in ksmbd rises, more eyes will be on it, and more
feedback will come. Remember it's experimental, it is not yet
frozen in stone by being adopted by large numbers of users.
Now is the time to work out the usability.

Tom.
Let's also pop up a level
