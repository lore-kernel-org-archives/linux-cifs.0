From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] cifs: revalidate directories instiantiated via
 FIND_* in order to handle DFS referrals
Date: Tue, 15 Jan 2013 14:47:31 -0500
Message-ID: <20130115144731.566066a0@tlielax.poochiereds.net>
References: <1358276491-4835-1-git-send-email-jlayton@redhat.com>
	<CAH2r5muYbaZewY3WjLXWF54R7DSPDswU9x1U87xj=2qFXnt5dQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muYbaZewY3WjLXWF54R7DSPDswU9x1U87xj=2qFXnt5dQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Jan 2013 13:34:07 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jan 15, 2013 at 1:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > We've had a long-standing problem with DFS referral points. CIFS servers
> > generally try to make them look like directories in FIND_FIRST/NEXT
> > responses. When you go to try to do a FIND_FIRST on them though, the
> > server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
> > manifests as spurious EREMOTE errors back to userland.
> 
> Why would we ever return STATUS_PATH_NOT_COVERED (converted to
> EREMOTE)?  If we do a find first on a directory and get status path
> not covered - why don't we simply chase the DFS referral then rather
> than greatly slow down findfirst?
> 

Note that I marked this RFC since I'm not 100% sold on the approach...

This doesn't slow down FIND_FIRST, it just means that we revalidate the
inode before trying to use it. The scenario goes something like this:

Suppose we have a share like this:

    //server/share

...and under the top level of that share is a DFS referral "dfslink".
Now, we go and do a readdir on the top level directory and that causes
a FIND_FIRST to go out on the wire. The response has "dfslink" in it,
but it looks just like a directory. So, we instantiate a new dentry for
it with a directory inode, based on the info in the FIND_FIRST response.

Now, we go to try and do a readdir() on "dfslink". We do an opendir()
which doesn't cause any sort of call to go out onto the wire because we
just instantiated the dentry. So, we end up doing a FIND_FIRST
against //server/share/dfslink, and get back STATUS_PATH_NOT_COVERED.

This patch fixes that by forcing the client to revalidate the dentry at
lookup time (i.e. when the directory is opened in the above example).
The lookup will be redone (via QPathInfo) and we'll end up chasing the
referral as expected.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
