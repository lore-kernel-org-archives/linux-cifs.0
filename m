Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDCAC4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEBCC60FEE
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhFWLur (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:50:47 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:32976 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhFWLur (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Jun 2021 07:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1624448909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JqjUcokIs5TXJyM31vb+hWeOrebEnjlWxtPzXNJY3aY=;
        b=BynYea8Nrb3TbAcS33Nvb36jWMNm36r4IXTgU3SiPCfE1DI0urSxcBvqcCZ/vQFHxjB6gq
        p2ZvRx+UTobIaHRPHR3ignkmlqSbDcC/bKRYhSgb0IZJBieBa6M3nNnTgYU2MJl4/NyzMv
        zvV5Q52oP/c/iKfTBo1oEotFsMw3DHc=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2053.outbound.protection.outlook.com [104.47.9.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-x0iUPFJUNvCM_9-yoGqgmg-1; Wed, 23 Jun 2021 13:48:27 +0200
X-MC-Unique: x0iUPFJUNvCM_9-yoGqgmg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjcycYJJvs8Ro0i3AiAtbF5/6qY6FmIsTfmDcIR1z2HOI6rpcPxA6+0aQC3x0MGqJ6H4qZ+jom9mfKJrvN5isNqKAV8kY0WaiAqZK7nYTIa8bfxc3JZjNs+9xxGtaFRd5SHCTaX+kXVCRjPhj+Nc8PmR/ucfIm3WwVOLYQFHqu3iXBtTh8+tDQhd9yVnv5s5VTMQoCyHGVwIhBKDqqD1wwEgOXGyqUK08WGhD2Mty2JdBTtED8Y+/ZjEcYVs8BDGlzoglanTjoI0D/PdabVdZJXF0nJ7DqzFoNbkb9Ir3LL57ceCS35WKyk307WFv3OroiB2Ui2y0IyXEd4TZFWSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqjUcokIs5TXJyM31vb+hWeOrebEnjlWxtPzXNJY3aY=;
 b=U7695GvwRBYyVpRAhMEyFclEqWcohcqePIN5pecDpyD5LLUvu+Hm4YptrMunTW7wX05vhUGvhyxvOYofdPUHzFuwGSyKiDjV8Yhm1fBtwKwO1yRCv8eMgeXwFOMMlL8kUpDVe4FGezKWI/g8T45tnvTBmmnsPDGeqKI5CCm7YQGAxvEFhzzF7Cb+1432EJ7AvsO3fkYs0Vjz6NHA8qVwx0uJg3dzVYvIN+aO69OjdTXCKF8Xn50ykQj9ud9cgNOmKgbgedqRwmVpLeW0+HaBA0JpTr7RgrTKdKwGaamXM+H6co7rPSpxOBQyex+ZIQch5+nOyMG58FxVXUIMj1iUYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6189.eurprd04.prod.outlook.com (2603:10a6:803:fd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Wed, 23 Jun
 2021 11:48:25 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 11:48:25 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
In-Reply-To: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
Date:   Wed, 23 Jun 2021 13:48:24 +0200
Message-ID: <875yy4red3.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70a:9978:e3b4:c6e6:8f68:a927]
X-ClientProxiedBy: ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::9) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70a:9978:e3b4:c6e6:8f68:a927) by ZR0P278CA0058.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 11:48:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8305b08-6f7a-4826-b3ee-08d9363ccf7c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6189:
X-Microsoft-Antispam-PRVS: <VI1PR04MB618918315E1B7D2926F761B1A8089@VI1PR04MB6189.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvmhMg3rykoYJl2v51EwrM8tHsDqLHnFa4KOyuX8A7gZr5M+hU9WR5gaefPheFWg1NYIE+Ayj9s7c2xTNPlQxEdmcAZT2lK6qB3pZ5jiZ5VHaO0nz7EmE3eEoPXvaZE7ct3fjO1T1OQh+HOK4jdF176YwtnGLfauBRBsOivsu5lQBHVRfGpgl9xocecyXjwBEGl0odnrIkGOh2iaaIXN4SHl/4MEv/CDZOGYFUDLPuM3ctJqzoCD+5YqzRkrkkIwcQFttgLfRZrizJAtXoMegSs/LM34j3hU0yFr88Ib7H2vMbByn+FwiAKMU8CPiB+i/czvOND0/CnYEbGdOB5cjWUaKu4MzP48pmrmMtJPJNhwXkM9YEYolW7kY1g29HZngweaLT0X8T24xLYcEjwty1Q70kDTcXT4yzPSuJDD9rvy+8Ht3YmDVGCC3/eBfaZ1uKNlCsc1pI0Tv1dhL2rQm4ilZKljsWdBZrOXpHeO8z/MLUjzh9LU1pNlDaKwOoJDiydcBo3N8xUwPPmaIna9dx+Dkzc22w5n7+Ry4JsvkP+u/Dtl358r4+xhs08/QifzVF48W0mIMt6jwOnUQ4ByhKzfa85RztJr+F9lwSrmQYc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(136003)(366004)(39860400002)(8676002)(4326008)(2616005)(86362001)(8936002)(66574015)(6486002)(186003)(316002)(6496006)(38100700002)(5660300002)(36756003)(66476007)(66556008)(66946007)(478600001)(2906002)(16526019)(4744005)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OU5RVlcwdkFUYWxybUg5Mi91N2Y1Y2NRRjY0S1Q4aHFBVFd3RVZsQTJtaE9K?=
 =?utf-8?B?S1dMcE5UYmxXSXN4SWR6NFdXRmhHVFRhV1V5cmZlNjZvWi9kTDZWS3lEZElJ?=
 =?utf-8?B?TkptdTBZQzZtTFEvR3BaYXdISTFxeDlqKzhSbk0vVllZcFBZZWluNnpYRzNz?=
 =?utf-8?B?bUxPSHVPVHhlWFBxQi80SFp0cnRlVDRBY09oOC9aSS9TdnlZSitZOEg1c3Bp?=
 =?utf-8?B?ZU1ZZzg1UzQ3MHF0MlRNS0Izd0lRSFdqNllpR1piaXowYjl3aCtxdVNaOFBo?=
 =?utf-8?B?eWdnc0NMT1VNbGowMGI2VFc0YUQ5Sit2M1ZZUWR2M2RjR1plSHNEaW1lZWt6?=
 =?utf-8?B?UzQzTytHaEMxSjMwSU5WR2FFZTV2VzFzTjlIUjZWMFZNZDBYRDg2cWZQZUNq?=
 =?utf-8?B?eG9xZ1dOKzlmVlk2bURNZ2ZlVGVXRFRmcm1LdE0vcVo2WFlBYzlsamdsNmFV?=
 =?utf-8?B?N2xtUVE5YmJmTmNYc2NyU1kzTUhJUERsL1p3TmNOMVJTNHRqUm5ZRUNTSzJQ?=
 =?utf-8?B?ZENxOW1lenVRWkt2a2RtUE9MdnpYcmJpeTNsOWR1ODNJRzJZSVJ6MkJidmZr?=
 =?utf-8?B?SVpwZlM4UW5yRytJc2duTTRCTkxDczZFcWQ4clptdE5iemV4Nm44bFRZbFN0?=
 =?utf-8?B?ZWowVnFpZFY4L1BxU3dvdm0zaTlpSFNMMWV6cFV5ZGgrQmkvQTdDMzdKN0ZL?=
 =?utf-8?B?cVc2cVJXN3dzTTIrZFVQeU0ySFNSSG5teSszTFFMUnM5VG16V0REalY4aUlu?=
 =?utf-8?B?RXBJSVM5bmJPZkMyQzVFWHRDSGFBcU9JNUZxZDFpZnZmdU5IandFK2ZIMnN3?=
 =?utf-8?B?bzRRMWRXTDdBemd3dmtqMnh3N0dxbkgxT0lyM1hpa2RNZlFKZXlBWlB0bHdq?=
 =?utf-8?B?YWJLWFhoelRMOGFlTElpYitLblBNSndUb1l6QmRaYVQ2T2RaZGZxTmdlZGZs?=
 =?utf-8?B?TVJYTEhHNFFVRUJBbnJSbS9rVDdkTkZFaU9GMnBURTdNNXRSZFdIMDk3Nkhu?=
 =?utf-8?B?anZHNEF1eWdCM3Z2L09qa1kxRTRCWFU5UkVKeVpOOENEbi9DdElpTU9mT3Z1?=
 =?utf-8?B?RkJRdmMreURpQ3JTNkRzVVFWaFE4ZmFhNHR6TytVc3Z2S2kvUjR1eUhWcnN3?=
 =?utf-8?B?dWtKQ0tjTlZ4QzRWWEJGNlV6TzVBR1FlUEVIU2ZIOFNQVFFGQlpqT00wR3lx?=
 =?utf-8?B?TVFMTlp0d2JOdlBnOFo1TUhGNFAzODNQeDNFNWgrRnBpK1doOTRXSFhGa2Q1?=
 =?utf-8?B?bFFCWjJYTnk0WkN3S1dyZ3R5WkkxMUxvQ0owdFNGU2EycGFGZjU1TVZLMkdv?=
 =?utf-8?B?OW03TktOK0NBTnpSNExGbjdTbHRzck9WWU93N0U3TTRUcnBoM0VHMjBiOXFv?=
 =?utf-8?B?YnNSYVpEcWNyWEJIMHZsWlkyaGpjZTArbHQxN2FaUHN6NENvZ1RXSi8yaHFU?=
 =?utf-8?B?cVJ3c0N5dEtWbzZhdUtZZmZ5ZEVmRTQ2T1ZUWnMyRzJVcWJWcFM1cmtVeDh0?=
 =?utf-8?B?SFpLT2UwM29rMzNSNFBHaDgrbllLVmNYR0lYTnc5cU93VmMwZFJzZkNGR0Ju?=
 =?utf-8?B?NTZoTXBOZFhmREFJNENUWUE5UmxxTERhZmZCK3NvOWF4RWdGbnZPV2M5Y0Jh?=
 =?utf-8?B?TTUwRS90dkNuWUZiLzdUa2NwbG5ZSG03R3FUZ1Z2KzhwbzZOS0ROdkd2OUk0?=
 =?utf-8?B?UXZmRzRDM1BVektaRFpZa0V4VS8vVlk1M3E2YmFDRmhmVHBCOWpTWW5oVENs?=
 =?utf-8?B?Q2k0bXorN3h1TXZMb0hvM0hqYnp4Y05XSTYyNjFLL1IrUWZWNDEyODhKMk0v?=
 =?utf-8?B?Qjk1WEVkVUtIbmFKVnJzZ0ZpT0pJZlowL25iSWl6bnAzYkdwbjRlQUdKVUh5?=
 =?utf-8?Q?1GcRt0XWVOlPD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8305b08-6f7a-4826-b3ee-08d9363ccf7c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 11:48:25.7393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRLex3AFNWrSiGcy2QMxFd72cuErJXtAlsrG/M0e4z0j0OzFv6XgtFasN+g7rWVg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6189
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> We weren't checking if tcon is null before setting dfs path,
> although we check for null tcon in an earlier assignment statement.

If tcon is NULL there is no point in continuing in that function, we
should have exited earlier.

If tcon is NULL it means mount_get_conns() failed so presumably rc will
be !=3D 0 and we would goto error.

I don't think this is needed. We could change the existing check after
the loop to this you really want to be safe:

	if (rc || !tcon)
		goto error;


Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

