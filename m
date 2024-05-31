Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5145D74068;
	Fri, 31 May 2024 07:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141307; cv=fail; b=iXnq1nT4EwxYJ4jZFzh6MA+FzK4dFFcN+SBfNIKeaWwgCv1Zam5fr/zTbE+923XLDQhEbJSBjnuuYqbRNgkeoj1il+CQzQuvBuuTuGaStYP6y1eQg6Ra+WJ5b+iu6Rvhuxc4PpueGgCZFh4QqKinRqitYTeVjHm6vJeYt+1DiT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141307; c=relaxed/simple;
	bh=hs7lh3kEyKaHQFI6SygnZR+7gyHVvQo6tE+3KJiYlJ8=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=orznRo/FlroVN9gxdgGlBhclanoE6PcQEeYIuh4qyz0MZLatrIlQopQLsjcEORV3+tVOiLdzeU1qEidQJGqrum/f/JcbJx5QFmibkCqX0V5DEuY9enxVn0oGYanuPvmccj8cn62wYY6Nz+YdDcQHydlAjHNsamEOnRtfiDzdnfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0XkRGL4; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0XkRGL4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717141306; x=1748677306;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=hs7lh3kEyKaHQFI6SygnZR+7gyHVvQo6tE+3KJiYlJ8=;
  b=Q0XkRGL4Jc8Z0RJvJD0+Hqfl+KIKP3zviOFJ+O692EUQMcgUWhE30869
   yLCJbajQ/1IOqjbCuOYWUEO1ZIAZdn8Ekou9pGvxKv/y+LCer0sUyMYkw
   rIdJ+t+xyBTQ4XM+B1AUk0zG8yQ5VJSx52yUb4W7XhGuuA3+risfK0UeK
   CBlcP0+n71lei84pE1R/2sfunLyGaEcJvXFO9WPGRFqkn45zmAfu/gHb5
   AdempJAkS3qxFsowaln9F0C31hKlHwicySGckbjHwuFLpQBABe3iwGXX8
   kir63ZK1Lpa8Q8aeGUk1Bl+HlZg8lIrzbt+6wXEQsKavp/ReDH2CruLqW
   Q==;
