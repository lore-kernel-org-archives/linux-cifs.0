Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A04C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 15:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbiI2Pk1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234340AbiI2Pj6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 11:39:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917271D0CB
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 08:37:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCUY2aZc/6CBE48y146A+pXSzHovqEJmQp1FQ9MWtUJXmdOeIRtGS54tzFqFmN8utehyAGcR65Ux2gjWJSx+pVLIwJJWb7EPrP+SpFjmdgcNghtcnvlmPx7iBos5PD4bMAWDuqo2f+xYKHSC20Gx7AO6jUwKvNGS4ZpUz5mHfYfzHqU5B70+4qtxySCELkGdq6UsmtDPLWve/OWrQqsmCISw/TyS7T0Hmu+0FmkzEv0sZQ3JC8jpNw56uL3prpDONSka8gt5+4eEl72OdvLr5Uits8DzsftKAW36NG3PPLl3+SyU5WkZqFotD483AkMb19Bnv8egMgVIda9SA8MV3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kT+U8UE1C9oSPgGNNqLFMn4XpdBrCi7LX2mwKgmeq9o=;
 b=Ba7MqgVqR5Jb+XrTkRQC1b/YzH+6yFnrrluTQ+EWd7Tq9lwSF5AO8i1pjeEs6wmdzYyrQn/lAM5gse/mHjiO3EyNtcFNXGj/hRV97CgL1ivSrSO9nqxRna8kZHqiY2ieEnZkFWR3CZCbj3c8wau//+/WfMgeMVvostvcA/2J1cwmawLCLeJ+3IrR1ynp7Pi7/1k8bKta96UTX5SmydHKuXenfRyh5gAnOMR6fIXRlLsZBMiZtnCxYhvd7kGk02+NjSOu1mXGbMbzuM5XKcOE4CuqVl4ilh/Ews9CktHL3eFs62QWdMwntd27n95MGf9/H1c08R1jqi3V61O8iFkVeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4663.prod.exchangelabs.com (2603:10b6:a03:82::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.15; Thu, 29 Sep 2022 15:37:28 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded%7]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 15:37:28 +0000
Message-ID: <08d13e36-d6dd-ff73-bc98-b3dbdfae0ea0@talpey.com>
Date:   Thu, 29 Sep 2022 11:37:27 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] ksmbd: hide socket error message when ipv6 config is
 disable
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20220927215151.6931-1-linkinjeon@kernel.org>
 <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
 <CAKYAXd-=nt_-X_YhZt+esNR8j9xF-UpSDApe+qb3t8T-NxP-8A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd-=nt_-X_YhZt+esNR8j9xF-UpSDApe+qb3t8T-NxP-8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0035.namprd17.prod.outlook.com
 (2603:10b6:208:15e::48) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BYAPR01MB4663:EE_
