Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022133.outbound.protection.outlook.com [40.93.195.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B82EDDAB;
	Sun, 10 Nov 2024 00:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731199643; cv=fail; b=OSWCUsfz/fzxfpfpizWXrxD96DvseQ9IPkaa0HCIisfP3bDRjS71LzGqWw3slqORhh9OpB+1SESq6IsdKkiD1apkzxL59ijDFK1cP+zflEUeSCRorkNZcPeooiaP/Qlp6sXF1hiSaGLOPkrTjYbCKgapaNVTS32zbCgPeVRZaKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731199643; c=relaxed/simple;
	bh=8RyWsKHtArJ0NzerjtSfozgoUHnktg1fDEpprzirVb8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CKAUG/46tU4Q3Zr8oQnyGzBvtpgLuzlqEz0fyH9CYIqoNYGWguo5qahAWy6v94ok/X9nrnspOPLH3lO2oqbqnWG0sja/lNTMdq4PuNMyzGCc+IWak09gqCiMnkeTjiONto/FO0B82Ob1HDk2HsvEKK6sE+PIdGXKLt+tpvkWF9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.195.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k4d8oPghM8++1ltnOPbNZuN6CXGWvWbti6Rh6kf2W+0lnBIPlYorbrLGvfRzL8Fc4qDbNHPOaX0XzxRHhKpLdWv0Op1n9rnizH4gtQDD2WOYGWzk3Uo/BksdkGdnqfCn/EnU6UE837NX0HxRXb+5rmPROKQWuSxYcr2EE6fAclDRrfKA49Y/rm3vkEsv2Lldf+UUDM7oEMRg0fgmcp2B9RFwoiQqVu+FKdD5DsPVwpCozpQrTm8Db3vaBmUNF+zqAQpffKQslSDHCisF8M3BTCnRFYE0TGcloQXGUElsAA1nIkKJLOC/c3Rm5vaFsm1xUvvdwLH0usRnaM20lnNqLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyMYhz7pJ31V6s8PUlfafvGcP+yoHKBz8DeEIw0kmkY=;
 b=gllCYYE3US9MEbnP//dEZnJIRa+tQ3wN0Olo4czTp0m6BDe/nGP90SJEJz8dZ88UqAP6L/Ep5KP3DvyGMI7DpV6Xnpl+c8kLWKKHfpTEn9poqdOfa2Yptw2+NQE3poPlo+p4JOb+2DnELk2rkAwRVs62ZKDsrohPJXcBKMoKKgJXnB6/Kr5g2brROS1sQ6dYqSUR5COu6wA0DqIC/8eGpFkjlYeoy1WKHqrSz6lS0UJqolEyADNYdsIvyKq9n38Z0+59BoiAUXz0zFy/8SeGQR7Vo2AfiSz3F5KcUlD2HAzw2gnyrPnJAs2MvA2sDgrJ4kRKTQitiSbAAnnLGKQpSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 DS0PR01MB7963.prod.exchangelabs.com (2603:10b6:8:14d::12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.11; Sun, 10 Nov 2024 00:47:15 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%3]) with mapi id 15.20.8158.007; Sun, 10 Nov 2024
 00:47:15 +0000
Message-ID: <de669b49-ae19-4d22-96ab-c0fe4610f9dd@talpey.com>
Date: Sat, 9 Nov 2024 19:47:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
To: Steve French <smfrench@gmail.com>,
 "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath S M
 <bharathsm@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20241007210214.102568-1-linux@treblig.org>
 <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::10) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|DS0PR01MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a21e5c7-d280-46f9-9413-08dd01213869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VU90WU9CYWJXYk8vejFZWGxiSnNqYjh0anhjZFhKWHhRTjBBSlNjcHNXSTJm?=
 =?utf-8?B?RkRDa2tmejAwNDdrckJvQWwzQWphYUxib01pekF0ZU1UUTBhVk5qTGkrbVh1?=
 =?utf-8?B?MFJNMXZOTElMWS9NUVc2WDQ5eC9INFRYMWh5TTN2WEhGZEdVQ1dvaE42Y0lh?=
 =?utf-8?B?T3d3Rlpra3ZkZThxVkU5bGFTQ1VVNDZIU3VqM0NXY2lyWmNFV0FwNjhYc0lr?=
 =?utf-8?B?ZGlUTTh2MUxTS3RpU0pkK3lGck1BS0lSaGs2eVFNMERCdy9TRDNCb09sTi8x?=
 =?utf-8?B?OFFBL3NWUlhubkxRRzRiTmpMMGcwcm82MEVLNE9nYkxaVDA0ajVOUUFNMzhr?=
 =?utf-8?B?RXRPRU51R2hGbGlmNk9veXRMNW92U3ZPWjNGL2dybkdIaGZway8zM0JOcGpi?=
 =?utf-8?B?U3ZFVnljZmdHenk0Z1lCM21lMWVoNWZlWDI4bE11ekFlNVM3NGF6c2c5Y2lJ?=
 =?utf-8?B?NVNFYXZwK2lKM2FXck5ULzQrUHViazZ5TVBNOXZHUWN4YzJPR3FEMU03R0pz?=
 =?utf-8?B?UmZDYXhyYXVPU2NLSnY1ajlQcmpKZHM3WlNHdnNPTDVIMEVCUnR4VVNkNmFm?=
 =?utf-8?B?cFpjbzhpWGhoMkkzcUhDcW9FYklTdE41ZEQrTVJ2WVlLQ085amxtZkVZRS9m?=
 =?utf-8?B?b2h3M3BEdFdzdFpEVGdoc2VMWDJIY29vWU0xWmlSS082VlN5R2drbWU4bjN1?=
 =?utf-8?B?MDlLQzFDaEpJQUpYazZicU1qRU85YllQWVd1aGRJdXFDdlpGOFhhaGY3N3NM?=
 =?utf-8?B?QVZXeEJGMGhyTVFrNitmVHFFOUFTb3BQcTJadEF2SVo4MnN0dHpBb3ovZ1Vq?=
 =?utf-8?B?c00yQzNGQmZWenFrYVdHYnFLRHdCZzhSQzY4ZEdEK0d0U1NVaTZRZTVhby82?=
 =?utf-8?B?RkxZM0ljTFF0ZWpOSFF4czFPTWRxZFd2RGFpUkt4WGFYRDZQZlNINWVRbmJp?=
 =?utf-8?B?K2VzRW9XeTl5VU9DeVBGbUJVdFBLOTkxMGRZSkc0SDhoYy9lb2owbG9EdkE1?=
 =?utf-8?B?Vm5Ga0pBTUNnTDJyU2VLSkFPSEdGSUNmdmdiMjd0VFBaNitDb3V1eXYwU3F3?=
 =?utf-8?B?akZwVzhHUkRscEVMaVBFV2diN3NnV1BWSHg4MmxWMWhHM2tVRHNmY1JqVTBo?=
 =?utf-8?B?dDBTcmFBaFQ4RllmdXdyL3NYbnd2TklBUHpGUVlLY3h2aGdoK1VGQ3Z1cFNs?=
 =?utf-8?B?R0pYbm5vN00wTGhzVDBIZ1h6aHdwa1p0R1pxTmVOSGxoT1c0aWhYNVRmZDFL?=
 =?utf-8?B?aC8zVi83YlFrTE5oNzY5WWF6UEZJeGlIbnBacWxmdHZiL1VJNEZGME43NVVD?=
 =?utf-8?B?Sm5WcWpVL0JKTVhlWlY4ZGI2TEdaUjBTbzArYW9ScjhJZ2o2THZBVTgwdmVx?=
 =?utf-8?B?R2VrTG5HbTJNWS9HdTU0MkNTL0FSSHhtb2NrOTBmNnVvcjJJcit0SGVDQVRG?=
 =?utf-8?B?M2NwSWNmelVxN1hwV2xOMlVmR3VuUmprd1dHdUtJRVZ1Zzd1RWp3Um5OR2Nr?=
 =?utf-8?B?N2c4cG9jdTExeEdBNjZuTmE4ZTN6YVBlNno1UXVDTVdDMTg4bVkwbWhwVGUz?=
 =?utf-8?B?clpHbzBVcklvcjNLZFB4TkNNWWtyTjlLOFNkUFNkZWRHaXBnM1N3TThWMVRa?=
 =?utf-8?B?OG1laGtoVlM5QS96eG1rVTZmb2N3T1hsRVB6ckJMaEN6UFRZVlE3QksxUUNT?=
 =?utf-8?Q?oTbGUUr1PKIKpXEhhZSN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aThzRXB3cVBNLzR4THlwRmVoNGl0cFZFTDU1UW1yWUpXNzhTYmJjK2FJaXJ5?=
 =?utf-8?B?ZjFYcUxtLytjYjZnZFNETlN6TEtwdkJoU0JRcmdxUURZYlZia1pXc2J5K3ZJ?=
 =?utf-8?B?M1Z2c3NlQlNoNjNtbG1CN0puRlN2ZWNkZU0zV05xWkRkVVRYb2c5TkZJdkF6?=
 =?utf-8?B?RHdWbkM3VUFBSHZwbUdYSm9VUjhnRjJMcEVlbC95NDFITmZGNkxCYVM4ZTVi?=
 =?utf-8?B?SkZ2Q1dTT2dmUmNHMXRzNmZCdU53Q1B4anB4RXZPTVVOR1hjdzE3Tmw4Tmc1?=
 =?utf-8?B?VVJuSERMQ2xwMXBveEw5NnR1WWw4THUvVzFpdldGSjdmMlFCeE5xbWlZYmJG?=
 =?utf-8?B?TmRYNVVNdVFHUmROSXl0eFdqd2YySjlGaXByZDlmUVFDNXB4MzVkZy9JZ216?=
 =?utf-8?B?SzVLTTRaazluSGVESzQxeUVSdWkyQUhuUFo0SVFGR3d6dndkYm40blpvRUx4?=
 =?utf-8?B?cWVadXBiT1BNSkVKMkc0ZEFxRHhiT2FDMUVYNTBaQzJDYWxiZnFGb3VKK05q?=
 =?utf-8?B?NEdXLzNmSFNBdE1wdVVEbmpFTDdMV0FHQk1UTi92U3VqR0s3UUgvMXBjUDYr?=
 =?utf-8?B?Wk5DZXpHOHMraUwwS1Riai9UdGd2ekdqTGI3a256S0c2TVhabThBRXJLNkc3?=
 =?utf-8?B?U2dqQVE3ODNpbXltOVN1M0hzVUpJRmF3WTdSaFI5V2tCMlBtb3NBN2oyanU4?=
 =?utf-8?B?Z24rdG1ETFNWL3dsTWdIUFFyMXYyelpvdDBtbVpKMHd2VUFGbmlEd2FndUgx?=
 =?utf-8?B?eFJCZC9Ic2Rlb2NyQmcxZjNWZ2Yyc21Ua04xSEhYVmprbnhqME8yeFFJbVIz?=
 =?utf-8?B?bjEvL2lIdXpiSElCOXRsYnp0eGVNQnVpVnpVdU42QVFEdFVHcnJSZitqK282?=
 =?utf-8?B?aXljNGVXckh6aU1CdGZkQi9Wb3p3UHBnTlZ4aHM5SEZGbmNXMG9jYTNDYUNI?=
 =?utf-8?B?TGtYejBvY1RtN2hlL0NKMjNva0MwR21QOWVYZjRpNEdmeHliZzZxQS9IQ3JG?=
 =?utf-8?B?cVVWajdveHZpUS9oelYxR2xHd2dFZ2loTGdZUFJ6WlFhQmZrVTE0MkJDbmo2?=
 =?utf-8?B?QmozQzd6SURWVTFzMWVFblp0cEJhSVhYVFZuRXdTM3cwaVkxS2JaVkEzbUNn?=
 =?utf-8?B?bERIRUFHdlZ1YkJiKy8wQnNVTE1WN0pid1pCeisyZnZHYW10aU82SWJQa29E?=
 =?utf-8?B?Q1MvVDZqeG9rMWRpTVpJUzdkVGdEcGRjUVZsTFNLYk1jRmRpMUUvd000VE01?=
 =?utf-8?B?N3lNa1crWkJoai9TTTJxVFVQZXBJZkUxOCtYUzZ1aGl0ZURaV1ZZRzVVT05F?=
 =?utf-8?B?Mm9PQkJ3WVBiZzhBbkp4L1RhRGIvMjZrNHBqbEg5aGF4S28vRmthL3NjeTZq?=
 =?utf-8?B?V3ZnbWd3aTNwRzRKdnFOWHJzUzF4bXBrWlFHekJwZEh0VW9IMnhqdjI1K0cv?=
 =?utf-8?B?WnBFbDlFd0RaS3lpem5HenJmbUFiNzRwMFR5QTF5OGxmTndaSXNYWkZkcDRV?=
 =?utf-8?B?dEtrRU8wcWlZb1Z6N011RUY4K0FpeEFQOHhKeUF5OU1Ec3VzTkRqa25KcVNT?=
 =?utf-8?B?RGU1RDJCWlVRSTRQTTJtNEJ1NG53TzdoR1QwSkI4OHh6Z2RQMnBjaEQ4ZnV0?=
 =?utf-8?B?MHhkOGVQVHYvODZnUDRBMkUwQm91M1pyblpzd0lSdXJZbHYvTm5hZHlWdnVP?=
 =?utf-8?B?K0tVTWNMN3lvQmtSUWFSdlhERkFkU3dXRTNkVTJsaUw2ekR4RHBYMGVQcEhG?=
 =?utf-8?B?TEZRVUF3UklYSXdZOGljN1U1QkVWSXRNNlYzc2J1eEs0U1dIQ3VBc0lFcVh1?=
 =?utf-8?B?aGxGYyt4RTBDUkRFN1RMNndJWmdhWW1PTGdOcnk5UzU1ekNYdnp4Njl5U0dW?=
 =?utf-8?B?VThhLzJ3ZmEzUThJZWR6SVFTN1FYSTFzOW5tU0l5Lzhpb0J3MmNsZ3o5UHRu?=
 =?utf-8?B?RmRGRXRxaXBZcCt4TkRrK0MxcVFlTzBJenNKTlNSYU15TnEvOVVHRDNxdjNl?=
 =?utf-8?B?dlVYTVczck5WWHU0YlcrZ0ZoRHVtcHY2czdpS0JRbGp6Rk4zakNPNjNtTUh1?=
 =?utf-8?B?dEVEZVRsaDJ6TGh4bWJRYUQyVDllVDdmWktkUUlXaUJjd3hUZzVrR1h3TUpD?=
 =?utf-8?Q?J9eo=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a21e5c7-d280-46f9-9413-08dd01213869
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2024 00:47:15.0491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2BqZggKMPehnLrD6cMtqB2AVzBe20q17RplQJVOYKHdBIlF821NwmmGM5tNvO2fL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR01MB7963

