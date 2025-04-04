Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9D17583;
	Fri,  4 Apr 2025 12:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743768474; cv=fail; b=EgICfO3eZNufK62Gc09GCamKJgcA0UjDuNI0T+7Dkapc7mTpu+Kf9LzgW3Wki+p0dvkK8/KKIOmEerIN5YfhAqDXxMQdnq49n3/z2zbsm6EpSQIV+brkn+fmin+C9mL3+BBABWyr0znHP3gaWdJw8wA7BxCi5iUTrzlM8/4Tkyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743768474; c=relaxed/simple;
	bh=B7EUkh7RdUDKcNbf2M9Xhv5MK2CnfddrrLaw/7M6bd8=;
	h=From:To:Subject:Date:Message-Id:Content-Type:MIME-Version; b=kva/yJzztbQcuSJdCTm7kqpIgQ4CJfRlvhD6ka1Tq8gtGfnfvXOixPPumCTNEESHp2OHGqojQ6IYiX5Df6vfN5Veq9/DDTOKO3mQJdcx7vcyT3SKXL9gmeGlASDHByfQ43jmcxTXvMWxd0AkBeSvekcjmPsPhHXSTf0gIJgxYYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534BI92P027622;
	Fri, 4 Apr 2025 05:07:02 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45sg1ua6uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 04 Apr 2025 05:07:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vt5xsHIVK9oGntEHuWbptomcA0YcY2Nsqa7D2MYprsyr94rnAeS73+/7UNaFi1zTAbmcIp5vBMc2eUGvWD697ULk1Dcju/DpF9MO/jaVQ7kt9heVuzimo0wCUuqM7x8ETy1UO7XeeWkxW9veaDi/3sr2n4if4kFf11yP/BnpLGvUlQnzKRCYvKlhcVmBjOx7pfK6VYK/57FNzbZwQDJHtn27ydCiRnUo3mMjVbvN01v2R8YYqjiG5epBEkzyFSrS6FIrR29eFzICJxdaL+kc7XiY42ClSEEuCAgntGl/nE3QWQ3vJss4m/tToTRFquz6mNccI5Nj2A8Ysm08aluO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LzV2li6kw6b0VUiH5/JePz7JwlsnYF67n1shzy6QPQ=;
 b=okUO457qnbf0s4wnWlzzLLZFK+NSqWiwq1iI/ERijbTvBmxWteLCpo0RkOIOKmSpMQCcDyh2rtHI8gfO9cTLZYCgM31H9QTMXDkqIdEwgneB69+KJKVL5K86VrWbhKMlshVukQdCgAcAZSQR6H8/BIISPUCDTnF1/o9r8/Y678W8tLDa+wvOER2INP4lKZVuDgkVdpW1doLIRULac0IN2LmnFyNZstVujsG/5AN/BM8DShQvPAfkFeWfH6uMZIsyvowsDPmQvEo3O/bsd3TK9YM9Ef+2wSpHKrdc4j0lu7N2tttx/mNccU84ieoLmAmgn5OmRjTRiJjPmES4dtlNXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SA3PR11MB7527.namprd11.prod.outlook.com (2603:10b6:806:314::20)
 by IA1PR11MB8787.namprd11.prod.outlook.com (2603:10b6:208:598::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Fri, 4 Apr
 2025 12:06:58 +0000
Received: from SA3PR11MB7527.namprd11.prod.outlook.com
 ([fe80::3133:62e0:c57c:e538]) by SA3PR11MB7527.namprd11.prod.outlook.com
 ([fe80::3133:62e0:c57c:e538%5]) with mapi id 15.20.8534.043; Fri, 4 Apr 2025
 12:06:58 +0000
From: He Zhe <zhe.he@windriver.com>
To: stable@vger.kernel.org, zhangxiaoxu5@huawei.com, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        zhe.he@windriver.com
Subject: [PATCH 5.10.y] cifs: Fix UAF in cifs_demultiplex_thread()
Date: Fri,  4 Apr 2025 20:06:43 +0800
Message-Id: <20250404120643.399885-1-zhe.he@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0121.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::8) To SA3PR11MB7527.namprd11.prod.outlook.com
 (2603:10b6:806:314::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR11MB7527:EE_|IA1PR11MB8787:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c8b3d5-a290-407a-f710-08dd73713305
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rRTmjsdR5gAnvQpXMEdvS0HRzTvGeDfvNBXacDHxMJBlM1vONitVkDGb6rTi?=
 =?us-ascii?Q?TldDHDlYgDkLlTfV1kJpF1V58HQAAFRtY5q9387MfCYdxImueWYn39zNJfm7?=
 =?us-ascii?Q?35awf7er5KXmr6ODib5H4vYTbKhaN1Va/tDt8Kcfk5A7pTMGoXXRdpZyEsB1?=
 =?us-ascii?Q?E1EuIv4AMyUR/NLNAay2LBKwi4Q6xNsRWw9v0TkSNIDqklBFX8JdL7xvhRL6?=
 =?us-ascii?Q?JWtGNW31f04Da0O6KDYsGngU5tmXlxjIBeYIE5YBFVxLai6T+W1tM6NmHC5p?=
 =?us-ascii?Q?Kg78x7o/RFbyit9hZBblQMAVhSKT7dEs/BX8dVohGsIhXlxxSvrb1TlHu9hQ?=
 =?us-ascii?Q?gvvSkMBSKPWOSkXSMwtc6DaskWPjF6S/4co4YyJGXfvGXP0WESwgK+Sobv8U?=
 =?us-ascii?Q?/ZKvpU/2uesyU6m9DlZJNJJb/HCIJngFtTGrcLdyUDwIyfFeb2KsdUjBnyXf?=
 =?us-ascii?Q?FXIT6ijXx5xXybJ43R1kNNwBDW4wwbuSIgT/dLYJ1OS/r3zrrP7Q1Dy4E9WJ?=
 =?us-ascii?Q?hqZ7oT9izOR8e1fnynNrr/KxceWu/XJ2h9Kk6ZQ5pmMi+apYzXPowJd9IDI7?=
 =?us-ascii?Q?MzU3JGJas+RDlrn86uf5xjcd7+0EfcCwxhIaW0IUXTx4eHrEtFfVf70pzXdo?=
 =?us-ascii?Q?c/qdSUqKDLu1Y/shmrqKfU6YZcytLl51kWpeM5DDyhOdC6GcygdGDkM3+vyY?=
 =?us-ascii?Q?DNeAEYdi4P2T1o15kjxwX+RE2NrCjNNrXP5HTpruMhnMSrYnHZiBY2mRMkHt?=
 =?us-ascii?Q?kEbddWmGSPCc3jF/2MEdIe8rNIGzURxH/LNpNRkcDuKAE4jvZ8ruovNiHkrq?=
 =?us-ascii?Q?YXbvbG1EyQJ8XKGtK9eVpNuFxXh28AHvpaXNrWs6TtClVPHlxz6MOMbYv8qW?=
 =?us-ascii?Q?/zmce1thqdF4ssrTTqd0FSEsvJn2DFcPnES0su6cqIRU15nz7tmx6f8s/HcU?=
 =?us-ascii?Q?m1ns4wEBGBj5VLafRJOAHpxMMVA2Npcpny+a5FolcplqXN6HpX4760hoUMTf?=
 =?us-ascii?Q?Dyycm79wqWP9RgRykBLjlPhYK9lM0GNenyFietXW2WWuI5Hv57APua6qGE7s?=
 =?us-ascii?Q?hfmcQeSMfrIZ69Ef4NxLaWGpbxHth57fN2kVIVcP1XSaCK/ZhOVrdGA/z3q7?=
 =?us-ascii?Q?Z39kBBkBw7mPcb6PG3MZ9uz+OSaBboBDdmkP018YTMyFksiW8ZV/Png7LMBL?=
 =?us-ascii?Q?KS1oc7xef+w6u7rZvlXcBjbQVB778PUm4Ml4ys9ZckZ7nFRr/yCaoD183F7P?=
 =?us-ascii?Q?rBE2fXrtASixuX12TDO2D9d30ohN692Hej+9RgIc6Ku4EfBw5Xu/5AHPTuy7?=
 =?us-ascii?Q?MYd3gvcc9kkEL/76jA6zd1hah1yu67LX5bdVTWXNv4xdz6X1dlKJIvAkOmQ4?=
 =?us-ascii?Q?Vz9Pu1aRr11hYmwbLswEw/3XENk0sznAqw709VyqE3EhEQQYWtKVCjpnA475?=
 =?us-ascii?Q?J/Cg9WsWtwiJpXIPB2kKpxFEUeLr1DIw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR11MB7527.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DukD1hTflHZHjBQqiX6hioezVz+OE1ThdeSbdAd/q2W3QL6UZMhPuUV/WsLv?=
 =?us-ascii?Q?QrhvVq9VkuKAufABbTtZKa576cVQ6Rj5t1avO++Q8EnQJ3RAekG1xbgZRITc?=
 =?us-ascii?Q?GhrVVj6kGIsKsXGR7k+9WIysJrciKXTKUPr5VFPpw5ZAdM8/MzFGhoOOKDAW?=
 =?us-ascii?Q?DfYR/9RVSkl7jQgHz5tn8AvbM8M/R2JFomDw1W4PyPO8XmgMqYCiN/hEP8Jh?=
 =?us-ascii?Q?SsA7UBARIR08z8Wy6fS5dMVdllmLA/MAyNGlVI7c/VmzLCTCLfjTGkL9iZQZ?=
 =?us-ascii?Q?kuKh1MOvE9R1fJ8ZuIzNTfuoikTODpVTw05sJ/eRf2Q6zv5+9wDsmD4bl03w?=
 =?us-ascii?Q?qljWUsudyc4N7c5xLl+G7qNVNgrZnk1mCCtT/9OR7u9aANbZc7aI/jA/T0we?=
 =?us-ascii?Q?E/0zpXCX960tSOKagrAv7FXFBUJeYRVTRLvWRXWoVrUU+t7EoiYT7qL6GuHX?=
 =?us-ascii?Q?oEaZl+s1/0kHcPdkxevhC+RnNmouGp8HRKMpHoeYvU2xdYNlBbH5/xXjm6AI?=
 =?us-ascii?Q?UQghzkqoW3GMdHTsVBYPkcL53agG0eXpy7Tf61vJ8SjDel9KOquxGTr3WoBn?=
 =?us-ascii?Q?puqz0ICC25uQb5899hc7ZtoKcdhBe/WcyJAiGVMtTvlz6Lgt8f+5lU4kcUhp?=
 =?us-ascii?Q?0AeuRyiMHNVIXcBxsIeOB2RS2CIKe262oB/Gytyeb50ntGeX4yVlNxbiU/wq?=
 =?us-ascii?Q?d8DCvANGT64BQcA3anczrvX0XXeB3AH+Vs6EFZsfpJDfb1dwT6DqKGEvij9M?=
 =?us-ascii?Q?IrSCy7lh6Trjfdy5tuW097gmWxTmQTb92VzahLKfcbZdh3Q1W7HR3oSl4940?=
 =?us-ascii?Q?xXK3iwoeTUqlaxEqxArNguSiRqVP97npDR0P459G0I1YxfmjhPuLWpYdXCrL?=
 =?us-ascii?Q?Tnuu1KFMltHr8m9JgzgYR3/xXRgIsV3E/XlZttuPRV3euaHOdIgBcv3NX0mM?=
 =?us-ascii?Q?LSE6FeHXL1VUyCw0z831tTOF1Jqz05U9cyDRP8D28sACch0HhdY4u/snqD5j?=
 =?us-ascii?Q?7Z7QINA3ZYuNTWzVAs3UKGOLlzZK5JekYH11H0P7e/skxTIpEOIJfKTb62Cn?=
 =?us-ascii?Q?AgUT9oM2f7Ah397rQXhOkMP5G+7ryB01Plcn6WKOAxoxnnmq4nVIbFJIQzP1?=
 =?us-ascii?Q?k+2uK+bngRlQ0HRUomFndxpBdfjYmd30nWMj7aEDObEtOgicH9tHyNqc4fCf?=
 =?us-ascii?Q?NzNBj7wMIMyzXRLkQjm2rYKXMei7ZgN39ZiPqN1Rjz3K0dVMjf+aa2fMemf0?=
 =?us-ascii?Q?3yzvSn0lIbdpa6szlrFStBkO+fPR6LxiX+/0Df+zBQ3Khc3kV1yNjflSe0dx?=
 =?us-ascii?Q?KJm23UMIAdtvORbHXhMdwOB7/obuw3SOTZbyXyhlMuWi6oeifzGPiTrQBrOF?=
 =?us-ascii?Q?nhapDAQw8o5j7osKIVI0/HPojqi/glHMcmSFpWVpr+Ab/eAlJSZM0VGPv35V?=
 =?us-ascii?Q?6bC+kgwlS+mJi1/7wiQ3DnMguexNfP8QHfW113MWLj2t9Z5yfnX0Obss0sZZ?=
 =?us-ascii?Q?ZhOH+n9n7a7jvgHcnH4kIREO9dK5OYlOH7nGRkj7elAGamp1K7JkY0EDFt2Q?=
 =?us-ascii?Q?AaK2iql5yYPhvgTg1oxtRBEuA3LJ8RA4rQq0HsbG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c8b3d5-a290-407a-f710-08dd73713305
X-MS-Exchange-CrossTenant-AuthSource: SA3PR11MB7527.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 12:06:58.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luQ2f28v0LEegLec4/oLmkP2QOLB2o+VHvYX3gyzwMuQ0DH+Nqfe0fsIg2v4TU8IBEKohj7T1rVcmLFzLLdqLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8787
X-Proofpoint-ORIG-GUID: QirvE0a9EAxW_jZLIzWVo86y2-UQEPkz
X-Authority-Analysis: v=2.4 cv=Aqnu3P9P c=1 sm=1 tr=0 ts=67efcb65 cx=c_pps a=e6lK8rWizvdfspXvJDLByw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=i0EeH86SAAAA:8 a=Li1AiuEPAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=I7mb3Kwx7LMPoRuHVzEA:9 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: QirvE0a9EAxW_jZLIzWVo86y2-UQEPkz
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_05,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 malwarescore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504040083

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
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/transport.c | 34 +++++++++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 92a7628560cc..a6697954fd68 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1768,6 +1768,7 @@ static inline bool is_retryable_error(int error)
 #define   MID_RETRY_NEEDED      8 /* session closed while this request out */
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
+#define   MID_RESPONSE_READY 0x40 /* ready for other process handle the rsp */
 
 /* Flags */
 #define   MID_WAIT_CANCELLED	 1 /* Cancelled while waiting for response */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 4409f56fc37e..488893962708 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -47,6 +47,8 @@
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
 {
+	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+		mid->mid_state = MID_RESPONSE_READY;
 	wake_up_process(mid->callback_data);
 }
 
@@ -99,7 +101,8 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
 	struct TCP_Server_Info *server = midEntry->server;
 
 	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
-	    midEntry->mid_state == MID_RESPONSE_RECEIVED &&
+	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
+	     midEntry->mid_state == MID_RESPONSE_READY) &&
 	    server->ops->handle_cancelled_mid)
 		server->ops->handle_cancelled_mid(midEntry, server);
 
