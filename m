Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149F17BD0
	for <linux-cifs@vger.kernel.org>; Sat, 13 Jan 2024 23:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l73tLSJLqX/bN1buWmhXHdqPDWBXkkphFm0pBGmK7D6xSMrFemM494diQH2Xhp55A/u7DR+HdmiYJ7CSD9vso2CeD1cIlN9Zrp3J9oK5HoZEkKftnd+ko1s3AwCAVPHQrOO3v9jU5ARQbdRckS65T5U/jFXk5erskfVfe6pwljEi0b+W69IFX/OQnZm/ihWuELGB0fsmpLfiriC65u9TNB1mOP3QVTiwcOfvoRTpP2j2c0hsSWLNi2VpImSvFAdIlp3HhGHkGaV3w37LFbXGJaqAXZo/msV/b69d4ClYN7IIV5ZAOTWQKWRySDK23kZagimtPjraQDERUAVP7Xr/qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vczeY1Or7qp5MFXm0TjrH9nFMujzE+LgMAEPYiG4l7s=;
 b=jlw01cmz7qQHho5ylAb1gK3mVikt/gRmZdQQoB35R67bArD4Odl39f+Rq67Vfi0m1c6Xpp9Z6zY/QrFDeFyllJm6oza2JbAMkcK5PW2DbZKnnM2X0rwyUAEEKpr/F+9hXhR2twJyQsuo3aClSjwwPwT8sbjAxj5OikQtCQ/0B/Gmp6fvOGVGEkGE6eGinFz7SIih0hW/FfWhA68EypH8D/Z9sO+xmMcs1SsyB7N48oymLzCoKvSSmU4B1hTNd3A46WZMD8rhzMzJPmvTCwKqcd769OL9PpEa+GNgNh7X6p9hNjXYTrmcmX3uhsPjRuxf2mmG/UBbaQxYEO/d6UWw3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from PH0PR01MB7428.prod.exchangelabs.com (2603:10b6:510:db::15) by
 PH0PR01MB7993.prod.exchangelabs.com (2603:10b6:510:285::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.23; Sat, 13 Jan 2024 23:53:11 +0000
Received: from PH0PR01MB7428.prod.exchangelabs.com
 ([fe80::53cb:bd90:c8de:268f]) by PH0PR01MB7428.prod.exchangelabs.com
 ([fe80::53cb:bd90:c8de:268f%3]) with mapi id 15.20.7181.022; Sat, 13 Jan 2024
 23:53:10 +0000
Message-ID: <6b7670f5-44d4-4b1e-aef1-5f15ec809072@talpey.com>
Date: Sat, 13 Jan 2024 18:53:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: update feature status in documentation
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20240113064643.4151-1-linkinjeon@kernel.org>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20240113064643.4151-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::32) To PH0PR01MB7428.prod.exchangelabs.com
 (2603:10b6:510:db::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR01MB7428:EE_|PH0PR01MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: 894a297b-1e39-43c3-5296-08dc1492cc3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8Mhpmv9g08SsGruL9X4+JxVOa9aSwwNOdaOFxzi2mNSwwTYAMIs/IMk7WsXw86b6/7PPMaCBiGgzkMBh4FngjJw7J0LsZFqAyHEVHqAeKPwVeSZEFVNpa4OSkUK6GAp/gFedAAekqs20mwJvOga/6TIYt99vG7nZowDvEPUB6poa4jGfWqG9XRAUElQ4/suncjb/lLWKJlkK8qTenn8ak02sa3xyE+XhJ6aM2hJimmjjn+qIC6gOqTe0S3eqbCh4gQ71ND+CLrhvLbApvOOAC7PFfNR1tTOUKsCReGEwWp8lL/WZxP8wod4JaDFXz3dRbCQyxlRb9mHi7wOaSatMoqrVr7EdD0Dp+pBS72YKCBmq9d5nLwgWscarRKu/ylZHhuaOX1hgH/9+x3GAAuqKOzCHcA1DE1gGQXBVVxnWviuWcLkw5sYi+7KyNAm2qKhfM7huAgjBHgDvHxybloFwjFq+RaXIoSQy4JENH/+B5yhLg+pP2o4SGlANhUBqB6oK9Q1pz7kgH7K4ZgzD/XSPWVORN5erMtBSWsgBMXiqzp2c7a3c02IBfiYlvCaK5hR8QGQUTXBbn7y3WHBkT9/EmaUg+IyUanS9zO1OqHta+E7CDeHM7aj5J+0pIcOD87CN
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB7428.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(39830400003)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(83380400001)(86362001)(26005)(2906002)(6512007)(6506007)(2616005)(66556008)(53546011)(5660300002)(38100700002)(478600001)(66476007)(8936002)(8676002)(316002)(6486002)(15650500001)(4326008)(6666004)(66946007)(41300700001)(31696002)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzRUU2JPd211S0NqRDlpdVNTRDgzL01kMEgzZHNXQ3k5VlZ6bUNyaktxZ1J5?=
 =?utf-8?B?bG1EYU9vU3JMM3JXYjNCN3JpRkZVcGhrdU0yNEJycUtQSXFGWWduM1hUL1VV?=
 =?utf-8?B?NlNZa0VmclJPbHlOcW5lOTdoVEJYR21lUUQvZ012TG1vV0FZTjNDUXZicnU5?=
 =?utf-8?B?Tm5KNG1aUVNrMk1TM0wvKzNuZnlVMlZxNXFmOTl5aU1VSGNIS2R2cTVKZXNr?=
 =?utf-8?B?NFVmbkNTSW5kYjRqclgwUzdNeUxaVHlZUG9CMFROaCtFQ21CbVdaSnRGVGlt?=
 =?utf-8?B?eXJBbmV6SFdjVlpqcEhmeVJZblJxQnJEUlJyYktBNHl0Q3pyY0FZbDJtbytN?=
 =?utf-8?B?Z0xTUUNmLy9XVUQrU05KbWd0N2tMVWl3NHVvSUxsNkcyZjZBWk1WaHVRRHVP?=
 =?utf-8?B?bEI4ZnV5YnBVU3pXMk5IVmU2QXkwZGk3ODhLZVFObUZkcW56c1kvbGV4YU9z?=
 =?utf-8?B?QkhDQU1WNEhCZXNpMEhFcCtqdy85TzN5SUZWWTR1eFhzNk1TdHlZak1ubEFI?=
 =?utf-8?B?MVVVWlkyWmZDTTRkYlhXK2YyMGVlZVJBMGluREhoQ1I5dTlwbWNqb09rWE02?=
 =?utf-8?B?aG5pZFgrVDB0YXluMW5FakZhNHdmd1IxeFo4bTBUTlVwR0tJb1htK2ZUcC9l?=
 =?utf-8?B?dVVtOFFFNmZMWEFVd1YvcHFtK3BYMy8vTFN4OExSYWNHeE9KQ2JxcmpRY3JK?=
 =?utf-8?B?UWxLdHIrWGpyZGRwNHhVZDF5QWRNeW03cDRxSmtVWFdUMDBydFk3aFhtdjJ5?=
 =?utf-8?B?MXJZbjZkbmR5L0xHbW1xUFg3MVAveG9MYXpFcEF3OVBJNkJqVkpuNVAyQncr?=
 =?utf-8?B?NXdkZHVDYmpDMFM0bGZtaVVmbGNhK0lDalFxVlhSMzh6WjlWeUlPcTBoYWJp?=
 =?utf-8?B?YTF2S0RrK2Y1Z3U2NTQwbUw1VzNsQVpaUWViQjdKRFZwZ21qVzRLUW93c2R2?=
 =?utf-8?B?N3cxYTdmeCtMbE02VzdHdDl1MG1RaExrS1gxTGx2SG16aHhMeEpZU2NwbHVK?=
 =?utf-8?B?THlNSEhsK01mYklMZU9xQzNpSVpzSndVeDduYlVnL1RDRXY0NUtKNGs1cVV6?=
 =?utf-8?B?Q1g0ajBVR2c2T2ltT3Q1T0JDWlVJbzZteG90d1pqTUFPMlEzWnM4d2JqVlVs?=
 =?utf-8?B?UVlyNWdmZlVkcGpEdVhCemh1ZjdrT09xZzFKNlhVemh0Q0l5WDhhbFR0Mks4?=
 =?utf-8?B?Q3ZLYlZsY0dHZlp0azhRd1lTR2h6TGxscVNVdEhqN0FkWUFnamNCQWdTUUht?=
 =?utf-8?B?ZkNna3dxbUlMN2ZXT3FvNVJydmNlSFBPTk9ESEpjQ0VWei9oaG5jVXRhK2Vh?=
 =?utf-8?B?bVJTdHNoQzhZdFRqK0pLSHg3UXNRS0dZNWs3ZGxLSWdrTXRRS2sxY2REUWM4?=
 =?utf-8?B?MFgvK2JMN3BXQWlLOHpBaHJBRlMrU1FuV1RJalpPWVRhQUtsSGpwejI5aHFJ?=
 =?utf-8?B?SFU2enpTNGxnZU4xUkJFMEF2UlZ1Y0thV3lrRERLZmhBV3hqRFg2N1pTd1Vk?=
 =?utf-8?B?L2R6NVZGU2VMVUhFK01RWU50V01LcjdaWDVLQ2dOUUtTbmQ0YkcxTy9hbW5q?=
 =?utf-8?B?T1VCYVd6OGdqMzFPSXlyUmdzOUpiZENiZDUwNXFxUEVZSWUzVjZRbWlOTjNq?=
 =?utf-8?B?dWdHaGt5ZVlEUkU0UWVkdUt2YlZlbGVGVVFHSXgwSHl4UDhqMVQ0MG1naUd1?=
 =?utf-8?B?YUN6a3JSWVhWdzZaZTUwdFhkK3pWL2RNUXFqUm9XYngvdjlFZnZ0MFFSeVdP?=
 =?utf-8?B?L0hjbWtKL0p4M3V1STRPcmFTbU94N0xPSTVuRVZsZW9RUEVOcFkrN1BmMk1Q?=
 =?utf-8?B?OU16N09LZFQ5Tjl3MGJHRXd1RDZybmk4YjEvL2R5V2N1YkJyRnVUdWtKeEJ2?=
 =?utf-8?B?RUdQcXBISGQvNC9La05WVkdBUFJ2N21BVFJHTjl3c3kwZmNZTHE2NDZIV1Ir?=
 =?utf-8?B?YnBPUEhlKyswYjlyUUUyN0lVekxwai9INkxXOGxWQWF5b1dFaklzSG82V2F6?=
 =?utf-8?B?dkU3QXg1UlpPdTdvUmQvQW1xVnBhd1I5Y0g1a0R1K3N6bG1tNmNUbnVHanUr?=
 =?utf-8?B?SnlmaWpMcVFHRmRoNlZsWFdpUUJxQ2hhNVQ2NnlJUWI4R2dEc21PKytKVkNP?=
 =?utf-8?Q?S4xH17gurXo/qunbNRm3YyyWy?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894a297b-1e39-43c3-5296-08dc1492cc3e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB7428.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2024 23:53:10.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I68fdNp+eLzf2GqaEGE5l23CRuhQmTPQapz75FskFPbP3G0fO1Ago/QZT1bK9RJ4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7993

On 1/13/2024 1:46 AM, Namjae Jeon wrote:
> Update ksmbd feature status in documentation file.
>   - add support for v2 lease feature and SMB3 CCM/GCM256 encryption.
>   - add planned features.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   Documentation/filesystems/smb/ksmbd.rst | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/smb/ksmbd.rst b/Documentation/filesystems/smb/ksmbd.rst
> index 7bed96d794fc..251e27900f88 100644
> --- a/Documentation/filesystems/smb/ksmbd.rst
> +++ b/Documentation/filesystems/smb/ksmbd.rst
> @@ -73,15 +73,14 @@ Auto Negotiation               Supported.
>   Compound Request               Supported.
>   Oplock Cache Mechanism         Supported.
>   SMB2 leases(v1 lease)          Supported.
> -Directory leases(v2 lease)     Planned for future.
> +Directory leases(v2 lease)     Supported.
>   Multi-credits                  Supported.
>   NTLM/NTLMv2                    Supported.
>   HMAC-SHA256 Signing            Supported.
>   Secure negotiate               Supported.
>   Signing Update                 Supported.
>   Pre-authentication integrity   Supported.
> -SMB3 encryption(CCM, GCM)      Supported. (CCM and GCM128 supported, GCM256 in
> -                               progress)
> +SMB3 encryption(CCM, GCM)      Supported. (CCM/GCM128 and CCM/GCM256 supported)
>   SMB direct(RDMA)               Supported.
>   SMB3 Multi-channel             Partially Supported. Planned to implement
>                                  replay/retry mechanisms for future.
> @@ -112,6 +111,9 @@ DCE/RPC support                Partially Supported. a few calls(NetShareEnumAll,
>                                  for Witness protocol e.g.)
>   ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
>                                  support are Leases, Notify, ACLs and Share modes.
> +SMB2 Compression               Planned for future.
> +SMB over QUIC                  Planned for future.

Technically speaking both compression and QUIC are SMB3.1.1-only.

Tom.

> +Signing/Encryption over RDMA   Planned for future.
>   ============================== =================================================
>   
>   
