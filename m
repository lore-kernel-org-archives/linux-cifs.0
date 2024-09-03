Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726511CDFA4;
	Tue,  3 Sep 2024 02:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725330227; cv=fail; b=DMbkh2zrqBUvQstmEhF70lkuiyf+fDQxxerry9ACIrK3pJlI4KWzNBphjzEK/6KvvMW9qYM76vY2Bq/TOt8qmlmQToupqLQY0pAPLF9AQYWz5GDpmiyodUTszsigXjx3Kk7j8kLbvuGbCserA3mE1TnalN0tob961tvatD0KOVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725330227; c=relaxed/simple;
	bh=5jBp2KTldgRN4cJG05Xo+nmm4D25FQgWOU9nQOZNPws=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=swK8uuZUqPwbE4tLP5wKDhmAXDzaAoRrzYQlh1UNA/tNkYP3pBTJ7hzWNkKPGQkJ21axHHefC/+NzhdC2me+PScT7YlysIpA5MlZVeZq4DhXfqFi+YYOwQV1qO+dIFhHqTpS/2Yypbje3ZRNwYPtvN20a53VuRdS7ZpW+wVP2No=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gpJ+5zhe; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gpJ+5zhe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725330226; x=1756866226;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5jBp2KTldgRN4cJG05Xo+nmm4D25FQgWOU9nQOZNPws=;
  b=gpJ+5zheOzYcvblZZh0fAaWhVGg6YFHGs7R4TPWjwTDPkLQ09Vr5ForO
   WHtddMEm63yxX80sUp0JWiZ3E8JyY3JdCozSEA+AnW078RzZGkbaVtaK5
   KnzsbZ9zOGuK6OgFYU+/URovCwcU6nmCCchrghoRMVdqNFU5zUZK2tIpS
   dSDHMCbcciVKSxWCBwn2asU+SioDeh/FqxG90JAzdFJ5xPUt3x4YnNKXk
   HH+xfvRuvXh71k/Djz8oXMIJOmG/RNC/Y3uvXcWBLCi11l6lZf7xumIKC
   Z3CGY2JakDLXWTeaeb4SotIO/9aAW6Me0xRBnifqqHQJK8iphXmBXejYH
   A==;
