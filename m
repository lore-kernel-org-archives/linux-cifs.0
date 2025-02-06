Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2135.outbound.protection.outlook.com [40.107.223.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1772D235344;
	Thu,  6 Feb 2025 16:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738859563; cv=fail; b=h8pNLo37G+nfdtJ4wyENOgIi4vlg+YYDYJSnhBkFek2OGXqMhiMM+iRFO57QKMxZCs2gFWpxh5V1PogmekBKdxTog4+iEUDHMr7VlCZ9QWpeu4Wx4U4Mit3g4yaKgRKIDhIv4RIN+lLTVzyoWJRqc9frGIRD5OPZ77EsSrYmu4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738859563; c=relaxed/simple;
	bh=l3NGm98dgtZtXOj0/Pij10Ww6JjvKp2nPsCbBQ7ebCM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sOkQv08NmOGrFVDXszlDzk3uSZmbZsTPKTDB/hOuYcfpUfAZZA/DFLd9jDzUyOIunrFckm98BSyC0VUeHDunbF7RbtH0zYwiv396oI19ZP62Etvovq8KwPzrMkGu/hH/HbSI38mTDL6vOq2HBHyhNoebYTjU1DLspqwSjoliACk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.223.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SRTpSOxcSl+5gc3grogOBWIAfgZ11DxcNr9cdA+mJBhO+fDwF6ko9lqM/8L7dwnZ0N1Alsw7rLFlezyMpMMj3Mza8DqmPxa01E9kWelzeVHdVzShVhOpIvCxujLh7rHJ7l+lyczGAZ32tuFkvFxTMkL/hZRN/jvEHNeOj6P0G1QXV4s6lQmGG3kO3VpcsM78Sw6CCgodz2CbLqwENwOHGuJ9AJ4xdD8HwVXtAbiLRqvBuBSS55isLlmGp+3XhmfyaessCgSdVDEJ94I0K9oDh01rBHEJfj67JQ7gp0V8kwgozZ/dj66myef0GhUsD+MmPT508ntqHxbLdsY+GT2l/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SqWi4QK8QhX3skksSosg+rNTnbzCqMfR20nMJsmZjw=;
 b=OM3Cn4BYfVd1/x5czqkdwqNpTVgfC7S1vCJAmeuuRlIoetGAhIq9375584c9jnySmdD4ro2ChhWY2/YX2FjuA4UhdpU8RYK6l1tIA7ripSQDYyYH+pyyS5VD9rPfOYFHns0/itbWPbM9v+mfAIsPvgh3b31Ne5cfVgWbBOpR0WOPD4MonXLA3cIZKSdpYOyT62xjsNgEwjoSHzj6rOg4nz5dBiyrD1hMoDHC6pLh1RsC2YakVsypukamspXipsH89RvqEciMsexd7/d+zJVGZyKFMXTf4Ds75IAbOr5DB6f8zI07HAJlHWcYDWKtGNFvyPrh67ya7NZj7FdSTu9x+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 SJ0PR01MB6447.prod.exchangelabs.com (2603:10b6:a03:299::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.6; Thu, 6 Feb 2025 16:32:37 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%6]) with mapi id 15.20.8445.005; Thu, 6 Feb 2025
 16:32:37 +0000
Message-ID: <ae198c3e-42e3-486f-92b6-705bde953b4d@talpey.com>
Date: Thu, 6 Feb 2025 08:32:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: make lease state changes compliant with
 the protocol spec
To: meetakshisetiyaoss@gmail.com, sfrench@samba.org, pc@manguebit.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, nspmangalore@gmail.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 samba-technical@lists.samba.org, bharathsm.hsk@gmail.com,
 bharathsm@microsoft.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>, stable@vger.kernel.org
References: <20250206065101.339850-1-meetakshisetiyaoss@gmail.com>
 <20250206065101.339850-2-meetakshisetiyaoss@gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20250206065101.339850-2-meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0337.namprd03.prod.outlook.com
 (2603:10b6:303:dc::12) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|SJ0PR01MB6447:EE_
