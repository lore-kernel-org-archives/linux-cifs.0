From: Jurjen Bokma <j.bokma-39IHFo8E5E0@public.gmane.org>
Subject: Re: Kerberized mount.cifs with SMB>1?
Date: Wed, 20 Aug 2014 19:16:44 +0200
Message-ID: <53F4D7FC.8020405@rug.nl>
References: <53F4ABCD.5040909@rug.nl> <1408545832.2071.6.camel@hh16.hh3.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408545832.2071.6.camel-HkULYb+WTT7YCGPCin2YbQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/20/2014 04:43 PM, steve wrote:
> On Wed, 2014-08-20 at 16:08 +0200, Jurjen Bokma wrote:
>> Hi,
>>
>> These are the commands that fail with mount error(13): Permission denied
>>
>> mount.cifs  //ws.mydomain.com/ydrive  /mnt/y
>> -omultiuser,sec=krb5,noexec,nosuid,vers=3.0
> Hi
> The upcall has nothing to go on. Get it working with cifs first:
>
> Who mounts the share? Add a domain user with a uid:gid key to the keytab
> and:
Hi Steve,

thanks for the advice.
I added a key for a domain user to the keytab. User has UID, GID, can 
log in on both Windows and Linux, and do kinit and kgetcred. Then I did 
what you advise (with cifsuser its username):
> mount.cifs //your/share /mnt -ousername=cifsuser,sec=krb5
This works, as it uses SMB1. SMB1 also works *with* all the frills. But 
it fails with 2.0, 2.1 or 3.0:

mount.cifs //your/share /mnt -ousername=cifsuser,sec=krb5,vers=3.0

No significant changes: still no trace of Kerberos in Wireshark.
Is there a way to see what keys upcall is being asked for?

I would very much like to get it working with protocol version 2.0 or later.

Best Regards
Jurjen

>
> add any multiuser frills later.
> HTH,
> Steve
>
>
