From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: CIFS: Deprecating NFS mounting syntax in mount.cifs
Date: Wed, 24 Oct 2012 08:47:05 +0200
Message-ID: <50878EE9.4030106@steve-ss.com>
References: <1350583669-12118-1-git-send-email-scott.lovenberg@gmail.com> <5086BE25.8080102@gmail.com> <5086CA29.8030305@steve-ss.com> <20121023130238.6100255d@corrin.poochiereds.net> <5086D258.1020203@steve-ss.com> <20121023133627.798100fb@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121023133627.798100fb-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 23/10/12 19:36, Jeff Layton wrote:
> On Tue, 23 Oct 2012 19:22:32 +0200
> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>
>> On 10/23/2012 07:02 PM, Jeff Layton wrote:
>>> On Tue, 23 Oct 2012 18:47:37 +0200
>>> steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>> On 10/23/2012 05:56 PM, Scott Lovenberg wrote:

>
> Well, better confusion now than confusion when it breaks. cifs really
> is just too "loose" about the syntax of things that it accepts, which
> sounds great until you have to test all of the different variations...
>

Hi
As dev's you have the power to change that. Users need to have it 'just 
work'. Simply tell us what the syntax is and we'll stick to it gladly. 
All we need is documentation which says, in plain straightforward 
English, something like:

This is the syntax allowed:
(say it in dev terms with all [:\\|//{ sort of stuff if you like)

And here are some real examples:
mount -t cifs //server/share /mnt
etc, etc.

Just make it clear and please don't give alternatives.
Cheers,
Steve
