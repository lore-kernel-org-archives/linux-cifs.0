From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate errors up to the caller during get/set
 acls
Date: Mon, 8 Nov 2010 14:19:05 -0500
Message-ID: <20101108141905.7eaa9530@tlielax.poochiereds.net>
References: <1289231238-15203-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101108121310.78951ec1@tlielax.poochiereds.net>
	<AANLkTi=dwS88JM422vAxSMaeuqDdu_dh2aqGc6fGSpkd@mail.gmail.com>
	<20101108123850.055b71b0@tlielax.poochiereds.net>
	<AANLkTi=PTMQvP2+uMWR-iVZ8md3C4XXjoRpNNCoVsfpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=PTMQvP2+uMWR-iVZ8md3C4XXjoRpNNCoVsfpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 8 Nov 2010 13:04:15 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> >>
> >> I think we now have a consistent interface not only within
> >> various get/set_cifs_acl* functions but like most of the rest of of
> >> the functions
> >> i.e. they return error code and not a ptr to a structure when successful
> >> or an err ptr for failure?
> >>
> >
> > I'm not sure I understand your question. Can you rephrase it?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> 
> I meant all the get/set_cifs_acl function now return an error code
> i.e. 0 for success and non-zero for an error.

Ok, so what's the question?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
