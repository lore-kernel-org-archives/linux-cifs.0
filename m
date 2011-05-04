From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: use the server's MaxMpxCount to determine max
 requests in flight
Date: Wed, 4 May 2011 07:09:55 -0400
Message-ID: <20110504070955.07d9420f@tlielax.poochiereds.net>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
	<1304345069-2441-9-git-send-email-jlayton@redhat.com>
	<BANLkTinJHDQup-QwRNrZF19L_VycUCf1Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinJHDQup-QwRNrZF19L_VycUCf1Jw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 4 May 2011 14:38:07 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/5/2 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Currently, we have a default cap of 50 outstanding requests and a hard
> > cap of 256. However, the server sends us how many requests it can handle
> > simultaneously via the MaxMapCount value in the NegProt request. Use
> > that value instead and eliminate the cifs_max_pending module parm.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> 
> If we ignore this limit for Echo request, can a server drop a
> connection if we send, e.g. maxReq write requests and 1 Echo request?
> http://msdn.microsoft.com/en-us/library/ee441946(v=PROT.13).aspx
> doesn't mention about any exceptions for Echo request in this case.
> 

Well, we currently ignore this for oplock breaks too...

I suppose we probably ought to have a small number of slots kept in
reserve for echoes and oplock breaks. Instead of just ignoring the
limit for those we can allow these calls access to those "emergency"
slots.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
