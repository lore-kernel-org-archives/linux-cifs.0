Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03DAC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 14:30:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiJCOa2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 10:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiJCOa1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 10:30:27 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8A11DF2F
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 07:30:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWJ7yFBoSCg8zvZmeb5FpOSmosqBoA9XssDP2TS283GwfOla5cskugYHxJcA//7HMixyWp3HbSHCJ0h3sJyYmKsQoHZmBJJhExxKAncCYx34N0v8cjuc+eCeyPnRsgLto3IjyGLJqoX9ljxTXT4cMhuwxR35FvLSt9Z1yKtlO5hKFFJRcUudzTHn9RkJEFIJIUgMCFUG9Yl4O4SBWaIPxAWB5MgU0CeR2qwROzNe4V+5nL/LnNWlMLZQyejgeGo60QXF75NfdDOXHLjHBXCRLqQAeR4lhuqQi/57QF3CRk6f+YksPcLQ85HPATiMeiIQayf9JWULN+WVVVK1TKdB8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZvIMn3cG6dj82f7guRFIzg941ktECS11EU3LglpzhbM=;
 b=Jb0v3nNrUJl/rD+b7FIqoRRNOcZFlSUXItkUY/u39x+SomjEeYRledD85CH3dMknzw1Cw2NrMYMi3SY6D8jNG1w0ecV2aq3mmoVULq0M1SlhE9790zp0PFnsxCcb7x+ge/oZ1L6Vu9PsjwIUs34vpyqzlvnu5O5dM/fxF5ZRmXoojCbPwU30AX9PP82cfppKRuBPbCcdqppTG+LuGGLEgSYBrUvMUzy0VizFj4F9ZeToRZKPQsre1Sj4Epi7fjaCPnnsKGuRYS/h6cK3feXVlcJ2eUJZBMQ42EHL0wHm4gcOgILPbZAMZUlGhqziYHE3mUIdYRGrkpQXW+9RbcF9xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB5123.prod.exchangelabs.com (2603:10b6:208:67::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Mon, 3 Oct 2022 14:30:25 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 14:30:25 +0000
Message-ID: <82a311a7-fa1b-5dbe-abdb-b8af2a6efdeb@talpey.com>
Date:   Mon, 3 Oct 2022 10:30:22 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v5] ksmbd: validate share name from share config response
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        =?UTF-8?Q?Atte_Heikkil=c3=a4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
References: <20221002230934.367900-1-atteh.mailbox@gmail.com>
 <CAKYAXd_DCSsO2iuMOd=VHdv1qhxPwj_-7BtyLi4C-ntMUR+WpQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_DCSsO2iuMOd=VHdv1qhxPwj_-7BtyLi4C-ntMUR+WpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0026.namprd16.prod.outlook.com
 (2603:10b6:208:134::39) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BL0PR01MB5123:EE_
