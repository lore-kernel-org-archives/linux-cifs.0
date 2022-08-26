Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE41ECAAA3
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 15:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344429AbiHZPSk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 11:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344583AbiHZPSU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 11:18:20 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D1EDEA56
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 08:12:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae0R+g7JF8iZQ7B+9yC4oduAJZcc2paylkHckr0suNDi1hfhgG5JWhUNUG62n10l6Gr2YDLzNVlzEwA21noOIk4mUuwfkF8rcigHCteJeTxp+78hgQo18xo5PjOe/G8zEaXfxmdIrdV8GxA9NuoyvyvddsPy35UeF6pkzNWvPw1CzqN/kPNQnH+mz16OhUcUOS4bawLJQpS05iK9yEJasYx7XOAdGYZE0e8vVAV8QjZieQ2IJDY5fgsWzY5GXcqFzS9S1iVOG/GJjEBvQQ6qgsULZ3tt+bn1iBXrpvR9/4bvkYK9DZIimcXXUAJEdLLFgtTg0lLGqe2JE+WFo+TntQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8P4P7RdE5mX+G362JT3Wsve3r+NMA7V5Ad2DdModj3U=;
 b=cKwHR8RxVLGl2umqHTTc90rwYsv3nV2mu3K+GS8884bQcs5biZldv73dzNestYs4U1vC87yS1W9TIR/8i1wsk/RZ86oGkmuUP/sBENL5l/6NCSOol61GlVjoiMEA21K1/dOfx9QL+ltKrZEqlZfZ3Yh8tBIfdoKpGdWDgj7DkzNxj/uggCce+eeoK6HCRGw0c5B1O0ezSzLdZh8a1XtEMMuJwGZ02I5NhviKOZO64bddnnmzjdJuyCGELmji6uCXWbGqKI25xwG0fNEa+znwDZNXt/FJwLgDCQxQ9XITtBmmu+gGqPDmyBMuQ3PgBGJIyGLaQxn0zF7NQltffqcntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR0102MB3461.prod.exchangelabs.com (2603:10b6:4:a1::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Fri, 26 Aug 2022 15:11:43 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Fri, 26 Aug 2022
 15:11:43 +0000
Message-ID: <93e55661-ea4e-7205-d310-59105bc767ed@talpey.com>
Date:   Fri, 26 Aug 2022 11:11:41 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: SMB client testing wiki
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org
References: <8bcbba74-d6ce-3c40-4655-e67bf75f3b3f@talpey.com>
 <878rnb3vkw.fsf@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <878rnb3vkw.fsf@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::31) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 385a5422-e053-4925-74b8-08da8775491d
