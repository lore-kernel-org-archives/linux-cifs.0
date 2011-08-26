From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Fri, 26 Aug 2011 13:52:25 -0500
Message-ID: <CAH2r5mvSxOqo_1uu5Wg_sBc0oX4525fWbo=BJ88FH2_bvbG-yA@mail.gmail.com>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
	<CADT32eJsAgNkhnY1VZ6wpxa2013h7TmO6i3H=4a6D8ke8iU2Aw@mail.gmail.com>
	<20110823091510.2d8b8027@corrin.poochiereds.net>
	<CADT32eJSUxL1NLYkxOPj_YfjzpRG7Q7XrMrz5HOm=ejnA=smYg@mail.gmail.com>
	<CAH2r5mv48Va=t8dj2Bk16o=XtX5UJ5UqQbQKLDooDmYxwmu+Xg@mail.gmail.com>
	<CADT32e+RNyB6aA0fsiGsEojkbLCswTUUydmYR918soYk35ErhA@mail.gmail.com>
	<CAH2r5muBT8J_VRTL18HC4_gEbLu7bjNV+DtTgJ9U9fej-=NxAg@mail.gmail.com>
	<CADT32eKv_t2NopeWZ3Pp7roZC4dN1MxqZnnodEZVKtt-AKuJNA@mail.gmail.com>
	<CAH2r5mugZTUNQ9KR92gdCnJv+7V3eGcKPnEQ86WwDA356DSpew@mail.gmail.com>
	<CADT32eLJWcUOCyDEVqinFA9Uv77fUuAh3GnzNZA3bvYopohvZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CADT32eLJWcUOCyDEVqinFA9Uv77fUuAh3GnzNZA3bvYopohvZA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

We have had a few requests for optionally sending the
"FILE_OPEN_FOR_BACKUP_INTENT"
flag on open - as it is used by various CIFS servers (including Windows=
)
to allow certain privileged users to backup files more easily (see quot=
e
from MS-CIFS protocol specification below).

There are few reasonable ways that I see to optionally request that suc=
h a flag
be sent on the wire, given that POSIX AFAIK has no exact equivalent ope=
n flag,
and it is unreasonable to expect that applications would be recoded to
add support
for a new flag like this until other file systems have equivalents.

One way would be to allow an ioctl or /proc/sys or /proc/fs setting
that turns on
(or off) the flag - but it is hard to imagine how that would help
since the flag is specified on open.

A more obvious way, following Shirish's suggestion of a "backup" mount.=
  All
opens on this mount would get the backup intent flag set - and since op=
ens
with this flag require a privileged user (with the "backup operator" ri=
ght)
the idea suggested below is to forbid "multiuser" behavior on such a mo=
unt.
If you mount a cifs share for backup - all opens are done with the user=
id
specified on the mount and with the backup intent flag.  That seems
workable - and appears to address the user requirement.

If any other approach for sending this flag makes more sense though
it would be helpful to get suggestions ...


On Wed, Aug 24, 2011 at 9:53 PM, Shirish Pargaonkar
<shirishpargaonkar@gmail.com> wrote:
> On Tue, Aug 23, 2011 at 8:44 PM, Steve French <smfrench@gmail.com> wr=
ote:
>> I agree - but want to have a stronger argument why multiuser doesn't
>> make sense and would conflict. =A0We need to establish whether:
>> 1) opens with backup intent can fail, where a normal open (without t=
he
>> flag) would work
>
> I think this can happen, based on this description in MS-CIFS.
>
> FILE_OPEN_FOR_BACKUP_INTENT 0x00004000
> The file is being opened or created for the purposes of either a
> backup or a restore operation. Thus, the server can make appropriate
> checks to ensure that the caller is capable of overriding whatever
> security checks have been placed on the file to allow a backup or
> restore operation to occur. The server can check for certain access
> rights to the file before checking the DesiredAccess field.
>
>> 2) whether there are users for which backup intent opens will always
>> work (or work no differently than the same open without the flag) - =
no
>> matter who the owner of the file.
>>
>> If the latter is true then we can make the argument that for "backup=
"
>> mounts you can only use one user.
>
> So the latter is true and a case of backup mount option being
> mutually exclusive to multiuser option.




--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
