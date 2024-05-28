Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E948F48;
	Tue, 28 May 2024 01:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716858908; cv=fail; b=UhTTfD6UfOxCV6tHkcUbjJjis+gipkBGke2cl8VH3ttTcn46BnIwcWmdcKCvVh+NxLJQyBsQhioR/waAQJ2zK6lR32inVF0g9oJJJNlYpB18R39Y7cspPzeGJXUyWh/jT5lyBj4uOEio7/+0Z3cvwxHL/7LyY1pqnwKU5syz328=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716858908; c=relaxed/simple;
	bh=FR7zjDf3tK+t0aVPZ060Xhbk9kEf77jHDTsplUd8jFI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=MDRi+z2IfaWbKq1VUL0WjPJOSuozQDqwp3qbr0Cp34+hmnclKy6e/VEDxp4Gy9ec/1BU+k+hUTfAU3AcVJGtmIxASdahIlcNPVoCdalSUkhPnsVl7LS5yLVCymESsBxHs4DQowhntXAEcDmxG0ANZMRyFJ9s4AuLm1LX7sizJQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HJByLZGp; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HJByLZGp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716858906; x=1748394906;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=FR7zjDf3tK+t0aVPZ060Xhbk9kEf77jHDTsplUd8jFI=;
  b=HJByLZGpX7T3fYsuEfU6so8GVHElwGSpw0zzEtgbB8PUeC0+bOWrhHb9
   5eIXqoMHdYf9cQPxtV3ma6sIvGR16T/ln0pWzPn7mR2dxYjRbjDdll9iZ
   ej2KabvxZkA3dWUv7qt9vfWBPYRLSM4BeL7fw67mr4HObS7ATYVPaIAfI
   2/Ppwer+g2stUOe5V4Gld5jPxd3vTRm5LAMSeZKySXDTpQC5LlB8NwI/k
   sAJnYXW0KyvgXSsAPAzT3NG1AHEzO/2F1+FFwlOfoKdj0HXmWA8PJYqzt
   0GOMsJYy1ElxYCWyUWvsU6RzdDTvF4l2BXkAMFhmdQwNXbwreLMxndHJQ
   Q==;
