Received: from esa.hc1803-32.eu.iphmx.com (esa.hc1803-32.eu.iphmx.com [194.165.193.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B7E219E9E
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 12:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=194.165.193.227
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739795241; cv=fail; b=OuS8A9wrrTYYA/Zpwm/VNI0gFzDiEETKySSTgtRYN+TIaHyi/Ox7s/iCGbkyWUJaNBspPUH7xh6DJi0kbsQvZYeMVsLcfIJVT9WL2G8wahdAcIAlLLCHjzAYpU3+oFBNrQEagtP8DxGO67aWYuiqO/+cG+s7uVUr3wnO8bec0ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739795241; c=relaxed/simple;
	bh=64HrDDFEXBQhbFiaQ/JL1K5ha+4YYc+9ZCyA23JCP3M=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cHZyfSVMSkH1UJqJYocbqBx0uF83Z+bTWSjPIagu45aZQHJ8ytdER1Ds9bL5kQYW0FesnqxiL1e/a3inVzDRxKDzYac9ndNkz4tm56EhzkrjCzXEn2KdfrwkD7fQ5aoHCItoFg1fqMH85aQzT6mi5w3lMNM/lQr2phWaCZIzAFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kistler.com; spf=pass smtp.mailfrom=kistler.com; dkim=pass (2048-bit key) header.d=kistler.com header.i=@kistler.com header.b=PkN4qEOx; dkim=pass (1024-bit key) header.d=kistlerinstrumente.onmicrosoft.com header.i=@kistlerinstrumente.onmicrosoft.com header.b=eRfLhsZF; arc=fail smtp.client-ip=194.165.193.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=kistler.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kistler.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kistler.com header.i=@kistler.com header.b="PkN4qEOx";
	dkim=pass (1024-bit key) header.d=kistlerinstrumente.onmicrosoft.com header.i=@kistlerinstrumente.onmicrosoft.com header.b="eRfLhsZF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=kistler.com; i=@kistler.com; l=8044; q=dns/txt;
  s=selector1; t=1739795239; x=1771331239;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=QcK4WRuEDk7aobfOGiK5Hzezm0FPa0U9DjF1s6+h/MY=;
  b=PkN4qEOxp4ob6X/xFpw0N4ya5Hb6r8XoAVgQ3VJ+mQA4KkS20Xc2FhrB
   f2lEgfJ4BYAMfiVSAvQWXxKsGu0dLXea49TA1k3c/s4hvGmUcN9PPp0RB
   mD1uMjHV0P/4am0bEq8WW1orm0+JiCfuztXapozoCs/whqpTZb+XSb5sp
   vJoN7F6c0Go4UhUcyvTkfyukj0QoFUOT8esnvVxIzdws6MXxNWVkKQgmN
   KytsjXbw6+dE/vvYKGQzUfDRhFQ5zghHH9nlkHJplvZWTYMidsUdDK9Vc
   mq0Ajh51XcAcvPkPmFkTPcPkUbaceK1Eyzx1V+VC+//tUedtZ6yelSsgR
   g==;
X-CSE-ConnectionGUID: MrhQP97CSbSZt43HdBWNKQ==
X-CSE-MsgGUID: v0uF/RjaTLGhuEdRaGIifw==
Received: from unknown (HELO sl-win-seppm-1.int.kistler.com) ([91.223.79.46])
  by ob1.hc1803-32.eu.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 13:27:17 +0100
Received: from esa.hc1803-32.eu.iphmx.com (esa.hc1803-32.eu.iphmx.com [194.165.193.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sl-win-seppm-1.int.kistler.com (Postfix) with ESMTPS
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 13:27:16 +0100 (CET)
X-CSE-ConnectionGUID: sy1EW8CUQyeG1awQrWg/bQ==
X-CSE-MsgGUID: AQeyONO2TC6Eae0cKY1N8w==
X-IronPort-RemoteIP: 104.47.18.109
X-IronPort-MID: 8102466
X-IronPort-Reputation: None
X-IronPort-Listener: OutgoingMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-am6eur05lp2109.outbound.protection.outlook.com (HELO EUR05-AM6-obe.outbound.protection.outlook.com) ([104.47.18.109])
  by ob1.hc1803-32.eu.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 13:27:15 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+O0vv4TC4X759aK00Q0tg9FRIgnnH0RMVTc1/k5aan9FBJ5LG3DKtnpYTVLITvLPpTDPUSOzxwuPlIKdjqMNy3OD9sHY1vWLjV1OtyM3QP1H9uv9oPA1y6eOBepwDlUQdFtigfOz84BPkVK1mNXha2VTsqc0k6QzJ/F2Rpz6sveJG+muI1k90JS6bm0a6OM5G49pDeDRPUwfYJggm8ZojVeRLZC2DJlZjPkGlcIyhxyBzbVwlSuNLm6FKZfuxHhi7ZstkjpE8/r9KEbwuiOS3a3YJudTV7VQcVtJlTFyfWKVQvzZPEeYt26tXqXn4LQCF58oJZ61gge6n029YyfxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QcK4WRuEDk7aobfOGiK5Hzezm0FPa0U9DjF1s6+h/MY=;
 b=l4jDNkAXy4dPTDDqkspEd66jWKLYFuRDFD/22GWps7IxIeJkVXkd5I0x+oQ7nhht4QNqSG8yxgwJC3Z8tUgwO72H9UZZTVfWYSeJ8m9c/eFAdFoxv9emmpr9UNOWR4yJ8J7w/iUHcGdDNuhmIgiqXX9Nozl/EeABA5ot7CdL/njzNL9Ec1b/iCdch14FEL29Qu/zuNCSmzeEbCZD6fFTsCBd9yi+tPD4Hc10hUxOGfqpjTn4XzInLOXC2fNGCp1DHO0TW0HN5JIrZFApKrgXewrkjlet31SjNUCTRvuQdvdo9RRDQo00fV0Boc8DBKXLTfQrR/JeBhcwMdTjTfIYKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kistler.com; dmarc=pass action=none header.from=kistler.com;
 dkim=pass header.d=kistler.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=kistlerinstrumente.onmicrosoft.com;
 s=selector1-kistlerinstrumente-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QcK4WRuEDk7aobfOGiK5Hzezm0FPa0U9DjF1s6+h/MY=;
 b=eRfLhsZFJGIo5j1746iJELP6MyEK+phnGH5TCItrFPIozk5Ev4WcLov8g49Pk8P7geVF9KMqrLjM1MK730T45RT5YpLL+rcN7MlqZAvQahdEH31nCbeHeBmvTKgHFr7NPEvflFIG8dr6v4I6vFv092jjHKnwHOS4nmzqnS/1ioE=
Received: from DB6P190MB0455.EURP190.PROD.OUTLOOK.COM (2603:10a6:6:31::26) by
 GV1P190MB2194.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:1ed::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.18; Mon, 17 Feb 2025 12:27:15 +0000
Received: from DB6P190MB0455.EURP190.PROD.OUTLOOK.COM
 ([fe80::ab7:66d6:388d:1928]) by DB6P190MB0455.EURP190.PROD.OUTLOOK.COM
 ([fe80::ab7:66d6:388d:1928%6]) with mapi id 15.20.8445.016; Mon, 17 Feb 2025
 12:27:15 +0000
From: Roesch Martin <Martin.Roesch@kistler.com>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: OOM killer triggered by CIFS mount
Thread-Topic: OOM killer triggered by CIFS mount
Thread-Index: AQHbgR7FqouwkHnFCEOurX+AyPtcuQ==
Date: Mon, 17 Feb 2025 12:27:15 +0000
Message-ID:
 <DB6P190MB0455F18F9C0EBE2AB7CD55FFE8FB2@DB6P190MB0455.EURP190.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-codetwoprocessed: true
x-codetwo-clientsignature-inserted: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=kistler.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB6P190MB0455:EE_|GV1P190MB2194:EE_
x-ms-office365-filtering-correlation-id: 05c86788-6dc4-4f24-358a-08dd4f4e6973
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?+3L45+4oLqhUiXPHMec1571Jx1l1hc6rAau93+poC4igqMmQij/siuMELd?=
 =?iso-8859-1?Q?o0NnYZOqMyIajIaoJvHXxL1Fl5qf49TFQum8yq/dgdGAg1shMwBdmtoXXA?=
 =?iso-8859-1?Q?wt89AuBXvl8KHipp54DJRzhrHaPkNKGbiFUm6JGUdj2oQM9Nw6t5P2XxnB?=
 =?iso-8859-1?Q?FV2w80/hjrkx24vgvQRWxk/8ynRPmKBBAS0TvtjRmxsmaH07mIKrdFIsc1?=
 =?iso-8859-1?Q?CLY9kZzTItdBDPVmdcMqHF8QnI4ffV5QXHqTkwQZj4Kn1rf9/AYGujugVU?=
 =?iso-8859-1?Q?mJqaWbdfGtC3RlxHp0c3rYlG32s1cOkRCMI5JjDEDPJzT3ga+3hIASvunJ?=
 =?iso-8859-1?Q?CbwvHCiMIoPAXmYeSX49a+AEYtLVdxkFWiV1+usVMTCFU9TJLjTzPPmw9I?=
 =?iso-8859-1?Q?ztSixC3eP2qjwrRIAd26RGzbGFmQN/k3+aWnYNAEogj6eG9pN8QjlOCchP?=
 =?iso-8859-1?Q?8DTx6xh1sAJ5RvLfFk9YroXpusEqbEiW8Alndk13MQW9cacctuPHYZqFgb?=
 =?iso-8859-1?Q?1/pJetNI4W83OyOXtefXcYkLjtExOfp1hebCqqu3G4EBbKEpwWuf/nN//b?=
 =?iso-8859-1?Q?/OIoLZQm33m3ljQjq0uBhPTQJzdrZ7M4CZlSK5PKtOKVLsf/sXqh2nxUG7?=
 =?iso-8859-1?Q?3zgInlwmVvfr5tcUKtBvUn3K80a+HYZ4DIHEEkmFuYTJi64Gqqi0lR8RWS?=
 =?iso-8859-1?Q?iRFZ0hffUJCZdVjy8o3tMhMoWwRaIhCP8xwdYZJl2zvV0fO477eGiNIE6Q?=
 =?iso-8859-1?Q?B9pn+ah5a88fWK6945mHN3SSYTvf6t3kJ7TOxSFeFdkd3vJdt1ZN5+h+eu?=
 =?iso-8859-1?Q?+BNs7yUb4I/oOxzTIBtewKz7gir+VCfzG1XK9xOMUvC3OM9M9IL+RdBZjf?=
 =?iso-8859-1?Q?1VtPb9Pi1iNkfIxEvFTDqsw+x+xmMKJcRUBWCFGySoEuT4dJgf8yMQEsdo?=
 =?iso-8859-1?Q?Lz2k4s7PaR5egrBbT/fpEB2qjBRa9APr674mjpzG/mNJGsjPwv1uSFjis8?=
 =?iso-8859-1?Q?0rjFEbb1d+3UrJsRa5CvtUAmn+4v/a4f5ICHHy47omnLTqyEHneR9Wof8f?=
 =?iso-8859-1?Q?gJ8Eg/vNFJ20sWDXZZwKqQ+SXF3I78SkJATX8ZnSYW9ESgAQSXWb+diiQK?=
 =?iso-8859-1?Q?YrpnWuJTqnlD0tzLVSqG/5XDeBUeuCRyAM9AKmBc6IoKc+Z4vHVtZMhIxg?=
 =?iso-8859-1?Q?3VVjtP9ODMlmQhArTXEfi0xvG5rpv2V3PF3vOxbGAMM0/+KmI7u8KRNbMR?=
 =?iso-8859-1?Q?igAiDtt9eqhK9Gy0qnouZVOogW0F9cBNxA5+xl7SOIWR2x8ZK556ljdCUP?=
 =?iso-8859-1?Q?gK5GjHrSUae9f7uYlG/+VSK7p3fF9cd7BT2xKegKnLSKolli51m4518/zG?=
 =?iso-8859-1?Q?d0B82ZUH3HV8hCX2VDm9PPFwaUt4PXYzLcq7g8Z71U6/nz3zC1TVO/gVla?=
 =?iso-8859-1?Q?HKF1fLBWFN+1lhGc?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6P190MB0455.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?nZ7EZfJj2SdTnBONeujIgEhAEBApKf8aFR2P94IoYhWhRxppt9XXaynzWW?=
 =?iso-8859-1?Q?KO39JeYa/77mDRMD3od0PfUpEh8nnJizuC5ccoMq0YXkBBsu7NXLGe840z?=
 =?iso-8859-1?Q?V1N71ybztfcKrBJBsSR8X04uZvRa6KVojPBLAfhGqYDGaGAwdatV1tPgx5?=
 =?iso-8859-1?Q?vvra0gaDU8EyCeukqSBqYhv7Q82l3Y9smFON0A7sO9y7SmAhTUgAcdoXZ1?=
 =?iso-8859-1?Q?iIqJrStBthrkr3NfbFMsST8ODwLF+OB3hEZFNqf85qPXrc2T6pb5S5/R9H?=
 =?iso-8859-1?Q?PROH0LLu00upclEnnRuznzwdwWIlNMNbekfy8plnP2VyA4Zz7MeVM+BW/j?=
 =?iso-8859-1?Q?0HT2YTiwOMjfWZruKxzvAIDQiBruBPXayWWkjsDQg0GFQZy0HkJP+QyBV+?=
 =?iso-8859-1?Q?Ag0kQyQD7/ewaXu1C2lb/koFz0y9oKhmaQUG0ZeSqu8McLgtKMwCoLxdCB?=
 =?iso-8859-1?Q?w70qdyxvj7e3A9DA5S6AUJWYjN+2HbuSchKFXOvggpjIbBx2rFxp0lr5x/?=
 =?iso-8859-1?Q?Sh1mHlvHgbGGaOs3u12yxcQwr/z6otqNYFuwo0rTvznoE8lgECzdJC+xCN?=
 =?iso-8859-1?Q?2BjfLowSAz1TLdW3HyipvYd82SM53t1SCLP87ClO4jWr6dPLx7h8qMt8T2?=
 =?iso-8859-1?Q?zrQMtXVIoxbnT7t487MNX+tWzy6QZnQPzSDM+eZjdw8n2xMJS2t0NNm/1v?=
 =?iso-8859-1?Q?Gehmc6CaOGfgDkeUgbHrmr+XV26zgUf6RwmPuh0CcPBxtFIH6xmXs75+3y?=
 =?iso-8859-1?Q?3BYGbQeAI8ZNWfxzJ3WAjOPAf07dyfHXD5yeEF1gYGxDnAeVvmgrLxqBFv?=
 =?iso-8859-1?Q?2DTZ+fTqH3onfxmIUoNSWy7EKCeRXKOEMIzYCatMio2t3KIpbq+mwrVNRc?=
 =?iso-8859-1?Q?5Amt9tL9hNNTKZ9ylmjruPmF9fB83JhJKEk3hYSweJh/g0+oOy4k5bcPip?=
 =?iso-8859-1?Q?6SCIsa+weo/FZN5yzsJU8brvWO4Joj2BWkPgV8vdEqJCFa8rkSaRehDpWP?=
 =?iso-8859-1?Q?UFJ07hJEgKuePj22nlCl43x2grM6JNeLqjRBY+lwvC7Np0U5U8Mo6qpOJS?=
 =?iso-8859-1?Q?ksO2qE56poLZFAcJ9M3Ik+YkYkAyaW202Il3WswEhq9gA74gzNvDvmga2m?=
 =?iso-8859-1?Q?fWo2BqLxfx89b0hDJwXK1R6MKbFJuh8hx/L/I0xQ+uEDoWLAQdadsxBlmo?=
 =?iso-8859-1?Q?WpFPCIRcRrilP7ArmNy+o/PZVrjZdzPh5IdsHe8SbjSjy9CBeSwn/SVW/N?=
 =?iso-8859-1?Q?6QKAld1YCu9B3tGcAvaP7FrvYrc/QFMyUJQ6JiI3pFpIT/LpJZoHflNZ8k?=
 =?iso-8859-1?Q?QQrxLAnwyUTleCibRZTcu+x88ruuX8qLRf8m2Ec8HBx07J3DAOpZ/OJhtV?=
 =?iso-8859-1?Q?3nhT+IVFJF9fLyoyCQvqFVfEK0KPiLLv2tA/vd7qYjvBuSleqdfZGl9/gd?=
 =?iso-8859-1?Q?NKQyXWfUHfYI3cEpTUODyMMkRiC/DwqG3ImzszZdGRJC9xgtkd1tzoqZLn?=
 =?iso-8859-1?Q?CCdm4cluf/noeU7pEYDxh4WpV/GVEylTftiR2v2Dq6SeM5h3Tjuz/aT8rW?=
 =?iso-8859-1?Q?8pKBWIBIQI3rkTShGcSbRbqrhGoUqaORxKChPW0JVj340Cbwux45pQqKcm?=
 =?iso-8859-1?Q?PaOI/XYW8XzENLKqRwLYSWHBCzj+fWehO6?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: kistler.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB6P190MB0455.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c86788-6dc4-4f24-358a-08dd4f4e6973
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2025 12:27:15.1584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 913b01a8-b729-4ffe-a3e6-dbf8f9ce11e5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q1G170z90zTXidVjnuMeNxYOc0EKuWSCkDWKXSQ1Te5g2As1zxPz1DFqBxz/VQ5ZukJbAwR2G8z0chnxmMX4wJo3twHHmh4FWmjarIAUm9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P190MB2194
X-SM-outgoing: yes

Hi,=0A=
=0A=
On our embedded Linux device, we mount a Samba share and periodically write=
 small Files to it (around 70KB, 20 times a second).=0A=
After several hours (or when about 400'000 files were written) we see that =
the OOM killer starts to kill processes until it eventually also kills the =
writing process -=0A=
rendering the device unusable.=0A=
=0A=
I was able to reproduce the issue with a simple shell script that in a loop=
 writes small files with random data to the Samba share using dd.=0A=
The Samba server (version 4.15.13 on Ubuntu 20.04) is in the same LAN as th=
e device - so throughput and latency are not an issue.=0A=
The device is a TI Cortex AM62x SOC (basically a BeaglePlay board https://w=
ww.beagleboard.org/boards/beagleplay) running the=0A=
kernel 6.6.32 from TI with realtime patches (built with Yocto with the meta=
-ti layer).=0A=
On the device the share is mounted with BusyBox mount (v1.36.1) and the fol=
lowing (default) options:=0A=
//192.168.103.126/share on /home/root/share type cifs (rw,relatime,vers=3D3=
.1.1,sec=3Dnone,cache=3Dstrict,uid=3D0,noforceuid,gid=3D0,noforcegid,addr=
=3D192.168.103.126,file_mode=3D0755,dir_mode=3D0755,=0A=
soft,nounix,serverino,mapposix,reparse=3Dnfs,rsize=3D4194304,wsize=3D419430=
4,bsize=3D1048576,retrans=3D1,echo_interval=3D60,actimeo=3D1,closetimeo=3D1=
)=0A=
=0A=
When the OOM killer is eventually triggered, dmesg contains reports like:=
=0A=
[1527133.672369] test_samba_blfl invoked oom-killer: gfp_mask=3D0x400dc0(GF=
P_KERNEL_ACCOUNT|__GFP_ZERO), order=3D2, oom_score_adj=3D0=0A=
[1527133.672431] CPU: 1 PID: 14450 Comm: test_samba_blfl Tainted: G        =
   O       6.6.32-rt32-ti-rt-01519-g2cc066b2c5d1-dirty #1=0A=
[1527133.672443] Hardware name: Kistler EVK with Skyboard V2 using AM62x (D=
T)=0A=
[1527133.672449] Call trace:=0A=
[1527133.672454]  dump_backtrace+0xa8/0x118=0A=
[1527133.672478]  show_stack+0x1c/0x30=0A=
[1527133.672486]  dump_stack_lvl+0x44/0x58=0A=
[1527133.672497]  dump_stack+0x14/0x20=0A=
[1527133.672504]  dump_header+0x4c/0x2c8=0A=
[1527133.672514]  oom_kill_process+0x364/0x560=0A=
[1527133.672521]  out_of_memory+0xac/0x460=0A=
[1527133.672527]  __alloc_pages+0x94c/0xcb8=0A=
[1527133.672541]  copy_process+0x168/0x12d0=0A=
[1527133.672549]  kernel_clone+0x88/0x388=0A=
[1527133.672555]  __do_sys_clone+0x5c/0x78=0A=
[1527133.672560]  __arm64_sys_clone+0x24/0x38=0A=
[1527133.672567]  el0_svc_common.constprop.0+0x60/0x138=0A=
[1527133.672576]  do_el0_svc+0x20/0x30=0A=
[1527133.672584]  el0_svc+0x18/0x50=0A=
[1527133.672592]  el0t_64_sync_handler+0x118/0x128=0A=
[1527133.672601]  el0t_64_sync+0x14c/0x150=0A=
[1527133.672626] Mem-Info:=0A=
[1527133.672632] active_anon:103 inactive_anon:909 isolated_anon:0=0A=
[1527133.672632]  active_file:365 inactive_file:320316 isolated_file:1=0A=
[1527133.672632]  unevictable:0 dirty:0 writeback:0=0A=
[1527133.672632]  slab_reclaimable:99138 slab_unreclaimable:3419=0A=
[1527133.672632]  mapped:177 shmem:233 pagetables:110=0A=
[1527133.672632]  sec_pagetables:0 bounce:0=0A=
[1527133.672632]  kernel_misc_reclaimable:0=0A=
[1527133.672632]  free:50574 free_pcp:62 free_cma:22870=0A=
[1527133.672648] Node 0 active_anon:412kB inactive_anon:3636kB active_file:=
1460kB inactive_file:1281264kB unevictable:0kB isolated(anon):0kB isolated(=
file):4kB mapped:708kB dirty:0kB writeback:0kB shmem:932kB shmem_thp:0kB sh=
mem_pmdmapped:0kB anon_thp:0kB writeback_tmp:0kB kernel_stack:1760kB pageta=
bles:440kB sec_pagetables:0kB all_unreclaimable? no=0A=
[1527133.672663] DMA free:202296kB boost:0kB min:22528kB low:28160kB high:3=
3792kB reserved_highatomic:2048KB active_anon:412kB inactive_anon:3636kB ac=
tive_file:1460kB inactive_file:1281264kB unevictable:0kB writepending:0kB p=
resent:2097152kB managed:1916044kB mlocked:0kB bounce:0kB free_pcp:252kB lo=
cal_pcp:184kB free_cma:91480kB=0A=
[1527133.672680] lowmem_reserve[]: 0 0 0 0=0A=
[1527133.672693] DMA: 15619*4kB (UMEC) 8377*8kB (UMEC) 385*16kB (C) 175*32k=
B (C) 211*64kB (C) 75*128kB (C) 12*256kB (C) 0*512kB 0*1024kB 15*2048kB (C)=
 1*4096kB (C) =3D 202244kB=0A=
[1527133.672738] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D1048576kB=0A=
[1527133.672743] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D32768kB=0A=
[1527133.672750] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D2048kB=0A=
[1527133.672755] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_su=
rp=3D0 hugepages_size=3D64kB=0A=
[1527133.672759] 273713 total pagecache pages=0A=
[1527133.672762] 0 pages in swap cache=0A=
[1527133.672765] Free swap  =3D 0kB=0A=
[1527133.672768] Total swap =3D 0kB=0A=
[1527133.672770] 524288 pages RAM=0A=
[1527133.672772] 0 pages HighMem/MovableOnly=0A=
[1527133.672775] 45277 pages reserved=0A=
[1527133.672777] 32768 pages cma reserved=0A=
[1527133.672779] 0 pages hwpoisoned=0A=
[1527133.672782] Tasks state (memory values in pages):=0A=
[1527133.672785] [  pid  ]   uid  tgid total_vm      rss pgtables_bytes swa=
pents oom_score_adj name=0A=
[1527133.672815] [    318]   102   318     1349      160    45056        0 =
            0 dbus-daemon=0A=
[1527133.672825] [    322]     0   322     1952      129    53248        0 =
            0 connmand=0A=
[1527133.672835] [    329]     0   329      755       64    40960        0 =
            0 dropbear=0A=
[1527133.672844] [    341]     0   341     3634      224    69632        0 =
            0 wpa_supplicant=0A=
[1527133.672854] [    345]     0   345      874       96    45056        0 =
            0 syslogd=0A=
[1527133.672863] [    349]     0   349      874       64    49152        0 =
            0 klogd=0A=
[1527133.672873] [    494]     0   494      874       64    45056        0 =
            0 getty=0A=
[1527133.672882] [   7989]     0  7989      946      192    53248        0 =
            0 start_getty=0A=
[1527133.672892] [   7991]     0  7991     1045      256    49152        0 =
            0 sh=0A=
[1527133.672902] [  14450]     0 14450      946      160    45056        0 =
            0 test_samba_blfl=0A=
[1527133.672916] oom-kill:constraint=3DCONSTRAINT_NONE,nodemask=3D(null),ta=
sk=3Dsh,pid=3D7991,uid=3D0=0A=
[1527133.672950] Out of memory: Killed process 7991 (sh) total-vm:4180kB, a=
non-rss:384kB, file-rss:640kB, shmem-rss:0kB, UID:0 pgtables:48kB oom_score=
_adj:0=0A=
=0A=
While the script was running, I monitored the system memory with the free c=
ommand:=0A=
While the buff/cache amount increases linearly, the free amount decreases l=
inearly  until the overcommit ratio is reached and the kernel frees up memo=
ry.=0A=
During that time the available amount remains at a constant high value (1.8=
 GB / 2GB available).=0A=
This looks to me like expected caching behavior - until the OOM killer is t=
riggered.=0A=
=0A=
I tried various options to prevent the OOM killer:=0A=
- cifs mount options vers=3D2.1,3.1.1, cache=3Dstrict,loose=0A=
- Increase the CIFSMaxBufSize of the cifs kernel module to the maximum=0A=
- Increase the VFS cache pressure=0A=
- Disable overcommit with echo 2 > /proc/sys/vm/overcommit_memory=0A=
- Periodically drop caches manually with echo 3 > /proc/sys/vm/drop_caches=
=0A=
None of these did prevent the OOM killer from triggering.=0A=
Only disabling the cache with the cache=3Dnone mount option prevents the OO=
M killer (thought it still slowly fills the buff/cache memory somehow),=0A=
but the write performance impact (around 100 millisec. per write) is too mu=
ch for the performance goals.=0A=
=0A=
I also searched the mailing list archives and came across this message=0A=
https://lore.kernel.org/linux-cifs/2db05b3eb59bfb59688e7cb435c1b5f2096b8f8a=
.camel@redhat.com/=0A=
that mentions the OOM killer being triggered by the xfstest generic/531. Bu=
t I' not sure whether that is relevant to this issue.=0A=
=0A=
I am out of ideas for ways to work-around of fix this issue.=0A=
Does anybody here have an idea for a work-around?=0A=
What information would help to identify the cause for the issue?=0A=
=0A=
Many thanks for your help and sorry for this long message.=0A=
=0A=
Regards, =0A=
=0A=
Martin R=F6sch=0A=
=0A=
Kistler Instrumente AG=0A=
Eulachstrasse 22, 8408 Winterthur, Switzerland=0A=
martin.roesch@kistler.com, www.kistler.com=
