Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DE91BD9C1;
	Wed, 19 Mar 2025 09:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742375394; cv=fail; b=ui+0sk1PUx+FLYNBcWUTVw5I/42MXdRg2Bnp5Xle3FmWCGN866H9Gar53kRIJUs0uSNJSFdPFqY7SU9uE2ljpI4RPjhyiw5ycdGOrmQIGXRAqdNWL6xWFIzu3TIM1hts4L/BeY9grfsV6FzRDruhFu4bPPwW0XBMFYyP8zm38K0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742375394; c=relaxed/simple;
	bh=lGUaj5huJMnqHRNBA04Onvr1gefnXh7YOhmIgW9NA2Q=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=tx+lE/tm7mSQME44ZzDEgaS1IVcTeCcLd1L80n5ztjBXTr/ESeXZ+xuB5eovEt1xrGSPApANkp7txldPI5yZEUXYCq7+ofj/lM0+ofYBWcBa4y5bsIda5SpxKzIq3XXlgveH/4+NDh8l3IgVd9uhV1StEnxwjPUsiMRciPUSTzY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52J6U4T9023954;
	Wed, 19 Mar 2025 02:08:58 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45eprra3tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Mar 2025 02:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TLBmMwgA60l84iPOeaJj0rhz0WWWJvjWY2F0I2fmIR23nPr1mvL0GScxfAGRojVh6ZGxmQKG+GymWc7buWMBJgIrLFIRGvm53uN6E9n9xP6OMgKE+SAja56bCIJt67egPzbMbRjsUfmOj01LZg+7Rz50nCqOGugdfnikTixkvruihdrR6nMElw3EAzUMgX1xDrm8gTDbcBmbsBER5548am9VaKf6v9d+d1F/HzpD7bDBs2M8P7Fh4XDQ1eJRU8TzEZDcPdrrVgXkUZdXULRSN4ldpdJS/P7eMU9Sysp9SwytCzvMdyPZRL+Dz08nvtb0AXjmCL7VNmPMnW9pNxGuPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkH+g1qfHdZbewlgImPHpgkT+tmnEw05kDU2sQYNMlM=;
 b=sjkofq0WHHCpeBT5YKFs4hSkXsW38hhZR6bLaS7bwRHaADSyevbCfaVMdw1SEtjZMI8Llzzhfqt6tJEmFm4Q6mswXk+El2Soupc0RGxRY/jtuOBzeMk8gHq9o4kvjCbgHkRdL/oa+ckDWIgKgRMvD8bevZrTqaVdNtmbqoPNO4hzvWWCF2rQLBnNwA2mqpLiAwupN0qXPu0GOgNvE0SoTbWSgPAeO+6ygAJ/SvHdCPjdtRb9pldUZCqMGSo0Kry6lAsRVDygV+iBy9xD58jYIHd56wUbNHzL3iMnLIaFZ0eI2ByMNUYMvXuLIre50w7G2Lf8BRGSFOjMYMvWa1HtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6)
 by LV3PR11MB8580.namprd11.prod.outlook.com (2603:10b6:408:1ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Wed, 19 Mar
 2025 09:08:54 +0000
Received: from CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d]) by CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d%4]) with mapi id 15.20.8534.031; Wed, 19 Mar 2025
 09:08:54 +0000
From: Cliff Liu <donghua.liu@windriver.com>
To: stable@vger.kernel.org, sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        paul@darkrain42.org, Zhe.He@windriver.com
Subject: [PATCH 6.1.y] smb: prevent use-after-free due to open_cached_dir error paths
Date: Wed, 19 Mar 2025 17:08:39 +0800
Message-ID: <20250319090839.3631424-1-donghua.liu@windriver.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0188.apcprd06.prod.outlook.com (2603:1096:4:1::20)
 To CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7012:EE_|LV3PR11MB8580:EE_
