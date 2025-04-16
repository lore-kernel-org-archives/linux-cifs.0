Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAF5199939;
	Wed, 16 Apr 2025 01:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744767718; cv=fail; b=qTXVptdaoPPLHr2zN3mdnv9gg7c3IA8fAy/uiW1OQRg7Uus2YXXk/XFZeWKISw5+v7YH2KAQqNd7UNcXco5KGQDl77RqKgcyplV3qqLHBFy4OeoSeO0pFRT3NL2t7DrQjjpWclc3iXjnO5ZWgnAaEQ4DqCQfAWVJzxZDyh3APig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744767718; c=relaxed/simple;
	bh=giP+yu3rsHWyw0VNEGIi5uMt9xDxdj9NwP/GqHAYWT4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=g0J3dv2iBGNy3XmYUOVGVa8bZZQIiunRBZ1jz5A9DiORvhCsrcy+ajRrEnTQH+cOVlsi6sF5RlrIn5Bgveex8pFrfownTxR1OS9qs59hAAmZjily5k6VTmp49zIH/IKfgvy2h67qih4MIMYDZXzCO/Xm4d6Ox98p+1AgcKnehzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53G0ATTr003139;
	Tue, 15 Apr 2025 18:41:15 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 45ykf3m2k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 18:41:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIgO/nP5nk5ViZOnNml75Nut9AimqnutbThQrotdzkm77tVmBzKDhqYDz7U0Bw99XXp6iiHQlPT3VZ/BbgBGwTVVrB37rPmYtgD1Qi5rLC2DXFTO9E/vD/wN3A8O7+6uiaCmxD/8n+Q9TWepYfpWi84TUyQCz9JmNHB0yFv6eBLzZjnVCtlDLpR9c4se2psLWDHdsY5G95m96Ohtk5DShYHKZQ/dJ1Aq2zWQEWbWgImECtqFj5n63KsSBeIlBbCcehveB7QlsxKY9+etSn19u/I9Qh6Fbzgl4kn9S9KNjKsDnNhiIX5S6Gd7Ovc0Iun6NfbaFXrWT53U4x1Me6haSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wVntmPoMTdDSMqK5gSlk5d4Ln2el66iKBNEcaJce4+w=;
 b=I44f7GL77mx8NdISoqxKFvcLlo+FmTxIK4HtrZtPnzwHohprvGhEfG9Rkqwxu/6z0jBboMXnQycJWGnw74W02K+1tz22EM4sZlbv/aLkL9OBeoD72T8ql71X/v7+zITd1QHpJukBbyyfolB5xRk6K7Im3Wa+XX+AzLg9EoXBP/HD4zpXs3L4ec9dsMXsk1bEmruXvdk/VsolqcK3btGj46EslqITtTCB7fRu8yVzZG2yoBACCVTMJ/RSz6j1QHsHE0vQeZPi1hSor4xjLEw/hMI6I0qgEuVIOzY1gFhiolScxjNOD9JCkvQfLAJ2wLkUO+QYWDDN7jX/ATkkHcQopA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CY8PR11MB7012.namprd11.prod.outlook.com (2603:10b6:930:54::6)
 by SJ0PR11MB5938.namprd11.prod.outlook.com (2603:10b6:a03:42d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Wed, 16 Apr
 2025 01:41:10 +0000
Received: from CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d]) by CY8PR11MB7012.namprd11.prod.outlook.com
 ([fe80::83d5:946f:3692:8c0d%4]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 01:41:10 +0000
From: Cliff Liu <donghua.liu@windriver.com>
To: stable@vger.kernel.org
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        Zhe.He@windriver.com, donghua.liu@windriver.com
Subject: [PATCH 5.15.y] smb: client: fix potential deadlock when releasing mids
Date: Wed, 16 Apr 2025 09:40:57 +0800
Message-Id: <20250416014057.2655727-1-donghua.liu@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::16) To CY8PR11MB7012.namprd11.prod.outlook.com
 (2603:10b6:930:54::6)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR11MB7012:EE_|SJ0PR11MB5938:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a23f8c-8a79-4537-a125-08dd7c87c36e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|52116014|1800799024|7053199007|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5hGq6qtU+AIb9Az7vjBUmpsKbdh19GCVDX0nua874EMi5NcC9Q0Fj5rYeCFt?=
 =?us-ascii?Q?+i+b2Kpb6RaEFV0ecDv1aoNm2o9KMt+uE0pnGDRO9ToSM/l8E2NZJj2Ch4Bg?=
 =?us-ascii?Q?5Sa7+93GWEZFIt9z0eOASnFxQQrzAxX3YDvVhAXPN8GDy6Rhi22VdYsJNjXH?=
 =?us-ascii?Q?tS6eHbDuHqmxddJwOkafbckSo1ScUNR92rt1RyAMdoT+RqoDQGLNkcLyYM0V?=
 =?us-ascii?Q?F+n3OkpO8+MjmgWNcYdvMC7c5gM7EUMbbikcHPpzEVfWCnzyMxzeGasZLWrQ?=
 =?us-ascii?Q?fup+fUS9HhbKqpBbxyPT5S+JYJBAuZMniLu9UOPhcnt9jd5Q/u/SsILUn2sl?=
 =?us-ascii?Q?2TtooDptTx4ST6M7UFMZYMNMZ4gJw9WZzaiv49TFVFdc5KdlQB5aXPY8w8zT?=
 =?us-ascii?Q?RiNV2dMWwLZjk2FvstISl/GjFnZ3TL0JsQkDJXw74ZJ3Zv70iq0iAcaRtsl5?=
 =?us-ascii?Q?IQw9QXIfOdC+SBupMuy3wfABWPx9XdxMRYl6C4RxJDimgQkiNUr8hb5KAqBD?=
 =?us-ascii?Q?fvQ+yXsquwe7dp0DZHIwPV55i2MLU6f+IznsuTJYVHfePPcO5fkIUJizkulC?=
 =?us-ascii?Q?F//0NT1uJ4PyAFR2ncTXWgsh0TtKyvvtl+JCq9FykngBg7y8nBLNdigZGw3/?=
 =?us-ascii?Q?0tPokJNBfE79WKXxH5Rogs4t7MbCpEQ9P/sKg78PuiySvsSzSPnxi9+dKA5/?=
 =?us-ascii?Q?6x0BwHVdwR4is/LEDOjcLWHcygFC3baXMxDDn0s+alZQ/9W7rxJIlgv/Ir/s?=
 =?us-ascii?Q?Rs6uuZyqldGsxHA2U/CS29tLYARWPAhxupwRimyQUzISQGWbvCdI+zDOBI1V?=
 =?us-ascii?Q?/yZmbhVkjS2PEvdnd00yj/t4TjRNVfZq+aeJIJu7IcXqfBXEmkEHuoJqyBJB?=
 =?us-ascii?Q?6CMiXx8YtgePaaPlEq9/qi7n47nlyC/LBxOngwLcflbrEJFZ/TWnV82FFdxa?=
 =?us-ascii?Q?yy8/W4rgY/WHu4zhEYuN0x1p0VuECPZvc/+VmkV3iPlLHjgz12hyrQru+trD?=
 =?us-ascii?Q?th3R17DeTUWruEpGsWmJQbcMcXJmToCSpeTkgp5xBJRnR5f2YS8RnJbvbKdY?=
 =?us-ascii?Q?q7Keb8CfFieRCKg+opGU2S+DimeVU72rC7sktrrhYfbvUwj3jxGD6o0sfJPH?=
 =?us-ascii?Q?o6s5rRRy/e0PTitJ2JxytTG7eCRN4/FO7ewKiAnIs9e/FOf3hiHTP5R0ZMuX?=
 =?us-ascii?Q?aZJPgaPFr6/xxB+mF/OvlJsCFE3jmdm21+gftW3uRbsx4y0I/tvvSZJXyDcT?=
 =?us-ascii?Q?BwkNUXY1GuJjf0Z43H6JOwSif8M8Pbw37+Bk8s04QdOpoaSVbi7QNDHPYGy/?=
 =?us-ascii?Q?iphZhARMx7v29jqGk1IB6SDAeYVawPZtHM+DOFAIZCjkoz+Ub4ibjbKS9HUQ?=
 =?us-ascii?Q?/ZlXDxIZQ6ygFZECeeBLoAXal+8/F/tHad1O/3IPyQ+mY8jME4SyGczDWHu2?=
 =?us-ascii?Q?t+XN19hZvYDgHd1+xf/cYR8VG64ekiFe3zMYQPezaVct2mPg6eoACQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR11MB7012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(52116014)(1800799024)(7053199007)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?unCB6SVZq6ZfDPiFPwtQwNeblhH/esGk93BMJBLjmA42nRI2JnWQPZqdLcTT?=
 =?us-ascii?Q?fnJ64nzKwaQ30mb3Vtt8UALH0gyTBoMxdA58Djz3zLsvHO9aZW5wiqhZa95F?=
 =?us-ascii?Q?xBVy6tgWJcCxaCsMM0jyKnWGsSdhxbJZIhyZm1NbbIaAjmRSf/Y3sk8HCW66?=
 =?us-ascii?Q?wBGln4qYRx/sgh8yOwNrTT1hO2tPtNswBcgZaG8KemW8PbDkqHcKoYDBumaH?=
 =?us-ascii?Q?NPftPEArZq9fbeqvBY83s253txvi0Lpd7eODn+PvxnS8aHA5dRWNC2Z7wwm1?=
 =?us-ascii?Q?gYesxoptCuJyFWBMSsfKWW6o0LHLX2b66A8phRI8Ymml55xL1ag2Beudn5ec?=
 =?us-ascii?Q?b7KaSFdJw76t0eqOwAr/cBeLp8kQ92Gq8xb0I7szUe7lqlI76N2lbtXu3u+s?=
 =?us-ascii?Q?Dgz1UzTehQCQNXs+KGpIQOBQtJbrURNg/4LIUpPi4/z4owwmDojJNIil57Wj?=
 =?us-ascii?Q?iH0rXjStU5TelPA/64smz3kIb4ztphG++mdvh1/CaI4ak+igRtyYGeLRJlMD?=
 =?us-ascii?Q?rbPAvfQ+GsynO/OUFXHBkB8nMs1pBkkqlgvPu7kQAeKPVu2b7YWFD+6urvmf?=
 =?us-ascii?Q?ZD3o+In+cKo9QTVEoDLPNo88nY2BpoU4XTRMFuJ0Ded3LZbYjceKIxRd+EWh?=
 =?us-ascii?Q?cilbP9jqbciBR2CWQpXg3SFeIr69mET1hGfA+jLjkhpxMbGoOArRuTWezWF5?=
 =?us-ascii?Q?JDeHoTqxyNko1S0Qsi1V6QenBmmtHDk7Nylb1OE+KGCUC+BSIhOjFDrJjKuO?=
 =?us-ascii?Q?TZnDPlOq7VoP9LmJz92sRd7TAWgKCj1dA6UAyd547h3xy0ltlgkdcOv4PYTC?=
 =?us-ascii?Q?sTPzd4Oywy5+1GMyYps1IzAiYiWEzx21SvZqgfl0MxRICZyG0tVhPPn87D3t?=
 =?us-ascii?Q?pOmabnV0FNGC3gH5JCAdIeu/4YOYudAwjzw44FcsIlccKHmKF1kvQN0x5ryH?=
 =?us-ascii?Q?twcNr5/RTzFA8oXqGFIDL3bjqt8jaTFB9MKyx4FjchGF9n7nWfHD/j6YTWvQ?=
 =?us-ascii?Q?E8DcbQM53qKwYA70m9Vh1szRATyeYPpZVUBxeRC4Giq2zzo8fpsy3vfWGHeN?=
 =?us-ascii?Q?/6e/TnC3RSTe1m/N6peihuFAFzvattmEIQQctet7X9tRweB7Cmiwl1tGWdit?=
 =?us-ascii?Q?CSDDbqSR0EWZX8rdfd0qOQd97kCnkILVqcLiREOGMuJCrikkPH982Ywlea/y?=
 =?us-ascii?Q?sdBhkDp4u16EZZwd0aiFen43kucuK0nigSACP9haBCvsc1q0CNvv3nPsDvDC?=
 =?us-ascii?Q?JRULhP7tlmxM+mgDU/57HL8pCYTgLr2CO7h3UVDuviXODQ5FMcyDShXj8jxp?=
 =?us-ascii?Q?smY90uCWXu7TmM5BWm1ivpNrQpeodHif3az96PD0pZGdWKwlz2aIETNm8aeu?=
 =?us-ascii?Q?D+vpUwB0d+DlBGRAN8c0Ar+rKLzt68JaN1ThrqfsOWkOxyTKXyMFPGpD8ZwV?=
 =?us-ascii?Q?NeovIx09OocmGOS411aWh3hPDNbvdPKx8Y2EGpIdezde4ojGF7/xnnSJceYs?=
 =?us-ascii?Q?PtLHh1dmoIbW6KQzjpVgohq5pXIwdiV28SCg4hsmNCelM9aQ0DfuS07kjN8O?=
 =?us-ascii?Q?CJcKloA13OIm2p3xIDGGyeoLF0RxIOLOjauthZNQb6Wq6KqwKmaaPsWQ7Jrv?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a23f8c-8a79-4537-a125-08dd7c87c36e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR11MB7012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 01:41:09.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 37Ptt3l0WxC+CvQf1sPRK66zmDHLmmiMuFGfd/G3rbuvR1hUXQG1oBIoNRdR0lPvbjQwYEADxolfdtR/ni7uxKL1P8QCT8qUIoEc8pYws54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5938
