Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA022C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Dec 2022 18:18:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiLTSSv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Dec 2022 13:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLTSSu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Dec 2022 13:18:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C171AA0E
        for <linux-cifs@vger.kernel.org>; Tue, 20 Dec 2022 10:18:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vj8RVz/oDgxI1+5eyryTzDO8MYnRHm5ePg6IihoUajYZXR8WfTUh48yxQ2/AKR78i8YED703FeAE+FYLlLyrjMTYZ2K0PgyZM50QWUFpH6CFCDOeEO2GwXGL9JrpoER0V0L7dwQSeHrpDCkpgCnAtN3rCS3EER718ImZS+CuJbNPAt8HxD9Y9NKQXTYoMOR35Ek9vNOlf7j7wCnYGKH7kKEKz24ul/AGXviNAuch/zK0AHuNBUzIFMuAQ1LHzjdAkwByygGSMmiIc91eErKq3LLnjiTyEHMZ87y7nkaZROuYBfTyT3Hdi/I1p7H7v66d6HKjEmxncVQJd4CV8b8I3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LDqKqgR7ZzYGFyZKg2W0GhxccOLoBBPTHiG235FXuA=;
 b=lPHMaDyXcDVlz8gqU5/L0+LZ1cu3wBatbbUljKzYEi2swfMewl3lyaC+US/HPAmq9IWWEIWpXaefJqllRgPUe+F+7oTfsoCnKNLL254VgxwDCXwksubIi8rw+DRgsNJlHW+59D/HWxdHh1knB5LJHv9Jz8dNUJjS8Cknp0/Rm/M7RBKr+x9DCjN7hWxC1nk3L0zDPouTcnhz4Nbk/2dQVh0x010pIib3KKqc79NnyAGC+W1EqBNswgNAFHFTxftWSuN1zSe77TL9YuFTg5JlAqBjT83pAh3wQZDGRStTA6lae3OrSzvvedzgb9PpCfJKMJAKZH3uCEby6ejpdDArfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW4PR01MB6435.prod.exchangelabs.com (2603:10b6:303:76::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.11; Tue, 20 Dec 2022 18:18:45 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 18:18:45 +0000
Message-ID: <6b39f048-b292-a0fd-af8a-abad97d22ed7@talpey.com>
Date:   Tue, 20 Dec 2022 13:18:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] cifs: use the least loaded channel for sending requests
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
References: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
 <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0064.namprd20.prod.outlook.com
 (2603:10b6:208:235::33) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MW4PR01MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b845e4-22a9-44eb-9bc1-08dae2b6a170
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3Z2FlOL9KhG2jkAWrJoG/9EdvVxYEyCv2PqbWaaWBFiB9kPvJeM0Kcaup5eWG4lmM5lf6PexjiVxr8hfzZbfd6UQ910DgvUN7TTmKIJcM4a4N1caDsaMIPc8eDVNP5xpthg7DkX634vSkysoPvGuDv736TeBqg/syF0T96QSAIXL0rN24h+1PQvXWAsuERSIgT+2/sxW8L3KkM1jXW3gSOu5CRqlzj5/GWcVQ+UV6ImIPj+mhvqy7001Q/OMMe9s8uW8nhpKLLOBGXHKL/OeL+DWRNilVvwlZuxV6t9McChBCjE4WEXEYkkDMZ7OhaeEHIMoMWD7T7zvRjK8loE9W/ffS7eNlRn7mN9Hvv4Ui3h39uDhs0U/A3CGqz06gnGCcJ16krmk62yBPQ2+I2agvTjZ9IGq8+32yZwcxdykIsV7SWCLRDAQsuNt71Het8JqI/CMPa2PD/q2P/xQJ9QD+k7DDg3STLdyXT5DpKNO/0kqa5aei6htV9a3c/FtyCNpvTER92RgiYwGfCsu0VmWJYNx5rsv2oi67CcxVn/dZd4xQH/DkBHFLF4azI+ZPfH0M40SY+ujGMfPRCSTHyP4SWUNddXvCW5rYRM9Swgebmtoytaz9vQMm2lOcLL8/RmE/IgaRQSpAFo50yKYCXXnc9ok5RRRfVdieRlkRFeIgTkYnpjDtW5/hhJq8lqiuy+wRQI7GixUEiucczOYs8/x0osZOzjWWa1/+FhGNhU+hgaKCwtvZbG9Rlh5w0QQ48L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(136003)(346002)(366004)(396003)(376002)(451199015)(8676002)(31686004)(5660300002)(54906003)(110136005)(66946007)(66556008)(53546011)(2906002)(66476007)(966005)(6486002)(52116002)(478600001)(45080400002)(186003)(6506007)(6666004)(6512007)(26005)(41300700001)(86362001)(31696002)(83380400001)(36756003)(2616005)(38350700002)(8936002)(316002)(38100700002)(4326008)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3NXR0R6S2ZVTVdiTk1EUUowbkkxeC9JenQzL0xUWFJaeXNRMWJaVGN1TkJS?=
 =?utf-8?B?ZFcvdnpGRlp4RXdDSFNVbkt5enN2YmJ2b1dtM210NFUySUhXMHpHdmpRSHN0?=
 =?utf-8?B?dzJid3JQR055b3V3NEk0THhmOTRlS3pxeGZxNnlnODFvQmdITXUrRlZwZCtu?=
 =?utf-8?B?eVV5UXdJUlA2VFh0d3R3ZVRJRWVNYzFIdytxZ25mTU1RZlNWT3RvOXhZam8v?=
 =?utf-8?B?WStNMW9sL3NjZTZnNElEYUltc2JldllTOWNHczlFQXZiaWNsK0FJMHVzaVhx?=
 =?utf-8?B?OW9LenRMQk1KZVJKQXhPUjlIWFB3NzBFTHRBc21obkVDYy9waERqZXRiS1pn?=
 =?utf-8?B?MlJGczlnMW1JdForOW9mQ21lRVE2QnVESmt3QkhKbTIyZzJqMG40MDNZd29I?=
 =?utf-8?B?anJIdkc0QzZ2bWV2UktIaEVuWTlvRmt0TUdEUnpqOUduZFNydzRWaTdrajVJ?=
 =?utf-8?B?NENEUmJHSitOcU1BNFFQTFJGN3ZDNEtEakZ1WWlzTXFCSVl6ZjFIbHFlMlR3?=
 =?utf-8?B?WnFnRGFYb2xUZlpnUGNFNktXcWl4WkxWcFhyU3BmcDR2WVliOGQ3aXlTdS9M?=
 =?utf-8?B?Ly9KNVVvOUpqYkZOVDN5dlJjZk5OWjhDYkJzNllNRHRzRDFVZXlNZUkxMG1z?=
 =?utf-8?B?WkhVOGlqSEljb2JPQk02UUlldTBodExiWkMwL29NRzhTL3FuY0hPVGQxSTF6?=
 =?utf-8?B?cGFPck5qVzRYZVNZWkdrMDhQQ3B1MENadGZXK2l1ZjQ1VVFqTWYxNGhJSU9O?=
 =?utf-8?B?aXZ4Ukljam0zNGZlWDArejREUEluZElBOEEwOUV5YTNQOEtXcGZFQlVGR3NM?=
 =?utf-8?B?K2Y1YVVjU3QwYW5SdC95L2dhN2NRa3NRV2xNMGV1ZU9qYlJYSVg0TFBkTUVW?=
 =?utf-8?B?UWQydEVLY3ErTXFLRjlGenVudFBiU1ZHazVwcy9pQ1crbXR4dFd5TDhyRFho?=
 =?utf-8?B?T2FaazRwUkpXVnJsZU5jRmM4Tll4dlNKYS9NK0hYTDg3ekRmWEJUckgvOWtp?=
 =?utf-8?B?Tnp4emhVckpLMlYzWUIvd3pPc0M3cDF3cTJkcXJsdkJscmFiNlljTFg0Y2Jj?=
 =?utf-8?B?cTN6VEczZ010OWUvVXB0c3hsaFhrWXRFcU9FVG1CVXkveTdxcmo4ZnJBRW8z?=
 =?utf-8?B?WDhHRzd5cWZ1bktncXRmM1dCNGNzYmhLdjY2Z2g5b3BUTWhHWXR2bWgrMUtE?=
 =?utf-8?B?SDU0NzAxc0NZeVR5YUE4NDZ4bHJwN2lyR0ovY3RmcDRCWVNOU2ZPZkhGOVdJ?=
 =?utf-8?B?ZFlIQkMvUE9YQW4rK3hjRjA0bWZzbmNhSVV1dWdYTXBBbzF1WGovSzhGSW5I?=
 =?utf-8?B?SFpjeURjSTNvTG5PeGRaMTMwSlg0czhzaDBoQ29sblZHcDJFeVhtbmI4Z0xD?=
 =?utf-8?B?RGlWcDRkS0h6cC9BWnlXaDhWUmpROFdJVW1DRWhpd1B6RDZjY3ZYMGJlWElM?=
 =?utf-8?B?R1VoTzNoWkpjMWhpR2ZmblpteXpDZ3k2cERrNmx0bVRwdjJueHBodmFMUXJY?=
 =?utf-8?B?WG9BVnVxdGdqbmkzZXVySzJ6WElNVURTMElBODVQNTNyQjMzbWZzTlhYdjFs?=
 =?utf-8?B?cGZVbnlNSWJiaGtCalk2T09CYjlvOU4xdzYvWGNPZmRPMW5JYzFKbjRJUGdQ?=
 =?utf-8?B?Vmo5bVZVNThOSjdtZE0zcTcxMkxhTnhYNW5rUGhVc3o5L3p4WTE0dWZkZ1BQ?=
 =?utf-8?B?NTVzVmZmdmp2QWdXOUs3cExPZ0Erak9GanBMMzVBOFNCNVJkZE92bGlEeEcw?=
 =?utf-8?B?QUVBcVF1ZVpkS0U0RUdqNG9lc3JORkQ4anU0eGo5RDVtbE1SbzZlSk12dmRt?=
 =?utf-8?B?ZG9DSWZXTndhS0I0UGdqNXc4KzUzT1p1YmJMbTFreHd2ZDhmV3dWQXZJdHpw?=
 =?utf-8?B?TFRINWtCMVpyd3BmNEF4RVF4UVdBenF6M3RlNHlhZWswMGRTRU5ZeVpwMi9D?=
 =?utf-8?B?bE9tUi9CMjAxZEVybWNicHFHQjVKMW5vU0VVMXZpUGQwV1NPMXM5bWRWT1c4?=
 =?utf-8?B?RDRmTTBpV3M3SW15eWltcWNoell3OWR2OEhLOWdzRWRJSlpId2J4ZUxXdkNU?=
 =?utf-8?B?ZnpiV1FzNkRINk5velBJV3FTcGFxamdiclRTVDUwUkhoVU0zZlRYeU5lOWhC?=
 =?utf-8?Q?2bAE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b845e4-22a9-44eb-9bc1-08dae2b6a170
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 18:18:44.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Srb0mCtftEvV3nCaBI/c2JKewAx6YYS1TZBWmd/7DSSp+BDGj8DI0+y0K2aVH41+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR01MB6435
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I'd suggest a runtime configuration, personally. A config option
is undesirable, because it's very difficult to deploy. A module
parameter is only slightly better. The channel selection is a
natural for a runtime per-operation decision. And for the record,
I think a round-robin selection is a bad approach. Personally
I'd just yank it.

