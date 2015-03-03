From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How does mounting with BACKUP INTENT work in CIFS?
Date: Tue, 3 Mar 2015 13:24:23 -0800
Message-ID: <CACyXjPx6t-ewMGN=ei6ET2AU82sXhSS68U8Vwm2qogZ7N816dQ@mail.gmail.com>
References: <CAPpy_fGs693BzGS3-pjtKvvkFo+Lwgqjgwq+4WmUthcUMRM0uA@mail.gmail.com>
	<CACyXjPwOaZ9VNeXwyh0t8PYOR2gTNWiUJLm_ecgCQPU-PbVToA@mail.gmail.com>
	<CAPpy_fGR9Y9vm2pp5e8287tkHpiazHoMaqAS044Fqa=NGmL7zQ@mail.gmail.com>
	<CAPpy_fE8gXrPV9nJjbGpYG0n5sGm+R2Hm7Q9SjPu8rMry-G2Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "pisymbol ." <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPpy_fE8gXrPV9nJjbGpYG0n5sGm+R2Hm7Q9SjPu8rMry-G2Hw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 3, 2015 at 1:16 PM, pisymbol . <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Mar 3, 2015 at 3:20 PM, pisymbol . <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>> On Tue, Mar 3, 2015 at 2:59 PM, Richard Sharpe
>> <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Tue, Mar 3, 2015 at 11:52 AM, pisymbol . <pisymbol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>>>> A colleague and I just witnessed that we could not write an access
>>>> time of a file on a CIFS mount using CentOS 6.5 despite the fact w=
e
>>>> mounted it with "Backup Intent."
>>>>
>>>> My current theory is that via CIFS, the DACL checks still apply
>>>> because Window backup clients use a different API to access files.
>>>> However, I'm not 100% sure.
>>>
>>> BackupIntent is only useful if you also have SeBackupPrivilege or
>>> SeRestorePrivilege or both. That is why it worked when you added
>>> BackupOperators, because privileges are associated with groups.
>>
>> So the domain user in Windows has to have these privileges set AND b=
e
>> part of the Backup Operators group for all of this to work?

Yes. Domain admins get it by default, but not ordinary domain users.

> Btw, I pester only because I had *thought* that those privs were
> automatically granted to anyone in the Backup Operator group and the
> mount.cifs command should follow suit.

Well, they cannot work around the Windows semantics of this bit. They
can add it by default, but you still have to have the privilege.


--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
