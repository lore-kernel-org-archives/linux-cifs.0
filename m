Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768063CFF46;
	Sun, 23 Aug 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787487819; cv=fail; b=rUwpdQ3kQBkN/nlhAtxGUwGU1hcrwHlG13G9u6PSzrTYJnaoPm77qqqEm05VA4d1YUX63HSHSxV/aZluLKMGj8Ewql8yWo9IqEVIJtHMbB9U5TNvqQutX5irzhszXsm/RJavqvceQR8o/ZASMIRTm4vebH+ZLk7Ga53Kym/Tx88=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787487819; c=relaxed/simple;
	bh=fyDQ+AfePCA8dstnrlTJ8YuxqlELQwUZsIZlJmKfZE0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SuRdODsrdRaBSc//Y2tDrnt72/xws9t8Y8GcQsRYQBTzZZCBsn3NGeT1kE/YfWe4v1L/mD6mPFTri8+mlgaEFo2kv3fpftjQsWeZ6JR+7MYcPUx2oeNZsJ4Q+m1n1hm7CCEPggW0idIdh1jv2fsPWwfkjxk7sR56KRVivNFgnEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XkzD3VhM; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XkzD3VhM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787487817; x=1819023817;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=fyDQ+AfePCA8dstnrlTJ8YuxqlELQwUZsIZlJmKfZE0=;
  b=XkzD3VhMPSy7ST/QghzmsX6N4eWWf3NrzAAoYYW/dFke6KGmvfML0Jz8
   lvetPvagPp7DPHK5W/cSoKlWEHQ2RuDquNlai7LB6OB5l9SD7sMDKUtzq
   nsQvQkozHx2Z0UrshkvL17UMvrX2y957nM0fyOuqpchm6ZLbTzgO2MoaL
   UNhbKsyRz50fZTSbyaUTyeMXp4mQwBbHzpTLjQb5UJOL895zrs304xTgM
   mHrVTYDE6Af0NgdCcyUgHOmWYL6QzpNgRUmkwp7tMU44vH6jlRY7d6B7o
   Jh2HDvzkWDfojyp0Z+JKDDdzsTFuI270sJ7rZiPBKZC38CFdeEzAykxc+
   g==;
X-CSE-ConnectionGUID: nHA6E1QsSJ+NpHuAw2QjjA==
X-CSE-MsgGUID: qc2k1Ly+Txy2F5MF8xNLEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="87974658"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="87974658"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:23:37 -0700
X-CSE-ConnectionGUID: 93jiBLguSn2A2XGxCISpUA==
X-CSE-MsgGUID: 4Jbp4cb5Q6mFmwXDdjjBFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="264992863"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:23:37 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:23:36 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 05:23:36 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.51) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:23:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xANbD3u9j164krKsHiP/NsoT/TxagAaE9DEUgMHdIbTFFlZm7IwP5MfdFpgQl9N8dCRLg6xSv+YPGzsr4CgXpt/rOos2eJ32omVYEnDUDAC9ibCbTKzlT6zrDWoD/9vq/31TJ6aKg3z3P6lc/5+4JNOFqLAzr8D3mKZRBco6SvVlTf9KJYIKWxkKn3BUZm8Ts29/231Q1Crit7JG7RKR4lCVcgmVOw+S9PmJaGUS5RZhQw4/0yIgUTAMGFDejHK6DRSVwSiFSuJWs6i+v7P+hJVNGg6gqdOWgBaBIFbcbkxfeDiiKS1nPhMixKw6kzy6iwBde9XfCOD0xqGYpjLt2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1jycrBpxe9CSgbERJy3fn2cTGpI7GXtt17OfsXlnUE=;
 b=ANsTzbbbD1MNMEqAw+5KzC+gMJVxGmSESGkoBWdUrgPKuuCUqRpPnsxfWXa+rbGJFLf6PPCSPh4Nf+fGPpuN5RYsyQgLgPbFZZFJmctY3r6k0V+GCu0szyjyUdSm4oF/Ko/MmnODrWlXgj2aROYPQc3wLYiX67scUlVJruPkWhs4d6Jmdwn7oQzYVKlzi+oyy7meVnCAspw07XU6Gp0J0Bieh+GKo85XDCg+CH3DRZzM0plHpFnYZ/yozctwccBDzx6OD1S/mRgO+cKVOrx7UO84JU07+S6cx4NgLcExLN/En2N6pawtJeZgzkLhiDN5NtsIB1lp3FSbeSsb567MQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by MW4PR11MB7053.namprd11.prod.outlook.com (2603:10b6:303:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 12:23:31 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 12:23:31 +0000
Date: Sun, 23 Aug 2026 20:23:23 +0800
From: kernel test robot <lkp@intel.com>
To: Frank Sorenson <sorenson@redhat.com>, <linux-cifs@vger.kernel.org>
CC: <oe-kbuild-all@lists.linux.dev>, <pc@manguebit.org>,
	<linkinjeon@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] cifs: fix i_size inconsistency in
 smb2_duplicate_extents() on FSCTL failure
