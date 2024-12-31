Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4ED847C
	for <linux-cifs@vger.kernel.org>; Tue, 31 Dec 2024 01:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735609781; cv=fail; b=ggWdMI4CJXATfPs7Hhmml9XHhOyFMUXIQ8rt+DuuCC+YVzOzWmlLOL/+Fo5IcDTyIN7Ocw5JezRzZxydSzR/PfLlUBZbAIZ9bsvk1FZt0sHA+ldggzSszWpL+fy9N2mUWmjRbb+qNC2aYwCdkMUFK3MfU2OhynTUCmkrZeOjRnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735609781; c=relaxed/simple;
	bh=VyImxS3TMS1vTizfR4U2SsTis4xy3wyHwDrdtUiLshE=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=oAI2CCJMtGSGQUPX20zPPUoV7ebL5eNEcPXd/2PpyoLj6XlIK9ck0fAAlQ+E2hPI5YRzrtRFw2ISWQzKV7tnd6KDEIoaIPBb4Wzmgr/E5YVmoVtgD8HnPQ6V010D/+MgSj/Zt+ZIfGb3Xc07X4yhNy3BlAtraDnLA06FfEqI1Ik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L05lBAou; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L05lBAou"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735609780; x=1767145780;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VyImxS3TMS1vTizfR4U2SsTis4xy3wyHwDrdtUiLshE=;
  b=L05lBAou+h2whlc4nY2WASNKyROKb8P5MylONeeYolE3IVi9TRClNL0f
   QdupBbnNVTMM9eZqT54cFsCZHF+2rMCUM6TVVrKNjjS794zNJbcrHikIW
   hhfdKrD5IxjpIgk/hR49zkKoW/IfzmXmPtmkC5R/j7A/BmsIAW2UZzQxq
   dkaImo8f1VwrEy6Ntfw9tY3/Qn0tzQajb0BWhoJOtz4SdbiZyJTEOdFQb
   htuWXNCm0mZyLGzJHZZVNudEStkuceBZf7DvvWcaUa195ayeN/TNs9MTT
   euQj24FvFirtEGSYUQgmqnVLBF2jUKXaDN+79u2rxWPIHNpBBdx844Rja
   A==;
X-CSE-ConnectionGUID: 6teyhqDwR3yWB50OBfv2Ig==
X-CSE-MsgGUID: psT5K8ryRsy6bycC2eJ2Wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11301"; a="36035751"
X-IronPort-AV: E=Sophos;i="6.12,278,1728975600"; 
   d="scan'208";a="36035751"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Dec 2024 17:49:40 -0800
X-CSE-ConnectionGUID: 5U1+gIgFSMaiLjyQTotGag==
X-CSE-MsgGUID: O5Z8GW1KRwue8fyEjD6rkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,278,1728975600"; 
   d="scan'208";a="101051800"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Dec 2024 17:49:39 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 30 Dec 2024 17:49:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 30 Dec 2024 17:49:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 30 Dec 2024 17:49:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvydxTgBxlJw38cGdMIfm2CyvaUX9/JzCaA/ToMliz5E2jw/Q9sdF+/Ph+XrP/IauW32AZrjDrm+El9mojsINm/TYOcS74pfbKNUvDh+TCf107lcWDj7P1UsbJ6LHEFkCb6j90AYsBs5fnmpc7QAXEw+l+JZU9HQkziDd88poLAHAxBt3lPvxgYotuqglZHM+WTtbxyOauZ5GVbfxDuN4tjT7tWABSpGBptDtEKYMHEOy4zkRd3vbxcN/EKkb0/AEEsWSNih3hlARuc/4/2potEMOODAQTPD8AL0Lto0330JR2gFC6/OVJHVdwBnKmDE7BsomUHiyoI+c/xMUfRUGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdFBm5j0O47HJ9Whqw2acrG7+90mmgIU3J1MHNus5xY=;
 b=ecrWSYkbkgrlcPNmV5ebOe3v0ezsVn0njmR9YRKiJihpuThf1I/PCLm5oduK3rQisjwWY6WNCK4ew/RLL9agsarEnGe7L8D9gusR+XGWC4fS7Of4fULjNeWR+xyMiHZRp6elgDesl7vgg6HhyPzRcuo/LCP5tmTxjlp106WBfaTAv9I/4q65IsNuPbGRMyrwT+c0+8wOqydt8CyYmHUZ9fBih3onx1LtGX38QH5I/9D1LOWX5OKonj67St8E6YS/F0kDSjtAcYoqg83xMiLrPzWrdE5c0Oo1v3TSnASZ23VoodwdL73u51lf2J4djvWRBJ/uPfv7NoFsEIm45R9SKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB5772.namprd11.prod.outlook.com (2603:10b6:a03:422::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.19; Tue, 31 Dec
 2024 01:49:14 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%6]) with mapi id 15.20.8293.000; Tue, 31 Dec 2024
 01:49:14 +0000
