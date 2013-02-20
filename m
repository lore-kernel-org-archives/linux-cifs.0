From: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Subject: Re: Samba mounting question
Date: Wed, 20 Feb 2013 15:58:16 -0600 (CST)
Message-ID: <870210071.7245.1361397496047.JavaMail.root@hendelman.net>
References: <20130220103014.0e18ffcb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130220103014.0e18ffcb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I've filed a bug against ubuntu/upstart in launchpad.  The bug ID is #1130781

Robert
----- Original Message -----
From: "Jeff Layton" <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Wednesday, February 20, 2013 9:30:14 AM
Subject: Re: Samba mounting question

On Tue, 19 Feb 2013 13:37:34 -0600 (CST)
"Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org> wrote:

> I forgot to check syslog and include the cifs.upcall info here....
> 
> ====
> cifs.upcall: key description: cifs.spnego;0;0;3f000000;ver=0x2;host=cifserver.mydomain.com;ip4=10.1.5.16;sec=krb5;uid=0x0;creduid=0x0;user=SERVERNAME$;pid=0x2c7
> cifs.upcall: ver=2
> cifs.upcall: host=cifserver.mydomain.com
> cifs.upcall: ip=10.1.5.16
> cifs.upcall: sec=1
> cifs.upcall: uid=0
> cifs.upcall: creduid=0
> cifs.upcall: user=SERVERNAME$
> cifs.upcall: pid=711
> cifs.upcall: krb5_get_init_creds_keytab: -1765328347
> cifs.upcall: handle_krb5_mech: getting service ticket for cifs/cifserver.mydomain.com
> cifs.upcall: cifs_krb5_get_req: unable to resolve (null) to ccache
> cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328245)
> cifs.upcall: handle_krb5_mech: getting service ticket for host/cifserver.mydomain.com
> cifs.upcall: cifs_krb5_get_req: unable to resolve (null) to ccache
> cifs.upcall: handle_krb5_mech: failed to obtain service ticket (-1765328245)
> 
> My guess is that it's trying to get cifs/host service tickets for the remote CIFS server when the network may not yet be up.
> 
> Does that look correct?
> 
> Robert
> 

Looks like setting up the credcache using the keytab failed:

    $ grep 1765328347 /usr/include/krb5/*
    /usr/include/krb5/krb5.h:#define KRB5KRB_AP_ERR_SKEW                      (-1765328347L)

...which is "Clock skew too great". So yeah, could maybe be an order of
operations thing if this actually works when the box is all the way up.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
