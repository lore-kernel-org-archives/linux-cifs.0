Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E758A1706
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 05:43:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcpaFvpmCZSQvZZWstgSUkdOjJ4SktPi2x6r3vcAeQDL299NwuP7pPOntwKNha6RdI1nZCqQkUT1+OU6+1x1616k1QlKUgVmUH3yCPgksSaTaxa9gUB9S94VfXk/iGHLq9qvgm1g80ajGMd+auiFRiLtadPY6QYt3F6wqnpbMbLnfWytIwohwUEulfsB06TnK7mcbIrM14seNMsp8HDVZnQSMYlNMSN7w/JDhXPYWH+9OoCwT5lznkNFU4qHYLWwI+SrFmYZv+MdXMcxzMrM5PbmhL1q4DwpHxKSOf80wAXBe1mBpjeq5RHeZ6uaO5tH3Ctk2+qXcoTQaxGXTTE7mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JM1tsUa2QHBmeeM9BIdwfT/pH4MNYNXBVJM1vdLV0oI=;
 b=IR6AwCM+8z35wKgRZLEpIch0+Uwqrx/30sqq9SASW6qqmLlCdRhH7kgP2x7dfyMS+YHPxSs1pwWM7ub+hi3+VNEtjhFdM9Z4iPfvXnh1uwoUklfChIcGXIYh2strrVyNfHikoF4HCVIPuPzDbr0BMMPyvyW0MsD48prUG/i3dEme8uTRw2e98ufxlKdLmDyRJUVeo7Grj8mwTr22bf4kQhmovjuBOa0OPG5dX/woOjTriH10vMPEoGdZViQ3+pL7yXZYG7qLT563jQnIg4GO95dQ/rHJtcP2US5HED3svgb1B6zyfw7SXyQ2KoXjwWHG2q4juFuzV2dHLnDy2deO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA1PR01MB6575.prod.exchangelabs.com (2603:10b6:806:18a::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.28; Fri, 8 Dec 2023 13:43:05 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7068.028; Fri, 8 Dec 2023 13:43:05 +0000
Message-ID: <88668505-bc39-4ec7-abe0-d78a345332ec@talpey.com>
Date: Fri, 8 Dec 2023 08:43:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
Content-Language: en-US
To: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
 linux-cifs@vger.kernel.org, smfrench@gmail.com,
 Shyam Prasad N <nspmangalore@gmail.com>, bharathsm.hsk@gmail.com,
 Paulo Alcantara <pc@manguebit.com>, lsahlber@redhat.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com>
 <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
 <e9921ba7ff3ec02cf5c0a0adc77d6edc@manguebit.com>
 <CAFTVevXHdcXLHD4H+6U+YvhOGzPtBJ37dHOYV1AT+AuDLqSfiA@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAFTVevXHdcXLHD4H+6U+YvhOGzPtBJ37dHOYV1AT+AuDLqSfiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:335::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA1PR01MB6575:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ef7f631-f4db-4992-b4bd-08dbf7f39afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	elF03iHNgFO13z64yn8Fk/7wVHGJVY3PLY/o2B3ZKgagLb7AUhJ1Qe6vN3AnhJaNWgrJNPOYmXnmNi6emQszlBdIXWmfecz7wYKRXsfVxu8ErEhwE9s5kK+5wHxzs9Pah5Ccw6fHMd7a16BZjMSz34Ly8kdLwxuJBPzRnqRAWDoDc7GPzR+i0dL3DCiG8zCqfZie6BSbpvqol1O91b/0JsavMgYNvsHG/S9O1SR2Eu4mIjbh1fjd+3S2Y8bG2jQ/Rq+3MVoP+Wqxh4FgFRxJ5iM9H9+0Dvn1XvKcCPkdo9B3nv52lUovU7WUr9eAIsN0DKA6IYM2gPpwjAjXHiaQl0yjpD+u5GoIsQW9BZo4pqszxeKSLQcFPv4SR0+i+J2cdjABtMKLp8RNmaUXTICHtwKL/GfG4M6p06iKolaiDBQtgsnzD9E3fwDgwdsnqn5g0K1lhSUfuyUfbFkWBzp17IvQnnstoMICs513NkiYExSI+gfqn3nLeOq7HzanMmyyFSCDLlpJOc4+Gvxgz6mRIyduOgvkvI/XDsxGeFMp2qgGdLvA9UWGyx7pLhj5CFwyC7elIC1UNcEEZzbbYmmhQu7lPpD6OO4JTWRaXybCq91qp4LWVIjooQFXtnREy+u2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(39830400003)(346002)(136003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(53546011)(6506007)(6486002)(478600001)(36756003)(5660300002)(66946007)(2906002)(66556008)(66476007)(110136005)(316002)(4326008)(8676002)(8936002)(83380400001)(31696002)(31686004)(2616005)(38100700002)(41300700001)(6512007)(26005)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDBNeGMzQlJpdGh4S0lKTHRjRWhTeHE0akw0RW16bnNjdWNITXN3eXd1czdh?=
 =?utf-8?B?QkdySVpWdHlXUmpLcTVsdVE2SlZXRlJBaTZoNmszUjFTcWFKTUNOSEpveW5N?=
 =?utf-8?B?QVlHd2IyU0I5WWlmSTJoM0ZvU2VGTlRiT3pwaERvd0RWMnczY1dCbG9PRE5I?=
 =?utf-8?B?SjdZUDhpTDZ6Skx2VmkyL0NycDZsQjlxQlBwanZCai9velE5bEZCVDR0WHNz?=
 =?utf-8?B?RFpkaFdEblRhRGh6OFV4Q3J1MDcrcmhvUWpIcUZWV1o1aThVcW5EYzFsekFW?=
 =?utf-8?B?RGllQ1hUcjM2NU9lcThDcnR1cWdLaVovSjZ0czNFNXV4Yi9VeHFqMlNWc2Y4?=
 =?utf-8?B?TUsyL2J5R21GaE44L0tuNC9qdTUvMjR2NVRNRE9KOHN5K2tLYW92aiszYjBr?=
 =?utf-8?B?a2x0MThFYTR1U3RoOC9JNUJSM1c1LzNNb0RMU3VjYy9MZDRZLzhLVmpkTzcr?=
 =?utf-8?B?bk9PUEgxQjUrYlRTRlo0U002eHdKbnIzU0p5Nmo0cjlMQk1rMDV5WDRsL200?=
 =?utf-8?B?RUVDaU5GbGJDUXVWSHI0YTl0OXZONWl2ditsTm9YSnR5OHg2eExoUnBEYzEx?=
 =?utf-8?B?WVpTUWE4NVd4WjJnYXpNUStDc3lrdUVZWkZPWlE2cUhWeEJ6YlRtOWIzQjRs?=
 =?utf-8?B?dmxSUGRGeTBobFE0ZXV2N3Jka3JhQktHOGZWalJrSlVKZm50R1VYdk5JRTlt?=
 =?utf-8?B?dS82ak50bnBXeUd1ZlNRcEdKL2xkeVhxWWtDNkQwSUNGZmtDTC9NYzJjTU1i?=
 =?utf-8?B?UldLajJ5SWlOVWdMNmJPRFJVb0g2T3FnYkVMcnRLRy9oQ29sc1N3bXNwOVM1?=
 =?utf-8?B?bzlEcS84SzVrMU52SUFyWTFWMkhFM1J1VGIzcS9CNFg0bGVLZ09laEhscU9L?=
 =?utf-8?B?ZnJyTnRLZVRmVmxsT2cwRVNoUjN6Sy9PNk9zVmVhMkZVZEtMbmIwc1BxS0k3?=
 =?utf-8?B?NFJjMzhucXFNSGk1TlNaOVJza1ljOERCem9LZU9MZmFnVnUwUTRsejZ2cUxV?=
 =?utf-8?B?dlhTTmY5NmgrRGcwVksxMU9Na0RiN0x4R24xUzhiMmtkWkdoZVZhWjYySzRD?=
 =?utf-8?B?cXhBc1VGM3JWQ0Z2Umk2ZmFQSUhOaVRqQnBtN3FPNUx4YU9oaVh6T0p3QWds?=
 =?utf-8?B?MmozVTc5RnRnQjJZc3lHNVBIaW1NY2dtQllva0ZsNzRHRVIxejc5WlVmOW9B?=
 =?utf-8?B?RWNLWEZiZm9nMWgzY2k4ODF0dDlmNHIwb3NCejNrbzJDTjZaNnZwWlR5dmZz?=
 =?utf-8?B?Z3REMUpMOHdTVVVHVWhOSXJHT05oNzZ4RENoa2xuNUxMMENIYWxVejBrNlhQ?=
 =?utf-8?B?K2xONXlBSnZOd1VMRFV0REMwa0JVdTVmbnUvMmxnV0lVblh3bnQxWnZNSkFl?=
 =?utf-8?B?Unl1Z051empMckxWNGNHWkFDMC9lMlpGamJGNXNVTTFVM1YyWnFSRXRiZjcv?=
 =?utf-8?B?Zm5razQxQzNzNUJwQnEvZjI0ZmJaNnc4S2NWSXQyOHZQNFdBN09xeGRoY1dK?=
 =?utf-8?B?aEcvWEFXOENxSUM0NHd5cFloc0QvVVQxVWkxcC9mNGREU2hURGdoYTEyK1R2?=
 =?utf-8?B?Y1lwQnZMSCtCUUQ5RVF4eXlXNVB5bk8zd0dyNUxXS0NyaXROaTV3U2thekxi?=
 =?utf-8?B?S2g2MFV5SU9FaVU1NFhQQk8wUkZKcVBpVE01YVBFM2JJNVJTRi9NUTM3M2tO?=
 =?utf-8?B?SjNnSWNJd2d6QlhNckc3Z2poRHFWV3ZpMk9UcFlkV0czRlltdVpqWmhsVG5l?=
 =?utf-8?B?ZU5QZGRPa2k2WENQRVFzMkxUSXlGZWRZYXYzbklWS0Y3cnQ1UjV0blV2dkJW?=
 =?utf-8?B?OTVoSXRMeTl4Zit6VExZZDhNYktjOFYwQmRYYVZZTDk4amdySWRxNDZmc1RT?=
 =?utf-8?B?dnlxeHNEa2tiV2FhOWdONmZETnZONFFzbDNRQ095WGhnVWkyR3Vwa2JGZC91?=
 =?utf-8?B?L1pyWDhkL0ozRnoraU5NVGJKSStQMVVrcHJWRHJUa3lQUHZEcFF1dW1MNDl1?=
 =?utf-8?B?SnRDajJNeW9zeXZEVWFtWFVyRGFPWE40QUJHZStHTCtCdE5oS25ad21KN3Jy?=
 =?utf-8?B?NVkvRlFWUjFRbGR6NGErcnBoNzBWU3M0cU11dXJmWWtISHVMOW1lTHp5QTlG?=
 =?utf-8?Q?OyFhLPHH1dMUbB8/oICw4CYzq?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef7f631-f4db-4992-b4bd-08dbf7f39afc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 13:43:05.3966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4i72xhVHiuTQA9+DZ5yFOe+SwkbiCr3g2WzWsbi3LP86pRWmspXX+IrBwdO23pWK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6575

On 12/8/2023 5:37 AM, Meetakshi Setiya wrote:
> Heeding the conversation above, I have updated the patch and added it as
> an attachment here. The problem with failing xfstests with this patch was
> reusing the lease key for a file to do operations on its hardlink. As per some
> investigations I performed on the windows smb server and, in the MS-SMB2 docs,
> leases are associated with file (full) path like Tom mentioned. Since
> we maintain
> lease key with the inode on the client, as a temporary fix, I have added a
> check to avoid sending the lease key when a file has hardlinks.

> +	/* If there is an existing lease, reuse it */
> +
> +	/*
> +	 * note: files with hardlinks cause unexpected behaviour. As per MS-SMB2,
> +	 * lease keys are associated with the file name. We are maintaining lease keys
> +	 * with the inode on the client. If the file has hardlinks associated with it,
> +	 * it could be possible that the lease for a file be reused for an operation
> +	 * on the hardlink or vice versa. As a temporary fix, skip reusing the
> +	 * lease if the file has hardlinks.
> +	 */
> +	if (dentry) {
> +		inode = d_inode(dentry);
> +		cinode = CIFS_I(inode);
> +		if (cinode->lease_granted && inode->i_nlink == 1) {
> +			oplock = SMB2_OPLOCK_LEVEL_LEASE;
> +			memcpy(fid.lease_key, cinode->lease_key, SMB2_LEASE_KEY_SIZE);
> +		}
> +	}
> +

This patch completely removes the fix for any hard linked file! How can
you justify proposing a "temporary fix" for upstream? It will simply
keep the old, problematic, behavior.

Also, the patch description hasn't been changed, and is therefore no
longer accurate.

Nak, in its present form.

Tom.

> 
> Thanks
> Meetakshi
> 
> On Wed, Dec 6, 2023 at 7:38 PM Paulo Alcantara <pc@manguebit.com> wrote:
>>
>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>
>>> That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
>>> due to the server not recognizing the lease id for the file bar.
>>> I'm not sure that this is a client bug.
>>> If the server supports hard links, then should it not be aware that
>>> foo and bar are the same files? AFAIK, file lease is associated with a
>>> file, and not the dentry.
>>
>> The patch is doing
>>
>>          +       //if there is an existing lease, reuse it
>>          +       if (dentry) {
>>          +               inode = d_inode(dentry);
>>          +               cinode = CIFS_I(inode);
>>          +               if (cinode->lease_granted) {
>>          +                       oplock = SMB2_OPLOCK_LEVEL_LEASE;
>>          +                       memcpy(fid.lease_key, cinode->lease_key, SMB2_LEASE_KEY_SIZE);
>>          +               }
>>          +       }
>>
>> and @inode ends up being the same for foo and bar from reproducer.  So,
>> the client is trying to close bar file by using lease key from foo.  The
>> server then fails to match @cinode->lease_key for bar file.
