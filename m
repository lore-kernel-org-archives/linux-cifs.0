Return-Path: <SRS0=Tfa0=D3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4614EC4363A
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 13:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B950521548
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Oct 2020 13:52:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="j2bCzAVj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407645AbgJTNw3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Oct 2020 09:52:29 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:42987 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407605AbgJTNw2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Oct 2020 09:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603201944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
        b=j2bCzAVjtgHzSZPBsRpnxxsUimk6IBjlJvW9Mbv2o+dT1DXIUeU69gzWfLfEVjYhfqad2Q
        bFLMgxJHgjCvZE5n8GEXjno8fDzqrwdxgjbYCGgGC6e3mzUOAiJOOxbBlbjQMITWUOet2U
        Rf7AhNWwPcf8f+tHsXxvLPc92BtO/ls=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-P3MxvL4CNwmxri7TmeMmgA-1; Tue, 20 Oct 2020 15:52:23 +0200
X-MC-Unique: P3MxvL4CNwmxri7TmeMmgA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bMDhvtTw3NUJnIMI0B6JOIlMirH43NRjkc+2+pF6PXtTw1vkc7ZWUddaccaXGDGFYeqKivSoVuiYXFGIPs4d6o+Ag6jm/QLNaVgsB47olcX7qj7Z3AIZec/rL4NKXI0682jL/f2PKgOWKxnmPqYVG8geIyAx3e0iVL/ctWP2y7q3DA9b+X6LtMNPJPauyOrkVppLlQvE+A5xbCquPlHlKFMgSP+4R+lIyOaTGtBGoniwcPCXdTfooFo4VbsZbWNdszVinaeSeKqP6qKq+faScdd2UYk1dcyaYWN33Ac/Mv57HhWGtwkLObXDWGagfJ/PYBLj/waUHk4dFVE53eqWgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
 b=G9sQSucWAx2QLcMhFZEEJ4Z6Q8gRx6tMqEvu8K1sM6zljffiF9a9aqcm+bcTPdIK/aROm+KkLPUTYjZKXGdM71U6USm3EuZbqrrIZzWHvGF4Yxb8PuB6zu0W3l6IEOP9+SyK2RS7xa22quG/FAhrSDb7eo3xY5tjL1RXhvyd2Vvs85dZ4MBOtm0woZGTaY6CSN3KYegRkK/q3eOe5nAyGa51CSoF9qIyhPyLBwEHG8I4VRD0cN6v4bZm1VfYhtp5064nTD+mqma/GOi6zdFk1k4fvk96bRNhbtn4yY1IhRoK8T2OlUffGQT2eYooEp3aSz46MXXypchznyuUZVz/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3348.eurprd04.prod.outlook.com
 (2603:10a6:208:24::24) by AM0PR0402MB3345.eurprd04.prod.outlook.com
 (2603:10a6:208:1d::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 13:52:21 +0000
Received: from AM0PR0402MB3348.eurprd04.prod.outlook.com
 ([fe80::b504:9b42:67a6:7f5f]) by AM0PR0402MB3348.eurprd04.prod.outlook.com
 ([fe80::b504:9b42:67a6:7f5f%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 13:52:21 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [SMB3][PATCH] add dynamic trace point to trace when credits
 obtained
In-Reply-To: <CAH2r5msrepnfx_wpi4uNp+OjcWz3qWTTBLBWb=T0E8i4E3Cffg@mail.gmail.com>
References: <CAH2r5msrepnfx_wpi4uNp+OjcWz3qWTTBLBWb=T0E8i4E3Cffg@mail.gmail.com>
Date:   Tue, 20 Oct 2020 15:52:20 +0200
Message-ID: <87v9f5f1ij.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6851:cd9:265:d9e0:b6c2]
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To AM0PR0402MB3348.eurprd04.prod.outlook.com
 (2603:10a6:208:24::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6851:cd9:265:d9e0:b6c2) by AM0PR04CA0121.eurprd04.prod.outlook.com (2603:10a6:208:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.23 via Frontend Transport; Tue, 20 Oct 2020 13:52:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d9cf955-c563-4f2f-6336-08d874ff5e20
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3345:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3345EF8390CD465A031D5240A81F0@AM0PR0402MB3345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3D0C+i82oCRucTBNlkzb9q5E+bM2InmNPCm4XBRaYAKguKGZ9rSFaqSkWIVj6Qd7Lat9GcBXSHqMAxLc8xhQGfFuk3QGgFQQ3OA1lYCIaqvcSz/ZbTTmDPEqX9C6fKNX5U3dtj3w7bofor+DqOq+pGgUa4RJtDVeimDFbHr7ytnxgrnh+X6FeoMF1uM7BeVNsH/3UnMToETYmPCkBgm6L8lCM6nobmldFAZAz6Uqqe9PU/50tuqwn/kJfltzlhosQhOIHDvJlzZtpoZQh2G2R0PC1TGiZbt/zEBWsDxr1CTlVP7x4rP6GJ3uPnFWLnnoldlTIbVC4fCVO3ueLAcog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3348.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(396003)(376002)(16526019)(36756003)(2616005)(558084003)(8676002)(316002)(8936002)(2906002)(186003)(478600001)(52116002)(6496006)(66476007)(66946007)(86362001)(66556008)(5660300002)(110136005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FzB04n9sN84ylDh6VeNXkCVYK59xqZB/iFVz/jWHmoK29zkaOM4XwtviHWNlCEeneREGJ/bKmeENJx2rKKiaaK++y0/u0oDzYSQyNwXCFCjVEpYvahVS27g38FIASdpnmcWF5q68wsdLYeUFiTpfeQywq/nduhsq66GTJvu/Epqh/Zre0dYH6QiOSuEuswiCj0K0c/fTtKkZF/OCB9d9VatH0vvwLH/P5D77SS0xPlylcPJDYi0aaic56toVSe/0rdRiyTdS22ypdpzGIE8w1LqrjkGioRZ6g2V5X8knVpRUW0Fk6kbuE4mAw9zpusuW3k00Pky8bbAovN5MIPOadUtchZnTtgTbtEWd36BpzNNtwCFKQqRuGj6u6FBMj4eyQW9T41KM06sF3dsFxOFTwfpt80aqC3yKJPkdSrJ2AnLAH32ARQHoZPuVc8FZXPRk0K7jOHAbnGdxD6aPohK5Hi6e7NRUtLGwriV7qdmLn1esvOe29K+hckUU0ccjQZdeVsq1LJyiMPK5seCpgz/RriF1UdZ377d6eQBtG9yp9JGIDuQ6mzW6LLBpsexnzRQbkUldXpWVV7+lWv+x1lkxAT/1Z8Krq1d6nlqdB5Wqu2IbnCIxIOk8vqkOSoZE1/ysAYsPx7M9I4Ys7Ie9sjuzxroHONPD1aA9dKYPkt85KlWy7DBXs3eqcXe6FlLNEydd
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d9cf955-c563-4f2f-6336-08d874ff5e20
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3348.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 13:52:21.8697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Lotzj/CgE5eEfrPYET21ITJ2j+22a2vtAMrQK/TMfCkjjB5e7XlmgrmyyboXsp6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3345
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

