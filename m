Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5451C20A5F3
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 13:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776864719; cv=fail; b=pHEc0Gs615fdIWI5TjLqsDIYQ3mfjVoYcK6mnk3VszwvYIM1AUHWSs8lC1pMXJzYVEJ0QACIe/BrXHqCQddrt0l51n2NTcSDThcRkNgQWGOIVzwKtkYm5WMnvUQGRn0HqlKKlUKxuu7sQc8+gceHoavu/NRup/B56GMqkn3xKtM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776864719; c=relaxed/simple;
	bh=krC7EjcJMxT3h/nOjUa2JwoMtuC9vkXOUsR3vfPnms0=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=WE4pQAUl79x2x8hK4MXtqKhVq2gwSBrD1YAUThtadmADqFjTe99q3F64eRGzemrwKK/yYEXwsvEhh53BOns/4p3OWA4XXYDi90wY7W8JjJp7snbGcklyflf7zbmnwHPh7XjdB6z3f99UosDUW7ZBPTACMkh0jdwh6JaAX8THL/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h6Xpe2Qq; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h6Xpe2Qq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776864717; x=1808400717;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=krC7EjcJMxT3h/nOjUa2JwoMtuC9vkXOUsR3vfPnms0=;
  b=h6Xpe2QqwAZwAG4WRf6grAQPfaq4cc3S0uFjFahmkHgN4erb1McC7aH3
   0dCxCQ4h1QRrhvD+g5nmXEL59NiH8MS9eZmlXEEccdgY/QaFmuyiaeQJ/
   eHh/CQTPY9mEwI+03VFgcPIJ/haBUO0QrOu6nLPMWsVPvo/DWwqY5JQeQ
   ncqSgdLwvODmf7pYvLa0kQeGDlJDLNB0aO9Rl7Agi337kbqkmXn70E6ce
   5EeJuS0WhIjLTKO9R4b2ZhlPXP1iTlAXcaSDWa4csmn8CAKymz5LXMYZS
   MoS1GEKMrlHu6R7bE/YUSV3bOoLg4wLIbGJeoWMcSZ6IHDtzutkdiqHgg
   Q==;
