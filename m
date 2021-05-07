Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B652C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 10:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E58056143F
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 10:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhEGKaI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 May 2021 06:30:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:29907 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236885AbhEGKaF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 May 2021 06:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620383344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w6zWIwel2XtdfKjmHuJWBuY9QryQgDaHUXm0SCKrbqU=;
        b=Joz8yceeCFMUdZLWGduOd17/C3GSOle+iAycPql+ica/4bzzXva5K5M87L+/4iFlcgKgrw
        Tkrw5Jxt/I7hSytJ1T1RcjQfaX4XXdSGp6sp8D+Ia/Obk1ApkcttT9WwLF3e1IOxCkDbUO
        o2E077c3RWZk7DWeAJMIXOWUdYohsDM=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2056.outbound.protection.outlook.com [104.47.12.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-RpIazyOZNdClOMyDzfz3Sw-1; Fri, 07 May 2021 12:29:02 +0200
X-MC-Unique: RpIazyOZNdClOMyDzfz3Sw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D5lDF0YAZ/4eTzr9zUdXv81wiovvEtZ2upHbiwbMEfMvUgkJIflgWkxhbwGizsYImKTkKZSVVrsmrperg4LLuwQaeqWjuwudWKlO3XYMApvhSirgDKU3OKDb2N/A/ojXp4WH4lM+Wvy33IXA0CUKrhcMJijUegEWLHVb/5NNrh4O5lirNoV+pkVI++cBr61Jf3yC6oBHLZw2gOL6AL+JeV9pKJHu8et01sBT9Qsv/pi2E3okKySOn9cDE9tBn2EXjjaxlwBkPHBZmwJ2kQntUjWzGz0jTlCBxef4h3yd3C6+3cDrfQfuUYafjCnSEOysv2AY93iWNg+IHPHE81Qz0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6zWIwel2XtdfKjmHuJWBuY9QryQgDaHUXm0SCKrbqU=;
 b=ISAtcOqmKOjNekZ13CN8NN1VwfIlhwzA57TyhNW74ry9bkQjJnW/fxnZxWaK2bZcMdxr89e8PFYEaAhfIS8Dj05HJmWvHf9SEZYNBoAdQ3P+FpZzcxOK3xaruevWu8BD3JT8TaR9gw5J2ZukWe6KI9Dj9at2XDfz6i6drkl2zgW3/LnDkYBiiwomcRIb51cwhgO92TGP/9JEiXQOnLV9FZByjBx279XVRRseq88xrh4j4yDSDj8HcplWVzJa/luyqd2TcM7q6NikU+bezhJMcuIutbuiMDkntX1wNTf75yMJyyqs11JbmORPR0vMqkr91lDkkHCXpN/f3C0BM52XEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: samba.org; dkim=none (message not signed)
 header.d=none;samba.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4752.eurprd04.prod.outlook.com (2603:10a6:803:5e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Fri, 7 May
 2021 10:29:01 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.028; Fri, 7 May 2021
 10:29:01 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve
 debugging of encrypted shares
In-Reply-To: <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org>
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org>
Date:   Fri, 07 May 2021 12:28:59 +0200
Message-ID: <87y2cqu9as.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a615:1bdd:6a41:a7f2:21f0]
X-ClientProxiedBy: ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a615:1bdd:6a41:a7f2:21f0) by ZR0P278CA0089.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 7 May 2021 10:29:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4abf6305-4767-452e-13c8-08d91142ee60
X-MS-TrafficTypeDiagnostic: VI1PR04MB4752:
X-Microsoft-Antispam-PRVS: <VI1PR04MB475254EE1B6F2F4B0CDD9140A8579@VI1PR04MB4752.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: afwAd4cKEza2D2OENpj93S6+Kq8pO2WSuja1xNDnLjJfoLA4UF6PxfJDItiva9cmMgAub64Wqg0aUmGPfcvJF7lxRHDbRsMlkHCW5bwlB4oSY0LJ+h0C4Hil1zBd/wGj1QmcnXzMaxmRUHzXRmLiq4eZgGGGCxCpNig1tVs8nzKFE71ddZGRIBov9j9ZOdCmtMdPpInzWLFyy4Z2hfz7JxL4SX4EViR3XQMuX3At4fkAVa0faisx54P7mVo0r/usLz9oeJkfN+ksuU11jgy1PjPSNuVyc5YFL3vY9nPxfVIlnSgBx59Co381MMKosx/4yCWkY1vt6UEgxTk9Zt4UZo6OojMJxN2qD5nt9CZxcZwgohXQxupQ8vkQXQR+es++8QH3zUJEsBjPiTCgnz5nJ7CALvCYCniQepQXrNfXy6Hme04aA6Ie3d9K7Nb6Pf5LNKisH4v8sO+zXzozddrm86XXcHxYK121PR0NrbdZ7FMpHEru7IU7cc3NtDz79OZLs30Oa00I5yZwtJOW5EEcFEL0dsw71PvjfSoPoAO58mqGJX6J4ojg8MV4ppgdbW9sOQ6Id37xqOFFw53xFoXfWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(39860400002)(346002)(396003)(366004)(186003)(478600001)(66946007)(8936002)(38100700002)(6486002)(5660300002)(6496006)(86362001)(16526019)(110136005)(316002)(8676002)(66476007)(66556008)(52116002)(2906002)(66574015)(4326008)(83380400001)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2N1UjAvRzllTExKa2FtekpKQnN6TUgwVEJFS3R6M3h3NmNYYTNPNWgwbVFX?=
 =?utf-8?B?QWpSVENWcXVxVEFmZWRkYnV4T0l4b2hZV1plY3BNTmpDdkQ0MVZmaUtmU2d0?=
 =?utf-8?B?SEd4SWtFK01jeDgzVWUxaGZUUnZaRmZwUjN0bmpSakQwUXF1U2thWlE1TEtR?=
 =?utf-8?B?OFlycmR0WExKb0x6T1EzeVhKcTNKVkNxOHI0L2hKUHc3KzZTc0x2aWl4OEV4?=
 =?utf-8?B?VHFoUytmZkxiMEN5UStiWjdQa21vRFNrTjFrVm9RN3NnTk1YKzhYNmZSejBS?=
 =?utf-8?B?ajhIODVKU09vRG5tTGpmN25yeCtldkw5M2RaYmNnTVdwZUJ6c3A2REFkaDIx?=
 =?utf-8?B?WTRrRVN3Z0I3ZHQzeDJsdVZDZUJOSDFOZXBNKzRxektBNkpWeU9Ob1ROeEEw?=
 =?utf-8?B?Z2U5VGRBekNZTFBZRktpdTlnSVVadk40aTd2L0pYK3pjdWpoS3ZoeUg0eEd5?=
 =?utf-8?B?bkFndWpWdGlNdHBpZ2NnMkwrN0VnVDc3R0ZKSmZyT2hRRlFqcWpRN2ZuUTJp?=
 =?utf-8?B?bkV6SkFLL00xZGVLU1V4VEFnWnE3Sko5dFNqVjRBRGhZT3QyQlhpcm1ZaGYr?=
 =?utf-8?B?V0hQSzZSQ3k3TUVlNjZoVCsxb2FPYXFiZ1Avem1sSVhpbEdscEhFR205TDhM?=
 =?utf-8?B?R1BEeDlnR1pJdmJtMHlqMVBuY2VPeU5tUDg0M3FmWjNxbnk2bjRSR01ERm81?=
 =?utf-8?B?MnBVVVgyeWtvOVlVYXEyeXJ5UWtKdTJNQVRVWGZRcndrbVJlUHQycXcxTmN4?=
 =?utf-8?B?bzA5R2UrR2w2a0xFRXpLbW1vc0I5Mk1FYXBIM1J0aHlMQXpZQnNNUnpvYTFi?=
 =?utf-8?B?MmsvVktqMUM2ck1UdjhGbEt1WmtOYjhoSU5XTGphS3pReWc0RmdWS2ZnTXdT?=
 =?utf-8?B?cHl5R0IrZXByZWtTeWkvU2owZGVQT3NBRVZkTzBIdTBlVkE2cHcybmFpWURq?=
 =?utf-8?B?bnpxS2JJRmZOMm90WCtuaTZoKzJUV0ZsRXR4Qm90dXJqclJEN0p6dUFEZExt?=
 =?utf-8?B?aUI1a3pmTEVKTThFMkhiY3l1ZVg3eDhEMHdlSnR4d3B3M2NyRVNrUmVBeHhw?=
 =?utf-8?B?QnRtT1FKS1NVSHB3dHpBajZrbWVCTnJURzRTREhRZE5qbUJib3lqNDRFakNU?=
 =?utf-8?B?Vk85cHBLbXJlUGFPSTRGQkZVdnJmUFBmQ0tDREo2a1hyZVpTSHNIUUtETlI3?=
 =?utf-8?B?RDZqMkpjRndFdStCeFJvdlUzVmhTdktNdGE5RU1JUmgwVE4zVmYrU2c3NjZS?=
 =?utf-8?B?QnRWSmNHZmN2bGxZN1FYU01qTXBYaW5sS1FMaXBKbmp0U3FuNFdrcW9KQUlJ?=
 =?utf-8?B?K2pYbWRlTmpmMzNxQSt3bVgvcDJMaU04VG1Zd3JsR0JkcFBkQ0dKVGY0V2Rr?=
 =?utf-8?B?ODYzUDRBdEJTdm10alRoM0d6Qk5nU0hrajZ6Zi9KbmZyZmYyMjJlREd2a0h5?=
 =?utf-8?B?cGtHbmJObExFRFNOaW9RalhIckRwK1E1R2MyZG1tL0RGM0wxbTV2NFVWSGh3?=
 =?utf-8?B?Qm42YnhaeUZPU3dNanN4YkNiU1lMOG1EcWRPRFJZOHFSdnZxSUtXYlR4M2hZ?=
 =?utf-8?B?bnZHQ01IVnBCRVVaWDQyUWx2U2pUYkJVMDJNOGtzSTUxbG1sRnVWdnMvVzVn?=
 =?utf-8?B?YXZyM2FCaUJmSUtRcnYzVDZHcklKUDdYVlUyQTJqaEZ5WkREN200cFpMc0pw?=
 =?utf-8?B?NTFtZTEzdGJYSWdoVUV5bWoyYjlUMEw0WG16YlJrZzZJdUpTVUtudHorMW91?=
 =?utf-8?B?bFF5dXdpTG1PUWh5UTdNKzJCY3VxeUFjbmYyNlZqSXorNzgvWU5id1l1U3pE?=
 =?utf-8?B?ZW5Ga3AycUFyeStDUnR5c3VUMkhQelBpU3lzZGUrTXFrMjVyVXI3eWV1RGt3?=
 =?utf-8?Q?Tpa9dJSHP0FAk?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abf6305-4767-452e-13c8-08d91142ee60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 10:29:01.5652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGeEE7mQJHMnpNEg4wUN/HL0MOyjU631zzWqjIBe7tlglWvZvM7vfy+p+CCXIWjG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4752
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> writes:

