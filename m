Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2103.outbound.protection.outlook.com [40.107.236.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF901459E8
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720187517; cv=fail; b=Y/g7WcbachVZQV1osKixQmbb7FE63S6O2ysufS73N0NiAyEwZ4KHHugcN8MC/o/x0JIti2jAFv6NnkgAj7rNXOGIL/ERIk/rlmgO94eA5/HZjO60O+CMO0jud4BXRKyreTk7fx2Ht0QAY1C01+oSAfYiYXPam39qJMEiZOV/AyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720187517; c=relaxed/simple;
	bh=L72ZEsJWY13hS4W8M/47IZFfzksExsc8rCl2lCSr5Ks=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h5Vo61fPCVtJhyV8jvN0RdbsPeiO3KBxjqNhKcPZ73Dez3Vq6mIpDT00WJI7kCQAsh5QmSCRAiu6kKCTD500jc0waZOgMk+TgezXJtSq0KShhtMls3cQerVMuhK7yeVQ7VSviwZb9qkdBEcmwdy8EhGT27LjTuc8/KdkgJ1zdSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.236.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cF+ETeV8hDJNtXRh/nfgOoB0chKEujZiB/ldp7AcYcyL/ZvYu1nnz0cDlJsS4f9Ssx6xKq58/dBDnqsvN9UjuvkNqhhhSRTGKYsK7iissha13eBGb4CLx9bnhp0+jzpO9j2fV4HgWABBZQruHPJjCsrSpmwUcuhrOpVr2hfnmQpq/f/lZc5b9pUJPihCat6cxNtekKOtbmUDBmMi/psNHRSDJiVGWEl8fuwAqhfm1EYroz75xKl2B7ZQJjgEW5pimvD/gAUtWaXTgSe6uGPb2uBnqFqZFQLzTy/LwEbwLzAdPgsYt7WWZ9oUylExBL5XrtQYaP5knAE1gLT4NOuNGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORkJIG7YkrKe8xNODb+1GIYWHuq+W6MMmyivEa2tC4Q=;
 b=Q2BtH3rostYayih+ChA+kFl2MG0m7Aps9GNPes7eTrbZ+hxb5aOaUezyBCaESZ30LfiDn0RTXsLCZvJrn8d9HXTBdSDCxMABV1cw8Xw46MiRAnRB8zJN9VQe71XU7FJVG4tZF+/g4DMzgofTwJgrZ86rXxtyViQtJM9x1N3eIz42iUCidgyF8oNB2Cu+7uJd703IeHpQAzss5P+tRQ1cudTrG002UZic2YFR7g5fcxYfMY82o2NWytfWGMP5bOBJ3GLYq1VbSEgx3PPqoTc15lpgMCArSLQdtA1yqU+ftsAX4Olb3To23DmHy1ptjQdbKzl917pXed2ifcTD664XXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 BY1PR01MB9089.prod.exchangelabs.com (2603:10b6:a03:5b5::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.30; Fri, 5 Jul 2024 13:51:51 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%7]) with mapi id 15.20.7741.017; Fri, 5 Jul 2024
 13:51:51 +0000
Message-ID: <e39d83a4-4f8c-41c6-98e5-089a51a2e833@talpey.com>
Date: Fri, 5 Jul 2024 09:51:49 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
To: Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org,
 sfrench@samba.org, senozhatsky@chromium.org, sj1557.seo@samsung.com,
 yoonho.shin@samsung.com, kiras.lee@samsung.com
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com>
 <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
 <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
 <ef50bdc4-360f-4714-a503-bddbdabcbb14@samba.org>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <ef50bdc4-360f-4714-a503-bddbdabcbb14@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:36e::22) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|BY1PR01MB9089:EE_
