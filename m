Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB270C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 14:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7727164DFF
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 14:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbhBDOsI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 09:48:08 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:31227 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236874AbhBDOqU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 09:46:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612449910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sjdxoyu3M6xWtoSoqB7mU4E6G6ZAZkvefDaKw2FBAgo=;
        b=IgF9TNFeAgpt+vJ8bqJFIepkelmCdybRxZHTAJNNGS1HUMn1fRYNMsRvXYcmZiyQvd+c1v
        8Ff8RMJ2ZejSp7tdO/DKjnjuGG4OKvhv0ENK1ebtJDAjMLOCD+sc2C44QM7VsS+zf/HSg+
        DESdxAw3LAU5KVg5jrSDRdiZX27LoX0=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-6-eSk-WsfUNyC2qp-ipTAOxg-1;
 Thu, 04 Feb 2021 15:45:09 +0100
X-MC-Unique: eSk-WsfUNyC2qp-ipTAOxg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIDJ2CYy4bxkFz4M/d2/nQ0duGqG2yiJkTsXV7zpp2tQJ1Ry1VrdfA6PbyQu1CgdQOMm7nzJqu1RWrhlVJHZHRrZLMuZ8c+1FnJLl1ES1NFiA8DgGIHnO22phr2baffH2lJnMSmXPppMGoPOU35ADQYL2bhjeSWRymaQUe8s+8GjJpuvJNQ6r0jyc7kBAECDSOy2aXxJhIPmKzuUaQAoiv7irNL5WBRWb/98KqYuB3eTUKUzwl9o3luscNKW19ke7Oq79jZ0hNvOSKH3PyKuPFAGzFR/Y9IuYf/s0X77/nNlRtwfQbMOX4B/kFeVYaQ2Iq94cCNBjHKvIOv0VxwYnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sjdxoyu3M6xWtoSoqB7mU4E6G6ZAZkvefDaKw2FBAgo=;
 b=NB4vO4jr34rD+RNWrA7YvAHSKreQ8hoHFrDs1GlQi0KUHfXTRHrP4LOQh0NaDf1ysoJj1wtupetK3+NtMw9RhU1xqOxO1PRVNn0Ex2lmPu2GbjEMJPz9O/9RhVyhSo0ls5j56VPks2lKfe+aZnrJbYojidf1zAJpotP2bZK5lD39mKwBVAI15oZFB25SgIeEe5Hlby7dnaayWGnnfBULREDcp/cJq+cr1V3mcrIfdvu7y7X0Xf6UzPTwRairxP11l0XFL6ujI7oH8ZG9a92KJHJG+sIZ2wk2INDRqkSMCayiTzvErEofH/0/YBr5CZKerATCoUohBlRiUAl5zhkyNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2400.eurprd04.prod.outlook.com (2603:10a6:800:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 14:45:08 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Thu, 4 Feb 2021
 14:45:08 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by
 conn_id.
In-Reply-To: <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com>
 <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
Date:   Thu, 04 Feb 2021 15:45:07 +0100
Message-ID: <87a6sjopsc.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b05:ee03:72d7:dd87:90d5]
X-ClientProxiedBy: ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::7) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b05:ee03:72d7:dd87:90d5) by ZR0P278CA0020.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Thu, 4 Feb 2021 14:45:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1f547ce-4c6d-4da9-e1f5-08d8c91b7795
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2400:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2400211F6E4FE4199C65817CA8B39@VI1PR0401MB2400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3GGaPC2jMGlj44oF3DXlHJG8sNGKEW0KaVCVxJl0e3uqU27feG0JCiSh7o/r+xDBxIrvA6bqevJgQOGp0uAYJn3IA+j2ub0pebkFdavWZ0t5Fqsz2fbWhBADknagxcGpwAEYRmotJb4ZrykA7eHmHf4nNECM9HZLjbdd5U06aa9HAVkZkRSqYiSaNAvpKr5zzQryhV69k3eXInery0LEu5SsrdNrJNoAWmsVsDbziPftfu7GPSxMkCr5jI23So6D3eJAofD7Zh9JfYYNbqyKH1kmfInVKNFB3zulWYgAsa86eZwqjXYkZGWpNYlM+2ECMa1kWLcvb/SZpQhC6VeG+iwgNKsRfR7T+J3NVyjyIuEW4yBjW1JfHv8UBHm2hagjMHHLrCCzHGd3Wrr/0nJ9nAiYiPfev7U4eNMMlisH7s4wHZ5zXtfI7AHGfq0PJW3h2f4U8c8rAAS0evSJpeUzm4DcXc+VwiJ8knmdSONh//aC8yaNeDiJlmHKlYIB7BmpDLFKqCDy9GmLAbIQ3e3zgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(39860400002)(346002)(366004)(6496006)(52116002)(478600001)(4744005)(2906002)(66946007)(8676002)(54906003)(66556008)(36756003)(316002)(186003)(4326008)(2616005)(16526019)(6486002)(5660300002)(86362001)(8936002)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RFhwSjZDWDVUbEpBNm1JM002Y0R6ZUxQNGc1aUhFcEZzQXp5d1BQQTNsMHpF?=
 =?utf-8?B?YmRmMEcrb0ZJVHN4QVdlN1NKem9KVDQ1UlcrV0w2QTlDWStHd3MyK2xpNThZ?=
 =?utf-8?B?MXJDTXFVc1NZQlRKS3hnaVdnK1prTWpNQTA2b0xnSVY1NGJ5RGZnWGFkanF4?=
 =?utf-8?B?eDVxcnB6Ujhjd2dxME0wRWRUaXhCemVMcDJWVFFQTDhna2hLbHhmL05jT3B2?=
 =?utf-8?B?MXNRSkoySC9Jcm5pMC9ZMUNBdm91SGV1dWhHMmgxeFNFbGUyQStVZzM2RlZE?=
 =?utf-8?B?aEhkZ0h6Ylh0TWRkRVlZNWJQK3d5aE5aR3dwVjBUTTZibm5qcUlWNlNsaC9K?=
 =?utf-8?B?SGgyR2pvWkVzWnkrNzRSWVhURVBnT05KNGoyVTF3eFBYUmFGcjVvSGRGQktp?=
 =?utf-8?B?Ulo0Q0czeWwrZmQ0ZDhsaXkxeHhBcnJFQ0lKTjNrc25XZWw5c0UrT3FTbUFJ?=
 =?utf-8?B?ZlhhT25KZDBYaGFicDl2clZPWXFvOWdlSVVrbkNvWG9qMVFOOTUvNENFQjRO?=
 =?utf-8?B?QjhwbzZZOVBjaTNucjk0TFZYUWU1WnRra3QzMm8vaW1pWFZheW45QVVRVVpR?=
 =?utf-8?B?WVNLa0FoUFVIcWkvTXlRUlhkWGV5bnhLdmFVU0pReTUzempNL3pHcXowd3NC?=
 =?utf-8?B?SEhzL2FBRHpkOGxKTS9NVXNmR1ZhWFZoeVBvV1p0TVZsS3cvYmJxZVJycmNz?=
 =?utf-8?B?MHFJMTBNZ1BsYzFseDZibEtvTkZhRUc3SU00aDY2SUU2dTd2SkZxWCtZNzUw?=
 =?utf-8?B?Nld4OVBQd0hqakViNWdyTkd6WVJ0QnB4Q2lVbGhQbU5qeXQrVjZmdGViY2J6?=
 =?utf-8?B?TU1aQ1JWNWU2TTRNR1FBM0NCNlNUa3pZMC9oSzA0V09XeUYwWDVHZ0xLYUJW?=
 =?utf-8?B?TFBvTnBnY1g0R1JEdDg2dlEwdXVSRVNxMEtiS0puODRMRS9DRmdQYWdWdWZX?=
 =?utf-8?B?SnNEbHdKMWF4ckZqWlVFdXp5NjdsbnEyU0hQYy85Q2RrNTVUb0JjT05obDB2?=
 =?utf-8?B?dHBQL09IL051bEtCenRMajg5U2U5ZkYxcVNPdFpQVk9sbHpLWFdEQS9CbzdG?=
 =?utf-8?B?eXo3UHMvNFBqUysvdVBWZ3RQWGsxeHYyQXVrR3M0REZFRENrWTVjQzVSRjJJ?=
 =?utf-8?B?LzF1NVpOaHRZVzZuejZIMklLaTJnMWFSN01oL2VaK2toVHJTdVVxVEw1aE1h?=
 =?utf-8?B?RGJUV280NXVYam9RK1ZHQ0U2MjU0TTk5NXU5ODBJUnBpTWVvc3BMNTlxT1Rr?=
 =?utf-8?B?ZVRCQWFoRFhsTUNudGJCK2ptdmorSzUvQTRTSW1xaStjbllhcDJ5ak9NVlpx?=
 =?utf-8?B?dS9nVmRGc3hDUnF2Vnp1VmQwZ0ZiUHBCWlhSVE92WE85R3hGL2p0SEc3V1B3?=
 =?utf-8?B?VWtRcUplSVFDaXNDZ29xTzBOc0ZFbFpZNjJ0bHhmZU90d3V3d3pXK2JDa281?=
 =?utf-8?B?NHNjQUVFMkVRaEtpR21MaE1UMHhvMkg1YXNhakZmcWtpczI0N2hIZGMxcVk5?=
 =?utf-8?Q?omEhEPElgYfOPQbATvqkhznZWOj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1f547ce-4c6d-4da9-e1f5-08d8c91b7795
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 14:45:08.2225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJfBt7y5s6+1bWHpUXELHiYBcs62Vkvuj97Qr0eNWOd95E/27O82eK2mxEjaLWfc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2400
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Code looks ok.

There are little style issues reported by checkpatch.pl: Trailing
whitespaces and comma+space stuff; ignore the columns ones.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

