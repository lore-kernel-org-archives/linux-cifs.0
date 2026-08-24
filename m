Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012008.outbound.protection.outlook.com [52.101.66.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57C4964F;
	Mon, 24 Aug 2026 00:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787533010; cv=fail; b=kqhNvZwMU4NnOoZLRdCZgthEK7Opxhgeoy5//7ddz/ChVo+SE85FDhPxfBMZ132xw+XgZpB/jPmL2dzxW5J94W50uT2s8dA8pX/7ZZ6m+ZGm4eA4YjtgBE2a1vHRTd71qf+ITEiwPne0CUYQ8LbarUu86FuEt0Wh1aZDf65XhzI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787533010; c=relaxed/simple;
	bh=A2vBugfM4FtsYPoPnEUqJ6AK75Z1J35mIDgC2uFNGJs=;
	h=From:Subject:Date:Message-Id:Content-Type:To:Cc:MIME-Version; b=tLYeYtXLdVd5qCJNYqnMnko3h9kjWHbvRXSvp0/7TkRtLaPxJtyCkM9f4Lz+0I9abwwPs2/PMrGbLXhlA7xPGyihNYIL2ZIohuBo9gIQLHsgeVPt4DErGeAzwoQ63Pd2HtB48QncH2lbm2cNrlxLik5FaouIST/02XDao62sFOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b=jW1jQorr; arc=fail smtp.client-ip=52.101.66.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=est.tech header.i=@est.tech header.b="jW1jQorr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MsIH/vGbuZGvg/QnzpgsZWeOnNx7JARwc0MXr5U2HoGERmgxzC1H9APa0xCG330eewLNxCWKLcXqr9rjRti2BRPg933UhHufNhZ2NRhPqIplktvFivooOl2d9HpFZsi/Q7OZ2Gy0rpZGespXBi0hoc/i4HcJzEFIiBDA+ASMBvvztl4YCBpABNRf/zR76ptd8AeMAnWthtRQ+iSOeP79iymG5kfAKIEBG3D2o45qwDR4PjmrTc7ueJkxMM21cnwMyipx0ihZEeemT/RHnN3kYNaGpMb/GzV5obfE/GNntZCDq+Vp6hQZuBTIcmMW5bLpSRLzokzs1mFjKJzQ3R6wow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vz4Kz9c0PV/pKybWyIKkcKkM8BcT4PY8yMnndTmyHJM=;
 b=e6lv7OOE0GzVQaYVz3CkQp2r9mA3H/2SpX3VKfQywkRL4DWQd8QVK9C5YftrQ5GZgg8B4v9XO4AZ3neDL5ZTN5MoW65RwfJF2eqlOSvNuZmGaSGBYe8z9WOjpyi2oB9AJRhmFo3U0cV4colHy7BKqJUWGdYPDKswTn56Um+X1AiiDgQRv7zie2dOJ8nukoHTy9p63ybISW3bxZiHY7F6MeR8zqPdgP+rr7iR2BoTBnzqQHMDuujqCIZDSDjvbT7c+RLGlc3SrhsTE2I1ksqMSmIi7L93pXSBxViF5zjt3j4d4HSm7EmsrTvi6cD86ezFkzhe01/Ybuk4xrbBusMtDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vz4Kz9c0PV/pKybWyIKkcKkM8BcT4PY8yMnndTmyHJM=;
 b=jW1jQorrZ1FQvtVwpqfH6Aaqo+upO6GQHMmzgiHWiZZ6gRCuvotXdPzp5RyjIP1uvjT8RrhtD9oPBYdlYlRlH6RddU+qgXaKuETz8+U1BjBJCDbo1DBS/HLH+yjyHI78CoafmEs9x9gx8c839OWx40ywRDqTPJMxcUVavVEtzNU+qNLpYBivAUKZqSi/zdkIPM+3XNQTjOvt6SszFhRJDMO5P+mHBBIhPxOo9PFZgdU5J0uL4gkIOKrOZGn39mZw/MpF70nDh4//lOHqwBqmcxRl2ehD/NjBU82ccSGgsMn0Sn1nsVjEeV9uVutE1U+uq/xiYrWl68WC3BPKWElIcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:39b::19)
 by GV4P189MB3726.EURP189.PROD.OUTLOOK.COM (2603:10a6:150:2b6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.5; Mon, 24 Aug
 2026 00:56:43 +0000
Received: from AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4]) by AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 ([fe80::69fc:c4d4:200b:e4b4%6]) with mapi id 15.21.0360.005; Mon, 24 Aug 2026
 00:56:43 +0000