X-MS-Office365-Filtering-Correlation-Id: b649cdac-271c-4384-3648-08dd66c5ac41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|7416014|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Px4/N5y4KKX5Obq8CqrCXcCnf5cnLalcOsEJf7dvgWi4Vxdbl/5rR8v6wFzd?=
 =?us-ascii?Q?VAVlKCkvLu1FVP/mJo/U5w1vsNYp/pCz7tOCIQOmy3Q/SGCplVnxsRsRMAbO?=
 =?us-ascii?Q?Qs4eIhUXt9urN9sPtQIixWvs95Bc6bMPVZTJZSFqV8cdD4Cj+b44OKYEzMV6?=
 =?us-ascii?Q?0ccUz3Q3JRbydJ94nK6Z0FXbaJdlRigDHjDRhhN3jb17Ol/KVRpyMVU+FfrJ?=
 =?us-ascii?Q?rWrd/AKxxGQEmPXmRUrWWg5IMLgkUGWTEhy1rRHd78kmiakAzxVOal4Ne/pq?=
 =?us-ascii?Q?SBc62OUQUzquOr4gRc9IU5fovKhgpCxiQ+w58ctA3L6oheJiuQn67a/S8vxj?=
 =?us-ascii?Q?pCjE6rpsEW+MTdFT1WKcPiLIAqQ9RyCnPXEAQEzEC4IlpqtcvyfS8WjQV7Ti?=
 =?us-ascii?Q?Mja9rZSsiTIKjl2M+SWIvUNTrdXk5s0GbZj1VhISYRP2zbc9imq1UbHgMKOg?=
 =?us-ascii?Q?w9lCQ7zIubcYJDouyMb79lPaMT05/0blFI0N+0Djka7iigF2PwDEl3Xtbajn?=
 =?us-ascii?Q?EPbR0vuAOWmys6F0fGHmmJ7bOu5ZRgOGIRNSkLs0ALv/J+2AM7Sqb152JTJK?=
 =?us-ascii?Q?0Xd1fLZi1F3iPNrqcf08Cq/T+49YNHHZ4kx7V8Gqbv2FyoQ/QHvXlzbJiuCY?=
 =?us-ascii?Q?zG7kay9zvGMcuNJiX/o9Ya8ZvxNXSq3oq8UwPb17uqLRdQCq4TDkiKxICUvE?=
 =?us-ascii?Q?+OYjk42EcWC3OXCM1yEfnOOr4x74dbYhnXOkUtc+6X2HqXUsen6AnY2KHwjp?=
 =?us-ascii?Q?MAkzQE2Oko9GHyl5MICAmEl5m3erVn5k4G04RDDpGifHe8h818ypbRbCAi57?=
 =?us-ascii?Q?f4jWBHHoufUtFaNRhvt8E9pucHe1Igsxr0wYCZdFQEDUM2okklanNgRITKPc?=
 =?us-ascii?Q?BfcuxRMKg4fI48+7MLKs5jZ/MXWrqIJmpBoPx75V/OSQ7cqP8ZsQk0nLci4G?=
 =?us-ascii?Q?8aylzIYMPEH0dMFpzHI58k3vZnEEs2c9I8yNAV+ef5CqiZ6vgMhoV5FR5ZSV?=
 =?us-ascii?Q?XzhyT5ZOnVIpHXRynTByW5YBH5PPznmafFe94+wStw1OQZlEKvcd5ZiVLVkZ?=
 =?us-ascii?Q?HG9eD2R35P9+I0+S2AK420T+eH82BwHFXOJ1WmQCDGmsFqi8Bhtb8DS12f/G?=
 =?us-ascii?Q?XO1NFcpZwIEfQF5eNBDDP1bloYkeqifPpzGsCw7VEUuyvzouH9CyYBDoBiiG?=
 =?us-ascii?Q?q8ieSIGtpsKuyXcpa9VwCRsgcfiN07gVjxRDoqWQW7v6Xt/TNWV73sG4ntPy?=
 =?us-ascii?Q?CeGAnw5yU2MpDn6xPJdwoRM2n1nwZbq2ZsDN3LPNn1V1kqzPNz6x0rBkMdTg?=
 =?us-ascii?Q?A7Oi1frR9DIpEN60UbBVcocTfmRIOPKToCq1qmQgUvhdsmsgrHOMP57/lVvh?=
 =?us-ascii?Q?GWIDcJ8hundUow3yVAihNstBzs7KQDwLmZsZ/vBQgtZCZjehiLW722qYI7U4?=
 =?us-ascii?Q?jUAoRecyjpmYtYx/HTnCtFxlGg8MJnm3ziMogXiGgHaJzzkzk1naCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(7416014)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xp0cyEdwwmW3whIy0/3M4oD0CNPt4ka1tZoP08aADo+IPDiZNOBDuV4ToolE?=
 =?us-ascii?Q?ZhIezXY7z8NdSfgm3R6Be9ozeB846jwAebNDPEUK5ifmw1QKSsAwRdXEwdoG?=
 =?us-ascii?Q?qg+2L1Znf1S6uZDdaygInHVjNWJtVGh2/RWSNoXP7rHyke//5itTr/zx8Vwo?=
 =?us-ascii?Q?0CPiuScLyZ41nouR1U4IZJYv5th61gE8PwHQ85C9e3CiOEyoTOQfSEReT5lw?=
 =?us-ascii?Q?U5dMien5Z+Ua11tbCQmHjzQdzjvtTiAaHlnUnKv3lrmlMDj+bUZ+Vt+RH7zZ?=
 =?us-ascii?Q?bDtAePzkEk8hYkswlXRemtHSlzkPAFHXuqpXVgl1IjHl5BEjFQfFxH0rdk8f?=
 =?us-ascii?Q?IPo7Kv8VUA0d/odqe7qm9GuvaYbNT/0LQnwHYfgVkAZ1HhUQ87w1NF2dqlqc?=
 =?us-ascii?Q?x9SNf0JAg9D/zk0Jp34WOyDnTP16fJdGEM3+bplfOSKYxFTqRaIUQnoSFmNN?=
 =?us-ascii?Q?BK0Gx0zgad/GYIRp+GWpRSPwMGN2mvfio365fGgCd6glViogdq8JyIXmmoby?=
 =?us-ascii?Q?ZMWHROxXhaxSyElUvND3hip5Bb0mOcoKKARaGt03d3N5CRVZS9XTmptamKl8?=
 =?us-ascii?Q?WFRv6KL87PkTlHmmtSC2JXNs/lIsCUBpey//nniEAC3LjqQXvFfnLPGYJtxG?=
 =?us-ascii?Q?yawkH53S4y7nWPHhbO6zLeod9Al/TyTyiKSU8xMw2+tM8y2wz1KxYqSvOEzm?=
 =?us-ascii?Q?KtQv3UZ1QIFnTBb7R+l2o5PbJfXbgMlC1bpTG8jwIhnym8IacBUNPAjm31jE?=
 =?us-ascii?Q?LXkdiX3N59XX38eNWxgR+eW7O0hTr/iNqlH4Q5xAkOK25L7QCEEwQH/kbry6?=
 =?us-ascii?Q?kwYRTwHuv+0RwY97cq9TIR5HTzO9XE0iXFBEjArwSkRhIAA1/s58JnpBx+3q?=
 =?us-ascii?Q?qo8r/c1XGDrKG+wndRsSfv2oOXUWbdZ315SwDI7X9VptnRZDNKcByr8AKEuR?=
 =?us-ascii?Q?OPImwMVPpcsofbvm/PgH+RlMjebmNlCZ6zaVKfNHvxmjuyZrgQ2WG6cXcsCX?=
 =?us-ascii?Q?FRPnmeMT/nnYGKcnWwWLwrQoqdHa4vwHCIW0ikCcFrewbKWP/6oPugn0jqdU?=
 =?us-ascii?Q?tJUXGRzuL6fYea/RVPhH7x/q4LcyuO51Fx5SQ4susYKNJdKpH1K/QXzi2Aud?=
 =?us-ascii?Q?McPjm8Xuv+Kkt364/qQRc7ET9Au9qL8LRxB1ycfJQrGMhMarAc1pTcBCawsn?=
 =?us-ascii?Q?yN9XGvt7fl6QR7kXRxFzSgYgldkLeWNTU3Y5iqWyg5v+Tj8lvvACx61POukI?=
 =?us-ascii?Q?uG/0TO85K3npV9DLpMQXYOEVk0CArpDubIbJiJimBBvVSoMS2sFz+dABXLGz?=
 =?us-ascii?Q?JqYTEbGevCBAtO3JEUlLp175MLZME0WgFnNlTNXZAf35OpQtYoDAb/WHOgsS?=
 =?us-ascii?Q?Dwrn5rLpBEn8nuQ9KRmPf6tciIvtrNh9IaVtv+b3vCHlSTXkK5UMXsaFVRP4?=
 =?us-ascii?Q?gx7MJaXQ4qKtBBzPKy4LHVQb76ZtM2c0qMoFbgfF1Sd9q5SDkwVnsThghxWv?=
 =?us-ascii?Q?ZuXiRWR0Ki80HKWz9Iz1oWr7JQAh0xEaTHmKMQFoMrTgSoOx6hOpItVciCh/?=
 =?us-ascii?Q?Z1T4KjwPYc/r1c1j0X0TbFjaeXuUZyi3SLBhKCfYEuD+/ThQKpMWTCxHX7DG?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b649cdac-271c-4384-3648-08dd66c5ac41
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 09:08:54.3313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ZkSFNn3OG0/S+VqVMq/I8j2QujKM6g4TEY959qH9NUfLW2VWSfyfB55w0kV5pHhpNn8IqF9qNnxj2e6sB7S8dU0DfedhJJLyJDAank0KJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8580
X-Authority-Analysis: v=2.4 cv=LZw86ifi c=1 sm=1 tr=0 ts=67da89a9 cx=c_pps a=MPHjzrODTC1L994aNYq1fw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=tDSLDpQlAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=ld9qtEkBpwlrdAxBCaYA:9 a=jQiStcyIZl8z1Bz5rpD2:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: l5LPjxcETmKKcNfHh_RuaC-3ZFpHwgYe
X-Proofpoint-ORIG-GUID: l5LPjxcETmKKcNfHh_RuaC-3ZFpHwgYe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_03,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 clxscore=1011 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503190062

