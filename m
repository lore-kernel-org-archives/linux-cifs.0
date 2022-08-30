Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E608ECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 14:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiH3OD6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 10:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiH3OD4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 10:03:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EEFCD52F
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 07:03:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD5y15lW5BctpV7w3HRnRHd2oSmZgt2ijkOfwkSRCGo7eHNF/yPNs17G7bfxBBQVrDWgrnwxzhMDFHK2iRc8Tc0U9VvSxPVK3Rtf4Gg07sUAzoplWx+7MgtDQmRCfBHsQ+KjbLfQAmkP4awul9W4AkcjcO5/q5sGo7RWn46HtvdaaC3NCcVVq/iorjp4sGi/JjRZWu7Jd24wK2pf2jrpo5LO8rk5RBPm5ewLOGcCbFP9ZcpbMw/1DnjkHFv+XPFLmw2U+Mbw43qB6X7RtNTn/f9BThWOeGpim60Gdo4PN9/wbQJ+/QqYFuzyUbcTIDmkDzl4wzB1PzEvM1Y5ik7bMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nRK/ph7krodNxEerPszTdrBDJRgZeL7T0XRAzA9nZpY=;
 b=Zg3kj4MeB5gOOOfKqz8PNRjbdiqh7PXcHirmfoP+Tx1WvzNJCy6UPi1CXPgwZvi6MlQpg9KmO1opgS2RnpJdmgHiKoPDuO87F9ozuhSVr4xV2yjLhU2da287dS/PoQBQSU13ZT56mOF7DK9KWa0tqMqfXlB8DC/XLnK1DVYAdK8xQ1DPIVRQ6/6iBngBU84SBH8Y9M+10F2+o8oyNhrcFWH3LRuGxjMBAnLdAEM91/rEI1miaKVugMecae5XBbFdP+Wi2mpdgDdnVl0Rn+/hnj9sOF6ZwVCzLUlhtnN3bwsFsJR+jCmuh7KSHlxnDL8xbjS7ioJOGeQ1dt/UT0//hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6140.prod.exchangelabs.com (2603:10b6:806:e4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Tue, 30 Aug 2022 14:03:51 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 14:03:51 +0000
Message-ID: <4d6633a3-43a5-8a4b-991c-d8148ce949b1@talpey.com>
Date:   Tue, 30 Aug 2022 10:03:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO
 message
Content-Language: en-US
To:     huaweicloud <zhangxiaoxu@huaweicloud.com>, stfrench@microsoft.com
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, pc@cjr.nz
References: <20220824085732.1928010-1-zhangxiaoxu5@huawei.com>
 <495c09a3-003f-7852-ef14-ba7e26984743@huaweicloud.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <495c09a3-003f-7852-ef14-ba7e26984743@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0133.namprd03.prod.outlook.com
 (2603:10b6:208:32e::18) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 301d4038-d535-4d19-f190-08da8a90777b
