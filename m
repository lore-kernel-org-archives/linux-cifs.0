Received: from PR0P264CU014.outbound.protection.outlook.com (mail-francecentralazon11012052.outbound.protection.outlook.com [40.107.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7462222C5
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 10:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750328684; cv=fail; b=HWUQx7ld8Ym0cCX/Sos58wUkCgneZQ0dN7IeLTNQeVmChCXTnjPrq8Y9MAhNEEo+SfSHM+OQ9XWbNcery9B7O820bc+3P0+iIdwY4Z3168LG2Nmd8r/XUvRPF1uq6ilMG+stcoZKz5g/2TNDoxSGQCVj4YPQGDKmZCarr3JF640=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750328684; c=relaxed/simple;
	bh=HBbXjRqzo83o2v4K1VHzhD1O1AVePfzCs+c50dQkJOI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=edWq0JYbx9LM5WyosxKTli5JkmDT8BUQomFlHQ95/gwwwL1wJW7eUF9o7zDJ/4hESuze4qk/xzY5JCSjpkl8FSV0zt3lS/knZgefaKDVR0AtmiO6cxagMDZFojlaqGydvveT23NWZd4ij8ONGcXmtHvueDKBOYzmUJLbznxs+hY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oxya.com; spf=pass smtp.mailfrom=oxya.com; dkim=pass (2048-bit key) header.d=oxya.com header.i=@oxya.com header.b=DllYtIug; arc=fail smtp.client-ip=40.107.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oxya.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oxya.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oxya.com header.i=@oxya.com header.b="DllYtIug"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uUWQE1T5h6W2RD6v1Hn3mU7BeUZyc3YCzwtEi+qI7DPRa9pr3muI3qd1+hPhPnVm+MGzT0WYP+fy+8Cy6rWNmGeqj4UnkCYNIMAt1qzq0hdZJR28KX1JbgJXL2J10GH9xKXF7sbByRBoIDPj9kWYF6cAycuLV5xvcbBve/pMuNmQHzEyXANREjrOCIbE7xKy+IK+6W3sWg1W7X7fcK1vy1E0h4lRA1VIRFIgQIOiLDQI6ivcD88jGwznU+LtTdx+4BLy15gpsJ4XOU7J30hv3uaKrMgRJNuCQZh//7Dv5yQ2KtTj8mq7wQWUKcTQ/OUjzGHHwszN+3dTu6mp9+f2xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBbXjRqzo83o2v4K1VHzhD1O1AVePfzCs+c50dQkJOI=;
 b=lDMmTWXEWSeIurPJQrK+GW0kUKMh7FIaP1HUyEOXMlriQtVEpWV7yjV4IpJvem1WM/iQVaDhmhPkOa8gTqeXL6TM/zFqnSqFuJsRfyCXgWSuHgJUw/laFlNSUCj95r28ibuDWmOCjvBfoLleYI9jU8TwvUDz3ivROnQWPZBh9F+KSzzFwnGrawLhmWSMbCtf8uzOzfILYyuCrhDHgwjWccUqU0dGuuG1Z6RDS0dLkhrMWnbkYCSb3dBvGCHgGBvEcKW2+cOShdklKOjp1IwOHVyAQlkg9sS7RjKyZE499j4S//eW1i24QHYTPR0Erk8KPGl7OniuxxoFTt5k5pXo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oxya.com; dmarc=pass action=none header.from=oxya.com;
 dkim=pass header.d=oxya.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oxya.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBbXjRqzo83o2v4K1VHzhD1O1AVePfzCs+c50dQkJOI=;
 b=DllYtIugiswnI+prldxiUX1snU6IyKjpyjSK4/Ux7rpJ4wAKT59prw3Zsl0EJhJhqWbzLJOu8aWtWVyUB8dYgnQr2pyQE+Np5wFEZ6RZIJCRjdnXqr+fzwM998OZrxWMcdxL7LZ/xdEucWQp4fM6WgfH4xUbFmpOLcoxvODTvsBYBu7TOyFOjMil2JIfVcTT7TWNrw6gwyQjYQ6xuGSxsROg2bGquTGkfcayFVwM8tqMdLcpRM+8UBn1w6d52BSIIn/x1L5nt5v3yDryN55SlRbKnJkBtywe+++gXOHLs+qvUOPJegQ7Qw93QMMCXzIBU/h1cuGAAnhMF/CGbbozYA==
Received: from MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1c::9) by
 MRYP264MB6015.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:6f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.23; Thu, 19 Jun 2025 10:24:38 +0000
Received: from MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5302:aca:9a01:25dd]) by MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5302:aca:9a01:25dd%3]) with mapi id 15.20.8857.022; Thu, 19 Jun 2025
 10:24:37 +0000
