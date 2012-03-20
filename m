From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Issue with CIFS mounting of DFS ROOT mount when redirecting from
 one domain controller to the next
Date: Tue, 20 Mar 2012 09:37:43 -0500
Message-ID: <CAH2r5mtG3CPEe5mipP=Y77kxvWVERhf43wwJdbdo=oxY1hh1DA@mail.gmail.com>
References: <7B8A1CD01838314387266CEE4CEB05600A136B3AD0@EX-002.mail.navisite.com>
	<20120320063826.78a89b3d@tlielax.poochiereds.net>
	<20120320064338.0632ee61@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120320064338.0632ee61-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Wouldn't this need stable as well - the superblock simplification
patch went in 10 months ago?

On Tue, Mar 20, 2012 at 5:43 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 20 Mar 2012 06:38:26 -0400
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Mon, 19 Mar 2012 18:21:28 -0400
>> Thomas Hadig <thomas.hadig-O4KOoiensp/QT0dZR+AlfA@public.gmane.org> wrote:
>>
>> > Hi,
>> >
>> > I am using the CIFS module from Linux kernel 3.2.9.
>> >
>> > We have the following setup:
>> >
>> > In DNS,=A0 domain.net resolves to our secondary AD server=A0=A0 ad=
2.domain.net
>> > Our primary domain controller is ad1.domain.net and has a DFS redi=
rection set up from \\ad1\share\Users to \\files\share\Users.
>> >
>> > When mounting =A0=A0=A0\\domain.net\share\Users=A0 I get an error.
>> >
>> > I traced this down to the cifs_mount function in fs/cifs/connect.c=
=2E In there, rc is set to 0 at the beginning but never reset.
>> > In short, adding an rc=3D0; line after the label try_mount_again: =
fixes the issue.
>> >
>> > Detailed information:
>> > - Connecting to \\domain.net\share\Users =A0connects to ad2 with a=
 SMB_COM_NEGOTIATE, SMB_COM_SESSION_SETUP_ANDX, and SMB_COM_TREE_CONNEC=
T_ANDX.
>> > - SMB_COM_TREE_CONNECT_ANDX fails with STATUS_BAD_NETWORK_NAME cau=
sing rc to be non-zero and jumping to remote_path_check:
>> > - It connects to ad2's IPC$ share and retrieves the DFS_REFERRAL w=
hich leads to \\ad1\share and jumps to try_mount_again:
>> > - It closes the samba session to ad2.
>> > - Now, it connects to ad1 with SMB_COM_NEGOTIATE, SMB_COM_SESSION_=
SETUP_ANDX, and SMB_COM_TREE_CONNECT_ANDX.
>> > - This time, it succeeds and continues with SMB_COM_TRANSACTION2/ =
TRANS2_QUERY_FS_INFORMATION/SMB_QUERY_FS_DEVICE_INFO and SMB_QUERY_FS_A=
TTRIBUTE_INFO.
>> > - It comes to:
>> > =A0=A0=A0=A0=A0=A0=A0 /* check if a whole path is not remote */
>> > =A0=A0=A0=A0=A0=A0=A0 if (!rc && tcon) {
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* build_path_to_roo=
t works only when we have a valid tcon */
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 where rc is still no=
n-zero and, thus, does NOT check again for a DFS_REFERRAL.
>> > - I closes the samba session to ad1 and exists with the -6 mount e=
rror from the initial tree connect.
>> >
>> > The correct behavior would be to reset rc to 0 when connecting to =
a different samba session.
>> >
>> >
>> > Patch info:
>> >
>> > =A0=A0=A0=A0=A0=A0=A0 rc =3D bdi_setup_and_register(&cifs_sb->bdi,=
 "cifs", BDI_CAP_MAP_COPY);
>> > =A0=A0=A0=A0=A0=A0=A0 if (rc)
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;
>> >
>> > #ifdef CONFIG_CIFS_DFS_UPCALL
>> > try_mount_again:
>> > =A0=A0=A0=A0=A0=A0=A0 /* cleanup activities if we're chasing a ref=
erral */
>> > =A0=A0=A0=A0=A0=A0=A0 if (referral_walks_count) {
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (tcon)
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 cifs_put_tcon(tcon);
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (pSesInfo)
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=
=A0cifs_put_smb_ses(pSesInfo);
>> >
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0FreeXid(xid);
>> > =A0=A0=A0=A0=A0=A0=A0 }
>> > #endif
>> > =A0=A0=A0=A0=A0=A0=A0 tcon =3D NULL;
>> > =A0=A0=A0=A0=A0=A0=A0 pSesInfo =3D NULL;
>> > =A0=A0=A0=A0=A0=A0=A0 srvTcp =3D NULL;
>> > =A0=A0=A0=A0=A0=A0=A0 full_path =3D NULL;
>> > =A0=A0=A0=A0=A0=A0=A0 tlink =3D NULL;
>> > +=A0=A0=A0=A0=A0=A0=A0 rc=3D0;
>> >
>> > =A0=A0=A0=A0=A0=A0=A0 xid =3D GetXid();
>> >
>> > =A0=A0=A0=A0=A0=A0=A0 /* get a reference to a tcp session */
>> > =A0=A0=A0=A0=A0=A0=A0 srvTcp =3D cifs_get_tcp_session(volume_info)=
;
>> > =A0=A0=A0=A0=A0=A0=A0 if (IS_ERR(srvTcp)) {
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D PTR_ERR(srvTc=
p);
>> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bdi_destroy(&cifs_sb=
->bdi);
>> > =A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
>> > =A0=A0=A0=A0=A0=A0=A0 }
>> >
>> >
>> >
>> > Thanks
>> > Thomas
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>
>> Nice analysis. That looks correct to me too...
>>
>> Care to spin up a patch with a description and signed-off-by line? Y=
ou
>> can add my Reviewed-by if so...
>>
>
> FWIW, this looks like a regression that was introduced in commit
> 724d9f1c. That patch should be appropriate for stable as well. When y=
ou
> add that line, you should also be able to get rid of the initializati=
on
> of rc in the declaration too.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
