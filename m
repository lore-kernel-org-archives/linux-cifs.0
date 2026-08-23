Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FCB3C9456;
	Sun, 23 Aug 2026 12:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787487805; cv=fail; b=hU5wI3IsUsYBlE003aCWgbuWyHu7kkMnqWbvJMVWUCNUpsGNTdX7rrsATW3e8Hv4hcg3iZ6LLehba78CueJDuyvz6fPZyZme+WCqf/a//gecgOpSz8smM2UGNH3hhRJq/ZqBZX7C+9W+yASg+tVnXODi9Sl1+6axtap/D9d8VIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787487805; c=relaxed/simple;
	bh=c3YUNIW1dp8Nw/vorYUAYZBxZ3JuvL2RKX/HMxryo/M=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=N+IKPdx5ruXPZUX8C622lRPRTIy5ZN0dnONmGYChsaCTsShLagjtRSjwBY7E16AFcXUgE475MrD4ZrKutK/MWCQ6rpaYqkXvG38il3hjS4Uwo5XBHczFjNLVYGCS0ckJAiJR7l/eNLfCVAfudBtCxr8rllrmY9oN7v28KCzo+Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kh4f/nf4; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kh4f/nf4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787487804; x=1819023804;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=c3YUNIW1dp8Nw/vorYUAYZBxZ3JuvL2RKX/HMxryo/M=;
  b=Kh4f/nf4utoQQJSr9S4efSMgt48W4aamJGioBCyfoNwngOL8p0f+xxsX
   8NqNAf+SPnRcqkzQGeClqOq7y6yKlX3z57svHdFf1SYhGTkIln8OAZpbm
   4rfwXJQ6fJN1WOUaXFfw//+18v4TigID7rpFZRw3VYj4AWpUzbEcACYFp
   vK2hTYN+rTq0wCQn8zonH+ltpKui2+Lx997KmVUARtJWjWuvbxPjkhRBo
   k0wNnfhDqoX3Bml8tvs5Y7Is70Xd8eXh+9mVMy4SjxLzcNd8TvE4DwiDa
   NIJP7cH1uHVwSNEc8gPyOVqSrN5G2kLIwK3Vc/z5Awsz64DJfadg3B4oh
   w==;
X-CSE-ConnectionGUID: 2G6hWSI6SQKAH6dlYnUcqQ==
X-CSE-MsgGUID: KmheZO1hR6+jFjEeUNfFxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11883"; a="87830425"
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="87830425"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:23:24 -0700
X-CSE-ConnectionGUID: q+pJkKfzS6Sz5ugb8K9vLg==
X-CSE-MsgGUID: BPlQl23YQM6ljczJIdCqbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,238,1779174000"; 
   d="scan'208";a="270572142"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2026 05:23:24 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:23:23 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Sun, 23 Aug 2026 05:23:23 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sun, 23 Aug 2026 05:23:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U3jT+5cWRrSaxpXoeQXUU8nLlwKc/YqItI5MHt1w313gGUumTkxb3MamYewcxfMuwjzVWO/JNM6xQBi/ttiRBcyffP73MYPHUGXHIKfxz1v7urxDa9z1VH52JpfA+iHFp5RZ56XTVk3AvkNnSxZE1VO/Yu5E0VmWShoIFiodBuUWjEJkqXKi2pI9faWfrELgYUucf7JAiutB7dBHRDgm+VDmIVXgfUAXjHse3/aPSVbWlCTePlBIZIWFx7kfGE+3nrWewnU7ZLI72BIkJNC06RumaOwgmq1ruDrkjpV5S9J/P0/88ROQXVlF4rAeAlkox/c92JBxF3sIBlt6oT9k/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCKdmKNUYb9Ll+fT+G9oIQeGbJvlOmWjt2t4oBBagn4=;
 b=r+M/tUZdDDTzliLJgtvhgScQW/mXXYKjOhF2lZDxllgVJ3rU3rAOVm4LlVw2SqPQVhg8SZBpZaQROX7jKGQzjzdO6jG2ttavd9QrKPAxD0W4T3OYTezGtTecmMRHvj/JgCGWzGa2yC4HMEI1um9iEspRfmaGseE0oIYaA8wPp36N01ip3CLX36IpGB0/WUzozexhjOLUGwMNK1dLryv7vZ6HQEo1h5ZmZ5YdVNfz0s1iaCC4x+09b4KsaAHsmGSBseHtGRWw2gheZ/Q6u1JMfI4639OSAcYMOvgbfyiJxzE0vnKuvPqjgbRJxUrffgzHktVKF1iXhdVbcoobDwDJzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22)
 by MW4PR11MB7053.namprd11.prod.outlook.com (2603:10b6:303:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Sun, 23 Aug
 2026 12:23:16 +0000
Received: from SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640]) by SJ0PR11MB5214.namprd11.prod.outlook.com
 ([fe80::5926:3836:4212:8640%4]) with mapi id 15.21.0339.012; Sun, 23 Aug 2026
 12:23:16 +0000
