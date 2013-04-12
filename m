From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: cifs multiuser sends wrong uid:gid [SOLVED]
Date: Fri, 12 Apr 2013 12:42:30 +0200
Message-ID: <5167E516.2050605@steve-ss.com>
References: <5167D1CF.2080708@steve-ss.com> <20130412062721.4768d904@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130412062721.4768d904-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/04/13 12:27, Jeff Layton wrote:
> On Fri, 12 Apr 2013 11:20:15 +0200
> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>
> ignored when you use kerberos. All that matters is the ticket.
>> - What am I doing wrong?
> At first glance, I have to wonder whether "steve2" is mapped to the
> same uid on the client and server. It seems likely that on the client
> that this krb5 user maps to 3000034, but on the server it maps to
> 3000019.
>
Hi Jeff
Yesssss! That was it. The uid was being pulled from idmap.ldb and not 
from AD. I deleted the entry for steve2 in idmap . It turns out that you 
need this:
idmap_ldb:use rfc2307 = Yes
in the [global] section of smb.conf to force the uidNumber and gidNumber 
from AD rather than idmap. Personally I think that this should be the 
default.
Thanks,
Steve
