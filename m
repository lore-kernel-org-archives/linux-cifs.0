Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D93C38A02
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Oct 2022 12:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiJ2MsQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 29 Oct 2022 08:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJ2MsP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 29 Oct 2022 08:48:15 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61D65D729
        for <linux-cifs@vger.kernel.org>; Sat, 29 Oct 2022 05:48:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1psq3XzDXdaVGiYn+IxSokAwr3EtjRuDPvWlfZwHxsOycZuzRhM88DYdExD2Qoj89uspadUyLienN/caUKrEdpTVsW9O31k8xLgrnhYl2iOa/I2yV9PGEZ1oiSWwOO+jC5E+SLWEfOXt/hlG8u38EFluPufXyAJVp4Gh7UDPYJVYLk0a2gyFlcHIeWqir4SmmzPUdYOWTW/SbPX2Ad6uW1pW4je10Zx5kD5naG/EXrgoMy0T7w1TQbtp3CwrsZ9IAgtx+Cih14UKjgRck00MDGHG+rYJ7vU2KlWXTN2rcs79YFosFPNBx2nOWiFztVIYZHwwzFfseOJQLb0uSqJOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tavuh1ZI4bzIjZ0kM/o5ahrfcTaQBsr89hpgQa9uHbs=;
 b=X1eRE0hyCavfz25XNyzHK687qqumoViF5hEuItsvQMOTkRRJNmy6Gql7jGiOTJLc+51qf6hpwsVgpwJs9SpQ8gUIXGOBOshR9SqKIXI1F9X+yww6mH1XcEq1qWB5w6IWInCs4H6lqdmg9d55M+KMER+8n4/VpotAP3cqntKB0I42yOzI9Q+JjnklpTnDhBtQuBhEnx3Vp0nXavSTpj2xReuLKsfB3giq7L5IzmeV3ipExSjsmTr/7gCM4zQOpupBxUlvmnKSsDfnVgXhQlXNdujCn8lwqGNTQ28/RkxBqnFanutq3sRlef33JY7pUgNHf4GnQOVtvk35uNrDuOhhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA0PR01MB6361.prod.exchangelabs.com (2603:10b6:806:e3::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Sat, 29 Oct 2022 12:48:11 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::a85b:910b:5c36:a282]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::a85b:910b:5c36:a282%4]) with mapi id 15.20.5769.016; Sat, 29 Oct 2022
 12:48:11 +0000
