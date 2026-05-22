Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7C934CFAB;
	Fri, 22 May 2026 20:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779481435; cv=fail; b=ZqUkcqq2L+4OKvB0jdK2w14vJHny+ARTKqMuy0M/lPn/ucShyTSjY1GTAAMoUIh34zC+/McpFEPeVXx5bhfl43GiMJidnnct5AC3e9PXCRXVS/hwjtUbAJoixA+UB8FY3tP8DCYk16Z8GIQd82fCQWLLgIt/5ZHXHKbhU0kUV6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779481435; c=relaxed/simple;
	bh=3B2R85IuKmg1+hi0V0yMNqz6PwIMFpbPdquyJOtVACU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ujFu3zeKPD98JXEAfqgKe3PekOXxwdKm5Pc6PqHZh2fsmqdbTJBoSO/pycp0P2vcK6MsTdnsBHx/xBoEbC2C4w/vu/4hx24ww1Rsg6TIaL556cjHks71yYiiBD89Q4r0OWl3PZNnX6yqMNc18NifnVyp8OnE/ZEKSTKSkRx+c+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UFFZ4vGi; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=beEFEdw4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UFFZ4vGi";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="beEFEdw4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MD7Qa71808735;
	Fri, 22 May 2026 20:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vW5EnLK0CDM8MyyNM/abwOp9FtRoNlrxzp+utCGw4sk=; b=
	UFFZ4vGi2oEB2Gzy0RS+pMB8m0x7sH0p9JRTP0PlmXSAHoy0C/xwICBZ9eDRf6x+
	i7Ny6Ry03NVrly5lfTk6aantGqwEhCMaH3cMu4A866XLxIjjLpLW9iZyPGzkEO2C
	Em1YjABp+UTod1Y1VzETRuqUcVXJe0iEG1F7M7veqMPMI0fW6fWjvensnoQLxgQq
	8n28dUZTrajWmLow+nNbfAE4Zl8AqkfKz3YcrYTv5lWcnrMXaSe6n2xhhGEXZ9HK
	Artj1/IIaiGePSqiL51LmVZ7Q4B7lxWa3nfMq7Ylqa18vjB8f/aleIkeuFjrC8v4
	e42TG1TBRcQoSUjS0Uqy8w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h1t3rs3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 20:23:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64MKEh34018582;
	Fri, 22 May 2026 20:23:26 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1fcsy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 20:23:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XV8XSVxKfdGEme7WaecYCIbXiGL+mLMU5IonoA303S+setK/zeo6BGP1wYd99RxSnST23b5zfMuTjZGa3iKfp8MFL5pxLLZrai+k97CBvGSKfAL74oGzEOmgdXY+6JbN4vSZeKsjoBkp7jIWx2ns05DUX6KtwiFuyrC5keN+3riqBTvvE/8HpWprJUQeKMysqx3cyw28Bbkotk/3qwsXWUoki4XLH/jaSX1zjEhfS6Is0T2I8bAVTelQnrcIHo2s+W8LaVJ7WBFt9ojJcZfREbPYz534/1o8f0uKpARav3rixUjD5VUFs9530bRz6iP63TcHPuS/N/IHdEC6vJD8xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vW5EnLK0CDM8MyyNM/abwOp9FtRoNlrxzp+utCGw4sk=;
 b=anRL6jRATJ+/x83b/lLG5FELit19kAY5h4KvP5ze7LGy/PY32gA908b4gyQ7yskZ9odYirDuCx+A/21ykNbZI+zwIdCmSC1bLekZqfgZWYjwJpA0FQqwVKLkYsh+ZhtcRpVvCsOzp3vHsQsGkoBil+3jfhT2jDRHulKHgNgcXEP02zyKlsUGC/aGfSaA3ZyfXKcTiZ0TgRUPCQR944JQ4zzpp3+mf5LnJd5VnnPPDXGOykLeGhHQZGmS3swVRl0gYUFxW5CAlDXy23/xHOIVSIdKZFRPSTmtr/rLN74+qQ8SJWXdAav8rFyAIB3mHSh5UXzkFOEQIJ2u4Elg98FITw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vW5EnLK0CDM8MyyNM/abwOp9FtRoNlrxzp+utCGw4sk=;
 b=beEFEdw4o9yFvfMOUhQSGy2optWHoglIdwShNsHRcc8gBIvV8YVfmVfgiqS+z6J2HvxX69Te7382P0XfBp3BdKQNh8+IiV7sz7fDnQpTXihVrhM/7hbQMmghb/znjl7KAaSv+W1CrD7XlVCr7EajshUelGHjYxe2HkMzRz+B+/w=
