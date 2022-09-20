Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82FBC54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 20:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiITUuA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiITUt7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 16:49:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49F41CFDC
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 13:49:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8D/OO9l1wUsqhxCyct8C/0YTbrqns2OPtoFkf6LyNH0SUNF8PD15HWyKDCw9uAaaFvUs7skosGCniJpQDFzEfQzit3DlCVi4TcDZG1uKajj+tOqo2Zt9itjBSAnnZZD9U0XumQWcodU7AuB+KXp4cOo9hdFmyz1OD48Kij9kCxAOo6IYO017DHHFNby6DW5vkBzeiDhco/nw0wlNIbCLK7tjXE6d4NqXsQaEGdc1FAUdee75MQNnchVwPekilTrklvSRWpcKdf8JDImtP3/vAwr7x2rGvfVvQQis00OaJ3Wj1OEF2HhMdRFo0aMbV5ZgqOykGw2BcIloXISdECgKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mPPmG4XZSztt/KCnkNPdp1ix7PYgUb5Pj5UgGIWGVgw=;
 b=FAjkvvpaLA7HDDf+08zhrQAk6jDCKosWlzbijb8XquMeo+noqDm++CX7+dAISblvOfM4oUQf04xwGim1gwwObH9EaHE9dbsqNo2s/bldPwkpUxuw28oOjIIO+c5jmerE5hD7I/yJKYRvnl7POrWwjppZODj/SRqGjd52DlbuHIy/Di1uypDYX7JnPAFqvwEgFLiEUcHIF2O8WTzWPVANnGjy0llwdbY74BSXCYHuOgSgLcDxMiARZHK2+2CwMxgCnjXq8owT2RybpR7q6bRB8b09D8vuIVwIgD26E4UtgcUawRvVq94FJF4EwZku3DnDhZdQz0MMOTSrgkDPqKgq9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 DM6PR01MB3692.prod.exchangelabs.com (2603:10b6:5:92::26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.17; Tue, 20 Sep 2022 20:49:53 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 20:49:53 +0000
Message-ID: <49d7e40f-098b-66b0-d347-522f7c49dc71@talpey.com>
Date:   Tue, 20 Sep 2022 16:49:51 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] cifs: check if mid was deleted in async read callback
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220918235442.2981-1-ematsumiya@suse.de> <874jx3l8zg.fsf@cjr.nz>
 <CAH2r5mtW=tSu1YtP1xCfDUZ09ykd-ca=Wr=z0QKrH6j2xmD7Rw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtW=tSu1YtP1xCfDUZ09ykd-ca=Wr=z0QKrH6j2xmD7Rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR04CA0006.namprd04.prod.outlook.com
 (2603:10b6:208:d4::19) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|DM6PR01MB3692:EE_
