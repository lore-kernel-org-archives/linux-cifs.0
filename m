Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C60AC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 15:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CC9D23B28
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 15:23:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbhANPWv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jan 2021 10:22:51 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:27311 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbhANPWv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Jan 2021 10:22:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610637703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PYuZ+1ut4ESAJWyY6kGKFjbAK2+udu/epEYYW3fS1QQ=;
        b=mywky8u3beEx+3hoKDmQYVxdMQgoVNoGsDvKpMD5wsKaG6HbTUclFYYN8WwlxnqA53Mvt2
        am2+GkBONemxxGStQgV2cEHuCjsIZQjbEynU8UVhycw/lJEbz+7Q5SBw+eK0D6WMqjlHpO
        awC4cPfBJJsdLlzUNV2ODA/CHdg7K+o=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-ixVmIiz3P1CCr8C5Rmir_Q-1; Thu, 14 Jan 2021 16:21:42 +0100
X-MC-Unique: ixVmIiz3P1CCr8C5Rmir_Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ejZCwhApVV5fDt2KpxSW5qV+qjddRB89pQ8M1zbdJVWAQrrc1Gr3iEJBfRNpetVnPhkWa8K98Q7Hl8RTZWQHKdbX82UxEHPJmC+utkYZonCsNqzy7UeXQvzNqHaEa25JPLzJxKPU5LQ7j2oG2neYc3GXyLjEcLzxgk97tGhPqg1A0h1F1pnlynYmeRqFnzmc3p7OCxSox0AE8OFeho9parRONZUWVTvGGnD3bNv81tuCxyaA1eJ+Wag3Byf4sZNqsBPIDORmexOVE3wwVcgKqstLxxOiq8vVUY+ESrnfJjZpCfNrrzU/EGRmxL1led9cz7aEyZ2gsmLncl983X13Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PYuZ+1ut4ESAJWyY6kGKFjbAK2+udu/epEYYW3fS1QQ=;
 b=MUooKpdyoo1ut9to7tDd/+MSTHiNw3/4BOBs8V44Rj63XhzOboo5rwz9kZtGxWSBcl0hfAJ/ZXKksCDqBdIbr/ZR3p7sC0xQ6ZSiHzIqRPsAVAqD7xOrrfMgThJgRhLSdTuEdaikHFlHr6iMVkRA2kHFQ0IMBC+88aj4pWjiYKS/kf/3q5REvOh64MNpm/zqy1idxitAQUALK/vBy57dVxHEcJ5cYQ8ALPD0Kp/O/05v123DporB9fbrzczebH3sxOw7eMpyNBZMRpw0yd0FWxsaUd/t/tA+BwFoOA77mVFjM1hdr+FbHblErUAIzw6XOXY5j1+gF3u1WoiWau7ZFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB3279.eurprd04.prod.outlook.com (2603:10a6:802:3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Thu, 14 Jan
 2021 15:21:41 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%3]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 15:21:41 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Duncan Findlay <duncf@duncf.ca>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [bug report] Inconsistent state with CIFS mount after
 interrupted process in Linux 5.10
In-Reply-To: <CAKywueT0U3+t3RdC452ZiqVpg1n1KFi_HK=83yGmS__2gALpJg@mail.gmail.com>
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
 <87ft35kojo.fsf@suse.com>
 <CAKywueQ9jmyTaKqR2x0nL-Q8A=-V1fP_1L2n=b+OdUzVhV083Q@mail.gmail.com>
 <87h7nk6art.fsf@cjr.nz>
 <CAH2r5msvYs4nLbje4vP+XNF_7SR=b5QehQ=t1WT4o=Ki6imPxg@mail.gmail.com>
 <CAKywueT0U3+t3RdC452ZiqVpg1n1KFi_HK=83yGmS__2gALpJg@mail.gmail.com>
