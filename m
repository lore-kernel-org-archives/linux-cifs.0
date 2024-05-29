Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8E715B0E1;
	Wed, 29 May 2024 02:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716951299; cv=fail; b=JW6+mFA1f9MT35e4v79KFr9HGZTFObKShRIBD9S6XIFJhB85oMeomeq9ex9VdHl65PvikU/ABW21rpZ5CgYMxwM5jFR8uKouYbeQ1CiT0EUD6hcgVzE7FiuRV0pBHem+GcwmYj37O5Au+QrlldgZXAfnoQr2zq2lq5PvB4cWrM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716951299; c=relaxed/simple;
	bh=jMJ6c8QF71zUCqQiGbFovr02iZxh0e/Jo0GfVh4Jklw=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=WUORbiA0lG0GpssJLU0XGbRDdJdqN6QdhjmIJ+U1g/aqUzUsWy20ppj8ybEPlHeCUv63ltHLvC561Z5ElTuCcuRQMpAnuC6ALl3JbezyvjtgR/G+OvtTelp1Db+5HHGhqO11e1JT2kDn3Mw/N1GyxvsB7LOOwwJNspMYZqW2iUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sbkel6dX; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sbkel6dX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716951296; x=1748487296;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=jMJ6c8QF71zUCqQiGbFovr02iZxh0e/Jo0GfVh4Jklw=;
  b=Sbkel6dXkpwB86gGboHAQVCEom374RYjKcNCa7oL/JiAsYdkItaRBHx/
   O47Mdoe8WigZGyklxvQ2iMFKXKsNzSvP/qinILfSRUmyv17tOiuw4i7bu
   8GYYpQmTVrlos8o+imtgY0j/E99WK4eC4vA21PUdPWEhTuUrNdJGmT7IF
   n4PNYzb+65HwjCHFN2tjbVbgsZftM3K/2leS+u4bzp5MmzHoh22Tjqm1M
   BihDHWvDEN59yIcIoRzuE3rYeYMWJfs/K6C+8IO9MOypto9Nf30h9YPJt
   CqoiyVp3HBHOywGbJTM6S1XiAomOblhSHIuieBGLH5uT15BIsXZ+Fa5Ot
   Q==;
