Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D51FC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 15:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJCPJp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJCPJn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 11:09:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA12655B0
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 08:09:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0RfE9nX223PlnJdDG7cIPLsDjsJFOx4xHvkAtOLtqs2pSRDQ//MYqbSew7W+VfvoAm7jmr1IARksf5RltGjdXJXEraSFg+Z/QIyOKR5v2cRPjVebWRFRCtjC2HQXxxNuaJhrhAnZNfP9uNZwDSXbznZEnYBmS8mcWzbST1Up2eUdxqov5V54vTb8DpF2gfiox27H2s+OE8wEpQCf5FRLK1rKfIvXOrixZANk8muZgcXY4rg97fjjkNhY67Iw5kR9pQYVaKwQg7NynSv8xfFg2SbVVJ8IOLiVOk+OVtfEk+EF97pWIPU+loXoJoxHgL5NV3AVpcYpZ8MLV7KcdXGqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvg8E4+HlR1AqxHJkByjCSYmimNzktqirAyAyytOjCQ=;
 b=n1xfGDBN+oZJBzAxEpgIGt8YXijkEoC0UTUoxSTz5mKN9aExd3ARKXmoey9RdGXKqPblsAgGld7EZGbNcx1Am9VnLm50cqvdO78LpB+ryKyIGfHmeINnhb5cEkIYG5yyofSmAOy9yWxWoVV4/mE4Yxg/BzOURVRcma89koQ5UiKbYqCJskXflUmGGAcbSoIQAldy1sgtpjISuPC5U01xIzp/5g97T78w2hH9YW1R9QuXgYiwZkxvJt6Zzy9nc3KuGT257vzaDG6Gq1yMX5+sMmAKkD3/l6dYF5hGmZm3zYG9axsRQarlkTCR5rpuYWtEdWRXS4xZX0IMMOMM2H/jFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5483.prod.exchangelabs.com (2603:10b6:5:153::12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Mon, 3 Oct 2022 15:09:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 15:09:33 +0000
Message-ID: <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
Date:   Mon, 3 Oct 2022 11:09:30 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
 <20221003145326.nx2hjsugeiweb2uy@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221003145326.nx2hjsugeiweb2uy@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:208:fc::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB5483:EE_
X-MS-Office365-Filtering-Correlation-Id: d5dc0bc4-9f23-491d-7f77-08daa551474d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXrb72o2QyE5HlBkRXLV26VYJ0G4Rlhj3iY8XbyA+FjryWdg4adYcBllRWWFpeeuK9EZyLdnHZxtKfFsgHizCwwfOWAv+D5/Xfz0fsLVXI7cftyX7W6/sjh5Kpp7sEm4uwSI97Pmaivdvcy9Kc6eLDbOIRf5+cVp/yOnqnFFPTbqKanhjZvTUJ4yqik4pc63qe2o16OYQDJpQ6RViy3sJBgr3fojAY3Ih0EFQMfA0xJIdoIMkuFsZQlTiyjZOLKKh3dTl1mNS60A3L4ShexbOf6n8jr/1T3m6gLsINrFaj8FKFU457ZazPByBqo66PEZfW+/z0JpkN7rdXo/qkC/QZAiLZ/KcgYAeNA/9mcNvggI//KkGR78oIfgXB7thQY7KkjVPXdVNADgIhE+LNB3jNaao0M7YHiwe2EO/olykR6TIlKBviGRZW5spRSaBc+aqkowrizokHh6DhFHv5R+rUMjNqDpKT1fRfZmIplV+jLGmXkZaX8p8m/8bSXKU2rkd96AKk+wmlkncF6HfmNF70jTIUKLuwShWD+6akG6vTWZqI/wlbLrFO7od8fbO8IBwPVCEqdWZEwNlJupOznkVUSrXVo4HceRldKkiSMnw5iyuyNWRmsv/CdHXTxetd2hsbLaYjsv6JLzfCxyGVprCxvrDJsgYHVT0WiTZ0nk5wxcx4soYz5n+K911WFJnBkGo9xgFTJkIG8Al6gEDGw+WGYN50fc4CDpdkgEvkK2QhkQ6bEc7Zek9edMaAh02F/PneUaZsvqmjLRs5YFjKo8icbzlVE1NK759jG4mViLt2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(39830400003)(136003)(366004)(451199015)(36756003)(6512007)(31686004)(86362001)(31696002)(38350700002)(38100700002)(83380400001)(2616005)(186003)(52116002)(53546011)(2906002)(6506007)(5660300002)(45080400002)(26005)(8936002)(4326008)(41300700001)(66476007)(66556008)(478600001)(316002)(66946007)(6486002)(54906003)(8676002)(6916009)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enRUQ2IvMFQ0NmZUaThZUnZRd3NGU2JVUjJqU2lycDVURFRnTnp3c0pEOGk2?=
 =?utf-8?B?MDQ1di96akNBS2ozVHlsODJZUmNqWCtqbUwyQXBJZ25pZzFsc2NxYWJWeXQ2?=
 =?utf-8?B?UjF6U2lrSVdyK0J1NUxVbmRJTE4wYnowL2ZTd0hLRGIvdlp6WHBEbGdZTm5h?=
 =?utf-8?B?ODF6aGZPdHYwSnBrbFl2MmNGZWJ2ZHI0UXBLaHRqeXpsR3d4Z20ybTZXdXNy?=
 =?utf-8?B?Uml4UCswUTlYYis3L0pIalY1cjZVa2drYWRoZ3g2QURXWm93K0tIVkMxeDFx?=
 =?utf-8?B?RDY5RHNBZ0JYK1drVE1ab2Y5a2t5alJ3VTZISGxrd0UrSmhkSzYrRkUvT0NV?=
 =?utf-8?B?T3VHaFVRYk1qQmpyc3p2M28ycmhGb3RqcXRJR1ovbDZubTEveXRJSWhvUTVO?=
 =?utf-8?B?RjdEV25ZUVFwaEp3MkI5L1ErdytmM1BqR3A2cjNKTlJqTnE2bmtxVDFuOGJD?=
 =?utf-8?B?N1dnNHFMblBwa2Z0UDFMYkVVYTlOTDM0S2tETXNIcitKaXNOQU9Ua3FkYklK?=
 =?utf-8?B?ZW04cm5SZG94eVo1WmVybXFGVWE5WFNxc0d4V3FDa0VHY09JYmJjdjlENDlQ?=
 =?utf-8?B?K2F2eWt6Z0lCZHZnVDh3MEQ3YmJmOVEwR3k5RnJ0UFFqR1Q0TFF4L0ZhOGNH?=
 =?utf-8?B?VXJyMmVqTjUrRC9xL0NEWERqaW40UUVaWjBuT1lKVXlyNVRacnkyZm5kQ1ll?=
 =?utf-8?B?VmlsVVZNbGQ0YnJyc1ROOHNZQjFKMS8wQmQ3Vkw2MWhYTUZPcjJqV0E1REto?=
 =?utf-8?B?eURPckFJU3hPVWwxOFhJM1VMQnJUV0hvRjN6ZmpYdmxMRVpLVm1wRE5iZmRs?=
 =?utf-8?B?bjNqSUdXOWZqK29vdzVBVDZxdVd4VzlwdytocGlhSmxKTFBmNUptRmRQRFRy?=
 =?utf-8?B?ajVtUFJadHk3M1c4VXplcWd4Rk5DSklzWExuVGEwa2VLVmR6Q0Z5UGNqTlpm?=
 =?utf-8?B?VkRaRld5R3FpN2ZhK0dmZUR1VE9oWXdxdSt4ajBNcnBZSmZtZ1dRTVRnblVS?=
 =?utf-8?B?a2NNQy81dXp4MzFHbnR4SE5YUi9mTy9Zdnd4OUZrR0lKRk03UzZWUXAvaTQ4?=
 =?utf-8?B?SXRWb3dnYTBuS3BVcTRIWnFHTFdzTE9mZGRibCs1cVltZ3hBU1ZVR3dSM1Q2?=
 =?utf-8?B?eVF4SlpmQ2V1QkRtMkZaelNkQ1RFNE53SnFUT0RFMmV4MXhzVExDZmxCNFUr?=
 =?utf-8?B?ZzV0YkpZMGNTRG00OTFRaUtwTnBaTnlXSnlnY3d1cVFzbmFpRDlraklISFdq?=
 =?utf-8?B?dDZiNUJHMlBlWVVXcERhS1RESU5xcmxKSVM4TVRUUit0bnRrcnR6cVRmVGFa?=
 =?utf-8?B?cHVMb2hsam8rSkdFK2h4Q1R3akZ2KzlyaGxESEZscHVYYko2N1YxNDhablg0?=
 =?utf-8?B?aFh2WmRlZUlrbStlV1BCUGpZcjE4Z1pWWVoyajBtWHVsck1RVnVxbERsS2lY?=
 =?utf-8?B?THIwZXozMzFQV0czQmdiMjJaVEdPeElDUW5Kd2xVZmh4V1l2RWVYQXNzMUlQ?=
 =?utf-8?B?b2pvOXdYV1d3dTFuZGZZN0NENkM1aW02OGdOcExjelB2R2FoKzBIVnBUNU5P?=
 =?utf-8?B?RjRidnBNVTJNS25wdytxWXNyNUtyd2ZwVVJZQ2FvZkIwSmxNTzlCWWJPMDNu?=
 =?utf-8?B?WTUrYmk2K1lXK0pSR0dxNWlhMmtadUxHZEFTMGlsSjI0Y1FpdXRJZ2pYZTlG?=
 =?utf-8?B?NmY4Z2Z5Zy9SMlhSdVRNUkNnc3AwaE9YU29RUHpUcmlHSWV6ODBRWEl6R0hi?=
 =?utf-8?B?QjJkQXpEMVI5bGlZWUwyVUlIYXNwYlFlYW9ZSTBlMGZrOENsY3B3bml1THZI?=
 =?utf-8?B?Ym1rT3RDK3BkSFM2MkRqUG1Sd2pJQzZzWEVSR2JtMWg3OXl0OHYzMytPZzBz?=
 =?utf-8?B?M1M1ZWdaOUo3RzFGWm9sM0lsczB0VjhFY1lpS1pOdEVBTndUU1I2N25mekVx?=
 =?utf-8?B?M0hrNUUxbllVRHdMUHArNk4wTkN3UTZPOFVuR1o3SDJ2OUdVNVRkWGhQVUNN?=
 =?utf-8?B?K2krdnRtbERhNmdTRzZQSUIyZWR5RmE2NCt2c2pHbk1Mb1VVdkt1K0o0bzJt?=
 =?utf-8?B?MVRTUmVOY0k4Szk4WW1oWWJiTEYrckh3N1UrY09TSGJQRGxhMklQc0ZqK3lO?=
 =?utf-8?Q?BiwH2ERw5Eo+tmR0XzJmer8Tc?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5dc0bc4-9f23-491d-7f77-08daa551474d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:09:33.4947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0s5tUhGHLsE6VfOMGSf+GNSRQnFqqGd3c6L0Jt06vtvRTY0XVdmwaQ/WoBGn5lEl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5483
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
> On 10/03, Tom Talpey wrote:
>> On 10/2/2022 11:54 PM, Steve French wrote:
>>> shash was not being initialized in one place in smb3_calc_signature
>>>
>>> Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>>
>>
>> I don't see the issue. The shash pointer is initialized in both
>> arms of the "if (allocate_crypto)" block.
> 
> True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
> crypto_shash_setkey() got stack garbage as sdesc.

Sorry, I still don't get it.

	if (allocate_crypto) {
		rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
		if (rc)
			return rc;

		shash = &sdesc->shash;
	} else {
		hash = server->secmech.cmacaes;
		shash = &server->secmech.sdesccmacaes->shash;
	}

The "shash" pointer is initialized one line later.
And, "sdesc" is already initilized to NULL.

Steve's patch initializes "shash", but now you're referring to
sdesc, and it still looks correct to me. Confused...

>> But if you do want to add this, them smb2_calc_signature has
>> the same code.
> 
> True.  Steve will you add it to this patch please?

FYI, smb2_calc_signature() also initializes sdesc, and not shash.
Does it not oops? Same code.

Tom.
