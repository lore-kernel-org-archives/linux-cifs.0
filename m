Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.76
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793112231;
	b=ViEweAgnKAPXjIZHSN7aKtWT4dQucUwDf4GwS3JC8ThIl19rhg+mHMzGbI1XFsJIri06
	 9P42PtihqEEHyIPAmhbl+Z6mrZ7eY7wKgASENY53TYSPq3chPwo5xvwQegP5VVIlP+he1
	 F+c+G+XezT/UtG9hN+qkWzCnkkdfgNljxKn4FM88Cs4inwMxEmgPwZaQHpnSHRrEEBHD/
	 JH38pecXp5Q/HCL1FYwVK7V++k3lILGtcTXmGrPCqkDgNQNv51yXpmT7kIaA+5KjWbI3k
	 C1tXTY8+Pbz5DLh6EZe3oGMAJl3OAr4R19jzk3pXo1J1ZhU0US872Ln8xmLRoc+VCsg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793112231;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Reply-To:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:X-Microsoft-Original-Message-ID:
	 MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SLBlob-MailProps:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Pos2oHcWRjYsAtZpG8y5oBVGffkHMx2ai5+tyyM8g6E=;
	b=rzcMn8Yr6AZxE1ljDbaEv54rvO+g6OjHE5xcWMAktPChVvMuZj/NS4HT/z7PiRpoOGcC
	 /3/X2C/F3jU5Uf0yjaxss0PRBILYvd1Z3x9bp/PsMThOOuvOPyRV5QMgGJ8GHVhGM5Nxi
	 fvMHlVrHGDCXEbxjkCXFtIhtF01qEQUBWiRXE2KpHc1bmZw2VRzkGKVnO5h5GUVLzyVRQ
	 oP1YAFhfPbC0vOP9+ZVq4oZGr8aYtdtn7ErVHv42akc6gQJv07A/eNbb6GYasdg292CeF
	 M/3bz4ceWFADgObAHnOFSOHJESsbnB0VJ/WLKbn6F9IxbfFxkBfi48gy0kCFgQfZ+Hw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b="s/FNDyii";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.74.76
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013076.outbound.protection.outlook.com [52.103.74.76])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007BE606A31B;
	Tue, 27 Oct 2026 14:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 007BE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=s/FNDyii
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBTH6+Kdr+9b/ZGrlPd1BiiJTTTinJpXH9DUrAZxfaSs5AVEUj1gDA12x46KDz66iHwoNsXZ0tvcvP6Sea33FXiDCr5Udhiw142JvFtAyJ6ghLahGe4PpfPV1+Gw8hX6wo7RXgbYllPkTQCRTFkrtocCqFuW7GriR+i3F5Q2fVUcOLm7YUjSmeIF6mAWHqbAzyMUbiVuHVyCPkbo7Q14kPQgvsIuUpKIqS+RWZfGYgZLIaV9+VQXkw1GuTMaxvbssMfx8Zdd6jVFY4X3E4sxtxFSfsP2o7QLqb8KuPAzjlI9VDkw46ikEMQwO7vfraaXtjg1Bzh9zMEmZPMKeD0gSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pos2oHcWRjYsAtZpG8y5oBVGffkHMx2ai5+tyyM8g6E=;
 b=fubC0tMMRZL+sn+qQKgUooCePPUWsl+S1cfPPO9/4qr9m/EzC/9yA7GcSjhwaX1+tmaUTiBljFnPAmzskvFQF5icRhk4KFY4icOmjdZfzdY+3dcGowaWlCVCz4dc6VVnWhJ/bFM34M+awythChEgTdFQIQNmmACp7PUzB9LVZM8WU8ofkoRT7z8ac1cyHwaW5pCp9unf/wg7ZU1stCPwCUv5OZ1ou2T0GM6e/wp/Xj9BaOG5afhfhJIwyKtH+bcLLXI59T3xr38V8gTKTVVFouxt5QAbD8zdpiYe5AyP359QjiXy4f9uTyl8VnKbhga85B5E5xMLrRkY1WNzPPDHlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pos2oHcWRjYsAtZpG8y5oBVGffkHMx2ai5+tyyM8g6E=;
 b=s/FNDyiiHDlfZRKaINF8z3wGjZY74E0ngn3CVcp2XA3WlyybIrGU5ot4P1cWX1ivVHaRwr1koj1RUH31/QE/mwFUiSsgSfXPdCjvtFDwxjzrX4TQOqnxPmgZh7u4uOyyRhQRVi7qdLcU9Qr+d8FPgQmPeOPww+LWesCEmvGjQnok85l6TuoiCltOH9Ug9YyYnB8FByBrrGdUZe+EihzMhOXfFDzL/vdAvl3uMxLm+KZPeeGvIz/A4yUsDrXwgmRo4SsIxwzmr9tMLhecVjmNHekvCuedxq64Trj+vKPsZQZYvNROYGvkdRnw31TbMCb+vHklv83J+T1avXZumyMUpg==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by OSNPR02MB9153.apcprd02.prod.outlook.com (2603:1096:604:472::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 14:43:46 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 14:43:46 +0000
From: Wang Zhaolong <wangzhaolong3@outlook.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] ksmbd: fix named-pipe reply loss and operation races
Date: Tue, 27 Oct 2026 22:43:22 +0800
Message-ID:
 <TYZPR02MB6959DA97FC41F99C5DBD9CE8E6602@TYZPR02MB6959.apcprd02.prod.outlook.com>
