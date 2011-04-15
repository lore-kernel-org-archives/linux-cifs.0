From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mids and cifs sendrcv2
Date: Fri, 15 Apr 2011 22:41:37 +0400
Message-ID: <BANLkTimQ-vgiTJVy5vcivwaqex2nCq9DLg@mail.gmail.com>
References: <BANLkTi=tUrieqB4jCo0GRX3Np10JxJUP9Q@mail.gmail.com>
	<BANLkTikLfy=4BPESJEmOe+mBhKSRtC=W6A@mail.gmail.com>
	<BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTiknBBtzjEjXK5N=SpUaU=b4GAos_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/15 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> I think nested mid structures (around a base of common mid fields)
> like the above is going to be the easiest way to handle the differences.
>
> I don't understand your PROTOCOL_ID #define though - we
> identify smb2 vs. cifs via a bool in the tcp server info struct,
> and presumably if we don't have access to the tcp server
> info struct we would have to add a field in the base mid
> (struct mid_q_entry) that indicates smb2 vs. cifs..
>
>
Good variant too. I don't it really matters how to get protocol
version - I just propose an idea how to organize structures.


-- 
Best regards,
Pavel Shilovsky.
