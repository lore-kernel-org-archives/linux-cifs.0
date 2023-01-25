Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24710C54E94
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 15:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbjAYPwJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 10:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjAYPwJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 10:52:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B4E59994
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 07:52:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0gdxINrwKTW/cHZsXtbf0q0VuNwfG53ZchqwGru073CLrEkdLvTU/JDURgwxmxa1FehnAvhSnkU/7P18d4upXyi0IzzpcUfHgBYFExcUECicGpNwrzLHGKs8vmODnzdT+CAOnV3mKQanZWjFXZDY3ungw6HBfCpP1lnsYU/7ykM6eydOkXYlsie3p2rtikuBt1rEUE/UA8H8wB13ZxqWQMxeG73+ogaG54RS9C6Nvrh9z5TzHtm1WCY45AOB6iGeyzJCB9JxJWYRfVDcXm9rZ7IhE8x2rkhmDaMdf5SyjO1scvKGHMOWC+lK0jZVRIQVvLnSeiHCY4TdvvnS+PXnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjxQnFvE9wzlr1UbDQG2CQ/uCuPZqsKFbJq3IxtvaMs=;
 b=MbYKLk/yibjB8UZzT+5eotNDfFQ6kqCXOg3aMA7+JpCr8cf1lG7U5A+msUEJU3WoWjgV5CSjjiucrDyabzWoCflN8A+aUVWLt12EERgug+e5YpGktlgQqzM9LURkTEkfkqoaxWVdOVCIRCm4U74xTXfa/I4YE0t36ZEsQsrjF+8JxlmqrBO5KrW5vOVbwu0EHTQnSa3EHU0/psov5WCQ/VAQS4TRX9usV3CaM7NHbochcniyzipaxGzpqS3sevWLfxz8y6LzPOMkUvMqRRKC9Yysqik9ZCQtjW/K7ajpIvyv9q2ugZK/mrPL4ToB45bRqTcTIUwqOlpeaMIUhGD/lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB5074.prod.exchangelabs.com (2603:10b6:208:61::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 15:52:05 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 15:52:04 +0000
Message-ID: <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com>
Date:   Wed, 25 Jan 2023 10:52:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in
 reconnect
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Steve French <sfrench@samba.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
References: <1130899.1674582538@warthog.procyon.org.uk>
 <2132364.1674655333@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <2132364.1674655333@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL0PR01MB5074:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f6739a-ad30-4588-ac72-08dafeec1b29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3RBE04RxcGb7FztWEAgfn+4bGfsKJDJGLn4gT8VEHUe2GB/lxKnrp+Ad4EYjDG78MI6NOOhnhztx/DxgdUTeHHL1inIvbMGKkGU7FJrdyNBHluMgtGADxTKwOvMK0e29Pg7vP4Twmd7B94pUgYfcy+ELJRTwmxMCccOOBViHgjlgKHZvm1WvPhvb4sVLRqzPy43C2EMpIB1KBICe9SIn4pOvZqHcpRs4V7fPN/iwZZN0CTgbEc54UhNuEOBy8S5zApHVPhBwLYfbyteGCz8uk8BC8wBAQ4OhDXxjaCj62KCe5NWgSSsidKloECzVqQFjTKDf2SLTjYBTuJbQws6Vb4ViN3ioVmhwNG4pp7bfCF/ifoGrUm9scNZTzX+h0mI/1aZNyH4MZGnekEPh0zFcinQcIMOe39U3N9PyvFl2MuXZ296pEKttxcJhLg+IsT9qbxDlFZWiFvfPovn23r0fndsPQbJBi7pjflexUsvNaIPIgUt0ek39NXu6CKNWC9JvIPHtCBjY5i/c92G3oK+4nyp4VLRbMjiV1fR2IcU75OtaS8eGTac3iC/uKg4p/HE5OYyZqgA/3ywGp+4W2+wapiBzWp/6AbndoqBaqaXr4nM6bSyuQ7TsLehe9wRtNYC/A/QNRz8C25JDvz6zRSRNAWAzJTOVnnvvfygLoQLK4x1xIaqxKpCAU2swgtDWyZZ/bMKR/2JzXlN49UVQfd0HElmQ7jjnoXAIAahOMUq1QSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39830400003)(376002)(136003)(346002)(366004)(451199018)(31696002)(31686004)(38350700002)(2906002)(38100700002)(2616005)(36756003)(52116002)(316002)(110136005)(26005)(54906003)(6512007)(45080400002)(86362001)(4326008)(66556008)(8676002)(5660300002)(478600001)(66946007)(6486002)(53546011)(41300700001)(66476007)(8936002)(186003)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXdwZGpOdjdCMWlNUTdpYTA3UWRNMHVYcWc4d2N1Q0c2MXdtclhMMEhOUUdQ?=
 =?utf-8?B?UkNWckY3dFZPMWZaamN3S0t6YnR5YWxQeGpkS2IwbXVuQ0YrTlFCSC93cXNL?=
 =?utf-8?B?VGNrcjZhKzN5SUxodkZFT0VqN05kRlNKOHcwWnU1QnZZSW4zYTl6UFNyZnNu?=
 =?utf-8?B?OTZUa1pkWmFoenpBVGtVZGdXeTMwNlgyNldaVFpIWDAwWEs4TElJeU43SWFu?=
 =?utf-8?B?NWlWaC9TZVp2cWU0c0dUMlA0VDlkeTcyNWFkaWR3TlBIalhqaU5NNXl2a0Vw?=
 =?utf-8?B?ZFFTaTN1V3NOd3orT01jVnhiM3pLc1FaTXBhWWNXRmxIbldWSzVOdHhPYTh3?=
 =?utf-8?B?K090cVF5eVZHMU1PMkMySHVYa0MycGdabkxmeFAzVHdiTy84ZlNTckR2Nkpk?=
 =?utf-8?B?ajBmemNPY2VjRlVFaGdqekJudXRQajcwRXFXWnFKT0FackZOR1pZV3pqNW5J?=
 =?utf-8?B?bXBPWStxUnZaeExxQjExemtmVXhxVmZPTkhPYlVkMVFFVUpJQmVDaEJIVXhO?=
 =?utf-8?B?RVg1TGsrT0MrblR4WUtiR3RMZGxRZzk5QzRnMlRIRmZIWFY4TENYQ3dyWFJM?=
 =?utf-8?B?bityNjBtOUhESUp1Mm53OVB0NG8xOHcwV3FmazU4YVdaUTFxYXI5cURqVVdZ?=
 =?utf-8?B?c2VxUGJuanpqbGtrMWVscmpvcjlqN0xNZFNJbDUxdjZXcyt2RDNHc3VaYWVI?=
 =?utf-8?B?VVNORTQ1dE1PYk5aOWhJVXpXRUVhUWRhbjM3RUgwUmowdWdyUk04QnorL3Jw?=
 =?utf-8?B?bWxvWnVXSDMzZERlWm5sL1hCTWlvd2VWdVRyaGhxUEN3aytjYVZpSFIvay8v?=
 =?utf-8?B?MVBaV1U4RTdadWRsbCthT3g1Smd4Q2pjckltWDdBbzJRZStLRnR4dURTUmU2?=
 =?utf-8?B?REtHWXQ5RElkeEpYdjJ2dFFxdkZQZFVkT21sRXBNM3NObDFQRHMvQjczc0xq?=
 =?utf-8?B?ZUd5NVNUK1dFempiU2kyZldtMEVhR2JXdlFhUDNaNTRZTk5kdmpVMjExVTFJ?=
 =?utf-8?B?RTkrMXM3YWdBYkJXMDBURXlZSWtnZEwwdmRCMEhPSmlXNjh6cXFmM2lkdWtU?=
 =?utf-8?B?QXhCWUQ0U1VUU3RjOThVTnVCMGtEblZyNVorMzFnenE2QkJLM2YvU3gyYUpx?=
 =?utf-8?B?WHRKSmRYaStnKzVNc0lnRzVQaWZYYUt6c01wZUtmaWJEcXQxT1A3cWFlUEt2?=
 =?utf-8?B?QXYvdEJKQXhGTFNZZWdRcVVlRTlmN2lwam5HNkxLQjdXYTFGQjRTVGJXOWxx?=
 =?utf-8?B?N2o5b3R6NENQd241K0UwOEx2TDBmMXVaQnl4UTJtMWJnZW4vMEZCMktra25Q?=
 =?utf-8?B?djJXaVYwS1JNaUNHUFJNUk9JQnJ6Y2JxZVpUek54bHQvY3hGazFaMW5wbTVs?=
 =?utf-8?B?dy9ONlg1b20wRTFoYlY4d3Y3UzBRL3pkWTg1TU5XV1htUWFicU1wRlRTN2Rz?=
 =?utf-8?B?SHozcTdaU3lXTis5QWw3bTVDVDIzQlNMRnhCNnFEdDZkSGhMdzJmWE9aSGMv?=
 =?utf-8?B?QUdsUUtJalhDQnQ5MG5EL3ZHczNpV1BVb2djc2ZkMUVlZVBjcjlJNzNYdE1M?=
 =?utf-8?B?U2pENnhLYU1LeE01ZkJuUlhUZndFcUNwSDVPZ2p1cFF5RlVOREIyR2svN0NH?=
 =?utf-8?B?NkxnazJhRnBIR2ZVdlhmYUFkeG1QVlMwZmxOMit5VG1wMUZEd0JIM1RuZVNZ?=
 =?utf-8?B?RUtoa3BNS0RrZ0UzNjhUckxvaGFxaWtTK0lKb2N3aWZIOURrdExMeDJWdjBN?=
 =?utf-8?B?UjNnd0lQNGVEYUJmdXdvSTVabDBCWnladlIvR0xPTGdNNmthYnJ1Snh0Z1Bs?=
 =?utf-8?B?N3IvWC94RXVEZWN5a1NaaU9KN2pMM0Jwc0JQQ2tQNm9iaHppaWx3MThVOTdZ?=
 =?utf-8?B?ZXphb3UySGpHMkxvaDVhRWN0WUN6djlTY3phWmdjT09YR2JMblVYZUE1UVpG?=
 =?utf-8?B?SytJM0lpYkZ1b2FNcmNTQ3kyVDVkQzNqMFltbW9CbFFtOFVnUTRkMUVpRitP?=
 =?utf-8?B?SklnSlZvaVpwZmlDL2tOTDFsVmNDQmlUUUxYVGZFVUZ5WlV2b01ESkMzcFA5?=
 =?utf-8?B?RzBucVVGTTM1bGowMnVJeWRsT1BnMjFPdDkvM3lTSjRpTk0zWjByc0s3R25U?=
 =?utf-8?Q?hj5RQxsC0RwUv5mnBabWCS0aU?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f6739a-ad30-4588-ac72-08dafeec1b29
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 15:52:04.9518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QeN95sgHnRgk0/+wsev59Y+eX1VqGyDSDfB3diKKsH1O3ngxYxGxcS53MdD/o6xT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB5074
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Re the one-liner...