Date: Sun, 23 Aug 2026 20:23:06 +0800
From: kernel test robot <lkp@intel.com>
To: Frank Sorenson <sorenson@redhat.com>, <linux-cifs@vger.kernel.org>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	<pc@manguebit.org>, <linkinjeon@kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] cifs: fix i_size inconsistency in
 smb2_duplicate_extents() on FSCTL failure
Message-ID: <202608230943.9VnBMLk2-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260820211443.1472310-1-sorenson@redhat.com>
X-ClientProxiedBy: KU2P306CA0054.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::8) To SJ0PR11MB5214.namprd11.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 764c5cae-7297-4236-502e-08df01114f00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info: DLTWkUpT/fefe6jnk53WsozhUvhcEhT4+zXMrsbpCdrFb+EnN6vUjC1zVgL9iU8zrIv8Xq6dgP8Kg1bBQxJQsBArNF3vbB5APreafEmrXvv5J9k34XDB0xq0eNT2KjGe2i1m6sCmUJtq0JvXCgyZemwPJ8MyvUSBiILGjhIAApPN++HnaYj3Z6sn2LUktczTnrK+BwT1DRN8BpOwKj/722QCM6HnXjkFCTBMinz6k8BJgAOHwrhuffRmR/AhSTGFBuK2stMLhsKM1xv2X4V9MyoGS3r9OpbLjog/aXcof8DWF4jqrCc/xm+fqIou6h2jJeap2j4FdHYjtFB7p/Fjj4IYfDT0rWPctdEP+jIwdAGkxP12npZaKorRSrp4oiXkcZmiUNS4apRzBc4/k0v8tGdAN0dmc1cfxm50CJVbE095k00mkqsBXeKcG2JXzwhmFl+Mu3ha5Crj5zdmy1D+YfvAZxIezK97oVEqpvyo2PPp2iSzO8S4ZSYjCLqERRFQQxpdhka51VyEnf8bVOqYk6YWdeqeXoOwIQHC/bSYMaJVimm82uq3m18SY72Qhk2/ZzEdXMK6YtXPlskZbQZBngRoSV0UchzQKa0bUBifgKtYzxBkcPlGeNu+auDsw4P9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5214.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krkxENkyOk0UYsgGZvvYHOa0ZiezeH5tVERKtXN5+Npt0xSXd7YakVX6HAH+?=
 =?us-ascii?Q?/5dFSs+7AfiOQFEjoGydCum1gj6YMu1m2t8ysdUxRV7QHysVWxBb5KFWeZKh?=
 =?us-ascii?Q?9iJqZ2RkCfdXggHZypAPa8h0PSdtUkF7aPbedTBTlNT7VC3Opa1HXQXM4f2H?=
 =?us-ascii?Q?ms3Uui6mxm4RFZPeqpyJYEkPyF5gdMyUNzvhKQzPhrRygX7reVJyLrd6DBb5?=
 =?us-ascii?Q?9rD4T6JFFlCEfZN0+p4AW0fxSohY8YDd5r47iCiw2zU7MIxfjjy5/RaKNwUt?=
 =?us-ascii?Q?s9X/Q/z3BM6ItKO8gqJ4f9geudJuLTpNmTXfgIK3g47xkL1VdT2vD8xRet+O?=
 =?us-ascii?Q?6fCFgmd30g75uxI5PGCujSs02EXDI6N0qt1Gij5vQ4KQzoSmoXCvoZt0j8Gd?=
 =?us-ascii?Q?LjNqU+tfZfZjkVY3FTjDnqHoX/xwdsWvtIQRUidG12EGZUfj1KgPZri73xK1?=
 =?us-ascii?Q?VlUJCg3RcaMnQgEcxtF6Ed+rcWahDwy3qZSj8xc+KHz4Ih8k7YPthsJlKNDn?=
 =?us-ascii?Q?ZtWC0OPYmWdTwEP2/2ZdcqbmJ5LHbO+/3kjnCXc5Jo9+br+r3tzAPawLq6ym?=
 =?us-ascii?Q?7byPQdwJkh1zgzqHlPc7TDFiSsxa/pZf9klXffVSCDJX8Bh9FAeodQQ81qSx?=
 =?us-ascii?Q?vpCNWXAyZKUEA5IMNeFmXIw4l/JAMpZI10l7XDVXDLlt5D1f+hWip3isE5pT?=
 =?us-ascii?Q?z286iqXZNEtAasadQdkEI/O8Przbvmzan+SpWOPCrHXDsD9Qks5KOY4eRn6O?=
 =?us-ascii?Q?l8XJuoyyNQOuUEUvRxbs65H4ll1V7J/xy4d51yMMZjf8YFWKuVeAhsJE/ZYJ?=
 =?us-ascii?Q?As6cz2Q5DIvAzozig5F2jIELnPYXV9I4lsBQCWzAAmTpJmDLIGDDlWcKZ5o9?=
 =?us-ascii?Q?zJX1dFFEBvtE9JrS3ljCvtLF8mG7p+V5LU49WdEvPJNEP5pSedQQsyx22UbI?=
 =?us-ascii?Q?USR8BbuPg+cK2d/usci5tbyBtKPBbRBtBIyCYn9bNvAIKKqYZvOiyywdiLn7?=
 =?us-ascii?Q?4P/fomqAlWckpXkHN9dKXOHgfPJ8aCwhw0RBaww6Srb8YlTsqrwJtC31IK2V?=
 =?us-ascii?Q?sMaVpaabYvZikV+YP8g1wRcopPgRamLfwyI1mqA2m3R62bdX3+QsyR+tcghc?=
 =?us-ascii?Q?/C/q7Yz2SpaEa5C3tip4N9BxYjA4XHNabLKKJC3zyd4mAm8ssBnT05pCT4KV?=
 =?us-ascii?Q?VGgp5Qjyog/LjvkuRoFpWpmqF7NM1qHAAF8+rrAGT3beEo4ht4d+a6j15mNr?=
 =?us-ascii?Q?DoMUE1WBwwxTjZ8eVJ87SeoWv2nOow2AVnP1vIxfgY8P7oLGpPm/sFn9SXBS?=
 =?us-ascii?Q?DvvEdDPT/Ffk0Qsao44omy8RaVX5X0cmNAIK2ZceAUczhQ3pgIxSerAhEyR3?=
 =?us-ascii?Q?IbY+EfLz07ueNlE7mUuGxBtN8reOkhYYInQSJHBdJ0iZBGk05r9YAhkgWIHw?=
 =?us-ascii?Q?3B4sFC7jKEOkBEqay/9yZAcbQDc8OsZaTJluFyu9L6VkXRPZbCiv+5hi6cLi?=
 =?us-ascii?Q?XsUek7s5EQPqM59fZz8CWlc35EyyRrAvEQRzhobyJ06O89W10B8pFmasUMZ0?=
 =?us-ascii?Q?sXm8n4hR4cHbsJh+2uJXX5Sferx19f32ow1DiHUwo4qUrpZn86D3jaNfJ2p6?=
 =?us-ascii?Q?G3knMJS/blqvfpND+RwYQjqffQubDosTB3H3r8MXL65eXBzBzXa5D9q+Btnw?=
 =?us-ascii?Q?QwO1bCOLWDbWvbzZbN5TLaNgIe5eO9WbbwjTYBqP7e0SLZP0IPOTnBYfIh3Q?=
 =?us-ascii?Q?Qm7TbudySQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: fjKKA7pLF6W7yeu+EPqzReqs2qUY4DRDminQhSOcib26TkyrmFBW1VxuyVfxLBAaETil1sX9BZ19H8u54EkEsjtcCZJhaUWN2gBHTcgLoJ9Eys9HUq6F+UwfPIMFw+CxkYtQP5TN7PGweSxvYM3aK7sNHGQS3D9QM6TBlqz8Skyj86wkVjkWg12W4nrFjOJFLKuAjverBrm9+PIL1hXeFATN1MOiUrVCkDL7+Fno5Yr+KNcxzlmqC1QoR5v83d70de9DYAyr6TvF2dhM/WS3Xb0EBrtlsl7stRoTJ43dNkZ8c00W3zmr0rTblP5HlAjluaEbrJZt/7w6SVTJ48uIOg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 764c5cae-7297-4236-502e-08df01114f00
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5214.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2026 12:23:16.3968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pbEPil28tVKO/kAaJQBXPpaMLwURgwnUwY8gYU75Y0EDRGoiX1wYqiyTOWuddkS0An9wk72P5yFsxXPXMPeZQ==
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260823/202608230943.9VnBMLk2-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260823/202608230943.9VnBMLk2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608230943.9VnBMLk2-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/smb/client/smb2ops.c:2251:4: error: call to undeclared function 'cifs_resize_file_locked'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2251 |                         cifs_resize_file_locked(inode, orig_size);
         |                         ^
   1 error generated.


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