X-MS-Office365-Filtering-Correlation-Id: 436397e6-16f0-477f-fdcc-08daa2308406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wwljf483JuPwVSBRj+py04GplfdmghDDKSAltx2yC8UtXXaIUX7+yZtqrqyNOagafm1cqUKUX5r4ML2Zgh+by5wbkfoDofLoDXw7sdCjtHEayDU+JykSJOEHj4gaEN8yb9dZU9+1Lf6zniw9IUC5qITD+9Or//XGgfdqUh2EaBcgWG6uMKJeAckxDjGkB/HhuNrutO/PvNRiykzz4/Q/c65hfmz9qBHv1tFW6UE9tK9mu6ZBfGEqUclOAifmF0mZGmQelraE+0R8UkAdsYitknux8yae/DkOIMr4wAIEhQ8LYX1E4eUwpwjPCUxHZZ8s1MuRbPx0+5sIXifJceWQPQ7i9E1ChEchus3V7mZa1KIN4QrW29Q8ZGtbrhIQFCCwJfRAZajlDqlt4Tj715BaU29gMx8A8BknvMiqvQdpjg+amTQkNsokun0Ny4mMJF2mozJMV8gpjnAzspi10nXq2HQJFZMzyRWTGgIbt3J9r7k59QY0gpik2oG1dsayiBfEIj/bqT+RidhW2D42wsvxittilZ42hs6htR2FxtOn4ViWyKaAdVENvM1lWMR71isFXkv6jKjoUTZ0gAEHIdhPArmvTUpUYE+Xu/Y7RWpaAtg6nk2Uv+S8NK4v2YFra2jqLfUGYwvQRgdDDekmQrLevgehvNWrXoDYdLMmz7cRtx68DlVJ0ifgXcd9pc/XI4lZI4tX5iM/MMhjB1i5b8KiKcuIMmNNpnTLIYo4qhsitYcjClN5ZhwTWa3ltQQYdxYIZb4bolA12jRz1ZoaH7QK+H5/bJ0juqcb6d+z3u1cGMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(39830400003)(136003)(451199015)(6916009)(316002)(31686004)(5660300002)(478600001)(4326008)(36756003)(41300700001)(38350700002)(31696002)(38100700002)(2616005)(6506007)(53546011)(52116002)(26005)(186003)(6486002)(8676002)(15650500001)(6512007)(66946007)(66556008)(66476007)(86362001)(8936002)(2906002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVVQeTNWTFJOYW1MV3ZvUkxQTXhpZlhJd3FwMkxiVU5ja2Y2SUZUbzNORFBi?=
 =?utf-8?B?TkVxb3VGaUF6bWhpVjAveVZvYVJvRkhpeEZlcVVwYVBQUjZWdjFOdW5NRk1h?=
 =?utf-8?B?Z3h0Zmlmd1o1VytvV055Z3NDY3loNVoyUERFK2pPUy9hRHNWTkNoUmdrcEtX?=
 =?utf-8?B?TzJ6c2hYOXVWZGFXQzBNZmpCaU9Cd21RT2c1WFBFZ1RmU0RjUWVjNlh4djhM?=
 =?utf-8?B?Y3hRUnYyemN1bjVMREIwZUoyWk1xUDBNN3FKUXpEb1JGZ1krYjVQNlhPd1dX?=
 =?utf-8?B?a3pVbnhxSFg5ck44VUp2SW82QUp4SEFXUlBuWDR5eTA5Yy92RGFvcE9UM1Iw?=
 =?utf-8?B?bnBJclZEVm9PSDZaL2NLMmZUQzhTNnNVZmJIUkJ1UWZFOEhlc2cyeWVVTlM1?=
 =?utf-8?B?dHMzc1FVemdPWi91ZzRJcmY5dTdpSXF3YmNMbTExamZaNlBIc1p6NmhXd1Q5?=
 =?utf-8?B?NVFlN29LaEgwSW5yblQ2Sjg2M1FPQ0U0VHIvdjFGOTdJTSszZFFWd1JTTUhT?=
 =?utf-8?B?RkUwd2VsdHpVZG5nWmVBb1Joc1dtTU5DSWFqOGFLZ0NtdTNxYXpUSHlzWWJB?=
 =?utf-8?B?NGNaTDNiSG5TZlFiaUlxNXpmY1RnN0plTzlTNGp6cVNscDVENUJ3ZWVTQkFj?=
 =?utf-8?B?MVc4N3hoYWRubnNoSm5PNXZ4WHRIWmE3bjN2bi9weEh6S0VGZVkxZWFWdFpj?=
 =?utf-8?B?QTBvSXNrL1MrQVRCSEp0OVY2cW1hTWE4bUtuTXVtSFBBZFpjb0p6dVQ3T0pk?=
 =?utf-8?B?TTJaZDdtdlpRcmZRMXJsUUNvSGFabkJvRWZQbW1HWnowcHBrUnNVMUdDWncx?=
 =?utf-8?B?ejg3cVU4S1dUenRXR0EvRUR2QlQzdG1TZVRRWGwxWi9oS1g4U3pnVzZrSElS?=
 =?utf-8?B?SzFNOUgwTVBCNXR0OVAxUzVOdkM0M2FaRzFIeXNxajBuUFh4ZHhFUkFNdStu?=
 =?utf-8?B?cHp5blU0bkFYeG1TZk5YS2tsTHY3OGpJaXVOWWlQMTNJYjJTcWNMazE2Y3NI?=
 =?utf-8?B?a2srTnBmWkVvTk5WSHhxczk5QVNLeDViRU5uNWJoTHdUUXF1MmtZZUNYT2tR?=
 =?utf-8?B?NmNOWTJuNjdNTmpMajR2YjJRRUdGVnF4UERnQ3JzbGhsNEtBZlE3cUJzbXNI?=
 =?utf-8?B?Q0dGQnpWVmRMYXlOWGVtTkhRSXVJVTlhTlQrbHA2YU8zWjN5Y2Q3YXBscFZM?=
 =?utf-8?B?Tmoza3JMSXgrRnJydEgvdnBkTm15aktXRkZZNmV3bzVEVDBOaERHa2xVQ3dv?=
 =?utf-8?B?Mm92VURLSWF1ejJDUkV4Rm1QWi9pSm1kUlM5Ujd4d1RqT3J4d0ZHZUloWEg3?=
 =?utf-8?B?K2lkbUVEcmZuTlQzbk1oTlhyUDlrUkJSejUvRUNaSXA1Sk9iRzJEVnRMNkgr?=
 =?utf-8?B?NHJKbEtGYjdJdUlKOFZ4TkZDb0ZGZW9tdVhML211OE8rSXpvSFpENEFnQk8x?=
 =?utf-8?B?R2Zlb1IrZnVra1N3RkxmNlFodzk2SjVMalFIZGZZU0c1RE13MFE5NjgxWXFM?=
 =?utf-8?B?SW52clA1T2tLRlExWDNaUUVKbDJMQjJGOVU2dlJvZFY5clVsalV0SGVPU3Jm?=
 =?utf-8?B?dm9tUzJJdURNTHlkT2pHTWtnK1lINkNuaVFwQVhIV2NGTFFQdHVCQ3dBUnlB?=
 =?utf-8?B?eHg3SThTejlNMVNkczlzVFVLcmZVU2xVeVBCQXoydDhLME4vTHR2dGFrYkJu?=
 =?utf-8?B?U1ZVWmI0N3RHYWFKMmRiQjdNOWFSRks3ZjAzR0F2NkZ0VHRtMVozcmxBZXAw?=
 =?utf-8?B?cXBSQjMwNmxONVVSaTBLT1V1TFRyMFFjNHdhSGJwSjRvTzkrSWRiKzgrTlU3?=
 =?utf-8?B?Slh1ekZaUjNIVzRFTW9hZ0wxbitjdkduZ3pVREk3c2NxZ3lUV2xuYTNDcmw2?=
 =?utf-8?B?OVRURVk0dE1EVHFBcGVJTDIzNXVxME15Rnh5QllLdmxxRHpYbHV4T1BmcFNQ?=
 =?utf-8?B?azcrVGsxK09DWTRNQW9uU2lrZzNUMEY5UmV2RW9ld05qYTh0ZEhLTnk3NW5K?=
 =?utf-8?B?V1lOclJCZHVWcmRxd3V4TXZPMzdvdjFoS2Rvb2hBU1ZZV0ptYXdJdFI1alJ0?=
 =?utf-8?B?Sy9SeUJncHJER2ZLNVBtQUx3emxWOXJYQmtRWWZkeW5JY2dSamdENXlHbXRD?=
 =?utf-8?Q?AST7yaJN7WFTrxHrzGslttJHF?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436397e6-16f0-477f-fdcc-08daa2308406
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 15:37:28.5870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3GiRhF6Snuyky0nUdSDm2y1DYITvm09u9o5tSpXPdZICcmuGwveU8B5uz6+Mytf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4663
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/28/2022 7:44 PM, Namjae Jeon wrote:
> 2022-09-29 0:25 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/27/2022 5:51 PM, Namjae Jeon wrote:
>>> When ipv6 config is disable(CONFIG_IPV6 is not set), ksmbd fallback to
>>> create ipv4 socket. User reported that this error message lead to
>>> misunderstood some issue. Users have requested not to print this error
>>> message that occurs even though there is no problem.
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/ksmbd/transport_tcp.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
>>> index 143bba4e4db8..9b35afcdcf0d 100644
>>> --- a/fs/ksmbd/transport_tcp.c
>>> +++ b/fs/ksmbd/transport_tcp.c
>>> @@ -399,7 +399,8 @@ static int create_socket(struct interface *iface)
>>>
>>>    	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
>>>    	if (ret) {
>>> -		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
>>> +		if (ret != -EAFNOSUPPORT)
>>> +			pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
>>
>> Why not just eliminate the splat? The only real error seems to be
>> that IPv6 is not configured, which is undoubtedly intentional, and
> No, It can return other errors.

In extremely exceptional circumstances, like the system out of memory
or a system without sockets configured. I just think these are not
worth raising in such a way. There is a handful of other pr_err's in
the same routine that I feel the same way about.  They all seem to be
targeted at a developer, rather than being useful operationally.

>> in any case there's nothing to do about it. Suggesting to "try ipv4"
>> is kind of pointless, isn't it?
> No, It is not bad to give info to users. users can check ksmbd
> connection status using netstats.
>>
>>>    		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
>>>    				  &ksmbd_socket);
>>>    		if (ret) {
>>
>> The same question applies to IPv4 - socket creation is not something
>> that fails in general, and spraying the kernel log isn't particularly
>> useful toward fixing it.
> I don't understand what you are saying. Since it's not common, it print an error
> and give the information to users.
>> In any case, the error propagates back up
>> to the caller, right? Why wouldn't ksmbd.mountd do the reporting?
> Why does ksmbd.mountd appear here?

I mention it because ksmbd.mountd is what loads the configuration and
starts the kernel processes. So it's logical that it would be the one
to report errors.

The present approach is something like "start the daemon", "if any
issues, sudo dmesg and see what you find." I, um, don't think that's
production-ready.

I'll go with your change for now.

Acked-by: Tom Talpey <tom@talpey.com>


>>
>> Tom.
>>
> 
