From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Autofs cifs mounts via Kerberos
Date: Tue, 7 Dec 2010 11:11:08 -0600
Message-ID: <AANLkTinKhXQh0+nY-MwDrs+FoxEkNV1opXzzymgiKyKW@mail.gmail.com>
References: <7A014DE1422A694A89BA2CE1F5692DF503831D00@niihau.lionsgate.ca>
	<20101207081239.73227aec@tlielax.poochiereds.net>
	<7A014DE1422A694A89BA2CE1F5692DF503831D02@niihau.lionsgate.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Carter, Joel" <JoelC-RAygmcqizRRkKYb1c3iuxNBPR1lH4CV8@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7A014DE1422A694A89BA2CE1F5692DF503831D02-Xb8fhGBsZ0XkezyJQHggdywD8/FfD2ys@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Dec 7, 2010 at 11:03 AM, Carter, Joel <JoelC-RAygmcqizRRkKYb1c3iuxNBPR1lH4CV8@public.gmane.org> wrote:
> Hi Jeff.
>
> Yes I think you are right that it's race condition between the Kerberos
> ticket being stored and the automounter attempting to use that ticket.
>
> Thanks for the reminder of sec=krb5 maturity status, I wasn't aware of
> that. This is for a production system so I should probably stay away
> from it. That said, do you know if this is possible with RHEL5 using
> smbfs (sorry - off topic) or should I push this off until we move to
> RHEL6? It's not a must have, just trying to make our AD/RHEL integration
> as tight as possible. I found your bugzilla entry as well, I'll keep my
> eyes on it.

smbfs doesn't support krb5.

I did get the impression that Jeff did a good job of the Kerberos
backport for RHEL5 though.

-- 
Thanks,

Steve
