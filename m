Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD59C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 13:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B59B61157
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 13:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbhEGNYQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 May 2021 09:24:16 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:49200 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235501AbhEGNYH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 May 2021 09:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620393786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DLTciW02t2vpjq+6V2ejCl20pXi99VXXgUHl9+QGqNE=;
        b=CJygR5EcyKc6a9mq999KOh9GJPgzojqp3F6Zijnj4mQm9gjO4K1ut0CodbvE3bXjhO37nG
        m7WpPgsjy1JfStudFoQWyXMxiF6fXQbC0s+u9z1SMIIGMiWy/RuoTRsTVJ5BOOYGO7egz2
        m0tpuEhAJuTLlL770H+1zDAJd/QUE3Q=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2053.outbound.protection.outlook.com [104.47.8.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-V3oD7hQTP-mKhVW8-G_p6A-1; Fri, 07 May 2021 15:23:05 +0200
X-MC-Unique: V3oD7hQTP-mKhVW8-G_p6A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlG1FnKD1+FwmyhEtEMs7ezLK4mSQhAhSVRfr6z9YWzdPkHWZXYxTjSGkinY1+d4is2KK0KYsrsdsXinUSAuUvoCL/QgN6yuO5m8z9W6gi9oVYQa3OKZQinyvQTI3kP7kaa1uRFG6isC97nsLR3Cd4Kb3JzfX7omZlntRLEhwNS1v6QgGjm0yli11a/6tgEUOuwbATO8xurIcS9QsyUFOoQ6Y8so+8s8SRO00JtueNBQ/SK1UlGLuH6eLfT6Np55BC12zDv9yrHmpDk1bUNPl9FiJWf2DRs7/Y2IqfOZRORUB2ADQEhNTNyCs3VUQWlDd/gdqe4lmosQqJ+S5KyrAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLTciW02t2vpjq+6V2ejCl20pXi99VXXgUHl9+QGqNE=;
 b=ia320pbwzPIzNfa+Kg38bYs9oMCPHrIRb8bmDn6IeHiFpRlAHNVNXoVip23h0YdAiqTg3xnW35GrDsRT+oAB59QUChRaEEXAhhKJzsqXjqkMMwenf311RIKhIUmbEwRsk/6pUFiEpA2OUELHVo33/nA9VR9xJKVOQaOX5ffwjFiPBXguBq1l9rWPnSJyPN055EbKeYpl1uciM++BkvHDoz0B5swpdn0/8nzVpfVQUJ7n0Aco7XDYPLrR/2ZCz1Qyzd7sLLDIydjwX6QhX23Jv2tLRJ0YnDRV/qVGqk0+8o813bBSpAKWl++bzgXaxFm6qK+4sWOGNA3EGrg9qYYulw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: samba.org; dkim=none (message not signed)
 header.d=none;samba.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2399.eurprd04.prod.outlook.com (2603:10a6:800:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Fri, 7 May
 2021 13:23:03 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.028; Fri, 7 May 2021
 13:23:03 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve
 debugging of encrypted shares
In-Reply-To: <2e20d5e9-148b-dbb2-9fda-50521be46fa5@samba.org>
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org> <87y2cqu9as.fsf@suse.com>
 <2e20d5e9-148b-dbb2-9fda-50521be46fa5@samba.org>
Date:   Fri, 07 May 2021 15:23:01 +0200
Message-ID: <87sg2yu18q.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a615:1bdd:6a41:a7f2:21f0]
X-ClientProxiedBy: ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::24) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a615:1bdd:6a41:a7f2:21f0) by ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 13:23:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8b4d7a7-1685-4dce-f78b-08d9115b3df4
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2399:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2399A884FA5D3A3487C16466A8579@VI1PR0401MB2399.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNQwEZ6NiiW7yu3kmHx06XPv2CwOpLj8fvME5nR2rsNt3MJUh/WyZ6gyT8gM18qx/eeR7ktS7WOC/enPmwzgfgR6XoPF9+GTBylb3z42v+uPNEBzwQRc9dAWTVKGam51h52AZo1ABzMGRoDKNAEFbV/CoxRMSHkpA3EzzT/j6hyvjWCD+PXkjtoXbZvGkmXWeIz8MiJwqSlt+ZjpvqiAB11QpOtBwL4IQoxWoX5eKknUV9UR79TgPXDIVr0kqJ9esgYXVebelvGlVyKnaMl0gPsYKoiIFF+X+nAA2JYNexvsfqR0uJtbMolr5j1m9DUQKhU/13hAg6HqqqDOYlniqGSQDcbE65O0XFDzaPmuFvf8/jjEF5bAYpvre7llPymguQQzk4hsPJoSIalzT1zKEdKAXErnai81IKjxhvVAy5SSjeINmQ2FQDG22aNiAmYFVms5BWGgVCr+1/XvifpgioXaCd+tNpkPgQyAidfWSFvkgWuhBmC0QwDkbGq9Hdg5aFHWXpQ/Qyox1c316mTPv95WN9Nk3EY6iueC7h41xWOHRNV9a3ZPnUqymnAVs5uasVaO+0/nEjfEXll74HlfHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39850400004)(396003)(136003)(66574015)(478600001)(316002)(52116002)(66476007)(186003)(5660300002)(6496006)(110136005)(86362001)(16526019)(66946007)(66556008)(83380400001)(38100700002)(36756003)(4326008)(2906002)(6486002)(8676002)(8936002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUNUUlh5OXhLM0FUSldma0pxUjNjdTJVUTBqeHZzZEYxeTdLZ3dZNDI0emQ2?=
 =?utf-8?B?aXhCMmtISERUU2FtZFhHbUJwSVN2V2lvY0tPTlV1QndSR1kxdlc3RURhWjRF?=
 =?utf-8?B?L2V1QUV4WmRHUlpZdE04NVdFY1N4cDJjcDR5bXA0SEl2cHRiaDBQUXNJcm1h?=
 =?utf-8?B?K2NCMU5SS3pKelFKSXJ0bUVDYmhCMnNobzl5ZVR4akxZZnQybXljM0dXUDha?=
 =?utf-8?B?V0xKRFZ6OW1VZnhpajMydTVndzR4VnZ2TmI2enZpSEZhRThFekx1TWk2YlJq?=
 =?utf-8?B?YWNjTWZqbml4TEhWYm4rRVRSeXEzejJmMHBlVVEwSk16cFNYTlQ4MnREZ015?=
 =?utf-8?B?bkdRUTNzVWdDVk5DUWtselhKUWIyLzVHWmd2OHQ0QXBpZTVEQnFjVDhNZHVs?=
 =?utf-8?B?V0lpWTNxTVVKTTB6dGE2enE5RHhRQ3VCbDNJWm5CdTR0dTFBV2tZMXdLTTVq?=
 =?utf-8?B?QThqWFRpb21wOWFYNWw2cnlmMEZOWkVPY0o0YkRSUnpiZ2Rnc05qbDMwZnYv?=
 =?utf-8?B?MHFpbGVpY2F4MnhRRHk0WWZLNDYvUnEyUTFIYndDV0crRVFPa2MvSGNyYWhl?=
 =?utf-8?B?alFJdDRlUVNzZjRUYTRvK0ZCVGtsd0d1bTE1QjEzMCtFamwyUEFjRlRTRmxn?=
 =?utf-8?B?VDNqNW9pdHlYMzhUcFp1NVFNd29lRVZkNGIwLzlTMnkrOG0wWXBraEZnWTJD?=
 =?utf-8?B?R0N2dWpOV3Fja0lpM2dNMDRzRnZFdzFYYi9BdzM3OFRTbVR1NDVqVTA4LzB6?=
 =?utf-8?B?cDJFVXlOVVNNS2kvOUx3aXpWM29lOU53dGZQcFZFenp2RDRNUjhkOGVObUFC?=
 =?utf-8?B?Wk56RFVEdlVtd0o2S1BLdmw2dHQ5a041cGFNVUJvY2hBenBGRTVMc2p1V3U5?=
 =?utf-8?B?S0E2cUVISDBZWmNNcUQzUWJocGwrd1dOdDVGQWZDbXJPbDNLZnhsZzQ5eWxo?=
 =?utf-8?B?WWdUZ0FudWNNVVo1V1haUENFVTNnSHpwbmp2NC9wejhKcUFYQ081SHZRWVVS?=
 =?utf-8?B?Z29YNkZzc0VCL0hIMVE5R0lPRjBHcEMyQ2M5ZEVaclN2RDNJdzkxSnJOZllD?=
 =?utf-8?B?bXNLUkpRdi9EWnJ5WHJyMTU3OUdaTUhEZFNxUjAzZGtRTG1TTVRWWFU3dm9a?=
 =?utf-8?B?RHZCNWZNZUFGMktmaklNeXhLTDExUmFqRmw0a2hXdHVZazhnbnhSR2lwWTVo?=
 =?utf-8?B?T3h0TW1HWkNURXFzeXlQOHFmSVM4UU5ydHBGMlZIdjdXK3VrV3JsUXBMTUJQ?=
 =?utf-8?B?emszQkdqNkoyeXkrUVI4ZEgvSWl3MzZkRDliaGhGczJqTGMwUVJiWnNWZjkw?=
 =?utf-8?B?L3JzVEU4RG9kaDlLMTBIQjN1ZFRRYi9YRHh5dEx6R01tbVJhQXpLYitOYUVQ?=
 =?utf-8?B?Y1RwdTNZQzhkN25XMjM2YWozd0NKUjdqQTU1OVp6YzRzbFRuTzlMWVA0cjJP?=
 =?utf-8?B?WUhEcU1DMTh3RzZPN0UvNEZ3MkhKa05WOU9lMnVzOWVIVEJTL1JIeUM4a0Vt?=
 =?utf-8?B?MFJEMW9qcmFkY1BUNGVPVEcvTWhtd3dRQ0xTM1NZVmRaaGlobUo1VmtUbXpY?=
 =?utf-8?B?QnF5RHpXaVZUaUFvOHU0Y1VCUThGbUMwOGtlZWpNemowM0dxc04xUzAyNi8y?=
 =?utf-8?B?UW94aFkrK1RTUy9KemRSQ1hTcFVaZXRxMzBxNVg3dHRmOVd1SnlrcW5IWFFs?=
 =?utf-8?B?Y2gzeFVyUWFoUW9ReGlXTTR1UEtNL0Joa1dVblNsd001a2pyZlRrazh2WnZs?=
 =?utf-8?B?Rk9lSkhWRXREeXZhM0hkTHlEcTdrYUJSKzVIV215MDVFY0pIUFl5UUVRWmIv?=
 =?utf-8?B?NlVxTHpMdjAwcnpycVFCSnF4ZWNrMXZmUGtTSHlTZUxZU0JJOVBBajhaRXRQ?=
 =?utf-8?Q?l5irF/Nsj72B0?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8b4d7a7-1685-4dce-f78b-08d9115b3df4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 13:23:03.0155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzT7pvt3YqHC6HZSjvb3D3HS4JZiTgos7rZ+pPBir0xvk6bsu7D4kXWdMSod3W69
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2399
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> writes:
> No in order to derive the aes256 keys we need the full session key that
> falls out of the authentication and that's 32 bytes is kerberos
> with aes256-cts-hmac-sha1-96 (the default) is used.

Ok

>> I would call it server_in_key and server_out_key.
>
> That's fine too.
>
>> I think we should have 2 ioctl:
>> - GET_FULL_KEY_SIZE: return the size of the struct
>> - GET_FULL_KEY: return the struct
>>=20
>> (note: no __packed, this might create all sorts of issues and kernel ABI
>> will be stable across the system anyway. I hope we didn't pack other
>> ioctl in the past... need to check)

I've checked and sadly we use __packed for every struct :(
That means we are forcing users to have packed struct as well which is
not a standard C attribute. Portable C code will have to process each
member field manually. I guess clang and gcc both support it so that's
not a huge deal... anyway that's a problem for another day.

>> struct smb3_full_key_debug_info {
>> 	__u64 session_id;
>> 	__u16 cipher_type;
>>         union {
>>             struct smb3_aes128_debug_info {
>>         	__u8 session_key[16];
>> 		__u8 server_in_key[16];
>> 		__u8 server_out_key[16];
>>             } aes128;
>>             struct smb3_aes256_debug_info {
>>         	__u8 session_key[16];
>> 		__u8 server_in_key[32];
>> 		__u8 server_out_key[32];
>>             } aes256;
>>         } keys;
>> };
>>=20
>> * Users will call GET_FULL_KEY_SIZE to allocate a properly sized buffer.
>> * Users can do a switch on cipher_type and process what they know exist
>> * We can update the struct if we need to in the future without breaking
>>   userspace
>>=20
>> This should cover any possible updates (AES-512 or some new cipher...)
>> unless I'm missing something.
>
> I think we should have explicit length fields for each key, if it's easie=
r
> we can still use fixed size arrays.

The problem with this is that if we make the keys bigger for a future
cipher, old userspace program will send us a buffer of the size of the
old smaller struct.

eg:

* user on kernel version N compiles:

    struct smb3_cipher_key_debug_info {
        __u64 session_id;
        __u16 cipher_algorithm;
        __u8 session_key_length;
        __u8 session_key[32];
        __u8 server_in_key_length;
        __u8 server_in_key[32];
        __u8 server_out_key_length;
        __u8 server_out_key[32];
    } buf; // sizeof =3D> 16
   =20
    ioctl(fd, CIFS_DUMP_FULL_KEY, &buf);

* user keeps compiled program and upgrades kernel to version N+1 where the
  kernel added AES-512 or whatever:

* in the kernel, sizeof(smb3_cipher_key_debug_info) is now let's say 24

    copy_to_user(userbuf, &kernelbuf, sizeof(struct smb3_full_key_debug_inf=
o));

Since we don't know the size of the user provided buffer and we assume
it's the same as the current size of the struct, So we will actually
write past it (24-16 =3D> invalid write of 8 bytes).

With the extra ioctl to get the size, userspace will always give us a
buffer that matches the struct size of the running system.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

