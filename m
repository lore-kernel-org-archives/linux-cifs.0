Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F95C4363D
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 14:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A35D422251
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 14:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FjO2T0mv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408091AbgJTO3T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:29:19 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20866 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408087AbgJTO3R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Oct 2020 10:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603204154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
        b=FjO2T0mvZaqydw2hIpyu4MAdnzVpYN9qxRO2ny/Lx0PvpOo0EXfxBOvxPJSJE0t/8FbJbz
        51nOtTAHGIwl+mRhCPCtHM0IP6GYApSPBQn1ATn6KBdnB4ha3SL1jqckrctsv4ZbL2Bt4M
        MREEuzHJ++eYuWR0E7ksSYO/mP0vAqQ=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2054.outbound.protection.outlook.com [104.47.10.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-6tG5QrSoNOiLy7OtPdEK3w-1;
 Tue, 20 Oct 2020 16:29:13 +0200
X-MC-Unique: 6tG5QrSoNOiLy7OtPdEK3w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eobax0F25boipUMjA2cTrn0BSs4YDxXXlFnHweV0Kr5crj/EfnjrCRR0lodSTS7bu5GHh48ZB/bFvdzZqCZB9TcZtBCKG3+z/KPaK8fErqr5uu8fEPai3o6jmelcTq49hf0OE2YzNHtdAoKDZog3GD8EGGpRdfiCD/V8HmJ0MrHpn3Yb9OWDcIHTWWmn3O72zeFQTbu5nBe5j8HM5pz1geUSZ36UQ2gN72C1eTO/jwZqLftq0lMC5qwI4kuIbFQIiXOEyCTlS/nzDBpBCNU5iM409sXIjzqQb3G1di6xbZSGbsSfCOXphlrAQVOTVwLxZLng55QnCaNkOjfEim6yew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
 b=cM4b5rWZGue2mNgMS7AMdcZNg/Sx4pgC9ZFM3SgKaUm4lbs+Ey4nq5UtcsTJhy7UhY2gZwYai9+MapUgffJ+EgnK7intCbd8vqRJZeK+BX4FbtAzw869OG/znOkfM5nKXWBB0TT9NzjMtCLlVsud+6VBJk0NCIluh5XfLJxdTy909qPCMHJTI37WmiyS8cGRuyAL2V+u9B6ISiDVAEObOenzYtjJATz6fTYFMz7YLABZ4UMfYxxBRLr9R91zZcEpkrQdu1cYr7qa13WxZKtreJ3Ea81kvfI9Zw39nZtWRA2sOlx5iJslWvf2t6aR+tC2XoQz5rHtaZrSHLUQLqd8nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3348.eurprd04.prod.outlook.com
 (2603:10a6:208:24::24) by AM0PR04MB6449.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Tue, 20 Oct
 2020 14:29:12 +0000
Received: from AM0PR0402MB3348.eurprd04.prod.outlook.com
 ([fe80::b504:9b42:67a6:7f5f]) by AM0PR0402MB3348.eurprd04.prod.outlook.com
 ([fe80::b504:9b42:67a6:7f5f%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 14:29:12 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Colin King <colin.king@canonical.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: make const array static, makes object smaller
In-Reply-To: <20201020141936.52272-1-colin.king@canonical.com>
References: <20201020141936.52272-1-colin.king@canonical.com>
Date:   Tue, 20 Oct 2020 16:29:10 +0200
Message-ID: <87mu0hezt5.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6851:cd9:265:d9e0:b6c2]
X-ClientProxiedBy: AM0PR02CA0008.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::21) To AM0PR0402MB3348.eurprd04.prod.outlook.com
 (2603:10a6:208:24::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6851:cd9:265:d9e0:b6c2) by AM0PR02CA0008.eurprd02.prod.outlook.com (2603:10a6:208:3e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 14:29:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 009b3f9a-3774-4780-6ece-08d875048389
X-MS-TrafficTypeDiagnostic: AM0PR04MB6449:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6449FBAAF18DAD953D33A558A81F0@AM0PR04MB6449.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1I1AUX9tvt86AK4qpPRUDXKum6iil4v6sFngdsWSKH+mbTNMgK9VP+sy0rcvHvfTwxFYg+KlNn2SPavWrtDIRKjy+jnkXtglGawe83ek1NuI59lrO9Hj/YC7b2tMlaAC0qeeykjYAXpcqAKU7h4OX7SUhpKNwN+JEW70vkKNyNNj6eEVyFMJ+OokN18WBIU6myjbaNWqetvD02BXY7SuuObf/bbIrLt61f3u26+D/dEReDoEwjt31NkXHbZdVTwIhSGQ7Kn21inUAZ5yFRffOnbSGp1mKEbDMUCRSExZeCmGGKW2ibTkVc+QHHLuMm0Rlb8SBkM7cXc3O4lLDc5yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3348.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(136003)(346002)(316002)(86362001)(52116002)(6496006)(558084003)(5660300002)(2616005)(36756003)(4326008)(110136005)(2906002)(8936002)(186003)(66476007)(66556008)(478600001)(8676002)(16526019)(6486002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x6KFFhPPUWttASFkgaS3TSSoe8vE1IJI4A630TVl9EzhLgAURnXw2pjCSJp4enqyXxsEfynf2H9mvYwkO1MgypOz8nyjOvuSub5rpN9l6Jh+e54VSQc2tFpagc6oYzqyUVgdDYZzkmnVgHa9eoNJLFHbfrtY8O6o/ucRu8OOLfUoBLP4WxFVHvtp16IuyuqbPwyCnVbSHQ/7hw7D3YWH25lfql8FqakeTHEDw6Z0iPnePhYEDU7h5ecUsF5C7Dla8xA658vMybMx0Fhq4vhhnM9mC8ztL+yUIyzvoBssXAn3onUtBzYQxzf5vdJD0Kfs+jftdV3f2+ufs4sxtkHA6HbP3jMm2VT+mmgvxG7EyAuLE3SdqG7muURuXk+zoxoA4DXmuvYQoqwbzcgeN9a4rwxLBXcKc4Ilb6LVo5VWyNVb2wcS5KN7Y+Sa1VxecHq2Hlv7fpXGC2oRWswN2+0yLuSUC621sxuhwjGLq7baO3En9OSMKXfZuwK8zm4STvvrDhplRgjh/9ETRb4RC+Sw531mDP+bNayPi4pXLdhrjB+Q32Wx+nXjNtU6BovhMTxoei8WybP/zb0F61ziYmMYu4oYaAVyR7XeSB4N4erqf1HL/MDbGfuhdllYMD5OipMD6H5GrqWRZMbrcYTWNg28WWs1acqqb8crWwn/d1cwFECkdp2AP5v7j+4vTu6ibjkOueT0a4VY7OqMuLWPVKvCGg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 009b3f9a-3774-4780-6ece-08d875048389
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3348.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 14:29:12.1095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwpaqaN1qx7A0f1f7t31Lzp4h5KY39AiI/loHjIFg4UTr9SlPloZOMbDaXcDnucv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6449
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

