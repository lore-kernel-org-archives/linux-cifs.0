From: "L. A. Walsh" <linux-cifs@tlinx.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Fri, 01 Sep 2017 11:23:26 -0700
Message-ID: <59A9A59E.6040205@tlinx.org>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info> <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
        Steve French <smfrench@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Linus Torvalds wrote:
> On Thu, Aug 31, 2017 at 2:36 PM, Thorsten Leemhuis <linux@leemhuis.info> wrote:
>   
>> Lo! To give a bit more background to this (the mail I reply to was the
>> first I sent with git send-email and I missed some details): Maybe I'm
>> over stretching my abilities/position as regression tracker with this
>> RFC for a revert, but I hope it at least triggers a discussion if such a
>> revert should be done or not.
>>     
>
> I don't think that a revert is appropriate.
>
> But perhaps just a single printk() or something if the user does *not*
> specify the version explicitly? Just saying something like
>
>   We used to default to 1.0, we now default to 3.0, if you want old
> defaults, use "vers=1.0"
>   
----
    Why be incompatible with the majority of Windows installations?
I.e.  If you really want to up security from 1.0 (not adverse to that),
then why not go to 2.1 as used by Win7?  Win7 is still in support
from MS -- and they haven't indicated a need to upgrade to 3.x for
security reasons.  3.x may have new security features, no argument, but
that doesn't mean 2.1, is insecure.


> I do *not* believe that "default to version 1" is acceptable.
>   
---
    But does it have to jump to 3?  I.e. Why not go a more middle
route of 2.1 -- as it is still security-supported by MS.  Ideally
MS would find some bug in 2.1 and allow 3.x to be an upgrade to Win7,
but until then...

Linda
