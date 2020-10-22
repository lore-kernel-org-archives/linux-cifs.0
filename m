Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29760C4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 10:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9949C22267
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 10:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KyaqKYYy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896559AbgJVKfe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 06:35:34 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:23361 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896551AbgJVKfd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Oct 2020 06:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603362930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=irPpszwIbVKex4o1GaVfw1Ex5iXYQwqHC80vKSPvuJI=;
        b=KyaqKYYyHrdMzwTRgRs0G093Aen8aInxbQUClLORvFVELypqD+lcab9FRv2lzgv4S97mSI
        4o7MSKlEKNdkz6AQfcYMfY6l95Ij/OdvU4/8v4iOoCRJL4kzShVG3K+dn0QVEtK0170Ifv
        1kUcaMdI/jauMLhSNOOs1LVEa/AkNSo=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2054.outbound.protection.outlook.com [104.47.5.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-8viZV_8mML-khzSQGa8y_g-1;
 Thu, 22 Oct 2020 12:35:28 +0200
X-MC-Unique: 8viZV_8mML-khzSQGa8y_g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=esOA2gTICiUuOOp8IBzAE3b9xUc1uh9StbcElFnb3I+UUkXwTpF5qne5CLshaRU3ErsBNFWyQQ4ynUnWt12WBRD1Rb7zZOeTTbAv8P9ZPozvSi7C3aBykj+LSMU33pgNWoPN43B6/zjRD6dBvJTKUAtwlAO3KBgjoCwWjh0Ykf9qx4007u+bno/x8I9M6r8SkT7QvmQ9Lyfm3lO3uA9RHxfQjkfV016h78Vqgw/QrlBTRBtqYTD+EewTHp/Vy9Eg+UsmDJ1MIvOljGWdoDYlTB0c2o2f1iy7LC6esVCIUGh+CHo0VFcZtJTv98L1DWtbgHiboH6Te+3jhiFSo5CWrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irPpszwIbVKex4o1GaVfw1Ex5iXYQwqHC80vKSPvuJI=;
 b=FdExlh7ytSTAEd+1/w0y2/VRs+Qk324Kn2cOjFYm/GJ8FQ6l9FqwM49oE128T8Hd/6MCVAy85gzeXJbC2gYjUQU/QpHQV5CNC9uki6AYYlTd9uQBynuuE9w10Rugu2VJqQoMlFcX85vuJ68kgF2/o4wET5iEg03BQVisvqa2Erdicp4sB/Ig8muNTYBEffisMJdT4Tc7guzAqLgiHhaJ+s/IUyPfp5JvNOKOyIbKpwLqpoClhS9EJPRkN7fLmPD9zpr5eYPCLMjF+j2kXbqG1BWIfHMF+m4rubFZ81hPb+ASiUDDEkymoKF6xppLjLDxJu+vVjJpowQIJFreu+srtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3358.eurprd04.prod.outlook.com (2603:10a6:803:11::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Thu, 22 Oct
 2020 10:35:27 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::e01c:2732:554a:608e]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::e01c:2732:554a:608e%6]) with mapi id 15.20.3499.018; Thu, 22 Oct 2020
 10:35:27 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH]SMB3] Add support for WSL reparse tags
In-Reply-To: <CAH2r5mvWqz2bMX9ut0bT4ZQH8WQNAc8Cjg3bM1TKeXgzupOZMQ@mail.gmail.com>
References: <CAH2r5mvWqz2bMX9ut0bT4ZQH8WQNAc8Cjg3bM1TKeXgzupOZMQ@mail.gmail.com>
Date:   Thu, 22 Oct 2020 12:35:24 +0200
Message-ID: <873626wntf.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6807:8347:7696:25d3:a22f]
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6807:8347:7696:25d3:a22f) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.7 via Frontend Transport; Thu, 22 Oct 2020 10:35:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5b05db0-f0fc-4cb1-d2f0-08d8767630ca
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3358:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB33586A441BC35F19F5A23B5AA81D0@VI1PR0402MB3358.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G6LtcqqLC1YKRWEyP4dYEsAn7wYguq/86ZLfa1FZVTKT6kvjZiFD2m8smVuxipeDty4SzxDKVT7ombbM1+PFaFCJuLDLE03/DmF62FaDxRvRNif0K/1st4WfI+EOzLOv20nMPH+YxR5UwQNflegZb5623Bhmt5Zt3cyvUSi7ida5kU5g8AHg5uzBr8a1EHmRl5uCdJoFdHhCU33SBaoy19nFuMFuFCVUH2sJe5C0pd42lh1P7xTO6zb1MoyC+KG2usN8w1dPkzJgR5Wk2Nz8VrER4iSYMMs0XKQxtYOHFSOU+cDKKmRGhqQ2Fd49uHpPhhGm+Xsk6Wh2noCirUdSPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(366004)(346002)(39860400002)(6486002)(2906002)(66476007)(66946007)(110136005)(86362001)(316002)(66556008)(2616005)(4744005)(186003)(16526019)(478600001)(8676002)(36756003)(6496006)(52116002)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MUBktffjhDYxnSLm8cxa4adGLCs1J3BmOeqgjQzg7lS2l3uiKvgLviNZsOwwV9qAFWz32iJeZTvvNlLjh1x0Z+jICibteiwYF5vIlItORQnXs11MBWQjH0g8vSrbKxF3jpvogAjIbzYl8Ps5UgyXqa2Fn1pwMrZ9jnDIlSFSDdyET3m9fbscZtpynWaFFVai0phQaKRpNiz2AQRQk8xbI1U9DzL7xtMvigRPF6Vt0RDy0QgBvMmXrBQY7ovIGOQmNoQc9G+Z3R50dm3MJ/bKvQ3zabBqwx8FCjw6d0ZGR9bRNgb23dgmWrTu7UO2zw8QD6N6aMzadI3AfmHzsqXQwN9vu6Mz6kRCDkXj/N2gp+8mc9sNIu9Et+aBDPTTosFIa2FAsO4xt0iupBrcBy6aa8yn8bQk1hloIuAfEpPJpIhyGOqGoHPxWkjWqJONuRsM+g3x6SpczPVmqhWFTw4DbjKbdI4/L2YeqG5NenKYLxeBRLA1MW0rmZgGoMIRVsJ09kwNFe60rC/0n0YnhlDp5ictQKK8f/YBWtyUIUuOXSXhtK1ABwMV1tnw3yDK5CZ3bHLisFX0DYOfgdg8qacTE0U2Fzf0aH9QdXgNFoAtrl1P4hfo8iW2kSJFEp3FBT710/KIV7mkLmhG97wzHRFwb2fYknwRRdLIislOT/mk9FWPqh+fJy12heRtkTsAsT90HhvL6Jij11s4zyVv8gfDmA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b05db0-f0fc-4cb1-d2f0-08d8767630ca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 10:35:27.1041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nLM6QwkB5HCVjJhYgeOjGleCayva15pNOL6f5MJyfgtLAqINBtAnK/9dnR/nS9MA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3358
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> Prior to this patch all of the special files would show up
> as being of type 'file' but with this patch they can be seen
> with the correct file type as can be seen below:

TODO: Still cannot read the symlink target and the device major/minor numbe=
rs.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

