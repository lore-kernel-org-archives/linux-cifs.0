From: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Sat, 2 Sep 2017 16:25:59 +0200
Message-ID: <e3c10df4-6681-b671-96eb-395264360385@leemhuis.info>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info>
 <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
 <CAH2r5msWDXzwbFPtUHCKbqHrEBTsvw5eaTayj5RkdgYCLM5nAQ@mail.gmail.com>
 <CAH2r5mv9roEvMX+C-csU=GZFM_HMbqxnHfF11NUp+2yonDVPgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv9roEvMX+C-csU=GZFM_HMbqxnHfF11NUp+2yonDVPgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-GB
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi! Just a quick feedback from my side.

After reading Andrew explanation in this thread about the "movement
against SMB1" I kind of think "maybe the proposed revert for 4.13 and
doing it properly in 4.14 would really have been a good fit". But
whatever, doesn't bother me much any more:

Steve French wrote on 01.09.2017 04:42:
> Any thoughts on this patch to add additional warnings for the user -
> logging when using default dialects (or when server returns dialect
> not supported), and noting the default dialect change?
> See https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=bb86f22eeddbb5879675b55168b8fa8990d74a21

I noticed Linus committed a sightly updated variant earlier today
(https://git.kernel.org/torvalds/c/7e682f766f28 ). I just gave it a
quick try and it worked well. I can still mount smb3 shares. For
cifs/smb1 shares mount.cifs obviously still fails with the confusing
error message. But at least one gets a better explanation in dmesg now.

Many thx for this! Ciao, Thorsten.

P.S.: For the curious reader (and search engines!), this is the
confusing mount message you'll get when trying to access a CIFS/SMB1
only share with Linux master currently:

mount error(112): Host is down
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)"

And this is the warning you see in dmesg now when not specifying
"vers=1.0" as option (-o) to mount/mount.cifs:

No dialect specified on mount. Default has changed to a
more secure dialect, SMB3 (vers=3.0), from CIFS (SMB1). To use the less
secure SMB1 dialect to access old servers which do not support SMB3
specify vers=1.0 on mount. For somewhat newer servers such as Windows 7
try vers=2.1.
CIFS VFS: cifs_mount failed w/return code = -112


> On Thu, Aug 31, 2017 at 7:29 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Yes - updating the parsing slightly and printks as suggested makes sense
>>
>> Some additional warning messages in the userspace helper (adding Jeff
>> Layton), mount.cifs can also help.
>>
>> I also have an experimental set of patches to allow multi-dialect
>> negotiation with at least three of the acceptable dialects
>> (smb2.1/smb3/smb3.02) which will help, but complicate secure dialect
>> validation ("validate negotiate") but that will have to wait till next
>> release.
>>
>> On Thu, Aug 31, 2017 at 7:12 PM, Linus Torvalds
>> <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>> On Thu, Aug 31, 2017 at 2:36 PM, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org> wrote:
>>>> Lo! To give a bit more background to this (the mail I reply to was the
>>>> first I sent with git send-email and I missed some details): Maybe I'm
>>>> over stretching my abilities/position as regression tracker with this
>>>> RFC for a revert, but I hope it at least triggers a discussion if such a
>>>> revert should be done or not.
>>>
>>> I don't think that a revert is appropriate.
>>>
>>> But perhaps just a single printk() or something if the user does *not*
>>> specify the version explicitly? Just saying something like
>>>
>>>   We used to default to 1.0, we now default to 3.0, if you want old
>>> defaults, use "vers=1.0"
>>>
>>> Oh, looking at that version parsing code, I think we also need to fix
>>> that legacy "ver=1" thing (ver without the 's') which now silently
>>> ignores "ver=1" as being the "default", even though it's not.
>>>
>>> I do *not* believe that "default to version 1" is acceptable.
>>>
>>>                 Linus
