From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v2 2/6] ntlmv2/ntlmssp ntlmssp autentication code
Date: Sun, 12 Sep 2010 22:25:06 -0400
Message-ID: <20100912222506.21f1c032@corrin.poochiereds.net>
References: <1284055960-792-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100912085214.08fea91e@tlielax.poochiereds.net>
	<AANLkTintaxP-BGTRWH-3GmYERvM7g_WYXYYT0StZJaGj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTintaxP-BGTRWH-3GmYERvM7g_WYXYYT0StZJaGj-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


> >
> > Would it be reasonable to split the simple mac_key to session_key
> > rename part into a separate patch from the ones that actually change
> > behavior?
> 
> OK. But I am not sure what we are trying to achieve here churning
> these patches so
> many times for a simple change.  Not sure who the audience is.
> 

I'm trying to achieve clarity and bisectability. By separating the
trivial changes from the substantive ones, the patches become smaller
and the changes they introduce are more evident.

For the clarity piece, the audience is those of us who are spending
time to review them (so far, Steve, Suresh and I). All of us have
limited amounts of time available to spend on review. None of us
want to spend time sifting through the trivial changes in these patches
to hunt down the ones that actually change behavior.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
