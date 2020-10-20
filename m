Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F535C4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 14:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B619322200
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 14:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SPayIC8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407793AbgJTOCf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 10:02:35 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:29199 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407792AbgJTOCf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Oct 2020 10:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603202552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
        b=SPayIC8uoCszgyoJaYnt9p5YFCjo5J2DCgFoszLgAxnn463ozLRrWtmDJLonJ5qFS3eGRv
        nRVmRledqcTJ6Vvoh3ZnRCF3w8ml8hpLrazc/VCCSN9FWp98I9AKC/nLqJ5Nz15tUhV6Cb
        3/VbRNEmcnbnJreVl67JF9+e+e0gmTU=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2054.outbound.protection.outlook.com [104.47.14.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-NeGKMcpZMPyBOgMb1GsNcQ-1; Tue, 20 Oct 2020 16:02:31 +0200
X-MC-Unique: NeGKMcpZMPyBOgMb1GsNcQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUNzww30lwR/riEUj58ZpdPCUvwJLcyBb340Jznek+efsgYAmf9VTKNr3k0PrLu/85hP+Seg8zk59qKDlfV4vGE0Zz/QJK9+Fb7UZjexXVK4Di3ngYyp3iiMrJyPIylsljiKdhM11Mcsm+HKSApyC7c8ljFGpyG1Gb24My8i2XBUJUUXT/XEUcO+uH5ZVj37rXh1a6xfgpisJ66z5oaXZgMJXbhaGcXrjZHHGI4Wi6Ghs/wXEhSUuxVx/b5m7UogMqGRjcuVQSuOH+9AkgEFHWV1aj3RZtBoI7FeeDSmr0P1qevSFAKxka96uTDYO/1v5iRWGxFEvRkPbqiL5BhDhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
 b=R4Rpo1XbBGdm+gf2aOdWKAPrm/lXHheYM62qWd838VbesEQFb1/xi4Ex7gAw8lO0cnCzgwh4SA+iaycagXF/luaCP50n0YDXNmASpYpJC1y6RntCFAnHR/CVfjMdkyMZ7t2bFQH/x3klxUrUfChsZyxRDvW3zMc0eM+HS/IKiNGB7AIe1uL4MoeETtkbH99EIBHgWfDLchw+cNZpPvA81MN15olN+47UAzm6NPvBWkBS0g6gbUYOJQTREnGeFrxlNVa1j+KX1NjubCR4fW7HsAdu0NxyEnD2KITaEW2ZOzqzk46IgQseMsW7zFHo709a/9Tq+E+3BJbA5KYpWb90Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3348.eurprd04.prod.outlook.com
 (2603:10a6:208:24::24) by AM0PR04MB4193.eurprd04.prod.outlook.com
 (2603:10a6:208:58::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Tue, 20 Oct
 2020 14:02:30 +0000
Received: from AM0PR0402MB3348.eurprd04.prod.outlook.com
 ([fe80::b504:9b42:67a6:7f5f]) by AM0PR0402MB3348.eurprd04.prod.outlook.com
 ([fe80::b504:9b42:67a6:7f5f%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 14:02:30 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [SMB3.1.1][PATCH] SMB3.1.1: Fix ids returned in POSIX query dir
In-Reply-To: <CAH2r5mupOWfBrki8w0bWDamWLB0m=HhSF+bqEwGsEs++K0x0Mg@mail.gmail.com>
References: <CAH2r5mupOWfBrki8w0bWDamWLB0m=HhSF+bqEwGsEs++K0x0Mg@mail.gmail.com>
Date:   Tue, 20 Oct 2020 16:02:28 +0200
Message-ID: <87sga9f11n.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6851:cd9:265:d9e0:b6c2]
X-ClientProxiedBy: AM4PR0302CA0009.eurprd03.prod.outlook.com
 (2603:10a6:205:2::22) To AM0PR0402MB3348.eurprd04.prod.outlook.com
 (2603:10a6:208:24::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6851:cd9:265:d9e0:b6c2) by AM4PR0302CA0009.eurprd03.prod.outlook.com (2603:10a6:205:2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 20 Oct 2020 14:02:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71c60ad1-fac5-4eca-6849-08d87500c894
X-MS-TrafficTypeDiagnostic: AM0PR04MB4193:
X-Microsoft-Antispam-PRVS: <AM0PR04MB419339B78E1AFF2206D922A0A81F0@AM0PR04MB4193.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XWfyeiGjN49db8kBKuByYZ/wzcolW7BfWZ2XFw3X9N5mAE6jnncHMgjpc22SC0rZSroWwgI+rscGLeCXr7HXMFjtldakED7VTRlD8DC/8hpjzNlKAicD8JGtfn54+s04taR+fU1gvRUSXBrxDYMv/O/9zYe7uQcQW+/MlRecVVIM43cOLcLH3FxzBoIlsENdOGxFpc7oX9vuqpX/bcKUhv30UtcnSzscqRQJ8ZXb6eOo6Gdz8iqdBIi8O7xlBtYhRN9d/8CbVt0LrU7kmePcy7VXqpQyiuePThhkaloLka5HWMg6VYHu4Zs9p9JZQZf+krr2+GY+MGCekhhbBES9Pg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3348.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(39860400002)(366004)(346002)(36756003)(2906002)(6486002)(6496006)(558084003)(52116002)(8936002)(16526019)(2616005)(66946007)(186003)(66476007)(66556008)(5660300002)(86362001)(478600001)(316002)(8676002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8vuGPrzitGWZnTARdOQ7nkgHtCAh/0Gx8JP+n8cO+OUz06Sdm+LYbMXnvdJm8y6OrH8OFZAXjOnmbROt5JZPuCQlP0rRdadUOlUMeOeXUgYEKh++AqZEG3yJH0GmpPbiXW0VPJMnTtFfx/cPpC2vJYA0wEFEToBFio7t8kk/lD6tR9wiEh70MlsvdwdZJqFLBfhVTZPvWIHOSqSGMTdc+9yjGK2nx8B5C8k6om1mJAFvz6TXJ8LDGm0IL/6AnbeMON9Bq/476WLvzlkm2tF/EpVCoA2117Rh36cMXrhgiPi3FW/xmYIcfAtW4ZAGSvHhbSvVJvfeLNgUdLBsGs9YNHcNOqbWrp2d4HUlFP81Ld3yCHvOq1q8tocxdxm4d9sC3eKeOGgqiKrLk6AG7Ay0BdTHFvBmQ46hU8jab0zXUXyB/b53+y9zf8gZ/xD1/BpJZNWYlpIYLGYTNbRz/cKEjG8aYIk+cu1F8WV0287LpITelTLQl3WsFfxdU1eqBUJIlF4v+oP2W3R+n8b3GpxKlaLrGK5FmBVhRQ5bVN4w6az5oB/k/XcvEBZFf2Ga7mrJsOknGdSAqv5d6BEF3KBeOcQPmsKaOsvmVyexPoPEBkpx5dI/94i65gAbsfdts7tkeKz6Vvg0vdKUPDVEkUMpiL9/imK5VMBdAuv9OwhwEU7GWw3d93Y1sUdzQf3EbxR3
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c60ad1-fac5-4eca-6849-08d87500c894
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3348.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 14:02:29.9683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGQxa2uZzgxzM88pnFu0oFjwITrerbbWNcZNdxr+Hh0HwSOZQlNh4X4kI4IkdPwO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4193
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

