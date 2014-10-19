From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: Kerberized mount.cifs with SMB>1?
Date: Sun, 19 Oct 2014 22:25:14 +0200
Message-ID: <54441E2A.6020809@steve-ss.com>
References: <53F4ABCD.5040909@rug.nl> <1408545832.2071.6.camel@hh16.hh3.site> <53F4D7FC.8020405@rug.nl> <544417CA.3000609@rug.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jurjen Bokma <j.bokma-39IHFo8E5E0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <544417CA.3000609-39IHFo8E5E0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

 >
On 19/10/14 21:58, Jurjen Bokma wrote:
> On 08/20/2014 07:16 PM, Jurjen Bokma wrote:
>> On 08/20/2014 04:43 PM, steve wrote:
>>> On Wed, 2014-08-20 at 16:08 +0200, Jurjen Bokma wrote:
> <snip>
>>> The upcall has nothing to go on. Get it working with cifs first:
>>>
>>> Who mounts the share? Add a domain user with a uid:gid key to the keytab
>>> and:
> <snip>
>>> mount.cifs //your/share /mnt -ousername=cifsuser,sec=krb5
>> This works, as it uses SMB1. SMB1 also works *with* all the frills. But
>> it fails with 2.0, 2.1 or 3.0:
>>
>> mount.cifs //your/share /mnt -ousername=cifsuser,sec=krb5,vers=3.0
> <snip>
>
> No matter whether I use my own Samba server or a Windows (2012) server,
> vers=2.0 or vers=3.0 fails with "permission denied", while 'vers=1.0'
> works perfectly:
>
> mount.cifs //server.mydom.com/cnc  /mnt/cnc
> -overs=1.0,sec=krb5,username=cifsuser,cruid=1234567,domain=MYDOM.COM
>
> With SMB>1, no Kerberos traffic in Wireshark. If it is encapsulated,
> that would explain a part. But the ticket still would have to be granted
> by the Kerberos server, and I don't see that either. Also, request-key
> is not being called with SMB>1. So I must conclude that Steve is right:
> the upcall has nothing to go on. But how to tell it?
>
> Any hints as to why this fails with SMB>1 would be much appreciated.
>
> Best Regards

Not sure why you would want smb2 with Linux boxes. Does it improve 
performance? Loading a big jpg to gimp to a lxde client still beats a w7 
client on the same hardware.
Cheers,
