Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020082.outbound.protection.outlook.com [52.101.193.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCCB146A6B;
	Tue, 24 Sep 2024 21:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727214882; cv=fail; b=N238LNs/N6SBZRnvuoF0mgkBRkezbvEiNJgsffOvMeku3ifIAAzy6noUjczFAz/d1VQJ/3dVvGaW2/upTYyGxZS4EK5VchVuzkhF0o8nnTgBjz6XalbY28FMGSH7Xgr+GWTUMf56/x8s56xOE7aCabfebosGQqBreHFRzX+yG00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727214882; c=relaxed/simple;
	bh=5QljwJMt1awenO99sp/V6KNlhViDDN9dqaFW/i5yRXk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qbe6mhJjNQBpRHfFW0OYr/kSLEFgrrDG6Iujflc91THq8IYSkb1tDDkAA0kdar1jUrhNmrVLvMTnKgPuyLtZZmI5UfzXqD+DEKBB4EudKHpU8/otkyMPxAkmHo0u3QtZX+k4HJcH7aT+mmwM+UiejZDgfE6RNRiiiB5NFarxQGo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.193.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lF2bIuVKKMlAVGye990oFtICZyxdsXeNTnoMkEUG/nRCCoE7wR6ZjOeG+4AksVwHP7rrLDRJ24HL8kbcOdbbjCzD8OhRLppo9LrEWOmmjUgsCP3auhAinAC+owhNSXLt9byTbJO26FskPg1NKpnDcrwUopyrXoIQfRKygG0V7ISHjAHMXFHan5w7GPOScsyrdDq0Eu8ZTNzuqg7VXFLYA9efZc4c5QM+yPlWtRVwxgjoWFahkyET/t+APcN+W07jiMtDQki6uaaiItJ94n8paNKMooxdt+Zp3JZ7EaCRgT+LdMk8pdJDU9prG3dlinfqEqMRaUE9wzOTWpEd8nrpFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WG1bSbp3u6MxA9WTbPcIpNrRzQcF6oIwLf0EIg8rlA8=;
 b=mvMofi8c50cBolDC52BoQ2qLtfTYJiBsgWan9w8iSMG9joMJFlsDRI4A19kUxWR96a98qfZzFxPmcD91PVj58O2c29Kome4dfKAfN1phYTOwtamJWqM7SA75WbEYOVBdomcH6TMh9hdj4Rv02GBBW3t1EHdgGmJtTRsLZC2lfeOtUzlCBhvpzb/WlBomOoMyUXSKochYt4LAAHjhVAr75dGuc++UvYMoGlcHeWVFh75JoQDFOvNltHJD1d2MAh+z4iPo5u48g9XWEKIvnFkJKE45tZ4oX8uo6Mh8grMIB2e4ffBtNFrfMhrqQxqYHacpJEtghoc6FRrgqxeiPw/lhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4016.prod.exchangelabs.com (2603:10b6:805:aa::28) by
 SN4PR01MB7405.prod.exchangelabs.com (2603:10b6:806:1e8::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.25; Tue, 24 Sep 2024 21:54:38 +0000
Received: from SN6PR01MB4016.prod.exchangelabs.com
 ([fe80::1fcb:ca70:b1b0:8ce5]) by SN6PR01MB4016.prod.exchangelabs.com
 ([fe80::1fcb:ca70:b1b0:8ce5%6]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 21:54:38 +0000
Message-ID: <e3dfcd3e-5f1f-4477-ace3-a97913a947cc@talpey.com>
Date: Tue, 24 Sep 2024 17:54:36 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: Annotate struct copychunk_ioctl_req with
 __counted_by_le()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20240924102243.239811-2-thorsten.blum@linux.dev>
 <d6341fc4-1d9d-46af-b809-f30430b30455@talpey.com>
 <C22D945F-4C40-4C0E-8074-07747C944C99@linux.dev>
 <4B489C2C-5463-4776-8182-F878BAD1754A@linux.dev>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <4B489C2C-5463-4776-8182-F878BAD1754A@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0022.namprd16.prod.outlook.com
 (2603:10b6:208:134::35) To SN6PR01MB4016.prod.exchangelabs.com
 (2603:10b6:805:aa::28)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4016:EE_|SN4PR01MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: b2634ece-9a45-476c-796d-08dcdce37c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXNITkdtRi8xNTBxeEM5V296STh6ZGFsNDFBMTA3YmNpRFRYL0luUHlCUkJU?=
 =?utf-8?B?dTNxR21EYUF2dUZ1RVhRTzhKbFpnV1VxQ0Q1c2lURVJqMThENWNuWk5ydkdF?=
 =?utf-8?B?eHFvUmxuQkViSDRYSElBbXo0aVJNcmcvc3hCYWlrajJ0bmcrdUFUaDF3Wk5n?=
 =?utf-8?B?UHhTeGVTRVhWbkthcG82QnFkUVZaenF5MHFKaDcyS2o2R0RXREQzWk91a1pF?=
 =?utf-8?B?TVIyQXIwZ3ZZN25mRytrOFVsVnBjRjRqcG16VlBaR1FIeWI2SWQ1ZlRQY24v?=
 =?utf-8?B?dTR2Tng2MVh6bnBoUkp5Q0JQOE1YazBLNCtuKzZCWDlST1NDYVpWNHVnV0Yy?=
 =?utf-8?B?NXNWWVZTZEtMNVFzNVBocmJmTGFFeEduSS9ncVpmUTlJK2hZVGJOZzlpQkJ0?=
 =?utf-8?B?c0tpMHA5U1kyN0lJUTduYnpHa0Z3M3hDN3Y4SmlvQWd2d0hQTXdReVMrc0Rt?=
 =?utf-8?B?aEE3Y2xmK3ZoRVBJMXo1cnRsUUJVNjk3K044VWFzYm44TmhDR1A3V1NDL01q?=
 =?utf-8?B?em8wWFVVYXNCKzg1bnFUNzdVN0lid1FpQ2xacERIL3N6TGYydDZ1YWZJclRX?=
 =?utf-8?B?cU5nd3E0NDI5Z081K1Z4czhTNUs0OVhjUGJHSHAxbENZRHcxNDJ2Sm1IUGZk?=
 =?utf-8?B?SEdhZEpKazhKV3YxdERyelRXdFVLUFUrREFUSGd5Z1IydjNYYVhLQjN6MHBj?=
 =?utf-8?B?MCtIaFJnRS9zSnJtKzJPSWVMNmdmdDF0eklUUkd4UDhIMXorRTYyZWJ0c3E4?=
 =?utf-8?B?WVhWNkpHREtSWGxHSmdQMFI1WWZKdnkzVTBoTEE3d0s1VW8wNTZjb2ZWUDk4?=
 =?utf-8?B?ZlZXajk3T3hVR05lZVREMjc4eXdYREtYTUVOQjNVTHE0bUtNZkd3VnFVdnNm?=
 =?utf-8?B?MDFxeUNKdWFEbkhkN0kwNnNCd3Q0UzU0aG5YUkdDajhTL3R4cnVLbk9yRkpt?=
 =?utf-8?B?cEJIaThuei9RS2pqMFJVSjNCczBSV2tiZi90OCtFUVdWd08rTkErTFpQK0xy?=
 =?utf-8?B?ejJYKzdGZ0lEcCtnUXNDT2RnMStZVnhlMGlObHVNTUJIZkdyZUdTNjZiMjMx?=
 =?utf-8?B?SEFVWEdWYUZ0OG4yQzBQWHJJU2x0aDl3S3lZb2ZxRjhZMzNLbFEyR0ZvdXN3?=
 =?utf-8?B?WVBZSWtUaWNPWW9ZZ0tZdXI2ZE1tZitLaHNuL05SdGNTR25vbUNFcDlIZk84?=
 =?utf-8?B?YzV5MzZ4enl3aGdxbWJxRzhPaUZXTEJ6U1c2VVlvSXNPWS90a0c2bDhlZjZD?=
 =?utf-8?B?NnNHMDhyYlRRQ3dJcEhzQi9hOFBJMkt0RWJzQ2tLcnorMi8xQjJzaVZaYkRm?=
 =?utf-8?B?RnJrUjhXZ0NxMjNYZ1RPKzJJTjNUTXpJUXNVQnRYRzlNQTBoNEJuTGpPV1ZZ?=
 =?utf-8?B?cE0zT3dQbnR6RUNFblU2enBabnZ4VUoxVHhRdmRIbGFNQVRsOXVyODdXVHla?=
 =?utf-8?B?L2NjL09tNGNYRnV6Q0NwRkNpVjAvR0F5YlZ1eWhFdzdmdTNjMVB0RWlxQVpi?=
 =?utf-8?B?OUdlRGNGTzEydWRtbnRUaHUzVjJaVnIxU09ndzNpN1YzMU5MOGd5ZjRtZGNF?=
 =?utf-8?B?R0FDMVZJTVZ5N09SRFlVWXEzRnNtOFUzeDBkL3FpVkdBdEdiOUpnYW5qdWh2?=
 =?utf-8?B?R0owcldYOVMra1Y3dzBTSWtaQk1IWFJnbnppeU1GRVdKRGZsMkVqR3dHaTk1?=
 =?utf-8?B?RmxHZmlHdFZrcDVReW9PZkhaa0NSMmVzUEJMbGE4NFdTMVZDMllWTDB3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4016.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVpDTkEyaUxSUDY5THZXUHEwTGJhcHh2emEvMjk4NlhhanIyUzhSVS9CZkVS?=
 =?utf-8?B?N2hPeXEyQkMzWEYwVXRJRFdSYmNEYURCelVhY1Fid3VMM25yZzM1M3hKQ3V3?=
 =?utf-8?B?VUlZT1hwNno1RDR6d1lSV291YytiYy9yajV5dUhEOXFpanZBNDU2ZXZON0ta?=
 =?utf-8?B?UmoybCs5cDlsWmQrRldHYksrejQxcEFYdzQ4cGxYdC9WaVpvUDRBN2x5cmtM?=
 =?utf-8?B?cW5qeFVLUTF3aW9wcjhLWmhZRTZiS0dvZjZFS1NnVVppQTB3V2JLbGczcmUv?=
 =?utf-8?B?UGpZc3JBRjFka0JKWkVUSU1Ha3ZTKzBWcVI4MzAvQnJoaEFNWXZXWExFWlRt?=
 =?utf-8?B?UUZnZU11NVBqd296MTZYamZiWWo2MGZsNSt2UEZIQXphei85VTBETzJrTUdh?=
 =?utf-8?B?RS9OMlRIWkNRRHA3YVpDZlh5ejZLaGRaSTNZNUJPMFQySVRyMk5GUkpSMnJK?=
 =?utf-8?B?UE9XWmx6SjE4eEo4MUV5d016QUVhTUhCRnh6cFd0SUdzWGZpdVNKK2tNZTda?=
 =?utf-8?B?N1p6M3lIOTFRcHRsUFZ0SjRONXUrbHhxbmZITG5ycnIvZis5ZHk3T3IyMjBa?=
 =?utf-8?B?eUhjTGJXRHJ1WTVHUGNRQ0ZoYUs3RVBaUnU0RFZrWWtGL1VOMDlZKzN1YUlK?=
 =?utf-8?B?UnBFU3B2czIwckpwU05mZ09DbHdSQjhJbmdYTlpmS2xPYWI0TUhZak0rdjNI?=
 =?utf-8?B?aCtON2ZkV3E1dHpQNEdHbEoyaGdJcjdWOEpJdnRobnQ4a0ttbEh0RkFKdm1H?=
 =?utf-8?B?dGxZSHhFVzVlUEhFcSttNm9RYTFXZFdPV095T20yYzVKd1p4NU1GUnF2eSs0?=
 =?utf-8?B?NHF6dllBaE1QZjRUaFpyZFdCbFJCNGRuYVI4S0hOZkJvNCtsTzR2cUluRnIv?=
 =?utf-8?B?YlhqNzJjeUlpOE9MWi9zTEhldlN2eVdOSzQzSktnU3RudXJoQU9RcEtUS3RT?=
 =?utf-8?B?d2JtZFZaNjhySS9hN1J1RFFiTWVQaWx1ZzYyOVpFOWs4SVR2bytORGs1Q3Rt?=
 =?utf-8?B?dnRYdGowaklOaHFYV0sxTGFaMWF2cnNlQ3JFaXR4MFZVYWdYcVJwN05wY3Z6?=
 =?utf-8?B?WGlOYUg3UXFtVStvY0M5bzMrNGExR1dPYXFLamoxc1NuRHBsNERNMTRXOEZm?=
 =?utf-8?B?YkZIYVloWmZCUHJXL1Z4aFpHNkp3cGRMVUpzeXBubE9NYUlNQkY0dHg3THlh?=
 =?utf-8?B?ZnZWQ1hLSWdNTmFXaW1HY29aMDFnZGdNZVFJVGE1T0ZxNFBqYkJGdDA0ZWwy?=
 =?utf-8?B?dFN6V3JGMEk2amQvVEhxZEt1WnpnTFNESEVsbGRnR2VQbDBUdVJxS2V3NlZS?=
 =?utf-8?B?bUJaaGh5VGczK0FoSWM0T1REVEtZQVdVcWFIQnNOeFJXekhjcjFxcEdIVys3?=
 =?utf-8?B?LzlFc2N5cnZYVmZDa0ExaXdWbjQxVEswYTBzMmtGMEs4N2c0QnFQU3JFYU53?=
 =?utf-8?B?K20xelhQeWx4clFqbEsxYkhGcUtibTFPZDQ2NDZYMWIyYVhtWXYvbTFyczBD?=
 =?utf-8?B?K0VYSUI3aFdLbkxyVEY2T0krTjNMbEdwL1pHNHcrYVBWNkRaSTNwTzA4ZTVB?=
 =?utf-8?B?RThhMmVsRGJQMWloNjdNSXp2dmY0MTh6VEY1VjZEZ1RQTmNCdnhLU01CRDBX?=
 =?utf-8?B?Q0tpYnl1RVdZSGF3RitMemJGb1V2aGV4ZHZXZk5tcEFzTE9jZ2MyNTZMc3ZE?=
 =?utf-8?B?dTUrZkQ2UUlxd3pyak94akVyVkxxc2IvKzF2ZGZiMStraUVTUENHWkR2NEVa?=
 =?utf-8?B?a3NDWWlNM3FBc2FTZkt3ajJXWU5OV0RVYiszYjJJYXgySjMxVk1tUklyRWxC?=
 =?utf-8?B?eGtybDlBTmlIdndHNTB5R0ZHc0Y2Mlk2VGNwSTVXUnNMQlBBbFBtYlA5VkFs?=
 =?utf-8?B?Ry8xRlVGT3RLVTQ3NVl4QTdncFRMazQ0aFBoa0lYZXhERGNuZkhzUThtNk5Q?=
 =?utf-8?B?MlJnR3lPMVNkM3pUOFkzNFNoSmRCSmRHSk45U0VRaEgvL2lPN08yUVRKUlZh?=
 =?utf-8?B?U0VjbTlBc202VW5WQTRLb1FFa0tPdGhheHUrMmFadC9NRi9JOHdyeFE5ME5H?=
 =?utf-8?B?UnBPLysvRlRwc0xvSmRnd1JYbndVNVhDRkt3bEwwYW9SS29DSHJrUjdQNnhR?=
 =?utf-8?Q?734A=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2634ece-9a45-476c-796d-08dcdce37c2e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4016.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 21:54:38.0443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aT8fP8kJwoY8qM3FzQZDfwR2L4x+QSXTKAGsTuZCoqJuvvFOyY/fk0G1DF4MlfXM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7405

On 9/24/2024 4:56 PM, Thorsten Blum wrote:
> On 24. Sep 2024, at 21:33, Thorsten Blum <thorsten.blum@linux.dev> wrote:
>>> On 24. Sep 2024, at 20:05, Tom Talpey <tom@talpey.com> wrote:
>>> On 9/24/2024 6:22 AM, Thorsten Blum wrote:
>>>> Add the __counted_by_le compiler attribute to the flexible array member
>>>> Chunks to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
>>>> CONFIG_FORTIFY_SOURCE.
>>>> Read Chunks[0] after checking that ChunkCount is not 0.
>>>> Compile-tested only.
>>>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>>>> ---
>>>> fs/smb/server/smb2pdu.c | 2 +-
>>>> fs/smb/server/smb2pdu.h | 2 +-
>>>> 2 files changed, 2 insertions(+), 2 deletions(-)
>>>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>>>> index 461c4fc682ac..0670bdf3e167 100644
>>>> --- a/fs/smb/server/smb2pdu.c
>>>> +++ b/fs/smb/server/smb2pdu.c
>>>> @@ -7565,7 +7565,6 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>>>>   ci_rsp->TotalBytesWritten =
>>>>   cpu_to_le32(ksmbd_server_side_copy_max_total_size());
>>>> - chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
>>>>   chunk_count = le32_to_cpu(ci_req->ChunkCount);
>>>>   if (chunk_count == 0)
>>>>   goto out;
>>>> @@ -7579,6 +7578,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>>>>   return -EINVAL;
>>>>   }
>>>> + chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
>>>>   for (i = 0; i < chunk_count; i++) {
>>>>   if (le32_to_cpu(chunks[i].Length) == 0 ||
>>>>      le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
>>>> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
>>>> index 73aff20e22d0..f01121dbf358 100644
>>>> --- a/fs/smb/server/smb2pdu.h
>>>> +++ b/fs/smb/server/smb2pdu.h
>>>> @@ -194,7 +194,7 @@ struct copychunk_ioctl_req {
>>>>   __le64 ResumeKey[3];
>>>>   __le32 ChunkCount;
>>>>   __le32 Reserved;
>>>> - __u8 Chunks[]; /* array of srv_copychunk */
>>>> + __u8 Chunks[] __counted_by_le(ChunkCount); /* array of srv_copychunk */
>>>> } __packed;
>>>>
>>>
>>> This isn't correct. The u8 is just a raw buffer, copychunk structs are
>>> marshaled into it, and they're 24 bytes each.
>>
>> Hm, I see.
>>
>> How does this for-loop work then? It iterates over ci_req->ChunkCount
>> and expects a srv_copychunk at each ci_req->Chunks[i]?
>>
>> for (i = 0; i < chunk_count; i++) {
>> if (le32_to_cpu(chunks[i].Length) == 0 ||
>>      le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
>> break;
>> total_size_written += le32_to_cpu(chunks[i].Length);
>> }
> 
> Never mind, I just realized that the pointer arithmetic takes the array
> offset into account.
> 
> A srv_copychunk takes up 24 bytes and therefore 24 __u8[] slots. The
> __counted_by annotation is essentially off by a factor of 24.

Right, and the fix is probably obvious, but the copychunk code has
yielded a few surprises in the past, so I'd really like to see any
change tested... Maybe Steve has a ready-to-go section in his set.

Tom.
