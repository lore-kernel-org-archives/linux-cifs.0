From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs autofs krb5i
Date: Fri, 16 Nov 2012 21:01:41 -0500
Message-ID: <20121116210141.33f983dc@corrin.poochiereds.net>
References: <1654211045.441511.1352248396994.JavaMail.www@wwinf8310>
	<20121107065651.18dc9f63@tlielax.poochiereds.net>
	<31084258.1033086.1353105472548.JavaMail.www@wwinf8315>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31084258.1033086.1353105472548.JavaMail.www@wwinf8315>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 16 Nov 2012 23:37:52 +0100
"sergio.conrad" <sergio.conrad-QFKgK+z4sOrR7s880joybQ@public.gmane.org> wrote:

> Hi,
> 
> I am able to connect to cifs share on Windows 2008 with Kerberos security via autofs with 
> this map : 
> * -
> fstype=cifs,sec=krb5i,user=&,uid=&,cruid=&,file_mode=0700,dir_mode=0700,nounix,noserverin
> o ://figue/data/&
> 
> Is it working fine with alpha numeric login 
> fs/cifs/cifs_spnego.c: key description = 
> ver=0x2;host=figue;ip4=130.120.8.11;sec=krb5;uid=0x1000001;creduid=0x1000001;user=conrad3
> ;pid=0xd331
> 
> 
> But if i use numeric only login like 12345678 i have a problem :
> fs/cifs/cifs_spnego.c: key description = 
> ver=0x2;host=figue;ip4=130.120.8.11;sec=krb5;uid=0xbc614e;creduid=0xbc614e;user=12345678;
> pid=0xe5db
> fs/cifs/sess.c: ssetup freeing small buf ffff88003a838140
> CIFS VFS: Send error in SessSetup = -126
> fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 223) rc = -126
> fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 222) rc = -126
> CIFS VFS: cifs_mount failed w/return code = -126
> 
> What can I do to solve this issue ?


cifs.upcall logs at daemon.debug level. Set up syslog to log that and
you'll get some details about what it's doing.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