X-MS-Office365-Filtering-Correlation-Id: 9108427a-9a26-4d91-9ceb-08dc9cf99f76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVdUZ0V3dlRoSEIwTXdwbkxsSXQ4aElsTENKc1dmMFFKb0FpYk91MU9iWXlB?=
 =?utf-8?B?RjN6QUd4SXhmTzA0WmlDbEI3K2UwT1pmVUc5YkdwSDdqWWcrNk5VdFFNNEti?=
 =?utf-8?B?dXpKaS8xaEx3Y3ltVmFZbEtBTlR0Q09iMTdGWTlsREVsa2VTcVlicHg5dkU1?=
 =?utf-8?B?U2Qxajk4MmVscFlTMHdDTVBzcmZTbFBWM0dDTEh2d1UzaWpPRVFvclVaQmhz?=
 =?utf-8?B?NEZTT3VjZ3RDNndEL1prODd2ZWVlYW9IL245cXdLdzNnL0FpdnArbnBaNUdV?=
 =?utf-8?B?RVFGRXllNzBGOXVoa04wcjdBSU5aT2lyN0hQRWxLcHB1cjVldmRGTHBGT3RL?=
 =?utf-8?B?MU9PN1FmWWZPYkpVQlZnalNBRG45WjAxbys0dkc3RW51NFZMMEhSY0NockY5?=
 =?utf-8?B?cHcrV2pHU0I3bU02cGZ2WmR5enppSkIyejVGdWplSzhqc3ZYZ1UvMWg3dGh4?=
 =?utf-8?B?aEMxYnRTQWlIVXJDZGJ0cUtUNk1xbG5FaDJTSmxiczFGTlN4alcrd2VaQ2ZB?=
 =?utf-8?B?TW9Bc0J3WndQQTdoWjM5ZVZVWm5RZU1LbHlwRWQwMGY2MjJMYWhSZVQ4V2pw?=
 =?utf-8?B?cVErOU9PaFRxdXI3V2xmbVdoaFZCaGhJQ2MxTGNNVlc3UUdOU1d5cDE5TU00?=
 =?utf-8?B?bGhCMlVicWdOYXFhMXBGUTUwUWVpdkRuRmJ6L1l5SWY2ZERwaHBYUGpPakF1?=
 =?utf-8?B?MjIzMGFndCs2OFJkZWVTUlQrSTFRcjFZZURWSlA3a3A0M0FQdnRnS0VtWENl?=
 =?utf-8?B?WWZ2OTJZdXlubW43ZzFuOHhscnh2UWdrb3lRZHJvZlFSWnRYc05xd1J0dVRG?=
 =?utf-8?B?czh3VHZBOCtERnEzQ280YjFPTEVHN29vMVA3QThnWTEzcEJKNjZjWEt4bWdJ?=
 =?utf-8?B?ekdVSTJzQTIxdUZPUy9jbWM3dmtzZEQ0RHpOcU1zc0NTbHFxbTl1Z2F5NC9l?=
 =?utf-8?B?VWtoTG95Rzh5RGpUdm4ySEhMRjYvcXVqMXUvR25VQU1HSDIvc1RQSXZTL1NJ?=
 =?utf-8?B?eEdUQm9ENGpJcU5VenlINHI5dVZrYlJ0R1BFSXozV2lnZXovWWJ6MzZVRHhs?=
 =?utf-8?B?VDNud2d2SGkzam43OWE1TkM5bHl4czVNekdSS1lxS0lCR1NTWG44MXhMNW12?=
 =?utf-8?B?eXBXUUNsQXNyUmVVMzM1Vy9mbFl6QTlXRzFCQlM0aWl4YXlFVGc3SHRhN0Zr?=
 =?utf-8?B?bFcyNEsrYkJOWUEyaVdzZmhvQlB1N2lMWHNuR0hmSnlKMEc0c1o1R2xNTUdx?=
 =?utf-8?B?Zm1mbDBpVEFqbDVsRnpMV2JOSDlobk9semM3R2F5TGl3UEhzdHowOVdoN2Ji?=
 =?utf-8?B?WUFSSGYyZEo3VzNnTG5FdGFFNDNGNnRLNFZaWFBJeXVMdkJkUFluc0lCNlVo?=
 =?utf-8?B?REQxWmM1YmJnYk1SZVc1VC9JU0dvUGxBdXhqQWJNQUk2bXNJVlE5QmVzaURj?=
 =?utf-8?B?NUpoQ0dwVGltVmx2dFJIdnlJOVI5VEJWa2dDNFloZmNiSG1VUEdvV0RCUmU5?=
 =?utf-8?B?OWNaRGU0eXhxdnd3SGVEZ0pCWk04R2tyY29iQ3V3bCs4UmJzSlFYYndtUkRm?=
 =?utf-8?B?TVRHU2trQW1KWW04bXpoRG45YWVSa1JRSGwyYnJtcmJpMmkrZS9XL2NWUmRk?=
 =?utf-8?B?WHpZYXo5SWpwaW1sZHZXd0ZQTklzMEdhMmZreXhTUFk4MldpWmdnMHpQeUtu?=
 =?utf-8?B?YUtsZmxDdjdNY0NFRlo3dFBUTlhmbzhmaEFaejRQQjZFQ1QvWnF0dFkrVmlz?=
 =?utf-8?B?V1R0Q1Bpc1RHK0d1cXhNNWZ1MGJQTmJ1WDB1dkhkWm05TklqV2pJSURVVmlk?=
 =?utf-8?B?Y1VyT3VvZ3M4Y0tOWGNrQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZEN3dXJaSEpYeUFiajM4TWtRUHRKTm1seG9ib0Q4UnZUSjFNTFJQTzJ1dEdq?=
 =?utf-8?B?WUsrRTRHTk5sSUJNSTJES1RUQUN0TkhwNmlxNDJHU3NoMzdsaDVnQW1kZ1JQ?=
 =?utf-8?B?eWdrenNVQWttVEM3WEtQWWRHVE9BWnMyVTFib0tla0NuajFpWUxKVWNnb2xD?=
 =?utf-8?B?Vko5a0xtOGVlWmJVVldmbmdGUnpCTi9GZ2tES2x6cWhybi9CTFVNcy80WlVq?=
 =?utf-8?B?WGpEdUxtdnkvN0ZFZVlUVTlBL28rQkpBNDdMQURtakVkTlROSDdMNWQ3NXFS?=
 =?utf-8?B?RTVYa0M2a0RpUkU1WTJMSStvdFVpeFZEc2pSaCsrdEd1U3llcUordnNRam5Q?=
 =?utf-8?B?Sm5SeERaVFRLQVREbVVqeXVJNnJjUkZLSnp0dzhvTEh3bWNKUkxreVh0NC9x?=
 =?utf-8?B?VkVVQVdOK0FKRDVaRW1EUVpRTUMvS2JYd1N4N3hta3QwdFpRMU90VDdZSmtS?=
 =?utf-8?B?WjJHSDkwbitESmxrVGZLRk1lNVhKRTI1VzlWc05CcUJzL2NMSkFPdkRVUDh4?=
 =?utf-8?B?VGJWVkcxR1FaOWFwaVF2RTdsRThoVFBrcUFNcVlNeWMvMi9CRXZ1am9pZ3hL?=
 =?utf-8?B?VjUreUk0bGpDWUl4MjU1SWRGd2JySmlyeWxhRzhodDBxKzRIMzJVcy9mNlY0?=
 =?utf-8?B?SDltYVptOVptSXFHNmZQSG9aVnBRUnFmVEZxL2FsbUtIVUplY0xEQmR3V0VN?=
 =?utf-8?B?YnoySU93aFJpclhTREJadWhQS0srQURBY1B0c2pVVE9kdXB2a2lBUTF6U2hL?=
 =?utf-8?B?VEk5OUpLV09iSlllRVJBUGlhakVGZThKTnRKSTdpVTBmVmw1Z2NpVXVuazJw?=
 =?utf-8?B?Nk5ZUUlZNFRnMUJiZmxiRmxiU2x5RXdDQjJVV3QvZGJBYm80d2JyU04yam4v?=
 =?utf-8?B?VlhSWnd4d2J6WC9HRUlMVjQrYUVBbGFwRjlybXFRT0k2R3ZlVHV0aTlTY3dL?=
 =?utf-8?B?OHo4YWFFN0R2NzJsTnlmSjRJTVMvQ01UUHZ5L29iMnJ5QnhZUzR6MEZOcU5Y?=
 =?utf-8?B?bHQ5dHBBdTZpRldrMWdxYWhZTnprNS9NbkQ5ZkRGTnhLb2pkNzFYYThCVElR?=
 =?utf-8?B?blpvZDRsdmFmWExDbEthZmtNdkRKd0lkN2FGN2J0OFZpZ1ZwVHVEb2RaMENR?=
 =?utf-8?B?bkQ2QTE5czZVQzVkWHphRjBWS2owUlU0dUdCMXljTXV5VG1rUGw3dkU1WGxm?=
 =?utf-8?B?M3B5Zjl5SGp6RDVtNGdtZnkzNUxZTTNJUHhvaXdwNHRYRURDQXNCK29IUzdM?=
 =?utf-8?B?dlJsNEtTd25pMnE4dGtCdXNQT3ZSV2JjYnJreWZXZS9SaHlpdTNkeDRWSWNY?=
 =?utf-8?B?UUR1NDRDUW1Na1JBLy8vV2NVSXY1NFRLbkJpTUJocnpWN0xPK3ZvTHA4ZTlO?=
 =?utf-8?B?UXlodTk1V1ZEOGdWVE5XSlhzK0dsWE9SMGhIS05Hd1IyY3hTWjl6VVpVc0dN?=
 =?utf-8?B?TGhsSlZvOEhiYTR1cjdwclhNSFMzV3c4cVZhbDRmUGlFT2VuV0xIa3dERDh0?=
 =?utf-8?B?T3pXV3dJR2JUNFhSZUJXR3VvMGgvZTJ4dnQ5dlFtOHNDRVJqVXh1N1FVbFR3?=
 =?utf-8?B?VDMwV0ZxSm9aMkdNZUhnOUNpdEcxTU5zc3FnVnZVU2NncU1QZGRUN0I0NXNk?=
 =?utf-8?B?WHUyeHFjMTBKbkZpdkRiWlpGQTlMQWQwaWxZeVZ0ekdWVm45dG1nZXlIWFRF?=
 =?utf-8?B?YmFJOFJXTUU2VDVXYkZZaUlkOWoxcURIUVVwRnFFL3FUSXNHZmVMZnRFMG4w?=
 =?utf-8?B?V2VvcjRjeERWNGJPa0Q1NkRXazVCQ1MvbEdDODF4a280RWQxY2ZwejlldkJ5?=
 =?utf-8?B?MW5iSjZGUjNOeE4wVEtSdmJrU0s0RGJFUWVkQjBlYWFHdDVsZUI1b1B3Mkxp?=
 =?utf-8?B?aWsxVFQ1ckFBVjNRbzNvMVhwOFczKzBhL012VlJsZmwrZ0hRK2d6eE9wcTJy?=
 =?utf-8?B?T1hSbmN6dDRMUHI4VWNZSGtzYWk1K2tsYUlQYXRQb1F2bkxjUlRUZkVaRi9N?=
 =?utf-8?B?dWF0VWwwemZjbjJyUHNKTzY4T1BRVklMUGlhaFJ4WmZpVi9NUGZoMjV1R3hs?=
 =?utf-8?B?T2p3cGQ0VSt6ZnNTcFhNSDVMQzVQUVN3MTBQWVp5L29nS1JFSlYrbU01REJv?=
 =?utf-8?Q?MJ7F4zvAnflP9wKUyFoq1sYiZ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9108427a-9a26-4d91-9ceb-08dc9cf99f76
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 13:51:51.6859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akTwcEQeQradpYnb39kLIl0CgwVhwZj4rccuw/9GiJNfU1C4vjWu7KN5Jki2MSSc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR01MB9089

