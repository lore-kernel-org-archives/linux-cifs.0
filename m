Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A497DA7D;
	Sun, 22 Sep 2024 09:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726998301; cv=fail; b=jvowWvKP+Mv+fEbuQZtZzmx2i1U3uVZQAY+EiEVmg+2c5W3CPhmS4j/rVNbHH8u3z1WSrJL/vYs2EJMb66tRPm2QdksdeiwYsOLYwPRhYTcq5T1/XtTQY5HE+wJ10gMk+64J6fymfcYwzgCAWMauoDqX03F6ABvQ8fjYfVjXBc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726998301; c=relaxed/simple;
	bh=lxZkTtos/7MWu8vzdHV7rdTZcYXkC2OV3XPF/LyD5XI=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=LAw2JwcWDeeTDNBL7fBxkrH9Tf6DeVkEPcWKJyz+lCCoQqaN5j8jpBN5WUC6iJEoVguY8gy8jKqNEQM36P++Lr2Rejx9GBnaNKzh+usZhtcNGNHiWRuouqGofuGYNH6rzwehlvxI+7FmpOGHTDWk71hJY9Yq9U/8LaBjekmuEqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JUITEQ6S; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JUITEQ6S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726998299; x=1758534299;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=lxZkTtos/7MWu8vzdHV7rdTZcYXkC2OV3XPF/LyD5XI=;
  b=JUITEQ6Sn905/U/iF5DmsAxqBqRCb1f+DqNN6ISHql7OlyEjgzXUZimB
   jKppcsCpXl55Z7kYHKkPz20yBU3qalUMJgtbksxtG6c0FwQRhPNvBm2ox
   VUld0zIzK4XmejUNloprENZ833Ac3kAgRcK0oorI9IB73wMIfjMEOwxth
   V5NZ+j1gQxCRwDYKoMqfbs3MXmtgsoaxyEiiS2Jcg/qBJE+NENHQ0+vpF
   Pg5eKz//mNTe1lkS/hBmNvqOYYo+AcfCujiiukSmTK53zrQAHT1TPK2Hc
   SX2IDrdNMJUK9b/59ExRCvLvgf0PUM+fSgfvN2XVSU2WBCMTfrl+5JhRy
   A==;
X-CSE-ConnectionGUID: L6+G0KmiR9CaN9fHXWQ2JQ==
X-CSE-MsgGUID: cJH15qSoQwicT34ZTWL4Tg==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="25902107"
X-IronPort-AV: E=Sophos;i="6.10,249,1719903600"; 
   d="scan'208";a="25902107"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2024 02:44:58 -0700