From: Ruben Devos <rdevos@oxya.com>
To: Steve French <smfrench@gmail.com>, Paul Aurich <paul@darkrain42.org>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Paulo Alcantara
	<pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, Henrique Carvalho <henrique.carvalho@suse.com>
Subject: RE: [PATCH] smb: Log an error when close_all_cached_dirs fails
Thread-Topic: [PATCH] smb: Log an error when close_all_cached_dirs fails
Thread-Index: AQHbO2WMl6og/vX22UawOs6fIOd5lbQLH/oAgABuCNA=
Date: Thu, 19 Jun 2025 10:24:37 +0000
Message-ID:
 <MRZP264MB25231734835D21DB05558E34A37DA@MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM>
References: <20241120160154.1502662-1-paul@darkrain42.org>
 <CAH2r5mtY8nGN_TFdGZoDAq4ks++bv1K+YhbkrmX5sS8So3+ZvQ@mail.gmail.com>
In-Reply-To:
 <CAH2r5mtY8nGN_TFdGZoDAq4ks++bv1K+YhbkrmX5sS8So3+ZvQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: nl-NL
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_ActionId=7ba99a00-67c9-43f8-8176-017455d6f3ba;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_ContentBits=0;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_Enabled=true;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_Method=Standard;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_Name=Files
 -
 Public;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_SetDate=2025-06-19T10:10:37Z;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_SiteId=3ff70438-4231-45a6-a29d-efbe03c61b31;MSIP_Label_14d0ca89-6a0f-4fde-835d-6a4f42af47a6_Tag=10,
 3, 0, 1;
