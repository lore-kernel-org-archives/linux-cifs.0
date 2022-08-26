Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B51ECAAD5
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 15:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344669AbiHZP2B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344443AbiHZP1J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 11:27:09 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1638A1EECD
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 08:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwvGPPUq/LvkM9Agn5kkG/73yzpKWDu6dm16oS0GvTJ22VwHaqjAkrjtLC+4q3cAxVEFPMAmjTIho3+as5CeBbxJvAMaZexrECIEqK2Qs8roMAxh+QSSfu9C4Fb0spqEk8sMeh4TRUoFtanfJpAiqCZpKO7joaXz1tmfyDt4Ntik63SxGyHSDgIokz3sVPDzYrWLx/sTeOIhuDhCLHU3uZmHxw8rE6WK3NFj/pnxOGTJ7uiQJW/8xj+CdIFazb/pEW8us5eOooktnLY8mvKPuHJgJ9gYpdrd/6ZY4Ro7pGn+WXsSuJmie+aelQtP1z1uPuFiCKmNGeW9XQhFjHZ81w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+8P1IkdXRoChVb8gLQ5+YwpvOrBRLvO0frVmbBeq1Q=;
 b=cAADSCZ1Z3gUKJdn2qbu1giCCqLSZkyOWereEFe7CT8W8aq1n8minqbeuryeUXm5iBz9YVAX9rRSyLChwPyEzJ3LjscDt6vWv7ZrIwa1KOEHs/hR+kbI9Wu59rZBDOrzxna3eCI2Y03u17uOHkpAB2i7QyVRJog1282mjHMcKoPwhhVDVJMd3nsvXBCdX5B57KxmQ8TUWrrPSV3Z8uLciP6sJPH3GMjyP+OLbKy/D3arFPEn5by/MyCy9h2sHQ3bBdPuhX2TMaudo7bIxuDhREGUWWs1GLmXmdXsJWHzis52SgUkL+Lf/y2EkhRvq3nqEgrZOwpJPhgOgF9OC66rAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4954.prod.exchangelabs.com (2603:10b6:5:5b::13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Fri, 26 Aug 2022 15:25:28 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Fri, 26 Aug 2022
 15:25:28 +0000
Message-ID: <884333e8-2a37-b409-1436-394fa9a289db@talpey.com>
Date:   Fri, 26 Aug 2022 11:25:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: SMB client testing wiki
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <8bcbba74-d6ce-3c40-4655-e67bf75f3b3f@talpey.com>
 <878rnb3vkw.fsf@cjr.nz>
 <CAH2r5msqW0RnNxETt=2Ec3Eq3o+RFgR+bQB6DFoCvBaNE2Hx4A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5msqW0RnNxETt=2Ec3Eq3o+RFgR+bQB6DFoCvBaNE2Hx4A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:c0::20) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eed54994-5ceb-4534-56d5-08da877734a5
