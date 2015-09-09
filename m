From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [GiT] CIFS Fixes
Date: Wed, 9 Sep 2015 10:02:12 -0700
Message-ID: <CA+55aFw9KB3iLZvCWfUT20vxsLovqUWEOjY51HjYf2ooEp2THw@mail.gmail.com>
References: <CAH2r5mvkcq1S8iLEZDNmvZiFpiEJT5fBo_g2zg_VQ2KRMLtrhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvkcq1S8iLEZDNmvZiFpiEJT5fBo_g2zg_VQ2KRMLtrhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Sep 8, 2015 at 9:22 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Small cifs fix and a patch for improved debugging.

Ugh. With the ioctl changes, I was really hoping for the fix to
cifs_ioctl_clone() from Jann. But it's not there.

Did that get lost somehow?

                   Linus
