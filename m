Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84D818027;
	Sat,  5 Apr 2025 05:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743831460; cv=fail; b=TJg1L3B9ABjRHgpcy/zwt4WcwPe/y8G6avBZBAGua79aTCRNLG0mUOy2u+QemQzyWFStKQBJmtNBL38L2u0BVSh5SexrdoQkr3aVcT/50IwI4gjuUdnePyJa47V8S1cCFuOQF7oSBHotCRD+ryAOlyh15ZMGHRHwYLkoCKAtYJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743831460; c=relaxed/simple;
	bh=4wG6dTAtUD7DbeHnLO+ihzzs+d3yhXNu5Owyw4bUBPg=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=IwK2N+zybtvR5E8ATe36cL85EZQAJlCFItOYj+q1XpUfWbHey3qnq359bcItxSQs3tcOEwXZbdsZ3LTisN0VcXL4AdXmtnKFEupX2ffHImmqKj+KG7pt17a/oHJ4CcgkTcH2yd76E+zHbLFBcYcbh/+JOY07+f5o4uOQySrBpAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5355aZpH003473;
	Sat, 5 Apr 2025 05:36:35 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2042.outbound.protection.outlook.com [104.47.51.42])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45tug8g4h7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 05 Apr 2025 05:36:35 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i+lGBy8NPDLUle8R1Vfl66HUfXqUp6V4G6NyGaJ5e5gEahgRt5hNHKJxEb7KQ3TQWTgrXENb8qeibPj5q78bCk3EHfAU3HGuBU+3JPq/nKTn04XaarpG5OBV42DOCb5D+wA5zp9VOqyXmBlqeukSBrqwlVfuaR0vUiNm2BL9KPqMt5t+tUIYx0IescuSmD4rHWxGvB10fkQFTt6BxBw29s+TPv+y1WmG8+nq73HAWS7C60WOXngHdvDritOm3DLw4jhtoRS1bUJcdfCQNQEFOHx1VuXnMVjuXUyMenbm/ddv79daKcdduVru+dCtkgjLkTY41/V4oY+F7tvw9Xi/1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ueIe2H70IOArTrG2JqUAna2c5xwag+hPcwGHnefnEc=;
 b=DLo29E4mnySmYdPCap6oroLvnCykd60ee1I/tl8fU8AYALILn8T+hPJn7JTYH1WCm3L1ZUFUnxrR2XFqTgJATuqb/hDUs4qmoh21wICupM+PmO/s6uZAhsqHgaEvLfMo5MeI/4iyV+v+2S+knC8JxJZQXi0WGIsIK8PRiF1M8qKLaZ35XW/xgnimKS9s/MIGiwr9RvdA0end3QUG9MZ/JrZcZsZKU+cro0lF7tF6msQsDDZVD2kxTcvTCw4xdf77cjtJew6Mpn2nWDwNQKuYd1ZHhqWOyhDPnNz619dzYXytbL63DYlTCx/88Ma5+8qfksZODtgoJAbqJDxMZGb8dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB7524.namprd11.prod.outlook.com (2603:10b6:510:281::18)
 by DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.52; Sat, 5 Apr
 2025 05:36:31 +0000
Received: from PH0PR11MB7524.namprd11.prod.outlook.com
 ([fe80::c61b:1595:174b:b95f]) by PH0PR11MB7524.namprd11.prod.outlook.com
 ([fe80::c61b:1595:174b:b95f%5]) with mapi id 15.20.8534.048; Sat, 5 Apr 2025
 05:36:31 +0000