Message-ID: <202608230427.RQarhMR6-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260820211443.1472310-1-sorenson@redhat.com>
X-ClientProxiedBy: TP0P295CA0033.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::14) To SJ0PR11MB5214.namprd11.prod.outlook.com
 (2603:10b6:a03:2df::22)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5214:EE_|MW4PR11MB7053:EE_
X-MS-Office365-Filtering-Correlation-Id: d7d80f04-7b5e-4d50-b60d-08df011157fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info: jTVuqJ33cKW52uPdzU4rQmtUmenPQ548V/CqW/Lp1ko8q6w7ojEfoVeVC4H9SstsaxI1aOKsMFJADiH5i7aDe8lYhjPNyEwdIPGR//1JorZfJ8Q9zLimQQVN+SuvbD/+I44viWHTZ30ORJymVFwviKlkqjFLe6DDwk16Z5pIIikcRAvc0CZRQBx7LyNghUjGs1nhLhWuq79Nr5kguVu9Ji4VOGZXTczLa7Cn4dRCnS+Bpel5LyHokLt0DI3/i4jzuDsgavxehEkBnwxw9WSZwRvsGZS0AhTeQ2kwrEyyGiw302vxoDQuThTA0OhN/iT7gLZZrnKNvYF4P987liWQQ+k+ygNSB+VulFCbtLmUDodNhFqAxsRoupYhlnevJr/h8ip3NfMzf/61b9vpdUs782h6slZL5SJPhejdlCLhe8lAAag5a9e9bJErnceyke/6ME6k5T9RFrqb2feIOoJ/2E4d4/ItTq/uusVg71cZ5au+RwB4+s6ku6zgw6qOTpMo0A7zK7on9k6moYnYiYExociN3oCsKny4ldiJK3YPJtsHbQEi0J5dYBiuufTXymWD8hAK04yQjkfkTZ/rwyAlTDbN5gDuZfchbm5mlBYoz1Y9R4s/UX/pdGJKUHeZeQae
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o4hsFPVhhh47+erp0pMaCW0c1DTpY41lHyHyJAq5J3mBqxl8UvLC0HSOXaL8?=
 =?us-ascii?Q?RzyQaYY8fPuI7ntIIDL3owPZa5M9NVZtY17ah1O585TgwW6wkU5InFSebODt?=
 =?us-ascii?Q?sD1QYAjvyHt1x3AhS/mj2Kk3rbE50or2vM/2YjL6jMwi0MlHtbyipiTO3wO/?=
 =?us-ascii?Q?ITmxzm1nl9cL9Gca+LP2e7yGzrEGY+X2ADt/Q08Aha6+KBBWwhOXfGQAODjo?=
 =?us-ascii?Q?4tK1ovJ6Cjc/uKVXu7wYeFPiUwNRakbXFuXC1Pql8wwICr2JxPNSKy4eFEOO?=
 =?us-ascii?Q?C3T7cN9nf7CB2YHAOl9MKV7CumMu44HLDBZ+WMkWC1LHHMFSt1inX4XPZHoE?=
 =?us-ascii?Q?8kmMisKxTE7ZL/P6es3NwyE1j16M2IX4LFgkfBxpAcQU6z6y+u+J/o+9vv6H?=
 =?us-ascii?Q?xO6o3triQTMDwDPmfzTwUwDj9Z7vemoEHef17n/v06P4ujWM69Mgve7JwjkG?=
 =?us-ascii?Q?mq4qX7UW2yTRH0Z5Rs9GcDHXG+STLLGCKcTxW6WziZca2qTWHVACLsL6ngPq?=
 =?us-ascii?Q?yHZO3f8OYbT+ixYMcsfMTyC9BKWrajRy5rXiN7//zhu7+/Ksb6N6XVVobmmp?=
 =?us-ascii?Q?LFQslOkdOeNDyBiUarB4HtRyQgZjiqGNwLSLt8pl75avQb/CFpT72a4Ub8si?=
 =?us-ascii?Q?yqUsqOmTLDvydEJzlzo2tkTE/q7RAFqLj/umeX/W9cK9H9Gl+EQB0tPoNVHG?=
 =?us-ascii?Q?Cg0o5kykURxmSjHGm3eIJlURA37NMYejmDRdDe/qE/8NxLud+yBG6/Zv/tM5?=
 =?us-ascii?Q?jhO4c1sEYkPCMs2+Mq5sDo4UrQE95oxK7cSg1H1Moia1P2kpe+BtI8jLaAhF?=
 =?us-ascii?Q?WfFdUYaRJjkuyx4JfpL7Ai22/eJz2XtqVVqBbKbU7uJkdDiP091qLgcYMdUZ?=
 =?us-ascii?Q?jky99kfYnSxtobeL7N1R5LglvmU6IaosIHyFkXBE0ecusSFMEH2gk1zcmEHw?=
 =?us-ascii?Q?1KzP756ZhHbQoUiuT2+HnGIlog4fj5vFJma+cspH4TpO2JtcJKmCzkv2yGVw?=
 =?us-ascii?Q?NY1/RUrEIPDRsqcBAd5zHrRI4tltNb1L636pEb3B2SoRKHZ8Sq2RA2Bfe4KW?=
 =?us-ascii?Q?NOdakrEcVVNSYHU9oOtN7eJTst/9IgnZ78Ok3yc4UpZpzAGP6I0usit/+mv2?=
 =?us-ascii?Q?kqSMhr4bWX61pggaTGTFd1lbuCtHFUsPzbntxx4UIfr6CTM2pVBNpA5uzdts?=
 =?us-ascii?Q?rsU6etswmRF0qB7zNUbmpil9uCVm44NWBIP7qijrDQDo62TbSxiymU+I4rNR?=
 =?us-ascii?Q?VCPM1GVzeoqwOtB5BtEKUWXCJoZmEAHJ9RVLqhVhfKcME36JVCtY6kKOibkU?=
 =?us-ascii?Q?qYumMJYLcCmLMMdXEmvjGck9ttULPpDTg9uQyslS2fGYFpgiTOkW4AP5dhj7?=
 =?us-ascii?Q?PgjF2yEzg9jmUUn6bgyw8mtxhazo/WCsHY2Sl49sRuv9eu2R4Ym+KDI9cZak?=
 =?us-ascii?Q?GIrnleEBjWcScNiKTpVr3Fh45OqNleYUXDEvBsFtVVXnv4UxevzC1uUVIbwf?=
 =?us-ascii?Q?uUOAw/BV4oEpMhDvXOVXUZW7i5Y4dPC9waaKhP+A1jbuiwWx0u062vbBa0cq?=
 =?us-ascii?Q?3m979/f0AuWjL+VEBIY9RtmBNg2gqwOLN89dfdTf+TY/7vOe3H2ABBBFRFdq?=
 =?us-ascii?Q?xnykCBTMIHAcOXZjTKwWERvtSZrZVXNSm3i/Xv3DjCboHBXEUXTKl6sZbX/1?=
 =?us-ascii?Q?fOp2wovYjgMs6Q00zzE4Qhwt6hiVmnmumWsIgelpc0tg1/YGLbWvt3Itcsw5?=
 =?us-ascii?Q?FJNOKbfL9w=3D=3D?=