X-CSE-ConnectionGUID: V1BQADkxS12o89+AC3mp4w==
X-CSE-MsgGUID: gsuMc28hQf6E/BdZuXZJkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="95378315"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="95378315"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 06:31:56 -0700
X-CSE-ConnectionGUID: i9eNVQBUR+mkibG8lC3gkg==
X-CSE-MsgGUID: K/SJU8MxREGoyA5HwX6vaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="237394134"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 06:31:56 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 06:31:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 06:31:55 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.23) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 06:31:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+0RD1nYhnUMfXiowohql0+t74lfWxFZllqNNxDzeSC5K5EC1sIQGqE7BsoOm6UjOLUEUpvgOxfFqa0YiQkjav5dpZWD90g9pxIbVwHT0W6m1Ewb4ZOqei+eBLQp4i+ABWfyp2/sdhOMrEBcww+VBw6R+vXQe3eB7TpsgeFc9YxKveeyiAOrSvG5S1qCacM9aeHcVKq9ea1tjLXm+nJumjqKODJ5MYcutfzzgbusqUsW1jYUT80TYUYA4Gcpq1v1EkqfaXOmhwQRuigUB3PQCQoxbmu4XJYjzyAq8Dcwv+INTc1yCGcYbjf3BgKd/E6VzZaKjXq1136wtgst96tw9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GQgB9aYA3q5L737KtuxUEVQl1o54XTam9b6jRCjgrVg=;
 b=YAt3l0FU4+niXEkGINpskpKEZ+DCe/6W7wkG8sBL4vkf5nCArTu19Py8eGIdGvgj8njlDBSoBq+AZiki4Qgir/Qo0g0nLQBfUagTEdRQOe+d0CgVf1W2d/Vmz6WMT7ZXHUVtZH7e73TXx6EsvaUFHGiIMisZv2jUq8zKEEe7uiSPYRxNQ/JnEiu0X8iTqWtn73Kk1IfqgZPtgIs6MisfLyr82CINVHpgJ8qLvOUAMpLPWly50mADW4OcuoRyyW+FrbznQdNr3z+FY5Myv3pHv8wXsj2HV6XLh/yRRB6Gd23QtGBnIv1EKgjafaR5HnRvCqg2uZh2/klHwsHUFMjneA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by LV0PR11MB9816.namprd11.prod.outlook.com (2603:10b6:408:383::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Wed, 22 Apr
 2026 13:31:52 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9846.011; Wed, 22 Apr 2026
 13:31:52 +0000
Date: Wed, 22 Apr 2026 21:31:45 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Paulo Alcantara <pc@manguebit.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Steve French
	<stfrench@microsoft.com>, ChenXiaoSong <chenxiaosong@kylinos.cn>, "David
 Howells" <dhowells@redhat.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [smb]  40e75e42f4: filebench.sum_operations/s
 9.5% improvement
Message-ID: <202604211611.9b649c8a-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TPYP295CA0024.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::13) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|LV0PR11MB9816:EE_
X-MS-Office365-Filtering-Correlation-Id: 727a9be0-bd6d-44ca-892c-08dea07383b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: OqbqE66WBhafuSfIJPqg0bG6lYDDNEW9jeURxAdK2McRyIw6Y8r6mRUM4ZeUFS0oLRfg7AKGkF/5ZFOPnwKtG2gqh5Ikl/xZQY8ZV60/1QF+JdqKwxXcfgcE/MmjAy/e4vNZcvImzsfQqIuN+AOE2FE9CWyc1jf3YuLDpCGc1K5asWP4NDNfFQW5FTLFW9bwyS3EV6VIWdoahpSf1FMwnsZLICmPKZUWKrMW1hrpkqPZ/oIscx+3dt8tgPCd76lGTAQXGoKdLt98xfbtb2xNtpmoyhx0qkY5IleFX00Kw3w1lSwx9GxgoNGe6nrtoVQDCZKc0EArCTnXq2c4JfO2l/fyJc5qPhqRgEqST4tnyqY8nYAZjcBgxt34HDl0hvPjxRYO33t6sysSNmN2Gw2XmezPVOmYbQN8b9ieF+QkXTP7WpPoqdT/hUMBNn4NOgYWxiuypp2QMhLfRcUUxvXjtKr2Tlr1oOL1T4IMbtcSCyTRfM+VpVVyJHj7z9aKcHOM4ZKHNCkuNIfUIFXnwCuBA3azOUhhW4lM0QLLA8SUf+gJXBIfZHR4VXIUCcJsJBKNduExudTzZd3VtEHsf7tPfkkPAgY8EjtDIqODiNvzTuViwBJrBpoOqDUFGIy8G1uyBJvPJvcTncS8tbN+qxYsq6WNSzUcIBGteaysLDxpId10tW693m4hxq3YAH8HAuCx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?3wTyQwIxQIqdVxijDicQDpsQsTx63JGB0MhKkx4cmGNQNjWSZGEAXgBap4?=
 =?iso-8859-1?Q?ROAHZ9j8eufzz5by/iK0+q7l4eXdEwSfGrGYItEEmOj9adR9ZEqqc4Bjhz?=
 =?iso-8859-1?Q?i5+pvzXfceGGavxmD4cFHjIM2D4rVtKTXgYrcBpl/tbBz06v3YXnC5C2Y+?=
 =?iso-8859-1?Q?HBiMX3ba7ih5yrHW4NeIHjHGbcdTL0eBEacHJUSMYGU4hQ9PgCE/1zO5EU?=
 =?iso-8859-1?Q?j2VDDBuf4erP/IOeVBVltfp3KmpWmVR1uqFdfc4kgZUCwdjBegBYEv2UUO?=
 =?iso-8859-1?Q?13/K86mrq+5GMAyZMI/6OZxP4yTZnOx9hP7NKxT656Br84AwCSDMbIzbd+?=
 =?iso-8859-1?Q?SmVtlRXK99rHjpkLkBqqCireqAH8eFVbHuJ27+8ObDRS516RfQqa+c0Ihx?=
 =?iso-8859-1?Q?K+pl0DMzuhDHUzyW0MdsBlBabmKFoA7Y4pZnk6Twa2e/S27UxsvyYna5LM?=
 =?iso-8859-1?Q?+jVDa6gJXWyTz+aaea0kaqCRXaSX27k9BbUiL6/ofUZEGxZJlrD1epOmaM?=
 =?iso-8859-1?Q?fE8z1YgJWkAu5f/RPuZ5z7DN9FRd2yhAHJhc4UzQqX1t03uismpwVIEyyj?=
 =?iso-8859-1?Q?t2K6u1PBjVdDDq0sNRGRI5V0mhi5NlO747sWWz9NHJ51t4OpGoV/5cr7V1?=
 =?iso-8859-1?Q?+GYqv6SdmQWsCBzWDmQnlAXZPehY/vBbi033u/zX3aJvcgt+kP4UjGAUQq?=
 =?iso-8859-1?Q?9Jd9CYC2miz1ydaX+CaZDieH4Pyd3WGBNybAJ5RbZWO74jthD2qrcC/G7w?=
 =?iso-8859-1?Q?9HSElafulXLBZKbFMQnT3tfdyEaGbXhZ+yVrZhHf9l67K+Jc8RBXgA1vvz?=
 =?iso-8859-1?Q?o/u3F9K/F4qdCOnoTS8Gbd4Yl2gH0T5pUOS6aTQo+T+3ksDO5qIRqHdyUS?=
 =?iso-8859-1?Q?IyEl16zfIQVE7OWwNLgdi7cRYirpHQCoMAXGaK2EBiMzE+lurqCpZ/R0Qk?=
 =?iso-8859-1?Q?2DecY40erU0v6cNIpdFYv1XMi8YAtA3VjjHzX9zIeceaW5QczA2BHdovvu?=
 =?iso-8859-1?Q?BkyhfumG9Y8Lr8Rldec4fJ/AqWufcbsDgbEyoarfn5+K9VY3DVpJuWOvYW?=
 =?iso-8859-1?Q?gjMqrnnftGi/1BQX9bzWu4bpN/WvcOl6p5DFMOCN5WIQ5G+tPZFSdPOf8w?=
 =?iso-8859-1?Q?7pZMm+MatH/gfc8wROamM1tDOoZODmcdJbEPyCsboxYDeA1dHEtJJH8KMu?=
 =?iso-8859-1?Q?zrVi/BryJlZzdKlQfce8Vm7bfcIsme4zgCafX4uj6gvL0Rl1OCKNmuRDnG?=
 =?iso-8859-1?Q?EH4GtUMSfNBZp3HuqH0kvVt1T3RPe59DbDj/NbT6NCjTw+ffIntSrxJNge?=
 =?iso-8859-1?Q?GVhcdypZbGr9Si1JcAdyn04RgEzVUqU4gz674aAuLN8/eJVtGJevbIlIAP?=
 =?iso-8859-1?Q?cxwbdK2nN5DVUfx5Yyzt+Fy6m4DWjWMA8oM9GuWpxI7c6FNaV5ovV+fw6r?=
 =?iso-8859-1?Q?5CSMBmyBgIyoTT6rDoq/KeuXYJM3zuOa+rHkqc04RXegk1PbJHZLOfF/nR?=
 =?iso-8859-1?Q?j7WD/3W9Ys7pbmBcWatT/MwwJ8BUO3PGUWTYjb/fwd/znE8oSX/xUeM30d?=
 =?iso-8859-1?Q?9wa5Ww3gkglOeDHKE7Bp0uhG1LR3mtDOkbe9sGQ3dwQmXJcz39vTfuS52y?=
 =?iso-8859-1?Q?nMzfDgTY1BFihlY+l8cwe7WUL8LOu5c5HdXxRYffRnc617LvGis+GMoL0k?=
 =?iso-8859-1?Q?2iEM5gs1A5CqBiZlG7fuNkSZBXHqbtyuYyQXycWpG2trphm2AQS2LeW+cX?=
 =?iso-8859-1?Q?GJBnPu3ThwmtD/l2fD160Z4+uPgvvsWox+cVfrRS+elxgOAOpqS6++mTOp?=
 =?iso-8859-1?Q?6LqypWoF8A=3D=3D?=
