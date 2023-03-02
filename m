Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B9DC6FA8E
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Mar 2023 19:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCBTTJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Mar 2023 14:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCBTTH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Mar 2023 14:19:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8001EBDD
        for <linux-cifs@vger.kernel.org>; Thu,  2 Mar 2023 11:19:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgG+lh0vHW0LfAIYCXFERV2TdDbaABFyw6tVRdq3ruVhG7kAEK4wR719+82UVNigJ5dbyLfNBpL2GGtWLddxrhVU7z1ptSD0Z9BjCfhCnY9vHn2CQYksZlpowHxmy3rZcMd/LEJigPOBKOyEiI5Jha21YW3q11Uk6iUaF+HnrovHCqGsYg4RRd03lQ+MX2Tgf5UM4+co9SNsekPn48pIZgXkuAcEvigk+BB7iWYcboZQRTdvmidVJSdirplmw83kgBuCjqxFKkzkuZQyFiplgKl/A5V8+2PoUdvUNIshuqv2W12rmmczrZc0ydhClpFzG+1N1qooEkRw1KVCZvVh3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xByz5562J3t9ISxXzQQx4DLmGVGdnza527FAkQ81vhM=;
 b=nAt84RkOmw+bou4+aEJoTjW6NdsQMOAW6NBSamnFk3RrjA/8+vDWkBpxiDFk3zdFWFFRt3mQZbTErvMh85hnzX69MSOU1wXLzMPVKJ7aN/+J8RETxkR27tSwOMy2mo/3uqSNS96pcGBxQyIU6Xp2EBBDrGgMhDoxAErWww6QT7eHQv+4jpoIFpPq8j9aKDEniObW7G3gOzrjxcWjEXKbVkY1r+iBPPnpBs7AXcq+nQalsVSW1T5TxeOhEyYB+Smp7v1qdd7d3WILYkbOZY/MjLh/afHqAi8qGMQ+/cXKyCllIqINcvVxJo+FylFAjzCQDyzIKiz0JZSDEh9iNlGYug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH2PR01MB5800.prod.exchangelabs.com (2603:10b6:610:40::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.18; Thu, 2 Mar 2023 19:19:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1d6d:194:ddc0:999d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1d6d:194:ddc0:999d%6]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 19:19:02 +0000