X-MS-Office365-Filtering-Correlation-Id: a010e371-5271-432f-b5ab-08da9b49ab31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fnBx8F0MT91dM/CQ7dxCr0l2+RRS7aMSZy7xVH1B3esVVNHHF12v8vs83L8VjG5PJQ3y13cjY75RDOYX+NlSvSpHX1860uTlnvIFaKpw5PWR+9vquL60Un+LkSGqVOtym2Nbr7v4H3KvTRUJL5LANOKKhMEJ/yo+Dv6rUGi83iUHZemvzoux2Zy8Q2nNZgs3eyNgtCA/Uz2GMNfxxho8MNEfgjjHjbnfvSY4ZwqDyamvTNTUrTjI6PpE/1LrE4mk3tpCLNGVJIbMPqoeAbeWmEVdMfgQYNDxI6RygqqqLpeeKSwiY2/Mze40J+AMr/95MdXQZb8orYlWZJgKnLTSL7QngcBtulq2p2Xqv6uFivjQG+2mH5dPCsPHIIdgfszD4PbwYGyWcKH5AAA0GFwouQmQqqLEW6x2huG8cHXmDxF7DtXGKl8WXc8bnGtxgZz4OwTSBTNAMOUDdTuc5qUD60juXcJFkuTxOZiEKl6wAAnaac1uClRxHETr5NSbMsZl8WKyK54boUkaIajP+6wp+CPQk1axJbjHx6Hdrd7RaCsMXJeuIS1zsDDwkU8Hmd9t4xqXlufqWfSo3yio0dfHbMoqdsgW4amoPtD/WtabM7eme471n4+qomsXHI0imupab1T62+84v9lI/dUCD2T0TduKB+sTBMwrfZ81XDLjcN8sD08PPCyeJVjhuue/njE6ggjWJjogW9kifYSXbYEFVTH1A0akWzBE1RRAP77Ih9Lvbg2isqasnTA0WMJjXEee97Jt26fBcT3I9OwsMDhSYl109jyReetfmIffGpUI/bc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39830400003)(451199015)(478600001)(2616005)(41300700001)(6486002)(53546011)(26005)(186003)(52116002)(6506007)(2906002)(6512007)(110136005)(316002)(5660300002)(66476007)(66556008)(66946007)(8676002)(4326008)(38350700002)(8936002)(38100700002)(31696002)(86362001)(36756003)(31686004)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VngrY3pKK0JmR1NQRlNHbHpVeGRYTTdGSEJZd0JXQnRhdDdITVp6VHFFR3k5?=
 =?utf-8?B?SnBhRkFhdFNnSWJya01vTjRaM1FUZVpZRU0rZDViRklEeVZSeElTVXhqdmhT?=
 =?utf-8?B?bFN6NGJra0JJQ3pFT29FRHd4S2JBd3JqUnpxei9RMUtOOEkzOUorWXpnelJF?=
 =?utf-8?B?bWF0OTJwYTd6Y1BDWkxMcE1Ia0hmdHlyOUZEL3JRbysyTjZYY0xoMEt5YVJx?=
 =?utf-8?B?S3pwV3FMQVZET2szWDBHeHJtMkpaRXVlUGRxYytqUUpOemhobFJkUkl6RWlw?=
 =?utf-8?B?MnYwc1doWWJqYWJYaEpsYXBaYUt0dHNqd1BFeFJweVBTcnJ4VVNQc2lpUTZs?=
 =?utf-8?B?ZGpLaytrRFFBR0p2bWpaUmFlMDM3Nm0rOWQ4RGJyOGkzcTVoN2FhbXJFclBx?=
 =?utf-8?B?UUlRZEsyTE5ZVnNZV2FybUIvWHRqNlpybkNkYVJMUHNneXZuOTNQaEgwdmZW?=
 =?utf-8?B?b294bWwybVFiakFOTHJIN3lIYkxSQ1FGM1JsWjR1a0pEcXc1Q0xaN0xkQWow?=
 =?utf-8?B?VWFXekRWMHl4Zyt0ZFI1S3VaMzVDaXd6akhmZ0FvQnJPTjkwTTI3bFo0Z0Y0?=
 =?utf-8?B?aVN4YlYrY0xoNmJUdnRTTjB1UmxCNENPMXNHZ204OTExNEk0dG0rdVdlN2Ns?=
 =?utf-8?B?MU5VSVViMWo1MEt4VEYxbjd3eStoK0dSZjVYRFlpSGVWT0NXM09iSG9SMWF6?=
 =?utf-8?B?UE5vSmhib1hxRnp0aDVIL1IrTU04WkdXWUxNdkZSaFhNQksxd0dicW81dFRy?=
 =?utf-8?B?dDlrMWdMdnVFMk9icVYxRUNOcWVDQ0pzblUyNWtvNlgzcGV4US9zSkVpSFRj?=
 =?utf-8?B?REo2YnpxOUhDVHRnVC9LS003bE51a2Ixcnp6L3RPL3RCVUFybU5SZnZDYmh4?=
 =?utf-8?B?Rk9CdzY0VGtZSVhSK0VabCtTaXorSjRidU9DbU9ReHA0QW1icUFiaE04cmVw?=
 =?utf-8?B?SS90cGl5ZzVNa2RyYzJObTFML3daVktQeXVaZFFaYnc2OFlxaUNMT292bWVv?=
 =?utf-8?B?M2RPYmFyS1c2T2RnZUdiVWNzRmoyeGpUVkNQRVE4aTB1YnVzOFRlZ2R6Sldw?=
 =?utf-8?B?MURlNkVMdDlKcnZ5cXVZeGFZNlpRd3RiZlM4RmpRd2tqNXpiYmhIdmw2OXk1?=
 =?utf-8?B?UFRTNlJrTnNINDdzQzROTmdrTjhGQzlNcnlFbWJTWG8xWGFmTkFGZlBaaFgx?=
 =?utf-8?B?bUE3WWNtd0ErTHVDQ2JES0RGeXF0SEFaNXg5MlB6a0M0ZFpDbDFRWDgzbFhF?=
 =?utf-8?B?cUJuVEZxVkxrVzJMMUw1NVdhdHF0L1AyL3BSVEhRUXpUT2dhVithdTl6TXhx?=
 =?utf-8?B?QWg4MEZSSmQ4aGJkUThTOVdrb0pKakhWTjcybWs2bThqS0ZMVnkrMGJxdWFs?=
 =?utf-8?B?S3NLSHZpRWJuZ3Z6NXpEVGJ0dmxOYjFzZlE5czR4eWppQTc5dE5rdTBWUTIx?=
 =?utf-8?B?aHp2NDlPd1lLOEZYaC9BcCs2UmJrZUxZNy9oRlgvTEE4U3cyT0k4WFJLSmNR?=
 =?utf-8?B?Y1lxSXc5RWJLdnk2WXU0RWxXRXFLbzAyeEM2SDZxRko1c0gvVUM4U09UUlIx?=
 =?utf-8?B?T0lIN2tUVFBja3dpeCtFMUdUTDJhZFhodXdDRkJ1M0tmWitPS0htbUhSd3dM?=
 =?utf-8?B?NHpTcDNQMnJlbktzb2lmK1RLMUp6eXBXdHRuT09FejFjWVVVQkVibktQRHRS?=
 =?utf-8?B?T3NIcERIeWxNTnlIc2dmbTJpT2lFRWx0ZWkwdXFobUtiZmprV3N0bHU5dTNG?=
 =?utf-8?B?YWZ6cG1INXVoSkVDdjN5Zit0bUdYQ1c3Mk01MWdJOWd3YU1kcnkvWXpiYWVU?=
 =?utf-8?B?T3FKZjlBdFBYQmJmQ2VCbmxWamRTZFRqTTJIWjNESWh2Vmt6ZTFSU2Y4OWRs?=
 =?utf-8?B?R1V2ak5nUnkvRERrSUc2YTB3NGx4cjZMOHpkTDh4OXZMbDBSVndCa1dXQ1JR?=
 =?utf-8?B?NDJ3OVc1elNIWSsrZmc4ck5hNnRtUVhEeVAvNitVOWIwdUlWaU04K2Y4MFNw?=
 =?utf-8?B?S0dSL1R0RStMcE5NdVhxUy9Pb3YwS09IaWRXamxhVTY1aXN0NXIwTXNLZndZ?=
 =?utf-8?B?YmRyOFJ5M2lzbGFLelNCc3c4UXBBZytXN0dZQkJYMEVzVTZrU0lLZ3Q5Q1FI?=
 =?utf-8?Q?pEXXravk9bzOQyKPSCRiQF6Z0?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a010e371-5271-432f-b5ab-08da9b49ab31
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 20:49:53.5613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpmDYjLDITm8g7TH4obrG/5fzUKRAwZaKoJf/Q8fk67bBcFnkPSp+VxhlpPCBkqh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3692
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I guess I caught up out-of-order, replying to the other thread.

