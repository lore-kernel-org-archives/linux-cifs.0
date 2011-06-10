From: Connor Hansen <cmdkhh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Fri, 10 Jun 2011 05:03:27 -0700
Message-ID: <BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
	<20110609183045.01f6f9fc@tlielax.poochiereds.net>
	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
	<20110610073702.061bc014@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martijn Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110610073702.061bc014-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 10, 2011 at 4:37 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
> =A0Uffing <mp3project-dT/mdtNybfnOcQoxchNua+fsyHJTGBv43KldkOmuLK4@public.gmane.org> wrote:
>
>>
>> <snip>
>> > call in get_dfs_path()
>> > rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
>> >
>> > function header for CIFSTCon
>> > int =A0CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>> > =A0 =A0 =A0 =A0 =A0const char *tree, struct cifs_tcon *tcon,
>> > =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage)
>> >
>> > get_dfs_path() is passing struct cifs_tcon *tcon as NULL
>> >
>> > from config: =A0CONFIG_CIFS_WEAK_PW_HASH=3Dy
>> >
>> > in CIFSTCon
>> >
>> > #ifdef CONFIG_CIFS_WEAK_PW_HASH
>> > 3222 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((global_secflags & CIFSSE=
C_MAY_LANMAN) &&
>> > 3223 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->secType=
 =3D=3D LANMAN))
>> > 3224 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanman_h=
ash(tcon->password,
>> > ses->server->cryptkey,
>> >
>> > in calc_lanman_hash tcon is dereferenced(tcon->password) without b=
eing
>> > checked if null
>> >
>> > 3225 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0ses->server->sec_mode &
>> > 3226 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 SECMODE_PW_ENCRYPT ?
>> > true : false,
>> > 3227 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0bcc_ptr);
>> > 3228 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> > 3229 #endif /* CIFS_WEAK_PW_HASH */
>> >
>> > Connor
>>
>>
>> Ave all
>>
>> I recompiled =A0kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_INFO=3Dy=
) and put
>> the oops (with the new adresses) through gdb per instruction of Jeff=
=2E And
>> Connor was spot on!
>>
>> <qoute oops>
>> BUG: unable to handle kernel NULL pointer dereference at 00000000000=
000a0
>> IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
>> </qoute oops>
>>
>> <qoute gdb>
>> This GDB was configured as "x86_64-linux-gnu".
>> For bug reporting instructions, please see:
>> <http://www.gnu.org/software/gdb/bugs/>...
>> Reading symbols from
>> /lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
>> (gdb) list *(CIFSTCon+0xf6)
>> 0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
>> 3225 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->sec_mode &
>> 3226 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SECMODE_PW_ENCRYPT ?
>> true : false,
>> 3227 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr);
>> 3228 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>> 3229 =A0 =A0#endif /* CIFS_WEAK_PW_HASH */
>> 3230 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SMBNTencrypt(tcon=
->password,
>> ses->server->cryptkey,
>> 3231 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr);
>> 3232
>> 3233 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr +=3D CIFS_AUTH_R=
ESP_SIZE;
>> 3234 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabilities & =
CAP_UNICODE) {
>> (gdb)
>> </qoute gdb>
>>
>
> (cc'ing Sean F. since I suspect this regression is due to his changes=
)
>
> Thanks for the analysis, Martijn and Connor...
>
> What sort of server are you mounting here? It looks like it's using
> share-level security, so it's either very old or is a samba server
> configured that way.
>
> I suspect that commit c1508ca236 is the culprit. With that, we call
> into expand_dfs_referral on every mount attempt. Previously we only
> called into there when we got back =A0an EREMOTE error and that would
> have been unlikely on a share-level security connection.
>
> I think there are several possible solutions, but since Sean was in
> here most recently I'd like to have his opinion.

I don't know enough about cifs but this call in fs/cifs/connect.c

2268: rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);

will always result in a null pointer derefence as CIFSTCon uses the
cifs_tcon struct for passwords without verification

either we need to check for tcon for null in CIFSTCon before use, or
change get_dfs_path to get the cifs_tcon info and pass it to the
CIFSTCon function. But again I don't know enough about cifs to know
the best approach

Connor
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
