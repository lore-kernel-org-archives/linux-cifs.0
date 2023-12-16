Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F3128E2B
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvraRXuSn6C3uJ1jGr7I4T1XPXbXA6mqtC/5ea2UGGVQXhkGitQz3weyG5r4vg+r28T8trE45zWY/g9jj9IOwaqmVc2KSi/+lsSc6UGfARC1Uc8iYiJ6/uGUqevSU6jHrudKOJyWd74RiJOAPE+Zvr/FDyFQPPb4F/r3wHzqW+ER1dt5ZNSPzJYwejM705BmdRiP1hVtjknvtoB/+A4zKsDha9hBxJrYjGrzF+pLV4kh6EXDo82jFV9qKs1HsndL5WpeX7cThmLIl74UvD9sefFoYFFQCORoYhzQBYo9NpIETHHUKyFnJXIAvMAZ2BMQqgexR4CqNEoFNLhDawg1JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1d8LZWW7A5uAZgLxF0A6lE4NBhgcg/INq9wTRsS9yNs=;
 b=VQxLn3cJaOF8VXRuHjT7CXa/ZkAs467MeqWYywobhOIAii2uoFmOtFFJ6ESPtvN6N8W/eoK6GBAFnW16lvQOqfqzz/0/zLdyDGrecmeTUFrG6koAJGSKLw7zZ9bXrhITH1GfdGDXUij4/OWsQyM90XzIVy13Oahig2J9MH3Dz/oJGnqBWFt/UN6YPHAYAFw3D3Aa2GS4PyWRoykEDLWwvPug3OvzBLhNyb2svdvZAs2lvip27e7pKH7yIKOAhAI0rn6lXd8F57k5pZvmfKe5zBecaB0h4UNF8MdYckx2Ts31/LvNdXz56HFvWVmMi5+hBqPE2lPzyz5QPF6fyQ2GcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL3PR01MB6850.prod.exchangelabs.com (2603:10b6:208:351::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.35; Sat, 16 Dec 2023 13:37:56 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7091.030; Sat, 16 Dec 2023 13:37:55 +0000
Message-ID: <4cdd0fbb-2afe-497c-ade3-e445c5c0ae53@talpey.com>
Date: Sat, 16 Dec 2023 08:37:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ksmbd: set v2 lease version on lease upgrade
Content-Language: en-US
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20231216122938.4511-1-linkinjeon@kernel.org>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20231216122938.4511-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL6PEPF00013E03.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:1b) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL3PR01MB6850:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd14a63-b3c6-4d1b-b647-08dbfe3c3596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B+CU6A6d+AKsjuoOLDXw/a5YapwiUGd/1YZyZK9ljOOnBiU6vbgFxZ5yu30cf32XpcjLUaXl0gQtMhaODV7URxgGOHuFRMSHOuvrNDWNv2HKFHswMrkR+Oa1nDR+BsRz9ZID5ktYmSq8+W3KuBYLOyMZ2aGn1sDnkrw7YfqAsVVu1jNiKs6HxcN+ogWZy0sYNdyBFylP2+nquth6t1Cg68Ha0HiOvz84MyDXW9FAXwKt6F4cb9TWCb0zVXU+koO3KAUrv53r3HvJmmF5f0KB+iZHCBKOlsxGfwwQ3fPE/4Tnt3AgOiFlFh5yLZCHp+7bkiulsogM1hLTbBFTEhp9TUW6z5zRJ2Vk8jEPtDp8XwuL3I18L0A3cYGpRol/PBLFsCOSwgwL57d/m6ic5e5N7ZgJMOehd2zhdBytC8iJGDro912pLkSnNpG+Wmheg6nYXgSgKrurVp8xxVmMa+pxhCsK3fyBI6R3H7mwfdpSJXJ/bfCR3uwsv+r5XUx+EHceavfcZpy9AMAUna9I+KeH1hZ6NRr31zgN3QVyofgR5GUHpWfGwER+9Yccd4FfIuRPI/3CxUbn3vU1eCxTtW7vDEZOEOq1reZuI88uSnY3q6gcg0/R1Kl+DjupPYGyAkKz
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(39830400003)(376002)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(83380400001)(31696002)(86362001)(478600001)(41300700001)(38100700002)(6486002)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(316002)(2616005)(36756003)(2906002)(26005)(6506007)(6666004)(5660300002)(53546011)(6512007)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEhjSGE0ZlFSb2JCaExIcDN5eFRPRWZrZDk1N1lJRWFyU3lDWXY3eFlHRzd0?=
 =?utf-8?B?ME45ZHlCeTM4MitaTERXZUtQOU5XYXY1R1Q0MkEweUl1YW5QcFh1aHVERzZB?=
 =?utf-8?B?RHFwTUVEa0c3cHRvZmhxY1RTeU1vV3NKc2g2QThVVXVvZ0xxZkhCQzBlQ3Zq?=
 =?utf-8?B?c2hTMjBPdnlHLzBlNnQxNVBIQkRSZ0VrUWYvVDA0dTJFbWxOcFRWajZRcVcy?=
 =?utf-8?B?MXZhMkl2N09PNWtEUjFhaCtsMERzbDFFdDFKT3N4R2RpaW9pcXdHMDRnc2Jo?=
 =?utf-8?B?Z3FFWmhWTlR6akNWMm9XMFozYm9MQytINXcxKzhhSlZycmI5N1c5VXUxTmNy?=
 =?utf-8?B?Z3NaekV3RUwxUFFZL1hoWWNRQkpPUUdya2dhL3dBQ3YrN2FiUStjNjFRR0FH?=
 =?utf-8?B?NTYxd1RQMG9kVkxhVnFqdjAxL0xvUm4xSHB6YzVGZDhoOFJoSjdDYnd3WG9J?=
 =?utf-8?B?Z2ZPVDJXaDArcklWb1dtOHRVQUJibHNhSldFQWVEeGF0OGQvYjhIYjVYZjJo?=
 =?utf-8?B?cVhGYTlhRll5dUV6ZDlVVmx0V2F0MWZCd3cvNEpabm5WVjdBejVKNm9hT1BM?=
 =?utf-8?B?emJsNjk0akNpNGJNbndLVnY0TWFsaUFDZ0kyTEJuS3cvcTZndkNaV0dQVXNE?=
 =?utf-8?B?dFZIcHRlb0k4dWpiVEFIRU0vc3VlS1JIYXgyUzJaMDcvVWJvSGZlTGpISlEy?=
 =?utf-8?B?ZkZBT1hNNG5VVTNiSndYejBGb2lFOTJPbnlqTXRMZko1MldQRTJ5RHk3aitt?=
 =?utf-8?B?RlFVNVNlRXlvTHRRSHlRQlEvTUxLV1dNOGRzUU9jblNqWmRYZFpPTlpzNnBw?=
 =?utf-8?B?ajJoajdvSHhsOTFRTkxVZ3ovRVozTzBkUlUwZzJUU0lkYXJpZjZOVmJaSkxC?=
 =?utf-8?B?c0t3STN0NVQreUE3Q1NqUzFuVjFCRHhLL25rOE9BQWdYdzErQlozcUVXY0Jv?=
 =?utf-8?B?ZnpFbUNMeFV1alA5MkRJa29UQVJZeEhJOGFoZzFQVnpFNkNLcjFqVWRENFVv?=
 =?utf-8?B?ZTBLQ3FvY0Vvbk9jeVVrT2N3R2wxSHpjaDgyL0RZRnkzSGR3dW4rWG96Mkto?=
 =?utf-8?B?WHlLSTlkTXNLZkNIOHYwRHRidUo3OGNLMlhBTGVDKzF6dzY5U1VzSndwVnNM?=
 =?utf-8?B?TkhnRmJpRWVrOHU1dFFab1BFOTM2ektUK3ViRFdhbGhZQXdTbVF6Q2ZwQWx3?=
 =?utf-8?B?Nyt1aVJ5V0RWVFdPT1hBTXgrVWppa0tONVQvYXJ0WWpUNWkvTWVMVlM0TzBu?=
 =?utf-8?B?REdURndoT1M4eVUwLzRKQTUvd2NDN05HY21SYXJRek1DbHlrRWNmODEvK1Fu?=
 =?utf-8?B?dFQyaGFmTksxdzhIKzFaMVBSeDB4L3NoVytCSWJrRFlWeWVnZlc4S2hod3Jt?=
 =?utf-8?B?WWpacDByeGx0VnhMTEVJdHV3V09uVTRyYjJ2WGRwRFFkWm1ORjk4dHRBRTJQ?=
 =?utf-8?B?dWMwWE9mbnpTTzVjNnRVaFlJZEloV3llQy84TkJFelNybmZhcGlDWCtaMHo3?=
 =?utf-8?B?M2RIWlh3cHVRdFNuQll1MDRLNEdZYUJ0TVh5UnJ3dUEyakNISy8zODRUdzZF?=
 =?utf-8?B?OHJkU0Q4R0lLME1LdStlZXpUTFVReW1XY0hHN3laM2loYThiN2pqQWpMVCtY?=
 =?utf-8?B?cUNqUml2WHNBV3NTS1JuZnhrRU5EcjgvUmdQNFdqejNiOGdYNnUxSDduWFNq?=
 =?utf-8?B?RkRKZHNFclM1WnpGQ1lSTkNvaDVPZkFJWEdUT3lYSm1uK28zSmc1dWZBenVa?=
 =?utf-8?B?UytTSklDRExTQllMSmhGdFl2azI3L0pIV1hwRmxyUXIrN2t3MTlPcFg5dzE0?=
 =?utf-8?B?TXhBalNnSVJCTjlYQmVXNVhHV1pnV0p6a2hRZEVNWWpCejIvK0RJYTAvUDRH?=
 =?utf-8?B?VURpSUF4UEFNVjUwTXNuUi9zVmV1MklKa2p3UGdjbzFGZGZNMGdyNUJDNEln?=
 =?utf-8?B?dzZpZ0dNQi95R3BlbTA1OHBDemNVbklNemovR2krN0RhUG8rUnJBUmN0bHpu?=
 =?utf-8?B?OWloN29jVDBjMXJwUjhBUCs1WEhteU8zVC8vcy9CKzNSaG5KU1I4bTZYdVc3?=
 =?utf-8?B?dzlPYk1vcVhSeURYNXNoUXdCK3h4blNRNkFBZk92VklaQXFQem1ZOTF0WEhv?=
 =?utf-8?Q?Q3xrlbp81t0ZseeOPiP2uAt2A?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd14a63-b3c6-4d1b-b647-08dbfe3c3596
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2023 13:37:55.5447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgbYr73hAOBsKacaXd1tqTMQmiwKGnUipFgrUUd7f7bkmsyExPnfpXf/spFpDSug
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR01MB6850

