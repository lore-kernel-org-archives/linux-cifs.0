Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9535C433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 14:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJCOWA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 10:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJCOV7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 10:21:59 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34774A105
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 07:21:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OTBpMaUZwEhESDQ89PjuTWhvFLPj+zV9WDgaPu63hYWc4Cb+faqN2u1Wt3Je3qz++qxFwbbrGZ3TqRvGtGgZK1EUNTtRelZePJ0Zy+9+WYcpCFYVm6WwDKZtH0bNPdgmGPC3bf2aVxrW4FeN/YwrhIdgJCZHmWnlJiJ//SBQ3YjCEIdlf91tyKTc/NmSpZXo+Z9jj1am9ebuuFE4Vy+TtXYGrM35CR2KGJhECg2RcEUYe7Q5GCo7gNWfNjMB2Fhm7vUnXSpS+OFR/fG6vCUhTKF4BRaGkAPOIclQjpzGFuowLtB6bimVFtw9KrOjBcSE/a6wqKGKDstV7v+VnD41vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liKmkes9+WhhoOtEH9P2r3Lc2iHpl+VkGZsdzHE5aFo=;
 b=UwoCMZFZJs7d5+DWqxlgl+BGQz+a7/X3qXBrwbL2MgcCZ7geWy71Y+MYNZxWYLnx54B9OMnp3dT2nVIOsiqxq/34FSK7V6UhewvjSN4Sw/VMOpeika3T8vVMoQKwwqf/Pi+T7IvTpy17BQKUJ2G2MNVdu00s+oK2ym8ZomlNvAMwnvRywJYkZZVzXrmU39mTJObLZWSpe3NDbfX8jzMnXCH6zk+nCVyZv4QsZCgeJJXV1fOZvvle7eJQ5/zbTMsDvmcfXD0mHceNwLc2FXTFdHh439h9/gF7qQqVha54HYbi4BjSLNhtrznJQcrmRBp83PP0I+WmiSa2QfaU9PzPMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN6PR01MB3283.prod.exchangelabs.com (2603:10b6:404:d7::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Mon, 3 Oct 2022 14:21:53 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 14:21:52 +0000
Message-ID: <d7bf66c8-0695-a239-4bfb-d234241479ac@talpey.com>
Date:   Mon, 3 Oct 2022 10:21:50 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH][smb3 client] log less confusing message on multichannel
 mounts to Samba when no interfaces returned
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mvS6_AXjbK8sY_dEWUbmtRjodSYEtxeNz_NST9+EyC96A@mail.gmail.com>
 <df473fde-e79d-ae90-37bb-3a3869d3aa9a@talpey.com>
 <CAH2r5msDX4eaGuyine__ePtOTRoSBDjiUN_dthaHpiA9UKm0yg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5msDX4eaGuyine__ePtOTRoSBDjiUN_dthaHpiA9UKm0yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0408.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::23) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BN6PR01MB3283:EE_