> Hi Steve,
>
>> +/*
>> + * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
>> + * is needed if GCM256 (stronger encryption) negotiated
>> + */
>> +struct smb3_full_key_debug_info {
>> + __u64 Suid;
>> + __u16 cipher_type;
>> + __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
>
> Why this? With kerberos the authentication key can be 32 bytes too.

That field should be named sesion_key.

We only need 16 bytes for the session key. If the source has less we
pad, if the source has more we truncate. That's how the specification
describes it.

> Why are you exporting it at all?

Wireshark initially derived the keys by itself from the session key and
computing the preauth from the trace:

Pros: only need to type one thing in Wireshark and it can figure out the
rest from the trace

Cons: The trace needs to contain to negprog&session setup

After several complaints, I added a way to directly provide S2C and C2S
keys. You can either provide any combination of Sesssion Key, S2C or C2S
and Wireshark will do best-effort to figure things out.

>> + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
>> + __u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
>> +} __packed;
>> +
>
> As encryption and decryption is relative wouldn't
>
> something like smb3_s2c_cipherkey and smb3_c2s_cipherkey be better names?
>
> They are derived with SMBS2CCipherKey and SMBC2SCipherKey as labels.

I would call it server_in_key and server_out_key.

I think we should have 2 ioctl:
- GET_FULL_KEY_SIZE: return the size of the struct
- GET_FULL_KEY: return the struct

(note: no __packed, this might create all sorts of issues and kernel ABI
will be stable across the system anyway. I hope we didn't pack other
ioctl in the past... need to check)

struct smb3_full_key_debug_info {
	__u64 session_id;
	__u16 cipher_type;
        union {
            struct smb3_aes128_debug_info {
        	__u8 session_key[16];
		__u8 server_in_key[16];
		__u8 server_out_key[16];
            } aes128;
            struct smb3_aes256_debug_info {
        	__u8 session_key[16];
		__u8 server_in_key[32];
		__u8 server_out_key[32];
            } aes256;
        } keys;
};

* Users will call GET_FULL_KEY_SIZE to allocate a properly sized buffer.
* Users can do a switch on cipher_type and process what they know exist
* We can update the struct if we need to in the future without breaking
  userspace

This should cover any possible updates (AES-512 or some new cipher...)
unless I'm missing something.

Thoughts?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

