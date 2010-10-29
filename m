From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: remove "legacy" parm from CIFSSMBQPathInfo
Date: Fri, 29 Oct 2010 09:25:16 +0530
Message-ID: <4CCA45A4.8030600@suse.de>
References: <4CC921E7.9020403@suse.de>	<AANLkTikpemR3PVzXSimbu-b1zn4QwQj+0VAEM9xwgYqt@mail.gmail.com>	<4CC9A2AB.8090208@suse.de>	<AANLkTinOsN05m0qM56poq2Q5d6Jss6b3ZnpEXc9Z_4cV@mail.gmail.com> <AANLkTimoCvWFbYj+TfCFA-nqd6H=8DTN_e-dw8Hoo_7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimoCvWFbYj+TfCFA-nqd6H=8DTN_e-dw8Hoo_7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/28/2010 11:17 PM, Steve French wrote:
> On Thu, Oct 28, 2010 at 11:41 AM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Thu, Oct 28, 2010 at 11:19 AM, Suresh Jayaraman <sjayaraman@suse.=
de> wrote:
>>> On 10/28/2010 09:12 PM, Steve French wrote:
>>>> What is the code flow then on Windows9x, OS/2 or in the EOPNOSUPP
>>>> case? =EF=BF=BDSeems strange that we don't retry with legacy or in=
 the case
>>>> where the dialect (or previous call) shows that we don't support t=
he
>>>> infolevel.
>>>
>>> If CIFSSMBOpen fails, the callers seem to be fall back to legacy op=
en using
>>> SMBLegacyOpen().
>>>
>>> cifs_open()
>>>
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD ...
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (tcon->ses->capabilities =
& CAP_NT_SMBS)
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BDrc =3D CIFSSMBOpen(xid, tcon, full_path, disposition,
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD desiredAccess, CREAT=
E_NOT_DIR, &netfid, &oplock, buf,
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD cifs_sb->local_nls, =
cifs_sb->mnt_cifs_flags
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD & CIFS_MOUNT_MAP_SPECIAL_CHR);
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDelse
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BDrc =3D -EIO; /* no NT SMB support fall into legacy open below=
 */
>>>
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDif (rc =3D=3D -EIO) {
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD/* Old server, try legacy style OpenX */
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BDrc =3D SMBLegacyOpen(xid, tcon, full_path, disposition,
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDdesiredAccess, CREATE=
_NOT_DIR, &netfid, &oplock, buf,
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BDcifs_sb->local_nls, c=
ifs_sb->mnt_cifs_flags
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD=
 =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD& CIFS_MOUNT_MAP_SPECIAL_CHR);
>>> =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD}
>>>
>> This is a general comment but should cifs client be using (server)
>> dialect specific set of smb commands
>> and those smb commands specific info levels instead of sending a
>> command and trying downlevel / legacy
>> if that command failed with "operation not supported"?
>=20
> We can do the former for smb2, but not for cifs unfortunately.
>=20
> For cifs there are lots of cases where a dialect doesn't support an
> infolevel it should (or even viceversa).

So that means this patch is applicable to CIFS as is, right?


--=20
Suresh Jayaraman