Date:   Thu, 14 Jan 2021 16:21:38 +0100
Message-ID: <87a6tblf25.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f18:fb1:853c:d58f:3748]
X-ClientProxiedBy: ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::18) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f18:fb1:853c:d58f:3748) by ZR0P278CA0121.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 15:21:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba5a6317-3d90-42e0-49d7-08d8b8a01809
X-MS-TrafficTypeDiagnostic: VI1PR04MB3279:
X-Microsoft-Antispam-PRVS: <VI1PR04MB327978743BEF18CDBAF7FD03A8A80@VI1PR04MB3279.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4nql71TtAqaWeS62+Kex2LGIwmJdmhKGgIJKsnucQ9bz7glDDaZIH/f8YKAJl8k/D/S7Rg665I+D6mhgBs3UgmYSW5B0jcTZujdzSMB4l+Q3qv1yZRG+5ID2MrNEd3wUOIb/toeEEPeK3Dx+q7TVIOLdbHxgJzRs+PRVhKUfnyqLuJZFfSklyie6WqJ5HapWNgtrxQpcVOpYPLDFbIsOEuJ5pHmLzN4e/mqfOBa1wfFZ3JHcjquTNyIqQQCYS3FNxqbKsHdCplKeIKqY2Snx/yQUPQEG/F/UTdxXD+EiiP3C2KoMpIJ+xa0GzPniyveD6/BGhq61ASjCRknyKkJ1hPsiNeVS99F9aPskNnbRAi3ty6TfZFDTR0TqVPdYR4W9sIP7imDYI/Qzr6DgrRvgFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39850400004)(136003)(366004)(16526019)(186003)(6496006)(110136005)(316002)(52116002)(2616005)(36756003)(6486002)(8676002)(4326008)(478600001)(86362001)(66476007)(4744005)(66946007)(66556008)(8936002)(54906003)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3dlNHovUlNML0M2cHRnc2VyT1YvMkZNUlkvU1RXRzZEWE5CdytYWHl4MCtk?=
 =?utf-8?B?ZGdVNnZsei84clNibDVoMTZBZFlQZkVMUXBJZzNvTG5zd2wxVCtjQlQ0K3Qw?=
 =?utf-8?B?VGJJVmIvL3BWUHlCNU1oMGZtUTYxTjVhR2tVdGhIY2w0TmZNVTh2dnhtamR1?=
 =?utf-8?B?UnBKWUo3dVhtMmRmK092Y2psQ3FVNGhiTHN6eVNQMnJsa0UrL2R1MXpwaUZx?=
 =?utf-8?B?dXNpV1R1UmlKMmlXLzRid3RqbUJRVVR3aVhianJZNnMwamFKZFVLMk93WS8w?=
 =?utf-8?B?TVpnMFc1dHMzMjViRTlTUzVrM1FDQXFBTzJPcmR3SG44M1lHREd2cjJHZDRp?=
 =?utf-8?B?czZVWEg3aU04TWw4U05vaGdNYkNzRkMycjNyMGZUY2pqc3o1OWNNTUJ1Z1RF?=
 =?utf-8?B?NEpNRWRZZEtrdk1VVnRQY0U3T0JFb3RMUTk1bytnTjVhTVNZWjdUUFBGZVBV?=
 =?utf-8?B?YUl3WUJ2eDhsY2hlaTAxQi9OdTFjSnRJOTVIa3JPc3FDZWlqb2V0cHdxU0Qy?=
 =?utf-8?B?ZFJDUnhGbGZsT0c3Qkp0dlp6UGZuWGRYWVpZeW1mR0E0cGtCT3hQRGhVL3RI?=
 =?utf-8?B?a1BPNVFzNmxxY2ZYYnNRRFpqKzRQc0I1TG0rOEV6TzRnUklvNmZuVnBPL1Ja?=
 =?utf-8?B?UDQxYjhGTDRUZWVJc3RrazZ5UTV3RzNxVnQwaGVGY3Z0Vk0yOGVRT251aEtL?=
 =?utf-8?B?aDVsWVk0N01BT1hLcUllTTBqUUJEL2YzYnZCeFZ5eWlXTzEvYVFHbW9CQzdV?=
 =?utf-8?B?RE1xMXJ3Um12STBKRWdWb1VvUHdFckV3bVpGL3N1QTBueE4xdHFiK0pycWpU?=
 =?utf-8?B?ZWc1blNEM2hxYzJLUndQVEk5VnlaeEtIZWplQkxyTGlXenRYQmZvQlJ1Znh2?=
 =?utf-8?B?T21CYXFsRnVZbTFxRGpJRjZtTGF1R2lCVzNlK0pMV2tHdGRNY2lSSG5Ra0V6?=
 =?utf-8?B?QlRWQjd2ZCs1Q0FndWdjUmh1WTFiOVlFSklNT2UzbG1VUFN3K1M0d2tRb0l0?=
 =?utf-8?B?ZGh3V0w1K3BSVTcxM1Z6enhEakg0cVZGQStMMjYvZTZtZ2ZEcFJMK1h5eTVj?=
 =?utf-8?B?SjkyWGluZG5PSHdGdUF4R3d4SUllNG9oQzJud2dCQlNFVlFXN2VxT3FpRFFK?=
 =?utf-8?B?TzhSQlQ5dUdjb2lidHptdEdLVTdqMnh5Yks3UDBQRVdERVpMeWNuVy9nY1ZB?=
 =?utf-8?B?YzhCL1JoazQ3eGwwbGVvdWEraTc2SW9ycGU2VXNUUmRVbnRoODIzUVh2WUVG?=
 =?utf-8?B?RXUxMHRsVTZuRDlkL1I1V0R4NHlBckZsd0tURitUdDBxUk1uQzBhSTE5TkVF?=
 =?utf-8?B?cndiNE42clNwQTVzN29IeXhBajE0VWJFSnNkQ3RBb1JneTU3bU9rMFVJVGVz?=
 =?utf-8?Q?eGoBJkznlLoBUaAVBu99HNczurSVC1Nk=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 15:21:40.9755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: ba5a6317-3d90-42e0-49d7-08d8b8a01809
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsHrLKbmBbSUZEtA/bifWTiaScYriExBzdIuQtmuTYKvn5tPn0wR538ot3vJz3nU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3279
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Paulo and Pavel for the quick fix and review.

I've added an xfstest test for it on the buildbot. It's essentially
doing this:

    set -e
    rm -f x
    sleep 5 > x &
    pid=3D$!
    sleep 1
    kill $pid
    wait $pid &> /dev/null || true
    timeout 2 stat x > /dev/null
    timeout 2 rm  x

this fails without the fix

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

