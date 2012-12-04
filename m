From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/6] mount.cifs: treat uid=,gid=,cruid= options as name
 before assuming they're a number
Date: Tue, 4 Dec 2012 10:45:19 -0500
Message-ID: <CAFB9KM2DAL+x46oW017HmhZX=+p8bxvFn3FX+K5QDpAUnbUHEQ@mail.gmail.com>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
	<1354634204-21602-2-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-2-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 4, 2012 at 10:16 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Sergio Conrad reported a problem trying to set up an autofs map to do
> a krb5 mount. In his environment, many users have usernames that are
> comprised entirely of numbers. While that's a bit odd, POSIX apparently
> allows for it.
>
> The current code assumes that when a numeric argument is passed to one
> of the above options, that it's a uid or gid. Instead, try to treat the
> argument as a user or group name first, and only try to treat it as a
> number if that fails.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Yuck.  What happens when a number is both a valid user name and uid?
IE, I add a user named "0" (uid=5001).  Does getpwnam() return root
(uid=0) or 0 (uid=5001)?

-- 
Peace and Blessings,
-Scott.
