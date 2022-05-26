Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814D8C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 15:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245332AbiEZPwk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 11:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239905AbiEZPwi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 11:52:38 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2044.outbound.protection.outlook.com [40.107.100.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5695DE31F
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 08:52:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ardrvO0uIhyVIdpf/KUOOVlKzKpLV+3j1HHEI0EnIZFeaL1xBDCkxljckBjd0T8LMzoMziDfdxbL9CUUFTqBtCG7GxzceZjXxBo88UkToRsDldPwzAs6fMDLOfIpIhUXuMuLokgyq2TEIZzIzlmQAQ/Zic32Yoxxm+0lFrw5lsMdwgEkPeE51FFX9hqVpEykxSZOSpgTSaIEekHWOFe8vneTtVBokx7d6WqclN0E1KSmr+C3r7nKunratkpO2DQPf14wEKRaKvwbom8W9qZaslzfqX+X11txmYLqi68p/J+nIB9q++2hrFuunv4sXEm8warwBZz/5wRNCOI74f74+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vr7QFVmrF9GZSAcy1SoQ0ou9Ofzv3ASZEbSHpiHBfOM=;
 b=gAnypgNKRuS6v1QHLNJLGC4n5520hFpBbbgInINMDvoqJqSK99S8VFQZp7kyCx3PfOV1dXhlJOUm8ptDW+0fiIDIYbJBe9kUiPH7JNLy+DoWujWJ+QM15PBjWfZWQ7yiaLMvMPx6A0hm6fbR+1PilDndwCnJHF2eNxOfkkjGDr7gndRO8Iqu/TLMGThLQuImgclRw+1yiUPsCOOxQ1o91jAJ8Hr25S006lI9mDfYgRQOZ07SdF/uNxfUeoNS/2Jfw8JE6/RSMbDv1V0Iir1jMAWgewp/qOExdv7pB0jjIwilaWezeDiFqre9yqcdDH8V6gsDt7/yi4gqTzDHhqY6xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CH2PR01MB6070.prod.exchangelabs.com (2603:10b6:610:43::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.13; Thu, 26 May 2022 15:52:33 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 15:52:32 +0000
Message-ID: <3d0f1538-629e-d4a7-8ac4-500f908b0c2a@talpey.com>
Date:   Thu, 26 May 2022 11:52:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        David Howells <dhowells@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <b8850e44-2772-73c0-8998-a961538b9525@samba.org>
 <1922487.1653470999@warthog.procyon.org.uk>
 <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
 <1922995.1653471687@warthog.procyon.org.uk>
 <1963315.1653474049@warthog.procyon.org.uk>
 <7841d1f6-a650-2c62-1518-baecf55cea39@samba.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <7841d1f6-a650-2c62-1518-baecf55cea39@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0251.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::16) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11af5b85-52aa-4ddc-7ffb-08da3f2fbef8
X-MS-TrafficTypeDiagnostic: CH2PR01MB6070:EE_
X-Microsoft-Antispam-PRVS: <CH2PR01MB6070DE0AD137A92688FB6DAED6D99@CH2PR01MB6070.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIpmnM0NohFbJLMUqdLMHB6DEF6Ezla8B70JIKQPP/tQD8V+Oh9OhdRvsE6xeMZfBSPkax4sWVDoUKM0l8xmmrStGpZtUBgzHkAN/XcmJwnshYGqF77To5yZOTn03QdK9OlMty6ihXluUV7EBSFH4dWgzzXQJRJT7jKATjxwxN3ORTcVKpKrYaOjiS2vAHG+t6TcNoPv9J+xj32qQjTus72xdGIsTHv1MKUwZ2xHjIQl4yVhEJx6y+zsj2PwTsr2Bp/PqHGfKqUYqV7VU1aJDOFXETSyboJ8GRCKC7uV15aHgx53nXnEd3O8tTt5/+5GU/qwr9K7MrnQ9/0WYB+yc21QOWf2B/7J6rd2kgBwpOeW3yvW9i7hILZr1tay7jr40jNTBEj/py4+CIC80b0r3Rca/oduuEm81h1t+sPvU8KTUVEAUsTv3vv4jJ3zrG6581s6ZPLEx5qbk+7u0FWPlNCJEt2BY3hqbvJuUB3Y7UVHmSyLLr0+/pFnAEgd0a6lgIaxJ/y2RsphSqFl33q7+7YvP/6w0uNCza3GCInUeDWd01rLjToRf+crqB7GdDjy4Lp0oT5oixwyHaITp9F6OSL45mmccZza82yRkpmswE/UigG91t6Hmv6FwwN7FA5w+DWZLZ1UW/BGdwoVqjN61ktOwWEzsgI5a2LgqdgKrM9UB5ZAdBBQqlR5lEtd4KC0dALf0rfCAlhxgbk8Qv+TDWrSAQemTNR82VRD+kU472xACXjbvx/6vQ2h8gSNTLfnh4TveGUlWuE97f1W4gZJaaVw8xrC/Yc0/GFielw78WbB+Rs0thuY9SAz/vDwhhoW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(136003)(39830400003)(396003)(366004)(31696002)(6512007)(26005)(86362001)(53546011)(966005)(52116002)(6506007)(508600001)(6486002)(83380400001)(8936002)(2906002)(5660300002)(38100700002)(38350700002)(36756003)(54906003)(110136005)(66476007)(66946007)(41300700001)(31686004)(316002)(66556008)(2616005)(8676002)(4326008)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a3pPdERtM0V6SHlwN0VUVGlVSjZHWjNnVVNVSCswZzFJSVJXMElSWlRQRFo5?=
 =?utf-8?B?dGlnTTVJSlhwSld3K2ErVy9zNlkrVHo4N3Zua0tDa3UwcWc0amkvT3F0UTcy?=
 =?utf-8?B?N2VJMDJSSTJLcjZhR0pJWU9ENVUybDdzUVFZSEcxTTlUWWZUSk1HNTh5dHFn?=
 =?utf-8?B?amlxSTM1dFgwUjJVdHRLTTEwbFYvQ2ZMWHdudVJzWlhEdk1tNUFXOGQ3U2hE?=
 =?utf-8?B?N1NENTExQ2RzUExwU1BkMXIvUExvYjRXTjhjYzVBeXhYNjJ0N1ZHTE1XZWZ2?=
 =?utf-8?B?VWpSaWhRSmJZakdXaUFXVUZDbkxEa0ZMTHo4NUU2ZkJwdW9DN0dCU05XV0Vj?=
 =?utf-8?B?b3Q1UWQ1M256ZUdhMWlIKzlqbTM1TmFxK1g5RVhnQ2xwTjdXTG1MOWRLc1Br?=
 =?utf-8?B?SEtsOVRYVXpScVF2aGJCa0VkOWE3RUVsNkx4bFdhRTk3UmIvWlFCQlp1RG5I?=
 =?utf-8?B?MzJsdUp4RHREeFR4aTcvbEttWStLc0ZSWGQrenFKUlZhdlRJS0RsZUczc3p2?=
 =?utf-8?B?UlJ1QTBOck5Ndm5oQVErVExqNGZaaU53SFNtbkJwNHg3SUZ3RCtmZGdmaHNR?=
 =?utf-8?B?ZlFTbzFxY2dZOU16bE5NRi9lWVlxZFRCU2o1VnJSRHFGK0tKQWNwNUMwZ1Er?=
 =?utf-8?B?c2tRVnByeEMvUjE5SmNCbUtXNXE5K25oWGtUdzlMbHlqMjlEelhDZ0UwNk1n?=
 =?utf-8?B?SHhwMzIreEtuS0l6TnJXMXRKSlpZNVVsNzd5dHE1ZjRjRTFHOU9NdGJhUjFh?=
 =?utf-8?B?TUZxa2hXVHZwTjJoK1JvWWdKakFxdWZVbE5yMndNbXg4UXJyUTd1ZmE1THRX?=
 =?utf-8?B?eGI1WnhEWFFNd0duVkdRbVRmMGxsUXpkVmhYOHBycC9VNEdYMm5oU09IQzVp?=
 =?utf-8?B?VitCZHZ6d2k2VmZWK2RtMmVVdWlHODFIMmZzNlVCWmF3NGp4c21GNDRSOGNj?=
 =?utf-8?B?WStJVHVCQzRUVm9SZko3ZHV5d0EwcEk5MlVIVzVnVDdOQ0crM3JrWGpCTyt1?=
 =?utf-8?B?ZlRqK3lXNm1pY0h0MzJtZjNXRVdmcXNXU1hZVlM1R09aUWordWloZGtwUFZD?=
 =?utf-8?B?TDFWajBwWjd6bjBwLzVqZ1lBZk1FaDRoMjZYTHFCUVVQSE8zbFRHZlkwdm8y?=
 =?utf-8?B?Z3N6Y2EvSS9UbTBJb3dCbmpWUkRZTmlGc2l4OWxyS0UwaFIwT2dteXQ5N2JF?=
 =?utf-8?B?U2pHZ0dhNlV1dGlGRHpoeUMveWN0T0pIamIxNSs4clArVEN3WGUzWXhweE1B?=
 =?utf-8?B?N0VuN0RXcVd3WTVIc1BZZU5BdDJtZjY2ejR4Kzd1WXBpbEZyb0FyU0JNOW1N?=
 =?utf-8?B?YWYxZ1JSYnZtMzhYdnd5b3Ftd25GT0ppdTBlWUtUTTRiMkdRbkxZdGpJanp5?=
 =?utf-8?B?cklZWklVdG41ck4zU2l1QVZkTnRkZ29KenE4dnZ6Zm5oTTRuZE4xcXpYQUw4?=
 =?utf-8?B?LzZudkJGL0FzaEk2VVg2YVgxbHpuMEJZemFyYnNLMXNhRWIyb3ZHdHRxbGVI?=
 =?utf-8?B?NjMrY29PUm1GeGlIWGNYOER6VlMxOW92UkphM2FRU3lMSURaUmZIRHcrODUx?=
 =?utf-8?B?cEp2NEpvRjY4UHpHNi9JMnFDbmtuYUZ0Z2dIZ1Y4cTR4cmVTbW9rcjFSMWt2?=
 =?utf-8?B?cTlXYnRZRzZMVEoyWlJtWXRhQzZiK2crQWZJZnN2UDU1Sm9hYVp0RG9qVDFG?=
 =?utf-8?B?cnY3Nmg1VHpPYllKTU9IR2hRc3FNdnBSN1BqTlFEQjVmMC9yV0JpMXBUYnBM?=
 =?utf-8?B?K0s4NHJIZ0QraTJsTkZTbHV4bUp6aldPRk5tTGRxSVpzSCtMWmxmUDl3bkRm?=
 =?utf-8?B?NHE5YjczcXJ2aWhYMVRTOTRydXFneXpvR1hhSVM4ZFZRSWZnOHhWV3BMQkRF?=
 =?utf-8?B?dTJLbmpQTi8rQ2tVWkhGSU9vOElXbjNUcDRZOTB3YngyckluYmNoM3JQSmNJ?=
 =?utf-8?B?cFBQcGJqalNlRkZiTUhOS1RRenV2WG96b2hWL3NMRGhFcUNYRXBKcEF2ZVpD?=
 =?utf-8?B?dkxKVDI1RDQ3YktyV2FicUdRVXlySTNKRExNczg0TzcwajNRblFBQXphZXZm?=
 =?utf-8?B?UG56alc2STJTdy93NndHSGhoTnM3OHRTcWFIM1JwV2FVbUZLcjFzZENreU5O?=
 =?utf-8?B?QkhsMGpMc3RpaVg5WStFK2RxSHoyYnhPckxpUG5JQ1BuKzFjeHlxQXZiNFVo?=
 =?utf-8?B?clBocERCeGZoRzgvdllEQmdUQVVYTi9EcktaWU40SE1paTZvcWU1MWRNcGRB?=
 =?utf-8?B?ejZnb2VNU2RMejFST2EzRjIwODF0L3hZeUpSd3gydkNBWGYrYlhRRjVBbEw4?=
 =?utf-8?B?amIvcVJKdDFzWS9KLzF3RVlLVlNZTU9mMGFQcWxHQlpCUlFScnFoUT09?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11af5b85-52aa-4ddc-7ffb-08da3f2fbef8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 15:52:32.8503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4c2athZrrZNrYBejIlyfv5ShArruIvtH+EgA0YIm8skjte/vduQcCRqQob481WqQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB6070
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/26/2022 10:56 AM, Stefan Metzmacher wrote:
> 
> Am 25.05.22 um 12:20 schrieb David Howells:
>> Stefan Metzmacher <metze@samba.org> wrote:
>>
>>> Can you share the capture file?
>>
>> See attached.
>>
>>> What version of wireshark are you using?
>>
>> wireshark-3.6.2-1.fc35.x86_64
>> Wireshark 3.7.0 (v3.7.0rc0-1686-g64dfed53330f)
> 
> Works fine for me with 3.6.2-2 on ubuntu and also a recent wireshark 
> master version.
> 
> I just fixed a minor problem with fragmented iwrap_ddp_rdma_send 
> messages in
> frames 91-96. Which seem to happen because ksmbd.ko negotiated a 
> preferred send size of 8192,
> which is accepted by the cifs.ko. Windows only uses 1364, which means 
> each send operation fits into
> a single ethernet frame...

That was not an accident. :)

There's a talk somewhere in which I mentioned how we tried to optimize
the smbdirect fragment size and always landed back on 1364. However,
this is only an implementation choice, the protocol supports a wide
range. So it's appropriate for wireshark to be accommodating.

> See https://gitlab.com/wireshark/wireshark/-/merge_requests/7025

I get a blank frame when I view both changes on this link. Do I need
a gitlab account??

Tom.

> 
> metze
> 
