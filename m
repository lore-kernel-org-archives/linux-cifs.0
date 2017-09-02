From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Fri, 1 Sep 2017 20:56:50 -0700
Message-ID: <CA+55aFwUHLxBhOh7DxtjSSnKX6KBj+k+p=_CzE8i_xgq-LNj0A@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
 <59A9A59E.6040205@tlinx.org> <CA+55aFzKhz=xLZNin4OR6DzUXiJMJ0EA=r4W9vN7WiaH7fY8UA@mail.gmail.com>
 <CAH2r5muHqSn=nJ42rwt7r6Mp4hvbNaPYJqEoqvqUS+rDFbxLMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "L. A. Walsh" <linux-cifs@tlinx.org>,
        Thorsten Leemhuis <linux@leemhuis.info>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muHqSn=nJ42rwt7r6Mp4hvbNaPYJqEoqvqUS+rDFbxLMg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Sep 1, 2017 at 7:16 PM, Steve French <smfrench@gmail.com> wrote:
>
> The default was SMB1 (CIFS) and was recently changed to SMB3.
> The dialect still can be overridden by specifying "vers=1.0" or "vers=2.1"
> etc. on mount.
>
> We just put together a patch to better explain the default changes
> (with additional warning messages) as suggested.
>
> SMB3 is significantly better than SMB2.1 (supporting encrypted shares
> and sessions for example, and requiring support for "secure negotiate")
> and some servers require SMB3 minimum as a result,

The default shouldn't be about "best and most secure", but "most
convenient, while still not actively *IN*secure"

So "some servers require 3.0" may be true, but if it's also the case
that "most servers still don't do 3.0 at all", then it's a "some" vs
"most".

Which is the most common one? That should be the default.

I realize that eventually we'll have auto-negotiation, but that's
clearly not for 4.13. So in the meantime the only issue is what the
right default should be without auto-negotiation.

So it should be about what the failure rate is. If trying for smb3 has
a high failure rate because people simply don't have that yet, then
making that the default was clearly the wrong choice.

Because being "better" is immaterial if it doesn't work.

              Linus