X-Exchange-RoutingPolicyChecked: meYhwny9rKTb7FJve4IhF+HJdTnFwqsLz9NUgFzbtjB8ZFGYIXF0p9y/froib/mtU4P7IPsZTuFdNhICep3exbXAx5LPlOsGWmn6zjoJ9TY5k7ulbUaZQYXfVjufwniRguswiAbJj8MmZty3Dxa1IdUZrVpHBdiR7s7IOWVe/bOpDBBwMUcPtsxFer8xMmm05Yk7vKc2gHjH8kEbCt5JAjf7LYX4e8UWbxDz7YH4iOvB0cQGbgxZR+tyC//iGz9G8KzAIMX8Qf+0Wsk/5xw/uDBlaKgexLBrYihnVi9n1Dlp5PCoIYd5HTdK3aY/qBZbvOuSE1XPeTnG25HlVn9w6g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 727a9be0-bd6d-44ca-892c-08dea07383b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 13:31:52.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AeDyoHHyfZlWvSu97dFvWtsRklzp/1zWeOhksmRHNmmFowreUcXb9O1UplrnrGO1rZUGRl3P0JFiaGPN2jZ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB9816
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed a 9.5% improvement of filebench.sum_operations/s on:


commit: 40e75e42f49ca54b4ff41f3edb94f5ef0299140c ("smb: client: fix open handle lookup in cifs_open()")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: filebench
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 512 threads 4 sockets Intel(R) Xeon(R) 6768P  CPU @ 2.4GHz (Granite Rapids) with 128G memory
parameters:

	disk: 1SSD
	fs: ext4
	fs2: cifs
	test: webproxy.f
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260421/202604211611.9b649c8a-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/disk/fs2/fs/kconfig/rootfs/tbox_group/test/testcase:
  gcc-14/performance/1SSD/cifs/ext4/x86_64-rhel-9.4/debian-13-x86_64-20250902.cgz/lkp-gnr-4sp2/webproxy.f/filebench

