From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix cifsConvertToUCS() for the mapchars case
Date: Sun, 15 May 2011 20:38:24 -0500
Message-ID: <BANLkTikmaFFF3sj_GGcPXru+=ALXMvmudg@mail.gmail.com>
References: <1305257555-20656-1-git-send-email-metze@samba.org>
	<1305257555-20656-2-git-send-email-metze@samba.org>
	<20110513201705.7fe75309@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110513201705.7fe75309-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Probably too late for 2.6.39 for a patch to a non-default mount option
(but I agree that it should go to stable).  Thoughts?

Jeff's suggestion below makes sense.

On Fri, May 13, 2011 at 7:17 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 13 May 2011 05:32:35 +0200
> Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
>> (84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
>> in just one commit (moving the function and changing it without test=
ing).
>>
>> put_unaligned_le16(temp, &target[j]); is never called for any codepo=
int
>> the goes via the 'default' switch statement. As a result we put
>> just zero (or maybe uninitialized) bytes into the target buffer,
>>
>> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_unicode.c | =A0 20 ++++++++++----------
>> =A01 files changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
>> index fc0fd4f..b1ff0bd 100644
>> --- a/fs/cifs/cifs_unicode.c
>> +++ b/fs/cifs/cifs_unicode.c
>> @@ -276,6 +276,7 @@ cifsConvertToUCS(__le16 *target, const char *sou=
rce, int maxlen,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return cifs_strtoUCS(target, source, PAT=
H_MAX, cp);
>>
>> =A0 =A0 =A0 for (i =3D 0, j =3D 0; i < maxlen; j++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 src_char =3D source[i];
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (src_char) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 0:
>> @@ -315,18 +316,17 @@ cifsConvertToUCS(__le16 *target, const char *s=
ource, int maxlen,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D=
 0x003f;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =
=3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len_remaining -=3D charlen=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* character may take mo=
re than one byte in the source
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* string, but will take=
 exactly two bytes in the
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* target string
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i +=3D charlen;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* character may take more than one byte=
 in the source
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* string, but will take exactly two byt=
es in the
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* target string
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(temp, &target[j]);
>> - =A0 =A0 =A0 =A0 =A0 =A0 i++; /* move to next char in source string=
 */
>> - =A0 =A0 =A0 =A0 =A0 =A0 len_remaining--;
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* move to next char in source string */
>> + =A0 =A0 =A0 =A0 =A0 =A0 i +=3D charlen;
>> + =A0 =A0 =A0 =A0 =A0 =A0 len_remaining -=3D charlen;
>> =A0 =A0 =A0 }
>>
>> =A0ctoUCS_out:
>
> Oof. Yeah, I broke it alright -- good catch...
>
> This patch probably won't apply to the current head of the tree,
> however. Rather than have a special patch for 2.6.38 and .39, what ma=
y
> be best is to go ahead and push 581ade4d in Steve's master branch to
> stable, and then apply something like this untested patch on top of i=
t.
>
> I'll plan to test it out when I get a chance, but I think that's
> probably the best approach.
>
> Thoughts?
>
> -----------------[snip]--------------------
>
> cifs: fix cifsConvertToUCS() for the mapchars case
>
> As Metze pointed out, commit 84cdf74e broke mapchars case:
>
> =A0 =A0Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
> =A0 =A0(84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
> =A0 =A0in just one commit (moving the function and changing it withou=
t
> =A0 =A0testing).
>
> =A0 =A0put_unaligned_le16(temp, &target[j]); is never called for any
> =A0 =A0codepoint the goes via the 'default' switch statement. As a re=
sult
> =A0 =A0we put just zero (or maybe uninitialized) bytes into the targe=
t
> =A0 =A0buffer.
>
> His proposed patch looks correct, but doesn't apply to the current he=
ad
> of the tree. This patch should also fix it.
>
> Reported-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_unicode.c | =A0 14 ++++++--------
> =A01 files changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 23d43cd..1b2e180 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -277,6 +277,7 @@ cifsConvertToUCS(__le16 *target, const char *sour=
ce, int srclen,
>
> =A0 =A0 =A0 =A0for (i =3D 0, j =3D 0; i < srclen; j++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0src_char =3D source[i];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 charlen =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (src_char) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 0:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0put_unaligned(0, &targ=
et[j]);
> @@ -316,16 +317,13 @@ cifsConvertToUCS(__le16 *target, const char *so=
urce, int srclen,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dst_ch=
ar =3D cpu_to_le16(0x003f);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0charle=
n =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* character may take=
 more than one byte in the source
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* string, but will t=
ake exactly two bytes in the
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* target string
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i +=3D charlen;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* character may take more than one b=
yte in the source string,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* but will take exactly two bytes in=
 the target string
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i +=3D charlen;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0put_unaligned(dst_char, &target[j]);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++; /* move to next char in source str=
ing */
> =A0 =A0 =A0 =A0}
>
> =A0ctoUCS_out:
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
