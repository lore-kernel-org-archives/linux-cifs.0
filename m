From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [CIFS] Cleanup use of CONFIG_CIFS_STATS2 ifdef to make transport
 routines more readable
Date: Fri, 18 Mar 2011 14:32:31 -0500
Message-ID: <AANLkTimrNogtXhiVx40L1wbCKDdOSh5bdo3unD=ojN=L@mail.gmail.com>
References: <AANLkTim2bOYRB9i-RzqTt62=Z_SF9BWk-7d-7qr2g0_p@mail.gmail.com>
	<20110318144111.75b4fe9a@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110318144111.75b4fe9a-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 18, 2011 at 1:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 17 Mar 2011 14:12:23 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Christoph had requested that the stats related code (in
>> CONFIG_CIFS_STATS2) be moved into helpers to make code flow
>> more readable.
...
> Nice cleanup. Don't forget the SoB line though ;)
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thx. Done.

Also, I reviewed and merged your
"cifs: clarify the meaning of tcpStatus == CifsGood" patch



-- 
Thanks,

Steve
