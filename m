Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D622CCA5;
	Thu, 20 Mar 2025 02:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.178.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742436849; cv=fail; b=WS2lmcrqqurZC5MqkAWLB/isaBYcYRaTetCxRZ7mmROzdUsZkK4tC/jva/3/ZBPGVsFJAAG+qELBVzNYtocumU85TS1G1/fbofe6lqfymy/fmE7yolTvE/NKADKcfbtXdjM1NAYlD9Fidl7hedZJwL9Mrf4G+Y8N7iTttHYdsak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742436849; c=relaxed/simple;
	bh=w0/tOr5y/X3UXx4OodEQdbTBVk7WqvGMfmkHBDqGtWc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WQPlkzjluayvp4t5o1nywBrxGoQmuTqIJ+fIkkcs36wySQjZ/gsI+x5czSVCLAo+oRBYT0JfkoalVdGjk/6bu810KTsLWjxtUjPzTkIdvD95rdFP5cPcEnorQeoZfE2/HL/4rUWztQ47SpDcBz+9PhcWia0eUQAg4mm6RsPvXqI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52K1tbbq010162;
	Thu, 20 Mar 2025 02:13:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45d0h95buv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Mar 2025 02:13:11 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hmD73+l9FywHVHQhpT6Dj9h0EyrUYwrHCQ3iOAqPGzxzDuAKWRwaxSZsrCvuv2vOrjOXOJHOw+jUXyULitoManfziOHUDUf2MGqEHVG4YY1ZG1AQ3eJwZ4ZEVa+w39htyyMQpCQxZdJaD1/LmubqOq+yOXNmz7dI+aaT6lpiRMSxBtNMKt3ezQm6yGbk1E2nUL0RSg7NJc3oHRYjJqfhW1xac6p6HONy6F7aagTzB5YYCqgO0S0SSFc8Wg7Cdk0JUaXunjEh3jJyvLg/rEZElRoTNVR0AWnjqF//59YKyZzso0kV59TInALYP7CjBwEIVJkoq1OW/R6NPwlSf9ILww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rcb6L2L31bHJR9+BiGl5DrnxJ1oxtEyRKoRrB+FfJtU=;
 b=doEPt4dSEuRW5rKQ5pCml9M92JZ2js9IXn9MmuT4QlIUbn4Ww5BK5xdlO7PR+7miYnzzyVuj74OBUVLvR6XUi7u1rs/3bMaDUCS4beF+HX9K6wYeLp5NWgRaK7uWkyEF6DjN1s23siwJbo8TW1BV4Y6EGNIPWwhqnEKzpi4Hy9Jvm10H1WWR4pjGJttuUTJbRFy/dF6P8tmdG7ssbgCmQco9R7rYHXrJg0ky2DkDB0XjN0ffSAITgP8++O04kN1AiAbYwFbhtXGky+KSMRyIdNknudLf8BFRUskriUxBoESpql89TWF5IIGKZbRd9cvzVQmE/DBYyG16PMkPtZvrgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6)
 by CO1PR11MB5076.namprd11.prod.outlook.com (2603:10b6:303:90::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 20 Mar
 2025 02:13:07 +0000
Received: from CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d]) by CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d%4]) with mapi id 15.20.8534.031; Thu, 20 Mar 2025
 02:13:07 +0000
Message-ID: <4a248d5e-fb81-4f45-aaec-79c36f93e14b@windriver.com>
Date: Thu, 20 Mar 2025 10:12:54 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1.y] smb: prevent use-after-free due to open_cached_dir
 error paths
To: Greg KH <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>,
        stable@vger.kernel.org
Cc: sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        paul@darkrain42.org, Zhe.He@windriver.com
References: <20250319090839.3631424-1-donghua.liu@windriver.com>
 <2025031913-unclaimed-ocean-06f5@gregkh>
