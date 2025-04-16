Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562345227;
	Wed, 16 Apr 2025 01:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744768106; cv=fail; b=S65JbAeOquBdRVReF2JrrSsZZsqDQz6NOAxC/p21Vb+BzEVcsfHB1zAL8uB1tgq0m3Sllzx6cEEj/OH0V0yV2tsmMWAkQnFzoczm0lcPhZjDgYX3zUAsSbJlHfTmmarfhH0Cnf6Vy5Qf7qVVZ41+wNFoH2nUmXnhgDgi+nSA4HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744768106; c=relaxed/simple;
	bh=AdlKEtkZH8xIWbZw2Vr2dyAjXGjVnaQyzjOokMqQwss=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ud+cT2OSpU9hfhb44Ll6hpYKpKEJ349HY1rXzmFw5LvhWExLnb1sb1XYnpY6Gd5S5dw3Sirp1JHnJzBBTGJBOqrjEeO65dSuhC2FNp/UeQIIKb9x1uhfIFZ4h79Xyp1dMkbYYg6+wIViDyRBnwIadTD5aszE4UHZkV3wxpMcIPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53G1AUcl026228;
	Tue, 15 Apr 2025 18:47:43 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45ykf3m2r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 18:47:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEu7G/ML3Imk7b7mRXvOp4gPiAyV1RnIw9+k57RKXOWOlqHRA9CRn0UmIkbtdBxfHXUb7v+DLVJLcUNCuPG+7gYRr/bkUljNnUsRVxIQf9iUAaXbcz1wNlmg0jqHWAVAImvJXX1vVbOa7B+nBNNsVbMV5kBZOWY4ndeQpGsjJTY43/0RiFrBGo5ryQrrilSxrDbxTvpKG4SChrZBMKuEXYT0dw8t16o5EzOkXy6xm0A6squCTrGKVTeXVmwJavKgeIrIAfWtOtE0ar5TLR6cpNidKvqIeRnKYs/sNCH8Kug8+kptSN6ZVcongb9w4c+xrZmvMX0iKK4bni8SHFL1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wc/eROlZhaRFvL0jG2bGxL4UiN/0FQWtXXy/BVj3jvY=;
 b=LAbU3srN9+3Sv4GPDeS9+fde+Y25GtZdR04sTAAl9Ly/095s659WKCr2HlOqLJcxaqsIYG5lLPvt/nVzHfZhYFErVFI/hWX833nDgFtPjYwp+MWOx8pSsbSImO9cLcMuOAO5ZbXgG0RAQs+ehTkjm2TMg9kW9bKaegTcWccSrb++3BfyCCzcLmoM6Ki7h3ITgwsZXU2SzQCdEzLsvxR9TW3KBYBL/hAKwvFN1OFgY6rLPxFHcxyiQlvVDIDwYHfF3MxDsot963w4TAr+Wo2Uluq3+ZuQGBUS5s8G1fJ3rBhKBi2+NjDKSzhg1DcQA8KJf23F2tn1Mw9ptJPkh1CD+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6)
 by CH3PR11MB8237.namprd11.prod.outlook.com (2603:10b6:610:154::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Wed, 16 Apr
 2025 01:47:38 +0000
Received: from CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d]) by CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d%4]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 01:47:38 +0000
From: Cliff Liu <donghua.liu@windriver.com>
To: stable@vger.kernel.org
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Zhe.He@windriver.com, donghua.liu@windriver.com
Subject: [PATCH 5.10.y] smb: client: fix potential deadlock when releasing mids
Date: Wed, 16 Apr 2025 09:47:26 +0800
Message-Id: <20250416014726.2671517-1-donghua.liu@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To CY8PR11MB7012.namprd11.prod.outlook.com
 (2603:10b6:930:54::6)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7012:EE_|CH3PR11MB8237:EE_
