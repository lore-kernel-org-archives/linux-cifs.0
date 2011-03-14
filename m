From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: always do is_path_accessible check in cifs_mount
Date: Mon, 14 Mar 2011 15:40:10 -0400
Message-ID: <20110314154010.137ef899@corrin.poochiereds.net>
References: <1300124888-16958-1-git-send-email-jlayton@redhat.com>
	<AANLkTinv8bmv3G-p9gcUJ3ciGABurNhdNr4Je32cmMVH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ysharma-3moEsy1GKqIAvxtiuMwx3w@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinv8bmv3G-p9gcUJ3ciGABurNhdNr4Je32cmMVH-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 14 Mar 2011 14:04:42 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> merged
> 

Thanks.

I should note that Yogesh is still having some trouble getting DFS
working in his setup, but this does seem to fix the oops. Anyone
wanting to follow along can do so here:

    https://bugzilla.redhat.com/show_bug.cgi?id=682829

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
