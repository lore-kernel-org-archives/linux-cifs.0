Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640E6C433FE
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Nov 2022 15:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiKNPpH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Nov 2022 10:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236409AbiKNPpG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Nov 2022 10:45:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04CD2DDB
        for <linux-cifs@vger.kernel.org>; Mon, 14 Nov 2022 07:45:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAiGgpd/k9JcM4ReX8Mk5AaunosRdG9JgOy23Ao2c07nHPSpW9sCptPhGxDmtcqB8g5ka7aQU/ulzJDRLYL9T7Mqn4+9kIdqKpmvPyXSAkmsOjLkX6lRXolC0HY4GTjzeMvq/b+yZS+cUPgiwhTsFeLlnt9K14O0UIeZRzM41HQ/b6GC6v9m4tXUiqsVDZh0ywxXiQbMc2xh0eNBMr+5ArlWm3F0GcItWdK3byb3kNVelZyEbl5oqF86N3gvo69gcLMYIOKRmzLRMVuBFe3La6/6MxNCeWu7vhayhKBl3zwOauzgUdUX6UaPVXrqGo2iJKpH71ekB8pbGFebu0H8Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHqjweMrqwlvzNWM4OoRp5HBo9wZv/ozJNrSGT0n4qM=;
 b=JLxh5acjPs5DIodfAl+u4YYmXi5uMYT9wTHqtOVSsgg4s91ShLvmFL27QF3bSQhMlf6XNj4J7Z4AszRQi35BP50rbL+zbkuUhggJaeNxkwCbwsE9owslDJzGMnl+ZjAkOSHQtCZ8rIhW5uszcgl34zZ3h1x6gLHyUXntGsyPCQXnp0F8WFQNDziyGIfVCctBzlPd4PXTquahfi/TZdCAYRCAmnL53+O/Y7ZKYAMInseBjw3L5XP816wmAcrLKdqTJIRTZ3LT40J5He5I+hpRaRa+iblZcWhR5CPnEMtOb7d37afK+Dh5nDIBGzEhK6W3erVe9BqJM3zz8zCuiBsDSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5344.prod.exchangelabs.com (2603:10b6:208:10e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.16; Mon, 14 Nov 2022 15:45:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::a621:8f2f:c5a6:9d33]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::a621:8f2f:c5a6:9d33%7]) with mapi id 15.20.5813.016; Mon, 14 Nov 2022
 15:45:02 +0000
