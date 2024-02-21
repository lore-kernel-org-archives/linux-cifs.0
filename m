Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18AFFC03;
	Wed, 21 Feb 2024 02:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708482422; cv=fail; b=Rhh83CL7xjMBWzLY67sEJo2zSGkRmA610sLWHx0ZPwpYKq3hXxDAFQNOHvgmL9yQndBiTtjg6wQEw0LpbsFV6gEjk2FtXG/VBI3tbg82IcPT4nOqHOq+CDkTnJROz1KpoL+L6vfPi0pnghlhhiPvW5EvefaQ/hWscUFEg4+ach4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708482422; c=relaxed/simple;
	bh=+uVclf3BHsan69+uXAvPeLbJJayWlDgsSMYbq+MdtHE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WtXd0iJCXdqKavNU+ZNLLrqCH8Vm7bi5Nplg7qHdaF+YF+rJqoa+LCy2bCzOjz0Su358p1oEIGs7/vjRqk1PQUgnpZFKQW+/0lP8IRMXu1oTrWQ97m4x00jwNkgg5Mb7mOTTNuoGzDEPM5l23cSP64fG8L7FBcR6bH85Pqv14Hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ABnc07lQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GnKh8H7T; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ABnc07lQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GnKh8H7T"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41L0QgrL029703;
	Wed, 21 Feb 2024 02:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=xrOrXMg0kUvxY2LeDvVzXQPOp8ExzuYQF4iZyIZ38iM=;
 b=ABnc07lQYkSkjUnsiRADnkNWmpFTF95SnlcA7qgMCKl80ZZTqYAcT1q1YyuKMRMxnNcc
 JJrhi0tOkjkQ1jE+fJBwl6HG0IeAtzh6YhHjJt8zdHNYqUHEiOu7kjrR98DJqRr+c07H
 cbrfmOIGJ9JgL0CFyxhR/mP54kXatteEK5F+HaCGv4618Hb5aFhfHQv12+4fqau62sNh
 IjAA/ko3Yl7azy0xIdjl6C/80TiiYAPiyfI/7IYAd073hloxNUaFOgzY//3tJiU4tdYg
 +Ov0C19vH1POTjj8fPoZzdpHSnziw5v6oRM66BPGY2ynwqrV1hEYxQNZhCJveD5LG3Kh dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakk40n9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Feb 2024 02:26:15 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41L1NPKN013149;
	Wed, 21 Feb 2024 02:26:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak888x7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Feb 2024 02:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwDYjxEuxsTN8qQ3h1vkDWTfprdWWunnAyvREHpYvZgiu6TqOsDddGcw3M50lMVyWkpsH2B3UBm3u70Brys8d3FRE3sgUFiBH57oNATXmtbI94xXrHJghN2v9i/vX/y6iOw41XNBlhMRdFSNdkhhX2l28Mbcdkl2xL4SMPkZXWrzL139CU/ZuBCit9/fz2XEQF4ep66oEK46JfYEw49xFG/pA74aPk6EWc9UNjF0Y3qfaRaqpWDp2jG5lEIyxfCwZqsBqKw6MBrg3orhEj61qVqOCrU3pKyCbWOfRZXdSyNB+41n4yVvLZLlz0MNhcjHcqB4er6eiA8FrcNaTQ8RBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xrOrXMg0kUvxY2LeDvVzXQPOp8ExzuYQF4iZyIZ38iM=;
 b=cTksDZFLd3oaJPIYxNj/D/wGgK/uwQJeu0mGtbz6LKX/N/LRKOU37R0rgxK/NC58gjye7vsIt3OOWKTJxQXWKdy+XIpa/1D+qGLRZ9jhl9SO6DM/p5vHRH1lpiqufwFPDrfVLpHZo+KGkhJgPDmB46kwfDF14M+lJ++1lg2kOh1UnX1EEZaPpooWA6RP5HWYY1DFL5hl54zuxX6wq1ALHxC17tpmYffBkpzrapFYoLM/9sK5xaiZgVEvsIQBZ91sGDyrzp/c1xskGS4X3VOTxE7kYkFp5LsVXqjrn/Y5fkDqSFieUM1kug8LDt91BeliuxTP4d+kd9UNkdoTYsNpEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xrOrXMg0kUvxY2LeDvVzXQPOp8ExzuYQF4iZyIZ38iM=;
 b=GnKh8H7T+8tIQE4Avb52ItIiTND84WGgCLd8EKu51MzaQ8pWNQuQC32yHO0qz9H3hkxkSSmV+xtUgXIKg6YlmYlWHgnqtbAnX35YuWHlsvKoY6GhFpUcVSskjgAv3G83jCI18aM+6ccc3N28bc0oZ81yZeTZcZr+gEryghbldMo=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by BLAPR10MB5266.namprd10.prod.outlook.com (2603:10b6:208:331::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 02:26:10 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::7fc:f926:8937:183]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::7fc:f926:8937:183%6]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 02:26:10 +0000
