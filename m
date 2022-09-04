Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5EFECAAD3
	for <linux-cifs@archiver.kernel.org>; Sun,  4 Sep 2022 14:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiIDOPo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 4 Sep 2022 10:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiIDOPn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 4 Sep 2022 10:15:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDA42DA93
        for <linux-cifs@vger.kernel.org>; Sun,  4 Sep 2022 07:15:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTj+Tr0n/9bKTXroJe0ADj+lC2dVEn5ZrFd12l5xHmMd3LPubK0yjqwtZcHq5x78r5kXYk1Av4TJvac+uW74+q+3mgSA/f/8zBxaQvJy/ZenxJ+6p7dq44ZVl33of/iDpyKCg/seeyLf8mQcUxBc2GUdW81rLti2HtHbDL/IGJ0/ISRfFR2nyUk0H5YA6AuO1UypPyD7zqJmW5PbUjMlp8bDsqc8Smfc3WR7HTFpqBEeAuId+lxToOblzsBXBcA6MDes/AuIsAVmTZ/IENVYJ2L5jM7coH+i65Ri6mq0cWoN81MWMfl3ngjRUn8a4IsXxQUaSHEtL5zIuL3AckKPIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xs1I/tM7bUwgaJ9wY6ZVo/5QRtMpEJXuH+kBxXyEjfQ=;
 b=LmesF6CLHByWo9RGojtz0Wq1eCHPlq0NN4tdckVqzWwqPmr7ZYJVknxAzS0MQCMPF4h1t70CPTIaY9NKckfL8PbGyzEWzoDnFUlqgTD8btW8nc+e44mw3Vf6fJBtExc5u9M1CZxg8jj5WO8RuT4GXjVj6BNxt4PPqHTl/qsSN6QSMgQeWyabNJw93hLttDr8GDkccvk13RdgzyFJGVEpJ1Q9hxQiLgFOEZERifbybvNya05LFITvvEYefs84k/oFudecqCe3H3ILcQVYjdmfd69uyeCIrCJMfwSDkhwRhD7swZ8CFe+RnDsnw/OgQ6P+AbftGmNBhbayb+dj14yUKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL3PR01MB6817.prod.exchangelabs.com (2603:10b6:208:33c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Sun, 4 Sep 2022 14:15:40 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5588.018; Sun, 4 Sep 2022
 14:15:40 +0000
Message-ID: <1ef69bf2-9532-8653-2d21-83beb8e14906@talpey.com>
Date:   Sun, 4 Sep 2022 10:15:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [Bug 13570] CIFS Mount Used Size descrepancy
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
To:     kato223@gmail.com, Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
References: <bug-13570-10630@https.bugzilla.samba.org/>
 <bug-13570-10630-SqsiUPsDTx@https.bugzilla.samba.org/>
 <f5708177-ff94-c745-a191-4fdba33a2e06@talpey.com>
In-Reply-To: <f5708177-ff94-c745-a191-4fdba33a2e06@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR1501CA0011.namprd15.prod.outlook.com
 (2603:10b6:207:17::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6173a24f-efe2-4488-5839-08da8e7ff24f
X-MS-TrafficTypeDiagnostic: BL3PR01MB6817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oCvS3NBPAdrBT4/xqdLfOUb6C79lTV7Pr3cTYlJL0CrLrWgJnzbrmH5P1GqsPQvn+GsjH8zgfjxRuI3AVIfwq2F/jBj4+MGhZCGwYxCo921h1d+yps3sRN1QqFjAdaH0qM71i8MJ/qpHUuG9L4ukjE0kZwH6OYTvObewa+bQCS/+C/b3AaCYfi2i9+u3l4hOIhbT/EOcEQ5qyQYnodq0hxapuiQBiPMadPwRdYTC2XvlAkLFLbePm2ZrSQkSl6VxcSK7kDs43nstq5rXa8k8m87Y58ppaypfXr4IC3c8c4njiJQM8zW3IYLxxeb0moCnubCxEHvN1sn2HeUXas6/c+ohkheMG+jxZrl0siWfeFHQLVOb9br+GAqm0ZCmBiO8eo6zjEMo3L+lD5X+lmHlQja5qd8iuNvlQsCpyQS0WbVMfUewYo6ipeP6EOafrf6vxUmzNd/YFe6mw+cLqOeGTZ4YgeYgQ07EY4Ha16x2DgU7qxAPetqRUhisZw98unrsFKOn5Yaj3W0Wayqkyzz+IgfHPwZkgFH2ZJu0aPFqI07VOBvgOXE3FR41jMwFY2dhvGUXbHR/wyLenJ4ZF4WyWYjSrBpfPdhgrrgYw998dqFTK96S9H6IoYlCgVPlfNpUb4A2Q4IkagwDPag6OvN6O90KFVUjGyQOEBOodfv4uXTlrRZEKOj0g4HZyQC31+hGjOmWshODtUhsHyhUsjBw6zklDzbJzb8mtHCednU/sA0PyGMKPx0Eo2xrfdEwlnohinM38+Jy7mYgsG3f/sV8OiW+xcxWm8vvD5uGnGTSESZx4MAe7s2kcxAJRURD8jwzegJIpfkLj8PdkGTEj74uvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(39830400003)(396003)(366004)(26005)(52116002)(6512007)(186003)(2616005)(8936002)(53546011)(5660300002)(6506007)(4744005)(86362001)(6666004)(966005)(41300700001)(6486002)(36756003)(31686004)(478600001)(31696002)(83380400001)(316002)(2906002)(110136005)(38350700002)(38100700002)(8676002)(66476007)(66556008)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVZWUnIxWVhlTFBpSSs2S3dqNDNVMjVHSm11Q084d0V5T1ZBd3NXZ09UMENL?=
 =?utf-8?B?ZHFLZ1Z0RFoyc2c0SjNWVTNWcXJCbmgxbVQ2ZS9ScytFQjUvckVwa2hYdDRP?=
 =?utf-8?B?S3JUeDlvc0xwSXpjaEdUQVF1RnlVRWVOdU1ORXpnVVJTUEtlMnBDOEtBbHBa?=
 =?utf-8?B?cDFXV3hhWHhsUEpRRzNSMG5QZW5wVVVmbFdxTjB5bEQxTDhwZ1BEOTFQbzBT?=
 =?utf-8?B?bjdwVUVaVzJNMGZFYnNPN0FKZlFhbHk4UVhUaXpoTVl0MVNGR2paT3IvcFBu?=
 =?utf-8?B?K1RoSXNiZzNTeng3WEpEREhIaGMrRTJhQmk0UmRBQTZvR3JGaTBKUHJSMTR2?=
 =?utf-8?B?ZkxDNnRwNU9YcW5uR0pTSWo3aEhKTWEwcXA1dlZRS3k1UUNwSHVYak1mT01N?=
 =?utf-8?B?aHdlZnFwTjdZRUtxVVZXM3l5SEtockc1RUdCQ0xCdGJLRVZxZ1d6UGo5MnR6?=
 =?utf-8?B?R2pCd1FiS0NSMnAwVy9LOFV3VFdTcVo1RHNUeUF2bDZReFU4MTdaSC9iejBM?=
 =?utf-8?B?WXYzcklaWGRteUwrM0piWVRncENPOWNqOXgvNkRHeGpCYlA5QzU2dEI0dTRD?=
 =?utf-8?B?c2hhZkwxajZIVkNtQ0tlTGdReWVqT0Y4aW8wSVA3L0xTVXN3dDVVZkRmRHN1?=
 =?utf-8?B?dGxLbkNxTTB6U0NQK1lIMnQzTDJZblFYbTZWM3ZJa2Fwak93eDNJbXZGZVdS?=
 =?utf-8?B?SzBrekZmeVVpa2ltU3N1bENIOWZKa01vYzBadGdjVUtCekRlYWdyRWpTWVBY?=
 =?utf-8?B?ZnRNWG1jbXFyOW1va0xUK0xhWko0OTRtdWErVWZPbm9tL3g4OWxSR0t1MkZN?=
 =?utf-8?B?M3dwOTBWeHVwUTJ1alhoZkFSU3BqaXJpODUrYkVVM2VkanZnaU1aSXNkZGFF?=
 =?utf-8?B?Uk9NdDVvYzVTQkxqdm5wa1lTZDRLa1pBR1N5dlZaaCt2WG9ZYUgvSGtZRXZp?=
 =?utf-8?B?U0RlMWV6b0FWQ2RlbllNWE95ZHpkd0dmSGx4SzcxT3BZbjY1RUpZSmUvR1FR?=
 =?utf-8?B?YVowNlBKM1JSaTVGNE93QzRydWNZTHNydmg4K0pBMVRBYklXOVF2Szg2bmhS?=
 =?utf-8?B?TWhDdWlkdkhCZ0dDL04rZkVmcUp4ZENTa0pNK2M1cGt5UXd3Yk5XWWgwQ0pj?=
 =?utf-8?B?MERINHdKL1daeXB6c1lEd2ZHU2dwSjJ0dFZyektGUGF5c2xMVjVvbDdHUi9C?=
 =?utf-8?B?N2FXWXBZd2g1TWFWLzZPWmh5UTBFdGRtNjc3NTZ1eVYzSktwdk4vMzd2Mi9F?=
 =?utf-8?B?QTUwa0VOeWl5WDVMN1lYcHF0U25jYTRuNFdjcVBzUmswcExTUzhXZ2tsQXpF?=
 =?utf-8?B?dXp3OWYvMVlSNmVKSWs5NnNab3hKZ0R5VW1ub3h4c3hOenFLaXhnNEJzRGJx?=
 =?utf-8?B?L3dmdHVlaDlpdjNlYlkzYkRFVEdEYUFKajVkd2NURE9VWUo2Tm9oN2VHSWVP?=
 =?utf-8?B?c1grOWxNUU1KOUxzVk1RN2FNeWxqbXBtNklsSkY0SktPRzFWdUVmUHZmL25y?=
 =?utf-8?B?SUp6eFM5QS9qdEhjRTZjNlpHUWJFUTJ4R1R3dElsbmtBa1JPeGVkK3ZiSlV2?=
 =?utf-8?B?SmI5RDZFMnN2QlBmcjlVSm85SmZnOUxDSkg5T0FBb0wzN2tpSUFmaXhFclhR?=
 =?utf-8?B?cnZydzVOaFpZNEpYWFBlYlNTZHdJRzdPbHhSNEZFSkx3cDBVZDBDYlR1L2pF?=
 =?utf-8?B?N2E3dTEySmJORVZNN29ZSDcxWkpGTno2N2VwazF2MEZaUmJpTEpGY3RmcU02?=
 =?utf-8?B?am5iYitkSDJtbjVUOFl2V21rNWdYa2NpWEUvRkRVZys4d2I3bEFQWDJjUzVI?=
 =?utf-8?B?ZDNiSTE4ekMrMDVhMkIweUdYOTZndkpFbXFsZGFabnFJVTNieEVsS0lGTWFw?=
 =?utf-8?B?dWoxbjFHWlZOOGNTWjdJRDc1QjFYNUMwMnZJcjgyOVVNZEdPc1JSOFZFYlRq?=
 =?utf-8?B?UWVON1VkbG0vbTIwdVgxZnNieHdkeEtOVlR3bERjYm0vZDdPWnl0RFlFalk4?=
 =?utf-8?B?bHllOURiaVVtbGFpMFg0SUxxKzFrVDVvYmZaaHNQYmdvNjJiS3ZKZ0g2dHpX?=
 =?utf-8?B?d0ppQ2JwOXg3MVJqNG54Z21ZMFcxK25haWJqeTRrM3crVjlsWS9RMDd5dm5t?=
 =?utf-8?Q?I+oyKUK2STeq7PDv+6iMxEvho?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6173a24f-efe2-4488-5839-08da8e7ff24f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2022 14:15:40.5029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIDy1UTLnJ107od3eocbNopDWHGjfDAsFaORfECvfWjLfEAc6XUqIlVEqXTPu5Ws
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6817
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

[resend including linux-cifs]

On 9/4/2022 10:13 AM, Tom Talpey wrote:
> [I don't have a Samba-bugzilla account, so replying directly]
> 
> This is clearly just a TB/TiB discrepancy in reporting.
> 
> 9.1 TB * 10e12 / 2e16 == 8.3 TiB
> 
> Odd that the "Size" and "Avail" numbers are the same, that's maybe
> worth looking into. I bet this is some sort of ancient compatibility
> behavior for a Windows-style API.
> 
> On 9/3/2022 5:55 PM, samba-bugs@samba.org wrote:
>> https://bugzilla.samba.org/show_bug.cgi?id=13570
>>
>> --- Comment #8 from Terrance <kato223@gmail.com> ---
>> Top line is the Samba mounted share and the bottom line is the exact 
>> same share
>> mounted on NFS.
>>
>> Filesystem                 Size  Used Avail Use% Mounted on
>> {..}
>> //10.0.0.220/storage        15T  9.1T  5.5T  63% /media/Samba
>> 10.0.0.220:/media/storage   15T  8.3T  5.5T  61% /media/NAS
>>
