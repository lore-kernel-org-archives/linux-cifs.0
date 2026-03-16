Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA39C37A4B8;
	Mon, 16 Mar 2026 23:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704989; cv=fail; b=pQbfWXUQolLvhe+B1tGujMRIzKh06nJpF5KSJ4z5lKwiFk84242vrlwDSoRdJXs/+4a+Hw1SF3d7dcjt0xIijZTQdfcn/vI0OR/5830ySZOVtm13R/5+poL29nK2tg4HCU83rNiuxlFIiSBIGu7Y2VeiCqW8R95+shcSPwK8U3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704989; c=relaxed/simple;
	bh=e5jz3IoPerYiL8yK2aAwdyogXm4p9q7YlS/YllOcmUA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IdgzQvidyZwO+WuXEtq/y7UjSoeGBmNoaewn8SnGFeeNWLUpdABh3+8cdDsBA7iG24waVT0LkbIVgE6u6hZrKdKFrA2bHjWWglgZErFa4tp0BMI3NNub/MA6OBicmX83ffr2G3LpIfpe6ZfGjO/mTIgpFeXMZlOuMa1PgCxEINo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fodC0xH9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qv4PrhPa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fodC0xH9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qv4PrhPa"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62GECvLE1184807;
	Mon, 16 Mar 2026 23:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IlzFq8L9eVxsWmd/QUNHE75XOtNvyyNBLgOZF+9QsFM=; b=
	fodC0xH9hrFhoMdfrQZTder9/4fhCNHK75gFbC7Q3z0oquCUT3hzATczeIoGQX2y
	B0/qysuXalmluujdjly418Pyy4Onm78dBy+VjkG99Qa1w+OLLbCi7NImFuljjmn2
	F6fCDiMxZfqKmldRr7W5L5khp3GmsEVCShlQ21FQXoWligs9OPybul+RJG3jWeOu
	kJDcLy9E/e3FOwyqPVe2aW0qqT6UyPKuuSoX8xZ8gji46ZZQn3T2hKESGkEE6A6d
	H1gYSwxUobaQDi9pROP+xt/lGVt2VrTYuTbbo1lHl0klCqnjOVb9GemaPVIzz6dr
	XgKQgyMn52ER2ivKPbVpTA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxk8bat9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 23:49:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62GMMqFC014031;
	Mon, 16 Mar 2026 23:49:10 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011027.outbound.protection.outlook.com [52.101.52.27])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx49a1ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 23:49:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nttPPwklYmcERJ5armQzk06zNbvflK2tE73QqH6ODmKO8tQyyLMBGwbBqjg2muNCNJmklEROgsKjIyXU4NVU34zXiEh9IpmIXjSdHTpIq6Oc0828wscpYd0JO0m898LBUxCDNgRr/RRH5NMKmTRB5wXiHfwxzSOCEF+heWJkF1GKH80Ureu8vH4UsHe6Czd6lWs5QtNk53MFso2YWVBUcN+Qq9aTcP5HwKNL/bqgsvWtDzbMcNUE0u5+qYfTvbOf4vrgQ6B8I3VMybw6vUm7+1onUZi3akDWcfO4Gf9YGkBanQzre+VelnkegJZR1x9XU3kDmBFsNRRuLSsVJLHzGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IlzFq8L9eVxsWmd/QUNHE75XOtNvyyNBLgOZF+9QsFM=;
 b=wTh6dgWWvE9xotWleQTNkaUeIGtfhDi4EbQBPWqonbgnEyTzLbrOuZX+xgj5ZjMTfTX8geL2kHn8Tp3LSICOZChHrbRJQDnrSytKBFtPZK6zkLz+Hpq2iVU3dGUo2RPtxo5SBaKyDlKOFplsm7fxnPEyUBLgupPPvlNIqr0ed8B9PCqceSZMv6ZHDIVT9ZS9rfmvm2ZKdB9rx1aqzzTKJgDVCGRWK6uDcKGqydhwimKEzuM1Ef2HbIG5cYcwR36CeKd03K67M1r2+rfpiBORgfh9sV8a3wmnwHNowFchg+oWoFQ4DI3F4olbg0HlCzOP5CUsSVhlXCVEAbsCr+uSdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IlzFq8L9eVxsWmd/QUNHE75XOtNvyyNBLgOZF+9QsFM=;
 b=qv4PrhPalGiWDXhZLzru+GLwo0knikx+2sy5r2PKqZ9BWMweFY44HgU3q4ggSFBpnXSFM1GyvIENw2wk3mTmuEPj5C682CUWpFPEZ0gAcZwgITbo/Xqgw1zzHnbZy5Hu0IpJlUD2vauFTtxbtRdLrPswoZsFxtuMQncFJoOLbUA=
