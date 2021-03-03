Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC61C4332E
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Mar 2021 00:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4DF464E51
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Mar 2021 00:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355407AbhCDA2P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:28:15 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:37794 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244735AbhCCLa5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Mar 2021 06:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1614770955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6l8mrKONlSQsfw6DsC4fUyVcA+oURFzRpjHL7bdxh/0=;
        b=gYMUa6hS5XnQMOIsTRWCIeiuDgESgqYVv//afNiofNHjTPWDOM7hyYE6Pn8ltIbESkJ2La
        Z/AOScMqwUqX7/Hl7ttbfGmDBhWAIcodxs23jLqiUOPHvl3Uu6Wm7R8A1WE1GF6x3XlQNy
        4S4f6u/U8RjlGpO/tNq5wqSplbM/8bI=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-MjduRdh7OtSMAM5fEg39aw-1; Wed, 03 Mar 2021 12:18:19 +0100
X-MC-Unique: MjduRdh7OtSMAM5fEg39aw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQdTsoVhSCZfNrrWI0fKsFTFGnUTCHwJe6yuprolKy4DZPceEjpIUqkOb/Oir5l9uAiLaf3Ux2wUKRB+Loi+cpys37xA4q0VsCuaMoVHzc4iCQV2ji9Y7E9NHPqOkejiH5NmOalcnCEAT58vICInBD7Gm1XhKLtr0WeTZirQq4SuvZ7XmlUzM4RiSDEEzHEaqVgFLtcXWd48Ka/aVp4FD9RNrnlnyrIBFIJ/VUrJSy/1kVRSeP9aGeUlpUGLJYpIeBuYMz3xvBd6oPBaIj+zbaP531b3GdtSf9jL3gwtIy3/0keVv/OE/rKWt34H6UMgtbD/u9ZIr2UjstfSy2NonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6l8mrKONlSQsfw6DsC4fUyVcA+oURFzRpjHL7bdxh/0=;
 b=Y+TqyzMwQv58r+UImwpzG80viLjg3HRCfOktYXhsULeRNYSP7eytLj0JzWVuXWcF4g+E2095ohXJZ4lXbGITwYRimWATki2k2nOYPg/T88NyMgzcZBiYaV3qd40fDTJQmG5WJ3AuHM/KXnXVVsOaB3VCVLzV1Kh+C2em/eK8V3LQEyQdZtRbGkRlD2IS6UtuPa6MeUYUslDL0M38ATFbGU/LWSQFyPj4aIeVwUOPN8ike1Mc71llWqG7tQEmOyjodaBiNi4U3TN60K5KcpYN7HnC1XIhxRsmcC4SsLuQ2xNpw5aeqkcZ4x8/F/w8Oi+Nu9yFESOABbLG6nr7r8ZTDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4959.eurprd04.prod.outlook.com (2603:10a6:803:5a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 3 Mar
 2021 11:18:18 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.028; Wed, 3 Mar 2021
 11:18:17 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        David Howells <dhowells@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [EXPERIMENT] new mount API verbose errors from userspace
In-Reply-To: <CAN05THRV_Tns4MTO-GFNg0reR+HJKa1BCSQ0m23PTSryGNPCeg@mail.gmail.com>
References: <87tupuya6t.fsf@suse.com>
 <CAN05THRV_Tns4MTO-GFNg0reR+HJKa1BCSQ0m23PTSryGNPCeg@mail.gmail.com>
Date:   Wed, 03 Mar 2021 12:18:16 +0100
Message-ID: <87k0qoxz7r.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a07:1423:4545:e408:5580]
X-ClientProxiedBy: ZR0P278CA0140.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::19) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a07:1423:4545:e408:5580) by ZR0P278CA0140.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 11:18:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 198bc1e5-45dd-4043-a05d-08d8de360b8d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4959:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49599C72DCC72532552471ACA8989@VI1PR04MB4959.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RT3CWf1LLeDa3/a+jtEM3CeSc5sdZ0u3Ud4TSNNNIIKxia+adowiPOWrW98ks7chBcl8cx0BpfLEwwUrERmZObwwE+agDaNaVwtic0z7IRAjIUAedYjbenyZMTuu4ZcHq8QKjwO8pHL1ogReX010AXcc+nKNnMBC2iO5p4DS17mgofE4Nma1qcbalP+Jwi+TeMoRKtrTbiXcOaKc+Ao62WHsvlDYbnOqbELW+kUhFpFsSgSQxQxh3n2fmfDZkxFXvEe7uzzkLqA+0pwVs/7kj2nY3XetBdG5dX7ye7Q4XcMYgMoh3OOXmsZPokPad+RAkpRpQtaNrl+wBwBMHJnNrbGaq4VtjcFBkoysDC61Y4mA04leL3PcIBon1mc4h7O6eOgVLYOmQ/qRHGRA+oLKJDiESvcPRKH3UcZqw5kC78kt3ceDg9+MA75yvJAdlGT9nI8TeSqEHgVR1zh1cjrlh5mKjBq/vQJP9lYG5R7CyB+B7z/erImaLPD9aPevFsOmQFnHgryuPQsQVrcPWJpAfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(6486002)(186003)(2616005)(52116002)(66556008)(6496006)(110136005)(66476007)(66946007)(8936002)(16526019)(83380400001)(5660300002)(4326008)(8676002)(86362001)(66574015)(2906002)(478600001)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dXNhOU5DWFZTNFpoUnVqaFBDelFTdjUvQjNxS3N3MHJSbHR2ZzdQSGlkN2dx?=
 =?utf-8?B?TXp3ejMyMmxhS2EyVXdCTFVIR0kydVJBNCtKWEdKRm1odTJqQStMYXYzZXU2?=
 =?utf-8?B?U0V2TVROelVXZlRsQkVDcTlCSnMyRjUwSHVqSVk4d2F2NnlKN0puanE4dFhI?=
 =?utf-8?B?MUR2SkNQUjhuZXZvTXBZTWoxWjFSVXc5RnhGcWFkZnAvdHFyZGx4NTJVNGRL?=
 =?utf-8?B?VlBXWEE4K3RTbXowWnVHQlpCSEk3QVl4aGkxc2VmTS9PaGJQTHp0ZG9pcjlC?=
 =?utf-8?B?Sk1veDZ0ck94cE9IWkxvR3ljTUhTNUx3dEIvMmNuNEw2TGFmY3ZQS0JIQllG?=
 =?utf-8?B?Vkx6aitzK3BHaHpTVVFQRDVFUUQweno4OWU5VlErWkFxVVdSajlZdDZkbnV5?=
 =?utf-8?B?UjNIck91c3ByMUY5eE96aDl0a0pqVktZYitYcGNrS3o1UjVrcVlhRjQ2UG9J?=
 =?utf-8?B?YzV5OFRPZEtVeDN4VzhJZGx2aFZYZ2lOWXdFN0FON05OaTlnSmpXVzd4QU1P?=
 =?utf-8?B?Z2VCMFRsYVY3QXplZC84UWZoMWVyeThEVFdUeEU1WGdkOWphVGQ1N2NzYThw?=
 =?utf-8?B?engzSEdWSTEvK0dmRnk3dlkvTVFPTEhGQW55L3Y5QzhkODdmei9oMDFrWjN1?=
 =?utf-8?B?SlBhZ0dNNWZjZTF1b2RacWlBYmh5ZTdyNzhFSDNZalRpVHVvVEgxU1dCRERo?=
 =?utf-8?B?TXFpWXBZWlRnektCR0MzckdEazhHanBxelc4NjdTS0lDa2p2TkpGRDcxM1g3?=
 =?utf-8?B?dEtaMklabkdrY1FpZnJHUzV1YWtBeFdnb1RRcEV0WFh0QkJPRmo4VkxxUjlV?=
 =?utf-8?B?cU14bEFZRmROVGpza2JlTkZ6TWZ0M1IzUHBpU1NEQ1dRK25lOU5VUjZ4eitk?=
 =?utf-8?B?dk5Ka1lUMDN4SUlGRE5ZRE9sMU5SdW9zQVVrUHZ2cjlOYmlaQ2FCcW1NL0sr?=
 =?utf-8?B?cnJiMmNXTDN0TS9ycTRWdXFIZCtXeDlDdVdqY2xDdlVzOUxNcU52Q0tNU2di?=
 =?utf-8?B?L2RMdVZicE9SL0dkc1lQcXpCRjlISTRUN1czeXRPUUI2V05HcGtlSmpvK2Zz?=
 =?utf-8?B?am93TjdINGF6U2x4KzhpNTIzN2g0WEJsV1dVMjNpdk9ib09vYzZ3aDdJdGo5?=
 =?utf-8?B?c1hQY1Z5MkIxSjZZcHExS1BqMTZ0aGJIVHRFa0MrWTlTazBIUGJDOU8zeTl0?=
 =?utf-8?B?WExqa2VDU1dBWTVsSStkblllQXhkbzAyYXlDSnYvcEtXcWZRWGxWbGl4UDFs?=
 =?utf-8?B?RTB2TnNtMlg4YlJiTEFmS24zWlhuclNDczBVYWZraDdUWVlCL2hBc1d0NHhX?=
 =?utf-8?B?ZFlqUTJ0ZUNNejlsanpnOHc4dUM3VHZtVE5LU3BIaGM1T0Q2R1B0dkRURWhK?=
 =?utf-8?B?Y2ZoVXUvakxIbjZ4dEN0d3QrUDhuOUkzV085Y2tsRDNlcjMxdXh3VThITmpz?=
 =?utf-8?B?NmgzNjRVWHBUSDRRenJxdEprU0NUM3VhVkUxR3Q1MkJIbWZJdXovNHAyUnhw?=
 =?utf-8?B?citCa3k2T2NobHFVZDVzc2RYK1ZIUW5SbnBoZWh3L1Vsdk9qaU1WU1RLWEtH?=
 =?utf-8?B?K3M1QTNrUTR3YnZHbXlubU0xdVdJa1Vpb2lqWUxGUlh6N1NhOVBWZ3pQWEVj?=
 =?utf-8?B?UUd3NVRSMDVkSTFVc1J4allCTTExdG5CRThCZ0VqQzYwVWM2YjZZK2NwYUtj?=
 =?utf-8?B?SDlsMllRb21qZHFHbC9BWmNpWGRTNUZxeWtOYWdUQnhRVjcrcVRjVE9rWk1X?=
 =?utf-8?B?ZGRZb0E3WEl5bnEwRTJTSFlQOXVKSWJ6RzBYb1pEWFY3VjI5d1RzSCtRY3RQ?=
 =?utf-8?B?OHBCK29IQnpYV3pVSkFGcGl4RmdnYkNQMktXNno0L3BZa0dLRnpYWVUzY011?=
 =?utf-8?Q?397UJI8adpEKs?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198bc1e5-45dd-4043-a05d-08d8de360b8d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 11:18:17.8835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ta5dNj4SFtnb0Ws9Ej33vGvp2COMHCxjUjxx7i3NFqu7QbX8sbyAdIoIrrS60nh5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4959
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ronnie sahlberg <ronniesahlberg@gmail.com> writes:
> I like this, this is very nice.
> But, as you touch upon, it requires we know in mount.c what type each
> argument is.
> Which is problematic because the list of mount arguments in cifs.ko
> has a fair amount of crunch
> and I think it would be unworkable to keep cifs-utils and cifs.ko in
> lockstep for every release where
> we modify a mount argument.

We could do some basic pattern matching: like if has no '=3D', assume
boolean flag. If value only made of number, assume int. String for
everything else.

But this might fail on numbers which are actually string
(e.g. password=3D123456).

> What I think we should have is a ioctl(),  system-call,
> /proc/fs/cifs/options,  where we can query the kernel/file-system
> module
> for "give me a list of all recognized mount options and their type"
> i.e. basically a way to fetch the "struct fs_parameter_spec" to userspace=
.
>
> This is probably something that would not be specific to cifs, but
> would apply to all filesystem modules.

That sounds like a good idea yes. I wonder if David Howells has
considered this.

We can already sort-of do this actually. We can have a special boolean
option "help" which on the kernel side would log the list of
options&types in the fs_context log (as "i" (info) messages).

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

