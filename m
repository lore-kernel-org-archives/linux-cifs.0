From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Tue, 23 Oct 2012 13:32:00 -0400
Message-ID: <CAFB9KM2oZJbCOr-GeL3gDASyq2CmF61zMk4uUgDQFucJ013jWA@mail.gmail.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com>
	<5086BE25.8080102@gmail.com>
	<5086CA29.8030305@steve-ss.com>
	<20121023130238.6100255d@corrin.poochiereds.net>
	<5086D258.1020203@steve-ss.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5086D258.1020203-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 23, 2012 at 1:22 PM, steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
> On 10/23/2012 07:02 PM, Jeff Layton wrote:
>>
>> On Tue, 23 Oct 2012 18:47:37 +0200
>> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>>
>>> On 10/23/2012 05:56 PM, Scott Lovenberg wrote:
>>> Currently, we have this map: * -fstype=cifs,rw,sec=krb5
>>> ://myserver/myshare/&
>>
>> Does that really work? What purpose does the ':' serve there?
>
> Yes. They always put a ':' before the mount except for the default NFS. I
> took a look at the example /etc/auto.misc which comes (commented out) with
> openSUSE. They always put a ':'.

I double checked this.  The ':' is a token for the automounter that
tells it that it's a local device.  You could probably remove that
character.  http://www.faqs.org/docs/Linux-mini/Automount.html#s4

-- 
Peace and Blessings,
-Scott.