Message-ID: <eb90696f-58db-4b28-a75a-7388c1e16a54@oracle.com>
Date: Wed, 21 Feb 2024 07:56:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Content-Language: en-US
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        kovalev@altlinux.org
Cc: Salvatore Bonaccorso <carnil@debian.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        Paulo Alcantara <pc@manguebit.com>,
        "leonardo@schenkel.net" <leonardo@schenkel.net>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "sairon@sairon.cz" <sairon@sairon.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
 <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
 <Zb5eL-AKcZpmvYSl@eldamar.lan>
 <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>
 <2024022011-afraid-automated-4677@gregkh>
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2024022011-afraid-automated-4677@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0070.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::15) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|BLAPR10MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: f76f7d60-bbf6-43cb-652e-08dc328477a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1CS1fRRXWJYdBbHgJfp54/VTA8WvaOUxBJV4ZVO023QvUdUFJYIT2nvWeex9Taapn4A0TiJejQK50/t8vXJXe/bbks2CL1I40CDilrm108DZGl+f5YtoiKH3Uu03ph73EIqTbAkxfImufvn/i3UJOmtgCV9XB/a7Dwn5EXuSreZ1U7I/0JNyz7VdrzDPcpvMWYjaQEO4/0A0g8qkteqt38IGx+vqo5cxXboDjOdcN4uixlQBogxQwAO58ME1ifz8pyQuPv08gKJzA03Uy2NiTA9+wirl4gH+2zRxX12DL2clAJtV/ntSrydkU5UbKUwkrlWubyIXO+3RMwcG4a6eSEvX3b2N0847L0GsDTT9PFZ/ztEpHMPlLjf/Q0gP/0IWhrkYAaOSKOfpRKr46J39q36wYGeWagAj5E5bmCQBaQW5uZlL3yQJ+7MTYaYEWhv0ioNcoFGoeDnGGZE9UL5DPlbBUTy/8Ddf/chxTW9TpQr3LSCAuMNVdbBsBGQfic0+rS8ng1g174vhjegBKhm6Yw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QWkwYXIrK1A5KzNNYk5OTDZ0RnFsdXZhSSthMEJTOEt4L3lnc1VFTm5IY1ZG?=
 =?utf-8?B?Z1orTm5KaEtSV0o2Z3VseEdTU0lhSDNjL3Mvci8rUXc2SkEwbjFOOWh1RGlw?=
 =?utf-8?B?cExYWlBNQ3dlL2Y2clJqOTBySU9zbWg4KzRuTnIvZ2FpTi9OczlHam14OEI4?=
 =?utf-8?B?akFxVG95cjFydUhPL0pNTEZ4bXFMbTQ4a2RpTlhldENuSXFTUE4xR09MV2FF?=
 =?utf-8?B?M3BUbHBOUGRPNSt2QWFXK3BnR1J0dGJzOHF1Y2U5SzEwZ2U0a1ZiNDMxbmc1?=
 =?utf-8?B?cEdqbXFTVGlYTWJGeHJGOUp5MW4ySFdOaTlZbGFPTHpNSVBTQU8ydW84RTNQ?=
 =?utf-8?B?MVlZSzBBQjg0blUreGlQRGlBUVVJV2traGtTUDFpSHQxNVVUTTRyMlpQTzNQ?=
 =?utf-8?B?MHhnQWViZnU1QUxZeUF2Wk1qSDZLTmVmWnU0RzBvcGtoVlE4K0h0NUIrMlNH?=
 =?utf-8?B?TFdqT2V6ODBhYUhOeFpEbXBWem1YeGFCU2d0RFV6VlBWL1cxK0VsckZqZWxk?=
 =?utf-8?B?VEdHYjlocnZSVGludFB5Uk5qSXE0clREekhGclh4UTZCRzhKdmtzbkhPbklK?=
 =?utf-8?B?OEc3eld4RkdrVzkzeUxFKytFRVV5K20rTDBJd1ZXNlZWV3c5d0pBOWYrRHg5?=
 =?utf-8?B?cEd4TlJ5c0VkbzJ2UjR6cy9MTzk0cU9jOVhNUzJyc1JqSFA5eVpEVkphR2Nz?=
 =?utf-8?B?OEY5cGJkYUtLaUY0K2Y1a0ZGREdwRDZBbkNvdlFzOFZsSDV0dHJyRUVIQUZP?=
 =?utf-8?B?STZKTXdKTGpicGdObC9vcGF2cGNKZU1teHVJLzAzNmlld3BhekxlWkx0bDk5?=
 =?utf-8?B?TWR1akZ0QzJPTitIZFRrWjR3OUR5d0dlWXpTV3hJR0dFd2czeGpJTHhBSmpv?=
 =?utf-8?B?di96WjYvdWtyWGsyZUJkWk5YRmhvcTk1K0xTRTc2Ky9MUDl2Sy9iY3lNMml0?=
 =?utf-8?B?MUVsSjhkWlk3U2FRYTZBSnVuNlBiNWVvcFdGYlRaaHdvZjY1c1lIVy9NTWRD?=
 =?utf-8?B?a0RUQlBOK1BXZDNKalpKZ053SlRBeFNUaUtKb25qTlNSWGlGRzNKREpVSElz?=
 =?utf-8?B?dmNZNHNPRElnZ1Nka0lPVHQ2NXFZQjYrYkVrZHloSTI2RnQxUVlTS01yN0lU?=
 =?utf-8?B?UW1IMWJFL3NqYWV4Vk12SzlxeGtPZ20rMmh6b2VYNUR2TWcrOHZMTmJQUEVh?=
 =?utf-8?B?cWFUN2t1dWExbnUrMGg4RUpSVXlOc1BxOHBLSzVRSnhsd1o2ZW43cmRIUkRD?=
 =?utf-8?B?dk1oRjB6MW56SHJsVlhOYlcxSC9SY1g4RFVCWElxcUpkRG8vaXNKUWY3TUg0?=
 =?utf-8?B?VEJKbTFFK1dDTU12bHNsa01JejFlZnc3czMvZzVjTm0zeExrVzdRRUMvOWlH?=
 =?utf-8?B?SUwxZDZiZG9YeDFBcEFSalBRbDR5R0FQVlhwWUtEbmlHc2RNaFc3RjZ3NnZm?=
 =?utf-8?B?QmM5cXNsMEFzREcwSHEwMDZqcU9yY1RiWlNVeG11YnJzUmsyRGF6aGFQdDhS?=
 =?utf-8?B?THk5MWUrcU1EWkQrWHhXRjM4QU8waXJxRksxY3NFczZ1U1AzeWJKVURpcWVM?=
 =?utf-8?B?TzArMHNibVcvQlFDLzE0OXRBMHdDWUg3dnVmK1JpQ2lBblRXdms4RXhaZUhY?=
 =?utf-8?B?ZnBpMmxDOUtwbXdwaWk5RUQvWWF2c2RuYTRQUG5DOWdIMlIyd2ZKMnpNdHhh?=
 =?utf-8?B?RFNET3hQeFhlTm9GVGJyNnJGYlZaK1BDMjIzS3l0MlMyazc4bHFRc3pta01D?=
 =?utf-8?B?U0E1eU1PV3FLenpna2lMa2R6RlFCUUtubGpMUEQ2dkNsN2UwVjNXR2tCMDFM?=
 =?utf-8?B?UGd6elozSmJDZlY0clRsb3lUYy9Rb3d5aXpVT0U2ZE1JQnVGYmJYRE9qS2hx?=
 =?utf-8?B?N2J6ZjhBV0NDTGZyUFZmVGZ0U2NDSTlLWjRudDM1YWdyOGR3bVkwbUhHT1hK?=
 =?utf-8?B?NGtCYTVTQXVEQUlsb2xYc1R0UGR0T1FMb3l5TjQwd3VLQUgrWEJmMUJaMmUv?=
 =?utf-8?B?WExFa2RkSU5iTFg3WmJ3NGRjcXBoTm1qbnNMcXNieXg5MEI2T1ZHYVppZUk2?=
 =?utf-8?B?YlVoMWlnYThicVA0ejg1VU9lYythcTEyVFovTDJLdVZONGZlalJxbEFPWHI0?=
 =?utf-8?B?SktSaVVsL3F3NDc5QzFKS3FveXhEblB5R3BuclVlTnBmWVI1bnpXRUxHbjMx?=
 =?utf-8?Q?W3VM1LevVdN+6bwdXOToCqg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+MCg7TuQTO94UeheKTWZc5ah+S+EcV6leNiuHLDNLz8wJytbQOdR8XkUvyDDCgLncq/p0uBQPh30Op9ydVmacy4lRSD8/usQaBinMtkJVlwVh4c9zf4Td1fbuhxVC7NgBfmeskWy4luaxvz1Uj0EifafhTDEE2sUDacdg07HKhyT2RrH6DAonzt32EnZdHBfakStFab0zGkQk46OMgeZoSeG+f2xACe/KOmF+XBbMndZpt3w8Sc/zaLaZ8jyLe6jtmYeG2KkMtlH+YuJySbdtBZDeL3t7XZMhlkq3f0/IbrZdDTY6mvnclI3s7PjQfB92Sth0i1tjq7Ti9FTEAORWDNMToCJ7cYknPhcgJ7FtilF3kA0MrvvtNQqd+YNsRhbMSqxBMuuOTbhdI7ej3heqIz+RNtDVH/PsjxXpCpKKDFmVxMc/EJ2u7KDea8XuCBjoLozUo85YTfe395Ll68gMz4nvUCwvOrvAUXYLEetzsDnxAZzqptGCHrLZ/MJx2iMMpzUgbRYs0LjdpqzopOmpF5fl+bHkxIf4oYM14g3f0i7D8FIuH2cJqKvoo4uinB4rTMq7GghwW+lG8dqXM+QZ+IMn/ZlbDnaMmAf/TBY9oM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76f7d60-bbf6-43cb-652e-08dc328477a3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 02:26:10.7233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h23AEukcyRjkLVP39zwRAfkjhYpx3fIWsTVNTOLKym1v2HFqd1juMLqnfyKYml46VmkDewxLcTlL4BE1LsV1wFDEnNp8MoU1k6ho9fNZW0gE8X4GgkFTpBvwmqcthOdj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402210015
