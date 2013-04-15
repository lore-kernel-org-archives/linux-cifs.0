From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: Add support for parsing IPv6 addresses
 enclosed in brackets.
Date: Sun, 14 Apr 2013 21:56:33 -0400
Message-ID: <CAFB9KM0rmj5YQ3KY0EcZ2-_eyBX4oCa6ja2HtAMW6hA5qYsy7A@mail.gmail.com>
References: <1365963558-20082-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365963558-20082-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Apr 14, 2013 at 2:19 PM,  <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> The standard for formatting IPv6 addresses is to enclose them in brackets.
> This patch allows the mount helper to parse IPv6 addresses that are enclosed in brackets.
> There is a slight change of behavior in this patch; specifying the --ip option without
> supplying an address now exits the mount helper rather than just ignoring and continuing.
>
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

I should mention, this hasn't actually been tested.  Only compiled.  A
patch this small is usually fairly safe.. then again, I've messed up
one-liners.  A few eyes over this code would be appreciated.


--
Peace and Blessings,
-Scott.