X-CSE-ConnectionGUID: oYSRxtdeTYCyf7X43FcwWw==
X-CSE-MsgGUID: w42sEu37RqeHBy8ABoyM/g==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="23988786"
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="23988786"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 19:54:55 -0700
X-CSE-ConnectionGUID: rdhDg0tDQOK+JxMoWdF6Hw==
X-CSE-MsgGUID: n5DRkW4MT8WqpSViboXjtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,197,1712646000"; 
   d="scan'208";a="40269087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 19:54:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 19:54:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 19:54:54 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 19:54:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faegF2N8KGXbChvDTiuDLDXhDNDrI1JbKNwJy/t4U0/KnXzduiI7Sr3qrjx+nhD0yDP1iXJTAGaQx7NjU6+x6JRt8HInYzxxY7WcZaAyRiJedTsnEQsgZ+ggOHH5yge+Wu5727fIck4XXNb9wxXBdBAz25lA4WNZeZLbhE42xTZRD89vneyIOupvAah0PkrCJ3p4fSHem2MKOIXiKB3YiDnyQv2HpxsF5bG4ttmrzCepb3SPMDpqGpCgPyjwOEFIXz+KrY0U9Bv94fGd2yDXz1Q7mgnsr7AxR6S0azTZIQfg4RpFwKWWAXO1bKY4slc/cs92wV/aNXj9qKf5mN4PYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFlJvzYJqJhIy9ydsmcfP6kRetiR+WyalmiSb4Xd3ow=;
 b=k5OfetHwEqflXQOS+2SrAT6S6JeTtAia/b9jOmhQWVBAKhS6/qfWgfza+1AtpLUI+JxCHbQhEUoPGz1kGTHJDG0SY4seFSDwwcqQ4vFr0tstsKl0zpHriqUXKonjyp9IdKEbXa55D9IGPa1nHTcSwO7v8ZNj8QomXoYWAxWFxrV9XljGfyRZFanjWri1+rwpg4IczUnAcy1a64BuYQ8CqBbeiyP8/KnxEnvVjWRa3zP1Xk6OFMT+AwEo11mkwcm24uji014DW+zpIaEBqsmA6kKcqJspTvkQkp1WUitMoEfM1JOp9muc9hDYSx5T8XrJfQlX+VmsVc2mKc/1eOnggw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BN9PR11MB5227.namprd11.prod.outlook.com (2603:10b6:408:134::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 02:54:52 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Wed, 29 May 2024
 02:54:52 +0000
Date: Wed, 29 May 2024 10:54:41 +0800
From: kernel test robot <oliver.sang@intel.com>
To: David Howells <dhowells@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Steve French <sfrench@samba.org>, Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>, Jeff Layton
	<jlayton@kernel.org>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <ying.huang@intel.com>,
	<feng.tang@intel.com>, <fengwei.yin@intel.com>, <oliver.sang@intel.com>
Subject: [linus:master] [cifs]  7c1ac89480:  filebench.sum_operations/s
 -19.4% regression
Message-ID: <202405291057.64718f4-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0243.apcprd06.prod.outlook.com
 (2603:1096:4:ac::27) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BN9PR11MB5227:EE_
X-MS-Office365-Filtering-Correlation-Id: f2cde61e-3725-434e-f3a2-08dc7f8ab610
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?abT30097L5R+3lo8qDeTCun7AK8ynlwBUjNmQG76FaN0kZKH88rdy4xqAE?=
 =?iso-8859-1?Q?KgR2k9gBks+qkejxs6NbkCzU3Qh7rUistCrbGX5AIyuUkObCOdiJj+i9r/?=
 =?iso-8859-1?Q?QoIcCJv29sMPHGyWan1ArAH7b3NOj0naEfglLl8yysK9F4zS8p3uJxxQsK?=
 =?iso-8859-1?Q?6Ho68AmGnANUiYxW5lRFp4a2cPq3K89+AQjjT/eP/+UPnIdLWXLkQbXCU/?=
 =?iso-8859-1?Q?yQzjdPGdFIsCamDac0qK/QrxYOA3yeibeez4KU1ALTPwqwdxW4ZX+nTS98?=
 =?iso-8859-1?Q?3GNxEMXTTK0+q5YAZBi7OFOLVrpLrNzSC9JbpXTl5s7P5FXYQFfAsdF21r?=
 =?iso-8859-1?Q?KVYbvsz1hogMaOAtnxiRgI6R6HwvZrw3jUnpYXhnj9cQemAAp47pfQojG2?=
 =?iso-8859-1?Q?k0xfdAL4AvB9sb7FvNljedUvA5eBqLErMAOOQtuMN+k4aOTKbUEDteVj70?=
 =?iso-8859-1?Q?hPFxY0461uZcgSQiCGfWFVcNFl7seD0TluGpWLgY+LS8c1pcDMjBwJHCO0?=
 =?iso-8859-1?Q?w06SQgR+JbPs0UoVHvpaNeyiXvxx71BERvzwEbVi5gAsztdbelaoAXSxxV?=
 =?iso-8859-1?Q?Nez8U42XkvzpNQJ1v69rK6wiaBtd4H15+j9hXn7FgxOgI+xLhORssdYakF?=
 =?iso-8859-1?Q?m5cHdzRqwYngJqVQypOjm1Qa9UiqrPiq7tgj701oaDblbEH4cEo6aMOBoh?=
 =?iso-8859-1?Q?OE4kkG7/ORsCTyIwWyzWIM5BdSiLuC7VUqe02d8N/1lt03gNPBihvMZC/3?=
 =?iso-8859-1?Q?2GzAJUUbs1RvLUZ+Nqm2W8oRTZu9gIzmLUxNLOPr6Yx7uCoExPrdWvF8a0?=
 =?iso-8859-1?Q?ULkerDoGdA7/1QcfMXG/hYTa/C9KzwKGmDhgM5Z5YBZWV4y0ybuD6uuuoh?=
 =?iso-8859-1?Q?TBb+/YYRSd7M26DzSYydn+FkpUnJxhzFOSN4LsJeuUzyizXGO5lkTX3FRg?=
 =?iso-8859-1?Q?gorStTTleDH/ZahYZn6r0QxHn6opk7L9vs/BXJIDLI0vrvqZ8mPHEC0toT?=
 =?iso-8859-1?Q?gfCJ+J/j5bpShLMVKmODuo5OKaI4iMiBagvIRljaZVT5G2QzP3BRfKmHQm?=
 =?iso-8859-1?Q?GlxFELIzN3Degh9hyZGlk4ymHcnB6B/K1BDkveSylZcnEmvh9NUOjDO/B9?=
 =?iso-8859-1?Q?ZKSdIIhYhglQqED8eCh9fuk3xL1u50l/77ZLOG7go3sF0LewWhwi1/LfPi?=
 =?iso-8859-1?Q?pr/R1Zt4W/2h4lGH6C1ULhl3fP3NBr2eVyILVLzmxSKroWQYcX9ZxYZTDd?=
 =?iso-8859-1?Q?TNjh2FJs/hR6dXNBkzCluADH+jLvmFjCUptzKqI8Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?bC608l6eR6PZvVEVA/djuHzIZiFGCSxEqILU6F4w2CPoayb3TSe7nAPrcL?=
 =?iso-8859-1?Q?NfQjYK+yqINdZ9hUrj0VB/QqBFiADVkYh1JV3M9ophB47xIvYR185Td/gS?=
 =?iso-8859-1?Q?XakcbwZx1dt7kPFzyyW7H8eJsW9UZz/91X3gl2QnVf/CYE+s72nu3OGEZa?=
 =?iso-8859-1?Q?OIKInOOkEtE0ImKlRSzzeUGuak/Vl34qtKFpZWbHo3GB789bB3bPyYrWP6?=
 =?iso-8859-1?Q?QEkve15hKDBcFserEz9okcMxdHfpIXHt32j4myzyETaYX/6LhGU1KnS/77?=
 =?iso-8859-1?Q?WB3OQw8yZU0VleWnx51h05Sj1y7mFCH8Z33KiXc1AJKeHAuCGHtTQXMWSg?=
 =?iso-8859-1?Q?cKmcansTXsv9fXqFa4Lw8IKtQMO/efBYa+WMdc4RCnSwu/Yb5ukkaiVrev?=
 =?iso-8859-1?Q?6YTSW2hbZ81/RQvXWxCQtrc8Mq3t8zD+NFBzdU2QgiF93ryyJWax9dlyvg?=
 =?iso-8859-1?Q?TvY3XDRZ+AwjK654V2UtF5ikBCO+FReiekGWWmMNdkBxQGE7cu87DSZWKh?=
 =?iso-8859-1?Q?aJzAOvuATRDO1l60vPTR5x0keJkgVicw+AoLpfRMHtFdedlDjDq7DZLDtr?=
 =?iso-8859-1?Q?8aP999DDS9oV6nl86Tnj9F3SUSjPNQ9TDmAmqH7+bQ24Cz4ZsCJdVwXg74?=
 =?iso-8859-1?Q?/37UqsQFNcgbjigVk4UnORedZj29jBXyQGIhNUXlCXxxx1Lj3cLuUY2VSz?=
 =?iso-8859-1?Q?kjLkrbsZ37909xE9Oh/r8VZ7DdC6YCwzVIjU4J5WRoIiJyWGalBpjB4Sz4?=
 =?iso-8859-1?Q?2bCOJ0AhKvth2mp8kU9+j36n5HG5U6q7Dhxbzl7KImn3XjtAWZ1iuyyvgE?=
 =?iso-8859-1?Q?cGJhDXjngstS43krZbIqVONbGwT9tJZrIHjdpvwJAo2Jb7mp5cTJgQGkop?=
 =?iso-8859-1?Q?qodM7uaLIvCO5dmPmhdsf26orfutGibq0Zv0S1p+QCSGfjsGQbgPS7jcbz?=
 =?iso-8859-1?Q?8nFeqdZRztoE3AttfAqTOiO7nc11xiQe+wkXIkWY7V0FRR5D0sUT3mo+F/?=
 =?iso-8859-1?Q?LeFxF0HqpangDkQPVG2LGfWvv/+IrGYVXGjnIvvqmPZmNoffX3ZREa+YWm?=
 =?iso-8859-1?Q?U7JizvFdp68ZrxPuVlscaVTohBsbcw/bPzCkPtGpf5pyX/4cBwlymHK66l?=
 =?iso-8859-1?Q?ALUr7cB3fQwV2vd2c4RWsdTqmC2Y4yR1X12Sn9hp2Y94tqHg8wsjZckrqs?=
 =?iso-8859-1?Q?5kYhqnl+TR6/DQOkpmNWkmsf/RKpVNs0DpwxCjd4IkZoNA+xerd+xQa2Ws?=
 =?iso-8859-1?Q?ys1ShxI6wzZ1L695W3gjcRFRAS9yM5vL/6Qf2CAIFfXA9T6ZaXARNMv6V+?=
 =?iso-8859-1?Q?q7Ug5G4ViilogamKW0I9KlcRkAVC/Am/Qx8aaSFYRgl4+GYTFmmajihvVX?=
 =?iso-8859-1?Q?CREbaSotC+SpapJGafeGId3ExxTHzuvJ+AC3VfhetsPHLzVywxzByPvdlF?=
 =?iso-8859-1?Q?b48UQWf53NPDwpTyeKGoAahEK7DD7ct8/SpLKCo7LXp62ujYBGVCP12D3s?=
 =?iso-8859-1?Q?MKcvzFBIjAp1gqMjh0ZUBKaH3xKT7pKmUwkZLutYqYZeQtEtyv6RHbPZqf?=
 =?iso-8859-1?Q?rrTgSlZOw8fnZj8L/lp+dSZ7yREaQePOEWY+kqw+MnZPpBrsKplhXf5tAS?=
 =?iso-8859-1?Q?KNTs7PgR90OpW9VldhnMDfYhPwZ1uyqfdz9LICNQynhcdNR2Vzr80VCw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2cde61e-3725-434e-f3a2-08dc7f8ab610
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 02:54:51.9695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gIyILGKeyuYtVZetzN0MPc7mw54HkRtok8+ZJllq7Mb3GhluHwsN+BQEfd2rO2yBt+ltGtEKAz8VdJi0yZET2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5227
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a -19.4% regression of filebench.sum_operations/s on:


commit: 7c1ac89480e8d5d34d38a868642216c8f05ee602 ("cifs: Enable large folio support")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: filebench
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
parameters:

	disk: 1HDD
	fs: ext4
	fs2: cifs
	test: fivestreamread.f
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405291057.64718f4-oliver.sang@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240529/202405291057.64718f4-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-13/performance/1HDD/cifs/ext4/x86_64-rhel-8.3/debian-12-x86_64-20240206.cgz/lkp-icl-2sp6/fivestreamread.f/filebench

commit: 
  b593634424 ("cifs: Remove some code that's no longer used, part 3")
  7c1ac89480 ("cifs: Enable large folio support")

b593634424d4ff13 7c1ac89480e8d5d34d38a868642 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      1.56 ±  7%     +44.3%       2.25 ±  2%  iostat.cpu.system
      2597 ± 30%     -82.6%     451.00 ± 16%  perf-c2c.DRAM.local
      1.53 ±  7%      +0.7        2.23 ±  2%  mpstat.cpu.all.sys%
      9.73 ± 98%    +481.0%      56.53 ±  5%  mpstat.max_utilization_pct
   2712692 ± 17%     -57.3%    1158294 ± 15%  numa-numastat.node0.local_node
   2790157 ± 16%     -55.9%    1230718 ± 14%  numa-numastat.node0.numa_hit
   2789418 ± 16%     -55.9%    1230047 ± 14%  numa-vmstat.node0.numa_hit
   2711951 ± 17%     -57.3%    1157623 ± 15%  numa-vmstat.node0.numa_local
     28475 ± 29%    +207.2%      87478 ± 14%  sched_debug.cfs_rq:/.avg_vruntime.avg
     28475 ± 29%    +207.2%      87478 ± 14%  sched_debug.cfs_rq:/.min_vruntime.avg
      3.17 ±  4%     +18.9%       3.77 ±  6%  vmstat.procs.r
     10197            +7.6%      10973        vmstat.system.in
    701646 ±  6%     +46.9%    1030651 ±  6%  meminfo.AnonPages
    937851 ±  5%     +36.5%    1280516 ±  4%  meminfo.Committed_AS
    722721 ±  6%     +45.5%    1051746 ±  5%  meminfo.Inactive(anon)
      5888           +11.2%       6550 ±  2%  meminfo.PageTables
     36277 ±  6%     -19.4%      29230 ±  4%  filebench.sum_bytes_mb/s
   2178950 ±  6%     -19.4%    1755646 ±  4%  filebench.sum_operations
     36313 ±  6%     -19.4%      29258 ±  4%  filebench.sum_operations/s
     36313 ±  6%     -19.4%      29258 ±  4%  filebench.sum_reads/s
      0.14 ±  6%     +24.0%       0.17 ±  4%  filebench.sum_time_ms/op
    175413 ±  6%     +46.9%     257668 ±  6%  proc-vmstat.nr_anon_pages
    180693 ±  6%     +45.5%     262957 ±  5%  proc-vmstat.nr_inactive_anon
      1472           +11.2%       1637 ±  2%  proc-vmstat.nr_page_table_pages
     63627            -4.2%      60945        proc-vmstat.nr_slab_reclaimable
      1079 ±  7%     +19.7%       1292 ± 11%  proc-vmstat.nr_writeback
    180693 ±  6%     +45.5%     262957 ±  5%  proc-vmstat.nr_zone_inactive_anon
      5942 ±157%   +1351.7%      86270 ± 28%  proc-vmstat.numa_hint_faults
      3304 ±175%   +1389.9%      49230 ± 36%  proc-vmstat.numa_hint_faults_local
   4601423           -47.1%    2432956        proc-vmstat.numa_hit
   4467440           -48.5%    2300320        proc-vmstat.numa_local
     49222 ± 40%    +193.4%     144420 ± 27%  proc-vmstat.numa_pte_updates
    623992 ±  5%     +42.5%     889010 ±  6%  proc-vmstat.pgfault
   5825920           -21.1%    4596157        proc-vmstat.pgfree
     30735 ±  8%     +80.3%      55418 ± 28%  proc-vmstat.pgreuse
     38.97          +257.2%     139.21 ±  4%  perf-stat.i.MPKI
      2.87            +0.3        3.19        perf-stat.i.branch-miss-rate%
   5231053            -5.6%    4936215        perf-stat.i.branch-misses
     11.93 ±  2%      +5.7       17.63 ±  3%  perf-stat.i.cache-miss-rate%
 1.199e+08 ±  4%     +28.5%  1.541e+08 ±  6%  perf-stat.i.cache-misses
 4.493e+08 ±  5%     -18.5%  3.663e+08 ±  4%  perf-stat.i.cache-references
      3.27 ±  3%    +115.6%       7.05 ±  2%  perf-stat.i.cpi
 7.142e+09 ±  6%     +41.5%   1.01e+10 ±  2%  perf-stat.i.cpu-cycles
      0.42           -12.0%       0.37        perf-stat.i.ipc
      3060 ±  5%     +52.6%       4668 ±  7%  perf-stat.i.minor-faults
      3060 ±  5%     +52.6%       4668 ±  7%  perf-stat.i.page-faults
     74.09 ±  6%     +28.8%      95.45 ±  8%  perf-stat.overall.MPKI
     26.72 ±  2%     +15.3       42.06 ±  3%  perf-stat.overall.cache-miss-rate%
      4.39 ±  3%     +41.9%       6.24        perf-stat.overall.cpi
      0.23 ±  3%     -29.6%       0.16        perf-stat.overall.ipc
   5215140            -5.6%    4921709        perf-stat.ps.branch-misses
 1.198e+08 ±  4%     +28.6%  1.541e+08 ±  6%  perf-stat.ps.cache-misses
 4.488e+08 ±  5%     -18.4%   3.66e+08 ±  4%  perf-stat.ps.cache-references
 7.131e+09 ±  6%     +41.3%  1.008e+10 ±  2%  perf-stat.ps.cpu-cycles
      3031 ±  5%     +52.4%       4620 ±  7%  perf-stat.ps.minor-faults
      3031 ±  5%     +52.4%       4620 ±  7%  perf-stat.ps.page-faults




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

