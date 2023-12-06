Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BA3C7
	for <linux-cifs@vger.kernel.org>; Wed,  6 Dec 2023 05:42:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xb/7P0SyRuor8KI/M3ISCzUEeIjZo8r810zdNzWxafGFqGDfWLs003xK55OvQ+zOBt5FX7LDmhgGU8fj/4+yvAHSJ/GDBDa7eJ2Jt5ArrEdIF6RSqS7f/uLFw4d0uoA3SEU5gjmOXG11QWyB3eA/N317RBY+DwU0g+Cc0yUicSdO8HSYxwieaT8dt+qwzLT2pZg4BNPBpoXQIjkPzeXvaJRU15r0dNVDyz1dYNZFhJz8iLF5fe/kw41kZL6J9L5iYyBZ9aSoHd753vaUKCS5ksDoQImBGgDGxVSlXyJPg453hKm5Ci/5eYmLMADBrK7+iQ66KtKV6KxNsVJ4G5zDxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YXPQ1Nrnv5KV2hfwahxaxmbWQmy/t+s3yrytlMPVajs=;
 b=NDErgl+9CyCI+srAWT7oa8rWZl1RdBGCh1hVoPIqLS9iHiTvnwMnFIppvkyOFKwM4SkfV43Vb0iN1RiKwBT7AGu+I0y/QQO2OOSrQeWzZTx2/rvzak+Z/Gy9hSLkk626XMWWbhrRWuE78mm971Pb8GTtJfosOjCRoT38MxREaUGanxE16+R4ohE0VivuJ5VLb+qDGURZvX1MCJdBOi6L/jDuwK+M7+TEnVkX+pAC+7xNZH7rSoH8JVEnvRj4BeiJbYj0Yobh4Ac0/iQSauoAq5ttCxuTfjwsaUAa73CUw+Vd/20jRDQe4KMbqtdVdKXD1EB6C3GFx6EHvLogG/rqRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 IA0PR01MB8398.prod.exchangelabs.com (2603:10b6:208:480::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.25; Wed, 6 Dec 2023 13:42:31 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7046.034; Wed, 6 Dec 2023 13:42:31 +0000
Message-ID: <9980a249-043c-4140-a5ee-bc06cf156747@talpey.com>
Date: Wed, 6 Dec 2023 08:42:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
Content-Language: en-US
To: Shyam Prasad N <nspmangalore@gmail.com>,
 Paulo Alcantara <pc@manguebit.com>, meetakshisetiyaoss@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 lsahlber@redhat.com, Meetakshi Setiya <msetiya@microsoft.com>
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com>
 <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:208:32a::27) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|IA0PR01MB8398:EE_