commit: 
  d4c7210d2f ("smb: client: fix iface port assignment in parse_server_interfaces")
  40e75e42f4 ("smb: client: fix open handle lookup in cifs_open()")

d4c7210d2f3ea481 40e75e42f49ca54b4ff41f3edb9 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     11.25            +8.0%      12.15        filebench.sum_bytes_mb/s
    185317            +9.5%     202907        filebench.sum_operations
      3088            +9.5%       3381        filebench.sum_operations/s
    812.33            +9.5%     889.50        filebench.sum_reads/s
     32.28            -8.7%      29.48        filebench.sum_time_ms/op
    162.33            +9.5%     177.83        filebench.sum_writes/s
    450654            +4.1%     468946        filebench.time.file_system_outputs
     65856 ±  2%      -5.4%      62305        filebench.time.minor_page_faults
    100.50           -37.8%      62.50 ±  2%  filebench.time.percent_of_cpu_this_job_got
    181.94           -38.1%     112.56        filebench.time.system_time
    281234            +8.9%     306129        filebench.time.voluntary_context_switches
     12871            +5.7%      13600        vmstat.system.cs
      0.31            -0.1        0.22        mpstat.cpu.all.sys%
     39.00 ± 18%     -97.4%       1.00        mpstat.max_utilization.seconds
      0.16 ± 13%      -0.0        0.11 ± 18%  perf-profile.children.cycles-pp.task_tick_idle
      0.51 ± 29%      +0.5        1.05 ± 58%  perf-profile.children.cycles-pp.hrtimer_try_to_cancel
      0.16 ± 13%      -0.0        0.11 ± 17%  perf-profile.self.cycles-pp.task_tick_idle
     18.00           -18.5%      14.67 ±  3%  turbostat.Avg_MHz
      0.47            -0.1        0.38        turbostat.Busy%
      0.44 ±  3%      +7.9%       0.48        turbostat.CPU%c1
      0.39           +16.8%       0.45        turbostat.IPC
   2624523            -4.0%    2519538        turbostat.IRQ
     77.69 ±  3%      -7.1%      72.19        perf-sched.total_wait_and_delay.average.ms
     74994 ±  2%      +8.4%      81279        perf-sched.total_wait_and_delay.count.ms
     77.37 ±  3%      -7.0%      71.96        perf-sched.total_wait_time.average.ms
     77.69 ±  3%      -7.1%      72.19        perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     74994 ±  2%      +8.4%      81279        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     77.37 ±  3%      -7.0%      71.96        perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
  7.73e+08            -7.5%  7.152e+08        perf-stat.i.branch-instructions
     12690            +5.9%      13433        perf-stat.i.context-switches
 9.481e+09           -18.8%  7.696e+09        perf-stat.i.cpu-cycles
 3.583e+09            -5.4%  3.389e+09        perf-stat.i.instructions
      0.32            +8.1%       0.34        perf-stat.i.ipc
      1.48            +0.1        1.61        perf-stat.overall.branch-miss-rate%
      2.65           -14.2%       2.27        perf-stat.overall.cpi
      3007 ±  6%     -19.1%       2433 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.38           +16.5%       0.44        perf-stat.overall.ipc
 7.704e+08            -7.6%  7.117e+08        perf-stat.ps.branch-instructions
     12637            +5.8%      13364        perf-stat.ps.context-switches
 9.449e+09           -18.9%  7.659e+09        perf-stat.ps.cpu-cycles
  3.57e+09            -5.6%  3.372e+09        perf-stat.ps.instructions
 6.534e+11            -5.5%  6.173e+11        perf-stat.total.instructions




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

