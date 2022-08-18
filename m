Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A63C00140
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Aug 2022 17:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiHRRsK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Aug 2022 13:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbiHRRsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Aug 2022 13:48:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B753BC653F
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 10:48:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnN/glOY5CWixSOWZ0WAs4mFmoDkgoUNpEtRqz3f+t3+F9RlkB/6KWLNIA+OQlZbxA8h2pnWMFpjqhcIm/EfR5t10B6kW8FXKYGGvZZPMEfJgzTb3VX7rXvAvlQgzOEf3YzyWsNPJbrbLOha7WlT7BSHK5J9UqVfoHeQ858hZc3rc0I2c4K0/S2e46mMEyIz0ll7q88DVNhEn0QDLG7V33r1Y6R3ZzkC8XofT024gxSJ9ypxzqZhik+pxyrb1liJxcH7AzGyGPV3lp+N3vHXWIXd1/167qzuMaTZ6k+MbyZOEPYifMGR9Kqw143PDieJCY02al4K/nA2fLqGEOLKRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mVwF3HeZV9uC0cIdhme7zoDiN7BBplisMdybKgu+oa8=;
 b=WK8viucIMRQECi3Oh8BQI1yc1yE/yUWWT/DX+soG9k7medDJEWWsn1Jbrf3GJl/WBMn59ZxKI3lsSHMdjMfAs9aqNXNZzrzVle8Y06uINFrxILGVtlT/DpKL3PRXRj+LgitV91iZ7ChUxr0Ls/yskSNBkUdNCdHyHxiQ0ESC5z7WEzMABcmwaEXL9BbCHsQciphj7IkoUK6k4Lpf/1D9ilXszyWQXXA8zNDsBwvdZiNWHlVIc36vxl77tQeWGa3IIHggAkaFHlseYcog9Ae6TxKsCHoblFwm/OFoDVQKQwfrKEWoUCeD1Phr40GGeWWqNm5gTDQRzWEB2qsFkuRj5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CO2PR01MB2166.prod.exchangelabs.com (2603:10b6:102:8::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.16; Thu, 18 Aug 2022 17:48:03 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5504.028; Thu, 18 Aug 2022
 17:48:03 +0000
Message-ID: <f45cb6d4-d666-b4e9-adc1-705eb3bc5a1c@talpey.com>
Date:   Thu, 18 Aug 2022 13:48:01 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: mount.cifs man page
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mupcJD89SP4SqOmTLSABQ0kStyWF9EU-eMEuyZ_uA7G9w@mail.gmail.com>
 <20220818163056.54xunvo5rfr7hi7g@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220818163056.54xunvo5rfr7hi7g@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0034.namprd02.prod.outlook.com
 (2603:10b6:208:fc::47) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 387ab0f4-2794-4181-74c1-08da8141cc91
X-MS-TrafficTypeDiagnostic: CO2PR01MB2166:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 506PRX5CRHJjVeyh0iWXCH4GOvEW8M1vy8zEyf6DHg9Um+hknS4TfymUmrfsRwd8nqxxx67gCsCsgn9054/GeRUdJxCgPr2xzK7BmS0XnKzknSlEIruF+5dSSTJHYxcck3MXJSgog7HjrfG0/4ZuqFcJeRR3q912OW0xJSYzW56OWmf/mkfmGnUPYuyeK6QAqrL53zdj8v0eXrAO5PP0L9Ud0YXMDY7Nr+D/I9GuCiLJrybEj6c9Zq4oaYLU8vhXizujWU6vHUq6J6IVAgM23kjFk1E/Q+JCDxiaC/9KPcK0Kmt1J7EbegcX55/zOSn9fkjh3Da/bFn8JfUJzdOhRZP23qfQzHV1neYg3sn4BvzPYrGxVLrsZrq1gkNH+8qw8h93KCdx5FMgxsS0ZdtB9vVh5FiQXlQy9He29k4sn8BKh2Ujmn/KwgGWDNELpOVgwClwj0vE7qEmDYTXSqm7QJF+irNTzYKn1YH8BJuFqkhHZfB4iwn4dW5Zr1TV7by59CjbZ3Tiv06ZR57b5qvHpq5ErNCCclH+2wLOaeM4trFOK6zkZyzPa2jSszxMgHg/+cwEKP3lPNZC1qWqvFIMahUxQVREZ8uf//AgflZF47R2KJ3enrU7Q5PZAoUX0ICtcncygTIZXr/ebF5wB5BfusqA1kFK5FwiOr7/EF/GFeAp+eRzn8EhBBG74qoR7zoTNkXQC+tD1iQQm0gir86jULUFqyjww/dZ5gyEn1hpzvQfzJ9EmtWdeM7kFuzizCA0PI/pzB+ALvP96PW/Qwm+kPJ+VwBqX5sykNwdOaiS7rc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(136003)(366004)(346002)(396003)(376002)(36756003)(3480700007)(86362001)(38100700002)(2906002)(31696002)(316002)(38350700002)(110136005)(31686004)(26005)(4326008)(186003)(5660300002)(8676002)(6486002)(6506007)(53546011)(52116002)(66556008)(2616005)(66476007)(66946007)(6512007)(478600001)(41300700001)(8936002)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnJkand0WGF5QU5iRzhJbWt0NGNlcklCMXN6a0R5dVIvMDk2Z3N5Qm9aVGJk?=
 =?utf-8?B?SVk1aWpZcTlzVzdheEhWRmNqWGNvYzdEYjRPTUZ2YmowMXZPd0JxdXRKR2x3?=
 =?utf-8?B?OHcvN1VyQUh2Rzg1emUzSm10NE5wUitldTNHdUdaR3U4V1gvMnVCSG9MSXEy?=
 =?utf-8?B?cm9XU2VMRzVoZTM0RHh4bWlCQkQweGhjM0xCU0tITWRZNUQrSDYxRmhSRUUx?=
 =?utf-8?B?bEd0T29CaVZkcXhxNlVZbjVWRlp3bHh2aXp3c2VkL25XVmRiZnJydGtZem0y?=
 =?utf-8?B?b2NPSkFTamk2VHJwR25MckR1NkM4N0F0NGR1WTZndTdwWG9RWmdHRCttVDFE?=
 =?utf-8?B?ZTFQdVFORGpQMllvbWdNb2tTUG52bndPbjgzWVIyNHJsQkFGRVVleU9KTE83?=
 =?utf-8?B?Y0xycnFIMWFDOHJnRjZUclNaY0xSWE4zRWlUV0ZnZm5ueXFWeGgvM2Y0bWV0?=
 =?utf-8?B?M0IrTWtLUmc4UjA1ci82MUl3b3dmRFNVQVVsNUxYQ2EzL01EbGRMWE1kU3R0?=
 =?utf-8?B?UDZKbnhiTCs5c2IrNDduazhRRnlkMGNVMlRYZVR3L1Rrd0hDQXI1clJBYmZX?=
 =?utf-8?B?VEMvWWxvYlZwSngzVlJaSDVEZmg3S0pRWWEyeTNMUzg0NEQ2c2hUYW1IYld2?=
 =?utf-8?B?djl1Z2o4Q0dMNTFBNXF0cG50ODF3bTlLNjZoaGtsa3lUcUw3MThoZTcvdTJW?=
 =?utf-8?B?S1hCaXNlYlNWZVhjUHBoNDFCMWlYSVJ1UTJDWERaakF0aHlKMnJJamduamJB?=
 =?utf-8?B?YTBFWmdnOXhESXJINmd4RWFCZGJJbGtOVVhBcnVudjJBeXpONFh1dzM2MzFo?=
 =?utf-8?B?blZRaVBad3Q5SStNSng3OExHRHVXVlkwWlI5VHU3cmllZkpSOFhCeDlOY09Q?=
 =?utf-8?B?ZnBZc0N2ZU1MUzJQUXN3TjhvbUZydFoxQWFMY09YUWovOTJ0elpXQlpnUWM3?=
 =?utf-8?B?N05tdlJLRENFd3lITDNrcUpUM3NTVHhtQUpGQ3l0UGdWZGc3Tjh2VkNBZXBn?=
 =?utf-8?B?Z1RVaVgyVHNyaGwwaE5IRmFtRDhzcllXamswQXZNMklvbEVoOGdCTHRMcTEw?=
 =?utf-8?B?MEJHTlJuZmJJa2VtWkZTTjFFaG02aVlrL0RDY1ZZSVZZc1BteHEvbkVJRVE2?=
 =?utf-8?B?UFFhTURjc0c5djg1TDVCQTk2SjJMMXpBbk5OdlloOXZmVHY3ZlJMQnYrd0M1?=
 =?utf-8?B?YzlNOUhmdUt4aUJONTk5T1Q5RWNoV3lkSnZpU3E5Q2MzSjdONklLb0lCSEpO?=
 =?utf-8?B?UmRpZ1czUkdKTUFFK2FvZzhJR0JhakI4dFlnbW5OcWZXVFBwVlExWjRJblJv?=
 =?utf-8?B?a2xrZ1h1OE5PTHRYNCtiV2h5S0loN1ZWckJGT3NqTmJJaTR0VS9YSEpGRkhV?=
 =?utf-8?B?WFNuV1hJNTJnR2FSWllJcWw5UzNLMEJCSzUxNXZKYmF3TjA2VFNPOG5EdzVr?=
 =?utf-8?B?aG1SVEtuWW90SkZ4Nnl3MW56RndvNEZ0Y1RlZ0NOQ0FQajRFNXVQQlhZWmor?=
 =?utf-8?B?bGsrSmIzUlpsb0prL25aam9yQnluUEdYbXJRUSt0d2dzUFJINDUxSnJBdHA3?=
 =?utf-8?B?MzRsK3IyTHo1Wmx5TlJoYStOaC93V29VSGN4b0drTUJvMjBaVm1MbithZXNn?=
 =?utf-8?B?SmIrUnNqTHJ6VWswUiszZTNmdmpvWlJLOUE2U1htclNUZ3VYcUxxRWVob1Vs?=
 =?utf-8?B?b3JqNmJoL3RFeWxOMG1jQUxmemIvVUowVm8yOVAwU2dmY2ljaHlkZUZBT0Yv?=
 =?utf-8?B?bXpOOVB5dW9WODlKUUNnb215Y0YwTitvU1M1RUdLQlJacjlqWUZNTmpEaWNC?=
 =?utf-8?B?RS9ieDlUWTduc3U2aWdrOFFNZ0wxVVM0S2c1R0tuOWVuNWN4NnZTSW9USVB0?=
 =?utf-8?B?K291Y2l0WlNZWXVBbnMrcm1Ib2xUS2hWSko1akUvSjZXbjB6dk9RUXVBdDdh?=
 =?utf-8?B?NmJZaC9TdUNaYVE3ZTd1aThJL3c1VTJhOFh2YWZId0hBMytheWM5RVAxdGNi?=
 =?utf-8?B?YTFSUmt1ZVZ2Uyt3V3dYK2t3ckVoaTd5UXpkMmpBYThua0NaSm1iSGRGZHZr?=
 =?utf-8?B?SWhLSS9MbmZRWUhrZmVWT0M2RzlaQjBKSkRweExCWjB4M01EMGd5OUNXeFhz?=
 =?utf-8?Q?kKPk=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 387ab0f4-2794-4181-74c1-08da8141cc91
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 17:48:03.2850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IwJkmUo9WFifsls5PKb8nRGzqVQS1awIWQmck3LlbL8DawuIr/p2wNss9sEpR/wP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR01MB2166
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/18/2022 12:30 PM, Enzo Matsumiya wrote:
> On 08/18, Steve French wrote:
>> I was looking at the mount.cifs man page, which is missing
>> documentation for some mount options, and also could be made less
>> confusing by moving some of the less commonly needed mount options.

"Some" mount options?!? I counted at least 100 when I last looked
at fs_context.c ...

That said, don't let me deter you! It's a good plan.

Tom.

>> Are there good examples (of better written man pages) that we could
>> borrow ideas for a a breakdown by section, etc. ?
> 
> I keep referring to nvme stuff, whether it's code or documentation. I
> think they do a pretty good job in making things clear.
> 
> cf.: man 1 nvme, (e.g.) man 1 nvme-connect, drivers/nvme/*
> 
> HTH
> 
>> -- 
>> Thanks,
>>
>> Steve
> 
> Cheers,
> 
> Enzo
> 
