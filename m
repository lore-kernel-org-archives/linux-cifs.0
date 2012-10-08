From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: clarify the user of the username= option
Date: Mon, 8 Oct 2012 06:09:53 -0400
Message-ID: <20121008060953.68bb4fc8@tlielax.poochiereds.net>
References: <1348570366-17466-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348570366-17466-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 25 Sep 2012 06:52:46 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Specifying the username as "user=" can confuse some versions of /bin/mount,
> and cause it to append noexec to the mount string. Also, remove the blurb
> about how cifs.ko will accept abbreviations -- it's just bad practice.
> 
> A wonderful example of this confusion was reported by Stefan here:
> 
>     https://bugzilla.redhat.com/show_bug.cgi?id=860154
> 
> Reported-by: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.8 | 24 ++----------------------
>  1 file changed, 2 insertions(+), 22 deletions(-)
> 


Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