X-MS-Office365-Filtering-Correlation-Id: 99faaec2-dab7-4554-a99a-08daa54a9e31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iChqZH6G//JiG7VHuqPHDXw8/7XlJICqT5dIhs0L+coiyqyYgD6aeth9EAKf93oexkCN3Y9BHkziJhWUKzA06BtFn4ViNQl0LLa+ZhQ7EeThX67ha+Ko65je51E7xhHHYpL5eRvjx3LGBr1ADPUv8ksl4eMwLHtU0aEATWbPyf+bRSa37oaULbKxyptBrv4fmQ3QxAg3YHbEb4846PVwi4AUv8wlLw7OEqTer+jXSQUPx7nWoP459rJaQyyVn1i55D8yaWn6rJtQwUiI2JPWV8zSniqwSIOeR5A2QHU+li54ut6djsOjXwq9svs483hW+tNrRjmvI1bjeFKum/zgxn4xZX01i/QTGFJ5lpzFV8X98+x+JklNP6zg3m/Ew5p1AfFNVv0KtvWaXkk2WZbIVD7G5p+1bx5urolhKhbaCUQ3TW+REOkCSjXFpF+xPNRKTanJd3eQW+rP4GuiZr00XtfvXwMIKaPCX7cNxyLNAq2JWH2k7/ZZJcJK48FaJWAoGUlDqYw1a5zSKdcMeEfvOnprGluGrF3nXGh3GonY1KNOaCEsgAk9YzZmTigqW8rXzwLOIk1vDy+TI5pyFofTaOuYsp4u+r31lkJnM7GrrnjKnqNAXqc1NiJ1LO1mTZj6dyWhS9n8Gn2NUN7reedjlKXcbCf3qWm243+CwlzmNZk4APeVeDOeh03tKsTrwEvcpCbldQBkQdKQUGcb6i4TJVZCxETtDhvorT2UerNnYm3VQQJu1JAcGIKqcwWFReTSbyYRrwlgeaWavna+kdm+aBtlN7XfOrGzknAD3fEJogo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39830400003)(346002)(396003)(136003)(366004)(451199015)(41300700001)(5660300002)(31686004)(15650500001)(2906002)(186003)(52116002)(53546011)(54906003)(6506007)(316002)(6916009)(4326008)(8676002)(66556008)(66946007)(8936002)(66476007)(38100700002)(38350700002)(6486002)(478600001)(83380400001)(31696002)(86362001)(6512007)(2616005)(26005)(45080400002)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0kyQndvbFd3dEpGeUZJUmhCVHhSalAybGJZZWx4clpxVnJRVW5oK05pSVdw?=
 =?utf-8?B?TFd0NkQ4QXZaNXg2cGhUb3pqb1NUNVJwcW1STnp3bEtPQmlYVk5mMDlkR0tQ?=
 =?utf-8?B?ajUxYmE5V2xGWitJUDdGUmRyN3NCZElDMkltT3RETkxPSEJZb3NuVFdEazFx?=
 =?utf-8?B?QWVRL2Q4T0FHajBFV21SZE9ibU9MMjRnL1RmN1FnMTZrK0NIcVAwbHhBemNh?=
 =?utf-8?B?eWxRSzVadUwrSUpENFArS0tnSzV0QjA3Y3B5SlJyVXQ2d2NqY3BObk8xRERT?=
 =?utf-8?B?c2NtcTlKOURLN2NDc2Z2L1g2dTU4WmhpRmdDcGxKa2paVG5jZUJZTnVDeEsx?=
 =?utf-8?B?S09PdEZiUjgzNTVSUmMrYzZnQksxQndrcWltdjZLYzhwZlJIdXJTajZaaldh?=
 =?utf-8?B?ZDFxMDZHS1oweXZKdEw4T1l5QXdmS2VNb2U4T1h2RSt4cmdLaUtScjJ2QTE0?=
 =?utf-8?B?TG10WW5ZVlRvTDlJeURPQ2JtRm55dThtKzVZQTI4eWw0eDlDY0RWcWFScUwr?=
 =?utf-8?B?ZDdmVWpaYW0zTTNlMkJCdjNIK2ZPZE41R2M4dGl2RnNpelF3MlJYemJ0YzRI?=
 =?utf-8?B?SkhrdlQ0VTN1QWw2TWRnZWRFUklDUnV0aHJVSWh3Y0ZpNEFkYkl5eUE0YUxx?=
 =?utf-8?B?d1Z0ak44VzdGdVQ2RVNqdW1rMnlySUFGYmQ2Y2thalNQcjFKSUY4RUVYYnNG?=
 =?utf-8?B?NmJ0aTk2MHlOUVJsTXlkMEhDV2pGcnozYzVCelR2NG9Oa1lHSFZkR0lTeGla?=
 =?utf-8?B?aHFOUVI4MXJRaU8yRzI1UGsyOXJvSHFFSVl5QUVNc3R2US9hS01qeHozZGts?=
 =?utf-8?B?cDZtSnkySmx1aDZMV3g0RGlRZk51VGVYZkVhdUdQaWhaeHcyNnpKT3hCcThU?=
 =?utf-8?B?dFo0TkdrdmFVU1lxa1k5SXJ4UFRENHN5Z0FkelRoWjVwTEN3TWc4OHVUT2s2?=
 =?utf-8?B?dVpnUGN3MGdjQVM0VERlYmYrZW8ydmhVTm9ndDB2TG83ZjlaWjJrUU9DTU0y?=
 =?utf-8?B?amhlVDNqZnlTd1FkZEc1aWpSTDVGbTdEQzhZSGpqWDBTRU5nNjZsTUFMQ0NS?=
 =?utf-8?B?Z202L0g2cWZpK01qMHZWOWxxdkJ6RTVYaGxWS2J3cEFLVi9XeDUyQjVhbGpv?=
 =?utf-8?B?WXFwYU5uaUd1OVV2ZTdrVTYwbmhqaEtrODFZSEU5bGRSYjRlWjBsVDZjbm1h?=
 =?utf-8?B?R1hJRy9hZkNOWDY3NmE5QnFsZWNLazkvTE5SZWxya2hQUjZmV1YvYjJaeU5v?=
 =?utf-8?B?U1RzclJjanZMM3YvM29MaEI3Q3gxM25uMWFoUXRGMzB5Tk5CYk1STGpZSmtT?=
 =?utf-8?B?ZEdIWUdxSEVoZXdhOXc1QXR1L2JVaU5XbitLNHNQVWNYYm9OSHRzWkhvY2JZ?=
 =?utf-8?B?ZFRkRkVkUjRzQVdDY2NaZldsOEM1bitzN0dBL2lLRGtZR3R5ZmVsT2tXdmlH?=
 =?utf-8?B?VkxHT3BOVFhjeEhxMi9DWHdwK0p2cEZpYXI5Q25JZHlxT04wbHcwaUw5cnox?=
 =?utf-8?B?ZE1VRzVvK255Q1NsMFZ6cXJUVnlwUktUclJIdmNreEFPYmFWWWhjdm5UTzdt?=
 =?utf-8?B?aWpOU1c5K3o2bmNITkRiTmNDb0xDN25YSndLN0hZTTcyZWJLYlo4dDMyaEw5?=
 =?utf-8?B?dm5zQXlKaHZpdmxWaVlmaGkvMlFOZFFzK3hFbTlQbzVIb1Njb3R0YXZ4blVx?=
 =?utf-8?B?c05XNFlPWS9qRnFiS3dqT0t3Rm9SQUdaeTRpSEE4NHFiY0Z4WUxVQjd0MklB?=
 =?utf-8?B?YW5JcWZXV000UmNsNVZnVnhPYWNkeHlKNE1Da0tPR2hKSFhiaVM4d3d5VE1z?=
 =?utf-8?B?YXNZU2wwVFZvWldHdFZWUWp3OXFQV3lMQkZVZW8rdEFyK2VCdTl5c3BneWQ2?=
 =?utf-8?B?cEFyVjBCUmJFVzRaemJyYmIzNm5nV1Z6eFlLcHp2RFZaNDVWNlFQTHd2Y29Y?=
 =?utf-8?B?NURYS1d6RC9RcDMwY29DNXF4REZSdlUrRjB1TTNub0NGSlN5VnA3Y0VzdXdn?=
 =?utf-8?B?bUpVYWhCYUs3WFV2bzlHM1VKWCsvUjFteFA5Z01ZUkE3LzdnakpySkdBS1lz?=
 =?utf-8?B?VGRkNnY3ajFZUis0VXBvVzBrN3lkNVl4aTVVSUNpQ3QxRXdVMEFDY0NmWXcy?=
 =?utf-8?Q?SOzg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99faaec2-dab7-4554-a99a-08daa54a9e31
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 14:21:52.7657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eP7IgAdkD52tLDRbRy6O3vTvFoBsy5vVtAJZVxbBo/HQ7xrLkUVgytInD/GdhhR/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3283
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/3/2022 12:38 AM, Steve French wrote:
> On Sat, Oct 1, 2022 at 6:22 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 10/1/2022 12:54 PM, Steve French wrote:
>>> Some servers can return an empty network interface list so, unless
>>> multichannel is requested, no need to log an error for this, and
>>> when multichannel is requested on mount but no interfaces, log
>>> something less confusing.  For this case change
>>>      parse_server_interfaces: malformed interface info
>>> to
>>>      empty network interface list returned by server
>>
>> Will this spam the log if it happens on every MC refresh (10 mins)?
>> It might be helpful to identify the servername, too.
> 
> Yes - I just noticed that in this case (multichannel mount to Samba
> where no valid interfaces) we log it every ten minutes.
> Maybe best way to fix this is to change it to a log once error (with
> server name is fine with me) since it is probably legal to return an
> empty list (so not serious enough to be worth logging every ten
> minutes) and in theory server could fix its interfaces later.

Ten minutes is the default recommended polling interval in the doc.

While it's odd, it's not prevented by the protocol. I could guess
that a server running in a namespace might return strange things
as devices came and went, for example.

It's not an error, so the message is purely informational. It is
useful though. Is it possible to suppress the logging if the
message *doesn't* change, but otherwise emit new ones? That might
require some per-server fiddling to avoid multiple servers flipping
the message.

A boolean or bit in the server struct? A little ugly for the purpose,
but surfacing multichannel events - especially ones that prevent it
from happening - seems worthwhile.

Tom.


Tom.


>>> Cc: <stable@vger.kernel.org>
>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>>
>>> See attached patch
>>>
> 
> 
> 