I'm uneasy about ignoring the channel bandwidth and channel type.
Low bandwidth channels, or mixing RDMA and non-RDMA, are going to
be very problematic for bulk data. In fact, the Windows client
never mixes such alternatives, it always selects identical link
speeds and transport types. The traffic will always find a way to
block on the slowest/worst connection.

Do you feel there is some advantage to mixing traffic? If so, can
you elaborate on that?

The patch you link to doesn't seem complete. If min_in_flight is
initialized to -1, how does the server->in_flight < min_in_flight
test ever return true?

Tom.

On 12/20/2022 9:47 AM, Steve French wrote:
> maybe a module load parm would be easier to use than kernel config
> option (and give more realistic test comparison data for many)
> 
> On Tue, Dec 20, 2022 at 7:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>
>> Hi Steve,
>>
>> Below is a patch for a new channel allocation strategy that we've been
>> discussing for some time now. It uses the least loaded channel to send
>> requests as compared to the simple round robin. This will help
>> especially in cases where the server is not consuming requests at the
>> same rate across the channels.
>>
>> I've put the changes behind a config option that has a default value of true.
>> This way, we have an option to switch to the current default of round
>> robin when needed.
>>
>> Please review.
>>
>> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch
>>
>> --
>> Regards,
>> Shyam
> 
> 
> 
