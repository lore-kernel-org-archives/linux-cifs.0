From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] cifs: clean up various nits in unicode routines
Date: Tue, 05 Apr 2011 18:58:59 +0100
Message-ID: <7828.1302026339@redhat.com>
References: <20110405103209.75fb7da5@corrin.poochiereds.net> <1301607405-4379-1-git-send-email-jlayton@redhat.com> <1301607405-4379-6-git-send-email-jlayton@redhat.com> <BANLkTino1a1Wr55BCynPGK176Zbm5DPcXw@mail.gmail.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110405103209.75fb7da5-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 5 Apr 2011 12:23:40 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > The patch is fine except that I would prefer that it not introduce a
> > sparse warning
> > (this would be the only endian warning). See below:
> > 
> >   CHECK   fs/cifs/cifs_unicode.c
> > fs/cifs/cifs_unicode.c:309:32: warning: cast from restricted __le16
> >   CC [M]  fs/cifs/cifs_unicode.o
> > 
> 
> Good point. I'll need to put a new variable on the stack to fix it, but
> that's no big deal. I'll fix and resend.

Which line is it that actually gives the warning?  Is it when 0 is implicitly
cast to __le16?  If so, can you just cast it directly?

David
