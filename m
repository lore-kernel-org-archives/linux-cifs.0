From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: document 'fsc' mount option
Date: Tue, 27 Jul 2010 11:34:21 -0400
Message-ID: <20100727113421.4f1a1bb4@tlielax.poochiereds.net>
References: <4C4EE408.7070109@suse.de>
	<20100727103313.4b730ea8@tlielax.poochiereds.net>
	<AANLkTina2EyHkrgNAcrY8ZRK=fXQS71dekWc+kOA0+mz@mail.gmail.com>
	<20100727111517.4fe0859e@tlielax.poochiereds.net>
	<AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik9JqtqAtKJQsaQR8aC8s0kwmrcU=_=QQei7U07-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Jul 2010 10:21:51 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> scripts/extract-ikconfig could be run against the image (or look at
> /proc/config.gz) - but unless there is an easier way to view kernel
> config options on particular distros via distro specific tools -
> probably easier just to note that CONFIG_FSCACHE must be selected in
> the kernel build (since it forces dependencies on the other kernel
> options being set)
> 

It would be nice if there were a definitive way to tell what's been
compiled in. Not just for this, but for DFS/krb5 upcalls, etc. Maybe we
should consider a /proc/fs/cifs/features file that would display this
info? For instance:

$ cat /proc/fs/cifs/features
dfs spnego fsc

...or something like that?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