X-MS-Office365-Filtering-Correlation-Id: 410789b0-eaf0-4647-888c-08dbf66131aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KaOJJYFwgn7K//I2D70vl1s+V9vbSSgUdB+LqDevo/JMO4Z9E4Zc5Jh3sbi4vQnhCWRi0iK+gcnuO6Clf3NIOvjG2EzUuPcFoPR0+cHQ3znjkjI+7cDqbJB4bwI62UPZfZAnP4vKp5156B0nRaMzwbZYLCpy7tUJYrFcca+D5gniMI1aIdQEcgF3TXU7yGzwCfhmsB6ZxgTvdY7m3dlRWYrveEiJgCdLo/NHveEAW1gYRwa/DFt7PaXWGOlLqvoT6rOFj+b5HxFt63pUYcENmzKCWMFt6isE/VI6ZW4EdTiGZ86s9UFnMH2E1pInXgKEOcdNHxnjh6FqARCwN41zgtvmaJ08qNRQ6dOXc7jrhOuXNTF1QeU0J3yF9g56nQKUSEpYVRICs9yuUTaQfliF354L4SNJVAnWrEvGSTC7bwS5IbUnhvljvpkQJvxJE08QbP1rgy3NIbN8XkHt0Qf+aBWLpjOZB/0hmF2uoVgTOk6BjdFGKxSLez1eq1yklwkJ6HTzrgjDNyeAwLQfvdCb3Tib1gGr6itA2ZzI5d+qs/hEAuZrZV8T4NNPMVu4jxOkZN6GbVhN7uemCTl7FoP4sLFYyaG8WY6dvS5L26DKmvV5vdlpUCY49HukNBA9SpI0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(376002)(366004)(39830400003)(396003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(2616005)(6512007)(110136005)(316002)(83380400001)(26005)(66476007)(66946007)(66556008)(478600001)(45080400002)(6486002)(6506007)(53546011)(6666004)(5660300002)(31696002)(38100700002)(2906002)(31686004)(41300700001)(86362001)(8936002)(36756003)(4326008)(8676002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUFhUVdrc2ZXbDJvMkhGcHFReUZHWWw3KzFYSWdKS0kwdlpiZVVRRExwa2Vv?=
 =?utf-8?B?K2lJaHd6eWZOUGxqMUJMeVdwNjNESmxJZHI5VnhwaFNqaGE0V2d2YjVZVHd2?=
 =?utf-8?B?OVVodzZWNlN6V1FVZ2tyZGpkOE9JM0M2YnBOMnlrMklIaXhrd1NIUWJjMXov?=
 =?utf-8?B?dkFKZGpabkZ6T09lS1Y0SGl4azZMUWd1ZE9Qa0p0d1pKcmRNSW5RSUNSS1RT?=
 =?utf-8?B?R0xodmZpMnNRbWw5cHdic0JEZ01lYjhUU1pWcVdscE1mNVZQa0x5d3BPbmpP?=
 =?utf-8?B?OXJiODZqdEY0VjNQMXJ1dUUwK0swVzNsQzdNVVZNdUR6TGpZb2dsbXI4V1NN?=
 =?utf-8?B?WFlFN1BrYmYwWHA2WnhDTTZKSzE3T0pGTi9uNDZXV09uTHBZRWt4TDZLMzVT?=
 =?utf-8?B?VDRxNk9VNVNiUEhXQ3V6ZWg0MHZwL2oxYzlTSnViYU5uTXJTK3hMbDRNZ3BQ?=
 =?utf-8?B?SGZ6VGZzcHk2RXh2U0NkZmlRdVlDTUdpbzZ3SjFqRmRPZnUvaUpWaGNtb29O?=
 =?utf-8?B?VjRrODJZcXg0eWZFSFJudm5TQ1BqaENGSlBoaEI4Z2Y5OW9WSGFGaWVVU0xX?=
 =?utf-8?B?SVk4NFB4YVAwQmg2SmhHUmRaVVp5cXhkcUMvUVZzS25zOXgyUW1OZDMwdXJD?=
 =?utf-8?B?aWdYL3FQMmJOMnVwK2hjVlZhaEdPMVN0eWx4TDRDZW9lWTlUekhmdkpFOGE2?=
 =?utf-8?B?NUliU2VUbVJ6WTZzZUpEMldDOGlZNTVmNjBkWGgwN0tUNEZQK0xaM2JmNDdG?=
 =?utf-8?B?Q25rd3IvUU5GczZxVDNFUHozQ3Ztd3BGN2QyazhqWTlHdXdZM2tjRE03MjFl?=
 =?utf-8?B?RkNZaUJpNnJGalhiTkdIeHRnRHpaNTNYNnA5WE5RekdXOUMrTHFaMStkUVg3?=
 =?utf-8?B?Rm5ZZmNhYlh1MXVEVTVhS0ZGK1N6Nk1UTlpISk5mdkdTRkpnVkR1NXFKanlT?=
 =?utf-8?B?WHd4czhrYkY3a1Jtc1BscTlEV29Dd2dkdkpnWHhwTm93V0g3SzFWZGlTSTRm?=
 =?utf-8?B?amRNZ1NxcFo4MHJxbk1hL3p4MWlGY1BnSFZQellVRzNDejFFQ2I4aXYrRVpr?=
 =?utf-8?B?UllvMktwbXdWVTNMK2U0S2o4U1lHdmZuVWNGYVpEMnQwa3VYT2s5alJlUnFo?=
 =?utf-8?B?YmQ0aER4UEU5NnBTVCtKQTNCRVAxcUw1NHRXMjFOeXVvSWtUeUZiTVBnR0xD?=
 =?utf-8?B?eFovQ2VQWUtoY21ueWFPZWF6dUo3d3AvL1lFbUU3Z2s2ZDgrWjdxMlpEbDNt?=
 =?utf-8?B?eVNOaE82UGFTN0JpNjNiZTd5WVFjTG9SYVFrcUR5dVJBQ0Vjc3JpZkVxbFYz?=
 =?utf-8?B?T2xuMU5HM2tZNVF0VW16SlJORHIycU1rWXNsTStPL2dHTG1RaXlyZDZSanpV?=
 =?utf-8?B?WU9OUmtKVER5SXRrYVNDNCttSGtidTVwUTJEME1PMnRaSXpVS0IwWXk1MkR2?=
 =?utf-8?B?eFFib3lqZ0tMRTQ5T2ZLUEhkMnlaYmdMR1Q1NDhLT0hlZjllUTJRWjZvN1ZI?=
 =?utf-8?B?WG9PRWp0ZkpLQ2pUOWR4Vms4QUtkRUJQTXNyRFNXQjQ1WFpyR0YxOHMxenVu?=
 =?utf-8?B?ZmpFeHhUOVR2QmlKR0hpZk9BcmxTSlBzSjNKRldZR3ZubVZPWVBEazlZdEFC?=
 =?utf-8?B?KzZtdmI3RmhvR3N4VzQ4UGVyYWZ5S0ZlUnA5ZGsybGE0YkttWmVSbU5xMnYy?=
 =?utf-8?B?aGxyTzRZTE12YkR2U1BsMHdiOE9UazlzK05EY253d0ROamk1Z1kyYTlLaFR5?=
 =?utf-8?B?M1dXcHJGMlduWjJpZUhXMUxNUDArZnBqU3FsS2ZaSUxZMDRpSjFxSU1EYTV4?=
 =?utf-8?B?LzJxNS9NcmVTYmY4YUoyYm9lTWNGUHJBNmdrTzdNWlZZcFZSYlFuRlV0ZFBi?=
 =?utf-8?B?d0ZlU1E4WjkvdUpoN3lWbkUvMENtNS9sMVBjcEF6UXFkWU55YUE3eFZHT2Jv?=
 =?utf-8?B?NEdmbmFHc0JDdUtsZVY3SHk3eFBucEV0NEdnblVrdjFpUjB1YUJsR3h6dEMw?=
 =?utf-8?B?ZUVheHFxUS9Ca25WMDVGMS94SmlnVUprR2hqaU9sVi9GYUNhMkowdTJVNlJG?=
 =?utf-8?B?MTZmTzh4UXFpclFQWjAwejVueFh4OHcrbTcrbVdLVUFQOXB6YUZ2RzNyU1Rs?=
 =?utf-8?Q?x//aJbPSqvkpipxcI+GekxLKw?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410789b0-eaf0-4647-888c-08dbf66131aa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 13:42:31.0070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TC8Kh7ECkjRmJ5TiFBXPWcqaPlioH41QWRswcRWnqpyjMKZ/iY9+RcdbTnbCcL+q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR01MB8398

