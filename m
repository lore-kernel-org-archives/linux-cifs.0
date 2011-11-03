From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 3 Nov 2011 13:40:40 -0500
Message-ID: <CADT32eJ2an_i6S-J=5ytaFgmsbL-pXgdyGyTRmJA-Yyy0JV24A@mail.gmail.com>
References: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
	<81357503-810A-477A-A320-D39F2CD69547@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Unix Support <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <81357503-810A-477A-A320-D39F2CD69547-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 3, 2011 at 10:42 AM, Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org> w=
rote:
> Hi,
>
> I should add that we are using iocharset=3Dutf8 mount option which me=
ans that the dcache hash/compare functions done in the cifs module do n=
ot work because it uses nls_tolower() and nls_strnicmp() both of which =
for utf8 NLS in the kernel do not do anything at all and effectively be=
have case sensitively!
>
> Thus this bug/problem in all likelyhood only affects utf8 iocharset u=
sers on a case-insensitive but case-preserving CIFS server that does no=
t support server inode numbers.

I tried iocharset=3Diso8859-1 and nls_tolower/charset2lower and
nls_toupper/charset2lower  functions work just fine.
But not for iocharset=3Dutf8.

>
> That probably explains why it has not been noticed before!
>
> We need utf8 thus we still need to fix this issue.
>
> Best regards,
>
> =A0 =A0 =A0 =A0Anton
>
> On 3 Nov 2011, at 15:20, Anton Altaparmakov wrote:
>
>> Hi,
>>
>> Our CIFS server problems seem to have no end=85 =A0The Novell CIFS s=
erver does not support server inode numbers (when I try the mount optio=
n I get the message it is being turned off as server does not support i=
t) and thus each inode gets a different number each time it is accessed=
 and it gets a different number again for each readdir call.
>>
>> The fun happens with rename() when the rename source and target only=
 differ in case, e.g.
>>
>> =A0 =A0 =A0 touch foo
>> =A0 =A0 =A0 mv foo Foo
>>
>> The result? =A0Because of the difference in inode numbers, the reque=
st gets through to the CIFS module which promptly does:
>>
>> =A0 =A0 =A0 cifs_unlink(target_dir, target_dentry)
>> =A0 =A0 =A0 rc =3D cifs_do_rename(=85)
>>
>> And because the cifs_unlink() just removed the source of the rename =
(as it is the same as the target), "rc" comes back as -ENOENT.
>>
>> And indeed the file is gone so we just lost the user's file for ever=
=2E =A0)-:
>>
>> We are tossing around ideas how to fix this but we would be interest=
ed in your input as to what you think the fix should be.
>>
>> In any case this probably should be fixed in the standard kernel CIF=
S module, too, and not just for us locally as this presumably affects a=
nyone who is using the CIFS module against case-insensitive, non-server=
-inode-number-supporting CIFS servers...
>>
>> Best regards,
>>
>> =A0 =A0 =A0 Anton
>
> --
> Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
> Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
> Linux NTFS maintainer, http://www.linux-ntfs.org/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
