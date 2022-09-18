Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64549ECAAA1
	for <linux-cifs@archiver.kernel.org>; Sun, 18 Sep 2022 00:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIRALG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Sep 2022 20:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIRALE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 17 Sep 2022 20:11:04 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC8324952
        for <linux-cifs@vger.kernel.org>; Sat, 17 Sep 2022 17:11:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9YOklrtUrxxoV5or/DCcBGC4Aim9ZJtyzZaL9MntDErdPF8hmcBDnXSDUxSRQQHBeXGpg9VehOG3hr/b1EtKEhjNiTiwkAA6ceqtEX7v19oebhzUq+7yt0aDxQpz8gb6qdpzvd0F5e1Qnc7dPAd565cM2YWnU40hoheh9jAWkUY/JRQX/eDdDayZ1BniERGvhuogZHUEn4AsNc5PWI7L8GN3lRE11V6gUHazBv7ac20tO9HUopqJne5teLzE/jrpxe11EVFLL5WhoJ12brbK9Ya0a2Q4ZJWmLSWJElhKnsbqc8bjVcMCN/byNH+AGSb9tHMu9v8soOooSk0RNf/2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCCG3agyVLS8YMQq7Fy4syiF2K8qkx2lB26L0nlxgIc=;
 b=QrpP+7IhzXIw8t8Du0GAoebz8bre1W3YXZj17IrKrxmgBIvqt48k9rtXdbR55HUOoPMU2m4bmr8AjeDUG2IREN7thFIVAtEhRRo14kblYpckavFP/Na1GscW7cy33kf5mp0cC88ZaEyNRWrHTbOm0OKygvvHhBYJYfnRNlfyQjN01OpdrB0O8Yo1utzeAfL1blcM3bdLbIKvdzEyF+AQAni3I0/omLgBEoofPG41iuNAqDHdOqwS+RXzCDxIWs1rvCfautA2GP9nA1IsBLqPI4UvRLeo1P5NntFCzqJKgWpksvy3/WKiC2LeJM9QU8ULpNBxbPEjdagfo5lI4vcKwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6636.prod.exchangelabs.com (2603:10b6:510:99::9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.17; Sun, 18 Sep 2022 00:10:58 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5632.018; Sun, 18 Sep 2022
 00:10:57 +0000
Message-ID: <3e03b3ec-f733-06b1-3023-592801414ae8@talpey.com>
Date:   Sat, 17 Sep 2022 20:10:56 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] cifs: verify signature only for valid responses
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
References: <20220917020704.25181-1-ematsumiya@suse.de>
 <bf09670b-df76-7fcc-2c8c-8b049f82d41b@talpey.com>
 <20220917162827.g3c32bh62maw7da3@suse.de>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220917162827.g3c32bh62maw7da3@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:208:36e::25) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB6636:EE_