Received: from DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19)
 by DS4PPFFE8543B68.namprd10.prod.outlook.com (2603:10b6:f:fc00::d5b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Fri, 22 May
 2026 20:23:22 +0000
Received: from DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a]) by DS3PR10MB997700.namprd10.prod.outlook.com
 ([fe80::4c1c:3bb:c4c9:8e7a%7]) with mapi id 15.21.0048.016; Fri, 22 May 2026
 20:23:22 +0000
Message-ID: <7ed573be-1df9-43ee-bfef-4499af0767b4@oracle.com>
Date: Sat, 23 May 2026 01:53:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 634/666] netfs: fix error handling in
 netfs_extract_user_iter()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Xiaoli Feng <xifeng@redhat.com>,
        "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
        David Howells <dhowells@redhat.com>, netfs@lists.linux.dev,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>
References: <20260520162111.222830634@linuxfoundation.org>
 <20260520162125.016902019@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20260520162125.016902019@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0091.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::31) To DS3PR10MB997700.namprd10.prod.outlook.com
 (2603:10b6:8:347::19)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR10MB997700:EE_|DS4PPFFE8543B68:EE_
X-MS-Office365-Filtering-Correlation-Id: f1d0071f-5f3d-4310-19cf-08deb83ff873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|4143699003|5023799004|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LEiXEkW8Wu4rTvUTBLX+VlWoWka4ILSnYte1UAlW3B3X6dQmA6sxF3hj1YYcOqQd638z8jel4juSPimKyqSj8E93Y54N80gJOkC5DtmnV7KJ7So4PsQNs03Dq7pR4K6Ufe2Xx0LshTKyrFKN9fpxWFM5S5NOBkb5yuiOWHOVAtusc4QpIuy7a7+L6DzYDdo6aBWioPBNQywOImJ+vggY95uOdF2vR071yfbiO7Ai+caN4tFrdNOKOvFnggfi35LdX4eMLr3HHr8CxFbPjzW0mkkRYaBUIsgKT+2nIsn4QCD9o08H+DAN3YMwnArTxO2nZZr0NY14lvZ1ctAhs8F/guRXQ999SdUKlp+XaebQLThQSqC7X+a+KqomNYTAuZEsuNHUwTX041KUEACRG9p5xTwPYm9nE6GSlhFw24DLPs/YEbt2LwnyJyFEi78emP46begTa2tgDdPA2UmjKdKMjaHPGkglDF2y7h2Ke+muT3UruhzTJRWKsiJ701CD4DfebfVgJ0nDbU17ad2KjR2ePSXQP74deuCUcW9QddJk11olWBgbqxN2v6oYYiNC9WcUfDWbP1VMe2bmoO8t11PaxpbqPM9zfkTGitQp5FkfuR84BmMUg1GInPN5jzz51Fp3h0/1JW0IngyvvVKmYDNt3g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR10MB997700.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(4143699003)(5023799004)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUJMMDNTbHZ2SDRMaURYT2lNc2VINmhKNnBGR0h1RiswUHdBRm5qRG55NTBD?=
 =?utf-8?B?aGhicG1iRDA2bFlibUJlZ3pjVDBBaDV0N25ISVZVWVpCSWJOUVh2TjVIakI1?=
 =?utf-8?B?NUROelNPN3AyOWFNQXF2RldtTEtGWXVLOXF1REk2b2dNM2dsY2RqLy9McGEv?=
 =?utf-8?B?SXpCZHBBNUg0K1NmekxtYzZKa0dQb1k5Mkg2L0xOSkFOUTNKWDE1eFNaNkNS?=
 =?utf-8?B?MllyQ295a2NBYkdmakhjUzlVZkhhdGZaOEJWSENQc0swSkIzMUt1eFhYcXlu?=
 =?utf-8?B?VzQ5aWU4TURNMlJGNU9SM0ttWk0xWUZScEVJK3Zrd3ZOWnAvMGlGRndYV25C?=
 =?utf-8?B?NGpRd0pUeW9lQWUyQlNDbHIvMTJFdWdEQmFoWkVTU2ZUY3YxQnNLbGY3Y0ZS?=
 =?utf-8?B?bjl1bURoRUFGZFJkUXZlNFNBbjJvZnVYanNKSjBGckVtNU9mTGNzbmVRZTQ0?=
 =?utf-8?B?cFFQMHNlVVU1V1l5eXdIZlhNVGdlNEE3UXAxRjJuRFVRSWFtWFBSWC9KdUZu?=
 =?utf-8?B?VnRuWGJBdEZpMXdvcUFlQWhKVlQySlQxQ2xtc0p3VXhXY1JvRXBZOW9OUmtq?=
 =?utf-8?B?TTNzTUdOZjBwTVpGcDN1M1BoTHpnRWhPUFcvTEF3Nmoza25TMitWdS9GWlFh?=
 =?utf-8?B?dFh1VzZrdmI5aHhiSnpEWUZqMHpGOW13RXVyZ3dielpma0NaNHdWVCtsU0lB?=
 =?utf-8?B?cmRWSE1PZWFsZ1Q5VkJ3TDlLSkxwTVkybWlBVDMzSlk2WkRjRUhya294WXRj?=
 =?utf-8?B?cG1iQUdMUlVJOWhra3hCWTZNWmpLRHB4RUZCZzBUQWJLa2QwN21jYzRoWXp2?=
 =?utf-8?B?ZVQ4Q1ovTGhVbnJLYWZFSzJQL0FFYUF5Nnl1VzRyRDlNMCtZVTlOd2MrM05x?=
 =?utf-8?B?UXg2bHlocU1sWGFqZ1luV1o5aGxVdDRlYVAxYTVMMUY1RDhHa2ZlZ0tUME9q?=
 =?utf-8?B?SEtWbCtpY3ppaHlIYU9sV3ZnVE0rZTdtUDRWSExiUnpOZUZ1L1AzbytsUTZN?=
 =?utf-8?B?OXZvcnBOeFVHcnNkc2JuNDJPUmxWdmIwczZUY0puODVaNlVLeDhBa05FSGRF?=
 =?utf-8?B?ZzdtUVhwR0hGMHZJdDNSS1poYjJOSVZnY29WemQ3T2c1UDBCaWppYlFKend6?=
 =?utf-8?B?Q0ZUOTdPSFNJSy9nR3Y0b3o4aGhyWEJ1Z1c3RHpDZUROdHg5eVA1TTJqK204?=
 =?utf-8?B?OUtMcWpzazZXNVZNNkZDaW5lTVN2UFRqZnRpcHZDRkJYdTdXeUNZdjA2cVN0?=
 =?utf-8?B?ZE9mUm1OeUo3eHZmRlYyelI4alU1dERkZHBETXdqd1k1T0s3YmFUTlpZMERD?=
 =?utf-8?B?OGllaXN3SHFEWVlZOHdTVUpMREpjMzd0SWJoSk9FajBWY0lzLzBRUDBGMkpO?=
 =?utf-8?B?N1F2NmRob2lDdldlay9xVmVhWTVqUzAwaDlkdEt1Snp1TWl2TlAzeHRzRjJZ?=
 =?utf-8?B?UWhYMGM0RjJTT0w5UnFWSDJDb0tWaGRvQi9tbHFiemExR0pCeDlhWmx1T2N1?=
 =?utf-8?B?WDBaS3VqbUdOMFNkU0V4WnJpQXUrNW1RdGxTUEF6OUowV205N2dFVWlXUC9u?=
 =?utf-8?B?eXluM1BEc2JQSnRCYXRnSlA3Yjc5alI2K3JGVHdLVVNESWdDZnp3OWhyVVk3?=
 =?utf-8?B?QzRqRWJhRmFLY2FtSzdQbE92SUxxTUEyTkVpaXlPeEJtS0pBU0xLWFhHRTZq?=
 =?utf-8?B?bHNVMGZIWFlWUnEyUE50VHRWam1hdGtxZDF3VUl1SFg3VlFGZUJuQ3cvM1Bw?=
 =?utf-8?B?U3hmNHRLQ1ltSmZNOWRFU3U4R1hIR21kbHFLOG1vaGlxMkF6b0I5azRFNUZv?=
 =?utf-8?B?MlF5U3NSZ25USmlnWE9hM1NORW9kWFZVMFk0WGRJOE5za0NySnhQS1hDUjJE?=
 =?utf-8?B?b3ZIOGpCNVZaYnI0M1B3dFY0Q3kyMVQ4YWJnM2d3TVRlNFdYVFlYL1puaWpS?=
 =?utf-8?B?TFB3dTExamNqaERDeDlHMi9IZDJKOGpMd0VuVXB6V2pLY0RIbWp4TmJ0bzlt?=
 =?utf-8?B?MHpYb0t1c3RndGF4QXlZU3BvNFVoc2hpRnFmMG1ONnM4TzBOQmk4b2NMWHE0?=
 =?utf-8?B?SDBPb2RoMnJBZFBKaXVCK0srZlRleGVrVjBhUjhBeHdMTHVWREd4enF5R1o5?=
 =?utf-8?B?UzN3SVYvNXExazJ1V21USEw4QWJNektSY0ZFbWY4VE5FczlneGdEei9jNm5W?=
 =?utf-8?B?Rm5HanNnOGVpc3R6Q3kwd3pjaVNSNy9WUjV0ZlRhUko3SWhvdjZqWnlOdDYx?=
 =?utf-8?B?SDgzbUhWK0VoK2lncU8rL0FKOXVSZWJXd01WTDJyaDZBWnAwT0pFZXlwTHJF?=
 =?utf-8?B?ek1TR21zZ3RkR3l2SERPbmluVWhsVEp5TnFOT25sdWZKOXBiQ1R0MEN0clVS?=
 =?utf-8?Q?RnSdfLFCzv6RXO2ZO71bTOIcwLGErUV4VyI1v?=
