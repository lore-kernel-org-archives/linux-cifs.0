Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B13EC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369236526A
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:30:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhCHPaU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:30:20 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:51009 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230002AbhCHPaD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 10:30:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615217402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JHOLZ0s/TsJ9xBRex7GHwFYJtD5iYwayMCNs9rIDfWc=;
        b=QdpN4k6hD/YJ8DsM9i+cixn7wIFdMrYTqPTIVklCnBZbxGN3DqLzzZhKICAZejuNE8Y90M
        qixK9J3KUxLxfJ3mJeoFMz+0Xtg37vg/6uf1/14iOGgZBLLZYwyAJsMY4afxLWh69fK2lk
        zLLuLHynt5uFYuTdBO42TsZySlgumzU=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2053.outbound.protection.outlook.com [104.47.2.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-4vz1kM41P6Cpx3y5VPv07Q-1; Mon, 08 Mar 2021 16:30:01 +0100
X-MC-Unique: 4vz1kM41P6Cpx3y5VPv07Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTyob5x0aEAbomnNp+rRNWXkdQos7EWdF+LYR+TP23K0mo9YmfXxFXTXrjktIffkdDbFJHtd+i4D/LpIHgpcjPeK9qBQIz9LiCEzKYKOGrlB+VZZ6kZ5e8q5vnq4K6oC1gRq+dGw4UA0tuo0FzkNvWIe45kryzO++NYQ3+u62I9sb4axfXGWDC1hl3Bxe1nCosQAPhy7rTh52OJiJ0+OJbyM4RYLclMaGwjH4W6c1Dnq72tNWCSDS0NjLD9NygV/BT2WwaOCWPqiFFxzeGtxQ4IL0gv8598WMb8PrLqcpNUROnW+EZ370Ng8UFS2xirdQASH5+BjD6Lm8lHFVwRnAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHOLZ0s/TsJ9xBRex7GHwFYJtD5iYwayMCNs9rIDfWc=;
 b=VWzu1MqiqF5GW0+BheSHkC3g+sNn5tzQsqQaC7HsB8V1l4V05c08zvM93rIks/d7n9keRoz04rb26Pk28KQnvPZfU/dZxfWnakqt1nfsDvfHf4bgFUxb/C+kE6iOsW6dtgW9scvJZgD+iicnCBrGw4nRpjQkblSlhC4FZMJEl1M+2OcvfERpohH7LvmwzLoABd50I1q5sYEb8b1oCjJPLgSubokgT2HB7/W9Y/kFgkOI9F4izhj97jC6U3UR3P8P0A7RehpnNniQW9vgvLLU1C15Okmq+WS2JxFOxjeJiSHjP7Poyk8E/m40Pn3QC2mxL9MOTRsiF6zYkOwqqET22Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6189.eurprd04.prod.outlook.com (2603:10a6:803:fd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Mon, 8 Mar
 2021 15:29:59 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 15:29:59 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH 4/4] cifs: do not send close in compound create+close
 requests
In-Reply-To: <20210308150050.19902-4-pc@cjr.nz>
References: <20210308150050.19902-1-pc@cjr.nz>
 <20210308150050.19902-4-pc@cjr.nz>
Date:   Mon, 08 Mar 2021 16:29:58 +0100
Message-ID: <87mtvdvf2h.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 15:29:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a24763c-cdc2-4f32-8a08-08d8e24708ce
X-MS-TrafficTypeDiagnostic: VI1PR04MB6189:
X-Microsoft-Antispam-PRVS: <VI1PR04MB61895BB6B7C28267E7BC50A5A8939@VI1PR04MB6189.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JhHLKLdvmVvuDUmnBUg6glF4hTn38puK7BPgAidOkVY9yw8Bw1vNLlJ50lGv2tzvKvP9fNhN+7qD98MOoDktVTVjPbU1hvy4sGuJS4+bUHhkHtQGBuu6anwl4m4iBzYoTaWlYaw+RqVAEULFzde3OZZRqFYeETX30YieNS3Av5ELCdrZl48YFnSRlAk9YF2RC32tcTQFl8WfdwmTwya9MLbJMlFl/MYzZzeRoc8Im1ptXMIKBxFLsy66ous1/IE0L8tOCvyAPoCB+MJzqWHs3VE74hhDt6E0ROSFPz+4ZDWgd4W9AzwmpqmT0UIgUttiuTewYlKqEHUjvrrmf3t+WjmJ00UEUAv8sliKHxbD12No0PfnCxtzSoY8Ny7zQjO1SgVa40GJAmsWp5ekFzceZLBoX36PwIXKx8o2KeDhLCERtbAqS54c8wIJOHvcC/kbmAuAwOmu1+Bg6iLm1+YMR3yLAl24BOXfmN7/kx1PexHdCY/VjihsFvPrCbp18KleG14aoy+UMJJvlFeYXhRMoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(396003)(376002)(136003)(66556008)(186003)(16526019)(66476007)(4744005)(2906002)(66574015)(6486002)(83380400001)(66946007)(36756003)(52116002)(86362001)(2616005)(5660300002)(6496006)(8936002)(478600001)(8676002)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NjlOWDVsLzVYRVVTOFkyVmY1VUN6bzdmRStXdnFPU2lMcngvNW51SWpPNjcx?=
 =?utf-8?B?V2xEd0IwejR5dVNCRTgra1ZpNFl6Wk5jOTNSTXpjOGQrWDAzSVVOMDFKT0xO?=
 =?utf-8?B?bDB6QnR4Sy9UT2FMLzZmeTlDTGxYVzFUdmszT1lTclBTdFUwNmhvcFJUS21C?=
 =?utf-8?B?ZDJNNUdxenV2RGpLanZMbnZ1VW54UXNRSE5mWWtZUHJVWWhxeHNFeDBhSUpL?=
 =?utf-8?B?cVYxVHI3TVlMbmRjZWVmaURDc2k5R3Y4U0xXZW4xTjVldk1mZ0Q0TGN5eGJl?=
 =?utf-8?B?cGJPbklRNzJMd2FzUUZ6ejV5TmZZSGFGZ2dpeGV0RWJ2enkrUm1ncEk0TjEv?=
 =?utf-8?B?djZCdWN3SG1nSFd2aUVEclNkeitUa1kvcEVKVmdicUg0MThHTGxJbFRRUUFO?=
 =?utf-8?B?WFZoUktGVFFXSGZzQ0pLS1ZkZWFCRHFVRVlKSWZsR2kwYXExVk4rSFp4ZDBp?=
 =?utf-8?B?eHVqcmdMTUJiMUNBZjlvc0djeUE3dHp2cis1OHRwNFJXSVVieEVMMURsL1VS?=
 =?utf-8?B?cTJQNjluYlBqYlorYlEvOElmUnRaMUcxZW1WbHNSZVpwYWZTVHdWVzBFY0lz?=
 =?utf-8?B?MWxndHBtWlVHT0w4RGU5Nmc3TzlwOHpXMUZrN0drRUxxRjJQLzczZVM1OHNF?=
 =?utf-8?B?OGNNR3dXM2xkUzRyeENWZ29RWk1CcDBpWDBtTzNscFRUWERZTndpZFdCQm1n?=
 =?utf-8?B?RTNrYlRIcERvTTA5dnh4QkdHWks1aGZ0TFVGTko1UEtKZXgveU5ERTM2Q1NY?=
 =?utf-8?B?N25VQ3AvNFlzT3dVODZMY0p1WFpINzlyL2p0Z2I5NE5Xd3FrUXRReURaQnlV?=
 =?utf-8?B?eTZQN2FNdHdsSVdzeEdScjUzWHhEWmpvTm9lMFYvcjNHdG94UEZnMkZWaUt6?=
 =?utf-8?B?bG9kMVVYVlR2VktkdW5UNkNLTWN6TTd5eEd0TmZGMDlmVWZHa0l4VHR3V0Vj?=
 =?utf-8?B?QTRwR1pFL05Gcy9QQXR0WkF5WFVFNEdTQnlHWG9zQzlBRFh0eDVKTDk1YVUv?=
 =?utf-8?B?QVpsNC9ndTlpV2IwenRoblVYc0oyZ2MvSFdxajQrcWpJSWtFUWRaL1ZPMmF0?=
 =?utf-8?B?bWkyT0UyRkhSb001R1J5V29SVjE1Z3lMUStKYUhZaU9Ra0pHNHB0NDQ1bU9E?=
 =?utf-8?B?QWN2UDJEeFExRy81U3VqMjhVNnZoVGZiWW9SSmhsNHlaM05nZ0wrZU9XVGFn?=
 =?utf-8?B?MXVwZTRTMDBoYm9iUXNLUkpKT0hMVzNmZlFUZjJpcVBCN0wxQ1l5bzhMUmt5?=
 =?utf-8?B?dE54ZXErQlRRbURsZjZ2d3dKOFJmanVQWXBiUzk5RFJTTWMvajZ4UTFhRC91?=
 =?utf-8?B?WXM0UGhjS0RpZUl0dUpWZjZINTdpWFdqTVBJQndUSHBkcmduN2hheUtxVk4r?=
 =?utf-8?B?c3RmWERLVWtidnJ2Q1U5eG5PRWowR3BiVTU5VEV4dDQra3BnZGc1TUFEY0VX?=
 =?utf-8?B?R1o2KzluTE9wdHJFbm5ZL3p2T2tiYkdXa0MrK0hDZXp2WjhXbmNGNzIyVndx?=
 =?utf-8?B?SUFZRGtRU2JDVEZ0KzExL1EzL2FrZDBnY2NWRThMZG14UlE4U3NPb240cmZr?=
 =?utf-8?B?ZERtMG9iaDgvd0QyTWNTclpvWm8wL2dQbmZXNG9VeElpbnZ2K3A1MmZmL2xr?=
 =?utf-8?B?R1hMRWNadXRvc1JiMzdpMWdLS1hCWm5ZQkxpd1FwRWJhQjEwTUhyejhNa0Uw?=
 =?utf-8?B?VmY2ZkdSNmVVcmdkZG1FTXlVdm14M1h2UE9ObTBGcVpSYkFYc2ZPaUk0bTln?=
 =?utf-8?B?eERDMkxSODNTcExET1ZIaXY5UzdoSFhUN3hoMTVEOVE5NmR6UTcvKzRobmov?=
 =?utf-8?B?M3JiRkJ1cGM3cCtUNG5Vc1pUTWxObUp1VGtBNjk5eUFjY0plcnZvT1g5cCtp?=
 =?utf-8?Q?FWGr71nq3s0iK?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a24763c-cdc2-4f32-8a08-08d8e24708ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 15:29:59.2403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9L1L8IUHkSEL0tGjsyUE+F14634qnA4BOk2dlkt2i4AzYOFWxxpLZAtWX16EOsmR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6189
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> writes:
> In case of interrupted syscalls, prevent sending CLOSE commands for
> compound CREATE+CLOSE requests by introducing an
> CIFS_CP_CREATE_CLOSE_OP flag to indicate lower layers that it should
> not send a CLOSE command to the MIDs corresponding the compound
> CREATE+CLOSE request.

Sounds and looks good to me, good catch!

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

