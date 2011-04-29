From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Fri, 29 Apr 2011 06:55:13 -0400
Message-ID: <20110429065513.7dd0c0bb@corrin.poochiereds.net>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<BANLkTimNseyrXc9ZDz0N4tomRx1oy5P60Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimNseyrXc9ZDz0N4tomRx1oy5P60Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 29 Apr 2011 00:05:09 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I merged the following 3 into cifs-2.6.git (from the versions in your
> cifs-2.6.39 branch).  Was curious why the last two weren't in that
> branch.
> 
> cifs: change bleft in decode_unicode_ssetup back to signed type
> cifs: check for bytes_remaining going to zero in CIFS_SessSetup
> cifs: sanitize length checking in coalesce_t2
> 

That would be because I'm an idiot and pushed the branch to my tree w/o
stg pushing the last two patches onto the stack. They're there now.
Sorry about that...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
