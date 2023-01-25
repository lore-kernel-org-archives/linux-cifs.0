Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7170FC54E94
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 22:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236141AbjAYW4s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 17:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbjAYW4r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 17:56:47 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B79458AE
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 14:56:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2nW8q1EzJri1BO3hnUpEZfpO8VWRJYGfOhwA1uiEPpjMbVWp1KZMo6b2KakF1VITvBk8dMiCoo1baN02E2q6F2/eRDNxS0VzGjMzmk/7ZltTAYH/26dCliGYB6BihQcT4g5aRhJ/jlA4UQU0QUg4zWl8ZM3XdQrKPL07VAjRrQ6iJu+CFGKYIT5ITFCcCaGZtE1C5bsASdqfEUMIslcvG0GAfY2g/3uIUkAcu1jJAeVhaFDWRveeZYFah2cIYHeQyiimyvHtPN9vNrMBceeyTFyt8NAJIZ9bqYYMJAdxzxA6h2TNXXHwPiq7qXSQLzpcmOGHDaVzsExqWuO+UwSRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dl1ISGw5C5F2wmtZ8wvaOg3EXZVVccOnJOfd76nzzPs=;
 b=NCA52DtZ37pPOJ0ixC3oHC/sOGsV+xLpS6w0Mjol94JuPpbLFyoKBjvWUylryP1vKlTL11eVebt11Urgp1ep016VfLgjYUglGhtnDe+xWVNOq3DE3s2BpUTdX7szs3u76fZIk6PLfp/hunofoFghkIhM5JuRK2luVXRNS6E2q+jIEBeDcJI3i7T2doOADj+xi5mHnMLQO3ciK+UnnLeg3ZSxe46Bs6ZMLi6T/VX7KU+BwOHeMiJgvQIJo88JYs549Y87ump3axctfAu0Mi5VPJMyAz6CKZlLaimb66v1G3dhAQmy2/Q91fAuuYIjNacbA1i8qsP/xrdvdrqk8nMXLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SJ2PR01MB8029.prod.exchangelabs.com (2603:10b6:a03:4c0::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 22:56:44 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 22:56:44 +0000
Message-ID: <06b1c12f-7662-d822-4c8d-4f76f7e8ab01@talpey.com>
Date:   Wed, 25 Jan 2023 17:56:42 -0500
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
References: <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com>
 <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com>
 <1130899.1674582538@warthog.procyon.org.uk>
 <2132364.1674655333@warthog.procyon.org.uk>
 <2302242.1674679279@warthog.procyon.org.uk>
 <2341329.1674686619@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <2341329.1674686619@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0038.prod.exchangelabs.com (2603:10b6:208:23f::7)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SJ2PR01MB8029:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e92de3-bbfe-4d7c-70fb-08daff276df2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LrykzJt2Mta0VAUPvf/dQyfe+6GFcYpBbHEnI0qSVvIVufEG+Vjzr5wEbVFHiI/r7grKuNyPwIO8D8sygWO2Cs2KdCtkNhd8oorajiMQ5Q0xqEvPMaAVrNKO2O8ukhY/IQLJEQjn20O7Xrro+9cFKRYpWvL6/Jq3pyvBafD+xx79tqS+Jc/TEwIwUJ3Z648/RFU5zVOhGDaYbbQSL5ESeVxc1XA8tmtGTxtCinKsIP5MUyZacImZH0bq+RMBfij6a68+3rlSJBnGF4baxks3qYZlkHXAuw+6x7pJt0KLdNbz+o+SWhUnTkKZHrITSb55J71DI6A7NVNj8VpsA2zNbaICe5TrA+IHlubFogfJ1mCB069HMw5ER5AnE6c5cKMTJexL6pKFUFltfSkJz4yuBETE8ZnWDop9kRjRQoyGH0H7xBFpBIJFDKFYX+izf3772MVRlKhzUZOrBLs32XWunKfZGtRIsIjtd48KcqvcUABXUGErhawpgNUFtex5EV9F2PHYF/m4wCMayG9+Iao2X3J3IFvReXfR/5PqfIwUvryETtlCbSQs06dQDdLEROhS4kl/GpC9O7eAfwuUJyWeZq5xk2P5DJZBRqyR30eb9gL0D3ti6aFw6Z2hGhKb2Z/F6vc/e8hfWN5AtJ1N0s9Cwmx2eLrS2f2T6x++hO3f9Wey4YmwWyvA2ollpI3aGqQ774tpBTwxnKAn5bJRJi+St26ishqg8AWKyWwURCysjeg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(136003)(39830400003)(376002)(451199018)(86362001)(31696002)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(52116002)(5660300002)(66946007)(6486002)(66556008)(4326008)(8676002)(66476007)(41300700001)(8936002)(6506007)(38100700002)(38350700002)(186003)(2616005)(31686004)(83380400001)(6512007)(26005)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGU5aTRlb3ROVHNnZ1BqbVJ5bTNIWlFJYjBTNkJINjhxUGU0RzY1c0E3WnBK?=
 =?utf-8?B?aVVEVGNnYVhnbkpqOVNYTXlIbEZQaUhya1hNa0U4UXBIVmdRNTJlQ2xTMEF6?=
 =?utf-8?B?ZEZPNGo2QjJzQjFVRWFXWHB6Z2o5dVdYL2RwdGFEbnZVMHJ5VXBMdnRvbWgx?=
 =?utf-8?B?NFQ4bS9HQkVlaS91OTlNbk5ZdzlJQmtZMVM3MG5sZGNsSUVLME00VW9OS1l2?=
 =?utf-8?B?OG02a0QvUTJxUERPeGhmU3M3MVErU3M1TENleTNmYUJCdXJvVStaMHZYby90?=
 =?utf-8?B?QXo2RUdIN2dzTThMWkVMNXFWT1ozM1JyQ29XZHZxRFhYTlRhcENFZ0JEdGFB?=
 =?utf-8?B?RlRIRytNejdMbFdJbTdvN1h0S3hNandhOXpxRkxUVDgvYTZHUDlvdmRvNlEw?=
 =?utf-8?B?OHRBR0JBelZHS2UzS3h6RUF5dXI4WjRuUEd4WEJGR29OdDBMN2dqNnZNWjVW?=
 =?utf-8?B?S1h0NzBiakt5QkFXTFUzRm1YS3dqek41UzV6WVJodWtWeTdFdHVHaS9aRmVp?=
 =?utf-8?B?d3QrcG8vMlovbVNYVlZaYlZHY2xOdmlaYU9HZ0g1VkdnbGl2M0IzVDZIaEZL?=
 =?utf-8?B?K1NDbFc0RFAyQ3JrRE5ZUHhab0I0V3h0bHdneE5EaVdaaHlnampPdmx1TUFr?=
 =?utf-8?B?eXo2dDhOSzhCZm5IM3QxVmkrWTR1QlgyczJKYkI5TDY0ek91c0l2VXdRNmlu?=
 =?utf-8?B?eTVOYjdCcGFhazBwM3dONVNhR0dEaTUycXhtZ0RqdGo4a3hXT3RhMExrU0dw?=
 =?utf-8?B?ek9lT3RHL3ZvdVA1Q2t6cUlVUkVrTDRRemNhWllxL0sxSk1Nc1Y2cmRMRFU2?=
 =?utf-8?B?N0lvb2dGSlErZDM4SXFzd3NjcFQ0eEZnM0gvMXhaUTcwOFgwMXh4THM1ZVN5?=
 =?utf-8?B?VDdoMC9iMDB1bENRdGJlQmdva0RETVJScVIxUzQ2TndvWUdiVS92em1NQThi?=
 =?utf-8?B?cDFGS2oyZEZoZ0UyNHlNcmxwQ0RTTFJaQTgrcHNxQmg5YjZFd3RFeitSK09B?=
 =?utf-8?B?UE5WS0FaSldGTFhXT2ExMkMrWGlUcEtJVEJ3ZGdwajliSElpUXgwbnArV3hT?=
 =?utf-8?B?OC80TndNRmc1VEhvTXNyMmpOY2RyNjVMN3ZvcXFmQVh5SGlTVVYwV1FOMUFN?=
 =?utf-8?B?YmdHa0Z3ZXBLN29WdEpGUGZTaFoxdmIyUG9DQTJTZWJuRHEwek04WUF6RFZP?=
 =?utf-8?B?elJaOXoxL2pCSmllV2UyZVU1aVZTZlBDK2ZjdWVUMUcvajllVmJMV3E5bU9O?=
 =?utf-8?B?MDFwa0syK0l0U2FkWDNidEo3NjZWRmxrQzJnUHdwQ2FVUnltQW1xSm4zWEdH?=
 =?utf-8?B?L0ViL082VWhJdy96M3hLUzI3SlF2OXlvNDJJbFJjUFNNR3RodC93Z3FtekhB?=
 =?utf-8?B?Q3pudUdUNll4eXpRN2FWaFpGcUFidmxaYVZYMDk4RE9sdDdVOWo5M1U4RG9L?=
 =?utf-8?B?RVpiLzFDendCQzNURTBmajM1SnJjd0FuWW8velAzNGJsNk5xUmJySFkycTVD?=
 =?utf-8?B?MjR2N3R4OGI5bjlhQUVTQ2JVbkQ4c0QzQ0VvTW1XREQ4NG1hMWhkdVE2R21w?=
 =?utf-8?B?NnA0M1VrRzhiTGlzemdGdHh5SVVjUlQzMWxWZ3NXWE15d3NxYnZyc0VhaEN2?=
 =?utf-8?B?ekxXWDJrSmlZbGFHVTdvaytUM2w1RWRGWHpOZGZ0ZEM2UDFsY3FVV2FOeWRK?=
 =?utf-8?B?dTdob29udnVQa1MwY0RGRlpOa2ZYOE1CejhVMEozdEZCdFVYVlV3SFdmQVlJ?=
 =?utf-8?B?MGZnUjZ0N1FWMlZyWmFodWZTekFlcm5odVkwN240dWJkUHE0UkNXZ2ZVUERk?=
 =?utf-8?B?YlZ0T2Izend4SktkazhrK2ZIc29SL0JaOUcyT2FVL0lzOWVOOFU4bkpQZkdC?=
 =?utf-8?B?ZTBiT251VFZ4MStDenNGR21pOFFsQmlFZHdzbWxMbVhrbTc4VlYxek80OUI5?=
 =?utf-8?B?SnlOWjNZNE1KNWh0L28wVXlGMUxhTEYweVdwckhXb0pPZEptMDFhMEp4RUx0?=
 =?utf-8?B?bWs4Wk5XTGJLblNXOVJNYnZlUWFocXlPS3kwWitZNVBtZFZhaE5uc2tMTHM2?=
 =?utf-8?B?dEs0Z05xMjZ0TlpVNTlxUEpNVGpVSzhBeHhGVUZjTGVDRCtwNXRoVnBaNmJB?=
 =?utf-8?Q?kNLy5cBC1Wjb1G1u39YiD2mp6?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e92de3-bbfe-4d7c-70fb-08daff276df2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 22:56:44.1165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lo5SOH5CidfxbQmUTh2ujFeRdUGW9KZavL3RDOD+XUL0hjC9jilsomcudpFre3Au
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8029
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/25/2023 5:43 PM, David Howells wrote:
> Tom Talpey <tom@talpey.com> wrote:
> 
>> What are you trying to test?
> 
> I'm trying to make sure my iteratorisation patches work, including with RDMA.
> I have some functions to decant some data an iterator either into a
> scatterlist and into an RDMA SGE array without the need to get refs on pages.

Most excellent. Great name for the task too. :)

There are going to be a couple of paths to test eventually. In the
non-encrypted case, the data will be coming down with a rather
different set of sges/segments than after it goes through the
scrambler.

Since we're not ready to implement the encrypted SMBDirect traffic
yet, it's best to put off the encrypted path work/testing, agree?

>> Since encrypted SMBDirect traffic is known to have an issue, I guess I'd
>> suggest turning off encryption-by-default on the share.
> 
> How do I do that?  In the ksmbd config?
> 
> 	[global]
> 		smb3 encryption = yes

That's definitely needed, but also check that the share stanzas
do not request encryption, as well.

Tom.
