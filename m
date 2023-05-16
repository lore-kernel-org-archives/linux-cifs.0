Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B20C77B75
	for <linux-cifs@archiver.kernel.org>; Tue, 16 May 2023 18:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjEPSlQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 May 2023 14:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjEPSlP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 May 2023 14:41:15 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6683630F7
        for <linux-cifs@vger.kernel.org>; Tue, 16 May 2023 11:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4e5ibU5jwH9dZlrp+kfhMWNdwgrGnmM0ezDFTFYj6LbKoxP4WHtjeYbKHXa1l/9vSoiiUhnNdZHWLDrIVEXc08Pgc6kQ9UB8Ytlsl1Uxo0YqvhYPffQM/yqo6ZdGFxDKd921H/QOxHoWnvZNnOY5Y8qAZGgH9daT4wlN9AZSYYi74Ft8zEUdlkVlMOVwFzO4AMsTT9Orj9wshx9hXaPjhyk6jE7/tcRd+EfSoxWCI95kVqkRb4qerhEWzeemEZEd749GsvTE+T3aR5j+l1vsRgwyajVoh56GRZbT37tGGAM59NUOt6hm2/KO0ZFb3JA7aWVsb7HKJ2Hoj4wgf53Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBXpl6I5q5E6of1hPLPo95/GUjNgy496q4XGrFTsPYY=;
 b=Gx0E361BBPJjS3i7+sWzmaauhcK0masDU0uA2BFjGvfNPUvqqg4fRKFvcvgRU2tIgEuNREyCdujQUkBpwGxxFSyrpTK0AaeZLBCpySGMslyjC+BoBMO69O1Yue54MbW6KBFG9rbuck8zTeoyCloPzexCaBo9pZu/q7EFFnxeZYVi1yCA6DWCHkinTLBwUkO46wtTb9gvl8tHK4wgKvwzEMhg60U+RBloG6d0K5VQDjsWZCk8DQxUiVOaU9F7Y9m7efCiyTA7em7IocTKP7jvyp3JOhrg3MdDii5SzUBneiskdFbsvvZFxoNcm3HVr8bZLTlL5cGQrvzIJ1KV/htPvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR0102MB3551.prod.exchangelabs.com (2603:10b6:805:5::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.30; Tue, 16 May 2023 18:41:09 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::ef26:464c:ccdf:ee6b%6]) with mapi id 15.20.6387.029; Tue, 16 May 2023
 18:41:09 +0000
Message-ID: <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
Date:   Tue, 16 May 2023 14:41:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard
 links
Content-Language: en-US
To:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Rohith Surabattula <rohiths@microsoft.com>
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0163.namprd03.prod.outlook.com
 (2603:10b6:208:32f::7) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR0102MB3551:EE_