From: Yunseong Kim <yunseong.kim@est.tech>
Subject: [PATCH 0/4] ksmbd: implement Continuously Available (CA) share
 support
Date: Mon, 24 Aug 2026 02:56:27 +0200
Message-Id: <20260824-b4-ca-v1-0-79d6ae0ad2c3@est.tech>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ5AMBCF4as0s9akmhJcRSzaMRiLkhaRiLsrl
 l/yv3dBpMAUoREXBDo48uIT8kwATtaPJLlPBq10qSptpDMSrbRItVEFknEKUrsGGvj8ftrud9z
 dTLi9Y7jvB+BdChtpAAAA
X-Change-ID: 20260824-b4-ca-ace9405ce4b0
To: Namjae Jeon <linkinjeon@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Yunseong Kim <yunseong.kim@est.tech>, ysk@kzalloc.com
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787533000; l=6337;
 i=yunseong.kim@est.tech; s=20260824; h=from:subject:message-id;
 bh=A2vBugfM4FtsYPoPnEUqJ6AK75Z1J35mIDgC2uFNGJs=;
 b=KGVxZCLlpxTq7ni+6ONxeG+Xl+FIy6wo/o6pRq+7a2HF6U0ATnwRLVX6drdnKUTnpB4o3cuTk
 LoKHEHNTgD9BnpbA4/72M8jQ+9TT7tqqjpI2BSLZ030/hGr1LtmOTxP
X-Developer-Key: i=yunseong.kim@est.tech; a=ed25519;
 pk=nfdmjNawkxBHo9UNdzLNBEht8sYmXp0MYUsa/hwC7vw=