@@ -733,7 +736,8 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 	int error;
 
 	error = wait_event_freezekillable_unsafe(server->response_q,
-				    midQ->mid_state != MID_REQUEST_SUBMITTED);
+				    midQ->mid_state != MID_REQUEST_SUBMITTED &&
+				    midQ->mid_state != MID_RESPONSE_RECEIVED);
 	if (error < 0)
 		return -ERESTARTSYS;
 
@@ -885,7 +889,7 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 
 	spin_lock(&GlobalMid_Lock);
 	switch (mid->mid_state) {
-	case MID_RESPONSE_RECEIVED:
+	case MID_RESPONSE_READY:
 		spin_unlock(&GlobalMid_Lock);
 		return rc;
 	case MID_RETRY_NEEDED:
@@ -984,6 +988,9 @@ cifs_compound_callback(struct mid_q_entry *mid)
 	credits.instance = server->reconnect_instance;
 
 	add_credits(server, &credits, mid->optype);
+
+	if (mid->mid_state == MID_RESPONSE_RECEIVED)
+		mid->mid_state = MID_RESPONSE_READY;
 }
 
 static void
@@ -1172,7 +1179,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&GlobalMid_Lock);
 			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
-			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED) {
+			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
+			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
@@ -1193,7 +1201,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		}
 
 		if (!midQ[i]->resp_buf ||
-		    midQ[i]->mid_state != MID_RESPONSE_RECEIVED) {
+		    midQ[i]->mid_state != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
@@ -1372,7 +1380,8 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		send_cancel(server, &rqst, midQ);
 		spin_lock(&GlobalMid_Lock);
-		if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+		if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
+		    midQ->mid_state == MID_RESPONSE_RECEIVED) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
@@ -1389,7 +1398,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	if (!midQ->resp_buf || !out_buf ||
-	    midQ->mid_state != MID_RESPONSE_RECEIVED) {
+	    midQ->mid_state != MID_RESPONSE_READY) {
 		rc = -EIO;
 		cifs_server_dbg(VFS, "Bad MID state?\n");
 		goto out;
@@ -1509,13 +1518,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
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
 
@@ -1545,7 +1556,8 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		if (rc) {
 			send_cancel(server, &rqst, midQ);
 			spin_lock(&GlobalMid_Lock);
-			if (midQ->mid_state == MID_REQUEST_SUBMITTED) {
+			if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
+			    midQ->mid_state == MID_RESPONSE_RECEIVED) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = DeleteMidQEntry;
 				spin_unlock(&GlobalMid_Lock);
@@ -1563,7 +1575,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	/* rcvd frame is ok */
-	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_RECEIVED) {
+	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_READY) {
 		rc = -EIO;
 		cifs_tcon_dbg(VFS, "Bad MID state?\n");
 		goto out;
-- 
2.34.1