On 7/5/2024 9:16 AM, Ralph Boehme wrote:
> On 7/5/24 2:33 PM, Namjae Jeon wrote:
>> 2024년 7월 5일 (금) 오후 8:54, Ralph Boehme <slow@samba.org>님이 작성:
>>>
>>> On 7/5/24 5:27 AM, Hobin Woo wrote:
>>>> may_open() does not allow a directory to be opened with the write 
>>>> access.
>>>> However, some writing flags set by client result in adding write access
>>>> on server, making ksmbd incompatible with FUSE file system. Simply, 
>>>> let's
>>>> discard the write access when opening a directory.
>>>
>>> afair this should cause a failure like EACCESS or EISDIR and just be
>>> ignored. What does a Windows server return in this case, or Samba for
>>> that matter as it (hopefully) will behave like Windows.
>>  From what I've checked the packet dump, Samba doesn't return any
>> errors in the same case.
>> Samba seems to open it with O_RDONLY if it is directory, So there is
>> no problem, is it right?
> 
> Hm, it seems my memory is playing tricks on me. Samba indeed forces 
> O_RDONLY for directories in the servers and ignores the client requested 
> access mask. Interestingly we don't seem to have any test for this case, 
> at least I couldn't find any with a quick search. Quickly putting 
> together a torture test shows Windows behaves the same. MS-FSA doesn't 
> mention any such check should be done for directories as well. Getinfo 
> on such a handle even returns the original unmodified client access 
> mask, including the write access.
> 
> Sorry for the noise! :)
> 
> -slow

I would ask to see that the SMB3 protocol test suite results are not
impacted by this change, and ideally the various Linux/XFS tests as
well. I don't see any indication these were run?

The other thing I want to point out is that the crash reported in the
commit message is a FUSE failure. Why is that not a bug, and why does
the message not justify why the "fix" is in ksmbd?

Tom.
