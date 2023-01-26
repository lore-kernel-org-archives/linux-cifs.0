Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52AA3C05027
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Jan 2023 20:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjAZU3a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Jan 2023 15:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjAZU33 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Jan 2023 15:29:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7DD4B8AE
        for <linux-cifs@vger.kernel.org>; Thu, 26 Jan 2023 12:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oRzOkFi45rWpxKwT1xJO+ggUjZY5UNuqhVa0MR+twjXJpVr+r0iAwKGEqb+NBxLFNIo/7PXzJ+YjMiR7KPoT7GnSwxXOiDFmaXMnfmZPVM/15XSHz5nkC8xJheraIl88K42jSM/fuZxRoVpT8Puu0KV7dNHNjcV5YbH5DXY5GAjHiKL7samHN7nXXYs3J3Jfkx9Ho1ag0Vumt24+kAB3f2qscfO9Px6jddVUXeg77MjhGHw23X13g30Qo+DvLiLJl6RTO5tm8KbnCH2osKKgSoBjH0XIpOd1RItn7Fiz1yq0Au5uZkIGyUPhyRxSA2rHl1qVIwk5OGaMW3aEQwI19A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JkuUYUvgwEGcNAUuVymZSNA/QuMXk+/mN5G5JneSvo=;
 b=il7/C9yndOcuZBjFDcAL7O9YepyLkgxefZAd4efJfAkuQ02ICcU99xSG9hBUyuI/CMDzalsT6vVTnIZUexNp3hTfR2cJ+ieQds0vVCt4V7itLbdYmIcqtxWDYG4h4ZNpaA8CAN8EI/sRTNWGwI9W7XZwBMEoZt1hIRt8Nms6T1hBOR7MBtaoa8BScWf949XPMc/AtqwQzthy0/hoBWSp6OqgMsgIhevJhoovLgRcvK04euRCQsMFFuLJgfU+ftCzC9tw6yGmsRTQorbAVVUDgrRxtYaSgYozm+RUXtNmvu106fzNYfkp2MPsSyonjV/TFwycL9P/sVUNaxpIQBIQhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4496.prod.exchangelabs.com (2603:10b6:805:e4::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21; Thu, 26 Jan 2023 20:29:27 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 20:29:27 +0000
Message-ID: <104c2782-4d9a-22ce-d680-08d01733fb4e@talpey.com>
Date:   Thu, 26 Jan 2023 15:29:25 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: pcap of misbehaving fallocate over cifs rdma
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Steve French <smfrench@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
References: <CAH2r5mupuFEw4hY7uOYjeHi08pS9vv3n30KppR_CTrKZ4xAdnw@mail.gmail.com>
 <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com>
 <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com>
 <1130899.1674582538@warthog.procyon.org.uk>
 <2132364.1674655333@warthog.procyon.org.uk>
 <2302242.1674679279@warthog.procyon.org.uk>
 <2341329.1674686619@warthog.procyon.org.uk>
 <06b1c12f-7662-d822-4c8d-4f76f7e8ab01@talpey.com>
 <2811906.1674744126@warthog.procyon.org.uk>
 <2896646.1674762874@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <2896646.1674762874@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: a72b5421-9fc4-43f8-bc78-08daffdc0516
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4cuYNafYrYE+fmX740JlyqgrciH4OFu3QP8BwFGMmY1CNl7eHo3FKMVzB3gR8Iy0m7NagvcBUriZjJfvF47ZS57bZJw3gJm/1kd0WNA2pcXqMM93Ja3h1BbbZw2ajFTJrOYJUGOXyeDBDfdQL40hkyWFO+OmZjTK6m6Da/CES1Jhfk8lRWN9Mb0YRcu5+a6q9BoYbkmK1TtYoAnF0cTVZ2dLxi+S8waz3occFqMXuM9kVxbV0I0LNAgQoMxqu+lvHNViXSORyOA+T3SRzWShBg8BexVfYOHmx3YqNWhPrtSWwqIwfeHNCzSGcuHWHkATmcb9cJ4CuVipFuIqZwhbGZI5psYK3563ornOG2MlwdggeGBHR7pEslOXpgMciKKd3CcNHG/DsPYJ8Dxf+KxrWbQNbbgvPwVmh5pqyYCsb2oiTFihtHIerw6NsBHpIwiHsCgVYO1eTbEirUL0Xrby+yfkGaDJb8fRBOI88l8Z2aKwtZXmTVL3KFCT3Y3+KoICvkYXcYvlN7SG1OOG7AfC2AlHOZuj7RXYuh7LPf+slb2fDy+w9Qw+BMIaFaVm7byeHDZVoCwDdIji34xPJKQGgaJsJe3z8+etgD8FqrbQG3Vdw/zVSJN0kiKuAdI9rhlKeK8A9j31yhtQOaVkqhC1TXHtjt5LP8qX+g72tWchDQQS2XSdWclX++jAoTCHHMEZaLJ7fOHXAy1aieNuu7Yhe84djqmCnfyYqgdrwiz7OWo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(376002)(346002)(451199018)(186003)(31686004)(36756003)(8676002)(31696002)(38100700002)(26005)(38350700002)(83380400001)(7416002)(66574015)(2616005)(86362001)(54906003)(6512007)(5660300002)(110136005)(478600001)(53546011)(41300700001)(6486002)(52116002)(6506007)(66476007)(66556008)(8936002)(2906002)(4326008)(316002)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NExZUjhRODFhSVdBSENHa2h1eTNjWkRVTzRrdHhJRWFVTWtCZ21aeXhzSmpR?=
 =?utf-8?B?b0locTNkeEh6S3lFdHVGZ3lFNGJYbGswcWtIVG5PTjZRaVJEeE5FeHBmVFV5?=
 =?utf-8?B?V2d4R2EzdFVCTjRmdmJIZE9LU0NCSzBJRU00bzFWak9QODY5bU5mcTJqZ3kr?=
 =?utf-8?B?V2J4ZFdXNkVOZmVGdUpHc0hFbGJLVjdYSU1EaDVLK1c4R0VBSFNhdWQ3S1Rl?=
 =?utf-8?B?VVpMWVFpaC9wTUpWb3BXcWZTd0hnS25nTzBNNlJJWFhtOTNBZXZ3OENwYXVi?=
 =?utf-8?B?eUlNTTZITjZxUEJPNEZMSks0TjQxekRIU2p5RFlnNFhwS3J0ODZQd1pzU1VO?=
 =?utf-8?B?ZWNTNUdxTkdDTllKVEkvYWFsY3VIMzRtMUYrSHNtbUhTSGo4Y3RrRkljcElp?=
 =?utf-8?B?cXRCNU1penZid1ZHYUVKRVdtSTJWWmNnMEY5c1k0OGpWTW9CT0dEZlpVSTNm?=
 =?utf-8?B?TXlsbmEyWmZBNE4ySm5teDZOMlJWK0hRejNEYUw2TFNnc0s1NzBBSHM1T1Ju?=
 =?utf-8?B?K2lUZHRQZG9MQlhDOVYwQ01BMzdtT2tTMEErZnRHTGt2a1h5blFFb1hGM0c2?=
 =?utf-8?B?YUpsRDdJU2E1dmtqWXRpRnV6b3dScE81bU9SL1JDd2tPSHR0b3pmQnNGOUVX?=
 =?utf-8?B?SktMT1paRjF6N0w0aVdhbHlmR0dibUZmV0ZUTEt4TXo1MGlvaElFS3k2WjZV?=
 =?utf-8?B?UTd1NlVZVFlkUkRVRTB5S2VSeG5NMjFrODJtU01HM3YrRnA3cFppcDVtdzdM?=
 =?utf-8?B?S1UyU1FRdDJhOGtlRmY3SUVSWGJVbGQrYkVqRkRaME9YRTNTWHpOT3VBZDZB?=
 =?utf-8?B?eFZOTXg3V0JJNjFobUdGZ2pLWTlyOWpiMGJDRHRHTW1Cbm1uT2JXaStjY0NL?=
 =?utf-8?B?a1UxUjJPa2U1Q2ZrY3lhUDVQbjJWMjhQSmozcWRRMlRiVGlWblc2bHNoRDJ1?=
 =?utf-8?B?MXZVUVNQekRUeUlVN0dNU0RFMkNWTTJITVVFdnhTRE9McktyWWI5dHJEdDJz?=
 =?utf-8?B?cG5zMkdFNGJ6d1lVblFIZDc2cUNCdWFCYlpxMkxSbVdOSExaVGs1S3R1ZGJJ?=
 =?utf-8?B?RUFjVlB2VWQyY05pdWRoT2V1UnFFbUUwZW50aXFvWmsyLzZPbVZnU0lkc3RJ?=
 =?utf-8?B?b08yUWZoUGVZdStsS285c2R0bm0vTHVBYTNuNXoxUTdUdHduODdoTnJFNjd0?=
 =?utf-8?B?b0kxY3EwcG4rdit2ak1CUkN5OTJROXNSeFNPbWcyRUVXcUFHNXdPRnJmMjlX?=
 =?utf-8?B?US92czNSTU5tcGxVNm9GWDhFcnBGT2RiYzg4cXFjUms3VkkrTi9zOGJvdkE4?=
 =?utf-8?B?UXU0ZmJ6TDNqSHpqRHV1WWdNb2JHY1RSS3Z3RngvcWFOQkJrTzNBeDFKeXpv?=
 =?utf-8?B?Ty9nRzBPSkExNG91Ump5TTVkQXJjdEM2aHdBY0VWenlHVndvYlRNMzV1MGNo?=
 =?utf-8?B?cDNjdEhhN1JySjBkdVE0Q25pUm85anRZNjFZLzhuNWNaYnB6SUhnQm9ZZ3JF?=
 =?utf-8?B?MkRkQ0s2VlExNzNiR1AxaXg1U3N3blJiNERTMTUxemJFSEpPY0lmRkJ5OTU1?=
 =?utf-8?B?MVAwK0JBU1hDM05mRkRTUGkyamtxMkhBN2VyU1VTSW9RVTNmNkplTkROUnJE?=
 =?utf-8?B?VU1aUTcwVWl5VmQvS3lHdzA4NkxlRWFtR0YxQUNEWUdqU2VBbTRzM1lSb3BQ?=
 =?utf-8?B?UjR2UVBTMmk3V2VWV2JZWUVvRURRWUQrUDdBc2t0ZXdhRy8vdGxaMm9tMkV4?=
 =?utf-8?B?clgxdlVuNm1pcGpyeGtDbU1VVENrT0crMzk1NE1MU0dabzNKbmJrRGFlVWFi?=
 =?utf-8?B?UGpWbFVPaExXUTBCTDRoaG42Z0ZJZ1lkN0U2OXJ6WGxyUGUvMFdkSGJDdklW?=
 =?utf-8?B?MDVIL201dzg2YmpSMnFKMUVXaWU4TjFkM1AyOFNidDNJN0VpaFk3VDZyVzdR?=
 =?utf-8?B?N3JOdVEvelV6RlVBYWZ3b2Y4MmF5emQwdm13QjdLTjVsT0YyUnVzUStmMmdL?=
 =?utf-8?B?QmRDR0ZaQ21heFF6R2VtUjNxc29hVW0wK1NxYjR0U0N5d0xpODA2bmdDdWtH?=
 =?utf-8?B?WDJqQjI1dW1hMHE5cDc3VGJPMXZTeGRSNXJNaUlFZlVhcTIwZlFRM2JPZUhD?=
 =?utf-8?Q?FrzEGggS68cLmu5GpeElkC+TV?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a72b5421-9fc4-43f8-bc78-08daffdc0516
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 20:29:27.1016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4eeShW3jb8cmP0dfz2jvSwWec5DdCqwdclwLof5r0oM2Smi6BAH5RkCjc6StTwLc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4496
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/26/2023 2:54 PM, David Howells wrote:
> Steve French <smfrench@gmail.com> wrote:
> 
>> I am puzzled ... you show the fallocate failing but why do you mention
>> it sending data, sending writes
> 
> smb3_simple_fallocate_write_range() sends data.
> 
>> - when I try the fallocate you pasted above I see what is in the attached
>> screenshot go over the network (no writes) - and your example looks like it
>> simply doesn't send anything then resets the session at frame 93
> 
> Look at frame 92.  That's the concluding packet of the write performed by
> smb3_simple_fallocate_write_range().
> 
>    74 4.568861795  192.168.6.2 -> 192.168.6.1  SMB2 250 Ioctl Request FSCTL_QUERY_ALLOCATED_RANGES File: hello
>     75 4.569429926  192.168.6.1 -> 192.168.6.2  SMB2 242 Ioctl Response FSCTL_QUERY_ALLOCATED_RANGES
>     77 4.680495774  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     78 4.680496219  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     79 4.680496364  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     80 4.680496552  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     81 4.680496698  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     82 4.680496844  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     83 4.680496989  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     84 4.680497177  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     88 4.680638842  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     89 4.680639016  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     90 4.680704523  192.168.6.1 -> 192.168.6.2  DDP/RDMA 114 5445 > 50018 Terminate [last DDP segment]
>     91 4.680735089  192.168.6.2 -> 192.168.6.1  DDP/RDMA 1514 50018 > 5445 Send [more DDP segments]
>     92 4.680735359  192.168.6.2 -> 192.168.6.1  SMB2 946 Write Request Len:16384 Off:204800 File: hello
> 

That's a really large SMBDirect Send operation, it looks like it's
trying to send the entire write in one message and it overflows
the receive buffer.

I'm still fighting with wireshark and can't decode the layers
above TCP. Can you look at the SMBDirect negotiation at the
start of the trace, and tell me what the max send/receive
values were set by each side?