X-MS-TrafficTypeDiagnostic: SA0PR01MB6140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XtAYMI7jRhbsZYp5CozGaOh6CoexcAIhrrJsXbW1cKwK4ucpicAVfQnrLWMFUOT//5n3nrFV21jAT6DH3yHna12DzxyXWU8lbxKlDfcW/dOk1ZhZkBqizb9aoE9NzYPqi7jwIuURIPgCWRvSpx769OTSNUrU7pVznuqA4DXLdeBpirCptTdm+HqR6QQGoPYXNQfG6VJGGIrfAKp6V2baOsr98a28PbU+2oPA2pygIcpTRHRx9QLAYbNalQPWVeKmb/vEmdpq0JmRlkf405FgAeyMRxA4ixuceMBy3JK+lMOIP7l9Kwd8eqyD97Ubt9SXKO2zk9XB465cP6HhLGfxpt7fa3nlNwBsfKvLWbk5OXeQJntqUjUz7OOEtTKnD2dAl/LeGvkk3H1p7xmKiWDc7biymcvdQkXn8s1UB+SwG3RkGFwhnU6Jhc9a815225URJi9WRb3pju8uSnWqFP2/xLJ3F1C4EQApvXetdZ2zxfJjK19OGFAW9nOywxNsaUQ6JekwYf/C4jaL83q0PM8zajOYOkqu1UZcjPIIfd5iXqXB4Lj29WmGF9RFdAXU7hekvhw/eVK7Y+kzIC4uK5Zz+EIuLxn4bETvuaRBXz3ze6ER+/ed3kYTpwc+6iaqJRirCdrZVM7wK4ogP6Tw6U0cxlxnjvO6KM9BrzzVgv67Qxr2GeyFnusr0N6oLdlDVanXdJJR8uOs4/Lh3HDm7OqH22BLtvXS4XTA3k5p7rkecXmsjHv8AwsN7RIRk6OQlCm1PK7bXhAFJu1z2x57tY9BAIjhuM0rEs54I6zuPHmomBo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(366004)(39830400003)(136003)(52116002)(15650500001)(53546011)(6506007)(2906002)(38350700002)(2616005)(83380400001)(26005)(6512007)(186003)(316002)(86362001)(66946007)(31686004)(8676002)(6486002)(66556008)(31696002)(4326008)(66476007)(36756003)(41300700001)(8936002)(5660300002)(38100700002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTAyMUpDUUYrUFp4UWF6UUlDR24xL1kyZG5VSGFUQ2FkMDFBbmRQd1NCMEhD?=
 =?utf-8?B?TmZ3ZTlnQmF3WkU0aXBtbjE5YnBFN0pYVUlxV0FuVVpYTEdMbTl5c0xDSGpU?=
 =?utf-8?B?YllrV284Rmh0aXlHSWMyMmIvREZIeXdjc1JQRWZ4anpic2RLOGRKZ1NYUTRX?=
 =?utf-8?B?R0lHSUt6Z3gycm4vc2JXdTBGd3dPdlZvSHIzOEU4Rzhld0N3N1czUGJ3VFRV?=
 =?utf-8?B?OEZ4SmtoWUt1YXRzZ0k1alJacWNjVDFuV2sxa25QUDZ3TVBvN1R1UUkvQ3Rp?=
 =?utf-8?B?OTFkdUttYmdwU2xPR0NLYmowUTR5SW9mTWkxYXBMWTFzeHZRNnJiRmVXV0pE?=
 =?utf-8?B?aGttdUJ5MGs0djVZMTgzbjloRVJmYnFKRmc5OTI1QmpCQldWb1ZFT0VpSFA3?=
 =?utf-8?B?RU9WV3hPckI3eGRaYU5lNWV6VTlzM3I1aUdCM0xaeXRiSndLWitxZkxaV2pV?=
 =?utf-8?B?djVic1N3S0JxTUNBdmdEV29iK0o4c29NcE84MTd2ZWp6RG9nVloyNUJFT2pu?=
 =?utf-8?B?Tmg1NjFIRE0rcVZQVHVhTFJSVGl1cUg1dzVqV2szNjY3QlN0aCtwS0licXgw?=
 =?utf-8?B?RUtwekFlZWdWV3Rtcm9VaWlaRG5sYUtMdmd3QmE0SHlEVjltZzZpdHJiR0ha?=
 =?utf-8?B?djltdkZmN3lkc1RsQWdpVEl1K25GcW9nZHhYdFBoZmFHMnFMV2svMGZYcG9Y?=
 =?utf-8?B?ZUtQREoxZUIzNHBLdVZDSFdPMER2ZkJCb3ZDQk9mVFZRMnVMcWw3QVcwSVY2?=
 =?utf-8?B?RVlaZzRGWTJKQ1g2bFc1bC91aHFvaG1nRmpRWlRYYWoxalhsYzdYY0xmMGNB?=
 =?utf-8?B?YzNFTGtrVlhvWlpKbk02YU54RkdmcUhqaDUzcVBnV213TWpUK2kzOWNXMkcw?=
 =?utf-8?B?cEx1RDU1cm5qOFZyZHZsMmZGSFYwWjdsY1JGUWpkQWtmYmRmS3RqRlRlWFlB?=
 =?utf-8?B?cnl0MEd5b0pza2gyODNIcHZRaDNGT1VxVzVhZ3kvYVhQQ0VLTzFDRHNuWllY?=
 =?utf-8?B?bEJXa3BSSUNzMFFEY0tlZlUxQjlpNjlhUmlNYUNsbllicFFjWjRpbjZnSkFO?=
 =?utf-8?B?MFhEZmlUV0QvZDFyWE5qUE5JNjF2Sk9hMThmT1pYWmtzVnNjKzNSa1d2TGlN?=
 =?utf-8?B?a1ErMitqekQyTEdtcjRkTmttcEFMWXlmY1FRdzRqSGNpT0RtRUV3UGNyb1JS?=
 =?utf-8?B?b01POGthMHM5c1MwZVFFWVBwc1UrdmZXQ0EzVU53VE5rVnc1TnJ5eTdtSmRT?=
 =?utf-8?B?NFJnTVdkb1Bzd2hKSTBENGw3YzQrem1PSVJGdEJ0eTRzUm9HenhQRTVFN2sz?=
 =?utf-8?B?L0E1dXk4clYvREdnV3FKbFpUWU8ySjVnY1RkQ1hPMmV3ZTdvY09LYnZ2NU9s?=
 =?utf-8?B?bmNXa0NhRi85Q2djcmRDSStnZlpNT2l0aUd2MjFISyt5ZDB2dlQwWEd6cHly?=
 =?utf-8?B?NTZ5VWM0WkdUSVorU3BCMnlXSEluZkF3d0NFOVNQcjhwWmswS1lhb3AyKzJy?=
 =?utf-8?B?cFJtQ3JzU2I4eXhhdzd3VG1ZSTIrWnR6ZEdkK1dNdlF0aVZBd240MU41dHlL?=
 =?utf-8?B?RWZkb0NTRFRLNDY5d1JyV1RoM2ZIbjVtVENGV3FFSi9pVU1NUVBTK1krNTBO?=
 =?utf-8?B?SkZGM2x2VXFVMEZJNzBMV0t5YjB0Rll0dzZwdDBqbFI0L2E4OW40UmlieGNs?=
 =?utf-8?B?RmhWb1FnbG9jWmhlbXFlZzVLWHcxb3FrTWsyYWtJa2d6T0ZMTjVESEFoeWZC?=
 =?utf-8?B?WEd2UHMyT0NOSmMvaFRBOHViSXhicWsvRnY4cmM1MVovYkEvY1lVRUN2ZlZZ?=
 =?utf-8?B?bURybEQ4MkR0SkFoSTlXamZGeGZaR3krN2hYU3kya0VveEdOdGRtdk41Unl2?=
 =?utf-8?B?Slp3TmpEK3NIUGRSWmtYY2wzYVVqN1dBWnByaGdZMEdadkhWVVhqd1ZCbUtr?=
 =?utf-8?B?Rms1T29nR1RiWUhjYk05c2xyaTh0U2pWajdQOVFjVEdneWFnYmtZTFp5Yjlv?=
 =?utf-8?B?TVNrU2VzQnlFTjRHYzc4ald5ekMvVUdJck12REVBbmpTRzJaOE9zQ1crMnA0?=
 =?utf-8?B?c2FLaDhVNTRLUUdBNjA5dGppZW45bWdaUm5rNWRmTFhqQ2xPYjJGS3JEVGJu?=
 =?utf-8?Q?iedA=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301d4038-d535-4d19-f190-08da8a90777b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 14:03:51.2600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LfvCmZL+2kS5ClCBT008MalX93In0+IXeNG0f+ZbTbxWPL0nK3QyVjQESGhP3kLz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6140
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Wouldn't it be safer to just set the size, instead of implicitly
assuming that there are 4 array elements?

   inbuflen = sizeof(*pneg_inbuf) - sizeof(pneg_inbuf.Dialects) + 
