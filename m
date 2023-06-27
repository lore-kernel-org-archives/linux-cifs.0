Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 148BBEB64DC
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Jun 2023 19:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjF0T2u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 15:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjF0T2t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 15:28:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3896C1BD5
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 12:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJLPVai+Ojssbu75lX9z+YuVbyMp60QLx3sYOl0TiOIIzYpeuvZT2riD9qAKIacz3mkhFqjHdlXkFpO+0/mWLk7K+j/syqnO9hoGwaj1Hhqmw2jr+0LPaehosVuKs7szgagf3RpRx2pX9VgQ6NBEjBpucLT1RVWqazidYdd7tSX2QCOGH6UAyAIdFI7aprJN/WchkreD2Jcj4TD0cApemCljnO/fdi4wu2efxQnWiP9qbud5IlQVVHdZV1SYiApWMeHyHenDmnSZmmMaO1J2+otW9fEbtqwAb/VKv2Xj0+HCJ5yUSi987qRdpvNBBu/AetEQ0Czkjj1Nz5gOJHITSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Op2NFuVLp5vS3zkLkCIjUbx4LDsI8ge6kK4PdqiuxQ=;
 b=b4MDMogXn8ueum6dVSvbAaLWoMANM+wJ3jzUKRYwhUllbga+r+VHnc8zSVLcyoHsEfryYe/+GaC/6Zdr4SHvXFl/aySzl11+3e1DUJd2a9GKlHoWLz1x6WewbT6X6yWfkcrY95GI1UXYqpqoxQZML2kVd94n+2BKUzWQGl8INHs273qGf7NONdhDqbXsyMTAq3Y39Zju4lh2dduIXP5tIenaSMXabnz8KcocX4ijwpty4cgr2bBHPjd+oQLSUaWWfkJnVXmL7JOyh758cU8Kkby65uWLb/whtis9D6KnIYqYulVL6Lmb4RuvcTQmV2xqxuyp99/rzzlPbWoTQpZQKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB7333.prod.exchangelabs.com (2603:10b6:510:dd::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.26; Tue, 27 Jun 2023 19:28:42 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Tue, 27 Jun 2023
 19:28:42 +0000
Message-ID: <a1006fe1-5be2-4e49-cf9e-cd1a23c213af@talpey.com>
Date:   Tue, 27 Jun 2023 15:28:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] cifs: print client_guid in DebugData
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
References: <20230627120943.16688-1-sprasad@microsoft.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20230627120943.16688-1-sprasad@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:207:3c::14) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 95be19eb-a086-4081-1085-08db7744b75e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFDMzUuSS4FIzzsDd/QmNStpqSUB2SMQ65YmHpaPSqDcxXBHYwdvd2Mei9xYsvuvhlb7Kfq3xgJ8e2xnyuStaBtiiaUaELyH6E/iTSVWDZvhNoix9+pmj+o/1/4ybE+LyOpiz45EyLTDnanAe4Z8irt4/Cvo7pEhERrRG+jp4ESn3yFZlTFlEKNi+EABdFKqFwJBI2wj69hwgkQ1YAbiMCB7wCs50GYJO0qxgxNUvGLjkD1seuinR6bsU71+vjAT3S8Nw7eWQevWo1Pb2Scc1vJLdgaWwDFbwGBMzuO99IyzoTOIRqlpAWhAcLfED41GynUX5dUO0JEaChuJ4M0dAq3yC8bhMSscSUeL/cc8Brg6u7MHVou4diPO8YJt0A4gZk3zDWxrgOc0iXDK3x4VtwVa8Tuo5xKT5f+b0H1+mvRtD7hAUU/uk+nQAQdjJtBvaxd+JR7rcjtqmUQhGriaphZRULo7B6DV+bblJibkcvLKYoGM+r8/0k0C/yze2QcE8g7Ie59mbyAdaXtr8X1Z5QGP5JAg3DATeJZjuzWo2U7439CVRT9cFkuMv6tE2FoH6y7+X63Rkr6Q67DoufU0LCwHD/wuBB8bWJcY/UetUfz5SsHlCeVUpvRXza7+j0vIiIMxC80EDwxZcZOzLCiGBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(39830400003)(136003)(376002)(366004)(451199021)(53546011)(31686004)(36756003)(316002)(5660300002)(86362001)(66476007)(8936002)(8676002)(31696002)(6512007)(66556008)(4326008)(38350700002)(66946007)(38100700002)(41300700001)(6486002)(26005)(186003)(45080400002)(83380400001)(6506007)(2906002)(2616005)(52116002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW5XcTcybjJnNWRVWE5ocnRWNU8vUFdDcUZRNFhMa3owODBXcWZ3ekRDMU1R?=
 =?utf-8?B?K1JQc3p5blNZc0ZPUFczZmJhaW1QZlpMSnIwb2JQNG8yZjQyT0ZFUmNKSWdu?=
 =?utf-8?B?UjdockVrNHg5MEVLR1ZuYVlYVlVCTFBkMDBFVFd6SG9LcXgxbTJVWlBJR2VX?=
 =?utf-8?B?MzBYUi9peG9ZOVBrWmlLV3ZlYWlmcnRGZUU4UHNjN2YveTlndEswY3FTWmZn?=
 =?utf-8?B?WE9zbWRUSlFCaVMrbURTT2lOSFBKNTU4ZngzR2huQkwxcWV1eTEyWndJYXY5?=
 =?utf-8?B?dWliQkhjTmZLN3J3ajJVMzZSQng0K0tXWjRQcTVYNU9JV3NaV3hzaHNJL2VP?=
 =?utf-8?B?cVdPTFpGWnRFS2dWdE1uRndiY2VwTDEyMHRnTTc3RTh4UmxncTFSMVhhKzNM?=
 =?utf-8?B?TE5leGEvMWxiUGNYVjN1LzhXRkhGT0s4d1R0OGJWVG5saFpDdkJSSzVTSmRJ?=
 =?utf-8?B?c3NjRWdMbTE0RVRhLzc1NVU5UDNwMUxHbWl3TlpjRThMT2ZZaS9QTjdxaTJJ?=
 =?utf-8?B?TlNUcWZrWWxhdjdIdkErWS9PTTVueU9CbUovTzQ2a3pobXgvVnZCdEVKY0ps?=
 =?utf-8?B?SHRxRmdXUG91Y2VUMjVsTE52U0VUM1Vram9zbzNhRThXalJINzB5YUEzcnNo?=
 =?utf-8?B?R1cydzlTTm9OVlJzaUN5bE1tbDJHK2piaFNxcEpPL0NndG9FQ25aY1dsYnQ3?=
 =?utf-8?B?U1dDQWtORmU3SllWZ3o1bXp0TEtBNUhQVnI1b0dJL1pQZkRMdDcvRHgxTXJP?=
 =?utf-8?B?NlNlblhSWEFJQnY4TlFyMFlTTS9udmZ2eVNSVDNXSkcyaXN0b2lUNnFDZnc1?=
 =?utf-8?B?K3FIazM5R1Jnb0p1N1dlRHk2eGZwcUpJbXcweDBCbktxUUZHbEUzTkwyMzJY?=
 =?utf-8?B?YXp1ZllKdW1vaXBpU0pPalkwVnFBNkQ0WXRJT0tJaGNwajhYem43di9mRDZV?=
 =?utf-8?B?bUlhVEMrY2FjZTc2M3dQa3V4WXFEa1ZxeUdjL09VeDI0d0lHK0R0T3RzdDFo?=
 =?utf-8?B?bTZ2NFZNWWIxVkY2c2NHbEgwUVVoVVZoa1VVb2dEZ2dqMU5MUW5QUVlJTDZq?=
 =?utf-8?B?dW1aaXl0Ym02ZCtvTHczNk9RdWpGSWZ3cjdNRmFEWGQ3SE5hSXFCNGljVU9T?=
 =?utf-8?B?TXNsYnQ3UlhDbGlZQk80MjVXZHpmT2JheGhEVDUyaitJZzJUbkNHYzFhdjlP?=
 =?utf-8?B?YlRjc3Q2M2VLZFFTUEdDVVZSVWRaUE5ObjQyN2NzZWRxaTJtV1pwZ3ZGTW44?=
 =?utf-8?B?Z3ZSSTFSZzQ3T01ESmRkN1FKREZESGhLMFRQVXFUN2h3RjdRei80U0NEd0Q4?=
 =?utf-8?B?ZkpYZ3E0NnAvVmVrc2orcGZjcDJGaXZkTHlmV2NSbklNNnNqc1dsWUNoQ1B0?=
 =?utf-8?B?OHY5RXpyaGxuODJIbHhvTmxKaFE5UURPUlZxUUNiUXRXY3EzUE9QbzhacFZL?=
 =?utf-8?B?eGJhQUdPZ0hYMStETnFvRGtHbW5QU0YxVGRESDlNZkg2U1UzZGwwcVFtVHlr?=
 =?utf-8?B?eEVNejVIZTdib1FJQmtCYmhjTGxaeno3Yy9HSWlVVEN2d3MrandVeXFxUU80?=
 =?utf-8?B?aFpCUnRDSy9ZQ3krWjQ3djN6Z2o3ZmVIWjYrSjg0aTJlWTZZTWlkVjljQUwz?=
 =?utf-8?B?c1JBMXZWZ3FFRFFBRE9MYWcxcXZEY3djZ2V1M3JtS3RQdVg3NG1odzkvSUIx?=
 =?utf-8?B?ZGRaZ1MxOStvdW1TNERsL09JQVJWalNDRVhmTkFkZmZwZ2FrUndXRmNNN1V3?=
 =?utf-8?B?N09WZDBQblZFK1BvVWJLTG1Kckp5REt4NThhQ0pQZnRYUGtmd2tmblBBUnI1?=
 =?utf-8?B?c1dLWjIxOUxlVjRNTU1rRVA1dDdaRGJXak1OUTdpSWFMWXVVSi80a3JOTEJO?=
 =?utf-8?B?WXJGeFlGaElMaVIyT1NPd2RGQ2F5Q3c4YlV0eElFTytMb1RHNDhxQzAzeHFy?=
 =?utf-8?B?Z0RSUDhHaThJdXdNeWNTQmdNK3ZrOEdvSSt2R3lpbFFIVm5CRlpzZkVkcGJr?=
 =?utf-8?B?OURiZ0VubnlIT0QyTndIbzRpa1UwdkJwUEQvd1pnNFNrZU9UdGFNYy9hTVd1?=
 =?utf-8?B?VEdHU09JbzNON1MwRVpad0wyRExsaG5zWTJLb0hGUkpnVW9QZEJpc2pWWm5B?=
 =?utf-8?Q?0RcrLmkp4YXtaJQmSWyTi0opc?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95be19eb-a086-4081-1085-08db7744b75e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2023 19:28:42.3003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OTMU6jtYGx9OpbISX3Z4AW611zSJsaX9zflVu9Aq2virZ53LgGapObxG6GfZ/BW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB7333
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/27/2023 8:09 AM, Shyam Prasad N wrote:
> Having the ClientGUID info makes it easier to debug
> issues related to a client on a server that serves a
> number of clients.
> 
> This change prints the ClientGUID in DebugData.

Good idea.

> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>   fs/smb/client/cifs_debug.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
> index 079c1df09172..f5af080ac100 100644
> --- a/fs/smb/client/cifs_debug.c
> +++ b/fs/smb/client/cifs_debug.c
> @@ -347,6 +347,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>   		spin_lock(&server->srv_lock);
>   		if (server->hostname)
>   			seq_printf(m, "Hostname: %s ", server->hostname);
> +		seq_printf(m, "\nClientGUID: %pUL", server->client_guid);
>   		spin_unlock(&server->srv_lock);

It's a totally minor thing, but does this code really need to
take the server lock? These elements never change anyway.

In any case:

Acked-by: Tom Talpey <tom@talpey.com>

>   #ifdef CONFIG_CIFS_SMB_DIRECT
>   		if (!server->rdma)
