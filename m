Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159512C842
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jan 2024 21:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g6uMbQSPuo5nQsbRFEXFnJxBq5UpaTRrxblMP9SOr1WIGfyKXaKlm7Itkv8/Or18RCvy454/Hv5b+MHNlznkT5ch2k4whm31idAGhWUhNfp3y3pOE4a3Qk8aEnRPYNlb9oCDXvuaGTn4VD8ShAhTk0icWzJRwXHcuCROI8mTiEa6QmMzfdqTjt38FUAa1gNxQKZz9nRh6q/neuzhqQZdYOzKcI1GUf7bMpOXY89cnYYiAk4bVLUhcY9Lycj6Nte3Y7/ak1nlyjqp1VcKU6lPrsA/RRPfjUQgtiuo2C93rSdw3xXuBMxXr+VPnn/EYwCjp8lt91daoUbqTFayUmAVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oj5VGISg1uSQUAoxHYrr8C8wX3YNV4yMWoY9sGcivCY=;
 b=RTD8MeYAHLA0Gf4rM39+jiVCnpzVd2NyAupaly4zkaio+WdIRVof70ejtsV3kolXtS29GBFRKez3o03BIgP/E16ve3Q4rzlfSpbGAMEJZ0+L3+mtL4SrYljMIcccd9/OqonDSVcmp3VcYXmHNEPVpZ5xHzBFfWyx+TYJqyXUsnX8Y9zHbQCuvkGlLmsDvdMQp2m6bFXu7voewTLynEGKnWHLejmW6GvntYiHr9a8Ifqxss/CetXzXiOpze8Kji1L73msO2zBIcNokF1V0EVxF02NYSkPf2KbARQwpBYMGAfJkZjJIOPQ6mKHybz2qY8q78qf0zsIOMoePIe3LZCPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN4PR01MB7471.prod.exchangelabs.com (2603:10b6:806:202::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.15; Thu, 4 Jan 2024 21:09:40 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7159.013; Thu, 4 Jan 2024 21:09:40 +0000
Message-ID: <62eb08fb-b27f-4c95-ab29-ac838f24d70f@talpey.com>
Date: Thu, 4 Jan 2024 16:09:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: retry compound request without reusing
 lease
Content-Language: en-US
To: Paulo Alcantara <pc@manguebit.com>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: sfrench@samba.org, sprasad@microsoft.com, linux-cifs@vger.kernel.org,
 nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 samba-technical@lists.samba.org, Meetakshi Setiya <msetiya@microsoft.com>
References: <20231229143521.44880-1-meetakshisetiyaoss@gmail.com>
 <20231229143521.44880-2-meetakshisetiyaoss@gmail.com>
 <7e61ce96ef41bdaf26ac765eda224381@manguebit.com>
 <CAFTVevWC-6S-fbDupfUugEOh_gP-1xrNuZpD15Of9zW5G9BuDQ@mail.gmail.com>
 <c618ab330758fcba46f4a0a6e4158414@manguebit.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <c618ab330758fcba46f4a0a6e4158414@manguebit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::33) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN4PR01MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: 8977a49a-da9d-4be0-e6fc-08dc0d697704
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6Jq5PDKfYhdZf2clgESgDIUrv0uu54jIg+9A9mIf9rkww+3rBWwTikH3zGp67A8Q4Fk/4SFgFFLXQnjUVGr/bTLFmvOK9pcWq9AjAh/5XSLyjUoh9tez//S2iQRbwRcmhNX3MifNbAo+Mol1JZhotzXzHfFbKEP+3PFNWAaJMSg7FaQSdOXzgeEHgaqCLh2XX/KvX7+WKfgD7K9ZUzUY5Cxu1COMzuOHA+Cw5kNuTJSujUtRYm2mhsqcjsN8zgMf/9Hfdys50P6kTi3axXT6jDTHfSnlsMHacx3OFbGs/jngJrXxIUgZ604lI3Ki7g2HkQHl9YozefRKV2HJGJVDglX5DpbJfl74soUYhnxWY6TstC7p+AQsSeP/4M9WX5+WqEozICOpSUE6crXO5vy+U+jv80cZxggKVVEkAB1Xj3GzC/lccWDqaWVbPWByPuKAX5O8/Pb+1kWtHrfHOp5j6a6MmFyYoT5TxZMLzzADZTBdgKuia9+suM+LfBhCYF+CYPgW54O854WvMMlZRLKvmYVuyf5+hzoiCHI21VQYRxpF9SRqtJV3oSe+FkVAQLyWnjUTfwJoH9g9rPXJGcQgEF4nNvaIaqmZJMRXaCqoc4V6rxXRgziC3JJ7PVY/+1eK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39830400003)(396003)(136003)(366004)(346002)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(53546011)(26005)(478600001)(6486002)(6666004)(6506007)(6512007)(2616005)(66476007)(83380400001)(2906002)(41300700001)(66946007)(316002)(110136005)(66556008)(4326008)(8936002)(8676002)(5660300002)(38100700002)(36756003)(86362001)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek1xOVMxd1ZBS2hIdDl2K0g3U3JZVnlLZkRqMWhla3R5QVFiTjdFU20vTlJD?=
 =?utf-8?B?Q0wrWGVnZFM3WWF0NWpIdG1ER20xekN2eDFxRzg3aEdQclZzd2hQVU4wOW1Q?=
 =?utf-8?B?YUlxcE1rWHF4K3BVd1l5NE9IYkowY3UycDFtMWxtTFBBUHltYXI3Q0crclF4?=
 =?utf-8?B?M1VhNHZqVDZtME80aG93bXR6Mmh3WnlrUzJtZGI0WTZiK2MvdnNGTHBXa0pl?=
 =?utf-8?B?MDRFRXowbkJ5Vkp4Q3M5N0ZnTCtwQ0VsWWgwV1RycHZTK2xhM00xMVpjclpy?=
 =?utf-8?B?YllkV0xmVFFhRzAwL1Y2cWNBWkNxdXBWRTVQUFkvMmYvRnRnNmRQcjZrR0NX?=
 =?utf-8?B?TWR6a1E1WlZnRWxLb3ovR2lCQzNVUm5vMnJvY21vczZveitYNUtlNDBRM3hy?=
 =?utf-8?B?NkFqYjJycURsUDdvQWcxWkVNRVZlY3UxR1I5ajhFRTFOSzF4cmZTbWN3T1l4?=
 =?utf-8?B?VkN5MDF4Nm9hR0hJUFFYVWdLTGNxT2gyTWZIanhlNzlwcE1YTDE3L0dROXdp?=
 =?utf-8?B?ZWtjSSt0Y1ZoeFhRNUJ0T1pTdWM5Q3NqSzNjN1E5M1hxN3AydWdyNFlRZEpW?=
 =?utf-8?B?UmdmQkxsSzhTbjVnK1JSdVdGakZlS3pqY1VoMG9aUnBVaXd3UlZDMlRDMDYy?=
 =?utf-8?B?WjRJZGtCbWppemIvTEVBa0tFM0RpSWJPdkFiYTdxbHJRNWR3blh3QnhieFNk?=
 =?utf-8?B?K1NaVDZYS0l1YWRWWnJOVWNGdHBsKzVQZjZjVldpV2tXVzlYMWxEcDZsd3I2?=
 =?utf-8?B?Y0IrSFlkRG00elJWS2dXM2UvT0xjSk4rUGtyTHlHbDBSdmxhSm5rVmtaSDBs?=
 =?utf-8?B?WVFtei9XVkppalVaNXlMa1R6dEhoNzZ4cEFDeFBCbThJWnRNcktrc3ZTWCtk?=
 =?utf-8?B?LzRjQmVUQUhMM1ZtRUdJRVY1ZC9haXpjek9QejFIV3lHRitFaERLcnFvY2d4?=
 =?utf-8?B?bFRKdDZiSmlOMU5mdXdaY2FTbGZJMFBUMmdJTWJpeTlwSFBSblJXeHBDVnV5?=
 =?utf-8?B?cnlhNFRVTlNIRDZwblAzakVpZytQQWhoVlQrMjEvTkZxSXFuZDNwNHZJNUpU?=
 =?utf-8?B?TWtzZC9WSWtYWFl5NTlSU1IvaFNWVGxOZVZUYU9KcTNHVmhXT1NiSWlaUDMr?=
 =?utf-8?B?VFZoSUNTUUF0aWdCdzUyMUp4TWdCUUN2OUhZdDZOOE5meHJvSFREbWw4eDJv?=
 =?utf-8?B?RUxnbnBrMm02TDJRNGw3dWp6MEVGZitoNE1tVitYVDhTN0hPUW4wWDZ3S1Y4?=
 =?utf-8?B?RkxNZVNhQ2tnNFdRakNkK1dHMmQyV2xQVCs1QVAwWk81c0NUV3h1cDJGS3Ni?=
 =?utf-8?B?ZW05STk0YW9yQUErY3Y1Q3pjZFJ0OHczblN5endPekhabUswcW1QaEtQT0t5?=
 =?utf-8?B?bnBRNXdXODFieGh2Ukc2K242SlBQTU5USDdHa0xaa3JPaWhDMi8rMVc4eFEv?=
 =?utf-8?B?YlFUY1JtU3JwOGlONUZxNTk4NGtCSFppaVM0ZDVlY2MvZ3FsOWdyd3F2ZEU4?=
 =?utf-8?B?NEk1WEZyY0sxbnhGV1k2MGt4TEhEQmJUUEVKbENpTTFLQlVGOEZqWDlsNTZw?=
 =?utf-8?B?b0gvb0dQVXB3VTd3R1BHN3pVeHkvYmxWVWVFUWNQekt4azZxNzBpZStVZ2Ey?=
 =?utf-8?B?M3Exby9QaVVlckNSaGtNUjlMc2FXU3gwd3lEZGNKY1dZSDAvOUR2VHJVTnlw?=
 =?utf-8?B?eXprZWxSa0Yzc0M5VWtTcE52b25xellYYTBqcUpSV00yKzErcEtnTGh1K3Yr?=
 =?utf-8?B?bmFhbVRRM1FZbWVRYnFMQXdFa0JsRU1zanlDSHU3dHA3RVlJUW53WGRtQTZU?=
 =?utf-8?B?UzJoNi9Wb1M0WjdmdGFLeFJ6WmNnK3pVdjRZekJqWHdTMDRXY3hneVBZaW1v?=
 =?utf-8?B?S3FTUElsZ3IxdjRJUlVjUG9udWMrUk1UWnBWTUZ6TVlUeEdVQ0xva2IvRWM3?=
 =?utf-8?B?cXRwNFhaciszc2dUaTlwRyttSkUyVzE5SUxQVUNUTEl4Vm5UYmNHYzk5ditV?=
 =?utf-8?B?SGhlMDEwdlhuYVBGZVFqVTJDZDBOaHUzTVBVUUhjc2hlNEQ2aTkreUM4RlY3?=
 =?utf-8?B?VGVTWU8vTkJ3Q3FFKzBwTlBzdE56VEQ5d3B3TjVEaWdpM0V2dndrMjk2ZDBL?=
 =?utf-8?Q?sSPSXiePMMqGW9oNXVgqw/Ghi?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8977a49a-da9d-4be0-e6fc-08dc0d697704
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2024 21:09:40.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4O8dvJHSSYsErFdM46uhMAt98RZNCU/WQzfIg7tPYxs6s3Qd5kYhWCwBNknu5dY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR01MB7471

