Return-Path: <SRS0=lstS=SO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6B8C10F0E
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 12:51:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ADB32084D
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Apr 2019 12:51:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="CeV9ZYW/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfDLMvL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Apr 2019 08:51:11 -0400
Received: from mail-eopbgr810097.outbound.protection.outlook.com ([40.107.81.97]:35699
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726867AbfDLMvK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 12 Apr 2019 08:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KaiykwOaK5CGCoLl3fIPvedLyVohcNoMFyLR4wzsL9I=;
 b=CeV9ZYW/h52tHPCEIAhmS2BYyzNwnVYAIdZ8W10g2Q0115UzSDet8vjrIeDqEXWgqTpny0Dy6O9eqaofY9GRPxMfkdkVCgcPMuHILhox2r0UU4gvLaQ/HzfBLq8i+LBxEKy9tSvnZlCH9JqYikReKAV8ffghcjIWfJZGZ8ZcKLg=
Received: from DM5PR2101MB0727.namprd21.prod.outlook.com (10.167.110.39) by
 DM5PR2101MB0807.namprd21.prod.outlook.com (10.167.110.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.2; Fri, 12 Apr 2019 12:51:08 +0000
Received: from DM5PR2101MB0727.namprd21.prod.outlook.com
 ([fe80::a5f2:8ec:f7d7:d0a5]) by DM5PR2101MB0727.namprd21.prod.outlook.com
 ([fe80::a5f2:8ec:f7d7:d0a5%7]) with mapi id 15.20.1813.005; Fri, 12 Apr 2019
 12:51:08 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
CC:     Steve French <smfrench@gmail.com>
Subject: RE: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Thread-Topic: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Thread-Index: AQHU8NyhHtEYGOraGE2RM0+eOP48VqY4emQw
Date:   Fri, 12 Apr 2019 12:51:08 +0000
Message-ID: <DM5PR2101MB0727698C9899BE431CFB1D6CA0280@DM5PR2101MB0727.namprd21.prod.outlook.com>
References: <20190412030534.23402-1-lsahlber@redhat.com>
In-Reply-To: <20190412030534.23402-1-lsahlber@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-04-12T12:51:06.6043479Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4a60dfa2-6b20-499d-97ea-6093793cbe82;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [2601:18f:901:8a17::1003]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ccc835d-2d70-4664-9430-08d6bf458881
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600139)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DM5PR2101MB0807;
x-ms-traffictypediagnostic: DM5PR2101MB0807:
x-microsoft-antispam-prvs: <DM5PR2101MB08075C6FCB2A82E8DC8FAE59A0280@DM5PR2101MB0807.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0005B05917
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(366004)(346002)(376002)(396003)(189003)(199004)(13464003)(74316002)(305945005)(7736002)(316002)(110136005)(97736004)(5660300002)(22452003)(6246003)(53936002)(76176011)(4326008)(6436002)(25786009)(2906002)(102836004)(6506007)(53546011)(229853002)(486006)(10090500001)(52536014)(68736007)(46003)(55016002)(9686003)(99286004)(8936002)(105586002)(476003)(106356001)(6116002)(446003)(11346002)(7696005)(186003)(14454004)(86612001)(10290500003)(478600001)(86362001)(8676002)(81156014)(81166006)(256004)(14444005)(8990500004)(71200400001)(71190400001)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0807;H:DM5PR2101MB0727.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qvVMYWdoEIjvbjjAfKX2Lrvc6i2WDvZS7cXQx3fMHEyEW+P+R4imuRnbMEPPNkGQGBDV1wQHrJXOnnzo8pl6FpcjXOoONKoDiiKc+cwYoXT6tyMmy+xBH77I2ffOha77CSQpYBUKYOh+/ZQZyF9gumrOmLgL0NodZtJwc6OFVZXbhn736KKAKIcgkwyf67JlPj0veTP5sF9Wv5721DwwDJwohxbDe40MwFlEDLHgCgBSdWFLPYk34v/oe+iosXLodWtRpgPobcLgVdFwvrHIUyF3Dia38kkGabhuroLNA9NADtckVYCfbtXQtFklrWScUu3T1r52pii0ueVINhbVy6SMBM9h5yFR4oaIgG8nOT6k1LSXhyT9zfHyX1pts3lFDXM1qaf8TCM3ggwwXLCBsqWlNta0pbXfWJ1QN0BbaHk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccc835d-2d70-4664-9430-08d6bf458881
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2019 12:51:08.1926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0807
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>=
 On
> Behalf Of Ronnie Sahlberg
> Sent: Thursday, April 11, 2019 11:06 PM
> To: linux-cifs <linux-cifs@vger.kernel.org>
> Cc: Steve French <smfrench@gmail.com>; Ronnie Sahlberg
> <lsahlber@redhat.com>
> Subject: [PATCH] cifs: fix bi-directional fsctl passthrough calls
>=20
> SMB2 Ioctl responses from servers may respond with both the request blob
> from
> the client followed by the actual reply blob for ioctls that are bi-direc=
tional.
>=20
> In that case we can not assume that the reply blob comes immediately afte=
r
> the
> ioctl response structure.
>=20
> This fixes FSCTLs such as SMB2:FSCTL_QUERY_ALLOCATED_RANGES
>=20
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0b7e2be2a781..768f35ea63cf 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1467,7 +1467,9 @@ smb2_ioctl_query_info(const unsigned int xid,
>  			rc =3D -EFAULT;
>  			goto iqinf_exit;
>  		}
> -		if (copy_to_user(pqi + 1, &io_rsp[1], qi.input_buffer_length)) {
> +		if (copy_to_user((char *)pqi + sizeof(struct smb_query_info),
> +				 (char *)io_rsp + le32_to_cpu(io_rsp-
> >OutputOffset),
> +				 qi.input_buffer_length)) {

Shouldn't this validate that OutputOffset, for a length of input_buffer_len=
gth, falls completely within the bounds of the response, before copying?


>  			rc =3D -EFAULT;
>  			goto iqinf_exit;
>  		}
> --
> 2.13.6