X-MS-Office365-Filtering-Correlation-Id: f26df627-888e-41f6-94c0-08dd46cbde1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXMrMGxjdjlIVkFUZlFGd2xvOGZiaEx3YXNoaVNGZGU3VjBzL2E0c25HTGdh?=
 =?utf-8?B?Y3pwc09YMHlCNENUNk9CR1A2ZE8rZUFtMWw0UHQxb2VjVklicDNrZFhtY3lp?=
 =?utf-8?B?b1BqTWJRS0haY3QrWDZqV3JRYlRtN2dhTEJBcE9TOXVkSXp3Q0lna0RSdmt6?=
 =?utf-8?B?QW42eGNKc0NTZkJhcUtDQTdUdVkwcnYvTXo4WjBZUUZsdnN3Qm5KeVJmcm9Y?=
 =?utf-8?B?bWNWeVM3MFVkMzZoUWc1VEh4QW4vUDN0V2xpVWdWWHVMYjNKSHZoOTRVVVRy?=
 =?utf-8?B?VUE4azByVXdKeDFhU2Q3UWFuajFCbDl5QUJ2b25KRkJEVnMvbnAwVmZJM1JO?=
 =?utf-8?B?RXh1TFJEb2RVWlJYbldFU3AzWlZ4bHRDaGlyOHUrNEpPcVFheXBXMHpWSTkz?=
 =?utf-8?B?SnVSck9sK2t5aER3MDIxWlRqMzlDYXhnQkQ3bUFlYStsN2d1VUVRTFBkSm8y?=
 =?utf-8?B?Vk9kQzJqRGU4WjlxY2ZONS81d1AzZmxEd1BJRWw0ZnZ1VUNjWVNHaUlTeE9Y?=
 =?utf-8?B?YjkwVmpwL21FMTBKNnVoV3dnZXVraWovSVNiNTg0cWc3WXN5QTZFNlI5VGdw?=
 =?utf-8?B?c1BMblhMRGhVb0ZraTVOYnJwSE5rbVllYk0yOHhXbDhTYXlSNnNWL3VyYXZp?=
 =?utf-8?B?czkyVXZwcmZKYTA1akVhTG4vZG1pMlptemlUc25YYnh2R053elg4S0MyeWV3?=
 =?utf-8?B?QXNNZ2h4LzhPSTdQWWsra280aGtFYjl1cGx1Q2pWR3NqUjVXMklaSmwySjhY?=
 =?utf-8?B?UnZtT2s3b3Rkc0FZMFlXbi91UEdYTXpWaVVBRXdBZUFTSjQvNkcydHo4WGFy?=
 =?utf-8?B?dlcrYXBFaG1PV0dHZGtnSTJHajRpNE1jbkpsUUgxd1BiMU1EQTNKb2hnemxF?=
 =?utf-8?B?dlVjbmVLT2UzbTM2b0dlMGtZWWg1RWd1VmpxeERRakdmS21OMHo1blkrUjFv?=
 =?utf-8?B?S0FGZUtqMmJ2M3JaNy8rbmJXUmFGNnZPT3c5cjlPU1VvVGdMYU4xMzV6ZERp?=
 =?utf-8?B?SmRkY2VRSmJpMUl1SVpwbVJGbjdWaWdISXVUSzJWUGpGVG55ekc5b25Edjdr?=
 =?utf-8?B?dENYYUpiSUFidy9mSWxmcnFjeVZkSjNWTjgyMjRLN3BHTlI4ZU5TR1lCd2R0?=
 =?utf-8?B?cE5yUUN1cTB3SmZrWFNCOTBXaVZHSlZJbllpTGlKMXBNM3RRNmNTNFA0TEhV?=
 =?utf-8?B?VDJudjBLOVBNY3hYTFNaL3pEeFdrdmdYM0tjbmZXQXNmK1c4QUdDZDRRQUNu?=
 =?utf-8?B?R1JJTk5SaFlpTGRhNzRlWG1zbU52SFFmeEh2OHJ6Q3M5dFhMbFF5cGVSZytF?=
 =?utf-8?B?Z2xucWMrK3J2SnFOSmt0U2FGM1laUExQdnQvaUYrTzBUMDlsZHhZdFpCN3ky?=
 =?utf-8?B?NHArMWlsM1pLN1ZvdDRSQ2xSdSs1ZHFLdW8zNWNBd0VDbnh5RjJZdmFseXBn?=
 =?utf-8?B?TlhvSjVwSVEzQ1RBcjlOeHN5d1JFYThCM1lzOFRlS2xrZnRuTkMzR0hkcVJC?=
 =?utf-8?B?SXp6M3EyTUloQXN4OVBNOHNjUnlMdnJQYnozQUtGUndTTGJwZ2RUOVc1OHZk?=
 =?utf-8?B?N2JEM09uSUkxWFg2elVjTU54VzQzdkhHSXYwSWQxM1pWSzJjbE13R2szclAv?=
 =?utf-8?B?YlFUZWg0VVlWSG4vRWgyYlBvNjkyQWJhRVp1MXA3dlRFZmlxRmJFa2RXTWR1?=
 =?utf-8?B?N1doSjNpSVJGbVFINWU2cENxcG5xTmxMTXkraGJYMCtTSHA5c0J6OGJnU25I?=
 =?utf-8?B?RXo5Zk5KV0lEdmpxUTNNOE1ORG5pa2s3UkZ5aFZpdTVrdTFkT3ZOZHZuWUY5?=
 =?utf-8?B?anZyUm8xZ2oyVkFjWmplYXA1aWg2WmR0VHBMYWxOVGNBQmQ1cGwzQTk1b1du?=
 =?utf-8?B?WEpWMUdUVHM3dUJFOFdNTjYxODJ2WVZXa2pLb05IQUo4SWhzU0s4ZGttdC9C?=
 =?utf-8?Q?5My/RimW7UY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S1YyTno2aC9SNHRmeGxqbitrRmw5R1dqWU4ydWxkOFBleXgxbXNnZmJ0UllY?=
 =?utf-8?B?bll3WXZvd0hENnU1OVlYaWF4N3prSktybEswRi82SXFhTG9BZnowZnhHMUZ1?=
 =?utf-8?B?R28vQXZwblE4SVFnZHBrUEJTL0pwV3pZZ1pzQW5WMklPYUZvY1B5YkdXbDJr?=
 =?utf-8?B?V3NCT29NTmtJSFdWRWtDSXFMQXVWZDJaRncxanExVlVMYThpa2FjNmIwTEdy?=
 =?utf-8?B?L2k2Q0tOS0NjUzR0OWowNjlEb1R6azYzbllicWxxYTBaQmhZVGp4Sk91NmNL?=
 =?utf-8?B?ei9BSXFwL2thWDB6OXRVTGNxOVlFOTVYV0ZDYk9LMXpia29PTEZZd1FncFEw?=
 =?utf-8?B?ck9YdldQUHErWStZS3NkdDlZWUhEUGI5R2VYVW9CQ3IrOGpqTjBiaHFFd2kr?=
 =?utf-8?B?cndNT0EvWXJqZnQ2YSsvbzYzU2ZkZWl0Y2ZnSndmZWxtZzI4RE91K2hWZzdr?=
 =?utf-8?B?eG5lMG8wSk40TTFjM1J1NGhPV3ljcWFteXIrcGNrV2JqY3pDWTVGcmFkYVRJ?=
 =?utf-8?B?THlDMVVXUDdsY0JYb3hKSGttb0djazlkUUkvR2pXTkpGTTBJRnJDMDBCNFov?=
 =?utf-8?B?MmFuY1YvOE1NcnV4cWhQSW5QQUhHdGdiZU9KTnR2TFlMMVR4eTR1YWx4Y3Jp?=
 =?utf-8?B?d1BXb0xYN3lidVFQRlNxeEIzQ0xSUFBadlVtZlNIajFUbGdRQlN5K24vb0px?=
 =?utf-8?B?NjI4bnlTQVdKR01UU2x6V3kxOEtpMmFOY21iK05lN1VKMkw2UU1waG53TVlk?=
 =?utf-8?B?eVJYcm9MSnN6MXRHeHEzcWp0Vi9HdTBhMDAwV2dJT0I5MW1JUkcxMk9XY0g4?=
 =?utf-8?B?czd5dmJmbmdoZDMzbXgxelZHN1g0bzA0ZUhxVmM3R1NqZWZmdFVwZ1dNYTdI?=
 =?utf-8?B?MURvTlVkbWk5OXU2L0JiS21PaGk2Y2tRMHVHY085elYwc3BzQmorZThQSmJm?=
 =?utf-8?B?VzB3MU9vTFBJMGxOQXhMa3BYQVNtc0thZ0k3K3E0eCtQYU9ZUzJpdmRHUDNG?=
 =?utf-8?B?Y3RIaVhoUEFPMjdOVHZPMXRYZHM0NHp5RXpWNjlobUdKbmFPaS84TzdlNHdK?=
 =?utf-8?B?QTVmYTBQYXpsZFBaRFlKYWhKS0d4ZjJ0UDdMbHhjdlo5QnZsWWdRdjFYc1k0?=
 =?utf-8?B?R0VGS3N3cFR1SHRZNzdnUzFyTm9vb2xyUTZ5dVkvbVprOUpFazJHS1JFRVB0?=
 =?utf-8?B?QVdFU2NOOHcyRzlybmxUWWdldTVabllpU2M1UDgzNnR4RFZxSy9NTmFZeW9u?=
 =?utf-8?B?SjhONHNyOTBxYktXSm0yWWpQMkpRQTN5V05DYk9KV3BIbndVL2xnREp5OU83?=
 =?utf-8?B?bTREcjYxcHFjYTVwT3g3Z3VLRDFnNHdzamlNUEI3V1BpcTZBMlVZaTdlRG5J?=
 =?utf-8?B?eVY2czNQQW9ISG8xNVRkMjhNdmYwSWJkeXhhQU9yQlpSdFdVRTFZMTVJSi9j?=
 =?utf-8?B?cWNSdGFxcUFJMW5wK096MStUVzRSM1BhU3gxbkJPT0U3aXdiUkk5WXo3UmdH?=
 =?utf-8?B?TG95dlpCcjZGdENpa2M2NXpTQ2VGVWZSc25ZaU14UCtEK0JsV3pGa1I3K1lH?=
 =?utf-8?B?clNsSkV2enN5b0FEMG5WNUxkZEs3VGJ3UklOUnBXcVl0T1FIUWV1V3NqT0Ro?=
 =?utf-8?B?NWlOYzhKNmdnUUxaeGxkTHAycklRanBDckVWb3lqcVhIR0wwM0dJakhOZzZz?=
 =?utf-8?B?aTE1amNwVmlBdm5DbHJhZVVOYU9oMzhxL3pCVzFEZThFQjVrVCtCL1RwMTZw?=
 =?utf-8?B?ajQrWCsyWmVMZnFlTm9DNGw3UEI0elNIZTEwd1Nkcm9ZeGhrRHFWcGY5UWp6?=
 =?utf-8?B?Sjh2Uk5LVEFqUDJnQ01pSGRiVDR1ZkVtOHEwclNHMDZ1d1JGb0dHS0pWT2Fz?=
 =?utf-8?B?SGVLY3NlS1dMRVBycEgwWWp1Sys3a2hCZnZmQytqLzFqcG1WMDdPVFc4K3VZ?=
 =?utf-8?B?K3dISDUrV1dpTHdSclhUNkRuRkdrVFhWUjlGZlRQT09jdS84UjlwRXJjZmlR?=
 =?utf-8?B?OUNOSGl1ZzF1VStyOWVrMFZLOW9zVFNQamRIOUo4TXI3cDVHbzJhTEJpMWwz?=
 =?utf-8?B?M1NoTWVuNzRoeDlKWUoyeVNQcTFKQUtCMFczdWIwdm10cjhEVWN0RWtYSTBR?=
 =?utf-8?Q?Y0yxejQ5UC+21XD2glvmxoiAO?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f26df627-888e-41f6-94c0-08dd46cbde1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 16:32:37.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJP3sdxKKI/RsrW6MCZlOCphU2zoUen6fWuK/TdeX45yBB9SdxKoAVaDUIdAxKva
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6447

