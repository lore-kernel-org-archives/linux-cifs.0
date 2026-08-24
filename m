Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0230E2BEC43;
	Mon, 24 Aug 2026 00:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533016; cv=fail; b=R9N0kufZU4UTtUMHhh8Brtxigpk4+Gx3VvZUdNBm2Oe3xWlth+TbLGmL11fS8/fU/LwCj6jYkw8E5gi4C+Iyw7MQMK7nZzaRjj+cDD6I6e+yHEOSM5GvyMnIy5oH5dV5GarSuxj4zqVDYb1jnn+ZIPccyLk1uD+xaWj370yRBHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533016; c=relaxed/simple;
	bh=8RWzXVZEjDOj8MlOVChB8ImYwz5zwtKOYihAeHreM2w=;
	h=From:Date:Subject:Content-Type:Message-Id:References:In-Reply-To:
	 To:Cc:MIME-Version; b=gMGYfAl+zrCdb59B7UEV44LqWcae6k1xpInMZFFBTchM5D0b8dnGxk+XfKWMaurz2Baxc8qwVWkujBkxcRC5NvHzHuMYDEXggF2IoG66UhLH4JWdfW2/PbxraS8X6SHJ7PCFp4cMCJjP3lB0e9sf3tqDoFVwfmZhJKQwwKqoag0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=SPAingN/; arc=fail smtp.client-ip=52.101.66.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="SPAingN/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cIBt0DzuQ8s0f48F+rveiryUGTpvKKGEYan7g3q7RxAiUvLCU91RnsgretvJAHnNL7srfC3dw6e/FleNwbG5a21MXoX0kgolkU1CBkiMsc/Eq/CDx+0tSRUltYRtM+9Q5jZrGVHttMtJNm2VmF7sdmmeKs1e169IeVhYvttV0E6sIOJdTf0N8OMxSoxaPVjbxfso8jGIy2P7Ief+DDWVCWNsXTzzQ/NUq1K0VVvgmerorArRqE37UJbJt7rykNJE+8rkpZqbntfaz7+WUi7wugHkRgZNbnIdZqdwsnbWMWqTNGyYYsHeoXtrfYYg8T9d3kBNUdkCPoNwLTnVmHmfOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQUG/l1C5cWbCkBQvAnEOL3DD5tAxb/wkBdsmSbVsTk=;
 b=CHglgl0Ny8RYZOOAAi3wlxgn7Bt+cPi9vGe+g3+xmAb9AWjdqA1f08iH8E3/02Dhailj4nnSM5+GnbxnQW8r1f/Gvy/fqUUnfvdq2Qohjxnq8Chl6CuhCfWM8e7fFBfMnBudG2VDnth0ByFYrcNqZHZj+QSfMa+i22Fefj13V4o6AUehKPFcHN5Ye1wcptFgswIqk/SHlZLMqvkMXzPrjDa4MHz/p1ePVfDOCfDMNYXtDYSBatRuEKmNt2NqwRrkQeYDio/sj+MiKN5+0lWbXilP/C+jzd5uiLFFeR879hTWHmt/4xYe7VtTiOcMYtX+SD8pOEGqQZZ4cuFGdfHocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQUG/l1C5cWbCkBQvAnEOL3DD5tAxb/wkBdsmSbVsTk=;
 b=SPAingN/TF5hoYppljFVC18KwSp/Ac9yCWQgQLyWuTP1m/sMl1Hz3hEmvtRSHjtUXlxQ00aM6ix3qUvLBu/5QTYp1tKW+fsC9BOoWNKHxOCF1YgDGRG3FcIusFVFYvBh2RBh0vsdnupXZ9vo7fOtE6o5wt2OKvDc/gHB4oMTtVCng7CE/bebnnZTs7SdGAniQzujSIvxsUVYwkbbyaMh/o4iQ7kGalB215UpRTWaiNDwOIj2nV3OT2cFZH8eHfR6AfSljgV/qQZga5/wI9HynIP0XE00bJpO2/ukYahiLMXhvGanAhM8i05RsR8I0qhyLN7E6nV+TGTUg61DQNsU2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by GV4P189MB3726.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:2b6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.5; Mon, 24 Aug
 2026 00:56:50 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.005; Mon, 24 Aug 2026
 00:56:50 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Date: Mon, 24 Aug 2026 02:56:30 +0200
