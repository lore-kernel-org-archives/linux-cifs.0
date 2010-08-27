From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Cannot allocate memory error on mount
Date: Fri, 27 Aug 2010 07:17:18 -0400
Message-ID: <20100827071718.6c21ab44@corrin.poochiereds.net>
References: <514808.54527.qm@web56908.mail.re3.yahoo.com>
	<4C7630D9.7060203@suse.de>
	<20100826082305.1594ec4e@barsoom.rdu.redhat.com>
	<AANLkTi=qnTFUcnu-uS8NGTkjYUhO-hHstargorpJ8yZ9@mail.gmail.com>
	<4C775A03.8010507@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C775A03.8010507-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 27 Aug 2010 11:54:03 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 08/26/2010 09:55 PM, Steve French wrote:
> > This is a good one to go upstream soon - if others critical to go
> > upstream soon let me know.
> 
> Do we need to Cc -stable as well? I don't feel strongly that we should
> include this fix. However, unrelated memory allocation errors during
> mount in supported kernels sounds more than annoying..
> 
> Thoughts?
> 

It doesn't seem like stable material to me. It's an annoyance, but not a
security or stability fix as far as I can see...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
