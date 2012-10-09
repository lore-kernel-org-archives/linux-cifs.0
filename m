From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: implement the "nofail" option
Date: Tue, 9 Oct 2012 15:19:48 -0400
Message-ID: <20121009151948.7b45c2eb@tlielax.poochiereds.net>
References: <1349693224-17065-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, PTrenholme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349693224-17065-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  8 Oct 2012 06:47:04 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> The mount(8) manpage lists this as a fs-independent option:
> 
>     nofail: Do not report errors for this device if it does not exist.
> 
> Implement that in mount.cifs by not returning an error if we were unable
> to find a suitable address for the mount attempt.
> 
> Reported-by: Peter Trenholme <PTrenholme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 

Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
