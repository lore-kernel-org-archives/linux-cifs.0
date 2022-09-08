Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B2DC38145
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Sep 2022 12:50:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiIHMuT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Sep 2022 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiIHMuP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Sep 2022 08:50:15 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540006B640
        for <linux-cifs@vger.kernel.org>; Thu,  8 Sep 2022 05:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgY+DjG+EZ0eJN3WKw/utKiLFAX+CJgF5EszuVo4kPKMhvxtds9NYZtHY1gqLA2yXYJWr8oIgZN7SLvSxBhERb2KLmsfa8m0ZNr9ljcNnQjwhBqd0o/1jQDFBpAqd6XNEwaMA3UfyBtb9pTqUjViudq+KKWOjJ29ur+10dg2OlTV5I+pM+LFg+kxPooi3xg7rrOplsyv+Rs+q2U9kKGTlwURYdKxT+D8QjMyKU3v0zRCxPjbZiIxxbiYaSNL0c2IypF2b7y5lTllY2egg91SrH79r3aVA2iP/vGx5YjJI6aExam/mVmD9JdBtHwRSPsGnAFC56heEmwN8JsUY+eMHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VH+v8DDwaL9DGDYVhA1CWQTK3CQw3lYhm7c2UVFznXk=;
 b=ULLsyNTmtRIEcbgbxFqXJfONOxio0OVVZ2vQMOsm4l6/gHlc0KnRk7fUSXH2c9RUfvBnfkkEkt+ZiFOff2eHLt4Q2XwyYaIq4COoMNaNX7zPLCr6QT2kt5wJdx0KFL8fr8zxQvLUL+Xegzp+/PuP60Lh2EUGLptMhzc8uwRHRrbhH1n9mJlPfW9CmU4QfQgH+2RM+Omnw8/YPSJXUdcndkFXlvAZuLvcFLGw8JkHEWZc87s2TGbjG9lxQuhht/2v6cDoBtuKuBvDp3yfzBzjbnWejSXk2//TvbQK8zSpCly2jg20wQcTTZg4/9L0pwul968NN64PPke+rAE2UMU+Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4975.prod.exchangelabs.com (2603:10b6:805:c8::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.16; Thu, 8 Sep 2022 12:50:10 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5588.018; Thu, 8 Sep 2022
 12:50:10 +0000
Message-ID: <24137999-6349-f058-2f9e-b523f2d0a2e9@talpey.com>
Date:   Thu, 8 Sep 2022 08:50:09 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20220906015823.12390-1-linkinjeon@kernel.org>
 <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
 <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31a69305-8de6-48ff-fd5c-08da9198aa2f
