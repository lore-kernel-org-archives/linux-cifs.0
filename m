From: "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org>
Subject: Re: A suggestion for error value, and question regarding EINTR for
 user-space system calls.
Date: Fri, 08 Nov 2013 02:11:37 +0900
Message-ID: <527BC9C9.5080502@yk.rim.or.jp>
References: <527BAFC6.5010600@yk.rim.or.jp> <20131107110353.6d203196@tlielax.poochiereds.net> <CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtuM6e7BpHk06sM9rzOxfcRgdkmw0vuQhJfYsrJkfrEdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear Jeff and Steve,

Thank you for your attention.

So maybe someone can produce a one line fix for changing ENOMEM to 
EREMOTEIO when the server complained about the particular ? (yes I 
prefer EREMOTEIO over EIO because, in this case, remote server is 
complaining.).

I have not downloaded the latest linux kernel source on my computer yet.

I will follow up on my EINTR issue in detail in a separate posting 
tomorrow.
It is a long and winding story.
Basically, I am trying to see whether I should re-try 
read()/write()/close() in the case of CIFS-share error.
If, during transient network error, read/write/close may return EINTR,
I can code a routine to retry these based on errno==EINTR.
(Oh wait, doe stat, stat64, etc. may also return EINTR? I will follow-up 
why I am investing this, and the recent hung problem of CIFS during 
testing. My using Win7 as CIFS-share server is not very good, I know.)

TIA


(2013/11/08 1:12), Steve French wrote:
> Your argument for mapping ENOMEM (returned from the server) to an
> error which indicates server problems (EIO? or better EREMOTEIO?)
> seems reasonable.
>
> On Thu, Nov 7, 2013 at 10:03 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On Fri, 08 Nov 2013 00:20:38 +0900
>> "ISHIKAWA,chiaki" <ishikawa-FORCTJUUkgPbmG5+kqVDhQ@public.gmane.org> wrote:
>>
>>> I am a newcomer to linux-cifs.
>>>
>>> Thank you for offering the great software package, which has improved
>>> greatly over the last few years.
>>>
>>> I have a suggestion and a question.
>>>
>>> 1. Suggestion: Change the return value ENOMEM -> EREMOTEIO for an error
>>> scenario.
>>>
>>> There was a discussion to changeerror code returned to user-level system
>>> calls when the remote server providing CIFS-share
>>> failing due to the allocation failure of non-paged resources, especially
>>> Windows 7:
>>>
>>> Currently the returned errno value is ENOMEM.
>>>
>>> See the discussion here, for example;
>>> http://thread.gmane.org/gmane.linux.kernel.cifs/4281
>>>
>>> especially the following one:
>>> http://article.gmane.org/gmane.linux.kernel.cifs/4303
>>>
>>> The suggestion there was to change this value to EREMOTEIO.
>>>
>>> I wonder what came out of the discussion.
>>> CIFS client in linux kernel still seems to return ENOMEM instead of
>>> EREMOTEIO.
>>>
>>> I will go for EREMOTEIO change any time.
>>>
>>> ENOMEM suggests to me that there is a LOCAL resource shortage,
>>> and it is difficult to gauge that system is telling us that there is
>>> something missing in the remote end.
>>>
>>> EREMOTEIO is much better in this regard, I think.
>>>
>>> I wasted looking at local log files and dmesg output before
>>> I got wiser and checked the remote Windows 7 system log when I saw
>>> "Cannot allocate memory." message.
>>>
>>> By the way, EREMOTEIO is not defined in POSIX.
>>> Under linux it is defined as
>>> #define       EREMOTEIO       121     /* Remote I/O error */
>>>
>>> (at least in my copy of
>>> Linux vm-debian-amd64 3.10-3-amd64 #1 SMP Debian 3.10.11-1 (2013-09-10)
>>> x86_64 GNU/Linux )
>>>
>>> Since linux-cifs is for linux obviously, I think it is OK to return
>>> EREMOTEIO without bothering the conformance to POSIX here.
>>>
>>> Decreasing the chance of user confusion when they see the message of
>>> "Cannot allocate memory" printed as the error message when mount fails
>>> due to ENOMEM being returned for this error
>>> on the remote side of the connection is more important IMHO.
>>>
>>
>> Agreed. It's terribly confusing. Steve (the maintainer) seemed to be
>> skeptical about the change, so I never actually proposed a patch. Feel
>> free to do so, or I may do it when I get some time.
>>
>>> 2. Question:  Can read()/write()/close() against CIFS-share return EINTR
>>> in errno?
>>>
>>> This may involve a few assumptions regarding the
>>>   - mount parameter: soft (default) vs hard
>>>   - program's signal setting
>>>
>>> Assuming that mount parameter is soft (default),
>>> can read/write/close end up returning EINTR in errno?
>>>
>>> I have seen EHOSTDOWN stored in errno by failing read() when I simulated
>>> network error by disabling network card of a VM in which a copy of
>>> linux runs and when it was mounting a host Windows7 CIFS-share.
>>> (close() returned -1, too. But I forgot to record the errno value then.)
>>>
>>> My question is whether linux CIFS client can return EINTR  in errno by
>>> interrupted read/write/close, and if so, I think I should retry
>>> these system calls up to a certain amount of time (so that the failure
>>> will not block the program forever...)
>>> Currently, there is no clear documentation about the error code returned
>>> to the user-level system calls, and so I am asking the mailing list.
>>>
>>>
>>
>> It's not clear to me what you're asking here. EINTR implies that the
>> process was signaled.
>>
>> Processes stuck in cifs code should generally respond well to SIGKILL
>> since we do put them to sleep in such a way that they respond to that
>> signal. Handling other signals in data-integrity codepaths is quite
>> tricky.
>>
>>>
>>> Thank you, whoever those would be, again for the improved CIFS
>>> package. After I gave up on using CIFS under linux due to its very
>>> slow speed against office server, I was quite pleasantly surprised
>>> with the transfer speed this week when I tried it for the first time
>>> in a few years. (If only my windows7 server didn't hiccup due to the
>>> well known issue.)
>>>
>>
>> Glad it's working well for you.
>>
>> --
>> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
