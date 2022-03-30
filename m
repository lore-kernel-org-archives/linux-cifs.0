Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B02C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 12:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344593AbiC3MUO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 08:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347200AbiC3MTD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 08:19:03 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E13F97B82
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 05:09:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDjVopG33tKAvcQtz0L7NsrlD9bkVMpsK1BLOUd4rQrWnwR3Rh+mngcgDXMNBmYlWlSovQ3lAEY/BQYQqUn4fu96sMid/MOk4h8aoI86S74vT15DPBnlrKM+ZyHqyW3G1XQXR8Qoi69k17cRgCLNh2wNLc2GA6EOMBTrpOuLuOt8shknOdISQOcR6G4sMZGWrSauBfMZhSE4/qPLsamLnR6VIEqFDSFDfKAbYWiNC7UZQH8skDYfGz2oMJfcoMA2U4kTv17f1+Gqc2GbMz//ur0+F4G78/tmXeCsv4ttxI4Fpp+ilRxNZdnltwbFyCKbxAdKNq2a8Q35HWONNx2A1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3GgQ0A7oyRGHrGBnrhzIN9vWb031oZHdwQ3RBYe8QA=;
 b=QFURN4TDxB063m5Nl1/JIFLCiYu/XdyuPVREN2Fr1JOhgGPVLYcXT+kHtUprakUAvsCc0Orne4JS2B1/udOXR43h2j98CKTI9pzY8Cup0dLQFsejELW54IOCWixz1dGBFt7vnjc6UHW7AhqyLoIUvrNoqU4hR05/LEfvNkpg+hh0DtCUZ8YCFJUsbO4Imz76+qfEsuFEyw6G7jIREJ7tgDdSX8h6i+DCBQfnjfqTtlj+PhtNUsEGfnPM6o+umNrRUQft+xZ92V5y+WRSbyd7I7jQ111fel94mlvoRrv+4R9QTQG244O83S0ZwzTDTjmQYVRiTbrFdRloZ+XIVZ7o/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH0PR01MB7187.prod.exchangelabs.com (2603:10b6:610:fb::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.16; Wed, 30 Mar 2022 12:09:10 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5123.021; Wed, 30 Mar 2022
 12:09:09 +0000
Message-ID: <63afe0cd-7151-45e6-a7c2-2eb9212d721b@talpey.com>
Date:   Wed, 30 Mar 2022 08:09:07 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Regarding to how ksmbd handles sector size request from windows
 cllient
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0131.namprd02.prod.outlook.com
 (2603:10b6:208:35::36) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dd66136-d760-4c26-eaeb-08da1246186e
X-MS-TrafficTypeDiagnostic: CH0PR01MB7187:EE_
X-Microsoft-Antispam-PRVS: <CH0PR01MB7187630FE5960DCDBE7DCBECD61F9@CH0PR01MB7187.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ln6CaIRq4/E8oBZh7X0we1HCU1h/Rtq5Zf575SBxELvkM9y+eHg6f93PyTKpYKSSV6TFL0rAKpUbEnCVY9RrwFju8fDadHThQDbbgXHl2gLM2r2htGFVo4C9dqB5p8SsOF9b1HR8Tf9mI70rh1IvjNpds7oId8Yhs/HFoT3bES8CYRc2P4RSMt0uyl5RYYq4oxI4pRUs2uhGORDrWnZIxkZ1nP2UAYZ35ehK1d8qK12OAH2xZmugXjVvItuNsYU78P0vGNGdPc3bdASzLWINaRO9V7qZaxO/+eAXBKi41gYOOgzB4FHrmpugKpJHHBkbrAw31kOnmaG3/Bk7gr6R0d9h2FhV1cG83myJTcPmxDA/BnBnrcMecanIzpcWZ1WBvIIOyf8LAAmfs8t4WygNsYT+H1c59WuAkgqaaPEMyhXAUVHljxnIA1n/NaXdAmRqN0mRaNJkEW3Ykbviu9fAx+BnvYlvZOmtPCxafVcgjY2cZ+Ir/N8krVPoObS/+wBUoZggvoLWgPY1fdTenrgXG8k9WA3xxghnm8ic5e4fK/nihwczyqpQFoxuD2fiRfI4zZ1HYgxbcKJB9PCxeYGDb6qDjqIoIo0Q+zbWHT6ZhNcItB78tKvRDPCn6X++wrRD9qyVL4w4uFrvnfgsj2Py+sT6ABxb7R+uw4s8ObqbF6qLiI9tnIbzJWML9GO28vFauE0veYchUyQwcH1In4ws7CrGWIwVq7NkNgveSbSLktw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(376002)(136003)(39830400003)(366004)(346002)(6486002)(54906003)(4326008)(110136005)(508600001)(31686004)(36756003)(66556008)(86362001)(5660300002)(8936002)(52116002)(38350700002)(316002)(6506007)(26005)(53546011)(66476007)(186003)(83380400001)(2616005)(2906002)(31696002)(6512007)(66946007)(8676002)(4744005)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFdsUnhvSjFBWkppK25PakFxRGsyQnozSmI5VHFQdXpUajVFeC82MFdYQzJq?=
 =?utf-8?B?R3Z1Ymh6cjJFQ21TeERvT2dRd1FzcXd0SkxSK1JIbzU3V25SOVJuMlIyT0pP?=
 =?utf-8?B?ZFJRcW01azh5ejNaOStXL3VOZGk5ZmcxbFlPcHZFZzVUWGpJRDh4TkRPYzFv?=
 =?utf-8?B?QzFvV3d6N2tyY0YvclNacHhDdG5OQVR5YWh1WTJwWVRpMnN0V2d2bkdFU2pB?=
 =?utf-8?B?Wk1WaXNrT1BqNmE1MkpVci9tTGtjK3I1VCtCd0VURFRiQ2tOdXpKTzZ2VW9S?=
 =?utf-8?B?MmY1MnFHTGxqOEk0Z2lsb2dSR0hnQzdvQ3ZYQ0JqVnQ2d0ZGZEdMY1VBZ0hU?=
 =?utf-8?B?ajVvdWRIZWpXaG00cTgxTXJ0SW0zeWlHclVNTFQvQm04V0EwY2JyOWd2YkxJ?=
 =?utf-8?B?WkdrUXhtRXdVRE1HalBXUFJBYWZISFkxUFVmQzl4aDFSK21MWGN5aXFySXF6?=
 =?utf-8?B?cVBqR2lxb1QvMVNNMG5RZkFDUE0rNFpwVmZqbnY4MmZzcmFuTDJObGdnREdo?=
 =?utf-8?B?YUtHWE9zTmhsM2o4MzcvRS9BaURwelNxOVQvUVJPRFNiMVljaUZSUmdWRkZN?=
 =?utf-8?B?dHRib3RMbEdORmJiS0VUc09kNXU0OEgvN2JFTEd3Z0xaQThQRk83VUFDekJa?=
 =?utf-8?B?YkY0VmU2d3NFRFN1cUxZbEVyOCtkeUxTYzMzOHVyMWNjZFd2ZHJKaTRuL2Jk?=
 =?utf-8?B?T0JMM3hXT3ZWU0prd1BuMU1xakZIU1gxS2hyTEpyUGZtOGFIaFk4R2NZNnlV?=
 =?utf-8?B?ZEx6TGhQcFNDU1pvdG5mU2lML0cwYnU5ZVpqSXZsY1ZCMkU0VkwwS3hIaTlo?=
 =?utf-8?B?emFTWnRIaVNjRXJQbkR1YUh3SHdWa21oQ3BqZStoNmQ5NkVObGNlYmJjRWpN?=
 =?utf-8?B?TnUrUGFwTitkRktzYjAzK2JXUW5aMVpJVWJMd2ZjWUp0YXBwamNSWml5V0h5?=
 =?utf-8?B?RG5rQXNqcS9KY0FYemd6MmR5NXh1RkpqTjdGOHBQald0aFdGekpJUk9rd0cw?=
 =?utf-8?B?UzVaOUpsZFVSalcyd3dqUjVXN2UzM01zQjVCU0hzVzZObkFoeGgzL3N2dHIr?=
 =?utf-8?B?bmFZYVBVbmk4azBMKzl4VVdiblM2MlZmZTBvTUwzeURkK1dpcXpBd3Y4b1By?=
 =?utf-8?B?aXFJUDlsd0RXYXc2MmtUM2hHNzR0bjJiQlBRSkVaTmNJUC9kWXF6OXJiVUFw?=
 =?utf-8?B?VCs0ejg2M3ZaQXZSTjV4Uml6MjM1TFg2TnQ1WjJFRVdEalkxeUsrQkM2Z1h5?=
 =?utf-8?B?LzFyZVFlRm0vd0J3VVpTWldHRDQrNEcweVBSZDQ5c1VDNHBFUnZYYmhNaGx6?=
 =?utf-8?B?aWVpb3JkSGdGeEFKTXcrYkptNlh1QjVmc3VMQ3AzZXNjcSsyZzZjeTFQRUE5?=
 =?utf-8?B?czFEVUJMSlc5VU41ZWN3RnA4QzBsVkJVajAzZytxYnAwOG9tT3VocHJxcXNP?=
 =?utf-8?B?b3JTNWNlSUxjMVlCSGg0bDN2RXpUNkcrZjNKUjVJU1hZQmwvTVpPUDdDeW05?=
 =?utf-8?B?THMzWCtFWXBVVE5FSFRWR0g3V1pwWm5LT2lHclR0bTZOQWc1RzZmdE9HbWlF?=
 =?utf-8?B?UmVzVjE2NG8vQVJ6RkxiR2krRDZ3QzM2aUoyYkZpbUxsaE5wN1pSNFBMU0ph?=
 =?utf-8?B?eFhYQmZVUFVuUThnRjZCUFhabVhYRW9ORUo0OTU2OEpUVmcxUitMVGZVdzQ0?=
 =?utf-8?B?NzhxMGJ3VUNOUmJ6YVpZcTlJKytENjVYaFgwdHk5TndwYXdjdndIeVpQNlpa?=
 =?utf-8?B?YURmU0JrVnlPOCtpTlNCb1BQNGlvTDZJYlVoNXRBd0Q4WlpVYkJmOVFQV092?=
 =?utf-8?B?S1d3SktIUnNtR3NmOWp5Zm5mWnZoSXhWRWNSZG8vOUtNR0FmVDVUcUV2K1JG?=
 =?utf-8?B?Q1ZQNW1wUXh2WmxvNVp3ZnJKa040THdVY3l0VXBreXF2Q213WDg3bExDQ3hn?=
 =?utf-8?B?QXRTVlc5b2p6bWJJMGNVcGxSMk4wM2ZGVjRQMGlBN2hoTk1NUWdEZk1uZWhy?=
 =?utf-8?B?UVN2Y1FwY3VqY3Bmc3dyLzNDajVydXBLN01JUnBwMVJ4V1Q2SzVCWE5kWG0z?=
 =?utf-8?B?SmpMeHVQNHNLZG82ZmErVDY2SkNxc2l2L1UybXhlUTZPSERWemFnQnJoRFVL?=
 =?utf-8?B?a3Yrc1RFTU1MeHFxNVRCbXd1SmM1Y3pVRVFSb0doQVA5WElYUldyalJsbzlU?=
 =?utf-8?B?d0ZKNVFEdkJjUGNUVUhuOGl2ekJEZHdjekhmeFJOT3N5R2hoN1o4bFkrdldS?=
 =?utf-8?B?QWQ1Q091UUE3YXo2WkNPdXJNclRBL1k0akpLZitXNkdCMU9pVU4vTjdlV2xv?=
 =?utf-8?Q?1sz81SPwOy/PnZAHtS?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dd66136-d760-4c26-eaeb-08da1246186e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 12:09:09.7497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgQ4sPbmZfIQ3bEK5hgZMRH674MkSmpJctoxu02zIw+DQa/+5HLSSF7Cgz10DZVN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7187
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/30/2022 3:53 AM, Namjae Jeon wrote:
> zfs block size is 128KB, and there is a problem when ksmbd responds to
> this value as a sector size to the windows client.
> This seems to judge as an error when a Windows client requests sector
> size information from the server and receives a value larger than 4KB.
> 
> If the logical/physical_block_size is obtained from the block layer in
> ksmbd, You might think of this as a layer violation.
> e.g. i_sb->s_bdev->bd_disk->queue->limits.logical_block_size.
> 
> So I am confused as to how to fix this issue. and I'd like to hear
> your thoughts on how to fix this correctly.
This sounds like a problem common to any LVM or RAID layering.
What does a Windows server return for a volume on a Storage Space?
Look to that for guidance.

Tom.
