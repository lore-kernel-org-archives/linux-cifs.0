From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Samba] Mount CIFS with multiuser option
Date: Fri, 17 Aug 2012 09:34:56 -0400
Message-ID: <20120817093456.20791005@corrin.poochiereds.net>
References: <OF5F429226.78706E8D-ON86257A5C.007118E9-86257A5C.00718CE4@TMRIUSA.COM>
	<CADT32eLsYB2rMfuYgyQHPvP1PmZgDJ-01=cJnakEhwJH2a2YxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Bastien Desalle <BDesalle-EIlpL8JyKVZBDgjK7y7TUQ@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLsYB2rMfuYgyQHPvP1PmZgDJ-01=cJnakEhwJH2a2YxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Aug 2012 16:42:37 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Aug 16, 2012 at 3:40 PM, Bastien Desalle <BDesalle-EIlpL8JyKVZBDgjK7y7TUQ@public.gmane.org> wrote:
> > Hi,
> >
> > Overview: Running redhat 6.3 kernel 2.6.32-279.
> >               cifs-utils : 4.8.1-10
> >
> > server is connected to Active Directory and working fine. Users from AD can
> > log in the server and have their /home created if it is the first time.
> > and then when I do a Klist i have a ticket.
> >
> >     Default principal: test-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org
> >
> >     Valid starting     Expires            Service principal
> >     08/16/12 14:34:27  08/17/12 00:34:28  krbtgt/TMRIUSA.COM-yHMt7BE/qW2uvtTkCOosKA@public.gmane.org
> >             renew until 08/23/12 14:34:27
> >
> > then my goal is to mount at boot time. windows share that then will be
> > available to all the users connected to the linux server. But i am having
> > hard time doing it. because i encounter the following problems.
> >
> > 1) i am unable to mount the windows share without using a user and password
> > from the AD even if the share does not required a password to be mounted
> > because accessible to everyone.
> >     //server/drive  /media/M  cifs  rw,exec._netdev,auto  0  0
> >
> > 2) bypassing this problem by using a test user i am able to mount it.
> >     //server/drive  /media/M  cifs
> > user=test,password=test,rw,exec._netdev,auto  0  0
> >
> > at this point i tried to use the multiuser option and sec=krb5 i have the
> > following error.
> >     mount error(126): Required key not available
> >
> > which i don't understand because klist is telling me that i have a ticket.
> 
> I do not think this is the kerberos ticket complain, it is about the
> keys in the kernel keyring that are missing/not_registered.
> 

Correct...

If you want to mount with sec=krb5, the upcall needs to be able to
figure out what user's credcache you want to use. When you did the
kinit above, what user did you do it as?

If it was user "test", then you should also add the option "cruid=test"
when mounting. If you don't pass in a "cruid=" option, then the kernel
assumes that it should ask the upcall to look for a credcache owned by
the mounting user (root in your case).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
