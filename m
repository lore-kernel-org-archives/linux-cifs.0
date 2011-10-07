From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: Add mount options for backup intent and their
 manpages (try #6)
Date: Fri, 7 Oct 2011 10:29:28 -0500
Message-ID: <CADT32eJVVHPtva-0pfY+D242sN_EvinoQQGnUn9Yh64fXBTA4Q@mail.gmail.com>
References: <1317149929-1206-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111003074953.06f8eb5d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111003074953.06f8eb5d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 3, 2011 at 6:49 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 27 Sep 2011 13:58:49 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Add mount options backupuid and backugid and their manpage contents.
>> Check for either a valid uid/gid or valid user/group name.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0mount.cifs.8 | =A0 14 +++++++++
>> =A0mount.cifs.c | =A0 85 +++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++-
>> =A02 files changed, 97 insertions(+), 2 deletions(-)
>>
>> diff --git a/mount.cifs.8 b/mount.cifs.8
>> index 81ebdbe..d7eb2dd 100644
>> --- a/mount.cifs.8
>> +++ b/mount.cifs.8
>> @@ -282,6 +282,20 @@ See sections on
>> =A0for more information\&.
>> =A0.RE
>> =A0.PP
>> +backupuid
>> +.RS 4
>> +Allow access to files with the intent to back them up for a user\&.
>> +.sp
>> +An authenticated user at the server with a privilege can access fil=
e system objects with the intent to back them up to which it otherwise =
may not have access permissions. =A0As an example, a privilege would be=
 "Backup files and directories user right" granted by the server by mak=
ing that user a part of the built-in group Backup Operators. This mount=
 option restricts to the specified user on the client, as such an authe=
nticated user, privilege to access files with the intent to back them u=
p.
>
> Better, but this is still pretty awkward and confusing. This manpage
> needs to answer 3 things:
>
> 1. what this option does (turn on the backup intent bit in open calls=
)

Not sure if implentation specifics need to be mentioned in a man page.

>
> 2. what the backup intent bit does (allows a user to open files to
> which he wouldn't ordinarily have access)

So IMHO, this can be phrased as

1. what this option does (allows a user to open files to
which he wouldn't ordinarily have access)

>
> 3. when should (or shouldn't) the user enable it?
>

I am not sure how to respond to this.  We are stating the intent
and purpose of these options.  Would not that suffice?
Once the intent and purpose are stated, it is upto the user
how_to_use_it / the_way_they_want_it.
Or we need to mention cautions?

> If this is going to be too long then you may want to add a new sectio=
n
> to explain the backup intent in detail.
>
>> +.RE
>> +.PP
>> +backupgid
>> +.RS 4
>> +Allow access to files with the intent to back them up for a group\&=
=2E
>> +.sp
>> +An authenticated user at the server with a privilege can access fil=
e system objects with the intent to back them up to which it otherwise =
may not have access permissions. =A0As an example, a privilege would be=
 "Backup files and directories user right" granted by the server by mak=
ing that user a part of the built-in group Backup Operators. This mount=
 option restricts to the users in the specified group on the client, as=
 such an authenticated user, privilege to access files with the intent =
to back them up.
>> +.RE
>> +.PP
>> =A0nocase
>> =A0.RS 4
>> =A0Request case insensitive path name matching (case sensitive is th=
e default if the server suports it)\&.
>> diff --git a/mount.cifs.c b/mount.cifs.c
>> index 1e3d534..36c3ac0 100644
>> --- a/mount.cifs.c
>> +++ b/mount.cifs.c
>> @@ -158,6 +158,8 @@
>> =A0#define OPT_MAND =A0 =A0 =A0 27
>> =A0#define OPT_NOMAND =A0 =A0 28
>> =A0#define OPT_CRUID =A0 =A0 =A029
>> +#define OPT_BKUPUID =A0 =A030
>> +#define OPT_BKUPGID =A0 =A031
>>
>>
>> =A0/* struct for holding parsed mount info for use by privleged proc=
ess */
>> @@ -843,6 +845,10 @@ static int parse_opt_token(const char *token)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return OPT_REMOUNT;
>> =A0 =A0 =A0 if (strncmp(token, "_netdev", 7) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return OPT_IGNORE;
>> + =A0 =A0 if (strncmp(token, "backupuid", 9) =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return OPT_BKUPUID;
>> + =A0 =A0 if (strncmp(token, "backupgid", 9) =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return OPT_BKUPGID;
>>
>> =A0 =A0 =A0 return OPT_ERROR;
>> =A0}
>> @@ -858,11 +864,13 @@ parse_options(const char *data, struct parsed_=
mount_info *parsed_info)
>> =A0 =A0 =A0 int out_len =3D 0;
>> =A0 =A0 =A0 int word_len;
>> =A0 =A0 =A0 int rc =3D 0;
>> + =A0 =A0 int got_bkupuid =3D 0;
>> + =A0 =A0 int got_bkupgid =3D 0;
>> =A0 =A0 =A0 int got_uid =3D 0;
>> =A0 =A0 =A0 int got_cruid =3D 0;
>> =A0 =A0 =A0 int got_gid =3D 0;
>> - =A0 =A0 uid_t uid, cruid =3D 0;
>> - =A0 =A0 gid_t gid;
>> + =A0 =A0 uid_t uid, cruid =3D 0, bkupuid;
>> + =A0 =A0 gid_t gid, bkupgid;
>> =A0 =A0 =A0 char *ep;
>> =A0 =A0 =A0 struct passwd *pw;
>> =A0 =A0 =A0 struct group *gr;
>> @@ -906,6 +914,8 @@ parse_options(const char *data, struct parsed_mo=
unt_info *parsed_info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 value =3D equals + 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> + =A0 =A0 =A0 =A0 =A0 =A0 ep =3D NULL;
>> +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch(parse_opt_token(data)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case OPT_USERS:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value) {
>> @@ -1171,6 +1181,42 @@ parse_options(const char *data, struct parsed=
_mount_info *parsed_info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case OPT_IGNORE:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocopy;
>> + =A0 =A0 =A0 =A0 =A0 =A0 case OPT_BKUPUID:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocop=
y;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 got_bkupuid =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bkupuid =3D strtoul(value,=
 &ep, 10);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strlen(ep))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocop=
y;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pw =3D getpwnam(value);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pw =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(st=
derr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 "bad user name \"%s\"\n", value);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EX_=
USAGE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bkupuid =3D pw->pw_uid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocopy;
>> + =A0 =A0 =A0 =A0 =A0 =A0 case OPT_BKUPGID:
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocop=
y;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 got_bkupgid =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bkupgid =3D strtoul(value,=
 &ep, 10);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!strlen(ep))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocop=
y;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 gr =3D getgrnam(value);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (gr =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(st=
derr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 "bad group name \"%s\"\n", value);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EX_=
USAGE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bkupgid =3D gr->gr_gid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocopy;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* check size before copying option to b=
uffer */
>> @@ -1246,6 +1292,39 @@ nocopy:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 snprintf(out + out_len, word_len + 5, "g=
id=3D%s", txtbuf);
>> =A0 =A0 =A0 }
>> + =A0 =A0 /* special-case the uid and gid */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^
> I don't think you need this comment.
>
>> + =A0 =A0 if (got_bkupuid) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 word_len =3D snprintf(txtbuf, sizeof(txtbu=
f), "%u", bkupuid);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* comma + "uid=3D" + terminating NULL =3D=
=3D 6 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (out_len + word_len + 6 > MAX_OPTIONS_L=
EN) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "Options s=
tring too long\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EX_USAGE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (out_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(out, ",", MAX_OPTI=
ONS_LEN);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_len++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 snprintf(out + out_len, word_len + 11, "ba=
ckupuid=3D%s", txtbuf);
>> + =A0 =A0 =A0 =A0 =A0 =A0 out_len =3D strlen(out);
>> + =A0 =A0 }
>> + =A0 =A0 if (got_bkupgid) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 word_len =3D snprintf(txtbuf, sizeof(txtbu=
f), "%u", bkupgid);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* comma + "backkupgid=3D" + terminating N=
ULL =3D=3D 6 */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (out_len + word_len + 6 > MAX_OPTIONS_L=
EN) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "Options s=
tring too long\n");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EX_USAGE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (out_len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(out, ",", MAX_OPTI=
ONS_LEN);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_len++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 snprintf(out + out_len, word_len + 11, "ba=
ckupgid=3D%s", txtbuf);
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 return 0;
>> =A0}
>>
>> @@ -1361,6 +1440,8 @@ static struct option longopts[] =3D {
>> =A0 =A0 =A0 {"type", 1, NULL, 't'},
>> =A0 =A0 =A0 {"uid", 1, NULL, '1'},
>> =A0 =A0 =A0 {"gid", 1, NULL, '2'},
>> + =A0 =A0 {"backupuid", 1, NULL, '1'},
>> + =A0 =A0 {"backupgid", 1, NULL, '2'},
>
> This looks unnecessary and wrong. You're adding a new command line
> alias for --uid called --backupuid?
>
>> =A0 =A0 =A0 {"user", 1, NULL, 'u'},
>> =A0 =A0 =A0 {"username", 1, NULL, 'u'},
>> =A0 =A0 =A0 {"dom", 1, NULL, 'd'},
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>
