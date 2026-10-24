Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.79
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792812024;
	b=lwdXWQ/jRe4uCxCZhxEg4YSVuuma9tYSBPXkNVYiFnARy8B2xrRkg18RNVonrsifvrjj
	 RrIrnI9mxioEqFlMNl9xbed+xvR4z3X2QXpESC/kOOsUaMpRkaVNUk/NGXR4eL3q9ov/C
	 mUhgLR6buRhJbmo0p2iOKGRQ12pwOeT+9xojiEY1TWyNJlDa18PYg/GLqH/3i6Jda0qJi
	 r4ExTtnhqJqLq0R57k0fl/f36uaM4Ef8E/v6zrLEjy+M/tzsFbeOFMQ/V3jLMPfRmjG9/
	 +W2bhSIsM06tLazmLU2YtATLS/7HGclIZ+96M8kQjkEcSAe+h4jbAPMIzKjEjOREkQQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792812024;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=NW70m5uiIPUflEZVaWRmo1ZxKjRYNliyR5UwvMa1TuU=;
	b=ZnBlw2HvtDIo414omIj+Z51g15YoIoIo7OzYiA14gp6GoCuIMSYRtTO29RSmoTyUfdei
	 0fpJSi6bowZ2Oi2m9z4L7nJj5XJDXJDmghRV5WMG07dIu1X+ziHDgs1FGUOZuvGAQ3JDR
	 3fj6MWlVjFIS7cO6WGdnJXQnI5vtpIfQaHL1zaLtS50iwpifUHWNUMYzmRcEib6JpOHz3
	 pZ1HRsflR5Gm6sATwrm/VlcPn6CHkIk4/PyreaLCxxOFxIPNuwSk1tsRB+WdMHy/Vi80Z
	 1FcZ4ApeiiMb5+6LzQRxGXgsyPJ9Ty5PjhD0zrMTSk2yUOhh6VIspMP5G1HIoBiymIA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kuleuven.be;
	spf=pass smtp.mailfrom=kuleuven.be;
	dkim=pass header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=juSg1Z1o;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.79
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023079.outbound.protection.outlook.com [52.101.72.79])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D65C606A31A
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 03:20:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D65C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=juSg1Z1o
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OcY1b0baEeCRrdbeQu8I8l1ixpRwgg8xGN6zWmoERtHUBAH+li/OSfcQ5LJ4HutHEd7gICBNHWisGctUAFk4I8waN45ixzyjQgPjHtL91Jb89oOfYRce4MftoXsJuPDpsija+YCRb7C1mAa86v6x9NYLj2IQ61xsYIU+DZR8xucHv+e1+BCX+ftlbJ5qX4Rxcv1rUsaXtz+HJsJDlyLNlQ6v0b4qrwxV8Mk7AXmWqOuA/GPD735mqwjsk9axYqH3CM3DLhT3i03yMKKkUFz9P7q1xsh1AthvxEMAT5oMiOyQxpIXuQeAfUoOYobrGfF0oAlQHyUVc9ULNE2iKy5+FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NW70m5uiIPUflEZVaWRmo1ZxKjRYNliyR5UwvMa1TuU=;
 b=CizpJIQ22PsRR2CZbowAV9Ed0DwKxzrC4tz8I6dhkCdu+1nXEzYwfgVAG+9er43pEfpCSYPQfjYtQprPoWypmr3Z4d+gyKNJ65y6e/LGxP3vd7ssOq9a+NMXma5lC8rvgThKbKSxNwm6M6k80WBT0651MKMcd8yWflc50jEEtIlyp0yBGBZnZV1pxLAJLavWtfcaZNEuWexV7I573+RK3PkWZ1cldgaIB/N9g7nWMlSqHKAE3bq0whYUftqcskamMZ9BcJLroZTiFIGxIZfdz0iiHrKA+voxy194HSSaqwmQufeEWHznvekIB/gxQtCMnV4kW05Sh8QRjCckchzO4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NW70m5uiIPUflEZVaWRmo1ZxKjRYNliyR5UwvMa1TuU=;
 b=juSg1Z1oFN6/4pi08DDFSaemOIobug1ycPVuqaSMHWRgbudRsb/SKx6noWRfSgSHOTVHEOce8evQA7CC6H0ZZstZxS8hdymdzaQFKUcviEGoE6cStPAkdtxfuUeCYem9YUPiRt4a1s1OZJSjEZfZKzM/NW2jnHzVIj7I6fKkRfo=
