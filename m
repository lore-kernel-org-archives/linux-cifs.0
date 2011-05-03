From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: refactor mid finding loop in
 cifs_demultiplex_thread
Date: Tue, 3 May 2011 08:09:53 -0400
Message-ID: <20110503080953.65db9af6@corrin.poochiereds.net>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
	<1303819401-14789-5-git-send-email-jlayton@redhat.com>
	<BANLkTim4jXoQm47-ecw8r5ftBVGRbA+mKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim4jXoQm47-ecw8r5ftBVGRbA+mKw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2 May 2011 22:44:42 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> From this series all but the cifs: remove unneeded variable
> initialization in cifs_r... (which doesn't need to go in 2.6.39) look
> fine and are merged.
> 

Thanks Steve,

Any idea when you'll update your for-2.6.40 branch? I have some patches
that are based on that branch that will probably need to be respun
now...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
