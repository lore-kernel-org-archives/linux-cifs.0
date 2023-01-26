Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051E4C05027
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Jan 2023 19:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjAZTWr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Jan 2023 14:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjAZTWq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Jan 2023 14:22:46 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DBE23D9E
        for <linux-cifs@vger.kernel.org>; Thu, 26 Jan 2023 11:22:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5Z8gEHhSMbqaxYrTG2daadKSXjrvTxpuvZvMALOGh8MSlbVsRDYTchiei46J1ilj0Z/YQVhpG755fSVi3px7PiXyAlbIuYmSjV0APVhpbLdEJRkiB3azoEmy9LeFPm8irsLPR4fN5R6NbDjCWLzT+3dLB/qR+mQ8mHPmqtLvfxhcxrn/L8HXJrW0+D0qvsi7kCn/U+DBdAbOHAipOl8bLKmvR9nk3L2AE4eUPkpUnvmf+McgaCEkiEUXDBKaONQjhAFhGuqHdSqxBZSl5s4qUxH6DjdTm5M3i8VqlHOy1AFU+lO5CmhsJ2gaoSD73wMT4HvPgaa0SqGi+VbKQFfEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J630dYvXjiSLnJmH6WHrz9qn0XBukIajpQ8z0AnHefY=;
 b=ZgenDqPeh+ZZhT//7UNmyALagNf+mYbM1t67UH71jZ0yZI/MGuFRhy09DFAJv+cO3vMEamWRYohDEXk4biVjTFbIvrAgFZrud1r1PWCNULh0V8jJuJpTb26Z0P/5G6enkrLt+DTFFqxtIv71ozAC1eB44b3s12K2/3F8xEDzh6rC+aMRn5ncJw5AKTULYHLrvhpJ6H376Zlo3VFpszuGlrM6TK8fUvRiwSVGIjtZvd6xTkiWFT+8VJ6YpVOgin4xY7in3o04whBuWgdR3Kpir9kH8q1V8cqQ9oFGO2PDtwGQGJTxNDy2Syxm+GZL5+5sdTB4rtVPXwxQ7eKpExvQrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB4245.prod.exchangelabs.com (2603:10b6:a03:5d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Thu, 26 Jan 2023 19:22:37 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 19:22:37 +0000
Message-ID: <c0bc974c-22f2-31ed-80b5-b5ec0103823f@talpey.com>
Date:   Thu, 26 Jan 2023 14:22:36 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in
 reconnect
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
References: <0d4d0b2f-bb2b-a69b-2009-8c883119c10d@talpey.com>
 <1130899.1674582538@warthog.procyon.org.uk>
 <2132364.1674655333@warthog.procyon.org.uk>
 <2861100.1674746423@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <2861100.1674746423@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0401.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::16) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BYAPR01MB4245:EE_