Received: from CH0PR10MB5131.namprd10.prod.outlook.com (2603:10b6:610:c6::24)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.24; Mon, 16 Mar
 2026 23:49:07 +0000
Received: from CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307]) by CH0PR10MB5131.namprd10.prod.outlook.com
 ([fe80::ab76:24ce:816a:8307%6]) with mapi id 15.20.9700.025; Mon, 16 Mar 2026
 23:49:07 +0000
Message-ID: <dfdc8367-1078-4823-b093-89408bc5900b@oracle.com>
Date: Mon, 16 Mar 2026 19:49:04 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [External] : [PATCH] cifs: smb1: fix comment typo
From: Joseph Salisbury <joseph.salisbury@oracle.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <20260316181921.151493-1-joseph.salisbury@oracle.com>
Content-Language: en-US, en-AG
In-Reply-To: <20260316181921.151493-1-joseph.salisbury@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P223CA0018.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::35) To CH0PR10MB5131.namprd10.prod.outlook.com
 (2603:10b6:610:c6::24)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5131:EE_|PH0PR10MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 48707184-5ba2-4543-c5b3-08de83b69cfd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vrvaTe3C6GLuqZ4k9OgtNVAODuEEjuu7R9SlCPe2UsMxAVakPLGgpDTDmXYKSdgbdtYmMdhTVhpgNf/jGoRv6akglYD8b+0wtUpsW3oL5ISe/0gCaapPugyfS3Y7wLgKEpLxThys5cYlmg7lrAm9hEYm68shK90lelRUt248cKtX8W4CkGt2rznqTMl7nlBMWOJu0I3e0S05rI+Mz3KI3DGQr6O7a5uVOc+2H7QF5kVMv1Qs9oN/pBwbtm5rRmMDAzbsqSbvPjtL57QG6fYc46AGo2/khgPtDp1jkoDdyi7Qj3yuH5zu3bi5ife38vz//RjFjbZBl4fpv+PnfUkvuEloLQvmB4tRnBhc9yTiJ5jsjIhKwfsK3eZtvDrBg1r/KB/X/6keBiXOAXQwOgKGNnDAmwIrSakndD5oP6eoTmAlTlywHWj64IyEUuJWXQVPFBWT5PS9q0LmnCa7172t5EFHmIBp5k5Hy+jcKZsZh8GUNkVJ3pLdH5Io7xsxIo/P9cKKuoHjYUTWMXsZQjXPYwPH7z9oktrV0VA5gfZxNUSMK8hsHCMKYbMyR4oh/mYCZRVGiZitWhnRZi2v7Sqv7sDwJiTROXEBzKGFPqIuJTk54QbpU6uSY0wvLUuo0gLj3TkYW29j9cIIpxzRzj5rGlxXn+bFyP+LZLdIgJEylPBRrnYBp/Aiw6otWUvVTIFu+ESC/QJUWLV468WK6KZGx2yY0FV3FRNGTU0BWn0bfVA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5131.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3hVdlhxZitQTkFMdHg4MXQ3SnRndlpnUGh3Q1pKVCtQb1c2RENKTVBremRJ?=
 =?utf-8?B?cDZuaVpURUNmQ3BRb2o2NStLNklmQ1pvQWhzZ0FjYllSUXJzNTNvdXFBTkNK?=
 =?utf-8?B?czA0ck9QUDZrQnNIcEFqVExSaHhsRjZpZDdQVUQvYUpVUUphWm1YVjRwVEFo?=
 =?utf-8?B?SE5KcU9rZndVYkhuZTBobUtGY0swUHQ2UHYvTG1LOVZPdXB6MHlRSEJLK2RV?=
 =?utf-8?B?ZlM1ZTNHdUpRZnlSbzhvUDNvbENwdktnY1lsVjcwWDhaUlZhK3h0dy9zM0Uv?=
 =?utf-8?B?UUo2UjFnOUZlNFlqYU5OaG9lSkpUWXIxYjRaZ0lBelBtQzd1Mk94SzBXakhs?=
 =?utf-8?B?a1dxejM0dWxLck82aFNaWnNMTWhrbEk5aC9qUEtMOUN5MlJ3RFpDa0tGRk92?=
 =?utf-8?B?WXJ5Z2JoSDZXZFV1c040ZkZSQ2VCK1ZvTTVxMzQrUE16bW9lbEtoZ21PWXU5?=
 =?utf-8?B?ejMvSVRMckFuQXdIS1JkYVJRMVBVRWFlb0ZaY0FOTzlvcTZxK0NsRjRhRkF6?=
 =?utf-8?B?YWJjenlkZVNjRnVqVFBOZHd4SFQ1enRwdDJndnFPMjUwM1dkT1k2NFh2bWRU?=
 =?utf-8?B?TzVjOWxWbjY2ZW5PQjd4SnlZSTZlVGIxdXExS1YrdnRoKzVKd0pvWVI0aC9Q?=
 =?utf-8?B?Wkt0WEJtdnUweHRJZHpYdzdIM25RRmhzRXZWcHhidTA3U0RZTmkvMWQvUEhI?=
 =?utf-8?B?MkhZSlNjWm1FaklzTHdoL1ZMS244RFRBM0FscVNXeHVMZ1c3SkxhbXkrN01W?=
 =?utf-8?B?clY5MDMrS2Z0Ty9Qb0tsUGVZZ3pJcWw3VXVwek9aUS9oSW93N3lkRGl0OWtq?=
 =?utf-8?B?L0FDYWdLWWZRZW5PT0VwQVZSSnF2UUhhQzdaTFVLdDBDM1oybDFZMXZsN2Vp?=
 =?utf-8?B?U2NBYzFaS1V3Vnp4T2lZRU9KSjJQUnljTGRBdDZkc2JVVzRvRDliZlJNQ3VS?=
 =?utf-8?B?eDZYVEpPQWRsak5rd1F6aHNZMUgvL2YyQjJSYXFYa3lzRVNFQUZqR1IwVHFh?=
 =?utf-8?B?RlhaUCs5eE5aemFob1NvRE9Pb3VwVzZ6bEcvTDdqb2p1YTU3V3ZEK2NMckxk?=
 =?utf-8?B?WUg1Qk8yYUpxbXRpS1dTbVp0R3pvc084NUt1TTVKVGhndFk4YU1Hdm9qZjht?=
 =?utf-8?B?ZTc3azlFRHNKMXlKY1NBV0xZemJHb0UxdlkyOEJLcDloTmFKUEZPRVQ5L1NZ?=
 =?utf-8?B?cXFlQW02Ty9xakczVjdsbXk5RHhBNjFrcmtrUXFtSU5jVVc4MnNMSVZRNnlW?=
 =?utf-8?B?RkVsamwyaEVDNi9KdjhQUVZpMGlNZzFWczRlS2VJdzFmNDQvVHhvQjE5TEJG?=
 =?utf-8?B?TEVma0NQWWJoR3dpOEhNdGZRZW0yTnc0S1puV3U3cjZzdzljR1pnUGYxSXlV?=
 =?utf-8?B?MDFzQkpadVU3RjRpanhIa2NQREk5anpCTGFMcHBabUpHSDd3cGNaSFpYeDBI?=
 =?utf-8?B?cWduMkVEUnAvNkhtMlhuZlBYV1JXWko5NC8xendNZzJ4bE5XV0oydkMxa0RD?=
 =?utf-8?B?ZGZWdGZRTFpBbS92RXNqZFpGUEJjWTV5S0J1RklhVk40SThRV0p5cThTcUEz?=
 =?utf-8?B?dEQ5ckFkWkRhOElZNmx3QU41ejhKZHhmR3dvRnhURzhwS3pzeGM3Tlh6dnZG?=
 =?utf-8?B?c3VuS3MvWU40MzhNdlh1bllId2N6Ym1pMHFJRTRRcnBhWWFvSjFIQWFwY09j?=
 =?utf-8?B?YW5rekhaeE8ybW12OUliZDlMUnNhZzMyenB0YWZaYjZVVVZxOEppN3NUdnZv?=
 =?utf-8?B?L0tvWFlScWNUbHE1TEs0SGJZTkdzLzZ6SDRVc2pteDJIV2ZmcThSOTdLNTJv?=
 =?utf-8?B?NDZIZzJEWFhJSW0yNzIzYzllZDgzckUydEs0SDYwUUo1ZXViLytoZkJwWm1n?=
 =?utf-8?B?ZWFtd0UydG9IaXNETVJEMHlXaFVMbEVoczVORGVka0s1OVIvSUkwajNpb2p6?=
 =?utf-8?B?RDlBY3NjVmNibzhSWFJHam5mbDJwTTRWVENhR1VZVDd1NkJaZjd2NnJaT1c4?=
 =?utf-8?B?cHd5VDZ1TEFKb1ZjVElwNmJDYkVDRVNLOVlPeUptQmYzUkhUVEJVL0lPT0lL?=
 =?utf-8?B?aWcrMjdmOUNpTlI3cVN5dnNrRm1kN3lKaW1URTdaZ09xU2paREp3RmRBTkty?=
 =?utf-8?B?amRLYkxXTzVrd0RjZXpUbGNOdi80eGpjMThDQ2pSKzI4bUh3V3I4ZU92NWpm?=
 =?utf-8?B?R2dJdW4xblZTRWZIQ2NCWFN3dkFad1lwaCt3NU5QN3F3aE0rRnFSdW9PQ2FO?=
 =?utf-8?B?UkN0ZTE2V21Bb3Q2Vk9kZ2hXcGZTMXFhYm9GZ1NzSFFVK1g4MXZHT1dhbVFJ?=
 =?utf-8?B?YkZRdjhJSlpLTHJFa3ZEWUtvZkRyOWJOdXl0dHl0SE5keXJiL3BkQkJ6UVRt?=
 =?utf-8?Q?OjSIZxe8QqYpmub8=3D?=
