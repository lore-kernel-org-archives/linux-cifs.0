From: "Suresh Jayaraman" <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Fri, 14 Feb 2014 02:14:56 +0000
Message-ID: <52FDC978020000F4000256F9@nat28.tlf.novell.com>
References: <52F9EDA5.1020004@assyoma.it>
 <20140211103302.6d74b90d@tlielax.poochiereds.net>
 <52FA46D5.8020904@assyoma.it>
 <20140211124536.5fdcb56f@tlielax.poochiereds.net>
 <CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q@mail.gmail.com>
 <20140213063738.1b345466@tlielax.poochiereds.net>
 <52FD0109.5030909@assyoma.it>
 <20140213144038.2101ea44@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	"James McDonough" <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Gionatan Danti" <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>,
	"Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140213144038.2101ea44-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>>> On 2/14/2014 at 01:10 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote: 
> On Thu, 13 Feb 2014 18:29:45 +0100
> Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org> wrote:
> 
>> On 02/13/2014 12:37 PM, Jeff Layton wrote:
>> >
>> > Using cache=none sort of defeats the purpose. After all Gionatan said
>> > that he was doing this specifically to use fscache, and that won't work
>> > with cache=none.
>> >
>> 
>> Surely my idea was to use FSCACHE to speed up remote access. Without it, 
>> the entire discussion is pointless...
>> 
>> > But, lets leave that aside for a moment and consider whether this could
>> > work at all. Assume we have samba set up re-share a cifs mount:
>> >
>> > Client sends an open to samba and requests an oplock. Samba then opens
>> > a file on the cifs mount, and does not request an oplock (because of
>> > cache=none). We then attempt to set a lease, which will fail because we
>> > don't have an oplock. Now you're no better off (and probably worse off)
>> > since you have zero caching going on and are having to bounce each
>> > request through an extra hop.
>> >
>> > So, suppose you disable "kernel oplocks" in samba in order to get samba
>> > to hand out L2 oplocks in this situation. Another client then comes
>> > along on the main (primary) server and changes a file. Samba is then
>> > not aware of that change and hilarity (aka data corruption) ensues.
>> >
>> 
>> Are you of the same advice for low-frequency file changes (eg: office 
>> files)?
>> 
>> What about using NFS to export the Fileserver directory, mount it (via 
>> mount.nfs) on the remote Linux box and then sharing via Samba? It is a 
>> horrible frankenstein?
>> 
> 
> You'll have similar problems with NFS.
> 
> You can't acquire leases on NFS either, so with kernel oplocks enabled
> on samba you won't ever get oplocks on there. If you turn them off (so
> that oplocks are tracked internally) you won't be aware of changes that
> occur outside of samba.
> 
>> > I just don't see how re-sharing a cifs mount is a good idea, unless you
>> > are absolutely certain that the data you're resharing won't ever
>> > change. If that's the case, then you're almost certainly better off
>> > keeping a local copy on the samba server and sharing that out.
>> >
>> 
>> After many tests, I tend to agree. Using a Fedora 20 test machine with 
>> fscache+cachefilesd as the remote Linux box, I had one kernel panic and 
>> multiple failed file copies (with Windows complaing about a "bad 
>> signature").
>> 
>> I also found this: https://bugzilla.redhat.com/show_bug.cgi?id=646224
>> Maybe the CIFS FSCACHE is not really production-grade on latest distros 
>> also?
>> 
> 
> I don't recall whether Suresh ever fixed those bugs. cifs+fsc is

If you are referring to this oops http://thread.gmane.org/gmane.linux.file-systems.cachefs.general/2961
it was fixed by the below commit

commit c902ce1bfb40d8b049bd2319b388b4b68b04bc27
Author: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Thu Jul 7 12:19:48 2011 +0100

    FS-Cache: Add a helper to bulk uncache pages on an inode

I remember verifying it by running fsstress for many hours then. I'm not sure what other bugs you are referring to.
    
> certainly not widely used, and it wouldn't surprise me if it were still
> horribly buggy.

Just curious, why would you say so? 



- Suresh Jayaraman