On 2/5/2025 1:50 AM, meetakshisetiyaoss@gmail.com wrote:
> From: Meetakshi Setiya <msetiya@microsoft.com>
> 
> MS-SMB2 section 3.2.5.7.5 specifies that client must evaluate
> delta_epoch to compare the old and new epoch values. This delta_epoch
> takes care of lease epoch wraparounds (e.g. when the server resets
> the epoch from 65535 to 0). Currently, we just check if the old epoch
> is numerically less than the new epoch, which can cause problems when
> the server resets its epoch counter from 65535 to 0 - like causing
> the client (with current epoch > 0) to not change its lease state.
> This patch uses delta_epoch based comparisons while comparing lease
> epochs in smb3_downgrade_oplock and smb3_set_oplock_level.
> 
> Also, in the current code for smb3_set_oplock_level, the client
> changes the lease state for a file without comparing the epoch. This
> patch adds the delta_epoch comparision before updating the lease
> state, so that when the change in epoch is negative, the new lease
> state is invalid too. This can protect the client from having an
> inconsistent lease state because of a stale lease state change
> response.
> 
> This patch also adds additional validations to check if the lease
> state change is valid or not, before going through
> smb3_set_oplock_level.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

These changes look promising, but how have they been tested? I'm
especially concerned with the cases where a lease update is becoming
ignored. Combined with the rather subtle wraparound logic, that
doesn't sound like these should go straight to stable.