From: Paul Aurich <paul@darkrain42.org>

If open_cached_dir() encounters an error parsing the lease from the
server, the error handling may race with receiving a lease break,
resulting in open_cached_dir() freeing the cfid while the queued work is
pending.

Update open_cached_dir() to drop refs rather than directly freeing the
cfid.

Have cached_dir_lease_break(), cfids_laundromat_worker(), and
invalidate_all_cached_dirs() clear has_lease immediately while still
holding cfids->cfid_list_lock, and then use this to also simplify the
reference counting in cfids_laundromat_worker() and
invalidate_all_cached_dirs().

Fixes this KASAN splat (which manually injects an error and lease break
in open_cached_dir()):

==================================================================
BUG: KASAN: slab-use-after-free in smb2_cached_lease_break+0x27/0xb0
Read of size 8 at addr ffff88811cc24c10 by task kworker/3:1/65

CPU: 3 UID: 0 PID: 65 Comm: kworker/3:1 Not tainted 6.12.0-rc6-g255cf264e6e5-dirty #87
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
Workqueue: cifsiod smb2_cached_lease_break
Call Trace:
 <TASK>
 dump_stack_lvl+0x77/0xb0
 print_report+0xce/0x660
 kasan_report+0xd3/0x110
 smb2_cached_lease_break+0x27/0xb0
 process_one_work+0x50a/0xc50
 worker_thread+0x2ba/0x530
 kthread+0x17c/0x1c0
 ret_from_fork+0x34/0x60
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 2464:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 __kasan_kmalloc+0xaa/0xb0
 open_cached_dir+0xa7d/0x1fb0
 smb2_query_path_info+0x43c/0x6e0
 cifs_get_fattr+0x346/0xf10
 cifs_get_inode_info+0x157/0x210
 cifs_revalidate_dentry_attr+0x2d1/0x460
 cifs_getattr+0x173/0x470
 vfs_statx_path+0x10f/0x160
 vfs_statx+0xe9/0x150
 vfs_fstatat+0x5e/0xc0
 __do_sys_newfstatat+0x91/0xf0
 do_syscall_64+0x95/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 2464:
 kasan_save_stack+0x33/0x60
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x51/0x70
 kfree+0x174/0x520
 open_cached_dir+0x97f/0x1fb0
 smb2_query_path_info+0x43c/0x6e0
 cifs_get_fattr+0x346/0xf10
 cifs_get_inode_info+0x157/0x210
 cifs_revalidate_dentry_attr+0x2d1/0x460
 cifs_getattr+0x173/0x470
 vfs_statx_path+0x10f/0x160
 vfs_statx+0xe9/0x150
 vfs_fstatat+0x5e/0xc0
 __do_sys_newfstatat+0x91/0xf0
 do_syscall_64+0x95/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Last potentially related work creation:
 kasan_save_stack+0x33/0x60
 __kasan_record_aux_stack+0xad/0xc0
 insert_work+0x32/0x100
 __queue_work+0x5c9/0x870
 queue_work_on+0x82/0x90
 open_cached_dir+0x1369/0x1fb0
 smb2_query_path_info+0x43c/0x6e0
 cifs_get_fattr+0x346/0xf10
 cifs_get_inode_info+0x157/0x210
 cifs_revalidate_dentry_attr+0x2d1/0x460
 cifs_getattr+0x173/0x470
 vfs_statx_path+0x10f/0x160
 vfs_statx+0xe9/0x150
 vfs_fstatat+0x5e/0xc0
 __do_sys_newfstatat+0x91/0xf0
 do_syscall_64+0x95/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The buggy address belongs to the object at ffff88811cc24c00
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 16 bytes inside of
 freed 1024-byte region [ffff88811cc24c00, ffff88811cc25000)