From: He Zhe <zhe.he@windriver.com>
To: stable@vger.kernel.org, zhangxiaoxu5@huawei.com, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        zhe.he@windriver.com
Subject: [PATCH 5.15.y] cifs: Fix UAF in cifs_demultiplex_thread()
Date: Sat,  5 Apr 2025 13:36:11 +0800
Message-Id: <20250405053611.4039379-1-zhe.he@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0156.apcprd04.prod.outlook.com (2603:1096:4::18)
 To PH0PR11MB7524.namprd11.prod.outlook.com (2603:10b6:510:281::18)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7524:EE_|DS0PR11MB8018:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c76be94-7caa-4069-7086-08dd7403d1cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bUk+XUa/4I7E/rhDR/4LpgpiSVHLs7A5c+XNhyBvk+gZZLzYkp2T1xSKXxPr?=
 =?us-ascii?Q?wXOL6lIjVDKDWzYRKUvoNIF75gircx5REv228zzHhw6R2IG2rAcXV/u39CGQ?=
 =?us-ascii?Q?xrgXODnC9eB4URBf2wbWbajMC3eQt5oNL7WJROPwWw18jqQXTtIdO7LGQtqd?=
 =?us-ascii?Q?i7LujpMN33KoBcgVxfjEEWI7rLvEntJpyPjEK81hhTWnSmqFB96i6mlQvyMS?=
 =?us-ascii?Q?o+/LvaukReRisjo9z1PfQHjp71Alynjnh1sXh1zqIrzuKM/BgsZvo7FnXoth?=
 =?us-ascii?Q?YBcX1LVta5CHCeHhBqxjHgxidBkYYSuT+rrtQJvHwP3h6n087DlCluNe3Dwj?=
 =?us-ascii?Q?egdKEGfqLQTrZtDnaNyrb1cY/9u/oHK/IUTDxlrN3pGFNluRonJQdv6GUZBs?=
 =?us-ascii?Q?3QDDyfh44K/S1FKgRXKxseknaXKyzsp0vO7i7VET9775uFDEW5V0IV9EjXcC?=
 =?us-ascii?Q?LfmxRmdMGsjVBFVCMl7OMQ0LKGxu43sSL6jgS/nCdQLLhlp64MV8lPTmW7wN?=
 =?us-ascii?Q?704AgfaixrPX+JjX2FyNXPcQwnarkA4EeeEtBUX9pOrpu7U1ZN5SU6MKvlKg?=
 =?us-ascii?Q?BQZbY12ovSfstJR1TRGErCvmiglmkXq1vjLpgcYhxFOe6LTh5GQyeQp4QdL2?=
 =?us-ascii?Q?stcs2WeurKEPQfsXqx1yyEQ9JO1i/0ry6/l0BMaMxHxlpe83bWoPgLK6KChY?=
 =?us-ascii?Q?Dss1QEm4I9zFLKUmFdBplnbxf0f+g5wQz/np7xoLF74yBfGgofsIQ7HRWD50?=
 =?us-ascii?Q?TYxi8cimBY1XAqL+/esJ2296oN+z2KWkgIPYCkAvRZdv2SCLjMAyWuu8031q?=
 =?us-ascii?Q?2qj0updhpy7+VrfaO7y4b1StL7kBwBwBOmhzQ2q73uMw0nDLVFhyggFWodPC?=
 =?us-ascii?Q?jgknjgsOJsqqxh32PZRar7Rx7VD6CGKPGzXW/l+Q4eW645VeG8nPj7ZoD3VX?=
 =?us-ascii?Q?VQepOWrT/Cd4RnWqPOQe3t58neuV3h9IDry3KjHnq5j/lJz0xpLu+muyz3Dt?=
 =?us-ascii?Q?BOTmYanYlyk6aglVzosqGXVeg43JUObHbPQc2hRyth3IE/lEDcm3hvaPcyeK?=
 =?us-ascii?Q?TyOIOVehR/4UsHBeHxXADqkxNWcG3FE0sIPH9cjuXvejYySsSOdH2i+f1yFN?=
 =?us-ascii?Q?Xm0JTkPQrmLmia/yEF4y6XoIlsQJ4y4kWkJwuJwurEMDqlIfzaaQsKNzVyl3?=
 =?us-ascii?Q?U4LF76PkRGSo0KS61vpqmj8+go+G19SXMpjAf0SHj73Ewlx0T8I7gpcWrBI4?=
 =?us-ascii?Q?9G59i9ejG1R8n57HuJ7z7QLxJxiHIYsO5tXaZw+AWEq3ZYuv/3784hZoUno7?=
 =?us-ascii?Q?yOZV20IP9DtkjtWvzDgy55tU7ZJ/0b9/bz1i5R+ovDfc0j1qTwN1IzbTcct0?=
 =?us-ascii?Q?8IW040cdQfvE9p2RLYy9YesNlllt7NPvuiOIB1UeoX3s06fdzUleZY1B3SBA?=
 =?us-ascii?Q?1Xj4S7KPR8hskHs/uboB/9m5CyUEdqky?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7524.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9I8xA87mMMJjd6dU0ibdUHWZZ4H2j977AeazDBRUJjX40fDg2/73uZDjkmU3?=
 =?us-ascii?Q?Cc56XwsACBJPqlg1mXZ4/bv7YldhsXqQnYKKQhnzetH6EJG9xsOWriBL0HMZ?=
 =?us-ascii?Q?lUnzEWlgVyp+OQViZ929dyZbFIgZDFEEPHA+kVkAfxaf6o1J61tG+iQc5C3u?=
 =?us-ascii?Q?1JwI/RPKaLUNXXjrIRlWoCTPA+Y6AVVyebHjU87/2V3CXvIS8BoUrkn2CxB8?=
 =?us-ascii?Q?XLkcW9gyEie2AShNzVIAdeHpcjIgUIxDBreXHNbMEg5U8s67+L02tNl9Qqi9?=
 =?us-ascii?Q?0mmPmhXEq4DnMCYpcotOo0ipCJIAiSJ/T8DT4VHZkMS6rNg6PCcgL6Kla5X4?=
 =?us-ascii?Q?Wtt8oyGOQBt7CujB+HklVWPDBUY+NmB4dLB+teRgPVsOAsgvGU/TWt5HhFY9?=
 =?us-ascii?Q?D3VgGl8wnZNaQDNpruNKbLQqn1kHTadE8LrvMtqgBnxlrrnaxzeM8iU6pqFS?=
 =?us-ascii?Q?vy/7zjmT0o8l/3EqqETB09XBeBGerYxx2QtMTzrMY7CFGZq22cIIvfrahhJo?=
 =?us-ascii?Q?rIGZKEa7A33ImdEL+WxNTYcgn4g5B1wF7sogIPwq7rTFy7MZNUG7F8HaZRWS?=
 =?us-ascii?Q?L8iY5b0fmklU1LKMaemERzb3Owtbr8EjGAdQYvbNPdFSAD78RwGPxvixbqwJ?=
 =?us-ascii?Q?pClB1uoBCiD4/0DIYgr8dm8XcttxlT3LJoLRlBtOz/vOWk5bX7Jt0nC9mQ/a?=
 =?us-ascii?Q?RajPJ0o2Wo0pFVEhsvPFBWY0/0pRFBtRcAjXXndXeGHCZvEZ0DXsvD6PY9q0?=
 =?us-ascii?Q?rAfOTeS4T0n/vHqKZcuMYumm84/21YK2iuGBSv0PqqOoNo4EsffxWe9Zp5TF?=
 =?us-ascii?Q?14L1HeeaFDT8YeYFqeyvd4zOD6MHYNqgCNlKRIfXGsua+73e2QogyGaQXi4O?=
 =?us-ascii?Q?cyTI2aw6flI1BbywohlGediGcwkjlrugius4gqVhO3HTmjP58kzXDT2PCbV2?=
 =?us-ascii?Q?tEUOX2voBBx7nBw2RiXYo2U/ycy0QcwGtGszZMvQVVogGGDBiRkMpNZVaKCt?=
 =?us-ascii?Q?j25ff3t+ln+JgL3MX+VNaIH19VuzoBMIDXcUis/fO0c76jUniGf7Dnbos4bH?=
 =?us-ascii?Q?bO0I0AFaCunxU1w5Vpgc0yvmlKN32CDLRRbi66v9tlc+sCDnI01KdkCN4VHh?=
 =?us-ascii?Q?8S1KX7BMQP0lH9QD+1QishDgHHpeGJ5MQd4azMtE9H0AermMaTsG4OtcP2tS?=
 =?us-ascii?Q?kiS40JDl7yW9v94yPiTBABz3M/qXMIJ7SGX2EJvXOflwWaCV0uZ+y+kDIi5c?=
 =?us-ascii?Q?e+G9NNijn92UJ3aPOphjWlnFfTGq53P7afERVdSzqCL4sRncIizv2UhIPOU2?=
 =?us-ascii?Q?fkw9X3i6m5CzXKElEw+Vcd/YNGVbUufCAw4mAJwiPC0Qaji4aeeqS9b8Emfl?=
 =?us-ascii?Q?AalLRM0vdlHmikeGq4Cru/mpuTlSaeImRYTXwntyvW8wNcSmwFgvVlNvIdko?=
 =?us-ascii?Q?uQH9XJc0lhMHhjC7ltaKY97xIQrgum7EeZ/8gUZld8XImWzTImHRAozHl9h+?=
 =?us-ascii?Q?dQSJqZLckJSTx6DIL4dy+byj34RWI6mz14mrb7MlPq9L6H7v7R5U8T621EwO?=
 =?us-ascii?Q?DiPyKKGTNzuoLJ0bSpoJpaJn0EMFA+fwOh1XaLGU?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c76be94-7caa-4069-7086-08dd7403d1cf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7524.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2025 05:36:31.2202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgdqvNVY+p2Yg0ST1Q1mqFYNibb5B749EKbcDEzpc94bL0xhGd9D2UIygMruwzdu5gtGMJabNdKCOhskeEPVXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8018
