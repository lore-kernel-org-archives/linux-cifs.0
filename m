Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D11A7C00144
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Aug 2022 15:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiHAPtI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Aug 2022 11:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiHAPtI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Aug 2022 11:49:08 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220723DBF1
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 08:49:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRpZOvXXMjiCO6EeK/ZQ1nlhrpH6RalooHfDmprd0Hv/SWApZECycIbz2gAmG9yvoJBaPNK25ucbbkK+wDw1P3CNybgr3CvzEY97dJWfbn9QiBpO3JRsEulqaFOzPLnMefLtqUCdXsWmDyX/XSUl08Hku/SOcEpoIpKakLfEXCGRvmXdXagOcXH/7gC1XfEkZIa/ihw4p2DtHUDaH2CTuBY5xbBaw9dZnAC6WA822LhcsPgzs3XnxDSG8DnTJCG8eTmNsNThLXrwALd1JVJEdPjDZHfjQjBPw/wu9T9gp4Nx5PPVZKc6yzYPgy728z64vft3RiUn3PO4OIm6Ng+Img==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FwnNxj8AKwHNWNEdKymo1UScYuq7NJQlzJCuyvDO338=;
 b=ZjMZc4nL4iDp125qP3IhS5KvrkzTVpcMOF8rMl8qPh3h2cYKYw8plR3ZUyR6BXNEkhgm0YSIP7BLGGxAMDD41t1CvN7iyygak3+7oLgSQzMu+8/QQ9AnSwvoN9Qps9cW2LkUhuJbwDpMF1KAAZMfloyr9VlNfRfaRCbHCR167Q/XdnVD9t6JFQxVpq6EHRCxIUVxRjpKEOsVdHZKUrTmsxLnHS4pt1iJRtFDvH3wJFDHNJw4Podxgv0qkfO3tsu6J25ry7E0jwYKHdZu93f5DIekuiBd8PWFg/hHDmlgrDU6YiEp54A32nIR/afUtDN7xHj2sdH3KqOahO++HLzA2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB3866.prod.exchangelabs.com (2603:10b6:5:83::23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5482.14; Mon, 1 Aug 2022 15:49:04 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 15:49:04 +0000
Message-ID: <f8632ab0-ddc4-ff8e-1bd1-3088cf05eb5c@talpey.com>
Date:   Mon, 1 Aug 2022 11:49:02 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [WIP PATCH][CIFS] move legacy cifs (smb1) code to legacy ifdef
 and do not include in build when legacy disabled
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvX3UT0q50rmMb-WSt6eSxh1i_gcmPdDBW1x1Qn6ppDNg@mail.gmail.com>
 <CAN05THRJTvA7huZjuW-tCPZjk6Nq_8EasjP6kQ0BGMBxBCtgqg@mail.gmail.com>
 <20220801121507.zpcnz55jj2qre3kh@cyberdelia>
 <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220801123930.ltet3tadtdlf6hpq@cyberdelia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:208:329::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04c217ce-79ee-4fc2-941c-08da73d55c7a
X-MS-TrafficTypeDiagnostic: DM6PR01MB3866:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +bCy4qrXOQGuseytY77t8HF3nkoYmmeEE4v05iAnS0WSwbiPjsx0qD61h8LX7g6L2MnU++EcDny5VochwKz7b83LmtYuLoEKw8oKF5A8lZ93JLX/IWwsgBc5BEMzxxh05+ushHPQBIFQsbdZyzFYsqPg/5cjr7x6OGPpmS7NDVuR15MQp59Dl/S2Miqua0vgObpOCoa2Wc07xqunAsFxRlOPHK7jKyK8NeUqOd7LSn1/eOFaj9pDLZiiRJVTavwRqx0PJEqrHpzB43/F+uedfNWIYCPCjRmwnyLramMMgSD1yd6pwsFJssDdGY1/H5OMHoQY1jn6+QvpVVuyPA8lFD1BIvssfW5braKNeQ1OTGnCAIDdUj+7kxYk49IC6p6aYe9gdXGg87Wd13iBqf1sc+ubfpGaAFjH47jnU6weA3/Lhtq/Ox3JijJZqAq2qwwTJMANNgpF1Q5aP1423kStnSDhVxqLcmL2HZKOYY2pEgVZbpZ9i0EA1AsfyDPxoh5k4Eno8fWUb/7nT5sZ5ctuapy4FS/JUI5c1f7OQDwAjFUD3n9acV3amhwxFManRpyqa8RzyaHe9wtUaCgjfVu7ao2W3uiNSWhYY+ByhxazK4lhNIQ0fDECWFAGbdD5FJHo3rUfAY/FJvZVRkF8EIqBWUz0FI58Bu42e/vaFIaznvSyWl0/+6su55GbinNuWXSWbt24pJtddJlT3bGgGgTGIUfjD+nMDaKfxaA9Nc2OgYI0rJc/WJvVxIig/ZFBt14wM+YfsyY8l5zDiBlQnzO5KZ8UyztzSeqZuOBLPynDvY5+vb7DAO+KqNighWCOz4YRUiP7bng60l8i8Q91a5j+mu+VjvpC8zi9dfKUP8K3a1g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(39830400003)(136003)(366004)(346002)(5660300002)(110136005)(478600001)(316002)(66556008)(31696002)(66946007)(31686004)(6486002)(966005)(36756003)(66476007)(8936002)(4326008)(8676002)(4744005)(2906002)(41300700001)(26005)(52116002)(53546011)(186003)(2616005)(6506007)(6512007)(83380400001)(86362001)(38350700002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUI0MVJyVVZIeWZJMGI3NERySExiZE1ROC9sWlhDcmg5cHdnT0xFd0VBUmor?=
 =?utf-8?B?U25MU1g4V1dWZHQ0ZGtFMWJOZXJTKzlkZFFRNXdiZ1ljbStVYWd6ZHBUdlZL?=
 =?utf-8?B?SkNLamNlazdsWXU4aFlxQnV1R212RFlCWEk4MzI1cFhRTFJjcXZSczBHSW5U?=
 =?utf-8?B?T0RGTFJ3cHM2eGI1UHhDRm1rRWk0L2VVTzIvbUZ0K29mRHVQNnBsRFV3RmZ2?=
 =?utf-8?B?S2NrMWhjdVo1cHRMaUdqdW82R2h5ZDlrSHp2VzlvV2NJNG5ndVQ5YnBIOTJ4?=
 =?utf-8?B?MjBnRTlmUGF6bFRmVk1qdTBYU1RJL0o3cTZQOXR2dEpRYVZRdzlncm8xVERH?=
 =?utf-8?B?QVl1QU16TU9OWXNrOGtaQ0lmMzBURzNtaWprUmtDMWVPTnk5cEdXS0M4S2tv?=
 =?utf-8?B?S0xDemZ0OHpycjV6Q1JpTGFtWWJyNG5vUjg3TzYxNWFOSEtsSzE3M3Q1MVNS?=
 =?utf-8?B?V2dCR2JmYmZHRWlnNGRNby8vS0tKQU9sdUJOL3VOUHNZTXVHNk1UZU9YSEdT?=
 =?utf-8?B?ampML2l1NUswSi9ITGF0ZVpBRld6QmhyWnd4MkhITFhqcHVmQUpTNlg2Tmxp?=
 =?utf-8?B?QUVBL251RlRHS2Z3cGhmakIxQnBDS2YzQ1RreDk0Tm44dEcxZEJUR3N5a0th?=
 =?utf-8?B?S1FBb3hqMGhvZFJkY0o2VXlqUThxLytXdytuN2RBM1g5U0c4T0MrL08wQTlT?=
 =?utf-8?B?SmZsdi8vaWVneG84QTZQTHNXVFZVWUl0UGw5cjJNSkxRdzJOUTFJVDBpWlYv?=
 =?utf-8?B?cXJFbFlCaGwzR2JndVdZSGlHV292RXVOdGFHaWdqNm9ZbmZrQzNnVERQdUw4?=
 =?utf-8?B?SjVnMVVrM0MwSTZvTWpRTlphZXc4bFYyTk9iaURxMWdqMnlCaWhHd3h4R1Q3?=
 =?utf-8?B?YXo2YXdDTGhrUDFzV1lpbVp2YUFqbG1CNDA3QVRDRkh1Nk1DOXpydWhobVFE?=
 =?utf-8?B?UnVDZURWSmt0UjcvT29zcStPWENyWXdFMkhlQlVDVFZZcHNqcVdTMjJ4aGlY?=
 =?utf-8?B?VHpnd0xrbDZuUk1pbWJ5ZzdsSlYzOEMzelgvaGJyVmhhYlVjb2JnbGdaMmlx?=
 =?utf-8?B?TnZobnpRdWUyR3YvSEJMSGdXTVN4aW43ZWZQS043akRQVUlWR2t1ZUYwalBX?=
 =?utf-8?B?WjY4M3NWVDc5Q2RxTDBYZ3JJV2p1U2ZpbzhmU3ZlZm9BSUJaWjc2bFg4Z0x1?=
 =?utf-8?B?bWlLZEpuMHBadGQxRmFuUTZWcG9zeU9EamJ3MTF4YXhRYnUzNFFtUEVrQklU?=
 =?utf-8?B?azhmUW9sR2p0WlY4RnB2NFhrOWlmVFlSdkoxNEFYdlVWa0swMEhTczUweFph?=
 =?utf-8?B?STRPK2hPbEdlRWh0c0xuZFdkVTVIRDVWR25XUmRwNmwwNzBYRjJOVDAyZVda?=
 =?utf-8?B?OGExVDRXTnNzMmdaTUtzZ3VDRkZkY1V2cDFzdW5tZjFmNXR3cWtiRUNEbWpq?=
 =?utf-8?B?M0ltdmM4aHNRTGRXeFZoMXM3TnZYSzlwemE5VEpmTnlDQkU5d3FLUWFGSUxh?=
 =?utf-8?B?bnFBVUtIUkduTWVxd0Z3bVYza0FyRGhZNHJZMU9ldnNFWDVzOEh6TDQ2YWtN?=
 =?utf-8?B?MmMySld4N3UwZ3pZRE9ybzB0YmIwUTRFYURjcTFIOXMxWnY3aTNwM0RRc1BO?=
 =?utf-8?B?SmtiU2E2ekI5dXN5OWIvY0UzZXY3S2pWZEhaTWExZnZPV2ZiVUZlY2Z2cUVk?=
 =?utf-8?B?UTNiRDRib0NJdk5vWVNDSHlSRlJCN1dJVld4enNpZDlhS1k1MTlhTjdoMk5q?=
 =?utf-8?B?WFBsdWNRQmtlSFRyR3Urc05ZSWJjMEZrRG05akJKMi9iUWowQXFkQlNtaVdK?=
 =?utf-8?B?bDhadjdHdTliT1V6M3FFTVhzcm8xVWFUaHU5aDZXNXJzNmdXUVp1YWY0L2wz?=
 =?utf-8?B?aDhab1l4NWR2dVY3bG13a1A5SXUzRUhCYjdzY0FzRit3QXg5RXNpeDViald0?=
 =?utf-8?B?MEFYcTFGRzhtcUJJNTlvTm1kclFhRWI1NFhabTA1NnRpWEFJRGUyUGdKQ3pB?=
 =?utf-8?B?TFpMZDllRXIwYTJjTC9vZkhHb2R2UmZqZFlUVVVEQXJHN0NCUnNFbFdKc2JO?=
 =?utf-8?B?QldDUDNyRVFpNWpSUlVkb2owci91VkkvOTlYb283OVVEcmZoY3JuMk1mdzN2?=
 =?utf-8?Q?9PFU=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c217ce-79ee-4fc2-941c-08da73d55c7a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 15:49:04.4674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1NqRJq3u0iW2pA4ygC7DCcpHHsAucVkBzLqRQZ766cWVY/PF7l3tnwGQdiFrT1BA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3866
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think a big chunk of cifsfs.c, and a boatload of module params,
can be similarly conditionalized.

On 8/1/2022 8:39 AM, Enzo Matsumiya wrote:
> On 08/01, Enzo Matsumiya wrote:
>> On 08/01, ronnie sahlberg wrote:
>>> Small nit : in cifssmb.c  why comment out smb2proto.h,  just delete 
>>> the line.
>>
>> Agreed.
>>
>> @Steve also, why ifdef everything instead of putting everything in a
>> "smb1" dir and just use Kconfig to build that dir? IOW like I did in in
>> my branch https://github.com/ematsumiya/linux/commits/refactor
> 
> Just to be clear on the advantages of this: clean code (reduce those
> ifdefs by a lot), move shared code to module top-level and fixes to
> those code gets higher priority to the newer protocol versions, proper
> isolation of smb1 code (separate dir) instead of a "virtual" one (ifdefs),
> all that while we can also maintain history if using "git mv" to move
> SMB1 specific files.
> 