X-MS-Office365-Filtering-Correlation-Id: 9689f233-486a-42ba-24d2-08dd7c88ab28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|366016|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eBZtkD162Pe+xHIztv1sTdQpXa2lC4g9mQQ1kbvHv/nhUas+C2Pf3DtfgCp8?=
 =?us-ascii?Q?3WmZppex9fmju1M4rHw5wH/5Zg2pp3/2Hb9xZRIavC4fDTuJPkRxF5u/0AcV?=
 =?us-ascii?Q?c6gvJ0zgn9jHcpJpCr1k4YbIYro2bho9+FOzsESEVWQLvpbOwMT0IX1iefEx?=
 =?us-ascii?Q?I9Mv8BiwEj46Li+JtZqXG/1ORYToTMxd4GT4ReQrxsuB99Anf/s7JCeO/3X1?=
 =?us-ascii?Q?MKOkFchEyfWHldsYmFLgfPr1A5qLGdtt6VIxejoAKXONGV5P2rcilHp3jMY2?=
 =?us-ascii?Q?vhEM28RY7N8kSqGl0Eb0CFsk2CRMNC5eAc3bK/iBrY/bHZ/YdNz6nj7NBf7h?=
 =?us-ascii?Q?DB2We6fRdjn8ZooLQAiCk53DfFr0COk/PcyaeHrZ1gB58tJBuXmxZlicUCvd?=
 =?us-ascii?Q?Ch9txSbuNor7KJMzhUIRWPPktbMwPOzgz/KueO9nnpCYdbT7FlTgLQj07DjX?=
 =?us-ascii?Q?DkjhK6izDBIImm+3RZiYzCD5NlX05Ma/lM1Yyexy3Yeo13NAh1T1XiUB5sZG?=
 =?us-ascii?Q?qNfL+Q9uw7VkcW5qErw3kRG4WwnIfEjg1h6iYbkSocVuYCjcjQ3J3wypoSCj?=
 =?us-ascii?Q?krI5ksYWh3wNiNZ8j/2bHSGHDkLMJknv4A+XDOp+17+K/4WvDKwhrzw/eLlA?=
 =?us-ascii?Q?1Jal042M9scMSvVTb4fkJ26/8EpJKMdD7B0UCPVjowOCynkwMMR9Pn+ZaCJE?=
 =?us-ascii?Q?mH0YH9DZ+Ri/P0B7jarEwAEuN0dhWGLjRicqZgVCeg3rK+2rhaWEha2vFgCn?=
 =?us-ascii?Q?1NnxGbKiazaUe7mDlfAWXP8S1Dn1OFcA/kv53m8J+F5ajuBxkL14hoqmpFNo?=
 =?us-ascii?Q?aiJz9iHzzXxSmrQFOQvIVFeSPsDZmLx8/EoQ8f/v6q23vTExOu5I7mjG/i9L?=
 =?us-ascii?Q?csF2RAZ+i9GmisKxGbAhOje0AycYawOJDwtu2Hmgcu2AsMFV4W+ikDSvlNpp?=
 =?us-ascii?Q?0F4IpBLuE2y1+02C+BNT+97Eho1ks/IC8V2us1OL9mpMs+VtHCHGs/ts/wJD?=
 =?us-ascii?Q?CNV0UMciOgkxOtyVbvkxJYqTzRstSSeCp4GJsEWH6u0QpviXb26ntpz2IfwL?=
 =?us-ascii?Q?qhkE2+m9AFFyhLnwfO0tZwmVCSYqVsJZx9aL4FYlxrlX6pJ857jMk/3gv8VD?=
 =?us-ascii?Q?LmsTY7CqDF/wGsSh0H6QPgtr2KRepzZtTJWsRw9zbPSQLkvMKo+i/D7eLeSG?=
 =?us-ascii?Q?+J8s6Yak04q/lT/KI0Da4McNsYk8RH92e38Z7TzIYhe6N9Ig0h82nEDbR+G/?=
 =?us-ascii?Q?otpgJqxKSfbW8DjYHCkn6Yg9F2zqqweB1JMBFLbDdB6ktveqNzqCI+iTB4Kr?=
 =?us-ascii?Q?eZF10ejEG3G+SJqxmlJBRmu7sNEUJs1puvGSak0kb/O9OHUeC8GKbC0iUCzF?=
 =?us-ascii?Q?WsiWxvMHT8uwWh2o6wE6dH7ijDA7viGT7KoMsAA1g3Jz23eahll0b9Cd6VIe?=
 =?us-ascii?Q?ZUrvwXxYPIRtQHpJ42UmsZ0/0RtOofM4603Yw6YTf3PMRjGBJ7FN5Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(366016)(38350700014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lxxQGRGmf8J03bYnC6cBESt7AUwOW7KUUgCDR+3OYORxUKbjGJDW2EgbFzQm?=
 =?us-ascii?Q?mT4YLn0Om+hgIAzNSurLbwsSAddKPaC+JINTMzLE7S8rmCaaDUperMVVXDKp?=
 =?us-ascii?Q?SG8rrE9L9zihqBIMsV/8oUxK873rxADWeQ2l3iIYKSoa4BdelRLMh1YEl6Mg?=
 =?us-ascii?Q?V2eV7KMy399zMGo1f2Kxqk3hT6En6gZHkmhBS5jOWo7i0GSM9zjxd408/diF?=
 =?us-ascii?Q?vR///jPD7qyQAOjkZ9cW+4BCtmKbe10eh5+vSKlTnOYtDvxe0FqiFlEN86Ye?=
 =?us-ascii?Q?wc1iXoC/MHMYnjUatUqD/bpjLQ4aKuXTbHsf3IdjnvrkXcyqZqJIzoyheqRC?=
 =?us-ascii?Q?zYVfj1oICQda0ca4fPfNekeI6cKY4xS0aXWPsTveNQvQPJpE4zOKSCkZ1eR5?=
 =?us-ascii?Q?nndowcmc1I1jxXgYemmbejjhjrldI8croc1Ve+rqvj3rG+1in8lC4HEjO8T2?=
 =?us-ascii?Q?d3kYwmGUeGDhQLksQI/is9VB4WviS93dmUjVzSptV4TaOkddwifPPPbBI2cE?=
 =?us-ascii?Q?bVgbJ9rjLlhIXdlrTj1Iswvd9bHlbl/rsBokdNtZUDLu5Eh1fMzs7tG7v27S?=
 =?us-ascii?Q?lRupbvwTEoYO77ItHg4r8tamHWUP4MluocaAkhNstaWeXAai7+lItQI2CPEv?=
 =?us-ascii?Q?pkc7MewzdlEYrQz0FtMzlfshOY+yY4E3aH7peU9sidgV2kecj+up37eERjiM?=
 =?us-ascii?Q?TFTsv53nQ3E9eExHUUrJriuGjm8WTTm5yol5AFekWnWuIiFO7qAuHMj4sDhr?=
 =?us-ascii?Q?c8sJO3BLI5yt5p7DY0M3JkTY9bO6IBobcOOXDAqhG27JO5qEhdDqCW9qAlft?=
 =?us-ascii?Q?9mvAdQWol6Zm0RAVc9qi4oxVNlQCCwg0py92YMc64453EZ70mKPm7UtntxN1?=
 =?us-ascii?Q?WW2cnSGFYdz9LtbHsQqpNieESUMNFXE6gGIimI/JTVoIH4toni4/QJndO+kC?=
 =?us-ascii?Q?gGal1TiPzpPsKqHSmSnkalkF0AoEpFHMTR3/IUL2O3jbqKIIfHdss9ur7dZB?=
 =?us-ascii?Q?aWPPostsEcA51A1uWJw+GWww/DnwL5jTxPA0XXeevZq0AAzCh0dDMZ+lqhWb?=
 =?us-ascii?Q?P74qD5v/SyrhbrRQ1IHQh3BP8Gfrre0Dd8Ch/Uz0rTN53782xZHOlyBkxYWI?=
 =?us-ascii?Q?P/Rg+Qpm5pcMda1Y6m5BDuczHs+zJVYfaqbNtUURlHVyGzLvojXqnCL5F86W?=
 =?us-ascii?Q?IWg6F5ANY1QOwPflT1KA7Fwo6Wtu99DD9HU8iphy4Ep1+74s9INBbln9iw3C?=
 =?us-ascii?Q?cVSpAKcwSc0y3MSirh4/QWNGAUaZcTWE6lo/ADm3HPh8TVTGv8/JvrmvhXkz?=
 =?us-ascii?Q?7VgksVO28KUHqPbZHmgrerA8WtN6a2JP4LjG0YQnzcJuIXTa8Zdi6I+w7Ntg?=
 =?us-ascii?Q?QrXxkY4RAmZgmeMyOP8OewHml9w3DSGnPUFNdkHXJ96lBD+nIF7z42LJYByE?=
 =?us-ascii?Q?nhYgLND0FQK28dcWUy6neQBaxS+5wvrXt8zu3XuFWZgSOvl8sROmaTBrMq9b?=
 =?us-ascii?Q?wrb/QT8Af4Im9PigcorWQINSbQtwNHE+Ct5mpv1aKj6bZKX0qsou8vxYXvIM?=
 =?us-ascii?Q?t50PlQHo9+OjxxYRrjol8P4l8LnVRb14KaGma/dRg2rRFCzXJzqNS5IxQn3A?=
 =?us-ascii?Q?UA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9689f233-486a-42ba-24d2-08dd7c88ab28
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 01:47:38.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69fG1e6R5L/e3xReX3GcFPFxZCkWjfAa79LyShKjlH3Vcc8TTeg9Dmq+4Kb18HTtBVHjl5hxhMlJX1YFES/kBT2FeFeDGD0mam0zyYW8ukE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8237
X-Proofpoint-ORIG-GUID: PjGMmP7nbAaVzy-tjdPAOdMF2u7lhTBm
X-Authority-Analysis: v=2.4 cv=Wd0Ma1hX c=1 sm=1 tr=0 ts=67ff0c3e cx=c_pps a=X8fexuRkk/LHRdmY6WyJkQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=-Sv9Ssta-Kpi4gml3-IA:9 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: PjGMmP7nbAaVzy-tjdPAOdMF2u7lhTBm
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_01,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504160013

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit e6322fd177c6885a21dd4609dc5e5c973d1a2eb7 ]