X-Proofpoint-GUID: gIUvOfO70u6oanESvC9vJLl62SRdnIMA
X-Authority-Analysis: v=2.4 cv=YJefyQGx c=1 sm=1 tr=0 ts=67f0c163 cx=c_pps a=x8A/wAfU1CBlff9R7r/2ew==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=i0EeH86SAAAA:8 a=Li1AiuEPAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=I7mb3Kwx7LMPoRuHVzEA:9 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: gIUvOfO70u6oanESvC9vJLl62SRdnIMA
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-05_02,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 mlxscore=0 clxscore=1015 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504050026

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit d527f51331cace562393a8038d870b3e9916686f upstream.

There is a UAF when xfstests on cifs:

  BUG: KASAN: use-after-free in smb2_is_network_name_deleted+0x27/0x160
  Read of size 4 at addr ffff88810103fc08 by task cifsd/923

  CPU: 1 PID: 923 Comm: cifsd Not tainted 6.1.0-rc4+ #45
  ...
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   print_report+0x171/0x472
   kasan_report+0xad/0x130
   kasan_check_range+0x145/0x1a0
   smb2_is_network_name_deleted+0x27/0x160
   cifs_demultiplex_thread.cold+0x172/0x5a4
   kthread+0x165/0x1a0
   ret_from_fork+0x1f/0x30
   </TASK>

  Allocated by task 923:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   __kasan_slab_alloc+0x54/0x60
   kmem_cache_alloc+0x147/0x320
   mempool_alloc+0xe1/0x260
   cifs_small_buf_get+0x24/0x60
   allocate_buffers+0xa1/0x1c0
   cifs_demultiplex_thread+0x199/0x10d0
   kthread+0x165/0x1a0
   ret_from_fork+0x1f/0x30

  Freed by task 921:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   kasan_save_free_info+0x2a/0x40
   ____kasan_slab_free+0x143/0x1b0
   kmem_cache_free+0xe3/0x4d0
   cifs_small_buf_release+0x29/0x90
   SMB2_negotiate+0x8b7/0x1c60
   smb2_negotiate+0x51/0x70
   cifs_negotiate_protocol+0xf0/0x160
   cifs_get_smb_ses+0x5fa/0x13c0
   mount_get_conns+0x7a/0x750
   cifs_mount+0x103/0xd00
   cifs_smb3_do_mount+0x1dd/0xcb0
   smb3_get_tree+0x1d5/0x300
   vfs_get_tree+0x41/0xf0
   path_mount+0x9b3/0xdd0
   __x64_sys_mount+0x190/0x1d0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

