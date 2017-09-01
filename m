From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Fri, 1 Sep 2017 13:06:45 +1000
Message-ID: <CAN05THQtq_MNfDFNY-XHNXfhv36CWupyA5dzNL+XsNx-498U3A@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
 <CAH2r5msWDXzwbFPtUHCKbqHrEBTsvw5eaTayj5RkdgYCLM5nAQ@mail.gmail.com> <CAH2r5mv9roEvMX+C-csU=GZFM_HMbqxnHfF11NUp+2yonDVPgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv9roEvMX+C-csU=GZFM_HMbqxnHfF11NUp+2yonDVPgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Two missing \n in connect.c

Fix those and you can add a
Reviewed-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Sep 1, 2017 at 12:42 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Any thoughts on this patch to add additional warnings for the user -
> logging when using default dialects (or when server returns dialect
> not supported), and noting the default dialect change?
>
> See https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=bb86f22eeddbb5879675b55168b8fa8990d74a21
>
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
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Thanks,
>
> Steve
