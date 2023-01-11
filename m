Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 072D7C5479D
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 17:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjAKRG4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 12:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235447AbjAKRGc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 12:06:32 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2351192AE
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 09:04:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HEBfoiKLbQf5YkGtKfK2/gpEcFqGqzHtk5mn5o/dqWphsncYfAppR9sTSK/fmjMBQlC+MCFXkD2tuMks99igEPnOOf7fpt26du2CVSRcoXUJVBNZJJi0YYZ9l8CSzFyEo+FvN++5YIzhD4QK2BuxQRwJ/iBEbGnlg8vTVfmi8EU25AfEEHkgRotfqgmpTlRCyO0W/6a2YcXDgh8RFHyZfxf848NyjQgA6ldyC9iWKX6YxOgK77eKVdby6trjkYnfHy70BqAV1nhk/26K53jzPSExpUJWpIhXmYwjMjwOEbDKWvX2VtvvJrthW3EtrvEkCL4ERx5XX+vdr4JUP7vQMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNGBxBD5+wzO2OlRSIIu7A3YCkNFJ4Y1Yf+hNPEUzac=;
 b=H0fbq4+5LFtllg4+hv8wgP4f1+jmeCjz1J83LIe6QztZ03TScUQlXZ5La83XeqbYkxNec5srSrCUDyeUaA9MdA0L669qCpoeYfLxbzG/ifcKjDsLtSic1pnxr6NW/XSLYPLDqrRqFGWfpdKK5r8G3dBrZYxfQqd0mJ3Q2HPiycRxl1uvLpea8tFlhpEfiDbC05Kozj4jfyhBcYZBN/AJPz0D6Lmpfyk3hInWhx7gk+d7iNhq6EUKIY7sKHreSFzG8oppvSlotjtB37sBoKRXHfJngWtXo7RcckRhAdyq+VSAQ0SvKH4+ZGRa+lx/RxZLxzG89j67igltmkt9JQ0j+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB3936.prod.exchangelabs.com (2603:10b6:805:22::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 17:04:28 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 17:04:28 +0000
Message-ID: <07befe2d-477a-5ff3-0eb5-93504ef1b09f@talpey.com>
Date:   Wed, 11 Jan 2023 12:04:26 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Fix posix 311 symlink creation mode
Content-Language: en-US
To:     Volker.Lendecke@sernet.de, Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org
References: <Y76gvH9ADxSgAxSw@sernet.de>
 <CAH2r5muTjUB7LBevcKE6oxWHPrm6yxY7H5jRuECMLbebQyRXpg@mail.gmail.com>
 <Y77pJ5LqbeU5uj8N@sernet.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <Y77pJ5LqbeU5uj8N@sernet.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0007.namprd06.prod.outlook.com
 (2603:10b6:208:23d::12) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB3936:EE_
X-MS-Office365-Filtering-Correlation-Id: 94957d2d-aeeb-4534-d35d-08daf3f5e612
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2CJA6sutzVdaiyv3N2ydjYHQssWEuatSdVtvFFJtXNhc6unfOQp0eP8HeSEYI+AqLzBvz752xQ51T3xqysq0mMSufro3KAgD0c7FiN5iNO0Bv9ZWfwDlX2+RUo9V14EZRwgrPaRYLLHe66iOZnXQU2zR7KLuS6ACFvjxtvgUcb94DUdBoP3IpT8nAkgJXuz+FpYuJewiRgO/RZxaQU13yzEAVL8H6UmvQc1Z/4f1q2+UjtTIu0sfYpu2CQ4b8hBP96kiOKRNLE4hLwFLPvq0Dvzrvp0lpaI5wef4AspURD447T1fQEaJJKsi9RAtP1z3sG6Y0aJHMRgZQliGrTGw69oM56OKAeKHHI06076rbsvXLs/1UYxkDK7s23/bLddopUMSbfmDQd8yR4evg5rHhVpPKOKSca3ZtOXAIvlNGwrHL0ye3RVEjZJZZbTdwmWGvUslUSACIfKl0/6mHcLj3qmUKSORKR4V2jgn5oo0/PUc7HuhbxKKVsLlbLQqMAvpgZeqgwWDm6qeZy/Sx2NaM0+uxk0puSqf+py75CdigGWNM5dV7NQRLRU6IjVXIcvVMVSyjFrnXloQRQkA4aWqAJtRa2EWJf1XxfunIV35cS7WuKFShBfij+JkwY5d1ptJGbhGmNnYhLMHJWifs4FZlwjDLLbJQZBFflaexvlSHCyWnU8OSUcCNMMFrVZNzuqtgPjzQw7a4e/Dx/DZeOt8Nu0PiX+PkSVOCwfWkKXLr4k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39830400003)(376002)(346002)(136003)(451199015)(66556008)(41300700001)(31686004)(6916009)(66476007)(66946007)(8676002)(4326008)(5660300002)(4744005)(8936002)(316002)(2906002)(86362001)(38100700002)(36756003)(478600001)(6486002)(52116002)(38350700002)(6512007)(186003)(31696002)(53546011)(26005)(6506007)(83380400001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZStGZWhodTB0cytDT29VTUwwUE42RWZGbVR2VWFkS1dYay8vbzlkaWpLTkFD?=
 =?utf-8?B?V0hUNWNzbkQ3STA1bEZiSitsTi9DYkF0OVY3ajBaMVVzYTZTZENPM216a1BF?=
 =?utf-8?B?NmEyU1M0Mk5xMlZpc24xQWFQWFVDUitxTUtDeHdGeEJFK2s0S1l0MnhxTlNO?=
 =?utf-8?B?MTU4bWpTRUIvS2kxQ0k5OHRmUzc0SU1tNm8rWXRWNzh5dW85K2pmZ2x5dXdX?=
 =?utf-8?B?VEZ3eVRrMzRuOENXUWMvbm15MUNmNjBqL3VGZktXYnZuSUJpUzBva2xJaUdk?=
 =?utf-8?B?Q25oSWtMWEQwaFF1T3hOMm5QdmZDakdXL3RWU0tjWjduaW1xdEVQWHc0RElK?=
 =?utf-8?B?cCtvM083ZC9HZ2gvZVpodkR2dEY2V0pJWWN3R2FIcnJHWUNkTjB0bXRKblpG?=
 =?utf-8?B?U0htMFJvamdWK2YyUDQrQUlpcFhjZkxnL0I3TnlNZy9mR2ZVV01pRTNJWFFS?=
 =?utf-8?B?TW9FZEV1UUg1QklSMHdYTS9HQ2ZRU2VCOGVXY015anl3dUR0aXRHZFV6aDZV?=
 =?utf-8?B?NXMyNFk4Z2lUVWdQeGMrdUMrOG5xeXhFaFRDdWJuNDdFRkpLV3EyeUc4VzJ4?=
 =?utf-8?B?WCtKeFVHcVY2VVVZMnA2MmdIdm5ZU0VlK1lJV1dPR2lLQlRJclcrSGE1a1NS?=
 =?utf-8?B?SnhLQXlnU2NqMFpWNTZsbEVmWHFzTG45clQ2dXhMMEJWSkVvN0VyY2lCV0Rs?=
 =?utf-8?B?VUJ1dUw2MlJ5SG1CUjFiMnN2WURxalNSK1FEWUNpMjhydmJCY3FOdWkxWjhr?=
 =?utf-8?B?S0VyMlhtS25jeDl4R01sK2Jydy9DQmtXUkRBbjJWanVTaHZqdWQrU3RwbG1V?=
 =?utf-8?B?cFlzcWpRTjhjTjU1RkR4bjByWUl0aHBwZVZDQ09zaXZwSFBNTG1sWkg4R05t?=
 =?utf-8?B?eC81ZHhhekhCeWZSenhlNTQwcUFDbzNNZWl1THRBZWcrZ3ZOZlUyb3pLVTNo?=
 =?utf-8?B?OXEwL1hWbElNT1pVTkMxc05IK2NtTXBLcGlYb0xmTUoyVXZneitnaE1xVFRK?=
 =?utf-8?B?dUpkdDNGZFVOd1ZaUE9UM0RzTlJqS2RZREtYWDlVaFVzL2ZsVEtyRDVVQ3R5?=
 =?utf-8?B?Y1NvNGt3UUU1ZnJJdG8rejM0QnpIN2t4ZGNxdWVXU1dBUWlSWk54QTF2SS91?=
 =?utf-8?B?Um1rYXFJdVZJb0xpOVRYUjgxT0JzenNMc2NXWWhNM2tvVnZwRjNqbi9LbzFO?=
 =?utf-8?B?Q3NCNUM5T0dHcmkwVklyRGsxQndkL1dabHFPVCt6L0NqcDJXOWpxYkFpMk1L?=
 =?utf-8?B?b3VBUlBqeTFaL3dBaTRydHdQUkZZdlhLVEtVYXRNVmRLSDZ3Ym15UXd1NEF6?=
 =?utf-8?B?V05XbTVQREI1VnNWV2VJK3pVb0x4K0FuTUNNQWk4WDdPWDFNYkhGMis0d2Nw?=
 =?utf-8?B?M0FQWllzZ1B6ekFCS2c5MmJZMHBlanFjUk41cGR6dHJ5UklWUUJxV1B3S2xu?=
 =?utf-8?B?NHZ3QkN5M25iY1lyTk4vc05kMUdJczZsajNQU1Q5TVRiT3VrcG4xMWplbEZK?=
 =?utf-8?B?aTZNYkVKODl2bzh0WEpPcC9POWVkSGljZ2hzYUdrWkZmRjZGYzJSbko5OGJM?=
 =?utf-8?B?a01HZyt6YzdVQnpYRFpieGsrWjZvY1ptTU0xWGZEbmVEYUZyd1hzaE1mTVBM?=
 =?utf-8?B?Qis2ZmlYWFkyUGFHRXdJRllDZXRxVk5rRnYyNGpYRWJLelk0dUNrVHpwNWMw?=
 =?utf-8?B?SWRWSHVzV1lXOFpWcSt6Uk5UZEFRemlnRHowRXpuc00yc1RxVSsyUFkxVXVE?=
 =?utf-8?B?cGFrdWs4NXQwMnoyQ2dsOWNuTXJ0M29BcDE0Y3lSWnl3V2VmWTF6U3VQUUpk?=
 =?utf-8?B?ajdPcHdUcmRlUFBDR1pidHkwbVNlTzBjV0ErS1F2YjQwMXFhcWptdWhJejRQ?=
 =?utf-8?B?cWNGbmFLTUw3RnJuMmZJT2w5R25RTHVaMzMxYjNYMzNVQVZNbzhUWmdkdkhD?=
 =?utf-8?B?a1VPbHNhZVpab3JOK1RXN2txM1l0Qkl3ZUxtLzIxQldBS1lXcFpWenBqTXlt?=
 =?utf-8?B?WnRQZ3lFcFF1V0dNeWpZRHQyYjNiTFJjVW1MRlRscEE0cVZFN0lTQnVod2R3?=
 =?utf-8?B?SjhtSEw1OExpb2RZVExhREp2UEp4RHNldDlmMC9nUkRPNFk0MU1CazFBYzBT?=
 =?utf-8?Q?De7XGQR+KLhBMTj8P5LgsNjOz?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94957d2d-aeeb-4534-d35d-08daf3f5e612
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 17:04:28.0439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlNSEDqprsT89uVcodQE2M4hvXHYkhgvOKjD3+zuYaVxjfKFLNGxl6UAdnpl3l06
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3936
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/11/2023 11:51 AM, Volker Lendecke wrote:
> Am Wed, Jan 11, 2023 at 10:21:07AM -0600 schrieb Steve French:
>> Should this be 0777 instead of 0644?
>>
>> I noticed the man page for symlink says:
>>
>>       "On Linux, the permissions of an ordinary symbolic link are not
>>         used in any operations; the permissions are always 0777 (read,
>>         write, and execute for all user categories), and can't be
>>         changed."
> 
> I thought about that as well. If you "ls -l" such a symlink once
> created, it will show as 0777, probably the client does it
> somehow. The problem however is that if you create it with 0777
> server-side, everybody can mess with that file that the client view as
> a symlink. That's why I thought that 0644 is the best approximation.

Yeah, because this is an mfsymlink, which is really just a file with
specific contents, you might even argue 0444 is safest.

Definitely not 0777.

Tom.
