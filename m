Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70778C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Jul 2022 15:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiGAPbB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Jul 2022 11:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiGAPa7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Jul 2022 11:30:59 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D8A2BB20
        for <linux-cifs@vger.kernel.org>; Fri,  1 Jul 2022 08:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeHXMyTj3vAQnDK84lNR3lGzJCD/qs3hRho2SJ+11qniWmJh8Vd7hKcxoLrjtW5eZeIojR12jggRSJlS9HPPkSb7dUxA34KymUoNJUsr8U26pU83+1BBEGUtIMlfMhr267YIxrPLIWfQcasKrmV+6jTeFZywZ1WvziDNugBzrODHbTQy63Jrp8hNR8/EVJfifExKZXHWss/ZE8SQtXV+Nhm8knQNR/zl0xViz8G7fxiOxIj6xqggP1ZNHwPT8EpBUCHXdT7cJmro0Mg85ok6cPVz0FZXbLmWmUkm6yiq3GAMFbpFIcqMPcuLsSlIdqjGYs/oy1KrddPC9d9MFjEczg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQADyB79fFDCKG4y3MSYecxQvpmaEZ0SPVXWGKNPdX0=;
 b=CBufwaLT/KMan7cQytPMP5Tf4vzQF/wNM5WwBtckTmKHveHZYXZ+Ri8Q/C3vbYUeMHXhisFzPBBq7FgpjzyoZ9+BAjz52TGMF+s9BrNO67e7lpBUb6ku55yYkXnFnZLmPD0OdCV+u/qHK2YsQpJJsJIEVdhxPlrHPxlonlQDoRUoL30foTVSuC1E0sQUTEdXEGfwKoxd6FNv2i5l4ptnbjYxGjoH31oEHNpA1d65Xgka8k6+482r9QMp3QD/9YFgeOwWmPi6/hH4VYbvru+CKfkOQzQA6WodxQDl6gtwkHLqvehfhTkk4hCCZimFCZnJNYKleVKmhhQqxIGwDQjkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6122.prod.exchangelabs.com (2603:10b6:806:da::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5395.15; Fri, 1 Jul 2022 15:30:57 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e1f2:b518:f502:3cac]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::e1f2:b518:f502:3cac%4]) with mapi id 15.20.5395.014; Fri, 1 Jul 2022
 15:30:56 +0000
Message-ID: <35b03fb9-1500-865f-f67a-c24817531ca1@talpey.com>
Date:   Fri, 1 Jul 2022 11:30:54 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] cifs: Add mount parameter to control deferred close
 timeout
Content-Language: en-US
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        rohiths msft <rohiths.msft@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <CAGypqWyKzYL+MKwsmStP=brsxYCE9MNq=2o-8QoywFX4oPSdTw@mail.gmail.com>
 <75e51680-f6b1-d83e-0832-bc384b7157be@talpey.com>
 <CANT5p=rhUvsrveJDA+AsJ6=j=sWC97LiTH+HcTFxbqRtFKqkAw@mail.gmail.com>
 <CAN05THSaD5JbdkjfEzQDtNOL-M+ZQhm-yrz6n1ystJKXOsJArw@mail.gmail.com>
 <CANT5p=pXXfou2H0pTX+yorFTkJ-AryhhDeaAuVzxoDb4-=U69Q@mail.gmail.com>
 <CAN05THTyNW6mw=arsDd5PCNvX_PwV2xijghe_MDFvbz_hMC-Nw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAN05THTyNW6mw=arsDd5PCNvX_PwV2xijghe_MDFvbz_hMC-Nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9488ab8a-be4f-4e0d-50bc-08da5b76b12b
