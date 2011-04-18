From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix extended security auth failure
Date: Mon, 18 Apr 2011 07:51:46 -0500
Message-ID: <BANLkTinWMnXKvy3Kxe0e_hPsijYimyNE2Q@mail.gmail.com>
References: <1302097566-11576-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110408094028.61a2f507@corrin.poochiereds.net>
	<BANLkTik=Mgbbu7G0U6oPvELEktCFQTArDg@mail.gmail.com>
	<BANLkTikuFDcUHuN9HeY=5KLodWo3_2dDpg@mail.gmail.com>
	<20110418082456.36406423@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110418082456.36406423-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 18, 2011 at 7:24 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 18 Apr 2011 07:16:36 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Apr 8, 2011 at 8:49 AM, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > On Fri, Apr 8, 2011 at 8:40 AM, Jeff Layton <jlayton@poochiereds.n=
et> wrote:
>> >> On Wed, =A06 Apr 2011 08:46:06 -0500
>> >> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >>
>> >>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>>
>> >>>
>> >>> Fix authentication failures using extended security mechanisms.
>> >>> cifs client does not take into consideration extended security b=
it
>> >>> in capabilities field in negotiate protocol response from the se=
rver.
>> >>>
>> >>> Please refer to Samba bugzilla 8046.
>> >>>
>> >>>
>> >>> Reported-and-tested by: Werner Maes <Werner.Maes-UiU5zyVfpuq/9j7TCjX/TQ@public.gmane.org=
e>
>> >>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >>> ---
>> >>> =A0fs/cifs/cifssmb.c | =A0 17 ++++++-----------
>> >>> =A01 files changed, 6 insertions(+), 11 deletions(-)
>> >>>
>> >>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> >>> index 3291770..e119d70 100644
>> >>> --- a/fs/cifs/cifssmb.c
>> >>> +++ b/fs/cifs/cifssmb.c
>> >>> @@ -570,18 +570,10 @@ CIFSSMBNegotiate(unsigned int xid, struct =
cifs_ses *ses)
>> >>> =A0 =A0 =A0 if (pSMBr->EncryptionKeyLength =3D=3D CIFS_CRYPTO_KE=
Y_SIZE) {
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ses->server->cryptkey, pSMBr-=
>u.EncryptionKey,
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_CRYPTO_KEY_SIZE)=
;
>> >>> - =A0 =A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC)
>> >>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (pSMBr->EncryptionK=
eyLength =3D=3D 0)) {
>> >>> + =A0 =A0 } else if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC ||
>> >>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities &=
 CAP_EXTENDED_SECURITY) &&
>> >>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (pSMBr=
->EncryptionKeyLength =3D=3D 0)) {
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* decode security blob */
>> >>
>> >> This looks wrong to me. CAP_EXTENDED_SECURITY just means that the
>> >> server supports extended security, not that it's in use, right? A=
ren't
>> >> we just working around server brokenness here. Why isn't it setti=
ng
>> >> SMBFLG2_EXT_SEC if it's using extended security?
>> >>
>> >> Are there cases where the server might set EncryptionKeyLength to=
 0,
>> >> and *not* be using extended security? If not, then why bother to =
check
>> >> the flags or capabilities at all?
>> >>
>> >>> - =A0 =A0 } else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
>> >>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* no crypt key only if p=
lain text pwd */
>> >>> - =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
>> >>> - =A0 =A0 }
>> >>> -
>> >>> - =A0 =A0 /* BB might be helpful to save off the domain of serve=
r here */
>> >>> -
>> >>> - =A0 =A0 if ((pSMBr->hdr.Flags2 & SMBFLG2_EXT_SEC) &&
>> >>> - =A0 =A0 =A0 =A0 =A0 =A0 (server->capabilities & CAP_EXTENDED_S=
ECURITY)) {
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 count =3D get_bcc(&pSMBr->hdr);
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (count < 16) {
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO;
>> >>> @@ -624,6 +616,9 @@ CIFSSMBNegotiate(unsigned int xid, struct ci=
fs_ses *ses)
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 rc =3D -EOPNOTSUPP;
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> >>> + =A0 =A0 } else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
>> >>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EIO; /* no crypt key only if p=
lain text pwd */
>> >>> + =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
>> >>> =A0 =A0 =A0 } else
>> >>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 server->capabilities &=3D ~CAP_EXTEN=
DED_SECURITY;
>> >>>
>> >>
>> >>
>> >> --
>> >> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>> >>
>> >
>> > I checked in ms-cifs and ms-smb, and there is no mention of server=
 needing
>> > to set extended security bit in flags2 in smb header but ms-smb do=
es mention
>> > about server setting extended security bit in capabilities field i=
n
>> > negotiate protocol response (there is an example of the exchange i=
n ms-smb).
>> > When server is indicating it supports extended security, it should=
 set
>> > encryptionkeylength to 0 since the ensuing exchange will involve a=
n
>> > encryption key (challenge).
>> >
>>
>> Jeff, any further comments on this?
>>
>
> No. As long as you're fairly sure that this won't cause regressions
> when we don't intend to use extended security then I'm ok with it.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Yes, I did verify that auth mechs like sec=3Dntlm/i and sec=3Dntlmv2/i
do work with this patch.

Regards,

Shirish
