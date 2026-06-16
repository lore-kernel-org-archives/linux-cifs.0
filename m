Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020106.outbound.protection.outlook.com [52.101.150.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF1F35504D
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.106
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781605108; cv=fail; b=mYy85sJKdmiAuECf6rO5ezYYAUVOiIh0c56sHlFZrE2NO472Z5xFci2qGFL4uJXD8EG/d43bnLM4s3usVyYZeTEemEPc8tN/4WDiXrZt1w5MBCE2heuEvkdeF/awsl+pZ1hdZ1ENcTuBBSff6zYVTPwDU2JLDq5X6ruAafykBz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781605108; c=relaxed/simple;
	bh=KZINkKp07HYB5zmF1Tfu0+x5R/4W2WNNoW2WzIKkv4o=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=nMLEDUEZCHETLOojrYbnXuLOUtIRFaU9aDmHIyOs0cRw0m/gJV3u/pk6UdCw8QtN6/jfwyWfhnbA61/77fd69Pzv7rv4lL9ulLWZPoMFTlApdDJprXqeIKdPl13zhPVZabuY0j8GauP5xbeZC9QS5giemV30OBpAnYqbuN3/m2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; arc=fail smtp.client-ip=52.101.150.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3mqjJFVF5qn9TKL7bv3pn/c6+ytH/IgvlQRsVBrPukOipJOhD9DRWz9VWTcVVTHi0hnPIM+4YEy2BD/8Hf5C7arxF8ZKgKgCFd/NtTLdpwHibUnzgTPxcHhX0lRfL7JCm7VIeCKM57FCPSSE/V+oKil6hho7PSuTH+M84Qy4I318vPmL1Z2acp8cWZBcUInfx6Qkx3gIkT7WORlojB3FHzuDly832ER1B7AsgTO8QuJ6RqlGbvoIz4b2RDNDT+DhwurfETshm8egiW+kqxhELlSX8K0eJ3yRh7gyvzBiG3kzTk4QPH6o0xYIa7QMQm0i9IqaB0vRxJ9DZxTTOuZ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlIZdpPLCECoAJkHDvuW225Ni8VEqp9fxE11Zac2vOU=;
 b=LM5nxDoT5eQHhG5bd5HRlf2A0TXIwPYunxgxP6rXfCCHy1e2uDx6DXw/8lpfJFrsOujVzOYiqhtFf5eTodDhbrClfNOgUjNXtq8JwkPhR4OxIXdioNg2Gh3gtmNWNwWvWWq7r03t/7d2cJRuyUIuClqnoUodTWUlHXkZcaUjSJgeM6bMCUPLgu4A/vy3UDEQpGLOY+VQYqNsd3xJtzPDiglH/IdD5n5a8pXMCtSczCfutW3PSobwfyW524MVDjJ7TaAEmIEare1g+dR/MUXSNgm+7vlNo7MfaSPr7CDMDVD00YrRRKVmVzPgPBjPoYNMPBmxIzI2EsbXwx8UyqtBUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=heitbaum.com; dmarc=pass action=none header.from=heitbaum.com;
 dkim=pass header.d=heitbaum.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=heitbaum.com;
Received: from SY7P282MB4909.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:279::22)
 by MEYP282MB1687.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 10:18:23 +0000
