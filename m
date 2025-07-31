Received: from loire.is.ed.ac.uk (loire.is.ed.ac.uk [129.215.16.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D32A189F5C
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=129.215.16.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753987027; cv=fail; b=EGdsh40cgNmhRsP87oirPodnmOJx4wXhzvS2jJgp2U3CPfJYlynpvMWryEzuloLefgOyRLwvJYTP54VdSJN8esxMmCmpRnr/7rxmPJfYi6oHXF3ekNKz4IPRYmCGfA7f0LZ9XfiyK1GhI3kpHbJ3ZUwqtfhY8cZLW7EQzUw/U7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753987027; c=relaxed/simple;
	bh=enQGxqeLgML+Mza4dui+6byIwJVDMb90rmYE1wRagOM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QBh2MHASrwXFuCB5SO/uYzG9ylytCXICtg5b/CIRBCWWO/+9PvGZLbsMvUWQ2MiNpyvgrpu9mZ/NxsotmTohQMte9BgIlKtDtTP7p1m6z9ygSp1VqKh9kTHygFRh/A08FJx0fe4/IDs03mB5QfRPhXtGApH4nixNv+uImpKco90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ed.ac.uk; spf=pass smtp.mailfrom=ed.ac.uk; dkim=pass (2048-bit key) header.d=ed.ac.uk header.i=@ed.ac.uk header.b=D/Sk+77+; arc=fail smtp.client-ip=129.215.16.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ed.ac.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ed.ac.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ed.ac.uk header.i=@ed.ac.uk header.b="D/Sk+77+"
Received: from exseed.ed.ac.uk (hbdkb3.is.ed.ac.uk [129.215.235.37])
	by loire.is.ed.ac.uk (8.15.2/8.15.2) with ESMTPS id 56VI2Wsj2661522
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Jul 2025 19:03:24 +0100
Received: from hbdat3.is.ed.ac.uk (129.215.235.38) by hbdkb3.is.ed.ac.uk
 (129.215.235.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.26; Thu, 31 Jul
 2025 19:03:15 +0100
Received: from GV1PR07CU001.outbound.protection.outlook.com (40.93.214.98) by
 hbdat3.is.ed.ac.uk (129.215.235.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 19:03:15 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kiFbbaghV/OPKVrEdn6EY+01sNyWaN5EGtS47iLLHZKM5/vzbYaFO9y+LyHgvsQHvxwXRB5ucV30I2BA9NLIcWHVEqhISKOT153cXa3wCDSikMxIfS0WxEtSLrfVi9dDmhkDf7kPCZiNWvONLy957llg8SPklHPnBm76uDRvYayTbJzJqpcnX0qhzfkZYjOgoYFLXu+G/HUPXdIMIwNl1UAwCTCB/0J/EPyepRlXrmTPcqIghKSWiuF/O97XwnhkQc0H4c2SJOm4rCAFamCYtiwnn+7WH7bcxhhRBRSIZ6TB7JM+VHbxFrCW48OT7Zz8ArY+914dPvrcLbzWlHK9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enQGxqeLgML+Mza4dui+6byIwJVDMb90rmYE1wRagOM=;
 b=L4SqDnN46V2vFTJoBJnUnXZBWSZo+nESYjUHsvbXZT/9zsMdkbF6JoQDH/3YG/i1qyFUPbPdXWZ4hHuo1voPQm3QZmtq018krgqRpe5qyQJdnPcd0LYp9+ff+6MlkQC4X7yQS4FAPKm0x6iQ2CPiBF2YG68gnBHeMx8fpWqzqRWgcvzktSoaaama7olTjupIggnO6XL9j/Ou5RbVpdmRl5+q9M9Ec94aCkNUgIoumWbf3jZrJiLon8QrpuFwHrMXxa0EMxW9DmF7kgIKWIViTKv1i7ZfnGv/WDKtOmGSuAQxS9iUUNmcaeDVM6oPjPoaTSNuKtuqAaY5OgmIZZiM9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ed.ac.uk; dmarc=pass action=none header.from=ed.ac.uk;
 dkim=pass header.d=ed.ac.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ed.ac.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enQGxqeLgML+Mza4dui+6byIwJVDMb90rmYE1wRagOM=;
 b=D/Sk+77+emsX3XDRYCUccrgKFniDwJ08ZMvsF0Ci9bIwiN0ulhvlibIBlEzQc9Uz9SpvQWVtMa2Ue7K3Fnxo50VruLuvcuULrmvN0ZfzJUTO/zFcgRzs51Cy/By8ykZ5umP/d+hkLIWKH3FOQPvQOeXX/vqiIf2MfQ50KbthEqX7q8VO/hpKPfmvwsMyAkfJR+Lof9fGOPLEJv8uouraqHJ8t1YZrILTHRN+pJsHu7iRKsojRuBR/sOKbyNIENg1QC4s2ygCPhQ0d3X3qYNFPi9W+YICHz1f9eqLabP0rcRV1vdmQv5ZyVz49wXgSjv3mTEmu3+9pMdejuO+UIUNyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ed.ac.uk;
Received: from PAXPR05MB8862.eurprd05.prod.outlook.com (2603:10a6:102:219::23)
 by DB9PR05MB7612.eurprd05.prod.outlook.com (2603:10a6:10:1fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.12; Thu, 31 Jul
 2025 18:03:14 +0000
Received: from PAXPR05MB8862.eurprd05.prod.outlook.com
 ([fe80::cedc:6b54:f25d:5981]) by PAXPR05MB8862.eurprd05.prod.outlook.com
 ([fe80::cedc:6b54:f25d:5981%3]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 18:03:14 +0000
Message-ID: <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
Date: Thu, 31 Jul 2025 19:03:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: Paulo Alcantara <pc@manguebit.org>, Ralph Boehme <slow@samba.org>
CC: <samba@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>,
        Steve French
	<smfrench@gmail.com>
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
Content-Language: en-US
From: Matthew Richardson <m.richardson@ed.ac.uk>
Autocrypt: addr=m.richardson@ed.ac.uk; keydata=
 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
 RVt9Yw==
In-Reply-To: <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------fIp0n0zSp9zuPsZ6RpCw469l"
X-ClientProxiedBy: LO3P123CA0033.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::11) To PAXPR05MB8862.eurprd05.prod.outlook.com
 (2603:10a6:102:219::23)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR05MB8862:EE_|DB9PR05MB7612:EE_
X-MS-Office365-Filtering-Correlation-Id: 50f8e01a-66f2-4f98-cdd0-08ddd05c84a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TEdqSERCcUg2TFZQRmpnRnR3U0w2N0srajVWZWFRaE1KWTF0S1RJd29oVWJ4?=
 =?utf-8?B?UDhsYWJwcHlvaW5pZFBlcE5GSVNHc201ZHQrYzhyRk1UUFVqd3lDb3ZCY2JT?=
 =?utf-8?B?YllSR0ZpTENVb3A2Z05zYzZVcStobFcvMlEyRVBmMTJqRnd5MFNlcDRydHNa?=
 =?utf-8?B?RzZOa0lFNHVUYmorSzNhcFNTSzlSKzdlbzFRTmsvZmJ2RmN5QTh2OHRyM3F4?=
 =?utf-8?B?TGdwUWw2ZitrZkUzMWFmYkkwcUwyQlkvbko5YTdpc1NEbzM2WENMSnRlNUJH?=
 =?utf-8?B?cERKNzRaUjNLalplRC92djBqZzVKSGg3TVJ2SzVib1JjaW5ReUFSMHRnYm9M?=
 =?utf-8?B?TnhnbE5ZNTNRUGYwcHdpRzZldVZGOCtNQmpna0QyTnFUK3h4ZUdZaEpOSG04?=
 =?utf-8?B?Vi9VVzFRY29RWi9jVGQ1Wms1VWw2L2sxa3oraFg3RlkvSktRczhienZmR09B?=
 =?utf-8?B?cS9BaVNoSklaOUZMWi9nOVg0MXN3MUNhMmZRWnhES1JrdnIvdmdzMXdrRTBk?=
 =?utf-8?B?aEhBWUx0eTd4dUJ2K0NvMkxZSUlYVjVzZGl2NGtYMFFDZmhXS2dwR1plR2tS?=
 =?utf-8?B?SDBrQ1R6bzNCa0VFRkkwS3Bma1NlUHpvbFk5WFRHT2wraWhEWEFISzRCVDNr?=
 =?utf-8?B?RlpHdE9USk1QcG14eVFLWnhiZEt1K0NGbkRISzd5M24wa0tUT0FBWEVndGhj?=
 =?utf-8?B?b2JQWWZNWURwSzdHSWR6c21OVkNMNGZOSGV4VFNzcUE0V3V1b0piZ0RuSFlY?=
 =?utf-8?B?T01mKzZsbHQ1TDd6Tk52NEZ5WkpLWWkvNHhmR3AwS0xnaW1YNnhVYTZnbGdY?=
 =?utf-8?B?NzB2QUkyRWxrMU12MFFZYmpqOE5mbDNzd2kxTTI3cEVzKzRwRUpCV0xxSjhE?=
 =?utf-8?B?ZXRFejBKTzlRVnAxbFdhbFZndmlZdktPUWhJQ3VXS0lpUWxwaEU1SmR1Mm1J?=
 =?utf-8?B?aE1Ud2xEZjgvTGhpU0NHcWZsTjRmdzkzbVF3bmF2WmZEMURpRlpXM2hTS25J?=
 =?utf-8?B?QW5VSVNWakFxNlBKZFZwZElVNDdrdDlUMThFQnJ2d05sRTdabGE5aEsxSzNr?=
 =?utf-8?B?YnJ1WGdrZVM5WFNrRFRhK2dtSS8yVHpVdkIzMVNTenIvWVN2STRVVHFML0cw?=
 =?utf-8?B?d2R4OFhrdTBtYWlYUDd0Q1RLOXdxUUE3YkhzaDYwRHkvcE1kUUxObkZ4VVZh?=
 =?utf-8?B?S0pHUzMwTWxNcFFWbkV0SEFEL3Z0c1FrMURjVDhiVzdGb2J5S08xR0F5VEJr?=
 =?utf-8?B?cUZPa2dUOVNqQUpyS1pRY0NnTTZNRnRZZlFsZTdyTkRWMDM5YVJPYXN3MmtI?=
 =?utf-8?B?eWtXS0VVK3cyZ1pxa0NFMkluUUJSdVZQWkF4OFI1S1Zua1dtUllQZWgvWUhX?=
 =?utf-8?B?QXFFM2NYNGpmcUxTTDhsWGExNmY4cmI1KzZHUzNJVmNHYXBnU05SNFk2NEJI?=
 =?utf-8?B?RkRmT0JHUGM3UjFob3MwTlZnS01sTFBHcXRRNlZRUjVjTHZZaEtTYU45VE5I?=
 =?utf-8?B?WnNKMW92TkJNYXhGZmJjU3RCOTFFRGsvTWo4SHVTb3RuVFdycTNDSDI2eDJT?=
 =?utf-8?B?dENMQXkrYWRDUmlwVzNRUVFCa0RQTzdVMDBkc2xhMFRxa2RFMzd3STBYNStx?=
 =?utf-8?B?TzhiQVhKVU9vNk5ad2pvSjNUM1JEcnZnYWJ6WUw5S3BEUWszTjZNanNYUzF2?=
 =?utf-8?B?aHlUcVhXMFoxNFRHbjNIRksxTml1Yi91TXpNT3lCVzJGNCs5WExhaXJvcTVT?=
 =?utf-8?B?SjdSSmJFbUxUQlAyL3E0UFlLNHNneWtLQUlLcE1RdUNteU9MYlpPeDYydzJ1?=
 =?utf-8?B?enNOOEFYZGhTbThCa25UdHlIZlNiV09tSkV5ZHExZldrTStVR2lzcU9mbkpJ?=
 =?utf-8?B?QkxWZ0FMQStJdnN4NmI3VitTbll1RGpNNDczUzZ3bGRBUEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR05MB8862.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0FjWFpXUVFuMm1uWEZzNGYySDRuaWVMZWVXOUJVK0tPc3k5MVhUNWlzU2JZ?=
 =?utf-8?B?SitIS3VEK05Mc1JLTmoxUnZIY3B5MHQwaW1UWGlBM0tsVURDQWZwRitITUc2?=
 =?utf-8?B?S3lOVGVSQ2ZhUkZGTjFTalJ3UzgyMUQ5blcyYmQ2NjhMUzlmNHA1ZFloQ1U2?=
 =?utf-8?B?eXFVZW0zOXBOUFhCVG9XeHNubkY2dUJRMTZQNXpRdTRlYWlRdlpKdEo1eWVN?=
 =?utf-8?B?eWhxc2RFYnlYdlB1ZDFFOWIxUkVBeVpocnpmWW5sdjVQbTU2Z0NIUG1hREU4?=
 =?utf-8?B?ckdXQkZ6R09GeVNNMVFjL0JVa2lDb3poQmJHTmx4cDVxUHU3dTRteDBaOExu?=
 =?utf-8?B?WnZSTXF1cCtiZGxVVUgrbEp2Mks2WmRUNUc1Q1Q2YVJrM0ZqdEh0Z290WHFm?=
 =?utf-8?B?anhZYVkyRXVJM1FLS0JlWVZhTTYwUlo1cHM5ckJ4T0hkbFZyOXV1NHh2cjNr?=
 =?utf-8?B?ZUsrdXpsSXZLdEcwYXlCNFBNQTlNUlRIcE94OG5IK0lLOG1iQUlYZXhVckR0?=
 =?utf-8?B?Y0YwS1ZCaFRGYjNFbG1mWVpwck9wSVM1T09YRXJZSE9raE50a1ViQjljbHBz?=
 =?utf-8?B?aW9LMEgyRDRtRW9qTmRFWkVZNEFERjhkRUhiVU9aeEV0SlNVbkN1VHJETDky?=
 =?utf-8?B?OXcvYVJVM2dYVWcrWXlkSmN4TkJ0d21CWG5jNWZ4WGRsTU10YkVyb1MrTUdq?=
 =?utf-8?B?TVlTSnBTVHlvV1NZQ0FhZVFOclhoRFcrWG1tRnp0eFNNSFNpUEcrNnlRMlh5?=
 =?utf-8?B?eEsvTGcwUmE4ZkxLYmJEdWRjc2laT0g0QTJsWktPcHUzKzlVcjg5elVvMDRw?=
 =?utf-8?B?eVUwRDJYcGNPbzZpTFQ0NkJRR3VZeVg4MDNjVXhiM0k0SGsyeGhhc3RqQXNa?=
 =?utf-8?B?K09GK01WK2dPbWFpa20rMVN2cW1RS25tVXhDNlVoc1Z2c0xhVklpVzVOWUtr?=
 =?utf-8?B?UjNUdUlUR2k5K1Zvd21qWGtqZUptTmVKOUp5Yi9iRytCcjZaTjU3cnNPbTVh?=
 =?utf-8?B?bnVMaUF5YlBaV1dRWThyTEJPR2pXd095endKd3dtbTJ3VnN5VjdNMkxTbE1G?=
 =?utf-8?B?d0hCcjRQZXZrVDdSdUVYeFl6bjQvRE92SURwRTlDM2NyMHIySndOeHpQbTJo?=
 =?utf-8?B?cXk0ZndyNzV5V0FhcFFOWkhCUmsyZ25yVDZEUFJrUncrSm5BelBkMHNydTFO?=
 =?utf-8?B?SzBlVktVZEdjaHJKcHhBeEt1dm1xeEFYY1B2MlNib29ONGsrQWFBSE5kNjNV?=
 =?utf-8?B?WjhaT0RJVVhPMW1zYjZDQ3UxK0M5QWJNa2QzQWprRUJCZm5pQXk3Uld2ZVdr?=
 =?utf-8?B?NFlTQkhxZk84L3QxQXNQUm9iM1pWYXFUQVVKVEtCZ3lMeXF6N2p5NFRTNUN2?=
 =?utf-8?B?TEhNbmJzMzFVRVcyKzBSaEp4enpJbFAxaDJJemlBWXVaMTFqNFg2STg5ZDFt?=
 =?utf-8?B?NSt1N01oMTk3Y2JSOFQyOXFoQWQyNloreHRRNEFiMTdkZzh0MlF0TmlESXBS?=
 =?utf-8?B?b3diZytjSlRtUG5jZDZVSXlaVGM0dE9TM3FZMUxuY2x6WXM0bkpQdWR0VGpa?=
 =?utf-8?B?OHIrdUJHbGlITVdDMU5aVGNUY3RxYVVhKytITmNBS3FobFlnZ0piTDAweUtZ?=
 =?utf-8?B?VkR6QTNLL1cybDNWNENWRlIzWDB3T3QrSHZPMVhZL0NZMVhwSzB5TVN2WWtW?=
 =?utf-8?B?b3I0TjlLQnZ4NXlKcUxPUDd3OW1LTERuUEsrTjZzckg2Mng0ZzBqaXd6S2c4?=
 =?utf-8?B?RnZyUkIwbXc4U1VueWVTMkJESUk3QjlwbG1wWkNNeGVWcXVLaC9zblBUM20v?=
 =?utf-8?B?SUZ4czVHNHQyYUdtRjNkUGdON1NUNTMxeGR6cy9IazNiZ2NnMElpOTVuQlow?=
 =?utf-8?B?Mi9JM2txZEJWSExGaVZwem04TWpISWJjeis3Q3Z5cnVBM0xqU0ZGMjdaYndu?=
 =?utf-8?B?NURDN1U1UVZWWUYwcXBTRFgzUWljMjUyVjh1QzdadmxsTWZnNUdpYkRIemhP?=
 =?utf-8?B?ZG1qT1pEcmhoVXpIYmZ4WjF3Z0pIVW40dUhuZVdpbEE1YzVlekRFeDJjZDVH?=
 =?utf-8?B?RldqZjVOQ1MvVWErSHJCTGZlL0VORnI5dGhCYVczYzQxMXRqNWllVmo0UjM5?=
 =?utf-8?Q?suTwPYdps2j62UuIHlmV7tA/u?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f8e01a-66f2-4f98-cdd0-08ddd05c84a7
X-MS-Exchange-CrossTenant-AuthSource: PAXPR05MB8862.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 18:03:13.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2e9f06b0-1669-4589-8789-10a06934dc61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUaTDh53ti8ZsH/y1XiSOK8kBlyoBy+folrPUfNgzdHHkrR6f07u/fqdwiDmJJnQsCEOLybCZVEzwpyXDyPipw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR05MB7612
X-OriginatorOrg: ed.ac.uk
X-Edinburgh-Scanned: at loire.is.ed.ac.uk

--------------fIp0n0zSp9zuPsZ6RpCw469l
Content-Type: multipart/mixed; boundary="------------mwB9J9uY5lsLwucEyJtBS0ai";
 protected-headers="v1"
From: Matthew Richardson <m.richardson@ed.ac.uk>
To: Paulo Alcantara <pc@manguebit.org>, Ralph Boehme <slow@samba.org>
Cc: samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
In-Reply-To: <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>

--------------mwB9J9uY5lsLwucEyJtBS0ai
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

VGhhbmtzIGZvciBzcG90dGluZyB0aGlzLiBJIGNhbiBjb25maXJtIHRoYXQgSSBzZWUgZGlm
ZmVyZW50IGJlaGF2aW91ciANCndpdGggZGlmZmVyZW50IGtlcm5lbHM6DQoNCjYuMTMuMCAt
IG1rZmlmbyBhbmQgbG4tcyB3b3JrIGFzIGV4cGVjdGVkLg0KNi4xNC4wIC0gbWtmaWZvIHdv
cmtzLCBsbi1zIGdpdmVzICdvcGVyYXRpb24gbm90IHN1cHBvcnRlZCcuDQogPj02LjE1Ljcg
LSBib3RoIGdpdmUgJ29wZXJhdGlvbiBub3Qgc3VwcG9ydGVkJy4NCg0KV2hpY2ggaW1wbGll
cyBwb3NzaWJseSBtb3JlIHRoYW4gb25lIHJlZ3Jlc3Npb24/DQoNClRoYW5rcywNCg0KTWF0
dGhldw0KDQoNCk9uIDMxLzA3LzIwMjUgMTg6MzcsIFBhdWxvIEFsY2FudGFyYSB3cm90ZToN
Cj4gW1lvdSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbSBwY0BtYW5ndWViaXQub3JnLiBM
ZWFybiB3aHkgdGhpcyBpcyBpbXBvcnRhbnQgYXQgaHR0cHM6Ly9ha2EubXMvTGVhcm5BYm91
dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCj4gDQo+IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1i
YS5vcmc+IHdyaXRlczoNCj4gDQo+PiAuLi5hZGRpbmcgbGludXgtY2lmcyBhbmQgU3RldmUg
dG8gdGhlIGxvb3AuLi4uDQo+Pg0KPj4gTG9va3MgdG8gYmUgYSBjbGllbnQgaXNzdWU6IHRo
ZSBjbGllbnQgaXMgY2hlY2tpbmcgZm9yIGV4aXN0ZW5jZSBvZiB0aGUNCj4+IHRhcmdldHMs
IHRoZSBzZXJ2ZXIgcmV0dXJucyBFTk9FTlQgYW5kIHRoZW4gdGhhdCdzIGl0LiBUaGVyZSBu
byBhdHRlbXB0DQo+PiB0byBjcmVhdGUgZWl0aGVyIGEgc3ltbGluayBub3IgdGhlIGZpZm8g
YXMgcmVwYXJzZSBwb2ludHMuDQo+Pg0KPj4gQFN0ZXZlOiBhbnkgaWRlYSBvZiB3aGF0IGNv
dWxkIGJlIGdvaW5nIHdyb25nPyBJaXJjIHRoaXMgaXMgc3VwcG9zZWQgdG8NCj4+IGJlIHdv
cmtpbmcgaW4gdGhlIGNsaWVudC4NCj4gDQo+IFdpdGggTGludXggdjYuMTYgYW5kIHNhbWJh
IG1hc3RlciAoZjFhODI4MDE2OTIxKToNCj4gDQo+IHJvb3RAZmVkOn4jIG1vdW50LmNpZnMg
Ly8xOTIuMTY4LjEyNC4xL3Rlc3QgL21udC8xIC1vIHVzZXJuYW1lPXRlc3R1c2VyLHBhc3N3
b3JkPWZvby0xMjMsdW5peA0KPiByb290QGZlZDp+IyBtb3VudCAtdCBjaWZzDQo+IC8vMTky
LjE2OC4xMjQuMS90ZXN0IG9uIC9tbnQvMSB0eXBlIGNpZnMgKHJ3LHJlbGF0aW1lLHZlcnM9
My4xLjEsY2FjaGU9c3RyaWN0LHVwY2FsbF90YXJnZXQ9YXBwLHVzZXJuYW1lPXRlc3R1c2Vy
LHVpZD0wLG5vZm9yY2V1aWQsZ2lkPTAsbm9mb3JjZWdpZCxhZGRyPTE5Mi4xNjguMTI0LjEs
ZmlsZV9tb2RlPTA3NTUsZGlyX21vZGU9MDc1NSxzb2Z0LHBvc2l4LHBvc2l4cGF0aHMsc2Vy
dmVyaW5vLHJlcGFyc2U9bmZzLG5hdGl2ZXNvY2tldCxzeW1saW5rPXVuaXgscnNpemU9NDE5
NDMwNCx3c2l6ZT00MTk0MzA0LGJzaXplPTEwNDg1NzYscmV0cmFucz0xLGVjaG9faW50ZXJ2
YWw9NjAsYWN0aW1lbz0xLGNsb3NldGltZW89MSkNCj4gcm9vdEBmZWQ6fiMgKGNkIC9tbnQv
MTsgcm0gLXJmICo7IG1rbm9kIGNociBjIDIgMTsgbWtub2QgYmxrIGIgMyA0OyBta25vZCBm
aWZvIHA7IGxuIC1zIGYwIGwwOyBweXRob24gLWMgImltcG9ydCBzb2NrZXQgYXMgczsgc29j
ayA9IHMuc29ja2V0KHMuQUZfVU5JWCk7IHNvY2suYmluZCgnc29jaycpIjsgbHMgLWxoKQ0K
PiBsbjogZmFpbGVkIHRvIGNyZWF0ZSBzeW1ib2xpYyBsaW5rICdsMCc6IE9wZXJhdGlvbiBu
b3Qgc3VwcG9ydGVkDQo+IHRvdGFsIDANCj4gYnJ3eHJ3eHJ3eCAxIHJvb3QgZnNncWEgMywg
NCBKdWwgMzEgMTQ6MzEgYmxrDQo+IGNyd3hyd3hyd3ggMSByb290IGZzZ3FhIDIsIDEgSnVs
IDMxIDE0OjMxIGNocg0KPiBwcnd4cnd4cnd4IDEgcm9vdCBmc2dxYSAgICAwIEp1bCAzMSAx
NDozMSBmaWZvDQo+IC1yd3hyd3hyd3ggMSByb290IGZzZ3FhICAgIDAgSnVsIDMxIDE0OjMx
IHNvY2sNCj4gDQo+IEkgc2VlIGEgcmVncmVzc2lvbiB3aGVuIGF0dGVtcHRpbmcgdG8gY3Jl
YXRlIHN5bWxpbmtzIGFuZCBzb2NrZXRzLiAgTm90ZQ0KPiB0aGUgJ25hdGl2ZXNvY2tldCcg
YW5kICdzeW1saW5rPXVuaXgnIG9wdGlvbnMsIHdoaWNoIGFyZSBkZWZpbml0ZWx5DQo+IHdy
b25nIGZvciBTTUIzLjEuMSBQT1NJWCBtb3VudHMuICBJdCBzaG91bGQgaGF2ZSAnc3ltbGlu
az1uYXRpdmUnIGFuZA0KPiAnbm9uYXRpdmVzb2NrZXQnLg0KDQo=

--------------mwB9J9uY5lsLwucEyJtBS0ai--

--------------fIp0n0zSp9zuPsZ6RpCw469l
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wmMEABEIACMWIQQSnW9toxeqqPSSp+ZFamLVZgJB0gUCaIuv4AUDAAAAAAAKCRBFamLVZgJB0rxj
AKC4Vmh+M+c55kQAPWR4/9s8avpXrgCfRUyNfn3pabQ+pbYSnoD4pOv/cHw=
=nh06
-----END PGP SIGNATURE-----

--------------fIp0n0zSp9zuPsZ6RpCw469l--