Subject: [PATCH 3/4] ksmbd: add fencing for disconnected persistent handles
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260824-b4-ca-v1-3-79d6ae0ad2c3@est.tech>
References: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
In-Reply-To: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
To: Namjae Jeon <linkinjeon@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yunseong Kim <yunseong.kim@est.tech>, ysk@kzalloc.com
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787533000; l=4289;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=8RWzXVZEjDOj8MlOVChB8ImYwz5zwtKOYihAeHreM2w=;
 b=fAjB1Fo4wtpjXfRpd5malkjBSJmRGD7AFHRnuBI9pWMLpggmGlGelkkWkxwe5UYnDNQnxbq6k
 DbY3BmHtOyxCNDMBJNHq1CtQJrnqG8PFEowGsRzoXIPKpYqZ/BaNfAo
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: GV2PEPF00023A1A.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::21c) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|GV4P189MB3726:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b5f282-6749-476a-c15c-08df017a9487
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|23010399003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	gubrsc7GACH1GFPQBu3jcb3AS/0fs5aXtLewynbZGM3zykrPP05RizEaY3QJaPb/4sSDhjhv7cPEyva59gRwFOO/PcTB/Ps6quOlgoXB1YM0vVvG5gTTJz1/4A1ne3kHCmbxZGnUoSqMb5/35zcjU26TvanVzXtCsGwquPuH8Y0dBxwmzakp0fa8wCq28HIMyswUbfhqe9DCV+zDdld2El2bSrScOVFDj8wK4q8EgmoZav71HECIpiLw2ks7PIGoDEqmDPSWs7bTxQi7ys3J7K9v+Esca04FdF1ix2p7aDTR0cAhawPQpjxfKzOZPb4/g2iRZyIWa0xt/hnUkoDzYks78Gyr/gU7+KpUcUKgwdOKAcSYvXNnITLCe5xsTy8s0Rw41Dhp0A+VTZ564xzLyFEopyS7WsTrDrvyPB0K1wBUoCJVfBy3CvQnpQvE8p6VX4itdLbEPCBhx2UZF7VAVhgr+jdkDqQUj3cFybGt+cIWsECjSyhoMYa6B5ObyiXoeQQVCc++bFIxGyThMHMNqQtpwZV+nfV+9T4EPCVEtM1WXjPROl9/9u/BOc065BbaCr7GGr5eAoDhgoRxflcR8C1RV8NTH8f6brnmPDabYxF000thXM/eu/8iYClg2VeF8p/R4mp85p/XzA/AwF0PE5K4RzlkAC0Fu1kKnwKiX4c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(23010399003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1lNd3YxWWtyWWVoY2FYcHdVajZidWFwMFdnVEJpYTRzM2orZUE5Z1REZ0x3?=
 =?utf-8?B?OWtMTzlRRCt5Mmtvejd4ZFFNSndSZHBxS0lHK1ZWNExDNGhkNE1aTU1HTjAv?=
 =?utf-8?B?eHlhYm1HZGlwOXVvSFpGS1V2cjlvcEFoK0p6NnVRUTdRcWcrYWF6N2k3bnV0?=
 =?utf-8?B?R3M4UEVwU2NWME0xSDRnNkNPV241aStLTGRxcGdFNi9xVE5zbllTQ0VQY216?=
 =?utf-8?B?b0c2a3doNWlpR1JoSkxhalNQdFk3L25RNklwMm1TdFF5c3cwR2I4blNrQ1Vh?=
 =?utf-8?B?dmxabVNUNnA5RjhJRmZVOUJGQkhZS3FHSWRtS3RLVFZmTHU5bnZiZDFRTGF0?=
 =?utf-8?B?Rm9nMlc2K2xLT1NmelREdXFDNEwvb2NPSGJVSnY3K05yKzBRL3FIUUxHVmJN?=
 =?utf-8?B?Q0MwRXBWTEY3Q3dNWElFb2w0cTZ2eCtCOUk5cVFwQ0lHMys1NW1IRnc1YTZF?=
 =?utf-8?B?NzBWdFJybnZNNjNMeFV5eHJZaWhRZ3FqZUJQV3pmQTl2WlRGcjIxa0JsT2Rw?=
 =?utf-8?B?Q1Z4cGhhUlJWeU1oTjg1VVdXRk5ob2dRTXJVZkFlYXRFUk03clJDQVRTSU1o?=
 =?utf-8?B?YzBKRnBIKzhDQXF2KzBNNER6RG1FMUVqZlhCMXZMOGFmMXIwdzkxVVR1alpj?=
 =?utf-8?B?UzZYRHhUUlNGSmNoNjdpYjBSMVdYM1d6THhjcVJaZEV6TEw5OEVQWGlUalhJ?=
 =?utf-8?B?K0Vidk5VWW12RkZoTG8wQ2xZZ0t2UHEvSm9ITE9JWWpteUpxUEoyZzJRRUJa?=
 =?utf-8?B?bno3a1RVRkI4a2JjbkR1Z1RCb3FUS2JPVTRSSVhDdkhQNjlCMzRMZDRWWVlE?=
 =?utf-8?B?bFE0Vk1FeEN6aGtmRWlyMEhMNk1iZHpBMU1UeDB1VXhqbXdnMGo1UGtnNW5s?=
 =?utf-8?B?dHg3QjByQm9zUk9qMlM4cHRRMnk5YWtvL2toTXM1YTBsaDlnM1FXWUM5cjg5?=
 =?utf-8?B?cEdJSGxpTDJkSnp5NlNOUm5VOHA5TmZMZW9CZTRaWHhzdmtna1lFZFhyblJl?=
 =?utf-8?B?SG9KV1A0WTVmZHFjWlJIbG5ycmpxKzdNVWFBS25oSmdRMDcvWDJlWVVhd2w0?=
 =?utf-8?B?RUE0SWYyVVc5MW11aGg3WkxFMDZRYk5GRlB2Wlh5UlErSFR4LzBwYis1R04r?=
 =?utf-8?B?aFFxU2xPVE5QR0UzQWtHUzl3RUVvVkhnWHM4ak84RjdickNKUjduZlQ2U2RL?=
 =?utf-8?B?QmhXQWxBeGxqRStZcU5JaU9JVDFhZHZBV0ltVmQrbWxuL2xDcmc4Y2FKT09m?=
 =?utf-8?B?UEd4ZlJrTlQ0TnFzZ1VXOG94aURsdDdMdFZaQzBoTnFReE5DR0hjd0xtL25V?=
 =?utf-8?B?b1dHQUpvWWlWcWlZY2tVclY2cU9HUXZxWXFRZm05bmZtekpPNjhzeU96OTBR?=
 =?utf-8?B?Wm4ySXgvZFJ4VFVkOUxpdlp3UUhZSWtlbmhYdXA1MVYrVkZaaW0waGhQblJt?=
 =?utf-8?B?ZWJqYUhjNk1JZUtvUEVlbEpCQnV3Q001VmhscmNCMWUyalB0VXo0ZDVzbkwr?=
 =?utf-8?B?ZE1VdXBIdk5pYS80dWVxd2dJNXhQR2pSUUpLSFo4eFdFSTNnbXNXc3VSRGFG?=
 =?utf-8?B?MFYvRmwyUXpqWEgzS2NxN0FsUlhjZ0FoSVIvN3VUZTVVNXhnbTNHMURreERP?=
 =?utf-8?B?SnFPdk5ZanFySWNUQlpUK2tOODd2a0pwWDNBSTlnOE9CQnlFMU82UG1Rcjg0?=
 =?utf-8?B?SjlSRk9nODI2bFZXdE9MSFVIVEl6WWcxWElRZzBtUTVYQnhrZ1dlZ3pNNUN1?=
 =?utf-8?B?NFFjZGFqQ3NXdFV1UXFaQVVsTE4vZFRDYmZvaUV1anYwUE1OT2hXSjQ1REpK?=
 =?utf-8?B?d21oaW9MNTBPcm53L3NyYW51L0o5VjNBYzd5YWZrSWI4aHA5elFYR2JxbjNx?=
 =?utf-8?B?MzhiUXY0OS9wRFlTUjF5a2k5VmgyL0JPZlRScmdkSndXcmp6NzZyVTdGTmp0?=
 =?utf-8?B?ajJld25keDJ3YjVNaXIxL3FaWFpSVGZ4amtlNGw4aTFZWUJlUnc2YnFBUlky?=
 =?utf-8?B?TDFzcTd1L1FmMGZWWk1YVEkvdnZ2ejB1cTNuYlNFdVNaMVMyRTJLNm53Unpr?=
 =?utf-8?B?R200eWFMZDUxeGxucldNOGIzMmhEcWF6TU1YV3U1Vm9GL0lPRUcvTlE1U1lj?=
 =?utf-8?B?bVNydTZvU3gzM2ZQcEk2NzVMZlhZYmlzQVRSeXp3cWErQU9ha2pCZTNLV3ZT?=
 =?utf-8?B?K1VoZU5aWnlXVWRkQ2FzRjhYNEZKZ1h4RlBtU1VBcHpKc1FQQkZqdzBkZnF5?=
 =?utf-8?B?OThrNFBQNUUwZE5QeCtHaVdjbmZZSDdlNldVTFUrY3ZPaEtQWjJxWFZDejBO?=
 =?utf-8?B?QkYxcTIxOXIyV3NPazZJRnJudmN0MjRkdHl0Vk5XbEJLaTh1VFQrUVNFTlMx?=
 =?utf-8?Q?vTxgqTqSpvG8QmaLTniStUZVW+WQfbniiunSAWkMBeQ35?=
X-MS-Exchange-AntiSpam-MessageData-1: 4muYZ+OwFd8izg==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b5f282-6749-476a-c15c-08df017a9487
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 00:56:50.0345
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: drpTA18o5U9Xz4c7V5YL0tuRNKcl5+x9exs6wCOKSyt28Qp49EN0l0qsHeRx43ZdXnzZXJibfI7OBMEvK9sHqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P189MB3726

Per MS-SMB2 3.3.5.9, when a non-reconnect CREATE request arrives for a
file that has a disconnected persistent handle from a different client,
the server SHOULD fail the request with STATUS_FILE_NOT_AVAILABLE.

Add ksmbd_has_disconnected_persistent_handle() which checks the inode's
open list for any persistent handle that is disconnected (fp->conn is
NULL) and belongs to a different client (different ClientGUID). The same
client is allowed through so it can reconnect its own handle via DH2C.

This fencing prevents data corruption by blocking conflicting opens
while the original client's persistent handle is preserved for
reconnection.

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
 fs/smb/server/smb2pdu.c   | 13 +++++++++++++
 fs/smb/server/vfs_cache.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  2 ++
 3 files changed, 60 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b4bf36fb7183..36efc3f0bf15 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4427,6 +4427,19 @@ int smb2_open(struct ksmbd_work *work)
 	if (!rc) {
 		file_present = true;
 
+		/*
+		 * MS-SMB2 3.3.5.9: If a non-reconnect CREATE arrives for a
+		 * file with a disconnected persistent handle from a different
+		 * client, fail with STATUS_FILE_NOT_AVAILABLE.
+		 */
+		if (!dh_info.reconnected && !dh_info.replay &&
+		    ksmbd_has_disconnected_persistent_handle(path.dentry,
+							    conn->ClientGUID)) {
+			rsp->hdr.Status = STATUS_FILE_NOT_AVAILABLE;
+			rc = -EAGAIN;
+			goto err_out;
+		}
+
 		if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
 			struct xattr_dos_attrib da;
 
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 81626d204249..48762f743789 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -788,6 +788,51 @@ bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry)
 	return closed;
 }
 