X-Exchange-RoutingPolicyChecked: J/l2z2pZ/MgUuhS/XJQEGj0Fb02ZnFT4VDlMaEcBu6f9QIoFSyiBWv/4XgHzfsUUPVDNpylFKN/k7eZ7hbV7EHKMiXLaxI64JgOktMR2Ho1yqOIKjlRJVj0EdRxjusLc2gtsKB0D9OjKPltmLco9IwXJHI2JEab3zaqP/RB9+hYqhLU0bJcUc7F4o34awDrLWj4wrbzymEeHyrh4yojBjkNbSE0u/BG71lkijLmcdtxXZU7RYDd3xh7+DwQge+CZyaDDCUSHZRFhZSv8yb+OfI5WFBUq9itDaJm6gROvsQqECMpc5tz8JFm+gxhmYyaJVM4FRCuS3v9o5nYk6Fz9PQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d7d80f04-7b5e-4d50-b60d-08df011157fe
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 12:23:31.4291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvlOnVdaNvZkDaoao2zt+zfUVXmnbTG3Qa8sxD3ysF5wE4z9GGbgytaNOFO57mvO8zi30lindH1AOFWsetPCNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7053
X-OriginatorOrg: intel.com

Hi Frank,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on cifs/for-next linus/master v7.2 next-20260821]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Frank-Sorenson/cifs-fix-i_size-inconsistency-in-smb2_duplicate_extents-on-FSCTL-failure/20260820-161443
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20260820211443.1472310-1-sorenson%40redhat.com
patch subject: [PATCH] cifs: fix i_size inconsistency in smb2_duplicate_extents() on FSCTL failure
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20260823/202608230427.RQarhMR6-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260823/202608230427.RQarhMR6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608230427.RQarhMR6-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/smb/client/smb2ops.c: In function 'smb2_duplicate_extents':
>> fs/smb/client/smb2ops.c:2251:25: error: implicit declaration of function 'cifs_resize_file_locked' [-Wimplicit-function-declaration]
    2251 |                         cifs_resize_file_locked(inode, orig_size);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~