Message-ID: <abbe9909-5bf6-23d0-3c86-4c7e98e8eea9@talpey.com>
Date:   Sat, 29 Oct 2022 08:48:12 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@samba.org>
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com>
 <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
 <CAKYAXd8OwkEt=fJZrtooba_OYorBt4kEg68DrLJN=0OjQhkrjQ@mail.gmail.com>
 <CAH2r5mt08V-RQa8=apT-fAqXxQtKkj_9XNSMFvUBm=da-UMyCg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mt08V-RQa8=apT-fAqXxQtKkj_9XNSMFvUBm=da-UMyCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:208:32d::15) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA0PR01MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: e49c2c7b-2f71-488a-5428-08dab9abd5f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HZ1I8WgEyjVrNkeyewojQCClssh0zDkYJA++VJjINC3h1DD8BoAOGGLDObD11mVX/bGQoIwwpf/IY+PUWkdHNUTF+3QiJjR+5JPq3NO4wE8FfSv2AhH0F0tDJ9a5SQSg1Lc1h08GJ0dQN7nqzd2wLGT0VtOAioAfzLHivKX7UEse83jQ44x9BOSEA+ywNkf2ul6UAp69JCcBcBFP+BHJxbF4eh8Hu85uzQD8JsIUMjPjewzz+EpB1IsEByOSEVVumMnLtA8e6vu3HYTn9SMnV9Opq88Q87XGarfdQM8+E85CI37obK76arHTifWsyqZy9pjcPJFGwQJd5XsdjdD5LEE48hYRNHQVUAlqVMM9OomGEEPnScUMMwadIfneVphqTKqpkcntNfE5q+fXI+NWEBRSpGG+DUS32kdus43nanhck1Rszc5wJm0FIAZhOoedG5WlBly7fjs1hrazg6BesiqYB7UAVkcqqg+/KKneAxYj5TCpvJYInQo8Hajh/EjLxt5MwVLBNQXCPVr+oCM0q1xxByEZs1CmEAv0lDQ95WsA5igscBpAZkyJgrf1bkaDjfGxFiajP3FABvm9rAXzcPCq24hYrDpqKJJ9q9Apnmu3nDRM1+2QISYFQrOYC6cjrqAKsmJF1G8uodpC/W6rqaZ156kv7oPwCAKEN9k42+86IQu556wD0vJnqtsrI4NXs9hB0zQfeP9j5TgZzQtGmJELMiEwr4v/WSpFO4H4E8LI2fmRP0xh4QYaYNEUdHZCdDsF9nFyhAJysmwXUTEqyfnjKAzXTSkqBH5mNV3Eeg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(39830400003)(136003)(366004)(451199015)(41300700001)(66556008)(110136005)(66476007)(66946007)(316002)(54906003)(8936002)(5660300002)(8676002)(478600001)(6486002)(4326008)(83380400001)(38350700002)(38100700002)(6506007)(52116002)(53546011)(31696002)(86362001)(186003)(26005)(6512007)(31686004)(2616005)(2906002)(36756003)(4001150100001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHpPSU4velBJT0RjeHFIR1FPRk41cURMUmlKbHhTOTM1WEJ1NUJhNU5PbXoz?=
 =?utf-8?B?eEF0bEZvWDZSQUorOHhlamdtdVEveGJPTFFEWktDYnppV3piUDA1aUZhUjlv?=
 =?utf-8?B?a0RFM2ZzaUR6RmpobGRpTlVQenVVL0laVndJbWM1OVBUaWw1c0hNYmlpYWE4?=
 =?utf-8?B?L1lSb3BDZjVCZC8xd2luUDJqank2SElBTm55b3U3VmVkdmltbFEzb09ZUTRF?=
 =?utf-8?B?M1diVnAvYUhYcmF3eHQ1MHV3UWRva0J1WE56Q2pUQ2NmS0VjcUV4ODJhOGIy?=
 =?utf-8?B?NW9sV3M4Q29oTHNDNmtYditpYVlyNlFUOGVYd3A3Sm52YW5JcDhYNDRtcTI4?=
 =?utf-8?B?NEd4b1h5OGFDTCtCaVZ6Uy9SRmlFTWEwdmZrZis0dzNncXIrNEpvV1hra0V3?=
 =?utf-8?B?S1VzR1FDcVZwNWE5QVZkZ2hqL3IzaUE4U1ZySFg4Q2Jud2tXRG05eVhTUEdO?=
 =?utf-8?B?REwzamJLRUpldGRCSU50VDh3enRqWTNSa2tXMHNUQXpCbjVYUUFYeGlzVVB2?=
 =?utf-8?B?TDMrdDVJSERIelNaOUx3cEF5UlhaUENNdUxQZjZBL2Rxa0ZjdytGQUo2Vis0?=
 =?utf-8?B?akpCa0Q0UkZSd05hczJoaUZWYnZCeEpZU2NoQXVYVU04aS9NQTF3NTFudG9I?=
 =?utf-8?B?eUtvYmVBRkEwSzE5UVd6c1k2U01WUkxRTTBPcDBLeGFXcVJXUmk0eWMzeitQ?=
 =?utf-8?B?Y1dibE8rM04rZm9lL21uYVMwS3Z0VjdQSmxFRUpyMGVwVmxXM3VYcnpMRXNB?=
 =?utf-8?B?cmtxRlJvdXBDVTREWUpjUUpjRlNuckEvN200S0dCbnNFaDh1MnlUYjFaU3dw?=
 =?utf-8?B?M2hLV3pxeU9XaUtSYmMwaUpyKzBqUUxFcjdORHp5cGFXVnZYelk5cHhLQ2h4?=
 =?utf-8?B?MWxxYXNtekE4V0wvcm02dHZYOGhKTWZKMDFLQzFWNmM0RjNqTWg4NksvdURY?=
 =?utf-8?B?Q2tTY0pjOVlpd3VJNmhJZTd6Vzd1ZUkrMlQwODhIaDI2MHVMSXJ3cU1QZnNJ?=
 =?utf-8?B?Sy9PUHJWa2U3Vzh2cktqNkNjdGFPNk43YkF3WHk4SzByUmpIOHVzTFV0aWVR?=
 =?utf-8?B?WGJuODc1TnlYM3hhMFlGZ3JJb0xzQ0d3NmQrUU5hNjdURFJQaW5DYXR2V01v?=
 =?utf-8?B?TTVKdzdNeE5xYWJqT29VbGZ1c2Z2ek5wUFlUWHFTZXZvd2VrN2xhSXhtKzNa?=
 =?utf-8?B?MEQ4WGE4NThMSmlKWWxlYWFONGpLaVBZNTdsbjhwRWpRRzN0bFdiYzRYTnR3?=
 =?utf-8?B?K3g3d2ZPTHBwTWJUSTgzamlSK0FqNitwVWFlRVRRdU90TWxDTjVES1lzQWMz?=
 =?utf-8?B?Z2IxVUgwWFd4U2pHdU15NnlmV2ZtQzF6NzhqUXFKeTk1UjRZRHQyKzNkYzJT?=
 =?utf-8?B?dUVsTngwNE1KK0h6N0wyU3dvdUdzN2puVlpGRXhGTGgyd1ZhWkZZQzd2VVZ3?=
 =?utf-8?B?bUpudHVQdmJ6aHJ4TnBxazljVW5XYUxTU2JWYWJkTi9jNjFTWjJwVWlEYjFz?=
 =?utf-8?B?SGNUVGw5QWllT2xOOWMyaFg5MHBaRUtzeVVLZzhRbmg4dDhTRk5HT0JieUJa?=
 =?utf-8?B?OGp3dlBnMCs2NHJPYjBCVUhaanRVbGM4dEJRZG0zRGJiL200cnZFRUI4bEhi?=
 =?utf-8?B?bkhsMDhUek1yc09kdVdWTzgxNUZRZGZOT1Nadk4wSk9obzNseForbFF4WEpC?=
 =?utf-8?B?czB5RUpubGF1M3A3cWNFNmVrQWRHeDUzdUxWQUVhREJ4Yk9Ucm5XT283VTMw?=
 =?utf-8?B?NEw5dkxWUTg3SXFELzJlekhDYTVDRWw5Wi9sclREZ1FHdTVzLzFGdFZGZTM4?=
 =?utf-8?B?d2hqUVNRWG9YQUllZXh5ZUJjbDUwOFlhNTFwK3ZCRnRFVzMrZ1N0b3NCSExu?=
 =?utf-8?B?ZkU4TFlmSTNnTHdRUkVuUGJpRW1jTTNhampqc3hlTTRTR2RXRDRoUGtKV2s3?=
 =?utf-8?B?c1ArcGJFcnBQVFduZ2ZQYWx6cFNkU1V5UVU1czJsTVNiZ2NPdjk1RnRDNkoy?=
 =?utf-8?B?c0RHYlpGaE8xYlF0SWNFTVFSOCsrTHVBUThQQkRBTCs3TWpHK0tKZUFHVkJS?=
 =?utf-8?B?S3NkZkFDc3Y2SXVPZmtnN01hYUFJK00zOGhqc051Tmc3Sk9XRnFoeXhLQjly?=
 =?utf-8?Q?iUtQ=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49c2c7b-2f71-488a-5428-08dab9abd5f8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2022 12:48:11.1870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZzRNH9mMK91dRmYnWFRnZopH2HxUiB+RmxuWQEwqgPt6pJ/DXICIpeIPOanq2KaP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6361
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/28/2022 10:29 PM, Steve French wrote:
> thx for testing this  - Shyam's fix for it looks promising (needs
> review though and some testing)