On 12/16/2023 7:29 AM, Namjae Jeon wrote:
> If file opened with v2 lease is upgraded with v1 lease, smb server

Can you elaborate on this scenario? Lease v1 is SMB2, while v2 is SMB3.
So how can the same client expect to do both? And how can the server
support that?

MS-SMB2:

> 3.2.4.3.8 Requesting a Lease on a File or a Directory
...
> If Connection.Dialect belongs to the SMB 3.x dialect family, the client MUST attach an
> SMB2_CREATE_REQUEST_LEASE_V2 create context to the request. The create context MUST be
> formatted as described in section 2.2.13.2.10 with the following values
...
> If Connection.Dialect is equal to "2.1", the client MUST attach an SMB2_CREATE_REQUEST_LEASE
> create context to the request. The create context MUST be formatted as described in section
> 2.2.13.2.8, with the LeaseState value provided by the application



Tom.

> should response v2 lease create context to client.
> This patch fix smb2.lease.v2_epoch2 test failure.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/smb/server/oplock.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> index 562b180459a1..9a19d8b06c8c 100644
> --- a/fs/smb/server/oplock.c
> +++ b/fs/smb/server/oplock.c
> @@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
>   	lease2->duration = lease1->duration;
>   	lease2->flags = lease1->flags;
>   	lease2->epoch = lease1->epoch++;
> +	lease2->version = lease1->version;
>   }
>   
>   static int add_lease_global_list(struct oplock_info *opinfo)
