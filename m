From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: RFC: Revert move default dialect from CIFS to to SMB3
Date: Fri, 1 Sep 2017 12:45:42 -0700
Message-ID: <CA+55aFzKhz=xLZNin4OR6DzUXiJMJ0EA=r4W9vN7WiaH7fY8UA@mail.gmail.com>
References: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
 <bf90b119-1e94-131b-d7b6-c35934d8d1bf@leemhuis.info> <CA+55aFwUdX3wNYCuWjUTLQGPMCw3peeKeSBfwXb+HuV36OwE+g@mail.gmail.com>
 <59A9A59E.6040205@tlinx.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: "L. A. Walsh" <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59A9A59E.6040205-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 1, 2017 at 11:23 AM, L. A. Walsh <linux-cifs-gT3AUAsYRbTYtjvyW6yDsg@public.gmane.org> wrote:
>    Why be incompatible with the majority of Windows installations?
> I.e.  If you really want to up security from 1.0 (not adverse to that),
> then why not go to 2.1 as used by Win7?  Win7 is still in support
> from MS -- and they haven't indicated a need to upgrade to 3.x for
> security reasons.  3.x may have new security features, no argument, but
> that doesn't mean 2.1, is insecure.

I'm certainly ok with changing the default to 2.1 if that helps people.

Is that actually likely to help the people who now see problems with
the existing 3.0 default?

I don't know the exact security issue details with cifs, but I _think_
it was explicitly _only_ smb-1.0, right?

                   Linus