X-ClientProxiedBy: GV2PEPF00023A0B.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::212) To AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:39b::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P189MB1752:EE_|GV4P189MB3726:EE_
X-MS-Office365-Filtering-Correlation-Id: eb0e1e08-89d7-4fc1-2000-08df017a909a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|10070799003|23010399003|10067099003|11063799006|56012099006|6133799003|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	RGus7KiHyqx3vCsAgAwmFyT/+kfOtNZ4EdL0Rmp9mn2g6StBcnyC48lP7c2iZehO5JXzPkll4mee/Rzd0lSmRcj/Rwks1yk0UdmhrcihbolAKLrfKboFsPedBQHcYn7JVwiSUnSXR4N9tuHOsRre/LQ1KEDX66jNCt5GdFZv1QLoBTiw+sNG/pXB8sIir2xmI83clyF1JYb5XQ51yA1QnQ5XAH+xp76lUNJ7UX8C6NeJcHXN5vgFMMPPIoy4rAwlkr8B4en1Og6Nw5PBd0fXlN3mf8T5CyLNzcOqbPOtryr6LE4iLbFpmkzYFvxUiNZNvYTRj2/3EnjVX/NvkR8e0HzPd1zf9VwqraX7BJTlz6wRKSaTuUvSn68J+xr81nM965hPR1OetzDE+4/Ly4iJPFwwFfXZicqprWhZO0AYe+p2Skp/DAqgnaA7EjqXX8jDCfj6yke5wBpLePn7TE3FOPtb9uH8Iz7Nkr3cVxTOQ69bfX8Gkl6P5dvl8fPKQfrD/FCwRfKtNPjKBwVRf2l5e3kljeGkjgSzeEfGl8EvpaOErIYCyU3a0aa+V+jknG24uh/t6l9D9Z4jLPtu0tRDavhWH+IolGPn36kUve1mlu1Q3M6j1mX32OSBbTHPoZLcr3YKzOAIM3uqEW2hf4xjetjNcRZbsKr5gNzmpsxUBRQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P189MB1752.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(10070799003)(23010399003)(10067099003)(11063799006)(56012099006)(6133799003)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eW90WDhxZ1lNeGJjaW5VT1FFVkVtSVZ5RDJ0N3owdmNvVk1wYURTZUZOVXRx?=
 =?utf-8?B?RjBXMkR6b3h2WHFlempIWDFQLzRrTzlXSjd4V3h3WS9GeFZnTVdZYVZzeG9o?=
 =?utf-8?B?QkdPcnhJNE5VSHdHcGtIN0lVN0JuQ2lGdFJnQ2NjKzQ3YSt2S0paT29wVERq?=
 =?utf-8?B?REg5T0JYK0lwbEF3Ry9KM1l5WUE4c3pEOVBKNEorWjZBdXdjNWZZYThGaTk0?=
 =?utf-8?B?WTVUZTRzcXlVOXlua0dyVlFzQnlTOVR0SzBubzlGbHZDSFd1L3EzSHFmUHp6?=
 =?utf-8?B?V3FPNDBhOHdFSlVhZXVHTVZLS2lTa3A2dkRTcWhGSDd2NnNHSC90em5SVHFY?=
 =?utf-8?B?b25seTZyOSt0SlpVN0VqTzV4bDFnM2xLM3F6a2VsWi9peG9zSWozU25MbE91?=
 =?utf-8?B?cjJqVTZPL1hhanMzYjhwQjVXWU1OY1RLTTJodUZjd1UyaHZQU0ZyV1Z2RDly?=
 =?utf-8?B?Ti9oSXgxNlBTbnhOU1BMSHA4eE1BMnM3UURQb1VIdnRoeE90SmVWMTB1N1Ur?=
 =?utf-8?B?NE5sY29qblV6cVdPSHJuTTFTWVlKemdEQ29tUGhPelB2NFBBWStBS1dObU94?=
 =?utf-8?B?SU9ERzJ4bjVSVWxGK0EwY1E3eExsNGNOd0JMQUZXTkZ2aEpsWVlqV1pzU2JU?=
 =?utf-8?B?R1RsQ0JaeGNISEROalRJcnZUZ1h6cUVLZ0pxZDFWMVJKa0IvTWo1Z0hGcDdC?=
 =?utf-8?B?WmhVV1NjRHAvVUlDOEV4bmowanFXcGNzTlp3cWxTaFRTTnBkVnJUSzFGRUZC?=
 =?utf-8?B?bmlRQ21DVEVFcjk3Wml5Z01nTTVETmVVeTRUUXZtMW5KQzNkWGh0ZnNTRFg1?=
 =?utf-8?B?MzBwclQxSXpwT1pSVDJXTVlQb0F5MU15Uno5K0NmOGhSV1BpajQ3Z2JlMGlj?=
 =?utf-8?B?T1NHaGVuREZGU0RKeU15TVdMSkF1WmJwSU9Lc3lHbkJkSkIxZmhmdHNnSExM?=
 =?utf-8?B?N1hVcER1T1BUYzJNeGFjQi9SWXp5aXBOME1WRGVPS0pweGZXN3QybVZBUnc1?=
 =?utf-8?B?MTBSRmh1SWVIMURraWlXcncrKy9ieGJ0MlNKM3ZpemZJWVRYNTlnSTZXNUtJ?=
 =?utf-8?B?OTB4WmRaa1hoaU80REpXQzlVUXJwSXluUW1lNG80VUZkLzdNRmR4dEZTb0lP?=
 =?utf-8?B?NjUzZUFTei9OQVlKblhxQmVkcTl3Y3FyUVpsWW8wZHpjWVZaeUZTZnRnRFBY?=
 =?utf-8?B?OUtpbDUvREtWRUREQzJ6d2dzcjMrUm4yYTRHcHJoMWx5N3VHcGQ3Nm1Tb3RG?=
 =?utf-8?B?aWZqSUs5bWZ6bW4zTWtOditJeEwraVNlcXVRblc2dEhUT1ZPaFVmeWhqYUFm?=
 =?utf-8?B?ZjhKUXhNVXJoVHUzNG53b0s4akxpRVlyRnpxODg0VnJTQlR3blQzUVBuNWJt?=
 =?utf-8?B?RU93azdkS1lyNU1neHo5K0JxS2JERkJNQmlBUlhHMzNuWmZlR2ZSQ0NvUlc3?=
 =?utf-8?B?RW8xYXNkUW1MTjNpYnhrZ2JMak9DZ2Y3T3VlY25EWEhuSDdNajdmQndvYUk0?=
 =?utf-8?B?cm80ZElONUY5VzFmazg1K2pTQi9IZi9XNG1ZNlcxM2ZzNE40eUpwekhzWUR0?=
 =?utf-8?B?TmdXTHBOamJJZjlMOThQTXoyNW1aeERMdnVacThsYmdIMnVrVERveGt6UWgy?=
 =?utf-8?B?VmIxSmxXT0xPRUhDb2hnM3laZHZTd1JpRjRqWjlOTGVlbWhPTTJWS2JYM3JT?=
 =?utf-8?B?cWhtR2dSMnA1RmJIZ1l0TFJpNlJtbHlWUkRWdkJmV2E0ZkVYU3pIVERyUzZH?=
 =?utf-8?B?QkxlbDBlZU1CT2YrejB5T1ZKYmROdUtZUElBVEp1VkNlbHFvV2MvUENHRkJy?=
 =?utf-8?B?Qm5KdzlCek55TkpsLzZ6NjdSMjZMZHIrbW5zYjd0VFRycEJHRXpjRGRHS3hq?=
 =?utf-8?B?VEpRN2h6QmxDZng0c3k3dS91aE4yQ2JudFZ0ZTdmSEdpcHM2OEg5Y2ZDYW1Z?=
 =?utf-8?B?RXVZa2grc0tKMUF1dVAraWl2YzNMWmUvU1FCZGJlRE5yWkZianJHWlhXZDJi?=
 =?utf-8?B?M3czWitDRlgrUnc5ckxyb1VtOVdKMXpFV1A2dTE4RDVuOGhaTzgxeENtdnpy?=
 =?utf-8?B?YXdpVElJSGN2Qzl0aVhpVGdoa2xPMmtUSmpxMFEyOEpxeGtxWjliT3lpRmpm?=
 =?utf-8?B?UzVTUUhLcVZaZHBhbHlWUVFybDExRXZZL2tISUdtTW5OaThxVzc3WWpYMmti?=
 =?utf-8?B?WnNWZkNnTW5CVFp4U2FOR3Z0VjkzQURSWlZpTzgxU3JDaVNzWkdLbXNteGFD?=
 =?utf-8?B?OWRIVG4wNE5CeG95U0tBVmRpZDE0NDVSVVhNSnA1WTJvSG4vRVpYdTRaL2ZO?=
 =?utf-8?B?SW5XdWpTcVhFRmhxZ3VEcjliT1RiRDdvMERDZ0FLNjQrUVZtaGN5MGc4UVhL?=
 =?utf-8?Q?6ITv1IjH/MaOpAPwFJZN4yPrzOe1FaZqN2FUxzi8JNzKU?=