Acked-by: Tom Talpey <tom@talpey.com>

On 1/25/2023 9:02 AM, David Howells wrote:
> Hi Steve,
> 
> That attached patch stops the kernel from oopsing, but it still tries
> endlessly to send with softRoCE.  I'm having better luck with softIWarp - with
> some other patches, I can run generic/001 to completion with that transport.
> 
> David
> 
> ---
> commit 820cb3802c6a73c54e2e215b674eb5870fd5d0e5
> Author: David Howells <dhowells@redhat.com>
> Date:   Wed Jan 25 12:42:07 2023 +0000
> 
>      cifs: Fix oops due to uncleared server->smbd_conn in reconnect
>      
>      In smbd_destroy(), clear the server->smbd_conn pointer after freeing the
>      smbd_connection struct that it points to so that reconnection doesn't get
>      confused.
>      
>      Fixes: 8ef130f9ec27 ("CIFS: SMBD: Implement function to destroy a SMB Direct connection")
>      Signed-off-by: David Howells <dhowells@redhat.com>
>      cc: Long Li <longli@microsoft.com>
>      cc: Steve French <smfrench@gmail.com>
>      cc: Pavel Shilovsky <pshilov@microsoft.com>
>      cc: Ronnie Sahlberg <lsahlber@redhat.com>
>      cc: linux-cifs@vger.kernel.org
> 
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index 90789aaa6567..8c816b25ce7c 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
>   	destroy_workqueue(info->workqueue);
>   	log_rdma_event(INFO,  "rdma session destroyed\n");
>   	kfree(info);
> +	server->smbd_conn = NULL;
>   }
>   
>   /*
> 
> 