x-processedbytemplafy: true
templafy-owa-emailsignature-processed: true
templafy-owa-emailsignature-version: 1.0.0.15
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oxya.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2523:EE_|MRYP264MB6015:EE_
x-ms-office365-filtering-correlation-id: 0035a224-73a8-4258-4612-08ddaf1b7e87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WTNWbDVzVzgwbEo2clpSQWxoVTF4TFVoL21tWEh2bnVhYmxXU2J3YjBRS3dU?=
 =?utf-8?B?djF1NjdKMUNHSW9yenFzR2x0TXFMV1M2aHFQUGRObGpuNlpiaGRvdSt5Wllu?=
 =?utf-8?B?U3h5VFVET3pGaU5IRWllRGs1c0o1YytFOTNrN1cvVWE0bHV6a0R0SFBMN0FT?=
 =?utf-8?B?NzNLWVE0TW9VcjdlMWhZNnk5eDZrR1M5UHRTWmtweXI5RXNTSmxHQ0V5eFZw?=
 =?utf-8?B?bXBCTU5MY2NjK3BIbTBYTExZOVRGamExOEVzNWpDbDRJOHZsMDZ6QTBOSGFq?=
 =?utf-8?B?UG9PeDNxVldZNnYyNkphaUNXZ21SWkxHbDdRbFZMQVF2eXNaTjlXVENuMlBB?=
 =?utf-8?B?Y0NKRjlpMTl6YURFSFEwclZrTEJsdEowZ0U3dm5YUEhQYjgwTVVHT3pRT2Fr?=
 =?utf-8?B?QjFsa1pVa3p5R0pmMHBKTnlwTGt4dURzalBoK0o4S3RDQnF4bEZhQ2E2Q1B6?=
 =?utf-8?B?aG44ZWFOa1UzanRYcDdQR3B1OG1YZFBkVTQzTThnZXIwMUVwWWxCSk14K1F3?=
 =?utf-8?B?aUpyRytkVDcyWXQ3b2s4VFVkQWZxOXNuOU00TkxXM1VjYVJySjlVVU9KVDRB?=
 =?utf-8?B?QnpiYzhrZExVNG5jWThjZUpiQXpsR2owTC9NNFVoMGtzNzR5NDdXTFpQeGVE?=
 =?utf-8?B?dmZaZE1BS0wxQlliWGpCSityTFc1aWlvWTFHdFdKQlpjQVAxVThIUWRWamho?=
 =?utf-8?B?V0poTWxGb1h5NmxOWnRqVG1jQ2k5b2xNMlN3eHJzWkMzWjJTaGZzM0Zzd0JM?=
 =?utf-8?B?WjV1VzluSFFXRVM2OEh6ME8vdDJXOWRzdlhHMTJoL0Y1U2VncE1pMUdIQVIz?=
 =?utf-8?B?R0IrbmY4bk1KQzBmbjBuc2F3ZFd4YmVhcU5HVnAwUjYwRTFjbG15NDN5WUJ0?=
 =?utf-8?B?aStFeUxQS0ViYnkrY2hTT2JpWnpyRnkzQXl2TnN1YTRJQnBYQ1U3UGFrbzhs?=
 =?utf-8?B?ZHQ0TE4xSTlHaVFMeDFjenVobmtVS2NLcXVlUlVVanVLUmxNRFFOTTlqd2Mz?=
 =?utf-8?B?TFA4RFVZK1VVZ2hWSEI5MXptckJSQmxESjN4Y1FycExxb0RXT1lxcW8wU2NI?=
 =?utf-8?B?YWZOQnB5MFJBcERCWmZWckxGRHhwbFJIdHVuTnE5M1lRZ1pjcjVtYkdIL0wx?=
 =?utf-8?B?cDJ4RXpUWWEvem1sR0RhbjlEVnFBWjgwRWptT0htUm5vTXB5ZFBCNjJpYUtI?=
 =?utf-8?B?K1JJM2ZBeTJnbFUrMW5DR0dLbVQ5dmk2RzRqc3NxeDhyRTBzL2tJbWFqQTZC?=
 =?utf-8?B?eVJkYUxQWHdBUHVuRWw2YnNSOENsLzF5OVh1TUUvdG5aTFB4T01aUGFBalZP?=
 =?utf-8?B?R0liRWhySXJlbmRrR1BEUmYxb2tGNGw4M2dCNEVrbDJXQTcvbDdUS0p1VHVK?=
 =?utf-8?B?blp4R1JNQTE3WUdhWFB4QVZMU2hjQUdUYS9OYnZLY3VGYmVKYnhJdDloOWRw?=
 =?utf-8?B?TG04WFo2Sk40SXJDbWZSaFF3SzI2QVYzVVdWbzJEbXRub2hVWVA3Rk1IZkZL?=
 =?utf-8?B?ck5UamJsWGZ3UmpEQktISjlSY3p6dkZGQVk0aGIwS0JnM043UTQ0M29rTHdC?=
 =?utf-8?B?bG1FQTVhblFDVW96L0F2dWFYbk10VjR1by9zZEhRcmRwVmJIbWE4dWN6OE9t?=
 =?utf-8?B?c3l2OVNLQU51am1lZEFJUW5ZU3VaTWlPWjI1dS9saVV0U1ZMRWlFUEY4UGJZ?=
 =?utf-8?B?blBsUGNhUWVHcWk2dVdxVTJFOTJrRmJ5WEkzclpHc0ZLN2h3OGFMVTMyVkVh?=
 =?utf-8?B?MllTSWF0blcyTkJKUDZtUTBwYzUzckdwVzVrV2pGeVlCaE5Zb1J3R2tFSkpV?=
 =?utf-8?B?NWhLMWlPMnBkckRTVWIzSGxqZW5zYndCUC9XdGdmTlhBeUoxSE15ekFydzNG?=
 =?utf-8?B?dFVIbGtYWjI1L1gwcUpHcTlCbFl2QUcvSmR2bXl3M1JPUXNSaW9JUFpUWmlB?=
 =?utf-8?B?eEMwaXhNcEJUY21xb2dIVFB0Y09Hd051aFNhWTdaV3E5MkZ1ODduR1lHa1kv?=
 =?utf-8?B?RTljUWZ3VldRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ckttMXo4VytkMUViNmUvOWlFOGNaVWd5bTR6TkcwNHVPcXJETm5sbWJucDdt?=
 =?utf-8?B?T01FSVJ0U2pUTk15ZHlaeDAwTklLVXpLUUFHbThDV2FYMFF3QzBsdFNKRVhY?=
 =?utf-8?B?dFFZR005bno4Tkh5VnB6cWZXMmlNS2dhRm83Sk4wUlFjMUJ5QmxpSlBiR1pv?=
 =?utf-8?B?b0U1RWRXTmp6dDdXM0cwWUNpdmhDTndQUzNxTEdkVjFSOHJuYzUzR2QremJy?=
 =?utf-8?B?UWd4dmxwblZVaTNDM0dXYmxXaVJCWU55SjhvUitCU2x0SFYrZFF1UW1HbjV3?=
 =?utf-8?B?c2dOS0hDQ1hiZm1mUzdlaGtCS0VuZmNtdVFucFZMMHZWMHhWTUM5b2wrQU5F?=
 =?utf-8?B?WDF6VUs0Vzl1ellwbFRYNnBhcUJsZVI1OWI2dVorWVlwdzFDQ2FabXJnT3hP?=
 =?utf-8?B?d3djblBuYThIeGRmWEJHOVJmVlFFNFZoaFFCRUpjUG5JaG5HYlAwNkQ4RDBq?=
 =?utf-8?B?SUVCSWpubU0yQVd3QngzTzlnM3Uxa0F0L0swWGYyVjZvSU5ubXJoc3IzUFoz?=
 =?utf-8?B?QlVXQTVCZkhJT0w2MjhPdnI4WHpSeThZa0MyNklTbWg0dGNzdU1IRWM5aEJu?=
 =?utf-8?B?cEQ2YTA3eVN3WXpKYyswWmt2VFc3VWVrZHNJcUZDTzdURmN2RnRyUmxxbGZa?=
 =?utf-8?B?eXNlbGVjMnpiM0ROVERqUmI2NlN0Z3NQZEhZS2JlMFpCMU52TTJpWm1mOTI0?=
 =?utf-8?B?Szk2bmFrR3ppTVMwL0NJRXpRbFBLcmdLN3daSTZ5Z2Q3bzJyWExzVWoyYlA4?=
 =?utf-8?B?dENVMEw4b29Kb0U5KzQ5aStxaGJaaVVuNWh4UytJYnRGQ01sWE0zQnBHWTBT?=
 =?utf-8?B?bU1BOEdDN2xPR0VROTg3elR0R3lxbTlZd05nNGFZVExLbXlCMytZSTZjcjFX?=
 =?utf-8?B?QS9LWHZJQjNBWjh5dXdDcWx2aDgrWHJxRUlKM3FCK2pueWJoWWFaeDBVL0pF?=
 =?utf-8?B?QnVtOVdPbWRqQ1NDdndCQWxEcU9iTnE5QU5uODR5djVINnA0Ujk0MkU3R0h1?=
 =?utf-8?B?MVdhWGxiRkE1Z0E3WTBZNW9VTEM1enVWN1dFWlQzb0dxQ2tDeSt0blowSEdB?=
 =?utf-8?B?OVE2OGV1bEdGYkdEcXlwRmw3aG40ZlVqRzdYaEQwQU9JcnluRTRWQnl4a2Js?=
 =?utf-8?B?cmZmQU0zUVFUWWVZZTk4RDZoUHNJM2VZY0dzdHdjR1FuSDd4TUQrUnV5Y0NR?=
 =?utf-8?B?ZzNxcUszRXFMT1hoUW9hdkw0NEVXNkY4VWhZRHR1VCtjT012YzNnWkpqSjVE?=
 =?utf-8?B?TDVudjBST1ZFbUI1SDR5RmpOYmpOSWhIOTNuVVpZck52SENVTFNUVHEvcWh6?=
 =?utf-8?B?YXJpYnFKcXJwdG8rVnVIcUN5UDhUZkR1V0tNMDVpd252d3dwdEJQM1o5Q0Nj?=
 =?utf-8?B?QlA0Q2xteUo1R0pRRGhnR0xNQ2xmTHJENEMyRkhTdDRtNnIwdHBoTXp4WEVZ?=
 =?utf-8?B?Um1hVTd2UWc3UHg1M2VGTkhINHZoTk1qT3NVOGFmcnpScVFIQVRKTFcrWjFm?=
 =?utf-8?B?ZVpsZHJWTys3Vk50Q1pnTm0rcDR4MlZEUENOa2QyUjM5T2QxbWNEelQwK2lL?=
 =?utf-8?B?bTRBVTk0NWxvSEVuWjZTbWVjRXRTWnVQVjNwK0JaLzVWallsSFUyWUJTenVa?=
 =?utf-8?B?WXAzRmE1RGU2dlFYV3k2MHpMNDdYNDQxRHE3Ykx5S1ZPaGdwMFpBZFBoQWtz?=
 =?utf-8?B?bWhha1dCUFM0UHhxVUZWZEhORWk0RWlCTndrVURZWGhobmhpQnhkU0wvSDhz?=
 =?utf-8?B?Um95WFdLa0M0cGJhVzMyZ1BnWEdhQ3B3bXRCaEV1Y2VlL2hsYnViUVVhU2hu?=
 =?utf-8?B?V2hocnFMazRsNnI2LzVPYVBVTTY1WG5UL1hLMmhXWVE2V2QzMDJWOGliWTB3?=
 =?utf-8?B?aUkyejluL0tHY00ySUs4cko1Yzk5bmY1YnI1YWJ0c0Rrd1hTdEFTRWkwM0hm?=
 =?utf-8?B?Z05xWWdPUmlEMzVaN0hiS2NJclZjZUp6azE5RXlSN2RhUFZZU1N5SVZUbTZS?=
 =?utf-8?B?SWphc0NadnAzR09WN25xaDRQd0pJUEZ5dll1L3QwQXhMbThuNWQyVEpvQnFM?=
 =?utf-8?B?NFFlTWk4T3lVaXV1QS84ais2a1RqWnJvS00vdndkdmZPUDNCSHJ6UytkTE1z?=
 =?utf-8?Q?4fsY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: oxya.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2523.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 0035a224-73a8-4258-4612-08ddaf1b7e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 10:24:37.7994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3ff70438-4231-45a6-a29d-efbe03c61b31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mLRzfPkP1wSpFQlRdsI7VByb4MQGvL05vGTdVyI4Ay7SW7CR3avqo+DuQ4Oe/iuS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRYP264MB6015