On 12/6/2023 12:31 AM, Shyam Prasad N wrote:
> On Wed, Dec 6, 2023 at 1:02 AM Paulo Alcantara <pc@manguebit.com> wrote:
>>
>> meetakshisetiyaoss@gmail.com writes:
>>
>>> From: Meetakshi Setiya <msetiya@microsoft.com>
>>>
>>> Lock contention during unlink operation causes cifs lease break ack
>>> worker thread to block and delay sending lease break acks to server.
>>> This case occurs when multiple threads perform unlink, write and lease
>>> break acks on the same file. Thhis patch fixes the problem by reusing
>>> the existing lease keys for rename, unlink and set path size compound
>>> operations so that the client does not break its own lease.
>>>
>>> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
>>> ---
>>>   fs/smb/client/cifsglob.h  |  6 ++---
>>>   fs/smb/client/cifsproto.h |  8 +++----
>>>   fs/smb/client/cifssmb.c   |  6 ++---
>>>   fs/smb/client/inode.c     | 12 +++++-----
>>>   fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++--------------
>>>   fs/smb/client/smb2proto.h |  8 +++----
>>>   6 files changed, 51 insertions(+), 38 deletions(-)
>>
>> NAK.  This patch broke some xfstests.
>>
>> Consider this reproducer:
>>
>> $ cat repro.sh
>> #!/bin/sh
>>
>> umount /mnt/1 &>/dev/null
>> mount.cifs //srv/share /mnt/1 -o ...,vers=3.1.1
>> rm /mnt/1/* &>/dev/null
>> pushd /mnt/1 >/dev/null
>> touch foo
>> ln -v foo bar
>> rm -v bar
>> popd >/dev/null
>> umount /mnt/1 &>/dev/null
>> $ ./repro.sh
>> 'bar' => 'foo'
>> rm: cannot remove 'bar': Invalid argument
>>
>> This is what going on
>>
>> - client creates 'foo' with RHW lease granted.
>> - client creates hardlink file 'bar'.
>>
>> At this point, we have two positive dentries (foo & bar) which share
>> same inode.
>>
>> - The client then attempts to remove 'bar' by re-using lease key from
>> 'foo' through compound request CREATE(DELETE)+CLOSE, which fails with
>> STATUS_INVALID_PARAMETER.
> 
> That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
> due to the server not recognizing the lease id for the file bar.
> I'm not sure that this is a client bug.
> If the server supports hard links, then should it not be aware that
> foo and bar are the same files? AFAIK, file lease is associated with a
> file, and not the dentry.

Lease keys are tied to the _filename_, including the full path. They
are basically guid's, and are used as lookup keys in the lease list,
from which the lease itself is the resulting value. The value is then
inspected for a match to the filename for which it was created.
They are not about the _handle_, which is what is apparently being
assumed here.

MS-SMB2 section 3.3.5.9.8 says this, which the server in question is
correctly enforcing [emphasis added]:

> The server MUST attempt to locate a Lease by performing a lookup in the LeaseTable.LeaseList
> using the LeaseKey in the SMB2_CREATE_REQUEST_LEASE as the lookup key. If a lease is found,
> Lease.FileDeleteOnClose is FALSE, and *Lease.Filename does not match the file name* for the
> incoming request, the request MUST be failed with STATUS_INVALID_PARAMETER

IOW, hard links are, from a protocol leasing standpoint, not the
same "file".

Tom.


> Meetakshi, can you please follow the repro steps provided by Paulo
> (against Windows file server) and check why the invalid parameter
> error is being returned?
> 
