Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792522149;
	b=LiBNUTxLWAWZDL2sGxLTNcN7D1P/PApElYJ0W9AGDlKUS7dYU/wm6+9yllfyMsffK4gC
	 mN75VADsZw+OvVTI4MWvNmHW30MrZygB1rJjprBHgocnISvYeHcTwtM4zSSHMkkRf8o0m
	 Rjac1mk2cck1nTsvRvBwhp+TMnMWQnYf/oQ27bdwC84qXeq7PPtHixUIXxy0bvytX8HzS
	 cZ6dAHJzku3y5r7jrkevyCrmD6j03tfkhxFL3bf3zyNiKZWJbyTHvVETzMBdqgCeN3Rio
	 ZtYJKJWTE4MsmD/Gu5eA6cEVAE+qaOhXOPJBm3FZPuPjEHbnGU+NoVedKLTYk3LrbNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792522149;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=OKG/qGv5ThyZkYxOmlLufr2y6ovRGRKhr3qd05b0ieY=;
	b=4E2Lof8RVxQzBVGaOX8mS5V5neovKpl+5K6RJw+200u1OFP08cHSz5jQE/RpHdbrKPt1
	 GDrjCAPVGFPLyHDchCyM0Lru2JiWTgIYK8uHk6OkjkNYdhR5L0EjA2+3s+JMuboND8G2Y
	 /bIcx2SX/dntJwbDf9PTS9FSenOxJ9j2Vb8EBzylUT+2/EPOh/cPkEPBTb9ZObMqz9B5a
	 Ce0v7KEpnCgsXYivjZnSgO6M0X9OxJXEU4zL21v/uyPpIAvVqiWFZSdgEgRfHJNQc/tGz
	 qqhHCbthzl5iyykgRUsX2jXX34AoJh4HzDkd8gBPpuZVvtLqFTC44yxc0y8I6MbchiQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hotmail.co.uk;
	spf=pass smtp.mailfrom=hotmail.co.uk;
	dkim=pass header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.a=rsa-sha256 header.s=selector1 header.b=EdtwnBYg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.2
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010002.outbound.protection.outlook.com [52.103.33.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98094606A323;
	Tue, 20 Oct 2026 18:49:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98094606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.a=rsa-sha256 header.s=selector1 header.b=EdtwnBYg
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QvUKFzrDK7XFYYs/ZwdJjo8fA764N5oCfy8udzNPJizqFciMkPhtIV0LYWZ90u1KLiFmiBa0JaieckOJgYS1gW+D8FWJOCeDCLvHIN6M6pL2P4lPtbu0fpx9B6qZH6RyCL5S373997zWON1zB9wUIUggr6mH6ynKwLkk1hG3P+50r+wHzP1gOzrVpdvrfdSZ+bM916Rehrb2c02kqReBCNFcxCM53pjqB9yN1vQFOXzdCMy9R5xRoXp5Z9ekY1e57irJUOARagL4VGnShB1iFew81hRn4XeTKnyr3mqx5xUrs+j/hAw+V6lM5jWCh75OtxCaCpUi/weUkiUDvf1eCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKG/qGv5ThyZkYxOmlLufr2y6ovRGRKhr3qd05b0ieY=;
 b=c4MlgEoR1OEAGgHBAk/Brkof1vtxvZ+UVR6r4UEDZNeDR1NmsMblyN9XD+k/Vl3iXtVi/KEgTjXXDqSwQqti1so9oi8nqS00xm00AMplTbP6mTY6F5/H6yd+dnLRm/DKTZY+neMHCWSPb7gc4lkVVO8MAne6TTN6F0SVPy27SzPWchvd6cAGrCE9M9eYbUqHajIoNK5ETe1yoPhBkxzX4RDT68YAXlCtiQn8yZk6HXZSyYctQo+DKLRiSI2S9CzIo7UWQXiTge4DZXnEqyGLsHHtQa/GRm+FK8aaPzDAxSzPeYbPm+N3rzQhpaTcwb0Omf2C502idcTOHIjx60nEGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKG/qGv5ThyZkYxOmlLufr2y6ovRGRKhr3qd05b0ieY=;
 b=EdtwnBYgg/AwxgVHcJtWg9EwpsAVO4PqoGWbaw22HqW5tW/SAawSiY2wzmgHW18aqIElmLy9pbRZrMPVnWIiqoZ/dIi0azje1tkGpv/jITyflP0go5VOW6Wxh29VoPoXVuNLKlCfnD8myaEbc3fsvjyws6u2lHCZy9LEIBye4zwFiQIzLoG6jo0lgQbDmuAX2PbCZKY+kWFCWg6pZ74wI72fJTnxhFeTlYWpufZwukSWAU8Ge8CH3xKlmIGzBnkklvl3MnoKNNoXgGBceGexwZqcJwOb+nzZ3QxPo7fGtou3cIz5FKi8V/ipCfO9knyDDojMqHzwlhC4h1h58uAOAg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by DB9P251MB0063.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:2c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Tue, 20 Oct
 2026 18:49:06 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0546.012; Tue, 20 Oct 2026
 18:49:05 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	lsahlber@redhat.com,
	stfrench@microsoft.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: Re: [PATCH v2] ksmbd: deny access for an empty DACL instead of granting the request
Date: Tue, 20 Oct 2026 19:49:02 +0100
Message-ID:
 <AS8P251MB00016AA2D945D625E586CF87C8672@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <AS8P251MB000104EEF679ECC44D8791F2C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References: <AS8P251MB000104EEF679ECC44D8791F2C8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0124.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::21) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20261020184902.50676-1-elb12345@hotmail.co.uk>
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
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|DB9P251MB0063:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b790745-bb7d-44dc-11f1-08df2edacfa2
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25031999004|37011999003|15080799012|23021999003|39105399006|24021099003|55001999006|5072599009|22141099003|8060799015|19110799012|260925184616899003|25010399006|4140399003|3412199025|26104999009|440099028|40105399003|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hnBecTqoWjJTwgeTq910aNoLu/yZJn3IkDQ7JDyTHk+wM9Tw1qywO0Rk9H/z?=
 =?us-ascii?Q?hoBUAc9uq/NO0XudHdwwcGbgTn+AERYj7YM1k6fTw71qKsid6a/1UO2HO2+m?=
 =?us-ascii?Q?5mPhnNdTb4aFafLDlRguCrnueg1/X6NCSGqwlfKABagqBnoiMn0CSiiBMwQG?=
 =?us-ascii?Q?bCzpdhLXHOTbBXqLMqPHdP06xWY4sFHDMyPvJd4EcnOveilCyYOUpVDAA9QA?=
 =?us-ascii?Q?HQneGA6dhFsZDfuZ6igOCtrpII2ubhNE6/oiPdtPL8OsKADWSmI8nrdMSzu6?=
 =?us-ascii?Q?sBMS4132bULSaXfl7l8fG0psBEGURaRLCZW5yIgSAxzlh2nzlZ9YrZCxNHQN?=
 =?us-ascii?Q?v7RvUnuoEFS6wx5m6VRcbs7G5BU/wvmsBCLBF0KisOC/YXtnybS++F7H/+3q?=
 =?us-ascii?Q?ajUl4zU5a033WEI452Ao30d5JvvAadmqfCDdmaUp02N9Uvu/T77OosA6gdWD?=
 =?us-ascii?Q?H/ST4YzLZYPn03Bj7YxFBRS7c3Kt1MYAzBLhAohjjBrlMo/F1CNsKsydllzQ?=
 =?us-ascii?Q?Zrh8l9k5F7bwC7GV9rQpwX2pouLJHDQE5ekgiTxf4ZQdOCthT+L00YhDNzmF?=
 =?us-ascii?Q?+reB0Z4KA+Gb2Whk6EjOKH1EB3hg4UcKpbs+ij+IXoqMgytrAi+40/F2aJQV?=
 =?us-ascii?Q?/Z4o5mi+wejs3FL0vqf0D7oSCX49cvq3Dgv7oAixR2k+YmWsqktObHaIyre9?=
 =?us-ascii?Q?JKWrNNKnanOp9IJSyhuJmXUe4+kmo+Gtcr4kg/nnDNoMfqIOQAH14rTEj63Y?=
 =?us-ascii?Q?34BEOJqeGmgEW3rjXFULoRVuA1/NnDMdPCH9ZF4uRLg9nes/eX8azId4EV7E?=
 =?us-ascii?Q?ILBJenA2eHnaLDaCuhMnljCA7LG5QgLR8nb450+42/i3C/KVZHWTv9wciU/d?=
 =?us-ascii?Q?364Wsrh2Go/PiuJwMvpdL1SKQ+w5231dX+z5E7hjoeL813Vtbj3WZ40Ds3pn?=
 =?us-ascii?Q?15TPmhu6eeXROTrtQlgudXVY5u+3eFaXHxjxBk8wxLG5PuaabwgoGTdm7AFv?=
 =?us-ascii?Q?+s1mbOI4nh81bj8Sy4TgviTwRfBxmFGZ2/BlJsHouhzXhu4EHHlwOECSAQmv?=
 =?us-ascii?Q?XXHOM3B1Ws74JInOWf7icw+ai6FshQ=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RusvD+ju9bnb3p/cp7jDR8mcdEaqlns7YENppbuOSkmK4AdlTWqnANxoCLuN?=
 =?us-ascii?Q?6CAe3JkMWS3O1egnQ/MTbm+tRcgeQnaGnGUeJf+q7UvPtnJC/nV8Cy4s3VyB?=
 =?us-ascii?Q?xroBDumD/jU/HpoWwMVoW5skEgL24qroTMlYjb32v945Y/1i3U9I1H3plgw+?=
 =?us-ascii?Q?C9rt7g1KgRagkceyZksvn82ea5tgqLDH6POdhRcxbPTwOFEm5mkTY/0NDUJO?=
 =?us-ascii?Q?RlXdWakEHIWSzpMOOY39YGz/CWnpuNjQ8pBIYLpUOHTS6ZgW6L9DlgijHHNW?=
 =?us-ascii?Q?eCuHmTIzcbPzTjSs1sdBqTqVL1KC4A6TqxY9gFdQKGQB0Z1aqoLWEYoWUV/f?=
 =?us-ascii?Q?ShHRUsGVLmK+MkB+RCx6YEIz2UFqZmdEuaaO7dVD+QpM2YtqTetJIdj/ykR1?=
 =?us-ascii?Q?AQwoOF7owW59OPZEDe64Rkyjf7y83iXKgkPu44z3DJr1BZprG6PWHzhPKX0c?=
 =?us-ascii?Q?KMsui1iVdRZRPSflLIr1E7AJZHinAA9b6NTnKdSoswFkMm+sMpxJAjdjWy2O?=
 =?us-ascii?Q?uekq5nNZQx1OumVlPY/5Rbe0ivP4RjkbY59ot8siOR7w0W26GaSUxbRNTYZF?=
 =?us-ascii?Q?Mj+DrEqI0gbDXXoGSyTxy4oxGJ+yha9CS+rOmYC+u8Z0vmbaXNSZVIVl5YqH?=
 =?us-ascii?Q?3Yuqw1z7EWrIuoRRdeX9/06Vp1Fk0g6JK7IVjymE5zPFYn4DhRIlE9SW2rZ5?=
 =?us-ascii?Q?bF9is8jc00vkemwvJK3XjUaxNIAjjyQH3ulZSFNp2f12+dxSNh5qYRd1sVWq?=
 =?us-ascii?Q?eNH3WMGPZkGNgsrLxynWfORkVJKPcRX0/F0+m/NFBIWrCgeswHbzP1+6/Abo?=
 =?us-ascii?Q?wfbQoFH26hGH57DECjqv5FWAQaNAu4u5Cl3eR48rYDiPDc40Sd/ittxvqDIQ?=
 =?us-ascii?Q?+YdPF3ADlAD+IIv3/wscsCVH3HUs2LaAIEclmnUS7kMj4Rg9r9G14pxExU8x?=
 =?us-ascii?Q?8gky1Q1RHEdTm9NwyYuOVNlPP3JshNBOOnFFJZ8vKI4aUC3XRbRZEsscE2Yi?=
 =?us-ascii?Q?2CPrL0K0VESGx4+49u23nT6hzpwwKSu1q+UbjmdVM59E9F9cZVA+ij5x1qdj?=
 =?us-ascii?Q?gyoG8c3dt08UBSbPQ50QRWyI2dgln4QKcZ54zGSkW/sBxHf/+ddUQFx7PklB?=
 =?us-ascii?Q?RWsXlBI08iSXeB7o7Q5T1U9ls0elUxKtwfgcBrJHNVRu9vD5RhhlwWuD4pYm?=
 =?us-ascii?Q?6dl/YWzqrZPBlOyZeRJFFKBTdW18RG2f6nkuAraPsnTZiLMC2ksZeZzDI4y3?=
 =?us-ascii?Q?Q9Tiv6GDXSJS3FMz0dVaPOyqbYMB9qxbllo/9Qa9CG4fkhmaVoaqtvbPrW2O?=
 =?us-ascii?Q?mctveoWuMkdmguohtdXLX1ak8B+HaEZnwqV87rLbKbuoljTIciFsQYLluMJ1?=
 =?us-ascii?Q?Xk6JwNATO9oc51eD3APqRZqjGpscrHh7lGyivM6Wmyl34NVmm9pTRDfPh265?=
 =?us-ascii?Q?mKxdgNw2KHTqV54dZ+y3/+pV/VpvmP1d?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b790745-bb7d-44dc-11f1-08df2edacfa2
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 18:49:04.9766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P251MB0063

Just following up on this -- v2 only added the Assisted-by: LLM tag,
the code is unchanged from v1.

Kind Regards
Aamir A.
