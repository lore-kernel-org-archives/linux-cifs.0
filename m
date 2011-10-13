From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: Should multiuser imply "noperm" mount option?
Date: Thu, 13 Oct 2011 21:31:38 +0200
Message-ID: <20111013193137.GA17107@cobija.connexer.com>
References: <CAH2r5mvEq3nrx=Qu0gkn9Oaa-WYK-EuJqqNKYLQOY4QmsrgHXA@mail.gmail.com>
 <20111013143409.7b4ec34a@barsoom.rdu.redhat.com>
 <CAH2r5msBBUPAAKenRf-944cZDha8AkQMN-MR28x_SSwyJYY5qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5msBBUPAAKenRf-944cZDha8AkQMN-MR28x_SSwyJYY5qA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi!

On Thu, Oct 13, 2011 at 01:33:59PM -0500, Steve French wrote:
> Wish it were easier to setup kerberos (and that we had Samba 4 DC out)
> so we could turn multiuser on by default ... (or if we could fix it
> for ntlmv2)

We're actually just rolling a kerberos+multiuser+autofs based system
out now at a customer, based off of a 2.6.38 kernel with cifs backported
from up to 3.0 or so.  for the most part have been getting pretty
positive feedback.  I don't think there's been serious I/O stress testing
done yet, but for the casual "open a spreadsheet here, dump a zipfile there"
work that most folks are using it for, it works pretty well.  Network
blips cause the occasional hang, but I blame that more on autofs than
the cifs driver.

One *gotcha* with how it works right now though (if i can make a slight
detour from the topic) is that the account/service doing the
mounting needs credentials to perform the initial mount in addition to
the kerberized users and their individual I/O calls, which makes things
a bit trickier in a multi-user setup where you want the mounts available
and already there for anyone logged in.

We're solving this so far by a little hackery to the autofs init script
and a cronjob to get it to use the machine keytab (all clients are
joined to an AD domain).  But it means that we've had to loosen filesystem
permissions on shares a bit, allowing all domain computers to access the
shares, which we're not super happy about.  But we haven't been able
to think of something smarter.  We could use a system account, but then
every machine would have access to the account and... same situation.
Anyone else have ideas?

Oh, and I'm not sure it's documented but with the current SMB calls the
needed permissions for this first step are "Traverse directory" up-to and
including the path being mounted, and "Read attributes / read extended
attributes" on the target folder (does not need to be recursively applied
though, and does *not* need read/write access).


	sean