X-Exchange-RoutingPolicyChecked:
	QjPJvIvvCl0+JUCCeZ5Keki4+XSnTNQSMohMruIbehArBb1qHRDJWEhj7riukzeufh534qYYRcLvv3qFKbAjRJsbIYDSIB6XnSuqNyFKRb6HH6SCG4v3eSNQPhDcCyVl6JTsFOaFi+6dX1hkEP2X5rnAhb6sKZuXasaQuhCI8gvYqk5WQ4LhaoxKETFQFYJQM7bDCtcSIz2X+fLjK7IsG28D4EUbI8DDME43hwrAI9S0dh3+P5aYpSE8LA47u7Sm4xAYUN7OXylJhjZWk1NvvKBZoFX1qpQHJP8cblQDB1Nuuobie3rbVvcn8B8mOfC0ZdZjb5VVCIbUHIP7o5vCNA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Blc4R4dE5qEtJGLR9xO4V7S+YVZlMm+x2KgJFu9YF11U+NHq7D12t0uRadWHoYMakk10HEsTho22SrNmnKtkmeCEnY+jv8zDFAc6M5iM804bbhwWWWhFeTrM1pl/LxscF2JDe4d/MbKU9lm8/STqGgoOnciZKClmuPqGA5wJEfSsdvr6/D7GOCxQLndlEZ6v+Esy/neoB53tzkD4QaY9aCsudOJ8GHF6JTxdd2WwVHle/tQZKjxu1cH3i1EOZ8I8/ik0lGpi9G7JfsUVqALkd0xDFmRPWCG32MXE5CI1bgnDV1ctm2OSoRLHxYNrzUjJSFXPh2mM4ZZBod7zoVmC4SDuAQdKm5LZ0RSe2m7cIOlRFox9oBR8+w+YTXfb3xLd3YCvM8+6r69GUMFpBhpwXMdb/vY+lZDZeNEQj6ioyu1uUoTXfkhDWQ00Fynvgwe9YPI9BDFABpTQ2AkJO6Yy38kDTieNsuiaqxs2WMU5XkBdH9PLsb6vemUldI4TL1gfJkJERLAfZiLE47rFL209PEAQrglg666nDopyvyKPPTfRp9zEC6uM6P5c0uURgTtcdDiT7jMn6pLSrP/Tzcf0qm1lxvivP2Xv2Ws6x6vY33w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48707184-5ba2-4543-c5b3-08de83b69cfd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5131.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 23:49:07.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0zKCze4Xn6Q23jMqeGknvr20EGZ48l9GQ7uTkJkzCuKLk3BFgHIW+oJryowrAcwut+SVD7pRXbpRn5yn/cpMPVM24tmKdWlh31lKvFKdIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_06,2026-03-16_06,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160197
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDE5NyBTYWx0ZWRfX75W0CJV+qLsF
 MN7Q1dK0haSqe3v+n4vVPEs4h13j9n5p56U7mmAfGTbHawD+08PEpZYzKDvdMNn+p74uBRboCX/
 M7nCkZj4ttjqlG21A6ZT7+LtU0jNbDcHlcu8g/t83zbMD+vzZQBtMounU81h1bnnDzbRaM5Kj9O
 OE2qDiW7KuHHKHfLX9OZ6+iXRbjkigRVvu4FgWS0lJP0huWCft4O/lJjnudR3Y5qmnIpHfcKY+H
 LGfZfB+TZFDp+3RbbxYiQj2NuqAPfKa7Jpp7E76LrdPDevOp1/eeLfmeJSRKHz5Zd8caZE0MP3E
 funW+zwB/itlCIvqvaohaRGVGMPMMGgQEsOh1QVVZQ2DGujb1mF67jBXIh+jaHPp6tdWgfa9znP
 VleYHHUk7MOnTmDeLCYOgWkjDBDotnSGdMgZPy0ZTgDGvUFFEA13aMyaL34BH7mj+FSmLz34qCF
 a0fYEa8/IT5JJf/9HDg==
