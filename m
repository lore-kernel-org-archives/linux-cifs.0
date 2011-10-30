From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Sun, 30 Oct 2011 01:36:49 -0400
Message-ID: <20111030013649.0bce08f5@corrin.poochiereds.net>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
	<20111028072019.GA14900@longonot.mountain>
	<CAH2r5msb_+tenSg1kWCn_0xi2EZu6vboqvmbQ17vRBYoqHp2Eg@mail.gmail.com>
	<20111028234406.01fd23ba@corrin.poochiereds.net>
	<CAH2r5mvHF0X6PQ8FyBfVEpQeyWgd7RGkawJykapkKt0K84QTHw@mail.gmail.com>
	<20111029014855.13dd53be@corrin.poochiereds.net>
	<CAH2r5muq4n34Liy_=CQQX-PeTinJFDAPi81fA-eqsTcXw5remQ@mail.gmail.com>
	<20111029224852.15ee6302@corrin.poochiereds.net>
	<CAH2r5msVoEuxo8vGj6sYjjNqjPeo9wxa-r7bAq6Or1_xS9EWFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msVoEuxo8vGj6sYjjNqjPeo9wxa-r7bAq6Or1_xS9EWFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 29 Oct 2011 21:53:13 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I thought we agreed that (at worst) the logic works for the "noperm"
> (no client side enforcement, ie multiuser case).
> 

It may work in that case, but that's really just an accident. It still
doesn't make any sense for the reasons I've already described.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
