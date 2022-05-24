Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 531E3C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 18:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbiEXSNN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 14:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240365AbiEXSNF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 14:13:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2056.outbound.protection.outlook.com [40.107.237.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AB76D38F
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 11:12:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4w76cTrZ0iXu+JwYJIYfCac/d5E7hFNYAOVaWbh/2c3X1Cp3yIZKTf46ZkuULF38V+Ccm7IMbgBc+kBib47gqF+V5noc45rMsG/4NDmT/WY/sAszifV7utzFH4BG5v01AdajoWA/mjH0x5VKVBjAmrdHV/cAF3txZyX3xpK6X44/deJ8dQK9DgaQcnkZ1EbpLCG1G876h4GTYVvj0BRtwn5ee2R577h3bnWW4BQ6WBQFVhPuQQi+9qcrrF6Ux71elscN5hoTWrZjbTtot3mypbjhHWjNJZWs/5daPrpT0mu3yeeB3oKhwqpkZjEtEd2oiW/54KR46ZyLMwBdkKy3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REL0hbLdovdCDagWOK5iwcjAPTp2eFsONtXL22Uhzng=;
 b=ixAI+0/svuGaS5Nxl9sAakGlmwPPN1wE47QQX+6QLgOD32tn9hoUoTz9hoFA/Sn9COspdetKgM88OK+ntsvkWXPYTcKjd2bJ6btLJWktpwf5SAaUXka8FsdrsKFohizYZeP8L9mJxXLWImOEKqMjB4T+O7rV7TDYmHMx+Fgy1d4J5A2wAbYExOhTgZhtPZGTm4mBm7mSuWyK+BQs8BgsK5DkbTHx1c0ysGcQRuaspFoamPl1TuzeTmoBhDkYK9NhnTBsf+xTzPn0nu9bUuXX335LVkFtZL2BZYnR+R/0UolW3x/qQoZ2ZdudrF8LMBaP6XZoYSf6zgsq7J71hBSXJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 LV2PR01MB7573.prod.exchangelabs.com (2603:10b6:408:17f::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.23; Tue, 24 May 2022 18:12:35 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::f135:e76f:7ddd:f21%3]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:12:35 +0000
Message-ID: <b02843ce-48ea-29b1-c032-575e08be622b@talpey.com>
Date:   Tue, 24 May 2022 14:12:32 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: RDMA (smbdirect) testing
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Long Li <longli@microsoft.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
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
 <1502011.1653383785@warthog.procyon.org.uk>
 <CAH2r5mt83Hxj_bT=y0G5XieEka6bATvt7Z0jKhcFDEuA-2u+hQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mt83Hxj_bT=y0G5XieEka6bATvt7Z0jKhcFDEuA-2u+hQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:208:32a::16) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36681de9-983c-4363-d8ac-08da3db0fa49
