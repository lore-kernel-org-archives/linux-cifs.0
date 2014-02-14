From: Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
Subject: Re: Problem with Samba re-share of a CIFS mount
Date: Fri, 14 Feb 2014 15:10:16 +0100
Message-ID: <52FE23C8.8060804@assyoma.it>
References: <52F9EDA5.1020004@assyoma.it>	<20140211103302.6d74b90d@tlielax.poochiereds.net>	<52FA46D5.8020904@assyoma.it>	<20140211124536.5fdcb56f@tlielax.poochiereds.net>	<CAH2r5mvQ590zaniv3cDuu+Do0N9TePasTaEFkrNSAdatTiaZ5Q@mail.gmail.com>	<20140213063738.1b345466@tlielax.poochiereds.net>	<52FD0109.5030909@assyoma.it>	<20140213144038.2101ea44@tlielax.poochiereds.net>	<52FDEF0D.8010708@assyoma.it> <20140214071724.725d8545@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	James McDonough <jmcd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>,
	"Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Gionatan Danti <g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140214071724.725d8545-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



On 02/14/2014 01:17 PM, Jeff Layton wrote:
>
> That's basically what cache=loose does with cifs. One might consider
> that to be an NFS-like caching model. That used to be the default
> behavior, but we changed it a few years ago since strict adherence
> to the protocol is really the only way to ensure that you don't end up
> with data corruption.
>
> The main problem with that is that Windows servers do lazy updates to
> their LastWriteTime (aka mtime), so watching for mtime changes is not a
> reliable method for detecting when a file has changed.

Ok

> That's correct. If you however, mount with cache=loose then fsc should
> persist across reboots as long as the files don't appear to have
> changed. That has its own problems however, particularly if you're
> dealing with Windows servers (see the comment above about lazy updates
> to LastWriteTime).

This also match with what I observed through my tests :)

> One thing you could consider is looking into BranchCache if you are
> using a relatively recent Windows infrastructure:
>
>      http://technet.microsoft.com/en-us/network/dd425028.aspx
>
> Chris Hertel had also started a project to implement something similar
> on unix-y OS' as well, but I'm not sure of the current state of that
> work.
>

True, but I can't use Windows 2008R2/2012 on the remote box (this is a 
requirement), so branchcache is not an option here. After all, in a 
Windows server to Windows server scenario, DFSR would be a very 
compelling solution (even better then branchcache, in my opinion).

Let me thank all you for the time dedicated to me and to the samba project!

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti-N44kj/XGErOonA0d6jMUrA@public.gmane.org - info-N44kj/XGErOonA0d6jMUrA@public.gmane.org
GPG public key ID: FF5F32A8
