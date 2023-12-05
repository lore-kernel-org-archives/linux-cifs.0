Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="c79nOaSj"
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020003.outbound.protection.outlook.com [52.101.61.3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADEB12C
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 08:46:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f18nGrm59ejx/XnqbssKNlSx8oTCXvJlc4i9Zg7dGCim+UjeRLLZtfpP7iXRI9MJi573cmECUMShAXYTv66FYBk0rDA3BrTY0Rcby0XcWsxCoiUkAtNgH53Eez+NSnNl0QiscDVn/0WyxmhKxI4FaD20bllC2TOjtEiumK7D7wu7xdF8yZcdo8N9mwCjRQIb0i8tOM2ZM8jumeqHwFzCpbpGsV8f8phTm1qvSARe7LKGC3CDB9UL4md72D3Mb8LODdd4uOc/6nyxSohVx6V4f6a8vIOWc7GsCbsPTha2lgeX999228t+I2Xz3D4QUpDU5qQAIxomceGv5AtcrMnc2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ISOUKdhKNctRmqKprAWhpHj9fR2CBEr0+c2Vx6PvDS4=;
 b=NzIIeJJ7OEMJegkdBW601kPOSMr+zURwrSGZ8LXbhrGlLE0UC8uZTm4LVg0lsSSkMW1U2xUyjeHjVG2Mzr50cbs8b7fFpFn9KXVpVAJpshqKmysOk85VrFt/AeBe417sRhSh9QiT4auS2wGzdTeqAgaJ3wXfEjeuJDTHCSjIFfn49y9nNakPzGeIidjxXq1jIFFXS6+igra6xwQthWjTVdbobIvYeMMDe5kMQ14wbISGAp12MBjUipZjI+YCWPPKVxvaP6XrARO7MULabw2hlS0K7qqL3zNPd7EmdPLlIzJv7fp04d9BY/u7XP8SojGjN4ZQ0WUToZH57RhF7HRtJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISOUKdhKNctRmqKprAWhpHj9fR2CBEr0+c2Vx6PvDS4=;
 b=c79nOaSjjpsiUQLNvAaL+lAEJljJaUvhL9OA3FRflAYs3+//3IT36ysyS25QODepJLGOAwFKTxom+RITKqRHf0c0L3rlwgTZVcDmYVUzm+Jm6tlxf4czT+3OnP+ctTYNFBHdgMMjRJsxQlh7WZSefbR2gRiLdvFLHijRoYrW3ZU=
Received: from SA1PR21MB1320.namprd21.prod.outlook.com (2603:10b6:806:1f3::19)
 by MN0PR21MB3461.namprd21.prod.outlook.com (2603:10b6:208:3d2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.5; Tue, 5 Dec
 2023 16:46:01 +0000
Received: from SA1PR21MB1320.namprd21.prod.outlook.com
 ([fe80::e6f8:2e32:e733:a5b4]) by SA1PR21MB1320.namprd21.prod.outlook.com
 ([fe80::e6f8:2e32:e733:a5b4%4]) with mapi id 15.20.7091.006; Tue, 5 Dec 2023
 16:46:01 +0000
From: Michael Bowen <Mike.Bowen@microsoft.com>
To: =?utf-8?B?UmFscGggQsO2aG1lIChzYW1iYSk=?= <slow@samba.org>, Namjae Jeon
	<linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, samba-technical
	<samba-technical@lists.samba.org>
CC: Microsoft Support <supportmail@microsoft.com>
Subject: RE: [EXTERNAL] Re: Name string of SMB2_CREATE_ALLOCATION_SIZE is AlSi
 or AISi ? - TrackingID#2312050040009715
Thread-Topic: [EXTERNAL] Re: Name string of SMB2_CREATE_ALLOCATION_SIZE is
 AlSi or AISi ? - TrackingID#2312050040009715
Thread-Index: AQHaJ5qHwCJO3+P1M0O5dwFAsKy4UA==
Date: Tue, 5 Dec 2023 16:46:01 +0000
Message-ID:
 <SA1PR21MB132084C1819B45EB6D2475879485A@SA1PR21MB1320.namprd21.prod.outlook.com>
References:
 <CAKYAXd9-61f1cjXMrovSEdio8fuTSbegfde4FZ9m1DAAS+CxRg@mail.gmail.com>
 <e20433c2-82e8-41e0-aa29-279dd64996fc@samba.org>
In-Reply-To: <e20433c2-82e8-41e0-aa29-279dd64996fc@samba.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=59e77e81-a08c-4ae9-ab94-37dd6d91aa12;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-12-05T16:44:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1320:EE_|MN0PR21MB3461:EE_
x-ms-office365-filtering-correlation-id: 706fefdc-2ec0-4f0c-06ef-08dbf5b1aa0e
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 xc77oxvWmjxnw3Dd+SHeKvRtRQFIrQwwcgyCl1xXM0rNx5Q/vX0AkOKLHKf2q4uWR1n4fd3UMFwS8bqNJioZDDC1se5+cRMDWwjEJLrln2w4IYEpJN5p1qp6qNlbclDEkz7USG3YqmvwFRRJmToAjzI2CAz9Px48DS0bvQ0QkiD+A8cn5vFKABmUp4XVmmNmHvI+BD9fgOa75rVbBU+VKryxqXrhsPXouSrxZSweFUv6pGvHqG/oRjkqsnhzQ8TyoKLXvODNX7Cz2lljNKXTcJvg6GKg8I3368x4NoAlkoF7evwyqQf1V1fOEZW+AUB7pUlwU2AERrXad8a5H1nfZhyQMJJGmyuVHysQ8Iy9v0d+Zqtbjlsf37stw0pTXVrAKnIwRh0B8YfUakyJV4r+U5eCIPK/5gZIfV8bTCqZDGLNn2z5ILBvqYNjWt9h9ItxzRQ58de+2wiCKo986nMh0ukabmjFYpARtZzWnJZF2tJFkPuximSFj29wwmRGRSRnZzh4p+hxOmIFTYowoihSLiRJb4LvV3FRneIOSzbFT5DmdiOAebdUdTVyzS6+rIZBE5WUS4vTHIGkoO3wYtDKUmWwbDE7XWk3jVlhQkXK/599py7jeZ8FaI/IYoAFwzL6U+Gm6B3wE/Ua5kaq/u0a8Q4AR5G1ogzkXRhiZG1VaBUlOPj8XeX+sQPCrdqaZz5wPBXY9bV13WSVyPzQ2zcqOQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1320.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(6029001)(39860400002)(136003)(366004)(376002)(346002)(396003)(230173577357003)(230273577357003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(52536014)(71200400001)(8936002)(10290500003)(4326008)(9686003)(7696005)(8676002)(53546011)(6506007)(66946007)(66446008)(316002)(110136005)(64756008)(66476007)(66556008)(76116006)(478600001)(2906002)(122000001)(55016003)(33656002)(8990500004)(38100700002)(41300700001)(38070700009)(86362001)(107886003)(83380400001)(82950400001)(82960400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UUViOGtGLytPYzJEZ0F3czVPUEhUQnpIWGRSNjZGQnZnaHZoTTdmNEhESmxm?=
 =?utf-8?B?MzNrRCtzNWZpMU9IM05BcWpOUjJ3eUhhMjBwdjFnK0lsZ3VBbHJ5dHpXZ2hX?=
 =?utf-8?B?LzVyNU03V2NpNFNUN3ZkVEt2dHBqM0FPWUQ3K0ZRU2hZZkUvajUxd09kUjIw?=
 =?utf-8?B?SjFIdkpxS3FjeGhOSUJveHdnUUMydFZrMm02cTdGU0NWNnlGRzU3MkdYaFQv?=
 =?utf-8?B?VGwxaUtOSS9XTUw4dHpSTlNKNmdFcFJjRTVYM0RHSFA4SFNkRkk4S24reDhu?=
 =?utf-8?B?TDdhRTdwOE5BK2VJU3VOYW8wdU9VQzhweENiMUR0b2RJdEkzbFQzZ21NNUpm?=
 =?utf-8?B?MDRmOThQc2RBN2hBSUZINUVnVkJUMG1oSXBLMUFPbFhBbjlONzZIdE5LUVVK?=
 =?utf-8?B?dHlhcWRmallVbWdhalNGdVlBZUJLRGx1SGgvWGdmTmxUZ0Z3a2JNK3FoaEs2?=
 =?utf-8?B?T2tVWGhLeEVKbmdhNFJxYkpQUjBnVkJPcmYrV045MHkzNTNYNjlqRlhLakRo?=
 =?utf-8?B?cXZoZ2pydDBTWE5XcVB3T0tybzJqVC9NZ1NlSTFabW5SUURSOUlLSDIzT2ow?=
 =?utf-8?B?cTZQQllYU0hveWp5MmdtN09GTXVNSlpTYVMxR3JUM0JCWjFIRXFoNWdoVEVJ?=
 =?utf-8?B?OHNzNTNqazdzc0hwY2d6ZU5RVElBYi90Ulo4cnJBYTJTOTRxRktEb3BHM2hv?=
 =?utf-8?B?bXNzQ3pKUmQyaTRocE1jZjBHVE13NTB0TFBvYXNaN2lrRkIrOE81SjRKZm9z?=
 =?utf-8?B?UDVkNzNScGxKTnVhOVJDbElYNndFWFpqM21BdEhVUnMrSi9maTdTQytZY3Zu?=
 =?utf-8?B?elNObE1VOVcxWG13ZjBhNS9pZFRwRGs2cU8wR0w3OHpCM01Lb1R4MDlwWVZt?=
 =?utf-8?B?WHljUEVvb0w1OVpacEttVVZneXl5OWxWYzA3OHFGZVQxRWg0d3FaWUtRU2Yr?=
 =?utf-8?B?eHhBVW5PcFdBNC8xdGNuM1g4ZG5LL29rM3dGRVlLbFF5ZTlPQ0xCell3dzl5?=
 =?utf-8?B?MkRrUmJxbWw2MXU2aU5nbFNQYktXVUZnVTlXaklvbC9VQ0F3RnByNW9FdWNx?=
 =?utf-8?B?bGEzeldRU1UxSWx3NXRJMnYxN0hOTnJOdXRnYmRLaDBPbWpnWTdYbFovSDg0?=
 =?utf-8?B?dTVDYUhBa3p0eGhEaXYzSVZ3RmY4QzFNcXR2a0dkTmVudlpsb25lNHdzaXFk?=
 =?utf-8?B?ZzhUWXNzMXVFQVcyc3A2N010eWgzZFQyeitnajk0QlIzZmU4aHE4YnBGcFd2?=
 =?utf-8?B?MmNOSC9Id3FHNzh5Tzg2WXJTRU1iSDVSNHQrNHZFT1cyTG5hVVBZKzNtZjhy?=
 =?utf-8?B?ZFZuZ1d4S1QzdkFpMVBmYXVDVHQ0VFYwZHdacjYrZVhpUkJ6TENhaGJ1MXFP?=
 =?utf-8?B?bzdjUmpBVW5zdHVkclE2N3ZzaEpGWkRzeXU4QXRtbC85VUFIdWZOVEsyeWh0?=
 =?utf-8?B?bWpXOWtaUDVIdkhuNld5MlAzd2htRXdhVnBoUDFwZVM1dHdFc2lvbnhGQkg5?=
 =?utf-8?B?SHNXazNFQXpURWErdDhVRDd2YXdzTE4rSkJrMVkrNEQrS3ExZXQ4RHF2T1NT?=
 =?utf-8?B?TmNUbVAxeGllZjFZTURidm1ybmlOR25hSWVZM2s0bTdZWDhZN1dTaVR3R3d3?=
 =?utf-8?B?dzEvbVY0MFJlNjFkUkZJYW9uVDYvRGIrTVU3ZEJtNXY0ZndHR0pza0wvdDM5?=
 =?utf-8?B?b1J5Qlh5MDl5VlpvakZhVm5YbXF5OVlDTjdpb1dReGxGYzgwK0RxL0UyeEl6?=
 =?utf-8?B?SElrcW8zSmZRNHhreVFZUGNGTjgzckRSTHJtNGp0aVo3VGpuN3NnVjlpYlU0?=
 =?utf-8?B?SjMzUElXbkZWdXBNc2ZYTTZ6YjRORTFzaEtZV2xyUkJzWnduQ1orQStaTTRp?=
 =?utf-8?B?WDliRTRqY25YQk5sWTE2Mjh2OFAvSWRoN0ZqUldGUE1aTWtTMXU5bE0wRjFU?=
 =?utf-8?B?OEV1ZmMxdlJNcFBxeWU3MEJMUEFXczJsa1UySFNQL2tqWnFVNkZnQUdTZDky?=
 =?utf-8?B?QW05R0RtUWJUejAyL0J2Q1h1V1kwNUJJdldxWVFqWUJXRlJNMFZ1MTVrWmZ5?=
 =?utf-8?B?TXhLNyt6M0JGbGZiU1R6ckxRVVVKVUdKdTRJN2RULytoZjhVaFhQSVJnM1lS?=
 =?utf-8?Q?q/2KKLm+7njOFibragK78PjIl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1320.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706fefdc-2ec0-4f0c-06ef-08dbf5b1aa0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Dec 2023 16:46:01.3736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uNkj/MUe33OOPmDh9cUcKnj5mFOv5E+MA4JoZ1UXoudegfvCFuwAUL4sRRUjASzt/goUGw2HprRXKwrPL22A7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR21MB3461

W0RvY0hlbHAgdG8gYmNjXQ0KSGkgUmFscGgsDQoNClRoYW5rcyBmb3IgeW91ciBxdWVzdGlvbiBh
Ym91dCBzbWIyLiBXZeKAmXZlIGNyZWF0ZWQgY2FzZSAyMzEyMDUwMDQwMDA5NzE1IHRvIHRyYWNr
IHRoaXMgaXNzdWUuIE9uZSBvZiBvdXIgZW5naW5lZXJzIHdpbGwgY29udGFjdCB5b3Ugc29vbi4g
DQoNCkJlc3QgcmVnYXJkcywNCk1pa2UgQm93ZW4NCkVzY2FsYXRpb24gRW5naW5lZXIgLSBNaWNy
b3NvZnQgT3BlbiBTcGVjaWZpY2F0aW9ucw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
RnJvbTogUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz4gDQpTZW50OiBUdWVzZGF5LCBEZWNl
bWJlciA1LCAyMDIzIDI6MDEgQU0NClRvOiBOYW1qYWUgSmVvbiA8bGlua2luamVvbkBrZXJuZWwu
b3JnPjsgQ0lGUyA8bGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc+OyBzYW1iYS10ZWNobmljYWwg
PHNhbWJhLXRlY2huaWNhbEBsaXN0cy5zYW1iYS5vcmc+OyBJbnRlcm9wZXJhYmlsaXR5IERvY3Vt
ZW50YXRpb24gSGVscCA8ZG9jaGVscEBtaWNyb3NvZnQuY29tPg0KU3ViamVjdDogW0VYVEVSTkFM
XSBSZTogTmFtZSBzdHJpbmcgb2YgU01CMl9DUkVBVEVfQUxMT0NBVElPTl9TSVpFIGlzIEFsU2kg
b3IgQUlTaSA/DQoNCk9uIDEyLzUvMjMgMDg6NDgsIE5hbWphZSBKZW9uIHZpYSBzYW1iYS10ZWNo
bmljYWwgd3JvdGU6DQo+IEkgZm91bmQgdGhhdCBuYW1lIHN0cmluZ3Mgb2YgU01CMl9DUkVBVEVf
QUxMT0NBVElPTl9TSVpFIGFyZSBkaWZmZXJlbnQgDQo+IGJldHdlZW4gc2FtYmEgYW5kIGNpZnMv
a3NtYmQgbGlrZSB0aGUgZm9sbG93aW5nLiBJbiB0aGUgTVMtU01CMiANCj4gc3BlY2lmaWNhdGlv
biwgdGhlIG5hbWUgb2YgU01CMl9DUkVBVEVfQUxMT0NBVElPTl9TSVpFIGlzIGRlZmluZWQgYXMg
DQo+IEFJU2kuDQo+IElzIGl0IGEgdHlwbyBpbiB0aGUgc3BlY2lmaWNhdGlvbiBvciBpcyBzYW1i
YSBkZWZpbmluZyBpdCBpbmNvcnJlY3RseT8NCj4gDQo+IHNhbWJhLTQuMTkuMi9saWJjbGkvc21i
L3NtYjJfY29uc3RhbnRzLmggOg0KPiAjZGVmaW5lIFNNQjJfQ1JFQVRFX1RBR19BTFNJICJBbFNp
Ig0KPiANCj4gL2ZzL3NtYi9jb21tb24vc21iMnBkdS5oIDoNCj4gI2RlZmluZSBTTUIyX0NSRUFU
RV9BTExPQ0FUSU9OX1NJWkUgICAgICAgICAgICAgIkFJU2kiDQoNCmxvb2tzIGxpa2UgYSBidWcg
aW4gTVMtU01CMjogdGhleSBoYXZlIHRoZSB2YWx1ZSBhcyAweDQxNmM1MzY5LCB3aGljaCBpcyAi
QWxTaSIsIHdpdGggYW4gImwiIGxpa2UgaW4gImwiYWtlLg0KDQpBZGRpbmcgZG9jaGVscCB0byBj
Yy4NCg0KQGRvY2hlbHA6IGxvb2tzIGxpa2UgeW91IGhhdmUgYSBzbWFsbCBidWcgaW4gTVMtU01C
Mi4gOikNCg0KLXNsb3cNCg==
