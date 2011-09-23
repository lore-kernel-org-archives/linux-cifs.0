From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: default security mechanism for 3.1
Date: Fri, 23 Sep 2011 15:21:29 -0400
Message-ID: <20110923152129.43c666ab@tlielax.poochiereds.net>
References: <20110923081620.40c0aa17@tlielax.poochiereds.net>
	<4E7C7AA1.2060402@suse.com>
	<20110923094321.1e848857@tlielax.poochiereds.net>
	<CADT32e+KDBM=_jOm4m0cirQGeO7YfH4RADb5fbv7dcvUGG9j+A@mail.gmail.com>
	<20110923112624.6449194e@tlielax.poochiereds.net>
	<CAH2r5mv1+66fxESK85+HRaRUyK_bRgzSO9tMZFoC1FiDu60zfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv1+66fxESK85+HRaRUyK_bRgzSO9tMZFoC1FiDu60zfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 23 Sep 2011 14:12:46 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> At the conference I got some valuable data (needed for this patch) from
> discussions with other engineers (and some testing)
> 
> - extended security is supported by enough servers to use as the default
> - we can use the server turning off extended security as a trigger to go
> back to directly using ntlmv2 (not in ntlmssp)
> - if extended security is on then all known servers will support raw ntlmssp
> 
> So basically change would be:
> - turn on extended security in negotiate by default
> - fall back if server doesn't support it
> - otherwise send raw ntlmssp
> 

Ok, I'm assuming that it's too late to get this into 3.1 and this will
be 3.2 material? If so, can you fix the printk to reflect the correct
version that this will change?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
