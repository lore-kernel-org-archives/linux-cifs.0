From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Sat, 2 Sep 2017 10:09:42 -0700
Message-ID: <CA+55aFxrXHMcvFe5adUr+0=u+Uwg=bHTn9ix9F0uUvGAkAPx7A@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
 <59A9A59E.6040205@tlinx.org> <CA+55aFzKhz=xLZNin4OR6DzUXiJMJ0EA=r4W9vN7WiaH7fY8UA@mail.gmail.com>
 <CAH2r5muHqSn=nJ42rwt7r6Mp4hvbNaPYJqEoqvqUS+rDFbxLMg@mail.gmail.com>
 <CA+55aFwUHLxBhOh7DxtjSSnKX6KBj+k+p=_CzE8i_xgq-LNj0A@mail.gmail.com> <1504329770.3249.61.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "L. A. Walsh" <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>,
        Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504329770.3249.61.camel-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 1, 2017 at 10:22 PM, Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
> My quick research shows:
>
> SMB 2.1 but not SMB3 is on:
>  Windows 7
>  Windows 8
>  Windows 2008
>  Windows 2012
>  Samba 3.6 and earlier (SMB1 only by default)
>
> SMB3 is on:
>  Windows 8.1
>  Windows 2012 R2
>  Windows 10
>  Windows 2016
>  Samba 4.0 and above (released 2012)

But most, if not all, of those SMB3 cases _also_ support SMB2.1,
right?  So the "3.0 _only_" case ends up being a fairly rare case
where things have been explicitly limited, and any previous Linux use
must have had that explicit "vers=3.0" flag anyway?

No?

Anyway, we can't avoid *some* breakage (ie the places that literally
only support 1.0 will have to add the explicit "vers=1.0" to get the
mount).

And I merged the code to add better error reporting yesterday, so
hopefully regardless of the default we choose the breakage is not
nearly as confusing to people any more.

                      Linus
