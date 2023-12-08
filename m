Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2046.outbound.protection.outlook.com [40.107.101.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF15B1732
	for <linux-cifs@vger.kernel.org>; Fri,  8 Dec 2023 06:02:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kdRWcxd4VqlGyYNMu9zOQDgclOMZVhd7KYT5iE8czr0AN9Sq4icFf9mMugdfgjwJA7MewGhND6CGAh6zwBxHSYXpgLMcF/Y8PsVrF9oiRrI8G0gDekQeSlDkX7gXXxgMSbzTyuuB7mhJXYEZr13Tmn5Azchpe5tMFucQME0KSGid6Qd8e6H8RbU1eBMV/5fwMCV7I3BNuNLuZV+4ankQle3Qvprs9O27iXTx9ztioJDjEKk4bYUBQoTB8w2pmx3Zfb6PWEez6XuYFjnUFJmR7CbywZh9vCVnTRYsUKZtxqpPBfctkzAyn3k0VpVRhdpBizh9O9kQvIrQXY2shq9wmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W62jN54YQVwSRnOBSMX0hMWSN2Zh/ZuHyhCGpOOLK1Q=;
 b=a5keY/EHDfbEHLwo2jD7rvQKj1/xj3+ScsBnF95pug74W6pLvgZq7unXCAhU0fuWVGa5xqKsXrfAspdv5A1YmokVR+HBtt6pRg10IGgQ+lEHY+q59SsXCpnf206THddeZVCEyQVGsKwY8sWJOL+Tzre86hpbqtiQdhStkGCq1ggYmcTll1F41BZB11Do9Jy+tdPFbw9tMzXNAic6DPiLyvnXQXs7VF4AaTacmcb9BzOx5BCFQyxFp+6v+NGB1/09gK/EGgU7C2eEww+ujwf4grgCMCbRk7z4G6CqGRjOXCiKbgo4l6cYkcCk3jR/pZONUILpD9OBs+y2Ksm7rGDeyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6380.prod.exchangelabs.com (2603:10b6:806:e5::9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.28; Fri, 8 Dec 2023 14:02:47 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7068.028; Fri, 8 Dec 2023 14:02:47 +0000
Message-ID: <f67c5e4e-8c0f-4755-b974-0b76a044433e@talpey.com>
Date: Fri, 8 Dec 2023 09:02:45 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
Content-Language: en-US
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, meetakshisetiyaoss@gmail.com,
 linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 lsahlber@redhat.com, Meetakshi Setiya <msetiya@microsoft.com>
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
 <65d6d76197069e56b472bbfead425913@manguebit.com>
 <CANT5p=qnEFJDTTrSRkdBfkE9Kzw9BzGRegtCuW6Hb4xc7PSdaQ@mail.gmail.com>
 <9980a249-043c-4140-a5ee-bc06cf156747@talpey.com>
 <CANT5p=p0Fk5j73Hu50DeywQdBSffKo8TNvZhSjQaj+-LtrNOTA@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=p0Fk5j73Hu50DeywQdBSffKo8TNvZhSjQaj+-LtrNOTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR19CA0018.namprd19.prod.outlook.com
 (2603:10b6:208:178::31) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA0PR01MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: d00f84f5-a7b8-414e-90a4-08dbf7f65b52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EyUu0F21Ct0Oyt/W/5xP6kfcrgP/iT9Uv3U1xEJEGyXWYEnsgNSxzr0PKJrAPKL6I+QuYcz1v9no9ojELn/dtB5cQ3cNhlopBuKSiLKzCjOwOVIBOcTWgVc40VIPBeWMeawOSMnttOfx8RF5UjZE+ys7wwVMTEumgeJsyCTEc4jbe1T0HTEmACOxfd+GncE54RDAaDVXtPWJLjvVmw+NbnTIAhJH0TvBAqgSGF92oDrwCd0IXU9DhdwbtzJYZbolIXZm51M7TfyxDBTv9y9Jsh/P1SQYM5eijZpLppvTPicp+EyLg9Is6yUUkvl0QHPIr/FVZ9/yzCoGWcXg5/3Hrft+uzvPUI2DOdb82ZtXg0RH9y49jaJy51RxbgcCcEfxQBB+QpQfRrIkBKHE32hqkMdoZRmzcgqkeg+B3dpVZRo59+rPV23M0Fw0EBFAyDqo7hzlXlr9c+ckpbZI6qIDZcvRn7OjFiDpiuzi0slIstP8lzYLBkrVIsPMGGA8MMra5Uu43kXhc0HVBb7u+LDBqgoiaLghjSpRSSnKkdR3kZ9TsDwjr8s25KOTyjtyfNRzHv00cOStNaDYVPL0RYpv786bJ9cLb0LATNOLr322gM2tG78lJIfzcD/o3+czcl7a
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(136003)(346002)(39830400003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(31686004)(478600001)(6486002)(316002)(66946007)(45080400002)(66476007)(66556008)(6916009)(8936002)(38100700002)(86362001)(6512007)(4326008)(83380400001)(6506007)(53546011)(8676002)(26005)(31696002)(2616005)(5660300002)(2906002)(36756003)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cksyZWo2WjlzM0QxMSttYmt6a2ZoYVhWbWViazN4S09zaFNvZWFVbkhoeWxJ?=
 =?utf-8?B?L1ZWM2NHd0RxczMwejkwUXlqVzRTRGdzYTAzY2ZmVzhqNDNSbWtpNGtic2tr?=
 =?utf-8?B?QjZ3T3pjUS9oOW9ISk4wYktJdEk3OEl2Qm1TWWhmdEk4T09GMi9zazhNNHZ4?=
 =?utf-8?B?ekp6SFd2RFZzR1ZRc0NOcERGc0JYOVpMVnFWZ0ppc3lwUjRROEQwcFVMZXhL?=
 =?utf-8?B?N3ZDa2JSeEJTVlBNNTRjbldRaEFyRng4dHhxWmthU1VIbWhQUFNQRDR2NFJV?=
 =?utf-8?B?MVZDeEtKMHB3bjNzTTBlV3cvOFBBNFhRQzZWM21qMGU0MVErVVorM041UUNO?=
 =?utf-8?B?d0wwM1VZajNFemxQcHFFM2NFYnRVVzZXYUwwYVJCS3RqYWJ6Zis4RS9VakZH?=
 =?utf-8?B?V1NRaU50ZzFvQnVtazZYZWtvWDVXUFZaSVFVN2hXNTZXaW0rY2c1Sk9WRUo1?=
 =?utf-8?B?NnB6RGM5UnlrZFh6TW53YXR2VEpIM1poU3d4YVhUQWpWUUcrQUkyMEVKWjdV?=
 =?utf-8?B?d0tZdFY0UVllS0ZYQWJQcUpJdVlzT2pVTmhSOE1GU3YzMUpoU1JaQXZwdHA0?=
 =?utf-8?B?UkV3emFHNUlLRDhSYVlzandpS2I0b2hHbmRJMGZIOVQzTnlRWUllWGgxVWlt?=
 =?utf-8?B?TWdZTllnc3VXSzdjVjZxd1dsZlpudm94ejQ4ek1vVzA2RzBSVXY5TUJFN1ZJ?=
 =?utf-8?B?YXV4cVZ4c1VlL0JNblZiQk5FbEpHTE5OVnNrb2ZReFpQaG1MdjJXVytHVVlP?=
 =?utf-8?B?Y0lDUTNQTjVsbmNhUndZUm4yNVJzM3gzcFhRdW5lYjZiUm1Gem5kYkw1K3NX?=
 =?utf-8?B?SmtuQ2NkbCtDUkQ5RFBBYnh6QWpoVVRHb3JuQk5rNjVKSmNnZXNWVlpIM1lC?=
 =?utf-8?B?UjFKQVZBeHVRcFZrVnByajM4eTN5aXdVd054MERTZ1R1WDhUUHRhZVEyaHpt?=
 =?utf-8?B?UDhCdktnNFhxTFhoNThMYjRwaFl3ZFBSOFJ1Z2czcS9IKzA1Zkptc3dHT3ZH?=
 =?utf-8?B?T2xvTmpaaGF3ZXdXSmZCSmwwbE5NTFNvMHNsSEpvVUdmTVk0TWsrZlhRTXd1?=
 =?utf-8?B?bHRiY0M0UjIwSTV3MExpbkpCUUhnT3JrVVpIYldSVDduWXVrbldaMW5NQlMz?=
 =?utf-8?B?dCtpb0hFOVpIYzRiY0dKN3JGcytlWnUwMWp2NU5SWVVBMStMNkxqa3J0REh0?=
 =?utf-8?B?Z3ZXcGZxcGduVnNCWEluVEoxTFdFa2xoSWFDWTV3bE5NSzRnajd2YWJwVzVB?=
 =?utf-8?B?OGpXZnFzOEhtUDR6bnIxMnR6VHFHYWl2K3ZOaDRLS3lnME0rTU85QktoMlk5?=
 =?utf-8?B?QUs1OFpXUmVWa3BKdW9keVJkL2cyeUd2L2lJT0ZGWXlsamh2VDdORUNMRGxP?=
 =?utf-8?B?alRPZStkRFA3QktVdmJKU1d0ejlpd1I3cUlDdysvSTZWUTZCMFJTa2tna2RU?=
 =?utf-8?B?bnB3Nm1ZUXF3V25GWm9ZTzBUSENpaU5CTmNTczI0NzlkVFJDZjhqNzJ0dmRr?=
 =?utf-8?B?ZFFRZ2tWWS9IZS8wK2krV1hLb0hXZzJiMXUrTGU2ZlQyNExrNTdJbk4zRFN4?=
 =?utf-8?B?cnlEbmliWVpXTzU4SDJwS2tKTm5ZTTVTOXBkRTV5VGJocUhKSXNDa3N0dFhr?=
 =?utf-8?B?bUJwbTN6ZnpReStmUjRrUmZzaHl6bUFYaml4aXpmRlZrcW1GMmxuV3BBWldl?=
 =?utf-8?B?VGI2bXdqalZKT1p2KytUbkRvQWd4WXJsVkYxSll2MENRQXlsbW83SWJBSXY2?=
 =?utf-8?B?OU1VTFp5RFVvT2p5Rk5tQ2VNcnh1N0p5VmlTTFQ0VmJXRnIrOWdSZVUzR2k4?=
 =?utf-8?B?am5oY0pkcnFTZ2ROT0o1MXE0UFpuZS90MndBdTEzTUczb0p1R1hNUUdtdE4v?=
 =?utf-8?B?MjJUN2R5MVkxK0syZTQ2RUR4UDg5a2F1RUUyc3Q1aWl4RFVGUW5qUk5GVHoz?=
 =?utf-8?B?bUNFRFkwckI3MHlBcDllYUd5eU9uYmljVmwvV3BzTUk5MmplUG5RbVpYMTJD?=
 =?utf-8?B?U2o5QWhTS0dnNXpydXk5QnloOUdBSGxndFdrOEJLdWY0Sk44L0xtS2YrRWdx?=
 =?utf-8?B?QXRUK0tqZjJqM0JBL1lzeGRIbWw0Wm5RaktsWmM5VjFxZ0k5eHgzeTI1cURC?=
 =?utf-8?Q?a3Tn68Dk+rrg11u9j4R6eW1kG?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d00f84f5-a7b8-414e-90a4-08dbf7f65b52
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2023 14:02:47.0325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U6nrS8OF49rPjvTUOYBvtrPxy+rdbM1R3rVYI2iiYpWDfnAhCXokdouX4PsDy7g0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6380

On 12/8/2023 5:58 AM, Shyam Prasad N wrote:
> On Wed, Dec 6, 2023 at 7:12 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 12/6/2023 12:31 AM, Shyam Prasad N wrote:
>>> On Wed, Dec 6, 2023 at 1:02 AM Paulo Alcantara <pc@manguebit.com> wrote:
>>>>
>>>> meetakshisetiyaoss@gmail.com writes:
>>>>
>>>>> From: Meetakshi Setiya <msetiya@microsoft.com>
>>>>>
>>>>> Lock contention during unlink operation causes cifs lease break ack
>>>>> worker thread to block and delay sending lease break acks to server.
>>>>> This case occurs when multiple threads perform unlink, write and lease
>>>>> break acks on the same file. Thhis patch fixes the problem by reusing
>>>>> the existing lease keys for rename, unlink and set path size compound
>>>>> operations so that the client does not break its own lease.
>>>>>
>>>>> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
>>>>> ---
>>>>>    fs/smb/client/cifsglob.h  |  6 ++---
>>>>>    fs/smb/client/cifsproto.h |  8 +++----
>>>>>    fs/smb/client/cifssmb.c   |  6 ++---
>>>>>    fs/smb/client/inode.c     | 12 +++++-----
>>>>>    fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++--------------
>>>>>    fs/smb/client/smb2proto.h |  8 +++----
>>>>>    6 files changed, 51 insertions(+), 38 deletions(-)
>>>>
>>>> NAK.  This patch broke some xfstests.
>>>>
>>>> Consider this reproducer:
>>>>
>>>> $ cat repro.sh
>>>> #!/bin/sh
>>>>
>>>> umount /mnt/1 &>/dev/null
>>>> mount.cifs //srv/share /mnt/1 -o ...,vers=3.1.1
>>>> rm /mnt/1/* &>/dev/null
>>>> pushd /mnt/1 >/dev/null
>>>> touch foo
>>>> ln -v foo bar
>>>> rm -v bar
>>>> popd >/dev/null
>>>> umount /mnt/1 &>/dev/null
>>>> $ ./repro.sh
>>>> 'bar' => 'foo'
>>>> rm: cannot remove 'bar': Invalid argument
>>>>
>>>> This is what going on
>>>>
>>>> - client creates 'foo' with RHW lease granted.
>>>> - client creates hardlink file 'bar'.
>>>>
>>>> At this point, we have two positive dentries (foo & bar) which share
>>>> same inode.
>>>>
>>>> - The client then attempts to remove 'bar' by re-using lease key from
>>>> 'foo' through compound request CREATE(DELETE)+CLOSE, which fails with
>>>> STATUS_INVALID_PARAMETER.
>>>
>>> That's interesting. I'm assuming that the STATUS_INVALID_PARAMETER is
>>> due to the server not recognizing the lease id for the file bar.
>>> I'm not sure that this is a client bug.
>>> If the server supports hard links, then should it not be aware that
>>> foo and bar are the same files? AFAIK, file lease is associated with a
>>> file, and not the dentry.
>>
>> Lease keys are tied to the _filename_, including the full path. They
>> are basically guid's, and are used as lookup keys in the lease list,
>> from which the lease itself is the resulting value. The value is then
>> inspected for a match to the filename for which it was created.
>> They are not about the _handle_, which is what is apparently being
>> assumed here.
>>
>> MS-SMB2 section 3.3.5.9.8 says this, which the server in question is
>> correctly enforcing [emphasis added]:
>>
>>> The server MUST attempt to locate a Lease by performing a lookup in the LeaseTable.LeaseList
>>> using the LeaseKey in the SMB2_CREATE_REQUEST_LEASE as the lookup key. If a lease is found,
>>> Lease.FileDeleteOnClose is FALSE, and *Lease.Filename does not match the file name* for the
>>> incoming request, the request MUST be failed with STATUS_INVALID_PARAMETER
>>
>> IOW, hard links are, from a protocol leasing standpoint, not the
>> same "file".
> 
> This is interesting. I would assume that leases are a mechanism that
> assure client that it is free to cache the file locally, and that the
> server would inform the client when that is not safe anymore.

MS-SMB2 has this (non-normative) statement in section 3.2.4.3:

> If the client accesses a file through multiple paths, such as using
> different server names or share names or parent directory names, it
> will create multiple File elements, and therefore multiple 
> File.LeaseKeys for the same remote file. This loses the performance
> benefits of sharing cache state across all Opens of the same file and
> can cause additional lease breaks to be generated, as actions by a
> client through one path will affect caching by that client through
> other paths. However, the impact is a matter of performance; cache
> correctness is preserved. If the client accesses the same path
> across multiple opens, the client will use the same File element and
> therefore the same File.LeaseKey is used.

So, this next statement makes an incorrect assumption:

> Hard links are in-fact pointing to the same file. So I would've
> assumed that the server would have treated both links to have the same
> lease.

Not at all - the lease key is chosen by the *client*, not the server,
and the key can only look up one actual lease. So the protocol enforces
it, meaning the server must verify the path.

> So either the server should share leases between hard links.
> If not, at least an existing RWH lease on link1 would be broken by RWH
> lease requested by another client on link2. At least for the Windows
> file server, that does not happen either.
> Isn't this a bug from the correctness stand point?

Can you provide traces on that? If the protocol document is incorrect,
or the Windows implementation does not conform to it, that's bad.

Tom.

> 
>>
>> Tom.
>>
>>
>>> Meetakshi, can you please follow the repro steps provided by Paulo
>>> (against Windows file server) and check why the invalid parameter
>>> error is being returned?
>>>
> 
> 
> 