X-Mailer: git-send-email 2.56.0
Reply-To: wangzhaolong633@gmail.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:610:cd::12) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <20261027144324.1869357-1-wangzhaolong3@outlook.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR02MB6959:EE_|OSNPR02MB9153:EE_
X-MS-Office365-Filtering-Correlation-Id: be164891-2748-4889-e84e-08df3438b488
X-MS-Exchange-SLBlob-MailProps:
	Cq7lScuPrnrlC5lHdFGci+YUsdS3F/CIc+EEcWMPEh6tLqy8fe7WLYB/OjnFDGB3Yi8AnNWEJkzCC2cX/c8fslSLlhux4o1dLGQpSpSnbm8SdVYY1TTmvoasriERWN1EeHwObO13+sVQO1FsOrQWcynZgoV9XGCXcooKnRrWWGEUanyqp9KbviVx78TtqKVevKiotjJ+KlLMNj8ty4ozLrZqppXt/TKSfh3N7k/8ICkS8YiUg+bT6EKXMDzBDnk4ZNxkGmOiVYkUv2O3sfm0Il+ezFg3cDZ39dDTEBEkFdvpv3RGf6KtCZeUt394D6KnCHr2mWtQmFYAXleMTCc6a3Ww1jJGepzDbTexthiKn+UBfxWHX0T3sIJ1DsYmNlc4zvNrtf0tTOYa400UELTyoaR17IfdunTWZHcHEHbe2LhwtWjIpPAAXaVkvBbgIRWAf6rijlSyNzKjS9nV090T2lSTyDVpAln1gKR80/lnN4Z+spQjogqYErFWEaRCqVOhM8PEX/vbbVOWrAicQym5yWpg6sPZhIKEK+4rD6pg2SoNUzr9boeAtlLxt5RxpSLRcORzLp3SbVFxHRvX6fPHr6opFnrRpofyvuKxv1fkR7ZdOs3BXwJf6qrdvaLl2uhGbObpGMZJevY1+J2mttCf9Px53D1guexqzIN8sZTfGWvI8b2vQ7WVyhLm4bvxl7wWB7OdPO4ZbYZ4eVny0Gm+ETtg0dVm5TEQ4bqz2/PXt4P/8Ll40jxlFqH8jnOPhxFQag9txpCd3I0=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|22091999003|24121999003|8060799015|23021999003|24021099003|12121999013|19110799012|15080799012|5072599009|260925184616899003|51005399006|41001999006|25010399006|4140399003|3412199025|440099028|40105399003|26121999007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ci+zCUALw9k4pz65K6fCzMpCUOEIhVJMmj77fEk3MemIpi+YYp6IlU9MLjjN?=
 =?us-ascii?Q?UmTBaEKBVnFhCSZwsw/nlPe2f/F9y+CbPB///OhDcvsXpTIbQCSOABrk2i87?=
 =?us-ascii?Q?nAwfXBeHPCDo2lU5zg0qaPD21/IVG+WXZu+U7duoR4CR1KKu7EfWUzlClTVn?=
 =?us-ascii?Q?NT7HcOPjeVboZF5QAxUDmVsVv6mXOEQLQJm0ZWOXyUNqDDR7gB2vXQTaQxoH?=
 =?us-ascii?Q?KQPOv/yYCyhSYi9L2KzvNWBcJLalLJUZ7pPk3z0xH8b2Oo+wJCdJK2fywAe1?=
 =?us-ascii?Q?JBoRMti1tvpkV1l1dmzR3/rAtCilIQruu3yzS+DyQMS5M1AmgptD2BQS6rLF?=
 =?us-ascii?Q?77CeWtH13RS3xXPyRT43ZGPjv7YU+F9XbXF7LlB2uTCGXH2fkbfpZusvwGcP?=
 =?us-ascii?Q?Aaa2dKDNm+2x2PycOuG68m7X8MaT4rlgbI+C99Cj+kQp8mQXRT/HaVRH+SFZ?=
 =?us-ascii?Q?9522aRoAk05oJHSf5Pox8ohAfhKLrSv4WwHNZLWR8P7caiBgtSupFBW4PDcs?=
 =?us-ascii?Q?2BWR8I+qqRVaTYoolJIiK04CdfO3hZz73pNdK+ZZK+Kj403o0MfPgCdEYV/e?=
 =?us-ascii?Q?AnEdEQJJOiBPHqC6hWcg9eKz0RNZcXcS60V5YEwM7R4RDF+w8cbEGXZsLFWX?=
 =?us-ascii?Q?z5qO1V8M77XEDKHkHtRvGHWnDCWgCt9h0MM/8pghH412UVLPJlkWQsGSYeXi?=
 =?us-ascii?Q?UhwtElC0aW3WelZbnL+p80t6WFYjEazaOMYXvQMUNxXePMMF0RIjXXM0ypeH?=
 =?us-ascii?Q?LhGR+mrNexbJ2MC8uP0qLJewJ73A0xGQ/QjTFIV42MpmMQcOM0hkufG/ESDi?=
 =?us-ascii?Q?DpZ59x59vi4lJgLXZ1I2uq8aqbEcATP1AcZfS8KmWbV7Tna3v7fq05kaAS6E?=
 =?us-ascii?Q?fyOg6kE/PW1MTUsNTfmhXsbNSaFkVUKatYloHb5JRWs09mPbzM69dcs7cdbw?=
 =?us-ascii?Q?ncF6J8l3G2oKfCK8oszJUmt1ZQfzO55SGMy1caAQsJbh8CP5SDixoQlI2YG4?=
 =?us-ascii?Q?177RZLVlRQET5D/WdYWN0q/n510UnqoGvt1qCe8YHvE6mEGm+fU2JVYi0qpx?=
 =?us-ascii?Q?lxJNQZ9lrw11gc8Q6tfO7t5JZOvabydNhBrIYToNodNtUj8/4J4=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?diVq1YPaMYRy1zmRFxI48fEsHrvS8/jGRr2lKINsrJXJZ+bE/LJ/YThWjlAq?=
 =?us-ascii?Q?vQyMSxjKWZIc8uf+7o2SVxSNh1A7OYPsmvk9Wkcbxsibbf2qYfwjrs9Exu8r?=
 =?us-ascii?Q?g2Ak0gzCxRe9o7RRy4ewHoJu/+vL8B6JdO7IHgfLOrONiMrG5z3rRh4MOFJg?=
 =?us-ascii?Q?eg5ivpMeLpIvPvDdEAdUmiVIQvFysgxXw2UEoACLkPeaB3TjsU6FUAh1gd4v?=
 =?us-ascii?Q?fO8NNC+cW0POgHQQEx3VO4wZJ8h0mPMTKPWdrZUSnVXMpS49O4xxn3yLxckX?=
 =?us-ascii?Q?YlTY+YxdbTzRZwtS/7w9BbOpHtBo90PKp97nB9zeFv9IO0pEC0VFXHKvxR2S?=
 =?us-ascii?Q?otRXe5sRRR4/YNqzpoaRPRWoImHQGGC/UV0Xk/eNobcI4vEBtaei9UbRHTvy?=
 =?us-ascii?Q?9XH3B3d8+BtyYRC27cmfvlC8oT62dGtfF/g0qkOKjFwHG4RfhLVUIAtotJPS?=
 =?us-ascii?Q?oIFGHFfSphz3vg/srBYredy/qNhbUcJIZUmMM9fI8XQ8ZIzIEsn0MVdXxl9M?=
 =?us-ascii?Q?S/mVaxW4ZIqnyMwVDQb91031HX9nwT23Do+5b1cLDbMKrHVZEqJxvxo2DUYg?=
 =?us-ascii?Q?NrL7v53aSbN8g9TvzHVxmcHCNaeG2dnonJMulWlAm5aHjvvQJdEIiw4+SqjH?=
 =?us-ascii?Q?7QIZhigaDfYukoK2yeX/C4eUExZqjDH6OQ5Vy1br/yYUKyd3ELpyXkiFPR+k?=
 =?us-ascii?Q?6Ikmnb1GeCpURvjsvNNyCCyv+EHS80Z9jDVReFNPfkqb1dcgnymrbe3pUV0l?=
 =?us-ascii?Q?Kv7yYTq475aP89y+gQpVK4tMw079DquAYO+uxKJ86Eg6izXRMBq6cOhjNVdG?=
 =?us-ascii?Q?xdtcydPprkusMkYUpqhcRyilJXr7AA0zWGr5F5rxFSiT6GBdBJxmQmLj0AnN?=
 =?us-ascii?Q?lyFgp6Mu3eJriU5fxggraZW0vsUweX+ieJuTjrYGZUSMfePxg+9Bg1J4tWnU?=
 =?us-ascii?Q?MnEaZR72iLU5BGImnl1ppqke5x98wquaw6GkNupttUF/lZZyFQdgq7FxYfQZ?=
 =?us-ascii?Q?/AXZ6GdijfewBsgDEfsCSYaj+MA6rZ53YQTL679dkv/ySXGC82LrF6QWl8n3?=
 =?us-ascii?Q?IvQbBOXVpEREDD/F1B+dqNu6s1Ufv6ZslOGgfRhQhhaGPVRBHIltgaHRCw75?=
 =?us-ascii?Q?70yCbxo18qoXUr1qRp2r3c49u1S20ClvlGspX8VFVfB5koBcloqFA+0w0s09?=
 =?us-ascii?Q?5Bo8nssK8PAoM6t7SHmPNs0Hv+nwFZdaimVpB4h5hQxOH3CFpcWlhO9jsKQB?=
 =?us-ascii?Q?aokVilw+i+TOGjQ/rABNxzMIAVWYoNBCgZdBDhjmRYppZUNdUZutPWlvLbD8?=
 =?us-ascii?Q?U4jjdjr+P6eFbaVPjyxTG/KAGQu7UeXc9wc7SAJ2T5E09myQ8/4O3YR7AtM9?=
 =?us-ascii?Q?M3QadcXIMJw4q3SL/GVI3aIFjGMnLIi7FWMkrWn7oyHJtr0ayw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be164891-2748-4889-e84e-08df3438b488
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 14:43:46.5256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR02MB9153