X-MS-TrafficTypeDiagnostic: SN6PR01MB4975:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcRzw164sLFOo0VLGrSl11TcXjp+DMLfn6zZqXxeyfjHDIC7ABoGwBS27aixeZajqolRH0Tb8oGLVgICmd9q/rNPchGAJHCmItn4/OGgAwCx7OzGzzPxnhTtcASbGs4NOxEAqENFCssR/AduzFeapdy2oyarTqVujdCvX8XGphSOTZv+pk7bOv1DSZHKGlE7iP+l0Lt0AornWq3dKLZImr4Nu48fAyP0bpOy+JjtJuLDpn1SPzCPp5oHr4bHSctI0VW12aaTJxBYdT/4vuSCX7tH6oELBdRJTmt8egs+zMGLFqrVe/ZTY0VKVd5mzK2F2Ql14lAeg7Kdi/6J6uzXkVcsFxuR079EMnarNQn0P3UXmmQMbSf1KYFZDsHvVaWF8b8jR9IKONsWobv/gHElmC8knIz51yDGArUwT9fF5QuSa+N6XJUB0V+YzJvhYuHUI7W/pTvEsslcS3yS+VQurbGo7qvBFP0BBXkc9GxeZ1GIVPChQORnXyJlgCUwcFaA3ZOEg7lV0oIw53WuRBXu1ZjGof3iuGZEI+hJ3X9gOM7vIraWW0dJq1XL3pblM+Bg64fgsqYjzx4z8u92kwAeF8jb60jsgldb03Yz4LbYy0dbAWcO79gsW9RVq53UeI9Wds/JBH9a8QfhkAKwDceCbzYM4M91FNJERKNSgoDBpShPd7XjhM2hDit7dCZd6hJvxup3v4qytvfMaM3TPCNuSFwCIVCuiYoYHgHqX+AkUV+EE+1HsntlAmrlao8mfefHmSZLraDCoh8sicEyMs9ZXH3W/Rrhx4bAJ9zGdabiM28=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(39830400003)(376002)(396003)(86362001)(83380400001)(6506007)(52116002)(8676002)(31696002)(6916009)(316002)(478600001)(41300700001)(6486002)(186003)(2616005)(26005)(6512007)(53546011)(31686004)(5660300002)(36756003)(4744005)(2906002)(15650500001)(38100700002)(38350700002)(66946007)(66476007)(66556008)(4326008)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0dxc2pYc05pUTFjaWJ1dFRteGxSZzBiSnZBTmRIV2F1UWJWMTZJTER1SThW?=
 =?utf-8?B?MVVQalpTMEpKalBrb3FPREFrdm43Z3FoRnE3TFNzNklGUGlya2tmMGN3WFE4?=
 =?utf-8?B?dkRJbzQ3M2RSNnJDOHgyTGJxYkRna1VNL3NZUUZ1L1A2VzU1SlYrc1UvNlFz?=
 =?utf-8?B?V21oNFJTeGJFTFE4T3I1MDNzaFRnWlByOFQ0QlNVUFFrS1hiRUgvcHdaMjRi?=
 =?utf-8?B?UWNiOVdBb3pGYjV4SEVicU9neVRKZEhCaUhlYmdCZmVRZWd5MVc5dUQzVFg5?=
 =?utf-8?B?VExFUjVhRkVEME1BWFNNOC9HWHNRZWsvcUpSWTM1MEN1Z3R5dzBpVlJldVdW?=
 =?utf-8?B?ZGFtc1ZoYzNPS00xUGVVYlpoRHg5NFdubnJZRFJLbmJNN1JRMUFrem1mbHRT?=
 =?utf-8?B?SDlvUTJUcTd1OVo2NTk4MytTeU5WVXhFZGF1WWFualdoaXlaWUtZTzN6T0tU?=
 =?utf-8?B?ZHU3TEhLNGZ3ZFY0RGZQWlFMU010eWRGV2tMTHN3cklwT29KZHBQOFNPcXI5?=
 =?utf-8?B?NUhxRC92ZmRmU0htd1BtMmZNNytYVVFpNXovb2lURnpVWk5KV01DcGdlZWJG?=
 =?utf-8?B?bmhSRFBqeEdpQ0hZR21HcnhQdWdQWWVJdERCSmJCRW1sSjhxWTdQcGlwdERk?=
 =?utf-8?B?VXAvcFo5a0p0NDZQMnRZa3doUFptaXlTTFp3M1c0Wm80RzZXZnhaUC9XMUFp?=
 =?utf-8?B?ZmVVdno4akVkM014NUtFdkFiT2N2TDVtWlkwNUtiZWYzcDE5bTRCZDZhQkNr?=
 =?utf-8?B?SUx4d2FqQWV4T2VwN1RtckdhdmV3MlJzUVRrRUNyUjVISGM2TWVKU1dzUXdW?=
 =?utf-8?B?eEM0NDFmVmVqV1cxd3pkOTk0ZHF2U01QamdJRzMwb1c3UStaeklyV0FCRHB3?=
 =?utf-8?B?cW9nWDNEYTlnSWg3ZTQ3VUw3T1QrSXpuSnF1dTJudVZhSUZ5aEMxZDRJRVN2?=
 =?utf-8?B?dGdHenV5WWhSbkJzMWdFdUhZOXVZV1BmUldIWU1zeUFSV0VrZWoybXdESFFK?=
 =?utf-8?B?dU85aElES2I5WFAwL2FNUDZCQkZhMmxibEM3blBrT0ZHc3Z5dm04eXc1cHVj?=
 =?utf-8?B?YmcrRmxGSnhsRFZjbXhHTE9GWGkzdDNVTmVrNjdnZ0JpV1NiRlhLSkViM3RJ?=
 =?utf-8?B?am5pUFVnbW1KV0pUTWxkcW5sN1ZPNURFRThpemVpZ2dtNzNlcUdWRzhqU0x3?=
 =?utf-8?B?bjBiTE51cjVyWktzV25ocGllT3dLWEZUUkMyN2N2Ynp0WE5BSGtIdXNTb2Fy?=
 =?utf-8?B?VUJwMm9aTmNqQ2RNVExvdWVONFFiK0gyUG9RcEsyR0FFN3U2U0tBSlRRR2xv?=
 =?utf-8?B?VkU5Qjl6b09BQUtSeHJpQVF0MGdCcFNnYWhuN3k4UXdHQnBydE9KWHJ2K3Rr?=
 =?utf-8?B?ZnRmRHJjNSt6SXJxYjh4clJLVmxVMFc3U0JHYlExNi9rUXhNVHl1Q0M5czRE?=
 =?utf-8?B?QjZodDh3Rzk0TTRRenI4L0l2SUJpczJvTnViU284cWVZOE52N1RBZVRrcjF1?=
 =?utf-8?B?QVJ0TXhOcHIwV21LdVVGVUJHUHNTWHo2NDdjVmI2RlVTcEVoeFovaWFMeG9l?=
 =?utf-8?B?V0JkN05jcWZ5MFJlait3bnYvOGFPK0VTR0V4VUtqRVV6RmJKeWZmZ0ZNV2xv?=
 =?utf-8?B?RFdxMCtMSnZrQ3ZKK2xiVVdCUnVmQkxLUVVrVFBtNXplZzFxRC80L1FOOEZn?=
 =?utf-8?B?OHJkcVFIZHEzUnFtWlpGWFEybURiTEYrVWxUNExIUmZmUGRZYW1ES2YwWXI0?=
 =?utf-8?B?RDB5M3VCWm5CREtuTFJDUHJHWTB1blFJYm9OVVJFODEwbXhBN2xESjV1S2RZ?=
 =?utf-8?B?L1UyY1NCWENINW0rMUpNL202cGNEd0dsa1VXb1BFTW9hc1NtK3o1dFFvTkNv?=
 =?utf-8?B?TTkyKzU4b3UyWmZPZU15UnFNb216OU1QR1NDc2lGZTBrUmJSK044RGIvZzVj?=
 =?utf-8?B?bTBNaUllUjRnK1VnM05mRjJKbGt1bEZlNTBoSzhMeERjcUMvdzI1TVkzNlU4?=
 =?utf-8?B?ckFqdm5mMFBKalByN0dIa2owUDQ0MEFic1FiTER1dVg4alJuVnNTQnFFdXJj?=
 =?utf-8?B?STdtT3pXYlhua29NZlRrV0ViOCtiS0JuWGFYeVdEOGFmVW15TlRqd2g5cksz?=
 =?utf-8?Q?5y1g=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a69305-8de6-48ff-fd5c-08da9198aa2f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 12:50:10.5955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ty7UknoBYrYDiZuBT21UW+aRqGocaZvA9HVbnptNE81aa+FoTrxM3wzR9PXlHuHJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4975
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/6/2022 7:46 PM, Namjae Jeon wrote:
> 2022-09-07 2:09 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/5/2022 9:58 PM, Namjae Jeon wrote:
>>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in smb.conf
>>> file.
>>
>> Typo - "ksmbd.conf" -------------------------------------------------^
> Will fix it.
>>
>> Wouldn't the ksmbd.addshare command be a safer way to do this?
> ksmbd.addshare can't update global section now. So I thought it seems
> appropriate to edit ksmbd.conf directly in the initial running. If you
> still need to add, please let me know.

I'm confused. If ksmbd.addshare can't add a share, what can it do?

Tom.