vim +/cifs_resize_file_locked +2251 fs/smb/client/smb2ops.c

  2188	
  2189	static int
  2190	smb2_duplicate_extents(const unsigned int xid,
  2191				struct cifsFileInfo *srcfile,
  2192				struct cifsFileInfo *trgtfile, u64 src_off,
  2193				u64 len, u64 dest_off)
  2194	{
  2195		int rc;
  2196		int qrc;
  2197		unsigned int ret_data_len;
  2198		struct inode *inode;
  2199		struct smb2_file_all_info file_inf;
  2200		struct duplicate_extents_to_file dup_ext_buf;
  2201		struct timespec64 ts;
  2202		struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
  2203		loff_t orig_size;
  2204		u64 asize;
  2205	
  2206		/* server fileays advertise duplicate extent support with this flag */
  2207		if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
  2208		     FILE_SUPPORTS_BLOCK_REFCOUNTING) == 0)
  2209			return -EOPNOTSUPP;
  2210	
  2211		dup_ext_buf.VolatileFileHandle = srcfile->fid.volatile_fid;
  2212		dup_ext_buf.PersistentFileHandle = srcfile->fid.persistent_fid;
  2213		dup_ext_buf.SourceFileOffset = cpu_to_le64(src_off);
  2214		dup_ext_buf.TargetFileOffset = cpu_to_le64(dest_off);
  2215		dup_ext_buf.ByteCount = cpu_to_le64(len);
  2216		cifs_dbg(FYI, "Duplicate extents: src off %lld dst off %lld len %lld\n",
  2217			src_off, dest_off, len);
  2218		trace_smb3_clone_enter(xid, srcfile->fid.volatile_fid,
  2219				       trgtfile->fid.volatile_fid, tcon->tid,
  2220				       tcon->ses->Suid, src_off, dest_off, len);
  2221		inode = d_inode(trgtfile->dentry);
  2222		orig_size = i_size_read(inode);
  2223		if (orig_size < dest_off + len) {
  2224			rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
  2225			if (rc)
  2226				goto duplicate_extents_out;
  2227			netfs_resize_file(netfs_inode(inode), dest_off + len, true);
  2228			cifs_setsize(inode, dest_off + len);
  2229		}
  2230		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
  2231				trgtfile->fid.volatile_fid,
  2232				FSCTL_DUPLICATE_EXTENTS_TO_FILE,
  2233				(char *)&dup_ext_buf,
  2234				sizeof(struct duplicate_extents_to_file),
  2235				CIFSMaxBufSize, NULL,
  2236				&ret_data_len);
  2237	
  2238		if (ret_data_len > 0)
  2239			cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
  2240	
  2241		if (rc && i_size_read(inode) > orig_size) {
  2242			int rrc;
  2243	
  2244			/*
  2245			 * FSCTL failed after we pre-extended the file.  Attempt to
  2246			 * restore the original size so the caller sees a consistent
  2247			 * file rather than a larger file with uncloned content.
  2248			 */
  2249			rrc = smb2_set_file_size(xid, tcon, trgtfile, orig_size, false);
  2250			if (rrc == 0)
> 2251				cifs_resize_file_locked(inode, orig_size);
  2252			else {
  2253				CIFS_I(inode)->time = 0; /* force reval */
  2254				cifs_invalidate_cache(inode, 0);
  2255			}
  2256		}
  2257	
  2258		if (rc == 0) {
  2259			qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
  2260					      trgtfile->fid.volatile_fid, &file_inf);
  2261			spin_lock(&inode->i_lock);
  2262			if (qrc == 0) {
  2263				asize = le64_to_cpu(file_inf.AllocationSize);
  2264				CIFS_I(inode)->time = jiffies;
  2265				if (file_inf.LastWriteTime) {
  2266					ts = cifs_NTtimeToUnix(file_inf.LastWriteTime);
  2267					inode_set_mtime_to_ts(inode, ts);
  2268				}
  2269				if (file_inf.ChangeTime) {
  2270					ts = cifs_NTtimeToUnix(file_inf.ChangeTime);
  2271					inode_set_ctime_to_ts(inode, ts);
  2272				}
  2273				if (file_inf.LastAccessTime) {
  2274					ts = cifs_NTtimeToUnix(file_inf.LastAccessTime);
  2275					inode_set_atime_to_ts(inode, ts);
  2276				}
  2277				inode->i_blocks = CIFS_INO_BLOCKS(asize);
  2278			} else {
  2279				CIFS_I(inode)->time = 0; /* force reval */
  2280			}
  2281			spin_unlock(&inode->i_lock);
  2282		}
  2283	
  2284	duplicate_extents_out:
  2285		if (rc)
  2286			trace_smb3_clone_err(xid, srcfile->fid.volatile_fid,
  2287					     trgtfile->fid.volatile_fid,
  2288					     tcon->tid, tcon->ses->Suid, src_off,
  2289					     dest_off, len, rc);
  2290		else
  2291			trace_smb3_clone_done(xid, srcfile->fid.volatile_fid,
  2292					      trgtfile->fid.volatile_fid, tcon->tid,
  2293					      tcon->ses->Suid, src_off, dest_off, len);
  2294		return rc;
  2295	}
  2296	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