The UAF is because:

 mount(pid: 921)               | cifsd(pid: 923)
-------------------------------|-------------------------------
                               | cifs_demultiplex_thread
SMB2_negotiate                 |
 cifs_send_recv                |
  compound_send_recv           |
   smb_send_rqst               |
    wait_for_response          |
     wait_event_state      [1] |
                               |  standard_receive3
                               |   cifs_handle_standard
                               |    handle_mid
                               |     mid->resp_buf = buf;  [2]
                               |     dequeue_mid           [3]
     KILL the process      [4] |
    resp_iov[i].iov_base = buf |
 free_rsp_buf              [5] |
                               |   is_network_name_deleted [6]
                               |   callback

1. After send request to server, wait the response until
    mid->mid_state != SUBMITTED;
2. Receive response from server, and set it to mid;
3. Set the mid state to RECEIVED;
4. Kill the process, the mid state already RECEIVED, get 0;
5. Handle and release the negotiate response;
6. UAF.

It can be easily reproduce with add some delay in [3] - [6].

Only sync call has the problem since async call's callback is
executed in cifsd process.

Add an extra state to mark the mid state to READY before wakeup the
waitter, then it can get the resp safely.

Fixes: ec637e3ffb6b ("[CIFS] Avoid extra large buffer allocation (and memcpy) in cifs_readpages")
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[fs/cifs was moved to fs/smb/client since
38c8a9a52082 ("smb: move client and server files to common directory fs/smb").
We apply the patch to fs/cifs with some minor context changes.]
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
---
Build test passed.
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/transport.c | 34 +++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2ee67a27020d..8bd5d528244e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1719,6 +1719,7 @@ static inline bool is_retryable_error(int error)
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
+#define   MID_RESPONSE_READY 0x40 /* ready for other process handle the rsp */
 
 /* Flags */
 #define   MID_WAIT_CANCELLED	 1 /* Cancelled while waiting for response */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 49b7edbe3497..8cf12c106afa 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -34,6 +34,8 @@
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
 {
+	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+		mid->mid_state = MID_RESPONSE_READY;
 	wake_up_process(mid->callback_data);
 }
 
