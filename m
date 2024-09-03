Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0836D1CA682
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371190; cv=fail; b=ha+p2pQBDO48GlD/7y3OAxYFq+lJLs86ZRNucgjeg1/ZOnQhBIAwjk7xZfJZWGfzMyePvVeoHXH7tafaf2k3mmq1e+T7pmqOECt4k04jwYnYNzuoceilvHV/9PBCS0dn2JnTikYdLZDi936pCn9GYm595pBu2ERJKD3mRaaTRTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371190; c=relaxed/simple;
	bh=FYCrV3tWjIak7+vUoJ6mRgfEoWGtXNQPvR7Ed25Bg+g=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=jP7utF99vYeFeK+ae3NZA5vRzk6LykTZ8WTyYILpMwM/8T0G3VoWhTYi6otdeXgYbsqkh6VewXOiqejuJlzTWni37Z3/9KtnDM9jgBNl9q0Yce/iIw8K4/cvdhKaYHC8PxUMuIAnO0CpEtSSeEPK2JHkbEBzXBC2ChfbS3vTjsw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OSZV4ERh; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OSZV4ERh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725371188; x=1756907188;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=FYCrV3tWjIak7+vUoJ6mRgfEoWGtXNQPvR7Ed25Bg+g=;
  b=OSZV4ERhdlW5KMJ4zyHwbEGXOELctKMjoGgA59jsZNeMU7gBtmIhy1ON
   jEchTRYTwscb1abPckZbrzol5BuGcoDpibSsHPebWKYBymvf7u0Fenq8U
   KL5SxlrR1TnT6930+hR44RZCoaxbKUIj0WLCKFcde4CtylekRD9s5zYmJ
   8kiXnMp2HwJxnC02/Zgfm+hUkN8kKdyvxw/7dq3yS5ARtv1lR/7AziXSQ
   sRZUyOhFnDZwi40LYE9LHoOtiHoynRzuxQPx8WeF5U1gQthWmyydeQR+P
   4uea4aeDWCBCEbE80MwvzJLklBfg0YPzVJk8w4ZN3FfhDFzzT8NW5uFvU
   A==;