Content-Language: en-US
From: Cliff Liu <donghua.liu@windriver.com>
In-Reply-To: <2025031913-unclaimed-ocean-06f5@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYCP286CA0276.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c9::13) To CY8PR11MB7012.namprd11.prod.outlook.com
 (2603:10b6:930:54::6)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7012:EE_|CO1PR11MB5076:EE_
X-MS-Office365-Filtering-Correlation-Id: f243f18f-0a2b-472c-97e1-08dd6754c111
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TUF3WEJtamZjRWZ2WDhDcFhIditxWlUrY2dvMlcvQlBOQUNtUDN5OG9lR1Rl?=
 =?utf-8?B?WXphT2pMLzdUbEZlNVJ2T3NIeWVPaGZjK0c1VHM1Y1VMMTRDc3BhUUthZzVO?=
 =?utf-8?B?MlVtd3pMSXltU21yTkFvU0k4bCtWVWNSanRsYlNpVy9jZ3ozNDViNHRCVWgx?=
 =?utf-8?B?T1ZUaG5uWVloZ0dvTFA3MG9yS2lpbE42bFhkc0dzeVFneG8xYlZzTHBINUJU?=
 =?utf-8?B?cThOTEN1UEZmSEJ3cUFua2c5SFVvYlE2THlzcThFc1I0dk9EeFhCNkM5Z080?=
 =?utf-8?B?VXZJQ25KRStCa0FVWmJEai9tMEI2UmhweldKdit6VUlkS051WUwxdVJWdVFZ?=
 =?utf-8?B?UHFHRCt1dWJBNkNoSWI3WnVaQ1Bwa1lueUZ4UFRnSVFMQStSRG4xdFNnenYv?=
 =?utf-8?B?VTdjanpvM3Jwck1ac2ZlSDR5ZWw3dGZkbVF6bGYxaWNXRER3ZTJtOUN1MWN5?=
 =?utf-8?B?Z0Jjc0x0aGt6dm9iV0NNZDNDbld4VGJSTnE1aVJNbFFMMXpiVzZNc09wckFv?=
 =?utf-8?B?Y014S2d6VUFUZzRjWisrS1RZNHNxUXZ3NjJZcEtsSnZUN2NsMXVjOHJtRU8r?=
 =?utf-8?B?UHpTdENEdzhMWmJaT21PVXByMFlrQ09MbHBZL3JvOUNxME5iRjlnQTluNU9G?=
 =?utf-8?B?bHBYSUZkbHdmL3Z5bUFGMEpkQ1QxN3BaaU5GN1lOdEQ2VDVnUkVlU1NkNUFO?=
 =?utf-8?B?MENXcllTbTdla1ZpcUczejFBMjU4RFJZR1ZMa3k2R0xYSklBNTNrdE9kMkhv?=
 =?utf-8?B?UWRmNFBQZjBKMWJ5ZFg2dDAwWTFaQWhPaHZPR3JHbW1TNFVacnk2a0Q2RFU0?=
 =?utf-8?B?LzlHZnNMYzZ5N3B1OEJwV2hsTnVoam9BbzlPY3ZyQ1MzZ2RsTDRpTzB3M0Jm?=
 =?utf-8?B?TmhIWHlQWFhiS1g2RitmejErbEdrVS9nalZpNDFLeGt5ZkJ5bjQvaGlMR1g2?=
 =?utf-8?B?MG5jbVdXKzRDNE9XQVhOV1g1WXFtMnZ1UXFqMnFQWWpIT2w3dFRQbE0zY1E1?=
 =?utf-8?B?SkNtUEFOUENFOVZMZlRkTTI3aWltbGNCVEt6OFF2USt6RGRCWWJXai84L0hp?=
 =?utf-8?B?NXY5OVZUNGpoc0Urb2ZvWW0zT3JOdE16My9HdEp0WDVGOUo5TnhHeGZuQTIv?=
 =?utf-8?B?UVFVdnkwbXh6Ykc3bk1pam41YWJVU1NMdHpIRTUrV2xrUEFtZVh3TEtaVjZE?=
 =?utf-8?B?OXo5RTNUSmtSbkFUVFFSaXRoVEpPbDh1cnJMRHBtek9QOGhIMUY5TUZDS3g0?=
 =?utf-8?B?ZlZOWkpVWmd0cS9Zb1dyazdSS050d05UU1RiTUZjcDRKY0hkKzZpWVdHd2FZ?=
 =?utf-8?B?T1NtTy9TS2JTNy9WTGg1ZEV4TVpDNnJjYk5sRElWdFRNK2IvdkUxV2tEeEpM?=
 =?utf-8?B?enNuVmRIdXYvb2hwOTNseHpCZVNOT3g2VmZpcjFnWlZBaE5LS1E4QTMrdjdU?=
 =?utf-8?B?UDNuTFFtYkZ3bWkvVytCQnF2a1lYREJaMVVMNWpkaVZFMUxiQkdlaE0rbnQr?=
 =?utf-8?B?Z2dvQzAxQWFyVmJjTjRlRitNRHNVditLM2Z3WGhta2J3ell2QWZXa3VyWUQw?=
 =?utf-8?B?cTUrSE1CRVNyOE1UZjVYbTloQWVWcTlRUGpSUWI0QUNPVzZGOHdXcFJXTXl2?=
 =?utf-8?B?M3FlSG45UjBrNVZlckQyYjR2Qm9yZGVJdkJmN3BRSjU4d2FaWjNUUWhvejFx?=
 =?utf-8?B?YU9TWmRkNFBjbVQwMUpHaExpY29SUkNoNStPbm9yV1UySnRCUnh6eDRUV0l3?=
 =?utf-8?B?QmRpUFJQN2JnK0JURHJhOW53WUpIK1lzdmpsYnROdE91NitlTGR3dFp0RWR2?=
 =?utf-8?B?ejJJZlo3STlDeW5GMnpsenU5TGpKZWttYkNWUjB0bE9VOExZeVdPZnJSVWdW?=
 =?utf-8?B?QzMwWXUzdVpTbUE2N0lXQzUrcDdwUVJJY0dWU2VvaFFmL0s4Z2kyaFBsQ29X?=
 =?utf-8?Q?9LVv/yE/1urHvxr1J0SgQNVHBjiPl5L5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUwyNzBxRzZ6YlIyK1FsS0k0RTZkR250b1NGenBxNVlxNnNvOVV4SGtqYmNL?=
 =?utf-8?B?TldTSXEySk1DMFJzWDV6R2JucFZwVE1SNjlvRlFXYUJ6SlRqTGgzMTIyUVR0?=
 =?utf-8?B?dDRrb1dyRW1oR3EvYmFQM0M2dkQvbGdjdzNSeXEvRjFYd2ROdDVoaVdDaUlt?=
 =?utf-8?B?a1lPWjdmWWhpTllwZmxsOTNOaFdGTnpCN3hTdHhOYjFiM1dYMFBRYXUxZ1dy?=
 =?utf-8?B?TVJkNnVUY1V1UzF2V2JJUmF4M0p4eXJxSE9WMjk0NGcwSExEd3loSzBuZ2ZC?=
 =?utf-8?B?WmdaamljdTB6WjgrajQycFhFZUZkalcrTFdkbEV1TWhwbEZKSFNYdGUrTmFa?=
 =?utf-8?B?UDFHTVJwZVlXYTBiQkRibURrR3RVK3ZXeGdleW1CTS9SU2JwaUhDMkIwOWxT?=
 =?utf-8?B?RWs4MVFkcWdnUVl3VnNHcTVyUkdIbkNyQjh5MWx3bFgwUEZRajRwWXBCcm1Y?=
 =?utf-8?B?aGR6MmNhWnFsVFBhdFMrcHppc0tRUm84TC91K09KT1Jtb2xqL1F6YlRkdzJT?=
 =?utf-8?B?MVJ5WTcrVng3d1hZRHV3MUI0S2gxZFptRE5ra3Bxb1BZQkhYVUJ3bEYwRjVS?=
 =?utf-8?B?bFRIQ0tGckxtL25wbk9VOEcrNFRqenV3L0hoUFFjRnNEZWFPTEJXVjVDczZw?=
 =?utf-8?B?T2tndHdnVEc4R25jNkZ1ZUNnVkNxOVhaVVhlZlFSK0Y5YlNtS2laSTBHbWNh?=
 =?utf-8?B?OUltaVE4QTQ0dGxEMys0c0VwaVI3c2FWRTdQUHh2RE1uZUR3T3VjTlgwOWIr?=
 =?utf-8?B?YlY2ZTArTTFWc2VEWEJ3eXZ5aGltM2h4WUVjQnNzZWgwS0V5UHlZN2crMHBG?=
 =?utf-8?B?cTBwOGZPNEp5R2svZ0IyZXpRc05aQVlHQ2tBbjhBbXJub3hIL2V2T1IyMENy?=
 =?utf-8?B?NUxoS1hlRkwyVmtpYUNxYUEzenhxRndST3pzTWZmUzVvYm42SlY0MzU4aTY1?=
 =?utf-8?B?WGt0eXcweE9yek5SbWV6QjVUa1VLVnp2TXhiQ0k0YnFhaklKMXZ6ZU4yUE5D?=
 =?utf-8?B?MlU2SlR1RW0ycVE3ZEY1enhySFlOVG9lNDJYMEdQb2pKMmRNSHJSNkNLSG90?=
 =?utf-8?B?SDhHOU5uRjl6UEI4TDRRUVRKSGVKZlIwOGJzaXRMdXZJTHcrQThKaEVKdEZC?=
 =?utf-8?B?bWI1Tno2dzFQWE9sMUZML2pwbXV1b3hscFk0akxCVVdwVWxvbTBac3J0dWpX?=
 =?utf-8?B?MXBKcWM1ZlAwWlVyRk5YOE53bEZsWElzdWh1ZFdCTEo1NVNvL3NHMTROZG5H?=
 =?utf-8?B?NXBXVGQxS0t3VUkwOWRKcmNlMlNSNUlUUkhhem1FWmtZV1daVXJjeS9GeHVy?=
 =?utf-8?B?K0pHRWFZeXo4Z2Z2SUlGY0R1MXNlT3BGZDhUVEljZkNUNmZodVpIRXBZcUxn?=
 =?utf-8?B?ME4rRUloeEp3SXBtZGNMbDdySTYwUTl3Sm1sOXg5NlNsSndMWHpCTDNEOUti?=
 =?utf-8?B?bk9PYXl2ZXh3QTRrV0tCZHYrbzd1NGN6VDRNbHRQYkxYVUZkdFJhcUNCcDNZ?=
 =?utf-8?B?emUxYkNNU0NaakxSYzNxU2pGYk1ka0ZFMlA5V0pWejFzNTdrV1BqcDRNMHJ0?=
 =?utf-8?B?OGFXeTJSMytCRUtjdTU4c1J0S1dSNjlkYUFzQXpLd0VBTW8wUVFDbGhja2ZO?=
 =?utf-8?B?L09wVWk2eVVwOGRRVzZpY010a01sb1diUHRKczBuWHZBbmtBTGZLL0dtN21M?=
 =?utf-8?B?NGlCeER0SWtEaDhaakVuTWpxWjRHcjV6a0dXbndJbTd6MU5nZmNCOGNlR293?=
 =?utf-8?B?bDV4RFdWVDIrOFlPVUtVS3NySE8xenJCVUFOZnVvbVRqaW02ZkpSYlJ4VnZU?=
 =?utf-8?B?YWxhRkxNcUE0OGJ6OEV6bmhOYXpaeXcyM2pHelFGTVRNV1hROEkxSnV3MVRG?=
 =?utf-8?B?eDRPYzhpWkxCMzZ2cW9JZTEyQTFBQklDNFJHSURSanhkdGxQbEVkWnZrNyt3?=
 =?utf-8?B?MGtBSDlnTFVwaVU2UENrS3NrVW5jdXRpZ2QwckJaOFFkM2FDVVdkKzBJQTRQ?=
 =?utf-8?B?VXg3NE16NTBEcmVITWNlUjlNK0p0TnRzTityZTIvL3NNbXNLSWU3ZWQ4ODdv?=
 =?utf-8?B?OUVWU0ZJOEMwazBsRk9xYi9ENk9GSTEzTTBweGxwSDRvQVNLYVpaMEI3Zktl?=
 =?utf-8?B?anRjZkRGak9LOTAybVdPYzJxWDlrVjd0TlFMQ2ltU3FXcEpIQk5EZ2NWUHI3?=
 =?utf-8?B?Nmc9PQ==?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f243f18f-0a2b-472c-97e1-08dd6754c111
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 02:13:07.3000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W47F7jIJjF8qoPZ7KNsLxgJWNzsjIOn8CWxdiRoSo6ljVqeub9ZOl4D4g0bVz6DdcR7mjwlchwBEMSxJTvx+G7XxZhZG6Nsb6zp++tfw0cg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5076
X-Proofpoint-ORIG-GUID: j7cotVgDdEibsTaA9s43C8zu706fdBBX
X-Authority-Analysis: v=2.4 cv=ROOzH5i+ c=1 sm=1 tr=0 ts=67db79b7 cx=c_pps a=TJva2t+EO/r6NhP7QVz7tA==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Vs1iUdzkB0EA:10 a=H5OGdu5hBBwA:10 a=tDSLDpQlAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=TANXYQ9qgNq1aNLOGB0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=jQiStcyIZl8z1Bz5rpD2:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: j7cotVgDdEibsTaA9s43C8zu706fdBBX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_01,2025-03-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1011
 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2503200013