X-CSE-ConnectionGUID: vRe9gykUQWmLVieT6/d98A==
X-CSE-MsgGUID: 9b9X46QsRDm4VdmTGGboZg==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="16619329"
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="16619329"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2024 00:41:45 -0700
X-CSE-ConnectionGUID: kkuBOOdGSU2lmcoU2NEOGA==
X-CSE-MsgGUID: y8KxRWSRSu+NDJchOfpHjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,203,1712646000"; 
   d="scan'208";a="36112105"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 May 2024 00:41:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 31 May 2024 00:41:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 31 May 2024 00:41:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 31 May 2024 00:41:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVxp/nMbY+h7whNXdsTXUGD40P0TBdcGSQwewtngU03Ff6buoEPEfKJilu3LLGO0kJpE+HLSVjxbF5tZ7pC3gFOHZ0NyCx1YRfQt/GAC23UUaxkcfmKMSFzfBZMRbnKCzuSLvCJ5/4qo3E0Xaxb+GkAHerK0Ko0gzKih7xnjoafWgGTQdv8sVHqQC0XPtt2Ks2ysuI1nWMzzBSJeNQjhjSs5TDTMH+aAzJ9EGJdtuLhD5O5BgYrj5ThnuNWsO+5j0YiHnkA0egvCupYE9l8B1q6PQy4ehWOhoQfRo1Thi5+SaWAjP1NRD1huPBsuXeYDloFjxXqpN5ONNQE24Kzydw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CH06MnDHkyZZFy6Nm6LWL0n9zAyHmlhggpSoeByivk=;
 b=eW0EKuTOdP9nFz8HCDbhYm/QjjiJQO745tgDwhffEIdlYa/qdFLUmk7CEqFtKomIVufCgpajAE4lmkt9Z52wG7niuDRspKwlnUHgdb4+Tm2jwEb8w1S5uRmQb0WIgtoD5okIAFYel8z2aEyc6YpCviZF51qTqf2rpwW0AhBMF7Lcgd4vD0svrsKRxDCGpR5dZY4RddP2E9nKVrOZPosxq8cGs0qbrs8/KmS7XX8051HCUU8GT857weM60xJEk1h6oCLV1Yi5qAdTgwgteonvXp0KbFNyLk4ankp+TXPgrTldoA/PRh2c37e4C6zdoreA0ORY48dCDRtUXPrNdenW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH8PR11MB6901.namprd11.prod.outlook.com (2603:10b6:510:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Fri, 31 May
 2024 07:41:41 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Fri, 31 May 2024
 07:41:41 +0000
Date: Fri, 31 May 2024 15:41:32 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Steve French <stfrench@microsoft.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>, David Howells <dhowell@redhat.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [cifs]  a395726cf8: xfstests.generic.647.fail
Message-ID: <202405311515.b6f72867-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR01CA0178.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::34) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH8PR11MB6901:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e3b0424-f733-4b28-ed56-08dc81451cc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+Lu3f6kyLB97nIWwPxPV9iACygtlVGQZLorXNysuQvnaSb9j7Zc3QLi3VF+8?=
 =?us-ascii?Q?Cz27WvaARKq4ua56ZHuDCKHAmjkpAU2XoTgboAvik8jV7X9QhBGhhTWRCZj/?=
 =?us-ascii?Q?5eq725Xa1n0CCuR0vtl67x15kDUblJnsQNkwnyxeb2K0Haj8DuuO10V7Pc57?=
 =?us-ascii?Q?ax+xgu0tcDAdsyqeXiP1M0V/G+IyjAYodpI01p+idfqWhdWiuc4aMi5Rv62s?=
 =?us-ascii?Q?i7KrRn1DaYwI+z5/x5GJj5ytZnhBYHuhY4Gd7uMbcKNEIjHpqDE02jdvxXOI?=
 =?us-ascii?Q?4DJQsWZ5eJGR5n5K5X6idTLVx8ktN8ILAgjh8TptVCX7GWu60X6cdXTGq9XE?=
 =?us-ascii?Q?ZduQvIwdz7frAO957vXyMH2wCFBOJEFrwx2vBzn7usTTHdzuRXxcgytKLifk?=
 =?us-ascii?Q?ZcoA2ga0jpz1ssicU3ySM6xG2J6CxM1lVp2CK2FpzACtEZz4gmyZCkWo3lHn?=
 =?us-ascii?Q?kOtfKo0uBw3pUeWNHWExY+MBueuVVBHbvjJoi6yKTf/+XAPbmepOHi96krYu?=
 =?us-ascii?Q?UZMFdb/6bEv2VSZYsL5eoLmA7YBZMnwceFf1mQA5reU6d3WEFVgn8yvOAndG?=
 =?us-ascii?Q?BOiACCq3wEYBARmhbPIHm5upvEzk3eDFcq8dfPUcszmQeq+OquSIn+YdSLI+?=
 =?us-ascii?Q?uaTkuS9q2CH+uvPprQYDlgAK2yyqE38aLhrByXBfkaYenMj3p0oUCTKkkMhN?=
 =?us-ascii?Q?KySTU5BbJEPbfd11D8rdFNOBupKOG9I6OLwzhQAUWBV65IbU+J42ikc1bjM5?=
 =?us-ascii?Q?f2Vo4bOZ5/CwujrMQaU93GeSs8BHoRdP/rbE92qpXP8e/h5ouo0oECmEBwiI?=
 =?us-ascii?Q?X4GyKHorbhpLUGXhcM7Zgcg8kbE7CGZMI0GbZEP1FzjwdVdNOLIOxLvRtAgx?=
 =?us-ascii?Q?VgFJNwqsaORIKgfBDepeoFMDhTAtoY47iojTNilWwe8pKFdU260GjL9UFWbQ?=
 =?us-ascii?Q?R4XcCtK7LAgGM+oxfBTTMRUQRyw+phW722MezI3AVh4Mj4rD74vqYZCNHGMP?=
 =?us-ascii?Q?Y248X0tyj8odKh/+LUYDDdx3fHXziP3FebV6Zu0eEErD2n1XyvFv+MEeExhO?=
 =?us-ascii?Q?AJV3gSI01HJmI5Ny086O/3fO2zc+UBj5GyRiyTXPZHZ67psHL1zawkndlf9I?=
 =?us-ascii?Q?xX8uxQS+WOdH0n8+VBxx6aAReJDazgaFchtd+/Kq2ofSOH8IA3L3ibEXIgKC?=
 =?us-ascii?Q?4fkRdrs9rCblC6g/xZkoZEZpMSGRkO1l5uvyGMJ3qjzE0zJt5HeVF0StVMs?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9tkmMw4CBIsv8+NA4Fu9Tw2SFC+o3KvXtUNaC3E6iOzFZDi/QXbgvdE6bY14?=
 =?us-ascii?Q?Z3gy7kpW2XszUobtGZOzkvqukhSV+USUFalBBbPpgqCHNGrXWTX/5iio6+QI?=
 =?us-ascii?Q?MmU2EIpk/OhJmbCoesdf0IPqEcHxzp8aTIoEdmraEQF3XbGAjPCYHOGOTWOC?=
 =?us-ascii?Q?KwRXmqqqWvGguO7lj1oxLIhN9R5uXpdQmr/BPYsotmGy6aoLcWn5Xh52Ws+p?=
 =?us-ascii?Q?pKO4mhgRxxwwywaN247Z85I9a73mQYjRF+fnwG/o4Vz/83bXUJ1OahPwgmqd?=
 =?us-ascii?Q?2DO4mWRON6oh7HS/AxfWhNzPRl5Xf0tzFo8oq+8W9/CifqKKvBKy1kqDBsBt?=
 =?us-ascii?Q?dBSeMX5ls61xMpAzDU52ebxZwfyG6IAFIGJJtZ5naNzw+NhusX1jc/xfa6x3?=
 =?us-ascii?Q?2YYmbzoURnhCzFrHKeA76y7wwoA8BTO+dlWljUUoIr2RI3qX9l95WE+wPyHO?=
 =?us-ascii?Q?kfjRQiBM2Mb5afyZuwPjeroAm+FlyUwpd+CX9d4YO3fHjFeFeQM/3sT4tmab?=
 =?us-ascii?Q?szKwV9BwK53oydRhfHMXecn4xvG320XDBk6h8Yw24zMuBTX5qSfb+iMCk16Z?=
 =?us-ascii?Q?LlZ3HuQgPHjaZwOayyFP2iLiYsBe8t2pBCr0l5wlX2TZHPG3Qu7XZiSs2JG2?=
 =?us-ascii?Q?tn8e48ZxDQjI/wQsof5qFO/RPFWRO1sY9X+r1a0zV2oNcGDhBumEvpbHee6d?=
 =?us-ascii?Q?SLVhaioz/d8wICPIJcupc6ysTST4ylCKQV1iZo1qi0msAKxKJ9BIt5aqo6Md?=
 =?us-ascii?Q?l6KtEKxKNtWHECnaQVC03aVlD2IWn9EgiDbG91g2JtHioCJFbz1AYT33WKrX?=
 =?us-ascii?Q?ZoY5UqdVYGYo9vketjBMWnF2j4LBzcr4NWTJVqqvthNSS20m0HWZQBxCnUnk?=
 =?us-ascii?Q?oU21QahKgZTCVMbm8o5ua7Nldfi0fcDzYGcNlAFM1D35zrxyZ9qkSpHX791t?=
 =?us-ascii?Q?4u99LtvumiiZL3JVvbFV2IauYuIbP79JlxUEZIeuVMWiQQIj9p67NFQxoqYV?=
 =?us-ascii?Q?8YU3IDBAHPlVUQ5cxwTeAoT0X7PXAtmC8WHqQpTemwJ8kNcLZquh7+B58JBO?=
 =?us-ascii?Q?eNUpaNVc58nhXzLMEY+iCsseK8liq3hPThilJ6H0U1DnO2kao2qVlwKzvqSY?=
 =?us-ascii?Q?0m+yGbY6+7byNpLmDMtwdutm5KCsxcPzUVxTxDhmAY3/kwzzplzyupNhnOvs?=
 =?us-ascii?Q?UAVrezQ5to7sACijgVJx5NvCmHJhJXX80avzsF3ZPaYkwdH3rMpTvI8+xMML?=
 =?us-ascii?Q?9AfKnu6Q8PLJv00mJOW23P90hjaJP2HA4Ark5eiHVBtw4AlU/TKuCheB7z0u?=
 =?us-ascii?Q?N5STgWFY51inPLHIlA5p5xirTt6NW68+YRqg/2ZCDef3H719GLK/0I3qG0W9?=
 =?us-ascii?Q?2SObWfcPtuwBc9Y02g4nz/LqOCyn+0l5FfVgqibNPGEBMIhCCUwvJjaHWQ4a?=
 =?us-ascii?Q?SN2/3Vyz8mA8WhrSlMwgQI9jpxvPH3eI3k/aUcqFvadg7ar+bjdDLoMEOn3Z?=
 =?us-ascii?Q?Im6C71TvdN4Ph7pxQlzdQr9LLLiBCxNQQ9Of5xE00dL/HpFn0IgQdIpz6IzG?=
 =?us-ascii?Q?sD+AIikb1ifRLp9frRrmcGFP8G7sOuxfhHtD0Yycf/4MSggAMGfx53l1Y82f?=
 =?us-ascii?Q?NA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3b0424-f733-4b28-ed56-08dc81451cc7
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 07:41:41.6194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K6mq7YyMqLXE3gp6z8PRGrebBGFAu1LCd+AeIPp9jHbbBvcQ+iZui2oWqlYO2znZnqktxSirFqs9Jx73Mqj7wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6901
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.647.fail" on:

commit: a395726cf823fe8f62f1b8c3829010e5652ce98c ("cifs: fix data corruption in read after invalidate")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      e0cce98fe279b64f4a7d81b7f5c3a23d80b92fbc]
[test failed on linux-next/master 6dc544b66971c7f9909ff038b62149105272d26a]

in testcase: xfstests
version: xfstests-x86_64-98379713-1_20240527
with following parameters:

	disk: 4HDD
	fs: ext4
	fs2: smbv2
	test: generic-647



compiler: gcc-13
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405311515.b6f72867-oliver.sang@intel.com

2024-05-30 11:21:01 mount /dev/sda1 /fs/sda1
2024-05-30 11:21:03 mkdir -p /smbv2//cifs/sda1
2024-05-30 11:21:03 export FSTYP=cifs
2024-05-30 11:21:03 export TEST_DEV=//localhost/fs/sda1
2024-05-30 11:21:03 export TEST_DIR=/smbv2//cifs/sda1
2024-05-30 11:21:03 export CIFS_MOUNT_OPTIONS=-ousername=root,password=pass,noperm,vers=2.0,mfsymlinks,actimeo=0
2024-05-30 11:21:03 echo generic/647
2024-05-30 11:21:03 ./check -E tests/cifs/exclude.incompatible-smb2.txt -E tests/cifs/exclude.very-slow.txt generic/647
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 lkp-skl-d05 6.9.0-07376-ga395726cf823 #1 SMP PREEMPT_DYNAMIC Thu May 30 15:02:21 CST 2024

generic/647       [failed, exit status 1]- output mismatch (see /lkp/benchmarks/xfstests/results//generic/647.out.bad)
    --- tests/generic/647.out	2024-05-27 19:30:46.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/647.out.bad	2024-05-30 11:23:38.490521034 +0000
    @@ -1,2 +1,3 @@
     QA output created by 647
     Silence is golden
    +mmap-rw-fault: pwrite is broken
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/647.out /lkp/benchmarks/xfstests/results//generic/647.out.bad'  to see the entire diff)
Ran: generic/647
Failures: generic/647
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240531/202405311515.b6f72867-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