Date: Tue, 31 Dec 2024 09:49:05 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Steve French <stfrench@microsoft.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, David Howells <dhowells@redhat.com>,
	<oliver.sang@intel.com>
Subject: [cifs:for-next-next] [smb3 client]  8f97b4a68e: mount cifs failed
Message-ID: <202412301620.c166bae2-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR02CA0082.apcprd02.prod.outlook.com
 (2603:1096:4:90::22) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: 2522e749-5de5-48d6-57ba-08dd293d544e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?W5xlXNYg5RHLyIGpEEWz69k0yAwkNXrQ6YH9EAkHkq7vDirS/XAXfTfGP2lQ?=
 =?us-ascii?Q?NbET0ZyDcu5DryF+UVztxbdMEykTkKcARH5ZXDziV74WbvDz+lGk33CtgRwp?=
 =?us-ascii?Q?FxXv7heG0LWbCEcdjZkia4P3hhBEHpbUXHD+H5yu+UeV2pvRHiVv1AP2yyIw?=
 =?us-ascii?Q?qIr4si9wJdq1nERuZPh84/OMNuUvkUMqALgcZclk8YwWxnk1kJcT+i/DQzzv?=
 =?us-ascii?Q?WpXmCX0tqwnVXbzSCuZ5+pOKbJF0/8slOueG8X3axQgNUGkJJYcTsNUYUQC6?=
 =?us-ascii?Q?icUEfbHX4W4hbCCDeRdcZDObNe8hmJ+ZI1+KVQwg91C46Rt1Y4ZwX3r6jTeH?=
 =?us-ascii?Q?1LqtShB8/uOB/TAthBo9D0nNLH8t/JpCox03c9kD5vpUTivPg91lUCl5YP2L?=
 =?us-ascii?Q?d5ynUn1IBAgCdaq7kzbkCTM+X51P5fFfweywPrfPOJX0W0uBWPJ/wtWf7DxH?=
 =?us-ascii?Q?+DlhTWvRmJCXmx3ptEeMJQE7lUEYG9mw7DdEUiIfSr+JFGsgUCQkBJIEX84N?=
 =?us-ascii?Q?tpjhIJsZn+Qnnq49JiqBTSmgO4jgNcm9ceJVoibe1B8TN1VuWWfh89N8v9Yu?=
 =?us-ascii?Q?Npb3DOWbUd29KpeSyJozV/+NX5kr9437s/kR6OASaUL+nvRC8v1/HAjt3Cr9?=
 =?us-ascii?Q?affjlA2xt1qxNegwErJ2iaEQkDl4qX36hxcbOSv/gv+Upa11rwxkmepEoXlF?=
 =?us-ascii?Q?KI+BT9y0Q6hbajyAcUuC8BMlKST57TVcQnT2sdgC37ViWrFb9ZycfkEzVRPK?=
 =?us-ascii?Q?hwI9qmQT3kyrV4MX0ZrvNMmI4SzUMtDWL3MSwT19F5uRHnUnUVonYRodfUnc?=
 =?us-ascii?Q?zHCrVM1/2WUhxDvSEEH1F8iuu4AhEygtjXSUWD20Hs7wBzVZF233ly2umiFF?=
 =?us-ascii?Q?hWzubTwYVq1j8sjvxD1qYPZp3wlglEQ4Og2h+NRGMhNzSVdqDBZTZKLrfGH1?=
 =?us-ascii?Q?BvyIExXkWxKsjSs3sR4wrQlVLqeVFCagLov0uo+6NnDtznhzxSlU6FmBAREQ?=
 =?us-ascii?Q?dyDF8ThTMTsChL7StchfuI6xz+PfU+eUrdPjnPLGRU8wIYHTOV6oHw6qWRbi?=
 =?us-ascii?Q?N62pL0EQvx9915RIBxOJx29pS+p4oFK4YhkmTpxcFIvOOZobEiHWwtbb7uCu?=
 =?us-ascii?Q?3/z96YEPaNqQxDDoV2z7+wMqZRm+n4xc2bBy9k3+cOrEYJm/bbCg4PW4NagA?=
 =?us-ascii?Q?FZ003lElLNaCCmyS5rtYVmNtMrwB8eXrVWQQJZ4eOewnNHT+YECtjNjGb8KM?=
 =?us-ascii?Q?IX/W1tIkMc9FHO+ohA4E8+W768d6LHSUXwENgjSeMYrlkewYZAzY8yZzIDXX?=
 =?us-ascii?Q?Qx5OT5lRRrqAdr+gGoeGFBb/guJBsNfFn3DbbubI7j0h8w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6X5kSn58ub9cHxFvmGTTasLqJFQ3pbKb+RvinNrBdrNGetWece3NITQVFy7W?=
 =?us-ascii?Q?2U82VvWEpjLVRDDiZclqxR4GStAVXWrVpBf9VNgJgnrbr9mCERy6AHjGEMVR?=
 =?us-ascii?Q?3TRV5prZB8l9+vcTg6vUeSfpx23YXT+h0yEK+6Z0fSq7sFWK6saZwhC5jWyz?=
 =?us-ascii?Q?JqQnFz3hh2sLcgYTZ48dsc3C13mXD6GqwmZwMIsHsSnxKB39+dwnUS5Bx43m?=
 =?us-ascii?Q?W0LRNjGZcYgjKusvK0+YfwZaLR7CBHdjSxjoMvjfxoadt+5tovg7bS6Kx7FH?=
 =?us-ascii?Q?Krs43NkdsE33BO1I9OUZW1wRuGbQRlFU+ql0HRpLjiwjv5y/eGEo5brAtmpu?=
 =?us-ascii?Q?rV4XLDQ6qFWrVZvOkeJS7TaFleVo/n9xDRhid4R9KUm2wcOUSEw7UhPUyT8S?=
 =?us-ascii?Q?Lr19DhiwnfbHBR7m7omHyOJUbgx6VM+B7dcQDr9aVxoFFCQxsLknBPwZuRdh?=
 =?us-ascii?Q?wBR6AAxXtXqDmV+q/SY8DzsMLNfDvkss77Y0LjbNSUODlGTzuw1sUpatEqfC?=
 =?us-ascii?Q?fN1kLesr/9igDu0U5fiPHMqk7/CISg5Kc2HHQPVeKZDkx9Y+6rvrDDsXjHjS?=
 =?us-ascii?Q?EPuFzXckvIYtsuSbjfrqjj5WFbV1tLeb6u604LdOceZE8gNz/wBbkozeVbDT?=
 =?us-ascii?Q?7z7gyTLXmiXl3Rie07miLVh/bBJOo02Uvypi3g0aP5jf8/2WYpoV5AE9GU8z?=
 =?us-ascii?Q?+JruwH39OaKRxn48GQlW+FcRtdyVNKTzAVS6q2cc2anCnPK0InzMiNSyGRk3?=
 =?us-ascii?Q?EGWkb8mqdBYbsXAQ6k9JDoW4SlvGeUfI3jFYdlBhOQay0//Ipk3VTiouo7rz?=
 =?us-ascii?Q?EH1Sn2GSNbKpslWtWrzwJaUKFjN9bIHki+Aifm5OfLj9Abzwkoih47jDGq7B?=
 =?us-ascii?Q?Z9PbEeEMssbyJDKXpFglAKVpTLb9Gv1IZwhYaBUt8jdq4O3VWjeW2XVaizbe?=
 =?us-ascii?Q?XiO6pdZ4x/TUtDZUGP+C1HVbv5mBO7Eu+jq64wRbqSgPm5HZ3jrAXTd9Ryo9?=
 =?us-ascii?Q?dtvx8qJzDyT0oKmpoCjZpH8YcLWAvuXpov2JpZEylJs2/VxvX6KSL194RXsz?=
 =?us-ascii?Q?rYzDq7XB5TzK/08pNfR49Zl9NnpDR8h8pE5ClPubhbJIYqDDD47aWxOonmDh?=
 =?us-ascii?Q?w4GoqfW/dl8fuRSpkloSDsBFVu2I0TUx/5eJpvmiXUb+IETSz8pIPcZL6Xz8?=
 =?us-ascii?Q?3gm34HKTbyDu8k8QvD9K3ZjgAX7bo6Daxgqbvrut0tpFV+YYMxVWyZD4QTvm?=
 =?us-ascii?Q?DCdN4E/1+sznWD8QWP1nSs+HugZvvJn6NXn+5+m05BpyAykFGqYyuwgXDSK5?=
 =?us-ascii?Q?31ecRZL/JqwY1F/N9iN8Fc3wiFtkGoppV6ghDit26lpyWQod6bWVTbPTnmVK?=
 =?us-ascii?Q?dDLEad74viUlob5T7Xt7XV78PD0ByWcu5zjuzWV1V3pHAhWlUcjBiVCVUG5f?=
 =?us-ascii?Q?ceACWTyWM+GH30L/K+0gQxx/mSwEJd11GAFNY2iAGshPfH5l8EzCElEWZMhM?=
 =?us-ascii?Q?jqbSAg9Rl2hEfqD48pU4lCKoAMQR3z69hjEusVd6s/qGyPsRJXnOGrgOsbjI?=
 =?us-ascii?Q?/prHNhOQaiXdhPFXOBAmgljmtkCTCO2u0SE5C505V5LtfNujNRUUbs4RlwU3?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2522e749-5de5-48d6-57ba-08dd293d544e
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2024 01:49:14.1778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vA7ykAMH/kqLU0IbRUBA547M0Mfv6LvyI3SU1OZW/Ibgzs5hLT3JMiYzN3s9hLu/oOCKltEmmZrcaF0aUuTwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5772
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "mount cifs failed" on:

