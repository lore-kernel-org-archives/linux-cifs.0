From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sync_smb2_mid_result
Date: Wed, 23 Mar 2011 14:32:43 -0400
Message-ID: <20110323143243.17abb03c@corrin.poochiereds.net>
References: <AANLkTinnLUXF3O=AOYG8PrCG1guAA8vkM18wYKSLegk2@mail.gmail.com>
	<20110323120617.0379e0a1@corrin.poochiereds.net>
	<AANLkTinVcBpT7X7A4XKd8+rz0XJw8ms159UnsK5aH49f@mail.gmail.com>
	<20110323135853.69b42c03@corrin.poochiereds.net>
	<AANLkTikTYEtgQVhFpqop658tWsQ_=wQ3Be5FK27Uuxqk@mail.gmail.com>
	<20110323140633.0927ce82@corrin.poochiereds.net>
	<AANLkTikkbxn527XAP1oT-U6yiE6fF-1Rb=+5KNHgQLOm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikkbxn527XAP1oT-U6yiE6fF-1Rb=+5KNHgQLOm-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Mar 2011 13:26:19 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Mar 23, 2011 at 1:06 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:>
> > Maybe you misunderstand me.
> >
> > The struct is *exactly the same* aside from a few small differences. It
> > doesn't even need to be a union, IMO. That would let you use a lot of
> > the same code in transport.c for smb2.
> 
> I don't mind trying to condense it to one structure, but it is not that simple:
> - smb2 doesn't need or sequence number, and the two transact2
> multiresponse booleans
> - cifs mid will grow by at least 10 bytes by expanding the mid, pid
> etc. to the required minimum sizes.
> - cifs mid doesn't need "async_response_received" or (that is an smb2
> only feature and that or equivalent is required).  When we add chained
> commands (common in smb2) then complex_mid or equivalent as well as
> the command list, the number of the commands received and the last
> response time of entries will be useless to cifs.
> 

Is it better to add an entirely new set of functions simply because
you'll have some unused fields in this structure in either case?

I don't think so.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
