Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021124.outbound.protection.outlook.com [52.101.62.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A223594B;
	Tue,  7 Oct 2025 19:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759863827; cv=fail; b=j33x1um86fER357n0mPnvPi5Z7zRrYkemXCMUheRsV/uWt3Swoik3a65sjpKliWjIYtSMFg5zhiIDCRYFhObiF7VAGKn1W2rDPTPY8wOXTvpoAR+ku0630paTeITWvAaNFOrc9uHhoYq7vGjC5gMi/pRrFTyTjKvIRXmyjgYj7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759863827; c=relaxed/simple;
	bh=Ye3JBMC3Wk3/Kb3rfJ1rK+uwzIEyf5FYs2NA6LOSUqc=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=rNPOBrVLOzPmKz4czMUPVbzfJUYGr/YuJOyqwQTGwyBFrsHbPygsAmhs4XMfBgyio6F0wMQCB1VAkgiO/8TxFSksDIzt35HqUapJ9B1eCZSeD1hTbheYgLJ5lvu9qpx+XAHjRHJlqpwERb8YBCjCEEOCVnGiK65rH3TXRlTqW2c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.62.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ledzN7qonPh6fFJE/16slcXpLkbl7ioQkxDMfXpp12HqsGhi3BUKP5lbDQ4Vmq0N7xxrQzLlzn2mrqraplMBW3zCp81/qhEKuRhWIy8xnZ5XtNFGJgfuSxLlqDJp5Th4fzBlY42o7iEOPJPayJqgZAZWNJFcnDy9SPM07W9D56S4diInSFhdE2VhY5ovMb2x4RlFHLtqmGCCXw+UDWXo9e+4do95ukDfkqh/ftVLdL0vZR3R5+oZGP7wTSMEqoFOmtVLnoueHZmLJESnVJSFd/aQjNEWf+FmyOJFBXlHknx17er+JhvIDeNYWwul0greoREosQpeWA5R1aYdApPyLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ye3JBMC3Wk3/Kb3rfJ1rK+uwzIEyf5FYs2NA6LOSUqc=;
 b=wBKezFxqVb3k9osKkceQDOYF8fgAxj4FRv0ucGgCOx/W1d2YXmuVCHWKMayg/YQB/i43PJ6XNWTBb9h5MGd8hB2yp7s/H4YXHqmgR2XeXTfQS9bCjHSVolLmV0SkjELVZspIMxcBE7QS4p4nvBIwlQnCRSd3067R0Ll4d9xv8ZjeDxlIMhkDRtU1/RHHnIgcnkMbr76F6DrzfnL1X6IcVv4WytgcRIgqxvuoVD2Pn1wetaqSGNuTiFSasxdyFSh498fShopIvwWYR6IWx9b5lT0bcwu6MdgEcRy1px4kEUeo4hcKPpx90YBSHb9v+bX7b1TV4AspK9a5c6AfFk1L3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CY3PR01MB9193.prod.exchangelabs.com (2603:10b6:930:109::5) by
 PH0PR01MB8096.prod.exchangelabs.com (2603:10b6:510:290::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9; Tue, 7 Oct 2025 19:03:37 +0000
Received: from CY3PR01MB9193.prod.exchangelabs.com
 ([fe80::5818:cc62:988f:8908]) by CY3PR01MB9193.prod.exchangelabs.com
 ([fe80::5818:cc62:988f:8908%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 19:03:37 +0000
Date: Tue, 7 Oct 2025 15:03:27 -0400 (EDT)
From: Tom Talpey <tom@talpey.com>
To: Steve French <smfrench@gmail.com>
Cc: Fushuai Wang <wangfushuai@baidu.com>,
	David Howells <dhowells@redhat.com>, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com,
	bharathsm@microsoft.com, Markus.Elfring@web.de,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Message-ID: <a22c8ce5-da8f-42d9-a02e-5cfe048b514b@talpey.com>
In-Reply-To: <CAH2r5mvws19ho44YJDROdNUy3FtWfxyVE8QcbCTbFJ_VWYNQ9Q@mail.gmail.com>
References: <20251007082603.16174-1-wangfushuai@baidu.com> <CAH2r5mvws19ho44YJDROdNUy3FtWfxyVE8QcbCTbFJ_VWYNQ9Q@mail.gmail.com>
Subject: Re: [PATCH v5] cifs: Fix copy_to_iter return value check
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <a22c8ce5-da8f-42d9-a02e-5cfe048b514b@talpey.com>
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To CY3PR01MB9193.prod.exchangelabs.com
 (2603:10b6:930:109::5)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY3PR01MB9193:EE_|PH0PR01MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: f5432c41-527d-4121-943a-08de05d4385c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|52116014|366016|1800799024|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ky83dHZRY3UwMVlTZVJLM1NvTWZRZmpRb3AxcExadmZvdGdMQXpoVHF5TUQ1?=
 =?utf-8?B?dWovVDlYZWJlZU4yRTZ1YmVuZjRCNzlMNmQ1R3puWmY1TzdvMEdWeU43MEVt?=
 =?utf-8?B?cG1kMWpBK01iQ2hSbmRwWVQrV3Zjbi9YK21DOEIxS2hHam9jdndQQURQSzh6?=
 =?utf-8?B?S0loa1AyU0EwNjFmdzVjamtoeldBeGQwQ2llZ0plY0xDbmd4Q2lSMVh4RGtI?=
 =?utf-8?B?akZlTFhjajU3NkV4RFpuamgyT0R6NEFCREZqTTM4T1EzbWdiYUVjUUsrM3Nu?=
 =?utf-8?B?VUFuUGt4MTI2d2tHcDhGUEtjLzQzc2RsWkN2bXptSmt3dFRGUVRPN3E4d2Nk?=
 =?utf-8?B?bU01bEN6VTdSbWc3cWsxbGE3amhBSVE2M1NONk9lbTl1WDdUSkhpbkVLbXpL?=
 =?utf-8?B?OTlLanBHRC9naFVSbmdIanJDanhISEw5ekJkRS9FUXI2ZWc0cUpQSWVkemY1?=
 =?utf-8?B?KzJFbXFVWjdZUUNVaGxNQ0ZiaVNMY282SWdGaGZiWDJXU0JNcS9nbzFkTE11?=
 =?utf-8?B?Wkl1K1JtdUdsNW1oZ3g1S2lXQTlxQ3VML3Y5Z0tBbHdZVndXQnpMcW9JaFZo?=
 =?utf-8?B?Mk5RRnpObkxJNXpDN0lIWkFXejhXSUd3TDd4cVRuNTh4eXlNbnlpN2ZWSkZR?=
 =?utf-8?B?TzBrOGlpNGFSc3NBd2ozVHRqK1cybXpwNDlXNGRiUURPZ2lIcm44dHcrdTRX?=
 =?utf-8?B?b1lQWmxlQ2tZc211bkVUZFQ1QjVnSXkybkpXTmNCYy9kTE1pazJrZ1p1NXpS?=
 =?utf-8?B?S2lGdnFBN0hnSmtBWGtWRi9TQm5lR201aHNrZ25udm8rejk5Z0liamZHbjY2?=
 =?utf-8?B?d0YyZEdaTFJwb2xYZjUvaExYaEZnNkxXcG85MFJ1MTJYdi9PNmZKekhlSjVx?=
 =?utf-8?B?ZzU5TmI4Y0NuNEgvWXR0ek5kZVdrUkpVVFFubzRoSFBnKzNzYWxUaFFPcW9I?=
 =?utf-8?B?RVlZakhhWTN4SEdiRkgwWW9PQ1plUytYOEUvOUtXRlNpN0Npd3FWVGphMXBu?=
 =?utf-8?B?V0ZGTlJHVWtGRXAvYnphWDVJNFhoVlV6Mnd5WnFSY0FLcFFIN0dlMzJrWjcr?=
 =?utf-8?B?Q2VKMmRZK1Q3djlkQXBnUXJEb3RrbFpxQ1gxQjNROW9aRktHNC9DazMwR3dL?=
 =?utf-8?B?M3dBRHFwSjJHQmNIWUhKUzJNaWZ1WTV4T045UFEwM3lJajJKbTVYaCt2ZDF2?=
 =?utf-8?B?V2JwZEhhamoxZk8reUVjTC9GSGp2U2Y0NDJHaXRna1MxeFVGSVRhUnJHelJV?=
 =?utf-8?B?VVRCdnF3dkFHZk9kampQTlU0RVUyekU2OXBidCttamh3S1kxd0FDTjU2aitH?=
 =?utf-8?B?dVY4NGxrdXJYb3Y5dVdidEt2V1lGd01lSGFwMURqY29sNmRHYTNDeFlzZXdK?=
 =?utf-8?B?bTZvazVIZTkwVFJySXBOUHd6STVFQTFOcHF4RnhRd2l1bUhwUXJySnhPSkpx?=
 =?utf-8?B?M0VsRHZLRWR4K0wzWGs3RHNyeSs3S3NKTS9ET0RQcjU0YW9iUzVSV3ppdzEx?=
 =?utf-8?B?WGlPQU1JZ0NTc1RKUzl5MTBON1llLzVTbmlQTU5BVlhNSE9rZG5ZRHFTMUR4?=
 =?utf-8?B?T2wxaEFxUUZIL1hkYTl2ZW5sZnhRTlpJOU9rbU4zVnJIQVA3djRrWWxQUjdu?=
 =?utf-8?B?d0tvWHgvemlyemRqZVg1ZnIxVmhaV1hiMUhoMDJGQjJZckpQOTUwRlYvcFF1?=
 =?utf-8?B?ZzFRZ09CT21PcEVGSlVnQmdHOXZuTEVXSE85QVBNd1dnOEpPM053cytzVGMr?=
 =?utf-8?B?ZmFpbDFzcitPLytuRGQ4RFJyNHg5M1lSdVpyR0tweTZTV1JyaHJIY2QxeGlm?=
 =?utf-8?B?Z1hYMUdQWGxCb2JDNkw1NWYyMGtQU2o3eHVHWjVsWmowODdNMTVOR2o4Q2NU?=
 =?utf-8?B?TnJIeGRFQVNlRTZyK0ErY2J1NFZTRUVDSTJwcnRhYXlhbEhtUEVZQnBwc0RO?=
 =?utf-8?B?b0J5aENjdk5ydDR3MlU1QVlxSjlZRUJ0UlU2dVdVbzYwTDdCVnMvdWNmbnRQ?=
 =?utf-8?B?bFdDS2dsQ0gxTnIrdWFjQTNaRkdGSVZoUk90S1dLaWxxSVdKSnFYVm1reHFX?=
 =?utf-8?Q?OQarYU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY3PR01MB9193.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(52116014)(366016)(1800799024)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VEhEaGN4bjlvY2ZWays0L3BBV056c2dDRHpvdno5MDc0eEVVOHdvSENPelBp?=
 =?utf-8?B?VHF2MjEwQnR2Tkp3b2ZWSERneUV3bUVTZ0dBS3N0b3JxVHpWd3l4Z1I2WEVI?=
 =?utf-8?B?Y1NDM2U4dVFGaDg3V05DUHg3T3didEc0M0NkVVcycHR5cmRiM1FJd21kMk1h?=
 =?utf-8?B?dTVWMFVzbUtlRzJMRUhQMThkbENhZXBzbzQwVll0R0srdTAzaHdkMkVxK1Zs?=
 =?utf-8?B?TTZ3RnVvUnFaRFh0NngyRE5wTnVSRE9jM24vVEVucE5nd3pNUWw1bDJyT2Jm?=
 =?utf-8?B?aGhoNjVaWndMeEg1OWFNa2JtSmdxQ3J0Wmt3SUhQSnBLVHNZakMxdWlmTkJa?=
 =?utf-8?B?aXJ6SElQcUlnUmRRTjk0d09JS1g3bG9vYWl3aEkrSk8wdGQ1ckFhRWZWUS9w?=
 =?utf-8?B?YWpPc2U3OTRWa2ZVcnFnNE1PRWJReXA2ZFhFMEdxY2paS3VGdVBySWlZUEw5?=
 =?utf-8?B?QUpkU1JGd2orWGZOeXoyS0lWMlpFZUU0aVYvd3NQTjFhMEJzL1hWL08vbU1Q?=
 =?utf-8?B?QllyZHpCTXRKRGxWM3VvQ3praDNiVUVzeTdEcXd5VmFYcVRJTG8yQUdISGUr?=
 =?utf-8?B?QnJQNU1oL0xPUnhiYWRWd01UVFBJTzd3eUFkMENVZlVyK1hlaEZZUmhzWk56?=
 =?utf-8?B?Mk5IQjhRUEhTdHowWDlqQ3BKd2FNTGp3SGRXL0FrK0V3SWNNZWlwbEwwWm4z?=
 =?utf-8?B?ZUJpUEErL0VhWmhaS2o0NXZGak5mNjdoTXlIVkp2bVBIdGZhaUhkR0Vvb25r?=
 =?utf-8?B?T1hiM1VxTXhUbEcrTzdvbktGY2JjVUtLcDhxSCtBQ2JYaklzOTlmZkJzUHhP?=
 =?utf-8?B?Qzkvc0RSQjV4SU1EcE84NmN3RmExU1pDTEgrQW0xZ1c5QlcrbEhXTXVXMTgz?=
 =?utf-8?B?UjZ1ZFRvb2g4bUEwZmJTU1N5WWtaK3MwUEpBZXBGeXpaRndUNm5zSjZmWkox?=
 =?utf-8?B?a0dzL3dQdW9PTVplZk53dmFOZEVsTGpxNmQvbUhINU4vVk1JYVZvQ0c4TkFI?=
 =?utf-8?B?TGs5NVpNVmRYbWxRYmVFZk43K3FhS2VodlJUbjJpNnFjazQrU2ozdmtVWngv?=
 =?utf-8?B?VjJsSmxUMEdqN05TdUtXNkRaV29WYWM0ZnhnTmdwaDBjQ3JpWUg4L1RWRVB0?=
 =?utf-8?B?VUhPSmRuSUc5SVdMVXRkZGx5VG1sNE1NTElUUlBMSjFUU2FWeUNUNGJXQXJD?=
 =?utf-8?B?SldTYVVKaUZIaFp1dStSbEVad0dkd0JMblh0Y0dhcklWRU5Mcms4Q1BDT2ph?=
 =?utf-8?B?ejlvTGlETmNwS1gvNWhsa1FxMkcxaDlZQlE5c0lHSWlCRVlKNXhZSjlwOEFv?=
 =?utf-8?B?NUVaVnZwTlVWZG5GSHplc2ZLZmlpaEpIM1BCeHc2cmJZVXJqQjMyeW4yZ1Fx?=
 =?utf-8?B?VWdJSXNwZE0xblVTRDVaNlJMeUI2VitkTHBiM01zaENWa3VPVGVZYjB0eXA2?=
 =?utf-8?B?U0JmV0VaUHQzSEt3Njg1TWdhcTZYYWxDWWRzV2JyMklXWUVLaytQekJGOWRz?=
 =?utf-8?B?bXh0TDg2L1c2OEtuejkxNFM3UXBYemdNYkdqT0h4clhHM1J0QklRWGRHbTFp?=
 =?utf-8?B?YXVXYkkwWTgxT0lCUmFVNzZIWHlFUmFPWm9UMWN4T2hnOWt2VlloZi9aV0JG?=
 =?utf-8?B?SWU2d0x3blBWWjc1RkFjbUFJaU9yMlhBR0NJKytLK2t5V0Z1RHFtUUJISnll?=
 =?utf-8?B?OHJld0svRlBOcWRrSmRVd2NRRGZZS0pxSHNKeExMM0dIbmtjdWdlUlRoN3Rl?=
 =?utf-8?B?UWRtc2xQRzJEVE5MYWhTcXg4dzlkYitOSnhOWHZnZm4xZndvdXVoUU1ibnZt?=
 =?utf-8?B?bHhuSmRySk9CdGxzZXkwWk54REF0ckpIb3R3N2V4b3JsL0Ywam1CWmZ4RTFj?=
 =?utf-8?B?Q3dsZjJsQ1JrU2ZOenpCNEQ4QmRXTE54ZGRwNGNoajZaRWQra3lRTUZMeFQ3?=
 =?utf-8?B?Z3c0Wnl6SG1Tb0xmMXpuZlplRW84bjFjeGdNYUZmUkRKRHFUVnZ6UmpNdEY0?=
 =?utf-8?B?SnE2dWpwNnJ3MDZpMncxSjB2clI1NEEzZzFqVVBiWGZ3M2paeVZubWlUWHhX?=
 =?utf-8?B?R3RLdFVReXBmSERqckdlQk1JcmNLcXV0QnhPL3RnT3RlZjBtTlpwemtlUk1p?=
 =?utf-8?Q?JJwjAxtwcapBjZ1QqZM2BKz07?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5432c41-527d-4121-943a-08de05d4385c
X-MS-Exchange-CrossTenant-AuthSource: CY3PR01MB9193.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 19:03:37.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tl3B6W2XLGSJ+RAJfF0BiIHjwh0LfTMwXdKvv2Lv6VPclb9ZLgRVt6G23roIO2zr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB8096

I like it. For v5 feel free to add my Reviewed-by and ack.

Tom.

Oct 7, 2025 2:45:33 PM Steve French <smfrench@gmail.com>:

> David suggested fixing this line:
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>=20
> to
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EIO;
>=20
> which makes sense to me since returning -1 could be confusing.
>=20
> On Tue, Oct 7, 2025 at 3:27=E2=80=AFAM Fushuai Wang <wangfushuai@baidu.co=
m> wrote:
>>=20
>> The return value of copy_to_iter() function will never be negative,
>> it is the number of bytes copied, or zero if nothing was copied.
>> Update the check to treat 0 as an error, and return -1 in that case.
>>=20
>> Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rath=
er than a page list")
>> Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
>> ---
>> v5: no code changes, only improve commit format
>> v4: no code changes, only add version description
>> v3: use size_t type for (copied) and check for (copied =3D=3D 0) as erro=
r.
>> v2: use (!length) check for error condition.
>> v1: use (length <=3D 0) check for error condition.
>>=20
>> fs/smb/client/smb2ops.c | 10 +++++-----
>> 1 file changed, 5 insertions(+), 5 deletions(-)
>>=20
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index 058050f744c0..ac8a5bd6aec4 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -4650,7 +4650,7 @@ handle_read_data(struct TCP_Server_Info *server, s=
truct mid_q_entry *mid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned int pad_len;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct cifs_io_subrequest *rd=
ata =3D mid->callback_data;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct smb2_hdr *shdr =3D (st=
ruct smb2_hdr *)buf;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int length;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size_t copied;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool use_rdma_mr =3D false;
>>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (shdr->Command !=3D SMB2_R=
EAD) {
>> @@ -4763,10 +4763,10 @@ handle_read_data(struct TCP_Server_Info *server,=
 struct mid_q_entry *mid,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else if (buf_len >=3D data_=
offset + data_len) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 /* read response payload is in buf */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WARN_ONCE(buffer, "read data can be either in buf or in =
buffer");
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 length =3D copy_to_iter(buf + data_offset, data_len, &rdata=
->subreq.io_iter);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (length < 0)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return leng=
th;
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 rdata->got_bytes =3D data_len;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 copied =3D copy_to_iter(buf + data_offset, data_len, &rdata=
->subreq.io_iter);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (copied =3D=3D 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -1;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 rdata->got_bytes =3D copied;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } else {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 /* read response payload cannot be in both buf and pages=
 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 WARN_ONCE(1, "buf can not contain only a part of read da=
ta");
>=20
>> --=20
>> 2.36.1
>>=20
>>=20
>=20
>=20
> --=20
> Thanks,
>=20
> Steve
