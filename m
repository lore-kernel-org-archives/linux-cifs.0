Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11021141.outbound.protection.outlook.com [52.101.57.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A53B34D93C
	for <linux-cifs@vger.kernel.org>; Sat,  3 Oct 2026 21:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791063835; cv=fail; b=lCrDguUmGB4GshoV1lb0TYRZoH8YFnrfF6EmoGKwVhat4cUakNblZqf6PfEtJMGDk8Ri9IdjyZKbnOGwg/Vjc7LLGbyA4k96bax5Rl7pVKU0R6SFmGE2dcNRzdNDtHOxr8H0A5Df6n7BgY1b0IWR0yDnet60aKgUDjvkvRHX1QM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791063835; c=relaxed/simple;
	bh=NNFLDDtKft6yOgxnqUaSnvgQn/9ttKKantIfe57VI3U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HZZL7ytl4RlnTxpQgr3Vq2uASOUNZ7C6+GZWAWbF9e9UOdQkZrFQI3lLL8RSdpABfM5kkPSBOxudKLhhck7z23YK/esK/lPMQaa0rDq8FRSgrPQogq9wdP5TpNQXcSQLZwdnOzCZqaR0xH38m+m5HG6XO/51UU2MpM5V77app7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.57.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=COXa0G8Tu9FD6jb4srwHGUFxF6oGPiliadLafqSGilcAMn01hsHgs+S6yz0stmMicvbBNKG5DH2Iu1JY6cTTUavChS7P/xTYQ2m9nn5kHVu+YqLS6eNkkPqO9k28pMDd0WDI9bfT3Y3JrX1UjhOWxdUgy0QFphpEoOjHy7y1SLMn6t6HD6wiNi3Qb4oyRlpyjwjbfVRun9X5tVKrSIFJN9BiE3Sis2GiGUBl/ogeoUvItXit9pAzGPgOkIlsi8ukX9U3xCn4Hi0INLR8m9skOfkPFysAi8y2Qy6GuyVCrOFWWZCzMqf+LUCeiu9bkIX7aE3rNm/WZhTjZw14LzDegg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEalO2ZQkmmDIeGQmrj8xHZPP2iIbO7wpZBfuzdcVhk=;
 b=o6qWWq2Z7pGPo56rqnuAWVVFFxfTtupjtr5hJ5rw/a4ALH/jS9kguch8zN7iwNwfKCVHffpst92FpEAkMesnGS9FoWHgARCReVTt7OUUjZeuh0BQkcEmPm9P0UkLbzuX8W2WJUL9Pprz1bFkcQFwLor/bj+0g4fhm+N/ugYtz+mJuYnvBdimxiqE00LOdvipOSaDngigkvECegoRMh0WkKDuDKr9wZ5XmG8DvpBrdOJIoTf0AvFG5SbXV3jmQtrZ9i9/WD01VTReDcic6OS/MagtHEWw8bbyERw2zPL5N+YA1wmUEZS6QMYa7j031jF2IZsOZs9pHm2vhe3uzBcUyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 PH0PR01MB7367.prod.exchangelabs.com (2603:10b6:510:dd::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.20; Sat, 3 Oct 2026 21:43:50 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 21:43:49 +0000
Message-ID: <ceb1d74f-085f-420d-b518-cede3f2a47fc@talpey.com>
Date: Sat, 3 Oct 2026 17:43:31 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: pre-auth remote DoS via SMB-Direct listener backlog slot
 leak
To: Stefan Metzmacher <metze@samba.org>, =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu2?=
 =?UTF-8?B?7Ja07JqU?= <ihopenre@gmail.com>
Cc: linkinjeon@kernel.org, linux-cifs@vger.kernel.org
References: <CANTrAmxL5sWU8Sn29JAGZvSq5PBB2OA+VKA0MHsZJMesagtfzA@mail.gmail.com>
 <e9d8518e-d762-444a-8dba-c2deafeaf66e@talpey.com>
 <9ab57169-0b77-47c9-9d75-670dae49b1ec@samba.org>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <9ab57169-0b77-47c9-9d75-670dae49b1ec@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:208:32a::21) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|PH0PR01MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af50140-3e6c-4be4-aa1d-08df21976912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|56012099006|4143699003|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Y/Wa/t/3PVpxzalPAURzf+qPQHlxNrfRcU3QHY/ueihtCjjgIafy5/dTStBwcpApoteX20tdQyFzQ+euzzNBjPOKV189J0jd6ixbgsHDGW7bXNWxtIDgj7YzMaz1+SAKT1qEpSMr6rEMw9ZIGE6F95wmaMD/frorNIafKutKjNnC5GX7FCtFcNA/bGq81msUt3JBKTb5OQ9xdtmYJ+ParQmwfHjI4Qis8hDRcarrbt7dBtdsJYrefcQFXzp5o365RX6oQSMcUNwUo7ok3EWy+TOVLRDUyWnpbp+HWojNRSqQKSwfYW6LmYWfHTzRIFynoSbba5jY1dvuD5QDS9fD3Ur484ZhOHMzwqPedULJV8wy3LQNb8FJRQhVPLJ80z6G7ipiG2YbBRgz0vxPHxXFsOAPGtBJoCZWVyOFpCiiSAMhGUDD2ExK/LHdtA8gk8pDWbZdDksfWfYc4S29NqojuI7hQRfD5L6OZ/nOZHINnHenItueZUzXKHXvpf+0ESVfsS2md8KyRMTWXod6XJqwUWfQi+zyHxvamo93pVQlqRNG2FHmLLx9PVKvuPp1yaAW9lr7AdC9vKT8flWX68YaGhh7FoDForAQcRhGJTg2D3Ng0mgMl/ovovnq6LETjjvU0pVZl7PQxRj+Z4beNuhMRFR2YcL6EPBpHsVq+AC9Jgk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(56012099006)(4143699003)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QThkR2I2SS9TSVZacnJ5S3lJQ2ZjSWhKYTB6WFZ2QWpVK1hPMHM4aUcxVWg1?=
 =?utf-8?B?NUVyRG1PQzFlN29SRmgvVmY1cHpWcjFuWFV0TVFnMVRwaWFVY1RDQ1IvY0hk?=
 =?utf-8?B?dEJhd0l5MXpZSlk0akp2TE40U29iMm53SFFNWG1WTHJPdDVGenVPaHpFK0Iw?=
 =?utf-8?B?bEZSbnZVYkVOaklSZmthWTNBTlI3MnRwc2QxUGlHNXBkOTlhL1JBNlNrc3U2?=
 =?utf-8?B?VE1wSFUwZUN2TzJ1aG5NVGJ6VERYV21OMGNQUVg1VFJXblRtYTB6M2ZZK01l?=
 =?utf-8?B?Wkx1UW8xMHU3aDlPcXdEekloeHcvVC9rTkRhZnd6YWJwZG9UUytIRW9DaGJv?=
 =?utf-8?B?R1NrVHQ5dGhDVklUMVlWR2Zzb2gyeEtCS2FTS3dYS0dOcDlLa1dKaDNmbjkv?=
 =?utf-8?B?cm1iVU1ldVR2VVMwZzRodmE0cEd6Wm1wTmNoVityNVBPZlFTdDRDbE15SGcr?=
 =?utf-8?B?eEZudjFldlpuM3piV3poTXNxb2xIYzc2bDc2TmJsemVJaytheG9wUWthd1Qv?=
 =?utf-8?B?ekZLRVBsK3A4UzVhR3haSElzSEo4eGg1cmMwSkNrN2plUm1wMkZDTHZ6QTZ5?=
 =?utf-8?B?dlZOVXMxN0lRWVpMdEk2aG53ZWR6V0hRc2FCOFJBUW5XQ3VCeHNvWWdkSmE4?=
 =?utf-8?B?VGV6SldCRkpXcmVvd0NmTzkxYjdoMXd6QUlrbE1Nb0doZUViOUc1UkpwbU5p?=
 =?utf-8?B?a0E3Q3lHQzJ4MUk5MXVOdnlDQ3VIcUJGUUNkRlZtVEdGSjYvM1RSQkFHRDNp?=
 =?utf-8?B?QVRxL1hMQnptRzhWV2d5THdVdlIvcTNaYy9QME5HSDk0U0NRbEdYL0x0YlVW?=
 =?utf-8?B?NG56OTJHWExYWW9HV1MyVWM0SDloenpTVTh0b0NSbUQ4QXY1V3U0RDNXcHFE?=
 =?utf-8?B?R3o5YWF4SFdOOTlpTGZQYUg2R1dEd1ByU05OR1BPNVJlWFozclh1U21wV3FT?=
 =?utf-8?B?c1pEdlJFYnk3QWxpenJxZnBxZzl4QU1jZDJmMXhHNUJTYmVUTnFteGxxMmtS?=
 =?utf-8?B?cWJRY1FKVjcvbHpQMGNIK3plSFhsZ1V0eHU1eG1FMXZaTURsSnRxbi9sZEtt?=
 =?utf-8?B?T0hOMXBUNmtvZmh6WWdVMm9xaFkrU3F0MG9kOFBPN1lkVXVuTkRJc0FIQjVR?=
 =?utf-8?B?VmZwYWpienFzMDloUGZDMmVGd085cGxEdlZPbjBHWUVvWXFsR0pLaXpkRVhM?=
 =?utf-8?B?QVJYTitaTkpPYVdzSkRWbHBJV3ZvRFkwQ255UEUrRm13dTV1YWw3aUZzaGpv?=
 =?utf-8?B?dkxTTmxLNXVYSFRGNUxwYko4cXNpSEdMQkhNMUV6SXdFUyszbFFScmhPOHlU?=
 =?utf-8?B?bkZPVjhtNmxmMUxMKzJsSmNwNWxzZFRSN3Nyb1dKM3FTVmxyWk0xK3hQbUxV?=
 =?utf-8?B?aFpRL3UvRXprb0x3TmN0aVl0YVh2MVF6VEp1MVVQcGYyb0hPazVyaFFHaVJy?=
 =?utf-8?B?VWdqdHFZb0o2K0NFejJVUm5lRFpqVkl5emZaSjFFZUhyT0dUQU5hSjU4Z1d5?=
 =?utf-8?B?aDRHa29PYnQ1aitHZWJPdWlma05kS2Q2a0E3T2ZMN3psVklzLzRkYzVTSlFX?=
 =?utf-8?B?aWhHdTAyL1M3TE5qUThHQm5BWmthSjc2ZGVUNEhMSWd3WWUvVmdOOUpqRVk3?=
 =?utf-8?B?WHV3cENPMWpsOXpwaWY2cnVZTWNLd2o0b2VLUmU2RFRYbEU0cmtOVldtZERk?=
 =?utf-8?B?T2tlZWY2M05ZN2p4RkxIZHl0dXJDTHNVellpdDdRSHZmenpRSG81cUQzZjB4?=
 =?utf-8?B?VmtJTnVZUzVETzlFWHN2REgvVnNlQ1NOcDFiaENVVk9QalZQMWxjMkhvYVNG?=
 =?utf-8?B?ZG1laDBtRGNJQ3RoZUVYakVPY0RNUGMzQkptc2pvSFhBWHJlZENIT3VaekI4?=
 =?utf-8?B?S3ZRNG1Da3QraXUzRzBQZlUwRlczVWYzcm9lNSs0R00xSmZoUzNRYkJPUysy?=
 =?utf-8?B?cnhOcjR6Rnk2aWtZTE1pM1dsUW9jMDNUdWV1ZnhINU5qS3lnSm9lOGpIMEhM?=
 =?utf-8?B?T2FCR0lKWndzeTNpS1p1dXFrc2gvaUxpNnlwMDBOM3Zyd0xza2xqZDczNEg1?=
 =?utf-8?B?WkVCTldFSU5Gc1doUHNQaEczVm9pbTlFOU5NUUlpeWxpelp6SXFCQ1FKN1la?=
 =?utf-8?B?enA5NjNVQXZHYXhrdmZEdW4vdnFBZ1I1TUFBbkxUZEhhNk1wR2wxbGtJd043?=
 =?utf-8?B?SDJzWmlpTCt5eG5Kdmd6aTgyRkxvT2tGWTVsQVc5cDNoQXpqRTAwNC9jM1BC?=
 =?utf-8?B?QmJQQlJBd3dDeUhZdERhQklROUtCZEhoczVVb3JiZVJXK1dQT2hNemY0R0h2?=
 =?utf-8?Q?pnt3cSCbKR6YySCZ+1?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af50140-3e6c-4be4-aa1d-08df21976912
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 21:43:49.7725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gg4jtG/cDqqrm5lyJr9AdgRLvD8Pjr8i0Oh8jyC7nD81BIJz9qei6Q4YPbaeQyqp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7367

On 10/3/2026 4:54 PM, Stefan Metzmacher wrote:
> Hi Tom,
> 
>> I think we hit this while testing at the IOLab this week. Thanks I'll 
>> give your fix a try after getting my test machine back together.
> 
> It was the reason why we were not able to rmmod smbdirect and we had to 
> reboot.

Yes, however it also happened earlier in the day when Stephen and I ran
the negotiation tests repeatedly. The SMB Direct tests have negotiation
timeout assertions which trigger this leak, and when run N times the
issue reported here appeared. A reboot was necessary.
> It was not the problem that responses could not be send.

And I'm very hopeful that we can achieve a high pass rate with them
both fixed! I'll be trying to do that once I get my gear unpacked.

Tom.


> 
> metze
> 
>> Oct 2, 2026 9:30:36 PM 레드팀하고싶어요 <ihopenre@gmail.com>:
>>
>>> Hi Namjae,
>>>
>>> I found a pre-authentication remote denial of service in ksmbd's
>>> SMB-Direct transport. An unauthenticated peer can permanently stop the
>>> server from accepting any new RDMA connection using about ten RDMA
>>> connections, with no valid credentials and without completing the
>>> SMB-Direct negotiate.
>>>
>>> This affects deployments that run ksmbd with SMB-Direct over an RDMA
>>> device (CONFIG_SMB_SERVER_SMBDIRECT). It does not affect the plain TCP
>>> transport.
>>>
>>> Summary
>>>
>>> The SMB-Direct listener keeps accepted connections on a fixed-size
>>> backlog (listen.pending, limit 10). A connection is removed from that
>>> backlog only on the success path: promotion to listen.ready after a
>>> completed negotiate, dequeue by the accept path, or a synchronous
>>> failure during connect-request setup. A connection that is accepted
>>> onto the backlog and then disconnects before completing the negotiate
>>> is never removed from the listener's pending list. The slot is leaked.
>>> After ten such events the listener rejects every further connection.
>>>
>>> Root Cause
>>>
>>> On an incoming RDMA connect request, smbdirect_listen_connect_request()
>>> (fs/smb/smbdirect/listen.c) checks the backlog, then adds the new child
>>> socket to lsc->listen.pending and calls
>>> smbdirect_accept_connect_request(), which does rdma_accept() and arms
>>> the negotiate timeout.
>>>
>>> The child is taken off listen.pending in only three places, all on the
>>> success path:
>>>
>>>    - smbdirect_accept.c, after a valid negotiate: list_del() from 
>>> pending
>>>      and list_add_tail() to listen.ready.
>>>    - the accept path: dequeue from listen.ready.
>>>    - listen.c: synchronous failure of accept_connect_request, before the
>>>      connection is live.
>>>
>>> If the child is accepted and then torn down before the negotiate
>>> completes (peer disconnects, or sends a malformed negotiate), the
>>> cleanup path does not apply. smbdirect_socket_schedule_cleanup() and
>>> smbdirect_socket_cleanup_work() (fs/smb/smbdirect/socket.c) only walk
>>> the pending/ready lists of a socket that is itself a listener; they
>>> never remove a child from its parent listener's pending list. The child
>>> stays linked in listen.pending, the pending list holds a reference so
>>> the socket is never released, and the backlog slot is leaked 
>>> permanently.
>>>
>>> smbdirect_socket_destroy() has WARN_ONCE(sc->accept.listener), which
>>> shows the design expects a connection to be delisted before teardown.
>>> No code path performs that delist for a connection that dies before
>>> negotiate.
>>>
>>> Trigger
>>>
>>> Repeat about eleven times:
>>>
>>>    1. RDMA connect to the SMB-Direct listener and reach ESTABLISHED.
>>>    2. Disconnect. Send no SMB-Direct negotiate.
>>>
>>> Each connection leaks one backlog slot. After the backlog (10) is full,
>>> smbdirect_listen_connect_request() logs
>>>
>>>    ksmbd: smb_direct: Backlog[10][10] full pending[11] ready[0]
>>>
>>> and returns -EBUSY for every new connection, including from legitimate
>>> clients. The negotiate timeout (SMB_DIRECT_NEGOTIATE_TIMEOUT, 5 seconds)
>>> does not reclaim the slots. The service stays down until ksmbd restarts.
>>>
>>> Impact
>>>
>>>    - Pre-authentication: no credentials, no completed negotiate.
>>>    - Remote: any peer that can open an RDMA connection to port 445.
>>>    - Permanent: slots are never reclaimed, so SMB-Direct service is dead
>>>      until restart. Roughly ten connections are enough.
>>>    - Availability only. No memory corruption, no information disclosure.
>>>    - CWE-400 (Uncontrolled Resource Consumption), CWE-404 (Improper
>>>      Resource Release).
>>>
>>> CVSS
>>>
>>> CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H (7.5 High)
>>>
>>> Affected
>>>
>>> fs/smb/smbdirect/ (the shared SMB-Direct module). Confirmed on Linux
>>> v7.3-rc2 (commit df2908090). The backlog handling in listen.c, accept.c
>>> and socket.c is the same in current mainline.
>>>
>>> Reproduction
>>>
>>> Environment: a guest with ksmbd built with CONFIG_SMB_SERVER_SMBDIRECT
>>> and an RDMA device. Soft-RoCE over loopback is enough:
>>>
>>>    rdma link add rxe0 type rxe netdev eth0
>>>
>>> PoC (attached, poc_smbd_dos.c, built with
>>> gcc -O2 -o poc_smbd_dos poc_smbd_dos.c -lrdmacm -libverbs):
>>>
>>>    ./poc_smbd_dos <server-ip>
>>>
>>> Output on the vulnerable server:
>>>
>>>    [*] baseline: does a legitimate client negotiate?
>>>      victim: negotiate OK (service alive)
>>>    [*] opening 12 pre-negotiate connections ...
>>>        conn  1..11: ESTABLISHED ...
>>>        conn 12: REFUSED (reject status 28) -- backlog already full
>>>    [*] waiting 10s (> 5s negotiate_timeout) ...
>>>    [*] legitimate client retry after the flood:
>>>      victim: connect REFUSED (RDMA_CM reject status 28)
>>>    [+] DoS CONFIRMED
>>>
>>> I verified this over Soft-RoCE (rxe) on a loopback setup. I did not test
>>> it on hardware RoCE or InfiniBand, but the backlog handling is in the
>>> transport-independent listen/accept/socket code, so I expect the same
>>> behaviour there.
>>>
>>> Proposed Fix (attached: fix-smbd-backlog.patch)
>>>
>>> Reclaim the leaked backlog slots in smbdirect_listen_connect_request(),
>>> before the backlog check, by removing from the listener's pending and
>>> ready lists any connection that has already been torn down
>>> (first_error set), and releasing it. This runs in the listener context,
>>> so the release is safe there, and it mirrors the delist that the
>>> success and listener-teardown paths already perform. Doing it on the
>>> child's own cleanup path is not an option, because that would release
>>> the socket from inside its own disconnect_work and deadlock on
>>> disable_work_sync().
>>>
>>>      struct smbdirect_socket *psc, *tsc;
>>>      LIST_HEAD(dead);
>>>      ...
>>>      spin_lock_irqsave(&lsc->listen.lock, flags);
>>>      list_for_each_entry_safe(psc, tsc, &lsc->listen.ready, 
>>> accept.list) {
>>>          if (psc->first_error) {
>>>              list_move_tail(&psc->accept.list, &dead);
>>>              psc->accept.listener = NULL;
>>>          }
>>>      }
>>>      list_for_each_entry_safe(psc, tsc, &lsc->listen.pending, 
>>> accept.list) {
>>>          if (psc->first_error) {
>>>              list_move_tail(&psc->accept.list, &dead);
>>>              psc->accept.listener = NULL;
>>>          }
>>>      }
>>>      spin_unlock_irqrestore(&lsc->listen.lock, flags);
>>>      list_for_each_entry_safe(psc, tsc, &dead, accept.list) {
>>>          list_del_init(&psc->accept.list);
>>>          smbdirect_socket_release(psc);
>>>      }
>>>
>>> I built this on the KASAN kernel and retested over Soft-RoCE. With the
>>> fix: the PoC can no longer wedge the listener (30 aborted pre-negotiate
>>> connections all accepted, a legitimate client still negotiates, no
>>> "Backlog full"), a normal "mount -o rdma" still works, and 500
>>> connect/abort cycles leave the service healthy with no KASAN report or
>>> warning. This is one possible fix; you may prefer a different spot or to
>>> reap asynchronously rather than in the connect path.
>>>
>>> Regards,
>>> ihopenre-eng
>>> Github: ihopenre-eng
>>>
>>> ----------------------------------------
>>> fix-smbd-backlog.patch
>>>
>>> diff --git a/fs/smb/smbdirect/listen.c b/fs/smb/smbdirect/listen.c
>>> index 2f78bcaed..3215cd027 100644
>>> --- a/fs/smb/smbdirect/listen.c
>>> +++ b/fs/smb/smbdirect/listen.c
>>> @@ -215,6 +215,8 @@ static int 
>>> smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
>>>      size_t psockets;
>>>      size_t rsockets;
>>>      int ret;
>>> +   struct smbdirect_socket *psc, *tsc;
>>> +   LIST_HEAD(dead);
>>>      if (!smbdirect_frwr_is_supported(&new_id->device->attrs)) {
>>>          smbdirect_log_rdma_event(lsc, SMBDIRECT_LOG_ERR,
>>> @@ -251,6 +253,36 @@ static int 
>>> smbdirect_listen_connect_request(struct smbdirect_socket *lsc,
>>>          return -EPROTONOSUPPORT;
>>>      }
>>> +   /*
>>> +    * Reclaim backlog slots from connections that were put on the
>>> +    * pending or ready list but then died before the upper layer
>>> +    * accepted them, e.g. an unauthenticated peer that connects and
>>> +    * disconnects before completing the negotiate. Such a connection
>>> +    * is only removed from the listener lists on the success paths
>>> +    * (promotion to ready, accept dequeue) or on listener teardown, so
>>> +    * without this its slot would be leaked and the backlog would fill
>>> +    * up permanently. first_error is set once the connection is torn
>>> +    * down, so use it to identify the dead ones.
>>> +    */
>>> +   spin_lock_irqsave(&lsc->listen.lock, flags);
>>> +   list_for_each_entry_safe(psc, tsc, &lsc->listen.ready, 
>>> accept.list) {
>>> +       if (psc->first_error) {
>>> +           list_move_tail(&psc->accept.list, &dead);
>>> +           psc->accept.listener = NULL;
>>> +       }
>>> +   }
>>> +   list_for_each_entry_safe(psc, tsc, &lsc->listen.pending, 
>>> accept.list) {
>>> +       if (psc->first_error) {
>>> +           list_move_tail(&psc->accept.list, &dead);
>>> +           psc->accept.listener = NULL;
>>> +       }
>>> +   }
>>> +   spin_unlock_irqrestore(&lsc->listen.lock, flags);
>>> +   list_for_each_entry_safe(psc, tsc, &dead, accept.list) {
>>> +       list_del_init(&psc->accept.list);
>>> +       smbdirect_socket_release(psc);
>>> +   }
>>> +
>>>      spin_lock_irqsave(&lsc->listen.lock, flags);
>>>      psockets = list_count_nodes(&lsc->listen.pending);
>>>      rsockets = list_count_nodes(&lsc->listen.ready);
> 
> 