Cc: stable@vger.kernel.org
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Do not apply the change for cfids_laundromat_worker() since there is no
  this function and related feature on 6.1.y. Update open_cached_dir()
  according to method of upstream patch. ]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
---
Verified the build test.
---
 fs/smb/client/cached_dir.c | 39 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d09226c1ac90..d65d5fe5b8fe 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -320,17 +320,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		/*
 		 * We are guaranteed to have two references at this point.
 		 * One for the caller and one for a potential lease.
-		 * Release the Lease-ref so that the directory will be closed
-		 * when the caller closes the cached handle.
+		 * Release one here, and the second below.
 		 */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 	if (rc) {
-		if (cfid->is_open)
-			SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
-				   cfid->fid.volatile_fid);
-		free_cached_dir(cfid);
-		cfid = NULL;
+		cfid->has_lease = false;
+		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 
 	if (rc == 0) {
@@ -462,25 +458,24 @@ void invalidate_all_cached_dirs(struct cifs_tcon *tcon)
 		cfids->num_entries--;
 		cfid->is_open = false;
 		cfid->on_list = false;
-		/* To prevent race with smb2_cached_lease_break() */
-		kref_get(&cfid->refcount);
+		if (cfid->has_lease) {
+			/*
+			 * The lease was never cancelled from the server,
+			 * so steal that reference.
+			 */
+			cfid->has_lease = false;
+		} else
+			kref_get(&cfid->refcount);
 	}
 	spin_unlock(&cfids->cfid_list_lock);
 
 	list_for_each_entry_safe(cfid, q, &entry, entry) {
 		list_del(&cfid->entry);
 		cancel_work_sync(&cfid->lease_break);
-		if (cfid->has_lease) {
-			/*
-			 * We lease was never cancelled from the server so we
-			 * need to drop the reference.
-			 */
-			spin_lock(&cfids->cfid_list_lock);
-			cfid->has_lease = false;
-			spin_unlock(&cfids->cfid_list_lock);
-			kref_put(&cfid->refcount, smb2_close_cached_fid);
-		}
-		/* Drop the extra reference opened above*/
+		/*
+		 * Drop the ref-count from above, either the lease-ref (if there
+		 * was one) or the extra one acquired.
+		 */
 		kref_put(&cfid->refcount, smb2_close_cached_fid);
 	}
 }
@@ -491,9 +486,6 @@ smb2_cached_lease_break(struct work_struct *work)
 	struct cached_fid *cfid = container_of(work,
 				struct cached_fid, lease_break);
 
-	spin_lock(&cfid->cfids->cfid_list_lock);
-	cfid->has_lease = false;
-	spin_unlock(&cfid->cfids->cfid_list_lock);
 	kref_put(&cfid->refcount, smb2_close_cached_fid);
 }
 
@@ -511,6 +503,7 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 		    !memcmp(lease_key,
 			    cfid->fid.lease_key,
 			    SMB2_LEASE_KEY_SIZE)) {
+			cfid->has_lease = false;
 			cfid->time = 0;
 			/*
 			 * We found a lease remove it from the list
-- 
2.43.0