X-MS-TrafficTypeDiagnostic: DM6PR01MB4954:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M1ZacrsETe8GcJ01QekLQDxfzca6WcA82Zl4dlUx4DtAz14qZrzKeGkBSKdT0Hk9EkZnq1cuzVQE1i019my5lzT+2TS/q4xwGGnEqIiEurP9MSJ0NL5X/IIiIdV/83c1SAmYW1pnY6AdV8M7QiuQIWARcBmTreWskJtnXyXX4bn3yhA3ppQMk75ftJmEZh6DnrYFyCG9L1afrrgkhHBZV8IJsEO6FwHqFi/w98jeIqOhXfMh/wZ5POxgHX7mVhvhGGtTRhqiFClWGqb9PlHZythdNvo9zoRgjYgbPxf7TqL9g5XPq9i52+4eLjIwyOWtMc2RJHGBvsX4Hik53jwJTXJYrUyXKq2yFc8ds8E2xmjbuJ5hhxNZCO5OhxM1RfdxSWGz6xgYTGpwpaqN3/jOyEOHrz7hWMDDCJvaUGSVbzgR4YH+1V3BYcSq6+mouh4Oi4a2yUlhbfd7ZoYX85LB1PpiyhP/6LY0rGrJJe+B/SpQEPJhPLL949p8gu69q5IiCBRQzN2SeviXaaQOMD5thzExjazTtQ0IysclpywoCyHkFP/KpmMB+SizIW7EB4GJgg1Tn5tYIy90/IYGveypSP8u0gkxV0mrrxMVXds1MkAb2KrrYqPJEox5LczRx6rAgFWO7ch2vIYtTgcST+4UUrIZ6dNW53VBp8gPtRNVw7B/cE7PlgcFQt6IdBHno2MOfUFzf26WSVykmeZvc8STv7nlvvhQpstFA7/2uNcBEjOcCUQoYXEi1QvwiLb5jkKoNQComl8jv/JmzNRd/LWwQQxeEaOBOx9StqGF9PBWPZM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(396003)(376002)(39830400003)(136003)(366004)(83380400001)(36756003)(186003)(478600001)(8936002)(6506007)(53546011)(6486002)(41300700001)(31686004)(26005)(2616005)(52116002)(6512007)(31696002)(66476007)(66946007)(5660300002)(2906002)(86362001)(3480700007)(66556008)(38100700002)(38350700002)(4326008)(110136005)(8676002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUpGK2VXekZGbU1GVVBMMFJMby9JNllDYWZRU0xlSEFCUHZEejl5L05kV3hH?=
 =?utf-8?B?YVd3cHJIeVZGN0VWYmg1NjErdnFuNlRFMklDcmxvMXlPbmNVNERDNEpJQzZz?=
 =?utf-8?B?WSt6NHNKNGx1L0tNTkJVS21TMlhwaVVuYUhjNGxEVytFNFc1SWE2K0pCZS9K?=
 =?utf-8?B?dzcyZnEwcVdqT0pDdWg5WFJGZGZ4ZzI5R3FLTWtrd1V1cE9ZUTFBQlZ5SU1R?=
 =?utf-8?B?b0ttRW5UVGVLdHdxZjdrM2g5TWRGYlJybUVtUENQS3k4cUo1OXBDT0FrcDNS?=
 =?utf-8?B?TTB1RXpCeEdNdlliQnZGNlYxbFVRT3JjQWQ5UFl3dmN1QXMyQWt4dkFVQkp3?=
 =?utf-8?B?b2F2SmEzNjNxNzFqRXlPY2xEbEhEWkwzZE5PZ0RxTXlqRTRJb3NLdWxmQVNa?=
 =?utf-8?B?Y09UN3paU1JnUXc3NkIwWGRGM09DVFRMaVFCUTdvSmVKS3JnU3RMQXBVTjZn?=
 =?utf-8?B?YXhHZk4ycHJtbUgxaEFWalFEUjhnMCtmNXB4aEZDcFJNQVRSV0lEZlZ0Nmpr?=
 =?utf-8?B?dTVsMmRCTXNYT3RXNUkwcWtTcXgyQ0xTRG1YaGZrZUlZYmRLSVoyc2xUNVNy?=
 =?utf-8?B?Zk9EL2MvakkrOTJTUGlhaHVKY29DcjNNQnBNVUc3VXhDZzJqakovZ0ZhU252?=
 =?utf-8?B?T1lFbi83TUw3S1lReXU1OWh1Zk9OOURvd2lsdU4ybFp6dTh2RWFZS3BvamRE?=
 =?utf-8?B?T3E0YmhWYnZuNnlZd0o4eFFTRXdnR2prMjVwdllseXFXMk1nSGlGZ1B6RzNX?=
 =?utf-8?B?dWZMN2ExMkxJSHl1czFBQVdJLzQ0cS9WdWowY1BaWVRTejJZWGtEdU8wWCtL?=
 =?utf-8?B?OWl2WDZrLzNFS1J0eFNVT2lHcEtDNGFtbFdtempyNkpNZDZuSDUwaHBaSVlQ?=
 =?utf-8?B?akRlK2l5S2xKVFI4Yk9qeEtZSEZRY2VFNkdlZEp6U3BNckRVZ0hhbWpBOW5h?=
 =?utf-8?B?MGpwdVlqamREQ0NZNTU4WFQ2ckVOZnJQVWZsUFgzNGQra0hVRWloRWhzSzFn?=
 =?utf-8?B?S3A3NEI0N0xKVThnUnhLYjlTcHlFT2FrVG9xVHhvQ0dEOGF1cFI2ZEluRHdK?=
 =?utf-8?B?ZlI3UUcya0JqeTBCSzM3bEV6U0xYL2syS2xTQi9QVmYwS29BRWxqS1kwdXNr?=
 =?utf-8?B?bmlmaDV0VE5pRnRZYlhzUEZkSFRYeks0SFRxaXJHNlMwL3FGSEJHTXZ6Tk1I?=
 =?utf-8?B?b3hzTHBrV3FiNnVaWmc2aVBCaENHY0JzbTBvK2I5NVc1dStSMVFjWGdKdUgr?=
 =?utf-8?B?bUtpUlpndmF5RTlGNWJIalluUUgrQXVGZ2lSU01IWUI4NUEvaDJHWTA0ak1M?=
 =?utf-8?B?VmFYRDdYTm9TNGN0UXh5UnF2TUVmRWI2RlNFdng2b29ja1M1bWI0OUdXSWFO?=
 =?utf-8?B?d25qUk5ibDdzS2hLakZETENQN1Y2OWNrUFFiUDBIakdTS2pTZ0hqTCttVDVv?=
 =?utf-8?B?WXlSbmRmUmRuaDE1YjJndlJ6U2M2L2pqQmFCQ09odm5hUmxISFNZMXptL2ph?=
 =?utf-8?B?citSRHM2OThwWmN2U3pJb0RJVGI1NjRzV1NtYnFWSnIxY0t3Wm1nNldmQ1dz?=
 =?utf-8?B?aUx6WnpZV3UyeFNHSVVYKzZCYjVWRzk3YUpRYmZsaGFFVTlkSy9yMktMb1FD?=
 =?utf-8?B?K2pSYSthdS95R3BOTXVXdGprWm0ycnJPNnQxcTRTRFZMM3JiY0pIRkVjRWxp?=
 =?utf-8?B?eFJpRzhNeXdLUTFPeGh6cG56U1dwUTZGa1pJcDRvanp6aStENjJIbk93SlBl?=
 =?utf-8?B?TEpNWVZxaEdqZE9wazgzbHduUkFjNTNFT1VCZEYrcjJLcXFSTTErOWl1WXFC?=
 =?utf-8?B?WDVhZFYxM0NuQkVPd2VGK3F4eWFaVmJmSFI2MkN5TVRHZWIxZEFWUlR1SDNZ?=
 =?utf-8?B?eHk3L3hZSi9TRUxyRVlKY1k0L0dNQ1RFSTQ4MEhhYnowbmEvRUp6L1QxbURH?=
 =?utf-8?B?L1NUZEovUzZDOGhwbWkxWnREdG1DM2ZFc1VIT3k1MGxXVXMzRHprWjJoZkhO?=
 =?utf-8?B?dVJha0xqekRhS1AvT3djR21SYmE4cWx0Q0xsZHRWbm84NGV2bi82RUxjNGxN?=
 =?utf-8?B?WDFJdTFZMTdaN0Q3TXZMNWJGeHVwK0JwRjhBMWdubC9aSEhFM1RIa25nSGxl?=
 =?utf-8?Q?yGdI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eed54994-5ceb-4534-56d5-08da877734a5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 15:25:28.2017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThTOpu+uS9BE+cUD5cotW3SZ5Ai/MvWPCsH1rCXdhJknS9hSY3brn864rsbwDgMT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4954
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Well ok, but my question is really about what to run and how to
be sure I'm not breaking anything. I want to test my SMB Direct
patch(es) so I'd focus on 3.1.1.

Or, can I say "it didn't oops, ship it"? :)

