From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [GiT] CIFS Fixes
Date: Wed, 9 Sep 2015 13:16:24 -0500
Message-ID: <CAH2r5mufnYU3pgOXi3sjUtFonMDzus+krvrS9i6w-cZHE9bQZQ@mail.gmail.com>
References: <CAH2r5mvkcq1S8iLEZDNmvZiFpiEJT5fBo_g2zg_VQ2KRMLtrhA@mail.gmail.com>
 <CA+55aFw9KB3iLZvCWfUT20vxsLovqUWEOjY51HjYf2ooEp2THw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFw9KB3iLZvCWfUT20vxsLovqUWEOjY51HjYf2ooEp2THw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Sep 9, 2015 at 12:02 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, Sep 8, 2015 at 9:22 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Small cifs fix and a patch for improved debugging.
>
> Ugh. With the ioctl changes, I was really hoping for the fix to
> cifs_ioctl_clone() from Jann. But it's not there.
>
> Did that get lost somehow?

I don't see any recent patch to cifs_ioctl_clone on fsdevel or
linux-cifs. Do you have a link to it?

Al did fix a deadlock in January in cifs_ioctl_clone via changeset
378ff1a53b5724f3ac97b0aba3c9ecac072f6fcd

-- 
Thanks,

Steve
