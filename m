Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [67.231.157.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF1B239E63;
	Fri, 22 Aug 2025 17:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.157.127
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755882724; cv=fail; b=QsGj6ICvmHl45ufBfFg1QZXnoWn5cs+l5XWn+elKk6G8bZp7M3ql8hBryZNe18FnFPrrFReWphK9RP7dZFzDHZFQrCUTIqhZ4TLoN5+pb6AgUuFVwfB3bAJ/Kpli1K75DP2oDkCtsRCcVUJ/G+J+o7ybLlEUR5Kpfy3VRNQroME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755882724; c=relaxed/simple;
	bh=UegzIFnSxXBXOEETkvQ1yfxQ/95C7eQW0NbOt34HMUE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S7DOOoTTvPiu7I/6i9Nje/sYcrw203stnkg8k5xel1F5+ZAFRoUeij3GobxYR4SCFBx7gAjyohTpLEWcRQ/3EhNyq1tg/pltrgL9bzxLGlSPVXpuSiRyulu9sXKsALi40i4y9h8rIfJjOqz9QD0CvJ/iCZC4KUhXwuiDi3Pej0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com; spf=pass smtp.mailfrom=akamai.com; dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b=hCXpxoQY; dkim=pass (1024-bit key) header.d=akamai365.onmicrosoft.com header.i=@akamai365.onmicrosoft.com header.b=nF+TVpop; arc=fail smtp.client-ip=67.231.157.127
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=akamai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=akamai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=akamai.com header.i=@akamai.com header.b="hCXpxoQY";
	dkim=pass (1024-bit key) header.d=akamai365.onmicrosoft.com header.i=@akamai365.onmicrosoft.com header.b="nF+TVpop"
Received: from pps.filterd (m0409411.ppops.net [127.0.0.1])
	by m0409411.ppops.net-00190b01. (8.18.1.2/8.18.1.2) with ESMTP id 57MDMsbs012843;
	Fri, 22 Aug 2025 18:11:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=jan2016.eng;
	 bh=vdYqv6J7ViVp2jb67jkEH3wrhm3Fdo1dpB5oaiiCjDM=; b=hCXpxoQYUA10
	qY6sAaFD8ssFFwlj1SBkZKHIFkJMQHD4RQHaN0bJ0+c/gK76Jg3Gitx80NRV6+zt
	Qjl0sqBpty2kg7wGxG27und3skNaMT3XgJ532z0fehCpoGKY0av2GaqsmVooA8I5
	Q2AtAWBcSf91MWmCx9clWn09XvfFlJu56VtEYwBgNscer+sRha6ykPuFgpkWP6Cq
	XhzTtzAu6zVot2/XGYjORdyLFmkq7+79EliX+oRC9VU/x8Q1m0yybuRRvYBLhq++
	EQ0CIWoM2rGW8Et4KyG0cg8bL8tIW3Y2UBSwCMohNBcaodNGbii5D5itUnyn7+jr
	RlH8bTmR8w==
Received: from prod-mail-ppoint7 (a72-247-45-33.deploy.static.akamaitechnologies.com [72.247.45.33] (may be forged))
	by m0409411.ppops.net-00190b01. (PPS) with ESMTPS id 48nempgdyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 18:11:05 +0100 (BST)
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
	by prod-mail-ppoint7.akamai.com (8.18.1.2/8.18.1.2) with ESMTP id 57MGSOws018686;
	Fri, 22 Aug 2025 13:11:05 -0400
Received: from email.msg.corp.akamai.com ([172.27.91.25])
	by prod-mail-ppoint7.akamai.com (PPS) with ESMTPS id 48myf2crw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 13:11:05 -0400
Received: from usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) by
 usma1ex-dag4mb6.msg.corp.akamai.com (172.27.91.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 22 Aug 2025 13:11:04 -0400
Received: from usma1ex-exedge2.msg.corp.akamai.com (172.27.91.35) by
 usma1ex-exedge1.msg.corp.akamai.com (172.27.91.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 22 Aug 2025 13:11:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (184.51.33.212)
 by usma1ex-exedge2.msg.corp.akamai.com (172.27.91.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 22 Aug 2025 13:11:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENoBL+meBBVlNSRmHZBqn/Ktqo1Nu7AtZNiaSC4VlO2cBHQEqkx8UvYz55bOgCyVqQdAk+bsld69JMZ8WbT4c2r0hqipvETX3mUi4xY36evCy22xf0KSpPZ2KIw8SWZyje+BcGJHC6jfPSATD9ZKGJ/OCAFAyNHhNDaEvAOzImOoblAXnSfrdP4cltdZM6/UV+fUXiWwOSPElViHwh6CZonI7EG+sXGMmop2dcJCrGpKx2hB1mzTJQjwjYVOKArbBegRlapJzQt05BPG5tbvmTOkZVbAVkhBBOi74FKODO3sXkaQebIN3DnO695mbiMjrkAF6RGb7SB9d+RHZhPmZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdYqv6J7ViVp2jb67jkEH3wrhm3Fdo1dpB5oaiiCjDM=;
 b=eEIAJ+z/XLx2VlNTknxF5ch0eqxcUwEZ63XBujYuvzVHaFV9V1XmOsPVS+lu2P8KXe6hHB1uaSMDui7LbuKp8K9kj6JRzK7YruwMLCpPsYxUGl9UfMa0DonJoaiJCR65D+qZ+z/Y4bbkYHmXnw2z4YtQsrLmkXpHqnmyZwT6HcLV3oIiWvuH4JtlXztWlbT7zB3Z99UV3khPUJgV4bzaeUqTQKEgodj1nUUrV5h0/Dn/lXtoqyFNPyFdm8nFGiXWjdfGVRfgIrerjqTZ9evHb+dpwr7goZ/Fb4RR94BtubH9150/Q3bEodKnOnqEOcig5nq8suDwJib1NR/0WZQM7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=akamai365.onmicrosoft.com; s=selector1-akamai365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdYqv6J7ViVp2jb67jkEH3wrhm3Fdo1dpB5oaiiCjDM=;
 b=nF+TVpopZVR1VYOQKB6kQ2AuhoC99GHZCMxBoiqwIqfLIXeACRYQ6iY4YC+yXhJ7FpGPXT48eCblp0M13UwlqldtUNNxSzpd7Za2YpmB5ISbgToRGUAtBgbFUB5FB8/6zhkiODd8PNCttZ2XMNlnEXdK/q8BlXzFKp5u9LgZYYw=
Received: from CH2PR17MB3669.namprd17.prod.outlook.com (2603:10b6:610:47::24)
 by MW4PR17MB5530.namprd17.prod.outlook.com (2603:10b6:303:125::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Fri, 22 Aug
 2025 17:11:02 +0000
Received: from CH2PR17MB3669.namprd17.prod.outlook.com
 ([fe80::ecdc:2512:2236:c203]) by CH2PR17MB3669.namprd17.prod.outlook.com
 ([fe80::ecdc:2512:2236:c203%6]) with mapi id 15.20.9052.017; Fri, 22 Aug 2025
 17:11:01 +0000
Message-ID: <7fd0f513-df05-43f4-b1dc-0fdb74e78378@akamai.com>
Date: Fri, 22 Aug 2025 13:10:33 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 07/15] quic: add connection id management
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>,
        Eric Dumazet
	<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman
	<horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
        Moritz Buhl
	<mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
        Pengtao He
	<hepengtao@xiaomi.com>, <linux-cifs@vger.kernel.org>,
        Steve French
	<smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Paulo Alcantara
	<pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
        <kernel-tls-handshake@lists.linux.dev>,
        Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
        "Alexander
 Aring" <aahringo@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Cong Wang
	<xiyou.wangcong@gmail.com>,
        "D . Wythe" <alibuda@linux.alibaba.com>,
        illiliti
	<illiliti@protonmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "Marcelo
 Ricardo Leitner" <marcelo.leitner@gmail.com>,
        Daniel Stenberg
	<daniel@haxx.se>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
 <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Jason Baron <jbaron@akamai.com>
In-Reply-To: <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:52c::34) To CH2PR17MB3669.namprd17.prod.outlook.com
 (2603:10b6:610:47::24)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR17MB3669:EE_|MW4PR17MB5530:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de39f9d-27e2-4b12-d00a-08dde19edee6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R2tqRWZ1SWl6dHNjT2tJRHVXaGdwaGFpT01yb0k5MU9rc25ZN2RBekJPRHdn?=
 =?utf-8?B?NlhVRHNUUXNabzhwejYzVjM3TWgyak1SUGtNOGpWWEZBMzNsZXpPZVdkQlJM?=
 =?utf-8?B?ZDc5Qkp0bVdSaW82YVNNRTZMVkJSZzAyRTNjQ2hoaGRvSlhZaS9leU56c2lQ?=
 =?utf-8?B?VTNYYVVJNU5USXpRZ1FQTWRVa0ZUaWJXZFVNb3VVSEU3RUxpWUljMENnVlZL?=
 =?utf-8?B?dk9QNHd3dW5tNDgxMWhjWXdKcVVQVGxRYXhDSG5TZ0JNZGpMcDNPWHIrOTNq?=
 =?utf-8?B?UXVzVTBBdlJ1cUR6bFcyVXUvV1ZMeUwxN1Z2Q1FsdXdSLzBmMzlJVTFSTE1D?=
 =?utf-8?B?aDBHTWpWQnFCNERIRHM1TDR0ZzBpdDVIeDBOanYvSWFjQWpqTUg5MW9KZE5a?=
 =?utf-8?B?NzJzTXg4RjY4eXhIZStZUThMWTBNV3QzTnlmZTV6cEVMMlVIWi9yZzdkaUtV?=
 =?utf-8?B?cU5pWDU0ckQ5ZTlvem1PV2VSR1lNUDg3Q2R1a2VVVnBtV0poVm9Da3VTRnJR?=
 =?utf-8?B?SkowelVmTUY4eHBHalQrRHpHM3piS1Y2dEk3SC9hUzdXZ1VQYVJTU0hOUHd2?=
 =?utf-8?B?Vm85K3YrWkZuSTFLblhJbXpxc3dreGdkZGVITHY4U29hV3ZoOU5idHEwd3l0?=
 =?utf-8?B?YnBaS1BHd080S2RKYnB4S24rSzhHLzhBeWw3c1ZnNm5MWXljK2c2V3lJMDRo?=
 =?utf-8?B?elhqai9DbWxPQlhMczM5cDVSZW5IY0VNSGN2c1lqZGF5Vm43UmU2UmJLaTly?=
 =?utf-8?B?Tjh4SkFLczFUdU5tc1JidUtqSVJIVXRsQnduY2R0QVpOVkVIaTlPRlBpTFVI?=
 =?utf-8?B?OHVoYndPMVNDMVFjbERVczY5Szljb29uN3Zzc2ZQOEhGZU1ObTZvSkVJY1Fn?=
 =?utf-8?B?VVF5T0FkdTZxWFBORUdQY3hNKzdabGFKalhNSzgyajJRVWFHdzU4ZFI2SXM0?=
 =?utf-8?B?WG9pcE9CY3crUmVCOU5mM2VvaFVHSEpTYzJ3TzRPSUNBeHphbldzclFzQ3lH?=
 =?utf-8?B?VFlTcG44WTlGa0JCZ1RNTDhmNDh4ZEdsRERBbkpRdFFDY2xISlZjd3E1alJC?=
 =?utf-8?B?b2NrK2k5MlBBZXZQbVRLaTFpaks3ellnMmYrQzJmR0FVa24rNkhLbnMyalNB?=
 =?utf-8?B?QWd4Wi9zSUR6VmJjdThlZ05VQ0Zkb1dnRDhHbGIxMGxpUVF6Y3ljR3pQWGhv?=
 =?utf-8?B?UWlzSkxISzZUaU9Udmo5Z202YlhLbGFSbTRSNnkvR0hXQ0F4WW9LWTVPQURU?=
 =?utf-8?B?akFpTWdLdHh6a3paQ1JpNkQ3SXowVEdKUC9lanNOdG5zMERrMnRiWG5jcVlp?=
 =?utf-8?B?NGhLK1RnTi9OL0pyNHNhUnRKMy9nSHo3TDdqdFpjc2RaZmFqenpEV0l5R3VL?=
 =?utf-8?B?MlptdGZzMVdPN25iZ3BGbmxVMi9pL1ppS0xQZHZxUE0xVm8yNFVLajFlVy9p?=
 =?utf-8?B?UHllWVFMU0tKbjJhZEpLUlJkRDVGV0Vxdm5aNUliUWI3RmNnbTBJdDZjb3ZG?=
 =?utf-8?B?YU8vck10MHAxNmdnQUNBTDFzb3VGaHNnTmlJbFFYUmZjTTdsaThwSk9Yak5i?=
 =?utf-8?B?djNMUmM0d085VzdyT1NtVUJiSzRBenVNbkQrOHJZV3NBNWQ2R0FPMUNnTGo4?=
 =?utf-8?B?dmVkZ3lrVnlQeDh0R3puWFFMK3JpRExxRVFvK2x0UkF1MXFEVzBYT24vUVRk?=
 =?utf-8?B?SkRPaTVHVXl2WUNUR1U2ZzNuYXRiNlkwcUpVMGpIM01jUG45WExHb0RiVFFh?=
 =?utf-8?B?ZXNyTXlHazdOQjNBWklHOUcrV1Q2Qk11Rk1hZW12Tk1jdUxKMWVnbVVmNEgy?=
 =?utf-8?B?ZVdhNTlOOGhtQlJiYWVKNkU0WGhKK0VpT3RzRSsyZlIrRlU5dERoeE1pcWE3?=
 =?utf-8?B?a2o2VU1tc1ZPbXNFOU5pTUYwWjBRWEVCS2RrUXBVdDd0OVRyOVllRCtGeUVO?=
 =?utf-8?Q?ufgPKfCtEHU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3669.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K09nNE9iS2l6K0E5YzdycEtQbFcyVVhUWW41TjVvV0lwNEJpbEo4S2VYQ3kz?=
 =?utf-8?B?ajEzVEZwRmdwSC9sU1Z5N0RZM0x2WW1WUWVKWDBJRDdxeXY3VG9TMnlUeHdK?=
 =?utf-8?B?UVZ6Z1JLV3IxRFZmbS9GdVAzSXhnSjVGSDB4K3FVblpLRXFScHpQdXNLVDJI?=
 =?utf-8?B?VERsTnh4ME1SM01oYXJpV2NPd0J6MlV1Y2tBRWZRWDZCT0VhNEhyUkxYbFZn?=
 =?utf-8?B?aFNjYTcvV2JuQkhvdWJnRDdaTmhNTWU2TVA2NVVwQVoxWDY3dThlNi8wd3pw?=
 =?utf-8?B?VjhrZlJKRGdITWxhd0NvUkt3RmZSZHowVHBJeVBidys1Q3ZBbE1KdTEyR25P?=
 =?utf-8?B?Y1lLVy9OTXhUM05iU1VLUjlLYUpuS01YbHpkb3RaSUUvbU14aVcxUktYUHdH?=
 =?utf-8?B?Q3N2MTUyWGVrRUU0M3hNRUUyWGJVaUYzZk11cFN5MXlqWG1FbXBoWU52eWhW?=
 =?utf-8?B?cWU5UmQ5NXJwbTBtcW1QWk1yaVpmUWF0QTVUck9Bd04vbEJPdnlCc3BBaHE1?=
 =?utf-8?B?Q2l2M2xHWS8wR21Rb2ZrUS83OVZFVWs4Y0xRRXdDZ2t4bnNWUXA3elFwNTgx?=
 =?utf-8?B?ajQvenlkU0s5bkNtMXV4RjZ3dE5yNVoveTV3aWtJcDJCWDlrcmJaQkJKeTd0?=
 =?utf-8?B?TFJzYmhLZ0krd2xaSlpUUkJxZFJ3eGZiUUJPcEs2SjdxNlJzTkRNSm9Cd3Mz?=
 =?utf-8?B?KzBDSGZ2Y1BuQ1BJcG44Z1V4RkVpQVF3K0czRm9aQ0o2M3gydFU2M3luNDFQ?=
 =?utf-8?B?NHJBSFZiS0Y4YlFKQkZQWjZnaVN2elduZ1dNYzFBU2NFZjAzMlY0OGR1OUQz?=
 =?utf-8?B?NHJvWC9OTXpKeGs5azFyblluZDUzSjk4VHk1NU1ic0gyVjJTUnY3VzcrUXBV?=
 =?utf-8?B?L2MwVENJeVhUdUs2NnhyVFFORHRlbXdGMlprYkI4K3NkelUwSC9QQzc5Wjdk?=
 =?utf-8?B?UWYzaEdoSzlVZXRNaWpXNHZtZDJObkpaZkpmV3JoWlphSjJ4OWppbG1vUGZ5?=
 =?utf-8?B?U3luT2cxcXdRc2lmaXhjZFBGenJmWDBSSEkzM3VCYkM1WVNuTExhOEZCTTd5?=
 =?utf-8?B?bUh0K01TR3l1UG8vNVZ5YzRZMmE5a3NFNnVCSzFTR01qNXlBaUZqVmtlVlJ4?=
 =?utf-8?B?MXBVM2hBU3dObE5RSEhyeEIyY3RrMFhibk9kZjQ0VzIrYXZObEVzQ2NnczZ6?=
 =?utf-8?B?ZGV2UVFuYitmcGs3dWxxa0dMZ1VGQ2RjN3o1VXZKVTV1VWx6clYyQWN3TExi?=
 =?utf-8?B?Tms1OUFDcGNGTlZ2NDRsbDFvZWNramg5cy8wY2k5SjRzbFRpcnVvRWpWY1ND?=
 =?utf-8?B?NzRIYXpxN0lrVXlLSkF4U3JnSjU3UjBBYW50Z3RKZm02LzNXMnVYb1Z5MmVq?=
 =?utf-8?B?Y1MxVjhRVUZTdjVBSmcrT3pDTjR1UXhRNnlsOWJ1L2EyQ1BzVVZpWjQ3ZkFV?=
 =?utf-8?B?a0kwaUhGcTNMZGZISUcrbUdvOWpJeEsxSkIyalhnS1I0ZzZlWjN6aXJIZjc2?=
 =?utf-8?B?TWVOQzQ2MDJ5eng5aXVzUThUd0ZHMmswSFJMSHptQnpHdzF2dEpuRSs0NHJ1?=
 =?utf-8?B?cCtvRmhKOGM4WHNYMkU4MEJZMStyZHJ0S0s0QXQ2SFZ5a3p3SnlENkoybEZ0?=
 =?utf-8?B?UDhpT2dnSHlGVVM3d1lGK1dHK0xUSXNXZnhNckxhTkVKRmZDT2VGNkxnZ3NP?=
 =?utf-8?B?UjF2cnBGRFNGeE1IK25lVHVjSWh1K1dZQ1JSaUdWMXIxVUxQQlNLM1N3NHpU?=
 =?utf-8?B?TTFDNFVzaVFtZkVJUW8vdlo2Vnd5VlFiOTg3ZlNZMjJLMFpSeGNVaEJHS3B1?=
 =?utf-8?B?bE8vU2JuUjdGRTVuTG5iWUt0UDFXRUI3dlFQNWVFZUdkOFp2MmdWRXhJZjFM?=
 =?utf-8?B?dzA3WS93dHlDVnVxMVpRVjlKTzVnbXptNlZUVFliUmJwMnk5WWxDZHBSYkNs?=
 =?utf-8?B?VFBNOEp2aHBSVjFyV0FMRHJLeDJZY0h6QStvOE9nYVFFZzZvNHRkTHA5OEJ3?=
 =?utf-8?B?UjEvd3JjVENoZEFROVFwd0dGNWNUNEZYLzBDeURGMHJHYXhCaGp5S0JMU2lB?=
 =?utf-8?B?TjVsSTlFMkRuM0xlVDcvc2dtSHh0cFpYTXovQ0RFdjA2Q3F4QjVmQ1R2N1Jv?=
 =?utf-8?Q?cOnvMDguunJCDjuYwZoPjHrsN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de39f9d-27e2-4b12-d00a-08dde19edee6
X-MS-Exchange-CrossTenant-AuthSource: CH2PR17MB3669.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 17:11:01.8660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 514876bd-5965-4b40-b0c8-e336cf72c743
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11s/7R8qfiCLIgAZO2yZI770/y4tG6wVzPhmUg1712klv6NPS8dQ+3QdqidGGlEhkGVDeTWfN+hENnlG8DLEPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR17MB5530
X-OriginatorOrg: akamai.com
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508220156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIwMDExMCBTYWx0ZWRfX4poyRCJPWrr0
 bHgmrW0Lttxn8C6PFskP1jXQzEt2uo3Mp7j28Wo7IXRyVbfzqfn+Ey67N89jyAJL2oie6eDlkc0
 5w4RxGQvBQ1SuPMJpAUaKIw5HmL5K+jf9NP/RePLOT8BzlAdM+sGvJ3xv+o7zpvmRA4VxxQ59ge
 R42JinRHMTv6ZXz3C2b5XMIYUyYQAIIClg0mz9bL0x0TuRcn9FnSfF4NaJLO9sjF/wex88nh1u4
 e3yzQFNNPd6iVM+gt8bOeTPKTMH3oErVKZBVpYe3SJJf2mwi9AitBNsHq56eW+pCIYTc5FQocFE
 u2wKHZu3UEmcyfb0YoeLt2NOzW0TnXnX9J2G63L6QbUj02k75kz3ajry3tCvQNGfc21C6kH68il
 ODJQ+xDi5+NZEAjnp/7c0+WhAO884w==
X-Authority-Analysis: v=2.4 cv=T4LVj/KQ c=1 sm=1 tr=0 ts=68a8a4a9 cx=c_pps
 a=3lD5tZmBJQAvN++OlPJl4w==:117 a=3lD5tZmBJQAvN++OlPJl4w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=g1y_e2JewP0A:10 a=48vgC7mUAAAA:8 a=pGLkceISAAAA:8
 a=ZYoOwGVJ7LitIazS4x4A:9 a=QEXdDO2ut3YA:10 a=DXsff8QfwkrTrK3sU8N1:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-GUID: b-4E5tZ0gTLVzeOnln4C5mpcuhoWWzT0
X-Proofpoint-ORIG-GUID: b-4E5tZ0gTLVzeOnln4C5mpcuhoWWzT0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2508110000 definitions=main-2508200110

Hi Xin,

On 8/18/25 10:04 AM, Xin Long wrote:
> !-------------------------------------------------------------------|
>    This Message Is From an External Sender
>    This message came from outside your organization.
> |-------------------------------------------------------------------!
> 
> This patch introduces 'struct quic_conn_id_set' for managing Connection
> IDs (CIDs), which are represented by 'struct quic_source_conn_id'
> and 'struct quic_dest_conn_id'.
> 
> It provides helpers to add and remove CIDs from the set, and handles
> insertion of source CIDs into the global connection ID hash table
> when necessary.
> 
> - quic_conn_id_add(): Add a new Connection ID to the set, and inserts
>    it to conn_id hash table if it is a source conn_id.
> 
> - quic_conn_id_remove(): Remove connection IDs the set with sequence
>    numbers less than or equal to a number.
> 
> It also adds utilities to look up CIDs by value or sequence number,
> search the global hash table for incoming packets, and check for
> stateless reset tokens among destination CIDs. These functions are
> essential for RX path connection lookup and stateless reset processing.
> 
> - quic_conn_id_find(): Find a Connection ID in the set by seq number.
> 
> - quic_conn_id_lookup(): Lookup a Connection ID from global hash table
>    using the ID value, typically used for socket lookup on the RX path.
> 
> - quic_conn_id_token_exists(): Check if a stateless reset token exists
>    in any dest Connection ID (used during stateless reset processing).
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Thanks Xin for all your work on this!

For QUIC-LB, where the server endpoint may want to choose a specific 
source CID to enable 'stateless' routing, I don't currently see an API 
to allow that? It appears source CIDs are created with random values and 
while userspace can get/set the indexes of the current ones in use, I 
don't see a way to set specific CID values?

For reference here is a proposal around it -
https://datatracker.ietf.org/doc/draft-ietf-quic-load-balancers/

In the reference above, the source CID is encrypted to help protect 
traceability if the connection migrates. Thus, if the kernel were to 
support such a feature, I don't think it wants to enforce a specific 
encoding scheme, but perhaps it might want to be a privileged operation, 
perhaps requiring CAP_NET_ADMIN to set specific source CIDs.

Thanks,

-Jason
