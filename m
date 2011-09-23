From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: default security mechanism for 3.1
Date: Fri, 23 Sep 2011 09:43:21 -0400
Message-ID: <20110923094321.1e848857@tlielax.poochiereds.net>
References: <20110923081620.40c0aa17@tlielax.poochiereds.net>
	<4E7C7AA1.2060402@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E7C7AA1.2060402-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Sep 2011 17:55:05 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 09/23/2011 05:46 PM, Jeff Layton wrote:
> > A printk warning was added to the kernel about the default security
> > mode changing in 3.1. As best I can tell though, that has not happened
> > even though the release is imminent. Are you still planning to change
> > that? If not, are you planning to fix the printk?
> > 
> 
> Did you mean this one?
>    http://www.spinics.net/lists/linux-cifs/msg03976.html
> 
> I remember Steve posted this patch sometime ago but I'm not seeing them
> in the cifs development tree..
> 
> 
> -Suresh

Yeah, that's the one. Seems a little late to be adding these sorts of
behavior changes in 3.1 though, so I'm just wondering what the plan is.

I also have some concerns about defaulting to raw NTLMv2 auth since (at
least) win2k8 rejects unless you go in and tweak registry keys. It
would seem to me to be better to decide the default based on the
negotiation:

Set extended security bit in the NegProt by default

If the server sets it, then use NTLMSSP

If it doesn't then use old NTLM (or NTLMv2)

That means an overhaul of how sec_mode is handled though, since that's
currently decided too early to do it that way.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