Received: from VI1PR08MB10052.eurprd08.prod.outlook.com (2603:10a6:800:1c7::7)
 by AS2PR08MB9618.eurprd08.prod.outlook.com (2603:10a6:20b:609::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.19; Sat, 24 Oct
 2026 03:20:18 +0000
Received: from VI1PR08MB10052.eurprd08.prod.outlook.com
 ([fe80::695b:af9e:19f8:f0c0]) by VI1PR08MB10052.eurprd08.prod.outlook.com
 ([fe80::695b:af9e:19f8:f0c0%4]) with mapi id 15.21.0546.017; Sat, 24 Oct 2026
 03:20:18 +0000
From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC: "pc@manguebit.org" <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: client: validate SMB1 EA list bounds before parsing
Thread-Topic: [PATCH] smb: client: validate SMB1 EA list bounds before parsing
Thread-Index: AQHdY2ZgCvOouWZaNEGBe9ngqUqvEA==
Date: Sat, 24 Oct 2026 03:20:17 +0000
Message-ID:
 <VI1PR08MB10052CCEFC43090CE23365A45FD632@VI1PR08MB10052.eurprd08.prod.outlook.com>
Accept-Language: en-BE, en-US
Content-Language: aa
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR08MB10052:EE_|AS2PR08MB9618:EE_
x-ms-office365-filtering-correlation-id: 24814708-9545-4ea1-2c1d-08df317dba80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|786006|366016|376014|1800799024|38070700021|260925021311599003|260925022911599003|260925021911599003|56012099006|11063799006|261009223027099003|261021121427099003|261021123027099003|261021135927099003|261022075727099003|261022105027099003|18002099003|10067099003|3023799007;
x-microsoft-antispam-message-info:
 aupeu5tLdgJtCBulo2LAPEfn4lXkrtwUSMYXeOeDnwwn2Rx8nmypQy/aobSDXyN206RZtvVvmJ3tXTDmnyLR/yq0B01HwzGfH7S3HABRgMO5ycfiBBBCqOztEjrDp4gkvaCQgKo2DJ7PsPYhfKp4Q0sFsBjAJD/NHgOx5AXpQpv7vJ6LGm2bZ0ONVIhI+wbRYWPLaUIKOsSrDPvfU1Z68fORgSjhqqaSmYd/1H4l9u7IxrOTzSRy97w2LXg3dGVsx/tKrh5RXnjf1EnojhidaZVyRaz2+85IU6uWwRdsUMvfUWalTMDkG/OYWOxra4gRpoamlEmJmEqQwRfG8V33UlS1rNZUosvRmEd0V0WA2Zz27N4jFeF09eL+dkzXW5/lV6irdFmYKUVIlfzU2zCNGn3bg/fjgj5nUsuwF/JQAhCFiA+2wwO6K7TzFkdJfM0FWw6KNv2dkhiyH4PV7Kt9+SbOBhL7s5j6dPgdy6+t/vWt3f5yFOTtVzjgRmG3sNwqwVtkWXkLprmoK5s0VrVT/c6Cc7LRDxfzBHK3nnClI4purXHiGVq8bnufM10/6/Zph6l1mRcGhP4vd6csM8V2IYO0pts2XkXD3Mt4qLs1/T2VZM7Q71bTI4sUIzXXxVIIdP6dzArHPy/ZQ+Kih6Am0Xny8BEbg7/4FlwZd88UQgaFeDHgnLWkv6A5yNSLyQncH71TI46LzOMUXYSEcOMdy9QNBf1nIm9+vcyeBh3c5JM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB10052.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(786006)(366016)(376014)(1800799024)(38070700021)(260925021311599003)(260925022911599003)(260925021911599003)(56012099006)(11063799006)(261009223027099003)(261021121427099003)(261021123027099003)(261021135927099003)(261022075727099003)(261022105027099003)(18002099003)(10067099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?r6N8xZWSzeFbQvAX9VqAJFxdzlJtMCWasGRO1aZ6sW2eJIuRJusDhSQ7D42S?=
 =?us-ascii?Q?Ppk7iU5BHMAGLefQIqVcjOTJ2ReOsHVcp4UqeJZMWPAFawDjtXGvcDQYJmXW?=
 =?us-ascii?Q?uJm0yD+P2Brg5DSk6rKucDIwovJYN1IVC1sWt5DAM/g4GUNLDtZ0kXEA3Wy1?=
 =?us-ascii?Q?8KuDQGUU3MvisR9EdN5szMe16LgPzcaXQoXZtHeRhFb0mnC1+6xBEeTIzCAp?=
 =?us-ascii?Q?Vp2yqKGxQ+2TgbOhZe81NsnZECuCSYUBRLd990dOB4MXSoFoKLblSGDa2OYl?=
 =?us-ascii?Q?o5ZdxWq9/WgIs2sUR6zrcosmIouUXiDPQ2Zr05NSBD1qFeoF0neH9dYzaMzD?=
 =?us-ascii?Q?5nt19lS4lA8+t8NMHY1UGk1noNb4c7aO7QKlx3dluJCYXCWlBjLvLP4yAEFy?=
 =?us-ascii?Q?FnOFiLofKB8hj/IMrEK1j21i7bjtmCTsO6XdMF0AJdPYCBgUOaMlUfDV81Rh?=
 =?us-ascii?Q?CJ1KvPf3s+VctuGhDQYX6nYhzC0TlwhM0P7sKonE9KOvQkKyGPXFTXwmozBN?=
 =?us-ascii?Q?RQ/9rSaH3PdFbQtQJINzSetgILnwcxbJUwSyeGtV4vEwWZhw251vHm9KY3YW?=
 =?us-ascii?Q?mM4fzlM5PuFEo4qpcxSkX2wBJUJ3il/qfMEwpoXwlgk4a7JTSexPaBRUEh1N?=
 =?us-ascii?Q?vYggtw3Cs2fmJveHkKz5APwAv7BdNbdrnqFdbCqpZuoDokHPXio1+ZsC+lD6?=
 =?us-ascii?Q?toYat4hU2fJz0u8iIBksWptbdcOdTOe1b8neGFAwuR/xVH+NMD+jq7EvejoV?=
 =?us-ascii?Q?JHpoy5EuNdxKQccX8Vfy1Oe/HIF8XE0ulgDCHe6VUZnPVETdoEMRbbqJRJ55?=
 =?us-ascii?Q?z/jlIdTECqoUYsp0TsBwJKwjCzc3fNqE+KSr/JbLXhkLbO6FdoFmYjEOvcFp?=
 =?us-ascii?Q?U7/Zp+BK6kewiqFa+lWc6ZR9I/SWY5RY3QQA+XLAgPiPjxEKaAS32b0WBHMR?=
 =?us-ascii?Q?ayjgue3wYjS3ch9ADosATVb/Cy9BrL08oEKwYbtCZuBR9gLJQKVU2L+c7PYs?=
 =?us-ascii?Q?UPJwIUjsPO3dymCaxKOo5qJAzEnEZXTSKPe3Gl8I2c2KZGZYkGyKmNsG17Ck?=
 =?us-ascii?Q?mCZdKha6CQJO6OMpAVpw+2PhOA+fU2TE4BVdPjyig8ZNhZJr+dkM4MPSkeFk?=
 =?us-ascii?Q?1Z/edJynEXECeDNajr7zBWWiCEJfjCqz7J4GXXQdw+uLRFILHXFIbsrvYF+3?=
 =?us-ascii?Q?D5ehYbsZypsW/Yj4Kp3/CL3OpyCktJ8wvIp5sSKZgHMnaM9TQYfMkvm6ulht?=
 =?us-ascii?Q?7Ge4/7DHI/9j5vr841UU8l/dYd8UvwQnxcVXSodamEraS5Y0K9zxT1x+iWt1?=
 =?us-ascii?Q?0rcXfRGh+s27sxkvb39ePEI55DYbCToV8BsBXsJ1e7c5SLP63mU1X05f2uoA?=
 =?us-ascii?Q?my6YVz4xdOnz5T2SCCm1jsExBRyfeduyVsVKvsAGzwqJrB6P649b2uRA9pdb?=
 =?us-ascii?Q?YRIlaTkvY07s7TukATuFKyaVCsgJldTxOKRBHp4Hw4Dyq+Et20HzdpBw97he?=
 =?us-ascii?Q?BULXeGdUsecXQ9skgtIzdlPDH4cmjdkFMvU+6jcKEfy8p6XmIyghe7LQUkaC?=
 =?us-ascii?Q?TD4kvNXr7JQqK4/oLR2RIfjJYZ1xGV8qcyuVTUQ9gsyYPN5u1sGSaHPr+pyn?=
 =?us-ascii?Q?tlFXzTevJqWghvdWu76IOJD70r+nUF++AQ7qhMsQO4WE6BxD+gjxBF+bq+Q4?=
 =?us-ascii?Q?MomVFq1vT+dnjd3kzeYztdZxE1PZVhiAvv0xWOG7xSWFRMlTJIgsSDhksGwK?=
 =?us-ascii?Q?/WVMwCJ1hA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: kuleuven.be
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB10052.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24814708-9545-4ea1-2c1d-08df317dba80
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 03:20:17.9189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1gydJowxifElwtCIC16ZbXiK0ms+h5e8XDMDNLOJBDYnt2Jy+Is/y226eJhvFYVDzYsNJHl5BBHzAcmkDJOe1yXqdwemCG72FvzDCOhqEd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9618

CIFSSMBQAllEAs() checks the server-provided EA list length by adding it=0A=
to the response pointer. On 32-bit systems, a positive length can wrap=0A=
the pointer and pass the comparison. The parser then walks outside the=0A=
received response while reading the next FEA header.=0A=
=0A=
A response with a list length of 0x40000000 reproduces this as a native=0A=
i386 page fault and kernel panic from listxattr() against an SMB1=0A=
server.=0A=
=0A=
Check that the EA list starts within the SMB byte area before reading=0A=
its header. Keep its length unsigned and compare it with the bytes left=0A=
in the response without pointer addition.=0A=
=0A=
SMB1 is not negotiated by default and requires an explicit vers=3D1.0=0A=
mount.=0A=
=0A=
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>=0A=
---=0A=
 fs/smb/client/cifssmb.c | 26 +++++++++++++++++++-------=0A=
 1 file changed, 19 insertions(+), 7 deletions(-)=0A=
=0A=
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c=0A=
index 6dddbd84b93..9843639833c 100644=0A=
--- a/fs/smb/client/cifssmb.c=0A=
+++ b/fs/smb/client/cifssmb.c=0A=
@@ -6161,9 +6161,11 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_t=
con *tcon,=0A=
        int rc =3D 0;=0A=
        int bytes_returned;=0A=
        int list_len;=0A=
+       u32 ea_list_len;=0A=
        struct fealist *ea_response_data;=0A=
        struct fea *temp_fea;=0A=
        char *temp_ptr;=0A=
+       char *byte_area;=0A=
        char *end_of_smb;=0A=
        __u16 params, byte_count, data_offset;=0A=
        unsigned int ea_name_len =3D ea_name ? strlen(ea_name) : 0;=0A=
@@ -6242,9 +6244,19 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_t=
con *tcon,=0A=
        ea_response_data =3D (struct fealist *)=0A=
                                (((char *) &pSMBr->hdr.Protocol) + data_off=
set);=0A=
=0A=
-       list_len =3D le32_to_cpu(ea_response_data->list_len);=0A=
-       cifs_dbg(FYI, "ea length %d\n", list_len);=0A=
-       if (list_len <=3D 8) {=0A=
+       byte_area =3D (char *)pByteArea(&pSMBr->hdr);=0A=
+       end_of_smb =3D byte_area + get_bcc(&pSMBr->hdr);=0A=
+       if ((char *)ea_response_data < byte_area ||=0A=
+           (char *)ea_response_data > end_of_smb - sizeof(ea_response_data=
->list_len)) {=0A=
+               cifs_dbg(FYI, "EA list starts outside SMB\n");=0A=
+               rc =3D smb_EIO2(smb_eio_trace_qalleas_overlong,=0A=
+                             data_offset, get_bcc(&pSMBr->hdr));=0A=
+               goto QAllEAsOut;=0A=
+       }=0A=
+=0A=
+       ea_list_len =3D le32_to_cpu(ea_response_data->list_len);=0A=
+       cifs_dbg(FYI, "ea length %u\n", ea_list_len);=0A=
+       if (ea_list_len <=3D 8) {=0A=
                cifs_dbg(FYI, "empty EA list returned from server\n");=0A=
                /* didn't find the named attribute */=0A=
                if (ea_name)=0A=
@@ -6253,14 +6265,14 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_=
tcon *tcon,=0A=
        }=0A=
=0A=
        /* make sure list_len doesn't go past end of SMB */=0A=
-       end_of_smb =3D (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr=
);=0A=
-       if ((char *)ea_response_data + list_len > end_of_smb) {=0A=
+       if (ea_list_len > end_of_smb - (char *)ea_response_data) {=0A=
                cifs_dbg(FYI, "EA list appears to go beyond SMB\n");=0A=
                rc =3D smb_EIO2(smb_eio_trace_qalleas_overlong,=0A=
-                             (unsigned long)ea_response_data + list_len - =
(unsigned long)pSMBr,=0A=
-                             (unsigned long)end_of_smb - (unsigned long)pS=
MBr);=0A=
+                             ea_list_len,=0A=
+                             end_of_smb - (char *)ea_response_data);=0A=
                goto QAllEAsOut;=0A=
        }=0A=
+       list_len =3D ea_list_len;=0A=
=0A=
        /* account for ea list len */=0A=
        list_len -=3D 4;=0A=
--=0A=
2.43.0=0A=
=0A=
=0A=
Yours Sincerely,=0A=
=0A=
Ratnaker Gautam=