Tom.

On 8/26/2022 11:19 AM, Steve French wrote:
> Nite that vers=3.0 can be much slower in some cases (like encryption) 
> than default (or default for version 3 or higher ie vers=3 or vers=3.1.1)
> 
> On Fri, Aug 26, 2022, 09:55 Paulo Alcantara <pc@cjr.nz 
> <mailto:pc@cjr.nz>> wrote:
> 
>     Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>> writes:
> 
>      > Is there an updated list of tests expected to pass, and/or
>      > any update for the scripting? Anything else I need to run in
>      > a basic local environment, to test smb3.ko client to ksmbd.ko
>      > and Samba servers on a pair of test machines?
> 
>     For the testing environment, I'd say there is nothing special.  Just
>     create two shares in both samba and ksmbd servers and specify them in
>     local.config when running xfstests.  We usually name them as 'test' and
>     'scratch', respectively.
> 
>     For testing SMB3 over samba, you would have something like this in your
>     local.config:
> 
>        [smb3samba]
>        FSTYP=cifs
>        TEST_DEV=//tom.samba/test
>        TEST_DIR=/mnt/test
>       
>     TEST_FS_MOUNT_OPTS='-ousername=tom,password=***,noperm,vers=3.0,mfsymlinks'
>        export
>     MOUNT_OPTIONS='-ousername=tom,password=***,noperm,vers=3.0,mfsymlinks'
>        export SCRATCH_DEV=//tom.samba/scratch
>        export SCRATCH_MNT=/mnt/scratch
> 
>     and then run xfstests
> 
>        ./check -s smb3samba ...
> 
