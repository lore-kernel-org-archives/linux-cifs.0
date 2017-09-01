From: Steve French <smfrench@gmail.com>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Thu, 31 Aug 2017 19:29:42 -0500
Message-ID: <CAH2r5msWDXzwbFPtUHCKbqHrEBTsvw5eaTayj5RkdgYCLM5nAQ@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Jeff Layton <jlayton@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Yes - updating the parsing slightly and printks as suggested makes sense

Some additional warning messages in the userspace helper (adding Jeff
Layton), mount.cifs can also help.

I also have an experimental set of patches to allow multi-dialect
negotiation with at least three of the acceptable dialects
(smb2.1/smb3/smb3.02) which will help, but complicate secure dialect
validation ("validate negotiate") but that will have to wait till next
release.

On Thu, Aug 31, 2017 at 7:12 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Aug 31, 2017 at 2:36 PM, Thorsten Leemhuis <linux@leemhuis.info> wrote:
>> Lo! To give a bit more background to this (the mail I reply to was the
>> first I sent with git send-email and I missed some details): Maybe I'm
>> over stretching my abilities/position as regression tracker with this
>> RFC for a revert, but I hope it at least triggers a discussion if such a
>> revert should be done or not.
>
> I don't think that a revert is appropriate.
>
> But perhaps just a single printk() or something if the user does *not*
> specify the version explicitly? Just saying something like
>
>   We used to default to 1.0, we now default to 3.0, if you want old
> defaults, use "vers=1.0"
>
> Oh, looking at that version parsing code, I think we also need to fix
> that legacy "ver=1" thing (ver without the 's') which now silently
> ignores "ver=1" as being the "default", even though it's not.
>
> I do *not* believe that "default to version 1" is acceptable.
>
>                 Linus



-- 
Thanks,

Steve