X-Proofpoint-ORIG-GUID: btsT9IVSWcQB6HFkoK33MeihFH6p2UFt
X-Proofpoint-GUID: btsT9IVSWcQB6HFkoK33MeihFH6p2UFt

Hi Greg,

On 21/02/24 01:58, gregkh@linuxfoundation.org wrote:
> On Tue, Feb 06, 2024 at 01:16:01PM +0530, Harshit Mogalapalli wrote:
>> Hi Salvatore,
>>
>> Adding kovalev here(who backported it to 5.10.y)
>>
>> On 03/02/24 9:09 pm, Salvatore Bonaccorso wrote:
>>> Hi,
>>>
>>> On Thu, Feb 01, 2024 at 12:58:28PM +0000, Mohamed Abuelfotoh, Hazem wrote:
>>>>
>>>> On 31/01/2024 17:19, Paulo Alcantara wrote:
>>>>> Greg, could you please drop
>>>>>
>>>>>            b3632baa5045 ("cifs: fix off-by-one in SMB2_query_info_init()")
>>>>>
>>>>> from v5.10.y as suggested by Salvatore?
>>>>>
>>>>> Thanks.
>>>>
>>>> Are we dropping b3632baa5045 ("cifs: fix off-by-one in
>>>> SMB2_query_info_init()") from v5.10.y while keeping it on v5.15.y? if we are
>>>> dropping it from v5.15.y as well then we should backport 06aa6eff7b smb3:
>>>> Replace smb2pdu 1-element arrays with flex-arrays to v5.15.y I remember
>>>> trying to backport this patch on v5.15.y but there were some merge conflicts
>>>> there.
>>>>
>>>> 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
>>>
>>> While I'm not eligible to say what should be done, my understading is
>>> that Greg probably would prefer to have the "backport 06aa6eff7b"
>>> version. What we know is that having now both commits in the
>>> stable-rc/linux-5.10.y queue breaks  cifs and the backport variants
>>> seens to work fine (Paulo Alcantara probably though can comment best).
>>>
>> Having both one-liner fix that I have sent and the above commit isn't
>> correct.
>>
>>> As 06aa6eff7b smb3: Replace smb2pdu 1-element arrays with flex-arrays
>>> was backportable to 5.10.y it should now work as well for the upper
>>> one 5.15.y.
>>
>> Correct, I agree. I had to send one-liner fix as we have the
>> backport("06aa6eff7b smb3: Replace smb2pdu 1-element arrays with
>> flex-arrays") missing in 5.15.y and when I tried backporting it to 5.15.y I
>> saw many conflicts.
>>
>> If we have backport for 5.15.y similar to 5.10.y we could ask greg to remove
>> one liner fix from both 5.10.y and 5.15.y: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/cifs-fix-off-by-one-in-smb2_query_info_init.patch
> 
> Someone needs to tell me what to do, as I'm lost.
> 

For 5.15.y:

1. Remove this patch from the queue:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.15/cifs-fix-off-by-one-in-smb2_query_info_init.patch
2. Add this patch(kovalev's backport) to queue:
https://lore.kernel.org/lkml/20240206161111.454699-1-kovalev@altlinux.org/T/#u

For 5.10.y:

1. Remove this patch from the queue:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/cifs-fix-off-by-one-in-smb2_query_info_init.patch

(kovalev's backport is already in queue[1], so nothing to add here like 
'2' in 5.15.y)



Reason for the above:

For 5.10.y and 5.15.y: I have sent a diverged patch(one liner) which is 
present in the queue now and have to be removed because kovalev sent a 
backport of upstream commit by resolving conflicts. Given that both of 
us were working on same problem there should only be one fix there, so 
we are going with Kovalev's backport and removing my one liner fix. 
Kovalev's backport for 5.10.y was already added to queue but not in 
5.15.y. So remove my one liner fix from both queues and queuing up 
Kovalev's 5.15.y backport will solve the problems. Please let me know if 
any of this is unclear, I can share more details.


Ref:
[1]: 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/smb3-replace-smb2pdu-1-element-arrays-with-flex-arrays.patch


Thanks,
Harshit
> thanks,
> 
> greg k-h

