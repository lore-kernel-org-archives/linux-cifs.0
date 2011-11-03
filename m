From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 3 Nov 2011 18:34:00 -0500
Message-ID: <CAH2r5mtye1DHKbPYMKnkcZjfVKBqek=a7DWGPJvxCsoLEhzDXA@mail.gmail.com>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
	<81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
	<20111103134056.178ee9e3@barsoom.rdu.redhat.com>
	<A2505FE2-FE28-4C23-879E-357C9D3AA03F@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Unix Support <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A2505FE2-FE28-4C23-879E-357C9D3AA03F-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

What is the actual sequence of events from the wire perspective (the
actual smb requests sent)?


On Thu, Nov 3, 2011 at 6:25 PM, Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> wr=
ote:
> Hi,
>
> On 3 Nov 2011, at 17:40, Jeff Layton wrote:
>> On Thu, 3 Nov 2011 15:42:13 +0000 Anton Altaparmakov <aia21-KWPb1pKIrII@public.gmane.org=
k> wrote:
>>>
>>> I should add that we are using iocharset=3Dutf8 mount option which =
means that the dcache hash/compare functions done in the cifs module do=
 not work because it uses nls_tolower() and nls_strnicmp() both of whic=
h for utf8 NLS in the kernel do not do anything at all and effectively =
behave case sensitively!
>>>
>>> Thus this bug/problem in all likelyhood only affects utf8 iocharset=
 users on a case-insensitive but case-preserving CIFS server that does =
not support server inode numbers.
>>>
>>> That probably explains why it has not been noticed before!
>>>
>>> We need utf8 thus we still need to fix this issue.
>
>> I'm confused...
>>
>> If the filesystem being served out by the server is using utf8, then
>> how is it handling the case-insensitivity?
>
>
> The file system being served is NSS (the Netware one but now mounted =
on Open Enterprise Server with Linux kernel rather than actual Netware =
kernel). =A0No idea how it works I am afraid. =A0It supports lots of di=
fferent namespaces as well as being case-insensitive and case preservin=
g when using the LONG name space (which is now being served through CIF=
S).
>
> If it was NTFS or exFAT I could tell you exactly how they work (each =
volume has an upcase table mapping the 65536 UCS-2 Unicode characters t=
o their upper case equivalents and each 16-bit character is upper-cased=
 individually, more recently Windows has switched to using UTF-16 inste=
ad of UCS-2 and the upcase table changed when that happened though it r=
emained the same size and I think for file system purposes the fact tha=
t there are surrogates in the above UCS-2 =A0 Unicode range is simply i=
gnored)...
>
> Best regards,
>
> =A0 =A0 =A0 =A0Anton
> --
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
>
>



--=20
Thanks,

Steve
