From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: packed attribute
Date: Mon, 16 Jan 2012 07:57:23 -0500
Message-ID: <20120116075723.2a4d30bd@tlielax.poochiereds.net>
References: <CAKywueSu=S-VkqS5K7=PYpt0a2hxR8Q=tmQrTEXSOvrKe=__Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueSu=S-VkqS5K7=PYpt0a2hxR8Q=tmQrTEXSOvrKe=__Nw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 16 Jan 2012 16:35:27 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I noticed that when I run checkpatch.pl over my smb2 patches it fails on
> 
> struct example {
> ...
> } __attribute__((packed));
> 
> and suggests to use
> 
> struct example {
> ...
> } __packed;
> 
> Also we already have many such "style broken" structures in cifsdpu.h.
> 
> What do you think about it? Should we fix them all?
> 

Hmm interesting...there's some discussion of this a few months ago here:

    https://lkml.org/lkml/2011/6/22/25

...looks like __packed is a shortcut in the kernel's compiler-gcc.h
header. Looks like using __packed is fine in new code as long as the
header will never be used by userspace (which may not have that
shortcut defined).

I don't see any reason to do a global search and replace in our headers
though. That would just increase the "churn" in the code for little
benefit.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
