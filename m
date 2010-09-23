From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/15] cifs: have cifsFileInfo hold a reference to a
 tlink rather than tcon pointer
Date: Thu, 23 Sep 2010 05:43:39 -0700
Message-ID: <20100923054339.6f8b176f@corrin.poochiereds.net>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-10-git-send-email-jlayton@redhat.com>
	<AANLkTi=n=_R_WF8NizLo+zfcBEmzcQpBWWj=_GNEmua1@mail.gmail.com>
	<20100923053623.09bd6f33@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100923053623.09bd6f33-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 23 Sep 2010 05:36:23 -0700
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 23 Sep 2010 01:08:51 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > cifsFileInfo needs a pointer to a tcon, but it doesn't currently hold a
> > > reference to it. Change it to keep a pointer to a tcon_link instead and
> > > hold a reference to it.
> > 
> > Nice work on these patches but they do end up more complex than I expected
> > (may be unavoidable).
> > 
> > Before committing the last set - are we sure that there is no way we could have
> > done the list of tids/uids off the same tcon or simplify.  For example (may be
> > impractical, but worth considering) - if we limited many of these changes to
> > init_smb itself - if in init_smb we see a request from local uid that does not
> > have an smb uid negotiated, we negotiate/sessionsetup/tcon
> > there (as we do reconnect today in some cases) to get the new tid - this does
> > have the problem of not knowing the uid of the opener of a file though so
> > perhaps not problem.
> > 
> > Your way may be better - but it is a much bigger change.
> > 
> 
> So essentially what you're proposing is to change the current model
> where we track one session per cifsSesInfo struct and one tcon per
> cifsTconInfo struct to a model where you'd have multiple UID/TID's
> tracked for each?
> 
> I suppose that would be one way to do that, but I'm not sure how you
> would implement such a model without ripping and replacing a lot of
> code. At that point not only does cifs_sb->tcon make no more sense, but
> tcon->ses doesn't make any. Doing so would also break the current
> hierarchy where a tcon is on the list of one and only one SMB session.
> 
> I think taking that approach would lead to a larger change than this
> one. This patchset builds upon the current hierarchical model that
> we've successfully used for the last few years.
> 

I should also point out that much of the complexity here comes from the
addition of usage refcounting for the tlink structs. This is necessary
if we want to avoid keeping idle sessions active on the server. You
can't tear down a tcon/session that's still in use, and you won't know
whether it's in use unless you keep track of that information. We'd
still need to do something similar even with the model you're
suggesting.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