All release_mid() callers seem to hold a reference of @mid so there is
no need to call kref_put(&mid->refcount, __release_mid) under
@server->mid_lock spinlock.  If they don't, then an use-after-free bug
would have occurred anyways.

By getting rid of such spinlock also fixes a potential deadlock as
shown below

CPU 0                                CPU 1
------------------------------------------------------------------
cifs_demultiplex_thread()            cifs_debug_data_proc_show()
 release_mid()
  spin_lock(&server->mid_lock);
                                     spin_lock(&cifs_tcp_ses_lock)
				      spin_lock(&server->mid_lock)
  __release_mid()
   smb2_find_smb_tcon()
    spin_lock(&cifs_tcp_ses_lock) *deadlock*

Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
[cifs_mid_q_entry_release() is renamed to release_mid() and
 _cifs_mid_q_entry_release() is renamed to __release_mid() by
 commit 70f08f914a37 ("cifs: remove useless DeleteMidQEntry()")
 which is integrated into v6.0, so preserve old names in v5.10.]
Signed-off-by: Cliff Liu <donghua.liu@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
---
Verified the build test.
---
 fs/cifs/cifsproto.h | 7 ++++++-
 fs/cifs/smb2misc.c  | 2 +-
 fs/cifs/transport.c | 9 +--------
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ca34cc1e1931..8c0ed2b60285 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -85,7 +85,7 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern void cifs_delete_mid(struct mid_q_entry *mid);
-extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
+void _cifs_mid_q_entry_release(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
@@ -646,4 +646,9 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 		return options;
 }
 
+static inline void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
+{
+	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 660e00eb4206..64887856331a 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -780,7 +780,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
 	if (!cancelled)
 		return -ENOMEM;
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 4409f56fc37e..ec16ab8bec3b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -86,7 +86,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-static void _cifs_mid_q_entry_release(struct kref *refcount)
+void _cifs_mid_q_entry_release(struct kref *refcount)
 {
 	struct mid_q_entry *midEntry =
 			container_of(refcount, struct mid_q_entry, refcount);
@@ -165,13 +165,6 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
-{
-	spin_lock(&GlobalMid_Lock);
-	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
-	spin_unlock(&GlobalMid_Lock);
-}
-
 void DeleteMidQEntry(struct mid_q_entry *midEntry)
 {
 	cifs_mid_q_entry_release(midEntry);
-- 
2.34.1

