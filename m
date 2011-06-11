From: Connor Hansen <cmdkhh@gmail.com>
Subject: Re: [OOPS] 3.0-rc1 cifs
Date: Sat, 11 Jun 2011 09:25:09 -0700
Message-ID: <BANLkTikCjH6f-kCmrTjvgNQ3SucEknXMdA@mail.gmail.com>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
	<20110609183045.01f6f9fc@tlielax.poochiereds.net>
	<BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
	<Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
	<20110610073702.061bc014@corrin.poochiereds.net>
	<BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com>
	<4DF20A97.8010405@suse.de>
	<BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
	<20110611074113.5a05f919@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
	Martijn Uffing <mp3project@sarijopen.student.utwente.nl>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	sean finney <seanius@seanius.net>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110611074113.5a05f919@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, Jun 11, 2011 at 4:41 AM, Jeff Layton <jlayton@redhat.com> wrote=
:
> On Fri, 10 Jun 2011 05:49:46 -0700
> Connor Hansen <cmdkhh@gmail.com> wrote:
>
>> On Fri, Jun 10, 2011 at 5:14 AM, Suresh Jayaraman <sjayaraman@suse.d=
e> wrote:
>> > On 06/10/2011 05:33 PM, Connor Hansen wrote:
>> >> On Fri, Jun 10, 2011 at 4:37 AM, Jeff Layton <jlayton@redhat.com>=
 wrote:
>> >>> On Fri, 10 Jun 2011 02:57:21 +0200 (CEST)
>> >>> =A0Uffing <mp3project@sarijopen.student.utwente.nl> wrote:
>> >>>
>> >>>>
>> >>>> <snip>
>> >>>>> call in get_dfs_path()
>> >>>>> rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage);
>> >>>>>
>> >>>>> function header for CIFSTCon
>> >>>>> int =A0CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>> >>>>> =A0 =A0 =A0 =A0 =A0const char *tree, struct cifs_tcon *tcon,
>> >>>>> =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage)
>> >>>>>
>> >>>>> get_dfs_path() is passing struct cifs_tcon *tcon as NULL
>> >>>>>
>> >>>>> from config: =A0CONFIG_CIFS_WEAK_PW_HASH=3Dy
>> >>>>>
>> >>>>> in CIFSTCon
>> >>>>>
>> >>>>> #ifdef CONFIG_CIFS_WEAK_PW_HASH
>> >>>>> 3222 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((global_secflags & CI=
=46SSEC_MAY_LANMAN) &&
>> >>>>> 3223 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->server->sec=
Type =3D=3D LANMAN))
>> >>>>> 3224 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 calc_lanm=
an_hash(tcon->password,
>> >>>>> ses->server->cryptkey,
>> >>>>>
>> >>>>> in calc_lanman_hash tcon is dereferenced(tcon->password) witho=
ut being
>> >>>>> checked if null
>> >>>>>
>> >>>>> 3225 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0ses->server->sec_mode &
>> >>>>> 3226 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SECMODE_PW_ENCRYPT ?
>> >>>>> true : false,
>> >>>>> 3227 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr);
>> >>>>> 3228 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> >>>>> 3229 #endif /* CIFS_WEAK_PW_HASH */
>> >>>>>
>> >>>>> Connor
>> >>>>
>> >>>>
>> >>>> Ave all
>> >>>>
>> >>>> I recompiled =A0kernel 3.0-rc1 (hadn't enabled CONFIG_DEBUG_INF=
O=3Dy) and put
>> >>>> the oops (with the new adresses) through gdb per instruction of=
 Jeff. And
>> >>>> Connor was spot on!
>> >>>>
>> >>>> <qoute oops>
>> >>>> BUG: unable to handle kernel NULL pointer dereference at 000000=
00000000a0
>> >>>> IP: [<ffffffffa041e286>] CIFSTCon+0xf6/0x4d0 [cifs]
>> >>>> </qoute oops>
>> >>>>
>> >>>> <qoute gdb>
>> >>>> This GDB was configured as "x86_64-linux-gnu".
>> >>>> For bug reporting instructions, please see:
>> >>>> <http://www.gnu.org/software/gdb/bugs/>...
>> >>>> Reading symbols from
>> >>>> /lib/modules/3.0.0-rc1-debug/kernel/fs/cifs/cifs.ko...done.
>> >>>> (gdb) list *(CIFSTCon+0xf6)
>> >>>> 0xc2b6 is in CIFSTCon (fs/cifs/connect.c:3230).
>> >>>> 3225 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->server->sec_mode &
>> >>>> 3226 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SECMODE_PW_ENCRYPT ?
>> >>>> true : false,
>> >>>> 3227 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr);
>> >>>> 3228 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
>> >>>> 3229 =A0 =A0#endif /* CIFS_WEAK_PW_HASH */
>> >>>> 3230 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D SMBNTencrypt=
(tcon->password,
>> >>>> ses->server->cryptkey,
>> >>>> 3231 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr);
>> >>>> 3232
>> >>>> 3233 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr +=3D CIFS_A=
UTH_RESP_SIZE;
>> >>>> 3234 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->capabiliti=
es & CAP_UNICODE) {
>> >>>> (gdb)
>> >>>> </qoute gdb>
>> >>>>
>> >>>
>> >>> (cc'ing Sean F. since I suspect this regression is due to his ch=
anges)
>> >>>
>> >>> Thanks for the analysis, Martijn and Connor...
>> >>>
>> >>> What sort of server are you mounting here? It looks like it's us=
ing
>> >>> share-level security, so it's either very old or is a samba serv=
er
>> >>> configured that way.
>> >>>
>> >>> I suspect that commit c1508ca236 is the culprit. With that, we c=
all
>> >>> into expand_dfs_referral on every mount attempt. Previously we o=
nly
>> >>> called into there when we got back =A0an EREMOTE error and that =
would
>> >>> have been unlikely on a share-level security connection.
>> >>>
>> >>> I think there are several possible solutions, but since Sean was=
 in
>> >>> here most recently I'd like to have his opinion.
>> >>
>> >> I don't know enough about cifs but this call in fs/cifs/connect.c
>> >>
>> >> 2268: rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nls_codepage=
);
>> >>
>> >> will always result in a null pointer derefence as CIFSTCon uses t=
he
>> >> cifs_tcon struct for passwords without verification
>> >
>> > Yes, I too was hovering around this code path today and it doesn't=
 look
