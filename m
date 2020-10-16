Return-Path: <SRS0=R2WM=DX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1245CC433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 14:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6152207DE
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Oct 2020 14:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407428AbgJPO1u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Oct 2020 10:27:50 -0400
Received: from p3plsmtpa06-01.prod.phx3.secureserver.net ([173.201.192.102]:48678
        "EHLO p3plsmtpa06-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407408AbgJPO1u (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 16 Oct 2020 10:27:50 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id TQhwkPvAWXReoTQhwkYFrS; Fri, 16 Oct 2020 07:27:49 -0700
X-CMAE-Analysis: v=2.3 cv=DKHxHBFb c=1 sm=1 tr=0
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=hGzw-44bAAAA:8 a=pGLkceISAAAA:8 a=SEc3moZ4AAAA:8
 a=iox4zFpeAAAA:8 a=yMhMjlubAAAA:8 a=hNOTfydlAAAA:8 a=ySJjVz2esI22uv7vTAIA:9
 a=QEXdDO2ut3YA:10 a=HvKuF1_PTVFglORKqfwH:22 a=5oRCH6oROnRZc2VpWJZ3:22
 a=WzC6qhA0u3u7Ye7llzcV:22 a=fZunMKNLB757I4m4HZ3M:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH][SMB3.1.1] Add defines for new signing context
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>
References: <CAH2r5mtwBHTk-Xoeuo+RbgNwiNw-cWTAhdy1YG5y+vXnNDSv4w@mail.gmail.com>
 <bd8f21ed-5fd4-0974-f15a-16d2f3ee607f@samba.org> <87r1q3hixr.fsf@suse.com>
 <827fd43f-40a9-9480-a6b9-aea1fa69090c@talpey.com>
 <CAH2r5mt3t=FHVd8RtCyrzY6TUKb+rGENENXbKJBgUdq4T4Qe6Q@mail.gmail.com>
 <CAH2r5mu72VSPFhiLjL3YUtStXc1=B5SBP86+A5vEWFhLFyOJBw@mail.gmail.com>
 <CAN05THRAZnea1NUW7-h5jHsQ+yUpvxO-5KHGaFgKB87JxmWBqg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <55b0a562-b6cc-b6d4-65c7-b642ce08cc4b@talpey.com>
Date:   Fri, 16 Oct 2020 10:27:49 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAN05THRAZnea1NUW7-h5jHsQ+yUpvxO-5KHGaFgKB87JxmWBqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfIxjPAgA97wmOXrhr3HAbnhORhugIuEaA16Agw7hcROM4DjCbRAho1qq2TuemZBcabvIgUEW8dngv6lItCFwLTQstQB0nAwkOeR4UqMQ8MrdsH9SbDVt
 7lyt0bci0F25I91F1VlLPZC6OPYv0rhPhErkoX8+DUk6+R14zJ0pzrm+FePKw/CSshUie/qv9NtBjymjb6cvIjWWyM2cAaYE3rK7XqkXZzB40cdAX9t4k79d
 v7n3Kilb2A6YZxgBl66lupHN2BuIhm/vTKlmg9bAA1VfBMeHQyh1IOm+sCNaitcM1FpR6V1kzl+x+adAkm2AO8wQ1MWCusJiMWxI/XuX+p4=
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Indeed yes, my point is that until/unless Microsoft indicates
the new signing context is committed to the protocol, it's
premature to bake it into Linux, or anywhere else. Speaking
from experience, things have been changed or removed at some
very late dates, in fact.

While I have the floor, and just a personal opinion, I feel
there is a huge and confusing proliferation of module options
and mount flags creeping into cifs.ko over time here. Is this
really a good idea?

Tom.