This is a candidate v4 of the named-pipe fix series, based on mainline
7d37252fc49a. Patch 1 is unchanged from v3. Patch 2 addresses the cached
TRANSCEIVE input-acceptance problem reported in review and reports
BUFFER_OVERFLOW for a positive pipe READ that leaves unread reply bytes.

The first problem is that RPC IPC replies are matched only by the pipe
handle. Concurrent operations can interfere with reply delivery, and
CLOSE can release the handle before another operation finishes. Patch 1
adds per-pipe serialization and lifetime, checks teardown after locking,
and clears pipe state on logoff. Existing mainline foreign-handle checks
and STATUS_FILE_CLOSED behavior are preserved.

Patch 2 retains the original IPC reply allocation with an offset. READ
and TRANSCEIVE return only bytes that fit and retain the suffix until it
is successfully pinned in a response. Closing, logging off or disconnecting
releases the cached reply.

In v3, TRANSCEIVE with cached data sent a userspace WRITE before returning
older cached bytes. Mountd's RETURN_READY fast path can acknowledge that
WRITE without accepting its input. A later transaction can then return an
old reply while skipping its own input. Merely returning the cache without
the WRITE would also silently ignore the current transaction's input.

V4 instead rejects TRANSCEIVE with STATUS_PIPE_BUSY before any IPC when
cached unread data exists. It does not accept input or consume output.
The client can drain through READ and explicitly resubmit. The no-cache
path still uses one combined IOCTL IPC. There is no new kernel RPC queue,
extra whole-reply copy, IPC ABI change, timeout, quota or production limit.