X-MS-TrafficTypeDiagnostic: DM5PR0102MB3461:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HN4q70HcBnD3j1LnuZnIMnIlPNv89O8M6BVo9RUmh5C6pO1ZOv/63W4yq4mdruiRLIiHl4IHTNxnKS//efh3vXw8a4hPvoSGIuUgHP3QoIc1SUsonhVy10vXt2j4cTO2jE1wpuh5Aiyle1PmsjqxLEK/gvKEchwVcQCr2KO97yEFNCSLanehYN4IofYmRQtDWtbU7tI9uVJvTHQSZuzj8i6dH8pW1CLVe/wLR4u79EjqSAu7vTsyYsoXBXFM28lXLF8MeJxs1HGMgNKI7gDp3h3D92/V8igjxFIC3CmmWOz//vvHFD7HShzjOzs5nock/szQrN/vtTNYbjnr6VkiQVjxqa5T9T7aiEwESRNqH9yELAz/4tBXB8vTXgYMxYn2kfAnoDcLGIffxRNy2MEgBfyiwOI47y2774S2eRPygsxqMY0zN5HD3/70n7LvySW9LrTDKJtghphCKuiNBp85Ts6XxWIWpkWR/2OuYIW2oMuh7bD8+ZbI1OlOsP5mCblwh7foC2v6rZy7R55NQ1mPiG/BU91lMdoRPL8UEskBHRUO3hniWMQBQkXBDxj16DQAXIQmA7muXLvGPdb8sWd7jb3IqyDL88FKFwMSjGyv7eU51EGv4Vgje+zcs3uEvtapALWMdJfX0KgZJn4SCvVASCfu+TarRxg9zhfAZSTJoQO2N4sIqFx2iLpxvSbazDO1lAZU4f+v/e8zsaISwfiAKWF2alagaFTBUjbwY7BxGlcxPrx4UC0SCoR0uoHlJ7A2IZMnxfa2PsGStNeHFZguxLMDkJsH0Dq+DbOxpOa0IJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(136003)(396003)(39830400003)(6506007)(316002)(26005)(2906002)(52116002)(2616005)(186003)(31696002)(6512007)(53546011)(83380400001)(3480700007)(86362001)(38350700002)(66946007)(31686004)(38100700002)(5660300002)(6486002)(8936002)(8676002)(36756003)(41300700001)(66556008)(66476007)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2RLcEZXbFdISXB5VDRnVVNIVjFTa05lempCRy9FWEhyRzRlVUxQck4wZENW?=
 =?utf-8?B?bVRFRWVpbFBOOGNlN1Zzc3dCck1RTUZqQXNMUlBCRDR5VVpVckdtZHdzSkR2?=
 =?utf-8?B?S0hTRUUzNHRnb3F6MXFZbXlINVRHZmovTFhVc29rTzVSZUwyYkpzVEdJMlRU?=
 =?utf-8?B?Qk04L0ZUbUJoOHJwRncySUFCSHdFVUNUMll5c1VWbmtaMGZ4dXgxbnU1M1lr?=
 =?utf-8?B?Q0hDSjRLV2lON0EvdTJuYnRmc3dSZFBUZGp3RnRDNVkzVTFIeVVKakxoS0dL?=
 =?utf-8?B?MGprQmprVFVIa3JrTWN2UVFtRWZaVG5paHZmZ2Vscm1kT25ieDRvZHNuSFd2?=
 =?utf-8?B?TG1tUkxjQlo0ODJiMGMwekVRbnd1ZG5Oa1dtdHN4RVhoc2d3QWZuZlliWnlS?=
 =?utf-8?B?N2lvZHZpN1g4Kzlrek91MzU1a1VBYWx1OWM3Wk11bERyaFVjRG9scUlDRHFC?=
 =?utf-8?B?VldhU040bU53cDIvY3BiRjdObStxWHBVRWhqVFhjc0NoZ0NSbGkwV2pockll?=
 =?utf-8?B?U2ZZLzlOaE9KSjJ0K0swTDNBQ0MwYng2N3VaelZidHVjcGxqQWtMY1ptdUJL?=
 =?utf-8?B?TWM4NlZGc0pqcUcxTnM0QjVVZGZSZXkrODkycE5tNTBOeEdLSnpoL0ZrLzZB?=
 =?utf-8?B?WndRZWlyWGlMV2JubWo1Q1dONXpzZUhOWFA1N3BvVVgyOGR4ZDJhYThvaEZJ?=
 =?utf-8?B?OE8waHhtNDFyZ2lZS1ZSRDZvL2xmcjNqckFKcmY5QWFQUUpBd0ZYRTRicVRl?=
 =?utf-8?B?ZTQvNFlYZTVBTDc5K1JIY3hyQzBWS0hLYUljbDducExWSDI3dEpJU1oramJR?=
 =?utf-8?B?MHJTazgwL09MWGgvZDg2UzNmWlhwVklxdngzbE91N3pmYWpTTVA3aFBrTEQv?=
 =?utf-8?B?bzlrVnZNcnFvSXBaaG82RjU4YnpXdFQrTXJoRzBVSzQ3cTNnZ3dSWG9YejZu?=
 =?utf-8?B?bktZUGEveSsvelZtNXlPRTk4cVZrb3NGZjhiL0k0Qjd6Q05uQkxOZFRraWhJ?=
 =?utf-8?B?RkJYWVhPaU4wb1JLb0dZTjgrSUJQTGVLYU5CTUYrQTBldm9CUUpFV3dIOFhZ?=
 =?utf-8?B?OGR2YnlYbDJBdkNnNExQdWJ3ZWc5TG5RZVdCRVluOWg2bFRjYnVHd2lBcjIr?=
 =?utf-8?B?bUt4c3N3MHJPTkJqTXIxVHJQc2syVWc0Uy9FS3UxeEdLTkhQR2hUU1pDUUlG?=
 =?utf-8?B?TzFEWGdvOGE3SjU0a3p3REZkUzdkc0UxUURkY1lXWEE1UXZJRnZpNTdObDRR?=
 =?utf-8?B?bW9INUxucjIxNHJhUGlMSzZvdmZhdXg3RStXVHpaUVh4eWFKM01WN0kxRjVW?=
 =?utf-8?B?cHZ0QlVQSUlIYUgzT09MZCtrRzQyTDF1R2M4MFhYQkRDVWwva3loRUdZbjZP?=
 =?utf-8?B?VFY1b1pITElkaWpjd0c3N1FNSjZieURyRXpGNEZKSmFZY0hBakFzTGZHd1h1?=
 =?utf-8?B?aEZmMXBVeVJlaGtucnIyNnRiU3k2NFV2ZVNBT0prazQ4enJSbkZwcGpDZWRI?=
 =?utf-8?B?RXRUVGlqVXQ3L0d5bTdENld5S0s2V3VWeHZLOEI2L1ZubDVqUzExS0ZRT25n?=
 =?utf-8?B?TlIrNlhWbnMwdnIxUS9TSzdDTTR3Z2Z0YWY5TmhUUlc2RDBLb0tNK0l5K0JR?=
 =?utf-8?B?cWsyRW5iR3NlTDZwb0NFVzNxZVVpMk9MUDdOaElKcUliclp4NW9tRXRqQnJ2?=
 =?utf-8?B?bkJKcTZKLzFreGZEM1JmdS9SUmFLWVpMNHdmUkM1WFhJM0VzeUVLOVFPWThC?=
 =?utf-8?B?M3hwK1oxSzFKN0FVSFB3dk56ZFdjQmlLZW9WcFA0eDdoUDlVdEExWnd4dmdN?=
 =?utf-8?B?MUJBTmhBZmk5U3B2MEM0dlc3Z2RCb2hRNTk2RGpKeTBxTHpYczNqR1FkNmdl?=
 =?utf-8?B?RTRXcnRMbmJONmdYSUZaSXhBK3MyYWcwTlpEWWdxdUVxeW5QT3FibjZuQ21x?=
 =?utf-8?B?b1lhWEljUHdhbkZXUmNUOTF4c3RVeFBjME9ydUFnTk1tZjF0WEFEWk9GZ3Bp?=
 =?utf-8?B?Zk9CZ0RGTjdMQXZmNmZFNVdxNHovalB4TmFrbW9TVm9PQ2UrSzhSWHVic1Qv?=
 =?utf-8?B?MzVDamx6RlZqaGdUbG1hNTJDMjc4YTBta3l6SWZlUWZ6RDk2Zys0REQxTGVk?=
 =?utf-8?Q?mVbk=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 385a5422-e053-4925-74b8-08da8775491d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 15:11:43.5187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCPH3RT3Ohy4hrnudMlvdTUS1je9ulmkx6WdAoclUd8iiQ4IOXFLJiitCmkA7NHM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0102MB3461
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/26/2022 10:53 AM, Paulo Alcantara wrote:
> Tom Talpey <tom@talpey.com> writes:
> 
>> Is there an updated list of tests expected to pass, and/or
>> any update for the scripting? Anything else I need to run in
>> a basic local environment, to test smb3.ko client to ksmbd.ko
>> and Samba servers on a pair of test machines?
> 
> For the testing environment, I'd say there is nothing special.  Just
> create two shares in both samba and ksmbd servers and specify them in
> local.config when running xfstests.  We usually name them as 'test' and
> 'scratch', respectively.
> 
> For testing SMB3 over samba, you would have something like this in your
> local.config:
> 
>    [smb3samba]
>    FSTYP=cifs
>    TEST_DEV=//tom.samba/test
>    TEST_DIR=/mnt/test
>    TEST_FS_MOUNT_OPTS='-ousername=tom,password=***,noperm,vers=3.0,mfsymlinks'
>    export MOUNT_OPTIONS='-ousername=tom,password=***,noperm,vers=3.0,mfsymlinks'
>    export SCRATCH_DEV=//tom.samba/scratch
>    export SCRATCH_MNT=/mnt/scratch
> 
> and then run xfstests
> 
>    ./check -s smb3samba ...

Easy enough! How do I know if it "passes" though? My understanding
is that a bunch of tests are expected to fail, or at least warn.
Do I need to test a clean client, then compare results? Or am I
misunderstanding, and FSTYP=cifs is taking care of it?

I'll probably be specifying vers=3.1.1 :)

Are MFS symlinks required to run the tests? That's a surprise.

Tom.
