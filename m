Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021087.outbound.protection.outlook.com [40.107.208.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B120E33F8AD
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 15:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790522573; cv=fail; b=AyS2SUhJYnXs4wm+/8S9vXv8vqbbGXNf34bpV6woHkcdOmxLLOL1fGfgwZmewE0WgYKsqbKKqZ85rZhnUdhHnNbckATslW+OdElR9Y4zPt/JrsQ/rmWGmpcYthmK9nnRZ4erQ3uFsPsx+5ECFT4RbOgPFnH8uGbgvPIWcKA7G3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790522573; c=relaxed/simple;
	bh=2n6UOJQ5zHhh07w4UkPpB0etc5d7lr1fMhJ+AyPuCcM=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r6Y2xm4EpuF9GqIpwjc3Va96opqn9AdWdioE06wt75gRvfhSmHcSrzq9HQES9TOtMn13YTpQ8sMcxqKuvCcxX9pudDipj0uBDuX9bvsJA4CniSfNIYAIbOYT6PqDc3AQLF/fGVZzfbXcBKcmYEK4XyIU438SXBGofIIvST0CXww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.208.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QVmjouNpJ2ABFF9qvhL+bMKJz5bxqssbI+UgOvd+/N49aco7UxwKkr0zJI9p5hLKtaoxlyFWDfU6AQJvoYQb54gs9PaH6sg4WJr1c96I8En/GDMLkqsFqW2U6BJG1pb4TyOYTmZoGGVQ63bCRCCUnDm473cSUR/7qtB13wU7bTP+NdCuIIWBr3NSgJ5rAAQ4ihnIChqQbLphJp0sazS4g9uZP+WJ5pqIwI2zy0mS4TpTWk3x7DJwtRW9MRbfxFRJ5DXh9frCJDTYyR8U9S59qzqU+F9KpGfFBkKNGDuzoIv+VvWoSR3xpV0P3njs266itp56YiHA02yC8NE+ubs6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3hC2mMJRPK+zPaxJmXtqgyjGkRqVhxl9Bb83eFX+nQ=;
 b=rP53F+IsSU0mRZuwNglg9Ge7t3fgv8ynsmVS5IVNq3VTpPSOdn2ZdtPWJBH4dLeszIva+KKqpB6hKC+2YysPTqlyn0eg26k1OWxInwRViy0YnGyDvLrawrp5sBWSNcpSFCyUkcyRNZvCsgIlwNRaAa/N/1tsWhbgnjiFnuiOIIbjnl+AxJFcOGrPOTfg+oelQq6FbQSSp+ktDuXCwnq04WkLD0pliP2Khzp6W8m4AmstLEPmNE/mr7JeGtspT/6KF4YxkyfFojIwbdmWvDabUuPa66ANhOiIJboad8xccDcl1aMgLA9Z1WFUvT+wu+Rmct6XDLebP99NWLkdNDvkgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 SA3PR01MB559726.prod.exchangelabs.com (2603:10b6:806:588::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.23; Sun, 27 Sep 2026 15:22:49 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0451.022; Sun, 27 Sep 2026
 15:22:47 +0000
Message-ID: <790e75dd-6976-4b95-b11e-71798d64d10a@talpey.com>
Date: Sun, 27 Sep 2026 08:22:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: pre-auth remote kernel heap info-leak via conn->ops TOCTOU
To: =?UTF-8?B?66CI65Oc7YyA7ZWY6rOg7Iu27Ja07JqU?= <ihopenre@gmail.com>,
 linux-cifs@vger.kernel.org, linkinjeon@kernel.org
References: <CANTrAmy-2tA9B_mY-hARC5LE_==6m+52Pq1p0EV6fRXgWtyGQg@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <CANTrAmy-2tA9B_mY-hARC5LE_==6m+52Pq1p0EV6fRXgWtyGQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ2P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5da::12) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|SA3PR01MB559726:EE_
X-MS-Office365-Filtering-Correlation-Id: b6fd6737-455b-46f0-ffd3-08df1cab2fb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|10067099003|3023799007|6133799003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ZKb4NKouIYT/qXHNAiV+7Zt1gbLYoerTVelPxIg7IAGOTVQ67d5D5F53bTeAuZDqcB5s+ijZl4Ti0IGIxOp7Q1OcYoIUcnNQYF2jaoIrKw3rFQ5TgVoCHUk9kjNIs4rv5x6fMiIsRqfN/53kqg31n6pvWZeQxOyqTpuSgCmDSUkNBlk61RHGeusE6DzhjtcNUXD52lLtu05dxwmxt4KV6IiLYSGuowLOJpw8p1KrTqRrw7FoCv02WbwXhLQKui1whvAG/kLx1NU1Bz7xL3yTYLH4UGmJt6bQHgpFy330LEWCLG3yAb2aNs0zjR0nXMsSI8UF5yUez2CAQuuzJqyaTqVecuQ2dEbNKCMApb2+rGm8DUvvgCIl5t5r0ugZWFATCZBZdPY+k4QjT/O18JBFnrClxA8JYVdRQNKHAd29vn/ado6HzP/VV+bEIIb3ahvmQYkJK69LIYExDmGT0S8VJhiSNcNKKqF3FCLrXxWoNn8RMaNPZlidQqi0EBgkAeXKTD24U6N+eOEII2OFdOAaIS9bn9kgj7//p/5UKVbDyED6CZbmR1u55Cqxu71osWp9DfknAZTCc7vKpwaSjH3myLWY3B+MbLuKh3oky7sJVEs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(10067099003)(3023799007)(6133799003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWZsZS9UZnBReTBEcU1EdVY4Zlg0R21JYktOZm9Ha0hveUJXNUt0QUlUUzZD?=
 =?utf-8?B?TmxyT3lWSm9WeVlVMWVqdVJObUJRMHNvbHNncGh4NVU0STltUzZMdWxNaUdK?=
 =?utf-8?B?V25rT0Vxa2VyV3hWWFp0RmIydzB5VktHZTF0Z2s5ZjBUYVVIQXp5M3dvdlFa?=
 =?utf-8?B?MXVEVXdPcDY4R2s0dlB3a2V6Um50RmV2aXorL1ZRNzZmSktUZEd2SVVBOWlM?=
 =?utf-8?B?b2lOc2tmam1rakRMblloQ0ZWTTgzL2ZKVzFkV25NRDBQQkdzcGR0NWFyRVgy?=
 =?utf-8?B?TUsxTUxwcGF2NEZkOUFlUnVac2pncmlQcDUrdXFnamZGNlZoZHM0UWtoRjI0?=
 =?utf-8?B?UUg0bzZvSWpnL0tDVjl3WGxZUTdKdmxaTFN4MEs1eEgzRG9tRDNCNVF3Zldu?=
 =?utf-8?B?OFlkeGhoUlYwNjJjek9ianlTL2dPTDNZWXpUakZ0aHkrYzhhTlVEVWNhMGsw?=
 =?utf-8?B?UkJDU1JWZ3Y5WEhOWjBYWlJtVEtZT1AzaFYxOExvVEtlSTlUaXVtSW4rMW9a?=
 =?utf-8?B?ZXRhaXZmZ1NaTnNuR2ZDSkloR0Q5c0hGRjRBWGF2WDNtWWp2N2pVZGJTWHRh?=
 =?utf-8?B?VmVKQmVPWnp0YzJUQVJSTnp2Qy90Zm9taTJXc2plZHo5eEFsSWUwdXJKOVkv?=
 =?utf-8?B?aUN6VW0xQjR4TVFQVm5uNFI4Y0RjbTh0KzVZS25ORVNOWEYwK0RmUHppdHhs?=
 =?utf-8?B?ZmZGbGlQQmpyTEhPQ1FBK2xienZXQ1h5V1piMzVFVk1jbUhzQVc0R3BhQ1lj?=
 =?utf-8?B?bzdVa2lXanNTOThaQWVXeTJ5Mkc3N0U5Z2dUeDJRQ2lINVBEMitadlphRngr?=
 =?utf-8?B?V08wSVFlWVZXY0JycWJXeldrSEU3dkNtNENLQytSbTV3aGZZUWNYSGlMMjdh?=
 =?utf-8?B?M1BQTkNTZ2d3N2NHTnh5eGF5dG1NTFVvVWRJK0JoVEtDblU4dlZyamJ4MzBV?=
 =?utf-8?B?RFU0T2FRTEV0andvKzAzYzRNZDlvS0ZudWNqZFpmbTYrTWZzWGJFVUlRVFY5?=
 =?utf-8?B?V1pXU2hQdkZxZmxEL2lmcFZzNmpiV0YzN0EzMW1OK0NDZmZUU0oxWklIeUtT?=
 =?utf-8?B?SXNPclYra2Q2ZEVORjJwcHJ6SUR4a1dyM2lhRDV1dVlNcjB4azJlTGU2NUxO?=
 =?utf-8?B?MXZnbWF1NlRZTVN5ekNCL1UzMEhxSDNiTW1nK01qNzJqbzN6VmYyN21CYXZY?=
 =?utf-8?B?SE1GUXcrd2VFMnkrL0tCa3hIOVk2Z09rc3Q4TmlWOGFwSDFKODN0WmFLSXdV?=
 =?utf-8?B?QUFLNGhIaS9WVllTeEdmWEVXM09CejJ4L25kb1BFM1ZxeStNWXlCdzhvNXFE?=
 =?utf-8?B?YUNnRHg4cU5YQk9sSWZ3cmppekM5ci94NkxoZUphVGpwOXVwUFQxV1BrOHJo?=
 =?utf-8?B?VVcvbk5wYWlwTGN3VVMxOHhEWGRpbHFEMGVXWHNQUWYxcHcwcFpQUlRFZHkz?=
 =?utf-8?B?WWVpRkxIa25jMzFiVUthUHUzcExCQ3lMdk9RdFdyMGxHTG5JQVlDamRsbmxY?=
 =?utf-8?B?TStWZ0VKNnZCSldmKy9Id2sxTG1pSVdqeitNNkdEZDJ0cVBqVTArUGZVOVRZ?=
 =?utf-8?B?MW8zeHphTUNPeWYzM1Y3bk5LZXM2Z2xWYW91MGFUV0VqQ1B4c1crY1NacFZG?=
 =?utf-8?B?MDRpZnE4RDlFdlo1WGY3WW9jMGFIcU1oNXZab21qeHhuNzh0NGZCMWVvRUQv?=
 =?utf-8?B?TDRYcjZRMmtmN1d2eXQ2SmVBTUhPQkhhQ24vU0pyMnVrMmFzeFJGdWhWaE1r?=
 =?utf-8?B?Z2xXZkhhclpOL05XNjVFTVhuaHNVNWgyZTVvSzBDcGg1VkRENXcvMmgyT0tH?=
 =?utf-8?B?MzJNWDdnOXhEbjNaWXdLb1JMMHVYZEg5cDcwNGQrTTh0dFVYOVNPc1BFTWM5?=
 =?utf-8?B?NWFZYXdzbmo5ZnRlaXJkYW91UDVCdHQzekJSRlh5dXBPZFZGVWsweGNVMTZY?=
 =?utf-8?B?bEEwbU1KV2x2bDBlV0hvN1Z6QUgrZTVHVE1mU1hFQURVek1maUF3VEZnbnJC?=
 =?utf-8?B?bC9oY1RiYkVTNG5hOVg4cmtIR1ZXZld1eUcvVFFJQWk0Rzc2b3FINHJTWHlT?=
 =?utf-8?B?V0pXRlRmOE9RUjhDTVhtSDFma0lFdmFVc1p3dmg4U3RTajJHQjBrSjV1RUt3?=
 =?utf-8?B?SDF4QThLSXREcGhyQWtGVVNLVVRYRDF0aVRvMm1ZS1pIc1l4dEVTVm1yeVI3?=
 =?utf-8?B?SGE3UU1kQzBpT1I4TEdqdHkyVG1HMFkxTGFyZUV6WkhRNFpXMTJXTGgrNFZW?=
 =?utf-8?B?ZDd0NHo1emxlK01lN0JTYUh3NmdVZmpjcDNiZHdMRUkwZ1VkaDViYTM0eTZ1?=
 =?utf-8?Q?TbHhUtVEOLMCzHbXOK?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fd6737-455b-46f0-ffd3-08df1cab2fb2
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2026 15:22:47.6305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hu6LvooczzpbVYBZkD1BwNFfihUWZv/VpVgF0obL9x05EF2TFDB0UZYKmCHjbEIn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB559726

On 9/27/2026 7:26 AM, 레드팀하고싶어요 wrote:
> Hi Namjae,
> 
> I found a TOCTOU race condition in ksmbd that allows an unauthenticated
> remote attacker to leak 23 bytes of kernel heap data per connection.
> 
> *Summary*
> 
> ksmbd_init_smb_server() in fs/smb/server/smb_common.c sets conn->ops
> based on the protocol identifier of each incoming request. The guard
> variable conn->need_neg is only cleared asynchronously by the kworker in
> smb2_handle_negotiate() (fs/smb/server/smb2pdu.c:1852). When an attacker
> sends two requests back-to-back on one TCP connection before the kworker
> processes the first, the second request overwrites conn->ops, causing
> protocol confusion.
> 
> *Root Cause*
> 
> The connection handler thread calls ksmbd_init_smb_server() for each
> request in its receive loop (connection.c, ksmbd_conn_handler_loop).
> Each call checks conn->need_neg; if true, it sets conn->ops to either
> smb1_server_ops or smb3_11_server_ops depending on the protocol
> identifier. Critically, init_smb3_11_server() does NOT clear
> conn->need_neg (only smb2_handle_negotiate does, line 1852 of
> smb2pdu.c), so every request that arrives before the negotiate kworker
> runs will re-enter this branch and overwrite conn->ops.

This is a good find and as a pre-auth vulnerability, very serious.
Thanks for the detailed analysis.

It seems however that it's actually two issues, the "need_neg" one
is just a gateway to access the second. Are there actually two
defects here, ans should they be classified and patched separately?

Other than that, each patch looks good.

Reviewed-by: Tom Talpey <tom@talpey.com>
> 
> The race window is large: SMB2_MAX_CREDITS (8192) concurrent requests
> are allowed by default.
> 
> *Exploit Scenario*
> 
> 1. Attacker sends [SMB1 NEGOTIATE (40 bytes)] + [SMB2 NEGOTIATE (>=66
>     bytes)] in a single TCP segment on one connection.
> 
> 2. Connection handler processes request A (SMB1):
>     - ksmbd_init_smb_server() sees need_neg==true, proto==SMB1
>     - Sets conn->ops = smb1_server_ops
>     - Allocates kmalloc-64 for the 40-byte PDU (+4 RFC1002 +1 = 45 bytes)
>     - Queues work A to kworker
> 
> 3. Connection handler processes request B (SMB2), before kworker runs:
>     - ksmbd_init_smb_server() still sees need_neg==true, proto==SMB2
>     - Overwrites conn->ops = smb3_11_server_ops
> 
> 4. kworker picks up work A:
>     - Calls conn->ops->init_rsp_hdr(work), which is now init_smb2_rsp_hdr
>     - init_smb2_rsp_hdr reads struct smb2_hdr (64 bytes) from a 40-byte
>       request buffer:
>       - SessionId at offset 40 (8 bytes): 3 bytes in-bounds + 5 OOB
>       - Signature at offset 48 (16 bytes): entirely OOB, 2 past alloc end
>     - Total: 23 bytes read from adjacent kmalloc-64 slab objects
>     - These bytes are copied into the response header and sent to the
>       attacker over the network
> 
> *Impact*
> 
> - Pre-authentication: no credentials required, just a TCP connection to
>    port 445
> - Information disclosure: 23 bytes of adjacent kernel slab data per
>    connection, repeatable
> - Potential for KASLR bypass or credential recovery depending on what
>    occupies adjacent kmalloc-64 objects
> - CWE-362 (Race Condition), CWE-125 (Out-of-bounds Read)
> 
> *CVSS*
> 
> CVSS:4.0/AV:N/AC:L/AT:N/PR:N/UI:N/VC:H/VI:N/VA:N/SC:N/SI:N/SA:N (8.7 High)
> 
> Without KASAN the OOB read is silent (no crash); with KASAN enabled it
> triggers a panic. Production kernels do not typically run KASAN, so the
> primary impact is data leakage, not denial of service.
> 
> *Affected Versions*
> 
> Confirmed on Linux 7.3-rc2 (commit df2908090). The vulnerable code
> pattern (need_neg cleared only in smb2_handle_negotiate, not in
> ksmbd_init_smb_server) appears present since ksmbd's initial merge.
> 
> *Reproduction*
> 
> Environment: QEMU/KVM guest running KASAN-enabled 7.3-rc2 kernel with
> ksmbd configured (port 445), host forwarding 10445 to guest 445.
> 
> PoC (Python 3, single script):
> 
>      import socket, struct, time
> 
>      def nbss(body):
>          return struct.pack(">I", len(body)) + body
> 
>      def smb1_neg():
>          buf = bytearray(40)
>          buf[0:4] = b"\xffSMB"
>          buf[4] = 0x72
>          return bytes(buf)
> 
>      def smb2_neg():
>          hdr = struct.pack("<4sHHIHHIIQ8sQ16s",
>              b"\xfeSMB", 64, 0, 0, 0, 31, 0, 0, 0,
>              b"\x00"*8, 0, b"\x00"*16)
>          body = struct.pack("<HHHHI16sIHH",
>              36, 2, 1, 0, 0x7f, b"\x00"*16, 0, 0, 0)
>          return hdr + body + struct.pack("<HH", 0x0311, 0x0300)
> 
>      s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
>      s.connect(("TARGET_IP", 445))
>      s.sendall(nbss(smb1_neg()) + nbss(smb2_neg()))
>      time.sleep(0.3)
>      # Check dmesg/serial for KASAN slab-out-of-bounds in init_smb2_rsp_hdr
> 
> KASAN output (abbreviated):
> 
>      BUG: KASAN: slab-out-of-bounds in init_smb2_rsp_hdr+0x640/0x720
>      Read of size 8 at addr ffff88800f60c5ac by task kworker/0:0/29466
>      Workqueue: ksmbd-io handle_ksmbd_work
> 
> *Proposed Fix*
> 
> Patch attached. Two changes:
> 
> 1. Set conn->need_neg = false in ksmbd_init_smb_server() before calling
>     init_smb1_server()/init_smb3_11_server(), preventing a second request
>     from re-entering the negotiation setup path.
> 
> 2. Add a buffer size check in init_smb2_rsp_hdr() as defense in depth.
> 
> Please assign a CVE via the kernel.org <http://kernel.org> CNA.
> 
> Regards,
> ihopenre-eng
> Github : ihopenre-eng

