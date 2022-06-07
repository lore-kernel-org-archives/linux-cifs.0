Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E052C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jun 2022 17:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347085AbiFGRc5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jun 2022 13:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347465AbiFGRaq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jun 2022 13:30:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C761A1116FE
        for <linux-cifs@vger.kernel.org>; Tue,  7 Jun 2022 10:26:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRh2hjKc4Ib0hrh1I0r9ixMv3R/kAl9ZePILqIsdZ1JaE5DRxplhT5kp5achNdycCCnCDIbB+H81LrLbW6GPMjNApYGfYzDChhvW8dlcWzBDQkO3N0NAqZbcw2S5e3yUnyz8U/lalGMjMjjhXMOugn8A+SzsA71j1b0Sv0QRizQ/xa/ZicKkBeC5/i94xIonW1OMbKQRFpVMSTLRNrgPXECC2a7FjuluRFd39XsXPYYDdCoV38ZcidNfe9KUpGVWYWJjmSXSYgla1nN/kXYPkq+HZKLry4EssvZU9RhN/G4ywLD9f9fHeKx1YZFDH51TNrf4wfRm9GdJAMmHzQDBqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=55U4ARvbI+wY/8JmFZTRWqBBz7kI5FxyMKY9uAUHWdM=;
 b=UKN8U5/qtVKgThDB7XW7YGdVMPVxzV+x0CvD2fLASYiGN2rNZ119H6C0YvnefoZnfUZRylm91XJNfZ2Pi2XBYQmTMbNMbv6eDHF34YI0IlF9NAs+cia4ljcEpUiBvwrPyiFCF8yrK0GlqDIt2pG2j8KOI4wLj0nGof/Br7LYcPLTZtkURlqxOf9xkAj+T/bgbhRZZJzcCykd72G/Zwdy+Qujo/IJLIrVyZfKsN/v/DcVTuX3LZC1qMcsqUyBi7H1TcAOpyYFnrPio5Z88W3DtJ7HhkMWbGmtke+Gj/PzAwOHZRv3mSZwLqOIlQRHWM9lFD4jjDtR+2q1HvbxP1kRhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR01MB2813.prod.exchangelabs.com (2603:10b6:300:f4::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Tue, 7 Jun 2022 17:26:48 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d478:8cfd:21ee:776f%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 17:26:48 +0000
Message-ID: <82a4f87f-202f-2032-1380-8d58c6af9761@talpey.com>
Date:   Tue, 7 Jun 2022 13:26:46 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Long Li <longli@microsoft.com>, linkinjeon <linkinjeon@kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
 <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
 <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
 <PH7PR21MB3263E3978006A32714AE5357CED79@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd9SZQPkxO9TshgbHGbwzaDN1Hz6dhT-pNDYpD3icjB4HA@mail.gmail.com>
 <PH7PR21MB32638DEF77D5B541B3F0858CCEA19@PH7PR21MB3263.namprd21.prod.outlook.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <PH7PR21MB32638DEF77D5B541B3F0858CCEA19@PH7PR21MB3263.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0432.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 281c85a4-a90d-4bb6-a9aa-08da48aae6f4
X-MS-TrafficTypeDiagnostic: MWHPR01MB2813:EE_
X-Microsoft-Antispam-PRVS: <MWHPR01MB281396373B7CB6C7BD5BFFF2D6A59@MWHPR01MB2813.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJZmIfgiqmNWxc/RXCvJNBAfOw5lNBMq8z2G9o5GGxBODgiUbD5AvpaIauRhbHLPC3WgT9qKRUoOq6vK0Ni3TVYbLQPsVHdJb3Nwm4zLxJoweH0+W3mgBgd/CDCO1f/Yn0ifWnfu6w25kveA+x/s3EprzDgfsx4yKnhqsP7E3GLDieIV8DifaXyINCpKGRDr/TLToNFMwmBrNYntPS5tYnrWvcdoSAFudLCYO/uJJnDNw+wxoMvizPxoOTn/iIRuEMUTQHKNKUzNrBcBQ6uDcxJVEIVEnaCWn12Fu0+YBeJ2o7JllnkBnY56+Aubcg7J5/CJ1w/r5wmcbejIIsMjuAHAJIlRxZprYCLjE5YU1QdhxjzvPKOOUFEJTlbSqay0wdor7mA1imzr5a8cWj41lUC5vQ/mYHlt7UthsXUf+ec8jNcfjCTbmhFIBsYq1d8NCFxOY/PP2JhhVMJg3ghxVVY2f1A6K9FLiJAEySTs87Nj0YgZiRvjnvCtbXZP9kw3mGIDkbk2yE+Wh4dVQZATrFTyO2BWjMKgqjvaShCag2S9+fWapKfNfL5HDU1G0a/LbCaMmuMARJshxKx6DYBHiOYrk5xNX8pDyLU+qFl724LZjDd0YxFjbjGt0cNkl4g/J4tXHgtlWBkiOQGEzr6r6vLfxylA2Oe6p1Q/SNSUpukN8htIPliHjXhQG+3RZ2fvEeR9IrxhdrTYq5kS8nFEu8NK1Q7dQZcJ8W/tYMHqw9I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(346002)(136003)(366004)(8936002)(6486002)(110136005)(316002)(54906003)(66946007)(8676002)(4326008)(31696002)(52116002)(66476007)(2906002)(86362001)(53546011)(36756003)(66556008)(83380400001)(6506007)(6512007)(26005)(5660300002)(38350700002)(31686004)(2616005)(186003)(41300700001)(38100700002)(508600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TC9NaUd1YTA1RTVSUUNyOFNhWHRRaHV3WGtHTDlHdFMyWWJHUDJKRnhCRjVn?=
 =?utf-8?B?ZmxQRERueFF0MUI0Rkx4TGdUUXVrVnBmT2xoQUt6UitFWDhJY2ZVdFRBSnpL?=
 =?utf-8?B?VXhvMzV6WjAvem9FVi9RVkFMT0ZIU3ZRWUl1Q29qMFpJRmRPRjRmbWU3QXU0?=
 =?utf-8?B?enRObktJNk5IaUthK2k1S3FOZC9KR1ZsSFlrQ2s0TVJ5RGRXU1llMlZwa0tY?=
 =?utf-8?B?QUdhUjFEeSsxVk56R29ob1BXSFFtZmpaUDB0eWdnWlpjSkVpOElDcWsxMW12?=
 =?utf-8?B?OFlDVkJHejY2UmNoOFBqZjh4QTFRWVdWZlVkSjkreDZ3VEhnRzZXbmRPd1R1?=
 =?utf-8?B?UWlaQm1nV1FNYVM4cFdrbmVTamRnaE5URGVCcUtEa3ZjQllNQWw5YzZrOXdT?=
 =?utf-8?B?UGhoVjhtQ0hBTFNzWmdhOVdSTi9NaTZPanF6S3FBVHYrL0kvMUhMSUN1SWdp?=
 =?utf-8?B?S0oyUTdtdXZObHhXNllndDgwRzF2Y2lkNmRGUWJSOXNaS09lQU1UK3plTVlH?=
 =?utf-8?B?andaL1pUaFFTbXprdFp0RDROeHpFZHdYMkJMVWRHcE9XT3EwWm5iRGJ1RVBF?=
 =?utf-8?B?bDdyTEQxMUFKT3pEWEM4ZUo0R0g2dkt2K3JYN1Y0YVZ4eDk5OWhnb09uY2JN?=
 =?utf-8?B?YlNEeDFrNWIwejVhYjB1ekJBaHVFdTRnYlp5VjcvS2RRTHg3eUExZmVHWDlY?=
 =?utf-8?B?K0FTYko0WkJxUzgwWThORW1EV0F3Szl1cDgrdHkzaW5BU3RrOVNEbHVCaWZ0?=
 =?utf-8?B?cnpuUHZTUjBmV29MaklVUTdLV2QyOWdrNTh3K3RqUU53R1l5NTVLa056TEJW?=
 =?utf-8?B?SHhXbzQ0YmxZdUxSc01DRFVxaFFuMHRyRmV2VFlFRW5HNTJtWWFhdElwWXA1?=
 =?utf-8?B?UkpKRm84aW5GVi9EdHFWODNKNGZGUnFpSUxlWjJnR3A3VHEzRkFiK1dKV2My?=
 =?utf-8?B?bXBYNlZkTWlSVldxZEtZdWY3dHpjc09XQ2pWbDdPaFdmZTExOVdYMlZGWThO?=
 =?utf-8?B?aVF6RWFRbjRIcTBYR2JLTndRcGxKTnlOY0dqbTZ5N2VqYlN4eDg4b2N1M3Zj?=
 =?utf-8?B?SVptVkQ5anc4cE1IY0ZqNVBUSk5OYTJ4SGMxT3BNWStPQ2Fhcm5NMkdoTmtN?=
 =?utf-8?B?ZW5sbnNpaXprZmNzSS9La0xLdmxMemNDL2w4YXVjMFpzQndtYi9KOTY1TmMz?=
 =?utf-8?B?eE9CU3d5Y1dQUnpYM051NURQWjlmRHF2MGFOcnFnanhhQno2YzlSYjBoSmZy?=
 =?utf-8?B?YkM0cGJZRWpaTmRnZnFFaktycVdpekFxTFNlRG5pdFhZMkh4WUhaN3B2OWlX?=
 =?utf-8?B?djVKd2ppWUxiOWJ0ckZzTnJKd0VnMlJWdzFSeGhBUHJ5OVFVTmJFNlVYN0dk?=
 =?utf-8?B?cnVSdi9Jd0l0ZVJvQ2JoRFNyNG5GM3Yvb0I3bEVDQThYZUZncm1tamN2bHJM?=
 =?utf-8?B?dGswZjZEdGo5TlN3Mk9pR3l1aVY5MGg2UDV5QUxMZ3NzQ0F0eUFna2tBbWp5?=
 =?utf-8?B?S2hTQisxblVwLytLSDJtaXFjakxMaUIzRFMyRVh5Q1llTHJvdjhtZURydmJO?=
 =?utf-8?B?QnVjMkF4cndSTGlqVjRhdDhGL1lSNmkwdXNISjk3K0RkaDlaQkFPZEpDWEN2?=
 =?utf-8?B?Nzd2c3Z1VFJIVEozRlQxSTljS1lkRHlwMEJMTHgzRHlQd3pJTTFyNENleFBL?=
 =?utf-8?B?akV3c1VGZ2xpWWcxWUtkbGRoQXk5VVIvVTVSOElBTUViOEpYemRVT01KcmJy?=
 =?utf-8?B?anhCWFV2eEhJd1ducTVmYmdWN0M0NGIwNUNZZzF1SXpRT0VnVm1ad09lZFRH?=
 =?utf-8?B?blF5a2hzUEYrbmdpVVhtRUpQMjVpbm5WU3IvMldOVklTY2l5U3FjMGNFeWs2?=
 =?utf-8?B?amF0amxSaVYrY1p2aEUxdHpkbnN6WjlSbzBndkNwQ2x4Nk9qcVprY2czdmJ1?=
 =?utf-8?B?Mk5lUC9lUzltVmEvTlVDc2dPWm1YRkZiZUI0dVlBU3NRdkloS2NrcXJpRDhw?=
 =?utf-8?B?aVlsWXQrZnlrQ200M3dpcTFNWkpma2JJelFkbGJDWEQ5eXA4ZE9ad05NVDZQ?=
 =?utf-8?B?RjF3WEFCbmVXM01KWGFESnZTZTI3SERyd05tK0lWakNoRCtCdzZ4eWFnSExm?=
 =?utf-8?B?NkxMSlIvK3k0bVA4UTlHalB0NVhKaGRQRTFKWklVTXU0eUJQbzBWWmlQbWZH?=
 =?utf-8?B?TUVoWGYzVzdmbXp2MThVdTA2eDBwZUM5TFRqNnRkaGRVWEk3RVJGQXRIWkNZ?=
 =?utf-8?B?bjZ5UEJhczFTblUvUDEwZ2lXNDVoZTUvTm5JNzh1dFVSMHhCc1RlNkN2M1di?=
 =?utf-8?Q?IxOLOuguDp5ad7X8ir?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281c85a4-a90d-4bb6-a9aa-08da48aae6f4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 17:26:48.5436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nrm1+sAgp2l2sEIN/JZzIdU4oeufF1q+fOtJgr8TlCLagIe8l1CbD8rVdcfictcV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB2813
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/2/2022 8:07 PM, Long Li wrote:
>> Long, My Chelsio(iWARP) NIC reports this value as 4. When I set it with hw
>> report value in cifs.ko, There is kernel oops in cifs.ko. Have you checked smb-
>> direct of cifs.ko with Chelsio and any iWARP NICs before ? or only Mellanox
>> NICs ?
>>
>> Thanks!
> 
> Yes, I have tested on Chelsio. I didn't see kernel panic. In fact, I can pass a larger value (8) and successfully create a QP on Chelsio.

There are many generations of Chelsio RDMA adapters, and this number
is very likely to be different. You both should be sure you're testing
with multiple configurations (and don't forget all the other in-kernel
RDMA NICs). But a constant value of "8" is still arbitrary.

The kernel should definitely not throw an oops when the NIC doesn't
support some precompiled constant value. Namjae, what oops, exactly?

Tom.

> Can you paste your kernel panic trace?
> 
>>>>> If the CIFS upper layer ever sends data with larger number of SGEs,
>>>>> the send will fail.
>>>>>
>>>>> Long
>>>>>
>>>>>>
>>>>>> Tom.
>>>>>>
>>>>>>> diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h index
>>>>>>> a87fca82a796..7003722ab004 100644
>>>>>>> --- a/fs/cifs/smbdirect.h
>>>>>>> +++ b/fs/cifs/smbdirect.h
>>>>>>> @@ -226,7 +226,7 @@ struct smbd_buffer_descriptor_v1 {
>>>>>>>    } __packed;
>>>>>>>
>>>>>>>    /* Default maximum number of SGEs in a RDMA send/recv */
>>>>>>> -#define SMBDIRECT_MAX_SGE      16
>>>>>>> +#define SMBDIRECT_MAX_SGE      6
>>>>>>>    /* The context for a SMBD request */
>>>>>>>    struct smbd_request {
>>>>>>>           struct smbd_connection *info; diff --git
>>>>>>> a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c index
>>>>>>> e646d79554b8..70662b3bd590 100644
>>>>>>> --- a/fs/ksmbd/transport_rdma.c
>>>>>>> +++ b/fs/ksmbd/transport_rdma.c
>>>>>>> @@ -42,7 +42,7 @@
>>>>>>>    /* SMB_DIRECT negotiation timeout in seconds */
>>>>>>>    #define SMB_DIRECT_NEGOTIATE_TIMEOUT           120
>>>>>>>
>>>>>>> -#define SMB_DIRECT_MAX_SEND_SGES               8
>>>>>>> +#define SMB_DIRECT_MAX_SEND_SGES               6
>>>>>>>    #define SMB_DIRECT_MAX_RECV_SGES               1
>>>>>>>
>>>>>>>    /*
>>>>>>>
>>>>>>> Thanks!
>>>>>>>>
>>>>>>>> Tom.
>>>>>>>>
>>>>>>>
>>>>>
>>>
