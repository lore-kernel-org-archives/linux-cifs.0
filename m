From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs autofs krb5i
Date: Wed, 7 Nov 2012 06:56:51 -0500
Message-ID: <20121107065651.18dc9f63@tlielax.poochiereds.net>
References: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 07 Nov 2012 01:33:17 +0100
"sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:

> Hi,
> 
> I am using a test computer
> kernel 2.6.32-279.11.1.el6.x86_64
> joined to an Active directory with winbind
> 
> I am getting A kerberos Ticket with the authentication with 
> /etc/security/pam_winbind.conf
> krb5_auth = yes
> krb5_ccache_type = FILE
> 
> /etc/request-key.conf is configured like this :
> create cifs.spnego * * /usr/sbin/cifs.upcall %k
> create dns_resolver * * /usr/sbin/cifs.upcall %k
> 
> 
> I got the ticket from kerberos
> [conrad3@centad5 ~]$ klist
> Ticket cache: FILE:/tmp/krb5cc_16777217
> Default principal: conrad3-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
> 
> Valid starting Expires Service principal
> 11/07/12 00:33:48 11/07/12 10:33:48 krbtgt/DOMAIN.LOCAL-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
> renew until 11/14/12 00:33:48
> 11/07/12 00:33:48 11/07/12 10:33:48 CENTAD5$@DOMAIN.LOCAL
> renew until 11/14/12 00:33:48
> 11/07/12 00:33:48 11/07/12 10:33:48 CENTAD5$@DOMAIN.LOCAL
> renew until 11/14/12 00:33:48
> 11/07/12 00:41:57 11/07/12 10:33:48 cifs/figue-10W9mfrL9XmlP7NgNAbZLA@public.gmane.org
> renew until 11/14/12 00:33:48
> 
> 
> When i put a entry in fstab, everything is working when i do mount /partage as a user
> FSTAB
> //figue/data/conrad4 /partage cifs 
> sec=krb5i,user,nounix,file_mode=0700,dir_mode=0700,noauto 
> fs/cifs/cifs_spnego.c: key description = 
> ver=0x2;host=figue;ip4=130.120.x.xx;sec=krb5;uid=0x1000001;creduid=0x1000001;user=conrad3
> ;pid=0xc2d
> 
> 
> Howether i got a problem with fstab, it seems to not pass the creduid options,and i 
> obtain 
> CIFS VFS: cifs_mount failed w/return code = -126
> 
> Hereis my different autofs configuration, with the result in dmesg
> 
> AUTOFS
> * -fstype=cifs,sec=krb5i,user=& ://figue/data/&
> fs/cifs/cifs_spnego.c: key description = 
> ver=0x2;host=figue;ip4=130.120.xx.xx;sec=krb5;uid=0x0;creduid=0x0;user=conrad3;pid=0xc6e
> 
> * -fstype=cifs,sec=krb5i,user=&,uid=& ://figue/data/&
> fs/cifs/cifs_spnego.c: key description = 
> ver=0x2;host=figue;ip4=130.120.xx.xx;sec=krb5;uid=0x1000001;creduid=0x0;user=conrad3;pid=
> 0xd02
> 
> * -fstype=cifs,sec=krb5i,user=&,uid=&,creduid=& ://figue/data/&

That option should be "cruid=&". "creduid=" isn't a mount option.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