X-Authority-Analysis: v=2.4 cv=AI0/m/Lt c=1 sm=1 tr=0 ts=69b896f7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=2wOkuT9POO4a-77qlAYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EKO3L8P96dFCG4EeoCVTl390dm76mWNh
X-Proofpoint-ORIG-GUID: EKO3L8P96dFCG4EeoCVTl390dm76mWNh



On 3/16/26 2:19 PM, Joseph Salisbury wrote:
> The file contains a spelling error in a source comment (resposne).
>
> Typos in comments reduce readability and make text searches less reliable
> for developers and maintainers.
>
> Replace 'resposne' with 'response' in the affected comment. This is a
> comment-only cleanup and does not change behavior.
>
> Fixes: 282432612aa7 ("cifs: SMB1 split: Move some SMB1 received PDU checking bits to smb1transport.c")
> Cc: stable@vger.kernel.org
> Signed-off-by: Joseph Salisbury <joseph.salisbury@oracle.com>
> ---
>   fs/smb/client/smb1transport.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
> index 38d6d5538b96..53abb29fe71b 100644
> --- a/fs/smb/client/smb1transport.c
> +++ b/fs/smb/client/smb1transport.c
> @@ -460,7 +460,7 @@ check_smb_hdr(struct smb_hdr *smb)
>   		return 0;
>   
>   	/*
> -	 * Windows NT server returns error resposne (e.g. STATUS_DELETE_PENDING
> +	 * Windows NT server returns error response (e.g. STATUS_DELETE_PENDING
>   	 * or STATUS_OBJECT_NAME_NOT_FOUND or ERRDOS/ERRbadfile or any other)
>   	 * for some TRANS2 requests without the RESPONSE flag set in header.
>   	 */
I inadvertently added Fixes: and Cc: stable tags.  If possible, please 
remove them as they are not appropriate for fixes to misspellings in 
code comments.  If it's not possible to remove them, I can send a v2.
