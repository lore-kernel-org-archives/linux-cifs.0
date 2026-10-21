Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.118
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792596629;
	b=UU1pExAGkytu6N2eElGteAJqFK3QZi66sYx82b/BmtEUfRyY1lqxNTYkmzYFYscIZMhG
	 ZbL8FxdZfAqjhN7sFEUYhG8zhGdaO+xDXTwssLhWo9zVI8DEB0n2MOYhT3krK86Ec/zcU
	 w++2rx5bplC/pK/jWD+ylimoVcZjdJOTmcsbbBUdKhKJy00Z/88e19bARyYXthWlsbUH/
	 lpaxvTsR/xjv2DQM1i8Giv0qsZjymMtLVdNIn4T0fTD9tp29RtOiHrotbqg9YyIFA/mQG
	 JdAH6jFZ85sf8mvSQSM10CvRJAmmthlzqth2Fi/Lt1czwPK7zUaNTgUKwobseZwp5Eg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792596629;
	h=DMARC-Filter:Received:Received:Message-ID:Date:User-Agent:Subject:To:
	 Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=PLLvHWqgDU70PFgwDhJOzNkURUoknZW3yt42UV4DQZQ=;
	b=saJdAOLfqU7Q6eNfYZQtbh5AwEtVNjFXhxdSP4gr6CEVevBYtgeWOpq3GucG+Hwo/kNz
	 1Cvdexpw8++TAUDIg9KHp0wF/P5T9xTQjW2afSOT26O6RzXU4IcqKbdEHEYlus1vzNoTY
	 zQqxnICVVegZ9UfinOjOWp5G3UYjjLAKTnZBuTppXnBlW2yRIHj1HrwsP/75PadK/oGVW
	 yij3mU2m25pNs7gOuo73OTvvWSyd9zQ2hAf7hReowGehtMMXtsLiyXY2ETAnGtHPR0MUM
	 KChod2vdiNtoZbuZjiIObfWkN04qQvYEPcc7WSUPwLjsqFDcUCJW3aiS/JxOC5zLTdA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=talpey.com;
	spf=pass smtp.mailfrom=talpey.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.118
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022118.outbound.protection.outlook.com [40.93.195.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66449606A31B;
	Wed, 21 Oct 2026 15:30:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66449606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6nGzyfSsJanb93ZYrx1Ky89EgtgQblxIOoSXfPsAJj7hZL+yrXi6Hl2Eb3aLTyetnriIcgqLIUKuNeTykdLQJesvVh4eAE1t8hZ5WqZLpSBfcgfQj/fbgrzzMfyV+C4hXlgPo5fN7O9btaUt60Du93BDsenBC2h6wJXW5mFPqrNIF+B8IKR23t7w1+UcYzuSS2MGPpJghkxb4TA47rjxq7Vwy8i1QvFT392eZ+QTE4/N4CbuFT3xhkEB9ZQYjsgkg+ibP7+unTzNJvuSkoB7m7jbO9PqNhhf4We3NySR56jMJnFCr8vGZg41kr/kdNVJGIArhd8ibcnmQnkWJCBEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PLLvHWqgDU70PFgwDhJOzNkURUoknZW3yt42UV4DQZQ=;
 b=CcUs/jy/xWiIyTVXmmPgIsC4N6ids30/WtUg0pvfXC+JDt8v3i3F1zZ4qRUl+RQjJnii93mr4eg+rMEbgsA3WNQoVkWtVONoVMvUmxKhfWwInY3cZqgLrSqMH4iDCfsR5UfZp+fa86m7pBNYHJFCyYHTAodvqQenjbJCgtqND5alGxhP2tjQnl7vE6FImBT1dSs9A/wlUJPW5eKfX+hPtx9TiyU5dgkZSMADiLnw061IGUHz7pMBlM52tPUzC7VeZgsxonTUGI/l5qGuEsqY1FAlrcm7RUfxkxGUcu5QlYzrrRGE/CwQrfD8S0vO1V7btFrGQH50QR3xVQMiCr3M7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from PH0PR01MB6344.prod.exchangelabs.com (2603:10b6:510:18::16) by
 PH0PR01MB994284.prod.exchangelabs.com (2603:10b6:510:38f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.2; Wed, 21 Oct 2026 15:30:25 +0000
Received: from PH0PR01MB6344.prod.exchangelabs.com
 ([fe80::eddb:aaf5:fd79:2b08]) by PH0PR01MB6344.prod.exchangelabs.com
 ([fe80::eddb:aaf5:fd79:2b08%6]) with mapi id 15.21.0569.000; Wed, 21 Oct 2026
 15:30:25 +0000
Message-ID: <6233e33a-e6e2-4c9d-8372-5aa75f4f3314@talpey.com>
Date: Wed, 21 Oct 2026 11:30:14 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] smb/client: don't unhash and rehash to prevent new
 opens.
To: NeilBrown <neil@brown.name>, Paulo Alcantara <pc@manguebit.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260928012812.2890035-1-neilb@ownmail.net>
 <20260928012812.2890035-2-neilb@ownmail.net>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <20260928012812.2890035-2-neilb@ownmail.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0162.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::35) To PH0PR01MB6344.prod.exchangelabs.com
 (2603:10b6:510:18::16)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR01MB6344:EE_|PH0PR01MB994284:EE_
