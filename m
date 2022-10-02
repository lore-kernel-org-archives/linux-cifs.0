Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F23C433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 18:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJBS1M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJBS1H (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 14:27:07 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBE23B97C
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 11:27:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPyiTdKZx2FCUsIC5uPe2d+rWLHcuaTT/Wr4rbBbuT9QEU/XnodvUxvUIq5jw2EM7h/Z3BkMp4NYyRyulhh4lzCxi7VgGsjEGIEkHogPriS7cMcDhqUbrEdRwWUo9lUDiFKRg5gzjTjZDJo8hJkzMO4X+G18/P4ZMGaWLEboptwHPm1L+DJvrcDhK5pFzV6VP4LTrlZf+pWrH1lO9xOzmDwh6UDl0PDHZ4VJzzTFX98lyai++1K2Odswnhsgcb81/vBUW3UNyOxCZItU2qWZfVNha1uWkB2K4GtA5tt6yVyaWPWiyzI/6PZL8cimdnrP1+9ncKYcAQPcgmzphNdw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQnRGVA1m69Qydoa2tXDLunqYuDs8VGtgkY7B28Jfto=;
 b=Sb2+ZfMOGvx19L9urnjM54DJPxhUg9iR66t5PTFTdXyU32VDBa+xjrH540Q4AXFu5WUgC+0zusqPbPpUReDmqZGA8zKlqss8mGWvO9hUvoE0PCIUqnV/rGhr1B6KgMUAZu7mUfyiuyK/s7YWVLRnYad5azKFpJvipMLj+kOPiEoMOxFS+Mr0oBqLmLUgeF9khrXEtCsEZHfdSJm+GyPkSvdL8X7ugnevG7xv66x8tEEOePR1To5cGUwydpLdfpUz34eUIodJYcfTP1HeHuBqMw4ICgwN2yiVCKJroyhHw+Qg4qqYOGkajCKedL9w6OEB2Nwan40uZs2pepmeNxgndA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 SN6PR01MB4848.prod.exchangelabs.com (2603:10b6:805:d2::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.20; Sun, 2 Oct 2022 18:27:02 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::b054:69db:e4d6:c1cc]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::b054:69db:e4d6:c1cc%7]) with mapi id 15.20.5676.028; Sun, 2 Oct 2022
 18:27:02 +0000
