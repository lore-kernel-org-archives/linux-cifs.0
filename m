Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazolkn19011029.outbound.protection.outlook.com [52.103.14.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A983D5242
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 12:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768911692; cv=fail; b=A8H74nhKCvXvEiEWFg1R7OOs/DuIYc7jb+hn3nEm3i2po5ds+kC53oFK5K+EwdtUOZU4d00+NzsRljbEY5iPb2QSsN0VIqKheR/K5yO+xGap6EfxFHV0DL5WMKoUzuqQHNOX6/KYYGqroCiNfI2ll76+cnVhrIo/VZPjQxPJvWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768911692; c=relaxed/simple;
	bh=DZAU0hE5brAYBTjDuUNzKuMXLHRygXuBeaO4lOGZFAg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=HXIdokpLFcpuWX3Ab2xunclDSq+eSt4yosTz/s23T8swFkU3InGFZHRZf3Zqa2H1LfDyzgMa682f2Jc3Mn7+h4IW8jsBPQCOdd7hTGp+kDtDUdjYInmzroRJRvepWxKJZgyFFkpGZ2xcA5Z5b49zfwUHyi9rFbTXL6i7m+HWw/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=gt23RpIY; arc=fail smtp.client-ip=52.103.14.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="gt23RpIY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGcIAebhb6ew8JJWiramydAOIObbbNxeM3xfmEEt9gqpykAhIsmjb4sO/mD5vIvSxsQ5gTkGlgipbfSYYvq8S6jZRqfoi6rS7AyXZzM/y8U4E9vUQDliQPVML990wAZXr4f1ZmJBFymWkwQ3InOAr6YvgbO2U8jWZGlKMEfoWzgGIkvR85+m70egpZU8sLDJ2tXbyU/F6TzZwK8CdVKNDMIvVx2fbFadQ47ns8xfHKc+TFCLwFXqHW69gDFhahh2EUC5isvfyEi6eiAbxvoXgJJY2QyJn4iCrN6YddBfqABWWV9q5JDYZco8rn0t1/YAgrUnrFd3GptN0BkUvRFxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ckMv2GVBDrkSL3BtslIN0XN6bqk3eaFcmtz/9TbVOI=;
 b=uNFHTc1kgkX5N2yqr6iWHd1nlBLwLO/LdYpGuOZvRsA2hWBnHXfEHJs5ZK+yJhY8kXOiZyFpCCgqI6Xmk6eVw4cvntctxH28E/kg7GFxzqZHewR2oeRzoTSPZoNWjtocPwewnPrHp4Zq0EHaeVeVaNKAx6++yJzPAAlZ4Vkw8CkfGBL0hjEsXsMn8Z7SdBxWsFy+liZthk6h6jSmc9vEZW2SADqDTMIpkjMLJJCyhuOeugCoQ7LDQWGet07eMw1VvIrM/+zYHgK1StHbPcZTAJKy01zBJZlpFWoarkhjG7H30tH/GzKWlr4QbiCqw0ALlprxwk5zwxaqEltrKSsFLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ckMv2GVBDrkSL3BtslIN0XN6bqk3eaFcmtz/9TbVOI=;
 b=gt23RpIYhqPgr0yeyxOvgQXBrtfv7A48LzbNKY5FF8uyG5uHrsALDn/e5WlF6yQGFWCTn1uk99nWoaztWIPZQ0ifilClYLL7UaDfoDWxF2F6M1O/Vw6IgXNHPY4SiIiH7n+hIuigj8o7J1vGsS0n2+4qHvN8MDaIpoy2rr0SxFH2CdPnE9UU0B/TF4Gq1JhV4IyVsZbKWq7//vk5eeEwV47ZHqQtE+6/K2BN4BvfxUrA/cm3dqeDH4n+uHqnOt6sI/OwQJio1joYrlGiihLHIsO4bqmpI08HgRJf2ghqWItbrtbp+UHx3XmcL2mK0BJulPNBhOyEyLrrqHr8O8oqDg==
Received: from BY5PR19MB3112.namprd19.prod.outlook.com (2603:10b6:a03:183::25)
 by DS3PR19MB9199.namprd19.prod.outlook.com (2603:10b6:8:2e1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 12:21:28 +0000
Received: from BY5PR19MB3112.namprd19.prod.outlook.com
 ([fe80::1f49:c79c:acc2:e0b4]) by BY5PR19MB3112.namprd19.prod.outlook.com
 ([fe80::1f49:c79c:acc2:e0b4%6]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 12:21:28 +0000
From: Ivan Korytov <toreonify@altlinux.org>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Ivan Korytov <toreonify@altlinux.org>
Subject: [PATCH] smb: client: Fix comparison of owner and group SIDs in populate_new_aces
Date: Tue, 20 Jan 2026 15:14:26 +0300
Message-ID:
 <BY5PR19MB31126CEA46F37CCF6F57F328A789A@BY5PR19MB3112.namprd19.prod.outlook.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: WA2P291CA0019.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::26) To BY5PR19MB3112.namprd19.prod.outlook.com
 (2603:10b6:a03:183::25)
X-Microsoft-Original-Message-ID:
 <20260120121424.1584156-3-toreonify@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Sender: Ivan Korytov <toreonify@outlook.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR19MB3112:EE_|DS3PR19MB9199:EE_
X-MS-Office365-Filtering-Correlation-Id: 5efdbc5a-279e-44e4-0c3a-08de581e6fbf
X-MS-Exchange-SLBlob-MailProps:
	WaIXnCbdHrPy8Gg0T1tV+ubdyTLMpos/TjOHsBsKfEWPvb2OGkk3kBr4lqjlruqzFMVBEr21bW/PFqkaVC9QLnpnlETJhR+ufvTqMgzgdTpQ8+16C9kuFVwW393R+sHxb49J13Imm/BRuGOC8kZmfj0vSlN477vUBxCh61uP7gLV1FtMTpmooVI21h8aNzY6CVjBKGITjyAilh2vgtssXBdk1jEMOpwLaNxfmESJmug9MYlH/RkWQf5onmsxYpNk8SP2vJ3u3LQ5L1LB/HLxhtwmNWVqRV9sqr39TyAm1dqwBp6r2gutBkWhifd9n9D2sG8SUMp/usdiY5OWbAiYmPanv6ZDVaMwODFJmRyum/JGs5ELfgntZLfyOwan32vTZpLw4Rr2BgvvOTsMQNZ2KPcHHPHFBxW5Gr1Fflnmnv77sFJe9+KyIwOllb3STH296DhdK0t0Kbc/bFxXkqZguu109/MpKY1SoxKp9Oq8av0CH0aCQ3opPuThhbJuDe9UJfblnGuVrr9l0bF3m7pttJA9wtpZfBapXnWOiyYnjuNk1QOfCB5i+95PUAu4/9S5W4cRMEz2J75zfhpj6clYQ/rZCw8soCdBDX6QuKuySWfwi4LG2FWzRvnNRZr60QCH21NtaXhF2G7Lrua6lIguXRYO4hUrb4zFbU4n6QPv0N5sRxT35F9fnrxFu3u3M2tBP4uu4pBX0QUERQOe6vAAwHOXd/qyyXdTdYeLUqfrejL7Mv83xPTsHMJtUeSHT8kgCySWH5+vOH0=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5072599009|461199028|39105399006|5062599005|8060799015|19110799012|15080799012|12121999013|23021999003|3412199025|440099028|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hp8dzmA1B4rKWrioGuilz2agKZOhk6zxRouDv2U9Cqcf9hOJiM2mKbeDfB5M?=
 =?us-ascii?Q?ayUi23+sHWVbDrBJ9NuIG0oZF3Xa9+9S8x7tvWzHVFRqJ9fJTpbU1kynSXM8?=
 =?us-ascii?Q?SSXCx5B1djdwA5+HHr1XLfZts3j1Bkwl+5nYlriztGND0/ewdk8Dg3t6GvED?=
 =?us-ascii?Q?hx1PL0Ou8traulYXPtkuEypATqia1C1cAgP4fBd5VPz0cnVFC+1KNbfsUb1y?=
 =?us-ascii?Q?vRZJPt4+pR7v4GMHhGoGHfBe/BKdZ1G85/YXKDOn2EWH/Bl2gsF8O3T0sW5E?=
 =?us-ascii?Q?gTuUM2+Y0z3w8r+kicz4y9TUfLS4/LeFLpteD3l123MhdnqgyBsKQg6D7HYn?=
 =?us-ascii?Q?1AP68GBy7c4UM42OtLvr5elpxNXywKiTFPjzrEaJ5gCkv3Vlr3KRAgKORGD2?=
 =?us-ascii?Q?zyRb1wGdUL4/vGUxuOjCNXY09LfYMXPW36RunlH93TN+VYzlhNhJ8uBzJF7P?=
 =?us-ascii?Q?TzZq7I4nCRoMcMq8eRpEcOZu+fquLF07uuUhsc33rpiZ5j0lM4nPAdEGCf3C?=
 =?us-ascii?Q?/Z9VgmXPuMU1X81lEUkTACAckHYMALMV5I9vx+qium1ZAiAaYR/R29yv9Dlo?=
 =?us-ascii?Q?3Yt8ec77E6qBeclWWl7g9Ro7aWFUhQn6VTU1Uiu2hhe3IuDCooTpiB3er61o?=
 =?us-ascii?Q?Gmrat1yzpLqC9zyqbWqThgWNI11gzrAptPdTxorMWXUjyrCUD7ZE43Xh2WnD?=
 =?us-ascii?Q?bSgpyhr7pDD8KZDgalsN+COmhGwVYoJAzyH1aWVEZKhz306f5kD1hxo5scbA?=
 =?us-ascii?Q?0G3gifle2J02gmDhplFBMwnsnBGRnBHHxmOQGR0+wySmxOUYNlNOZdL7G/hb?=
 =?us-ascii?Q?hbWMDT4HRHvHFCnELRwA9oIDVnmcZGPg2XM7SaR0MOmT3IBkInVXU8ssCj9Q?=
 =?us-ascii?Q?jmuNODEP0KP1YgNp4RufPn2MQQbFVg+IG1aX6+Zi8oQLfwYfC7VXvB2ubOun?=
 =?us-ascii?Q?asxf9qeBj9+tYFFpwITuTcZHq5S1jNTUf7HFJsuqKr0XIKMJEZuqou2bcLw+?=
 =?us-ascii?Q?5CWOauFVPUo7Spj5lyMInD6ZCMfXR6FRxIeBn//hcOaHJMhPD6aR1WZPkFd7?=
 =?us-ascii?Q?y6hsiYxd/WsZclZYXMOb2vfeih6+DQm5ArjdCFdXor0OZSgSUbtLpgVSrtlp?=
 =?us-ascii?Q?s7IMTnOplGMDdOOTWZjH+hCfXNDoMz+rRqRtmbSMXFzTNApMtHdT6Z+ImrtG?=
 =?us-ascii?Q?bcqahWuvxt3Nbb/5BGINJzUS00E+lVwdH+akf8VRoiwmtB7TK80wWf1mOFO0?=
 =?us-ascii?Q?K21ZZk0W23ZKxWq5R5x0Na6HdVwP8dIjUrubvzjpXQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jiMWgjDpLSlfEvOON9qpDN6bzrzSODmHVhZjJmhurXQnycFAxgorv5jZuqWt?=
 =?us-ascii?Q?OmEdQwBJi+UZg/DjEyAj1BmaSwbggmvm1UGtUpc8PbDuJHgLL1o7CsvzSJZn?=
 =?us-ascii?Q?zxnb04Xh3TNR9Xzrn8yh2a3g/JSI2b4lRMuohW2Q1G1b2JtHbQ+gR6x2V3jR?=
 =?us-ascii?Q?P4mryDmkwyi9F4hUlUyMdpWovBYTVOEhUX77YzmTIW7tniI5lQWpEFoB+hTC?=
 =?us-ascii?Q?Vkx5+LUTc0fqnUec7gk8hA/Sb0DvX7ZmVhWCMML0HM7HPeYQUUJq9SxNKO9Q?=
 =?us-ascii?Q?UpNNNqsC1bV008Zx3lp4Pm02LurjchBaoROrkfAKAzReexnvJxBhRXiPWfWV?=
 =?us-ascii?Q?cb9fO86NfT20l7LTaBMnUTphrwVCfBWw9WvKN2xrkY5loo+FHrk0WPUFM6fV?=
 =?us-ascii?Q?TfPLLLtPsjipcIidR6KzP2hbmpzY6z6aSfOeMrJFtUHSj3UKpoFjDw3cvRRQ?=
 =?us-ascii?Q?U8h87wnPM+o63GSpip0PbPEfVEiQiU0lw+YkfSFGHvFDQHgpPeF11APkO5At?=
 =?us-ascii?Q?SEnSfmq0eP3GGkePGuKMNjqhiXIvKmfs6+sJJNFPqHYU+39vYPNMm08GhQdr?=
 =?us-ascii?Q?jXh6D9SLyb59PGrQjZD77Qram238NSAmdqGudNd3I/nKUSWmKcxtIiTezZlA?=
 =?us-ascii?Q?JpW6wBDSCspd0gVOrmkgvHTN3Jolf+HRhuZmaXhlvVHeNY7xQn1HXr+exiO2?=
 =?us-ascii?Q?7rg0ABWsX2QaliR8bG7W9MQNCn2YJylZ7/zkR7fS/y8Ch9YWEmSLv+LE4l2A?=
 =?us-ascii?Q?m3bXM0BVJn2xTAqxPagkzQi2yccI+53QQNlu6Nst6HAfxo8xDqGIUUdShOzv?=
 =?us-ascii?Q?t760MEE2AJlXIEVyEhRPv8mp/q/AT5WDIEHnIgJL3rEEPdoV7sem/joHz+gB?=
 =?us-ascii?Q?UlCDO706xrUr6xqCIc94ZoIja/RcFarHaetUkgpSV2DJvwDQ75Pw7cD3kWNK?=
 =?us-ascii?Q?bTh98JXbtu37RAxH07hS3HkhiUGUEFQ/YY6N4MQuNbzjfvyv5nHLzeMXBiNb?=
 =?us-ascii?Q?gfnLsrBvrrTLcxKBLzl2fPz155ppZwfa9grHf+NoE9xDZ7NSzgGnsop3D+Gz?=
 =?us-ascii?Q?Yw0QROaODAn0Xj/59GWjU8nFqrNAHN1X7dhRKBBIaiG2ObXPAyFPw/5SwXNq?=
 =?us-ascii?Q?4cRzHzvRKQO6+zTTj1qaepQnoN4Rj+fp6Mw4DKNxum//Y5AWT4mku9poZTYZ?=
 =?us-ascii?Q?lKzfVpWsF78HKyvj/jrMZ2Du7hAf0XiVrMKJJvMLqC5uOj5njmJ+LJrVtPH+?=
 =?us-ascii?Q?BmJgXjvZ9kHH4WSlr9tSwhL6SRJL8sQ0QHtp5ZMlZ+MXP+XOrazoDrQE/s1N?=
 =?us-ascii?Q?mIa7yCOPS1qPL2ZJorlbsRDbFFhSCimCdVl+AeXASYs+KOmpYXQ9v+jCOhDJ?=
 =?us-ascii?Q?7lDCZGUvKFbiPqPmS0AQWdjVpHc7?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5efdbc5a-279e-44e4-0c3a-08de581e6fbf
X-MS-Exchange-CrossTenant-AuthSource: BY5PR19MB3112.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 12:21:28.5547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR19MB9199

memcmp used for comparison of owner and group SIDs was producing incorrect
result because fields in smb_sid structure aren't always fully populated
to allow a byte-to-byte comparison (as they can be uninitialized in unused
regions).

memcmp always took the false branch and assigned ACLs as if they were
assigned for nonidentical SIDs, which produced an incorrect DACL that
didn't reflect user intensions when using chmod.

Existing function compare_sids compares each field separately and takes
into account variable length fields.

Signed-off-by: Ivan Korytov <toreonify@altlinux.org>
---
 fs/smb/client/cifsacl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 7e6e473bd4a0..9346a459e380 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -995,7 +995,7 @@ static void populate_new_aces(char *nacl_base,
 	 * updated in the inode.
 	 */
 
-	if (!memcmp(pownersid, pgrpsid, sizeof(struct smb_sid))) {
+	if (!compare_sids(pownersid, pgrpsid)) {
 		/*
 		 * Case when owner and group SIDs are the same.
 		 * Set the more restrictive of the two modes.
-- 
2.50.1