X-MS-Office365-Filtering-Correlation-Id: a30ab429-4fad-43b1-b91c-08df2f883a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|10067099003|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	vQGXAiTT03jvxNZyrR7kRiVAopDaUISe4baWaxTqzYC9SpqjKu6G2bBORjwp/rkhLH3Xo6kDHBTmkm7NxbgFeS7Aq2+336qu1piGxaiNnu3FgqSiizNhpFmisKrjBiBHczDaQxnNVoNRo6JadEKLVXRSRqWv5d+E7R/P7HlvWkZTBeDPn5g18LbKyTqfVKsYU1OwzRmCGkcCIKnciv1oBkkmM4HGHBrfU068/TZKLLExQjQDZ5PnOGhMoPQU+zwS9Up599mErh4TzUyR1jKZi+rO5gb3PyXgLEV6uF7auK+npJTqKFH0DuHMTrS7iSIO9GaxQ6/4ToVIreiRif7BOXC/884cCIi6wyC+csBQaDdLzXeRD7dSbS0VXCdQlm6ImSpgIMA2+5k2uzNSFowJcVSy8lpaFUUimJv/ljixQfwViJdp7zMjdbjpo3I+1pwEJK7L3RNfivaITtsK5dBRYgVTWgnV2j+RJ+fRUOPaH/CYuvag6JiGHmRGEdBVLNWiQudKJGiUyxonGLQl8DVg9Gzf3q5bMFEbvpGer2YCngnlGNwa3FvWtZj8En8mutbD3c78GEzUoI+xAft5JiPbnX4+sSzxSg9frWFPkifO46L8XPQQA9S5Cm2CjzfHXg5dtAMrlThZEQ54Dsdtqp/NbdkRNh6qawXMZsDr4e3+q7I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6344.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1VoSzgwcHBXWkVIZnZaNkdLQXNleFR6ZmZyNk0wMEdwMjdwUHR0QzdsSjNk?=
 =?utf-8?B?YXF0V1J6bDVIdk1RSTNMUkJiY1NlWWl2NG1UK3hJUDRNY2RZWGRsaUxiWkw2?=
 =?utf-8?B?MmxlaTdNbHh4UEE2RmRnOVl4bm5oZmpnYngvbE00ZkxEQmtieVZrdEFPeG16?=
 =?utf-8?B?SUEyS0UzbnFVY0lvVUswQWxWSHJNNjdDTUNEZFROR1M3eS9SUEtqR28vOHQr?=
 =?utf-8?B?RDN3bzdjMnR4N0IxcUVjSlpqUm51TG96dDNYcjQyVDVwZVZkSUR5MnVwRGV2?=
 =?utf-8?B?UnRSRWlvdGt6bzFVSEpMRmN5TWlidThHV0ZHcGVWNE5xQlRMTXlDN0hqOGxU?=
 =?utf-8?B?TmN4eUFFYlhScUU2L0x2VGRxOG9iQ081SVZKK2Z5K1J6M1h0OWR5L0h6L0U4?=
 =?utf-8?B?ZGNYT1hOVmlMRjRDRGxUaTlHanR2Y2xLY3ZGUUhtUEdDaS9VMG80Y3o0Z3Vz?=
 =?utf-8?B?ejROVXJ6TVJoNStPOEY4b3JzdVpEVEptenp4cmxEOU5uUWVtWVFLSXBJYUpL?=
 =?utf-8?B?TUdpRkQwSUFEUGVVTHRCWjFHY2NwNWl6UmtQRVBPNy8vakR1M1RLYUdUVDZw?=
 =?utf-8?B?MjcyK1lNNHlpeGZScjdLVVQ3ci81Ym5IUm9kRG9nNHY4elVBeDdNelVmV0xv?=
 =?utf-8?B?MHJaWUw4aS9sbWFBeXRnZC9uUmJTV2xzREh5UTE0R3JMY1JySjJ0bXJJMEp3?=
 =?utf-8?B?SHhOM0ZOQXR3U3h6REMvZXFKOCs1V3ludk51cWNDRG5aeDUwczdFaHB4dzBG?=
 =?utf-8?B?S2N4WHNNRjFia0lwaXJhRTFZWmZJUVpGcTVITDlsK3RCS0FWMnFpNm4rT1dY?=
 =?utf-8?B?VGYvQnl1WjZ3VHBrWXMrbTMwbVI1YnArNWpSVVdEOXQzOHZpc3AvWnVSN0J2?=
 =?utf-8?B?Z3lXd2Nha0NpVXkvOTR6QXhsT2wvc1FFa3FKTkhFMEV3NUF0amg0QlY4VVVz?=
 =?utf-8?B?NHhnU291TDBzWG5wNURuc2dycjVRbjB3Y0ppeUk2b0xhdXJnckZsZEw0U29N?=
 =?utf-8?B?dXcwbzk0MzNTSXZpRWFOYUpvRW42Q280cTFFMmxMeitFSVY2cm1XZEJicWZv?=
 =?utf-8?B?bVRvMTlEbEFzbXhTbXdrQ0x3emJXYXBTb0YycUdKa2lzcWFKSTZpbnYzZ2wv?=
 =?utf-8?B?UWIrS3UxOUlIbk5GbGlRQnFBbXJIMFVRMndPb054ZXZvaWlhc0JsMFUveEM5?=
 =?utf-8?B?VjJEaEpZb1o1TlFKNktMNmMyTDhTUW56M21DRUJ6ZzhWVU5JWHA5a0hMNm1T?=
 =?utf-8?B?UnBOTlluR2xiNU0zc3RyYWdYWUw4YnNHS1JXdlZrbWYrMUU0S3d1R1ZYUk5J?=
 =?utf-8?B?Yi84VURxNE5mQm5kaXM4cG9ieStrYTFqNU5aK1V3QVdrS2Z4Q2s1QkpVak5a?=
 =?utf-8?B?TCt3QnFpNHk5WkQxVWRHQk8yV0p4bnZIbFAySmNoZnNQdXJWWXQvaHI1Wlpz?=
 =?utf-8?B?eTRKMWhJQmlRVDFQN1d1ZEFWSENYSXVGQWtTdXRDUFlNUERGVCtzTnNZNHdQ?=
 =?utf-8?B?WU44dk05YUNrZU1YWmJOM0R6Q2FCbWpxa0Q1MEtKUTEyUHVKdGxJRHBKREo3?=
 =?utf-8?B?TS9WK29FUm9mSldQY0E2cDF0OG1pV1FyQXVwOFVlZ3Z3TUlLdjFmcWZmaklj?=
 =?utf-8?B?bjJ4NUpQRzdrN2gvMXE0Zi85Z1k2RjFCcS9RQmVzK2tkakJtOWZuaUJOaG5B?=
 =?utf-8?B?TUQ5OFE5TGc3RFpuSDQzbjZlb3ZZK09XdzZPYUVzTzRrNmVmNWJLNENuejQw?=
 =?utf-8?B?L0Q1VUpVdEUxSG9VTXZwNDJhczVoY25iaERDOFpUYkt0UklueU9QbzROWEhS?=
 =?utf-8?B?ZTVDeGRrdFdIU1Q3RlJRaklMS0NLb1gyZ2NGZUlUZTdzUEhJWjBOZTEwT0lK?=
 =?utf-8?B?VjMxSXI3dHpyV2dSbTQrY254cnhsM29LZ2JCcjhySXl0SDVCbG55Um1oVEh6?=
 =?utf-8?B?TmIyeGpLSjZRTVpDWk1xQnREd1N1bGhQeHR6MGxTa01OZDB5YmZFVytMZVZZ?=
 =?utf-8?B?UHdUellkd1Z3T1NUQ3dSRldtYS9YbDF4ZGtPa05uaDVkbGcrQ1hmTU03TThF?=
 =?utf-8?B?QkxRL3dGYUpkbmNDc0o3VlY2MXNtVFNXcTVUQlZzeVBNN0FPb0Vlamp3amdi?=
 =?utf-8?B?dWk0OTF5V1NaeDMvSzBsSEpieXhnSVMrbGsvZnp6ODNMRG9JS2d6eERkbDZq?=
 =?utf-8?B?WTB5eWV5d0tkNE9KbzFuZi9JRks2UVlyVnNzTGNkUklKUzNMbit5ZTVUdGh5?=
 =?utf-8?B?WkhwK3RNeDYzbURXZURSWUJNMGVlOWZoMUlyUlZPaTIwalZubWN6UVloazh0?=
 =?utf-8?Q?0dS64ZrLwWpUly6Q8o?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a30ab429-4fad-43b1-b91c-08df2f883a28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6344.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 15:30:24.9572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iYHLAK7eIn2n3ykuIElqj0gSCCfSs06pgdOsFLq53EMk3g/44S7urKAJLx7nl8Hz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB994284

