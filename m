From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix wsize negotiation to respect max buffer size
 and active signing
Date: Tue, 21 Jun 2011 12:37:49 -0400
Message-ID: <20110621123749.305dd576@tlielax.poochiereds.net>
References: <1308658097-14805-1-git-send-email-jlayton@redhat.com>
	<20110621113327.6df5fdd4@tlielax.poochiereds.net>
	<BANLkTik=QLv-=mynGjxe+8Bp7GCpuhwt8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTik=QLv-=mynGjxe+8Bp7GCpuhwt8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 21 Jun 2011 11:24:12 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Yep - makes sense - I will plan on merging the respun patch.
> 
> Opinions about the rsize equivalent of this going in quickly as well?
> 

According to George, reading doesn't have this issue and Hongwei's blog
is wrong in this respect. That makes some sense since for a read we're
sending a very small request to the server, and we specify how much we
want to receive.

Eventually, cleaning up the rsize negotiation would be good, but I
don't think there's any urgency for it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
