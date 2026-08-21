Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023141.outbound.protection.outlook.com [40.93.196.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0EA352019;
	Fri, 21 Aug 2026 17:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787332151; cv=fail; b=W0edbRhQ69C2KYBgEA/WBAmHIaXI4mQgvBLYf4Mutt5vwi+SY+Sb6XTgKsNJPYjRTNsAtaUKCcFKu+ZfxpW4yqPiWKvo3v5RpF9SIcCnIS5zr1K2jm5fDt0dtC5LYbD8PFy7VZwlfS1JwN674uUNxYwwmZsJUQZnYd+Oj0d83XM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787332151; c=relaxed/simple;
	bh=rClzwTKQd7h0m9dm63i5V/DDDApv/n47TuV2Oyxufz0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=iFvYUnBghvcbK5Muc5+CHhr3N3baEQElHFA62DK/KIHurx2TfotiiUS0TigH2UvQ6B+gzXImoS9V8Puszm7X31+nMwH0zt8z+iiGTtsdw0V4OK+9Uk6RlOndQflYGDcsPXpirb5+sHuRDz0M6hCzzwoJUWWqG60XN7e6sVO47P0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.196.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZ4nwCW7JlsKxUD8THEtEVRulZg8w5PwT5w6cS8B7MfnorqQRzegpiSup6+6yxzVjAsfogxXWusX4yIkImQG6krP5S3f5g3DQmzhfkq1I6q6XHCRkAwC8OycxOYvUdTygLrsEUYoLp74OI+f9tSaQA+58VAlIg2TloIZrYwLHS/cU9ERgfZs0JGFxEvPKJn685o7gq3mpdN7jYV//ncMgl8D057pvuJAX9UREbxonuJeKNiWD4L2SyMmHXr6Bf/FMNKd3gkaMXk4NMsdknlTVav1xGvgS0NSRXTKWifFr6dkNRUtLmsx3RUMks0L/tE+4GLjhm3PeBAlguIwqKbFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rClzwTKQd7h0m9dm63i5V/DDDApv/n47TuV2Oyxufz0=;
 b=Gsf8uUuxvXRWaqzpH1eEQ3UySaXBPjFKO9u2VJKvjipec+C/1Wusqj7FchXNtQZ3w7H41bg4eUU6wPp6uqLYPd7ESxLY4r96QJ4CoxNJ67yv+YSRkD/bRnolFExiXLUF2tsDWxdiA/vDfhQE2xUyHjF26jgS/g4yZroJ81gU3HweHsBd+2QX0VBl48AmMRoVbbQlotucI6Kof6Jh5uQ+1ywoRAUzwsbtsNv/NRc7n5Dx3OoeidzzcHYmKZmhB3KzLZQbPkpaxaJJ1Y4rE0/NIPAbFbh86u7BXyeSdHIpWdEp8d0d44bl7YRnHwXogeFcTue53SVMq0NHI8EHDl5lRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 IA6PR01MB755614.prod.exchangelabs.com (2603:10b6:208:5e9::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.11; Fri, 21 Aug 2026 17:09:06 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 17:09:05 +0000
Date: Fri, 21 Aug 2026 13:08:52 -0400
From: Tom Talpey <tom@talpey.com>
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, linkinjeon@kernel.org,
	stable@vger.kernel.org
Message-ID: <32cea692-1aa7-4eac-8f6f-eb39db63777a@talpey.com>
In-Reply-To: <20260821142946.1728452-1-sorenson@redhat.com>
References: <20260821142946.1728452-1-sorenson@redhat.com>
Subject: Re: [PATCH] smb: client: fix OOB array access in __smb2_calc_size()
 on unknown Command
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <32cea692-1aa7-4eac-8f6f-eb39db63777a@talpey.com>
X-ClientProxiedBy: BN9P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::16) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|IA6PR01MB755614:EE_
X-MS-Office365-Filtering-Correlation-Id: 2736f091-eea2-4c96-3445-08deffa6e81d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|52116014|376014|1800799024|3023799007|10067099003|56012099006|22082099003|38350700014|18002099003;
X-Microsoft-Antispam-Message-Info:
	e7mhA5JIyWF9ubWAEutnyZvvdltY82A/GfHV1NWqVJ4DoyrBuYOmxJzKwVYBpJGF3ddFa6gAnPVF+g+N2Qxj8zxKpJioOJVa1/WZWr8HOEaOEE5l4KIF5bDOqdm0QYJ51SvVCFJqVcs30Me4DqKUsmMtt2w97EZVOCn9hS/CFghyIqekjCUSEjy+WnvAk6whrVYivSUR0a/ECCySCPajPsJx5jXrcDd9saLMPdv+LgZMh7DivFGZkvbUb1jhn32HgC+mja95TTUUjGLB1PWGOuxOqGTnE96B5Hg5Qof/odiETkJcNM64QCRnJBAnNgTTIrXP8noQ9MFRFz9oSsy7zQMdAgqozAVnWAhzW1SFLi4dfnEwANT5kB/Yo7Nehe86LX6B6mOZCwiyMZFzBfs9GlN84abVgOiY7aaX1L6f/m+eZP0h/029lyJw8R7ayQl2FIWnSwqXBcn2Z1DhXeyuiGubrJ9Pt6XLopV9spMkXuBTvcSz1rheH1fuCvySS13a32UrwDKTM3ahrBZMIc3g6x25BLS7Ad0Gt4memKlQPGf+0POxjQZq2d3OfsRYH0iuCeQdLER5NGw81kLg5WpVcK/PyR/mEK+A4G7Ntg+W9dRcG8fDxsi3ajOpIQ87fOVuT/DrVzQ/EZ4cS7nJa2FFQLvSzrYpGrvHoC9BzEagRLAhxW9/ZlbFYwxTNvM3ktp4eMOcjaCcf6gUXFISwevreFLu0ycyK/X73BoLB041mbc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(52116014)(376014)(1800799024)(3023799007)(10067099003)(56012099006)(22082099003)(38350700014)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVkyalpaNlFBcWZBREp4elI3NWw2UFBJOGdQZmlvaEFpZzFBdkdJVWsvVjhV?=
 =?utf-8?B?cG9PSTNyY3dmd205WHNEODlQdmZkRFExWmFqRm9VdWRGTEpZT1ZQRkk3K1Ns?=
 =?utf-8?B?b2pFNVpRTXFIK1dNN1UvdElhNEZXWEJmMm5pOFZXOElqSXlFSFY0eXQraXBz?=
 =?utf-8?B?SDFNTmtpR1MxeHpGd2NOdEtzSTJrNk5UYnl6WTFPam5PZjF1Tmw0UjdQS1Fk?=
 =?utf-8?B?QVVoOE0vVFdWazFzbjZka3BJQkxVelBMRzRKMXNYU2dzRGhYMGFhbnJvbWM0?=
 =?utf-8?B?Und4WjE3ZXNNZ25TQ3BLdmVSUkZPb2RZS1F2ckJWUGRxNktiMEt0aUlWbUVi?=
 =?utf-8?B?aFNjK3l2dDJhUGtPL3YzZWZJWlhSelFhRXJZc2NTeWQ0bUpybzdtZjU4R1JJ?=
 =?utf-8?B?ZWlvVzNGckl2aGQ3YTcydDVLd2ZuM3lERXNFclUrTytyNlJFMFc2M1pUUjB1?=
 =?utf-8?B?ZTA1S0lvSXkxUmovSGkyV2lsN1ZPRHMzQTY0WEFKRWtGNERHdU1Md0NkVHJi?=
 =?utf-8?B?R25Zdm5VazBwclNJRndRQmphaHFNMGwzczJoWnRxYzRNWExaVHJJRDQ2N2Vr?=
 =?utf-8?B?NW80Vm96cDZXUzhLY3hLS00xWmRVK3JJdE4xNTZMYXovWTFMVXh0OWZWN0p0?=
 =?utf-8?B?L0o2NmI1ck9BRVlOL250NVB3TE95eFZhZVlEbFk5UDBUejdJMmNDTkRmUlVy?=
 =?utf-8?B?cU9BRWtlcDBCS2dPdzUxZGoxS3pkb0tNM2ZyT1VickxYcmhrbGFTV1hXS0RL?=
 =?utf-8?B?czBZY0h3YUhiaHdwblQ2SFdSd3pOUDUvb2doTW4xMUgvQmVVOFhrbWNaQ01Z?=
 =?utf-8?B?VnByU01hZXZ1YUVRNTdVNXN4Z0pWOGlLU1pGUThKd2U4eVlSb1dqeVVLdTZJ?=
 =?utf-8?B?SnR2cmI4UE5GRVZJSEhkblRUaVFKeE1NaXJScHFYa2lFVjgrY3VSOGQvbVJv?=
 =?utf-8?B?SGVXekhPa251bTZodWFVY0s3QW5XWnV1LzkwUVd1VlAvZGdjSjVDRVlld0kz?=
 =?utf-8?B?S0VSc1A2YWxCLzNTZkR3UDIwUEtydWozeHJPQytockg4V3lqWWcrekF2bEpF?=
 =?utf-8?B?ejFhM3h1YUI2akpwV1N2Qll4UFlVMUplR2tSNi9YOEt2OHhUY000TXRad2J2?=
 =?utf-8?B?SUtZeGI5NjREZUVBZXRpSlhKdnFGK042WFhPRXNjdDV5RUxEdVJha1pldWhL?=
 =?utf-8?B?RjFGMytjYmEyYm1SWVkySTVyOElWT3phWGNOeXJKL2xsQllOdFo3bUQ3M1lH?=
 =?utf-8?B?cHR3RFZtdGJBZ3FQLzhiUEpFOEl5LzVWOWo2RGRuUGxKS0ZNMHFnRXZGUHNm?=
 =?utf-8?B?dkR5d1U5c3FDamJlMWdhaTgwRlhIWkIzOW0rVThzYkNUUGVINktzN0J1TkF1?=
 =?utf-8?B?WTdtSlhtVG1MMGF0NGxNYUVORVpnY3dMTVRTcHZUcmRadjIyTTFLK29JaUoz?=
 =?utf-8?B?Q09rb0hsOXRxcEFndXBiUDVod1pyZGE5V1AzSkhXVjhCZ3ZHZG5BWTlvbWFz?=
 =?utf-8?B?Y1B6Qkx5V25NbE41Q0RpbGRvTWM3anJpSGVZRFdQMnlESGJwRGFLQ2cwWEd2?=
 =?utf-8?B?Y3E5N0ptUVZ1RHNsZG9IY2p1MnFpTVZBbXZ3RHRHMWhGa3h2akdQTTlKSkov?=
 =?utf-8?B?ZnIrY3lDMVo1NTN3RDk1bnU2VWo1bThyQlB2OG5SU00yM0doT3pmYmtpdGdm?=
 =?utf-8?B?cEwvZm9zaE40VTNEMnY3Q0x6c1p0UmVwb2VlWGNNcUdSYnE2aEsvL1huamRJ?=
 =?utf-8?B?dDQ3TWFLTHFRZXAvb0lzRVR3QytuM3E3WE4zMDBHZnk4N1d6dUo0d1U3bkpl?=
 =?utf-8?B?aVFDaC9YZVJxM0poRisrVnNwNFl1UjlneTF6Sm54OFVKWEVjWkU4L3hEQ3Zt?=
 =?utf-8?B?Y2tQTGpQYWxEUjBOYTBUNGJOenRZQWUwb2RFRnVpdTUxVzhxYTBueVAzWFVh?=
 =?utf-8?B?OThBWEhwaFRuNU5xVDJjU2lSOHVhSmFwaHQ4Q1JUa0FMR0p5MzJUR2FlbWRa?=
 =?utf-8?B?MzZaclJKOWZnQUdpczVPT3I5RWhSZ0ZyVmZjVndCS25YWEFoWFJrWjFNUzZR?=
 =?utf-8?B?b3k0c2dhZEdJMHJuYnpFSnN0Zm1mUVRnbTNFMTAzaVJtNGxpTlYzcjBCZDN3?=
 =?utf-8?B?aUVtaDZrOWZkbzBzQ0xpSXFnaWpSSzhEQmcyTXhRS1R0bUlLL2MyK0EwRTNv?=
 =?utf-8?B?RWNKZHhoRkJTM2gzb1oyenUza2IwWkQ1YWQ2K2lndzl0UC8ycFlCbXd0Slgx?=
 =?utf-8?B?UHdSQUZzd3ZveUZNdFpuOTU5aG9nejI5cVRpdTYvQTlFcEVIWlV2UVMxNnRD?=
 =?utf-8?Q?VapDt+Nwt1hYYhoH7x?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2736f091-eea2-4c96-3445-08deffa6e81d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 17:09:05.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2HeCGg+FOOJuqa+UXJE97bUmCNBYFoWCKnRl+utJuHgrrvNhPYHLJJpWArh62Tf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR01MB755614

The SMB3 protocol often specifies closing the connection on invalid message=
s, is there some reason you are opting to ignore this field?

Tom.

Aug 21, 2026 10:45:35 AM Frank Sorenson <sorenson@redhat.com>:

> has_smb2_data_area[] is indexed by the server-supplied shdr->Command
> with no bounds check:
>=20
> =C2=A0=C2=A0=C2=A0 if (has_smb2_data_area[le16_to_cpu(shdr->Command)] =3D=
=3D false)
>=20
> The array has NUMBER_OF_SMB2_COMMANDS (0x13) entries; any Command value
>> =3D 0x13 reads past the end into adjacent read-only data.
>=20
> Add an upper-bound check before the lookup; commands outside the valid
> range have no data area, so treat them as false.
>=20
> Fixes: 093b2bdad322 ("CIFS: Make demultiplex_thread work with SMB2 code")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
> fs/smb/client/smb2misc.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
> index 9068175e57cd..26b41ea3b72b 100644
> --- a/fs/smb/client/smb2misc.c
> +++ b/fs/smb/client/smb2misc.c
> @@ -451,7 +451,8 @@ __smb2_calc_size(void *buf, bool *have_data, bool *da=
ta_area_overlap)
> =C2=A0=C2=A0=C2=A0=C2=A0 */
> =C2=A0=C2=A0=C2=A0 len +=3D le16_to_cpu(pdu->StructureSize2);
>=20
> -=C2=A0=C2=A0 if (has_smb2_data_area[le16_to_cpu(shdr->Command)] =3D=3D f=
alse)
> +=C2=A0=C2=A0 if (le16_to_cpu(shdr->Command) >=3D ARRAY_SIZE(has_smb2_dat=
a_area) ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !has_smb2_data_area[le16_to_cpu(shd=
r->Command)])
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto calc_size_exit;
>=20
> =C2=A0=C2=A0=C2=A0 smb2_get_data_area_len(&offset, &data_length, shdr);
> --=20
> 2.55.0