X-MS-Exchange-AntiSpam-MessageData-1: bgk+7tDcx0piTg==
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0e1e08-89d7-4fc1-2000-08df017a909a
X-MS-Exchange-CrossTenant-AuthSource: AS8P189MB1752.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 00:56:43.5304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNJbhbsD0guFfGDdAyQZjuof+ZqeCkQyXCRMIexeYctIkD9gg4NfTlurfaVP0EvyGztHCapR7J8/f+ZEto98RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4P189MB3726

Enable the Continuously Available (CA) share infrastructure in ksmbd,
allowing SMB clients to request and use persistent handles on configured shares.

Background
==========

KSMBD already has a complete in-memory durable handle v1/v2
implementation including the persistent handle data model
(fp->is_persistent), protocol parsing (DH2Q with
SMB2_DHANDLE_FLAG_PERSISTENT), and reconnect validation (DH2C). However,
the server never advertises SMB2_GLOBAL_CAP_PERSISTENT_HANDLES or sets
SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY, making this code path unreachable
by clients.

Per MS-SMB2, a client can only request a persistent handle on a share
that advertises SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY. This creates a
chicken-and-egg: we cannot test persistent handles without first
advertising the CA capability.

Implementation Approach
=======================

I chose a top-down approach: enable the CA share capability first,
validate with real clients using Samba smbtorture, and then layer on-disk
state persistence in a follow-up series. This allows us to:

  1. Get end-to-end protocol validation immediately with smbtorture
  2. Discover client behavioral expectations before building persistence
  3. Deliver incremental value (fencing + write-through + disconnect
     resilience) before the harder persistence work

Note: at this stage, handles survive connection/session loss but NOT full
server crash. On-disk state persistence and startup recovery will be
addressed in a follow-up series.

Patches
=======

  Patch 1: Advertise SMB2_GLOBAL_CAP_PERSISTENT_HANDLES in negotiate
            response when durable handles are enabled globally.

  Patch 2: Set SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY in tree connect
            response for shares with 'continuous availability = yes'.

  Patch 3: Add STATUS_FILE_NOT_AVAILABLE fencing: block conflicting
            opens from other clients while a persistent handle is in
            disconnected state (MS-SMB2 3.3.5.9).

  Patch 4: Enforce FILE_WRITE_THROUGH on all opens to CA shares to
            ensure data commits to stable storage (MS-SMB2 3.3.5.9).

The corresponding ksmbd-tools patch that adds the 'continuous availability'
share configuration parameter is submitted:

  https://github.com/namjaejeon/ksmbd-tools/pull/205

Testing
=======