Received: from SY7P282MB4909.AUSP282.PROD.OUTLOOK.COM
 ([fe80::21b6:91f8:614d:1fdd]) by SY7P282MB4909.AUSP282.PROD.OUTLOOK.COM
 ([fe80::21b6:91f8:614d:1fdd%4]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 10:18:22 +0000
Date: Tue, 16 Jun 2026 10:18:08 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Cc: rudi@heitbaum.com, pshilovsky@samba.org
Subject: [PATCH cifs-utils] mount.cifs: fix const correctness in parse_options
Message-ID: <ajEi4CyvM6bcl3bp@a2f8b33cc4be>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: MEWPR01CA0130.ausprd01.prod.outlook.com
 (2603:10c6:220:1d3::19) To SY7P282MB4909.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:279::22)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY7P282MB4909:EE_|MEYP282MB1687:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d6f6f40-d374-4713-4b7e-08decb909807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	G8TuSErqwgyyB5wrolcr+hq1DNN13K3CEPQRipEInKis9udRMrht6Td/km7RuNVkcwuGeXyqc9G8CkdZpB52DRI/5CPhcdJl1j1lLW1zc900OccMaCatF5/03hTwaU27HuwVjZsZ1GwiEfPMOzrVNpta5uXZSf3GHD1teT1JlyAoQ09muRG6z7hTmJAjQlATPPkNRbMvr9A5Nsyzz/1lwj/Qc+v4PfU2qj2eagSqqVgAlV0ic5RNpScbBO5Ync+D4i/7BWSv4D7O42FvNO9gxQqd4Nks+FUDuX5E8Grgm3bZsQmDB4f5xyYW0KRUC5XfdLF4QPth3pulbR3PkEFVGhXxciGsxnCG2VdxJHfYxWQaGJHQzktceufN4uHDGheTIzNyFO/iOOzigs6sRFPHc8GQsgefMqOmT1JVu5au8Y5Ee3YJFX9Q789TcQCMlVH9kkvHv775GjNOcKQK1LqFNXAGkg/DQlaFU+K7mWslTFmN3wF6RFlPFgP85tRDOlJebd9DHQujqmOIPaPDYUHaB0N5/AyfbxDbwjW20vHLdTUwIMoITjRSn+jGSVVr4ea4sXl82zZ3B1GGOdMji/DVWjEILdg1+y51rkTpf3MzcWC23y4bbAdZAzxlfElR4xqSB0QQDj1bPUaGlvRriISSzdhHpbDd2tcNjJhByhNBP7t4am20AqkDGIkPG1Ivrc8I
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SY7P282MB4909.AUSP282.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(18002099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x2RwYp8C3d5ymWsubGWOJgXwSkAITs1lK/2SFS9JExJxBwXv7vbfpN2ClffD?=
 =?us-ascii?Q?0fWPzf9+NHOyU6J0+g3FErbmbfd7UNC2411qvpfFybGxlgVaCxV2UuL7rcIW?=
 =?us-ascii?Q?6O3pDIknVyZL9LZfbnIKR4LeNMF1dtaqgDWffjFPblj+dU1WZvYIP1MdyVK2?=
 =?us-ascii?Q?rcaTESAwkV5iqdDCpbrvNtDXKESZQfOEvNmgIqtC/AjwSoUM2y6XtkR1D2HI?=
 =?us-ascii?Q?+Lmiql0SCnfJpSFYR+qtBgS/ogeKVC23JYOG00i2NFA48PQymvtPpLHlMcNF?=
 =?us-ascii?Q?I+bQwClQ0pBo6g73G85MWgeLCELi9nLlDYBZQrlY7Ne8noUBpiZoDXlR8lcW?=
 =?us-ascii?Q?RgnSv3N/YaVkptteI9Ut3og41672q4zgz71Vk9JYM4LnEkDhUMJA1iLnwNFO?=
 =?us-ascii?Q?mHe3m8YNVovGlmH6ZMjaTB3084dZpuNsl4uy78+yN4oJYafcaAPmN71qaWFS?=
 =?us-ascii?Q?Saq2WOZCGuu4NvXNfKBp1xio1a7s82DD0TZupVrILoRLmlNzVzFXt9GdOjGP?=
 =?us-ascii?Q?s4ZQvjpn889k7lD13m5QvEdKsol0Kjt9isoGs8Hwt9egTurenkInKGVvjeun?=
 =?us-ascii?Q?ZFDx6J+9Ik+1MtLSDomz+bA3tGgmA1jWDWoXIJSDA/JJgMledguj+rW59uCz?=
 =?us-ascii?Q?uy5LT4ksbzIbphgYVEfGDPj5yue9d0MqL7sBuN4Q3nBXhe2YFVBCIj+LlNuy?=
 =?us-ascii?Q?oEJHVOrTo94zBgnz0TQdR3ef9wOudc1DZ3tdVq6FhS5bCX9O7ZavjJZgVDJe?=
 =?us-ascii?Q?1QnFwn14okKoxuaWcBxA2umcoEG7RdnUSm+BYttd56DQZ08XKlVLGafPQTA2?=
 =?us-ascii?Q?eoTAUyW53WvS6htV5Up+mt8WNhSq4t0wvxBVWOladkk9v7Yu6jXuzU+Ffyl1?=
 =?us-ascii?Q?rR9QlWO2gfuCw8PUkUB9GI4TW04rU1kKaPA6UW21EE5Y5fBYrvqGiQxWJow8?=
 =?us-ascii?Q?9++LoJw1gNt6F8czkNzfetJwfsRwiQS+GUFTJaJkIOnX5MlGuy1ekB48PlYU?=
 =?us-ascii?Q?ci6n3wSZN/aFq3V1L5eke8GRPogL//G6bHKSR+R8X6TRJ1eXpPrBphPrUQSm?=
 =?us-ascii?Q?aq98J9+DYuG+ukuwvWx8xAMpiMliIS3tnOBKnmY91kJKv0Z2emZHyOhcJqQU?=
 =?us-ascii?Q?tyD78Ygd2xTEGwiYCHRvytMmsuVcf1HtUS6de8q5ULzUBwrul964qmQJAT7j?=
 =?us-ascii?Q?F6ChUgcChdsmLynWwmZBms2zNEn672WnC+7xBQLeIE1EkUudOoX0WMkb0tBA?=
 =?us-ascii?Q?xpIjeCCI+QAAiFK5h+PZ0o+bWlIvQnCPyac75n4EIAdgWh/zNguUDcKE4X+j?=
 =?us-ascii?Q?FOBQ0V1GshJ3dPiulFGNcJzS/DpA8aiycKxtons71ekYUWXbImpXhudngJEm?=
 =?us-ascii?Q?xvJOH+pbjyBFWc8dyCy5FaA9vMhXitkpEaEhNI0f2wlam/kHc0CoakOjJdZ7?=
 =?us-ascii?Q?L1OTFweIiWoQFCOpzlLOpLDZIMLBR9O/2ZmmJgRloYbBVci5MAmpNoer238z?=
 =?us-ascii?Q?32IeJCjpphGVCbeXUI8LZ0lOEVsLjHYeL5URkR4Pfyv5CfoSIgshT5O3BTka?=
 =?us-ascii?Q?JxBFWRH5JeY6nhUXrNAX4ADH8DeiXhBQ8kSyAeoJO4/hm1jal97MEHAGRkV+?=
 =?us-ascii?Q?9u15r8OPDnxa3SE3Og+j6qP4ezj1OEt7QiHZPN6gUZ0KkE4uQFtFfxaAwt4I?=
 =?us-ascii?Q?cWXe3UdbVjoi29rOUxnRXzkZih4v4aLybD16iKAdbOnskSJz?=
X-OriginatorOrg: heitbaum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d6f6f40-d374-4713-4b7e-08decb909807
X-MS-Exchange-CrossTenant-AuthSource: SY7P282MB4909.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 10:18:22.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 35ffebb5-7282-4da6-8519-efab29b0108e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITLUmTk1fWQqn7MhGfvHZRmfITcYfZGr3AwOOXsXw/dmcUpNplrwoPxyhvos8iJIfA4CWYvYEjkCaTQE/qeyuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MEYP282MB1687

parse_options() modifies the string it receives in-place, temporarily
null-terminating keyword and value boundaries. The const qualifier on
the data parameter was wrong; remove it so the compiler can verify
the pointer assignments are valid.

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
---
 mount.cifs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 836a060..b57c7d3 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -834,7 +834,7 @@ static int parse_opt_token(const char *token)
 }
 
 static int
-parse_options(const char *data, struct parsed_mount_info *parsed_info)
+parse_options(char *data, struct parsed_mount_info *parsed_info)
 {
 	char *value = NULL;
 	char *equals = NULL;
-- 
2.53.0

