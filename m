Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11023096.outbound.protection.outlook.com [40.107.201.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4842917A319
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.96
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744214241; cv=fail; b=rk7f9MwMVFIP32xrm39dZACONHMCz03zUTr7UqKkAoKlUaknRuESPHsa/WfG4hVrB/NZ32w556fkOmHhD7P5eLr48N2VoIpqLJW+4+ZeSJYiPWGzZsFSaYXPhwBopV2JZLG4zDfmHdqFcWAOBqSVDntFudGkHdJFDK3LFcYAX8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744214241; c=relaxed/simple;
	bh=OXGiEDSeXZ1nlDlKyPE73kXsAs9BV58ja781OhAZ2sY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z5dP9ppHgKhR435yArLq1xW2Ud63adAkwDHELfCu5v5RsY+0RVW45jaqHg5MMEVM+3py6E9Q1ZeX3Bntii/5wvrA7UB0BjLT2O9XFgPqrTINty4EYekxylvVDF9kf2W3ULZPEX6XCeHMuwy0yQiRtoDafATmxZSZpuHl5wwxJcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=OeVhOo9G; arc=fail smtp.client-ip=40.107.201.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="OeVhOo9G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UpH8uVIefzxj4zpXsjTePfJ58vEn1hy8HOWMVFHWix/vQXE8JktlHYClv0BYtCA1U0uHDvK+HKhyU5MrGU3VDJGO0rP0Yrcs/2FOsy/IXOdHw7VNnSmDxldPsRZyrJG5xpHUSDkm5RFZFEFw3/01wqJce/1D170VoeK/Rppg1GaEvoL572df7J3foADqa0EBVVRBqiwmAcyS/md3nb/NIvz98eDKtEmSPathZXp9qjccMWGXnd0dHi7+M5p8zDKps1x/NzffeOhfcUMAF9q+zd2SQlA9+WamBoAg7urAM0mElcWdd22qdznKD6Y5d6NH/n/hCVaLT2JJX7JjCW2M4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXGiEDSeXZ1nlDlKyPE73kXsAs9BV58ja781OhAZ2sY=;
 b=vxp4GTn7uEVA+N+1nzRSXiTIyg/dU6xn0o1tTJ8CAbKzE7ff72GJK5nwXofmwy75q7ujvLK0QHCVCboVlUcNK4Nw33ZD2F0eox4/HqszO0FR8cgZDXPRlCcoZtkivERVoLdhU5KdQIcl5Z2fL9ydwF4Tmm4DOrr2IficuQdOx+FnMbUBnAy/vay/TSIsdNOytmISRPMu9JTiVi/USdS9wLRvzD+ggk8K5qX//1CcCrgFyNCRRNK01Fi5dXAhw3kDZSXzsUdn4iUFLYVXmEydPFmltriPbd+bJNy88o2Sz/1UWnBms8fBzBGNc5V14FtkMHOAJZHzh5+tbqM/QFjbNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXGiEDSeXZ1nlDlKyPE73kXsAs9BV58ja781OhAZ2sY=;
 b=OeVhOo9GLrUJxj8A3ieqDByTp9NrSZFqLua3uBtL7bI1Z4qzkbogUIpXdFQj6zIU7RV3S+XB7DN5YIDbt9LCmqT6SDVehzpooUYaH++eFCiJZ5sqlEEsL1LFSbRU1gneLWBjJ2o66GoGbOe3peR3hszjAJhg1qPP837kxTVF6TA=
Received: from MWHPR21MB4524.namprd21.prod.outlook.com (2603:10b6:303:280::21)
 by IA3PR21MB4199.namprd21.prod.outlook.com (2603:10b6:208:524::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Wed, 9 Apr
 2025 15:57:16 +0000
Received: from MWHPR21MB4524.namprd21.prod.outlook.com
 ([fe80::5b61:7eb2:5d4e:4490]) by MWHPR21MB4524.namprd21.prod.outlook.com
 ([fe80::5b61:7eb2:5d4e:4490%5]) with mapi id 15.20.8655.002; Wed, 9 Apr 2025
 15:57:16 +0000
From: Michael Bowen <Mike.Bowen@microsoft.com>
To: Ralph Boehme <slow@samba.org>
CC: smfrench <smfrench@gmail.com>, tom <tom@talpey.com>,
	=?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>, CIFS
	<linux-cifs@vger.kernel.org>, Microsoft Support <supportmail@microsoft.com>
Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Thread-Topic: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Thread-Index: AQHbqWgQ7UGLzlwId02T9V4GHBXYeQ==
Date: Wed, 9 Apr 2025 15:57:16 +0000
Message-ID:
 <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
References: <20250408224309.kscufcpvgiedx27v@pali>
 <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
In-Reply-To: <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e0f4e4df-0c76-4b14-9017-4b36a34561c4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2025-04-09T15:55:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR21MB4524:EE_|IA3PR21MB4199:EE_
x-ms-office365-filtering-correlation-id: 11cc639c-96dd-4e60-421e-08dd777f3358
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|13003099007;
x-microsoft-antispam-message-info:
 =?utf-8?B?a1RLYU94RkN5QWJrZVAyR281TjMvU1RqYWJ3UEpSQUg1RzdlYUJ4ZWprbVM5?=
 =?utf-8?B?NWVra3B2WjJLRHBOc1RYUTNhc1VQT0pBaXcyQVVCUUVxUjJMc0IvMU0zd2x4?=
 =?utf-8?B?T045b2RSMzFhZ2w2bHU4MWVQTDN6WG0zMVJlSm84QytQSzg4NERBSkdlZ1BU?=
 =?utf-8?B?NDhkazQ1NEZRZUdYL29qakZXMWhERUhobGFXaHVuVzBYRlBuNXNVd1R0bG1m?=
 =?utf-8?B?VlNVMS9pZ1ErQzhCbDlSVjU1QS85ejl1RTBraUNGdk1LVFFyYVRZVFN2Sk40?=
 =?utf-8?B?bWttTkduRWhmWXVEMkJ1LzRoR0NNc0VMNzJhS3NHamJQc2ZuQy9zMU5nNGRO?=
 =?utf-8?B?RFRxZDRxUTVzVHBIUkFRaTh3MG5BOVlvcWZBbU4yRU4rWEpwVElpaFlqNi93?=
 =?utf-8?B?NnFQM0k2U3FJK04vTTBjWlR3aklMVGVwaUZueXBzOGZtVFNsV21YZEVmcy96?=
 =?utf-8?B?TkRGaWtKbGpxZ2Rha3RNUUZDc0p0dFRWcm8xMUthRUVDTnk2dmJSU1BTZVhX?=
 =?utf-8?B?d3BHWThGL1MvcHMxNTlnT20zdmxJWFFIOEJ1R3U1WThMeUE4dXR2SUI4MzZY?=
 =?utf-8?B?T0FHRVpnalRxdnhNT21oSXBzUFpsYXNlTnlmelZxREdhQlhYQ21LWE95blB0?=
 =?utf-8?B?RmN1QlhZbGc3aWN6UmhUWEZxTE1LL2x4OWtOWk9jNkhLZFNFSDB4RVlnSGcr?=
 =?utf-8?B?dXEvdFZaWnZGSnFJaHBvdmVJcXptaTA5ZStXa0RkN0c5UVdEVTR2eit2SnFY?=
 =?utf-8?B?MEVDM3V0T25mam5EdHh3MlJxRWhDT1kzVVNmclhRSDlFNjhaQVorQmlnZTJS?=
 =?utf-8?B?aW5qMmo2K3ZtamxqUzlHM08rRjFhdkJyOWE3OEIzNkZkVzFPWE5Ud2Fac0t0?=
 =?utf-8?B?TmZZMndzS3kzZ2N6aHRwbU1BSFlGaktySXFmRFR2L0lYaE0wa1Y2RWxKdTZO?=
 =?utf-8?B?bFVOMCtTMlQ3TFY0anZjenVWRTNZcU1sWlRwZDNtek9QU1JjTFhld3lNZGNv?=
 =?utf-8?B?ZTgxenczVXcxeXdncXNnRXlBZWxkMXFRa0xhbEJRT3FNNmlJeFZsRVZMYXVL?=
 =?utf-8?B?anNSM3ZzQ3pVR0IxditPQXd4V3NSc0wwNUhLak54eXlCWHhEcVAyRnhxQTQ2?=
 =?utf-8?B?QmptWmF5M2NVdzVzYXRMcVliM0dxWUw2NmNjTDgxNTZnYnpoYlNWM25ybUl2?=
 =?utf-8?B?RnFGVTZ3R0hxazVQYjFLaitiNHNpZTBOWHhydmwvRFVMcTNRcDZ4UkNHM21W?=
 =?utf-8?B?YlJESXMvOFBQbWFIREFrR2svQm5nektIQU1NMERKQUFRN3lsTkp5N0w5aDNP?=
 =?utf-8?B?c2xXVHFJWHByVWhKanUwQ1ltQXY2aWVPbTdCMHo1bkg4eWwzQ3lZcHMwZ0lz?=
 =?utf-8?B?TFZrSHEzMFVxOFYxeGNGSmptc3FaOHFocFJMMVhMSC82VzZ6MXAxcFdQSUU3?=
 =?utf-8?B?cUlYR2kzU2Vpa1V5cU5QNnJvUzcrZjBWV3o0cXlENXNCMXI5RmcxRkF6bEZU?=
 =?utf-8?B?TFZqcmp1cWdjZ3dNVUh4N1crSnhGaXlHandYQUJuS2J6N2ZEb3hrZWdEVldr?=
 =?utf-8?B?cUhrQ29KQzdLbVd5TXVkS1BEL3cwdDRZcUR3NmEySTVqbmpwM2drTkVDdm4w?=
 =?utf-8?B?U1ZyVTVEbkNzQitucUcwQlhqTi9SRlNSWU5nQ3JvL2VEWTgxU0FDVUVUNHJn?=
 =?utf-8?B?RnVXczBocmlFY0k5cWR6R2VSMWVKMUFJZFJTSGhWenlDMWR3b1h6MDNNV2hK?=
 =?utf-8?B?cFJMd0E2N1FIN1NUVHA1bm10c3B3QUU4M0xRQmpmVTZVVjduWE1yS1pRKzEw?=
 =?utf-8?B?VFAvYzFQemVqZkVHeitYSWJWYi8zZkZmWS91emc4Rk85WE1RdTNaRkVnR005?=
 =?utf-8?B?RTYyWkZENUozdEVJRDRodDlEUHpmZFE3bGV1bkoxYy9YaFg1d2p4WjJJOWF1?=
 =?utf-8?Q?GDdxSxULQ5A=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR21MB4524.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(13003099007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dUhtYkJGbmZNdVViakpXVGJBQ2RSRFZHZm9Rd04wc09VUTdNbEdEYldnYTUw?=
 =?utf-8?B?Rk5EVExFSk51K0E1VHNGT2lTMUloZHM5dXJuUWFCL3hUVVlMWFVOdHFPcTN2?=
 =?utf-8?B?bURiVCtXMEhXUGVYTVV4cVJjVUxhUjhBUXlTaEhGbGlYUmFWRXlZOWNrRWha?=
 =?utf-8?B?LzB3TEZQb21QWncxQVhpQ0NHQVd0a0dUdlJvL3VDY3JXWUQ2NjdDMkdncUph?=
 =?utf-8?B?ZEx6djNEdDhlVWw2WGNmVDFHOFZ0Ymh6eHYyVjBxbWsvNVpiQXptVzBqOXcv?=
 =?utf-8?B?aGpVdkZZbXlxMDhoQmdnY0xZMG91Mi9MSGxkWUo0cnFEZGJtZ2NFRUVKK0d0?=
 =?utf-8?B?Y0kwa1lBT2pWZG4zTjdkRTdaQVd3ZWlKUU1DbWw2RWVjbi9OVUJ1NS84SHRt?=
 =?utf-8?B?S3NVai90SDh5OWdUUjB3aG81YWtPQjhzZlIzNXZTNFE2aGc5Q250OC9RNTZq?=
 =?utf-8?B?SFNucHZ3dk1tRTNhL3FyK0RWNDlESHVWZDVqNFlpR2l1TWYwbXFsYW1rQitx?=
 =?utf-8?B?ZXRFbHVzUU9wR25wQVFlVkFCYWpmLzFSOGNTT3RBVzVHcGJuOFlQbjg3anJS?=
 =?utf-8?B?ZjdXMmNpb1YvOHBQSXhDTVN4R1ViMjNzL1pzSis2STNYYnBNbXBpUHRjby9Y?=
 =?utf-8?B?VGJDcUVFdnhCZUpSSEFrMkdhTGlIM0I1TEJuTGF4aHJaN20zZFpnMm9MeUIx?=
 =?utf-8?B?Q2JCNkV3NkFQRURNUGEvNGFudGFJd1RKa242NFBPdkErS1lDM3ppbFlweXlq?=
 =?utf-8?B?WEtRMlBFUlZ3K1Jwd0c0SjJoL015TittbVcxc2ZoTTlRazFrbzlWS3BOd0JM?=
 =?utf-8?B?Y1c2MlZPMkU1L0Jzb1Zoa3BhWjI0L0pWSHgvMGVXeE41c2FFZ2ZKVUNXeGtY?=
 =?utf-8?B?MlF5c3pqTWVBQ1dqbVl1MWx6UHZMTHZQcWlZRkR3Wmw1T2ExMytTd0xOVVhO?=
 =?utf-8?B?aUgxclZ2bDVsbXlYK3pvZURPcUJlWTdKWlIzWVVvU1dSMy9vZktZRFhsOXZ5?=
 =?utf-8?B?dWNaTE1MYjQrNDFqeUVKYy9IamNCL2RFWFEvZTdHVHZVdHpJa3pJY2tSMkdq?=
 =?utf-8?B?b2QwLzRoUUlFWnBuSU9tSms0cnFOMUVBTjZHQTBKKzR4VXd3RUszSERzUm5D?=
 =?utf-8?B?azVTbC8yMW1mZDh3emxaRGx0a2lNZjdwRWhKa2txQXRrbVJ3blZSYUpLS1hT?=
 =?utf-8?B?T2hEZS83c2tQc092dlRPL21SWjNPQXVhVjZqbTRSMHBQK3h1RGZ3SkNHcE13?=
 =?utf-8?B?ckNvYlU4Z0RGWkdVSG9jVktTTmZNc3ZXUTRTVVNGbWw4ODVzZUdIdWNvT01E?=
 =?utf-8?B?WDJESnpUa0w1OXNPcGIxQ214VUZzVmJVZTE5Yk1wK0IwSzhJUE5GOHJMOG0v?=
 =?utf-8?B?Q0thcm1aLy9MRlR2S0pnN2VXYlpRRm1YZTgrNW5xTy9mLzYvakFKeWlraCtM?=
 =?utf-8?B?bnk3NTY4eXNGNmlPcmxQVlhwclUxMkhWSjIxVkw0Z1BxRG1BNW4yWnNZcVBP?=
 =?utf-8?B?Q01XTGMrOWZXb1F0V1JXd2NTMlg4MHJJZHBXbEtvK2dGa0hFWjlIOWpITERa?=
 =?utf-8?B?TjVHUjFFY0dIcjBYUUI5U2NyZDlaUGMxWnBtaWp2NHNzcWNLVmx0cXJ1UXV4?=
 =?utf-8?B?dzIycEVDanlRYVY4TWk0M2YzM3JaVmdrcWw3VXRXREhXWkJ2ZXRYaENQVmww?=
 =?utf-8?B?M291SDUxOHZBaVppc0hvNGVTcTFNYXpvSGd1QTBhOGVXaDZZblVpNDRGUVlT?=
 =?utf-8?B?RytqTmlTaWoyMlQ0QWNqOUFhL1F0aDk5emlFV04zQmlOcjBGOTlBSVJWcW5l?=
 =?utf-8?B?TDRtNVpnZ2pKbkFjenVKTTVrU2JSUkFFWmtEWkh3STVxd1d2Y3FycnVuRzJE?=
 =?utf-8?B?R2lsa0xQK01WNmpuVTNMMnU1R1JPQzc1T1VNU3c0bmZZM3JNR0dUOGFvMjRo?=
 =?utf-8?B?anNZWUpNQzdtRjIrMDgxa0N2eHZ1K3ZXRVpDZlJLdUxsY0FuN0hTR1hXaE5T?=
 =?utf-8?Q?ScccD4eamlvh0Q4CB8gVTbsvsvYMWI=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: MWHPR21MB4524.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11cc639c-96dd-4e60-421e-08dd777f3358
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2025 15:57:16.1973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: muyYEYwdThXTnxGhEo3JZqZSLPIFnAsyiTkOrzzIRQMJNYiDy5PAYyvsU333Sl/pBA4ZFuu+2/qCZO3u/ZFFfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR21MB4199

W0RvY0hlbHAgdG8gYmNjXQ0KDQpIaSBSYWxwaCwNCg0KVGhhbmtzIGZvciB5b3VyIHF1ZXN0aW9u
IGFib3V0IFNNQjIuIFdlJ3ZlIGNyZWF0ZWQgY2FzZSBudW1iZXIgMjUwNDA5MDA0MDAwOTU2NCB0
byB0cmFjayB0aGlzIGlzc3VlLiBPbmUgb2Ygb3VyIGVuZ2luZWVycyB3aWxsIGNvbnRhY3QgeW91
IHNvb24uDQoNCkJlc3QgcmVnYXJkcywNCk1pY2hhZWwgQm93ZW4NCk1pY3Jvc29mdCBPcGVuIFNw
ZWNpZmljYXRpb25zIFN1cHBvcnQNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206
IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+IA0KU2VudDogVHVlc2RheSwgQXByaWwgOCwg
MjAyNSAxMTo1MSBQTQ0KVG86IEludGVyb3BlcmFiaWxpdHkgRG9jdW1lbnRhdGlvbiBIZWxwIDxk
b2NoZWxwQG1pY3Jvc29mdC5jb20+DQpDYzogc21mcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT47
IHRvbSA8dG9tQHRhbHBleS5jb20+OyBQYWxpIFJvaMOhciA8cGFsaUBrZXJuZWwub3JnPjsgQ0lG
UyA8bGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc+DQpTdWJqZWN0OiBbRVhURVJOQUxdIEZ3ZDog
U01CMiBERUxFVEUgdnMgVU5MSU5LDQoNCkhlbGxvIGRvY2hlbHAsDQoNCml0IHNlZW1zIHRoZSB1
cGRhdGVzIGZvciBQT1NJWCB1bmxpbmsgYW5kIHJlbmFtZSBtYWRlIGl0IGludG8gTVMtRlNDQw0K
DQo8aHR0cHM6Ly9sZWFybi5taWNyb3NvZnQuY29tL2VuLXVzL29wZW5zcGVjcy93aW5kb3dzX3By
b3RvY29scy9tcy1mc2NjL2YxZjg4YjIyLTE1YzYtNDA4MS1hODk5LTc4ODUxMWFlMmVkOT4NCg0K
YnV0IEkgZG9uJ3Qgc2VlIGFjY29tcGFueWluZyB1cGRhdGVzIHRvIE1TLUZTQSBhbmQsIGlmIHN1
cHBvcnRlZCBvdmVyIFNNQiwgTVMtU01CMi4NCg0KSXMgdGhpcyBjb21pbmc/IElmIHRoaXMgaXMg
c3VwcG9ydGVkIG92ZXIgU01CIGJ5IFdpbmRvd3MgaXQgaXMgbm90IHN1ZmZpY2llbnQgdG8gaGF2
ZSBpdCBidXJyaWVkIGluIE1TLUZTQ0MuIDopDQoNClRoYW5rcyENCi1zbG93DQoNCi0tLS0tLS0t
IEZvcndhcmRlZCBNZXNzYWdlIC0tLS0tLS0tDQpTdWJqZWN0OiBSZTogU01CMiBERUxFVEUgdnMg
VU5MSU5LDQpEYXRlOiBXZWQsIDkgQXByIDIwMjUgMDA6NDM6MDkgKzAyMDANCkZyb206IFBhbGkg
Um9ow6FyIDxwYWxpQGtlcm5lbC5vcmc+DQpUbzogbGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmcN
CkNDOiBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4sIFN0ZXZlIEZyZW5jaCA8c2ZyZW5jaEBz
YW1iYS5vcmc+LCBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5jb20+LCBOYW1qYWUgSmVv
biA8bGlua2luamVvbkBrZXJuZWwub3JnPiwgUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz4N
Cg0KT24gRnJpZGF5IDI3IERlY2VtYmVyIDIwMjQgMTk6NTE6MzAgUGFsaSBSb2jDoXIgd3JvdGU6
DQo+IE9uIEZyaWRheSAyNyBEZWNlbWJlciAyMDI0IDExOjQzOjU4IFRvbSBUYWxwZXkgd3JvdGU6
DQo+ID4gT24gMTIvMjcvMjAyNCAxMTozMiBBTSwgUGFsaSBSb2jDoXIgd3JvdGU6DQo+ID4gPiBP
biBGcmlkYXkgMjcgRGVjZW1iZXIgMjAyNCAxMToyMTo0OSBUb20gVGFscGV5IHdyb3RlOg0KPiA+
ID4gPiBGZWVsIGZyZWUgdG8gcmFpc2UgdGhlIGlzc3VlIHlvdXJzZWxmISBTaW1wbHkgZW1haWwg
ImRvY2hlbHBAbWljcm9zb2Z0LmNvbSIuDQo+ID4gPiA+IFNlbmQgYXMgbXVjaCBzdXBwb3J0aW5n
IGV2aWRlbmNlIGFzIHlvdSBoYXZlIGdhdGhlcmVkLg0KPiA+ID4gPiANCj4gPiA+ID4gVG9tLg0K
PiA+ID4gDQo+ID4gPiBPay4gSSBjYW4gZG8gaXQuIFNob3VsZCBJIGluY2x1ZGUgc29tZWJvZHkg
ZWxzZSBpbnRvIGNvcHk/DQo+ID4gDQo+ID4gU3VyZSwgeW91IG1heSBpbmNsdWRlIG1lLCB0ZWxs
IHRoZW0gSSBzZW50IHlvdS4gOikNCj4gPiANCj4gPiBUb20uDQo+ID4gDQo+IA0KPiBKdXN0IG5v
dGUgZm9yIG90aGVycyB0aGF0IEkgaGF2ZSBhbHJlYWR5IHNlbnQgZW1haWwgdG8gZG9jaGVscC4N
Cg0KSGVsbG8sIEkgaGF2ZSBnb29kIG5ld3MhDQoNCmRvY2hlbHAgb24gMDQvMDcvMjAyNSB1cGRh
dGVkIE1TLUZTQ0MgZG9jdW1lbnRhdGlvbiBhbmQgbm93IGl0IGNvbnRhaW5zIHRoZSBzdHJ1Y3R1
cmVzIHRvIGlzc3VlIHRoZSBQT1NJWCBVTkxJTksgYW5kIFJFTkFNRSBvcGVyYXRpb25zLg0KDQpo
dHRwczovL2xlYXJuLm1pY3Jvc29mdC5jb20vZW4tdXMvb3BlbnNwZWNzL3dpbmRvd3NfcHJvdG9j
b2xzL21zLWZzY2MvZjFmODhiMjItMTVjNi00MDgxLWE4OTktNzg4NTExYWUyZWQ5DQpNUy1GU0ND
IDcgQ2hhbmdlIFRyYWNraW5nDQoNCmh0dHBzOi8vbGVhcm4ubWljcm9zb2Z0LmNvbS9lbi11cy9v
cGVuc3BlY3Mvd2luZG93c19wcm90b2NvbHMvbXMtZnNjYy8yZTg2MDI2NC0wMThhLTQ3YjMtODU1
NS01NjVhMTNiMzVhNDUNCk1TLUZTQ0MgMi40LjEyIEZpbGVEaXNwb3NpdGlvbkluZm9ybWF0aW9u
RXggaGFzIEZJTEVfRElTUE9TSVRJT05fUE9TSVhfU0VNQU5USUNTDQoNCmh0dHBzOi8vbGVhcm4u
bWljcm9zb2Z0LmNvbS9lbi11cy9vcGVuc3BlY3Mvd2luZG93c19wcm90b2NvbHMvbXMtZnNjYy80
MjE3NTUxYi1kMmMwLTQyY2ItOWRjMS02OWE3MTZjZjZkMGMNCk1TLUZTQ0MgMi40LjQzIEZpbGVS
ZW5hbWVJbmZvcm1hdGlvbkV4IGhhcyBGSUxFX1JFTkFNRV9SRVBMQUNFX0lGX0VYSVNUUyANCisg
RklMRV9SRU5BTUVfUE9TSVhfU0VNQU5USUNTDQoNCmh0dHBzOi8vbGVhcm4ubWljcm9zb2Z0LmNv
bS9lbi11cy9vcGVuc3BlY3Mvd2luZG93c19wcm90b2NvbHMvbXMtZnNjYy9lYmM3ZTZlNS00NjUw
LTRlNTQtYjE3Yy1jZjYwZjZmYmVlYWENCk1TLUZTQ0MgMi41LjEgRmlsZUZzQXR0cmlidXRlSW5m
b3JtYXRpb24gaGFzIEZJTEVfU1VQUE9SVFNfUE9TSVhfVU5MSU5LX1JFTkFNRQ0KDQpTbyBub3cg
Ym90aCBjbGFzc2ljIFdpbmRvd3MgREVMRVRFIGFuZCBQT1NJWCBVTkxJTksgaXMgYXZhaWxhYmxl
IGFuZCBkb2N1bWVudGVkLg0K
