Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B266118
	for <linux-cifs@vger.kernel.org>; Wed, 27 Dec 2023 08:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W2bNF+Mk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703664307; x=1735200307;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=kyjEBzvx9YFayLPP2onKKxUPlsXK/764AYQFEwG7YP8=;
  b=W2bNF+MkCPfW7WoLa0lNI9max3gVM3ZVPTKp3PYXa612qFopv7uFz01/
   zExAnFSXiLGszwmy1Btnyq9uLi7Yo/ZxCQhlfIYK2wIFlFwCC0rFDpJQu
   dKf+am4jOmOyf06mZJHfMLJpwNeKLw2pbWuT0/oT6ew9I4o2wP9Hv+7+6
   B2en6YdZz+Vl3UPZa1XA5iRjKRyrgl+KzDeJ+lW8NidlaPxkDe1dYSbUn
   ioD2MWu9bh4gPNrpWgqVmtLl4AWUrMZacWRQcz+d04mcF3bay2bp0fe/i
   3YNBIxPl6QyB5q1DC8NMkI8YmPEZsnYLb5BmwYFrJCfFMf6zGH7Rb3cmK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10935"; a="381398066"
X-IronPort-AV: E=Sophos;i="6.04,308,1695711600"; 
   d="scan'208";a="381398066"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2023 00:05:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10935"; a="778179403"
X-IronPort-AV: E=Sophos;i="6.04,308,1695711600"; 
   d="scan'208";a="778179403"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Dec 2023 00:04:53 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Dec 2023 00:04:50 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Dec 2023 00:04:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Dec 2023 00:04:48 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Dec 2023 00:04:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PRakdRGK+P0A38ju8NmmtueXtEQH55MSvRTmpiHEe+fxKt8qi92C12P0S5XrxFAB/3KpZWr4b1kCRWyApKjhSZi0skNjTrBGeolrC470vmuwvMGGub4dc1owopnU2g3774bgiZYh3lOgX+aZy419DmcGW01bTYSALCVSBArWzmDvV8/CfBPioUBlo8SIdMpgFCB2R+xb7JFD8Ix6if6gtuYNZM+nrdFjS4bzzZ5xUqUkGRBIKVLD1gllToe/vgpAVWP24YFS/n5T+vnnx/oh3tJtGnhk/EVCH74a8d3S6TSqkFxAE791YHZDeenmdqLD+Rklk/OAAjGWl3a3hXEzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7Du+x8yGUSSjRtH4FxTaGKLcarSrSYIv4E939awZ/s=;
 b=IRmJUpwV1MgB6BSNz7cCFlQANrSh8Kv0VW7F/A8s1ogcovjTdk3bMfZYikrhNFG7aZO8OrJZKB0VwwaRjlwL/WFm2YjtwosahkLqHNCN+1cpynlO83cxSm4S3SM1GNkDLGGIu7AaGbn6NxRRMMIBErm7iVX12OCfXlrgKOhJIUVZIXJpy+fl/otaa/C3TsHQC0Vknmsb+21QOWKheNsrY5Cfx6zDcTnQ0ydZDvmvJ93+kvCv7xI8jmH9Kk9j3MbgmfcVD/gSpR9LpFMoIlQM945aZpZ1bhaF4rd9rGYVKH0lX6WKUGFQngzDKUHcxjdc5GHrHau8+1dDoqxpnooq1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB5663.namprd11.prod.outlook.com (2603:10b6:a03:3bc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.27; Wed, 27 Dec
 2023 08:04:45 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::1236:9a2e:5acd:a7f%3]) with mapi id 15.20.7113.027; Wed, 27 Dec 2023
 08:04:44 +0000
Date: Wed, 27 Dec 2023 16:04:35 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Steve French <stfrench@microsoft.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, Xiaoli Feng <xifeng@redhat.com>,
	<ying.huang@intel.com>, <feng.tang@intel.com>, <fengwei.yin@intel.com>,
	<oliver.sang@intel.com>
Subject: [cifs:for-next-next] [smb3]  29ed7da631:  filebench.sum_operations/s
 18.8% improvement