X-MS-Office365-Filtering-Correlation-Id: b28a0050-2973-4fc8-c76c-08daa54bcf7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RLsQZz48ARtUeLgBNR7sWI7SrsWsVC1yKtE67TdqFpFKVH9QEv9FTYQd1mT0xstzoGqkjxXHEh1TstbEzcbl06ewZKLv328Qhglce8ra4xIFjRDy0FQ8XKnKD9/NeC0HxIreiswKTsxxyqzN42LwlRVVFQ8jhfiFbF1Cwyz6uTFEcvlU6znVBsYDBtFBqWDtLVPBRipOASOkmHNMZ08HNvN7zLKx3aL0F4Oz/jzMQrTf4cS7b5uSNHaJDd6C52B1Rh3NZmpNbLnOrVaVKgYmNaB+/blpK79XqBO5uVqojGWebi+c0CW/7bSED7Qn2GZpgdkThRfSAFwDs6rLin8PVQ2bSBXbOO3gE1h66vjeKXmGn630KH7aBK/CD+ncHV3LfzGp/4UQMKyPehAERor455LvIfd8LMZe8eNcTlZemK8XOK9R3F2k2rA/AOOEtMESXrCN3jZ9w2d8vkIGkdGhe/KiyT/ncr+i6lfXOXvy7jpvEarGkXZcNuIND2kPudbIVyFbPLO9tfGczMe1v3B+7+0vwDBxO4ISVhjqoP96S/IsQl+QyRHvhMzqcb/oJsR0lEWKtZPnxELqK6YRBnFxAum8+W8iGt6sUzrR0pxkfNIyGfcEUqDBA6aYqLhUtF1rRXLl2TSLjFwyj06QSRmMQiUPaliY5ecMjzcpaLXWthWeMGxjP3iUzQ26V9Zj7BaCEgvSwL6zw+jWK1q90qCK+zQX708RT+5cSVdtzl+Eu68k2Dc48/kGkGqu4CHowVe7ggl4H+2Xw2ZoaTesn8y8Shg1kEW/jWNijiIUS2JLfRA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(346002)(39830400003)(376002)(451199015)(52116002)(6506007)(6666004)(31686004)(38350700002)(66556008)(66476007)(66946007)(38100700002)(8676002)(4326008)(86362001)(31696002)(36756003)(2616005)(53546011)(478600001)(6512007)(26005)(6486002)(15650500001)(186003)(2906002)(316002)(110136005)(5660300002)(83380400001)(8936002)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFd2UURoNGJZRG4yYjY5cCtYN1p1ODFXM0VLbkk0cmxYOHZlVHRXQkJucXl1?=
 =?utf-8?B?MWdXRTZ2Y1o3N0toZ3JsbDQ0dVJFTC81R1dJWCsvcHVPaDJMNE1Dem5mS0JU?=
 =?utf-8?B?bWtZV1dWalV0ZHhFNXFWT2syYmxVWE56REwyL3NFbUdXUVpjUlkvVHU0NklX?=
 =?utf-8?B?OElTeXZXTUhha0F6TGpBWENsYTYwVkNmU0JKNjFQTEliSFBCMlNtWXA0L0xu?=
 =?utf-8?B?Z3ZPUFM5YXBsODI2bEQyWWNHRFljUkZRTVAyNkRoKzJrd1hFTHl5ZWNST2tD?=
 =?utf-8?B?eFVkV21LUHNZT0w5Y1Mrd01HaytUUnJrTThoeDRsRXBHRlNMaUhGSkJ5OVkv?=
 =?utf-8?B?MHpPYXpnQ3Z5ajBUMG1BVGljbnZHMmVPN09Hb3FWYVlxaUNKaHM5MWdIazIr?=
 =?utf-8?B?K2tSbGFxVzVxVXUrbGJNdzVXcnVaUE5xU0Q3OHdlZHV0K2VKemJ6MWZZdVpu?=
 =?utf-8?B?S3RnZWgxemlsZFBicmhyVXRTOWs5NVZrUDBzZ3FlT1VRRUpuRTQ3aFo5NFZj?=
 =?utf-8?B?TkQ5T0dTbkRnWTJuTjJRc2tiQnlCdXc4bjBKaXkwcmJ6aHR1RUQyNUlGYVZZ?=
 =?utf-8?B?SGxRM08xK0U4THNxdWlzRkkwVUhuMGxHOWJFSjFpdU0xNGxMcllwczN0N1I0?=
 =?utf-8?B?T055SXIrUDFxaExzSEZOdk02ZWFhWGUvUlFWQWp6eHJwVjFndkFZVmpxaHQ1?=
 =?utf-8?B?NzJQblpkQmdWeW9uL25RVER1N3hEREZHRXd1VTQyZHdkSkVWOU1hT0lINW5H?=
 =?utf-8?B?R3g5MEJuc2dTK1Q4eHRJRFFva1gyL0NrMmVtY3dDUGh6WWtnWFIzV2dQNVdz?=
 =?utf-8?B?dGQzZVR6bnN6WXBZRHRQQmNwWE9ITVRQQzJhNW1HaURtdEFUTzFaQjRXYVFF?=
 =?utf-8?B?SHRWVGFYYjdTZndJbXZRUEdIY2VTQlhEWmJpRWVvWiswNkN2a3R4bjZVNXU5?=
 =?utf-8?B?ZENJWnQvbityalcyWXgrT2lST3paWVZ5M3NTcDhyKytRY3JOQWhYUXQ3U0pt?=
 =?utf-8?B?c1dpUFQvU0l2cjM5Mzh6NzhwdmdLMTVuNXFySllQQjhqRjJMN2Y0UjlrUGdy?=
 =?utf-8?B?ZmRNT2FEUmlRdXRQRVR1Q2R2S0VLTmlCV2xNUXdGZ2ExZXVpM1U0NW1uOXNG?=
 =?utf-8?B?TW0xb2huTkhXUUZVSGlpbm94cExIV1cxbmIxRlJ5aHZ4dlRGRVA1aXRVRHYw?=
 =?utf-8?B?SklRTDBDa1JpdG1ub0IwMmtiV2hoOXpjOThybGtPdENOYTlBN2dWdEZxb2ll?=
 =?utf-8?B?M2tudmVkR0hzQzV4a001NjB2alo0UDB4Wi9pdXJIazV5VUVDMVJiSG1hR2xv?=
 =?utf-8?B?TG1JMDJSMHgvWUFRSFQ5ZTZaQWFKdzNwZUI4T202ZFRXLzgvUEp4UUYrZEJ3?=
 =?utf-8?B?Y0FJQWpZQitrbjFMV29xdzVFSWhaNUdhMWcvYi9jdDFXcGNaOGhFTnJtbFhH?=
 =?utf-8?B?dHpVOGU4dFJPTmMwYWdSaFh3ZVhpMlNEOUxOajhnL2gwTUN1VHZ2cmpGeW5G?=
 =?utf-8?B?WDdkcFEycFVOMHpHUmNnNiswK0FzRDdYRzlCSUpnbmFpQlFpMjArVXIvZzFs?=
 =?utf-8?B?MWdabFdUcVJ3cWlFZ25lbzc0RW1RS0c3cFNycWVaeWltYkpFWWFYWjRqTXcw?=
 =?utf-8?B?d3BIbXlrQ25mZGlycjY1SUNBZms4S1FydG16L211SXFuMnhsd3ZaaXdzQnAv?=
 =?utf-8?B?SGNnNFFITU8zZWZhMWZDamg0T2J0NGpVNlBLNGsrdUI2TStzcjlWNzNkc0w2?=
 =?utf-8?B?TDlZVUVYdEQwSHFoUmdxWENTbnZTRnpVWUY2ekFLa1FxNUhkWUVRbkxZOWtv?=
 =?utf-8?B?RHFOYko4NGRoRVdBUThJd3F5YjVwZ0ZiNTYxdjFWTVRWWXExV1ExTHpvQ3dT?=
 =?utf-8?B?MzM2c2dRQ2tqL2lJY0lUNEl3dXhkaG9TeHkveFgxKzljeTVoa1pra2hiQXZ3?=
 =?utf-8?B?N3FiUW9NUVJYVjBGQUVleFRpemo3TGkyY1psSVdnaEh4VytobUxPNzBFcUlz?=
 =?utf-8?B?UkZmNUVudTZCZmxZSzJDMkF2Uzg2MU5KQ2UzalgyUGFmZTIyWExBRlN6UkdI?=
 =?utf-8?B?TTgyL0FqSG9uTFJVdmtjZXJFcnRPWmFYWE1WV2NCN21rVUd5dWR1dWwvblFu?=
 =?utf-8?Q?zEBc=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28a0050-2973-4fc8-c76c-08daa54bcf7f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 14:30:24.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n2OFUdn7yRWM+iyOnP16czdRbOVs8yKWIf+NSBywxW1iPNfO8YF5lw5NfwwoosIy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB5123
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/2/2022 10:46 PM, Namjae Jeon wrote:
> 2022-10-03 8:09 GMT+09:00, Atte Heikkilä <atteh.mailbox@gmail.com>:
>> Share config response may contain the share name without casefolding as
>> it is known to the user space daemon. When it is present, casefold and
>> compare it to the share name the share config request was made with. If
>> they differ, we have a share config which is incompatible with the way
>> share config caching is done. This is the case when CONFIG_UNICODE is
>> not set, the share name contains non-ASCII characters, and those non-
>> ASCII characters do not match those in the share name known to user
>> space. In other words, when CONFIG_UNICODE is not set, UTF-8 share
>> names now work but are only case-insensitive in the ASCII range.
>>
>> Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
> I agreed that Tom's review comments should be changed
> ksmbd/ksmbd-tools together.
> I will make another clean-up patches included Tom's comments.
> 
> For this patch,
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> 
> Thanks for your work!
> 


LGTM too, thanks!

Acked-by: Tom Talpey <tom@talpey.com>
