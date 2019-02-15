Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A6B5C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 20:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE0D3222BE
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 20:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="lYSH7Sl/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387989AbfBOUKw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Feb 2019 15:10:52 -0500
Received: from mail-eopbgr700137.outbound.protection.outlook.com ([40.107.70.137]:4480
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfBOUKw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Feb 2019 15:10:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBoGtGGeP3XKpAczamnta9RPMXukwbDaOYx9do7PzXE=;
 b=lYSH7Sl/1C8E7WVBrOldoGQjhMI+7DmTvIZu+my4pbSHbLWXF+WDJoW+UfaU/t68unhRyaCXJM4DisHG0kKeeeSc8lLrn/6DM372zqJwcXR4m2Xi1x6OOP/CPZ/oR+ZOmPAa/5j4ZlOAVp8R+MoNtm3KstPI4k1sSC9EiTts0/E=
Received: from DM5PR21MB0140.namprd21.prod.outlook.com (10.173.173.15) by
 DM5PR21MB0779.namprd21.prod.outlook.com (10.173.172.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.4; Fri, 15 Feb 2019 20:10:47 +0000
Received: from DM5PR21MB0140.namprd21.prod.outlook.com
 ([fe80::14fc:ecd:4819:e723]) by DM5PR21MB0140.namprd21.prod.outlook.com
 ([fe80::14fc:ecd:4819:e723%13]) with mapi id 15.20.1643.004; Fri, 15 Feb 2019
 20:10:47 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Steven French <Steven.French@microsoft.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 4.20 65/77] CIFS: Do not assume one credit for
 async responses
Thread-Topic: [PATCH AUTOSEL 4.20 65/77] CIFS: Do not assume one credit for
 async responses
Thread-Index: AQHUxNO1smY2cEMsYUqmQ3cNYc4zQ6XhSvTA
Date:   Fri, 15 Feb 2019 20:10:47 +0000
Message-ID: <DM5PR21MB0140327178FA380F6D7DCAC5B6600@DM5PR21MB0140.namprd21.prod.outlook.com>
References: <20190215020855.176727-1-sashal@kernel.org>
 <20190215020855.176727-65-sashal@kernel.org>
In-Reply-To: <20190215020855.176727-65-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e8:2:176:e45a:3af6:1f8c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 021bf45e-7695-4116-4688-08d69381acb0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605085)(4618075)(2017052603328)(7193020);SRVR:DM5PR21MB0779;
x-ms-traffictypediagnostic: DM5PR21MB0779:
x-ms-exchange-purlcount: 1
x-microsoft-exchange-diagnostics: =?koi8-r?Q?1;DM5PR21MB0779;23:Aw39odj/RnpYWdTePt01XsUnGWzz16WzY+fsIkaKL50?=
 =?koi8-r?Q?77PsHHiqWElfzUeC4Yr+Z6CKGo7CDofbhHaMlOiPcSA5rI7f7xYt9M3+wJly2Y?=
 =?koi8-r?Q?Vb+Desak4RHO/Apg6vapNIa+b8wrBHqDGLrlzw/TgZzkWU0A0A8EHZQzwHffpg?=
 =?koi8-r?Q?XJwmkOEJFxJiYiH/JqQSo9b7YEm+vKiw/ZUQEZn4GIA1izCm20FITPBLe4V0qK?=
 =?koi8-r?Q?Zv14xYfeORcUPydhMWnKdMGXDm2XcpgCe85sqQ+r2wrRbfjRrbd9dkgdfOXqXG?=
 =?koi8-r?Q?JlzCwjEwExzmnkUOIl9Tk5BdFU0bBT2tpsKMTroM/2mE0h4jHT91bGQx8kQf/l?=
 =?koi8-r?Q?WOouZwS8r+C6+DhQ7puDl3xlLtF+63QYl8is8n4Fku1DgtSAcMYmV9er64UW8S?=
 =?koi8-r?Q?owAZfYTLPAqqsN9pOZaGT90Nb3f1V/EZKhDTr/3qLECaX8PiQa5bMaMStSd7ja?=
 =?koi8-r?Q?j7p4AGF8b2skdZ6Kx+kNJLC2B2Lg7ND6ShbHb+tc7jQlhCWe9o5wcQ20zwWc2P?=
 =?koi8-r?Q?77I4kpnqlJ7TBU6u4xgo9WYQvHJMaC/fj8uiFQrkIhB4WheDcqJmHMIaTFI91G?=
 =?koi8-r?Q?1VQtxZJIpETLSGdro/SovabcJbThq+ZwbT8yMX5dLgBVaVd2RDiZiA4Ec4BHtQ?=
 =?koi8-r?Q?uAipoQw6lHFJvqhSmxzdqCi1R/P3HSReBPjvcnxnqhGrubXoym4hEaRU33NWau?=
 =?koi8-r?Q?1DNdPNHovTdqmhYPP5DoUUya5aXp6AaJQ0q316NosE23gOHLny0vcfnMERklqc?=
 =?koi8-r?Q?x7Vq4U3Ul1spP7eKC6uAUaX07UdToJ6f5ZK7nmh4h1VhT3NONSZjK+awMOObPi?=
 =?koi8-r?Q?z9tdyhn7cX3kRl/5dr6z1WqE2pCS8OA9XDYC47JUmdIjShZeWyuHfdoh2jCHWd?=
 =?koi8-r?Q?afZ5L2fDKtEAmu2zDnmlNJtFADPYRR34ssI2im0aqjBGiEIJgjcS1zeK62EIoD?=
 =?koi8-r?Q?D0VYNqlBUO8qA6GMrkrVIX+ycvKU7XrbiZ2HsDofrmQShuZZ9ksScFUyZSp0Fz?=
 =?koi8-r?Q?mZcRDoLU93ygSZw0vW2vLMa4Tm6HVqgKGS73+7mxxNs6KX1NwjZOcflbfRimnN?=
 =?koi8-r?Q?q0aWzuI27o6EoJvv/kioWlhUpo9ATD0EirFNuB7B6HCCjcjULzIQ74/wB0xY0l?=
 =?koi8-r?Q?rq1igwp5GBOG3ftO3VEClntWZP5oWT5NRfeclo4bea7ehH7RsL+eMcdtKmm0+D?=
 =?koi8-r?Q?4BckCEo4j0rkpmZLJHyFKGmzx3g14t3eAxAUdq7URRugBRNaICVVYtAwD4LAt1?=
 =?koi8-r?Q?z3SofO3EVvwTx0I2E1yw2lDDLCB3fHrSiuaHUUT3sXUqpGBeM8SgYZ9PRdFmqj?=
 =?koi8-r?Q?ombO44d/ReckaoYZXkb/djDyZNHjNje32SzUfdywGE=3D?=
