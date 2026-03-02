Received: from loire.is.ed.ac.uk (loire.is.ed.ac.uk [129.215.16.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A241C0B5
	for <linux-cifs@vger.kernel.org>; Mon,  2 Mar 2026 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=129.215.16.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772466869; cv=fail; b=pGbNGwa1mQ5B1sm3xKobgrbnRed+Sp/qXAfESR24auUh9DYw5lMCdAYuPclWNMmCbJq0pyYqFAclO4W2GIRE19Yoolh2+FiYltZd1F7e2i+O4F0MdCYbF1J+6tNwrGzzz6ZQSByhD5vFxUu5r05ve2BPFNucT4waxxKxkmLdNpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772466869; c=relaxed/simple;
	bh=fzmjGisogF0iZRLyuszQIe4OUQOWtzrGuw/6VZuYMy8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NyGEoHE6aiqMQinEZwtxgXfN5zYEOu3DnBeEiDZHkuU4pdgPeqM5Auzss23n3q9HDy54INSiyO3bFvR8Zeatkd5qCeNWjs4WNMn8litvKF0LN+BlvjruQ3HPoFm9w2bcsCCdLuzBbOJYrOtLCKVzMQgIw0BOsdeYRncma5Ys5RY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ed.ac.uk; spf=pass smtp.mailfrom=ed.ac.uk; dkim=pass (2048-bit key) header.d=ed.ac.uk header.i=@ed.ac.uk header.b=PnfhNV+2; arc=fail smtp.client-ip=129.215.16.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ed.ac.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ed.ac.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ed.ac.uk header.i=@ed.ac.uk header.b="PnfhNV+2"
Received: from exseed.ed.ac.uk (hbdat4.is.ed.ac.uk [129.215.235.40])
	by loire.is.ed.ac.uk (8.15.2/8.15.2) with ESMTPS id 622F8wrs2270687
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 2 Mar 2026 15:09:38 GMT
Received: from hbdkb3.is.ed.ac.uk (129.215.235.37) by hbdat4.is.ed.ac.uk
 (129.215.235.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Mon, 2 Mar
 2026 15:09:21 +0000
Received: from AM0PR07CU002.outbound.protection.outlook.com (40.93.65.64) by
 hbdkb3.is.ed.ac.uk (129.215.235.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 15:09:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HmToOJb7oLri+kMVdxCIG5tCcYs8lyY+5Xclt7S60hcA1N1AUcogelZCbizEfDKBFRBuvBjeWf+ldI8nP2zmnC/b56x2B7zJG+FfncPbszIdTIX0a2T3E1IwJ2GKnQnlYQjWbx6RveBEnT3pj1qrrzUezKZPmswk0o+VTDushJFpYKtBaFiTKC5W7pCNmH//oWQ9u83e1Osre8MFGLB2cdM3ClkuJw9Yhh9e+DgtutBctfnMaYOfIion/lTvx7VTvQsTu+89AtB8SMPClHKxqzfIbKYbf0LCHSkK9q1wS9vkrxIsXJ0go7qwa4Dz4KEqkfGs0j8b4hPYOpXkGH4OXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzmjGisogF0iZRLyuszQIe4OUQOWtzrGuw/6VZuYMy8=;
 b=jeXnUAKymWJwDzvLdXGKHSJdjYgDFg3w5ilCd+YqAUtT94pUJpctsARqE6sjJsxAMTQuElq2cH7xmL2Zst57ev47uxcEkg3Txz7o0fPgQueeIQuOj+WpdxLhEVG2TtMUreutuQW9dbml6YIgggaqGDYtET83wHIp0rmfmC8TQEgdxJHukRFqJZaU/Viz1dGN/0dqbAk6qahlofItcMdoVm3GkuFS/xVJ24y6iWuQ9JGgZeBnvKorYfP7Su6Sox6FzMwE+vT8d3jYbhUmiOzHloYfGztnxRauOyDfwAjI3G8iuwUVN6O97a/SC30XO0GJOQo5KGIEpdL93r6067my5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ed.ac.uk; dmarc=pass action=none header.from=ed.ac.uk;
 dkim=pass header.d=ed.ac.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ed.ac.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzmjGisogF0iZRLyuszQIe4OUQOWtzrGuw/6VZuYMy8=;
 b=PnfhNV+2/tadBQDmCN6w45rEXXOv4UXqIEjKZHVX5saKjR4BsUUxvHOl50uqpWCL4R/O1uSdEMwP/hq+6FJDNmJ23Xcn4BdxHdiB/ZPbcqp0gKjdJ92p83XT6obTkFMe9t/lEw2Is3ZTIJxok5VFR5c9Hgsb06ST7Qs/mdscprhvDFk6EVzX5VzcXqNmBc5Yys8JG9Fpz9xNZnt4+LLXlMw1EOF9i/sOPnJwyz7kjAA5ds/tzIawRSD5rjnp74CZjLUgtaYU6cGm5P5nHOIeYZsrTQkoiTEVY+HY5tl1Tp0B7ilvs9Wm3QVnQhKRoj5jbkyDWFmI80zVsNZEfOdbrA==
Received: from DB7PR05MB5771.eurprd05.prod.outlook.com (2603:10a6:10:8a::22)
 by DU4PR05MB12598.eurprd05.prod.outlook.com (2603:10a6:10:633::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 15:09:20 +0000
Received: from DB7PR05MB5771.eurprd05.prod.outlook.com
 ([fe80::c444:22d5:cdec:48f6]) by DB7PR05MB5771.eurprd05.prod.outlook.com
 ([fe80::c444:22d5:cdec:48f6%6]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 15:09:20 +0000
From: Matthew Richardson <m.richardson@ed.ac.uk>
To: Paulo Alcantara <pc@manguebit.org>, Steve French <smfrench@gmail.com>
CC: Ralph Boehme <slow@samba.org>, Samba Listing <samba@lists.samba.org>,
        CIFS
	<linux-cifs@vger.kernel.org>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
Thread-Topic: [Samba] SMB3 Unix Extensions - creating special files
Thread-Index: AQHcAJQadwXNTaO+Pk+Hl8fCt+tfRbRJWYiAgAFBDQCAAdAUAIAAF96AgAAHEwCAAAOBgIAACmyAgAAZb4D///lagIFP/Mct
Date: Mon, 2 Mar 2026 15:09:20 +0000
Message-ID: <DB7PR05MB57711EF45DD1CFC24471B84BB17EA@DB7PR05MB5771.eurprd05.prod.outlook.com>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
 <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
 <1ee7cccb5fc35163cd8d0ed7777b37c0@manguebit.org>
In-Reply-To: <1ee7cccb5fc35163cd8d0ed7777b37c0@manguebit.org>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ed.ac.uk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB7PR05MB5771:EE_|DU4PR05MB12598:EE_
x-ms-office365-filtering-correlation-id: f6f49fe1-7a04-4749-0065-08de786dae59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|786006|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: cyypP0GcR+8LZPAfEh3CRZ9uKsE/1x3ixFg4Np4LtGQiCjz98+oL8KJImJ27+av/JWLO1Er6KCWgUZlyut90QtKEKp5bRtRHTqpNLdmDP35vDcpWhMa7lWQAZWAo44iicxGCuq46pDKUTwc4Sj/MDkprR2CXvQ5vX3BQ5OOFWh/ciNq71wGbIRRux19T7j8m7N8u4DbCOZiXCz7/b2NOLFrZUvY6XEblGcwPZImdyC9DxA5EUF0F9IqmlLpzUiDCjM7kSkpxOu+1a5KDkC3rdTuQMRvDrVoDts+0xdmRHdkRKp8mmVGN7ubZ9F+wqxh2UfRKUXwDLqto0gavREpkTeLYqNjyAqOzYFlCrAcEpeJYRdWHq5nCsfGhMDLePVtuG5GlTEkz2vB69da6mRD0iXPLBeGqWOItgx38lly+qs8CHFfpv8CWS5IoeRhZQ5NHmWWnwTlfEld9Mgngm08hIwN5/RwGCK78mS4z3tsKWQ33BhPH5KdPG1e5SWgn9Y9x8fMBwsy/He/fJvCH9gjgB6LXzEl0WZke0tDz/ETPLgZ0XpkSnqY0favAz/Id70INpg8wZbEB9JEpXvIlk3b1nND51lFKbzltyS6OsFlEFJOevsNekJ/JPBF6SuyURwi+G5atr4MuTstbGv9SLXA4zh5J4fl5Dom8icJNaK33dCqjjaVsyQa5gp1+VzaEDasPhTC5TDSW7BMsBmDcHkAtVAr8gMV0MaIRLw+KZ9oKQ90diYJ+DkVFzcNHhuqkXAXUAjiNem91kuRiLKXLSZGyuLXD8G9iPhJnR+vKJ9OaoRg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB5771.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(786006)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTVXMmZTSzY0Ukt1UkF2WGF5UUhMb1MzYjl6WlJmMTF1M3grT0lKUkQvSk94?=
 =?utf-8?B?QXUxOGRXalVORnE1Y0RLc3I4ZUl3RnlNODMyM0o4cWNkbnhIWU5jcVdXUlFS?=
 =?utf-8?B?Z0NBTzZqbG01dVpjZjAvYVlwR3p1KzZsakhXSmkrVnVwUWFnSDZieFZxczBZ?=
 =?utf-8?B?ZnN6NXkwc1NTQm0yenZWbzBOdHMyeU1qamJFdkNHV3dibGxGZG9CRDlrWXJ1?=
 =?utf-8?B?OXZhTEpaZTlIYlVOSGN5QmlQSkZXeFFiME9iRTZxRVdjZDNXT09vdHZDcnpS?=
 =?utf-8?B?WE5HYXk1U2ZUa1RxKzUrWTc3aHdzNXdKaGtsZ0o0ZllGdDFNUks3UnpUL2or?=
 =?utf-8?B?T0tYaUFDWUw2RG1ZUTRhZEs2RVRiS2JVWXdDZG40S0o2UmpXWEhXNUZJNnVt?=
 =?utf-8?B?K0VSRWFncUw3N1lPb094L0FXMmxsVVU5eGNkclhsWEQ4M3FaRFFVekxITWpC?=
 =?utf-8?B?ellhMEFjMkw3UEM4am16VG81N2QzNHM0NkZ2cTdGYlZQK1h3L0ZDYzYycklv?=
 =?utf-8?B?NVBsSHNIem9UQ0xrZE1tYVE4RmdQQlU1VmNyMnhHZ1RMYkxFOTNzdWtHKzVF?=
 =?utf-8?B?aXdnSUZ3akJ3VldJWkZYYUljdGFHZk1zN2JzSzA5QU9GYjdURnlkMGxKS3BI?=
 =?utf-8?B?ZjZZK0tveEg4bllIOUdHdllIRTBIbGRIYjFsbXg4YzdhTnMvVldJR0hXN0dn?=
 =?utf-8?B?U0tlRFg4bjNRMjF5alltbmxmY01NcjgrdjJpTUZzVllXVW10M2lKUkp5M2Z3?=
 =?utf-8?B?c2tRV0ZnTVBzNDdwa1VJMG1pQ3VEekFMQi92bEhURHpBdjc0OXdsSGNCQlNT?=
 =?utf-8?B?cmMxR1NqY3lvcCtZeHlzOFEzbGJuejFUTStWN3NIZjBzMjJrMEVrWEdGUGN1?=
 =?utf-8?B?Y3NWamllSWZJaEdhOUczY1pEV044bkUxQzJnTEVVZXRqamZTbGplS1JwQWxN?=
 =?utf-8?B?S3Fhd2JuTXBRdDdld00rRG1HckVPMkxxMER4dFh0ZExjQnc1dyt1NDI0YVpE?=
 =?utf-8?B?VzdiREIzcVdCQTJGV2JXSGtobGhUdzBSR3BweFlqRTVGNTd2OXRjcE5LVUp4?=
 =?utf-8?B?SnNoWGxuT0c1TWR5U2xkQTU0bXpGdS80dWtPV3dxVnlZOHRzakRGaHdsVlht?=
 =?utf-8?B?VVlnRzhwUzk4UVNxSllBSmlqL3N6RjVlSmhNZElwaDh1UDBvbWZqUXQwRnhj?=
 =?utf-8?B?d3FvL1hKZTlYclhnWmZueXJsbk9lRXZSZGhaanhObkRhUUM3QlFxQllRZ0Y5?=
 =?utf-8?B?dHBja0dQcGtxVkdRa0dZakVmdlcxdklQRE9GQng3bkxNTExIU0NhVHdpcmk2?=
 =?utf-8?B?N2J0eS9IbEZ2emd1VXM0L1k4R2hqMlRHSGUxck1NdDJsajFlZlUwQzJPcEFk?=
 =?utf-8?B?T3o2Q2Q3dXNXTTAzV0lJYi9Ua2F2azVXeEpTb0ZGMXIxeEZmOUlac3NQblRY?=
 =?utf-8?B?enFIS0xySzIxUDFEeFhuUkFpTTA0dzl0MzFNN0NPS1N6WFpXZ0hHY0FmZk5I?=
 =?utf-8?B?ckhBOWZ1OS9kcWFhV1AzNXpYQkhZelRFQnB0YmozUllJY0lxNlBiVzN2N1Qx?=
 =?utf-8?B?dHBXeTdMY1MzeGNidFNrUDRhWTdjc0ZvV2FOTU50RCsxYlVvMFNxYVFKZWkz?=
 =?utf-8?B?L0J2YlZ4SWpGWXZkZzVpOVBWNUMyWnJ3NlJ0d0EzVHA4QitUSUp6L2h4bTZH?=
 =?utf-8?B?Q0UvdUtCSGVsdTlSVmwyWEhpcFZsTmhGd0liLzQwb2QyQmJNTzRYTlJtSGpD?=
 =?utf-8?B?QTUxY2FWNGh2eFozSTVEK09wRWR2QUhiMi9yMlRXdEJrZGpoN1F5Sjc1clRk?=
 =?utf-8?B?WFBGN3RJTWswdWc2VUZCeHY5S09VS1lwUlpObVB3R2oxYnBwZVZHRXI4YWtC?=
 =?utf-8?B?U3p2OUZIaFpCeWttN3B6dzFLMnE1U3ZZVml1OHlBZmtaVFpVYVdNUjgyVWJk?=
 =?utf-8?B?d2xNby96c2oxMk9PMTRpWktia3lnZXN5Skpvd1kwSzI4V0dPbU1BUko1bDRK?=
 =?utf-8?B?amVPd04yeDUxVHczbDg2cUtPdnc0RnpmL1M5YklFSnNiVmdjc2N0VCtJSUp4?=
 =?utf-8?B?bDBDZFh4ZUd0TWdOMzBwMEw0U0FqUHZpdDJOWkw0SlQ5Z1dvdXV3eXdROFFU?=
 =?utf-8?B?S2VLcWsyanZjVmJWQnJvYUEzQUN3MktJd0RvaUlxdVJSdWV4eGIrcVhYaHJ2?=
 =?utf-8?B?M1pDRlBuTk11WkYxMUxackVCWGM0bG90SVByUUhORXdqYjhLem5XbWFtVnJh?=
 =?utf-8?B?b1Y3c2c1NlQ1R0JXUnVydkVnZFFoWFBYaW9HSjFOaFVacTFQVjA4Q0oxaTVO?=
 =?utf-8?Q?S0E/bNrog+LrTaS8v6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB5771.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f49fe1-7a04-4749-0065-08de786dae59
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2026 15:09:20.4738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e9f06b0-1669-4589-8789-10a06934dc61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uDM5ZXnoGn/TxaDbg53qCCh7036E9OgUKb1g/wsnzW4yQtK9CmDhnkN6PV+50mXAJOhwrYXOJ0KfnwlwgI276g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR05MB12598
X-OriginatorOrg: ed.ac.uk
X-Edinburgh-Scanned: at loire.is.ed.ac.uk

SGksDQoNCkp1c3QgZ290IGJhY2sgdG8gdGVzdGluZyB0aGlzIGFuZCB3b25kZXJpbmcgaWYgdGhl
c2UgcGF0Y2hlcyBtYWRlIGl0IGludG8gTUw/DQoNCkkndmUgdGVzdGVkIHdpdGggNi4xNyAoVWJ1
bnR1IE5vYmxlIHN0YW5kYXJkIGtlcm5lbCkgYW5kIGxhdGVzdCA2LjE5IChtYWlubGluZSkgYW5k
IGFtIHNlZWluZyBvZGQgYmVoYXZpb3VyIHdoZXJlIGl0IGlzIGNyZWF0aW5nIHJlZ3VsYXIgZmls
ZXMgd2l0aCAnc3BlY2lhbCcgbWV0YWRhdGEgcmF0aGVyIHRoYW4gJ3JlYWwnIHNwZWNpYWwgZmls
ZXMuIChUaGlzIG1pZ2h0IGJlIGEgZGlmZmVyZW50IGlzc3VlIG9mIGNvdXJzZSEpLiBSZWFkaW5n
IGV4aXN0aW5nIHNwZWNpYWwgZmlsZXMgKGNyZWF0ZWQgb24gJ3JlYWwnIGZzKSB3b3JrcyBmaW5l
Lg0KDQpJJ20gYmFzaWNhbGx5IHVzaW5nIHRoZSBzYW1lIGNvbmZpZyBhcyBpbiBteSBvcmlnaW5h
bCBwb3N0IC0gc2VydmVyIGlzIHJ1bm5pbmcgNC4yMy42IHdpdGggdGhlIGZvbGxvd2luZyBjb25m
aWc6DQoNCltnbG9iYWxdDQogICAgd29ya2dyb3VwID0gV09SS0dST1VQDQogICAgc2VjdXJpdHkg
PSB1c2VyDQogICAgbWFwIHRvIGd1ZXN0ID0gbmV2ZXINCiAgICBsb2cgbGV2ZWwgPSAzDQogICAg
Z3Vlc3Qgb2sgPSBubw0KICAgIHNtYjMgdW5peCBleHRlbnNpb25zID0geWVzDQogICAgZm9sbG93
IHN5bWxpbmtzID0geWVzDQoNCg0KW215c2hhcmVdDQogICAgcGF0aCA9IC9tbnQvdXNlcnMNCiAg
ICBicm93c2FibGUgPSB5ZXMNCiAgICB3cml0YWJsZSA9IHllcw0KICAgIHJlYWQgb25seSA9IG5v
DQogICAgdmFsaWQgdXNlcnMgPSBzYW1iYXVzZXIgI3VpZC9naWQgMTAwMA0KICAgIGNyZWF0ZSBt
YXNrID0gMDc3Nw0KICAgIGRpcmVjdG9yeSBtYXNrID0gMDc3Nw0KDQpDbGllbnQgaXMgbW91bnRp
bmcgYXM6DQoNCm1vdW50IC10IGNpZnMgLy9zZXJ2ZXIuZXhhbXBsZS5jb20vbXlzaGFyZSAvbW50
L3NtYiAtbyBwb3NpeCx2ZXJzPTMuMS4xLHVzZXJuYW1lPXNhbWJhdXNlcixwYXNzPXRlc3Rpbmcx
MjMNCg0KUmVhZGluZyBleGlzdGluZyBzcGVjaWFsIGZpbGVzIGNyZWF0ZWQgb24gcmVhbCBmcyB3
b3JrcyBmaW5lOg0KDQo+IHN0YXQgdGVzdF9sb2NhbA0KDQpzdGF0IHRlc3RfbG9jYWwNCiAgRmls
ZTogdGVzdF9sb2NhbCAtPiB0ZXN0LnR4dA0KICBTaXplOiA1ICAgICAgICAgICAgICAgQmxvY2tz
OiAxICAgICAgICAgIElPIEJsb2NrOiAxNjM4NCAgc3ltYm9saWMgbGluaw0KRGV2aWNlOiAwLDQ5
ICAgIElub2RlOiAxMDk5NTExNjMxMDQ2ICBMaW5rczogMQ0KDQpJIGNhbiB0aGVuIGRvOg0KDQp0
b3VjaCBmb28NCmxuIC1zIGZvbyBmb29fbGluaw0KDQo+IHN0YXQgZm9vX2xpbmsNCiAgRmlsZTog
Zm9vX2xpbmsgLT4gbW50L3NtYi9mb28NCiAgU2l6ZTogMjMgICAgICAgICAgICAgIEJsb2Nrczog
MCAgICAgICAgICBJTyBCbG9jazogMTYzODQgIHN5bWJvbGljIGxpbmsNCkRldmljZTogMCw0OCAg
ICBJbm9kZTogMTA5OTUxMTYyOTUzMSAgTGlua3M6IDENCg0KSG93ZXZlciBvbiAncmVhbCcgZmls
ZXN5c3RlbToNCj4gc3RhdCBmb29fbGluaw0KICBGaWxlOiBmb29fbGluaw0KICBTaXplOiAwICAg
ICAgICAgICAgICAgQmxvY2tzOiAwICAgICAgICAgIElPIEJsb2NrOiA0MTk0MzA0IHJlZ3VsYXIg
ZW1wdHkgZmlsZQ0KRGV2aWNlOiAzY2gvNjBkIElub2RlOiAxMDk5NTExNjI5NTMxICBMaW5rczog
MQ0KDQpnZXRmYXR0ciAtZCB4X2xpbmsNCiMgZmlsZTogeF9saW5rDQp1c2VyLkRPU0FUVFJJQj0w
c0FBQUZBQVVBQUFBUkFBQUFJQVFBQUptY0dhNVVxdHdCDQp1c2VyLlNtYlJlcGFyc2U9MHNEQUFB
b0dnQUFBQXVBQzRBQUFBdUFBQUFBQUJ2QUhBQWRBQXZBR01BWlFCd0FHZ0FMd0J6QUdNQWNnQmhB
SFFBWXdCb0FDOEFkQUJsQUhNQWRBQXZBSGdBYndCd0FIUUFMd0JqQUdVQWNBQm9BQzhBY3dCakFI
SUFZUUIwQUdNQWFBQXZBSFFBWlFCekFIUUFMd0I0QUE9PQ0KDQpBbnkgc3VnZ2VzdGlvbnMgYXBw
cmVjaWF0ZWQgYXMgdG8gd2hhdCdzIGdvaW5nIHdyb25nIC0gaGFwcHkgdG8gcHJvdmlkZSBuZXR3
b3JrIHRyYWNlcyBpZiB0aGF0J3MgbmVlZGVkLg0KDQpUaGFua3MsDQoNCk1hdHRoZXcNCg0KDQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQpGcm9tOiBQYXVsbyBBbGNh
bnRhcmEgPHBjQG1hbmd1ZWJpdC5vcmc+DQpTZW50OiAzMSBKdWx5IDIwMjUgMjE6MDANClRvOiBN
YXR0aGV3IFJpY2hhcmRzb247IFN0ZXZlIEZyZW5jaA0KQ2M6IFJhbHBoIEJvZWhtZTsgU2FtYmEg
TGlzdGluZzsgQ0lGUw0KU3ViamVjdDogUmU6IFtTYW1iYV0gU01CMyBVbml4IEV4dGVuc2lvbnMg
LSBjcmVhdGluZyBzcGVjaWFsIGZpbGVzDQoNCk1hdHRoZXcgUmljaGFyZHNvbiA8bS5yaWNoYXJk
c29uQGVkLmFjLnVrPiB3cml0ZXM6DQoNCj4gSSd2ZSBqdXN0IHRyaWVkIHRoZSA2LjE2IGtlcm5l
bCBmcm9tIG1haW5saW5lIChMaW51eCB2bS1iDQo+IDYuMTYuMC0wNjE2MDAtZ2VuZXJpYyAjMjAy
NTA3MjcyMTM4IFNNUCBQUkVFTVBUX0RZTkFNSUMgU3VuIEp1bCAyNw0KPiAyMjowMDozNiBVVEMg
MjAyNSB4ODZfNjQgeDg2XzY0IHg4Nl82NCBHTlUvTGludXgpIGFuZCB3aGlsZSBta2ZpZm8gd29y
a3MNCj4gYWdhaW4sIGxuIC1zIGlzIHN0aWxsIGdpdmluZyAnb3BlcmF0aW9uIG5vdCBzdXBwb3J0
ZWQnLg0KDQpZZXMgLSBtYWlubGluZSBpcyBzdGlsbCBicm9rZW4uICBJJ2xsIHNlbmQgYSBmaXgg
c29vbiB0byBNTC4NClRoZSBVbml2ZXJzaXR5IG9mIEVkaW5idXJnaCBpcyBhIGNoYXJpdGFibGUg
Ym9keSwgcmVnaXN0ZXJlZCBpbiBTY290bGFuZCwgd2l0aCByZWdpc3RyYXRpb24gbnVtYmVyIFND
MDA1MzM2LiBJcyBlIGJ1aWRoZWFubiBjYXJ0aGFubmFpcyBhIHRo4oCZIGFubiBhbiBPaWx0aGln
aCBEaMO5biDDiGlkZWFubiwgY2zDoHJhaWNodGUgYW4gQWxiYSwgw6BpcmVhbWggY2zDoHJhaWRo
IFNDMDA1MzM2Lg0K