X-MS-Office365-Filtering-Correlation-Id: ae223ac4-8c74-4af0-c867-08da990a4273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DumeHPXN8APy6ZDaIQzxKJF5WKJukZnoAFYsvnmX05Fr7JpKbMt6sAS5kJRk2yXssVFOitBOXc4RNUw3vKgm5xJsCdLm4FBqo7RQNTob+9khsFCrO2HeszRgULLMOQYBXzTu4+NvoPW5MD0u/GPSvO7yjyP4+O+XZzpzHTWU6brdqCX7xfKKNLeBNtpM7ycO8OyvDASVCUVU39CPgf1E9cAD61iJmtC91DaexjPm2NUFjGBwiK7mJ2N56b3WL2wU3UIcYmfu/0aef8gYbGEENAyzBsaizZIv7wOSiiB5I+3Vb8Fsega4cG9TsadUQzgy/nVrn9x0tBWrnEfpf5aC7mbEd5qpw3FV66UIKspHJl/Mjfl3w+N08KRDNpIdt8z5g/ejeS4G5cW1ug50oVlFLCfMRIoYKn5vA1XFACR8e/COYfPccvxPlO/sWKY+5nsRTfeKmyIOVB3fCwScXxgxz4O0uiwkSAatjlzGsLJcpPb6EmO50Wnebx1tCbC+SQLlCom8UpSGLmCd55Oa2BQUL+rK6scTdhi3Wgz81dIruSoF6hbHW7b9CjHUwMr/PefAYpnKglQW+OBVAxqMQKxQ8cTiXC6g/+GHaGvPwOE7bzXkYhJYqRCmO3JVZsMDxai8Hn6p5HsNdfbFEOprm0cyo7KtpC2n9IkuW5fVkFz2VsHcfM9gPI+LJgmlI9vo8FYtX439Ht9SB4pt0BaVHE980Y7KUczYKFhQsHqK01zuXzRqF3LxTqwjdQ6ZiOPEBGAxURUYklp2qZVcDzQLlJTUgdPZMMjm5ypvYbLxS7hPjrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39830400003)(396003)(366004)(136003)(346002)(451199015)(66476007)(8676002)(66946007)(66556008)(38100700002)(38350700002)(4326008)(15650500001)(86362001)(2906002)(31696002)(8936002)(2616005)(83380400001)(186003)(478600001)(6486002)(41300700001)(6512007)(26005)(52116002)(53546011)(6506007)(316002)(6916009)(5660300002)(31686004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STNnckJrSUhDb1hBSzdmR0tsQVROenNmVUowTi9VT0JjZlh0Y2JIL3RBUHBO?=
 =?utf-8?B?blFxRzAzQ2R2RFkzZkRKdE5IeVN2eGEwcG1TYU5wdDNTcldidTZuVzMvVXI2?=
 =?utf-8?B?Vm81S01XeldUYk5aWHUvb1pmbEdxUUlpS2RzTjVtUHpPL3k1WGxyOWdwd1pB?=
 =?utf-8?B?RDdCVWw1S3NyaTZQSFFibER4Q2RYYnZaTTg5SkJqUmtLZW5wWjVMa0ZtQktq?=
 =?utf-8?B?VVBiN3ZzUGtVQjJYZHFCaTBoK3JiMVROWnJqeTFrRDV2Z2NyZUMvM0hIeDNO?=
 =?utf-8?B?T1Nvdko3dmNwSnJQSUp5RWE1VmwwYnlFdEx0b1lVUzd2cERpU2JSNDdoWDBP?=
 =?utf-8?B?UzRFSEt0TGhaekhSS0JUR2QwOWNqODhTckVSSS9rS2tGUjEzMUg3V2w4R2RP?=
 =?utf-8?B?a2xHNnBBSWRtbG05Y0VXd05ZallNTW1keDNsOTNOWEZCdGppWG9Xdk14TThU?=
 =?utf-8?B?aHoxSUJGWU1ydC9IczcxQzRnZUdTV3pGNWFTY01zK3BqODNlN2dRbS9yVEs2?=
 =?utf-8?B?eFlJMkdGYlFTV21hdkVadEFweVQ5WE56SnFWL05zbFg0RGV4cFdEbTFkQkt0?=
 =?utf-8?B?d1hTMEl0ZHMxVzFoRHE5YmYybm1nQ0x6VWsreU85Q2tMMWpwRVlnN0o2R2J2?=
 =?utf-8?B?dmFyd00yaXJDVmhJMnV5WXRCK3BhT0VBWjhwdEQyaGUvK3ZEMlVMd2dQZy9W?=
 =?utf-8?B?UVcyUk92SVF6OVpwS0kxSDVEVVR4WGJ0QmMyQVZCZW4zSnF1RWlDcjd6T2FH?=
 =?utf-8?B?SGtXbEtNTk9Ed3hJSDh6UjR5YjI0OE94Nk9HcTlqUjBpb2lBTWN5enJhM3ZI?=
 =?utf-8?B?Wm9icG9LMU94dnowQW1yVnhBbnZieW9Nb2l3dVlPZTdPSjRZL2thcTE5OEJP?=
 =?utf-8?B?OC9XS3pQa3BqMFc2a0prcko5UHlLN0V2TGF2b0tHL2xrNGdBWHQxM2ZuUUk0?=
 =?utf-8?B?andnUWt6clhpOExMejVRUFRrSm45WlZhYWxQS3NONVFqVU1xMVYrSVNwY1Rk?=
 =?utf-8?B?cHRPbjN3cmNGdnB1UEZMRWN3aUtYOEdPclIyTkxqNERLOUo1bUZFNlhmOVB6?=
 =?utf-8?B?T2pDcGZ0dmRGYVpydjhaOStwN0NMM1BvN2RGWXpJSHA1LzY4SHUzRU5kdmFJ?=
 =?utf-8?B?MUJqSjlaenl1RWxmbHdQSTdRZmZQOGt1ejVpakVaWTllaDl6WTVVNVlQQm1D?=
 =?utf-8?B?MGN6RUN1U0pxcTVZWDV3SjNaY2ZyK2VnS2FCL2RpNEhLSnRJT2lLaGpROWtv?=
 =?utf-8?B?aklmNU5NU3RVSkpBazA3bVJmVDJHdGdLNTFmeFJjSEF2d0JTeFluRlBtdnND?=
 =?utf-8?B?MEpoVnNFQlJYZWxWaUxBWGh5VWJyRWw4S2hLSHdBeEFoK2R4b1l5bjBVMldD?=
 =?utf-8?B?SFpoSXJId0wwRGZ2Q29Pc1kxaFFGZkpCQ290bHovaHdCN055c0NEdVg0bllD?=
 =?utf-8?B?SnVES1kyREdPN2twRHNNeDlET1U3QmJwQ0pySGkxR3NDeHpCYVhGZ1k4K0hG?=
 =?utf-8?B?M3VwZHF6bC9hTGtaUWVOTTh4ZyttV0d5U3hjWm1TTVpia2JJY1JwMTV0K29D?=
 =?utf-8?B?U2xwNTdkbXlHZnBsZ2VCbzFZSFhrVkxCZjNIUUM5a2lzanNIZGZhVGhDdGg2?=
 =?utf-8?B?eHY0bkxkaGFRY2tJSm13NkdPekF1bnFYdUFTTkVUOHZlUUswOGptajVMYUUy?=
 =?utf-8?B?b0pGL1VISkduWjRudXpINFpnaGQrS3RHdGlrV3dqbHRrck5VV3ZqSjdxTm4r?=
 =?utf-8?B?SzVVdndVemFVbDdGWGpXVGl6RzJhbUJLNkZsSWdwNmtYNE9WYUlKYVBwdGI2?=
 =?utf-8?B?RmFrY3EzZXlIcCt6ZXFtRVVHejJlUlZ5aVA3TC9iUEpTczJMUFJqMy8vSnZ6?=
 =?utf-8?B?TnNka3gvRC95VnVLQ1hpUnZsaUk5MmhKTjBLb1UzZ0IvazJZdlpzNFBLeTdW?=
 =?utf-8?B?d1Z1WitXNnJiaGtqQzJzMGRmVVBJVVF4LzJ1K1Z5RGp0enk0QWtwdGJNbWhS?=
 =?utf-8?B?dWFld1VVWVhvSjBFdjB2Q1NsbmdPeDR0OFFMbGVIUXE3YXpBcWtIeHllWmwv?=
 =?utf-8?B?NVNFb1N6MlpUSnoyYis5TzA4VVBLVitpOUhQcjYxQTlTNGwzc1lNTE9sTHF1?=
 =?utf-8?Q?KY+g=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae223ac4-8c74-4af0-c867-08da990a4273
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2022 00:10:57.4171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7MY7pxPBXGYNHvd/peZ0idFD+OCPEaRAaYe5X0LEsduB3xbYHp53cceHoXVBDmcn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6636
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/17/2022 12:28 PM, Enzo Matsumiya wrote:
> On 09/17, Tom Talpey wrote:
>> On 9/16/2022 10:07 PM, Enzo Matsumiya wrote:
>>> The signature check will always fail for a response with SMB2
>>> Status == STATUS_END_OF_FILE, so skip the verification of those.
>>
>> Can you elaborate on this assertion? I don't see this as a protocol
>> requirement:
>>
>>  3.2.5.1.3 Verifying the Signature
>>    The client MUST skip the processing in this section if any of the
>>    following is TRUE:
>>    - Client implements the SMB 3.x dialect family and decryption in
>>      section 3.2.5.1.1.1 succeeds
>>    - MessageId is 0xFFFFFFFFFFFFFFFF
>>    - Status in the SMB2 header is STATUS_PENDING
>>    [goes on to discuss action if session not found, etc]
> 
> Yeah I didn't find anything in the spec either. I woke up this morning
> thinking about this actually, and it might actually be a miscalculation
> on our side. My initial assumption, and debugging target now, is the
> 1-byte cropping done on some odd-sized structs, but I haven't deepened
> on that so far.
> 
> I'll reply back with my findings later.

Good, because there are definitely some tricky rules regarding what
parts of the payload are included in the signing. Padding, especially,
is easy to get wrong.

>>> Also, in async IO, it doesn't make sense to verify the signature
>>> of an unsuccessful read (rdata->result != 0), as the data is
>>> probably corrupt/inconsistent/incomplete. Verify only the responses
>>> of successful reads.
>>
>> Same question. Why would we ever want to selectively skip signing
>> verification? Signing protects against corrupted SMB headers, MITM,
>> etc etc.
> 
> The problem here is actually different because rdata->result can
> contain an internal (kernel) error code when an underlying problem
> occurred (think EIO, EINTR, ECONNABORTED (not sure if possible this one),
> ENOMEM maybe?). But in between "mid set with MID_RESPONSE_RECEIVED state"
> and "verify the signature", the SMB2 header/message itself might be
> correct/valid, but our internal processing failed somewhere, so, the

Wait, we process the message *before* we check the signature??? Apart
from inspecting the MID and verifying it's a response to a request we
made, there isn't a lot to cause such an error. See 3.2.5.1.3.

Also, if we process a bogus response, or drop a valid one, that's a
seriously important issue. It's not a server/protocol/network error
but we trashed the operation!

Not quoting the ENOCOFFEE part of the rest of your message. :)

Tom.
