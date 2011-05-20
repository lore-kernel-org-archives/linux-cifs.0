From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Fri, 20 May 2011 11:54:58 -0500
Message-ID: <BANLkTinoO4YSEP-PkzE6SmRJKa3A=PMxVA@mail.gmail.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
	<20110519140132.32850e2c@barsoom.rdu.redhat.com>
	<BANLkTinsqwMoFzP+9+qX+W+Gr+LGae0Rdw@mail.gmail.com>
	<BANLkTi=6jvvugqCTjYTx6FredDswkFZccw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=6jvvugqCTjYTx6FredDswkFZccw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 20, 2011 at 11:50 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The fix makes sense, but it reminded me - would allowing
> "mapping_set_error" when rc is zero reset/clear a saved error - and
> would we want that (ie getattr or llseek able to flush a page which we
> failed writing earlier could clear the saved error if we allowed
> mapping_set_error on rc == 0)?
>
Nevermind - mapping_set_error bails out when rc is 0.



-- 
Thanks,

Steve