>> > correct. Specifically, the call from cifs_dfs_path to CIFSTCon wit=
h
>> > cifs_tcon as NULL seems wrong. I tried to do dig history a bit wit=
h `git
>> > blame`, but couldn't figure out the commit that introduced this.
>> >
>> >
>> > --
>> > Suresh Jayaraman
>> >
>>
>> git annotate fs/cifs/connect.c
>> 1da177e4 =A0 =A0 =A0 =A0(Linus Torvalds 2005-04-16 15:20:36 -0700 =A0=
 =A0 =A0 2268)
>> =A0 =A0 =A0 =A0 =A0rc =3D CIFSTCon(xid, pSesInfo, temp_unc, NULL, nl=
s_codepage);
>>
>> this was valid at the time to simply get the rc, and the code was ch=
ecked
>> =A0if ((rc =3D=3D 0) && (tcon !=3D NULL)) { =A0 // =A0first use of t=
con in
>> CIFSTCon back then.....
>>
>>
>> after a loooooong look, i found the patch which changed it
>>
>> 00e485b0
>> commit 00e485b0198ea4f509341373f1d9adb0a5977a2f
>> Author: Jeff Layton <jlayton@redhat.com>
>> Date: =A0 Fri Dec 5 20:41:21 2008 -0500
>>
>> =A0 =A0 cifs: store password in tcon
>>
>> =A0 =A0 cifs: store password in tcon
>>
>> =A0 =A0 Each tcon has its own password for share-level security. Sto=
re it in
>> =A0 =A0 the tcon and wipe it clean and free it when freeing the tcon=
=2E When
>> =A0 =A0 doing the tree connect with share-level security, use the tc=
on password
>> =A0 =A0 instead of the session password.
>>
>> =A0 =A0 Signed-off-by: Jeff Layton <jlayton@redhat.com>
>> =A0 =A0 Signed-off-by: Steve French <sfrench@us.ibm.com>
>>
>
> Yep, mea culpa. This patch should fix it. Martin, can you test it?
> Anyone else have comments?
>
> Thanks...

Looks good to me,
Connor

>
> -----------------------[snip]--------------------
>
> [PATCH] cifs: correctly handle NULL tcon pointer in CIFSTCon
>
> Long ago (in commit 00e485b0), I added some code to handle share-leve=
l
> passwords in CIFSTCon. That code ignored the fact that it's legit to
> pass in a NULL tcon pointer when connecting to the IPC$ share on the
> server.
>
> This wasn't really a problem until recently as we only called CIFSTCo=
n
> this way when the server returned -EREMOTE. With the introduction of
> commit c1508ca2 however, it gets called this way on every mount, caus=
ing
> an oops when share-level security is in effect.
>
> Fix this by simply treating a NULL tcon pointer as if user-level
> security were in effect. I'm not aware of any servers that protect th=
e
> IPC$ share with a specific password anyway. Also, add a comment to th=
e
> top of CIFSTCon to ensure that we don't make the same mistake again.
>
> Reported-by: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
> =A0fs/cifs/connect.c | =A0 =A06 +++++-
> =A01 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7b6cad2..fa5a5d7 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3174,6 +3174,10 @@ out:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/*
> + * Issue a TREE_CONNECT request. Note that for IPC$ shares, that the=
 tcon
> + * pointer may be NULL.
> + */
> =A0int
> =A0CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> =A0 =A0 =A0 =A0 const char *tree, struct cifs_tcon *tcon,
> @@ -3208,7 +3212,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses=
,
> =A0 =A0 =A0 =A0pSMB->AndXCommand =3D 0xFF;
> =A0 =A0 =A0 =A0pSMB->Flags =3D cpu_to_le16(TCON_EXTENDED_SECINFO);
> =A0 =A0 =A0 =A0bcc_ptr =3D &pSMB->Password[0];
> - =A0 =A0 =A0 if ((ses->server->sec_mode) & SECMODE_USER) {
> + =A0 =A0 =A0 if (!tcon || (ses->server->sec_mode & SECMODE_USER)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMB->PasswordLength =3D cpu_to_le16(1=
); =A0/* minimum */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*bcc_ptr =3D 0; /* password is null by=
te */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bcc_ptr++; =A0 =A0 =A0 =A0 =A0 =A0 =A0=
/* skip password */
> --
> 1.7.5.2
>
>