Catching the race is good, but "dequeuing the MID" has nothing to
do with signing and should not be listed as justification. If
the message is being processed, e.g. returning the status field,
then the payload MUST be validated per the processing in 3.2.5.1.3.
This validation requires only a valid session, and the message itself.

Apparently the code is storing the decryption status in the local
mid structure. That's the root-cause bug here. The signing validation
must not be skipped otherwise! Poking holes in security is never a
good approach. Can the decryption boolean be stored someplace else?

Tom.

On 9/20/2022 12:15 AM, Steve French wrote:
> merged into cifs-2.6.git for-next
> 
> On Mon, Sep 19, 2022 at 9:43 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Enzo Matsumiya <ematsumiya@suse.de> writes:
>>
>>> There's a race when cifs_readv_receive() might dequeue the mid,
>>> and mid->callback(), called from demultiplex thread, will try to
>>> access it to verify the signature before the mid is actually
>>> released/deleted.
>>>
>>> Currently the signature verification fails, but the verification
>>> shouldn't have happened at all because the mid was deleted because
>>> of an error, and hence not really supposed to be passed to
>>> ->callback(). There are no further errors because the mid is
>>> effectivelly gone by the end of the callback.
>>>
>>> This patch checks if the mid doesn't have the MID_DELETED flag set (by
>>> dequeue_mid()) right before trying to verify the signature. According to
>>> my tests, trying to check it earlier, e.g. after the ->receive() call in
>>> cifs_demultiplex_thread, will fail most of the time as dequeue_mid()
>>> might not have been called yet.
>>>
>>> This behaviour can be seen in xfstests generic/465, for example, where
>>> mids with STATUS_END_OF_FILE (-ENODATA) are dequeued and supposed to be
>>> discarded, but instead have their signature computed, but mismatched.
>>>
>>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>> ---
>>>   fs/cifs/cifssmb.c | 2 +-
>>>   fs/cifs/smb2pdu.c | 2 +-
>>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> Good catch!
>>
>> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> 
> 
> 