Good, because the original fix confuses me deeply. A tcon is not tied
to a connection, or at least, it never should be. It's a property of
the session, which is shared among multichannel connections. So if we
have to poke at other connections to find a tcon, that's a fundamental
issue.

Shyam's fix always simply looks on the primary channel, which works,
but it's weird relative to the protocol. The real fix would be to hang
the tcon off the proper object.

Ronnie asked:

 > What does MS-SMB2.pdf say about channels and oplocks?

Oplocks are not tied to channels, they're tied to sessions, tree
connects and files. An oplock can be granted on one channel and be
valid client-wide. And broken on any channel too btw.

Tom.

> On Fri, Oct 28, 2022 at 5:30 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>>
>> 2022-10-28 18:19 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
>>> On Fri, 28 Oct 2022 at 16:55, ronnie sahlberg <ronniesahlberg@gmail.com>
>>> wrote:
>>>>
>>>> On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
>>>>>
>>>>> I haven't tried a scenario to windows where we turn off leases and force
>>>>> server to use oplocks but with ksmbd that is the default.
>>>>> Worth also investigating how primary vs secondary works for finding
>>>>> leases for windows case
>>>>
>>>> Yes. Until we know what/how windows does things and what ms-smb2.pdf
>>>> says  we can not know if this is a cifs client bug or a ksmbd bug.
>>>
>>> So lets wait with this patch until we know where the bug is.
>>> I will review it later for locking correctness, but lets make sure it
>>> is not a ksmbd bug first.
>> We can reproduce it against samba with the following parameters.
>>
>> server multi channel support = yes
>> oplock break wait time = 35000
>> smb2 leases = no
>>
>>>
>>>
>>>>
>>>>
>>>>>
>>>>> On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com>
>>>>> wrote:
>>>>>>
>>>>>> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
>>>>>>>
>>>>>>> If a mount to a server is using multichannel, an oplock break
>>>>>>> arriving
>>>>>>> on a secondary channel won't find the open file (since it won't find
>>>>>>> the
>>>>>>> tcon for it), and this will cause each oplock break on secondary
>>>>>>> channels
>>>>>>> to time out, slowing performance drastically.
>>>>>>>
>>>>>>> Fix smb2_is_valid_oplock_break so that if it is a secondary channel
>>>>>>> and
>>>>>>> an oplock break was not found, check for tcons (and the files
>>>>>>> hanging
>>>>>>> off the tcons) on the primary channel.
>>>>>>
>>>>>> Does this also happen against windows or is is only against ksmbd this
>>>>>> triggers?
>>>>>> What does MS-SMB2.pdf say about channels and oplocks?
>>>>>>
>>>>>>>
>>>>>>> Fixes xfstest generic/013 to ksmbd
>>>>>>>
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>
>>>>>>>
>>>>>>> --
>>>>>>> Thanks,
>>>>>>>
>>>>>>> Steve
>>>
> 
> 
> 