X-Exchange-RoutingPolicyChecked:
	d/efc80us4yey490STJYY4D16pFfSm2Ebsz9sR6A3B5Ym4ulJQWOau6QykHQrmZpcI1ZuU+2u697j21YLU434Kxau9vOS1u18Okd/0NOLDRgRgHSbCC07SFDz7ZyZwdIw70F8iMeAJrmTt3UpXM/OLKdnvwMIxhU6MDnj4JngGccOBh5GgUv4IEv+ihE6j6E5+TNXcjuWxkzDBB0dRiyzTS8R17ZeAWaTJnshByk6wNMQLGGTEq0J2GUkZ+sBJbwSg42trcSN7iE2IrV1F26U95lfo/szyVwoGas6NB4/V0SGFFFNIBjdTe/ZuBLgASzylqsUOHmc2FpOxmEwx6PHg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hh3EtgHtq4IU8YMveWUiwYrUIgLJQXn83bazJHm27QIFptigakFY+OPFymkBCbYM4t08d5Ob7TqBXumH3KPcIC1XtBkR6olldV/ghgJmn2J0fgiO+B1oIjQjN+xh2wOtWcKKcb2LPSDo9I9jrehWmJiU3Jumx1g0GmV/9saV1+td+4w/aILZOjYIQmD9KQfHDug8axLjQRkRVq+JH4M5uIV5TOMrKp7MsnNIfou2TYLUREd71eiCsHkP55mA4n3j89GTpptmRcmgIJ78oHK65nqryRmrlfkcW2awQUuIMvYMZfaD54YzGRs88NdeDuKcq9nDZCoJEvVXCfAmGJDXJINtm8qLPOGqosGe3FJmMe8jnZETlRDcp/kSGA+6PDhHa5ARra9pCCU0hDUxC/0y8l8xl+P4AF163MNr1XKCoOWyoayoSlbGLI/L8f6pn20gbNQZC8y5uzk8m9VLd8Qom6xFJRdva0zlTdZ0GXe0CafKJkrHBXYyuDhA3H9P5QrBWMWpXn0YzNiF2fyL9xKtBGfwPqmuHpO2qgh4eOpCsass/ZCiXqSQluPWMxQdkqqjzK4lCuiHQfsibzlYQUtlArX0BaCflulmbXVFVSLeqeA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d0071f-5f3d-4310-19cf-08deb83ff873
