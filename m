From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: DFS : Object is remote
Date: Fri, 14 Jun 2013 10:24:19 -0400
Message-ID: <20130614102419.2d6a6a9d@tlielax.poochiereds.net>
References: <A88483E8-9A66-47E6-ABF9-A1AA86B3F8D5@dashbox.com>
	<CAH2r5msFcgP-eV3NEa0j7yxXOUWWcJSSh2OMnLno8QPO+43h4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Doug Clow <doug.clow-jCDWx9PA3/RBDgjK7y7TUQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5msFcgP-eV3NEa0j7yxXOUWWcJSSh2OMnLno8QPO+43h4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Jun 2013 16:14:28 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This is a tough issue - if you are doing an ls immediately followed by
> a cd into the dfs link.   We plan to ask Microsoft next week if they
> have any ideas how to detect the following sequence - ls of directory
> which contains dfs link (client caches the dfs link for one second
> thinking it is a directory), client cd into directory.   The problem
> we have is that many variants of "ls" can potentially cause 1000s of
> stat calls to be sent over the network for one ls (queyrpathinfo or
> open/query/close) if we don't cache the output of readdir (SMB
> FindFirst/FindNext), but if we do cache then we can mistake a
> directory for a dfs link.  If that is the problem that you are running
> into - the obvious solution is to turn off metadata attribute caching
> (set actimeo=0 on mount).  Jeff suggested a patch which would prevent
> us from caching information on directories which is returned from
> FindFirst but that could cause a substantial degradation in
> performance - and we have not researched the alternatives (higher
> levels of FindFirst and QueryDir that may return hints we can use to
> decide whether to cache such as different "LinkCount" or EA size or
> some such).
> 

Any performance degradation from that patch is highly dependent on the
workload, and the degradation from that patch is less you'd get from
setting actimeo=0.

But regardless, always have to choose correctness over performance.
If we can come up with a way to deal with this that doesn't harm
performance then I'm all for it. Otherwise, this code is just plain
buggy and people will keep complaining about it.

One thing we could do to lessen the performance hit by default would be
to flip the default to 'nodfs' and require that people mount with '-o
dfs' in order to chase DFS referrals. It's a user visible change so it
would have to happen over several releases with some warning in
between...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