x-microsoft-antispam-prvs: <DM5PR21MB0779C6FF9656AE43C4E7BA96B6600@DM5PR21MB0779.namprd21.prod.outlook.com>
x-forefront-prvs: 09497C15EB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(346002)(136003)(396003)(366004)(199004)(189003)(68736007)(33656002)(6346003)(8676002)(229853002)(6506007)(71190400001)(14454004)(7736002)(7696005)(14444005)(10290500003)(102836004)(478600001)(966005)(186003)(256004)(53936002)(2501003)(76176011)(81156014)(8990500004)(81166006)(55016002)(71200400001)(6116002)(486006)(25786009)(446003)(305945005)(11346002)(97736004)(6306002)(106356001)(22452003)(2201001)(110136005)(6436002)(4326008)(8936002)(2906002)(316002)(105586002)(9686003)(6246003)(217873002)(99286004)(86612001)(46003)(10090500001)(86362001)(54906003)(476003)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0779;H:DM5PR21MB0140.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7bQSpdDe/tmIOlP7q3YIQlwsgmFr1WAUZ1tGjhtBBUM7dbmc2eth0jVDJKZ+xAYMRmck7bllyGpTRUco0QQ5Ow++0a+xpjeRwBXZB7axxtCo4GpTsa5CHtS1StygnRQqqcfXK/eIiZxmSg9E+QEeYU6KtWcB1q5E+kI68U2na4wRMHKB7ph3k8WDW9zklW7CjeuhGkexJqzaA+WWcWyC0LcICWdvAvzRtyzv5RfhZTBaQFeVqC1ZPQZavibDxD4lxcIMzmt6SQarlF1bJeoJ34rVKPa8DCmiiQ9mYl2eU7GMq70q5kDrMBk62wgJ/MRAys0SsBTwCbFRpxvhd9TFZKG1n/6MYimNWZZQeCMmyrq/w6VupoOAICUquG0Cic/3GBpoUQN+nQf2YqtwVFlMgxH4STCkW922U5yD2hYD+3c=
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 021bf45e-7695-4116-4688-08d69381acb0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2019 20:10:47.5900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0779
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=DE=D4, 14 =C6=C5=D7=D2. 2019 =C7. =D7 18:40, Sasha Levin <sashal@kernel.or=
g>:
>
> From: Pavel Shilovsky <pshilov@microsoft.com>
>
> [ Upstream commit 0fd1d37b0501efc6e295f56ab55cdaff784aa50c ]
>
> If we don't receive a response we can't assume that the server
> granted one credit. Assume zero credits in such cases.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/cifs/smb2pdu.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index d1ae7cdb236d..3c44c51310c4 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2834,9 +2834,10 @@ smb2_echo_callback(struct mid_q_entry *mid)
>  {
>         struct TCP_Server_Info *server =3D mid->callback_data;
>         struct smb2_echo_rsp *rsp =3D (struct smb2_echo_rsp *)mid->resp_b=
uf;
> -       unsigned int credits_received =3D 1;
> +       unsigned int credits_received =3D 0;
>
> -       if (mid->mid_state =3D=3D MID_RESPONSE_RECEIVED)
> +       if (mid->mid_state =3D=3D MID_RESPONSE_RECEIVED
> +           || mid->mid_state =3D=3D MID_RESPONSE_MALFORMED)
>                 credits_received =3D le16_to_cpu(rsp->sync_hdr.CreditRequ=
est);
>
>         DeleteMidQEntry(mid);
> @@ -3093,7 +3094,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         struct smb2_sync_hdr *shdr =3D
>                                 (struct smb2_sync_hdr *)rdata->iov[0].iov=
_base;
> -       unsigned int credits_received =3D 1;
> +       unsigned int credits_received =3D 0;
>         struct smb_rqst rqst =3D { .rq_iov =3D rdata->iov,
>                                  .rq_nvec =3D 2,
>                                  .rq_pages =3D rdata->pages,
> @@ -3132,6 +3133,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
>                 task_io_account_read(rdata->got_bytes);
>                 cifs_stats_bytes_read(tcon, rdata->got_bytes);
>                 break;
> +       case MID_RESPONSE_MALFORMED:
> +               credits_received =3D le16_to_cpu(shdr->CreditRequest);
> +               /* fall through */
>         default:
>                 if (rdata->result !=3D -ENODATA)
>                         rdata->result =3D -EIO;
> @@ -3325,7 +3329,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
>         struct cifs_tcon *tcon =3D tlink_tcon(wdata->cfile->tlink);
>         unsigned int written;
>         struct smb2_write_rsp *rsp =3D (struct smb2_write_rsp *)mid->resp=
_buf;
> -       unsigned int credits_received =3D 1;
> +       unsigned int credits_received =3D 0;
>
>         switch (mid->mid_state) {
>         case MID_RESPONSE_RECEIVED:
> @@ -3353,6 +3357,9 @@ smb2_writev_callback(struct mid_q_entry *mid)
>         case MID_RETRY_NEEDED:
>                 wdata->result =3D -EAGAIN;
>                 break;
> +       case MID_RESPONSE_MALFORMED:
> +               credits_received =3D le16_to_cpu(rsp->sync_hdr.CreditRequ=
est);
> +               /* fall through */
>         default:
>                 wdata->result =3D -EIO;
>                 break;
> --
> 2.19.1
>

Can you also apply the following patch to 4.20.y and 4.19.y, please?

https://patchwork.ozlabs.org/patch/1030180/

Best regards,
Pavel Shilovsky

