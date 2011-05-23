From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Mon, 23 May 2011 13:24:41 -0500
Message-ID: <BANLkTi=wCtL=eHksuLuBPX8swEJjrtiV5w@mail.gmail.com>
References: <20110522081707.72cce108@corrin.poochiereds.net>
	<BANLkTim_K__5bqJG5snk+Bb+CW5dB70aQA@mail.gmail.com>
	<20110523071208.5dc935f8@corrin.poochiereds.net>
	<BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ@mail.gmail.com>
	<4DDA8BE6.8000001@plainjoe.org>
	<BANLkTikpWQaYRbaTGs5WtZ8zWrL8jeeQZQ@mail.gmail.com>
	<20110523134542.7d16be6d@tlielax.poochiereds.net>
	<BANLkTinX=CA_zeqNPhZpZD9JY3BNk08K_w@mail.gmail.com>
	<20110523140722.45c4ffc6@tlielax.poochiereds.net>
	<BANLkTi=NXhZ1PJKRKA1wYgbcBnw05_X8dQ@mail.gmail.com>
	<20110523182332.GA13791@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Gerald Carter <jerry-I3iY/6WR96Zg9hUCZPvPmw@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110523182332.GA13791-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 23, 2011 at 1:23 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> On Mon, May 23, 2011 at 01:21:35PM -0500, Steve French wrote:
>> Until Peter's Linux NFS fix is in - aren't we in that situation
>> already with other fs.
>
> That patch is not going to help with the fundamental problem that
> you won't be able to ever find an inode that went out of cache.

Isn't that what Peter's fix (and Solaris and other clients do) - they
revalidate the inode via another nfs lookup when it has gone stale.



-- 
Thanks,

Steve
