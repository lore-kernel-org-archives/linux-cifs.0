Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.95
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792845380;
	b=Xz+3qxyylNplqJmLaE2igr6DbEsuyRKJu5dC0m4eKN/fCa1ySmjkgimwROjhCgLRcI69
	 VeOLjL7OPxUxfVclf8+/U7udTOxCGnNxBzyzlzMb9fXeQDnrcUQLnQDHJKBNJtJJRAFBC
	 mWcFkqbPgZccn0dmMtQMvfqBSM1a/u9V5CeOqY946jNKwb3wQ7/UJsEOQAKrbxG8iBVMo
	 wF+PJawu30uAwhgos42Uygu93IOmCMFWU1418LcgaZqNnxMXfc8EYV1HoPrkmUfq6+MAE
	 MfAOBY58EYKrgWZnZuatQHzBzF/gWmTsd3bt0F34n9BJMpQNDTBCIYzms3Vj3NTTxxg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792845380;
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
	bh=E6x2C4ed46QgklsY33q8+PIVEWQQ+i2A4Y9A2oWICjs=;
	b=AZ/4kSgmVIvNRq9PXt16rYbcxEO9UzdbfFq5FQXlK2HD//CY82RgevPrqxlBZo23Djik
	 nO9W0ULg5O1lKOIPrsOW9riDo4uGeRPPmyToJ3JVhYJnlfDDmWuehNMJdynS//cJ22UFH
	 /Aycahgc8oAMIngDZoLgfMCijIeWfJcjeZOr5bpxfYjNwNE8Jofvr8va75CApxGCHc9Ry
	 95QHIzN33vWrvDhCdYGKG4WVDrISA+se6r1+STQhyInKmnkTwpuvuzzo95ztCrfOQxwqQ
	 u443KT/kgSyc8/sjnXRUvN93nxp0CWtbWvb9dJKAZcYThuG2xCfAQGfgSjBcYCmDFnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kuleuven.be;
	spf=pass smtp.mailfrom=kuleuven.be;
	dkim=pass header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=fld+7UfP;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.84.95
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020095.outbound.protection.outlook.com [52.101.84.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B0F606A31A
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 12:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00B0F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kuleuven.be
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=kuleuven.be header.i=@kuleuven.be header.a=rsa-sha256 header.s=selector1 header.b=fld+7UfP
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A48LZ0ZUqOx/xTQQ65r21gJrGDjP7eMboVXneV2W1DcnHV2DlTbjYf5M6FO5roq2P3T3dTdwPC4g5gXDknV5Yy4ENwaWg44xRk186yMQwxFJ/AXUVL61zNmGFTtLviiXlnRpszIvdNYy0M4VyKOB7FJ1cQVaZT30TiRHAO/qu6J9fyHAAQEkznxcplWXpHuEaX/UFnuopIhQIsv8PVCRhu4nEl6Z+nj/FFDuGFiX37hNFj1kkISEArHfMqkVk4Arf/B+2PBXkuZJCOaHzlQ2N0VY8on+ro24Nge3Cw7U7Miqm2P5360sImQlKUWL2N559VyFT7xbDCyXLjPvTm+V2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6x2C4ed46QgklsY33q8+PIVEWQQ+i2A4Y9A2oWICjs=;
 b=TOy4uUagW6xuW/niHftNJU9KB9vpPrznK0KCArSQD9LbTgxH35SewYkE88qjmJjIYbGxYaHnq/h3MjsXak/cV/7QX2l2f/vsW4OIXmYCGj2qw9dlY8+oI6uQQM+KwOpu+NpRO26Yxdp1yKjmunOZxNCob8DkkzvfJFlOJTutA7DcVh2qvmHw7qP4U+H6ugcuAMusI9pK80Zmqy+aVa6YcdXWwpkd0aXA7E91sQxDtyoxSehJVpvMdF02wHJ+1IV/ALy4LQMArXqTBZDeONQAgtRaKo9goSuAt26dzPIrwU3jYjyrG8O5Utj3NrLh2kzl3XYcj9hpj3OYXTqL1O4pzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kuleuven.be; dmarc=pass action=none header.from=kuleuven.be;
 dkim=pass header.d=kuleuven.be; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kuleuven.be;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6x2C4ed46QgklsY33q8+PIVEWQQ+i2A4Y9A2oWICjs=;
 b=fld+7UfPTHXBZbk1JD2v748tFl/Rqgvz93hez52QrrzsxZSgUYMhUtG+GrCz+w+fl9+WHTxta9hLU/D+48bi6o4sFIWc3UCzkVHCgeHAI8YOwjJUZQbWs327tYi8t3I04oKkKTbhHvjuYV3A+f9XvT11ikPwAqGBU78KukLSf9c=
Received: from DB5PR08MB10062.eurprd08.prod.outlook.com (2603:10a6:10:48f::10)
 by AS8PR08MB5927.eurprd08.prod.outlook.com (2603:10a6:20b:292::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.21; Sat, 24 Oct
 2026 12:36:15 +0000
Received: from DB5PR08MB10062.eurprd08.prod.outlook.com
 ([fe80::cd17:89dc:ddbb:2f38]) by DB5PR08MB10062.eurprd08.prod.outlook.com
 ([fe80::cd17:89dc:ddbb:2f38%3]) with mapi id 15.21.0546.019; Sat, 24 Oct 2026
 12:36:15 +0000
From: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
CC: "pc@manguebit.org" <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2] smb: client: validate SMB1 EA list bounds before parsing
Thread-Topic: [PATCH v2] smb: client: validate SMB1 EA list bounds before
 parsing
Thread-Index: AQHdY7P4BJGorWzOi0aRoFw3dBkOdg==
Date: Sat, 24 Oct 2026 12:36:14 +0000
Message-ID:
 <DB5PR08MB100624D4B388FF7946505BFDEFD632@DB5PR08MB10062.eurprd08.prod.outlook.com>
Accept-Language: en-BE, en-US
Content-Language: aa
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kuleuven.be;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB5PR08MB10062:EE_|AS8PR08MB5927:EE_
x-ms-office365-filtering-correlation-id: a9484f33-74ac-47e8-7615-08df31cb64db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|786006|1800799024|376014|10070799003|366016|23010399003|38070700021|260925021311599003|260925022911599003|260925021911599003|11063799006|56012099006|261009223027099003|261021123027099003|261021121427099003|261022105027099003|261022075727099003|261021135927099003|261022115727099003|10067099003|18002099003|3023799007;
x-microsoft-antispam-message-info:
 XREaQKYuvv/fXbiZuQVINWfyZcsWa+hXQF27oOyx4iKRlSdITypfeUi6XPDAkt6bBE1BFAesjg8paH4rwEYm0ZBQ7fu0CFu7huqFrxC/9h/SkkSJN2XvK9aFLPxBb2g47ZtiV9bCsDKioTt2wb8IAlyrv/1q4sNXnycGs2cbOpB6hI8wJYacT260Y0a2F3da8micFuSsSicgsyCZb4skyCj83vaDbIOG9zgClnYGL0pfY5UVRikCCEeul2gE1pa1rGlwAsQSCAIGT9Ws+nxBB1/lu8HkDPnx4e0por43L+nGqylrKDxsEf+3PF0FuX7v7VHkAjJyAL3AD+bQuX9t6q+C3yUrXWtSFlnPnjbVuA5LV4krMf75LDi3vxmps+YhT3GS39j0Y+SLtDqyNaZ9xkCU69qrk3Eo8+c+Q2/F0QTTpr7HJBt0LOBy67VExRwG8rVDQVWaTilJcOi75cA+Lj0H3dSSoJnQlrqQbXetjWfEO9/aI2FtKgzq0E9khlgDqDIuzouUFpzuhQMMlwufjs48eVItj9/ksSOr4N0hRHJeRY3Fnbj9e2XMkzXWWNxXaak8o6QWC6jgINWGtImCz0MPOjeQIBG3oEIN9S4iiCBzJAUlcYg8P+xZuJLzgLxaroZ7bhOdn4tvmHoQ0OzI5xBxn+R077a4pMBBVpS1Pj2Lma0auHHevYV/OW1eGUXKYO3tr1HBGQoJP8WpypWGSYhDjxTvWBe9y28CU1Qfa8c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB5PR08MB10062.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(786006)(1800799024)(376014)(10070799003)(366016)(23010399003)(38070700021)(260925021311599003)(260925022911599003)(260925021911599003)(11063799006)(56012099006)(261009223027099003)(261021123027099003)(261021121427099003)(261022105027099003)(261022075727099003)(261021135927099003)(261022115727099003)(10067099003)(18002099003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?z6I9PhnLdYyUr80mfoHGuU8b6xMILYqAYh1kyKjjwS3Ez+8QkI/HzFk36uIs?=
 =?us-ascii?Q?WxECqCab1S4adc+c/F6vWaSgNqUmr1Eoiurdy1W1/79chAH8M5131RKfwH5U?=
 =?us-ascii?Q?vCYzWulHl2gGfSWRAuTfzYfAv6uRbHcB14pvIXsahELIZ/NW1CKJWRtLt/EW?=
 =?us-ascii?Q?zev/EYWgIejfMhcMpwvzZ9f72OwbkyzrAY+WvrCmQch9Mq9xTlJqP2iqCk+z?=
 =?us-ascii?Q?L2zsAI5GP6PIgBmFF4NPEk85jIXOKQNElZKazJc+shk2P/eeVl3kdRzh2WXm?=
 =?us-ascii?Q?DamRkEyb6WTvE13CZlaT4CXQ7kSEnY6zxtKJF/3RaP2X5qwb+/ZtepiqQSPf?=
 =?us-ascii?Q?RsDYWRSdzCX5S6mpfcNSAQTocg+FrjbxJQmzjyY94Nuq3BiD2XfWEracM31j?=
 =?us-ascii?Q?yKRaqxiNMSkrhH08P7sTZHR+/Je9H1eLrKxXgRPmBJHcbVmyeCkTcNJ11GON?=
 =?us-ascii?Q?kOEQg/P5ScQ7Liimr1z4OIQOeNDp8O0wJyK/i4XA7gPmbu8cRXm+xpAa0nAw?=
 =?us-ascii?Q?tkbzTa+L/SPd4MSSCcADhyMWpqJASM6hzsLU/NxK2v9ehBzr6TxwYuciwagU?=
 =?us-ascii?Q?IH9MSpxB4Kn/Lc1BFE0ptc7iPF78XWPhGKd2Of6j+9FScqjyTKhji7r11yBw?=
 =?us-ascii?Q?eQCzawGsWOiYdDVlD/MglXma3MjVTLJTc9JNgPCKsxOJ4CZYVL/kcwliq2ej?=
 =?us-ascii?Q?pnlhokHds5XCsuGxeJ7Mo64V8uFgPS+pl+7uVUCu+MD6/MlPHFSjuq7amBd3?=
 =?us-ascii?Q?mQEoZl15eO4v+M2xa/HnAcEKMivJSQTD+rUpdpkklIxp6h8ECyrYpiGR2kpx?=
 =?us-ascii?Q?5yBjVeRrw6rTTva5i6e1y3xkGZzbCYnBG5A67+H+C8WKqFbFPQ5XXAUbsfDH?=
 =?us-ascii?Q?Axu2xEvJ/AK5NVGI86eZ+dfvTTRSMf1Mxt8BSUpImECPg12U+M9MKjOkIcd1?=
 =?us-ascii?Q?nXDJ+0OjNQVM4yxbkLxYe/3fVxzkradoRsMWM0YnLIbRaIaGtWDRUqi8hyj7?=
 =?us-ascii?Q?o3ZBbB4uU4U5ynNc1ATTsVuAE19/b0EcnFBo2nxKgSwls8kwNxKdCE2LajIZ?=
 =?us-ascii?Q?xF4ERb+moMnCDiyiT/MZMQM/NaykZLKYbww+gTdQhUvRcLPeoTiRUWZk0Yn0?=
 =?us-ascii?Q?UqOTlCe46wrxqNYhzksZ9f/NdF+nZOBAF7qbLbVkJw/dcvhXC7TKQ0xI8PQX?=
 =?us-ascii?Q?DY8FHpPfl9pgwJxpj0eWueOkV0DMKSOJFTXySb40TNHOYlm8EtUW0jyBAa4T?=
 =?us-ascii?Q?k3CNaAFJ7wLS6fDdjM5hETFLpBALXJqosdmpMB2gBuwPSqTbHWKEaPYpW8RY?=
 =?us-ascii?Q?OiE4uSlWONNLNabPq+cuKjlwLu8Vmo4MFctibVDK3IMDgS/3qxuNUfyjUKt5?=
 =?us-ascii?Q?zsTLj0zd6Ym8DO9A+pW5BjocsB2uTEyQ1G7stvuKiGQgB1+ceIorhYHpalpo?=
 =?us-ascii?Q?E0cv2UrergJ0zUUrwhXVccBLuRwzhabM6LuCGcESoF00Y7Q3Jko9RuM7C6Cq?=
 =?us-ascii?Q?fG6pA9VFiY6aOqyJr64I3lPkxmVxn0uF3jGf3pQo823DsQ26WXWFCUoCIyxd?=
 =?us-ascii?Q?sFV5pOgjf1tEc0UebB7ps5bMWekxWb6GMvPjeWKdkC4fx2kGkOG67JhxuKSM?=
 =?us-ascii?Q?jtPTNB+XbMUm8iKOXeUrkIaRtJenNzPxDnStpb91DP/WrmVPGCql/TwM3Ypk?=
 =?us-ascii?Q?alk1y4zyZPACHyNFhf/nvsytQRQFhkWz/ypsgqIgbYfxqxkzSROTI4yA0nKD?=
 =?us-ascii?Q?CW3e7tRk9oGgK/6XX6cNu6u0JMwSEVYn6ARLhnRlM0s2NS6z+GX8?=
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
X-MS-Exchange-CrossTenant-AuthSource: DB5PR08MB10062.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9484f33-74ac-47e8-7615-08df31cb64db
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2026 12:36:14.9737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3973589b-9e40-4eb5-800e-b0b6383d1621
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyuECSQl+GAa69kA3jhvH/i7GzuarYBtZrRvOTYaL1IZqZcge4BtVsTJ6bH9/hpsvw4yfqFlrDViFdMce7P4Ywte8rFjcPE//I/eILPa3g8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5927

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
Resent because my mail client damaged the whitespace of the first copy;=0A=
the patch is unchanged.=0A=
=0A=
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
+	u32 ea_list_len;=0A=
 	struct fealist *ea_response_data;=0A=
 	struct fea *temp_fea;=0A=
 	char *temp_ptr;=0A=
+	char *byte_area;=0A=
 	char *end_of_smb;=0A=
 	__u16 params, byte_count, data_offset;=0A=
 	unsigned int ea_name_len =3D ea_name ? strlen(ea_name) : 0;=0A=
@@ -6242,9 +6244,19 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_t=
con *tcon,=0A=
 	ea_response_data =3D (struct fealist *)=0A=
 				(((char *) &pSMBr->hdr.Protocol) + data_offset);=0A=
 =0A=
-	list_len =3D le32_to_cpu(ea_response_data->list_len);=0A=
-	cifs_dbg(FYI, "ea length %d\n", list_len);=0A=
-	if (list_len <=3D 8) {=0A=
+	byte_area =3D (char *)pByteArea(&pSMBr->hdr);=0A=
+	end_of_smb =3D byte_area + get_bcc(&pSMBr->hdr);=0A=
+	if ((char *)ea_response_data < byte_area ||=0A=
+	    (char *)ea_response_data > end_of_smb - sizeof(ea_response_data->list=
_len)) {=0A=
+		cifs_dbg(FYI, "EA list starts outside SMB\n");=0A=
+		rc =3D smb_EIO2(smb_eio_trace_qalleas_overlong,=0A=
+			      data_offset, get_bcc(&pSMBr->hdr));=0A=
+		goto QAllEAsOut;=0A=
+	}=0A=
+=0A=
+	ea_list_len =3D le32_to_cpu(ea_response_data->list_len);=0A=
+	cifs_dbg(FYI, "ea length %u\n", ea_list_len);=0A=
+	if (ea_list_len <=3D 8) {=0A=
 		cifs_dbg(FYI, "empty EA list returned from server\n");=0A=
 		/* didn't find the named attribute */=0A=
 		if (ea_name)=0A=
@@ -6253,14 +6265,14 @@ CIFSSMBQAllEAs(const unsigned int xid, struct cifs_=
tcon *tcon,=0A=
 	}=0A=
 =0A=
 	/* make sure list_len doesn't go past end of SMB */=0A=
-	end_of_smb =3D (char *)pByteArea(&pSMBr->hdr) + get_bcc(&pSMBr->hdr);=0A=
-	if ((char *)ea_response_data + list_len > end_of_smb) {=0A=
+	if (ea_list_len > end_of_smb - (char *)ea_response_data) {=0A=
 		cifs_dbg(FYI, "EA list appears to go beyond SMB\n");=0A=
 		rc =3D smb_EIO2(smb_eio_trace_qalleas_overlong,=0A=
-			      (unsigned long)ea_response_data + list_len - (unsigned long)pSMBr=
,=0A=
-			      (unsigned long)end_of_smb - (unsigned long)pSMBr);=0A=
+			      ea_list_len,=0A=
+			      end_of_smb - (char *)ea_response_data);=0A=
 		goto QAllEAsOut;=0A=
 	}=0A=
+	list_len =3D ea_list_len;=0A=
 =0A=
 	/* account for ea list len */=0A=
 	list_len -=3D 4;=0A=
-- =0A=
2.43.0=