X-CSE-ConnectionGUID: NnSz2+/xSHqbkSsUt4hP3w==
X-CSE-MsgGUID: 5rk2sCKGToSEcX49Thc/Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,249,1719903600"; 
   d="scan'208";a="71600939"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Sep 2024 02:44:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 22 Sep 2024 02:44:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 22 Sep 2024 02:44:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 22 Sep 2024 02:44:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C7N4mQVdhA1JElXUvL/cwNhLNubbLiOkKgq5EoNcBv0XJwa4DXDzxXBTWQkB9vVdpbSSSvTyhepSzeZsAOT/xSS5rxgpC/grKSPe4VrqCh7qO+UyRtaOh/hLDYYNHm/XqAK8mjkXcNSSsUXALwYYbbZTNGq71MnebSOskmW+bPbPA0ymb73Pc4cFmet6Lq2zIubDSsXgfiYUqHqOImkBg+UUixhcJv8Zybqg8Lb33GtT+VDV2fePOHuyhGaG2VQ7oO/6Smdtvl7tYa4UPfdOWJ/S252+FSroUTx3Jo7d63l7E191HEBsS+IzS3WK30ksjY4FTYaZFvZXGMlxn3FQmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjLn2rN7lgMTz+BTH7m9hTYlXr6Ygk9w5K3rvDjc1qM=;
 b=b2tKWfCKK+HMHfdc1I7/VaRsSR681ArUczGG1UTeiXTAyowyNoKIMPDUdoQgCDH3yMu3iT6VmmcTfg0kZba927Kj7W9ayWDagX6dvLZ2GjVUyQmtf2g2UtMDMlhyST51CSwk3asASIdmE6jHgHuZzRFt+vju8uC/544YpbAwXRU/IkRcXN+M+a+yUTISIMA6uUSJe5ZzPwYjp97GM6UA+rSvdVlQRFpbbxyv+pGJTms+jYAoH9dPCR68LNZv0k4BSfIchPirlOqyPRjIri02eNNm2V6OGfzfJ6Lld57t0udX94TNb/tSg2Ju2YAGgbHPaa33gp9cjTjKV6V5BItL4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW4PR11MB5934.namprd11.prod.outlook.com (2603:10b6:303:189::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.24; Sun, 22 Sep
 2024 09:44:55 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.7982.022; Sun, 22 Sep 2024
 09:44:55 +0000
Date: Sun, 22 Sep 2024 17:44:46 +0800
From: kernel test robot <oliver.sang@intel.com>
To: David Howells <dhowells@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, Steve French
	<stfrench@microsoft.com>, Paulo Alcantara <pc@manguebit.com>, "Christian
 Brauner" <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<oliver.sang@intel.com>
Subject: [linus:master] [cifs]  43a64bd02f: xfstests.generic.465.fail
Message-ID: <202409221711.b537f7a8-oliver.sang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: TYCP301CA0044.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:380::6) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW4PR11MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f5d143-fae4-4bac-208c-08dcdaeb36f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2anRbA8UPWk8CoK0d6r1zW18PU+HJ1NYxKtEXONi7jEGC0j5GRlZ3p3jnf9M?=
 =?us-ascii?Q?esT565/aUZ1T+zn0npwMhQreRw7o26zSYax9RW+eK3fdfZLxLCwsfHp5INvE?=
 =?us-ascii?Q?d8NkRXiyYJ0DgtI4WlR3PfjdJ+1nVVWHwCQbABPW8pRmY8SjxfNW1DXdFWNS?=
 =?us-ascii?Q?Jrrg1W/wuSc6IfE5r3+Itwmjeci3RKQPq54evNzZd1OoWWfq6qCtTADzkejj?=
 =?us-ascii?Q?4oNV+f2MQ0hiuIIPLXz7FWqwwdzgir9abs/Hcz1IZ0dqPoC1eOFMqr9drglj?=
 =?us-ascii?Q?wJtyqLez3eiOwHlo94iAVI/tvouywkFdNFAGwx/Rj3hf8oDANErCuqxQ21hC?=
 =?us-ascii?Q?PNHRJZJ5HokhikueWK9yHFKhsBbLDnxmBI/wPezRV/GfVsBfpEsQtuAyKroI?=
 =?us-ascii?Q?/j9bkbVcZ9tKgSrj4kWpys1VRi7cpADER1LwyTJy68yNCUpneW7bnKK9F6sh?=
 =?us-ascii?Q?g10mc4iZG49GFDLvevm1tQ3PNC1LyONr/bz/2FfS687g+ZIS/WrxrrCHUGwd?=
 =?us-ascii?Q?vt5f5czCTsFtor+Z1XMzUmxTVfZHGu03XlmQwKiJsHb+NBm6TKmLQrKPLla6?=
 =?us-ascii?Q?Wg8zJADN1QfI3Bd55eAX0PEZyxWlv6EclmDWA5DJLw3KyzudLlw+jX5qlEll?=
 =?us-ascii?Q?AKSOoZfwbWM+JweauBK5QlCPWOyKOVCiZNfUNLL8+o5nJRCdZb9f1dTfBwnL?=
 =?us-ascii?Q?GsA5SX/4K+6CHZ9X/i168VBVjplBPdPYmAZRSbxSyjQKTPkHUNoZUejX/n1u?=
 =?us-ascii?Q?K1eKcmGgs1NmFpwYlHwy0msiqSMmn8modnvOIbrOb4awk/Jly/33ZTwZV05J?=
 =?us-ascii?Q?fiN0u3xoCeaUf9m66yi2DE6ceIbtCQpEU2Jz6HDnhhD97osrVKhnj3HFElwK?=
 =?us-ascii?Q?AjKwuV5lb07hh+MgtY4uiBxxDQ9sn30wH2gcIR89EOkvW4u9DeDqR9YfoSkl?=
 =?us-ascii?Q?rhGZaHk5NnrghJwfoHQLGYMw3kpS3xoey8N80BGt/LXRB1pDR8t88bwOmFJx?=
 =?us-ascii?Q?/ZgUmFfv9WB09R1urcjAz1CxCOSwfRWIyVj9H6iX/iCpNAv5CH6nv8OmIFRV?=
 =?us-ascii?Q?2BSGwtF7d/CK80IWpXO1V4Kg5KlYSpj6ot8bBWD8hBRCq+q9tF0sk4W6AD3P?=
 =?us-ascii?Q?jopb73jq0u8dJgT44rrd/1xLBj/xCeegUgE/zgEyocyOAfcv4impUFWvQEX0?=
 =?us-ascii?Q?7zN/4W0oh+UTNtzIyc53e9I4iQTeJ7GGvqAqm3GpukWxYCIBgI0dQhG4SwNc?=
 =?us-ascii?Q?YB4U0M/mAEAZ2DKPl3j0TiWI8rKFZ5dIBCmlqKkl+4apYqMq1Oep8NMhH557?=
 =?us-ascii?Q?kSc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SfIXauI+ryHWO+Yz1V0WUeVG5+xNhqIF7fziUYqOvWn9va5aTrFOJW31vsi9?=
 =?us-ascii?Q?1RV79Q6MtQRb/0WN/YRWAIpWNQpqgk/x9ZlNUxjmUaMajE9+OPfdR8GWBgCv?=
 =?us-ascii?Q?QEySvEwVMY3Jeo/kFAYSZk7a+u18AyNeifQwuc99CmICrnhepqP1Lzy8+/fJ?=
 =?us-ascii?Q?IjohEjZrja9QK1nYUN3yQYh9zCWpOIZtcp0YEV4R/7MefVdP+VXdhPyIUVSV?=
 =?us-ascii?Q?bbNhcddpTypkmUm5YQwjidj7rEFUgNhD3tOTSFlBzyNU5NNV/a4zzBah8CLe?=
 =?us-ascii?Q?UVPJm4EzIWEodolq6AIbZxcEAQu+rQisVKH5Fyf8mBFvof49TSkgv4pl5t/s?=
 =?us-ascii?Q?tBthNod4t7jvRvBX/8FDyTuVhuY4P1iwhexUTUaWgMDFOfK+cqszMzDpGcIt?=
 =?us-ascii?Q?5v1gLwk55ARAA9XTqC9WmdP9sNdZz/yrkt1praNqzhjpnJTIwqft5St0j3a2?=
 =?us-ascii?Q?fBaKgKwME88QLzw4O6UrHIHyai2fEajP0O75mZvSmBg+QtGvy9yfLqX6tkVi?=
 =?us-ascii?Q?6J9XUlWu3pmzUDDl5wtH9E98ZHlZDtq1rO2qBz4xPZzbPEV5GhRNrJGcHV5l?=
 =?us-ascii?Q?lQkaQcO8uvKVx5dOW3dSyhMp6WrY1zJK3HBx7TLYkV2Y2LqvggHMb8GHRclX?=
 =?us-ascii?Q?SpzqndYukPr4uxKg7nPi3VUsP9tXF/IGN/ZnGCRV9+nHTx2g1YdtD0iUhx32?=
 =?us-ascii?Q?LqjWVoN31pHu0JXPyTkoggMfnYVKzJIOI4yhZMN4puceAVbK4za6YO2mMgKB?=
 =?us-ascii?Q?TnzZ7vsUSJQINpignNQBdA7TnUMtUAjHjg2oPrno+IMDJPv4iQScbE3HJJZ2?=
 =?us-ascii?Q?S38afb6ZBPksHwBGrmOenhzHIZYl8x/RPA+ziZWEmQpCMy07CzABPajvANS8?=
 =?us-ascii?Q?8QEKizKhN0kclJgS5kDpFzYz3ifCuh00Mll0iZPOnxTMMinutXS3rqNoxm3u?=
 =?us-ascii?Q?ZWUfVkBuSKqTLOiuvgZxZuBBji1/NjEnQ+j87L3dTVG0j/V9miMAkALxISeg?=
 =?us-ascii?Q?6DsZphG69As3NR1oQm0TBIcoursYaYq6jgS9fSCfoCkOF3SfkV2ZEoCEETOf?=
 =?us-ascii?Q?6mjiJp/dL0Rc1+6/f2R6lPjaZlbYNfhKLUjTrIbUiXUaBoEai2Ga9QcOc3rC?=
 =?us-ascii?Q?HrvVt0qol3wXLGnHvK/od6tKwLNpzS92kCBBmbxMh6nF+8OWWMx7LQq95dX6?=
 =?us-ascii?Q?DcloIJB+2wuxAvrwxhZs2FCIzTr4PXY2QN3/PrnH1r5Ektt0Yd8Jq6PDwYa0?=
 =?us-ascii?Q?Aoru7uq/wP3MSqo9/gQUPThJetoaEIbrjLo5ZjCYcTnrU5pnW9dwHtFBFLap?=
 =?us-ascii?Q?onV2w3KNP68gUR+aAX6UHjPSwqxzLmIYlowLTWxz9r5xwBTX0+VL6DsW7rK2?=
 =?us-ascii?Q?+oBsSrWeDsC6yhZuvfJAk+6FM3lB5CbaZETc7qnLYu/jmc4mjeoAu4VP2eBD?=
 =?us-ascii?Q?R/2FqKuemSyWWqWSqd1n+8C0NvObkt4Qrnjwf8R7k6Roz1V67vfTBrRF1KyD?=
 =?us-ascii?Q?bfFOJzotLWzSvLjQbU+Wt7aOOjfixCmRABg38yW4zVqW0AGH4uP29SltdMt+?=
 =?us-ascii?Q?AX8KMBclaMMkS5Y9xC22fLAvAr/+xxYQVN+DXMwk5bYxqlzYcrDl/PMqb7QF?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f5d143-fae4-4bac-208c-08dcdaeb36f5
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 09:44:55.4758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Qg2spghJaVbujIEGdy7Rs/TEBc6S/IQCsCa+m/dQleezswiJaKm2aRAtWA59HntI4qTvIuoRkd/4BGEDmiH9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5934
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "xfstests.generic.465.fail" on:

commit: 43a64bd02f9369be02c4c9312fc0965f78f65ad5 ("cifs: Remove redundant setting of NETFS_SREQ_HIT_EOF")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      1868f9d0260e9afaf7c6436d14923ae12eaea465]
[test failed on linux-next/master 62f92d634458a1e308bb699986b9147a6d670457]

in testcase: xfstests
version: xfstests-x86_64-b1465280-1_20240909
with following parameters:

	disk: 4HDD
	fs: ext4
	fs2: smbv2
	test: generic-465



compiler: gcc-12
test machine: 4 threads Intel(R) Core(TM) i5-6500 CPU @ 3.20GHz (Skylake) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202409221711.b537f7a8-oliver.sang@intel.com

2024-09-21 00:52:25 mount /dev/sdb1 /fs/sdb1
2024-09-21 00:52:25 mkdir -p /smbv2//cifs/sdb1
2024-09-21 00:52:25 export FSTYP=cifs
2024-09-21 00:52:25 export TEST_DEV=//localhost/fs/sdb1
2024-09-21 00:52:25 export TEST_DIR=/smbv2//cifs/sdb1
2024-09-21 00:52:25 export CIFS_MOUNT_OPTIONS=-ousername=root,password=pass,noperm,vers=2.0,mfsymlinks,actimeo=0
2024-09-21 00:52:25 echo generic/465
2024-09-21 00:52:25 ./check -E tests/cifs/exclude.incompatible-smb2.txt -E tests/cifs/exclude.very-slow.txt generic/465
FSTYP         -- cifs
PLATFORM      -- Linux/x86_64 lkp-skl-d05 6.11.0-02522-g43a64bd02f93 #1 SMP PREEMPT_DYNAMIC Fri Sep 20 15:09:41 CST 2024

generic/465       - output mismatch (see /lkp/benchmarks/xfstests/results//generic/465.out.bad)
    --- tests/generic/465.out	2024-09-09 16:31:23.000000000 +0000
    +++ /lkp/benchmarks/xfstests/results//generic/465.out.bad	2024-09-21 00:52:29.101923154 +0000
    @@ -1,3 +1,22 @@
     QA output created by 465
     non-aio dio test
    +read file: Cannot allocate memory
    +read file: Cannot allocate memory
    +read file: Cannot allocate memory
    +read file: Cannot allocate memory
    +read file: Cannot allocate memory
    ...
    (Run 'diff -u /lkp/benchmarks/xfstests/tests/generic/465.out /lkp/benchmarks/xfstests/results//generic/465.out.bad'  to see the entire diff)
Ran: generic/465
Failures: generic/465
Failed 1 of 1 tests




The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240922/202409221711.b537f7a8-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

