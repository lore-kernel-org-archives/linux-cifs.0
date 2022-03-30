Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DB4C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Mar 2022 23:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344742AbiC3Xqb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Mar 2022 19:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241629AbiC3Xqa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Mar 2022 19:46:30 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2080.outbound.protection.outlook.com [40.107.236.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DBC31519
        for <linux-cifs@vger.kernel.org>; Wed, 30 Mar 2022 16:44:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMAGz+ujwXN5IZZ2NoxjA2H5d+zQDbbmQkrE6r609ONaxW4VWrtRox+Ifl+ycPVnJdUQQVV3SqlYQz6cbNbUND6qBYDABn4lDm2BlBf781o6Fsr4SrntxqaHNQ1yZzoP/czSnU4j12MnlPO6y91ifKaS02OAzVDQ34DNS0RbaGvGeFeb+vZgZXN76q7BXBigwdA8pbZPvoU73s03sDGRaOaROs5olP2Nyu7uE1YxPJ9RrnrsQdJMJverA13+1bi75LEJOP4FykyzEeErkYSD7HrbGuTqgSWPqWLaEmPX+CymlR0SRAY2R9H2CVb8Z/D0YCUf0W/ANL/9i7/YvUtE7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nolovzaz0C0KvsYecB6RaB1M+B6sQgDg0sYi+mVV95g=;
 b=VgR/HiPTudzeiQveeCVbEJkOGyHZ29Vqcwa5sLEruxxn1TqypeJWqSFt2DWaCd6uvzlfjrNe1IvKnTQdVLWnilZhp1xP5zfLZBC5JGdCS/quOc7kYtT15ufB1mOMr9IgLEBDq99BeZ4klULwuD18Q4EKzdeJ+UsERT6zvRxEb6L2qaO6lXD2XxxQMxoyt6wxJEyZTXp3lcPRxTjp+qe4eerFNZXzECqDS/zaf3WjfTbjz44YuZDefpjryUDfQkcbAgvaUD6qsoSDRNahKdO7tLSB2agyNeY3vzxNti3VdjSBIwcucJU8sV+M6rEWpOhjuU8kgp6SipZx09ju6WVjig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB5245.prod.exchangelabs.com (2603:10b6:805:ce::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Wed, 30 Mar 2022 23:44:41 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5123.021; Wed, 30 Mar 2022
 23:44:41 +0000
Date:   Wed, 30 Mar 2022 23:44:38 +0000 (UTC)
From:   Tom Talpey <tom@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <84c7d6a4-f3e8-420e-828c-5852e21f1b08@talpey.com>
In-Reply-To: <CAKYAXd-G-NnN+1Ex2JcRJ_PDADV3PbyfRQ=qsoQ6TDq=RdHmvQ@mail.gmail.com>
References: <CAKYAXd_XMW1-VSLwB=k3ypqgqjsux5OFNnr=Ri3B+-8w4aNHjw@mail.gmail.com> <63afe0cd-7151-45e6-a7c2-2eb9212d721b@talpey.com> <CAKYAXd-G-NnN+1Ex2JcRJ_PDADV3PbyfRQ=qsoQ6TDq=RdHmvQ@mail.gmail.com>
Subject: Re: Regarding to how ksmbd handles sector size request from windows
 cllient
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Correlation-ID: <84c7d6a4-f3e8-420e-828c-5852e21f1b08@talpey.com>
X-ClientProxiedBy: BL0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:208:91::37) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26b4f046-d7af-4934-54dc-08da12a742ba
X-MS-TrafficTypeDiagnostic: SN6PR01MB5245:EE_
X-Microsoft-Antispam-PRVS: <SN6PR01MB524540F9882D33FA0D56A0EAD61F9@SN6PR01MB5245.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99AH+//xcc+WzWVcHGktyLEZ+j8XX/bqnwbPLYcQk0b/9pumiFnx3gh8Sp9hl8sCRPSALHbdwUjz7miDcRdBLvugQJfVEhcPVNab7V5ZOlueDUaXWnRExg9xLsEmVhAiFSl5xMDZnDJP6r3zmNZPAs2WI7nOdmiOrU65XMFxk2Lpc97UMwi0yF8Ri60TfM83ul14R5Wo2ejaTKmySxzs/V1XHVtYzeEk6Jc3v5YEECUaLlXWTyHAvfzx7hRQeRLm6GkPg2TuVjefREdaBEmW6Vv0y/xusSJhJL9LELQeIuBsA1CvKUkQzdtAQVwayN9icN8m8c15osoIfXkwSFqQDdxwTpwi8bfmzogRDpFBf3rxHj+QExV8vU4gcZJn5jHfmTD29jhtvwR1W1350cyU6InG399uHETg2UOH03nev/Hsa8b2e8xJpvqyY+xt+t/PoMAhkn6soPOCYsAei46mvqsJj0d3vN6MNgDEKh2QKMCLj7zl9vrI5ce/sFpW2JzAY3H1iDpmdTlOifpOk8DJ2AMB/IM5xUBV/9YLpWDlZMRvrRKPTRyx88dGVmeWlE/q0uiJUM1GNHGzKSGcEFsQ9w/Hvv7xAyg3buMK6mQcOV+ZM8O+06YLKvz6auTT6K/MvZ5sQQJr0n6+tNdfuIYnUrRKwInhjq9v7rf5W6C3XvXFtLNse4KCwwOtjAgXqU3FsRlzgWgK0gKbqe5hR19pfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(136003)(396003)(366004)(39830400003)(346002)(54906003)(2906002)(6512007)(6916009)(2616005)(186003)(83380400001)(26005)(53546011)(316002)(52116002)(86362001)(6486002)(38100700002)(31696002)(6666004)(8936002)(36756003)(66946007)(6506007)(31686004)(8676002)(4326008)(66556008)(5660300002)(66476007)(38350700002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXBobjdvakRZM1YxWkh4a29SeW11ZEdSSnZIL0tpNkVSVFl5YlRteU5oMk1h?=
 =?utf-8?B?ZUgwUitXTUtJWTM4dU85ZnRQV05DRTJabjUyZ2xqWVB5bDZGckM0R1N1emUx?=
 =?utf-8?B?N3BTVmRUa21YdUFKQW4vc1grWFhNV1l6VU00YU9qVEFOZEovTnZvZWs1SVc3?=
 =?utf-8?B?SDV5cU9jMXVjNzdLRm5oTGlQVTJXM1JKcEcvMUJxVHZVNkNMbU0wN2pZeFVl?=
 =?utf-8?B?VWR4d3Y3VXBodzFlNUxWbEk3QXIwb1FuUEpKSnlxUzB6RWVBaXJoeG9DRDF3?=
 =?utf-8?B?QzVNTEl4TC9jeG42a0s4NWJpQWJyUi9aRFlUcXNHV2Z6bk9qb0x5UzQwbktu?=
 =?utf-8?B?RGNoTWpsYVpQTE9mYWhVR3NiNnpsV3dpV2JHaDlZa3UvUGpPTWRjOUJsblZo?=
 =?utf-8?B?SktramVmMjNwQjNKR2w3TW5hWWROVmg0MkZGUCthQnByK0NVUEx5dUtZNnp1?=
 =?utf-8?B?cG9zZUZ1dGhLWjZWMmpRR1I1L042UFZTdk5ZZG9jcFBaMWU4TlEwbkVrZ3U3?=
 =?utf-8?B?UnFtZy9INzh3RS9BWVkrVDAxUHZxclRURG1sQ0JoZkZMMWk4aGJ3WWM1cjNL?=
 =?utf-8?B?UUdXd0NjNzRzNVNYdGswM3dud1NQZGcxR2hRRGhsbjhOL0xCZWE2RUFOUXpl?=
 =?utf-8?B?NzR0Z3FzWXhKWU5OSzR0QWNGZnZCRGZ2alM4ZGU5Mi9aUlZRT2xJMlFMS09s?=
 =?utf-8?B?dFMyMnc1YkRiZ0tNSjJsMWE1bTFYYmNOdDNrcTdHb2JIQVNZb1Y4OUJWZFBo?=
 =?utf-8?B?QkxsRHhNODZtNlNXRFNLSkc5NHlPbW9ueXF0d01CcjBiREU0eWZIUjNQK3hT?=
 =?utf-8?B?MGxncmJJbGRFd21EZlRsbmprYzcvNUVyUW1ma3NXdmxPdEpnWEJvWGw0aUQ0?=
 =?utf-8?B?RHc3SXkxMlN0V0hFOXQrZXUvN0g2ZWg4Qm5FaWtBREVnejAxemdQZHM1eWxG?=
 =?utf-8?B?QkcvUGxxak5DbHFjL1lkVE00d3NtdUp4K1lyVEtvYTdiQUhEd0RGYXc1d2xW?=
 =?utf-8?B?T1hOdW0xMy9VSTdHREdoSEw2T1ljc2l0NWRiR1V2YlIrcm9rUHFaOE1CNzk1?=
 =?utf-8?B?U2thbUN0Qk00R2NCYk1KVXBPT1NYSW1wYW9YZDJtd1l6WHFYZnNjS1lUWHhC?=
 =?utf-8?B?U0xoRlpySE5laUc1WGYyeW5HSkg0VXlGRkhHRUZDSnkyZzNENXZNR0N3cUdp?=
 =?utf-8?B?ZWFHeWNmRW5rQXlMRUhxQXNQMHo5MXRYcnRwWWIwalRNVkRLYzFhdFlwakc5?=
 =?utf-8?B?RUVlUnB6Z1d2SVJFTTRYeGcxcXBYZTJPL3Y1M3JocDFyQklTRXVyT3FJTER5?=
 =?utf-8?B?Smx2VzVQRFUxSHdlSzl2VmtRU1dHV1ZOaTdQM0Z5ckJIRCtrOGgyWHlLcnQ0?=
 =?utf-8?B?QnRkQlp0dUFyWnVDYVRLQ0hZQmEvL01uTzN0bUdVM3JMVVVFV2dBL05rNE1a?=
 =?utf-8?B?aDEweFNSUFNSVFQweFBVZnllYVZoR0NhVGgraG9XRlRtQU5nc2gwQ0pFNzlt?=
 =?utf-8?B?MXVYQmNSSG5XZFc5RlNHdDhzNVl4cnI4R2JCamRKMHpJRkdPYUpCTEpMQms4?=
 =?utf-8?B?R3B4b2Rkb0w0cDV2SlVLMlp4Z0hPQjUxNGRQaXEwUDFxUXRXNVdPREZlaFM2?=
 =?utf-8?B?Z09OTXkxVDF2NlpzR0J5QTFnK3VHTXhhcVc5VFNpM21zYTU0blE3b3ZlTXRz?=
 =?utf-8?B?K0djTWJCSkpkamRtb25RY3lPdnNZVi9KK3l2RzVOOTB0dS84QU1iVTN2MG1Z?=
 =?utf-8?B?emJNdFY3dmNlTEFwWkdPbDlFNmhsQ1Q2VkN3djNPR1hFZTdmc3ZKdC9SWFRl?=
 =?utf-8?B?OVI2MWVuS0RlNU1CR1hyaVRaelpmWnk0NVkzZ1NrWlFsTlpmUmRwWlRrbk9W?=
 =?utf-8?B?NzQwdE43TEp3RU1Vdi8xVVFEb1dPYTBOWFBWTFBoazdnTVFFUWlxL0w1OUly?=
 =?utf-8?B?ODVOdmFqMkkzRzdSQ2hoZlV6bmZNWTgrdjZVT3dDM1dGSlFxNml2Umc5VHQ3?=
 =?utf-8?B?UmNBcThiZHE2eUNrMzQvazU4TC9vR3hUVnRDTFFXaHpOd2xkeXpBWFZhYm1p?=
 =?utf-8?B?Ym9tOTJua1VnMUJLcDl6MFlNdVJvSnIrWWwwaGZ5V05xRUNTcXNIL1diQWR1?=
 =?utf-8?B?anowellPVFZjTGJtVmVPTkxDTG9Gby9xcVQ1T3lNQUpjVWZwRmpDVy93Uzl2?=
 =?utf-8?B?aHArbWVURXlvYW16VTZXVStwd3dBaElwd1BXejcyUy85VThLYm84SWtnZ29O?=
 =?utf-8?B?ci9NKytDKzA2bnhpRnJ4RzZ1dk02V2xTa0Mvb3ZVNVVUb1BWamJHV3RLN216?=
 =?utf-8?B?NkVZTnRhZXE1RlhFMEJtYWVvUldUY3cwZjFiRlNxYjFDL2NsOWd5dz09?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26b4f046-d7af-4934-54dc-08da12a742ba
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 23:44:41.6098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4vRMx14SpyV//EFZR9mo/0SULSJnIQheZ8KcOppOWrnoOTrMqciMrmANKJCJ5OX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB5245
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I agree with Christof, don't do anything ZFS-specific here. But I was trying to encourage you to think more broadly about the situation, and hopefully find a compatible solution.

Sector size is mostly about application compatibility. If you don't return anything, the app may break. For example, I bet SQL Server issues that info req, and SQL supports running over SMB. So that's one reason.

Tom.

Mar 30, 2022 7:37:20 PM Namjae Jeon <linkinjeon@kernel.org>:

> 2022-03-30 21:09 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 3/30/2022 3:53 AM, Namjae Jeon wrote:
>>> zfs block size is 128KB, and there is a problem when ksmbd responds to
>>> this value as a sector size to the windows client.
>>> This seems to judge as an error when a Windows client requests sector
>>> size information from the server and receives a value larger than 4KB.
>>> 
>>> If the logical/physical_block_size is obtained from the block layer in
>>> ksmbd, You might think of this as a layer violation.
>>> e.g. i_sb->s_bdev->bd_disk->queue->limits.logical_block_size.
>>> 
>>> So I am confused as to how to fix this issue. and I'd like to hear
>>> your thoughts on how to fix this correctly.
>> This sounds like a problem common to any LVM or RAID layering.
>> What does a Windows server return for a volume on a Storage Space?
> I'm not sure if windows server & ZFS share is possible. samba & ZFS
> respond 512Bytes sector size to client. I don't know why SMB client
> need the disk sector size information from server...
>> Look to that for guidance.
> Okay:)
> 
> Thanks!
>> 
>> Tom.
>> 