X-MS-Office365-Filtering-Correlation-Id: 89beb766-9cfa-4b24-4105-08db563d1d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yd53eNCGi8zLAKBvsBBfJVMjq17rRbIpPGE4mh1phISUxnJwTbgLXvR+ZX3Mavwqul08x+7t8kUE+uWm74RAczy5ZeBUyj59+8DvxLGQpdOYKHwnuUXoEycvaP1OB4+6qwP7iQF09MVdovSNMBEqQXzBmvEAX0nW6GaV0TyyXPtuAANYhWgQ1mYq4HS59uAwYPhGpP6Sj1Vmgn7WhcMo4teMJys/bxfp21DMMk8Wp3Ih3fm5JSWgySYJ7IxARstzB4X1+hV23DI55gSnvUhHhzkYoQHzByOUBcRYvD8tic1e8CrwLGo4KnmAeYTwRAPtVO3kQtRCAvcWBiEmjCe7hhi1XUC9N8kCZ8O82PxMcoySGjE4kOVT+Wqy71gxEKu60dVmAWCIr+IHFGVKVKAv33WUPvlPy9dMP3mHNsFyJTfnKmubw8/ufW50nX89a8sQbX4hcaM/Z5K3VTv9+azSRvDCS2Jgt2KMF76E0tBE4EcTJ9Jk9s7+ZThDz8ax1xkirJAEg2r2/niavVaSBzVCVnAGO71IbRK7hdTftkw7QqpAt10LdtfE2n9gvxBx1OYeUsSm04nNwUUL8TUtWoenB6Kxf+19dZ3I9ebyc0VBOwAvADGMId9rb94eXvLake4GmCdimm4uo4rBc6MUbo0YMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(366004)(376002)(136003)(39830400003)(451199021)(31686004)(4326008)(478600001)(66946007)(66556008)(66476007)(6486002)(316002)(86362001)(52116002)(45080400002)(54906003)(36756003)(6512007)(186003)(53546011)(26005)(6506007)(83380400001)(6666004)(8936002)(2906002)(5660300002)(8676002)(2616005)(38100700002)(41300700001)(31696002)(38350700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0ptMUxQR1pjZk9HVUduRjRxa2dWVk96NEJuQ0g1L1VwNmtUL2tIMUVHS3Nq?=
 =?utf-8?B?ZGRpR2xVelgvay9ydEM2dnRPTlcrZXRXN2JXcnpXVkZuWnpTWGlma2t5WG9B?=
 =?utf-8?B?TThjN0V3ZWhaSXlwandFUXdrME0rdlR0eWdCclpxcFYxcmhoN3hVSEt4dytM?=
 =?utf-8?B?c1JjTWt3MFl5dlFuSTVVZlV5S2N2NnduS2pHaVVzVkxSQTNROUpNT1JjWVBy?=
 =?utf-8?B?OWV3QzJYTWduK1pib0RVZDNuUWtTQ21yR3lEMnU1T21yUW8xdEpYeDE4YWZG?=
 =?utf-8?B?Z3dYSzJKNVZDM3YvN0huSy8wSFo4THA5RzBKOE9EMW9LM1BwMjkrUXBtZkY3?=
 =?utf-8?B?S0h1K2RYZEZ1YkM3ZXZ4WGRnYzlNRFlTOFBkZWFvS0QxVHBMYnQxbm0vcnVX?=
 =?utf-8?B?NlZJVGFub1owYTlDcXhBWXAybEVJWnNzSVdZai9kQlZSWVdYd2duekJ0dXN0?=
 =?utf-8?B?eHNTWXFnNi83K253V2wxSXJCMjJ4VTRkbU1seEluUm0zczZJcjdGUUlabnJR?=
 =?utf-8?B?VmNpWXQ2Yk5UTkx3dWhXZ1NtbW5jQzkvNkZCa1JuNTdXM3RrUVFzT0R2NXB0?=
 =?utf-8?B?REJReHlWUUR0eXQreU5sZk9UNk5KTGV0cE85ZWtsbGRhRWpqb1NqK1p0WXBl?=
 =?utf-8?B?Sm5KSnAwUGZNb09hbUZnODh3V3dIeUVIZXIzS1puOVk3WVIzVXREYnpKZ3Yx?=
 =?utf-8?B?eGRrb2lZemwzOEtyVU1LRmN4UmJhdHQzRGx3UW9HdGI5b1d4VVcxRU1ZQUx5?=
 =?utf-8?B?VnZ6bHoxRUl3MU1kZXFSbEdpTk1vRlF5eDFGZGFGb1drL1JVMlJZZ09oK2pv?=
 =?utf-8?B?UDVkcS9iQ1o4dm1BcXNXbkJyejNBZ0t4YTZmUXpQMW5MYXNEVExYNnRqd2NZ?=
 =?utf-8?B?Wmk4VnVweUloQjIxZ09Qd3dDQUNzU09lYlpFdWVvNDd5U0tYWGtvd2xLTlRU?=
 =?utf-8?B?c280b2dBaVVpU212Zi9PTWtuYm1taU5yZnNiTlVSSGdVTStoMWw4Zkh2Tllt?=
 =?utf-8?B?YXFpdFNOU2toM1F6OUFmZ01CSzNJMklwWnQyakN5S1BCRWtSbDVTR04yb2lL?=
 =?utf-8?B?Z0dOeDhSUGhPYkRuWTRvczdnb1YwZGR0bW1abkh2dG1sMy9sTUtOTlhYSkNj?=
 =?utf-8?B?d0ZoaktKSUV1TE52TXdNazZLZ0VOb2tzTWVnY3p5YU1sblFZbFlyYkNjWDNw?=
 =?utf-8?B?Sy9NQkVtQVdGS0VMTENHZWVnOFBKK3RuVzJ0OThSQ2FCdVBlWTJlWE81dWVH?=
 =?utf-8?B?TG1nSkc1cHJIRjBsYWdCN24rbi9RTjlsalpDbGU5ZW5tR1RJcXVVMHNYL0dq?=
 =?utf-8?B?VlpOS0hITDVxbkVRL2FmRVY2V1YrT1c4RGc1TnJPS2FmaVQ5L3l2OVQrU2VR?=
 =?utf-8?B?OHR3OVJKcTRqZkZLdG9JQ0Z6Wm5yeHNUM29qM3pSRGkyMGVNa2h2RVBlNXFZ?=
 =?utf-8?B?ek5DMk5mSm9YSVU5emU0dktzTGpEdXB1MEVzMUFtbkE3WGQwKyttanU5WnZY?=
 =?utf-8?B?MXZKSEdOOEFhMzZ3T05peGpFRXRGa0pybm5HSkc1OTBVMXVsSU8vWGI2SjNM?=
 =?utf-8?B?RkRwcnJ4NzdjL1NzQzVDVHJlWEJhTWZ0RHF2TmVkT2dkTlpEUWcwRmd5SHVP?=
 =?utf-8?B?Sjdvc2J1TXZteW1aUEVSMG1oNFIrV0dhMVBCV0ZSMzlwV3Rac3NPMHpmOVBq?=
 =?utf-8?B?MWdRMDJSVTRwWERFNFpVWVlTR1lHUExwQjJRUzExWTNZMmdyWUIwQ3hBWEZt?=
 =?utf-8?B?N1dsUGpkYTc2Sjg1U0d4VkQzSW1pekViM3JMTGZVTUhneGU0NDRUcjNyUUtG?=
 =?utf-8?B?QjFuY2JjODZqT1BnWGEyTjRMcE1EM3Q2N3ZGcWFJR0ZRaC82S1VOTUI2Q3Q3?=
 =?utf-8?B?N0pXa3ZGV3B3d0JTNDBML2N6QjJSVEdqUXAvcWZkU3F0bzlrRkdXWFZSaTU2?=
 =?utf-8?B?Z0MyeE16OHptVUVRN0JkSG90bjdHQ3l0ZU1TdFhoa2NBN0JPY1V0VHM1OVJJ?=
 =?utf-8?B?Skk2dnRwci9Ca3g5MktqKzBOSllvbVhmNlNPWVdDVy9FSFJqdk5zcFZISnQy?=
 =?utf-8?B?RENPekhiYmxlNjJQbG5uQWFCOHRtbGEybDBWV1d4V1lGZWRCTGxlZmNXS1FH?=
 =?utf-8?Q?EO5NHe5N+DWa5z7RfCgu6c0Wp?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89beb766-9cfa-4b24-4105-08db563d1d29
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2023 18:41:08.7339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fml9ha9oRjpayACVqN+BchHCn5mz9j9UM0dp1Pj2ui8zOWB33zwRLNGNYARZKjWb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3551
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 5/16/2023 11:01 AM, Ross Lagerwall wrote:
> Windows Server (tested with 2016) disallows opening the same inode via
> two different hardlinks at the same time. With deferred closes, this can
> result in unexpected behaviour as the following Python snippet shows:
> 
>      # Create file
>      fd = os.open('test', os.O_WRONLY|os.O_CREAT)
>      os.write(fd, b'foo')
>      os.close(fd)
> 
>      # Open and close the file to leave a pending deferred close
>      fd = os.open('test', os.O_RDONLY|os.O_DIRECT)
>      os.close(fd)
> 
>      # Try to open the file via a hard link
>      os.link('test', 'new')
>      newfd = os.open('new', os.O_RDONLY|os.O_DIRECT)
> 
> The final open returns EINVAL due to the server returning
> STATUS_INVALID_PARAMETER.

Good sleuthing. The hardlink behavior is slightly surprising, but
it is certainly the case that certain incompatible combinations of
open/create flags can conflict with other handles, including
cached opens.

> Fix this by closing any deferred closes that may be open via other hard
> links if we haven't successfully reused a cached handle.
> 
> Fixes: c3f207ab29f7 ("cifs: Deferred close for files")
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> ---
> 
> This is kind of an RFC. Is the server doing the wrong thing? Is it
> correct to work around this in the client?

By definition the server is doing what it does, and it's a moot
question whether it's appropriate to work around it. However, I don't
see this behavior explicitly stated in MS-FSA. And INVALID_PARAMETER
is a strange error code to return for this. Do you have a packet
trace? We should ask Microsoft.

>   fs/cifs/file.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index c5fcefdfd797..723cbc060f57 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -749,6 +749,7 @@ int cifs_open(struct inode *inode, struct file *file)
>   			_cifsFileInfo_put(cfile, true, false);
>   		}
>   	}
> +	cifs_close_deferred_file(CIFS_I(inode));

But, is this correct? I don't believe this function blocks. And I'm
not sure this triggers the close only in the case you've identified.

Tom.

>   	if (server->oplocks)
>   		oplock = REQ_OPLOCK;