X-MS-TrafficTypeDiagnostic: LV2PR01MB7573:EE_
X-Microsoft-Antispam-PRVS: <LV2PR01MB75738B410F7CD040190D2C99D6D79@LV2PR01MB7573.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TOGKld1EG1Vz4oVlSKkOmB2wETCFie9MWRnb9kBCr9U4pxBRVaUisjFtI11ypwBdGRciVxAiEWg3oqAljKwfLqBTmI2k6omLhqMR91WgaCusSxD2elEVdeVVtw2ftMH34YEqdsNCmpA9Urfx5iwrTeYnDxs79s9dzzTOE+gHO97SPRq2ngvxls9mdXxiZ8Cs7zm33sLnDuID5Mu+UvI2qZnNMywbQlue4g2Y8zpEaEz2XzI36xeHbfcauxJpDS7j2T8Ktu9fs8V6ZEi35b/tSeXO3ny4PgMIQuDPAOdyhadtBv8a8NoJIK0SADCJGXs/qmu9+YU/b0G656cB4w1znYhidTw8tj8kCZVO0LbDctbReAHAvgPzReQllWEtz/1YhcTVlxVE4ygVPtKYmBR8pTTyuWA1wQR1sbfrh2Vl23ITZsRO+5TfWl5m+1LBdxAIV0LxJh1l/96AA2VVMO1PmZj91PyMCJIp/basg8Ck0j2MDTxG195WjaL8DWYPIVP/0t3Pw4AZFQC3j9FSoRbRxWh5cDZQ+L2Tv1IwUSi3ZMnsl6gfASEWYttTArtt3uCk5JXwF6ppA2GbqsBOvgMzsirsUI8VEtTUfwFYsTl02e0lPOGRWWEXrtR+fUbTpCBFUbSnXB9RmIaQt9AtMTXDz200CF5URdo5RCzuVPlPICBflUEyR997MInGH+RxROTqXsLAXh3tGh0KlOzZ71RadNRvw0QvaGVoWRt262hLaSk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(39830400003)(136003)(346002)(396003)(110136005)(8936002)(52116002)(316002)(54906003)(5660300002)(186003)(31686004)(36756003)(2906002)(6486002)(6666004)(6506007)(6512007)(53546011)(26005)(41300700001)(2616005)(4326008)(31696002)(38350700002)(38100700002)(66556008)(66476007)(66946007)(8676002)(86362001)(508600001)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0dwV0YxRG04cndCcE0rWXIwMWpvcmluSXJjOHU0L04xMUE3Y0N0cFpnUnkr?=
 =?utf-8?B?Zm5FN0RlYWh4RkVrZVNyU0E1endFVEV3M3ovc3lnQzBnQVpPSFNkSnRuVi9s?=
 =?utf-8?B?ZEt3VmZvSCtIWm5YVTMzOGJMTlk2N095K1ViZlV6QktxM0dXOEs2KzhTTTVE?=
 =?utf-8?B?OVFXWU9RTGhVTlJGSlFnbW9iSXExcUV0dWdOZTBYUUY4a01YZGJXNFh6VFJP?=
 =?utf-8?B?UmtTNm9LYWhhcUJEQmtUUmxJYWpLV1lzOVRyYXZpL2xQZHdCRHRBWVorY3dF?=
 =?utf-8?B?a3Zza2k1bXh0TXB6Q1FCWk5Pc08zdlUrRmJaUEJ1aHFwOVhmRjRBdTBtZVhL?=
 =?utf-8?B?YS9uYmVNSXAvWHNkSGRYNUx0VEM5a3hmdUJNbTMzbG1yMUJnVDF2cWl0cTVr?=
 =?utf-8?B?TjUrdWhxZ1dQTWtuWm9zOFRpTkFZbkhMZ3pxcDhybEVsMGlMcFBtK3gyY3FV?=
 =?utf-8?B?bU1RZmtQRmFjZlNLeU5sZG9yZk1wRjdoN053dDNYUzgrR1h2TzJuTWVyaFZQ?=
 =?utf-8?B?cTZEYnZCbUFIa1ZhOFF2SURFNUZxZDNqemVmUXI2eWRQMEZyUTdwYmFGUTFD?=
 =?utf-8?B?OE83S2gvUm9rUXYwSUdmdWdndmVPK082QXdkMFdnZW9BOXZoMld2S05QVGs1?=
 =?utf-8?B?YUk1dFQ3UTBHb0hsZmlEbThtckhPL3hGQTZUNERKRnJLdFV4Q1pURlJLYVg4?=
 =?utf-8?B?UHJIV3JFbGVJdU40QjVhMjVTSm4zeTFjdHljaTFBUzdNak4wOS9vWGhnaFIr?=
 =?utf-8?B?d1lJc2FXY29VTkNqc080YnJlWklmQk1XTXI4R1RsTUNlaDRscWxCVlZxRXZP?=
 =?utf-8?B?enhlM1AvUTNYWnB1eHcvNkV1cUhaYWpkMlEzaURiUnYxYk84Z0IrMjc0bkpl?=
 =?utf-8?B?K1pPbGNDaWQzMW9KVnhuOFc3Wit4Y3RvVkhWZDI2T0JSMVdseWpRQk03Ukt5?=
 =?utf-8?B?bWRYZEZtU2syNkRGalpBU2pjczllRkZpNG9qMXZqbzFydm56V1RheWlQaEdK?=
 =?utf-8?B?OVBYYkJXT2Z0ZkdOOFZmVEZCY29XclM3dlJMdEsxRzRsaHBnLzhKNzZpSEM1?=
 =?utf-8?B?cUVLdEs2b2lGajY0em1FcFdDN2txeVlVREh5anYyZDN5SktIekNIbTllRkxj?=
 =?utf-8?B?WGtGcTNaUjZPWVpybDVFc2RlR0NMNWxVQjhNT0g4cHJob3JWaENPNDNNbFJz?=
 =?utf-8?B?N2k0RlYwcm1pTjJNdmZwM2s3ekZ1Z0dldEJpaUxDM1Evc1JEYmwwUUYyU2Zj?=
 =?utf-8?B?VU9DK0xVTDlDUnBZMHFLMytqdFJVcGtmemg0UGp6WjNJdWFBT3l6Y08zVnA1?=
 =?utf-8?B?MUVtZU9WSXJLZ1pVRU9Sdk9QVVY3L2hPcU8wMmlkRVorUGUrbmEzcG5KUmRX?=
 =?utf-8?B?WUJETWlTR1N4eUcxTzJFaldUNE10ZnArbzFzdVFLRDB4Q1hKNUhPTUFWSTBj?=
 =?utf-8?B?TWZWVTR4eVI3N2dEQzIwdkp3ak1XY0t0M3VEdkFidHFkTGJSOTFNU2ZSREE1?=
 =?utf-8?B?MXluRXZHZmpaT1R6bjhoRGdtWmdjRnpoQ1lVWFA4SUhzMm5qeUF6cURURjY4?=
 =?utf-8?B?WHZRSjdDWUF0MG5JR0Q1N1VlU3pNM0txY0NsNEp0cmRqTXpzdnJWT3ZGdVh1?=
 =?utf-8?B?Lzl1V0hZYlV0eXBMd0NPU3gvV2R5eWprYmhFNVc1NHBBUExrWkJFWHFscjJP?=
 =?utf-8?B?T2prZVlPNnhORGkwRkRJYTBFV2xZTUxJYW5BNVk4TjZTY25MOXozM2h6TVNS?=
 =?utf-8?B?eUJmOFJFM0FjNjFldVhKZGdDMmxPSWEzNFIxYkRxS2lWM2hESGZWTTJ5YU0y?=
 =?utf-8?B?eVgrTEdKbzBxY0VEaitXYk1uZEEycExiRURvSnhqNmJ3aVU5ZGZqZ0RFUmpG?=
 =?utf-8?B?cllXUit6dDEvbDl6bFhFOTZxaGU2SUx2VStKbkM2ZzR3N1orK0VCaHhxOHBU?=
 =?utf-8?B?OEFVSDUzc0xqRHBzQ2NsK0VhT3pMZ0dTSE5ac0V6Yi9uRDZQMGUyd2NLUCs4?=
 =?utf-8?B?dkdDdTN4aWpkVDRIdXRWWUJZV3BwZjdKMmNrSHh1R3BDNGkyd0xqT2NmZ1Az?=
 =?utf-8?B?blVtbGFxVGl0UmNSR3lOM1phODdkbEF3dFN0SjQwcnIxWXRyUjc0bmhtWFoz?=
 =?utf-8?B?YlhFaS85REFOWHR0UVlCZjNtMU5PaHVmTmRiK3ltUnBDekdLaHVyc0trVjYz?=
 =?utf-8?B?aC9FWUFzY1pISnM4bjRZMkU5eCtoc2tNYUNoTk9DeTJyVWV6dWV5V21VM21o?=
 =?utf-8?B?Tm9CZ2g1NWRmeFdTdFFrNGhKZWw1QTBLeWlEVXplZ3V0MnNPMHBsd3lRTzc2?=
 =?utf-8?Q?zJb6LCzTdMaepn9egV?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36681de9-983c-4363-d8ac-08da3db0fa49
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 18:12:35.0590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XHDjK0jrLopUiRwuN8iUtRprJvr7bEQ46+ylXi6bXkpMYd2oGuVYkWpSdCzEckvF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7573
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 5/24/2022 1:49 PM, Steve French wrote:
> Or alternatively - the "query network interfaces" ioctl - wonder if
> additional flags that could be added (beyond what is defined in
> MS-SMB2 2.2.32.5

Huh? I see no reason to expose this over the wire, it's entirely a local
device API question. Zero impact on the far side of the connection.

> On Tue, May 24, 2022 at 4:16 AM David Howells <dhowells@redhat.com> wrote:
>>
>> Is there some way for cifs to ask the RDMA layer what it supports?

Yes, and in fact the client and server already fetch it. It's a
standard verbs device attibute.

client fs/cifs/smbdirect.c:

> 	if (info->id->device->attrs.max_send_sge < SMBDIRECT_MAX_SGE) {
> 		log_rdma_event(ERR,
> 			"warning: device max_send_sge = %d too small\n",
> 			info->id->device->attrs.max_send_sge);
> 		log_rdma_event(ERR, "Queue Pair creation may fail\n");
> 	}
> 	if (info->id->device->attrs.max_recv_sge < SMBDIRECT_MAX_SGE) {
> 		log_rdma_event(ERR,
> 			"warning: device max_recv_sge = %d too small\n",
> 			info->id->device->attrs.max_recv_sge);
> 		log_rdma_event(ERR, "Queue Pair creation may fail\n");
> 	}

server fs/ksmbd/transport_rdma.c:

> 
> 	if (device->attrs.max_send_sge < SMB_DIRECT_MAX_SEND_SGES) {
> 		pr_err("warning: device max_send_sge = %d too small\n",
> 		       device->attrs.max_send_sge);
> 		return -EINVAL;
> 	}
> 	if (device->attrs.max_recv_sge < SMB_DIRECT_MAX_RECV_SGES) {
> 		pr_err("warning: device max_recv_sge = %d too small\n",
> 		       device->attrs.max_recv_sge);
> 		return -EINVAL;
> 	}

Tom.
