Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B130C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 18:22:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA30120760
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 18:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgJOSWv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 14:22:51 -0400
Received: from p3plsmtpa07-05.prod.phx3.secureserver.net ([173.201.192.234]:54762
        "EHLO p3plsmtpa07-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727197AbgJOSWv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 15 Oct 2020 14:22:51 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2020 14:22:51 EDT
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id T7mlk50kils90T7mmkWp2O; Thu, 15 Oct 2020 11:15:32 -0700
X-CMAE-Analysis: v=2.3 cv=QfEYQfTv c=1 sm=1 tr=0
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=iox4zFpeAAAA:8 a=hGzw-44bAAAA:8 a=yMhMjlubAAAA:8
 a=hNOTfydlAAAA:8 a=NA896NxhSAy2TpZPZw8A:9 a=QEXdDO2ut3YA:10
 a=WzC6qhA0u3u7Ye7llzcV:22 a=HvKuF1_PTVFglORKqfwH:22 a=fZunMKNLB757I4m4HZ3M:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3.1.1] Add defines for new signing context
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
References: <CAH2r5mtwBHTk-Xoeuo+RbgNwiNw-cWTAhdy1YG5y+vXnNDSv4w@mail.gmail.com>
 <bd8f21ed-5fd4-0974-f15a-16d2f3ee607f@samba.org> <87r1q3hixr.fsf@suse.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <827fd43f-40a9-9480-a6b9-aea1fa69090c@talpey.com>
Date:   Thu, 15 Oct 2020 14:15:32 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87r1q3hixr.fsf@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLmTpx9naniZReK859+SV7OpWXmKk90o0qW9Iu8lGA2lvvOTOIOQ+XwLwLRalM3IYh9oay3wogCYDv5OOZy7qcJSI7rd0lc//8EQNhRk5/gPvbJt6H7Y
 iz0P9B3TRA6Yu6gIG/x17OL/9X4WaRVbzV2iOBjOWX3nKu7S9Im0sMEsn07BguCFXjUtwRU/1U03J4aWFxozvYCm9OG7/uyq738uDthRjCXIPrqd8cLCoa8o
 kkusUjwzblO6ohdqFaOGc7ehIh30uFz/JZIbk0OB3NM+54siHMlRvoW/dbe4BkXn
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/12/2020 5:50 AM, Aurélien Aptel wrote:
> Patch LGTM
> 
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> 
> Stefan Metzmacher via samba-technical <samba-technical@lists.samba.org>
>> This isn't in MS-SMB2 yet.
>>
>> Is this AES_128?
> 
> This is returned in latest Windows Server Insider builds but it's not
> documented yet.
> 
> https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewserver
> 
> I've asked dochelp about it during the SDC plugfest and they gave me
> this:
> 
>      The new ContextType is:
>      SMB2_SIGNING_CAPABILITIES 0x0008
>      The Data field contains a list of signing algorithms.
>      •    It adds a new negotiate context, which enables SMB to decouple signing algorithms from dialects. E.g. if both client and server supports it, a session may use HMAC-SHA256 with SMB 3.1.1.
>      •    It adds the AES-GMAC algorithm.
>       
>      SigningAlgorithmCount (2 bytes): Count of signing algorithms
>      SigningAlgorithms (variable): An array of SigningAlgorithmCount 16-bit integer IDs specifying the supported signing algorithms.
>       
>      The following IDs are assigned:
>      0 = HMAC-SHA256
>      1 = AES-CMAC
>      2 = AES-GMAC
> 
> 
> I've been CCed in a Microsoft email thread later on and it seems to be
> unclear why this was missed/wasn't documented. Maybe this is subject to
> change so take with a grain of salt.

Just curious if you've heard back on this. Insider builds will sometimes
support things that don't make it to the release. Even Preview docs can
change. However, AES_GMAC has been on the radar since 2015 (*) so
perhaps the time has come!

I'd suggest wrapping this context and the integrity algs in some kind of
conditional, in case this is delayed...

Tom.

(*) slide 29+ 
https://www.snia.org/sites/default/files/SDC15_presentations/smb/GregKramer_%20SMB_3-1-1_rev.pdf