X-CSE-ConnectionGUID: OnzDUYyARiawL2W8PGkZWw==
X-CSE-MsgGUID: IYRFfSe6QdOI8octJTUVOw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13307060"
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="13307060"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 18:15:05 -0700
X-CSE-ConnectionGUID: GoyAYUyOQDaplSO6wO7JJg==
X-CSE-MsgGUID: NI8oizv2Q22CEci4xErEGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="39882572"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 May 2024 18:15:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 18:15:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 27 May 2024 18:15:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 18:15:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpyBz/7tCW3IZNY1IBJtp6Bi6rkmuGFJgQDMBPsudkbs0+7DMifXOs74g7W2a2gaJTtiLLENSipjQF+WAfAyBaOiru/ddkaJAG6aL2CvJrn2bP7lQ91J45uO1hMCS0m459ccHrTBiMYphm6hni93GI+0GbaGs9skqR/WRfM39WReGk4I+SibmWVz92Wx9tSoGjbXKIZhOOqFl5i31ahZNUda/cQMW48+zd6CXcpcTmRPArYjJ+cjhxJNFfmktDxCcxCsxN8Txlkg+DEcQ3zt8ooRKlyRq7UR5JMZUwe3c+PwwXvYQACzYBAAeiaifnpYH7C6Y2FbPT8DVFgMbNOSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1n1FKwH1zJ65OA0ymh2YZngVs4rJF/+/YwJ1fRyZmx8=;
 b=a1eZzfXPeKQOTVaN5AXjALgvFUE4RTdb90B8to9/M7wQHNv1vxCwWP/AwQcU9JgWlxdMbxV/4fz8ijVeK2wppuS7jPK3edCmOnT3IEgKWaLmI/SHIyYBXcqdquC2emHhK6c1tmLas1n0UYCod2icos1f33bTYD4uL92KYnFdDbB8p9wPq1iSwXJGY1LrNDlS4JbIwjdFn7Z6gufz5CoFs9aGZeS/2mNWk4OY9J/U9IaUSR06mr+Bgf4qPlXnjzAQ+btBuSv9ovztidrS7loCkanodOBgqP+ogGdu3YNMoRr13lrDfxSffs94iRmHVlkszr8pvVIkagGPSVfzFVT4lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW3PR11MB4714.namprd11.prod.outlook.com (2603:10b6:303:5d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 28 May
 2024 01:15:01 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Tue, 28 May 2024
 01:15:01 +0000
Date: Tue, 28 May 2024 09:14:52 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Steve French <stfrench@microsoft.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>, Enzo Matsumiya <ematsumiya@suse.de>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>,
	<oliver.sang@intel.com>
Subject: [linus:master] [smb3]  edfc6481fa:  filebench.sum_operations/s
 4194.8% improvement
Message-ID: <202405271633.b56b258d-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:820:c::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW3PR11MB4714:EE_
X-MS-Office365-Filtering-Correlation-Id: 09aab516-1446-424d-cc2a-08dc7eb39937
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?dakQTbG+XyjnCo1mOShickqcThFuxD9io0YxibqP93yYxhpYU1qQiODXYK?=
 =?iso-8859-1?Q?KY0BaiJJQQKeWeMTwVb1xO3H+lXmTcbXM8A1uT7ajx5Z9BN2rm0yF8uPCT?=
 =?iso-8859-1?Q?OwnNmC2PDtQSCR8+ecyRnVRpnAqQDmC2fURgFmVTy1AG4JdR45S3wReMAy?=
 =?iso-8859-1?Q?pPAN4GF3CxdMuU1bNQCvi2r1Qftsu3JRijoJKSFcyz9R0dM8M3GM1XxNzv?=
 =?iso-8859-1?Q?xgGDCkUHQX8/SalqfE5crP8OqL6jfwoBLLsonu63rNQvEJPebiM93ETbp3?=
 =?iso-8859-1?Q?AXMuO0DLQe7Db3k171pAhFtyzlREfHLFy0f7AJJbvVZne/FEFeg4dCaS3X?=
 =?iso-8859-1?Q?uspyRg//+aD9/RC0xanvoIp1L/Y93iAOwxApakmuWap1pPwK6iPdneMVGG?=
 =?iso-8859-1?Q?lFMIYv3yBgUFJMO2PasyppSETImonPggtapG1MI2XTNvd7KQmW9CvdbtLn?=
 =?iso-8859-1?Q?5zHb8ufU+CLIYR07DofgsRBMVaY3sI1tYzBEi63Yh9EQZeNQUmrS+9w2PS?=
 =?iso-8859-1?Q?65h+ooMO/GgTIqmEOmUpJmXYMzpZe2nWMLeKYI8saa6eDfJ7tHrqYrv8jw?=
 =?iso-8859-1?Q?iMvSvntyqNS/e/HnAPCF1RIZNz5bVm2TlIx0YUwMsrcDeNfKBXmzN0WpTZ?=
 =?iso-8859-1?Q?uNuxEMvTqSKQQyP4GWBDfoCjTRsNH7gChqlqURVSDbavggEQfS+GhqqS9q?=
 =?iso-8859-1?Q?xIicBFUUshjzAKSf8yAsOHf6HNGfdLzKx9RiMNDjeyKx1jg2lG7jyv/QcA?=
 =?iso-8859-1?Q?MAleEM8IgFWhMydkVF79CUjxXWvGHMcGYqabX/Moum7hz+uoSFnz2+Ov/k?=
 =?iso-8859-1?Q?T5vA2nYA2jADV0CJyUHp2wGZNXY+0QYWmsZVc2eQx+ydxOxXU+/cyzmGGB?=
 =?iso-8859-1?Q?dV4ubtr2Ocvd8SCw3ZVRHTIG7h/LM7gA6RAbCdK+aj90iQ0OQvXGbklDwM?=
 =?iso-8859-1?Q?mbcvfTkV6Cdcj7ZSc1Zvtx/VqU3fpfJ5XQUHLR04dJJJ1zkm0OBHSvacyT?=
 =?iso-8859-1?Q?WG9+bQwbawOE3KG0WMmM5ztoIBGZ4I8KAyxCkNBStqnSUsRSByQZiSkiE2?=
 =?iso-8859-1?Q?xOoC2oyADST36xPFyGnyrx4G2O8bhVEfeo5IqUlegofm4aZCnNbNcBGlP4?=
 =?iso-8859-1?Q?bkjvoXtkC5ekhB7lrhisNGEnJWLMioAtc/tVbcaDwscU9gTnzjIthXBuld?=
 =?iso-8859-1?Q?HwZx0JBXT5ng3UL+ZUUxFy9W0yXMNbtXYAkcNmN7Xtr3UP+AFvWXqra4v0?=
 =?iso-8859-1?Q?FXOmSQr6PPgZ95TFUxR03962PYBBBb9vCgXIgUtgg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?NTXtwWxLfDEwf0A3elCZoGXQ29UWlS/H5elihCAu02xf2VDPs7xw2qL8X0?=
 =?iso-8859-1?Q?SGdLxsAqoWDMGCohkV9V1i3bXrqdn2Wo1VCesUoPig4Y4iaktIiiw7d/jP?=
 =?iso-8859-1?Q?PsACBSt5c7Equ5UhQrpvrIawDgFlOt+FWTgBIsGHpTpAUZ3jdTH4Yh01cu?=
 =?iso-8859-1?Q?1S1YeFmO2rFXW04xZvlSr/uTRlndKRzXSAZnSOAOV+Mf7l3HN4ogQX9KeT?=
 =?iso-8859-1?Q?LxkVn+KXg6o69ZE4hcv7kWy4n1kUz/hZZeiTUqO+9Ti4HQe/oeJ7QLeP2s?=
 =?iso-8859-1?Q?fD/ivzBOU1jeq8du7XAKMwF5i7KReJdUDG53UK8teJijxtK9ifP3dc7rr0?=
 =?iso-8859-1?Q?4q7jalbPBThP2rrro4br/1fdRyYV6Sk3wQG5ClIuTd1yUUVD9cPIflcaST?=
 =?iso-8859-1?Q?l5/znrA7cndRK3haaz09pMdo2d8HDnFbNClXQp6L7lqoeFabajBMy+4Dj0?=
 =?iso-8859-1?Q?DhMqSbIubycDfBHJ43NrfJLFlAOkTo4++CWncH3J37tkp27tEMQRG0nU5/?=
 =?iso-8859-1?Q?7bxezns/bn3Jbc1sZ/kpRl4ZQIuiAZvu0QSYuJwTjZDS4tkd8EjCjbFN9r?=
 =?iso-8859-1?Q?wZQggAhhQmEatWtzlU1TaUf9S0bKe3/w6Hxj5wC/oWoGu9xSrbCmaX91gn?=
 =?iso-8859-1?Q?U3lSE4gRmXSpcrngl2bmV/SIiEUJ8spGsCq3JRl6Ek9cHCuXDr2iKrJtr0?=
 =?iso-8859-1?Q?5dASEqDYt8WL+8zTpJE37nBERzOG6iMFQhtvwGEqNxSg9zj6fWPZ55Hcqn?=
 =?iso-8859-1?Q?fq+Q1/ncfjwHRgD8YejrRTO7bQOW7uCI31FnZuz87SJZMPBPAIL9tGhnyL?=
 =?iso-8859-1?Q?yMvrC/NoFVbetFqVpobyo6MUhQ1eqYWibZcNZmkGgz3jjaVZYaqEfvTTZu?=
 =?iso-8859-1?Q?m/RvxErHs6uHuU4FNehjBKR2E4VT777BRzK/spTfRek200heQIgx2WoOQP?=
 =?iso-8859-1?Q?zaT84ih3Ya6h36bqc0fbV4QNKIyR/JlWndsp3v2hxm6fauCOUM+W+Kqdn6?=
 =?iso-8859-1?Q?dpdpzzZcgajXJ7NVImPzF6B/zVOxKyRbtYv4iUGRGYkwbBW/HqMd6Sp41j?=
 =?iso-8859-1?Q?qNggkMMiZML4IXW5dADj5AeqTXsfny+6NAm4Zd+juu9ZcVWn5bmBdC1jRr?=
 =?iso-8859-1?Q?Rr4QC1VMBbnC5LsjL/gEGl0Wicm6tIFbH/39/Ss/QZ7Z8/ilNKTHC0oVzX?=
 =?iso-8859-1?Q?g4t1v+m4+zVjFlgjZaKXSuIz1cBfBHCvKTOTZg304CJEV8a5FgTnTLU6to?=
 =?iso-8859-1?Q?q00fYf1j4LNMSGBqHXCjjJcrO6LFq3c6SiUixNWhU+U5wvGEylrD6aJMl4?=
 =?iso-8859-1?Q?4EryRsfi9OqQryES+zTjICU81OO180WbVkLql0eELMzlsKSgK+A2YbQBNv?=
 =?iso-8859-1?Q?du1EOpYgB8zPDT6LUsgBeQeKmo+1ius8xW9GwcmlhDh7av/SJKp1EQHBY9?=
 =?iso-8859-1?Q?Y4Ko3qpV8ylA+xpVMMaWUfC9KpWgdn2Qu5lSh442agl6w5Xbhg/J2RCAlY?=
 =?iso-8859-1?Q?ku9Ejk3YvY9vmpC88nqtYBYKmMdik6IN6mtu6m7gisDdBDwACXEHHhR8eF?=
 =?iso-8859-1?Q?ruseji3bYdX230ecFZ1JiHw0RgpIwtzFzEByD/EShIhFmXXurFCTuwvBJB?=
 =?iso-8859-1?Q?tPDdY1S1K81cPQVeibRi8HqdJ0Z+Xm9wolfcWbpDZkdXZywS0F7Fa0XA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09aab516-1446-424d-cc2a-08dc7eb39937
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 01:15:01.7637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Qfdl7EFtVw5aFsESMBhqmHOF7zUgFl4iwMbbRoIfoXTi+tZYACiwmaNGQmeQc8ytV/GKcvkAbH/lNK3yVJLsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4714
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 4194.8% improvement of filebench.sum_operations/s on:


commit: edfc6481faf896301cab940da776229fe39e9fc9 ("smb3: fix perf regression with cached writes with netfs conversion")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: filebench
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
parameters:

	disk: 1HDD
	fs: ext4
	fs2: cifs
	test: randomwrite.f
	cpufreq_governor: performance






Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240527/202405271633.b56b258d-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-13/performance/1HDD/cifs/ext4/x86_64-rhel-8.3/debian-12-x86_64-20240206.cgz/lkp-icl-2sp6/randomwrite.f/filebench

commit: 
  14b1cd2534 ("cifs: Fix locking in cifs_strict_readv()")
  edfc6481fa ("smb3: fix perf regression with cached writes with netfs conversion")

14b1cd25346b1d61 edfc6481faf896301cab940da77 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   3814731 ± 93%     -62.9%    1414791 ± 44%  cpuidle..usage
     91.23 ±  4%      +6.5%      97.17        iostat.cpu.idle
      1817 ± 25%     -49.1%     925.83 ± 36%  perf-c2c.DRAM.remote
    207192          +418.2%    1073659 ± 20%  meminfo.AnonHugePages
   2604959 ±  5%     +65.7%    4315389 ±  4%  meminfo.Dirty
     69239 ±139%    +547.1%     448063 ± 51%  numa-meminfo.node0.AnonHugePages
    138049 ± 70%    +353.2%     625629 ± 65%  numa-meminfo.node1.AnonHugePages
     33.79 ±139%    +547.7%     218.82 ± 51%  numa-vmstat.node0.nr_anon_transparent_hugepages
     67.47 ± 70%    +353.0%     305.60 ± 65%  numa-vmstat.node1.nr_anon_transparent_hugepages
     10799 ± 25%     -35.4%       6972 ±  8%  sched_debug.cfs_rq:/.load.avg
     37988 ±120%    +526.0%     237792 ± 59%  sched_debug.cpu.avg_idle.min
      4690 ±153%     -92.0%     376.83 ± 24%  sched_debug.cpu.nr_switches.min
     69222 ±  3%     -16.7%      57628        vmstat.io.bo
      0.73 ± 12%     -24.9%       0.55 ±  2%  vmstat.procs.b
     19540 ± 24%     -55.2%       8762 ± 12%  vmstat.system.in
      0.58 ± 14%      -0.2        0.41        mpstat.cpu.all.iowait%
      0.05 ± 32%      -0.0        0.02 ± 14%  mpstat.cpu.all.irq%
      0.05 ± 14%      -0.0        0.02 ±  6%  mpstat.cpu.all.soft%
      2.00         +2391.7%      49.83 ± 27%  mpstat.max_utilization.seconds
     58.54 ±  7%     -24.5%      44.17 ± 13%  mpstat.max_utilization_pct
     99.67 ±163%   +4194.7%       4280 ±  7%  filebench.sum_bytes_mb/s
    765489 ±163%   +4194.8%   32875866 ±  7%  filebench.sum_operations
     12757 ±163%   +4194.8%     547887 ±  7%  filebench.sum_operations/s
      0.24 ± 41%     -99.2%       0.00        filebench.sum_time_ms/op
     12757 ±163%   +4194.8%     547887 ±  7%  filebench.sum_writes/s
    241.17 ± 80%    +321.8%       1017 ±  8%  filebench.time.involuntary_context_switches
     22.67 ± 23%     +63.2%      37.00        filebench.time.percent_of_cpu_this_job_got
     37.73 ± 23%     +49.1%      56.25        filebench.time.system_time
 1.997e+09 ± 45%     -62.3%  7.533e+08 ± 26%  perf-stat.i.branch-instructions
     11.93 ± 23%      +3.9       15.84 ±  7%  perf-stat.i.cache-miss-rate%
 1.589e+08 ±  5%     -36.2%  1.013e+08 ±  6%  perf-stat.i.cache-references
      1227 ± 13%     -23.7%     937.19 ±  7%  perf-stat.i.cycles-between-cache-misses
  9.86e+09 ± 45%     -63.3%  3.621e+09 ± 27%  perf-stat.i.instructions
      4.84 ± 44%     +96.1%       9.48 ± 18%  perf-stat.overall.MPKI
    830.79 ± 40%     -62.4%     312.02 ± 34%  perf-stat.overall.cycles-between-cache-misses
 1.994e+09 ± 45%     -62.2%  7.528e+08 ± 27%  perf-stat.ps.branch-instructions
 1.585e+08 ±  5%     -36.3%   1.01e+08 ±  6%  perf-stat.ps.cache-references
 9.842e+09 ± 45%     -63.2%   3.62e+09 ± 27%  perf-stat.ps.instructions
 1.637e+12 ± 45%     -62.9%  6.073e+11 ± 27%  perf-stat.total.instructions
    101.22          +418.0%     524.27 ± 20%  proc-vmstat.nr_anon_transparent_hugepages
   2918550 ±  3%    +421.9%   15232014 ±  9%  proc-vmstat.nr_dirtied
    650592 ±  5%     +66.0%    1079880 ±  4%  proc-vmstat.nr_dirty
     23980            -2.1%      23472        proc-vmstat.nr_kernel_stack
     17286 ±  6%      -5.1%      16397        proc-vmstat.nr_mapped
     79441            -2.5%      77426        proc-vmstat.nr_slab_unreclaimable
    662082 ±  6%     +66.5%    1102087 ±  5%  proc-vmstat.nr_zone_write_pending
   8719968 ± 21%     -48.5%    4491902 ± 10%  proc-vmstat.numa_hit
      8.00 ± 20%  +12912.5%       1041 ± 45%  proc-vmstat.numa_huge_pte_updates
   8584943 ± 21%     -49.2%    4359325 ± 10%  proc-vmstat.numa_local
  11674686 ±  3%     -16.0%    9806002        proc-vmstat.pgpgout
      2.00        +51250.0%       1027 ± 56%  proc-vmstat.thp_fault_alloc
      4.19 ±100%      -1.7        2.53 ±144%  perf-profile.calltrace.cycles-pp.scsi_end_request.scsi_io_completion.blk_complete_reqs.handle_softirqs.irq_exit_rcu
      4.19 ±100%      -1.7        2.53 ±144%  perf-profile.calltrace.cycles-pp.scsi_io_completion.blk_complete_reqs.handle_softirqs.irq_exit_rcu.common_interrupt
      4.24 ±100%      -1.7        2.58 ±145%  perf-profile.calltrace.cycles-pp.irq_exit_rcu.common_interrupt.asm_common_interrupt.cpuidle_enter_state.cpuidle_enter
      4.23 ±100%      -1.6        2.58 ±145%  perf-profile.calltrace.cycles-pp.handle_softirqs.irq_exit_rcu.common_interrupt.asm_common_interrupt.cpuidle_enter_state
      4.20 ±100%      -1.6        2.57 ±145%  perf-profile.calltrace.cycles-pp.blk_complete_reqs.handle_softirqs.irq_exit_rcu.common_interrupt.asm_common_interrupt
      0.50 ± 46%      +0.3        0.78 ±  5%  perf-profile.calltrace.cycles-pp.write
      0.28 ±100%      +0.4        0.67 ±  6%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      0.31 ±100%      +0.4        0.71 ±  8%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      0.31 ±100%      +0.4        0.71 ±  8%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.write
      0.19 ±141%      +0.5        0.64 ±  6%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.write
      2.50 ± 14%      +0.5        3.04 ±  8%  perf-profile.calltrace.cycles-pp.read
      2.66 ± 14%      +0.6        3.28 ±  9%  perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.33 ± 11%      +0.6        2.98 ± 14%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      2.33 ± 11%      +0.7        3.00 ± 14%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
      0.22 ± 20%      -0.2        0.06 ± 83%  perf-profile.children.cycles-pp.native_apic_mem_eoi
      0.23 ± 11%      -0.1        0.15 ± 24%  perf-profile.children.cycles-pp.getenv
      0.03 ±141%      +0.1        0.10 ± 29%  perf-profile.children.cycles-pp.set_task_cpu
      0.01 ±223%      +0.1        0.08 ± 37%  perf-profile.children.cycles-pp.__radix_tree_lookup
      0.00            +0.1        0.10 ± 43%  perf-profile.children.cycles-pp.kmalloc_trace
      0.01 ±223%      +0.1        0.12 ± 37%  perf-profile.children.cycles-pp.free_pcppages_bulk
      0.16 ± 33%      +0.1        0.29 ± 29%  perf-profile.children.cycles-pp.vm_area_alloc
      0.10 ± 79%      +0.1        0.24 ± 26%  perf-profile.children.cycles-pp.leave_mm
      0.24 ± 19%      +0.2        0.41 ± 36%  perf-profile.children.cycles-pp.strnlen_user
      0.41 ± 22%      +0.2        0.58 ± 19%  perf-profile.children.cycles-pp.migration_cpu_stop
      0.68 ± 12%      +0.2        0.86 ±  6%  perf-profile.children.cycles-pp.ksys_write
      0.65 ± 15%      +0.2        0.84 ±  6%  perf-profile.children.cycles-pp.vfs_write
      0.41 ± 22%      +0.2        0.62 ± 19%  perf-profile.children.cycles-pp.cpu_stopper_thread
      0.79 ± 10%      +0.2        1.00 ±  3%  perf-profile.children.cycles-pp.write
      0.47 ± 28%      +0.2        0.70 ± 23%  perf-profile.children.cycles-pp.syscall_exit_to_user_mode
      0.24 ± 35%      +0.2        0.47 ± 20%  perf-profile.children.cycles-pp.set_pte_range
      0.43 ± 28%      +0.2        0.67 ± 25%  perf-profile.children.cycles-pp.d_alloc_parallel
      0.58 ± 23%      +0.3        0.87 ± 21%  perf-profile.children.cycles-pp.__lookup_slow
      0.98 ± 22%      +0.3        1.27 ± 13%  perf-profile.children.cycles-pp.copy_process
      1.39 ±  9%      +0.3        1.74 ± 13%  perf-profile.children.cycles-pp.filemap_map_pages
      1.49 ±  9%      +0.4        1.91 ± 11%  perf-profile.children.cycles-pp.do_read_fault
      1.75 ± 10%      +0.5        2.26 ±  8%  perf-profile.children.cycles-pp.do_fault
      2.66 ± 14%      +0.6        3.28 ±  9%  perf-profile.children.cycles-pp.smpboot_thread_fn
      3.94 ± 16%      +0.7        4.62 ±  8%  perf-profile.children.cycles-pp.read
      4.09 ±  4%      +0.8        4.93 ±  8%  perf-profile.children.cycles-pp.asm_exc_page_fault
      3.08 ± 10%      +0.9        3.96 ±  8%  perf-profile.children.cycles-pp.__handle_mm_fault
      3.22 ±  8%      +1.0        4.18 ±  8%  perf-profile.children.cycles-pp.handle_mm_fault
      3.44 ±  6%      +1.0        4.47 ±  9%  perf-profile.children.cycles-pp.do_user_addr_fault
      3.45 ±  5%      +1.0        4.48 ±  9%  perf-profile.children.cycles-pp.exc_page_fault
     20.31 ±  9%      +2.6       22.93 ±  6%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     20.26 ±  9%      +2.6       22.88 ±  6%  perf-profile.children.cycles-pp.do_syscall_64
      0.21 ± 20%      -0.2        0.06 ± 83%  perf-profile.self.cycles-pp.native_apic_mem_eoi
      0.12 ± 30%      +0.1        0.18 ± 19%  perf-profile.self.cycles-pp.newidle_balance
      0.01 ±223%      +0.1        0.08 ± 37%  perf-profile.self.cycles-pp.__radix_tree_lookup
      0.00            +0.1        0.09 ± 39%  perf-profile.self.cycles-pp.kmalloc_trace
      0.05 ±111%      +0.1        0.17 ± 36%  perf-profile.self.cycles-pp.leave_mm
      0.23 ± 23%      +0.2        0.39 ± 40%  perf-profile.self.cycles-pp.strnlen_user
      0.10 ± 53%      +0.2        0.30 ± 59%  perf-profile.self.cycles-pp.read_counters




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

