Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D2BC433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A4C6140D
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Apr 2021 17:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbhDURvm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:42 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:38294 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244897AbhDURvl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 21 Apr 2021 13:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619027467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHN48wZ45N3xzAN5FX4N3fEeq6sNIPMbyOGB/F4nQ1M=;
        b=M48SaCAYO3mD62CgWi5ehnbvD9Ep5nJsgsC6AEucsyZJ+ApFr2+lgTb7M5HrpkHDZKqUpI
        M5q2uX7ywpCSA+s0YG9vjDNotD9M0hCjQCn2NhR90qtfuM7LYy44viJtaigAWZhqVusnzG
        8Wy0PsQ1Uz7QqXVyxwzNI9vbin4X2NM=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2104.outbound.protection.outlook.com [104.47.17.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-DL6YfKbSN8GcTZtxxRAwbQ-1; Wed, 21 Apr 2021 19:51:05 +0200
X-MC-Unique: DL6YfKbSN8GcTZtxxRAwbQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOy8OXarIcGBVGT0R9rSsyu9cXW1XHOldN9dgVVpcHMDoWPhZi00JOYvDqGEWcxLNHmb9bD4w6VM1OoBFE57ZS8pQCQrso8/jLM/lmvCFIQlY1OMCdBZlU9kOCWatvDlSzOcRRq4Zckvna5SigU5Rbb5dMBae0uL7bEBlnZYlEsE4sZFLws2lOfLpFBAbUhaKOMSwNcIybGfHyDPlFZ+o9dWGWK37k6NLb88cv0WFotnKrlBhN6+8A3LT//cIoU1/Ff/I+RhwAksBnptmC6qMlyqCQV4g/E5LyZ3EsGjkNW+SROnJW58QbZ1HKarWm8rrbgOvPeTspvBC+FCvM7KiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LHN48wZ45N3xzAN5FX4N3fEeq6sNIPMbyOGB/F4nQ1M=;
 b=cvLKz2EE0Wi+UIt9a2qEEjBqVDBCFKQVS7peH1QkCWsqZoG/KIvP8S1S8VutFc3FEJIx4YpEnorIM0ALjhe2CGM3xsXKFksRnkz5hrTTkdz5v9N9njqaoI5WJOsFTyN9H2/RxT+knyu6riHJiKthIJlqDcLzCrmYBVUpTLFk1ZSBI33rCyyyRtrCGzGbbgeTqDa8Le1dBnxIeA/jXJ1zpieIbmF+DaHcZ6l97+b//rf+gaPMqo/0Kf6IuUAKiy5FfkS3zf43jLUz/ryVf5zCEBbEG5vSjnpXH2gwiGDkouT4aTIuEkjgKfJHNSIUBUumOryxF/KJGSrOctdxW13Gkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2400.eurprd04.prod.outlook.com (2603:10a6:800:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 21 Apr
 2021 17:51:03 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4042.024; Wed, 21 Apr 2021
 17:51:03 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-cifsd-devel@lists.sourceforge.net
Cc:     Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: ksmbd testing progress - buildbot run passed
In-Reply-To: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
References: <CAH2r5mse7yH8VxL4x3bRz1qe2K1p69mo6ApMZzQH_v8ZLpy6kA@mail.gmail.com>
Date:   Wed, 21 Apr 2021 19:51:01 +0200
Message-ID: <875z0fzfui.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:703:7334:11df:fa3b:9968:bb7a]
X-ClientProxiedBy: ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::21) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:703:7334:11df:fa3b:9968:bb7a) by ZRAP278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Wed, 21 Apr 2021 17:51:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd57975d-5e0d-4cb1-ffab-08d904ee0823
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2400:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2400C286EAE465044D8F0F3FA8479@VI1PR0401MB2400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3O9qfVYY7AucmEMV/u2p7k8wz4I1OqhNO4qVTg5CHEVEqo3DqWK2Cwosyb69JtaTYyRlevn+VJAJstWiBkJXV42N2+2kX7GESd2kHBdCIdd0eSVh2EbCAGBPkMmsH8DnH0pDQwsxmYlCHoq406xy+BSzAuaeQSDWMbrHaOOOz26rmWJHFXC5mbZbDPrViGXVHbk706xkiDZTAfbe2nUstDYhfHBNjYklQr30TWjoz1kHpW7v74cSNBn0xZ3rBqqQdkVmZMqSl1BIK6iQo4YD6wSrOh1LxgNEqHRGwMfPz583tWcX6pGWOsev09Edf2tw8wfpKnZSc/+N7/cXwSmUNxqa5+OfwYf6CRchvskyri/2PCPmLI5v6g1UJnKVkZr3tWbsnFp/ETYBulAGE4DeeKP7TkqKXCgQ1i5LMPfM+QMCwfct23KbeIXjJZU6UWJVIdtwi6T1oQUVN0pqfIDxcFHQdyfW/Mep48QkdMJySRjnpkgyUgcWkfFa7Kp7QDmIP3SnMfhIN4Klpm+LUXAtPpUeXZirpPbcxGJ0/4PEIOXaA1vpTriWP85gM7AuGSfzDP+v/vsMIqGhkW5TqmqIRjaoKzMHKCcKE03/MZsMVZXiNUWBubMbmp0LlZGyP09Z2I9ZN5vZj60sScaev3Y4fvwWPwe8F0zrwChI++N82HE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(366004)(136003)(376002)(8936002)(2906002)(8676002)(966005)(16526019)(4326008)(2616005)(186003)(316002)(110136005)(38100700002)(6496006)(52116002)(66946007)(66476007)(86362001)(5660300002)(6486002)(66574015)(36756003)(66556008)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2JYNFJmUXRTN0RDNUJLNm41RFZkSEE1OE9tbysrbGZHL1JhU0o4TUk2NDUz?=
 =?utf-8?B?NTZ3SS91RGcxc0pmRmJ5VEZJckFIOWlZWFI1eVZnMVFsWHBEcTVyZ0xMUVh3?=
 =?utf-8?B?bFVOckhJRFFUdGwraC9jQ1p0MTBXd3VUTXNvT2NSNUk4aXFnRWZKdXZ5aTJa?=
 =?utf-8?B?d3BUMlRGQkV1UXhiTmhJTVpLOWF4NC9SVHMwUWNnN1FQYmlsR01QZExveXpv?=
 =?utf-8?B?UDBFOVcxV2QvWFNwZTN0a1kzU3lad0hZYzJnSWg5d3lJOHc3cHZDZ2dxS2pT?=
 =?utf-8?B?RHBUK1p1WUZMb3ludWxvUUNQaDllY0RPZFNCd1ZjQXQyVm1BT1JGMTBTYlJp?=
 =?utf-8?B?TkhveVVmV1VrZld1WWROSUQ1dFl1T1kyNUl6bUNaK1ZndTRtQldVbzdpZkh6?=
 =?utf-8?B?ZC84TkxNc1ZqQTJUYUxkMlFQZ3dKSzJPN2RzTkc2UCtTTCt3OVFqSGxXZGU0?=
 =?utf-8?B?THpmQ3pnQVBUb1AyRmsrQTR6UmJxTFNYdWVVN2g4RWVjWEhVZkR3alpPT0x0?=
 =?utf-8?B?a1pwYUplVHU0UHVVTEhxWjRVVlQxOFZ5b0c4cWh5SFZaMHcvNnpySkQ2ODZt?=
 =?utf-8?B?YjRuSkhsdXlrMjdBa1dob0xtOG5BK3p6a083MHlad29SaDE1ZWEwVTUxSDY5?=
 =?utf-8?B?UGtLdVdKbHRpbkYzRzU4dWtLc05qYjFyWEYrZFdwcWFyTlVWT2VMWC9UVEFl?=
 =?utf-8?B?RUJzblVCT1BCS3BzTW9weXlGbFdCdGlPdWhqbFVOVGx3MHJVeGxJaDd6K0sx?=
 =?utf-8?B?amF6TFhRd3ZsQ3B5MkxiMVV6SFY4bzQ3ekZPNUYvdTZjQkJWOC9ydGt3b284?=
 =?utf-8?B?Y2tqT2F4SlJiMmlxa3pGajQyUjJxcStlNnprb2lLUlpYZlJHemc5eWc1WjhO?=
 =?utf-8?B?Y1FXekdpdnFmc1hEcys1TkFzVUx5YjlDV1QzL0RTY2Fsd0prcUtQb0kyRm9k?=
 =?utf-8?B?bHZ4cEYvRnlwbVVtMjR1bmxUdk5KeHJLT2l0UmRnZS93dG90VjlJbFF4NGk0?=
 =?utf-8?B?TTBIVmgvQlpLY3hUY2hpdVpPUHRmTDVUQUtqVEtnNXd3WkdRYUtDdVI5cW0v?=
 =?utf-8?B?S2VTN0VEK1pNeC8wbWQ3eDZvM2FEUCtMV0RVTFBHcnFzSzFXOWRFa1JLZW5P?=
 =?utf-8?B?b1M1TndyY1BPOERjdW02TlVZY0FqaXZxQitDOTl6empHYVIwZ2p1ZGtrb0xj?=
 =?utf-8?B?ekNKRXNGeEN0Z0VpTEluVmR5WHdRbjJrZytyajltdnFKUkVUbnBucTNQZk95?=
 =?utf-8?B?S2RlZ0RUdnRkTmlsKzNWRWwvclBvNVE4UGdleG9DSEVjWGt1cm0wdXhUNUdx?=
 =?utf-8?B?UFBGUmt4TUF1aDhVMWRyOVlaclQ1TjhNV2d2c0s2VXB6K2xkNFFkaXJxUDdt?=
 =?utf-8?B?d29IVUYrV1RwNW5lUXB1Q29QUjRrUXRGVGMyQndSeXBzYW5SNFU5WTJ4aVo1?=
 =?utf-8?B?dXh1WDA2U2FKekVwc3RiRlk5NEtGWW5kZ0dQK2FTVU4zWFVoeng3SWYxTHlE?=
 =?utf-8?B?NW9uOW9tbVphcG5sWjJGQVRWQjBXanB6RjZMTWRuM3IySVlzS0k1S2R6MXIw?=
 =?utf-8?B?RXRrcXRpYm00R3RaNWtTK1pNN3JEUjZkbVNTd2QrclRjM2ZtUE5WaTQxQVgx?=
 =?utf-8?B?cUhiL0tHNndvUGZaNHdXZ0kvUnljc2lXZElzWDBOdlJuMmdXeUM2b2ZXMkNy?=
 =?utf-8?B?OFY5QU1YN0pHUXdHOWthdE9BQW11UG05UDNtblRnTmFpeUZUUjRxVWVPYkYy?=
 =?utf-8?B?UUdyQnM0N3BNcDJLdWw4Tk9nRVp5dkhoR1VZeTAyZ2s3UTJIeDBqa0xMVi9z?=
 =?utf-8?B?bFVjejZtRVhPUjgxV01IRUtMNkg0cXBZelNBMVJPbmNyaGhGek83QTFINDRW?=
 =?utf-8?Q?+nphIZc3FvSon?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd57975d-5e0d-4cb1-ffab-08d904ee0823
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 17:51:03.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDG9m11i/bIkYD09iKVpHTpjKNRHt314GOFmQ7dG3gYewEHyUp3qEROPxaSDJsyL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2400
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I have started a small project to test ksmbd by fuzzing.

