Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B356E0
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 10:55:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9VlC24svO1krWK6fAEPOyNqKMMtTCSQnVTIIwJtF4GYmojpvPfdQvdjHUFLzADHnUIFRz60gbpjdS08bvBz0HNDst0ctHZQ0aDqiRG2Em+BJy5T9Hl2zxWLEJ0/vzVxbA2dMbuTYTGCTi8xnC3p6H4no8sZwyPpsG/RQMmsev8gxYyQnZAdUQlsZ1KmJkjrlvIiLP57FeG8OZ6rxuUKbZoVL6WdhVJZJDOCa976a5N/o9/YAu+8UZQzoWnI7G+Io4c/9bBL8DjEuVNOEOC+SauwhnKjQ5v8imOghDjMkEInxRS2CUMX75enCcbq3DGUUByKmYr6VrdCU9E9nJ+sIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5u8e9EbJbE9+qx75ltepisAGSw/OryzvAWVgIHQYNmU=;
 b=RDKezpPoW4aQm+iDeyCFVSaZyGZNocgeEKLlRS7wAg/ME8s3gEKZoDnCTM9EnL9vE92oBaFrFfUrpLnh1ZMUmccSbvZhM9Xp03ki+sPlX4eXcKvl0FciulECGNd+5jVb2IrOtjnNqfkKUWb8PPXlVnd2LcHXPpdpuY1dZMmnKcCtAgPmQWV6TUNIc053Z9DzuVVXup8Mst46H+yXRGy3l3a5tO6eozLkpPi0evwW1CO1MIGgX5qRtK2AX5JDsrYJ/sWY7uxKIrjeyfOxZykl9q9OSm4du1WHmcXgauwhqwq89XPui2jK3MTFnkZw/X02foQ4PzVAgjfaa2ZukcUmyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN0PR01MB6896.prod.exchangelabs.com (2603:10b6:408:16b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.28; Fri, 8 Dec 2023 18:55:42 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7068.028; Fri, 8 Dec 2023 18:55:42 +0000
Message-ID: <2f21c53c-c374-40d3-b9ff-f2af8ec219cb@talpey.com>
Date: Fri, 8 Dec 2023 13:55:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: Lease keys and hardlinked files
Content-Language: en-US
To: Steve French <smfrench@gmail.com>,
 samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N
 <nspmangalore@gmail.com>, meetakshisetiyaoss@gmail.com,
 Meetakshi Setiya <msetiya@microsoft.com>
References: <CAH2r5mtK-JQeH5gLoGjUS5sywfd-KTJhnF_Mf4c+KCoapMEPhQ@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtK-JQeH5gLoGjUS5sywfd-KTJhnF_Mf4c+KCoapMEPhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0036.prod.exchangelabs.com
 (2603:10b6:207:18::49) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BN0PR01MB6896:EE_
X-MS-Office365-Filtering-Correlation-Id: 96b884b4-a101-4677-7f97-08dbf81f46cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a5a6q6WfuafpjUGYyMuaLM3tV6OvwHdOy+vCVcQVFiJ06ldVPHf3RVf6qjAE/uLQMtgW9GqM+LZdFdf8rvnWJEG7UO/jR6ak9wMa1c7kw4NV2AYaBOTIJGsRUdEq7KdzeLlBHoLLBhWiEVqmbp/LJRMA5on+Tl4nm1+P+5AHl8IRCXO6IjJh2CQyBupXfGyxHQsAkJdTzaBg5X7IAEr21KmMV1FvKn5AfxEPUjy6MTPnWGf9BVzTJXGw4JgoLkmjm1WTLn/e4l++I86jCTUcQ1d+tshuyCB+cnmIA2icNzLbcbytnu+OTZuWGSsIxDFSsGDuoksu65lUZRCo8u4rZHxoCCOuwpfSY8tb8CX0LnKiGt6uR2UbstnLKlcoPGwaRY9dSue7dS+ySb4jGpV4tQLkduD7qBUjhCE2a47aR2LsKvu7UnXlsfRaEW9MemLw6Fb+J2EqXJwjeNZvZ8TPZIjqUa+8SNUIE2ta0QuXAyhsmQ3K6JevmJRD9/d5d3rrM8wYBFpSHj2T0ePmn9E8/+uYipS4MZE6v8xCbcWlwbtQS6lgPhg36NO/DGfRb6jpwDRP2QHfm/4+/akl7s8b+DXmGjRxDY7tWyMl2USJyS3uY7M90quuyg4Kv4cUrnfm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(136003)(39830400003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(8676002)(26005)(2616005)(6486002)(8936002)(38100700002)(4326008)(478600001)(86362001)(36756003)(6512007)(31696002)(5660300002)(53546011)(41300700001)(31686004)(6506007)(316002)(66556008)(66476007)(66946007)(54906003)(110136005)(83380400001)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkpYSjh0MWgvTHRBRmFXWk9xZWEwOHFBUHRBQUUxN29sK1RVTlFoNmc4QmFi?=
 =?utf-8?B?dHdhSW04MGxrU3loT1k5WGYzRXVXMU1xeWwzZXFvNmJaVkRRaDRqMXVDVGxp?=
 =?utf-8?B?U2YxOXlFaFVhb3lTWVh6VDdSdmNVcjk3cUZIMWxDZndyZDg2UVJZVVFVWVRG?=
 =?utf-8?B?SGZOZnR6SlY3WWZTbEg0UkVJZWd4R1REUnI1ZUlTTzVJN2xzN05vOW0xd1RI?=
 =?utf-8?B?V21RcTRteEdMOUhYTTVoNkcxZFRTdEtlQ3E4MVl4QnJndUJhcDE1NDM5a1Fn?=
 =?utf-8?B?UzcxSEsxYnF6OFNydnJHSEtxbDI1anI5VU0zZXE3TFVwNi9GQ1pCLzdEUjdw?=
 =?utf-8?B?MWdrVXpMYm5CTU8xWWx6WVJFcmpIVHNtbGh2eWZydUJCNEJ6M2VqdzAwTi9z?=
 =?utf-8?B?NVJ2UUIweGhIdm05YzgvVXV0WTlCRVJ3RmxLVEFmcjV6WEg5YUZTdzBEUTF5?=
 =?utf-8?B?b1hUTFBCZTRjb2d0Uk1PYVhEazNzRFp1ZTB1b1NHcjN4WFRzWmphTk92NGNo?=
 =?utf-8?B?R1VCeXVvVnh4MXgveWNlUmRmeDFZYnQvekhpSER0ZDdmNGlrQWMrMTJLZnRs?=
 =?utf-8?B?YWRqb2psdWIrMG96V3B5N1FHL085MUpUWi9Rb3lYaG93Q1gwOWR2VEZOZ0sv?=
 =?utf-8?B?MnBxTitEMXlMR2ZzNVZ2aWlnTlJlTkFTMjk5TDRwcVZJUks4SGRva3V0NndB?=
 =?utf-8?B?RUlFN0RpNU04UzBNd0VaM3JwMFN4c1VXQ29mKzRpeEE1Z2hLemxnS1FYMFl3?=
 =?utf-8?B?M2ZSOXpHL2FrNnZrbFJmQXNlRXlmR3J6dmtHQ25NM1I2TDllRHVkUjlsSjRS?=
 =?utf-8?B?eFRPRlBJaExTdkJuS3cvNzY0cnJTMGZ2OWg5S0xyYUZDMkk0VnZVMVJxdGd6?=
 =?utf-8?B?aGQ5eXhINWZyd1pLclZRbXduYWxiZjZVaW82Vkk1YUI5ME9jSTFQWUdlczk5?=
 =?utf-8?B?Zk81d0dTY294Q2hjTEdndFVyOHFEWm9hOVJnSGJFem5xdUlXL3E3Z04yWkVz?=
 =?utf-8?B?d1Vjdkk3Sks3dGlLTlRXUktnVlIvaUQ1cFVSRXlNSzl2SnF3OE1xSW1MM1JI?=
 =?utf-8?B?N2FZdUh0djN1S1E5cVE3a2ZvZXRaeVpkMjk1Y2gyK3ZocTdqVklvRVlRV2lM?=
 =?utf-8?B?Ti9kRWdITUVzZjZHQ1EwMElMQndzZVJxcFczRVhXdHJNRldGeFI5cjJWMkxG?=
 =?utf-8?B?TEhZTUlDRlRESHNXVUt3c2d3emJtWTQyNG1oUnBQTXVySU5vbEU3TmpLWEg3?=
 =?utf-8?B?K21BYXJEVitHYVVQaFZNL0FmNFExUU1DV0syQ2FKT1VwWURGbTVuVTllRVVo?=
 =?utf-8?B?bk55QSsyZzhOTUJhQkhnb2kyQXlOUWpibWx1ZUMyNzJkYUlOaXYvcVlFclRF?=
 =?utf-8?B?MFlYemdMdXEyU2xlMlFEM012SHJFazk2YTljL2hXU01pZ0E3dGhZc1h5TE9O?=
 =?utf-8?B?Wnd2eFVjVTlwdzd0SW9JeXNJSDhDTE1uYVhIL21NK3c4Nm5KY0hlalFVUzcw?=
 =?utf-8?B?eFM1VE1MQlBWWVVEZ1Z3VkY0QVIwSzI4bEJZRXBCZ1gvK0x5K2hMaEZUdks3?=
 =?utf-8?B?UThQd1ZDZW9jK202SllscTNDUEUvdTlSREg4amtTYms2elR1Ui93YnMydm4v?=
 =?utf-8?B?OXRxaW85WEMyeWZyRlhqVC9yT1ZlL2kxQmVtRkVlWktoN2ZaekNWMDdhdExh?=
 =?utf-8?B?K20wNDJ0NDNjKzZKUTVWT2QwUHJXUng1MTRIbHAzRkxOY1JXN3pMVDVialk0?=
 =?utf-8?B?SVJCNk9tcXc1N1Rkb3A1eUZPdjhQNWU4Y3Q1bi9DUTJPaVFJSUZ6Y1NUMHZl?=
 =?utf-8?B?QTg5Yk5WWGgrbm9hSkFRY2hWRGo4SFBBVFpkbjhxa2V5UmVPa015ZERlcVYw?=
 =?utf-8?B?S2VXOHdIQkpsUXVmS3J6YjlnTlFJZklBNk5kS1hNaUxpZXNuOXJ4U1ZiS2I2?=
 =?utf-8?B?aU5EMjl1MjloNHBrTG9sd1FRTmNFa2JIN0JRZ0FzZXZiblhJVkFlZ3dKZklz?=
 =?utf-8?B?NHA4V1RhZVVlZ3ZDRGZ3NzVad0JhUjhKeW9EbXlTK1dkNWREN2VnaHV5OGZR?=
 =?utf-8?B?eUtqNTdmRVpRQUhGb1BNVGxMM3NSQTBXNHBIaS9pOW9VaGp3VXhUdDBIaHdX?=
 =?utf-8?Q?wgDTfXn/4YpFpPO7cyjVq5Tvt?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b884b4-a101-4677-7f97-08dbf81f46cb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 18:55:41.9734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +EF98ZGhaz6yrookX9s5AnOD1ddbBBLE1M3ACPmLN+5AHVVpSATb3cd2z+9dWiCh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6896

On 12/8/2023 12:01 PM, Steve French wrote:
> Following up on a question about hardlinks and caching data remotely,
> I tried a simple experiment:
> 
> 1) ln /mnt/hardlink1 /mnt/hardlink2
>     then
> 2) echo "some data" >> /mnt/hardlink1
>     then
> 3) echo "more stuff" >> /mnt/hardlink2
> 
> I see the second open (ie the one to hardlink2) fail with
> STATUS_INVALID_PARAMETER, presumably due to the lease key being reused
> for the second open (for hardlink2) came from the first open (of

Ok, so that is a client bug.

> hardlink1).  It would be logical that leasekeys depend on the inode
> not that the pathname (so could handle hardlinks on the same mount)
> but that appears not to be the case.

Logical, maybe, but the client's inode is not any business of the
server's.

> Interestingly the case when two clients access the hardlink (or eg.
> nosharesock mount to same share on /mnt1 and /mnt2) works more
> logically:
> 
> 1) hardlink /mnt1/hardlink1 /mnt1/hardlink2
>     then
> 2) nosharesock mount /mnt2 to the same share
>     then
> 3) echo "some data" >> /mnt1/hardlink1
>     then
> 4) echo "more data" >> /mnt2/hardlink2
> 
> What you see at step 4 is the open of /mnt2/hardlink2 generates a
> lease break of the (deferred close) handle on /mnt1/hardlink1 from RWH
> to RH, and the open of /mnt2/hardlink2 is given RH then after the
> write to hardlink2 you see a lease break from RH to none as expected
> before the close.

That's expected, by design in the protocol. The issue Shyam and
Meetakshi were attempting to address is that the lease break can
cause a storm of dirty page pushes, and crediting gets in the way.

Which may well be a second client bug.

Tom.