X-MS-Exchange-CrossTenant-AuthSource: DS3PR10MB997700.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2026 20:23:22.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWiTgUWHUYko+fjElL+U2X96qDnUfhz47IbeKTZw4+5Fr2PCj6c9WFCWb+yp3nzc3RhlqQE0r2PD6KiqahAT+AV4TRbH8sdcL/ijx+dxfhQvts7zMGXX+4WAQuu5un9r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFFE8543B68
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_05,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605220202
X-Proofpoint-GUID: rX7zauaEEzFDHaRyDp9pgXuMXU9B_MaP
X-Authority-Analysis: v=2.4 cv=d9jFDxjE c=1 sm=1 tr=0 ts=6a10bb3f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=bC-a23v3AAAA:8
 a=20KFwNOVAAAA:8 a=tAGQbYHnAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8
 a=k5tvX0q1aSgfgFQQrR4A:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
 a=lXWXidlrYx5KKt6n-8sY:22 a=Yupwre4RP9_Eg_Bd0iYG:22
X-Proofpoint-ORIG-GUID: rX7zauaEEzFDHaRyDp9pgXuMXU9B_MaP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDIwMiBTYWx0ZWRfX3uBCCKFVsxJa
 KoQyWKuIJ4tG/7DSEGdCUZ4w8hwv4RO0+N5Xn6idzWVX/pTDPl3MsXbOR1jNdmZq1ABXBKKdqCS
 IayoPBCSIQq/Q6mvi+Bsc3I/8dWZXs/Aw9Y8psgwqj8VRAjxf0zQxNH0yAPVXR2tyhl1yeSJ6UC
 FDObEFgNtixVR9qFLiI5CCqUUSFZJaoVXyW19XGpZLMbLnrCLiyFlta4VDbdJaPVMqrgNR5/FIz
 bKZpgMdLUMRbrmI0MOtpErJPXh5oPdS+rRTwbwWL8ELdi2Lr/R43zJZuBbGg80NmgSkqwwcgD0/
 ZVCT1SIhw0PbDVIN4aQD8HqXy7lTH0CMSq7iN7xCe7b2006fi0m0P/f1sGrF5u+MfoV0skLzexe
 llqlYeu7xRlqpwERFat6b8ZUC17DiZDiESgw7Y/julGORQiDHnVDznGKe9KHlP9ojlOM8VGUf8s
 y0Crm+OU36mvpMhx37A==