Build the kernel with debug sanitizers enabled:

  $ vng --build --force \
      --configitem CONFIG_SMB_SERVER=y \
      --configitem CONFIG_SMB_SERVER_CHECK_CAP_NET_ADMIN=y \
      --configitem CONFIG_SMB_SERVER_KERBEROS5=y \
      --configitem CONFIG_CIFS=y \
      --configitem CONFIG_CIFS_XATTR=y \
      --configitem CONFIG_CIFS_POSIX=y \
      --configitem CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y \
      --configitem CONFIG_CIFS_DEBUG=y \
      --configitem CONFIG_DEBUG_KERNEL=y \
      --configitem CONFIG_KASAN=y \
      --configitem CONFIG_KASAN_GENERIC=y \
      --configitem CONFIG_KASAN_INLINE=y \
      --configitem CONFIG_UBSAN=y \
      --configitem CONFIG_LOCKDEP=y \
      --configitem CONFIG_LOCK_DEBUGGING_SUPPORT=y \
      --configitem CONFIG_PROVE_LOCKING=y \
      --configitem CONFIG_DEBUG_SPINLOCK=y

Run the CA-specific smbtorture tests inside virtme-ng:

  $ vng --memory 4G --exec '
      mkdir -p /tmp/ksmbd_share /tmp/ksmbd_ca /tmp/ksmbd_conf
      chmod 777 /tmp/ksmbd_share /tmp/ksmbd_ca
      useradd -u 4242 -M fuzz 2>/dev/null || true
      ksmbd.adduser -C ksmbd-sandbox.config \
          -P /tmp/ksmbd_conf/ksmbdpwd.db -a fuzz -p fuzz
      ksmbd.mountd -C ksmbd-sandbox.config \
          -P /tmp/ksmbd_conf/ksmbdpwd.db -n &
      sleep 3
      T=/path/to/samba/bin/smbtorture
      $T //127.0.0.1/ca_share -U fuzz%fuzz \
          smb2.durable-v2-open.persistent-open-oplock
      $T //127.0.0.1/ca_share -U fuzz%fuzz \
          smb2.durable-v2-open.persistent-open-lease
      $T //127.0.0.1/ca_share -U fuzz%fuzz \
          smb2.durable-v2-open.reopen1
      dmesg | grep -E "BUG:|KASAN:|UBSAN:|WARNING:.*ksmbd"
  '

Key smbtorture tests for CA validation:

  smb2.durable-v2-open.persistent-open-oplock
    - Connects to CA share, verifies SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY
    - Opens file with DH2Q + SMB2_DHANDLE_FLAG_PERSISTENT + batch oplock
    - Verifies server grants persistent handle (response has flag 0x02)
    - Tests various oplock level combinations with persistent flag

  smb2.durable-v2-open.persistent-open-lease
    - Same as above but with lease (RWH) instead of oplock
    - Disconnects TCP, reconnects with DH2C, verifies handle survives
    - Tests lease level combinations with persistent flag

  smb2.durable-v2-open.reopen1
    - Basic durable v2 disconnect/reconnect lifecycle
    - Opens file with batch oplock + DH2Q
    - Disconnects session, establishes new session
    - Reconnects via DH2C with CreateGuid matching
    - Verifies file access resumes after reconnect

  smb2.durable-v2-open.purge-disconnected-rwh-with-rwh-open
    - Tests conflict resolution: a new RWH open from a different client
      should purge (close) a disconnected durable handle with RWH lease
    - Verifies the server correctly resolves lease conflicts

Results on KASAN/UBSAN/LOCKDEP kernel:

    smb2.durable-v2-open.persistent-open-oplock: PASS
    smb2.durable-v2-open.persistent-open-lease:  PASS
    smb2.durable-v2-open.reopen1:                PASS
    smb2.durable-v2-open.purge-disconnected-rwh-with-rwh-open: PASS

    Zero KASAN/UBSAN/lockdep findings

Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
---
Yunseong Kim (4):
      ksmbd: advertise SMB2_GLOBAL_CAP_PERSISTENT_HANDLES
      ksmbd: set SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY in tree connect
      ksmbd: add fencing for disconnected persistent handles
      ksmbd: enforce write-through on CA share opens

 fs/smb/server/smb2ops.c   | 10 +++++-----
 fs/smb/server/smb2pdu.c   | 33 +++++++++++++++++++++++++++++----
 fs/smb/server/vfs_cache.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |  2 ++
 4 files changed, 81 insertions(+), 9 deletions(-)
---
base-commit: 4c6320e0ad400d4ee41cfde614c05a0d87f54e1b
change-id: 20260824-b4-ca-ace9405ce4b0

Best regards,
--  
Yunseong Kim <yunseong.kim@est.tech>

