Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B86C27C76
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 22:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbjAYWYY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 17:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjAYWYX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 17:24:23 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1395029E38
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 14:24:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkzX3Utb2Dvai1hTb78xtLWnNvGqT00VbhWmQGBrprmtVHOlcM4f3vMzVUB9KVF6afr3jS9uoCg7y83ZGRr8wuPsD/bjSaEu3RyUYe/rRNpGFbJtxBZpxEeYT7Gna9t902XIfRbgRKBxDRNTVgNhV+LqHLSv87j/JG+XTkYyN2z44LZZA8kX2qwNPOQ5ky+V/7+DOpeozjmVyi5chPOeit+RPstPlZ3ikgvAiJHYgVYhc0NOGex0m1bClnAeYn5MzpRLoujcN49JTpodvJNsvbSzYsX1PkqEihYZlsTYGGzAXLahe4STHxr5eaAb42D48EDDJpR7EDeOkrhwDSlVXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jOphdXwpS5D5VUshimE0bBrLMKuPz3z3APHC7h/uXMA=;
 b=DCI0O2PeONRngAsb3jwQf01kx6ADyrv5oQaMJtD37ORBlNztQd+ZL6dUmoWbDLJWb5KmDd3yhh3g7AbVBawC3cuVfmiMt6zDA21cl5uVboXEoAHOn9tL0q08ciu4Kuo8hp+Pb9NfXsIa3k1Av0O71QlKHeVzztvHu9i+ZcemW5lPM0tRqKIo8NegOWobMNJwalLR1GVGmfTfNTcgPVKxwpUaOLURvwlpxv9g/y+pZ7VsGIqN1uMNomPbo5OW4XorlBt2J+owYLfCrto1aE8rgEzA5GLSCdOKhYao0jWcZ7ZVzgrI3tSgmrDiI4xhtZee3ECQyFz9f3mQFDJWudb6EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR0102MB3430.prod.exchangelabs.com (2603:10b6:4:a4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Wed, 25 Jan 2023 22:24:19 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 22:24:19 +0000
Message-ID: <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com>
Date:   Wed, 25 Jan 2023 17:24:16 -0500
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
References: <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com>
 <1130899.1674582538@warthog.procyon.org.uk>
 <2132364.1674655333@warthog.procyon.org.uk>
 <2302242.1674679279@warthog.procyon.org.uk>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <2302242.1674679279@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0066.namprd15.prod.outlook.com
 (2603:10b6:208:237::35) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM5PR0102MB3430:EE_
X-MS-Office365-Filtering-Correlation-Id: ad691325-6cb6-4b44-7ebb-08daff22e696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UvtEk93QPdOWFVsqVb59JiZbqUxg3VxlwfwaBKHJzlZBLY4W4tALHWZ8UlOGTCSNLArdktvRAsiZvoUqmZRQSVO7sU4hJX1XBENDtkZEzAVB49dLC/ymAhqlc4fCh8PThCgZp52kPPdIKpI4137TSYMEsH2JN4jz7HrsuS7q6/pYnvZm9mn9UbmWuLR/OuWZF2P8xUBlxv22+jpSmFKekNyQpTMVgHZ6x1K/dRvEZGXrkabPhBJK4Xn10SkacCnneTEztbYPNg3I0v+8YSLahuq84c0NegvjngNVCblaTnmj5yQ7phMxDhD5jqwwblLHU53yqMQzLIA7aIR9cF6T+ZqneTlzEWpoic4qE5ynowmRo31j2T5tVvU2Zqz/1nR5YOMFUe6GU5vh9dfPlHaGDQkZvHyQyAD8/HvyMIf6jOIwslxpJvOaRcY5yTJSXJETALwTlmQExNsy17pL265NUmx0sPbCM+N9nZRqHku+irAfdaxk/iSFTnBLlb6sQRrs7OI6zzgfAsrLkxtjctjuYtpEpU7q4HdkyJX6NFaEJZhncnPPERHWf9jytd4QtvaBgs6XTpm/IYgFFdYRiRGlJPMQwZR055u/02Dey5YBb3DEr52V0rPx4YD+icKBlJcyxYQThA38BJz6Rk8DWDzCrGujlQ6A5dalybzXqj214R5yq0yiwmECEYfI2VEVAHuHD/psb/NWuI58AJvAz/wrRpqsfoRK6Ikv/Si/r9w8vhGRP+kHWMg+7DNwT673ZsJWb2BRMOEDMzWl5n9nUJvIIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(39830400003)(396003)(346002)(451199018)(66946007)(45080400002)(6916009)(8676002)(316002)(86362001)(36756003)(54906003)(8936002)(5660300002)(31686004)(38100700002)(31696002)(2906002)(6512007)(66556008)(4326008)(38350700002)(41300700001)(53546011)(26005)(6666004)(6506007)(186003)(2616005)(966005)(478600001)(66476007)(83380400001)(6486002)(52116002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXlOdHZ3a1RBeHQyOGc5YnluYldnOWVVVWJRTnh6WWtJVnV4Y1ZuQ2lvT1JC?=
 =?utf-8?B?aXRGVGtLT3lseFh1NTVYWmE0cVBWcjBPRGFBS29jSVJUY2ZOZGxtK1RPaDZL?=
 =?utf-8?B?WTJqZkFEb0tzdWFnUS9nSm9JL0laRXFaaUh1ZXFwZGtyaHVNV0F2RUxnaGND?=
 =?utf-8?B?NlVXcFB2UWM4bGZCNXpSdmxCeHQ3TkF3SlZNUHp4SWFKcThNMHRoVXlVQU5V?=
 =?utf-8?B?eVNkeEUwU3N1eVpRNnN2a3Bqd0xwMGlnZ2Z2V2F6emx2NHVxTHFjR1dHYXBY?=
 =?utf-8?B?Z0xPZjd2cmZ3RWh4RWRLWi9KTEs5Vkxsa2Y3czZTMWhjcW1ZQ1BwdmZXa1JD?=
 =?utf-8?B?eE0rWTVPUzdLc2ZNbWxCYTc2TXBPRG1sN3Y4TUx0dFNkTFdQMFV4UmxCR2pR?=
 =?utf-8?B?Z3RheXdZeFkrQ2FaTFIrUVJrU0xHMk5lY1Awc2s0U1ByUVE2RGF5emh0SGtN?=
 =?utf-8?B?WG0xbWxKdW5xVHd1Um9pNTUyZWQ4WTVmam42VlhEbm4wL0FPMUNPRWhNODJS?=
 =?utf-8?B?WVdrY2M0WnNXUFdJQkZrV0VQVVpVWitCbGU5aHd4M3BEUHFxOFZPNGtjNkV4?=
 =?utf-8?B?Z1BnRzZ0K3ptSUx3Z01HOUdNdVZhU2lVQUZnaTQ4UURQVFFObWlEUFBLSlB3?=
 =?utf-8?B?b2dDYmtPTE5NdW9hQjNNOEFUS2NQaUp2SFlmUDQzVkZsaG5jdVZhZDh5dXg0?=
 =?utf-8?B?bnJYR3BpN1lLR3F0ckhxOFRSc0svSGtPSEdKaUo1NlFMYktMYW9hclBOcEMy?=
 =?utf-8?B?bVhHYlpjdlVCMmVGR3NxUERCWXpxWjRSUEY4czc3RkI4N2hSZU5scE9JdmE0?=
 =?utf-8?B?c2VLMGlxWUlLZjVDdVBjbGJpQS8zdldRVkxpMHp4M2N3dnFraExGck5MakEy?=
 =?utf-8?B?RlRieEJSMDlvUHBqNCt3ejlTckJWVEVWdXR2TGlZZkV6d0p6YkJ4QmxvL3o2?=
 =?utf-8?B?RFBkQVdWVnM2Y2VPbUtlZWlXdWw4L3hIK2V6UEpPQVM4SFNEMGZsTHdVYVF0?=
 =?utf-8?B?ODI3QWY2bjBDR3FsTkxzU0NldVNCMk1PeDkrUXZpTEtBcHAvdTNBZXhsUyt3?=
 =?utf-8?B?MjlyU1JQOCtEeU1KSmRlTmxGT2pkTzEzT2xFZm1tZnRnZ1lxc29ubkZRc1dS?=
 =?utf-8?B?SkNPSS9yTWhHZDVORjlnS2ZuL3dXbnhTVi9OckZTTWZZZXBwdXFYUjZWZXdE?=
 =?utf-8?B?UlRQYVoyWlRDYWtPcUZEemZtRml5ejVTUkFiRlRqaWtLV0pTVTF5dTE0b3k1?=
 =?utf-8?B?QWpzWnJFcG5uZk5HUlYzNXBCVkNTZldvRjFVRkpUc1NLZVNvSWJGWmQwSUpx?=
 =?utf-8?B?dDl4cklwT3ZBQTg5Q1JsWWtPemd4UkY2TWRISjFGTm1LeERJcDgrTk16ck9J?=
 =?utf-8?B?N200N0tjT2tObktHSHAvWWhXMnlES25HT3JYV1ZBa0NNbDIvNjhUUUtldm1B?=
 =?utf-8?B?blVhRW9JaUxYdDdiL0l4cFdpbC9BRHhtMlFtYmZFbjF5Tmx2cTZjd01rMXd2?=
 =?utf-8?B?MnRRODdXOFJIRmVVVFNsaFBselVDS0tRNlY1NHM0TXJaQTZUZVVmNkxLdEQ3?=
 =?utf-8?B?Q0U4ZllXSkEyRnJac0lOZnhMa1dGQ1VDcU1PRGIxWml3WUNmSFg5b2xBbGxL?=
 =?utf-8?B?UmpxQjdkNkE1RUtjYW5Na1pJMHRYVHlmeUpZQ3gzM3Fydm9FZlhoeGxjV3Z4?=
 =?utf-8?B?L0FWOW9YNnhEMUIxVmJUM3ZScUVrakZmSHNQUjZITHdSSkJyTGJ1VHZVZjA3?=
 =?utf-8?B?V1cvR1lnZ3VmbjBQSGJZdUtOMGNsVkgwSmd4cjB3TDBsK0Fjc1crTW81aDRS?=
 =?utf-8?B?Z1JyR1doa2Jvb3ZIVUdJa29ic2M3NWpseFJSaDdLYm85QkYxZUFqN0Mrdll2?=
 =?utf-8?B?WXNvRENOeDZGVHlsSTgzc1A1VWZIL0g1aE5kL0hKZzVhYzl0NmYrVWxMUWJa?=
 =?utf-8?B?cit5N21naDBnMmxZbjlBZTVKbXFzSGxPNVVHeFBsT2tNK1pZb2hSS2F4Sk9s?=
 =?utf-8?B?UWV1UjltdU0rTUVkTlp3Ynk0dElzWlZMbVZJd1k5bUpVUzF4ckJoa1VaQXhL?=
 =?utf-8?B?UUY2Ymc2ZG55V2xZaSt3dkU1QlprR0tXL3A0KytkZ2ZYK05oYXB0RTVYamlV?=
 =?utf-8?Q?sLgI4Tuy2e0Y5qqWwuv7sYa3U?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad691325-6cb6-4b44-7ebb-08daff22e696
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 22:24:19.1908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b32dO6HXGrCR+/7QAdkA/yBEh5dlABFb+v9GmCDqRlmfKeiMIV2RvRhX/x0qPMaf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0102MB3430
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/25/2023 3:41 PM, David Howells wrote:
> Hi Tom,
> 
> Steve suggested I should ask you about this.
> 
> I have IWarp RDMA mostly working with my iteratorisation patches - certainly
> better than without them, but I think that's mostly due to the patch that
> Stefan Metzmacher so dislikes ("cifs: Fix problem with encrypted RDMA data
> read").

The encryption problem is real, and Metze is correct. The client
shouldnt be requesting, and the server shouldn't be responding,
with unencrypted messages on encrypted shares.

The problem is, the proper fix is complicated.

- We've reported the issue to Microsoft, but they have not yet
   said how the Windows client and server are intended to behave,
   and they have not yet revealed how the protocol document will
   be changed. At this time, the Linux implementation conforms,
   dangerously, with the published spec.

- There is some unexplained behavior in the client when the
   connection is lost after failing to decrypt the unencrypted
   response. In my earlier look at the traces, for some reason
   it reconnects and retries without requesting RDMA. This
   succeeds, because the "inline" requests and responses are
   encrypted and decrypted successfully.

It's interesting that this occurs on a compounded fallocate call.
That might be a clue, too.

What are you trying to test? Since encrypted SMBDirect traffic
is known to have an issue, I guess I'd suggest turning off
encryption-by-default on the share.

I'll poke Microsoft again on the protocol ticket.

Tom.

> However, fallocate doesn't work:
> 
>     # rdma link add siw0 type siw netdev enp6s0 # andromeda, softIWarp
>     # mount //192.168.6.1/test /xfstest.test -o user=shares,pass=foobar,rdma
>     # fallocate -l 1M /xfstest.test/hello
>     fallocate: fallocate failed: Resource temporarily unavailable
> 
> Because smb3_simple_fallocate_write_range() calls SMB2_write(), which calls
> cifs_send_recv() then compound_send_recv() and thence to smb_send_rqst().
> 
> smb_send_rqst() encrypts the buffer it is given and smbd_send() attempts to
> shovel it to the server using Direct Data Placement - which I think might fail
> because the data is encrypted.
> 
> In one run of the above commands, the data in the kvec array looked like:
> 
> fe534d42400001000000000009000a0000000000000000001600000000000000a01300000200
> 0000000000000000000000000000000000000000000000000000000000000000000000000000
> 
> before the smb_send_rqst() gets to ->init_transform_rq() and like:
> 
> 98eddc1bc31da7c55c00341e4dc769fa4c8b2b0ecdacbad33eb31855ec162fa2458b8437edc7
> 88ee0a033c84aa857b65ab31ce553594d412719cc3daf925e873e80062ec16b97c855721a42d
> 
> after.  The encrypted data is seen on the wire in DDP/RDMA packets.
> 
> Any thoughts as to how to fix this?
> 
> Does it need to pass a flag down to suppress the encryption or suppress the
> use of direct data placement?  Or should it perhaps go through something like
> ->write_iter()?
> 
> Note also that it encrypts the buffer in place and then
> smb3_simple_fallocate_write_range() reuses the buffer multiple times without
> clearing it.
> 
> I've pushed my cifs iteratorisation patches to:
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-cifs
> 
> I can post them by email a bit later.
> 
> David
> 
> 