On 11/8/2024 11:09 PM, Steve French wrote:
> As an alternative, might be useful to see if this command still works
> to Samba and/or older Windows (and e.g. enable an ioctl for it - might
> have been useful in the past to old servers)

Please let's not do anything to enhance usage of the hopelessly
insecure SMB1 protocol. Especially not with something we just
found in the back of the closet.

The MS-CIFS document has this to say about SMB_COM_COPY:

2.2.4.37 SMB_COM_COPY (0x29)
This command was introduced in the LAN Manager 1.0 dialect (see
[SMB-LM1X] section 9.2.1 and [XOPEN-SMB] sections 14.1 and 15.2).
It was rendered obsolete in the NT LAN Manager dialect. This
command was used to perform server-side file copies, but is no
longer used. Clients SHOULD NOT send requests using this command
code. Servers receiving requests with this command code SHOULD
return STATUS_NOT_IMPLEMENTED (ERRDOS/ERRbadfunc). <51>

<51> Section 2.2.4.37: Windows NT servers attempt to process this
command, but the implementation is incomplete and the results are
not predictable.


Deletion-Enthusiastically-Acked-by: Tom Talpey <tom@talpey.com>

Tom.

> On Fri, Nov 8, 2024 at 10:06 PM Steve French <smfrench@gmail.com> wrote:
>>
>> No objections to this from me. Will add it to for next next in the next few days so can queue it for 6.13-rc
>>
>> On Thu, Nov 7, 2024, 3:11 PM Dr. David Alan Gilbert <linux@treblig.org> wrote:
>>>
>>> * linux@treblig.org (linux@treblig.org) wrote:
>>>> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>>>>
>>>> CIFSSMBCopy() is unused, remove it.
>>>>
>>>> It seems to have been that way pre-git; looking in a historic
>>>> archive, I think it landed around May 2004 in Linus'
>>>> BKrev: 40ab7591J_OgkpHW-qhzZukvAUAw9g
>>>> and was unused back then.
>>>>
>>>> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
>>>
>>> Ping?
>>>
>>> Dave
>>>
>>>> ---
>>>>   fs/smb/client/cifsproto.h |  7 -----
>>>>   fs/smb/client/cifssmb.c   | 63 ---------------------------------------
>>>>   2 files changed, 70 deletions(-)
>>>>
>>>> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
>>>> index 1d3470bca45e..8235b5a0aa2b 100644
>>>> --- a/fs/smb/client/cifsproto.h
>>>> +++ b/fs/smb/client/cifsproto.h
>>>> @@ -549,13 +549,6 @@ extern int generate_smb311signingkey(struct cifs_ses *ses,
>>>>                                     struct TCP_Server_Info *server);
>>>>
>>>>   #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>>>> -extern int CIFSSMBCopy(unsigned int xid,
>>>> -                     struct cifs_tcon *source_tcon,
>>>> -                     const char *fromName,
>>>> -                     const __u16 target_tid,
>>>> -                     const char *toName, const int flags,
>>>> -                     const struct nls_table *nls_codepage,
>>>> -                     int remap_special_chars);
>>>>   extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *tcon,
>>>>                        const unsigned char *searchName,
>>>>                        const unsigned char *ea_name, char *EAData,
>>>> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
>>>> index c6f15dbe860a..ca50ac652e02 100644
>>>> --- a/fs/smb/client/cifssmb.c
>>>> +++ b/fs/smb/client/cifssmb.c
>>>> @@ -2339,69 +2339,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, struct cifs_tcon *pTcon,
>>>>        return rc;
>>>>   }
>>>>
>>>> -int
>>>> -CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
>>>> -         const char *fromName, const __u16 target_tid, const char *toName,
>>>> -         const int flags, const struct nls_table *nls_codepage, int remap)
>>>> -{
>>>> -     int rc = 0;
>>>> -     COPY_REQ *pSMB = NULL;
>>>> -     COPY_RSP *pSMBr = NULL;
>>>> -     int bytes_returned;
>>>> -     int name_len, name_len2;
>>>> -     __u16 count;
>>>> -
>>>> -     cifs_dbg(FYI, "In CIFSSMBCopy\n");
>>>> -copyRetry:
>>>> -     rc = smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
>>>> -                     (void **) &pSMBr);
>>>> -     if (rc)
>>>> -             return rc;
>>>> -
>>>> -     pSMB->BufferFormat = 0x04;
>>>> -     pSMB->Tid2 = target_tid;
>>>> -
>>>> -     pSMB->Flags = cpu_to_le16(flags & COPY_TREE);
>>>> -
>>>> -     if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
>>>> -             name_len = cifsConvertToUTF16((__le16 *) pSMB->OldFileName,
>>>> -                                           fromName, PATH_MAX, nls_codepage,
>>>> -                                           remap);
>>>> -             name_len++;     /* trailing null */
>>>> -             name_len *= 2;
>>>> -             pSMB->OldFileName[name_len] = 0x04;     /* pad */
>>>> -             /* protocol requires ASCII signature byte on Unicode string */
>>>> -             pSMB->OldFileName[name_len + 1] = 0x00;
>>>> -             name_len2 =
>>>> -                 cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_len+2],
>>>> -                                    toName, PATH_MAX, nls_codepage, remap);
>>>> -             name_len2 += 1 /* trailing null */  + 1 /* Signature word */ ;
>>>> -             name_len2 *= 2; /* convert to bytes */
>>>> -     } else {
>>>> -             name_len = copy_path_name(pSMB->OldFileName, fromName);
>>>> -             pSMB->OldFileName[name_len] = 0x04;  /* 2nd buffer format */
>>>> -             name_len2 = copy_path_name(pSMB->OldFileName+name_len+1, toName);
>>>> -             name_len2++;    /* signature byte */
>>>> -     }
>>>> -
>>>> -     count = 1 /* 1st signature byte */  + name_len + name_len2;
>>>> -     inc_rfc1001_len(pSMB, count);
>>>> -     pSMB->ByteCount = cpu_to_le16(count);
>>>> -
>>>> -     rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
>>>> -             (struct smb_hdr *) pSMBr, &bytes_returned, 0);
>>>> -     if (rc) {
>>>> -             cifs_dbg(FYI, "Send error in copy = %d with %d files copied\n",
>>>> -                      rc, le16_to_cpu(pSMBr->CopyCount));
>>>> -     }
>>>> -     cifs_buf_release(pSMB);
>>>> -
>>>> -     if (rc == -EAGAIN)
>>>> -             goto copyRetry;
>>>> -
>>>> -     return rc;
>>>> -}
>>>> -
>>>>   int
>>>>   CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>>>>                      const char *fromName, const char *toName,
>>>> --
>>>> 2.46.2
>>>>
>>> --
>>>   -----Open up your eyes, open up your mind, open up your code -------
>>> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \
>>> \        dave @ treblig.org |                               | In Hex /
>>>   \ _________________________|_____ http://www.treblig.org   |_______/
>>>
> 
> 