@@ -86,7 +88,8 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
 	struct TCP_Server_Info *server = midEntry->server;
 
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
-	    midEntry->mid_state == MID_RESPONSE_RECEIVED &&
+	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
+	     midEntry->mid_state == MID_RESPONSE_READY) &&
 	    server->ops->handle_cancelled_mid)
 		server->ops->handle_cancelled_mid(midEntry, server);
 
@@ -762,7 +765,8 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	int error;
 
 	error = wait_event_freezekillable_unsafe(server->response_q,
-				    midQ->mid_state != MID_REQUEST_SUBMITTED);
+				    midQ->mid_state != MID_REQUEST_SUBMITTED &&
+				    midQ->mid_state != MID_RESPONSE_RECEIVED);
 	if (error < 0)
 		return -ERESTARTSYS;
 
@@ -914,7 +918,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 
 	spin_lock(&GlobalMid_Lock);
 	switch (mid->mid_state) {
-	case MID_RESPONSE_RECEIVED:
+	case MID_RESPONSE_READY:
 		spin_unlock(&GlobalMid_Lock);
 		return rc;
 	case MID_RETRY_NEEDED:
@@ -1013,6 +1017,9 @@ cifs_compound_callback(struct mid_q_entry *mid)
 	credits.instance = server->reconnect_instance;
 
 	add_credits(server, &credits, mid->optype);
+
+	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+		mid->mid_state = MID_RESPONSE_READY;
 }
 
 static void
@@ -1204,7 +1211,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&GlobalMid_Lock);
 			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
-			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
+			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
+			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
@@ -1225,7 +1233,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		}
 
 		if (!midQ[i]->resp_buf ||
-		    midQ[i]->mid_state != MID_RESPONSE_RECEIVED) {
+		    midQ[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
@@ -1404,7 +1412,8 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_cancel(server, &rqst, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
+		    midQ->mid_state == MID_RESPONSE_RECEIVED) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
@@ -1421,7 +1430,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	if (!midQ->resp_buf || !out_buf ||
-	    midQ->mid_state != MID_RESPONSE_RECEIVED) {
+	    midQ->mid_state != MID_RESPONSE_READY) {
 		rc = -EIO;
 		cifs_server_dbg(VFS, "Bad MID state?\n");
 		goto out;
@@ -1541,13 +1550,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* Wait for a reply - allow signals to interrupt. */
 	rc = wait_event_interruptible(server->response_q,
-		(!(midQ->mid_state == MID_REQUEST_SUBMITTED)) ||
+		(!(midQ->mid_state == MID_REQUEST_SUBMITTED ||
+		   midQ->mid_state == MID_RESPONSE_RECEIVED)) ||
 		((server->tcpStatus != CifsGood) &&
 		 (server->tcpStatus != CifsNew)));
 
 	/* Were we interrupted by a signal ? */
 	if ((rc == -ERESTARTSYS) &&
-		(midQ->mid_state == MID_REQUEST_SUBMITTED) &&
+		(midQ->mid_state == MID_REQUEST_SUBMITTED ||
+		 midQ->mid_state == MID_RESPONSE_RECEIVED) &&
 		((server->tcpStatus == CifsGood) ||
 		 (server->tcpStatus == CifsNew))) {
 
@@ -1577,7 +1588,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (rc) {
 			send_cancel(server, &rqst, midQ);
 			spin_lock(&GlobalMid_Lock);
-			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+			if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
+			    midQ->mid_state == MID_RESPONSE_RECEIVED) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
@@ -1595,7 +1607,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	/* rcvd frame is ok */
-	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_RECEIVED) {
+	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_READY) {
 		rc = -EIO;
 		cifs_tcon_dbg(VFS, "Bad MID state?\n");
 		goto out;
-- 
2.34.1

