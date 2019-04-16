Return-Path: <SRS0=txT2=SS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EF8C10F13
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 20:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C35420868
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Apr 2019 20:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="bLcgC4b8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfDPUba (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Apr 2019 16:31:30 -0400
Received: from mail-eopbgr700091.outbound.protection.outlook.com ([40.107.70.91]:24544
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728466AbfDPUba (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Apr 2019 16:31:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=W2LCqMhtJJg32QWEPdGQeqLzsWCxhqgPgwObud4tvxHOL43kEb+JlPdqo/AgsPa+vMbdl0wqOIX3Pu/brmR09e1plLCfjB3eisyzN45l31m61yGinz9S2WVSae8B1+kKGOjo+ViG31l18mOPUsJSypxrkyH5OVzl4ZEvrRtn9vxOvF8y5VNqgmbxu8OW9j31NnaDsF4LzR3xdHY7AAAiyvnc6405G1NBtfTHsqAMquS0gH9/vU2Ws7XV2ucS8bKHCn3Ec8sX6liOyjvQ4JDSXFEBZaAW685WR5qMIXPL3a1HsBIlectpKhmf3N+ENekIeNKLOEvT2mvd6IkZBveWEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcM+f2xQlq5wdk23MifDPmL4QlPsfonyzJl6sdlucXw=;
 b=Sq/yPazA1oPexmFIo9Q/VL1xdcM9+slgtu0xYJEF+RtnzybOEPliUXIZhMOcPn0ltfQsw3Fc6hScOH7WjtjQfCm1dX2EgRUcA0SqxLa2oXwMIGfR3oBAx24v8wHnE4sjLuXJ0awDiu7t/4sMyUprrqlWbURmkAkKzQVc6I+v0Cs0g+V+MDJoB3NrVJmmyFfAeI+XkyEQqXpU6uyxRdBhC7y6AuteTZojLH9LC2vnL+ctTwMPSZmzf1rpoSMDI8sDmTKAvwSh7VMh/HHi2CBUyF7ulVT96RS3KhnEHwocuJfa9eeCJfZjQjNNAADAjHBevh1KXQOhzoewGC5byj6I+A==
ARC-Authentication-Results: i=1; test.office365.com 1;spf=none;dmarc=none
 action=none header.from=microsoft.com;dkim=none (message not signed);arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcM+f2xQlq5wdk23MifDPmL4QlPsfonyzJl6sdlucXw=;
 b=bLcgC4b8oWrMhF/0jdBcUyJ9gncsLuFreo0eSPvaW2rlrrQUbwgugIK4PPt9uJEjIU3gZhAcPfh5cPI4YB+krGsNCQxHJlqZToe4OV905aJxlfKV9q4jx49uviuK8w4WdMo2cIlT6IFbm6sM8heaHCUGDS8XHL5JpryoQr8ZAn0=
Received: from BN8PR21MB1186.namprd21.prod.outlook.com (20.179.73.78) by
 BN8PR21MB1268.namprd21.prod.outlook.com (20.179.74.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.1; Tue, 16 Apr 2019 20:30:48 +0000
Received: from BN8PR21MB1186.namprd21.prod.outlook.com
 ([fe80::fd3b:ec19:62af:45a2]) by BN8PR21MB1186.namprd21.prod.outlook.com
 ([fe80::fd3b:ec19:62af:45a2%9]) with mapi id 15.20.1835.000; Tue, 16 Apr 2019
 20:30:48 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
CC:     Steve French <smfrench@gmail.com>
Subject: RE: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Thread-Topic: [PATCH] cifs: fix bi-directional fsctl passthrough calls
Thread-Index: AQHU8zDmFWmJJmKlhkqsxLV2O14cKaY/PsTQ
Date:   Tue, 16 Apr 2019 20:30:48 +0000
Message-ID: <BN8PR21MB11867D56B51DB9EA88747F68A0240@BN8PR21MB1186.namprd21.prod.outlook.com>
References: <20190415021352.30854-1-lsahlber@redhat.com>
 <20190415021352.30854-2-lsahlber@redhat.com>
In-Reply-To: <20190415021352.30854-2-lsahlber@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-04-16T20:30:45.7574657Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c25fb7ec-681c-4b53-a6e4-1ca439e4e341;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [24.218.182.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7bd536bb-9201-405a-0024-08d6c2aa6955
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600140)(711020)(4605104)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:BN8PR21MB1268;
x-ms-traffictypediagnostic: BN8PR21MB1268:
x-microsoft-antispam-prvs: <BN8PR21MB126843E7E3B31DF0CB88CB70A0240@BN8PR21MB1268.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 000947967F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(13464003)(189003)(86362001)(71200400001)(25786009)(6506007)(7736002)(316002)(486006)(10090500001)(22452003)(76176011)(6246003)(99286004)(71190400001)(186003)(53546011)(14444005)(81166006)(53936002)(68736007)(81156014)(8676002)(7696005)(256004)(86612001)(305945005)(3846002)(478600001)(2906002)(110136005)(105586002)(66066001)(106356001)(4326008)(9686003)(55016002)(229853002)(8936002)(74316002)(52536014)(5660300002)(476003)(26005)(446003)(11346002)(8990500004)(6436002)(14454004)(97736004)(10290500003)(102836004)(6116002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR21MB1268;H:BN8PR21MB1186.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CmB+6n2T0vDPdani69cvfoJ82azYBDYOOt1Xs7OZD4vHGrfV+A/jB1JvEIHE8aMjTqYMcve/369tmg5LWDDJog8QvmD5XZ/pfuaDr/RyXr/JIN+l4J1cr+WXfdQCKwC01Yvrve5Tq/LYVaBRGw7JLPibGcpzeuRO2dejgJJSLQZzvtfA9L8Oy2+b3LTMbdx/qlgZlcxD+b5xPyzfslnuMqamlCFa8IDFiZ4OuliaTMzMky2BGMEyfghJrhrFzQ+3//kYgfQhJ3UjeUHLI7lZThdAAlKViv+/tl52QMcN8vSd41CeSE+1yLQA2b9dvYAe6ptVyuVuqbvO92SSRBaoMbqnWapppvXHihqGOkQw0+QasZR0SB2A2hMstkFK/Pbh7ti7SJImAS30XZHLPdv5286qoPK/kbAYRwjeKsNfBBk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd536bb-9201-405a-0024-08d6c2aa6955
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2019 20:30:48.4909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1268
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>=
 On
> Behalf Of Ronnie Sahlberg
> Sent: Sunday, April 14, 2019 10:14 PM
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
>  fs/cifs/smb2ops.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0b7e2be2a781..2824b97c5869 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1462,12 +1462,19 @@ smb2_ioctl_query_info(const unsigned int xid,
>  		io_rsp =3D (struct smb2_ioctl_rsp *)rsp_iov[1].iov_base;
>  		if (le32_to_cpu(io_rsp->OutputCount) <
> qi.input_buffer_length)
>  			qi.input_buffer_length =3D le32_to_cpu(io_rsp-
> >OutputCount);
> +		if (qi.input_buffer_length > 0 &&
> +		    le32_to_cpu(io_rsp->OutputOffset) + qi.input_buffer_length
> > rsp_iov[1].iov_len) {

I hope this isn't a dumb question, but I can't readily figure it out due to
multiple layers of #include nesting. Is le32_to_cpu() signed or unsigned?
If it's signed, this validation could still be attacked.

And second question, is the fsctl output payload always guaranteed to land
in rsp_iov[1]?

Tom.

> +			rc =3D -EFAULT;
> +			goto iqinf_exit;
> +		}
>  		if (copy_to_user(&pqi->input_buffer_length,
> &qi.input_buffer_length,
>  				 sizeof(qi.input_buffer_length))) {
>  			rc =3D -EFAULT;
>  			goto iqinf_exit;
>  		}
> -		if (copy_to_user(pqi + 1, &io_rsp[1], qi.input_buffer_length)) {
> +		if (copy_to_user((char *)pqi + sizeof(struct smb_query_info),
> +				 (char *)io_rsp + le32_to_cpu(io_rsp-
> >OutputOffset),
> +				 qi.input_buffer_length)) {
>  			rc =3D -EFAULT;
>  			goto iqinf_exit;
>  		}
> --
> 2.13.6

