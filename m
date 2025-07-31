Received: from loire.is.ed.ac.uk (loire.is.ed.ac.uk [129.215.16.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC32413A258
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 19:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=129.215.16.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753989883; cv=fail; b=bWm8hD+9QcPKq57Kika6R9wC7C7vyXn/Qukhk90DEMYKpTK9YMNj6dGCuR/e7luk3JV0e3a6ofe54I/VHNLSUiaB9hqTqOoSRauIXhrOiqRLV0Y5+BoGjUFDsYnIosJITJXWuotzWWKbMbd3K+6RZ6z+MtL8a1F+q4kvTolLWp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753989883; c=relaxed/simple;
	bh=KpH6SU/9fxoKAhwNiFCadu/q2i3l6me6/GBpLnbPAak=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gUcXQH5QxoVmFw/lz/mtfMYkJUUQUYMI/HVdOsrcF25UiH/VQLFAQzZgBTz75fKal4S4dp4v1t076w8Nw6sX8B9sN+mLMdtBuF0Gd7xzSs3NnXXkR8bokFiqC3NxGdJ4v+d2EtpjEhtIuD2maRcpkBfunO0P1FUqje0c203z8GE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ed.ac.uk; spf=pass smtp.mailfrom=ed.ac.uk; dkim=pass (2048-bit key) header.d=ed.ac.uk header.i=@ed.ac.uk header.b=JdToA5Hj; arc=fail smtp.client-ip=129.215.16.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ed.ac.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ed.ac.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ed.ac.uk header.i=@ed.ac.uk header.b="JdToA5Hj"
Received: from exseed.ed.ac.uk (hbdat4.is.ed.ac.uk [129.215.235.40])
	by loire.is.ed.ac.uk (8.15.2/8.15.2) with ESMTPS id 56VJOFpD2689102
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Jul 2025 20:24:15 +0100
Received: from hbdkb4.is.ed.ac.uk (129.215.235.39) by hbdat4.is.ed.ac.uk
 (129.215.235.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Thu, 31 Jul
 2025 20:24:15 +0100
Received: from GV1PR07CU001.outbound.protection.outlook.com (40.93.214.100) by
 hbdkb4.is.ed.ac.uk (129.215.235.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 20:24:15 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9meRqH3hnit+Dps9QJBMAnEQaJPmJG+dncDkp2onRB9u8BJzm+k0WZytNbSt+4wRIglbpZ92ZIBH29WZgnpytuinaOgA1fxyguEYtptvahPtR9Yri1KVse5wVumZTUugEIlTPJMjZCyzOzBoR3tbTsFuBcHuwwabtdwOpBhKGnSmw5VJRoy3/+KRCr07K+l/d9Iob+2A1jFiKwvMOZi6VXOOdVu+pLd0niBiLRgS6equiEDIYRB37CtLdK2TvNX+z2ZnOFatFseYM2Zoh+O9fJA7C8hXX8i6lMMsPlA9JIp4SFuEJ5EyZQuxnc6zrAH/0pavkQ8N0qhq9vttcp8yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KpH6SU/9fxoKAhwNiFCadu/q2i3l6me6/GBpLnbPAak=;
 b=EurQ9eolxsKQrFPFWpoZoNyyeIZiyBjSdwfVShzcsa5ZsRL8sGgN05s7cIZ24IzTG2AnI1cbJR+Qg6zvk9Wdv2Ca7MDwBdS2mudOqh+s4h9RNnDcthbEpv1Cs+CeLJJ9TvW74l/dXmAQe22CcQUrqSoufYkz20Qnm5KyEHDCwvFWi4hrY/tsh1m3wWkR4gEg7hnezOqaHbUYjDYOAHb63I7e1DOqDuIm1vgJNCXMJYzxjIuRyCcULzB8iO4kUs5LUiQ2eMfSAAzKWOPiuLVZIJ4KwmXlqY5E3wWL4DSwNAD5XwC8BRq4cdwzuPr81PUBX6mKp61fuliZRJMUmQMV1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ed.ac.uk; dmarc=pass action=none header.from=ed.ac.uk;
 dkim=pass header.d=ed.ac.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ed.ac.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpH6SU/9fxoKAhwNiFCadu/q2i3l6me6/GBpLnbPAak=;
 b=JdToA5HjKhvCi4NQt746qu7Gjk1JeymXV96YSzZKTcPn2HvrATXQlcVMqC2W/KOCahjylND3XKiVLctaBvdztMMKdkK+3zqA4dBT+cX2JAE0MCkS6Lb36GwcMSHHyuJSHsvmdbYbOnxtebjqeUMdhsZ8kvJ3g8jI6IjT8qwmYdZcxRJK6zfVYiWlp+QwWuuyyR8+s9gvEgDAf/CpXyy9PWKAZ/vcb3g+G933XBXqvNkvWYfTtE5JTbE717bOul1vPoIfVhvHwyxUP4SYEsbLUq4tFPAV8vMFODlRnyy96K4FzuIMXBnTALh5PN4U4L/0TstcnNLSlI8yc/3kEfpE/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ed.ac.uk;
Received: from AS8PR05MB8851.eurprd05.prod.outlook.com (2603:10a6:20b:426::5)
 by VI0PR05MB11522.eurprd05.prod.outlook.com (2603:10a6:800:245::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Thu, 31 Jul
 2025 19:24:12 +0000
Received: from AS8PR05MB8851.eurprd05.prod.outlook.com
 ([fe80::ccfb:7666:1440:9029]) by AS8PR05MB8851.eurprd05.prod.outlook.com
 ([fe80::ccfb:7666:1440:9029%4]) with mapi id 15.20.8989.015; Thu, 31 Jul 2025
 19:24:07 +0000
Message-ID: <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
Date: Thu, 31 Jul 2025 20:24:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>
CC: Ralph Boehme <slow@samba.org>, Samba Listing <samba@lists.samba.org>,
        CIFS
	<linux-cifs@vger.kernel.org>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
Content-Language: en-US
From: Matthew Richardson <m.richardson@ed.ac.uk>
Autocrypt: addr=m.richardson@ed.ac.uk; keydata=
 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
 RVt9Yw==
In-Reply-To: <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------L4R9aqiXU7oDVe6Vo70WCTO0"
X-ClientProxiedBy: LNXP265CA0017.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::29) To AS8PR05MB8851.eurprd05.prod.outlook.com
 (2603:10a6:20b:426::5)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR05MB8851:EE_|VI0PR05MB11522:EE_
X-MS-Office365-Filtering-Correlation-Id: f40ae3b1-7c4d-4e08-f34e-08ddd067d186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NmhyWDBNdXVzVExWL0JvMGllRFBiOThkazZ0eWt4bStUd1gwYzBzb2Rndzlp?=
 =?utf-8?B?Nmk1M2UrT09tOUxMcEs5aERjTWFyb3pWTkJXVEUvQTJFOFVlNmVqUy9rdElW?=
 =?utf-8?B?bTQ2N3RZNzBXbFViMHNtUmVuN2RxYTRmWE4yRTZvTFFIVFNaNW1RaUdsR3oy?=
 =?utf-8?B?bmQzbkFidUtIQ1luN2phblNCTGh5WlRXUWQwOHR2V0hPWHM2KzZEdXQ2Q3Q4?=
 =?utf-8?B?RlJYcjAwWDdONERJbGpJNUJqYlE0RS9ubDZobGc2d2VSYitWcm0rTW85Ykl0?=
 =?utf-8?B?VkpJTXA2b1ZBNkNzR3N1TW1WVnV6VWhDeFpKZjlmZ1lhTFFhRGd4bGhRbzR5?=
 =?utf-8?B?eWxsbWZCaVhMY1lQK0NaTzJBSWtMcUhvcGxLd1B1OCtLbW9mKzA4UFBZWEhE?=
 =?utf-8?B?UjBSVkFPY2grbzlkUjMyVzRFMy9VVDBjbHB0NHRpRXllVHF6YjJRL1FVVnhB?=
 =?utf-8?B?b1F2Z1lpNVlOazFLRURkZGpQdXdwaVh6Z2phUEthbFpwOGhMRGFObCtEd1Bv?=
 =?utf-8?B?YVY1TTRsc2MvVzFZdmY2aDVkQjBmOFVtZ0g0R0R5ZlJpSlJrZXVFRHdmSW1V?=
 =?utf-8?B?R0RrT3AydUJRVU83WEZoaWtUU0ZQZHRSSG5qRndncllDZGpGZWlNRDM1QVhW?=
 =?utf-8?B?bmxhMXdRaWYwMkFEZnpaZUs3b1FobUpkT0ZlYVF6Z0NUTXVUT0FGRWxka0tU?=
 =?utf-8?B?Zm5tS1hIZmZtYVBTVkRmMVRzNzUvY0ZhWC9yVTZlWGEwOUFPdWpUOTlDTlZO?=
 =?utf-8?B?dWJKTzZzKy9TdHZEV0c3UXhma04yYzFyWWRCSGZIWkUzQkxzeUpvVUhqUytj?=
 =?utf-8?B?NUxxalczWXQ1K0NYdWsrRkd0TDZMb1FJb1Bwb0hVS2dwbEd4eXZRa1dLYSt6?=
 =?utf-8?B?V05YbDN1T1dtTkFjYm1mRURaQnFHaWdkdHhrczVGUHE1eEY3UkdldDFLaTdT?=
 =?utf-8?B?cmlSQkJEdlFzajhLMC9KS2VDdUtTRFN6S1gwUnlGV0lpTFB3T3h2Wm9HMVlM?=
 =?utf-8?B?M3Y0clh2bzF2V3FjRnpnQkZqWVFEUFVqQ1dkT0NQbUl6QnFKSkE3Zlpkb0Fh?=
 =?utf-8?B?L080d25VMGdsNDc1MUxkTjVMOGRwWEVSRmRoeU54UnVWckJyV2Q3UFNuc0ln?=
 =?utf-8?B?R0V3L1NWV2d3Z0VleHk0N2lNTTRFejZVUHVnYUIyWnRDdVd2YTdCaTVjK1ZV?=
 =?utf-8?B?MzNHRzlFNXdJR21iQWVrOVBaQUs4OFVGdlplWDJNOS9GTFJtSCtMbWhNbjg1?=
 =?utf-8?B?MjlsL1IyRmFCWHQ1OTc4UlIzTWZDUFYwazVCR2c3T09tUS9nZzdMZW9GaVVN?=
 =?utf-8?B?clRmOGZ0aWg4K0pua2NKbFpYVTJCL3RyQlJ5QTI1S2pPT3owOGp6bnJvNlJm?=
 =?utf-8?B?UmRZSTZnK0paWnpGV3NDWG91VmxWL3R3THNUL042ZWtvRnR1Z1NRMUlaSVU0?=
 =?utf-8?B?L2dTUlRuYUJNUlJCMnRHMEY4TFpSL3lScDFxb2VaczBGWmJOQk9kRldKRzJt?=
 =?utf-8?B?Q3l6ZlU1VXV6Y3l2aG5maDFRZkNJLy9FUUhqeFhHSlNTdjV4cTZITmw3MzB3?=
 =?utf-8?B?c1RWZE1FS3NaMWdMUk1GaTZwdlJxUjJzaFdMM0VRWnpwK2M3NWd6NG5CNjVk?=
 =?utf-8?B?WDJSeVE0M3ZtNjhZa1ArTm8xUHlCTjQ3a0RzK2RIUTJHcDBiQ3RuZzh5ZE5T?=
 =?utf-8?B?Z29oc1lWMXgxazVINkFRN2hUbVYvTjFmTmd0dnhyNlhBSjRrUTZEcjB4UmZ5?=
 =?utf-8?B?VW15cGRqTDlyajRYUjlQTHhTMHJ1dlpxNllBenRPSSsrZG5XYU1SVWFxcGZV?=
 =?utf-8?Q?T+ntBpCW5O3G5M2bP8BkzMfH9guzg/OM95VPQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR05MB8851.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2sxTU53K1V6MGVENmtvS0dzeDdvTXFCNk9INUd4TW1LV1J4aXVoUUtzaGFs?=
 =?utf-8?B?Sm1pZmExN0lyMmc4UWdBVGlHNUpUNFRxSWFxdHVkOG8zODJRWXQ5T1liQ1RS?=
 =?utf-8?B?L3Z2WStndXJ3WkFIQWEvL0JuNUljVHBvY2VzRTlYWDhVcEhIcUNGRTFFNndr?=
 =?utf-8?B?UGVINzNJL28wYjBZV0Qzc0plc2dSTVZJMWR2ZFNNVjJXcXZQZTJ3MDlibDJk?=
 =?utf-8?B?NkM3c0RhSGUzR3IyZ1EwcThZc1EvSzhmZHU2QnZoOFFHYUR0YWFYTVpjb1pG?=
 =?utf-8?B?bmRtQTJIMDVNSllLVEJPZ2lIL0M3SmZDM2tQV1A5RWlSNWMzdXNJaDAzSWdk?=
 =?utf-8?B?bjl0bkNlQUE2bWxXdXdxamVJMGk0ZVlvYzd0d3BTU1pVdVdUT2Y5Qmgxd01B?=
 =?utf-8?B?ZkhuQ0cxbUlGeDR0d2M0clZWL2IvM0hHbk15WXFNbnNjM1U5MXMvVklSeEx0?=
 =?utf-8?B?K3RZRWZyTEZmUGs3VDcrbjBad3J1WGREMUVjVW5YYnZaUVhpL0RxV21jOUJB?=
 =?utf-8?B?MjVpeUkxYVVDalZMNW8zMTF3Z1JvUUJNOHNHT0YyN3VhekZZazNKaGV4bzBw?=
 =?utf-8?B?OHczQ2dDYVRlSVV3bUtkRHNlZ3B0U3FvY0YxNGo0eVMwRTlvcDkxWGFmNnYr?=
 =?utf-8?B?QnFSNGRVaERPMG0zTzJNUy9PNFZ2Q1Q0S0c0T0ZtcHF4cTBsR3JEMzNYWUlj?=
 =?utf-8?B?UE1KMlFPRlBXRWEvZll6ZkhiNjdWYmczNGhJeHFjSW9GcFhRck5vaG5adEZ0?=
 =?utf-8?B?OFBmQXdmSTR6dktLeWtReDhLTDRDNXJsOHRSQ3FDVlcrRENyMUV5YkdKMC9u?=
 =?utf-8?B?cjRHK29ha24zRXR5ZnF1aWRnR2ZDa1ZERkRhUUxnRVZ3dS9xcTNxL0NxYldN?=
 =?utf-8?B?NW9nei92NHZqRDVmQVFtNDVTZTQ5cHE5dWNSQ0s2OHlQSEIvTEkyTVhFSVZt?=
 =?utf-8?B?Mk5vcFFJbW9vQkJ2UlFHemF3UnZ6NFdrZm1EL3JWTDJUN1k5bGRlamhJQXBw?=
 =?utf-8?B?aDlnTk1zVXlyRnNweFNKUDk1Ulk5SWM5eFVSTzJuOXIvL3hOd2JDWFFuVmJH?=
 =?utf-8?B?Sy83dkJhQ1FpN3hQUFRmQ1NORnhhRVFPRXdsOHFreUdWNTJGWkhBL29xaXcv?=
 =?utf-8?B?SzFSUTFqVWlhZmFqNWZBZWV4M1hIbU52S0NxMTVQN3k0c0JYZ3ZlcWMzZ1ZX?=
 =?utf-8?B?YTZoRHdYcy9jZjA1RkRITVBMRWNGaWhWVktIWnBVZDIyZy9RREozVDlJcTJq?=
 =?utf-8?B?endmbmtGYlUyQ21WTWsrd1g0TE5XeFNFSGR2V2tSdVRETWtnQ2owSzFTTS9z?=
 =?utf-8?B?eHRrN0ZKMDBhTFhubFY0QWVmbG5HUC8yc0cwNzYrZXd4V1hWdmFEbXRDanhW?=
 =?utf-8?B?Z2FIcXNiL1Z2c09mczVDdis0N1JyTGdIVGFiVFZNdjJtVFNDWnRlN1FSSjRZ?=
 =?utf-8?B?bG5CMW1NNVJJQ2pmTDRWUVU5TTdkK2x3VUczUGNydWxRbEdwWDZtMXkyQkNO?=
 =?utf-8?B?QTBoL1M3NHBnWC9WdWtncXp6YkYyVzl3cFd0RE4ycDB1Ni9VMld2THl6K0Z2?=
 =?utf-8?B?eHVDSHBiRFhzVXJZY1FXbFJNdzVROWlJK2tKc2gxYXF3UjRVb2NySDZZdlR0?=
 =?utf-8?B?RE9uR0dMaFFRN3RLeUliWVZieXh6L1hYK2pHWUhJMUx2MmdQNEwzQW9RdWwz?=
 =?utf-8?B?ZERCSCt0cTJaYzg1M2RZSi9oVVNBOWN5Q0dOYzArMEhIMjZMNUMyRTZYNTc4?=
 =?utf-8?B?YVFlQ3RUeTZ4NXRqS0RqTGtybGJDa0U5bTFUMVlEWURTM1RwRkhJRlRwVnI2?=
 =?utf-8?B?YWozZmRTVHdzOFdrbmFtQTZLQW5sMFVnL2VCUW9oZVpETW5ZUGRsRWdxV0tM?=
 =?utf-8?B?Y3JTVldEWGlHNTdJUm1MSzZCNFpZRExidDFNUzRXYVFabEJkSWtzK2pBRXhV?=
 =?utf-8?B?c1ptMGpJVzhPRnd0dk9CV3lXZVZqRDVtdGs1MmtGV0JKNTB2bHFtUGR5a0FN?=
 =?utf-8?B?d1JwSDFIYXNqaVBZZ2pxSXQxbVE1cDV2OFhzbDB5akNTaS9yM2ZRTVpXZG5G?=
 =?utf-8?B?ZGgrTDFxZGtiY2NaQkFBVDQxc0Vlcmh1YkxEMGVvL3VwVHI2QXBuanFHdzFB?=
 =?utf-8?Q?Agck1cgsV1DxPRSy+rQx44xBq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f40ae3b1-7c4d-4e08-f34e-08ddd067d186
X-MS-Exchange-CrossTenant-AuthSource: AS8PR05MB8851.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 19:24:07.4427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2e9f06b0-1669-4589-8789-10a06934dc61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0lRB7Bf53ULfRl/8WmiNFloDE61epn2bt2j4lnS/qb4V9Bhou+ys7qsJut0FzqHCZuPnPUX2270N4LnD871DXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR05MB11522
X-OriginatorOrg: ed.ac.uk
X-Edinburgh-Scanned: at loire.is.ed.ac.uk

--------------L4R9aqiXU7oDVe6Vo70WCTO0
Content-Type: multipart/mixed; boundary="------------eAXd0Po64JWS3I85cL8HaE1l";
 protected-headers="v1"
From: Matthew Richardson <m.richardson@ed.ac.uk>
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>
Cc: Ralph Boehme <slow@samba.org>, Samba Listing <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
Message-ID: <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
In-Reply-To: <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>

--------------eAXd0Po64JWS3I85cL8HaE1l
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SSd2ZSBqdXN0IHRyaWVkIHRoZSA2LjE2IGtlcm5lbCBmcm9tIG1haW5saW5lIChMaW51eCB2
bS1iIA0KNi4xNi4wLTA2MTYwMC1nZW5lcmljICMyMDI1MDcyNzIxMzggU01QIFBSRUVNUFRf
RFlOQU1JQyBTdW4gSnVsIDI3IA0KMjI6MDA6MzYgVVRDIDIwMjUgeDg2XzY0IHg4Nl82NCB4
ODZfNjQgR05VL0xpbnV4KSBhbmQgd2hpbGUgbWtmaWZvIHdvcmtzIA0KYWdhaW4sIGxuIC1z
IGlzIHN0aWxsIGdpdmluZyAnb3BlcmF0aW9uIG5vdCBzdXBwb3J0ZWQnLg0KDQpUaGFua3Ms
DQoNCk1hdHRoZXcNCg0KT24gMzEvMDcvMjAyNSAxOTo1MywgU3RldmUgRnJlbmNoIHdyb3Rl
Og0KPiAJDQo+IFlvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBzbWZyZW5jaEBnbWFp
bC5jb20uIExlYXJuIHdoeSB0aGlzIGlzIA0KPiBpbXBvcnRhbnQgPGh0dHBzOi8vYWthLm1z
L0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbj4NCj4gCQ0KPiANCj4+IEZJTEVfU1VQ
UE9SVFNfUkVQQVJTRV9QT0lOVFMsIHdoaWNoIGJyZWFrcyBhZ2FpbnN0IHNhbWJhIGJlY2F1
c2UgaXQNCj4gaXNuJ3Qgc2V0LsKgIElPVywgd2Ugc2hvdWxkIHNraXAgdGhpcyBjaGVjayBm
b3IgU01CMy4xLjEgUE9TSVggbW91bnRzLg0KPiANCj4gV2UgZGlkIGFkZCB0aGlzIHBhdGNo
IHRvIDYuMTYgaW4gbWFpbmxpbmUNCj4gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHVi
L3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC8gDQo+IGNvbW1pdC9m
cy9zbWIvY2xpZW50P2lkPTg3NjdjYjNmYmQ1MTRjNGNmODViNGY1MTZjYTMwMzg4ZTg0NmY1
NDAgDQo+IDxodHRwczovL2V1cjAyLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29t
Lz8gDQo+IHVybD1odHRwcyUzQSUyRiUyRmdpdC5rZXJuZWwub3JnJTJGcHViJTJGc2NtJTJG
bGludXglMkZrZXJuZWwlMkZnaXQlMkZ0b3J2YWxkcyUyRmxpbnV4LmdpdCUyRmNvbW1pdCUy
RmZzJTJGc21iJTJGY2xpZW50JTNGaWQlM0Q4NzY3Y2IzZmJkNTE0YzRjZjg1YjRmNTE2Y2Ez
MDM4OGU4NDZmNTQwJmRhdGE9MDUlN0MwMiU3QyU3Q2MyOWI5ODI4MzM1YzQyZmE1NGY5MDhk
ZGQwNjM4NzQ2JTdDMmU5ZjA2YjAxNjY5NDU4OTg3ODkxMGEwNjkzNGRjNjElN0MwJTdDMCU3
QzYzODg5NTg0ODA4Mjc1Njc3MCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpGYlhCMGVV
MWhjR2tpT25SeWRXVXNJbFlpT2lJd0xqQXVNREF3TUNJc0lsQWlPaUpYYVc0ek1pSXNJa0ZP
SWpvaVRXRnBiQ0lzSWxkVUlqb3lmUSUzRCUzRCU3QzAlN0MlN0MlN0Mmc2RhdGE9aFFkU1Zh
cUpGUElqaXdEUHVOJTJGbE9uJTJGU3FHbHFnOFN0czF5SDI3MnN2dEElM0QmcmVzZXJ2ZWQ9
MD4NCj4gDQo+IEFuZCBpdCBzaG91bGQgYmUgYmFja3BvcnRlZCB0byBzb21lIHN0YWJsZSBr
ZXJuZWxzIGJ5IG5vdw0KPiBUaGFua3MsDQo+IA0KPiBTdGV2ZQ0KPiANCj4gT24gVGh1LCBK
dWwgMzEsIDIwMjUsIDE6MTXigK9QTSBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5v
cmcgDQo+IDxtYWlsdG86cGNAbWFuZ3VlYml0Lm9yZz4+IHdyb3RlOg0KPiANCj4gICAgIE1h
dHRoZXcgUmljaGFyZHNvbiA8bS5yaWNoYXJkc29uQGVkLmFjLnVrDQo+ICAgICA8bWFpbHRv
Om0ucmljaGFyZHNvbkBlZC5hYy51az4+IHdyaXRlczoNCj4gDQo+ICAgICAgPiBUaGFua3Mg
Zm9yIHNwb3R0aW5nIHRoaXMuIEkgY2FuIGNvbmZpcm0gdGhhdCBJIHNlZSBkaWZmZXJlbnQN
Cj4gICAgIGJlaGF2aW91cg0KPiAgICAgID4gd2l0aCBkaWZmZXJlbnQga2VybmVsczoNCj4g
ICAgICA+DQo+ICAgICAgPiA2LjEzLjAgLSBta2ZpZm8gYW5kIGxuLXMgd29yayBhcyBleHBl
Y3RlZC4NCj4gICAgICA+IDYuMTQuMCAtIG1rZmlmbyB3b3JrcywgbG4tcyBnaXZlcyAnb3Bl
cmF0aW9uIG5vdCBzdXBwb3J0ZWQnLg0KPiAgICAgID7CoCA+PTYuMTUuNyAtIGJvdGggZ2l2
ZSAnb3BlcmF0aW9uIG5vdCBzdXBwb3J0ZWQnLg0KPiAgICAgID4NCj4gICAgICA+IFdoaWNo
IGltcGxpZXMgcG9zc2libHkgbW9yZSB0aGFuIG9uZSByZWdyZXNzaW9uPw0KPiANCj4gICAg
IFllcy7CoCBJdCB1c2VkIHRvIHdvcmsgb24gb2xkZXIga2VybmVscyBiZWNhdXNlIHRoZSBj
bGllbnQgdXNlZCB0byBjcmVhdGUNCj4gICAgIHNwZWNpYWwgZmlsZXMgd2l0aCBORlMgcmVw
YXJzZSBwb2ludHMgYnkgZGVmYXVsdCwgd2hpY2ggaXMgcmVxdWlyZWQgZm9yDQo+ICAgICBT
TUIzLjEuMSBQT1NJWCBtb3VudHMuwqAgNmMwNmJlOTA4Y2ExICgiY2lmczogQ2hlY2sgaWYg
c2VydmVyIHN1cHBvcnRzDQo+ICAgICByZXBhcnNlIHBvaW50cyBiZWZvcmUgdXNpbmcgdGhl
bSIpIHRoZW4gYWRkZWQgYSBjaGVjayBmb3INCj4gICAgIEZJTEVfU1VQUE9SVFNfUkVQQVJT
RV9QT0lOVFMsIHdoaWNoIGJyZWFrcyBhZ2FpbnN0IHNhbWJhIGJlY2F1c2UgaXQNCj4gICAg
IGlzbid0IHNldC7CoCBJT1csIHdlIHNob3VsZCBza2lwIHRoaXMgY2hlY2sgZm9yIFNNQjMu
MS4xIFBPU0lYIG1vdW50cy4NCj4gDQoNCg==

--------------eAXd0Po64JWS3I85cL8HaE1l--

--------------L4R9aqiXU7oDVe6Vo70WCTO0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQQSnW9toxeqqPSSp+ZFamLVZgJB0gUCaIvC1QUDAAAAAAAKCRBFamLVZgJB0gMh
AJ0WLoJncrSEFPjbipmN7r68rJK+6wCfYdl5aMf5oWb7CDB+4Ic43k2Eq4I=
=CkKj
-----END PGP SIGNATURE-----

--------------L4R9aqiXU7oDVe6Vo70WCTO0--