X-Proofpoint-ORIG-GUID: eZG1owrV4FfUXCYe6KOdKosBVIQDYPqI
X-Authority-Analysis: v=2.4 cv=Wd0Ma1hX c=1 sm=1 tr=0 ts=67ff0abb cx=c_pps a=YkRwJB1Lcas13D3J5+BQ6w==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=XR8D0OoHHMoA:10
 a=Li1AiuEPAAAA:8 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=t7CeM3EgAAAA:8 a=wiVl3jrDMy8VPOfTkJYA:9 a=qGKPP_lnpMOaqR3bcYHU:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: eZG1owrV4FfUXCYe6KOdKosBVIQDYPqI
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_01,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2502280000
 definitions=main-2504160012

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
 which is integrated into v6.0, so preserve old names in v5.15.]
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
index 50844d51da5d..7d00802f9722 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -83,7 +83,7 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern void cifs_delete_mid(struct mid_q_entry *mid);
-extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
+void _cifs_mid_q_entry_release(struct kref *refcount);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_handle_standard(struct TCP_Server_Info *server,
 				struct mid_q_entry *mid);
@@ -637,4 +637,9 @@ static inline int cifs_create_options(struct cifs_sb_info *cifs_sb, int options)
 struct super_block *cifs_get_tcon_super(struct cifs_tcon *tcon);
 void cifs_put_tcon_super(struct super_block *sb);
 
+static inline void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
+{
+	kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
+}
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 8f409404aee1..89a2f38f17f3 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -759,7 +759,7 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 {
 	struct close_cancelled_open *cancelled;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_ATOMIC);
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
 	if (!cancelled)
 		return -ENOMEM;
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 49b7edbe3497..57d72eb13f8b 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -73,7 +73,7 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	return temp;
 }
 
-static void _cifs_mid_q_entry_release(struct kref *refcount)
+void _cifs_mid_q_entry_release(struct kref *refcount)
 {
 	struct mid_q_entry *midEntry =
 			container_of(refcount, struct mid_q_entry, refcount);
@@ -152,13 +152,6 @@ static void _cifs_mid_q_entry_release(struct kref *refcount)
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