MS-FSCC section 2.3.48 lists PIPE_BUSY for unread pipe data; native Wine
and ReactOS behavior also supports this rejection. This remains a proposal
for the SMB2 path, not a claim of a fresh Windows remote-SMB2 oracle or a
universal MUST. No new per-pipe mode selection is introduced.

Changes in v4:
- Reject cached TRANSCEIVE with PIPE_BUSY and a standard SMB2 error reply
  before IPC, preserving the cache and offset.
- Remove the cached TRANSCEIVE WRITE/ACK path.
- Set BUFFER_OVERFLOW only after a successful positive-length READ leaves
  a suffix of the same cached reply; exact final drain returns success.
- Preserve the zero-length READ no-op and pin-before-consume ordering.

Bugzilla references:
  222196: short PIPE_TRANSCEIVE output loses unread RPC reply bytes
  222197: same-pipe RPC replies can reach the wrong request

Wang Zhaolong (2):
  ksmbd: avoid races between named-pipe operations
  ksmbd: fix named-pipe reply loss with small output buffers

 fs/smb/server/mgmt/user_session.c | 128 +++++++++++------
 fs/smb/server/mgmt/user_session.h |  18 +++
 fs/smb/server/smb2pdu.c           | 282 ++++++++++++++++++++++++++------------
 fs/smb/server/transport_ipc.c     |  45 +++---
 fs/smb/server/transport_ipc.h     |  14 +-
 5 files changed, 324 insertions(+), 163 deletions(-)

base-commit: 7d37252fc49a939d005a7495b81d1bb337c29e45
-- 
2.56.0
