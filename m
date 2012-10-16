From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix potential buffer overrun in cifs.idmap
 handling code
Date: Tue, 16 Oct 2012 19:21:34 -0400
Message-ID: <20121016192134.17ff3428@corrin.poochiereds.net>
References: <1350386379-16850-1-git-send-email-jlayton@redhat.com>
	<CADT32eL0ghENLv1xof1RMUEUH=E=ZBVD_VHemkx5Ni4xiMS8JQ@mail.gmail.com>
	<20121016102620.26f852b5@tlielax.poochiereds.net>
	<CADT32e+=Ftx=h8A_-=Cqhi7shXLDxm7XdDD7Pk9=u0-_3Qsj2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+=Ftx=h8A_-=Cqhi7shXLDxm7XdDD7Pk9=u0-_3Qsj2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Oct 2012 17:01:56 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Oct 16, 2012 at 9:26 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Thanks, I had another question too on a related note...
> >
> > The idmap code basically does double caching. You call into the keys
> > API to do the mapping. If it doesn't have a mapping then it will call
> > into userspace to establish one. The keys API will then cache that
> > result in a "struct key". You're then taking that payload and caching
> > it again in a rbtree.
> >
> > What's the rationale for that? Why not just use they keys API cache
> > directly and get rid of all of the rbtrees? It seems like that would be
> > a lot simpler...
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Jeff,
> 
> Would not we end up making an upcall for every uid/gid to sid
> and sid to uid/gid mapping needed?  

No. A request_key call will instantiate a new key in the keyring.
Further request_key calls for the same string will return a reference
to that key without upcalling.

> That would be expensive.
> The search in cached kernel cifs_sid_id structure would certainly
> be faster and if either of the caches does not have mapping, it would
> end up in making a winbind library to the server in either cases.
> Is keys API cache bigger and sticks longer and searches quicker?
> 

I'm not sure which would be quicker, but I can't imagine it'll make
that much difference. The keyring search uses RCU though and is mostly
lock-free. Concurrent processes searching that keyring shouldn't
serialize.

While I'm sure that speed is important here, concurrency would seem to
be more so. You don't want your stat() calls to serialize if you can at
all help it.

> How would keys API cache entry look like?  Right now, cifs client
> asks for either sid or id (uid or gid) and makes that association
> in the cache entries. Would keys API cache make/keep same
> association and return kernel that entire mapping?
> 

It'll look just like it does today. You compose up a string with the
key you're looking for and get the same payload you're looking for. The
only difference is that we'll always call request key from id_to_sid
and sid_to_id instead of searching the rbtree first.

I think that bottom line is that this rbtree handling code is a lot of
complexity to keep around and the benefits seem to be marginal. I've
also found a number of bugs in this code. I'll plan to send a
preliminary patchset tomorrow for discussion, but it probably needs
some testing before I formally propose it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