I'll attempt to find time to review in more detail next week.

Tom.


> ---
>   fs/smb/client/cifsglob.h |  6 +++
>   fs/smb/client/smb2ops.c  | 95 +++++++++++++++++++++++++++++++---------
>   2 files changed, 80 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 2c1b0438fe7d..4417fa46885f 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1558,6 +1558,12 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
>   #define CIFS_CACHE_HANDLE(cinode) (cinode->oplock & CIFS_CACHE_HANDLE_FLG)
>   #define CIFS_CACHE_WRITE(cinode) ((cinode->oplock & CIFS_CACHE_WRITE_FLG) || (CIFS_SB(cinode->netfs.inode.i_sb)->mnt_cifs_flags & CIFS_MOUNT_RW_CACHE))
>   
> +#define IS_SAME_EPOCH(new, cur) ((__u16)new == (__u16)cur)
> +#define IS_NEWER_EPOCH(new, cur) (((short)((__u16)new - (__u16)cur) <= (short)32767) && ((__u16)new != (__u16)cur))
> +
> +bool validate_lease_state_change(__u32 old_state, __u32 new_state,
> +				__u16 old_epoch, __u16 new_epoch);
> +
>   /*
>    * One of these for each file inode
>    */
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index ec36bed54b0b..6e0ce114fc08 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3922,7 +3922,7 @@ smb3_downgrade_oplock(struct TCP_Server_Info *server,
>   	__u16 old_epoch = cinode->epoch;
>   	unsigned int new_state;
>   
> -	if (epoch > old_epoch) {
> +	if (IS_NEWER_EPOCH(epoch, old_epoch)) {
>   		smb21_set_oplock_level(cinode, oplock, 0, NULL);
>   		cinode->epoch = epoch;
>   	}
> @@ -3998,39 +3998,92 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
>   		 &cinode->netfs.inode);
>   }
>   
> +/* helper function to ascertain that the incoming lease state is valid */
> +bool
> +validate_lease_state_change(__u32 old_state, __u32 new_state,
> +				__u16 old_epoch, __u16 new_epoch)
> +{
> +	if (new_state == 0)
> +		return true;
> +
> +	if (old_state == CIFS_CACHE_RH_FLG && new_state == CIFS_CACHE_READ_FLG)
> +		return false;
> +
> +	if (old_state == CIFS_CACHE_RHW_FLG) {
> +		if (new_state == CIFS_CACHE_READ_FLG || new_state == CIFS_CACHE_RH_FLG)
> +			return false;
> +	}
> +
> +	// lease state changes should not be possible without a valid epoch change
> +	if (old_state != new_state) {
> +		if (IS_SAME_EPOCH(new_epoch, old_epoch))
> +			return false;
> +	} else {
> +		if ((old_state & new_state) == CIFS_CACHE_RHW_FLG) {
> +			if (!IS_SAME_EPOCH(new_epoch, old_epoch))
> +				return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
>   static void
>   smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
>   		      __u16 epoch, bool *purge_cache)
>   {
>   	unsigned int old_oplock = cinode->oplock;
> +	unsigned int new_oplock = oplock;
> +
> +	if (!validate_lease_state_change(cinode->oplock, oplock, cinode->epoch, epoch)) {
> +		cifs_dbg(FYI, "Invalid lease state change on inode %p\n", &cinode->netfs.inode);
> +		return;
> +	}
>   
> -	smb21_set_oplock_level(cinode, oplock, epoch, purge_cache);
> +	/* if the epoch returned by the server is older than the current one,
> +	 * the new lease state is stale.
> +	 * In this case, just retain the existing lease level.
> +	 */
> +	if (IS_NEWER_EPOCH(cinode->epoch, epoch)) {
> +		cifs_dbg(FYI,
> +			 "Stale lease epoch received for inode %p, ignoring state change\n",
> +			 &cinode->netfs.inode);
> +		return;
> +	}
>   
> -	if (purge_cache) {
> +	if (purge_cache && old_oplock != 0) {
>   		*purge_cache = false;
> -		if (old_oplock == CIFS_CACHE_READ_FLG) {
> -			if (cinode->oplock == CIFS_CACHE_READ_FLG &&
> -			    (epoch - cinode->epoch > 0))
> -				*purge_cache = true;
> -			else if (cinode->oplock == CIFS_CACHE_RH_FLG &&
> -				 (epoch - cinode->epoch > 1))
> -				*purge_cache = true;
> -			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
> -				 (epoch - cinode->epoch > 1))
> -				*purge_cache = true;
> -			else if (cinode->oplock == 0 &&
> -				 (epoch - cinode->epoch > 0))
> +
> +		/* case 1: lease state remained the same,
> +		 * - if epoch change is 0, no action
> +		 * - if epoch change is > 0, purge cache
> +		 */
> +		if (old_oplock == new_oplock) {
> +			if (IS_NEWER_EPOCH(epoch, cinode->epoch))
>   				*purge_cache = true;
> -		} else if (old_oplock == CIFS_CACHE_RH_FLG) {
> -			if (cinode->oplock == CIFS_CACHE_RH_FLG &&
> -			    (epoch - cinode->epoch > 0))
> +		}
> +
> +		/* case 2: lease state upgraded,
> +		 * - if epoch change is 1, upgrade
> +		 * - if epoch change is > 1, upgrade and purge cache
> +		 * we do not handle lease upgrades, so just purging the cache is ok.
> +		 */
> +		else if (old_oplock == (new_oplock & old_oplock)) {
> +			if (IS_NEWER_EPOCH(epoch-1, cinode->epoch))
>   				*purge_cache = true;
> -			else if (cinode->oplock == CIFS_CACHE_RHW_FLG &&
> -				 (epoch - cinode->epoch > 1))
> +		}
> +
> +		/* case 3: lease state downgraded,
> +		 * - if epoch change > 0, purge cache
> +		 */
> +		else {
> +			if (IS_NEWER_EPOCH(epoch, cinode->epoch))
>   				*purge_cache = true;
>   		}
> -		cinode->epoch = epoch;
>   	}
> +
> +	smb21_set_oplock_level(cinode, new_oplock, epoch, purge_cache);
> +	cinode->epoch = epoch;
>   }
>   
>   #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY

