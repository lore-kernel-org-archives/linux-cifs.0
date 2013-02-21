From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove the sockopt= mount option
Date: Thu, 21 Feb 2013 11:29:28 -0500
Message-ID: <51264B68.7060008@gmail.com>
References: <1361446379-7970-1-git-send-email-jlayton@redhat.com>	<CAFB9KM0bJo4NpePoe9aWMZGJ_jfk0W41Thefg7MD=_V+VP98Eg@mail.gmail.com> <CAH2r5mtHsOjXjXx5NdHWNzoTmVmny8gSh_Gd1XfHdNfCOHJDyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtHsOjXjXx5NdHWNzoTmVmny8gSh_Gd1XfHdNfCOHJDyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 2/21/2013 11:00 AM, Steve French wrote:
> We should do some quick performance runs to verify this - but with
> corking and uncorking the socket explicitly presumably TCP_NODELAY
> should not be needed.
I got that info from the old Samba HOWTO and Reference Guide, but it's 
very, very old info.  I'm guessing that when matched with an older 
kernel and possibly older TCP/IP congestion algorithm, it might have 
made more of a difference than it does now.