It's based on an existing project called Fuzzotron and it's not finished
yet. I have taken code from libsmb2 and other places to setup a valid
connection (negprot, sess setup, tcon) before the fuzzing starts. The
code is very messy, not clean at all (all SMB2 logic is in callback.c)

https://github.com/aaptel/fuzzotron

I haven't had time to finish it, TCON creation fails with ACCESS_DENIED,
I haven't figured out why yet :(

Maybe there's a better project to fuzz network servers, I've just used
fuzzotron because the code looked simple enough. The callback.c has all
the required code so it should be relatively easy to move to another
fuzzer.

I think it would be very useful to run this on ksmbd, because:

- the stakes of security issues in that code are very high.
- it would make people trust ksmbd code a lot more if it passes this.

Quick how to if you want to give it a try:
* get radamsa https://gitlab.com/akihe/radamsa and compile it, put it in $P=
ATH
* make a test folder to be used for test input samples (valid SMB2 packets)
- dd if=3D/dev/urandom of=3Dtest/sample1 bs=3D1K count=3D1 (simple invalid =
test)
* make a script to test if server crashed, for example:
- echo 'ping -c1 192.168.2.110' > check.sh
* run
./fuzzotron --radamsa --directory $PWD/test -h 192.168.2.110 -p 445 -P tcp =
-z "$PWD/check.sh" -o output

Unfortunately it fails because of bad TCON creation right now, as I said
earlier... I need to find some time to find the issue.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

