From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: update limit for snprintf() in
 cifs_construct_tcon()
Date: Tue, 12 Jul 2011 21:20:39 +0300
Message-ID: <20110712182039.GJ18655@shale.localdomain>
References: <20110617103059.GE2520@shale.localdomain>
 <CAH2r5mu6TuWs6P8ZeR1=KCv8BLSu0_Z8b2uoVUqXhw55=39CWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"open list:COMMON INTERNET F..." <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"open list:COMMON INTERNET F..." <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mu6TuWs6P8ZeR1=KCv8BLSu0_Z8b2uoVUqXhw55=39CWg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jul 12, 2011 at 01:14:00PM -0500, Steve French wrote:
> What about the following alternative, so we dont rely on the magic
> number as much.
> 

Yeah.  That's better.  Want me to do anything or will you just give
me the reported-by?

regards,
dan carpenter