Message-ID: <2734eb6f-cc01-cb0a-433d-e97729ce2aee@talpey.com>
Date:   Sun, 2 Oct 2022 14:26:59 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: new SMB3.1.1 create contexts
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvM6a4dU3d7Mxer9jWP0xkA2hyF9PrkwreES5T11W9O9w@mail.gmail.com>
 <CAH2r5mtoZRrCY-jDCH72DSNXPMxYiu24cuRRguLyXDx6zKUvwg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtoZRrCY-jDCH72DSNXPMxYiu24cuRRguLyXDx6zKUvwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0014.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::27) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|SN6PR01MB4848:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f8136e0-86f1-4af8-5026-08daa4a3b30f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQueOilz3w7lfCPe25Oa75CqNKjTwvqkEvtrRE0JeY2u/w7WBhCZOEYWPZbY/1hwhWiEvXI1hvzXa/rA+EI/7yKGJ3xNZK/MrQ8E9CxIRidARZXuGunRYQG+Z3Q5Qkk7Qchfb/lhVd+klzJkXj8tdiE4+LcNWOZWjXxixUDPsXpGnc9lJXIBjtima5pakZfHp06S5BgWBDXwVYXVSm3b4lGGMsBGQDajVWRCgb1dHtQ9wP6vj4UUirgSLuETYE7kF0e6w/LqF5n+eFMV3U+I/dVLfqaITZWjdHG2TtEZXfXYx6Cn1PlGX0MPoeJ2pDzZ1MUcCvBfP4xc/byRckza8DdBtQxMiROB6goHm0XRiWs50Ck0daGWMdj9kGJSyB64H3BTnyAvwo1S/A8tdyhZQCByhUxeJw4otff66HUbOzXpZQ2+DauyemMEMtdnaDffprW7cmRaGtDVOsusSMAdT3/5WO6qkqZDOY5gd7vfIzTqDKZ7nCCA37I1rjQxS9TCPeJrLn8G4XmV/kfsKLPC5KByV2/QhnqqNlfg2CCmEVeTNo8K637DpVG8O4qnbQXreo5ogH30kq31kgx/zZ5B+b9AnrE6qTsFSwPv1iEXm9t6hKygk3R/DkXIIE8MvxhzUN7SaljZGSj6zhjLgX7l2EnGEekAxlqCx9r2M/tBdwyiCJT12L1+82xidhfOtTwthVKJA65yBg/eie2kHTUZd1lD9ol1UL3Fw4iPg3XKDGweMX1UNLZk8hocwYqvRKyKGo7VT/C+TU9bxkznqevlglQ+Pv3enxg0Klz9PUwKjoY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39830400003)(366004)(136003)(396003)(346002)(451199015)(2616005)(38100700002)(38350700002)(86362001)(8676002)(8936002)(26005)(41300700001)(6512007)(31696002)(66476007)(66556008)(186003)(6666004)(53546011)(6506007)(66946007)(316002)(36756003)(5660300002)(52116002)(110136005)(2906002)(6486002)(31686004)(478600001)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1h4MFFQV21qWll4c3AwK3FybXA2QXZGVHRCTng4NkVDUFNyWHRMYy9xSEZO?=
 =?utf-8?B?Tm5sdlVWN3ZJUjZSNkJEKzArT3ZsMm55S1VRbXdDVElRQ1JWYWdZMFc1REps?=
 =?utf-8?B?NmpxMjlMY21wMy9RNHVvUXloTGRwTWdCYUI5bnpNOUc1R2NmMXAvNEJRajRR?=
 =?utf-8?B?b3dBMURkMFFzeVp2aVdyWitiSFZFbVB2Qm4wcHRHVHdSYTZUS1FhTDBlRnda?=
 =?utf-8?B?VHB6QzB5blJZRVFLZUdoTUxacnY1aGtvYmNCb0RpeGlPenRJcHlkNHB3UG03?=
 =?utf-8?B?Tk9sdVhoa2tESTU3WUJwYmJ4QnV6TkVDeGZzWnU5d3lsSUczZ21NVEpDK01h?=
 =?utf-8?B?RmdaaGlzZ0UxdVNzRENscFBTUmd2dm1JZWQyTHloVWlmaFFHdGRoeVF2UjBS?=
 =?utf-8?B?L3ZVZFBQbzFYNnZWSFpKQmJHdUlRQkVMU0wyeW5kZ1ZjbStlRnRyVHdLd29h?=
 =?utf-8?B?Q1VCZStQZEFub01CeThZcFRScFk4VFNMMmU2OCtPYUpXazhubHNNU3oxdGxt?=
 =?utf-8?B?SVMyeVA3dzN5SGpyNkNKK0hsUC9xUEN5ZHZqYjBCSUtoeURtUkFFOStJbTU1?=
 =?utf-8?B?N2xja1Q2OGRKay94eU1YaWdpYmpEZGxLakt3eW5Wc1FmRjNpNkhJRzF1V3Q3?=
 =?utf-8?B?ZENhcjF3MWdCY095dDJCODUxT1JVZGp5VExwMnB3eFRPVCs1cVJyS0EvSTNs?=
 =?utf-8?B?Y2pNV0xnM0wrYjlhbnJhZTdVejBBU0Q0enJjOCtEL2dwRncrVXdGbjVnai82?=
 =?utf-8?B?UkhGR0ZsUFNOWmorWVhJVGhRa09tWFViZGJSUVUvYnQvMXF4NHBjcFZMeWRZ?=
 =?utf-8?B?eWJXUVZOMktUbkN3bU1RL1l5ekhGbzhLRTU1b1NMWDJBVGZpOG1ydmYyRGtv?=
 =?utf-8?B?a2dMYzVrcWhhZFpqZmlhT0NZZ0R4amtQVnJ5TWFDZDJORlkwZWhHaEFKWEp4?=
 =?utf-8?B?SzNnN1pZTzRZcEdXcVNMSWU4QXE4OUYxRUxWa044NzQyaXhKVGkwdFAvSUdv?=
 =?utf-8?B?OWI4Zk94SmVGOFdEVEJRWEk1ZU1yWXVBenh3eXR3VlZuLzZUYysvdEZrOGpz?=
 =?utf-8?B?UGZQVjJPNWZlNGlrQTAzN2o2YTN1SmlLU3Q5YjRBRzdWOEdRVGxjaTV2RjNz?=
 =?utf-8?B?bnFsSVA2elhwcjZVOE5YYUREZDdtbEsyVS84anZic1pKMkhzeXUvcEVwdGpQ?=
 =?utf-8?B?Zjg4K25mTUw0MHhmcXB3SThaVzBtZ081Mm9DSG90Uk1HUGN3RDRWYndpdmZS?=
 =?utf-8?B?dlMwM2JLZFVLWjBzMzV5SWNRSHNDdVNnN2tTd2pxZ0R1N3hGMjVkeWR1cnZl?=
 =?utf-8?B?cjJJWUJKcEwxSElOSEY3ejZ1Zm9DcURNeHRMTkdtUWpLTHZtUkVqN1g2R1Jv?=
 =?utf-8?B?N3hHcitucGZpeGw4dXNSUytGRldkWUtJZnhHUk9TeEcrQTM1U1FXSEJWMFh0?=
 =?utf-8?B?OWlDVXVsU0tnYUNzZ1NaMFAwQUJKUHlRSVozcGV3bmpBa0I0bEpVSXF1czRt?=
 =?utf-8?B?dFFHQWZCWjQxSGdLYWhyTEVhbHNxNkJTVlJhVDVEaHJ3ZHR5V0t1ck5uYlF6?=
 =?utf-8?B?bWdTTjBlcVMwOUFEbGsrVzJCK1ZCZHh4cmNHM3BId2VUT2hWY0FndHJucm1y?=
 =?utf-8?B?VmgxVVdibzE3dFRtbG1UVTJmcS9TVFJUSTcrMjREdHpkczdXM0ZwTytYa3cr?=
 =?utf-8?B?S2xCYnJXcm5Ndk9pOU5KZG83TmZCdE5oWWQrUTNEZC96YndhL09EV2QxUnVu?=
 =?utf-8?B?WE4zR1NhRHdUa2Z0QVJ3RndKdFBGcUtNRkptbTFNaUkzWFFoSGNKMWNaYWR2?=
 =?utf-8?B?RHEya1ozT24rdUNXT0VnZTBxUEpkcjFGMzd1eVBsVXBNNWptSHVyWmdYaWFn?=
 =?utf-8?B?WUdpSTNvM0FtNGpFejJiOCtSdk5WSGFJSG1lR0k5UllSVk5XOGE1dWFQaGtI?=
 =?utf-8?B?U1NmcHlWRTVRNG9Ha05aTjIzUUs4MFp5di9HdFdiK1RZUVh3b2dDTWN1RllF?=
 =?utf-8?B?dXRuRlR4ckRvQ05BdWppNEZyMy9FNTkxOE1xSmtXa25Ia1VETGpsZVpoSHY1?=
 =?utf-8?B?NncvMy84K0pFNFNPK1N6WG1iaS93VCtnbWFra1VEKzY5Wmp4THJWeXNrbjQw?=
 =?utf-8?Q?cQ9SvG2U4bOsZPkjersjPlWhg?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8136e0-86f1-4af8-5026-08daa4a3b30f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 18:27:01.9127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dciOBBwVCeFJAOVMOK5gKtW/orXRtKOCKBLKMHlD8FjWp+Mv65+8TuHxsSnwHRYf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4848
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/2/2022 12:01 AM, Steve French wrote:
> patch attached to add the four missing create context IDs to the kernel