+/**
+ * ksmbd_has_disconnected_persistent_handle() - check if a file has a
+ *	disconnected persistent handle that should block new opens (fencing)
+ * @dentry:	dentry of the file being opened
+ * @client_guid: ClientGUID of the requesting client (same client may reconnect)
+ *
+ * Per MS-SMB2 3.3.5.9: when a non-reconnect CREATE arrives for a file with
+ * a disconnected persistent handle, the server SHOULD fail with
+ * STATUS_FILE_NOT_AVAILABLE.  Exception: same ClientGuid with handle-caching
+ * lease or batch oplock may attempt to break the lease.
+ *
+ * Return:	true if a disconnected persistent handle exists from a
+ *		different client.
+ */
+bool ksmbd_has_disconnected_persistent_handle(struct dentry *dentry,
+					      const char *client_guid)
+{
+	struct ksmbd_inode *ci;
+	struct ksmbd_file *fp;
+	bool found = false;
+
+	ci = ksmbd_inode_lookup_lock(dentry);
+	if (!ci)
+		return false;
+
+	down_read(&ci->m_lock);
+	list_for_each_entry(fp, &ci->m_fp_list, node) {
+		if (!fp->is_persistent)
+			continue;
+		if (fp->conn)
+			continue;
+		if (fp->f_state != FP_INITED)
+			continue;
+		/* Same client can reconnect — don't fence it */
+		if (!memcmp(fp->client_guid, client_guid,
+			    SMB2_CLIENT_GUID_SIZE))
+			continue;
+		found = true;
+		break;
+	}
+	up_read(&ci->m_lock);
+	ksmbd_inode_put(ci);
+	return found;
+}
+
 static struct ksmbd_file *ksmbd_fp_get(struct ksmbd_file *fp)
 {
 	if (fp->f_state != FP_INITED)
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 502efb16f05f..c562ed1c9ee8 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -207,6 +207,8 @@ void ksmbd_fd_put(struct ksmbd_work *work, struct ksmbd_file *fp);
 struct ksmbd_inode *ksmbd_inode_lookup_lock(struct dentry *d);
 void ksmbd_inode_put(struct ksmbd_inode *ci);
 bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry);
+bool ksmbd_has_disconnected_persistent_handle(struct dentry *dentry,
+					      const char *client_guid);
 struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);

-- 
2.47.3

