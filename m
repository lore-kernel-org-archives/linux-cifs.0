Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3ACC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFB4765218
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCHPNf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:13:35 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:53359 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229904AbhCHPNF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 10:13:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615216384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
        b=dsSIb7oiY/V2/taVirZoEOJ8BP3D5jkQzDk+xs7MKSZ09C57n67HDjI7ltEnUQ71hYJHRm
        ejeenlkUKivumPidBBNc6ti5tQZ1vWuGjwlIooVLVkLEVNxTao8C5+2hDb4SO5PM29D+a7
        2tXKzhjWEnMIVifYlXsofKGlPZvuq/U=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-4eUxL0BNNvO-Cxea1DaczA-1; Mon, 08 Mar 2021 16:13:02 +0100
X-MC-Unique: 4eUxL0BNNvO-Cxea1DaczA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfX/6mwpv7aD9NSmF5ehO3474cKh87Oc2oJ9SKh9bVEB8r02yXDSn5zMJTDL9kFGNfoLtj0bvLhdxeBjaOezrzaH8d56/Q5705MbGOp4U8MLaHDRZbUtxvfUqKPWs3PtNhWCNBqJrti5029LUxhV7dlvLzgyMrFBNyP9Fx5e9DVRA7E+zha/KXyjJiQLPL18NMRPdrrt+9RQdu/pROmfd+xzSvIw/hbuJvZwl6ppxWNAPcRas6uYSGNO0tmWPlBp+sipYjecCkkIFhTncIbc9WIcVUqHV1yn5XET8ZTa2dPYfY++1s9ieqNHmrZDg+s3Ho5sHi/ieDnX2m2kH2pXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
 b=ZJtT4dmhL3CkPGfmVhNE6slff0MPcYsuyE3Zxfis7Uk0/hmOiXWQ+SRDMh5d5C4kFEnKU7OFRBQjkqljSHDGcytwncnDDTaIJ9ueTTpEZKIEWmO0N5Y3l0Uarob6uNLuPZNKl2/4jbw4tdLxC4VZixDmf+7WvO5JDHs405FcKhSpy6WawfFEe7njP7IgZpVgtA+23n24J7tAnwQsz/3S1xDEQpJn6zameO4MEFH36oRBskSlyF96dTg0Wv1NubmZTb0+RcSTnsTpepvI9cI9FMwn4MAsaL1iuLhrxorYhhSw0bJYS41Yu9CWMYP3qElbZUs8e0P33GsHE9tv1j6m8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5391.eurprd04.prod.outlook.com (2603:10a6:803:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 8 Mar
 2021 15:13:01 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 15:13:01 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH 3/4] cifs: return proper error code in statfs(2)
In-Reply-To: <20210308150050.19902-3-pc@cjr.nz>
References: <20210308150050.19902-1-pc@cjr.nz>
 <20210308150050.19902-3-pc@cjr.nz>