One nit below...

On 9/27/2026 9:25 PM, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> smb/client needs to block new opens of the target of unlink and rename
> while the operation is progressing.  This stablises d_count() and allows
> a determination of whether a "silly-rename" is required.
> 
> It currently unhashes the dentry which will cause lookup to block on
> the parent directory i_rwsem.  Proposed changes to locking will cause
> this approach to stop working as the exclusivity will be provided for
> the dentry only, and only while it is hashed.
> 
> So we introduce a new machanism similar to that used by nfs.
> DCACHE_PRIVATE (given the name DCACHE_BLOCKED) is set when lookups need
> to be blocked.  ->d_revalidate checks for this and blocks.  This might
> still allow d_count() to increment, but once it has been tested as 1,
> there can be no new opens completed.
> 
> Unlike unhash which does not need to be reverted on error, and which
> must not be reverted on a successful d_move, blocking of opens must
> always be reverted.  So we don't block the open until after the last
> early "return", and we always unblock on the final "return".
> 
> Strictly speaking it is only necessary to block opens before the value
> of d_count() is tested under ->d_lock. But we block as early as possible
> to discourage new opens from starting.  As open is path-based in cifs a
> concurrent rename can be confused a rename of one other the paths.  Once
> cifs_open() has generated the full_path it doesn't hold any locks to
> prevent a rename from making that path invalid.
> 
> The important details of the interlock between __cifs_unlink (which both
> unlink and rename use) and "open" are that __cifs_unlink() sets
> DCACHE_BLOCKED  *before* testing d_count() which is
> in a d_lock locked region,  and cifs_d_revalidate() tests the bit *after*
> ->d_lock is taken by e.g. __d_lookup() to increment d_count().
> Thus ->d_lock provide serialization between the set and the test
> even though the test isn't in a locked region.
> (The fact that cifs_d_revalidate() always returned -ECHILD when
>   LOOKUP_RCU is important for this sequencing to work as it ensures
>   d_revalidate() is called *after* d_count() is incremented).
> 
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>   fs/smb/client/cifsfs.h |  8 +++++
>   fs/smb/client/dir.c    |  3 ++
>   fs/smb/client/inode.c  | 68 ++++++++++++++++++++++++------------------
>   3 files changed, 50 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
> index 0c85daa8386e..bcc0fb5c2c9b 100644
> --- a/fs/smb/client/cifsfs.h
> +++ b/fs/smb/client/cifsfs.h
> @@ -42,6 +42,14 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
>   	return (unsigned long) dentry->d_fsdata;
>   }
>   
> +/*
> + * This is set to block d_revalidate on a dentry that is being removed -
> + * the target of unlink or rename.  This causes any open attempt to
> + * block.  There may be existing opens but they can be detected by
> + * checking d_count() under ->d_lock.
> + */
> +#define DCACHE_BLOCKED DCACHE_PRIVATE

