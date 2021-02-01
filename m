Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36E7C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Feb 2021 10:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 743B564E2A
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Feb 2021 10:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhBAKwr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Feb 2021 05:52:47 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:30952 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233039AbhBAKwq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Feb 2021 05:52:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612176697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Shw8rJX7mjuDOREb4EQiHtiZX49ZIEF13zjd5rtpGQE=;
        b=mrrq2sHpQUDDRDBWWg/0GNMyc427uDVZS+44xh2wwvIRmGMVY5L4bjfDWhz/3ZwyemDOXq
        VdQPEQ2HyXZWy1mZIE/P7ULi5BqpkHhQlYZ8QVUUhu/u4UGB2rHwOr0uCUOlLEHg2K8mSv
        eZYsfiO6zl9htRvD0+6PF6P9IIMFJbM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-7BJo_QXGNVyxrkLqMLDSGw-1; Mon, 01 Feb 2021 11:51:36 +0100
X-MC-Unique: 7BJo_QXGNVyxrkLqMLDSGw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aVTC5JMNS1hO9TS+76M1rqrJ/wpldkqakHKnUvWnK5Tw9o92hgUiKPA2Pl0H4nnY0mxo7xaQQPtN/i18YXhUT9+0eqvTYhoB4lsx+F+cmjwXd9vAw4QspfuFlhb1ucIrBYHx/iNgCXYzLVENLtHdYViQY7JejQb/mTW71MM9KYMHQqBeoI/IRqQnszb5TkHe/YHTMp/prPl96tMgs6ZrR1BSbKAvYXU5J8SL0xSOqPTsStwpOTytnaiKgZUNUGPs/lpX5dzmBE0FrEPVtWYSOWoVF8YOWniSJcXfw+tpArA8z1cuNQtTcxChA53IYYr1hoJ+W1z8b1U1XcmQCi2gVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Shw8rJX7mjuDOREb4EQiHtiZX49ZIEF13zjd5rtpGQE=;
 b=iD9TxYJwh116mCrWmYilm3K4ZtzeBzdOZLk+JkS/RdfCKnjXbLO/2w9bjgFxnlPp3bKyiiZa3gwhPtZzSfqyWxQha/JE9DxScBsgg5Ay9++3D6huF3HxTx+OCboOb40LSK82b9gpUKUlTGQdh3WIttkyhv6mA2Hz/BRUHoURn9r06Tq7COCwn6Lbl7B17uY11nEkXwlvV1VYpEqAfqxPDTWF0TkFnbNIwbom0tF/JIJRNPA0z9b519DJodiIDHca0BT66jBrPMGdi6QHtsVikAlsAgUSAPfP1PZo80hqOBpO/j2JGS+UOyOFycH9wp9T/Bc37tCI6jVto3TUdeTJGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2576.eurprd04.prod.outlook.com (2603:10a6:800:56::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 10:51:34 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Mon, 1 Feb 2021
 10:51:34 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        samba-technical <samba-technical@lists.samba.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
In-Reply-To: <CANT5p=rV-KhHtahaF-9YcM5X8jDMLbCx-szwLiZvACRt1oCyow@mail.gmail.com>
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
 <87pn7t4kr9.fsf@suse.com>
 <CANT5p=oeY91u17DPe6WO75Eq_bjzrVC0kmAErrZ=h3S1qh-Wxw@mail.gmail.com>
 <87eeo54q0i.fsf@suse.com>
 <CANT5p=rxp3iQMgxaM_mn3RE3B+zezWr3o8zpkFyWUR27CpeVCA@mail.gmail.com>
 <CANT5p=qMHxq_L5RpXAixzrQztjMr8-P_aO4aPg5uqfPSLNUiTA@mail.gmail.com>
 <874ko7vy0z.fsf@suse.com>
 <CANT5p=o07RqmMkcFoLeUVTeQHhzh5MmFYpfAdv0755iiGbp1ZA@mail.gmail.com>
 <87mu1yc6gw.fsf@suse.com>
 <CANT5p=r0Jix9EuuF8gJzQBGHLp0Y-Oogxzju7_2cJog_jF2fjg@mail.gmail.com>
 <874knolhpw.fsf@suse.com>
 <CANT5p=oTTErJk240GKc+k6Cihqks+9Nnurh=MdrvgC7gqKu1ww@mail.gmail.com>
 <CAKywueTr9GHbzg65s12BRKNB_L881wFLmHcb5boFxGX2AoN40g@mail.gmail.com>
 <CANT5p=rECwTZgskdXUr3VAHWA-PkYHEXX=qwO8PpVZRc0=pOKA@mail.gmail.com>
 <CAKywueTuGuqT8QN-8Jn1QNHT+HPKysLDhdp1gPsm6+Q0tQnbGA@mail.gmail.com>
 <CANT5p=pUVucG6NhzfziAjsjDnimHCWDUiJP46DYoRqjpXHegsA@mail.gmail.com>
 <0b80c61e-3953-e627-9818-8a8c6c50499e@samba.org>
 <CANT5p=rYiY0xE-35swsFKVitZD2yTchRiReyA0wVvY+mU_qKEw@mail.gmail.com>
 <CANT5p=rV-KhHtahaF-9YcM5X8jDMLbCx-szwLiZvACRt1oCyow@mail.gmail.com>
Date:   Mon, 01 Feb 2021 11:51:32 +0100
Message-ID: <871re09i2z.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f12:fb7a:e8aa:e796:34d1]
X-ClientProxiedBy: GV0P278CA0033.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:28::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f12:fb7a:e8aa:e796:34d1) by GV0P278CA0033.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:28::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 10:51:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49dbf935-8c71-4bfc-278f-08d8c69f5762
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2576:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB257697B82325F52E0373BD09A8B69@VI1PR0401MB2576.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTGZd2+e4AvH3bcg5fF54lEB85JQvYigYfQdcZazjdAS4qFfeJYubqZQ8rrveGhPZ6B89Lp+7QWEE/CANJN5xM92ZKP5p4WaCY2T3OVLTJnbnbrOWizi5EMpXB6xPXsge06LCv7D1MVpxDIfOC+AE+Mo6ObuaMrhlkDufFu8YL2QdpbpOTNg0BZ17lnY3WFKYC96vUTHOSOec5tjebe6sdTDERBjEbrEsFUj7MQLgbPi90jpTjP1sxlbqHqCq+tfe7+/ovsoB8icc4EJtvdNFUPlJ28nco6uVT38MY353sJO2GX+fBHV0tj7x2IqtxbBsJF8rN1G0RJipdhew891uPAGIlgiwy/XaZm0V32XcE2wcJrzIpPUBCZchxRxkFIWIZJ6baVxL6fJpX1a2Z8qpoY2pH7Eri9ZNObnVsbtHKNxu6o6rFx/1SWJo2bXbjiIibMFF78OY1+J2qywTTJLEq1GH2E2QqOhdE1dtSCcF4oFCJ7i3SkITZVgHEwFln2BF211CMqoasXQSLZbtnt7BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(396003)(376002)(366004)(316002)(36756003)(66574015)(6486002)(54906003)(110136005)(83380400001)(6496006)(52116002)(478600001)(4326008)(16526019)(5660300002)(86362001)(2906002)(2616005)(8936002)(186003)(66476007)(8676002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R0xWczVQQW9sbTNnZDd0bjl5UDd4TTRrWm4xNDNabE1qTWJ5Z3lJRWVHNXFj?=
 =?utf-8?B?YW13R1FWUFRKTXBJQ2IzOVdnTU9YbjZSU2lzNkVXN1h6K3VLMzJoNTArLzJj?=
 =?utf-8?B?dU5uZURuMFlOanBzREhCeCtGaTBNKzc5Mjgyd2E2ZlkxYnlhTGF1amdwRXQz?=
 =?utf-8?B?RGhkdFFZRnNFM3FhblFFcFBET2ZFRTlBMkhsYWR3aEtCOGtCblhuR2JBSUor?=
 =?utf-8?B?a1ZiSHQ0dERwOEF6bS9TTVVkcytQNWFUSldUb05kOE54VHNNbWhBaTRRNjhC?=
 =?utf-8?B?bkVKWEFWMnRYZm1zWVdrdEN2Y0QzUkhpbWoyeWdWNjdtY05nSGwzTWRuQnBK?=
 =?utf-8?B?UldObC83VWVzTnpMZm9vK29YbFgzbmFpck5CK3lQRmVjcjNCb2l4NEd4dVE0?=
 =?utf-8?B?ZE5mRUNTcVlINjhlZVJQOTBWZFcvSkJnRklkSUE1SGVTendIbzJkK1Vick1q?=
 =?utf-8?B?cXVabjEyVkw3Q3doTGV6dC9KL1JKNUVwcTEwaW12RWx5ZVkzdWFVa2YzT01s?=
 =?utf-8?B?M0xES0VGVkgxUGpZRWpmZEFGWHVMcVlnOEJUZm1yM3hTUmJuQ21HRmpDTTla?=
 =?utf-8?B?QVNMQmhyRmJPQWc4NjExbU83V3h2YVRwWWRqUkFzRFY2ZVJYcjVVc0s0NEEy?=
 =?utf-8?B?L2pIZzg0U25tTHhMNFJyWURtNU83V1FlZndaaklyQWZNVGpoSVEybEw2aC95?=
 =?utf-8?B?dXhjWk5KTHZweWJ6R0plWjRPdzlMeE1vRllicnRoaTNZaEJ1S1BjZGpUaE5C?=
 =?utf-8?B?RXBwUk1mSkg3alpyMG1HQTNCcHRkUlorZ3RmTlpRY0xQTnhaNDd3bDBENWxl?=
 =?utf-8?B?T0FudGsxc2trUHNDK2RpUmxDdUNndnV1alVyU2d0V0FvbmNLc2c4UUFoSkwv?=
 =?utf-8?B?c0lmZ3NUeEw3OWwyOU84OHVLcnQ3b1lXYW5WbVJFT2k4UVhlTENPdzlmaXpi?=
 =?utf-8?B?bkcrdjMrTGVrcGNsUEMydXpPMzk4TnM0Wm81ampGczRmUlB4R3pwaXhhY252?=
 =?utf-8?B?Y2R1N1J5aURoY3lLbjRraFNGaTZraStuSXJzNEJsclprOGFhd2pmb29xY0JF?=
 =?utf-8?B?L0QvWkVzV1Z3Y0JqMFZ0VzhvUWI3ZkRjUFdOUFI4Z3VsdnlZUkNvYWJyRUVk?=
 =?utf-8?B?MjdzWFlPYnJnLzArUEhqYkZIaGp3V0JsNnBlaUlGekxaYzYzeDlsNVZkaGhk?=
 =?utf-8?B?VzJXWVdoZjVYck55VkNwNE56UU5ZVkZlVDI0U3l6RzFEeFM2UHRQS3dEMW1M?=
 =?utf-8?B?RjllWURBK0ROZTVSRjE4MSs5K0NYUVNFQnBSWVBMdDI2dno5RHdKcWhpWFBP?=
 =?utf-8?B?M29iK1JvNVh6MjNrV0lSUmhOYVd1TVBtVFZSeW9aZFRZaFFzK0ovUytWWVZE?=
 =?utf-8?B?Q3NiejlNcGs2blJyOFBodElmNmpCTm1NNUN0M1BMdzEvTjRyMi9RQnFOSG1k?=
 =?utf-8?B?enQrUFh2L1NNcWpBcjIwS2tHajFYOG80RUVTYVJWY0FyN29yd2txdU9nb3hI?=
 =?utf-8?Q?Of842rLsI+sgH8mZQBd/+nEPRtV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49dbf935-8c71-4bfc-278f-08d8c69f5762
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 10:51:34.3294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNfdyquP3tqHpZjKChp+kaKicatmpprZL2eIaWp+WKxHJ9k4cyp6gJruJiFILQ7N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2576
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> It just occurred to me that integrating with mount.cifs will not
> suffice for a multiuser scenario.
> It sounds like we need to modify cifscreds command to have a switch
> for cifscreds command; if used in krb5 context, instead of dealing
> with kernel keyring, we authenticate with PAM (for add) and call PAM
> logoff (for clear).
> If users are then missing krb5 tickets (logged in to ssh using private
> keys), they can call cifscreds to get the tickets.
>
> @Pavel Shilovsky @Aur=C3=A9lien Aptel Please let me know what you think
> about this approach.
> If you agree, I'll start working on the patch.

Hm what happens where there are multiple mounts with different auth type
on the same machine. e.g.

//host/share1 as userA in /mnt/1 via ntlmssp
//host/share2 as userA in /mnt/2 via krb

cifscreds should change both no?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