Date:   Mon, 08 Mar 2021 16:13:00 +0100
Message-ID: <87pn09vfur.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::16) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 15:13:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1630f67f-6f53-4c75-ae9d-08d8e244aa31
X-MS-TrafficTypeDiagnostic: VI1PR04MB5391:
X-Microsoft-Antispam-PRVS: <VI1PR04MB539133CA812CD29B13AC999BA8939@VI1PR04MB5391.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcZMS7cqdD8hUwj2BfBQs1XCt2hi9ymKFuyAvt/s2GxZIcEt4n2eLrb/SMF7rbSNEMZmTGdgIuZ8EfGi1ylmQlnX4xM3SM9MSdm6TvOEyIIGhFc3G2vXF+0BUumnTMJel3WDc+DOOaCEOPNF/Ou3uaKMYwr9Dage+EhTRF6xr9BX5x7VsyusmL/VOcx8KpbTOjm7B0LXr7Iiffde+44qLJRxLV++Zftl+t48bXZJy7KBMOXlViisRfEQAuo4ij9eWvMiEWQRhsmJzprD7QwK2J+LkYD8dmFzod5jMyq/uuDbvBfMtyklsZARnSByTrsMGDT1GeCSHKTvMEBvv3Vhj4xU3hdX5oQChpArYDeyPxtswIMcFV+SsgdxUGWMGMC35+SwOEDcFeR/LzdfkRonocl9pbJr9Jy0CaL2BbfRCt0SME8eO3zG1bMqw9W+BO5vMzW7maTKU7JzzQX8X1kl7tyPrrSvccPxsFWPcc573slo7ZwsDbOMdhWbEnWg5KmCup3sKRg17E9mYNHBI9U1gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(16526019)(316002)(66946007)(86362001)(66556008)(66476007)(4326008)(186003)(2906002)(36756003)(558084003)(478600001)(8936002)(2616005)(6486002)(8676002)(6496006)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dXJkUWlTaWN2NE9YUjIxSHdyblVuSDBqdUNIeVYveTNpUDFDRHVYSWdhOXRX?=
 =?utf-8?B?RHlMTGZCaTZ3WDJDaUVWMXBwSUhyaFArV2ZMTXZsUG9RUjBVQTZGZGpMck90?=
 =?utf-8?B?RmxTQ3AzTCthWlhlMGRIMkpuM3phcEVpajhFRFI3QnNGc0VjUTNoY0d6cmxH?=
 =?utf-8?B?bEhPNS90SllDb0dTUlpmd09tOStkTDlRcS90SXUveVMxYnJheURQdnJxN3di?=
 =?utf-8?B?RVNySCtXZnlNTCsyWkFyZHNxQnJoKzdlYmxzTVRZSmRUUy9DQnRKZDdhbDYv?=
 =?utf-8?B?UVZXSzlweVkxazJiMjh0cUx6R1A0V0Z1bTNuVUZoV3R5QkFqUTRyc21ubTND?=
 =?utf-8?B?WmdXQzlBMjRPb09JOEppdFNlUkRyaEg5RHRxbi8wUXJQa0ZJc3FQSHdlYSt5?=
 =?utf-8?B?YzgwNUJFNHlkZVREVWF4QzBXUDFBdjh5YkwwaUltVisrbWhRTUV6WDhOdDU0?=
 =?utf-8?B?dUpsZkNHTkRJYnFSY3Y4VG40SDR5dDFlamhYRjhQK2x2aHFmaVZ4YjVGTzFk?=
 =?utf-8?B?aWtFcGVaUk1NWkJpTWlUTUVDSGlSY1BoMEkrU01LWWlMU0x2WnZ5MHRnNjNV?=
 =?utf-8?B?WXZmS01HblRQSE1RREpYVlcyOWtDQTJJR1RKNFRqU0JVRHVmaE1NaVZLSFFU?=
 =?utf-8?B?dnFJVnV6Sk1zek10cVFOZVg3dmRGNGY1S2Yrd2NSdUxUV0Z5ZEVsNC9TRG01?=
 =?utf-8?B?ZkM5TGgyUURxMmthWGFoU0RxS1M0cXZyT3g1R3V6QzRJdXRtTjFYWnVMVk11?=
 =?utf-8?B?eEpmd3FDRWdxemg4Ty93blFxSkEvSjl4WDFLVzRsZFB1a0Y1L0h6Z1hGWHpX?=
 =?utf-8?B?M1JLL1B3LytQZ1c4d01EVC9PN21TMkMvZkYzbk1NMkYzamVsUFJ0Z2xCVXAx?=
 =?utf-8?B?Nm5jc2daeGt6OE9EN3lRWUxpVnUvdVJCckdKKzFTMzBPU2hDdHpzUXRTRmdj?=
 =?utf-8?B?ZGFnRkZqUmQ4bzZJcFNuU3dGUHRBZlUrSHVXMWZQUlpVdXpBSldDNjJLbnRY?=
 =?utf-8?B?TGdOWFdHc2VpNHpGY281NW9HRUl3RE55R3VaaW5ZZzk2WDBVKzlPWTFSbzRU?=
 =?utf-8?B?YUExdHg4NVhYclJTRjNzbU5SZm92VlVUZzB0d2E3RlMvRUFJZzFqelVwakhi?=
 =?utf-8?B?YVhNRGtZUWVSQjlya25aV0U3a3NCOEVWNzdmaHJYcmRVUGErSkZKR01UdHcw?=
 =?utf-8?B?bHR3bHNiRlcrRVIrMExlYnR6S1I3S05ZamxDOHpaM0ZkZTRHRkV3VFViMEJ3?=
 =?utf-8?B?eUdQaWdFc2wwZmsxYWk2NnpnektyL2N3K3JrMHcwMDdrUExhc0FSeE9ucGN1?=
 =?utf-8?B?OElZekkzMTRleGkvTWQ0N1VMV2tJY3BpN3F1ZXVTMXVpamVTZzJ5S09zcDBW?=
 =?utf-8?B?aXRuNnJGYjhEc09hUUpRY2tHWVQ3a2p2eU9XUmV1Y0FyU1dFSUs5OEUrZmpN?=
 =?utf-8?B?cjlPUytBTW5SRVN2QjhWWlF4VzdIdWRxZ2N1SnZGM2ZtZWVqekFYVVNpZGoz?=
 =?utf-8?B?R3ZPdTJDaUNzbDR3dG5YT3lYZVh2SXUwQ3Rpb2MzNkVwOGhNSjNxSHJ2cDRz?=
 =?utf-8?B?a1A0RnB4bXl1bmp2WGZqVlQ2Q1c1eHpWd0ZTYnQwcHFaRVRBN3JYdUJmUEQz?=
 =?utf-8?B?Rll1UkRUN0UzVzJJa0o1eDYwcEMwa3drTjNrMWRBVDltKzVIYkEyRHpSNDZT?=
 =?utf-8?B?S3lobkRtYlptSFlxS3UzVlpJMEdZcFhVWis5TFk1RjF3MG1SenpSSlZTV3l1?=
 =?utf-8?B?UXpDVUUzQ3d5OXBPN25ka1MxWDBud214ZTdKdUIvVktKaXpEa2pqL0hHd0Q2?=
 =?utf-8?B?WmdVRTZSVUpFZjJKUndXbkxKWitHOWR6N0pKbU5GdGoxQ25wNkdDVFhOVGZU?=
 =?utf-8?Q?N4gjz8l58l/Wm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1630f67f-6f53-4c75-ae9d-08d8e244aa31
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 15:13:01.4860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jkcnl3iPK0vWEr+cOcdnUvsXsNVW5rZXiw/5LstosBNUT4F+on2ACHSA8BEUc+Hv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5391
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