Message-ID: <974f2e2e-52d5-ff4b-9a2c-3630de721c25@talpey.com>
Date:   Mon, 14 Nov 2022 10:44:59 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
Content-Language: en-US
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aurelien.aptel@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@samba.org>
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
 <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
 <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
 <CAH2r5mt08V-RQa8=apT-fAqXxQtKkj_9XNSMFvUBm=da-UMyCg@mail.gmail.com>
 <abbe9909-5bf6-23d0-3c86-4c7e98e8eea9@talpey.com>
 <CANT5p=qEWs8WTJQ1h0Wgrs3D5KVL3V_T0+p=yo4X=gOD1jvKfg@mail.gmail.com>
 <CA+5B0FNuZFX01jin63f06nszYsVm7gWL_1vk1S+HUn2-wBuasw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CA+5B0FNuZFX01jin63f06nszYsVm7gWL_1vk1S+HUn2-wBuasw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MN2PR01MB5344:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c42945e-adca-4fc9-89b9-08dac65731a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jnYhRTqlnH6DQDzdzOk5xDOp7loNFqv445j+8AbXJgF3CkfjXQ6TaZSb4eSLeqbcTTYxUFuYPNaY6VNP4JTfrOb6Lv1BKLDVe28YOTAIBHVkKqyjqi7zlIvYd1wZRMEdvV5WeXIdxNYWCnn5oE+2OdoC1gUxZjEOJKoP3+mcfqP5KDGcJuWduJxESfYSdo8PdDnvO27Rl/c/QkX8Jsv+gdpQZxqo7U2n4Q3gXfvzv52mjKKPg02nVm4E5qxD1QFQBRmxXT4kcq647xh7igbUwHn3bcNQ0Bdux6vhpqusWwGMZDZ8Ql5Vxr/7OtBN9Fyc8aQLekH+VENttcQuMWNt1zZn5RkgdRysbJCU80QMjK0VTjDSB9FT7YeKtvelF6C0CeWSTaZ5ptnG7LdNNfJvVrsu7OgMnhHCgm7KUyJFNk2i9Jy8NeMiqa2V+I9OOByLlDDLy+JSrPt6s8BQCAq5s2WBu4OsZXSFCez/N82AUPYVUDYP01Z7xavwvJLHaaa+Rbp9Qmw8UOaoud8eBgn8O+BB7N2SYtEpG9ui3BesoYTR5EgjCr91iLtz/ECjuLAcRo20/V02vtzjsBBnAqFOiezwLWoB1XBSmYOIYHVbYgZzhrmiEUTTEka16gEuEgrVdedSOlEpU5Jvu1wb9UM6IUo39hqRqNoyljYpVdmEMXozRCRdEws+CkUUjqulV1kfRNMFcrrfXe0IkQ36e74jhpfj3cnDSgrOF+eSxhzrjbE1F/DG4kzyg5b+Ia1ZX3Xxz2zBCjHRmJJDg6InKtXEi1ByeEbbgirt2UM0yZpayl0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(396003)(136003)(346002)(376002)(366004)(451199015)(2906002)(8936002)(66476007)(66556008)(4326008)(8676002)(5660300002)(41300700001)(31686004)(52116002)(53546011)(6486002)(26005)(38350700002)(38100700002)(6506007)(6512007)(6666004)(186003)(478600001)(36756003)(110136005)(316002)(54906003)(2616005)(66946007)(83380400001)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmpMM1M3b3dnWmlWdk5ERTVZbERzbkFYNnBNazZkWmhTYUUzU2JwWEthNmxP?=
 =?utf-8?B?bmdOM0ZtQ1FBS0gvN2hycEQwNUovSzI5enN5Tm5YMEtKU1JiQUgyajl2Tjkz?=
 =?utf-8?B?SnBqTW0xNGhaWVhBcjF1VDQvZ0NxY25uSjh3SFJhNUVZZjNNdXNNUSsrUWor?=
 =?utf-8?B?VWJERVpqdDhuSHRnQjl5aXN4WmlzbmIyNDRXbWtmV1YvTUFEemNEVmpvTEh3?=
 =?utf-8?B?ZGJwWE5RU3FCMFV1OS9RaHhTaUxFSWtNZVlrd1FEYThSK25jcWpINDVnWjMr?=
 =?utf-8?B?SkhLeFFkM2NvNGpXR3hLMzAvTVNuWExzVEFiYThEamppcVhTMndWNytXTHlU?=
 =?utf-8?B?S0UzZ2ZHVkNMeXRLS3B0U09HOFZmWHdLUnVINnV4U3p5M2dRODMyOEdKcEd3?=
 =?utf-8?B?VTIxN0E2N0hwbElmeG9QaG9EZ3RzM1l5NWJHOG5NK2V6aVBLZmpodEhGd04x?=
 =?utf-8?B?ZTg3cDFxS2E1K3ZMQzlpNitLUkJWT25jYnkzU1NjNWRNaDRvdHNoSFp5Mkt2?=
 =?utf-8?B?MmxYRFVGQVZnM3NnVmlJQ045aHlpTVhiSThOaTYzN3FDRkdJaFl6MlR2MUJZ?=
 =?utf-8?B?bllqWTArMm1hSjlCVlEwaGJoTGtKK2F1WUdpQjIvcFJhWDh4V042dFhUNjFa?=
 =?utf-8?B?QXE2ZElWQUtEZ3dBMDZZQVpqYUdVR1FQNWx3OUdhYTlISXVGbmltQWhaTEtx?=
 =?utf-8?B?RWQzRzYxOEQ2OFNsRTNMYWc0MmZRTUh6Tk9mTURGKzhMQTB1cTd0Q29xcEdo?=
 =?utf-8?B?SWcvZ0krNjdaSExwSDBQVU95c241eEkzMG8xd2lROEpuaElwVHJTQk9ZUFVa?=
 =?utf-8?B?Q0srQ0NyRlhabGVhWFpkVW1wdURrMEFhd0RMVFRvcU9qZVgvQWdzMUZac2VK?=
 =?utf-8?B?TitBdjVhUzZOd1F2RkEvZXNOVUlMQ3A5K3VqVmlXcWl3MTNRbktWWFlKYWRu?=
 =?utf-8?B?c09pVmZTTXV6STFOb0ppYkpQV2p3SGd1WHBYWTlIRzl2dDBIZWl0UDJLY2Vp?=
 =?utf-8?B?c2ZLVEJOU2c5Y2dQYnhmQUo4NVZSUmNWRVh0VjVHVXM4T3pMN05NdU5velpR?=
 =?utf-8?B?NnMwMnVsT3RtZ05meStKV012WVVNUmFWTEZta1dyMUN2QkMzWW41VHZBSm1E?=
 =?utf-8?B?YU8rNHlWOE44YlAzUUU2VkViTys3UDFiQUh2S0s2d1N6Ni9EME5NYVdRdzc4?=
 =?utf-8?B?OTdtNHc0YTcyeFVNZWJzWUZCZW1LYldCaEdjaGJPdG9mZThUTkJyK0FwQmNi?=
 =?utf-8?B?ek5vSHphOXZtY3lPdmQxUWVHbG5FUERta3V1Nm5ZQjJaRHUyazRqazJBMGVD?=
 =?utf-8?B?NFlxRmpSOElzdWdSYXpjTHFSV1crakdtVUE2YVRBQUt6eDE2NmVFTTV1bDQ3?=
 =?utf-8?B?Y3NnTzEzVi9HTERsY3E0Mnk3YVZhellXMTNENnI4Q1BBb3hrdS9PV2YxcldT?=
 =?utf-8?B?M25sOG5pR3RTVjNrTnVJMXROUmo0ZnBRbFg4VnMzUGZmZ0ZJMUtKQXNkZFEx?=
 =?utf-8?B?NnBKV2NiblJCRzZXV1ZlRXlrN1RubTZBUWFJVGJpQXVxaWgzTVZQaXZmT2dU?=
 =?utf-8?B?czZsRElGdDcwaGZEbDZiUENxQ1lNaVZoWG1uNTlFdllUTk1ZMmwrZ05tbXdy?=
 =?utf-8?B?R0dGVm1SSkZWenRXZVZPWEErUWlYS08zdDJPY1E5TGVrbDA0a2JMME1qaXVZ?=
 =?utf-8?B?SGRSSnpiOVhweU9ZcTJ5SXBCaytVMXZBZEZwd0dCMmtMVVd3aXNVZFNwMGhu?=
 =?utf-8?B?Q3A0c1FEQUY0NEhwcnR5RDVvRVZvTWpHZzJ0czVuUm01dUxLM2hzbEV4dktz?=
 =?utf-8?B?VTY4RWRHQi8vRzhUT0hLNkZ3Y1ZIellWTm9aa2NySnhiUkhRSis0YlVaSklx?=
 =?utf-8?B?STUyYUpaWVg5OGhxMUdmZGd0c2NkRGZQZkdsTlYxNmhGS2dXTXZqeFdkYmNK?=
 =?utf-8?B?d3JTVnR4YnRCYVB6enFPNml3N2tsbjZIRkdiOElRKzBzR3h5T0VTL1ZKbmpJ?=
 =?utf-8?B?emU3UG82dGdWUHZQbVZqbW1sVnY0Q3FKNTE3NEVQUzlXK2FSa3NOOVZxUGZI?=
 =?utf-8?B?Q1E5MnY3b3RzakdXUGNBa1dHVEJUUGprcEVNU1BjRUFuUVUyZ0tRTytWaDFj?=
 =?utf-8?Q?Pwtg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c42945e-adca-4fc9-89b9-08dac65731a5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 15:45:02.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptgSKvQ1ToJbj7gyDLIsXIyezQysrwDNRuhviWn2a/enbpZLgtUaOlHHRS3fX+AJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5344
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 11/9/2022 4:08 AM, Aurélien Aptel wrote:
> It's been a while since I worked on this and I'm not sure what exactly
> you are referring to but:
> 
> There is a fundamental problem with intern linked lists (the way they
> are used in cifs and in the kernel in general).
> One element cannot be part of multiple lists.
> Within each element, you need to add a list_head field per list its part of.
> 
> I didn't want to introduce cycles or redundant pointers (each new
> pointer is a pointer that has to be updated along with all its copies
> at the same time, can go stale, need to think about refcount, etc)
> 
> In MS-SMB2, the channel list is an attribute of the session, so that's
> where I put it.

The problem is, a single connection can be associated with many
sessions. The "channel" represents only one such association.

It's actually a many-to-many relationship. A connection may be
used by many sessions, and session may use many connections. If
the code is assuming a 1:1 relationship, it's broken.

Tom.