PiAtLS0tLU9vcnNwcm9ua2VsaWprIGJlcmljaHQtLS0tLQ0KPiBWYW46IFN0ZXZlIEZyZW5jaCA8
c21mcmVuY2hAZ21haWwuY29tPg0KPiBWZXJ6b25kZW46IGRvbmRlcmRhZyAxOSBqdW5pIDIwMjUg
NTozNw0KPiBBYW46IFBhdWwgQXVyaWNoIDxwYXVsQGRhcmtyYWluNDIub3JnPg0KPiBDQzogbGlu
dXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc7IFJ1YmVuIERldm9zIDxyZGV2b3NAb3h5YS5jb20+OyBQ
YXVsbw0KPiBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5jb20+OyBSb25uaWUgU2FobGJlcmcgPHJv
bm5pZXNhaGxiZXJnQGdtYWlsLmNvbT47DQo+IFNoeWFtIFByYXNhZCBOIDxzcHJhc2FkQG1pY3Jv
c29mdC5jb20+OyBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT47DQo+IEJoYXJhdGggU00gPGJo
YXJhdGhzbUBtaWNyb3NvZnQuY29tPjsgSGVucmlxdWUgQ2FydmFsaG8NCj4gPGhlbnJpcXVlLmNh
cnZhbGhvQHN1c2UuY29tPg0KPiBPbmRlcndlcnA6IFJlOiBbUEFUQ0hdIHNtYjogTG9nIGFuIGVy
cm9yIHdoZW4gY2xvc2VfYWxsX2NhY2hlZF9kaXJzIGZhaWxzDQo+IA0KPiANCj4gV2FzIGxvb2tp
bmcgdGhyb3VnaCBvbGQgcGF0Y2hlcyBhbmQgbm90aWNlZCB0aGlzIGRpcl9sZWFzZSBwYXRjaCB3
YXNuJ3QgbWVyZ2VkLg0KPiBBbnkgdGhvdWdodHMgb24gd2hldGhlciBpdCBpcyBzdGlsbCB2YWxp
ZCBhbmQgd29ydGggbWVyZ2luZz8NCg0KSGkgU3RldmUsDQoNCkkgY29udGFjdGVkIFBhdWwgZGly
ZWN0bHkgbGFzdCB5ZWFyIHdoZW4gSSBzYXcgaGlzIHBhdGNoZXMgZm9yIHRoZSBkZW50cnkgc3Rp
bGwgaW4gdXNlDQppc3N1ZS4NClRoZSBleHRyYSBtZXNzYWdlIHRoYXQncyBsb2dnZWQgd2l0aCB0
aGlzIHBhdGNoIGNvdWxkIGJlIHVzZWZ1bCBmb3Igc3lzYWRtaW5zLCBpdA0KZ2l2ZXMgYSBiaXQg
bW9yZSBjb250ZXh0IHRvIHdoYXQgaGFwcGVuZWQuIEkgd2lsbCBsZWF2ZSBpdCB1cCB0byB0aGUg
ZGV2ZWxvcGVycyB0aG91Z2ggDQp0byBkZWNpZGUgaWYgc3RpbGwgbmVlZHMgdG8gYmUgbWVyZ2Vk
Lg0KDQo+IA0KPiBDb3VsZCBiZSBpbXBvcnRhbnQgZ2l2ZW4gdGhlIHJlY2VudCB3b3JrIG9uIGRp
ciBsZWFzZXMNCj4gDQo+IA0KPiBPbiBXZWQsIE5vdiAyMCwgMjAyNCBhdCAxMDowMuKAr0FNIFBh
dWwgQXVyaWNoIDxwYXVsQGRhcmtyYWluNDIub3JnPiB3cm90ZToNCj4gPg0KPiA+IFVuZGVyIGxv
dy1tZW1vcnkgY29uZGl0aW9ucywgY2xvc2VfYWxsX2NhY2hlZF9kaXJzKCkgY2FuJ3QgbW92ZSB0
aGUNCj4gPiBkZW50cmllcyB0byBhIHNlcGFyYXRlIGxpc3QgdG8gZHB1dCgpIHRoZW0gb25jZSB0
aGUgbG9ja3MgYXJlIGRyb3BwZWQuDQo+ID4gVGhpcyB3aWxsIHJlc3VsdCBpbiBhICJEZW50cnkg
c3RpbGwgaW4gdXNlIiBlcnJvciwgc28gYWRkIGFuIGVycm9yDQo+ID4gbWVzc2FnZSB0aGF0IG1h
a2VzIGl0IGNsZWFyIHRoaXMgaXMgd2hhdCBoYXBwZW5lZDoNCj4gPg0KPiA+IFsgIDQ5NS4yODEx
MTldIENJRlM6IFZGUzogXFxvdHRlcnMuZXhhbXBsZS5jb21cc2hhcmUgT3V0IG9mIG1lbW9yeQ0K
PiA+IHdoaWxlIGRyb3BwaW5nIGRlbnRyaWVzIFsgIDQ5NS4yODE1OTVdIC0tLS0tLS0tLS0tLVsg
Y3V0IGhlcmUNCj4gPiBdLS0tLS0tLS0tLS0tIFsgIDQ5NS4yODE4ODddIEJVRzogRGVudHJ5IGZm
ZmY4ODgxMTU1MzExMzh7aT03OCxuPS99DQo+ID4gc3RpbGwgaW4gdXNlICgyKSBbdW5tb3VudCBv
ZiBjaWZzIGNpZnNdIFsgIDQ5NS4yODIzOTFdIFdBUk5JTkc6IENQVTogMQ0KPiA+IFBJRDogMjMy
OSBhdCBmcy9kY2FjaGUuYzoxNTM2IHVtb3VudF9jaGVjaysweGM4LzB4ZjANCj4gPg0KPiA+IEFs
c28sIGJhaWwgb3V0IG9mIGxvb3BpbmcgdGhyb3VnaCBhbGwgdGNvbnMgYXMgc29vbiBhcyBhIHNp
bmdsZQ0KPiA+IGFsbG9jYXRpb24gZmFpbHMsIHNpbmNlIHdlJ3JlIGFscmVhZHkgaW4gdHJvdWJs
ZSwgYW5kIGttYWxsb2MoKQ0KPiA+IGF0dGVtcHRzIGZvciBzdWJzZXFldWVudCB0Y29ucyBhcmUg
bGlrZWx5IHRvIGZhaWwganVzdCBsaWtlIHRoZSBmaXJzdCBvbmUgZGlkLg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogUGF1bCBBdXJpY2ggPHBhdWxAZGFya3JhaW40Mi5vcmc+DQo+ID4gU3VnZ2Vz
dGVkLWJ5OiBSdWJlbiBEZXZvcyA8cmRldm9zQG94eWEuY29tPg0KPiA+IENjOiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+ID4gLS0tDQo+ID4NCj4gPiBUaGlzIGNvdWxkIGFsc28gYmUgZm9sZGVk
IGRpcmVjdGx5IGludG8gInNtYjogRHVyaW5nIHVubW91bnQsIGVuc3VyZQ0KPiA+IGFsbCBjYWNo
ZWQgZGlyIGluc3RhbmNlcyBkcm9wIHRoZWlyIGRlbnRyeSIuDQo+ID4NCj4gPiAtLS0NCj4gPiAg
ZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMgfCAxNCArKysrKysrKysrKystLQ0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYyBiL2ZzL3NtYi9jbGllbnQvY2Fj
aGVkX2Rpci5jDQo+ID4gaW5kZXggMDA0MzQ5YTdhYjY5Li44YjUxMGM4NThmNGYgMTAwNjQ0DQo+
ID4gLS0tIGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMNCj4gPiArKysgYi9mcy9zbWIvY2xp
ZW50L2NhY2hlZF9kaXIuYw0KPiA+IEBAIC00ODgsMTIgKzQ4OCwyMSBAQCB2b2lkIGNsb3NlX2Fs
bF9jYWNoZWRfZGlycyhzdHJ1Y3QgY2lmc19zYl9pbmZvDQo+ICpjaWZzX3NiKQ0KPiA+ICAgICAg
ICAgICAgICAgICBpZiAoY2ZpZHMgPT0gTlVMTCkNCj4gPiAgICAgICAgICAgICAgICAgICAgICAg
ICBjb250aW51ZTsNCj4gPiAgICAgICAgICAgICAgICAgc3Bpbl9sb2NrKCZjZmlkcy0+Y2ZpZF9s
aXN0X2xvY2spOw0KPiA+ICAgICAgICAgICAgICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5KGNmaWQs
ICZjZmlkcy0+ZW50cmllcywgZW50cnkpIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICB0
bXBfbGlzdCA9IGttYWxsb2Moc2l6ZW9mKCp0bXBfbGlzdCksIEdGUF9BVE9NSUMpOw0KPiA+IC0g
ICAgICAgICAgICAgICAgICAgICAgIGlmICh0bXBfbGlzdCA9PSBOVUxMKQ0KPiA+IC0gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgaWYgKHRtcF9saXN0ID09IE5VTEwpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIC8qDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBJZiB0aGUg
bWFsbG9jKCkgZmFpbHMsIHdlIHdvbid0IGRyb3AgYWxsDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKiBkZW50cmllcywgYW5kIHVubW91bnRpbmcgaXMgbGlrZWx5IHRvIHRy
aWdnZXINCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIGEgJ0RlbnRyeSBz
dGlsbCBpbiB1c2UnIGVycm9yLg0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICovDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjaWZzX3Rjb25fZGJnKFZG
UywgIk91dCBvZiBtZW1vcnkgd2hpbGUgZHJvcHBpbmcgZGVudHJpZXNcbiIpOw0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgc3Bpbl91bmxvY2soJmNmaWRzLT5jZmlkX2xpc3Rf
bG9jayk7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzcGluX3VubG9jaygm
Y2lmc19zYi0+dGxpbmtfdHJlZV9sb2NrKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGdvdG8gZG9uZTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICB9DQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgc3Bpbl9sb2NrKCZjZmlkLT5maWRfbG9jayk7DQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgdG1wX2xpc3QtPmRlbnRyeSA9IGNmaWQtPmRlbnRyeTsNCj4g
PiAgICAgICAgICAgICAgICAgICAgICAgICBjZmlkLT5kZW50cnkgPSBOVUxMOw0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgIHNwaW5fdW5sb2NrKCZjZmlkLT5maWRfbG9jayk7DQo+ID4NCj4g
PiBAQCAtNTAxLDEwICs1MTAsMTEgQEAgdm9pZCBjbG9zZV9hbGxfY2FjaGVkX2RpcnMoc3RydWN0
IGNpZnNfc2JfaW5mbw0KPiAqY2lmc19zYikNCj4gPiAgICAgICAgICAgICAgICAgfQ0KPiA+ICAg
ICAgICAgICAgICAgICBzcGluX3VubG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsNCj4gPiAg
ICAgICAgIH0NCj4gPiAgICAgICAgIHNwaW5fdW5sb2NrKCZjaWZzX3NiLT50bGlua190cmVlX2xv
Y2spOw0KPiA+DQo+ID4gK2RvbmU6DQo+ID4gICAgICAgICBsaXN0X2Zvcl9lYWNoX2VudHJ5X3Nh
ZmUodG1wX2xpc3QsIHEsICZlbnRyeSwgZW50cnkpIHsNCj4gPiAgICAgICAgICAgICAgICAgbGlz
dF9kZWwoJnRtcF9saXN0LT5lbnRyeSk7DQo+ID4gICAgICAgICAgICAgICAgIGRwdXQodG1wX2xp
c3QtPmRlbnRyeSk7DQo+ID4gICAgICAgICAgICAgICAgIGtmcmVlKHRtcF9saXN0KTsNCj4gPiAg
ICAgICAgIH0NCj4gPiAtLQ0KPiA+IDIuNDUuMg0KPiA+DQo+ID4NCj4gDQo+IA0KPiAtLQ0KPiBU
aGFua3MsDQo+IA0KPiBTdGV2ZQ0KUnViZW4NCg==
