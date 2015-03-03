From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How does mounting with BACKUP INTENT work in CIFS?
Date: Tue, 3 Mar 2015 11:59:52 -0800
Message-ID: <CACyXjPwOaZ9VNeXwyh0t8PYOR2gTNWiUJLm_ecgCQPU-PbVToA@mail.gmail.com>
References: <CAPpy_fGs693BzGS3-pjtKvvkFo+Lwgqjgwq+4WmUthcUMRM0uA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "pisymbol ." <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPpy_fGs693BzGS3-pjtKvvkFo+Lwgqjgwq+4WmUthcUMRM0uA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 3, 2015 at 11:52 AM, pisymbol . <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> A colleague and I just witnessed that we could not write an access
> time of a file on a CIFS mount using CentOS 6.5 despite the fact we
> mounted it with "Backup Intent."
>
> My current theory is that via CIFS, the DACL checks still apply
> because Window backup clients use a different API to access files.
> However, I'm not 100% sure.

BackupIntent is only useful if you also have SeBackupPrivilege or
SeRestorePrivilege or both. That is why it worked when you added
BackupOperators, because privileges are associated with groups.

> Notes:
>
> - The machine was joined to AD
> - The account we used to mount was in the domain's Backup Operators g=
roup.
> - We used backupuid=3D0 (root) when we mounted the share.
>
> After adding the the Backup Operators group to the share, we were abl=
e
> to successfully restore access times and everything just worked.
>
> Is it true that via purely SMB/CIFS, you don't entirely get around
> normal DACLs checks via mount.cifs? How does this work within CIFS?
>
> Thanks!
>
> -aps (Alex)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