sizeof(pneg_inbuf.Dialects[0]);

Or, because it obviously works to send the extra bytes even
though the DialectCount is just 1, just zero them out?

   memset(pneg_inbuf.Dialects, 0, sizeof(pneg_inbuf.Dialects));
   pneg_inbuf.Dialects[0] = cpu_to_le16(server->vals->protocol_id);

Tom.

On 8/30/2022 3:06 AM, huaweicloud wrote:
> Hi Steve,
> 
> Could you help to review this patch.
> 
> Thanks,
> Zhang Xiaoxu
> 
> 在 2022/8/24 16:57, Zhang Xiaoxu 写道:
>> Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>> extend the dialects from 3 to 4, but forget to decrease the extended
>> length when specific the dialect, then the message length is larger
>> than expected.
>>
>> This maybe leak some info through network because not initialize the
>> message body.
>>
>> After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
>> reduced from 28 bytes to 26 bytes.
>>
>> Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> Cc: <stable@vger.kernel.org>
>> ---
>>   fs/cifs/smb2pdu.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
>> index 1ecc2501c56f..3df7adc01fe5 100644
>> --- a/fs/cifs/smb2pdu.c
>> +++ b/fs/cifs/smb2pdu.c
>> @@ -1162,9 +1162,9 @@ int smb3_validate_negotiate(const unsigned int 
>> xid, struct cifs_tcon *tcon)
>>           pneg_inbuf->Dialects[0] =
>>               cpu_to_le16(server->vals->protocol_id);
>>           pneg_inbuf->DialectCount = cpu_to_le16(1);
>> -        /* structure is big enough for 3 dialects, sending only 1 */
>> +        /* structure is big enough for 4 dialects, sending only 1 */
>>           inbuflen = sizeof(*pneg_inbuf) -
>> -                sizeof(pneg_inbuf->Dialects[0]) * 2;
>> +                sizeof(pneg_inbuf->Dialects[0]) * 3;
>>       }
>>       rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> 
> 
