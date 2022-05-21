Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91FEC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 21 May 2022 11:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiEULy3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 21 May 2022 07:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbiEULy2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 21 May 2022 07:54:28 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2084.outbound.protection.outlook.com [40.107.101.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7407460A82
        for <linux-cifs@vger.kernel.org>; Sat, 21 May 2022 04:54:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L3hvnTffjoPJaHwrjFZzmISGwbMgplEQY+sb5TqT0nxUCMVoROyEqwGJX6viuhyauBa889R0F4iUfi3X0Qd5r6xZ6qsufTEiZaYYBHQOiJBz80AmY4h6sUlI21u/X4azFcHv7nlR2HrXDXbhyCv+DZOcDX2VE5wwJFFBx7y3DWT80gx6Em6jpi/x5fUkWcXCTzMuvQqQpa6lz50ErEIRtnzAeBRIYMo0p+upfV0SCDaOLlStNkRqntSaz4VnknxSOaMe67LvC43iYDVWzhE/IwCQE3GAhETzCmOaPO+E1eeTz2VVwFtTdX6i9S3VIxa9n5YjUSehylFenv3dyESbSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKGv++OYuzKjRg37pN10L5Dyc/sI1L8DMkxNSxQa9wc=;
 b=Jjd9Zh6K76pGCRvTVZ6X1gqComnO+1XeKgTK3/tRkSPaDxpeIc0KH+rIT54Ha4xs6A8Rt54/pBV9adrFjiKGxvWX9kWExbnK3UGsiEZ8+7lKVL+cixsPf6zKCzgvRWFNyUxLCb/pFgf08KI4I6/DS9Ev3W17GZ+cLWMUv9am0puAMmsq+dsIylgaXX9b3rc4WUFDUoAs9RFQ45kuqDAvqKKCZWiAN8q44PyMjCSeWMnQulHOK7szqoImpYffpZupCRXedNJ1X35S2zsOeHs4JvQYlEHDeR7P7suPLYA1B2jWCeNxx8uQYSqbO1A1d/cXWQW6dCsfKZRixFZ0HeMBPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4876.prod.exchangelabs.com (2603:10b6:5:66::24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Sat, 21 May 2022 11:54:24 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.016; Sat, 21 May 2022
 11:54:24 +0000
Message-ID: <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
Date:   Sat, 21 May 2022 07:54:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <84589.1653070372@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0027.namprd22.prod.outlook.com
 (2603:10b6:208:238::32) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 494b483c-ac4f-482b-73b8-08da3b20a694
X-MS-TrafficTypeDiagnostic: DM6PR01MB4876:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB4876EA4ABA5B08380D43B66FD6D29@DM6PR01MB4876.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxYBnQuuazOV6XIGBq2b4WlOS85cFIvLhcsA+LYg38PS/fTJLO23ikxZCVL7V+XAP+qHhZ97/yx4aCJCYsIcTWxdLZtcMtaixn9f7PNhvbhX+1tSkuzU8G/XiXWhfBdBDskVg/aF8/85dsBrh5Lrd7acWTgSOV1gDsr0jHvgPhCR0jyd+2A39MXamfAfIHsOxRmkBPo164kYsqHtjZJxT+KGOY3ChKs+Krpb8wt49eZlKrO3lqJLiIRd3KF0ST9Xqm7GJwEfNkQhFQ4RyAHakxJxLpudT06blf+qGA0BcZSwzICuy8XozRE2X7aL2pHMiuAME6vRX7v9dGUyqoeQOMTWS4Nu4nBNREm+iQ+8zZQ6qdWA1HzDU9HEGwyocUiOIs9rXSYadnzEEBak+1C6Mg7xH4PQN6irPWqWfCv1D6KilxvHo0aHIidteeOkYiUhg/pEbtRQS0Vee4lUSZH74q7nO8AH1tjYZKyxL6v5+AkkfHXFJM0nK5UDibgY4Js826+k8+rNZRzx4ZcZKzMpvwcRa6A5PXPMqLUbpOxQuSdtHFrINz0wrvYLG7M183yQsbA+mkvChX2eUFc9uUM1pfJivhDLZTDhcLrOyBL+ROnG8HKK7HS6YZnuTnzqtKcqi80QkJWAQqRjt5LLtDwOOkrkWK/boVVIIUBVx5lDkV/ZFG5z4HFVWXu7wMUCCNGOU2G0VIA76tvI/cgIhNZmKJf+bmEfPwW6Z1XmS/4WOkg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(346002)(39830400003)(136003)(376002)(66476007)(31696002)(54906003)(86362001)(38100700002)(508600001)(8676002)(316002)(110136005)(6486002)(66946007)(66556008)(4326008)(186003)(83380400001)(6506007)(53546011)(52116002)(2616005)(5660300002)(26005)(6512007)(36756003)(38350700002)(31686004)(41300700001)(2906002)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzZXcWRpZUtTK3g3NWlVekFmRjRVcStXMk85ZmpQd1FHMitiY1o4R29LdS9O?=
 =?utf-8?B?SFkwMkdueVF4QXhha3F6cjRPMmJhU0tqVmxuY054dzFPZEV0Z0dNOXVYeEdN?=
 =?utf-8?B?aVZUemM2U1NQZDFZWkUxM0VIRGdHN2lIS0RBcDJNeVBtd2dlT3R2d2RSeG8z?=
 =?utf-8?B?eVgvSGViTlhtUUlySU5oMTVqemQvcmRBU3N5WDhIM1VSVW1ROUNhTm9vd051?=
 =?utf-8?B?bitzaFNzTm51TG12QlZkcVduc2FoV3BqczI4dUFPb1Fwc1A0QTgzQWIxY3pE?=
 =?utf-8?B?U1llU2ZzckFsYmxLMllFaG5CbG9PMDAveHVEWkt1U245ZVp2bG9RYXc3RXlJ?=
 =?utf-8?B?WWdsY1JZdUdTTGlDeWpHK2p4ci9XOEdhcWp2RkpDNUJpZ1BqTnJJbVNGUjdF?=
 =?utf-8?B?eGhUdDRHeGFTL0ZIcHBXVHF2ZmloanBVSnB5c0JhWWhLK3JPZUVFNzFzTXJO?=
 =?utf-8?B?a0xMQVJHa2dQSXpOMWJMTlArcER3aHVHVW9IdTNZckEzTHgyektoYUhlemYr?=
 =?utf-8?B?ZUFqUlFzSHFpK3BrNEptcENianRPLzFoZ3poczR2WVI4MDV0cUZuQUhwTm00?=
 =?utf-8?B?d0szY2drNENsL2YyRTVCeWZxa0pZZE9DM2EzRUdJb2V0a21iUHltZWZ6dGlr?=
 =?utf-8?B?TnFHR3dhVm5lQ2tBWGNiOGkrbmlPNVUrSkVHN3Y2anlWS0plRlFnSHVvWnZ3?=
 =?utf-8?B?aFNGNWwvWUU3UU9PcnFsNlZicStReTlnNUhnd3hWMUNMcFpGakF3czgwQkk5?=
 =?utf-8?B?TDZoYlhwS1lZaG04S1FDMk81djN4RUNCeXMvMkozajdES1k4eXdTOEswYzdW?=
 =?utf-8?B?UWt4dHlkYzdkd0NvUHZPdVdtanJuRG5zbW5MZFJxVFlBMkdSKzRwcUYzUjVP?=
 =?utf-8?B?NmIvZmpiQjE0aUNtQnl2Wjl6ckVjUWx6bUlaK3p1NU1pTHhNcnZMSDRqLzhU?=
 =?utf-8?B?Wjkza2FyQTNTZUNZdGpEbm5VeEdvMG8vZXlXMm1hcUgrWXRPQVBhVkNtRmU3?=
 =?utf-8?B?N1BkditPTmdmOU96WWlHbXF4SitFdk9ETjNIQTJGZjZJcVdqMk50UDRCSTBx?=
 =?utf-8?B?L2J5Vm9WZGFCenpjVksvUVJWaTQ3bjBiQ1I3Ykt5YkxNT0o0Q3hXYVpPVEkr?=
 =?utf-8?B?Y2hmY0w1NGY4aUFaUkdiM0VneEVrZlRNUlRIYUtmUzZiQ25ubms4Nis3OXpU?=
 =?utf-8?B?RTZsZXZNYjlPSGp0VEJubXhteXlqdzF3aHJKQ2pkbEo1T0FEU1ViY3VVa2Nv?=
 =?utf-8?B?Ym1wb0tkS29NUDQ2RHFjSzYyak0rdVdIUVNqczNabWpZR3Z6RDNGNDloR1Zr?=
 =?utf-8?B?blFCSndoWVhGOHNoNjdFbFlJUFFJbms2QVpqK1d0ZzdNVDhGM3ZGQk5Ya0Zo?=
 =?utf-8?B?TTlMRGM2UDV2ajhxR2l4dHk2enZYbG0vbW9zamJha3c4dlI0Z0hFNVgvTHAy?=
 =?utf-8?B?MWFtOXJQUzJYZ1dBMXlFaXFDaW5LRHVLblZXSjhNQ3NCeXl4eDFrejRld2hj?=
 =?utf-8?B?YUNERVB5RlcvNG1BUDNGdUFUeEZWbEVKZjNKaDA1dElDTm1nUzZjZlNyY2FT?=
 =?utf-8?B?OWdXelltczV5SHNuR3MxS29saVRUS3JNZStjbUVEV2tFSzBua1V4eUZmSDMz?=
 =?utf-8?B?ajJ1dHIzQUhPN0RtUmRrb3JxSkFTYk93bHBRbGgxNUJrQ09ZNFN0amc2Z0pQ?=
 =?utf-8?B?QTJVTlc0bDFFTWFrTEMxZEFPaS90T1FSVnZTdnJUT3RURHY2VjJVN2VkRGo0?=
 =?utf-8?B?Vm5jL1c0MUxzcHpuSXVkR1FNaUM4bDdWc2ZnTXZVNVFlV0R2SHBVMlJOdlRF?=
 =?utf-8?B?ZlBieGN3b0VoYU1rR0kwY0JnQTUxeVV4UVc1eW9tRExYNzFaN0hJa1RQOCtv?=
 =?utf-8?B?eG5ZUExobzN5dmFWL0FnNjl1UWZYcWhaUFIrMzZlNlVkbzlWRTVaaUF2Y2ZB?=
 =?utf-8?B?UGVLai9ITENKSkgzM0p6U2xzMmM4QVBhRktRZjZ2QUNmbDgrS21sNGFvak85?=
 =?utf-8?B?WDNMUUhpcjRtVUIxdXRBSlNnMTBNNXVJUlNTRjJxN255dlVJTlErSmltOEwy?=
 =?utf-8?B?S01VSFdmN0ZqMG80cjBiSWpleFp5MWMyUGVjMm9mRnAvdTd4LzF3WmVhd05N?=
 =?utf-8?B?OW93Nks0QzRxeUVvWFQ0Y3o0NnM0eTlDNW5jWnRraHpEUFM4UmZpZ3ZWY3Qx?=
 =?utf-8?B?Q0VzbSt2K0h0T2ZnUndDOFo2T012eE9LT2puM3dBSTYwMlV4QWxMeUQxZjJh?=
 =?utf-8?B?dXVwWmJ6a3FpRUFDUlI3YkJaSm9mRWV5emZvS0lxNVMyb3E2bHZKMFBJdmxh?=
 =?utf-8?Q?PRuA8B5ALMODqbewsb?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494b483c-ac4f-482b-73b8-08da3b20a694
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 11:54:24.8585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVrqdQzScc2tBS4ED/la02mCTvRLXXoocq8uBS/DZVjwChBi0WhbZ8rssWwM2Dfj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4876
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 5/20/2022 2:12 PM, David Howells wrote:
> Tom Talpey <tom@talpey.com> wrote:
> 
>> SoftROCE is a bit of a hot mess in upstream right now. It's
>> getting a lot of attention, but it's still pretty shaky.
>> If you're testing, I'd STRONGLY recommend SoftiWARP.
> 
> I'm having problems getting that working.  I'm setting the client up with:
> 
> rdma link add siw0 type siw netdev enp6s0
> mount //192.168.6.1/scratch /xfstest.scratch -o rdma,user=shares,pass=...
> 
> and then see:
> 
> CIFS: Attempting to mount \\192.168.6.1\scratch
> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too small
> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too small
> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
> CIFS: VFS: _smbd_get_connection:1513 warning: device max_send_sge = 6 too small
> CIFS: VFS: _smbd_get_connection:1516 Queue Pair creation may fail
> CIFS: VFS: _smbd_get_connection:1519 warning: device max_recv_sge = 6 too small
> CIFS: VFS: _smbd_get_connection:1522 Queue Pair creation may fail
> CIFS: VFS: _smbd_get_connection:1559 rdma_create_qp failed -22
> CIFS: VFS: cifs_mount failed w/return code = -2
> 
> in dmesg.
> 
> Problem is, I don't know what to do about it:-/

It looks like the client is hardcoding 16 sge's, and has no option to
configure a smaller value, or reduce its requested number. That's bad,
because providers all have their own limits - and SIW_MAX_SGE is 6. I
thought I'd seen this working (metze?), but either the code changed or
someone built a custom version.

Namjae/Long, have you used siw successfully? Why does the code require
16 sge's, regardless of other size limits? Normally, if the lower layer
supports fewer, the upper layer will simply reduce its operation sizes.

Tom.