Why the alias? The blocking behavior is reasonable but #defining a
flag value which is purely local to this file seems unnecessary and
confusing. What if another file in fs/smb/client also overloads the
DCACHE_PRIVATE flag, for example. Consider removing this hunk.

Tom.


> +
>   extern struct file_system_type cifs_fs_type, smb3_fs_type;
>   extern const struct address_space_operations cifs_addr_ops;
>   extern const struct address_space_operations cifs_addr_ops_smallbuf;
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 6fa6d48fdfd3..88fff65320f5 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -872,6 +872,9 @@ cifs_d_revalidate(struct inode *dir, const struct qstr *name,
>   	if (flags & LOOKUP_RCU)
>   		return -ECHILD;
>   
> +	/* Wait for pending rename/unlink */
> +	wait_var_event(&direntry->d_flags, !(direntry->d_flags & DCACHE_BLOCKED));
> +
>   	if (d_really_is_positive(direntry)) {
>   		int rc;
>   		struct inode *inode = d_inode(direntry);
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 12ed8db10e00..4d34c5622cd4 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1967,24 +1967,31 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
>   	__u32 dosattr = 0, origattr = 0;
>   	struct TCP_Server_Info *server;
>   	struct iattr *attrs = NULL;
> -	bool rehash = false;
> +	bool unblock = false;
>   
>   	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
>   
>   	if (unlikely(cifs_forced_shutdown(cifs_sb)))
>   		return smb_EIO(smb_eio_trace_forced_shutdown);
>   
> -	/* Unhash dentry in advance to prevent any concurrent opens */
> -	spin_lock(&dentry->d_lock);
> -	if (!d_unhashed(dentry)) {
> -		__d_drop(dentry);
> -		rehash = true;
> -	}
> -	spin_unlock(&dentry->d_lock);
> -
>   	tlink = cifs_sb_tlink(cifs_sb);
>   	if (IS_ERR(tlink))
>   		return PTR_ERR(tlink);
> +
> +	/* opens might already be blocked by rename */
> +	if (!(dentry->d_flags & DCACHE_BLOCKED)) {
> +		/*
> +		 * Block opens - and all lookups that involve d_revalidate.
> +		 * This guarantees that if another thread tries to open(), it
> +		 * will either block, or will increment d_count()
> +		 * before we test it below.
> +		 */
> +		spin_lock(&dentry->d_lock);
> +		dentry->d_flags |= DCACHE_BLOCKED;
> +		spin_unlock(&dentry->d_lock);
> +		unblock = true;
> +	}
> +
>   	tcon = tlink_tcon(tlink);
>   	server = tcon->ses->server;
>   
> @@ -2107,8 +2114,13 @@ static int __cifs_unlink(struct inode *dir, struct dentry *dentry, bool sillyren
>   	kfree(attrs);
>   	free_xid(xid);
>   	cifs_put_tlink(tlink);
> -	if (rehash)
> -		d_rehash(dentry);
> +	/* Allow lookups/opens */
> +	if (unblock) {
> +		spin_lock(&dentry->d_lock);
> +		store_release_wake_up(&dentry->d_flags,
> +				      dentry->d_flags &~ DCACHE_BLOCKED);
> +		spin_unlock(&dentry->d_lock);
> +	}
>   	return rc;
>   }
>   
> @@ -2536,7 +2548,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   	struct cifs_sb_info *cifs_sb;
>   	struct tcon_link *tlink;
>   	struct cifs_tcon *tcon;
> -	bool rehash = false;
>   	unsigned int xid;
>   	int rc, tmprc;
>   	int retry_count = 0;
> @@ -2552,20 +2563,20 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   	if (unlikely(cifs_forced_shutdown(cifs_sb)))
>   		return smb_EIO(smb_eio_trace_forced_shutdown);
>   
> -	/*
> -	 * Prevent any concurrent opens on the target by unhashing the dentry.
> -	 * VFS already unhashes the target when renaming directories.
> -	 */
> -	if (d_is_positive(target_dentry) && !d_is_dir(target_dentry)) {
> -		if (!d_unhashed(target_dentry)) {
> -			d_drop(target_dentry);
> -			rehash = true;
> -		}
> -	}
> -
>   	tlink = cifs_sb_tlink(cifs_sb);
>   	if (IS_ERR(tlink))
>   		return PTR_ERR(tlink);
> +
> +	/*
> +	 * Block opens - and all lookups that involve d_revalidate.
> +	 * This guarantees that if another thread tries to open(), it
> +	 * will either block, or will increment d_count()
> +	 * before we test it in __cifs_unlink().
> +	 */
> +	spin_lock(&target_dentry->d_lock);
> +	target_dentry->d_flags |= DCACHE_BLOCKED;
> +	spin_unlock(&target_dentry->d_lock);
> +
>   	tcon = tlink_tcon(tlink);
>   	server = tcon->ses->server;
>   
> @@ -2605,8 +2616,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   		}
>   	}
>   
> -	if (!rc)
> -		rehash = false;
>   	/*
>   	 * No-replace is the natural behavior for CIFS, so skip unlink hacks.
>   	 */
> @@ -2698,8 +2707,6 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   			}
>   			rc = cifs_do_rename(xid, source_dentry, from_name,
>   					    target_dentry, to_name);
> -			if (!rc)
> -				rehash = false;
>   		}
>   	}
>   
> @@ -2713,8 +2720,11 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
>   	CIFS_I(source_dir)->time = CIFS_I(target_dir)->time = 0;
>   
>   cifs_rename_exit:
> -	if (rehash)
> -		d_rehash(target_dentry);
> +	/* Allow lookups/opens */
> +	spin_lock(&target_dentry->d_lock);
> +	store_release_wake_up(&target_dentry->d_flags,
> +			      target_dentry->d_flags &~ DCACHE_BLOCKED);
> +	spin_unlock(&target_dentry->d_lock);
>   	kfree(info_buf_source);
>   	free_dentry_path(page2);
>   	free_dentry_path(page1);
> 
> base-commit: 3879f51857325da9bf3cfb073280257cd16ae067