Message-ID: <202312271513.cd04d453-oliver.sang@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0049.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::13) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB5663:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a559f0-0731-4f93-be0e-08dc06b27cb0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0k5bI3MSwyq91K9fz7dTXmV42+24bLRLJIEaea1+D4V0FLWqZQYos9VNobVFT7CCcWYG8XOLqQL8q4xh8r952RMxlsNmUYzZ1QX+aAy8sjSh7oIr3xkinjuK+uEwmutXHHB8diYcvSs0hhYOdInkT7yYpo8cQAWXaj73Wnd5/MeFAU6t7otqMxY1CS/TaHYd5fWuYIRB60lC8RWxhwm4rWA1JNXcyWtAI0adZh3GAw9MgQ819Y8tUafXeX086Q3qQdp38RFdPeT51C8w0cf7lOZMi7OB2nSMFJZ60eFKyYQnW075PGbkLZEwrXm2ku93vO79CDe/lgPAL2yWlyGWhOvkBZRvytVRofvTvcQHOrNhnbpc40IxVid4/36rPnExmmfwlYc5Y8W8kNCOuSPAwKzqVchlKCXhdOHtP/13D+DMxMPY79j9sz/b5Vui++wEAi4MqkGgdLTpecUMTxh/lq1wv0M2CAXLc6Sgxi4Xx6jA78GJk5n6bzPzDIyXtZvRtfWLiiEqe1S1X/ZGLWigB0iGli+GFNXv7TiTpLxCBv3AljIVUvYqwOXI4XS0QEBf0Myha7yLJLLL+FOl53K6poKp6PR3P63muT6mMzOLMwwAYw546Ic3s9Y53WjchMx2iDBd97ifKgPT6gcxzN4hsMJqy10h/Wt5wo5VTEbF4+s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(346002)(39860400002)(396003)(230473577357003)(230173577357003)(230273577357003)(230373577357003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(8936002)(8676002)(6506007)(6512007)(6666004)(4326008)(5660300002)(2906002)(30864003)(6486002)(478600001)(966005)(66476007)(6916009)(66556008)(66946007)(316002)(38100700002)(41300700001)(86362001)(36756003)(82960400001)(1076003)(2616005)(26005)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?nblSTTgZvO8fPAqA0gQ/IeZ2muE2VwC6aRunm3gi6XSXhXUFp3OBjAk2LF?=
 =?iso-8859-1?Q?3uzq+ZxKQFs7Xzt+nbL+ivioB13iLAabC3TlGp2k5UHHD4mpywoy0eVEqA?=
 =?iso-8859-1?Q?+yfQgOxsdecDIz/BuFr00m9ZY4/EMIjz+HsHUuKxQS3fd7RXHGLtUoae2E?=
 =?iso-8859-1?Q?2UwnT6yLAzZ793S+HfVhb6jyZ2j3ggb3JgNXj1YnLTaab4LQF0SeNukdWD?=
 =?iso-8859-1?Q?7r+nuh45sw2AMFx5qjE/kyPuLUV+j+2PmdD7Z8LdY6kuujG0hQZyZauOVt?=
 =?iso-8859-1?Q?Z7zwHwyXgA1TYzOYqvG28Keash619hBrWjAxcdOK19e5bnZ6f/EDGMn3nr?=
 =?iso-8859-1?Q?RwUrHFQWTvlAnj/WksqtbnwQbkf9UoX342RDD2YSoQikxh93o2E8fsE5/u?=
 =?iso-8859-1?Q?E0MiFLeoSduk8uNeFkhkzGMtckByy5yCSqD8r+nqG6NSpFtOz5I16+VwM6?=
 =?iso-8859-1?Q?k6VUEbCkTth+XUew6C8bVTN6kvo1zVl9rjn1Z39OzsmvJV8sMyb8nok735?=
 =?iso-8859-1?Q?QExekZIGHIHkfjdGxJMl+pcCFUhgfQXPGYbCCYUfCuE5yBWdo4CaSEOwZQ?=
 =?iso-8859-1?Q?luTRAq2f4AH+5cX8zaxceNP3WTpoHM8drUCIDYW8qv0Lvot7vwS+x8THL9?=
 =?iso-8859-1?Q?fQ6i8BeLDm1CW+/c2Ys8XFAKhc/39AcmMA1uaM+TlEvsbKjGqMvliYcHRk?=
 =?iso-8859-1?Q?W93K0NK9L+jJX0VJKxjzE6Of+kHXrtoW4GvchokPOMYl98EREdCQteJU7z?=
 =?iso-8859-1?Q?69JJpV1qP/+kGBfy52inVZg6jProANcCfzDxBnLcC0apcHOJNGKUnR8YFt?=
 =?iso-8859-1?Q?l3SHTMwICwU6Hsk6LPWpYwY/SPLlGx8dBMe/qAROEZbyf5LtwjoTDIzrIu?=
 =?iso-8859-1?Q?p8gFfukilhiXjXM+gLR7/nTCxCoElmWyUalz5RGvqWqvl1bHfUsidZLaJe?=
 =?iso-8859-1?Q?HKgAGfj+chZiewDiMkrrxBTsLmK1ndeEvySilisw6fm5wwesPlz8UvLRsY?=
 =?iso-8859-1?Q?+dEcmsij9SFhM+B1HrI+oFvk0jp3N/r0EEYRkV7fn1p6yldmN9ZigDEgfl?=
 =?iso-8859-1?Q?ok4Sx7CQcFN2hyFx8DfodaGcBsKDjA7AVa1mUA89/LYgDppxNahAjW0BJH?=
 =?iso-8859-1?Q?OvLRM2IdMUr33CC363YMAb/hQManSJVTP7/B8of93/Ti8yINzb1M9M0vlb?=
 =?iso-8859-1?Q?uT7YVylLnbB1bG69IQyhMj6D6mopxKqNrJjde/6D4H7XwdsQzfPzvaD1uU?=
 =?iso-8859-1?Q?gkMoyJilEliCUp+8ZndqhmuFSDz8rETz0yhqjCHPRCkRZW2rJMJEhct2Bb?=
 =?iso-8859-1?Q?22w8yQXRpNx7SK/hh4niSy9vRPXHWlCaWqjkRNwrrroln9YUQ+WJFSAUIk?=
 =?iso-8859-1?Q?WE9pVDOXNSYYFST8H2DG4bv45x+ERroUfxawjxh/AuX0Dnj63nreWpgnVc?=
 =?iso-8859-1?Q?SQTLI6kkacBSAbO4Y6OmZ4JoDVVbnPaquqnbsXNjLpColrIRFvgYDr9U4Q?=
 =?iso-8859-1?Q?uBY8qZf2a+SJ5Pc6XoqvWmICZGozSbbFO6RZYBM3CnK6CkjD7U9af9drrb?=
 =?iso-8859-1?Q?pu3OrjC1mhODfcNku1RpG5FWcBuxA79kjeAh5etvEhvdO0j7Q8NQTH4EJT?=
 =?iso-8859-1?Q?Kot2DDRKetBC95wqBj/lAlO7lt/v4T1KeJ5Ze1/8G4uC0SeuIABoKpFg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a559f0-0731-4f93-be0e-08dc06b27cb0
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2023 08:04:44.9077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ufw77Vmn6DTSt0AEZPfxW8+C9VeqolNNyTASR0Q0NvU5qBtcsYqX4votKLuoNQCvtl6Y/zRH+zjJFUSYsbgO0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5663
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 18.8% improvement of filebench.sum_operations/s on:


commit: 29ed7da6313fc6048b9a60c75aae44fc8f6ddbab ("smb3: allow files to be created with backslash in name")
git://git.samba.org/sfrench/cifs-2.6.git for-next-next

testcase: filebench
test machine: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
parameters:

	disk: 1HDD
	fs: ext4
	fs2: cifs
	test: fileserver.f
	cpufreq_governor: performance


In addition to that, the commit also has significant impact on the following tests:

+------------------+------------------------------------------------------------------------------------------------+
| testcase: change | filebench: filebench.sum_operations/s 45.9% improvement                                        |
| test machine     | 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory |
| test parameters  | cpufreq_governor=performance                                                                   |
|                  | disk=1HDD                                                                                      |
|                  | fs2=cifs                                                                                       |
|                  | fs=xfs                                                                                         |
|                  | test=webserver.f                                                                               |
+------------------+------------------------------------------------------------------------------------------------+




Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20231227/202312271513.cd04d453-oliver.sang@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-12/performance/1HDD/cifs/ext4/x86_64-rhel-8.3/debian-11.1-x86_64-20220510.cgz/lkp-icl-2sp6/fileserver.f/filebench

commit: 
  54f95f4e6f ("smb: client: Fix minor whitespace errors and warnings")
  29ed7da631 ("smb3: allow files to be created with backslash in name")

54f95f4e6ff76fa3 29ed7da6313fc6048b9a60c75aa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    421.00 ±  4%     +10.0%     463.00 ±  6%  perf-c2c.HITM.local
     32.70 ±  4%     -11.5%      28.93 ±  4%  vmstat.procs.r
     50682            +7.4%      54452        vmstat.system.cs
     72.78            +2.9%      74.91        iostat.cpu.idle
      1.17            +4.0%       1.22 ±  3%  iostat.cpu.iowait
     25.69            -8.6%      23.48        iostat.cpu.system
      0.10            +0.0        0.11        mpstat.cpu.all.soft%
     24.28            -2.5       21.80        mpstat.cpu.all.sys%
      0.36            +0.0        0.40        mpstat.cpu.all.usr%
      3136            -1.2%       3099        turbostat.Bzy_MHz
      6.19            +0.5        6.66        turbostat.C1E%
    298.22            -1.9%     292.51        turbostat.PkgWatt
    108.62           +19.2%     129.50        filebench.sum_bytes_mb/s
    275222           +18.8%     326951        filebench.sum_operations
      4586           +18.8%       5448        filebench.sum_operations/s
    417.00           +18.8%     495.33        filebench.sum_reads/s
     10.89           -15.8%       9.17        filebench.sum_time_ms/op
    834.17           +18.8%     991.00        filebench.sum_writes/s
   9095557           +15.1%   10466277        filebench.time.file_system_outputs
      9077            -8.2%       8336        filebench.time.involuntary_context_switches
      2140            -6.9%       1993        filebench.time.percent_of_cpu_this_job_got
      1453            -6.7%       1355        filebench.time.system_time
    545023           +11.9%     609623        filebench.time.voluntary_context_switches
     27722            +4.6%      29007        proc-vmstat.nr_active_anon
     51938            -6.2%      48695        proc-vmstat.nr_active_file
   2259798           +14.9%    2596743        proc-vmstat.nr_dirtied
    169458            +6.1%     179785        proc-vmstat.nr_dirty
   1133821            +1.8%    1154179        proc-vmstat.nr_file_pages
    317423            +7.0%     339622        proc-vmstat.nr_inactive_file
     44201            +3.3%      45644        proc-vmstat.nr_shmem
   1530949           +12.0%    1715152        proc-vmstat.nr_written
     27722            +4.6%      29007        proc-vmstat.nr_zone_active_anon
     51938            -6.2%      48695        proc-vmstat.nr_zone_active_file
    317423            +7.0%     339622        proc-vmstat.nr_zone_inactive_file
    168178            +6.2%     178558        proc-vmstat.nr_zone_write_pending
   4020254            +9.6%    4404885        proc-vmstat.numa_hit
   3884880            +9.9%    4270577        proc-vmstat.numa_local
   6063917            +9.1%    6613855        proc-vmstat.pgalloc_normal
   5868547            +9.2%    6405878        proc-vmstat.pgfree
      3.21 ±  4%     -20.8%       2.54 ± 21%  perf-sched.sch_delay.avg.ms.__cond_resched.dput.cifsFileInfo_put_final._cifsFileInfo_put.process_one_work
      0.00 ±152%   +1776.2%       0.07 ±163%  perf-sched.sch_delay.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.04 ± 26%     +72.2%       0.07 ± 17%  perf-sched.sch_delay.avg.ms.__cond_resched.stop_one_cpu.migrate_task_to.task_numa_migrate.isra
      0.30 ±105%     -78.0%       0.07 ± 20%  perf-sched.sch_delay.avg.ms.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
      0.02 ±  3%     -13.4%       0.02 ±  2%  perf-sched.sch_delay.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      0.35 ±  9%     -42.7%       0.20 ± 12%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.01 ±148%   +2277.1%       0.14 ±194%  perf-sched.sch_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    219.43 ±123%     -93.7%      13.89 ±147%  perf-sched.sch_delay.max.ms.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
     12.64 ± 15%     -27.7%       9.14 ± 13%  perf-sched.sch_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     21.79 ± 21%     -57.8%       9.20 ±100%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc.cifs_do_create.isra.0
      0.15 ±  3%     -11.6%       0.13 ±  7%  perf-sched.wait_and_delay.avg.ms.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
      0.10 ±  8%     -12.7%       0.08 ±  4%  perf-sched.wait_and_delay.avg.ms.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      0.16           -12.9%       0.14        perf-sched.wait_and_delay.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      6.77 ±  2%     -11.3%       6.00        perf-sched.wait_and_delay.avg.ms.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_open
      0.70 ±  4%     +18.0%       0.83 ±  5%  perf-sched.wait_and_delay.avg.ms.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_read
      6.12 ±  4%     -18.7%       4.97 ± 14%  perf-sched.wait_and_delay.avg.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_unlink
    881.17 ±  6%     -37.5%     551.17 ±  8%  perf-sched.wait_and_delay.count.__cond_resched.__flush_work.isra.0.__cancel_work_timer
      2525           +29.8%       3277 ±  2%  perf-sched.wait_and_delay.count.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
    933.50 ±  4%     +27.6%       1190 ±  5%  perf-sched.wait_and_delay.count.__lock_sock.lock_sock_nested.tcp_sendmsg.sock_sendmsg
      1383 ±  2%     +18.9%       1645 ±  3%  perf-sched.wait_and_delay.count.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
      3776 ±  2%     +31.6%       4971        perf-sched.wait_and_delay.count.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      5344           +19.1%       6367 ±  2%  perf-sched.wait_and_delay.count.io_schedule.folio_wait_bit_common.folio_wait_writeback.__filemap_fdatawait_range
      4272 ±  5%     +15.3%       4926 ±  3%  perf-sched.wait_and_delay.count.schedule_preempt_disabled.__mutex_lock.constprop.0.compound_send_recv
      1659           +16.7%       1937        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.do_unlinkat
      1649           +16.3%       1918        perf-sched.wait_and_delay.count.schedule_preempt_disabled.rwsem_down_write_slowpath.down_write.open_last_lookups
     29390           +11.1%      32658        perf-sched.wait_and_delay.count.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      2032           +16.8%       2374        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.cifs_send_recv.query_info
     11622           +14.3%      13279        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
      2034           +16.6%       2372        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.smb2_compound_op.smb2_unlink
    157.95 ±  9%     -16.6%     131.81 ±  8%  perf-sched.wait_and_delay.max.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
     21.18 ± 21%     -22.2%      16.48 ± 12%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc.cifs_do_create.isra.0
      0.11 ±  4%     -14.5%       0.09 ±  4%  perf-sched.wait_time.avg.ms.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
      0.08 ±  6%     -10.8%       0.07 ±  3%  perf-sched.wait_time.avg.ms.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
      0.13           -13.0%       0.12        perf-sched.wait_time.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      6.66           -11.4%       5.90        perf-sched.wait_time.avg.ms.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_open
      0.64 ±  3%     +19.8%       0.76 ±  5%  perf-sched.wait_time.avg.ms.wait_for_response.compound_send_recv.cifs_send_recv.SMB2_read
      6.02 ±  4%     -18.8%       4.89 ± 15%  perf-sched.wait_time.avg.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_unlink
      5.96 ± 11%     -25.4%       4.44 ± 11%  perf-sched.wait_time.max.ms.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
    157.85 ±  9%     -16.6%     131.67 ±  8%  perf-sched.wait_time.max.ms.wait_for_response.compound_send_recv.smb2_compound_op.smb2_query_path_info
      0.63           +11.6%       0.71 ±  4%  perf-stat.i.MPKI
 5.193e+09            -6.7%  4.846e+09        perf-stat.i.branch-instructions
      0.74            +0.1        0.82 ±  2%  perf-stat.i.branch-miss-rate%
  29430000            +5.6%   31068143        perf-stat.i.branch-misses
      6.26            -0.2        6.10        perf-stat.i.cache-miss-rate%
  12345040            +7.8%   13312743        perf-stat.i.cache-misses
  1.96e+08           +10.3%  2.163e+08        perf-stat.i.cache-references
     52474            +7.7%      56494        perf-stat.i.context-switches
      4.88            -4.7%       4.65        perf-stat.i.cpi
 1.096e+11            -8.8%      1e+11        perf-stat.i.cpu-cycles
      1654            +6.0%       1752        perf-stat.i.cpu-migrations
      8628           -15.4%       7303 ±  2%  perf-stat.i.cycles-between-cache-misses
      0.13 ±  3%      +0.0        0.14        perf-stat.i.dTLB-load-miss-rate%
   5020142 ±  2%     +13.8%    5711312        perf-stat.i.dTLB-load-misses
    462535            +8.1%     500225        perf-stat.i.dTLB-store-misses
  1.24e+09           +13.6%  1.409e+09        perf-stat.i.dTLB-stores
  2.13e+10            -3.7%   2.05e+10        perf-stat.i.instructions
      0.86            -8.8%       0.78        perf-stat.i.metric.GHz
     91.83            -1.7%      90.27        perf-stat.i.metric.M/sec
   2029913 ±  2%      +8.6%    2204401 ±  5%  perf-stat.i.node-load-misses
   2736286            +9.3%    2991129 ±  2%  perf-stat.i.node-stores
      0.58           +12.1%       0.65        perf-stat.overall.MPKI
      0.56            +0.1        0.64        perf-stat.overall.branch-miss-rate%
      6.32            -0.2        6.17        perf-stat.overall.cache-miss-rate%
      5.16            -5.3%       4.88        perf-stat.overall.cpi
      8920           -15.5%       7538        perf-stat.overall.cycles-between-cache-misses
      0.10 ±  2%      +0.0        0.11        perf-stat.overall.dTLB-load-miss-rate%
      0.04            -0.0        0.04        perf-stat.overall.dTLB-store-miss-rate%
      0.19            +5.6%       0.20        perf-stat.overall.ipc
 5.143e+09            -6.8%  4.792e+09        perf-stat.ps.branch-instructions
  28981289            +5.6%   30608098        perf-stat.ps.branch-misses
  12187330            +7.8%   13136296        perf-stat.ps.cache-misses
  1.93e+08           +10.4%  2.131e+08        perf-stat.ps.cache-references
     51715            +7.7%      55685        perf-stat.ps.context-switches
 1.087e+11            -8.9%  9.901e+10        perf-stat.ps.cpu-cycles
      1637            +5.8%       1733        perf-stat.ps.cpu-migrations
   4939197 ±  2%     +13.9%    5624080        perf-stat.ps.dTLB-load-misses
    454820            +8.2%     492327        perf-stat.ps.dTLB-store-misses
 1.224e+09           +13.6%  1.391e+09        perf-stat.ps.dTLB-stores
 2.108e+10            -3.9%  2.027e+10        perf-stat.ps.instructions
   2009213 ±  2%      +8.4%    2178707 ±  5%  perf-stat.ps.node-load-misses
   2688455            +9.5%    2943088 ±  2%  perf-stat.ps.node-stores
 1.444e+12            -3.8%  1.388e+12        perf-stat.total.instructions
      5.12 ± 21%      -3.0        2.10 ± 39%  perf-profile.calltrace.cycles-pp.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      3.74 ± 20%      -2.7        1.04 ± 52%  perf-profile.calltrace.cycles-pp.filemap_map_pages.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault
      5.65 ± 22%      -2.7        3.00 ± 55%  perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      3.97 ± 18%      -2.6        1.40 ± 57%  perf-profile.calltrace.cycles-pp.do_read_fault.do_fault.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      5.52 ± 20%      -2.5        3.06 ± 16%  perf-profile.calltrace.cycles-pp.__libc_fork
      5.65 ± 22%      -2.4        3.21 ± 48%  perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault
      4.78 ± 22%      -1.9        2.84 ± 32%  perf-profile.calltrace.cycles-pp.exit_mm.do_exit.do_group_exit.__x64_sys_exit_group.do_syscall_64
      2.46 ± 45%      -1.9        0.52 ± 79%  perf-profile.calltrace.cycles-pp.next_uptodate_folio.filemap_map_pages.do_read_fault.do_fault.__handle_mm_fault
      4.29 ± 22%      -1.9        2.37 ± 30%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__libc_fork
      4.29 ± 22%      -1.9        2.37 ± 30%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_fork
      4.29 ± 22%      -1.9        2.37 ± 30%  perf-profile.calltrace.cycles-pp.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_fork
      4.29 ± 22%      -1.9        2.37 ± 30%  perf-profile.calltrace.cycles-pp.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe.__libc_fork
      3.42 ± 29%      -1.9        1.56 ± 59%  perf-profile.calltrace.cycles-pp.exit_mmap.__mmput.exit_mm.do_exit.do_group_exit
      3.75 ± 22%      -1.8        1.92 ± 44%  perf-profile.calltrace.cycles-pp.copy_process.kernel_clone.__do_sys_clone.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.84 ± 33%      -1.8        1.04 ± 69%  perf-profile.calltrace.cycles-pp.dup_mm.copy_process.kernel_clone.__do_sys_clone.do_syscall_64
      3.31 ± 29%      -1.7        1.56 ± 59%  perf-profile.calltrace.cycles-pp.__mmput.exit_mm.do_exit.do_group_exit.__x64_sys_exit_group
      3.18 ±  5%      -0.4        2.75 ± 11%  perf-profile.calltrace.cycles-pp.record__mmap_read_evlist.__cmd_record.cmd_record.run_builtin.main
      3.18 ±  5%      -0.4        2.75 ± 11%  perf-profile.calltrace.cycles-pp.perf_mmap__push.record__mmap_read_evlist.__cmd_record.cmd_record.run_builtin
      0.23 ±141%      +0.7        0.95 ± 50%  perf-profile.calltrace.cycles-pp.proc_task_name.proc_pid_status.proc_single_show.seq_read_iter.seq_read
      9.40 ± 18%      -4.2        5.21 ± 34%  perf-profile.children.cycles-pp.do_user_addr_fault
      9.40 ± 18%      -4.0        5.42 ± 30%  perf-profile.children.cycles-pp.exc_page_fault
      5.12 ± 21%      -3.0        2.11 ± 39%  perf-profile.children.cycles-pp.do_fault
      5.82 ± 19%      -2.9        2.92 ± 54%  perf-profile.children.cycles-pp.__mmput
      3.85 ± 22%      -2.8        1.04 ± 52%  perf-profile.children.cycles-pp.filemap_map_pages
      5.58 ± 20%      -2.8        2.83 ± 59%  perf-profile.children.cycles-pp.exit_mmap
      3.97 ± 18%      -2.6        1.40 ± 57%  perf-profile.children.cycles-pp.do_read_fault
      5.55 ± 18%      -2.5        3.06 ± 16%  perf-profile.children.cycles-pp.__libc_fork
      5.12 ± 22%      -2.3        2.84 ± 32%  perf-profile.children.cycles-pp.exit_mm
      5.68 ± 33%      -2.1        3.62 ± 27%  perf-profile.children.cycles-pp.__schedule
      4.29 ± 22%      -1.9        2.37 ± 30%  perf-profile.children.cycles-pp.__do_sys_clone
      4.29 ± 22%      -1.9        2.37 ± 30%  perf-profile.children.cycles-pp.kernel_clone
      3.75 ± 22%      -1.8        1.92 ± 44%  perf-profile.children.cycles-pp.copy_process
      2.34 ± 41%      -1.8        0.52 ± 79%  perf-profile.children.cycles-pp.next_uptodate_folio
      2.84 ± 33%      -1.8        1.04 ± 69%  perf-profile.children.cycles-pp.dup_mm
      1.01 ± 48%      -0.7        0.30 ±100%  perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.90 ± 34%      -0.6        0.29 ±100%  perf-profile.children.cycles-pp.mtree_range_walk
      3.18 ±  5%      -0.4        2.75 ± 11%  perf-profile.children.cycles-pp.record__mmap_read_evlist
      3.18 ±  5%      -0.4        2.75 ± 11%  perf-profile.children.cycles-pp.perf_mmap__push
      0.23 ±141%      +0.7        0.95 ± 50%  perf-profile.children.cycles-pp.proc_task_name
      5.69 ± 31%      +2.4        8.08 ± 11%  perf-profile.children.cycles-pp.seq_read_iter
     63.77 ±  9%      +8.5       72.28 ±  4%  perf-profile.children.cycles-pp.do_syscall_64
     63.77 ±  9%      +8.6       72.41 ±  4%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      1.88 ± 53%      -1.4        0.52 ± 79%  perf-profile.self.cycles-pp.next_uptodate_folio
      0.90 ± 34%      -0.6        0.29 ±100%  perf-profile.self.cycles-pp.mtree_range_walk


***************************************************************************************************
lkp-icl-2sp6: 128 threads 2 sockets Intel(R) Xeon(R) Platinum 8358 CPU @ 2.60GHz (Ice Lake) with 128G memory
=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-12/performance/1HDD/cifs/xfs/x86_64-rhel-8.3/debian-11.1-x86_64-20220510.cgz/lkp-icl-2sp6/webserver.f/filebench

commit: 
  54f95f4e6f ("smb: client: Fix minor whitespace errors and warnings")
  29ed7da631 ("smb3: allow files to be created with backslash in name")

54f95f4e6ff76fa3 29ed7da6313fc6048b9a60c75aa 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    324.60 ±  6%     -10.2%     291.63 ±  2%  sched_debug.cfs_rq:/.runnable_avg.stddev
    322.59 ±  6%      -9.9%     290.68 ±  2%  sched_debug.cfs_rq:/.util_avg.stddev
      4227 ± 10%     +22.7%       5187 ±  7%  vmstat.io.bo
     24086           +20.7%      29072 ±  3%  vmstat.system.cs
    107057 ±  9%     +43.7%     153891 ±  6%  meminfo.Dirty
    102405 ±  4%     +46.5%     149992        meminfo.FileHugePages
    326524 ±  3%     +42.8%     466341        meminfo.Inactive(file)
     47288 ± 25%     +45.5%      68805 ± 12%  numa-meminfo.node0.Dirty
    137726 ± 30%     +55.3%     213928 ± 20%  numa-meminfo.node0.Inactive(file)
     59597 ± 22%     +43.2%      85366 ± 10%  numa-meminfo.node1.Dirty
    560238           +17.2%     656377        turbostat.C1E
      1.17            +0.1        1.24        turbostat.C1E%
     12032 ± 11%     +41.4%      17014 ± 12%  turbostat.POLL
     11823 ± 25%     +45.6%      17216 ± 12%  numa-vmstat.node0.nr_dirty
     34433 ± 30%     +55.4%      53497 ± 20%  numa-vmstat.node0.nr_inactive_file
     34433 ± 30%     +55.4%      53497 ± 20%  numa-vmstat.node0.nr_zone_inactive_file
     11995 ± 26%     +45.3%      17432 ± 12%  numa-vmstat.node0.nr_zone_write_pending
     14904 ± 22%     +43.3%      21350 ± 10%  numa-vmstat.node1.nr_dirty
     15299 ± 22%     +42.3%      21763 ± 10%  numa-vmstat.node1.nr_zone_write_pending
    137.92           +45.8%     201.12        filebench.sum_bytes_mb/s
   1650593           +45.9%    2407494        filebench.sum_operations
     27507           +45.9%      40122        filebench.sum_operations/s
      8873           +45.9%      12942        filebench.sum_reads/s
      3.61           -31.4%       2.48        filebench.sum_time_ms/op
    888.17           +45.8%       1295        filebench.sum_writes/s
    845794           +44.1%    1218541        filebench.time.file_system_outputs
     86085 ±  2%      +8.4%      93282 ±  4%  filebench.time.minor_page_faults
    482544           +26.9%     612318 ±  4%  filebench.time.voluntary_context_switches
     29.97 ±  9%      -5.7       24.28 ± 15%  perf-profile.calltrace.cycles-pp.perf_release.__fput.task_work_run.do_exit.do_group_exit
     29.97 ±  9%      -5.7       24.28 ± 15%  perf-profile.calltrace.cycles-pp.perf_event_release_kernel.perf_release.__fput.task_work_run.do_exit
      1.45 ± 27%      -1.1        0.37 ±102%  perf-profile.calltrace.cycles-pp.__d_lookup_rcu.lookup_fast.open_last_lookups.path_openat.do_filp_open
      0.26 ±141%      +0.9        1.15 ± 52%  perf-profile.calltrace.cycles-pp.proc_task_name.proc_pid_status.proc_single_show.seq_read_iter.seq_read
     29.97 ±  9%      -5.7       24.28 ± 15%  perf-profile.children.cycles-pp.perf_release
     29.97 ±  9%      -5.7       24.28 ± 15%  perf-profile.children.cycles-pp.perf_event_release_kernel
      1.84 ± 33%      -1.3        0.50 ±119%  perf-profile.children.cycles-pp.__d_lookup_rcu
      2.25 ± 28%      -1.3        0.94 ± 89%  perf-profile.children.cycles-pp.intel_idle_irq
      1.73 ± 39%      -1.2        0.48 ±116%  perf-profile.children.cycles-pp.__split_vma
      0.26 ±141%      +0.9        1.15 ± 52%  perf-profile.children.cycles-pp.proc_task_name
      1.84 ± 33%      -1.3        0.50 ±119%  perf-profile.self.cycles-pp.__d_lookup_rcu
      1.44 ± 40%      -0.9        0.51 ± 73%  perf-profile.self.cycles-pp.intel_idle_irq
      1.47 ± 54%      +1.1        2.57 ± 20%  perf-profile.self.cycles-pp._raw_spin_lock
     23688            +4.3%      24697        proc-vmstat.nr_active_anon
    211445           +44.1%     304619        proc-vmstat.nr_dirtied
     26739 ±  9%     +43.9%      38482 ±  6%  proc-vmstat.nr_dirty
    848497            +4.3%     884801        proc-vmstat.nr_file_pages
     81638 ±  3%     +42.8%     116595        proc-vmstat.nr_inactive_file
     42477            +3.1%      43810        proc-vmstat.nr_shmem
    175170 ±  3%     +35.8%     237820 ±  3%  proc-vmstat.nr_written
     23688            +4.3%      24697        proc-vmstat.nr_zone_active_anon
     81638 ±  3%     +42.8%     116595        proc-vmstat.nr_zone_inactive_file
     27275 ±  9%     +43.4%      39120 ±  6%  proc-vmstat.nr_zone_write_pending
    847032            +6.9%     905154        proc-vmstat.numa_hit
    711333            +8.4%     771356        proc-vmstat.numa_local
     61861            +2.4%      63333        proc-vmstat.pgactivate
   1439695           +11.1%    1599027        proc-vmstat.pgalloc_normal
   1249954 ±  2%     +12.4%    1405256        proc-vmstat.pgfree
    278966 ± 10%     +23.1%     343274 ±  7%  proc-vmstat.pgpgout
      0.34 ±  6%     -40.5%       0.20 ± 24%  perf-sched.sch_delay.avg.ms.futex_wait_queue.__futex_wait.futex_wait.do_futex
      0.04 ± 28%     -57.8%       0.02 ± 45%  perf-sched.sch_delay.avg.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
      0.02 ± 25%     -44.4%       0.01 ± 37%  perf-sched.sch_delay.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      1.13 ± 52%     -48.4%       0.58 ± 11%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
    345.04 ±  6%     -20.3%     275.00 ± 14%  perf-sched.sch_delay.max.ms.futex_wait_queue.__futex_wait.futex_wait.do_futex
    211.37 ± 43%     -67.7%      68.37 ± 77%  perf-sched.sch_delay.max.ms.schedule_hrtimeout_range_clock.ep_poll.do_epoll_wait.__x64_sys_epoll_wait
    312.80 ±  9%     -26.3%     230.55 ± 17%  perf-sched.sch_delay.max.ms.wait_for_response.compound_send_recv.cifs_send_recv.query_info
     20.18 ±  2%     -13.0%      17.56 ±  7%  perf-sched.total_wait_and_delay.average.ms
     64102           +17.2%      75124 ±  5%  perf-sched.total_wait_and_delay.count.ms
     19.80 ±  2%     -12.7%      17.28 ±  7%  perf-sched.total_wait_time.average.ms
      0.17 ± 56%     -55.9%       0.07 ± 14%  perf-sched.wait_and_delay.avg.ms.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
      0.39 ±  6%     -38.4%       0.24 ± 20%  perf-sched.wait_and_delay.avg.ms.futex_wait_queue.__futex_wait.futex_wait.do_futex
      0.52 ±  6%     -14.8%       0.44 ±  2%  perf-sched.wait_and_delay.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
    531.50 ± 11%     +94.8%       1035 ± 16%  perf-sched.wait_and_delay.count.__lock_sock.sk_wait_data.tcp_recvmsg_locked.tcp_recvmsg
    495.50 ± 11%     -55.8%     219.17 ±100%  perf-sched.wait_and_delay.count.cifs_wait_bit_killable.__wait_on_bit_lock.out_of_line_wait_on_bit_lock.cifs_revalidate_mapping
      9.67 ± 48%    +110.3%      20.33 ± 17%  perf-sched.wait_and_delay.count.io_schedule.rq_qos_wait.wbt_wait.__rq_qos_throttle
     34.83 ±  6%     +37.3%      47.83 ± 18%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.do_poll.constprop.0.do_sys_poll
      9312 ±  5%     +14.9%      10702 ±  3%  perf-sched.wait_and_delay.count.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      4316           +46.7%       6333        perf-sched.wait_and_delay.count.wait_for_response.compound_send_recv.cifs_send_recv.query_info
    363.37 ± 10%     -23.8%     276.88 ± 13%  perf-sched.wait_and_delay.max.ms.futex_wait_queue.__futex_wait.futex_wait.do_futex
      1504 ± 14%     +33.1%       2003        perf-sched.wait_and_delay.max.ms.pipe_read.vfs_read.ksys_read.do_syscall_64
      0.14 ± 36%     -50.8%       0.07 ± 15%  perf-sched.wait_time.avg.ms.__lock_sock.lock_sock_nested.tcp_recvmsg.inet6_recvmsg
      0.04 ±  8%     -21.4%       0.03 ±  5%  perf-sched.wait_time.avg.ms.futex_wait_queue.__futex_wait.futex_wait.do_futex
      0.02 ± 12%     +43.5%       0.02 ± 19%  perf-sched.wait_time.avg.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.compound_send_recv
      0.50 ±  5%     -13.4%       0.43 ±  2%  perf-sched.wait_time.avg.ms.schedule_timeout.wait_woken.sk_wait_data.tcp_recvmsg_locked
      0.44 ± 38%     +94.3%       0.86 ± 30%  perf-sched.wait_time.max.ms.__lock_sock.lock_sock_nested.tcp_sock_set_cork.__smb_send_rqst
      0.28 ± 30%    +397.5%       1.41 ± 69%  perf-sched.wait_time.max.ms.schedule_preempt_disabled.__mutex_lock.constprop.0.compound_send_recv
      0.19 ±  2%     +24.1%       0.24 ± 11%  perf-stat.i.MPKI
 8.285e+09            -1.9%   8.13e+09        perf-stat.i.branch-instructions
   5693586 ±  2%     +21.0%    6890289        perf-stat.i.cache-misses
  43522169           +16.9%   50865574 ±  2%  perf-stat.i.cache-references
     24767           +21.1%      29984 ±  3%  perf-stat.i.context-switches
    252.79           +10.0%     278.09 ±  3%  perf-stat.i.cpu-migrations
     59997 ±  2%     -18.8%      48703 ±  2%  perf-stat.i.cycles-between-cache-misses
 8.121e+09            +2.1%  8.292e+09        perf-stat.i.dTLB-loads
  9.31e+08           +19.2%   1.11e+09        perf-stat.i.dTLB-stores
    300.38           +16.6%     350.14 ±  2%  perf-stat.i.metric.K/sec
   1118594 ±  2%     +20.8%    1351232        perf-stat.i.node-load-misses
    227414 ±  5%     +18.4%     269333 ±  3%  perf-stat.i.node-loads
    458563 ±  2%     +24.9%     572925        perf-stat.i.node-store-misses
   1007667 ±  4%     +21.4%    1222862 ±  2%  perf-stat.i.node-stores
      0.17 ±  2%     +21.9%       0.20        perf-stat.overall.MPKI
     56414 ±  2%     -18.4%      46044        perf-stat.overall.cycles-between-cache-misses
      0.02            -0.0        0.01 ±  2%  perf-stat.overall.dTLB-store-miss-rate%
 8.205e+09            -2.0%  8.042e+09        perf-stat.ps.branch-instructions
   5523801 ±  2%     +21.8%    6730244        perf-stat.ps.cache-misses
  41259525           +18.6%   48943300 ±  2%  perf-stat.ps.cache-references
     24329           +21.3%      29518 ±  3%  perf-stat.ps.context-switches
    240.48           +11.3%     267.76 ±  3%  perf-stat.ps.cpu-migrations
 8.038e+09            +2.0%  8.198e+09        perf-stat.ps.dTLB-loads
  9.15e+08           +19.5%  1.093e+09        perf-stat.ps.dTLB-stores
   1099551 ±  2%     +21.1%    1331752        perf-stat.ps.node-load-misses
    221785 ±  5%     +19.3%     264529 ±  3%  perf-stat.ps.node-loads
    448003 ±  2%     +25.6%     562873        perf-stat.ps.node-store-misses
    936984 ±  4%     +23.7%    1159370 ±  2%  perf-stat.ps.node-stores





Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

