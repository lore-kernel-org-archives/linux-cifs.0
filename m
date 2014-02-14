From: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Fri, 14 Feb 2014 11:25:17 +0100
Message-ID: <52FDEF0D.8010708@assyoma.it>
References: <52F9EDA5.1020004@assyoma.it>	<20140211103302.6d74b90d@tlielax.poochiereds.net>	<52FA46D5.8020904@assyoma.it>	<20140211124536.5fdcb56f@tlielax.poochiereds.net>	<CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q@mail.gmail.com>	<20140213063738.1b345466@tlielax.poochiereds.net>	<52FD0109.5030909@assyoma.it> <20140213144038.2101ea44@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	James McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140213144038.2101ea44-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On 02/13/2014 08:40 PM, Jeff Layton wrote:
>
> You'll have similar problems with NFS.
>
> You can't acquire leases on NFS either, so with kernel oplocks enabled
> on samba you won't ever get oplocks on there. If you turn them off (so
> that oplocks are tracked internally) you won't be aware of changes that
> occur outside of samba.

Ok, so it is the SMB protocol which is intrinsically unfriendly to 
persistent caches. Maybe it is for this very same reason that Microsoft 
suggest to use the "offline files" feature only where files change on 
one single side (eg: laptop).

> I don't recall whether Suresh ever fixed those bugs. cifs+fsc is
> certainly not widely used, and it wouldn't surprise me if it were still
> horribly buggy.
>
> fscache is somewhat at odds with the fundamental caching model of the
> cifs protocol. The whole point of fscache is to speed up access to
> frequently read files when a client starts up, and to reduce load on the
> server in these cases.
>
> For NFS, that works because we rely on looking at inode attributes to
> determine whether the file has changed (i.e. the mtime, size, NFSv4
> change attribute). So, with NFS we can reasonably tell whether a file
> has changed across a client remount.
>
> For CIFS, things are different. The protocol basically states that you
> should only cache file data if you hold an oplock, and you only get an
> oplock when you open a file. When you first bring up a client, you
> don't hold one, so you really should just toss out any data that you're
> caching...thereby making fscache sort of pointless.

What about not having an oplock but watch at file attributes (eg: last 
modified date)? I think cache=loose do this same thing. The man page say 
that Windows can be "lazy" to update file's attribute, but I think that 
we are speaking of some seconds at most. In scenarios with low 
cross-editing probability, this some-second window seems reasonable 
small. I am missing something?

> Now, there is some argument that you can use fsc and still follow the
> protocol by using it as "swap for pagecache". IOW, you could use it
> to cache a large amount of open file data than you have memory. I'm not
> aware of anyone having actually tested to see if that works however.
>

Mmm... this "swap for pagecache" will not survive reboot, right? Or, 
better stated, the cache _will_ survive, but by not having any oplock, 
the client will request the live data from the server, right?

Thank you.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org - info-N44kj/XGErOonA0d6jMUrA@public.gmane.org
GPG public key ID: FF5F32A8
