From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Autofs cifs mounts via Kerberos
Date: Tue, 7 Dec 2010 13:52:40 -0500
Message-ID: <20101207135240.171cb2df@tlielax.poochiereds.net>
References: <7A014DE1422A694A89BA2CE1F5692DF503831D00@niihau.lionsgate.ca>
	<20101207081239.73227aec@tlielax.poochiereds.net>
	<7A014DE1422A694A89BA2CE1F5692DF503831D02@niihau.lionsgate.ca>
	<AANLkTinKhXQh0+nY-MwDrs+FoxEkNV1opXzzymgiKyKW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Carter, Joel" <JoelC-RAygmcqizRRkKYb1c3iuxNBPR1lH4CV8@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinKhXQh0+nY-MwDrs+FoxEkNV1opXzzymgiKyKW-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 7 Dec 2010 11:11:08 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Dec 7, 2010 at 11:03 AM, Carter, Joel <JoelC-RAygmcqizRRkKYb1c3iuxNBPR1lH4CV8@public.gmane.org> wrote:
> > Hi Jeff.
> >
> > Yes I think you are right that it's race condition between the Kerberos
> > ticket being stored and the automounter attempting to use that ticket.
> >
> > Thanks for the reminder of sec=krb5 maturity status, I wasn't aware of
> > that. This is for a production system so I should probably stay away
> > from it. That said, do you know if this is possible with RHEL5 using
> > smbfs (sorry - off topic) or should I push this off until we move to
> > RHEL6? It's not a must have, just trying to make our AD/RHEL integration
> > as tight as possible. I found your bugzilla entry as well, I'll keep my
> > eyes on it.
> 
> smbfs doesn't support krb5.
> 

Actually, I think it does. Socket creation and setup in smbfs was
essentially offloaded to userspace so as long as libsmbclient supported
it, it did too. I never really messed with it though so I can't vouch
for its robustness.

The point is moot though since RHEL5 didn't ship with smbfs enabled.

> I did get the impression that Jeff did a good job of the Kerberos
> backport for RHEL5 though.
> 

Thanks, it basically works. There are some differences between how
RHEL5 and RHEL6/mainline handle the uid= option however.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
