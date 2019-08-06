Return-Path: <SRS0=QbqR=WC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89C95C31E40
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 15:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CDBB20717
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 15:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="lXKjAvZA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732952AbfHFPS3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Aug 2019 11:18:29 -0400
Received: from mail-eopbgr790111.outbound.protection.outlook.com ([40.107.79.111]:4944
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726713AbfHFPS3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 6 Aug 2019 11:18:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxAUT7IFwBptBLw7j9/Lv20Cf7UGnHavdAH38wUBnLJMtdM1eMWA0x995x3kirYb3E8Tr5KnnCgzPsnUcv/N+7j+JCduLlJlubbzNouVdt9og+vTEGE7fKc6SmFDDFDhiOySEGaqEfVp8jTQvZFAsr/wgNcNTM6O23gQCNgmBPDUrX9YfV2hwPrLe8v9TuBzsG2gNkmgtur6L7FA6LufpsK2yHNtbh4HejPJIc+MoYWLDu2mIjGzFPNSx2x8mm5hrpvtaWtmrh8KbDoRshRWjRrY0GLiLlyl8xQ16ESC4D4VTPu0P1gwCZYpk/n5ABBzRJGW8D0wP3BAciIq+diIhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vbhk1JUJjMmSTNmW2aoWGGd8QjjGNkAcSHyDBt5qLJE=;
 b=FbpLnUYF0RKD4cO1RUzjO9j0kRFVzwZNxw+s/zJx+x/c3DdL5mnujrGDtwo+QiX31iomaAej7OdBoc1UM8pktUbPm6a0HIv/TY2VO1h0SWzhKt9V4bblkTXUQu614RSJFg4U5fQzRF8RCFyWn+NXGIVfHNp3W+sDviS7TC56Rb1Ae9+auMr4UnQQTJjFqJkStUfY1LxtUjbnvabk+Z6wpnN4ig+PB1AuWv4ffnY+FW9zS6l+oFST2LyQvqtrDss3Fa3rZbThoWroRYDNYQUhRoXeG1DrkAn4wJXJQr5tOvcNGulWj/2CXKrfsLFR0KndgPv7Mnh3izDbWeNOyrpPiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vbhk1JUJjMmSTNmW2aoWGGd8QjjGNkAcSHyDBt5qLJE=;
 b=lXKjAvZAFUgOZkZlg+fq2JCCSeUTXb6zSzaEEGTHGjf9BwuWNHyWjLWOpeUGqUnuNxvG+k5Jm3b9vN76kRjoGf44r3/GQcE93p+Mx4PajxeoNra/1ZqR9y1zm+zNARY/UpId3xLCR6W1vxMSq3FEEB7afkJQ4bdJdXkM1iMlzJM=
Received: from SN4PR2101MB0733.namprd21.prod.outlook.com (10.167.150.161) by
 SN4PR2101MB0735.namprd21.prod.outlook.com (10.167.151.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.2; Tue, 6 Aug 2019 15:18:26 +0000
Received: from SN4PR2101MB0733.namprd21.prod.outlook.com
 ([fe80::a5d7:a038:f63e:bf3d]) by SN4PR2101MB0733.namprd21.prod.outlook.com
 ([fe80::a5d7:a038:f63e:bf3d%9]) with mapi id 15.20.2157.001; Tue, 6 Aug 2019
 15:18:26 +0000
From:   Tom Talpey <ttalpey@microsoft.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
CC:     Steve French <smfrench@gmail.com>
Subject: RE: [PATCH] cifs: do not attempt unlink-and-retry-rename for SMB2+
 mounts
Thread-Topic: [PATCH] cifs: do not attempt unlink-and-retry-rename for SMB2+
 mounts
Thread-Index: AQHVS9+wyCF12HsmFUi4Qjm9BQ8A9qbuOsbg
Date:   Tue, 6 Aug 2019 15:18:26 +0000
Message-ID: <SN4PR2101MB07334B83742BE57988263F7CA0D50@SN4PR2101MB0733.namprd21.prod.outlook.com>
References: <20190805224639.2322-1-lsahlber@redhat.com>
In-Reply-To: <20190805224639.2322-1-lsahlber@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=ttalpey@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-08-06T15:18:24.8571323Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=880e6134-6e08-48b4-aef6-b3cef36cb961;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ttalpey@microsoft.com; 
x-originating-ip: [2601:18f:900:cff6::100d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c33b06ce-a6fe-497e-91f2-08d71a815463
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:SN4PR2101MB0735;
x-ms-traffictypediagnostic: SN4PR2101MB0735:
x-microsoft-antispam-prvs: <SN4PR2101MB073541BA74D6218F22168448A0D50@SN4PR2101MB0735.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(189003)(199004)(13464003)(305945005)(25786009)(446003)(4326008)(11346002)(9686003)(68736007)(8990500004)(186003)(46003)(76176011)(6246003)(53546011)(486006)(8676002)(86362001)(81156014)(5660300002)(256004)(10090500001)(229853002)(110136005)(476003)(66946007)(52536014)(7696005)(6116002)(102836004)(33656002)(66446008)(14444005)(6436002)(55016002)(66556008)(81166006)(478600001)(66476007)(71190400001)(22452003)(14454004)(99286004)(10290500003)(64756008)(8936002)(53936002)(2906002)(71200400001)(76116006)(316002)(6506007)(7736002)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR2101MB0735;H:SN4PR2101MB0733.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fO/xOZH+HA8x+1hv6psfg2YRV68HSZB6o8psvt++15NdEeG4O0tH2sSgY8ZcGPkSFuwReKzUDoxvEgXUNcMAH44zgML+vo/D2e5efVO5ACXFyo3dlD8xBvVIFwba5/6UU2fqWmgPLnpIcineuMM879XNQMlMDdUJOoa3F7E96MHRFEQOtp6PlqWJnznwexJWOhRSn+fgq2H9rgT46egd46yxwH0WkJPfbW4ZkidSTampjIR1n4jSBXqMjpH3hxKn6DTRqo1mqNM8A5nBL5MESNfYn8/yz94CiWZCrwm7xVahw3N/QeieU2SOFXlDD8O9xR4Ga/dvL3q/aKWNe0BngQrZxRHNmWwwcyuJKwqOdYtGu4ti3gZJzF/Bt5YFyRIuK6vGmGUlqRvFbWvoNjAPeFJS4PcBZ3BQJdCMQtGPTaA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33b06ce-a6fe-497e-91f2-08d71a815463
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 15:18:26.3110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mbuU2LO/xKp/nkgqTT5OX/cYWXtR8r8tS8KEnzVYoaDOHT9Q/wwClP9feLw9m0JzSuctrWX0sWjb9+jILSIuwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR2101MB0735
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> -----Original Message-----
> From: linux-cifs-owner@vger.kernel.org <linux-cifs-owner@vger.kernel.org>=
 On
> Behalf Of Ronnie Sahlberg
> Sent: Monday, August 5, 2019 6:47 PM
> To: linux-cifs <linux-cifs@vger.kernel.org>
> Cc: Steve French <smfrench@gmail.com>; Ronnie Sahlberg
> <lsahlber@redhat.com>
> Subject: [PATCH] cifs: do not attempt unlink-and-retry-rename for SMB2+
> mounts
>=20
> Normally in smb you can not rename ontop of a destination that is held op=
en
> except in SMB1 where this is allowed IFF the delete-on-close flag is also=
 set.

The FILE_DELETE_ON_CLOSE flag doesn't really have any significance in the
protocol, it is passed to the underlying filesystem except in one special c=
ase
where the server validates that the DELETE or GENERIC is granted on the
share. Did you find some reference in the documents to the contrary?

In other words, I think the fix may be ok, but the server->vals->protocol_i=
d !=3D 0
conditional may need more thought.

Tom.

> This special case is not supported in SMB2 so should not attempt the unli=
nk-
> and-try-again
> since the rename will still fail but we now also delete the destination f=
ile.
>=20
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/inode.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 56ca4b8ccaba..fdea45267a39 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1777,6 +1777,7 @@ cifs_rename2(struct inode *source_dir, struct dentr=
y
> *source_dentry,
>  	FILE_UNIX_BASIC_INFO *info_buf_target;
>  	unsigned int xid;
>  	int rc, tmprc;
> +	struct TCP_Server_Info *server;
>=20
>  	if (flags & ~RENAME_NOREPLACE)
>  		return -EINVAL;
> @@ -1786,6 +1787,7 @@ cifs_rename2(struct inode *source_dir, struct dentr=
y
> *source_dentry,
>  	if (IS_ERR(tlink))
>  		return PTR_ERR(tlink);
>  	tcon =3D tlink_tcon(tlink);
> +	server =3D tcon->ses->server;
>=20
>  	xid =3D get_xid();
>=20
> @@ -1809,6 +1811,14 @@ cifs_rename2(struct inode *source_dir, struct
> dentry *source_dentry,
>  			    to_name);
>=20
>  	/*
> +	 * Do not attempt unlink-then-try-rename-again for SMB2+.
> +	 * Renaming ontop of an existing open file IF the delete-on-close
> +	 * flag is set is only supported for SMB1.
> +	 */
> +	if (rc =3D=3D -EACCES && server->vals->protocol_id !=3D 0)
> +		goto cifs_rename_exit;
> +
> +	/*
>  	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
>  	 */
>  	if (flags & RENAME_NOREPLACE)
> --
> 2.13.6