On 1/3/2024 9:37 AM, Paulo Alcantara wrote:
> Meetakshi Setiya <meetakshisetiyaoss@gmail.com> writes:
> 
>> As per the discussion with Tom on the previous version of the changes, I
>> conferred with Shyam and Steve about possible workarounds and this seemed like a
>> choice which did the job without much perf drawbacks and code changes. One
>> highlighted difference between the two could be that in the previous
>> version, lease
>> would not be reused for any file with hardlinks at all, even though the inode
>> may hold the correct lease for that particular file. The current changes
>> would take care of this by sending the lease at least once, irrespective of the
>> number of hardlinks.
> 
> Thanks for the explanation.  However, the code change size is no excuse
> for providing workarounds rather than the actual fix.

I have to agree. And it really isn't much of a workaround either.

> A possible way to handle such case would be keeping a list of
> pathname:lease_key pairs inside the inode, so in smb2_compound_op() you
> could look up the lease key by using @dentry.  I'm not sure if there's a
> better way to handle it as I haven't looked into it further.

A list would also allow for better handling of lease revocation.
It seems to me this approach basically discards the original lease,
putting the client's cached data at risk, no? And what happens if
EINVAL comes back again, or the connection breaks? Is this a
recoverable situation?

Also, what's up with the xfstest the robot mailed about?

Tom.