On 10/16/2020 2:11 AM, ronnie sahlberg wrote:
> Looks good, but I think Tom's point is we should not put this in
> upstream until the feature is officially launched.
> In  wireshark, we can add these things immediately since any capture
> files with these parameters will continue to exist forever.
> See wireshark still supports pre-RFS versions of iSCSI.
> But for cifs.ko we might want to wait sending to Linus until it is
> officially released in a consumer version of windows.
> 
> Lets just look at SMB2.PDF and all the bitfields/flags that specify a
> feature with description and then the comment that it is not used,
> clients should set it to 0 and servers must ignore the flag. Things
> can change until official release.
> 
> 
> 
> On Fri, Oct 16, 2020 at 3:50 PM Steve French via samba-technical
> <samba-technical@lists.samba.org> wrote:
>>
>> Here is a patch to add a module load parm that is turned off by
>> default to allow users to enable it for experimentation
>>
>> # ls /sys/module/cifs/parameters/
>> CIFSMaxBufSize    cifs_min_small           enable_oplocks
>> cifs_max_pending  disable_legacy_dialects  enable_signing_negcontext
>> cifs_min_rcv      enable_gcm_256           require_gcm_256
>>
>> # cat /sys/module/cifs/parameters/enable_signing_negcontext
>> N
>>
>> On Thu, Oct 15, 2020 at 11:50 PM Steve French <smfrench@gmail.com> wrote:
>>>
>>>> suggest wrapping this context and the integrity algs in some kind of conditional
>>>
>>> I have a couple patches to send the context (which I haven't merged
>>> yet, because, similar to what you suggested, I wanted to make sure
>>> they were disabled by default).
>>>
>>> Tentative plan was to have them disabled by default, and sending the
>>> new context can be enabled for testing by a module parameter (e.g.
>>> "echo 1 >  /sys/modules/cifs/parameters/enable_signing_context"  or
>>> some similar config variable name)
>>>
>>> On Thu, Oct 15, 2020 at 1:15 PM Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>> On 10/12/2020 5:50 AM, Aurélien Aptel wrote:
>>>>> Patch LGTM
>>>>>
>>>>> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>>>>>
>>>>> Stefan Metzmacher via samba-technical <samba-technical@lists.samba.org>
>>>>>> This isn't in MS-SMB2 yet.
>>>>>>
>>>>>> Is this AES_128?
>>>>>
>>>>> This is returned in latest Windows Server Insider builds but it's not
>>>>> documented yet.
>>>>>
>>>>> https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewserver
>>>>>
>>>>> I've asked dochelp about it during the SDC plugfest and they gave me
>>>>> this:
>>>>>
>>>>>       The new ContextType is:
>>>>>       SMB2_SIGNING_CAPABILITIES 0x0008
>>>>>       The Data field contains a list of signing algorithms.
>>>>>       •    It adds a new negotiate context, which enables SMB to decouple signing algorithms from dialects. E.g. if both client and server supports it, a session may use HMAC-SHA256 with SMB 3.1.1.
>>>>>       •    It adds the AES-GMAC algorithm.
>>>>>
>>>>>       SigningAlgorithmCount (2 bytes): Count of signing algorithms
>>>>>       SigningAlgorithms (variable): An array of SigningAlgorithmCount 16-bit integer IDs specifying the supported signing algorithms.
>>>>>
>>>>>       The following IDs are assigned:
>>>>>       0 = HMAC-SHA256
>>>>>       1 = AES-CMAC
>>>>>       2 = AES-GMAC
>>>>>
>>>>>
>>>>> I've been CCed in a Microsoft email thread later on and it seems to be
>>>>> unclear why this was missed/wasn't documented. Maybe this is subject to
>>>>> change so take with a grain of salt.
>>>>
>>>> Just curious if you've heard back on this. Insider builds will sometimes
>>>> support things that don't make it to the release. Even Preview docs can
>>>> change. However, AES_GMAC has been on the radar since 2015 (*) so
>>>> perhaps the time has come!
>>>>
>>>> I'd suggest wrapping this context and the integrity algs in some kind of
>>>> conditional, in case this is delayed...
>>>>
>>>> Tom.
>>>>
>>>> (*) slide 29+
>>>> https://www.snia.org/sites/default/files/SDC15_presentations/smb/GregKramer_%20SMB_3-1-1_rev.pdf
>>>
>>>
>>>
>>> --
>>> Thanks,
>>>
>>> Steve
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