X-CSE-ConnectionGUID: xVddr60vQrGZCc4jTqkWDg==
X-CSE-MsgGUID: LlpQXYrEQgu4Ou1vxBNyWA==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="24158404"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="24158404"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 06:45:57 -0700
X-CSE-ConnectionGUID: mQNHNStpS4CuD4q94613cw==
X-CSE-MsgGUID: +lryPEC0QeucOQB4WqoFaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="88158469"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 06:45:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 06:45:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 06:45:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 06:45:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O01MlA3Wl2kiromyRz4EGjTaD43ylfmTk/M5YBhRvSbcmUaFAHWnEIjE0XKgYKyIFAfw8nD1DAVpN5Uq+Pfxzkx3ie7ZFRUArMEBzrW/uq3XROGanmPwYCPsJziCmMuCBXGgg0wd99xSK1Ybq3lCdkjltTF8ulc31IgRi4tTvxG1ByToXl3uYnizRqiESbYgFbDMgdWz+RRHdzXTrCFzi2/BQK1gQK5oks9AdUQzZFnPRbuk+LcWz56DnPs8qG8eK55nO+oZYdvFN8UsbHibvG71kq8RysG+oivhrERvwxTcFpxmEzn9KMzz+65sK+Y6Kzb86GzgGiwMqywoiMr/QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UIvvRUpSb68JiizQQ0SuCU0RZgBFq+esISgxGKx+sjc=;
 b=Th36I3SA2dqTMq4Ke9phjMziPseXQxVxrMFdsp8jAUzECtgf5s7Qj/Ho8JidGdRG/dx4E1FK1S1H+XrWSqoLE90juSe42l7D9GXP1jSORSJXWFfpudlody0TVQ9Z0EVLmMEyZ1MX6DG95n1h4TfVdiBNXXT7tlnFfnk/vY5eNvRMKNew4u7DZ4Ar401cpSSp11V0iSGGA6Ltv/pG0AatCKWvrVZRaR+P+PoCpGsT/oMeZsDjCN06tR3m+42UETH2/WUhrekurNOfzrFuN27Qs33Kbd+kfnU0HaeGjNvwf5CyXrEmMZqPMr7oIVdmM+KFR0c1DuLmth1KUrBtDlAGBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB8479.namprd11.prod.outlook.com (2603:10b6:510:30c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 13:45:37 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7918.020; Tue, 3 Sep 2024
 13:45:37 +0000
Date: Tue, 3 Sep 2024 21:45:27 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, Steve French <stfrench@microsoft.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>, <ying.huang@intel.com>,
	<feng.tang@intel.com>, <fengwei.yin@intel.com>, <oliver.sang@intel.com>
Subject: [cifs:for-next-next] [smb]  6c18ca82c3:  filebench.sum_operations/s
 -16.4% regression
Message-ID: <202409032100.5acabffb-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::11) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB8479:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b68c149-c24f-425d-c4b0-08dccc1eb121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?X4flqTagYbkoVMmq8KuWpKcxINtGGgM4RdQU2q+FnD+7dWljK4THQmchn/?=
 =?iso-8859-1?Q?tUHHppd/bSneuDb61ewUpOatAe4n9CIDIUk7PIeNr1dsEg8evQx2LWc+BN?=
 =?iso-8859-1?Q?nw3oDT0vy16nODiEEEPBoM6oHlv2sE0VjUCZfSBuPxXfnUgkuzZ74gU9pQ?=
 =?iso-8859-1?Q?Gv3ux4zxgAoYOPwdPBXko2o7+7NRAxHPwl0e2lmiQ1IKO8vsFaqnuGvSdu?=
 =?iso-8859-1?Q?kiv2qtN8QENnd1bsLfsshFzZ8p3a25MPkzlGSjZQaPg9i0TmdYINXdJD7U?=
 =?iso-8859-1?Q?Xw6ESo4F41QkdePNY38ynXxXWiaOB5XQ/nTI1uNQDIhxWgqyvr9LzKxm2v?=
 =?iso-8859-1?Q?UrmwJwxgNAlmPJHB/90v8NoZ3A/3dt3P1/lar/Qug6Wqq085yd2MczDFaB?=
 =?iso-8859-1?Q?ZQmqUTyoxbR24AOKgInKNFMCr7wejl+QYlzjOtrSDtQ90wlkEngBGCTxfr?=
 =?iso-8859-1?Q?EHyqLTPuMAn7RxZQYIoBg6uym159xgS19WjgHRIbP91QkOjbLb63e8ADtK?=
 =?iso-8859-1?Q?89dzNNNuTvlil3yc6JNBo7nG4ryUxK0e3W8FRbNhYgfTwhp+pub8nvBb+J?=
 =?iso-8859-1?Q?Yg3oTgq4ngJCnDph/HnpUPucdYzqgVqT+t885dAavPo8E8N74OhzN+FNq+?=
 =?iso-8859-1?Q?qwQJtokPkwYorN03e55T+PRYYrDL7WAXHGhxI0yL3gu00D8HqO4d5P758h?=
 =?iso-8859-1?Q?A1J4V26VWU7paJFBo/9MLhtS0APhb5PcshyqMsORpGCW/pnG6jYTyhM8p3?=
 =?iso-8859-1?Q?MBomcDlE+Ki4ZRxN2JgynoD8KovEb6wzY3I5UXikOuSnB8DcF3F71x4EXF?=
 =?iso-8859-1?Q?gxvsIliIAtT+4vx+cbW1scPgiajPkO8EMMM6PYVRM4JHwdj0phmofZGOQL?=
 =?iso-8859-1?Q?qIl7cxk3Vahl6KejI/3BjloifptkcsOjDf3zK7crGKTb1VIokc/41GFzHA?=
 =?iso-8859-1?Q?bmAcapPfR0BQE/qVT+h5xXugSAfyHpWiT/sAQPYOIf21p4YMPhow1DGFVH?=
 =?iso-8859-1?Q?7EkpplAyKUVmBtqaAozV1/QZim6E+43yF4gMVvJKxQ+xChmYhDGRvQc1j9?=
 =?iso-8859-1?Q?YprLhxKp3R0Dr4AxGo18BO4TV2dJaiO8cPHXeC1f+ksC0sIlsKZe23n0rL?=
 =?iso-8859-1?Q?CQ3KtnuxlX+ktPD8BoBgDDeysexCNPndm5K18QwCvJZaY5Z5fquZ+/x2Jd?=
 =?iso-8859-1?Q?TtplvXe3hIXY8RjdJx71uEyatxbSAt7QdwvuIzufNYVOkPVd7t+9lrkZRb?=
 =?iso-8859-1?Q?RIXy2i0aoxT6F2q7BdVAEcIcrCxuyClYCgi6q5Ppve7Fx12yfAsrwgO/9q?=
 =?iso-8859-1?Q?cBXJLs8fuOBTYsnEz8rKpjbNV0uzmMxbN6qhOk0OS0KNqAx2CAiMbnWaF4?=
 =?iso-8859-1?Q?/ZIYLY2+6M?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Nj7lFKUi5r+NUQ9r4A6idHveneppL28h6rAw6vR5LXeSwe8nSX6/Xvih9U?=
 =?iso-8859-1?Q?whZ57DJ+IWh5ogmVqnA70Kb6b1O9I/TZW2l6OPS7rdeUowEjKjdQeal0Fd?=
 =?iso-8859-1?Q?1GjQNV9xTenfJZ5F6LHB/jKCUic4j+1xmCXZnT8dakdLmcFEeAmUAuamRb?=
 =?iso-8859-1?Q?Szob8r6gjeGsXYH+a1gouyuvNNewphMOBIrg9NhdtVwN0WoQ+LdUXLOLGx?=
 =?iso-8859-1?Q?b+60zTtAaE35f0a9bflLU0k+oqAS5FtG6kLqdwePcLeNUrNo4ZhcwqPEMH?=
 =?iso-8859-1?Q?Jl//WqCHUSkPdKNoeqSd/QZDaEsg8J85J4ytrs6/sshXiHnN4qbxOr0jl5?=
 =?iso-8859-1?Q?7/TpBD7YR8N/s7jyeX2U26JXi0j8MdSpUgGkuJVQNRQYQJ8jVEKPV39h0j?=
 =?iso-8859-1?Q?i6Hfdt7jEAFoh+ovGSigkK+5WIbYJ88bC4X6bj2JQpyemRoD5yKqpcdFS1?=
 =?iso-8859-1?Q?RdKX5P3hPOgTydTvcWkm8WnTu3RFkVr8wNM9dJ63rRMFdR0NzCprQn4H7H?=
 =?iso-8859-1?Q?Te1BzCzMpVug0XW0Hk7IKKNlT477GgrwseBQiiWunEJteEnz7ewr92XE/3?=
 =?iso-8859-1?Q?SGIqmEd8o2x6FwW8UoBw2ZiR8/86LR52/t74Q0AvbnbydmgSn2bMkPfeJ0?=
 =?iso-8859-1?Q?YZ/Z6uDOFJQFmA8m2fMyg0GfTKjyLwMy/zUsUloZC1hzPX2WsaE6maijGd?=
 =?iso-8859-1?Q?pI4A6zlYNKaH4HPMge2m9U+zQYEDNvXcNyKHtoaQSzq+cu86eUZhKCjxhL?=
 =?iso-8859-1?Q?HN+EDUxkz1chAnNkHzji9lPl3BB4V2iGv8IwqQk/WwwPCvDDsgjiuzCwMC?=
 =?iso-8859-1?Q?6yPkMkyBaNJqYHW3o9F1k0jKES6Ip0fwMhBc0wQ/BxoR9+esqD5X8KE898?=
 =?iso-8859-1?Q?3KY7ufRMnGft2e0iDexT40yeWr3khHh66vAQhE1j0sjprCE+KhTNkDSLyS?=
 =?iso-8859-1?Q?Arm683BXuNFuJjILEVQl2Vl7hJ6jlfQwyCoZE9HpXdaVIjemTOim2b6TMK?=
 =?iso-8859-1?Q?tyku28K1OGiTh7bEMA9qbAh/NuheOly7STF9JMM7iPr4XoWb77hoVUJCCf?=
 =?iso-8859-1?Q?u9XINNVAlZv8MYjK1vFMEnokUIiYUeAW6ALtbQo8GJjGbmbLeByibV3VNr?=
 =?iso-8859-1?Q?DIO9X8Oixdrb8dRpSDLZInqgtFHRbpSgaDybDBo2opnQEeS04kXUlXFuIJ?=
 =?iso-8859-1?Q?IKZKlCTDWON6klv3mau8SEyX+1IkEdZrL5NQe2yQ9UPsWUyPo1RpTlO2zM?=
 =?iso-8859-1?Q?d1t/ysGURRR9hK7eqNhY26kWLpQHcLofpNLWOBhi2JKC4vIKshZze0cLVG?=
 =?iso-8859-1?Q?AKu3SlV+UwuIm2lOJl0TZXgs6/Y39oo9zwYRUOoddLJ9Ww93oCMzZjIGVs?=
 =?iso-8859-1?Q?bRj5XvlWVfLj53WI78W6jI5WweuxroYbREKIqtz8U2DOagj0qR88Gw9sLl?=
 =?iso-8859-1?Q?DTZQ7jR1rrd8dwBMCrremJaeX/O+zKIgf6AWkCqwAkc/AM8oQzcQnG5vDh?=
 =?iso-8859-1?Q?cCI0C16X28otoXIERwMDDb12V3AFAT0D4ITwqsb+BdFZ9jdyze0t/aElhH?=
 =?iso-8859-1?Q?SagfhkDng7cn5F824xSWMWPU4kIutTQXC7NVK3KJqX5kfhxJVv3swXF+gI?=
 =?iso-8859-1?Q?r3mqpCUyrcliLKx2/6EkTM4GChgTdCJrkMmTiCKSeFAmRy6c1/c1HHdg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b68c149-c24f-425d-c4b0-08dccc1eb121
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 13:45:37.5996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOyBACGV3fBdIZIAXF3KLEZpibm4O0w3K7ZKZNGf9DR/LabaM4obrJeHbl/zUTXIbzmMb6vuglb7jSqBoq6RyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8479
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a -16.4% regression of filebench.sum_operations/s on:


