From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Thu, 4 Jan 2018 16:52:17 +1100
Message-ID: <20180104165217.7737a0bc@canb.auug.org.au>
References: <20180104093359.4e012f2f@canb.auug.org.au>
        <CAH2r5mvgtC3Y_aLxk7-_R8E=ohR1LoFSkiqZZ6rhn9azXY05xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvgtC3Y_aLxk7-_R8E=ohR1LoFSkiqZZ6rhn9azXY05xw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Steve,

On Wed, 3 Jan 2018 16:44:59 -0600 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> I don't see this with gcc 5.4

Good to know.

> Harmless to initialize flags here ... even if unneeded ... so if it
> makes your life easier I don't mind initializes to 0.  Let me know.
> Wonder why it doesn't generate the warning on the various other places
> in the fs that do the same thing?

I might just take the hint to upgrade my cross compilers :-)  Thanks anyway.

In the mean time, my scripts will automatically skip reporting this
warning to me.
-- 
Cheers,
Stephen Rothwell
