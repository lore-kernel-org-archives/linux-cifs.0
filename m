From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove "legacy" parm from CIFSSMBQPathInfo
Date: Thu, 28 Oct 2010 12:47:22 -0500
Message-ID: <AANLkTimoCvWFbYj+TfCFA-nqd6H=8DTN_e-dw8Hoo_7g@mail.gmail.com>
References: <4CC921E7.9020403@suse.de>
	<AANLkTikpemR3PVzXSimbu-b1zn4QwQj+0VAEM9xwgYqt@mail.gmail.com>
	<4CC9A2AB.8090208@suse.de>
	<AANLkTinOsN05m0qM56poq2Q5d6Jss6b3ZnpEXc9Z_4cV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinOsN05m0qM56poq2Q5d6Jss6b3ZnpEXc9Z_4cV-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 28, 2010 at 11:41 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Oct 28, 2010 at 11:19 AM, Suresh Jayaraman <sjayaraman@suse.d=
e> wrote:
>> On 10/28/2010 09:12 PM, Steve French wrote:
>>> What is the code flow then on Windows9x, OS/2 or in the EOPNOSUPP
>>> case? =A0Seems strange that we don't retry with legacy or in the ca=
se
>>> where the dialect (or previous call) shows that we don't support th=
e
>>> infolevel.
>>>
>>
>> If CIFSSMBOpen fails, the callers seem to be fall back to legacy ope=
n using
>> SMBLegacyOpen().
>>
>> cifs_open()
>>
>> =A0 =A0 =A0 ...
>> =A0 =A0 =A0 =A0if (tcon->ses->capabilities & CAP_NT_SMBS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, full_pa=
th, disposition,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREAT=
E_NOT_DIR, &netfid, &oplock, buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, =
cifs_sb->mnt_cifs_flags
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CI=
=46S_MOUNT_MAP_SPECIAL_CHR);
>> =A0 =A0 =A0 =A0else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; /* no NT SMB support fal=
l into legacy open below */
>>
>> =A0 =A0 =A0 =A0if (rc =3D=3D -EIO) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Old server, try legacy style OpenX=
 */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SMBLegacyOpen(xid, tcon, full_=
path, disposition,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREATE=
_NOT_DIR, &netfid, &oplock, buf,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls, c=
ifs_sb->mnt_cifs_flags
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& CIF=
S_MOUNT_MAP_SPECIAL_CHR);
>> =A0 =A0 =A0 =A0}
>>
>>
>>
>> --
>> Suresh Jayaraman
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> This is a general comment but should cifs client be using (server)
> dialect specific set of smb commands
> and those smb commands specific info levels instead of sending a
> command and trying downlevel / legacy
> if that command failed with "operation not supported"?

We can do the former for smb2, but not for cifs unfortunately.

=46or cifs there are lots of cases where a dialect doesn't support an
infolevel it should (or even viceversa).   Part of this difficulty
mapping levels to dialects is presumably due to lack of authoritative
documentation for cifs when some of the server developers were doing
initial cifs development years ago - even so there are cases where we
can make assumptions (based on feedback from 7 years of test events)
but it depends on the operation.

--=20
Thanks,

Steve