Hi Greg/Sasha,

On 20/05/26 21:54, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Paulo Alcantara <pc@manguebit.org>
> 
> commit 0aad5704c6b4d14007d4eab15883e8524e4310f4 upstream.
> 
> In netfs_extract_user_iter(), if iov_iter_extract_pages() failed to
> extract user pages, bail out on -ENOMEM, otherwise return the error
> code only if @npages == 0, allowing short DIO reads and writes to be
> issued.
> 
> This fixes mmapstress02 from LTP tests against CIFS.
> 
> Fixes: 85dd2c8ff368 ("netfs: Add a function to extract a UBUF or IOVEC into a BVEC iterator")
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Link: https://patch.msgid.link/20260512123404.719402-10-dhowells@redhat.com
> Cc: netfs@lists.linux.dev
> Cc: stable@vger.kernel.org
> Cc: linux-cifs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/netfs/iterator.c |   13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> --- a/fs/netfs/iterator.c
> +++ b/fs/netfs/iterator.c
> @@ -22,7 +22,7 @@
>    *
>    * Extract the page fragments from the given amount of the source iterator and
>    * build up a second iterator that refers to all of those bits.  This allows
> - * the original iterator to disposed of.
> + * the original iterator to be disposed of.
>    *
>    * @extraction_flags can have ITER_ALLOW_P2PDMA set to request peer-to-peer DMA be
>    * allowed on the pages extracted.
> @@ -67,8 +67,8 @@ ssize_t netfs_extract_user_iter(struct i
>   		ret = iov_iter_extract_pages(orig, &pages, count,
>   					     max_pages - npages, extraction_flags,
>   					     &offset);
> -		if (ret < 0) {
> -			pr_err("Couldn't get user pages (rc=%zd)\n", ret);
> +		if (unlikely(ret <= 0)) {
> +			ret = ret ?: -EIO;
>   			break;
>   		}
>   
> @@ -97,6 +97,13 @@ ssize_t netfs_extract_user_iter(struct i
>   		npages += cur_npages;
>   	}
>   
> +	if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
> +		for (i = 0; i < npages; i++)
> +			unpin_user_page(bv[i].bv_page);
> +		kvfree(bv);
> +		return ret;
> +	}
> +

I have run an AI assisted backport review and it spotted an issue: I
have taken a look and the issues goes like:

Upstream has:



ssize_t ret = 0;

...
if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
         for (i = 0; i < npages; i++)
                 unpin_user_page(bv[i].bv_page);
         kvfree(bv);
         return ret;
}

6.12.y has:

ssize_t ret;

...
if (ret < 0 && (ret == -ENOMEM || npages == 0)) {
         for (i = 0; i < npages; i++)
                 unpin_user_page(bv[i].bv_page);
         kvfree(bv);
         return ret;
}

I think 6.12.y misses commit: 7e3d8db899d5 ("netfs: Fix potential 
uninitialised var in netfs_extract_user_iter()") so backport might not 
be complete, thoughts ?

thanks,
Harshit


>   	iov_iter_bvec(new, orig->data_source, bv, npages, orig_len - count);
>   	return npages;
>   }
> 
> 
> 

