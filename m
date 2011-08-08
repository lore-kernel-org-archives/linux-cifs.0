From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: demote cERROR in build_path_from_dentry to cFYI
Date: Mon, 8 Aug 2011 12:37:07 -0400
Message-ID: <20110808123707.2287c6bb@tlielax.poochiereds.net>
References: <1312818624-6108-1-git-send-email-jlayton@redhat.com>
	<CAH2r5mubUpMUgaaE-GS9Wu8brn-6Cn1XQYRx+ya1G_e-reJskQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mubUpMUgaaE-GS9Wu8brn-6Cn1XQYRx+ya1G_e-reJskQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 8 Aug 2011 11:19:05 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Probably reasonable.
> 
> How often are you hitting this (roughly) in cthon test run now?  I
> don't remember seeing it much before - do you remember seeing it
> before?
> 

It varies. Sometimes it doesn't pop at all, but on one run I hit it 7
times within 1 second. I think this started with commit dc137bf553
which is pretty recent. Before that, the read_seqretry check wasn't
present.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