These don't seem very important, to me. The APP_INSTANCE ones are
about clustered clients where VMs may want to migrate around the
cluster and not lose their VHDs. The OPEN_DEVICE_CONTEXT is about
MS-RSVD. Neither of these are in Linux?

The AAPL one is all about MacOS behaviors. If this is being added,
it needs additional documentation of the parameter block, no?

Tom.

> On Sat, Oct 1, 2022 at 6:50 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Noticed a few SMB3.1.1 create contexts missing from the Linux kernel
>> code.  Any more beyond these four that are still missing?
>>
>> diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
>> index 2cab413fffee..7d605db3bb3b 100644
>> --- a/fs/smbfs_common/smb2pdu.h
>> +++ b/fs/smbfs_common/smb2pdu.h
>> @@ -1101,7 +1101,11 @@ struct smb2_change_notify_rsp {
>>   #define SMB2_CREATE_REQUEST_LEASE              "RqLs"
>>   #define SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2  "DH2Q"
>>   #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2        "DH2C"
>> -#define SMB2_CREATE_TAG_POSIX
>> "\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
>> +#define SMB2_CREATE_TAG_POSIX
>> "\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
>> +#define SMB2_CREATE_APP_INSTANCE_ID
>> "\x45\xBC\xA6\x6A\xEF\xA7\xF7\x4A\x90\x08\xFA\x46\x2E\x14\x4D\x74"
>> +#define SMB2_CREATE_APP_INSTANCE_VERSION
>> "\xB9\x82\xD0\xB7\x3B\x56\x07\x4F\xA0\x7B\x52\x4A\x81\x16\xA0\x10"
>> +#define SVHDX_OPEN_DEVICE_CONTEXT
>> "\x9C\xCB\xCF\x9E\x04\xC1\xE6\x43\x98\x0E\x15\x8D\xA1\xF6\xEC\x83"
>> +#define SMB2_CREATE_TAG_AAPL                   "AAPL"
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 