commit: 8f97b4a68ea216bad142a5391e30fa63c8efce30 ("smb3 client: minor cleanup of username parsing on mount")
git://git.samba.org/sfrench/cifs-2.6.git for-next-next

in testcase: filebench
version: filebench-x86_64-22620e6-1_20241103
with following parameters:

	disk: 1HDD
	fs: ext4
	fs2: cifs
	test: fivestreamwritedirect.f
	cpufreq_governor: performance



config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202412301620.c166bae2-lkp@intel.com



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20241230/202412301620.c166bae2-lkp@intel.com


[   76.224066][ T1501] 2024-12-29 09:40:51 mkdir -p /cifs/sdc1
[   76.224069][ T1501] 
[   76.232341][ T2587] Key type dns_resolver registered
[   76.235173][ T1501] 2024-12-29 09:40:51 timeout 5m mount -t cifs -o user=root,password=pass //localhost/fs/sdc1 /cifs/sdc1
[   76.237738][ T1501] 
[   76.582135][ T2587] Key type cifs.spnego registered
[   76.587345][ T2587] Key type cifs.idmap registered
[   76.594324][ T2585] CIFS: No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.
[   76.621797][ T2585] CIFS: Attempting to mount //localhost/fs/sdc1
[   76.640924][ T2585] CIFS: Status code returned 0xc000006d STATUS_LOGON_FAILURE
[   76.650555][ T1501] mount cifs failed

[   77.701465][ T1501] 
[   80.113215][ T1503] mount error(13): Permission denied
[   80.113219][ T1503] 
[   80.340094][ T1501] 2024-12-29 09:40:55 executing post-run script: /tmp/lkp/result/post-run.fs
[   80.340097][ T1501] 
[   80.352169][ T2650] EXT4-fs (sdc1): unmounting filesystem c7b7fa61-d323-4246-9fd8-7d69a4f68780.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

