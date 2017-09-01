From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Thu, 31 Aug 2017 17:12:09 -0700
Message-ID: <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info> <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <smfrench@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
To: Thorsten Leemhuis <linux@leemhuis.info>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Aug 31, 2017 at 2:36 PM, Thorsten Leemhuis <linux@leemhuis.info> wrote:
> Lo! To give a bit more background to this (the mail I reply to was the
> first I sent with git send-email and I missed some details): Maybe I'm
> over stretching my abilities/position as regression tracker with this
> RFC for a revert, but I hope it at least triggers a discussion if such a
> revert should be done or not.

I don't think that a revert is appropriate.

But perhaps just a single printk() or something if the user does *not*
specify the version explicitly? Just saying something like

  We used to default to 1.0, we now default to 3.0, if you want old
defaults, use "vers=1.0"

Oh, looking at that version parsing code, I think we also need to fix
that legacy "ver=1" thing (ver without the 's') which now silently
ignores "ver=1" as being the "default", even though it's not.

I do *not* believe that "default to version 1" is acceptable.

                Linus