X-MS-TrafficTypeDiagnostic: SA0PR01MB6122:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVSzQX8U0ckU0D38SC1JmvLebztnQ3a3g+ILw3dXh9JrvJNAhmxry1caDJhpWw9YZ75jJJLwvRgff+LhfwKq2TTEXmQ3kVHGpD/h6h751yGx8RwJLUUetwRVacfZYlVJnWzA8tJ/dRPWM68Ke9Ln8clkpLQJJX6TrOQaz7iEFqfJ6ko2NocDTqqieeYT60gK7yjm+XOPkCt4VsTSzeGRHUC8HutocTfSFQjetvC61lFWQGsLdDIBD4H858ZddL6yshqfv/VcXhLJaLRUyeaBWmEgrqt5SmI7kKbRQfsvgfeTMW86bR8jcMGh6Q+2XloW+kD0GYQBYry31NRCC+B6n2WW8GmCPtCfL8RS5NNG2npBAhgntjkVVDp8aQbh5MazzOV9tzqZDiWB0UWeMpmKacillgvM8vSuevDjVCzIBB6DONyh8wTlyOVQpCge9nCtPCGtg7ftqNj1fI0rfFGyuls/iqdgV4LsyZtd7YpKsKDfWokiyl351fTbmKJB6A/MmIbWuGULDTibBgg3KpIZjt9+cFyfgVizOmTC0sZZbdqUw7pyJ2RO5oiv3/UjEmGT2Z0MNVizJDJG/HB8Z+at8wIprEGX/N5QS6n7P3ftBxbldcB8SGmaJYfqQbsPVd8KhZOW6Sb774Oe6L3HvHC9+r1fgzNrVQbiUJLyIckbOl1ucNIUokGgtbfH5z8oIi5FlgkjEwHnV7cK6OO6B0EA+h7/u1spENeOavQC/SYZM2BhmA4uPt1v7SCndQ+UCLhZsKjO3dpNF325AoceowY7ZGIhJ/rc54u1qdSIL1QsVkx1kyFCgQpxIEBXa/xzojaurFl98WzHeMUxwMo0OWpOrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(366004)(39830400003)(136003)(66476007)(38350700002)(36756003)(6486002)(2906002)(38100700002)(41300700001)(31696002)(66946007)(54906003)(83380400001)(110136005)(31686004)(316002)(478600001)(5660300002)(186003)(8936002)(2616005)(6512007)(52116002)(26005)(66556008)(4326008)(6506007)(53546011)(86362001)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTdkZnJSVmNQc09QT2c3UjJOKzUrOXkxOGVrYmFEckgrU2RoVUtGQ1hreWlL?=
 =?utf-8?B?V1JGOS9iSXF3aXVaa1B5dnh6ZDNDaUNiYS9SUTVxYUtqU3BLSDA3dEs2Wk4v?=
 =?utf-8?B?QmliNnRxTDdDTHkrdnk0RnhrUEg0M3dVMEdPS25vcGtnK3pQUWpuOUp5REFE?=
 =?utf-8?B?WjRTQ21yclQwK0ZZd2VPMUZnMXZJZnhGNVMvUHAvUGxsSDhwcTZ6QWtCU3Nv?=
 =?utf-8?B?dzdoaWtkSzQ3WklpRk1Wb3ZBaXQzRy9nNHY4dFoxb3hVYUpPWEk2bGN0WSt4?=
 =?utf-8?B?TmlwK256WHR1eVdzNlZmWDdFd05FOUhkeVlWS0w3UTN2YmxSY1NKeEczWEVI?=
 =?utf-8?B?RFpISVZkK3YyNzY0c0puWmErd3ZtRktkL2NkRThZQnJBUmpnZkxudkFEUE1G?=
 =?utf-8?B?bmtuSUhmcXp3TFlJNFUvMS84Zjk4NVpodzlxejhmR0FNZldQRHIzd3ZpcnJm?=
 =?utf-8?B?dzMydGl5Lzk4enoycEcwcnBsZ0pYRHYzQmhpMTcreXJhZS9JVEFPb0I4S1Za?=
 =?utf-8?B?TWdMV3hRaTJmNVZPbDBSempHQnVDSVRScVEwRmx2b2I5Ym91b2xob3Y1Uzdx?=
 =?utf-8?B?ejQ1NitRMTNtTHJZekIzR05ZVlgyNEVKNHNpZ2VPZkp6TWprbjhzcWZ0REhr?=
 =?utf-8?B?dmJFMDF1WE1NZk1yVk00MnV2NjdxQVFTNCtQemNrY1RDbzkzSVVKNEVJODlt?=
 =?utf-8?B?Vng1d2ZRYnN3Mk5RVG5ZZXJtRm1EeFRQYThNTlROaTRSZXQxazZpcEZZaHFU?=
 =?utf-8?B?Z2NOd2c0eWg0SFZzRWF4ZEpTaEpOK0dMZEswSVdqWE5MaWVVZHh3S29lTDRa?=
 =?utf-8?B?OXI2V3E4QzA2cEtaWldQM3kyWnp3a09nUkxQamJ2dU1pcUpBTDN2Y0tBSHU2?=
 =?utf-8?B?MkMyTXRWSTd0eXo5NTZ5aVFZQnBUckUvZUI2TnpMVkRGc3Z2eU41dW1XNU8r?=
 =?utf-8?B?RFNSRWFpVnkzdkJsa0p4OTFTTkhBRmpZSVZvNndzNkxOeXk0UmZKYU1ScFp0?=
 =?utf-8?B?cytBRmttZXBEWWpQb0tPUnBYTWVwM2xCaStSVWxXM1YvcmxweW5XMXVPeWpy?=
 =?utf-8?B?R1hsUXVUa0xrdVV1c1VUVkU4RzdhVTAzTStpN0ZIMkVmODVrQ2xoSEVxOEdC?=
 =?utf-8?B?M0U1M29mVk95emZsTnUrN1dpb2s4ZTZSTk5lMVFvcnRFd01Nd2d1RHQyYi9p?=
 =?utf-8?B?QzhTQ1pHR0RaRWlleFlSalpsUUlOTmVOeFFWVDAxazlVTjhkNCt0amk2S0Ru?=
 =?utf-8?B?UGtBTlFKQ3A1ME5BVDllQy9pbDJRMGlndEYySWZtZE50RzZoem50NXI4YUpl?=
 =?utf-8?B?YmltN1YvcHVqK3hPc055UnVCMkp0OU9sZ25uZDdWWXJ2aEcvMTVJZEMzUDdk?=
 =?utf-8?B?dDVHakh1cUhGUk1KbW4xWGtXTkNEMGsvNnBqaWM2OVl4RGFPNUlDWHRYVDZh?=
 =?utf-8?B?WEdFOENBR1RERlJHZHQ3cmJ1eURqNzI4STRIL3U5NkZUM2FRTlFBT2FCakV4?=
 =?utf-8?B?U21uTGNMMXNpamk2ays4WjMySFFVQWx2WW82eDBNV0VDNEd5VmlTTmZybTJa?=
 =?utf-8?B?RDByQmFDNjFiZXZpUVFDQjd0cHhzVTFKVHZUVnVqUUJBbWRtN2FyMkNHRmpT?=
 =?utf-8?B?MVZPeTE3N2U0Q3hPc2xjbytzUFNXQytwSmpEQXlFaGovTTBPVnB0TzRHcVlp?=
 =?utf-8?B?U2RDc1FGbW5vU1pmOUM4MVJLVDhDK0p6S0p2cVcxclBIOTRMeVpQZXVkeU1G?=
 =?utf-8?B?STJnd0dVdXFtRmtuSGtveHdKQTlTYmMwL1cxSU9ibmhISUUzaDROOXJNTjBP?=
 =?utf-8?B?bmtMZk9Uams0S1ZVMzAya2V3RE95OGoxVnhmR0tjYWJOOGZWU21jWGNhSWxM?=
 =?utf-8?B?KzNDWXAyWEEzeFBWVDlEMHBIVEpxOFFzVm5sZlg2L2x3Lyt5MW5kT2puZUg4?=
 =?utf-8?B?RmtlTWM1SnpUYmNEU210MXZrY2RJVklvK21NRFlHM2FWUVMyaG5PZmhUQ3J2?=
 =?utf-8?B?QUViRFNwRFQraGNaa2tVbjA4aGVNMXdFakVBMjRrYWN6NVZENHZZQXBtcW9W?=
 =?utf-8?B?ZHgvUVkzWWtxeEprSWpGMEZVQUpNMnZ4bnRzRTlnbklxSjBKN2lEYmFFN1JO?=
 =?utf-8?Q?p0zY=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9488ab8a-be4f-4e0d-50bc-08da5b76b12b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2022 15:30:56.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pq/xERZxlf5omKDdgGGo4MU2P7czLoHRXYH2PiRhTaVhAAGuAEKmc45TMVN88e31
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6122
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 7/1/2022 7:00 AM, ronnie sahlberg wrote:
> On Fri, 1 Jul 2022 at 18:44, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>
>> On Fri, Jul 1, 2022 at 12:07 PM ronnie sahlberg
>> <ronniesahlberg@gmail.com> wrote:
>>>
>>> On Fri, 1 Jul 2022 at 16:03, Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>
>>>> On Fri, Jul 1, 2022 at 3:23 AM Tom Talpey <tom@talpey.com> wrote:
>>>>>
>>>>> Is there a justification for why this is necessary?
>>>>>
>>>>> When and how are admins expected to use it, and with what values?
>>>>>
>>>>
>>>> Hi Tom,
>>>>
>>>> This came up specifically when a customer reported an issue with lease break.
>>>> We wanted to rule out (or confirm) if deferred close is playing any
>>>> part in this by disabling it.
>>>> However, to disable it today, we will need to set acregmax to 0, which
>>>> will also disable attribute caching.
>>>>
>>>> So Bharath now submitted a patch for this to be able to tune this
>>>> parameter separately.
>>>
>>> Ok,  will the option be removed later once the investigation is done?
>>> We shouldn't add options that are difficult/impossible to use
>>> correctly by normal users.
>> We didn't intend to. We thought that this could be a useful tunable
>> parameter that the basic users need not even worry about, but advanced
>> users / developers could suggest changing it to tune / troubleshoot
>> specific scenarios.
> 
> If it is just for developers needing it to debug specific issues  it
> should absolutely not be a mount option in upstream.
> Maybe have it as a /proc/fs/cifs/Debug thing or just provide custom
> builds for the customer when debugging specific issues.

Absolutely agree. Upstream isn't a developer sandbox.

I'll point out that this patch:
1) Doesn't change any behavior as-is
2) Doesn't give any guidance on values
3) Doesn't update the userspace mount command
4) Doesn't ever go away because it changes the ABI
5) Increases the total number of cifs.ko mount options to 102.

I'm not sure about that last one. It might be 103.

> Once they become mount options they need to be documented, what they
> do and why you would use them and exactly how to determine what to set
> them to.
> 
> 
> 
>>>
>>>
>>>>
>>>>> On 6/29/2022 4:26 AM, Bharath SM wrote:
>>>>>> Adding a new mount parameter to specifically control timeout for deferred close.
>>>>
>>>>
>>>>
>>>> --
>>>> Regards,
>>>> Shyam
>>
>>
>>
>> --
>> Regards,
>> Shyam
> 
