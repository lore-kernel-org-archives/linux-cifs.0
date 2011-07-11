From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: -o noposixpaths
Date: Mon, 11 Jul 2011 15:06:26 -0400
Message-ID: <20110711150626.64dad9bd@tlielax.poochiereds.net>
References: <20110711142311.27b4dfce@tlielax.poochiereds.net>
	<CAH2r5mv3WOCKk4jL1YXrfvSjt52NOTgJZKatbLqB4U61iuZxRg@mail.gmail.com>
	<20110711144146.3748d1ff@tlielax.poochiereds.net>
	<CAH2r5mvR3E=E066MckaLVjpvwbcWg8BEvH+gtzpF-BSYaLvZUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvR3E=E066MckaLVjpvwbcWg8BEvH+gtzpF-BSYaLvZUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Jul 2011 13:48:20 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Jul 11, 2011 at 1:41 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Mon, 11 Jul 2011 13:32:54 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Yes, IIRC the apple guys mentioned plausible server scenarios for this
> >> (where we want to mount with unix extensions for symlinks and ownership
> >> but server can not handle posix path names)
> >>
> >> Presumably if the server file system does not support posix path names
> >> (FAT32, NTFS?) or if we want to restrict the characters (for interoperability
> >> with Windows clients accessing the same share?) - might be other cases.
> >>
> >
> > In that case though, shouldn't those servers just not set
> > CIFS_UNIX_POSIX_PATHNAMES_CAP ?
> 
> I don't think servers do that (unset the POSIX_PATHNAMES CAP for one
> share and not others, even assuming the share exports all volumes
> of the same file system type)  for the former case
> (unless they cant support posix path at all for the whole server),
> and for the latter case, not sure that the server can know enough
> information (about other clients which may mount the system)
> to unset the CAP unilaterally.
> 

This explanation doesn't make any sense. IIUC, The server should only
set the flag if it's appropriate to use posix-style pathnames on the
share. Why should the server care at all what the clients can support?

Perhaps I should phrase this question differently: Under what
circumstances would someone want to use the "noposixpaths" mount option?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