Message-ID: <300597ce-06a5-a987-5110-aa6ec24ea199@talpey.com>
Date:   Thu, 2 Mar 2023 14:18:57 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Nested NTFS volumes within Windows SMB share may result in inode
 collisions in linux client
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Andrew Walker <awalker@ixsystems.com>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
References: <CAB5c7xoUXH6Xy+79Wz8M4yC70E=rwUL0ZRD_ApAFWv=C7S_uxg@mail.gmail.com>
 <514a3d90d263bd8422e9d13bd4c6e269.pc@manguebit.com>
 <CAB5c7xrdKSO4YE_vUQ6tg+p=WwxEdquj+VrRpwKxi8Jd0vPyAQ@mail.gmail.com>
 <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mv52koGnKbvtRKE95c_JwwtitTXFaRc6mcM8nwLmWNo9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:208:d4::48) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CH2PR01MB5800:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a053b89-0f1f-4810-912b-08db1b52fb66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B22kQozd9yi2e8Gyz4ala3wH/YU6x0HXLkkCiYdr2xwoIi5igFyWEUCbz/3za6TVG4ufvGqjsgeiE6b06I9365bNatxBPpDb+UyQuM1BIL3Uhq7cTIWrKdE6nOAtu3KQhLoR3qDaDnYpk94jFFUpugxA0rFm6EmvaIS5KSab0LYIsMWHM/AFPxIQHg5ngO1fjZY3nIaKjbKYUINOVawv1UToYRrCUckGp31MNGZshJIPB43aLKL/McpEljIKMlvKr0Hm5TmOg9/WTyrZXWx6Nnx5z+NADEcRG29jhVWr9hT+vwFLidUYE4gR9uOW886ZaJkU7r29joU6kn2ICmVXWgqsF3ndyhXVDro7x1VJzf32w3CxvtG/3ohjR7mFqZJpvckeKf4nowod4PiYZHDAdVADMjPkjoWprD+anr/0FIWUhmPCuQecmrQvDOiS0VzB/C5Cf34EpVzD9pUon/wZTSZ4w17MqgRp1CoXdi20n5yaoIfPZ102DvDiKzTuegMR/upf9OfnEUfH//npI+OnVM5EqMGwnHhfzxfDUoIDRAplnIcVa9hSEBy+ULOH4KIacec2VdnOubQwzP5p0QueVZfGT/xBJIFHxjgHM69HhNfrPYPa9tnCqk/JqBdIDNU6YyHtG3IDJrYK774tb4UMnj98J1/Z7OrjHDCUMQMKMwv7T85xXQnKs+5N++Sjo7AgkSUgo96CjO8zaK+99kdgf2S8sAFk+NHeOUqj+WV4KfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(39830400003)(376002)(366004)(136003)(346002)(396003)(451199018)(6486002)(186003)(6666004)(38350700002)(2906002)(38100700002)(36756003)(110136005)(86362001)(478600001)(52116002)(316002)(31696002)(6512007)(8676002)(4326008)(6506007)(53546011)(66556008)(66946007)(26005)(66476007)(8936002)(83380400001)(5660300002)(2616005)(31686004)(4744005)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akI0ZjhJdC8vMk85UXNLaGw2WjF6WkVZT2VVdEtHeVpHL0ZOQlBXOEJkVUN4?=
 =?utf-8?B?d2JGWk41U3Vvb1ZjR3p6ZGptM1JEMldhYXRmQ2lyZFRGOVlSa0p4MDNFSm11?=
 =?utf-8?B?UVhYZGU3aEUwM3N3Zm91bTBCeFFBREkxNGtkUkMwV29CcXlJNksxQS9JNDJQ?=
 =?utf-8?B?RlNSeEIyRXhLa25hTUovWUFBN2czSkRxaXEyNDhKMTJzTFp2NXpRclk4NGpZ?=
 =?utf-8?B?cDRJeHVtdU1lU2kzNDdURlZzNnF0Mkt6bFZndEx6VjhER3BrRTlOVlRpODR5?=
 =?utf-8?B?MytaNVZ4UlJCY1JlNnF5QVF6aWwraWI4ODVMR3V2N21aM0oyQzhTbkpwZExU?=
 =?utf-8?B?QlZKRlV5MGs2OUF0a0NVbEtic2hKeHpSbXRlbjRzK0ZvOC9Gd04ySHYzUFJm?=
 =?utf-8?B?bUJTb3hwY3pieStMUHVDUnFZeEZjWHQvRGF2WmZjcDU4M2JETTFLcFNzaS8x?=
 =?utf-8?B?bEN6VmV5Z29Pbm9GZlFUQkNlYndpZHVZSmlFa2VPSE5DQTFUVmMxZlMwY1Y5?=
 =?utf-8?B?SGRLRHZJMy96TVJjalZmNzZ0eEdUa2M0TGFjZnFRN0NIY25yUkxBUDV4Mnl0?=
 =?utf-8?B?ZHFnY0ptRGsrRlQxcUgrSVNjRWIvMlY0YU0yNkpIamxaaGdqSmVmUWRZYUlK?=
 =?utf-8?B?MjF3UzhITDRESmgxVFZYWXpiUXFrVGdMRHZ2cWZVd3orMHNHTjF2VGg1c2xF?=
 =?utf-8?B?Wk1WOWxTSEdSOUJVMHE2TlNGNXhUMHk1a2MwZTBYOEQ2V1hIM3BLYjdZS0kz?=
 =?utf-8?B?NmxjR2ltQ0VFTWVtTXNKRW5WSmxtOGM1dW1mNUxsWG5rSVJBSzE1d3BFeUEv?=
 =?utf-8?B?bWppVURDaHIwNGhLTS9kdERtUzdnQytJenlWUzVaT1NXa09ZaDMvNXRjUkRh?=
 =?utf-8?B?VC9FMXhaRjJQSDRXM0R0WUs0V29jVHpKVjhwczJUdklIV0tzM1hTN2pCUHRu?=
 =?utf-8?B?T0llUGNuSWRNZUU0SnBJYU5mZDJCTVN2V0djNnRTT0hUSVBjdEErTGlERmpu?=
 =?utf-8?B?aTQzL080T1IxM1N6a3dPck0yNm1scDdTK1czclBGYTFwVnZ3SkxGRWZ2RnZi?=
 =?utf-8?B?K3R2Y1dhRTNpWEZvVG1ySWJ0NFJTVm5sUmh1eStNbVYrcWFZMTBLYkVUenl2?=
 =?utf-8?B?bERrSmpjWkFxN0ZVek42RGxvZ1c3RHNXb21BTzVVcDdkWGpKaUlPaG5jVnZz?=
 =?utf-8?B?aW81ZVNtK05BaE91OU9IR0VIRzNFRlgyU0dhSktRZ0Z2ckpqWER2TlJacXNy?=
 =?utf-8?B?TkE1OU9hK0JNR2xJeDRCU1BYRHQ4ZjJhc1BNMUpvUVNBOVFiQTdOQ0ZMczRM?=
 =?utf-8?B?d215Nm41VGd1N3pZcGhEMmtPT0FJVnBMc0dGMldDQWdObFYvNkx4YWNUOUtH?=
 =?utf-8?B?SVhYcSt4STdNQTNTNCtZRE02Q2k2dmJuMVBPb2grU3pHOEwxMS9GTGlDODRY?=
 =?utf-8?B?WTRKMGJEN1FvRncxRjNjQUFHQy9ISU9GUllWcHVMYSsvOFNLNjJ4WU9Uc0Vq?=
 =?utf-8?B?bmo3Z05yRWNFczRvNGRSWVQzQlBVM0tBVktwRWM2Y294YmtrT3hYRVNDaUJp?=
 =?utf-8?B?L0ZDU2tTWmRoa0Q0bzB5bW1vMlRMVDcrVlR4ZmdiMkhYM1RxbUpBVWd2UkRL?=
 =?utf-8?B?czlMazR6dW5Nc3YxcG92Q0w1Z1diQ294NUVTanhoV2Z3RWMvSDZNMzlvRlpZ?=
 =?utf-8?B?bHpuR1lDN3U3K2RXU0VBSDR5UmhYUStBR3RhS1VxTU9CeHlxVVpFSWdrT2NG?=
 =?utf-8?B?NHlra2JZcXZ6VFc0dGs0Q1BLeC9tRE1uWDRmcWJrREFZWHFpemp1YTU0TFhr?=
 =?utf-8?B?TmdRcjJVQ3ExalppU1dyaHljaUVUc05uTis2Qmp1NWxRdnNtcitnZ1F6b1o5?=
 =?utf-8?B?U3FObkFrY2pCcC9jY1N4bEpMdU1Sb2h6WVZaekdUQlN6eDQwVDBkWWdWSzlD?=
 =?utf-8?B?dlJPcHRHdTZ1ejIwbVp1alcwNWJyQ3g3MVQxNkJUV1N4bkg5Q0FuM0VDd3I2?=
 =?utf-8?B?QUNIUVNlR016MmdLU0UxME1pR3MvUTN0ZDk2OVBiUTZBQmtOUE5aMXJweE5l?=
 =?utf-8?B?c0ZucUN6M2NqZmx4Y25rYnUvakxLVlhUVWY3UG92bWw5dnMxK3I5VnZmTGxZ?=
 =?utf-8?Q?XZ23NQRpesVVvx3z5TqGeZyd/?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a053b89-0f1f-4810-912b-08db1b52fb66
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 19:19:02.4003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8ACyeNfX56oQNTBj9o0jN/cRi6F/chH+XJywvy8GH1W0w5F9/K3N64ddVYrdAQ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB5800
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/1/2023 8:49 PM, Steve French wrote:
> I would expect when the inode collision is noted that
> "cifs_autodisable_serverino()" will get called in the Linux client and
> you should see: "Autodisabling the user of server inode numbers on
> ..."
> "Consider mounting with noserverino to silence this message"

Why isn't this behavior simply the default? It's going to be
data corruption (sev 1 issue) if the inode number is the same
for two different fileid's, so this seems entirely backwards.

Also, the words "to silence this message" really don't convey
the severity of the situation.

Tom.