commit: 6c18ca82c3155bea26e0080ffc613e100b99f706 ("smb: client: force dentry revalidation if nohandlecache is set")
git://git.samba.org/sfrench/cifs-2.6.git for-next-next

testcase: filebench
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
parameters:

	disk: 1HDD
	fs: btrfs
	fs2: cifs
	test: webproxy.f
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409032100.5acabffb-oliver.sang@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240903/202409032100.5acabffb-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-12/performance/1HDD/cifs/btrfs/x86_64-rhel-8.3/debian-12-x86_64-20240206.cgz/lkp-icl-2sp6/webproxy.f/filebench

commit: 
  a493f1a10b ("smb: client: fix hang in wait_for_response() for negproto")
  6c18ca82c3 ("smb: client: force dentry revalidation if nohandlecache is set")

a493f1a10b62652c 6c18ca82c3155bea26e0080ffc6 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     34.06            -1.8%      33.45        boot-time.boot
      1.18           +70.6%       2.01        iostat.cpu.system
    128.33 ± 15%     -28.4%      91.83 ± 12%  perf-c2c.DRAM.local
    117016 ±  2%     +19.4%     139662 ±  3%  numa-meminfo.node1.Active(anon)
    125998 ±  4%     +25.9%     158613 ±  5%  numa-meminfo.node1.Shmem
    126046           +17.2%     147675        meminfo.Active(anon)
     70015 ±  2%      -9.4%      63434        meminfo.KernelStack
    163656           +13.7%     186105        meminfo.Shmem
      3.10 ±  5%     +37.7%       4.26 ±  2%  vmstat.procs.r
     15063           +12.7%      16975        vmstat.system.cs
     11960            +3.6%      12391        vmstat.system.in
      0.37            -0.1        0.31        mpstat.cpu.all.iowait%
      1.11            +0.8        1.95        mpstat.cpu.all.sys%
     18.33 ±  4%    +134.5%      43.00 ± 13%  mpstat.max_utilization.seconds
      4.76 ±  3%     +54.2%       7.34 ±  2%  mpstat.max_utilization_pct
    427754 ±  4%     -15.7%     360658 ±  8%  numa-numastat.node0.local_node
     53543 ± 71%    +115.3%     115274 ± 11%  numa-numastat.node0.other_node
    433291 ±  4%     +16.0%     502556 ±  6%  numa-numastat.node1.local_node
     87012 ± 44%     -72.9%      23607 ± 54%  numa-numastat.node1.other_node
    427339 ±  4%     -15.7%     360284 ±  8%  numa-vmstat.node0.numa_local
     53543 ± 71%    +115.3%     115274 ± 11%  numa-vmstat.node0.numa_other
     29247 ±  2%     +19.3%      34891 ±  3%  numa-vmstat.node1.nr_active_anon
     31500 ±  4%     +25.8%      39633 ±  5%  numa-vmstat.node1.nr_shmem
     29247 ±  2%     +19.3%      34891 ±  3%  numa-vmstat.node1.nr_zone_active_anon
    432962 ±  4%     +15.8%     501460 ±  6%  numa-vmstat.node1.numa_local
     87012 ± 44%     -72.9%      23607 ± 54%  numa-vmstat.node1.numa_other
     14.95           -13.6%      12.92        filebench.sum_bytes_mb/s
    261178           -16.4%     218311        filebench.sum_operations
      4352           -16.4%       3638        filebench.sum_operations/s
      1145           -16.4%     957.17        filebench.sum_reads/s
     22.93           +19.6%      27.42        filebench.sum_time_ms/op
    229.17           -16.4%     191.50        filebench.sum_writes/s
    177.33            +4.0%     184.48        filebench.time.elapsed_time
    177.33            +4.0%     184.48        filebench.time.elapsed_time.max
    530197            -8.4%     485534        filebench.time.file_system_outputs
      2085 ±  3%     +85.6%       3871        filebench.time.involuntary_context_switches
     87.67          +108.6%     182.83        filebench.time.percent_of_cpu_this_job_got
    155.38          +117.4%     337.73        filebench.time.system_time
    373095           +40.8%     525150        filebench.time.voluntary_context_switches
      7689 ± 12%    +155.9%      19679 ±  4%  sched_debug.cfs_rq:/.avg_vruntime.avg
    386.01 ± 56%    +834.0%       3605 ± 49%  sched_debug.cfs_rq:/.avg_vruntime.min
      7689 ± 12%    +155.9%      19679 ±  4%  sched_debug.cfs_rq:/.min_vruntime.avg
    386.01 ± 56%    +834.0%       3605 ± 49%  sched_debug.cfs_rq:/.min_vruntime.min
    433.64 ± 19%     -35.8%     278.31 ± 12%  sched_debug.cfs_rq:/.removed.load_avg.max
     86.64 ± 24%     -31.6%      59.25 ± 23%  sched_debug.cfs_rq:/.removed.load_avg.stddev
    227.69 ± 18%     -34.5%     149.18 ± 16%  sched_debug.cfs_rq:/.removed.runnable_avg.max
     37.03 ± 22%     -28.9%      26.34 ± 24%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
    227.53 ± 18%     -34.5%     149.10 ± 17%  sched_debug.cfs_rq:/.removed.util_avg.max
     37.00 ± 22%     -28.9%      26.29 ± 24%  sched_debug.cfs_rq:/.removed.util_avg.stddev
    186314 ± 76%    +108.7%     388769 ±  8%  sched_debug.cpu.avg_idle.min
    300393 ± 81%     -57.8%     126916 ±  9%  sched_debug.cpu.avg_idle.stddev
     10939 ± 19%     +51.8%      16603 ±  6%  sched_debug.cpu.nr_switches.avg
     38505 ± 16%     +52.2%      58598 ± 18%  sched_debug.cpu.nr_switches.max
    492.25 ± 26%    +454.4%       2728 ± 40%  sched_debug.cpu.nr_switches.min
      0.32 ± 19%     -35.5%       0.21 ± 10%  sched_debug.cpu.nr_uninterruptible.avg
     31486           +17.2%      36902        proc-vmstat.nr_active_anon
    252034            -1.7%     247778        proc-vmstat.nr_anon_pages
    144469            -9.1%     131275        proc-vmstat.nr_dirtied
    259096            -1.6%     255042        proc-vmstat.nr_inactive_anon
     27566            +1.5%      27977        proc-vmstat.nr_inactive_file
     69963 ±  2%      -9.4%      63387        proc-vmstat.nr_kernel_stack
     40920           +13.7%      46536        proc-vmstat.nr_shmem
     95280            -1.3%      93995        proc-vmstat.nr_slab_unreclaimable
    116777 ±  2%      -6.6%     109072 ±  3%  proc-vmstat.nr_written
     31486           +17.2%      36902        proc-vmstat.nr_zone_active_anon
    259096            -1.6%     255042        proc-vmstat.nr_zone_inactive_anon
     27566            +1.5%      27977        proc-vmstat.nr_zone_inactive_file
      1021            +3.5%       1057 ±  2%  proc-vmstat.numa_huge_pte_updates
    157598 ±  5%     +22.6%     193263 ±  8%  proc-vmstat.numa_pages_migrated
    666331            +5.0%     699975        proc-vmstat.pgfault
    157598 ±  5%     +22.6%     193263 ±  8%  proc-vmstat.pgmigrate_success
     31631 ±  2%     +10.1%      34822 ±  4%  proc-vmstat.pgreuse
 1.117e+09           +17.5%  1.313e+09        perf-stat.i.branch-instructions
      2.86            -0.0        2.81        perf-stat.i.branch-miss-rate%
  15245638            +4.0%   15859539        perf-stat.i.branch-misses
  56242131            +4.5%   58762772        perf-stat.i.cache-references
     15103           +12.5%      16988        perf-stat.i.context-switches
      1.62           +10.6%       1.80        perf-stat.i.cpi
 6.063e+09           +59.6%  9.679e+09        perf-stat.i.cpu-cycles
    255.96           +13.8%     291.33        perf-stat.i.cpu-migrations
      2441 ±  2%     +34.7%       3289 ±  4%  perf-stat.i.cycles-between-cache-misses
 4.996e+09           +15.7%  5.781e+09        perf-stat.i.instructions
      0.69            -9.0%       0.63        perf-stat.i.ipc
      0.43 ±  4%     -10.8%       0.38 ±  4%  perf-stat.overall.MPKI
      1.36            -0.2        1.21        perf-stat.overall.branch-miss-rate%
      1.21           +38.0%       1.67        perf-stat.overall.cpi
      2853 ±  3%     +54.7%       4414 ±  4%  perf-stat.overall.cycles-between-cache-misses
      0.82           -27.5%       0.60        perf-stat.overall.ipc
 1.112e+09           +17.6%  1.308e+09        perf-stat.ps.branch-instructions
  15163646            +4.0%   15775672        perf-stat.ps.branch-misses
  55997377            +4.5%   58544094        perf-stat.ps.cache-references
     15036           +12.6%      16924        perf-stat.ps.context-switches
 6.038e+09           +59.7%  9.644e+09        perf-stat.ps.cpu-cycles
    254.65           +13.9%     289.98        perf-stat.ps.cpu-migrations
 4.974e+09           +15.8%  5.759e+09        perf-stat.ps.instructions
 8.889e+11           +20.4%   1.07e+12        perf-stat.total.instructions
      0.65 ±  6%      -0.4        0.29 ±100%  perf-profile.calltrace.cycles-pp.sched_ttwu_pending.__flush_smp_call_function_queue.flush_smp_call_function_queue.do_idle.cpu_startup_entry
      1.66 ± 13%      -0.3        1.39 ±  8%  perf-profile.calltrace.cycles-pp.evsel__read_counter.read_counters.process_interval.dispatch_events.cmd_stat
      3.62 ±  7%      +0.4        4.07 ±  2%  perf-profile.calltrace.cycles-pp.tick_nohz_handler.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt
      4.33 ±  6%      +0.6        4.92 ±  5%  perf-profile.calltrace.cycles-pp.__hrtimer_run_queues.hrtimer_interrupt.__sysvec_apic_timer_interrupt.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
      1.50 ± 23%      -0.5        1.00 ± 18%  perf-profile.children.cycles-pp.walk_component
      0.97 ± 27%      -0.4        0.60 ± 19%  perf-profile.children.cycles-pp.__lookup_slow
      1.66 ± 13%      -0.3        1.39 ±  8%  perf-profile.children.cycles-pp.evsel__read_counter
      0.66 ±  4%      -0.2        0.50 ± 25%  perf-profile.children.cycles-pp.sched_ttwu_pending
      0.17 ± 38%      -0.1        0.04 ± 80%  perf-profile.children.cycles-pp.up_read
      0.34 ± 22%      -0.1        0.22 ± 31%  perf-profile.children.cycles-pp.evlist__id2evsel
      0.24 ± 39%      -0.1        0.12 ± 39%  perf-profile.children.cycles-pp.ct_kernel_exit_state
      0.20 ± 46%      -0.1        0.08 ± 75%  perf-profile.children.cycles-pp.copy_page
      0.19 ± 45%      -0.1        0.08 ± 78%  perf-profile.children.cycles-pp.vm_area_dup
      0.14 ± 44%      +0.1        0.28 ± 24%  perf-profile.children.cycles-pp.task_work_run
      0.08 ± 85%      +0.1        0.23 ± 29%  perf-profile.children.cycles-pp.__get_user_8
      0.10 ± 56%      +0.1        0.24 ± 21%  perf-profile.children.cycles-pp.run_timer_softirq
      0.11 ± 90%      +0.2        0.26 ± 54%  perf-profile.children.cycles-pp.rseq_ip_fixup
      0.13 ± 53%      +0.2        0.30 ± 13%  perf-profile.children.cycles-pp.__run_timers
      0.73 ± 15%      +0.2        0.95 ± 11%  perf-profile.children.cycles-pp.dequeue_entity
      0.50 ± 32%      +0.2        0.74 ±  9%  perf-profile.children.cycles-pp.wp_page_copy
      0.81 ± 19%      +0.2        1.06 ± 15%  perf-profile.children.cycles-pp.dequeue_task_fair
      4.04 ±  5%      +0.4        4.39 ±  3%  perf-profile.children.cycles-pp.tick_nohz_handler
      4.76 ±  5%      +0.5        5.28 ±  6%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.19 ± 51%      -0.1        0.07 ± 71%  perf-profile.self.cycles-pp.copy_page
      0.15 ± 24%      -0.1        0.08 ± 25%  perf-profile.self.cycles-pp.do_idle
      0.08 ± 85%      +0.1        0.22 ± 32%  perf-profile.self.cycles-pp.__get_user_8
      0.04 ±  7%     +25.1%       0.05 ±  8%  perf-sched.sch_delay.avg.ms.io_schedule.folio_wait_bit_common.filemap_update_page.filemap_get_pages
      0.05 ±  4%     +83.8%       0.08 ±  3%  perf-sched.sch_delay.avg.ms.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range
      0.03 ± 41%    +150.6%       0.07 ± 39%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.04 ±  9%     +42.9%       0.05 ±  6%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.cifs_call_async
      0.09 ±  2%     -26.7%       0.07 ± 17%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ±  3%    +419.1%       0.10 ±111%  perf-sched.sch_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
      0.04 ± 18%     +69.0%       0.06 ± 18%  perf-sched.sch_delay.avg.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
      0.19 ± 13%    +115.0%       0.42 ± 49%  perf-sched.sch_delay.max.ms.__cond_resched.__kmalloc_noprof.cifs_strndup_to_utf16.cifs_convert_path_to_utf16.smb2_compound_op
      0.61 ± 40%    +206.7%       1.86 ± 36%  perf-sched.sch_delay.max.ms.__cond_resched.dput.cifsFileInfo_put_final._cifsFileInfo_put.process_one_work
      0.32 ± 10%    +342.4%       1.43 ±163%  perf-sched.sch_delay.max.ms.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      0.28 ±  6%    +685.7%       2.16 ±109%  perf-sched.sch_delay.max.ms.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range
      0.21 ± 76%    +132.6%       0.48 ± 44%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.17 ±  9%     +28.1%       0.22 ±  5%  perf-sched.sch_delay.max.ms.schedule_preempt_disabled.kthread.ret_from_fork.ret_from_fork_asm
      0.70 ± 31%    +112.4%       1.49 ± 74%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
     42.95 ±  2%     -20.5%      34.15 ±  2%  perf-sched.total_wait_and_delay.average.ms
    100335           +11.8%     112159        perf-sched.total_wait_and_delay.count.ms
     42.79 ±  2%     -20.6%      33.98 ±  2%  perf-sched.total_wait_time.average.ms
     93.35 ± 12%     -29.6%      65.67 ± 13%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__kmalloc_noprof.cifs_strndup_to_utf16.cifs_convert_path_to_utf16.smb2_compound_op
    206.36 ±  6%     +19.4%     246.43 ±  4%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.cifs_do_create.isra.0
     52.82 ± 19%     -51.7%      25.49 ± 17%  perf-sched.wait_and_delay.avg.ms.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
      0.21 ±  2%     -12.6%       0.18 ±  4%  perf-sched.wait_and_delay.avg.ms.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      0.76           +17.7%       0.89        perf-sched.wait_and_delay.avg.ms.io_schedule.folio_wait_bit_common.filemap_update_page.filemap_get_pages
      0.44 ±  5%     +67.8%       0.73 ±  3%  perf-sched.wait_and_delay.avg.ms.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range
     19.27 ±  2%     +52.6%      29.42 ±  7%  perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
     14.40 ± 11%     +70.0%      24.48 ± 10%  perf-sched.wait_and_delay.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.open_last_lookups
      0.35 ±  2%     -20.0%       0.28 ±  2%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
     20.75           -61.4%       8.02 ±  2%  perf-sched.wait_and_delay.avg.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
      0.42 ±  2%     +11.0%       0.46 ±  3%  perf-sched.wait_and_delay.avg.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_unlink
     22.05 ±  5%     +22.6%      27.04 ±  2%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
     93.17 ±  4%    +117.5%     202.67 ±  7%  perf-sched.wait_and_delay.count.__cond_resched.__kmalloc_noprof.cifs_strndup_to_utf16.cifs_convert_path_to_utf16.smb2_compound_op
     41.67 ± 24%    +144.8%     102.00 ± 14%  perf-sched.wait_and_delay.count.__cond_resched.cancel_work_sync._cifsFileInfo_put.process_one_work.worker_thread
      1458 ±  4%     +86.4%       2718        perf-sched.wait_and_delay.count.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
    282.67 ± 70%    +155.7%     722.67 ±  6%  perf-sched.wait_and_delay.count.__lock_sock.lock_sock_nested.tcp_sendmsg.sock_sendmsg
    703.00 ±  2%     +49.2%       1049 ±  4%  perf-sched.wait_and_delay.count.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
      1280 ±  4%     +52.2%       1948 ±  2%  perf-sched.wait_and_delay.count.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      8403 ±  2%     -22.3%       6525 ±  2%  perf-sched.wait_and_delay.count.futex_wait_queue.__futex_wait.futex_wait.do_futex
      5561           -17.5%       4590        perf-sched.wait_and_delay.count.io_schedule.folio_wait_bit_common.filemap_update_page.filemap_get_pages
      1115           -15.6%     941.67        perf-sched.wait_and_delay.count.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range
      1118           -14.8%     952.83        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
      1111           -16.0%     934.00        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.open_last_lookups
    196.83 ± 22%     +62.2%     319.17 ± 24%  perf-sched.wait_and_delay.count.schedule_timeout.__wait_for_common.wait_for_completion_killable.__kthread_create_on_node
     15475 ±  2%     +19.7%      18526        perf-sched.wait_and_delay.count.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      6670           -17.1%       5528        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_open
      6713           -16.3%       5617        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.cifs_send_recv.__SMB2_close
      1112           -15.6%     939.17        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.cifs_send_recv.query_info
      9037          +139.4%      21632        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
      1116           -15.6%     942.00        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.smb2_compound_op.smb2_unlink
     16955           -11.5%      15012        perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
    253.45 ±  2%     +16.9%     296.20 ±  2%  perf-sched.wait_and_delay.max.ms.__cond_resched.__kmalloc_noprof.cifs_strndup_to_utf16.cifs_convert_path_to_utf16.smb2_compound_op
    251.26 ±  2%     +19.1%     299.18 ±  2%  perf-sched.wait_and_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.cifs_do_create.isra.0
    252.33 ±  2%     +19.8%     302.34 ±  2%  perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
    252.86 ±  2%     +18.1%     298.54 ±  2%  perf-sched.wait_and_delay.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.open_last_lookups
    257.81 ±  2%     +18.5%     305.46 ±  2%  perf-sched.wait_and_delay.max.ms.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_open
    257.83 ±  2%     +18.6%     305.78 ±  2%  perf-sched.wait_and_delay.max.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
     93.27 ± 12%     -29.7%      65.60 ± 13%  perf-sched.wait_time.avg.ms.__cond_resched.__kmalloc_noprof.cifs_strndup_to_utf16.cifs_convert_path_to_utf16.smb2_compound_op
    206.26 ±  6%     +19.4%     246.33 ±  4%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.cifs_do_create.isra.0
     45.44 ±  9%     -49.3%      23.03 ± 17%  perf-sched.wait_time.avg.ms.__lock_sock.lock_sock_nested.tcp_sendmsg.sock_sendmsg
     52.52 ± 19%     -51.6%      25.45 ± 17%  perf-sched.wait_time.avg.ms.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
      0.14 ±  2%     -16.0%       0.12 ±  3%  perf-sched.wait_time.avg.ms.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      0.72           +17.2%       0.84        perf-sched.wait_time.avg.ms.io_schedule.folio_wait_bit_common.filemap_update_page.filemap_get_pages
      0.39 ±  5%     +65.8%       0.65 ±  3%  perf-sched.wait_time.avg.ms.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range
     27.92 ± 20%     -38.2%      17.24 ± 26%  perf-sched.wait_time.avg.ms.kthreadd.ret_from_fork.ret_from_fork_asm
      0.65 ±  6%     +40.2%       0.92        perf-sched.wait_time.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.cifs_call_async
      0.19 ± 45%    +679.3%       1.49 ±139%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.btrfs_tree_read_lock_nested
     19.25 ±  2%     +52.3%      29.32 ±  7%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
     14.32 ± 11%     +70.2%      24.38 ± 11%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.open_last_lookups
      0.27           -24.1%       0.21 ±  2%  perf-sched.wait_time.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
     20.69           -61.5%       7.96 ±  2%  perf-sched.wait_time.avg.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
      0.34 ±  2%     +12.5%       0.38 ±  3%  perf-sched.wait_time.avg.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_unlink
     21.95 ±  5%     +22.1%      26.79 ±  2%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
    253.37 ±  2%     +16.9%     296.11 ±  2%  perf-sched.wait_time.max.ms.__cond_resched.__kmalloc_noprof.cifs_strndup_to_utf16.cifs_convert_path_to_utf16.smb2_compound_op
      1.97 ±  2%     +11.7%       2.20 ±  7%  perf-sched.wait_time.max.ms.__cond_resched.cifs_demultiplex_thread.kthread.ret_from_fork.ret_from_fork_asm
    251.18 ±  2%     +19.1%     299.06 ±  2%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.cifs_do_create.isra.0
      5.19 ± 78%   +2302.7%     124.73 ±144%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_read_slowpath.down_read.btrfs_tree_read_lock_nested
    252.23 ±  2%     +19.8%     302.20 ±  2%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
    252.74 ±  2%     +18.1%     298.41 ±  2%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.open_last_lookups
    669.39 ± 69%     -50.0%     334.44 ±140%  perf-sched.wait_time.max.ms.syscall_exit_to_user_mode.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
    257.71 ±  2%     +18.5%     305.36 ±  2%  perf-sched.wait_time.max.ms.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_open
    257.72 ±  2%     +18.6%     305.67 ±  2%  perf-sched.wait_time.max.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

