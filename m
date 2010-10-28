From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: remove "legacy" parm from CIFSSMBQPathInfo
Date: Thu, 28 Oct 2010 11:41:46 -0500
Message-ID: <AANLkTinOsN05m0qM56poq2Q5d6Jss6b3ZnpEXc9Z_4cV@mail.gmail.com>
References: <4CC921E7.9020403@suse.de>
	<AANLkTikpemR3PVzXSimbu-b1zn4QwQj+0VAEM9xwgYqt@mail.gmail.com>
	<4CC9A2AB.8090208@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CC9A2AB.8090208-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 28, 2010 at 11:19 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>=
 wrote:
> On 10/28/2010 09:12 PM, Steve French wrote:
>> What is the code flow then on Windows9x, OS/2 or in the EOPNOSUPP
>> case? =A0Seems strange that we don't retry with legacy or in the cas=
e
>> where the dialect (or previous call) shows that we don't support the
>> infolevel.
>>
>
> If CIFSSMBOpen fails, the callers seem to be fall back to legacy open=
 using
> SMBLegacyOpen().
>
> cifs_open()
>
> =A0 =A0 =A0 ...
> =A0 =A0 =A0 =A0if (tcon->ses->capabilities & CAP_NT_SMBS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, full_pat=
h, disposition,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 desiredAccess, CREATE=
_NOT_DIR, &netfid, &oplock, buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, c=
ifs_sb->mnt_cifs_flags
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIF=
S_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EIO; /* no NT SMB support fall=
 into legacy open below */
>
> =A0 =A0 =A0 =A0if (rc =3D=3D -EIO) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Old server, try legacy style OpenX =
*/
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SMBLegacyOpen(xid, tcon, full_p=
ath, disposition,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREATE_=
NOT_DIR, &netfid, &oplock, buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls, ci=
fs_sb->mnt_cifs_flags
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& CIFS=
_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0}
>
>
>
> --
> Suresh Jayaraman
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

This is a general comment but should cifs client be using (server)
dialect specific set of smb commands
and those smb commands specific info levels instead of sending a
command and trying downlevel / legacy
if that command failed with "operation not supported"?
