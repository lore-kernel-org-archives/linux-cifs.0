From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] [mount.cifs] Mapping Windows ACLs SIDs to POSIX ACL ?
Date: Thu, 6 Oct 2011 07:54:20 -0500
Message-ID: <CADT32eLYwFmSf8P3kyj5GmGCQFvkZTYQ3Yd13nWBEiTWqYcT3A@mail.gmail.com>
References: <4E8D7788.8000209@exalead.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Xavier Roche <roche+kml2-bMN6HEGc4E9BDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E8D7788.8000209-bMN6HEGc4E9BDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 6, 2011 at 4:40 AM, Xavier Roche <roche+kml2-bMN6HEGc4E9BDgjK7y7TUQ@public.gmane.org> w=
rote:
> Hi folks,
>
> This may sound like a really stupid question, but I could not find an=
y way
> to somehow map remote Windows ACLs into POSIX ACLs (mapping users and=
 group
> SIDs to Unix mapped ids) when mounting a remote share (mount.cifs) on=
 a
> Linux box.
>
> Is is something not currently implemented ? The smbcacls tool can sho=
w the
> actual ACLs remotely, but this information is not exposed to the moun=
ted
> filesystem apparently. The acl feature of the client seem to be an ex=
tension
> to CIFS allowing to handle POSIX ACLs, not something allowing a mappi=
ng.
>
> Any insightful remark or documentation would be welcome!
>
> [ Note: the only potential issue when mapping would be related to den=
y ACLs
> (AceType =3D=3D ACCESS_DENIED_ACE_TYPE) ; something which is not mapp=
able to
> POSIX ACL. ]
> --
> To unsubscribe from this list go to the following URL and read the
> instructions: =A0https://lists.samba.org/mailman/options/samba
>
,
Currently cifs client maps DACL to Linux permission model
but not to POSIX ACL model.

You will need a kernel built with cifs_cifsacl config option
(because it is still maexperimental) and current cifs-utils package.
The manpages in that cifs-utils package will have info on how
to use mount option cifsacl and how to setup id mapping
(using winbind).

The current cifs-utils package has two binaries, getcifsacl
and setcifsacl, modeled after smbcacls.

Hope that helps. You may direct any further questions/concerns
to linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org mailing list.

Regards,

Shirish