X-MS-Office365-Filtering-Correlation-Id: 15dc966c-f5dc-4573-c1bf-08daffd2af44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I4eWUx/BPwnHtRKvYnr2K8vFcxFeNdNPIxGn0IHQY1BOEbeFQKHYLdcG6vRVYoKzR33T6bF/ZDljQ4AcByIdokLhykl2myFcS24X80rVTzLh4AOKvR1iAQK1rr6Dsah6LNjiCoEwrPYpGvk3+oqzp/pelrzzeCg7kF8BJQoIR29lIAQJGzeURaRHKlkX54icCqTpRzapZjiTQWwsSZYDWws1c+twMmKj74qk6z73cpfa2x6rxUpyqJhMlyv5BJqyDL3NBysVwnw0EgpvKWRHeXi0tlD9+WY3+z+Ez9k9Us+Ebe+mQ/Ufc9yYeRcwEJm/m6+W/kB0OcqDZafggKJO+kPxMi/CxZg5eehPrsU1c3AU2FDH0DotzZ6sD/FloFMp1aRMAripWikqiwLa9BX5Ulim+H/rWwRz7lRE/+O1MCBkikY9o+g7UvlD6Mjo3W1no5ZdSaAlV/fKfoz3TvbHtwYNdf4kh3dqX2vKOA9uTqxBM0osJxmj8oMP2JFjNxnvgT/WloBVDSZaDly7vB7Ce5foa0y0yy+MyV8+ozaXtVBGmUMht2VQdy+C4ayVfBmvy6yH9g/yZNr1MGVch0mIn25Z49/yYLcSOnx8CAwr7UFJkCZDBwyUAi1oPqLMjuIe75qzgGVwarYE8Etl7fjXt+OPrh6Cx8iXEVPRER9001Dazyij9QLBYJBB/wNPSNbktmSCzcY5ujBT7BMsJq5zBXlk3/g+RrAGcJaVkLXoGO8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(39830400003)(136003)(376002)(366004)(346002)(396003)(451199018)(66946007)(86362001)(316002)(66476007)(4326008)(6916009)(36756003)(31696002)(186003)(38350700002)(5660300002)(31686004)(2616005)(41300700001)(38100700002)(8936002)(2906002)(8676002)(6506007)(53546011)(6512007)(6486002)(26005)(54906003)(66556008)(478600001)(52116002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVovNmdrM0Z6aDExMEhYNXJVZXlEUjQzeHlTd3RpWnVDejN2Sll0N0hkbUtO?=
 =?utf-8?B?Z2g5c0Mzc3B2ZFptQjQ4dVFjUytXdzA3eXpEQWNOTDYyaXg0ckhYeVJmVkkv?=
 =?utf-8?B?VGtGbERKZ1lBaG9pLzN1aWRxT0NSREFiTHlxVTlBWlBpWHA4anhDbklQNHhC?=
 =?utf-8?B?TE9SWlhLZDFXVGVPTkdMSStudmxYS095UkE1K0s1U1pFNmlOelI1ZGVmb0FS?=
 =?utf-8?B?dXVoRG1WLzdER0NVMWFaNWhJVDlOTUIyd0hEMTczZkVtTU1kNG90bk5NVmdl?=
 =?utf-8?B?Rk9YUXE1SXhtZjNoYWgwNlVldDRJNUVHVEVMNzlYZklPckR4dnpZWmZkZk5C?=
 =?utf-8?B?cUMvT1FyUExHTW5hYU1xditGVFlCMkFMdlZVSjBWWWNpd0V0dG1CNjJLM3Bw?=
 =?utf-8?B?VnRNUjkvdnVsQVpJOFpmeFNvbmZ1NWpWSXY4Rm1FVkljOHB0L0szOE9mT00x?=
 =?utf-8?B?Y1BNR0J4ZlJybWFFdGxPZ3ZYVjNmQXJ1NVRlb2xQUFpPUHphZEdSUHAycWVQ?=
 =?utf-8?B?UmY5N2JySUc5OWwzTGxwSVBHN2cwRVdFUlRsb1BUWlc2Wm5KNXh5QjUzS0JN?=
 =?utf-8?B?aEZiNVFJMU9zczh4ek5BYVF4bHFCOXBNYWcyZlVJcVBjYUNOckkyMkloL2xE?=
 =?utf-8?B?NlI4YnRCaVh1R05zaGxyRmd0VGtpSm5QR3JBOEp2SzRDM3Q4MW05aEFTLzN3?=
 =?utf-8?B?U09yY0YxaGxuR3d1dTBnVmkyZUprVFNxYWhVYklEZUNYU01SU0poNzg3VzNU?=
 =?utf-8?B?S3NZMXN1UHQrUnVQNzR0LytlVUZzT3NaTHVwYzFQZXA2V2ZFY0RyZWNveHJz?=
 =?utf-8?B?WCtkNnNyMDNXdzM2cHNiUDBuKzF5NFlnbTFlVE0rbWpwLytSUUZNa09nNmdB?=
 =?utf-8?B?czN0N0owQkM0THJuMWVHNmRMcjc0dmlFWU91TjdqeHhiQ21LdHRwQnIwWFZy?=
 =?utf-8?B?UWFpcXNmNWJ0S2NlcHAwVG5naVp4RzVENUdPVlZCMWdkMXVBSk4rQU1POU9q?=
 =?utf-8?B?emxoeXRmZHBCT2w5VXNOcTEyTENrVDV3clN1bUdCeCsvWHhTZDBxallDdUpE?=
 =?utf-8?B?Yk1jZEhqcGFnQnlhQ21SY1FtTUFRODZleDY5Nm1mbSt5ays4Ym5HUGpZaGVy?=
 =?utf-8?B?NDhWMy9BMGpvYm9GeEtJcklKSGh0MExsd2tycnl3K1l5MnF6bWtCbWlZMVBu?=
 =?utf-8?B?akx1Mmwrcml3M3dlenJsck9DNm81UnpWSlNZNHFPaFY0T0ozZjVnSnBJTDZT?=
 =?utf-8?B?ZEE5RUIzL3FDUE5KemZZUGlnbWh5VG9EakMwQkl4RjdjUzNJTzlwalBNbHph?=
 =?utf-8?B?d0IySHFPZ1JiOHJveFNDUGJjN1l0Mnh3Wk5Bd20vekhnRks4MGZPMU5ja2c0?=
 =?utf-8?B?R1hPSC9LQWpOT3VpZGdzZE1BUUlvdElFQUNnQ1VXTmd2SWlxUjhBSHAyREdM?=
 =?utf-8?B?TStUcEdNVS9vNjRWQ21KZzBzclcvNUoxckdGS2JNcnhScHJ0R2pWUUo4TCtD?=
 =?utf-8?B?SkpQSEppa2N4ZWN5SEdVYzQrdUgzN0R0Snp0ckZleHZiUXNsUGZOaDVKTE14?=
 =?utf-8?B?aEI5MFZTSjhnK1VZOEFDcThzZzBuMzhMZDZIQ1R6ayt4aE9DUGVPOTBGSDVH?=
 =?utf-8?B?dG1laXdlZ1h4Z21PQWhNM1N6dWprSHQzSThZKzRhYXhScjFJQ2xsd3VmM2do?=
 =?utf-8?B?T2c5c0tPL2lMRnJCSDhUMDc1eW1PS0pJcmpKdEJZd0JmUEdaRmVLQU5MNE8z?=
 =?utf-8?B?MGxHWk5LRFB2VkV2QlJxTFRXTFFtOU1mM00rWVdVd3Ntd2FFa0txK0p2MEMy?=
 =?utf-8?B?ak0wUlRneVFueEdCTEhjRko5UTc1TE5Kc1VoQU0wTXB0SHhXQUdISVhNLzFH?=
 =?utf-8?B?QkhpeWdYY1FoN0dNa0JicDFSN00xeW9Pd04zcE5TZCtPZU54eWp3SFRvN3gw?=
 =?utf-8?B?clVzY1lMelNDN09VYmVieGhwVWRycXdXSzNqelhYOGVkR1hQNURLanRLbmM4?=
 =?utf-8?B?ZFNqVW5UNFBkbnNwVjBWRmxWYTJ4bDNhcmZNcDI4VlJnb3lZTnQvdlNLT2Ns?=
 =?utf-8?B?cHNUbCtySXBrNnlkbGpmUm1JU2VhUU16dnpLTk9TRHJlS1pPZzIvc1piUFhD?=
 =?utf-8?Q?1MfMBaja3tey48er91K1Us/nK?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dc966c-f5dc-4573-c1bf-08daffd2af44
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 19:22:37.6330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z4GTgD3LDMAS1ci2wz/lgKgquAux+RNeO76PoAAPMJsVdHoCH7hMqHIzBDNto9at
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB4245
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/26/2023 10:20 AM, David Howells wrote:
> Tom Talpey <tom@talpey.com> wrote:
> 
>> Do you have any logging from the softRoCE runs? I'd suspect some
>> kind of RDMA-specific scatter/gather overflow which might be
>> server-side as easily as client-side.
>>
>> On client, try:
>>    echo 0x1ff >/sys/module/cifs/parameters/smbd_logging_class
>>
>> On server:
>>     ksmbd.control -d conn
>>     ksmbd.control -d rdma
> 
> Okay, on -rc5 without my patches, using:
> 
> # rdma link add rxe0 type rxe netdev enp6s0 # andromeda, softRoCE
> # mount //192.168.6.1/test /xfstest.test -o user=shares,pass=foobar,rdma
> # dd if=/dev/zero of=/xfstest.test/hello2 bs=16k count=1 oflag=direct conv=notrunc seek=2
> 
> the dd hangs.  I've captured the client and server logging you requested plus
> a pcap file on the server (see attached).
> 
> Note also I tried md5summing a 1MiB file and that produced a different MD5 sum
> each time.  I couldn't see enough data being transferred in the pcap to
> indicate that that was happening.

It looks like the server is seeing transmit timeouts on its responses,
there are 7 of these in server-log.txt:

[3700697.936899] ksmbd: smb_direct: read/write error. opcode = 0, status 
= transport retry counter exceeded(12)
[3700697.937043] ksmbd: Failed to send message: -107

Maybe this is a softiWARP issue?


