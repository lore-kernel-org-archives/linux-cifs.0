From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: Kerberized mount.cifs with SMB>1?
Date: Wed, 20 Aug 2014 16:43:52 +0200
Message-ID: <1408545832.2071.6.camel@hh16.hh3.site>
References: <53F4ABCD.5040909@rug.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jurjen Bokma <j.bokma-39IHFo8E5E0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53F4ABCD.5040909-39IHFo8E5E0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2014-08-20 at 16:08 +0200, Jurjen Bokma wrote:
> Hi,
> 

> 
> These are the commands that fail with mount error(13): Permission denied
> 
> mount.cifs  //ws.mydomain.com/ydrive  /mnt/y 
> -omultiuser,sec=krb5,noexec,nosuid,vers=3.0

Hi
The upcall has nothing to go on. Get it working with cifs first:

Who mounts the share? Add a domain user with a uid:gid key to the keytab
and:

mount.cifs //your/share /mnt -ousername=cifsuser,sec=krb5

add any multiuser frills later.
HTH,
Steve
