From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Samba] Mount CIFS with multiuser option
Date: Fri, 17 Aug 2012 10:24:42 -0400
Message-ID: <20120817102442.740e4e1e@tlielax.poochiereds.net>
References: <OF5F429226.78706E8D-ON86257A5C.007118E9-86257A5C.00718CE4@TMRIUSA.COM>
	<CADT32eLsYB2rMfuYgyQHPvP1PmZgDJ-01=cJnakEhwJH2a2YxA@mail.gmail.com>
	<20120817093456.20791005@corrin.poochiereds.net>
	<OF55744813.E8074AA0-ON86257A5D.004CE329-86257A5D.004DEB31@TMRIUSA.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Bastien Desalle <BDesalle-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF55744813.E8074AA0-ON86257A5D.004CE329-86257A5D.004DEB31-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Aug 2012 09:11:09 -0500
Bastien Desalle <BDesalle-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org> wrote:

> Ok but adding the cruid=test does not resolve the problem , here is the 
> error:
> 
> mount.cifs kernel mount options: 
> ip=172.15.1.12,unc=\\chifs1.tmriusa.com\vhdl-d,multiuser,exec._netdev,sec=krb5,cruid=,ver=1,user=Test,pass=********

So here, you're adding cruid=16777217

> mount error(126): Required key not available
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> 
> and here is my ticket : 
> [bdesalle@chifpga ~]$ klist
> Ticket cache: FILE:/tmp/krb5cc_16777220_UaSFIw

...but here, it looks like this probably owned by uid=16777220? If so,
then it looks like you're just using the wrong cruid= option.

> Default principal: Test at TMRIUSA.COM
> 
> Valid starting     Expires            Service principal
> 08/17/12 08:55:48  08/17/12 18:55:55  krbtgt/TMRIUSA.COM at TMRIUSA.COM
>         renew until 08/24/12 08:55:48
> 
> 
> All that i am trying to do is mount a windows share at boot if possible 
> without having to use any credentials because the share is open to mount 
> for everyone and then use the multiuser to allow each user to create a 
> session in the server and allow them to access the Share but according to 
> their credentials.
> 
> Is that possible ? 

So, do the mount as "anonymous" or "guest" and then allow "real" users
to acquire their own creds? That would be a nice-to-have...

But, it's not currently possible. At the moment, the cifs client
decides what sec= mode to use at mount time and that prevents the use
of mixed sec= modes on a single socket.

If someone wants to clean up that mess (and it really does need to be
cleaned up), then that would lay the groundwork for that ability.

> 
> Is there any problem with the version of cifs-utils or linux kernel 
> because i know that there is newer version ? 
> 

Not that I know of.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