X-CSE-ConnectionGUID: 4LT/YJMUTSaa51xiPSxCCg==
X-CSE-MsgGUID: xNJgdwIaSm6NcowjKOxJBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="41404494"
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="41404494"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 19:23:39 -0700
X-CSE-ConnectionGUID: BWOnQdP+TqOJ2AtOlEoQNQ==
X-CSE-MsgGUID: oyEuqrjiThmP3tuysNcn2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,197,1719903600"; 
   d="scan'208";a="69616562"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Sep 2024 19:23:37 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 19:23:35 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 2 Sep 2024 19:23:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 2 Sep 2024 19:23:35 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 2 Sep 2024 19:23:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eoxGHAFK55pYglrgXfZ87KSAZbjYBr+8zbEWEBiVpdO10lxCr8oRogptrmdirJlbLfVgBp6JkqFu1ks05ACxh2taCAAf7355qZvNInNLCVqpjelIkxQeaDjkqkT55VFoYl8vXDSMirg7qqbXV0KzgdIE21ZQPinGyX+tdaovxy0d6Omkm3OtYqBF7h6TOEMlKIDb1FIMIG1aB8uE8GSknIwLSqRnZaKx22fm1J2nT8e7o6i2fq60ZVtvA6/5g5geZWBigdMmNo1ljjovlKHdpjh5AZ4PBkBR2IzKjHdE351CQrywC15hma107JlHX+l0MwDC2e6O+ycoJMs/VsbK6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGdqA5c02sWfV/JYDpuhTS4S34FybI76/mE2UcRn9Ps=;
 b=PL1rn2j43tqXPl3XnjI53f6WnJUc4dCURLNygIGsTVNzLxDpp8Y0bNctpViF86R1yLJUovLvTX2ET3vYEWs1JD8S6P/OUyqYh6649Oo2Ei4HV8R1EVY4yp38Y/9bCexKkPp8qUk+Q4aRoFcAgDwLl9D7NTMDswx6ZtFu+zNLcc3C5n9SekpesIAiqPOdonEQ666yqGN1B1DADYjRPrYvnCyJ2QdE6pGbNgEl6qZs4Obk7/Pu6BdW6oBQYW532lbb7U7EYdJi70t4VFCok1jaqScRPSq6gFODn/kMatpcMBy0nk8mLUcJSRLF6vBk4otGhbW+VDEgivKkMfmwgrE9sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW6PR11MB8411.namprd11.prod.outlook.com (2603:10b6:303:23c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 02:23:33 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7918.020; Tue, 3 Sep 2024
 02:23:33 +0000
Date: Tue, 3 Sep 2024 10:23:22 +0800
From: kernel test robot <oliver.sang@intel.com>
To: David Howells <dhowells@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Steve French <stfrench@microsoft.com>, Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>, Rohith Surabattula
	<rohiths.msft@gmail.com>, Matthew Wilcox <willy@infradead.org>, Jeff Layton
	<jlayton@kernel.org>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <oliver.sang@intel.com>
Subject: [linus:master] [cifs]  8101d6e112: xfstests.generic.433.fail
Message-ID: <202409031003.eda2be98-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SG2PR06CA0224.apcprd06.prod.outlook.com
 (2603:1096:4:68::32) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW6PR11MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eaeca0d-b871-4763-4e62-08dccbbf684b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vZWtwpXX1i2JNXB0RgBH0YnYWTGPizQUmkeTBORfyjhrKucUds9vOluq5Xd/?=
 =?us-ascii?Q?ZMw3rIcfVHbsT774r8vqCPAg4Ka9u+erdlFjoa4fOEbCj64QAM6sapQdwR+7?=
 =?us-ascii?Q?hhlJqkE8mFnp8fv9kHtMWpoHGbut7e8Ol8WJx5UMTmLF+qIBCwUlrP83v/mT?=
 =?us-ascii?Q?tQCxLE7mxuoXEEFkPh/D4J23t55SM5iGDeuQK0Zgb050rf6Aj6P4n2jZspf6?=
 =?us-ascii?Q?f2Rz3HfeE4+SqJmI3wvGWbdqcEeEL9oloEJWJC4weHTL9eYn8vfRAeHny41O?=
 =?us-ascii?Q?YH88kHNXzX1Srn6nLI+/BdWgQrlmc+B4XfpnYdPKY8hRENR12C8fUEZvLx2i?=
 =?us-ascii?Q?oubLUDCoPJb+keOVEWRyBZc2Hr5EaaFol4bS+u7/yUFqiaX3XFfVbKEFAyiy?=
 =?us-ascii?Q?Rbj9NZXn/TNeUHHfIo8+M5kZ5u4iQyUz/zOO7++80MY6EzrnXiGGylgiDJ3G?=
 =?us-ascii?Q?YkMpBWpUMxRGqRMkhmf0dTZ/BBg/Wc9b8RY/RtM4Q2VElET3CKjKk6j23u/X?=
 =?us-ascii?Q?VNUMHwbpAa2SfjnguKwhQltSLySXvtK8rnDbYD/WLd6za5VdGPcPwxjrJ/cm?=
 =?us-ascii?Q?ntHTgBVTCgetxOOTW20eW5Ivu+xUI/AVcZYadN6QeIiXfVKTnurmPqjqsHVB?=
 =?us-ascii?Q?ngkrAui+fMvVIGFbMIDPCguGlnTnXUEBgOZ6O5AD3RrQxacED95P051XTLyA?=
 =?us-ascii?Q?3guCqhJCokAMPhKK3ct+2/5GLABKISW1gMiclEtaa6W3En4RZm8lydLQDNcn?=
 =?us-ascii?Q?tRnnGzcTXLNWPMnQ2EBHqa3nP1GzDge8zJCnB+WM8hdE7aW4wnK8oCCGXUHR?=
 =?us-ascii?Q?wwBGTlIby+1KemlJZqlW8WilsVx/8CNCTQ4W9XFO7i+FqX6zqT5nv2BpANEw?=
 =?us-ascii?Q?UApthEA5uz/FnO5xCjGzOBvaja05WeJS8EFnNeYcSsU+VnhGAMaAgK0FR5OA?=
 =?us-ascii?Q?YNGQIJv4n2XF/itQ1hvzNtmaFCC6WSjIXGy6aWpLrCdmRLlpWj+7KrTzfHm7?=
 =?us-ascii?Q?WxdVh+cey2HfW/Z1lCPdhhFmrsDpHtwqohYDwaxKttuazpHGbJz16QMHB4r7?=
 =?us-ascii?Q?8HJ81tLHyEx+vKkphgqB2eJGdCfw7MSbS3UmsrVsDznhWZYIJv776aAQ7iok?=
 =?us-ascii?Q?oKGdfVK7BtdEybQm9EbDg+m/6xGFncDxvLbZxsDjHS5bCmQDIBqXUGwC1Xak?=
 =?us-ascii?Q?1pip12O0kuhYR6ovMxs5WaITLj/Y1IoVIS5nhlrWYTwzXP1CdvmQzEfNsKmi?=
 =?us-ascii?Q?wnCvv3meSd6IZep+om3VCVrB/Zdg/854oovsgsPYdAYiXEq6XABmXpl9feat?=
 =?us-ascii?Q?+Lh7vX+RlnH+qlITdHlNxa/P?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O1QydxaMdZ8d+FsUsOkQyQBC/FrcobBNKEAo/1ZG/Fqcrjqe2QICxeyP8qbE?=
 =?us-ascii?Q?7GWCp3+a6dKMLEHJ5V/Y4PShhR1LbtHXiX/bql9BKABpsYsJwMAWi/uL9vev?=
 =?us-ascii?Q?0PCAoyvAlfOSNLK2XWRAtXTw7Y3UhfNHRjY2YaX9Ikh7Z+ORfsg7oyNkiJ7S?=
 =?us-ascii?Q?3ETO6hgwWpUSU69WEdcT+We/QgVOI5W2kf9U2G16HTrMzZwaXgcJrzEE6Gnr?=
 =?us-ascii?Q?9NFhcJz1bAeu8jPPeuXyHezxTgpU7AskrjNlCGZsRkJFFEZdJCafVYBdv9up?=
 =?us-ascii?Q?4KSck6y7WrqK+z/A/+SmVfc1Y4OJfgXCAPzzAxXY1TSVGAT4rmhxkgC1yo3w?=
 =?us-ascii?Q?cWVXOoUCsxNPyQ6hpUv8tgJpKQt/lvX3NEHb1NJwogCJ/kzy63i83Jwp+WQD?=
 =?us-ascii?Q?nXytCfdGkXvfv8+QxqcuH+CxFHalufusvmTc/z7+ZvDmdJhdI7YCfwXeuBPC?=
 =?us-ascii?Q?bg+gwqIYvnQtgn5OnVmLuv1mao/MEZM5iwNwTP4mcpIqV+R0BVcXIGyj2gBr?=
 =?us-ascii?Q?ZYtuYpYg31jdnVjDG9O47/dtyI5iA7L6EL17TKcOZh7jIIJDGaYquZ/6DSa7?=
 =?us-ascii?Q?ep6/h7Vd//Gl4c78/vgWPdaKDEFveffnZusl8PdgGzBp6CVIMP92g09vwTwB?=
 =?us-ascii?Q?QzYJCyTsgMttG43MMO/zS4v9nDkJ3EGHYphHXGCiAPnupV3ZerylGrOD/pHx?=
 =?us-ascii?Q?43rgoCVaNwBhOj0gDzcDhEnp18JxIqdaGvQKp2kvsMBfgyTokP5Z+Em+JQ4Q?=
 =?us-ascii?Q?lAW2ejvQltqtHkRlvDpnY0nyJ2kIXJRr5OWTHxw23EMGxU32Ap8IcEvJoaHe?=
 =?us-ascii?Q?SR3qZP1crgwYnV3bSketZLdvmrz09Oz8mN7N5LLnAGU1kB2wpQu07uT76kPO?=
 =?us-ascii?Q?O+9AlX10WJmvhM77xYlS7a8tFQ4KqirbWoZgdp9Z/6gFCUpBZi/d3DudaKE7?=
 =?us-ascii?Q?NV63PPq8FXwtJnjscLfMTZ9rT8jzsbh9rMFgqWdLxaAdpwHdXLOivFNkHGDn?=
 =?us-ascii?Q?TdWk7OLb3N5q5Q5K7uzuBGSrHP8KhFjDZ1nAnJSzMGbYxgbHnVRm8yS5WkCo?=
 =?us-ascii?Q?YJBJtEKvXBuea/c6yhGx1i0wseYmUkhwm4nS9BD4Cbk+yzEL7vzqM/S7xoK5?=
 =?us-ascii?Q?NXLOLpp6WXslLeMH0gYBEjejenqZLoEs3FS3JqC4IvfyEGxxoT7hp32z/c7U?=
 =?us-ascii?Q?/U237hcLAjfaEo27BT2bKCtuBJqNKro/lKbAZQeHVMjYF7DLuZWZHKqnyyQ9?=
 =?us-ascii?Q?hId5NFt5kOoSMm8g3Ycswvk1cQ2U/NKlO5YZFSlRBdhOpYcH/QkDJWar9qdz?=
 =?us-ascii?Q?whmOWNp5s3Ki75sF7ZE0G6j6dSBngtoduoKFw/XdjV+gpr/EmY7Z9ARxEFZz?=
 =?us-ascii?Q?jWfxO7Km3ies86QTJZniFmqoOeun3suwXahvlL69jzUWKWVs/S/Y2CV6DqjH?=
 =?us-ascii?Q?2iC2PbGUYslaS/D7l21+uwuBrbMqC7tb1lm0gcJzWcs80F5i/T4H/GsSVG1t?=
 =?us-ascii?Q?b3dCp3EHIBtys67wlnHUlguuuB2WjE4pNsFxqVkuh/7dqC39yOKEXKMBGFYC?=
 =?us-ascii?Q?lV9uCvM1pKJkGDuHc2lJ1K65oPfAv0GhO+b8eUf5s70nHzCrzUDzD5va3FHM?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eaeca0d-b871-4763-4e62-08dccbbf684b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 02:23:32.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQ2VZbne9J+0AdDIQ97usoXZ9dv//JRPrT5jicawj52vscKVmCD6eNMMsy46rmOLQEhTWnos4qHbANF/gDraRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8411
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.433.fail" on:

commit: 8101d6e112e2524e967368f920c404ae445a9757 ("cifs: Fix copy offload to flush destination region")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master


in testcase: xfstests
version: xfstests-x86_64-d9423fec-1_20240826
with following parameters:

	disk: 4HDD
	fs: ext4
	fs2: smbv3
	test: generic-433



compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409031003.eda2be98-oliver.sang@intel.com

2024-08-31 09:34:42 mount /dev/sdb1 /fs/sdb1
2024-08-31 09:34:42 mkdir -p /smbv3//cifs/sdb1
2024-08-31 09:34:42 export FSTYP=cifs
2024-08-31 09:34:42 export TEST_DEV=//localhost/fs/sdb1
2024-08-31 09:34:42 export TEST_DIR=/smbv3//cifs/sdb1
2024-08-31 09:34:42 export CIFS_MOUNT_OPTIONS=-ousername=root,password=pass,noperm,vers=3.0,mfsymlinks,actimeo=0
2024-08-31 09:34:42 echo generic/433
2024-08-31 09:34:42 ./check -E tests/cifs/exclude.incompatible-smb3.txt -E tests/cifs/exclude.very-slow.txt generic/433
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 lkp-skl-d05 6.11.0-rc5-00060-g8101d6e112e2 #1 SMP PREEMPT_DYNAMIC Sat Aug 31 16:44:21 CST 2024

generic/433       - output mismatch (see /lkp/benchmarks/xfstests/results//generic/433.out.bad)
    --- tests/generic/433.out	2024-08-26 19:09:50.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/433.out.bad	2024-08-31 09:35:24.724294098 +0000
    @@ -4,14 +4,17 @@
     ab56b4d92b40713acc5af89985d4b786  TEST_DIR/test-433/file
     ab56b4d92b40713acc5af89985d4b786  TEST_DIR/test-433/copy
     Swap beginning and end of original file
    +/smbv3/cifs/sdb1/test-433/copy - differ: char 1, line 1
     md5sums after swapping beginning and end:
     ab56b4d92b40713acc5af89985d4b786  TEST_DIR/test-433/file
    -32db1f6d06d15f7e38e1ab1c69da498a  TEST_DIR/test-433/copy
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/433.out /lkp/benchmarks/xfstests/results//generic/433.out.bad'  to see the entire diff)
Ran: generic/433
Failures: generic/433
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240903/202409031003.eda2be98-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