Hi,

There is upstream id in my local patch, but it is discarded by 'git 
shend-mail'.

Please ignore this patch. I'll check the reason and send it later.

So sorry for my mistake.

Thanks,

   Cliff

On 2025/3/19 22:03, Greg KH wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
> On Wed, Mar 19, 2025 at 05:08:39PM +0800, Cliff Liu wrote:
>> From: Paul Aurich <paul@darkrain42.org>
>>
>> If open_cached_dir() encounters an error parsing the lease from the
>> server, the error handling may race with receiving a lease break,
>> resulting in open_cached_dir() freeing the cfid while the queued work is
>> pending.
>>
>> Update open_cached_dir() to drop refs rather than directly freeing the
>> cfid.
>>
>> Have cached_dir_lease_break(), cfids_laundromat_worker(), and
>> invalidate_all_cached_dirs() clear has_lease immediately while still
>> holding cfids->cfid_list_lock, and then use this to also simplify the
>> reference counting in cfids_laundromat_worker() and
>> invalidate_all_cached_dirs().
>>
>> Fixes this KASAN splat (which manually injects an error and lease break
>> in open_cached_dir()):
>>
>> ==================================================================
>> BUG: KASAN: slab-use-after-free in smb2_cached_lease_break+0x27/0xb0
>> Read of size 8 at addr ffff88811cc24c10 by task kworker/3:1/65
>>
>> CPU: 3 UID: 0 PID: 65 Comm: kworker/3:1 Not tainted 6.12.0-rc6-g255cf264e6e5-dirty #87
>> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
>> Workqueue: cifsiod smb2_cached_lease_break
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0x77/0xb0
>>   print_report+0xce/0x660
>>   kasan_report+0xd3/0x110
>>   smb2_cached_lease_break+0x27/0xb0
>>   process_one_work+0x50a/0xc50
>>   worker_thread+0x2ba/0x530
>>   kthread+0x17c/0x1c0
>>   ret_from_fork+0x34/0x60
>>   ret_from_fork_asm+0x1a/0x30
>>   </TASK>
>>
>> Allocated by task 2464:
>>   kasan_save_stack+0x33/0x60
>>   kasan_save_track+0x14/0x30
>>   __kasan_kmalloc+0xaa/0xb0
>>   open_cached_dir+0xa7d/0x1fb0
>>   smb2_query_path_info+0x43c/0x6e0
>>   cifs_get_fattr+0x346/0xf10
>>   cifs_get_inode_info+0x157/0x210
>>   cifs_revalidate_dentry_attr+0x2d1/0x460
>>   cifs_getattr+0x173/0x470
>>   vfs_statx_path+0x10f/0x160
>>   vfs_statx+0xe9/0x150
>>   vfs_fstatat+0x5e/0xc0
>>   __do_sys_newfstatat+0x91/0xf0
>>   do_syscall_64+0x95/0x1a0
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> Freed by task 2464:
>>   kasan_save_stack+0x33/0x60
>>   kasan_save_track+0x14/0x30
>>   kasan_save_free_info+0x3b/0x60
>>   __kasan_slab_free+0x51/0x70
>>   kfree+0x174/0x520
>>   open_cached_dir+0x97f/0x1fb0
>>   smb2_query_path_info+0x43c/0x6e0
>>   cifs_get_fattr+0x346/0xf10
>>   cifs_get_inode_info+0x157/0x210
>>   cifs_revalidate_dentry_attr+0x2d1/0x460
>>   cifs_getattr+0x173/0x470
>>   vfs_statx_path+0x10f/0x160
>>   vfs_statx+0xe9/0x150
>>   vfs_fstatat+0x5e/0xc0
>>   __do_sys_newfstatat+0x91/0xf0
>>   do_syscall_64+0x95/0x1a0
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> Last potentially related work creation:
>>   kasan_save_stack+0x33/0x60
>>   __kasan_record_aux_stack+0xad/0xc0
>>   insert_work+0x32/0x100
>>   __queue_work+0x5c9/0x870
>>   queue_work_on+0x82/0x90
>>   open_cached_dir+0x1369/0x1fb0
>>   smb2_query_path_info+0x43c/0x6e0
>>   cifs_get_fattr+0x346/0xf10
>>   cifs_get_inode_info+0x157/0x210
>>   cifs_revalidate_dentry_attr+0x2d1/0x460
>>   cifs_getattr+0x173/0x470
>>   vfs_statx_path+0x10f/0x160
>>   vfs_statx+0xe9/0x150
>>   vfs_fstatat+0x5e/0xc0
>>   __do_sys_newfstatat+0x91/0xf0
>>   do_syscall_64+0x95/0x1a0
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> The buggy address belongs to the object at ffff88811cc24c00
>>   which belongs to the cache kmalloc-1k of size 1024
>> The buggy address is located 16 bytes inside of
>>   freed 1024-byte region [ffff88811cc24c00, ffff88811cc25000)
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paul Aurich <paul@darkrain42.org>
>> Signed-off-by: Steve French <stfrench@microsoft.com>
>> [ Do not apply the change for cfids_laundromat_worker() since there is no
>>    this function and related feature on 6.1.y. Update open_cached_dir()
>>    according to method of upstream patch. ]
>> Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
>> Signed-off-by: He Zhe <Zhe.He@windriver.com>
>> ---
>> Verified the build test.
>> ---
>>   fs/smb/client/cached_dir.c | 39 ++++++++++++++++----------------------
>>   1 file changed, 16 insertions(+), 23 deletions(-)
> No upstream git id :(
